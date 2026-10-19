# TGS 启动、连接与保存生命周期

TGS 负责世界对象、玩家状态和游戏规则，不直接充当玩家公网登录入口。本页串联公开源码中的运行主干；端口以目标配置为准，完整网络拓扑见 [系统架构](architecture.md)，报文结构见 [通信协议](protocol.md)。

公开工程见 [TGS1000](https://github.com/oiuv/TGS1000)，本页列出的 TGS 单元可在该仓库根目录查找；共享依赖位于 `Kor/`。本资料库已有源码镜像继续保留，版本适用范围和引用规范见 [公开源码与引用说明](source-reference.md)。

## 1. 启动顺序与资源

`tgs1000.dpr` 先创建主窗体，再创建通知连接、Gate/DB/战场连接及日志窗体，最后进入 VCL 消息循环。各单元的 `initialization` 在这些窗体创建之前执行，不能把所有初始化都归到 `FormCreate`。

| 阶段 | 关键操作 | 源码入口 |
| --- | --- | --- |
| 单元初始化 | `svClass` 创建物品、药品、武功、怪物、地图辅助规则等配置对象，并加载 `game.ini` | `svClass.pas` 的 `initialization` |
| 主窗体创建 | 读取 `sv1000.Ini`，加载 `Script/Script.SDB`，创建地图管理器、连接表、玩家表、门派、擂台、传送门等对象 | `TFrmMain.FormCreate` |
| 地图管理器创建 | 加载 `Init/MAP.SDB`，建立地图及其怪物、NPC、物品等列表，并绑定地图脚本 | `TManagerList.Create/LoadFromFile` |
| 通信窗体创建 | 配置 DB/战场连接，启用 Gate 接入监听和各自的处理定时器 | `TfrmGate.FormCreate` |
| 激活与运行 | 主窗体激活后设置服务活动状态，加载公告等资料；定时器持续推进连接和游戏世界 | `TFrmMain.FormActivate/TimerProcessTimer` |

这些加载入口大量使用 `./Init`、`./Script`、`./sv1000.Ini` 等相对路径，应核对进程工作目录及完整运行资源。启动不是无副作用的配置检查：例如 `FormCreate` 会读取并递增写回 `sv1000.Ini` 的 `[DATABASE] COUNT`。

地图管理器的 `ServerID` 是本进程内地图管理标识，不能仅凭名字解释成独立 TGS 实例编号。数据表具体用途见 [运行资源索引](RuntimeResources.md)、[sv1000.Ini](sv1000.ini.md)、[Map.SDB](Init_map.sdb.md) 和 [脚本系统](Script.md)。

源码：工程入口 `tgs1000.dpr`、通知连接 `FSockets.pas`；本资料库可查阅 [svClass.pas](TGS核心源码/svClass.pas)、[SVMain.pas](TGS核心源码/SVMain.pas)、[uManager.pas](TGS核心源码/uManager.pas)、[FGate.pas](TGS核心源码/FGate.pas)。

## 2. 调度与时间单位

`TFrmMain.TimerProcessTimer` 的配置间隔为 10 毫秒，取 `mmAnsTick` 后依次推进：

```text
Gate 连接 → 等待退出角色表 → 监狱 → 角色连接 → 玩家
  → 地图管理器 → 传送门 → 门派/镜像/区域效果
  → 擂台/门派战 → 声音对象 → ScriptManager.Update
```

这里是调度入口顺序，不代表每个对象都以相同频率执行全部逻辑。默认 `mmAnsTick` 约每 10 毫秒增加 1，因此常见 `100 tick` 约为 1 秒；具体方法还会检查自己的计时字段。VCL 定时器和系统计时也不是实时调度保证，不能把设置间隔当作负载下的严格执行周期。

另外还有独立的通信处理入口：`FGate.timerProcess` 推进 DB/战场收发，`FSockets.TimerProcess` 处理通知服务。DB/战场断线后的定时重连只恢复连接，不等于自动重放之前的业务请求。

公开源码的 `TScriptManager.Update` 方法体为空。地图、角色和其他对象的事件路径才是脚本执行的重要入口，不能据主循环末尾的一次 `Update` 推断所有脚本都在那里统一定时执行。事件条件见 [TGS 地图、对象与事件](TGSWorld.md)。

源码：[SVMain.pas](TGS核心源码/SVMain.pas) 的 `TimerProcessTimer`；[uManager.pas](TGS核心源码/uManager.pas) 的 `TManagerList.Update`；[FGate.pas](TGS核心源码/FGate.pas) 与 `FSockets.pas` 的定时器；[uScriptManager.pas](TGS核心源码/uScriptManager.pas) 的 `TScriptManager.Update`。默认计时来源为共享单元 `Common/uAnsTick.pas`。

## 3. Gate 连接、角色进入与命令分派

```text
Gate 的 GM_CONNECT
  → TGateConnector.MessageProcess
  → TConnectorList.CreateConnect
  → TConnector.StartLayer
  → TUserList.InitialLayer / StartChar
  → 角色进入世界

Gate 的 GM_SENDGAMEDATA
  → TConnectorList.AddReceiveData
  → 该角色的 ReceiveBuffer
  → TUser.Update
  → TUser.MessageProcess（CM_* 游戏命令）

游戏处理结果 → TConnector.AddSendData
  → TGateConnectorList.AddSendData
  → GM_SENDGAMEDATA → Gate → 玩家客户端
```

Gate 连接和角色连接不是同一个对象：一个 `TGateConnector` 对应一条 Gate→TGS 连接，玩家由 `TConnector` 单独管理；转发时带角色连接标识。

`CreateConnect` 会检查空主键、已有角色连接及等待退出角色表等条件；成功后建立主键/名称索引及连接列表。它不是收到包后无条件创建第二个同名角色。`StartLayer` 把传入角色记录复制到运行数据，分离 `Dummy` 中的付费信息，再初始化角色及发送进入通知。登录位置与死亡复活位置规则不同，见 [PosByDie.SDB](Init_PosByDie.sdb.md)。

普通游戏命令实际在 `TUser.Update` 从连接接收缓冲取出后，交给 `TUser.MessageProcess`。公开源码中的 `TConnector.MessageProcess` 是空方法，不是 `CM_*` 命令分派器。处于战场转发状态时，`TConnector.Update` 另有向战场服务发送 `GB_GAMEDATA` 的分支，不能把普通地图路径套到所有状态。

进入世界后还会触发角色脚本，例如 `UserStart` 绑定脚本并调用 `OnUserStart`。物品、攻击、移动和窗口请求最终仍由 TGS 对当前状态及规则做校验；客户端显示成功请求，不代表服务器已接受并完成操作。

源码：`uGConnect.pas` 的 `TGateConnector.MessageProcess/AddSendData`；`uConnect.pas` 的 `CreateConnect/StartLayer/Update/AddSendData`；本资料库可查阅 [UUser.pas](TGS核心源码/UUser.pas) 的 `TUser.Update/MessageProcess/UserStart` 和 [通信协议](protocol.md) 的转发结构。

## 4. 游戏状态与数据库记录之间的边界

保存路径分成几个不同阶段，不能用一个“保存成功”概括：

| 阶段 | 含义 | 不代表什么 |
| --- | --- | --- |
| 角色状态整理 | 从运行对象整理背包、装备、武功、属性等角色记录 | DB 已收到最新状态 |
| `AddSaveData` | 将待保存记录加入 TGS 的 `SaveBuffer` | 持久化日志或可靠重试队列 |
| `AddSendDBServerData` 返回成功 | 发送器接受了报文，调用端可推进本地保存队列 | DB 已完成写入 |
| DB 返回成功应答 | DB 处理结果回到 TGS，对应路径记录日志或解除等待 | 每条应答都由关闭流程统一等待 |

周期保存与角色退出都会参与这些路径。`TConnector.Destroy` 在普通世界状态先执行 `EndLayer`，随后构造退出保存记录并请求解锁、登记等待退出角色；战场状态另有结束通知路径。不能把销毁连接等同于磁盘上已安全落盘。

物品的 `BoNotSave` 也在正常角色记录序列化时生效，不只是某类备份工具的过滤选项。角色字段、快照、DB 备份格式见 [玩家数据库](database.md)；物品字段边界见 [Item.SDB](Init_item.sdb.md)。

源码：[UUser.pas](TGS核心源码/UUser.pas) 的 `TUserList.FinalLayer`；`uConnect.pas` 的 `TConnector.Destroy/Update`、`TConnectorList.AddSaveData/Update`；[FGate.pas](TGS核心源码/FGate.pas) 的 `AddSendDBServerData/DBMessageProcess`。保存队列的关键代码节选见 [系统架构](architecture.md#65-保存队列处理)。

## 正常关服与保存确认

`TFrmMain.Exit1Click` 设置关闭标志并启动关闭定时器。后续主循环不再推进 `ManagerList.Update`；关闭定时器通过 `CloseAllConnect` 请求断开角色连接，等待玩家列表、连接列表和本地保存队列归零。满足这些条件后再经过约 5 秒的定时阶段关闭程序。

这个流程**没有逐条等待 DB 成功应答**，也没有把 DB 发送器积压计入完成条件：

- `AddSaveData` 没有处理 `SaveBuffer.Put` 的失败返回，因此不能宣称所有入队请求都有可靠接收保证。
- 发送器接受报文后，本地保存队列便可能推进；传输断开时发送/接收对象被释放，没有通用的业务重放机制。
- `DBMessageProcess` 对保存失败主要记录日志，没有自动重新入队；退出保存成功应答还会解除等待退出角色状态。
- 定时自动重连与保存成功确认是两回事。

因此，运维应先限制新角色进入，使用正常退出流程，并保持 Gate/DB 可用；结合退出情况、队列和 DB 成功/失败记录确认保存结果后，再停止后端、复制数据库或备份。不能只以 TGS 窗口消失、本地队列为零或固定等几秒作为全部角色已经可靠保存的证明。

源码：[SVMain.pas](TGS核心源码/SVMain.pas) 的 `Exit1Click/TimerCloseTimer`；`uConnect.pas` 的 `CloseAllConnect/Update/AddSaveData`；[FGate.pas](TGS核心源码/FGate.pas) 的 `DBMessageProcess/sckDBConnectDisconnect`。具体保存周期与 DB 文件写入行为见 [系统架构](architecture.md#66-保存失败与关服边界) 和 [玩家数据库](database.md)。

## 5. 按症状定位

| 问题 | 优先检查 |
| --- | --- |
| 能连接 Gate，但角色无法进入 | TGS 连接、角色主键/重名/等待退出状态、`StartLayer` 初始化及地图资料 |
| 已进入，但移动/攻击不执行 | `TUser.MessageProcess` 准入、死亡/窗口/地图限制、角色动作和时间条件 |
| NPC/怪物/脚本不符合预期 | 地图对象的实际事件路径、[脚本索引加载规则](Script.md#scriptsdb)、生成表及地图开关 |
| 游戏内变化正确，重登恢复旧状态 | 状态整理、本地保存入队、DB 发送/应答及失败日志，逐段区分 |
| 关服后出现保存问题 | 是否走正常退出、Gate/DB 是否保持可用、DB 应答与发送队列是否已处理 |

本页覆盖启动、调度、进入与退出主干；战斗规则见 [TGS 战斗与角色状态](TGSCombat.md)，地图、感知和传送见 [TGS 地图、对象与事件](TGSWorld.md)。
