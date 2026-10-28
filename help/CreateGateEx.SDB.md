# CreateGateEx.SDB

`Setting/CreateGateEx.SDB` 由 `TGateListEx.LoadFromFile` 加载，用于创建扩展传送门。它与 `CreateGate.sdb` 的表头和加载器不同，不应混用字段。

本表的随机功能是每次进入时选择**目的地**，不是让入口在地图上随机换点，也不保证同队玩家落在一起。机制选择见 [地图传送机制总览](Teleportation.md)，入口轮换见 [普通门的随机入口位置](CreateGate.SDB.md#随机入口位置)。

## 字段

| 字段 | 实际加载行为 |
| --- | --- |
| `Name` | SDB 行索引；对象内部名称实际取 `GateName` |
| `GateName`、`ViewName`、`Kind`、`Shape` | 对象名称、显示名、门类型和形状 |
| `MapId`、`X`、`Y` | 所在地图与坐标 |
| `TX`、`TY` | 对象的目标坐标成员 |
| `EX`、`EY` | 不能进入或门未激活时的弹出坐标 |
| `TargetServerID0..4`、`TargetX0..4`、`TargetY0..4` | 最多 5 组目标地图及坐标 |
| `boRandom`、`RandomCount`、`RandomTotal` | 随机目标开关、候选池长度、循环使用的目标配置总数；详见下文 |
| `boCondition`、`Condition` | 条件分流开关及条件字符串；当前处理代码按冒号拆分后用剩余部分与玩家年龄比较，在目标 0、1 间选择 |
| `Width` | 触发区域宽度参数 |
| `NeedAge`、`AgeNeedItem` | `NeedAge>0` 时的年龄门槛。年龄达到 `NeedAge` 直接通过此项；不足时须达到 `AgeNeedItem>0` 且通过全部有效 `NeedItem` 检查，随后扣物品 |
| `NeedItem` | 重复的 `物品名:数量`，最多 5 组 |
| `Quest`、`QuestNOtice` | 任务检查编号和失败提示。表头拼写为 `QuestNOtice`，加载器按 `QuestNotice` 查询 |
| `RegenInterval`、`ActiveInterval` | 重新激活与保持激活的 tick 间隔 |
| `EjectNotice` | 年龄/替代物品条件失败时的提示；为空时使用内置提示。门未激活及任务失败各有独立提示分支 |

## 目标选择

- `boRandom=true` 时，`RandomCount` 是候选池长度，不是每次进门抽取的次数。池第 0 项只放一次目标 0；其余项循环填入目标 `1..RandomTotal-1`。玩家进入时只执行一次 `Random(RandomCount)` 选择池下标。
- 例如 `RandomCount=5`、`RandomTotal=3`，候选池为 `[目标0, 目标1, 目标2, 目标1, 目标2]`，三个目标的概率分别为 1/5、2/5、2/5。
- `TargetData` 固定为下标 `0..11`，随机模式使用 `1..12` 的池长度；`RandomCount` 为 0、负数或超过 12 时，加载器记录日志并跳过该传送门，不创建残缺候选池。当池长度大于 1 时，`RandomTotal` 应为 `2..5`，且涉及的目标字段必须完整。
- `boRandom=false` 时仍会读取全部 5 组目标。
- 当前 `GATE_KIND_NORMAL` 处理代码分别执行随机分支和条件分支；若两个开关同时为真，二者不会互斥。配置时应避免无意同时启用。
- 普通扩展门的上述传送分支依赖这两个开关；都为假时，不会仅凭 `TX/TY` 自动执行一次普通传送。固定入口和固定目的地优先使用普通 `CreateGate.sdb`。

## 物品与拒绝条件

- 门未激活时先弹回，不进入物品检查。
- `NeedAge>0` 且年龄不足、达到 `AgeNeedItem>0` 时，按配置数量检查有效的 `NeedItem`，全部通过后立即逐项删除；扩展门没有普通门的 `boRemainItem` 保留开关。配置中不存在的物品名会被跳过，应使用有效名称和正数量。
- 达到 `NeedAge` 的玩家不需要这些物品；`NeedAge=0` 时也不会单独检查 `NeedItem`。不能照搬普通门“只填 NeedItem”的用法。
- `Quest` 检查在上述扣除之后。任务失败会弹回并显示 `QuestNotice` 与检查结果，已扣物品不会自动返还；这里不是事务式扣除。
- 条件分流将 `Condition` 按冒号拆开，用剩余文本转整数后比较年龄：阈值大于玩家年龄选目标 0，否则选目标 1。必须提供可转为整数的阈值，不能把它当作通用脚本表达式。

## 校验依据

- [BasicObj.pas](TGS核心源码/BasicObj.pas)：`TGateListEx.LoadFromFile`、`TGateObjectEx.FieldProc`。
- [deftype.pas](TGS核心源码/deftype.pas)：`TCreateGateDataEx.TargetData`。
- 普通门的独立规则见 [CreateGate.SDB](CreateGate.SDB.md)。
