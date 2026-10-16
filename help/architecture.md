# 千年 (1000y) 系统架构文档

> 基于 Delphi 7 源码分析，所有端口、状态转换、消息类型均来自实际代码。

---

## 1. 系统架构总览

### 1.1 架构图

```
Client ── TCP 3053 ──> Balance
Client <── SM_CONNECTTHRU ── Balance（返回 Gate 地址）
Client ── TCP 3054 ──> Gate
                       ├── UDP 3030 ──> Balance（BM_GATEINFO）
                       ├── TCP 3050 ──> Login（SQL/SDB 二选一）
                       ├── TCP 3051 ──> DB（选角、锁定等）
                       ├── TCP 配置端口 ──> Paid
                       └── TCP 3052 ──> Game（TGS）
                                        ├── TCP 3051 ──> DB（角色保存、福袋等）
                                        ├── TCP 3040 ──> Battle
                                        ├── TCP 3020 ──> Notice
                                        └── UDP ──> 七路日志目标
```

以上箭头表示主动连接或发送方向；TCP 建立后可双向传输。公网入口是 Balance 与 Gate，其余服务与日志目标应位于受信内网。UDP 日志配置示例为 ITEM 6001、MOUSEEVENT 6010、MONITER 6011、CONNECT 6022、PAY 6000、OBJECT 3003、RELATION 3005。Balance 另保留 TCP 3000 监听，本版本 `gate_biscuit` 不使用该注册通道。

### 1.2 各服务职责

| 服务 | 源码目录 | 职责 |
|------|----------|------|
| **Balance** | `balance/` | 接入调度器。根据 Gate 上报的连接数选择可用且启用的 Gate，向客户端返回其地址；不持续转发游戏流量 |
| **Gate** | `gate_biscuit/` | 网关服务器。维护客户端连接和完整登录状态机，路由消息到 Game/DB/Login/Paid |
| **Login** | `loginsdb_biscuit/` 或 `loginsql/` | 两个二选一实现：SDB 账号适配器，或通过 BDE/ODBC 连接 SQL Server |
| **DB** | `db/` | 数据库服务器。管理角色数据持久化，使用自定义 FDB 文件格式存储 |
| **Game** | `gameserver-tgs1000/` | 游戏服务器。处理游戏逻辑、地图管理、怪物/NPC 更新、用户交互 |
| **Paid** | （外部服务） | 计费服务器。验证用户付费状态和到期时间 |

### 1.3 建议的部署边界

按协议拓扑，客户端只需要访问以下端口：

- `Balance TCP 3053` — 客户端初始连接入口（短连接）
- `Gate TCP 3054` — 客户端游戏连接入口（长连接）

Balance 提供 Gate 地址，Gate 承接后续登录、选角和游戏通信。“Gate 是游戏业务入口”不等于只需对玩家开放 Gate 一个服务。上述端口为默认值，部署时以配置为准。

因此生产部署通常只对外开放 Balance 和 Gate，其余服务应由防火墙限制在内网。DB 与 SQL Login 的客户端接入检查使用程序工作目录下的 `IPList.txt`，不是 `RemoteIP.txt`；文件不存在时检查器会禁用并允许所有来源。源码本身不能证明服务器当前的公网暴露状态：

- SQL Login (`loginsql/sckAccept`) — `IPList.txt` 存在时按列表检查；缺失时允许全部来源
- SDB Login (`loginsdb_biscuit/sckAccept`) — 当前实现不调用 `IPChecker`，直接接受连接
- DB (`sckAccept`) — `IPList.txt` 存在时按列表检查；缺失时允许全部来源
- Game — 通过 Gate 间接访问，不直接对外

DB 读取的 `RemoteIP.txt` 属于另一组远程连接器配置，不能代替接入白名单。无论文件是否存在，都应使用主机防火墙把 Login、DB、Game 和 Paid 限制在受信内网。

`IPList.txt` 每行一个来源 IP，按整行精确匹配；不支持网段、通配符或行尾注释。空文件会拒绝全部来源，缺失文件则放行，二者不同；详见[配置文件说明](protocol.md#55-配置文件)。

Gate 的 `[GATE_SERVER] LOCALIP` 用于向 Balance 公布连接地址；`FMain.FormCreate` 启动玩家监听时只设置 `Port`，没有使用该值绑定监听地址。因此，`LOCALIP=127.0.0.1` 不能作为“只监听本机”的安全保证。跨机器部署时，该值还必须是玩家可达的地址，见[Gate 配置说明](protocol.md#55-配置文件)。

---

## 2. 服务端口表

### 2.1 TCP 端口

| 端口 | 服务 | 方向 | 用途 | 内/外网 |
|------|------|------|------|---------|
| **3053** | Balance | 监听 | 客户端连接入口 | **外网** |
| **3054** | Gate | 监听 | 客户端游戏连接入口 | **外网** |
| **3050** | Login | 监听 | Gate → Login 连接 | 内网 |
| **3051** | DB | 监听 | Gate/TGS → DB 连接 | 内网 |
| **3052** | Game | 监听 | Gate → Game 连接 | 内网 |
| **配置决定** | Paid | 监听 | Gate → Paid；新建 Gate 配置写入 5999，缺项读取回退到 3049 | 内网 |
| **3000** | Balance | 监听 | 保留的 Gate 管理 TCP 通道；本版 Gate 不使用 | 内网 |
| **1021** | SDB Login | 监听 | `REMOTEACCEPTPORT` 远程连接 | 内网 |
| **6060** | SQL Login 的远端服务 | 连接目标 | SQL Login 读取 `[REMOTE_SERVER]` 后主动连接的缺省端口 | 内网 |
| **1024** | DB | 远程管理 | DB 远程同步端口 | 内网 |
| **1020** | DB | 远程管理 | DB 物品远程同步端口 | 内网 |
| **3040** | Battle | 监听 | 战斗服务器 | 内网 |
| **3020** | Notice | 监听 | 公告服务器 | 内网 |

### 2.2 UDP 端口

| 端口 | 方向 | 用途 |
|------|------|------|
| **3030** | Gate → Balance | Gate 心跳注册（`BM_GATEINFO`）；当前源码实际约每秒发送，见 3.3 节缺陷说明 |
| **6001** | Game → Logger | ITEM 物品日志 |
| **6010** | Game → Logger | MOUSEEVENT 鼠标事件日志 |
| **6011** | Game → Logger | MONITER 监控日志 |
| **6022** | Game → Logger | CONNECT 连接日志 |
| **6000** | Game → Logger | PAY 计费日志 |
| **3003** | Game → Logger | OBJECT 对象日志 |
| **3005** | Game → Logger | RELATION 关系日志 |

> 所有 UDP 日志端口的目标 IP 和端口均可在 `sv1000.Ini` 中配置。

---

## 3. 负载均衡（Balance）

Balance 均衡的是**客户端到 Gate 的新连接**，不是把玩家分配到人数最少的游戏区服，也不选择角色数据库。客户端先连接 Balance，取得 Gate 地址后断开，再直接连接该 Gate；后续登录和游戏消息经过 Gate，不再经过 Balance。

Gate 是接入网关，不等于独立游戏世界。同一游戏服可以部署多个 Gate，共同连接同一套 Login、DB 和 Game 服务。例如 Gate A 有 100 个连接、Gate B 有 50 个连接，Balance 会优先把新连接分配给 B；只要二者接入同一套后端，玩家仍在同一个世界，使用同一套账号和角色数据。实际后端由各 Gate 的配置决定，Balance 不检查或保证它们一致。

增加 Gate 主要分担客户端连接和消息转发压力，不会自动分担 TGS 的游戏逻辑计算，也不会自动迁移已经连接的玩家。

### 3.1 核心数据结构

```delphi
// balance/FMain.pas
TGateInfo = record
  boAvail     : Boolean;     // 是否可用
  boChecked   : Boolean;     // 管理员是否勾选启用
  RemoteIP    : String;      // Gate 的外网 IP
  RemotePort  : Integer;     // Gate 的客户端端口
  UserCount   : Integer;     // Gate 最近上报的连接数
  ReceiveTick : LongWord;    // 最后收到心跳的时间
end;

MAX_AVAILABLE_GATE = 10;    // 最多支持 10 个 Gate
```

### 3.2 最少连接数算法

客户端 TCP 连接可写时（`sckUserClientWrite`），Balance 从可用且管理员勾选启用的 Gate 中，选择最近上报连接数最少的节点。客户端不需要先发送获取 Gate 地址的请求报文。

比较值来自 Gate 的 `ConnectorList.Count`，包含尚未进入游戏的连接，并非仅统计游戏中的角色（`PlayingUserCount`）。Balance 使用最近一次状态上报值；分配后不自行递增该值，连接数相同时优先选择列表中靠前的 Gate。

```delphi
// balance/FMain.pas — sckUserClientWrite
nIndex := -1;
MinCount := 0;
for i := 0 to MAX_AVAILABLE_GATE - 1 do begin
  if (GateInfo[i].boAvail = true) and (isGateChecked(i) = true) then begin
    if nIndex = -1 then begin
      MinCount := GateInfo[i].UserCount + 1;
    end;
    if GateInfo[i].UserCount < MinCount then begin
      nIndex := i;
      MinCount := GateInfo[i].UserCount;
    end;
  end;
end;
```

选中后向客户端发送 `SM_CONNECTTHRU` 消息，包含目标 Gate 的 IP 和端口：

```delphi
sConnectThru.rMsg := SM_CONNECTTHRU;
StrPCopy(@sConnectThru.rIpAddr, GateInfo[nIndex].RemoteIP);
sConnectThru.rPort := GateInfo[nIndex].RemotePort;
```

### 3.3 网关注册和心跳机制

当前 `gate_biscuit` 通过 UDP 向 Balance 注册：

**UDP 心跳**（主要方式）：代码用 `BalanceSendTick + 3000` 表达三秒阈值，通过 UDP 发送 `BM_GATEINFO`：

```delphi
// gate_biscuit/FMain.pas — timerDisplayTimer
if CurTick >= BalanceSendTick + 3000 then begin
  udpBalance.RemoteHost := BalanceConnectInfo.RemoteIP;
  udpBalance.RemotePort := BalanceConnectInfo.RemotePort;
  pBalanceData^.rMsg := BM_GATEINFO;
  StrPCopy(@pBalanceData^.rIpAddr, UserAcceptInfo.RemoteIP);
  pBalanceData^.rPort := UserAcceptInfo.LocalPort;
  pBalanceData^.rUserCount := ConnectorList.Count;
  udpBalance.SendBuffer(buffer, sizeof(TBalanceData));
end;
```

但当前源码没有任何位置更新 `BalanceSendTick`，该全局变量初值为 0。`CurTick` 来自 `timeGetTime`，是系统启动后的毫秒计数，不是 Gate 程序运行时长。因此正常运行时上述条件在每次定时器回调中成立；`timerDisplay` 的间隔是 1000 毫秒，实际约为**每秒发送一次**，并没有实现每三秒一次的节流。这是源码缺陷，不能根据条件字面推导发送周期或认定 Gate 启动后要先等待三秒。

Balance 源码还监听 TCP 3000，并包含处理 `BM_GATEINFO` 的 `TGateConnector`；但当前仓库的 `gate_biscuit` 没有对应 TCP 客户端连接代码，因此不能把它描述为本版本 Gate 的有效注册通道。

**超时判定**：Balance 每秒检查，如果 5 秒未收到某 Gate 的心跳，标记为不可用：

```delphi
// balance/FMain.pas — timerDisplayTimer
if CurTick >= GateInfo[i].ReceiveTick + 5000 then begin
  GateInfo[i].boAvail := false;
  DrawStatus(i);
end;
```

### 3.4 短连接设计（10 秒超时）

Balance 与客户端的连接是**短连接**。连接可写且选到可用 Gate 时，Balance 在 `OnWrite` 事件中发送 `SM_CONNECTTHRU` 重定向消息；没有可用 Gate 时不发送重定向。连接创建后记录 `CreateTime`，10 秒后如果连接仍未关闭则在定时检查中强制断开：

```delphi
// balance/uConnect.pas — TConnectorList.Update
if CurTick >= Connector.CreateTime + 10000 then begin
  Connector.Socket.Close;
end;
```

客户端收到 `SM_CONNECTTHRU` 后应主动断开并连接到指定 Gate。

---

## 4. 网关（Gate）状态机

### 4.1 TGameStatus 状态转换

```delphi
// gate_biscuit/uConnector.pas
TGameStatus = (
  gs_none,         // 空闲：包括登录前和选角待命
  gs_login,        // 等待登录验证
  gs_agree,        // 仅声明；当前 Gate 流程未使用
  gs_selectchar,   // 已提交选角，等待 DB 查询结果
  gs_gotogame,     // 正在进入游戏（等待 Game 确认）
  gs_playing,      // 游戏中
  gs_createchar,   // 创建角色中
  gs_deletechar,   // 删除角色中
  gs_createlogin,  // 注册相关保留状态；客户端注册入口未启用
  gs_changepass    // 修改密码相关保留状态
);
```

源码中的实际登录/选角状态转换如下。`LG_SELECT` 成功后 Gate 会把状态恢复为 `gs_none`；只有收到角色选择请求后才进入 `gs_selectchar`：

```
gs_none ──(客户端发送登录)──► gs_login
gs_login ──(LG_SELECT 成功，显示角色列表并处理计费状态)──► gs_none
gs_none ──(计费状态有效且客户端选择角色)──► gs_selectchar
gs_selectchar ──(DB_SELECT 成功且角色归属等检查通过)──► gs_gotogame
gs_gotogame ──(Game 回复 GM_CONNECT)──► gs_playing
连接断开 ──► 销毁该连接对象
```

`GM_DUPLICATE` 分支会清空所选角色、恢复 `gs_none`，并使总连接超时检查到期；它不是返回选角后继续使用同一连接的流程，见[顶号机制](#54-顶号机制gm_duplicate)。

### 4.2 TClientWindow 窗口状态

```delphi
// gate_biscuit/uConnector.pas
TClientWindow = (
  cw_none,         // 无窗口
  cw_login,        // 登录窗口
  cw_createlogin,  // 创建账号窗口
  cw_selectchar,   // 角色选择窗口
  cw_main,         // 游戏主窗口
  cw_agree         // 仅声明；当前 Gate 流程未使用
);
```

Gate 通过 `SM_WINDOW` 消息控制客户端显示/隐藏窗口：

登录成功时 Gate 直接隐藏 `cw_login` 并显示 `cw_selectchar`。服务端根目录的 `GameAgree.TXT` 由 Game Server 的 `TSystemAlert` 加载，在进入游戏后的系统窗口中处理，不属于 Gate 登录状态机。

```delphi
procedure TConnector.ShowWindow(aKey: TClientWindow; boShow: Boolean);
begin
  if boShow then FClientWindow := aKey;
  sWindow.rmsg := SM_WINDOW;
  sWindow.rwindow := Byte(aKey);
  sWindow.rboShow := boShow;
  AddSendData(@sWindow, sizeof(sWindow));
end;
```

### 4.3 消息路由机制

Gate 是所有客户端消息的枢纽，根据当前状态路由到不同后端服务：

**客户端 → Gate 的消息处理**（`uConnector.pas — Update`）：

```
if FGameStatus = gs_playing then
  → 转发到 Game（GM_SENDGAMEDATA）
else
  → 本地 MessageProcess 处理登录/选角等流程
```

**各后端 → Gate → 客户端的消息处理**：

| 来源 | 处理函数 | 关键消息 |
|------|----------|----------|
| Game | `GameMessageProcess` | `GM_CONNECT`（进入游戏）、`GM_DISCONNECT`（断开）、`GM_SENDGAMEDATA`（游戏数据转发）、`GM_DUPLICATE`（顶号）、`GM_SENDALL`（全服广播）、`GM_SENDUSERDATA`（角色数据写入 DB） |
| DB | `DBMessageProcess` | `DB_INSERT`（创建角色结果）、`DB_SELECT`（角色数据查询结果） |
| Login | `LoginMessageProcess` | `LG_INSERT`（保留的注册回包分支）、`LG_SELECT`（登录验证结果）、`LG_UPDATE`（账号信息更新） |
| Paid | `PaidMessageProcess` | `PM_CHECKPAID`（计费验证结果） |

当前 `MessageProcess` 对 `CM_CREATEIDPASS`、`CM_CREATEIDPASS2`、`CM_CREATEIDPASS3` 都直接退出，不向 Login 发起注册。保留消息常量、状态或回包处理函数，不代表客户端账号注册功能已经启用；这与 `CM_CREATECHAR` 创建游戏角色是两件事。

### 4.4 超时和断开机制

**请求超时（60 秒）**：仅在状态既非 `gs_none`、也非 `gs_playing` 时检查；距 `RequestTime` 达到 60 秒便重置状态并提示超时。该时间戳在客户端消息处理函数 `MessageProcess` 的尾部更新，不是每个后端请求各自独立的计时器：

```delphi
// gate_biscuit/uConnector.pas — Update
if (FGameStatus <> gs_none) and (FGameStatus <> gs_playing) then begin
  if RequestTime + 60000 <= CurTick then begin
    RequestTime := 0;
    FGameStatus := gs_none;
    // 根据当前窗口发送超时提示
    SendStatusMessage(MESSAGE_LOGIN, '[TIMEOUT] 다시 시도해 주세요');
  end;
end;
```

**总连接超时（5 分钟）**：连接建立后达到 5 分钟且仍未进入 `gs_playing` 时强制断开；已通过账号验证、停留在角色选择界面的连接也在检查范围内：

```delphi
if FGameStatus <> gs_playing then begin
  if (CreateTime > 0) and (CurTick >= CreateTime + 1000 * 60 * 5) then begin
    CreateTime := 0;
    Socket.Close;
  end;
end;
```

### 4.5 包频率限制

Gate 使用环形缓冲区记录每个连接的包频率（`PacketCountBufferSize = 8` 个采样点）：

```delphi
// gate_biscuit/uConnector.pas
CheckTime := CurTick - PacketCount[PCIndex].Tick;
PacketCount[PCIndex].Count := PacketReceiver.Count;
PacketCount[PCIndex].Tick := CurTick;
PCIndex := (PCIndex + 1) mod PacketCountBufferSize;

if CheckTime >= 1000 then begin
  nPacketCount := (GetPacketCountOnCycle * 1000) div CheckTime;
  if nPacketCount > LimitPacketCount then begin  // 默认 10 包/秒
    Socket.Close;  // 超限直接断开
  end;
end;
```

`LimitPacketCount` 在 `GATE.INI` 中配置，默认值为 10。10 毫秒定时器调用的是连接列表更新；`TConnectorList.Update` 每轮只处理 `max(40, 连接数 * 4 div 100)` 个连接，遍历完一圈即停止，并非每个连接都每 10 毫秒更新。

连接数稳定、每次定时器恰好间隔 10 毫秒时，单个连接的 8 槽采样周期如下：

| 连接数 | 每轮处理数 | 8 槽采样周期 |
| ---: | ---: | ---: |
| 40 | 40 | 80ms |
| 100 | 40 | 200ms |
| 500 | 40 | 1000ms |
| 1000 | 40 | 2000ms |

实际周期还受定时器延迟和连接增减影响。低连接数、调度顺畅时，稳定运行后的 `CheckTime >= 1000` 可能一直不成立；连接数增加或调度变慢时又可能触发。触发后比较的是该采样周期内的平均包率，也不是任意一秒窗口的硬上限。当前代码不能被视为持续有效的“一秒最多 10 包”防护，生产环境仍需外围限速。

### 4.6 接入校验边界

Gate 检查新连接的版本和地区、登录密码及选角归属，但不能据此认为公网输入已经完整校验：

- 客户端包的 `RequestID` 递增检查在 `TConnector.Update` 中被注释。原生客户端仍按连接维护递增序号，这是发送行为，不是当前 Gate 实际执行的拒绝条件。
- `TPacketReceiver.Update` 没有核对解密结果长度与声明包长的一致性；Gate 随后复制载荷，并直接使用 `TWordComData.Size` 转发或按命令结构读取，缺少完整的嵌套长度检查。详见[接收流程与校验缺口](protocol.md#44-缓冲区管理)。
- 进入 `gs_playing` 后，游戏命令以 `GM_SENDGAMEDATA` 转交 TGS，物品、战斗等游戏规则仍需由 TGS 验证。版本字段和自定义加密封装不等于客户端身份认证，也不能代替输入校验。

---

## 5. 完整登录流程

### 5.1 流程步骤

```
步骤  方向                     消息/动作                              状态变化
────────────────────────────────────────────────────────────────────────────────
 1   Client → Balance         TCP 连接 (3053)                       —
 2   Balance → Client         SM_CONNECTTHRU (最少连接 Gate 的 IP:Port)  —
 3   Client → Gate            TCP 连接 (3054)                       gs_none
 4   Client → Gate            CM_VERSION (目标Gate版本、区域版本)     gs_none
 5   Gate → Client            通过：SM_MESSAGE；失败：SM_CLOSE        cw_login（通过时）
 6   Client → Gate            CM_IDPASS (LoginID + LoginPW)         gs_login
 7   Gate → Login             LG_SELECT (ConnectID, LoginID)        —
 8   Login → Gate             LG_SELECT 结果 (TLGRecord 含角色列表)  —
 9   Gate                     比对 PrimaryKey 和 PassWord           —
10   Gate → Client            隐藏 cw_login，显示 cw_selectchar      cw_selectchar
11   Gate → Login             LG_UPDATE (IP、LastDate 等账号信息)    —
12   Gate → Client            SM_CHARINFO (角色列表)                 随后恢复 gs_none
13   Gate → Paid              PM_CHECKPAID（需要外部查询时）          —
14   Paid → Gate              返回付费类型和有效期                   gs_none
15   Client → Gate            CM_SELECTCHAR (角色名 + 服务器)        gs_selectchar
16   Gate → DB                DB_SELECT (角色名)                    —
17   DB → Gate                DB_SELECT 结果 (TDBRecord)            —
18   Gate → Game              GM_CONNECT (ConnectID, TDBRecord)     gs_gotogame
19   Game → Gate              GM_CONNECT (确认)                     gs_playing
20   Gate → Client            隐藏 cw_selectchar，显示 cw_main       cw_main
21   Gate → DB                DB_LOCK (角色名)                      —
22   Game → Gate              游戏数据流                            GM_SENDGAMEDATA 转发
```

### 5.2 涉及的服务和消息类型

| 阶段 | 参与服务 | 消息 |
|------|----------|------|
| 负载均衡 | Balance ↔ Client | `SM_CONNECTTHRU` |
| 账号验证 | Gate ↔ Login | `LG_SELECT` |
| 角色列表 | Gate ↔ Login、Gate → Client | `LG_SELECT` 返回角色槽位，`SM_CHARINFO` 下发列表 |
| 角色加载 | Gate ↔ DB | `DB_SELECT` 读取选中的角色数据 |
| 计费验证 | Gate ↔ Paid | 当前 Gate 使用 `PM_CHECKPAID`；`PM_CHECKPAID2` 未在此实现中使用 |
| 进入游戏 | Gate ↔ Game | `GM_CONNECT` |
| 角色在线标记 | Gate → DB | `DB_LOCK` |

### 5.3 角色锁定机制（DB_LOCK）

当角色成功进入游戏后（步骤 21），Gate 向 DB 发送 `DB_LOCK`：

```delphi
// gate_biscuit/uConnector.pas — GameMessageProcess
GM_CONNECT:
begin
  FGameStatus := gs_playing;
  ShowWindow(cw_selectchar, FALSE);
  ShowWindow(cw_main, TRUE);
  StrPCopy(@buffer, PlayChar);
  DBSender.PutPacket(ConnectID, DB_LOCK, 0, @buffer, SizeOf(buffer));
end;
```

`DB_LOCK` 向 DB 的 `CurrentCharList` 添加角色在线标记，`DB_UNLOCK` 移除标记。普通 `DB_SELECT` 直接调用 `DBProvider.Select` 读取记录并检查 CRC，不检查该列表，因此这个“锁”不是阻止重复登录的互斥锁。重复登录由 TGS 的角色名称索引 `NameKey` 和 `WaitPlayerList` 处理。

正常角色下线时，TGS 的 `TConnector.Destroy` 发送 `DB_UNLOCK`；外部 Gate 析构函数中的同名发送代码已被注释，不能把解锁职责完全归给外部 Gate。

### 5.4 顶号机制（GM_DUPLICATE）

当同一角色重复登录时，Game 服务器执行顶号逻辑：

```delphi
// gameserver-tgs1000/uConnect.pas — TConnectorList.CreateConnect
Connector := NameKey.Select(StrPas(@pcd^.PrimaryKey));
if Connector <> nil then begin
  // 断开旧连接
  GateConnectorList.AddSendServerData(Connector.GateNo, Connector.ConnectID,
    GM_DISCONNECT, nil, 0);
  // 通知新连接顶号
  GateConnectorList.AddSendServerData(GateNo, ConnectID,
    GM_DUPLICATE, nil, 0);
  // 清理旧连接数据
  UniqueKey.Delete(Connector.ConnectID);
  NameKey.Delete(Connector.CharName);
  DataList.Remove(Connector);
  Connector.Free;
  exit;
end;
```

Gate 收到 `GM_DUPLICATE` 后的处理：

```delphi
// gate_biscuit/uConnector.pas — GameMessageProcess
GM_DUPLICATE:
begin
  SendStatusMessage(MESSAGE_SELCHAR, '접속해제 되었습니다');
  PlayChar := ''; UseChar := ''; UseLand := '';
  FGameStatus := gs_none;
  CreateTime := timeGetTime - (1000 * 60 * 5);  // 立即触发超时断开
end;
```

Game 还维护 `WaitPlayerList`（等待列表）。角色连接销毁时加入记录；记录仍存在时，同名角色的新接入会收到 `GM_DUPLICATE`。等待记录通过以下任一路径解除：

- TGS 收到 `DB_UPDATE_END` 的成功回包，按角色名立即调用 `WaitPlayerList.Release`。
- `WaitPlayerList.Update` 检测到等待时间到期，清理记录。

超时值 `WAITPLAYERTICK` 从 `sv1000.Ini` 的 `[SERVER] WAITPLAYERTIME` 读取，缺省为 10000 个 `mmAnsTick`，按默认每 tick 10ms 计算约为 100 秒。实际等待时间受保存回包、配置和 tick 单位影响，不是断线后必须等满 100 秒。超时清理本身也不证明存档成功。

### 5.5 计费校验条件

Gate 在账号验证成功后先发送角色列表，再处理计费状态。标准 `CM_IDPASS` 登录是否查询外部 Paid，由当时的发送器和计费状态共同决定：

- `PaidSender=nil` 或 `CHECKPAIDINFO=FALSE` 时，直接把 `FPaidData.rPaidType` 设为 `pt_validate`，不等待外部计费回包。
- 仅在上述处理后类型仍为 `pt_none` 时，向 Paid 发送 `PM_CHECKPAID`。其他已有非 `pt_none` 的类型不走此查询；例如 `CM_IDPASSAZACOM` 分支会预设 `pt_timepay`。
- 选角时若类型为 `pt_none`，提示等待；若为 `pt_invalidate`，拒绝继续。外部 `PM_CHECKPAID` 回包的 `ResultCode=0` 会直接结束处理，不应用其计费数据；非零回包仍要核对账号并按付费模式处理，不能等同于自动放行。

因此，`CHECKPAIDINFO=TRUE` 不保证 Paid 不可用时拒绝登录。文档描述的是当前分支行为，不代表已实现计费故障时的拒绝策略。

---

## 6. 数据持久化流程

### 6.1 数据传递路径

角色数据从 Game 到 DB 的保存路径：

```
Game (TConnector)
  │  AddSaveData() → SaveBuffer (环形缓冲区, 4MB)
  │
  ▼  ConnectorList.Update() 每 10ms 检查
  │
Game 内部 FGate (TfrmGate)
  │  AddSendDBServerData(DB_UPDATE / DB_UPDATE_END)
  │
  ▼  通过 TGS ↔ DB 的 TCP 连接
  │
DB (TDBProvider)
  │  写入 FDB 文件
  ▼
```

此处 `TfrmGate` 定义于 `gameserver-tgs1000/FGate.pas`，是 TGS 自身的通信窗口；其 `sckDBConnect` 直接连接 DB。外部 `gate_biscuit` 仍保留 `GM_SENDUSERDATA` 转发分支，但上述 SaveBuffer 保存路径不经过它。

### 6.2 环形缓冲区批量写入

Game 服务器使用 `TPacketBuffer` 作为保存队列（4MB 容量）：

```delphi
// gameserver-tgs1000/uConnect.pas — TConnectorList
SaveBuffer := TPacketBuffer.Create(1024 * 1024 * 4);  // 4MB 缓冲区
```

保存数据封装为 `TCheckCharData`（包含 `TDBRecord` + `rEnd` 标志位）：

- `rEnd = 0`：发送 `DB_UPDATE`
- `rEnd = 1`：发送 `DB_UPDATE_END`；当前定期与下线保存入口均使用此值

### 6.3 定期保存

每个在线角色每 10 分钟触发一次保存（`60 * 10 * 100` 个 10ms tick）：

```delphi
// gameserver-tgs1000/uConnect.pas — TConnector.Update
if SaveTick + 60 * 10 * 100 < CurTick then begin
  Move(CharData, rCharData, SizeOf(TDBRecord));
  rCharData.rEnd := 1;
  ConnectorList.AddSaveData(@rCharData, SizeOf(TCheckCharData));
  SaveTick := CurTick;
end;
```

> 定期保存使用 `rEnd := 1`（即 `DB_UPDATE_END`）；DB 返回成功后，TGS 的 `FGate.DBMessageProcess` 调用 `WaitPlayerList.Release`。连接器的定期入队功能由 TGS 主窗口 `chkSaveUserData` 复选框控制；`UUser.pas` 中每 10 分钟收集角色状态是另一条更新内存记录的路径。

### 6.4 下线保存

角色断开连接时（`TConnector.Destroy`），执行最终保存：

```delphi
// gameserver-tgs1000/uConnect.pas — TConnector.Destroy
if CharName <> '' then begin
  if BattleConnectState = bcs_none then EndLayer;
  Move(CharData, rCharData, SizeOf(TDBRecord));
  rCharData.rEnd := 1;
  ConnectorList.AddSaveData(@rCharData, SizeOf(TCheckCharData));
  frmGate.AddSendDBServerData(DB_UNLOCK, @CharData, SizeOf(CharData.PrimaryKey));
end;
```

下线时同时发送 `DB_UNLOCK` 释放角色锁。

### 6.5 保存队列处理

TGS 主定时器每 10ms 调用 `TConnectorList.Update()`，但发送分支还要求经过 10 个 `mmAnsTick`。`Common/uAnsTick.pas` 默认每 10ms 增加 1，因此有待保存记录时，约每 100ms 尝试发送一条到 DB；只有成功写入发送缓冲区才出队。窗口定时器调度及连接状态可能延长间隔。

```delphi
// gameserver-tgs1000/uConnect.pas — TConnectorList.Update
if SaveBuffer.Count > 0 then begin
  if CurTick >= SaveTick + 10 then begin
    if SaveBuffer.View(@CharData) = true then begin
      case CharData.rEnd of
        0: if frmGate.AddSendDBServerData(DB_UPDATE, @CharData.rCharData, SizeOf(TDBRecord)) then SaveBuffer.Flush;
        1: if frmGate.AddSendDBServerData(DB_UPDATE_END, @CharData.rCharData, SizeOf(TDBRecord)) then SaveBuffer.Flush;
      end;
    end;
    SaveTick := CurTick;
  end;
end;
```

### 6.6 保存失败与关服边界

`AddSendDBServerData` 返回成功，只表示 `TPacketSender.PutPacket` 接受数据；调用端据此将保存队列出队，不代表 DB 已写盘。`FGate.DBMessageProcess` 收到 `DB_UPDATE` / `DB_UPDATE_END` 失败回包时只记录 `User Data Save Failed`，没有将记录重新加入保存队列。DB 连接断开会释放该连接的收发缓冲，也没有为已出队记录建立逐条确认后的重放队列。

保存入队同样有容量限制：`TConnectorList.AddSaveData` 没有检查 `SaveBuffer.Put` 的返回值。因此不能把这条链路描述成保证送达的持久化队列，或认为自动重连会自动恢复所有失败保存。

正常退出入口 `TFrmMain.Exit1Click` 设置关闭标志，并启动关服检查。`TimerCloseTimer` 等待角色列表、连接列表和 `SaveBuffer` 均为空后，将检查间隔从 1 秒改为 5 秒；下一次条件仍满足才关闭。它不以 DB 未确认请求数或网络发送缓冲是否排空作为退出条件。

维护时先阻止新登录，保持 Gate、DB 连接可用，确认角色下线、保存队列处理及 DB 成功回包，再结束写入服务并备份。仅看到队列为 0、等待时间到期或 TGS 进程退出，不能单独证明最后一次保存成功。详见 [TGS 运行与生命周期](TGSRuntime.md#正常关服与保存确认)。

依据：`uConnect.pas` 的 `AddSaveData`、`Update`（队列处理节选见上一节），[FGate.pas](TGS核心源码/FGate.pas) 的 `AddSendDBServerData`、`DBMessageProcess`、`sckDBConnectDisconnect`，[SVMain.pas](TGS核心源码/SVMain.pas) 的 `Exit1Click`、`TimerCloseTimer`。

---

## 7. 服务间通信拓扑

### 7.1 TCP 连接关系图

```
主动连接方           监听/目标服务
Client       ──3053──> Balance
Client       ──3054──> Gate
Gate         ──3050──> Login
Gate         ──3051──> DB
Gate         ──3052──> Game
Gate         ──配置──> Paid
Game         ──3051──> DB
Game         ──3040──> Battle
Game         ──3020──> Notice
远程管理端   ──1021──> SDB Login
SQL Login    ──6060──> REMOTE_SERVER（配置目标）
远程管理端 ─1024/1020─> DB
```

**连接方向说明**：

- Gate 作为**客户端**主动连接到 Game/Login/DB/Paid
- Balance 的 `sckGate` 保留 TCP 3000 监听；当前 Gate 实现只通过 UDP 3030 上报状态
- Game 的 `GateConnectorList` 作为**服务端**接受 Gate 的连接
- DB 的 `sckAccept` 作为**服务端**接受 Gate 和 TGS 的连接
- Game 自身作为**客户端**主动连接 DB/Battle/Notice

SDB Login 监听配置的 `REMOTEACCEPTPORT`（缺省 1021）；SQL Login 不监听该端口，而是作为客户端连接 `[REMOTE_SERVER]`（缺省 `127.0.0.1:6060`）。

### 7.2 UDP 日志推送

Game 服务器通过 UDP 向外部日志服务推送数据，共 7 个日志通道：

| 日志类型 | 配置节 | 服务器配置端口 | 源码缺省端口 | 说明 |
|----------|--------|----------------|--------------|------|
| ITEM | `[UDP_ITEM]` | 6001 | 6001 | 物品变动日志 |
| MOUSEEVENT | `[UDP_MOUSEEVENT]` | 6010 | 6001 | 鼠标事件日志 |
| MONITER | `[UDP_MONITER]` | 6011 | 6000 | 系统监控 |
| CONNECT | `[UDP_CONNECT]` | 6022 | 6022 | 连接/断开日志 |
| PAY | `[UDP_PAY]` | 6000 | 6000 | 计费日志 |
| OBJECT | `[UDP_OBJECT]` | 3003 | 3003 | 对象操作日志 |
| RELATION | `[UDP_RELATION]` | 3005 | 3005 | 关系日志 |

“服务器配置端口”对应当前提供的 `sv1000.ini`；只有相应配置项缺失时，程序才使用 `SVMain.pas` 中的源码缺省值。各通道缺省 IP 均为 `127.0.0.1`。

### 7.3 自动重连机制

**Gate 的自动重连**：Gate 的 `timerDisplayTimer`（每秒执行）检查所有后端连接状态，断线后自动重连：

```delphi
// gate_biscuit/FMain.pas — timerDisplayTimer
if sckGameConnect.Active = false then begin
  shpGameConnected.Brush.Color := clRed;
  sckGameConnect.Socket.Close;
  sckGameConnect.Active := true;    // 自动重连
end;
// 对 DB、Login、Paid 连接同样处理
```

**DB 的远程连接重连**：DB 服务器的定时器周期性检查远程管理连接，断开后自动重连：

```delphi
// db/FMain.pas — Timer1Timer
if not RemoteConnector.Connected then begin
  RemoteConnector.Connect;
end;
if not ItemRemoteConnector.Connected then begin
  ItemRemoteConnector.Connect;
end;
```

**Login 的远程连接重连**：Login 同样在 `timerDisplayTimer` 中检查并自动重连远程管理连接。

---

## 附录：关键消息常量汇总

### 客户端 ↔ Gate 消息

| 常量 | 值 | 方向 | 说明 |
|------|-----|------|------|
| `SM_WINDOW` | 1 | S→C | 窗口显示/隐藏控制 |
| `SM_MESSAGE` | 2 | S→C | 状态消息提示 |
| `SM_CONNECTTHRU` | 253 | S→C | Balance 重定向到 Gate |
| `SM_CHARINFO` | 3 | S→C | 角色列表信息 |
| `SM_CLOSE` | 255 | S→C | 关闭连接（版本不匹配等） |

### Gate ↔ Game 消息

| 常量 | 值 | 说明 |
|------|-----|------|
| `GM_CONNECT` | 0 | 角色进入游戏 / 确认进入 |
| `GM_DISCONNECT` | 1 | 断开连接 |
| `GM_SENDUSERDATA` | 2 | 角色数据写入请求 |
| `GM_SENDGAMEDATA` | 3 | 游戏数据转发 |
| `GM_DUPLICATE` | 4 | 顶号通知 |
| `GM_SENDALL` | 5 | 全服广播 |
| `GM_UNIQUEVALUE` | 6 | 网关唯一标识请求 |

### Gate/TGS ↔ DB 消息

| 常量 | 值 | 说明 |
|------|-----|------|
| `DB_INSERT` | 0 | DB 返回创建角色结果；作为请求发送时，当前 DB 实现直接拒绝 |
| `DB_SELECT` | 1 | 查询角色数据 |
| `DB_UPDATE` | 3 | 更新角色数据 |
| `DB_LOCK` | 4 | 添加角色在线标记 |
| `DB_UNLOCK` | 5 | 移除角色在线标记 |
| `DB_UPDATE_END` | 9 | 更新角色数据（结束标记，释放 WaitPlayer） |
| `DB_CREATENEW` | 10 | Gate 发起创建角色请求，结果以 `DB_INSERT` 回包 |

请求与回复方向、通信记录和磁盘记录的区别见[玩家数据库文档](database.md)。

### Gate ↔ Login 消息

| 常量 | 值 | 说明 |
|------|-----|------|
| `LG_INSERT` | 0 | 创建账号 |
| `LG_SELECT` | 1 | 登录验证 |
| `LG_DELETE` | 2 | 删除账号 |
| `LG_UPDATE` | 3 | 更新账号信息 |

### Balance 消息

| 常量 | 值 | 说明 |
|------|-----|------|
| `BM_GATEINFO` | 0 | Gate 心跳/注册信息 |

### DB 返回码

| 常量 | 值 | 说明 |
|------|-----|------|
| `DB_OK` | 0 | 操作成功 |
| `DB_ERR` | 1 | 通用错误 |
| `DB_ERR_NOTFOUND` | 2 | 未找到记录 |
| `DB_ERR_DUPLICATE` | 3 | 重复记录 |
| `DB_ERR_IO` | 4 | I/O 错误 |
| `DB_ERR_INVALIDDATA` | 5 | 无效数据 |
| `DB_ERR_NOTENOUGHSPACE` | 6 | 空间不足 |

### 客户端版本

```delphi
// PROGRAM_VERSION = 39; // 源码中保留的旧值
PROGRAM_VERSION = 40;    // 公开源码基线值
```

版本检查针对 Gate 的实际构建值。公开源码基线为 40，不代表任一线上部署的版本；客户端连接具体服务器时必须发送该 Gate 实际要求的值。
