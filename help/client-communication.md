# 客户端连接与通信

本文按炎黄新章客户端与服务端 Pascal 源码说明真实连接过程。客户端始终通过 Gate 与 Login、Paid、DB 和 Game Server 间接通信，不会直接连接这些后端服务。

## 1. 源码入口

| 职责 | 代码位置 |
|---|---|
| 程序与窗口初始化 | `client/Client.dpr` |
| 建立连接、登录、统一收发与消息分派 | `client/FLogOn.pas` |
| 服务器地址列表解析 | `client/uHostAddr.pas` |
| TCP 封包、加密与收发缓冲 | `client/Lib/ALib/uClientPackets.pas` |
| 角色选择 | `client/FSelChar.pas` |
| 移动及主要游戏消息处理 | `client/FMain.pas` |
| 共用消息结构和编号 | `1000ydef/deftype.pas` |

当前主路径使用 Delphi `TClientSocket`。`client/dll_Sock.pas` 中的 `AnsCSock.dll` 接口不是 `FLogOn` 的实际收发路径，不能据此判断正式客户端协议。

## 2. 入口地址 `addr.txt`

`TFrmLogOn.FormCreate` 从**客户端当前工作目录**加载 `addr.txt`，每行必须有四个逗号分隔字段：

```text
IP地址,端口,区域名,服务器名
203.0.113.10,3053,正式区,炎黄新章
```

这里应填写对外 Balance 地址和 TCP 端口，标准入口为 3053，而不是 Gate 的 3054。Pascal 客户端目录未随附 `addr.txt`，部署时必须单独提供。`uHostAddr.pas` 只检查并读取前四个字段：其中任一字段为空则丢弃该行，多余字段不参与解析。配置文件应按上述四列编写；中文字段应采用客户端运行系统的 ANSI 代码页，中国区通常使用 CP936/GBK。

源码中无有效选择时存在历史回退地址和端口 3051，但它不代表当前部署配置，不能依赖该回退值连接正式服务器。

## 3. Balance 到 Gate 的连接过程

```text
Client                  Balance :3053                 Gate :3054
  |---- TCP connect -------->|                             |
  |<--- SM_CONNECTTHRU ------|                             |
  |     Gate IP + Port       |                             |
  |---- disconnect ----------|                             |
  |---------------- TCP connect -------------------------->|
  |---------------- CM_VERSION --------------------------->|
  |<--------------- SM_MESSAGE 或 SM_CLOSE ----------------|
```

1. 登录窗口首次激活时，`FormActivate` 根据 `addr.txt` 设置 `sckConnect.Address/Port` 并连接 Balance。
2. Balance 在连接可写时选择当前连接数最少的可用 Gate，将 `TSConnectThru` 封装为加密包返回；客户端不需要先发送请求。
3. `FLogOn.MessageProcess` 收到 `SM_CONNECTTHRU` 后保存 Gate IP 和端口、关闭 Balance 连接，再由 `TimerReConnect` 使用同一个 `TClientSocket` 连接 Gate。
4. Gate 连接成功后，客户端立即发送 `TCVer`：`rmsg=CM_VERSION`、`rVer=PROGRAM_VERSION`、`rNation=NATION_VERSION`。仓库 `deftype.pas` 当前启用值为 40。联调必须使用目标 Gate 的构建版本，不能仅凭仓库常量推断其他部署的值。
5. Gate 要求新连接的第一条应用消息是 `CM_VERSION`。版本或区域不符时返回 `SM_CLOSE(rkey=1)`；通过后设置登录窗口状态并返回 `SM_MESSAGE` 连接提示。

## 4. 登录、选角和进入游戏

用户提交账号密码时，`BtnLogInClick` 生成 `TCIdPass`（通常为 `CM_IDPASS`）并调用 `SocketAddData`。后续链路为：

```text
Client -> Gate -> Login：查询账号记录并由 Gate 比对密码
Gate -> Client：返回角色列表
Gate -> Paid：启用计费校验时检查付费状态
Client -> Gate：CM_SELECTCHAR
Gate -> DB：读取所选角色记录
Gate -> Game：GM_CONNECT，将角色交给游戏服务器
Game -> Gate -> Client：进入游戏并持续转发游戏消息
```

登录阶段的账号密码、角色列表和计费结果都经过 Gate。进入游戏后，移动、攻击、拾取、聊天等 `CM_*` 消息仍发给 Gate；Gate 在 `gs_playing` 状态下以 `GM_SENDGAMEDATA` 转发给 Game Server，不会要求客户端另建 Game 连接。

## 5. 客户端封包与加密

业务结构（例如 `TCMove`）的第一个字节是 `CM_*` 消息号。`SocketAddData` 按以下层次封装：

```text
CM_* 业务结构
  -> TWordComData { Size: Word, Data }
  -> TPacketData { PacketSize, RequestID, RequestMsg=0, ResultCode=0, Data }
  -> 0x28 + EnCryption(TPacketData) + 0x29
  -> TCP 字节流
```

所有整数按 Delphi packed record 的小端布局处理。`RequestID` 使用当前连接的 `SendPacketCount`，连接建立时归零，成功排队后递增；不能固定为零。客户端外层 `RequestMsg` 通常为 0，真正的 `CM_*` 位于 `TWordComData.Data[0]`。

这套加密是项目自定义编码和边界封装，不是 TLS。TCP 可能拆分或合并数据，不能假设一次读取就是一个完整包。

## 6. 收发和消息分派

- 发送：`SocketAddData` 把加密帧写入 `TPacketSender` 缓冲区，10 毫秒定时器调用 `Update`，最终通过 `Socket.SendBuf` 发送；写阻塞后等待 `OnWrite` 再继续。
- 接收：`OnRead` 最多读取 4096 字节并追加到 `TPacketReceiver`；`Update` 查找 `0x28/0x29`、解密并恢复 `TPacketData`。
- 分派：`FLogOn.MessageProcess` 先处理重定向、窗口和登录消息，其余消息交给 `FMain`、`FBottom`、`FAttrib` 等界面模块。

## 7. 客户端状态校验

进入游戏后，Game 经 Gate 周期性发送 `SM_NETSTATE=56`。原生客户端在 `client/FMain.pas` 回传 `CM_NETSTATE=36`：保留服务端的 ID 与 MadeTick，填写客户端 `mmAnsTick`，对 16 字节问题计算第一个 CRC32，再对答复结构的前 17 字节计算第二个 CRC32。两侧默认 tick 单位均为 10 ms。

这是带计时与校验值的客户端状态校验，不能只回传问题或填固定时间。错误 CRC 会在校验分支触发断开；未应答、回复延迟和时钟差值也参与检查，具体条件见[协议中的状态校验](protocol.md#45-客户端状态校验)。

## 8. 常见联调问题

- **没有服务器列表**：检查工作目录是否存在 `addr.txt`，前四个字段是否非空；按四列格式编写。
- **能连 Balance 但不能跳转**：确认 Balance 已收到 Gate 状态上报，并能返回可用 Gate 的外网 IP 和 3054 端口。
- **连接 Gate 后立即断开**：检查第一条应用消息是否为 `CM_VERSION`，版本是否与目标 Gate 一致（当前线上炎黄与仓库源码均为 40），并核对 `NATION_VERSION`。
- **登录无响应**：检查 Gate 到 Login/Paid 的内网连接；客户端不直接访问这两个服务。
- **进入游戏后断开**：检查 `SM_NETSTATE` 的应答 CRC、客户端 tick 单位和回复延迟，不要仅验证登录包。
- **偶发粘包或半包错误**：按字节流累计后再按 `0x28/0x29` 解帧，不要按单次 `recv()` 解析。
- **中文乱码**：协议字符串和旧客户端文本按 CP936/GBK 处理，并保留定长字段的 NUL 填充。

进一步的字段布局、加密算法和消息编号参见[网络协议与封包结构](protocol.md)、[系统架构与登录链路](architecture.md)和[消息常量索引](constants/MESSAGES.md)。
