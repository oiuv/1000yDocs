# 地图、视野与对象生命周期

TGS 不只是把坐标转发给客户端：它维护地图通行数据、对象位置、可见列表、怪物行为及刷新状态，再把结果转成客户端消息。本页按公开原版解释这些层次，地图参数详见 [MAP.SDB](Init_map.sdb.md)。

## 一张地图中的对象

`TManagerList.LoadFromFile` 为 `Init/MAP.SDB` 的每条地图记录创建 `TManager`，每个管理器拥有 `TMaper`、`TFieldPhone`，以及怪物、NPC、物品、动态物件、虚拟物件、矿点等列表。一个 TGS 进程可管理多张地图；地图 `ServerID` 不能直接理解为独立网络服务器。

主循环通过 `TManagerList.Update` 更新各地图，地图再更新对象列表。地图障碍由服务端 `SmpName` 指定的 `.smp` 提供；客户端 `.map/.til/.obj` 图形资源不代替服务端通行判断。`TMaper.isMoveable` 同时考虑地形与当前占位，`isMoveTile` 仅看地形，不能互换使用。

依据：[uManager.pas](TGS核心源码/uManager.pas) 的 `TManagerList.LoadFromFile/Update`、`TManager.Update`；[MapUnit.pas](TGS核心源码/MapUnit.pas) 的 `TMaper.isMoveable/isMoveTile`。文件格式见 [MapFiles](MapFiles.md)。

## 空间广播、视野与近身事件

玩家、怪物等派生对象在 `StartProcess` 注册空间位置并发送 `FM_CREATE`；移动时以 `FM_MOVE` 等消息更新周围关系；退出时注销并发送销毁消息。基类 `StartProcess/EndProcess` 负责注册状态标志、计时与列表等公共状态，不能把它们单独视为完整的注册/注销流程。空间消息用于找出附近候选对象，是否真正进入可见列表还由对象的范围判断决定，并不是整张地图无条件广播给每个玩家。

| 层次 | 条件与作用 |
| --- | --- |
| 可见范围 `isRange` | 公开原版横向半径 10、纵向半径 8，包含边界，即 21×17 格矩形。不是宽 10、高 8 |
| `ViewObjectList` | `FM_SHOW` 加入、`FM_HIDE` 移除，维护已进入视野的对象；被 `SendLocalMessage` 的局部广播/按 ID 查找等路径复用 |
| 移动与可见性 | `FM_MOVE` 比较新旧坐标的可见关系，必要时发送 SHOW/HIDE；普通移动消息不意味着每次都重新创建对象 |
| 近身范围 `isApproach` | 横、纵差均不超过 2 格，即 5×5 格；普通移动跨越该边界才产生 `FM_APPROACH/FM_AWAY` |
| 脚本接近/离开 | 上述消息到达已绑定回调的对象后才执行 `OnApproach/OnAway`，与客户端显示/隐藏不是同一事件 |

`TBasicObject.SendLocalMessage` 使用维护好的可见列表，另一些路径直接通过 `Phone.SendMessage` 处理空间消息；不能只看到一个“广播”调用就推断范围、接收者或客户端是否显示。玩家、怪物、NPC 共用基础对象的可见关系，怪物再叠加自己的感知条件。

依据：[BasicObj.pas](TGS核心源码/BasicObj.pas) 的 `TBasicObject.StartProcess/EndProcess/SendLocalMessage/isRange/isApproach/FieldProc`，以及 [uMonster.pas](TGS核心源码/uMonster.pas)、[UUser.pas](TGS核心源码/UUser.pas) 的派生 `StartProcess/EndProcess`；[基础常量](constants/BASICS.md)。脚本接口见 [OnApproach](../procedure/OnApproach.md)、[OnAway](../procedure/OnAway.md)。

## 怪物感知与 AI

怪物模板由 [Monster.SDB](Init_monster.sdb.md) 定义，地图上的实例由 [CreateMonster.SDB](CreateMonster.SDB.md) 定义。模板决定战斗与行为参数；刷新点决定在哪里、以多少个实例出现，二者不可混淆。

`TMonster.FieldProc` 从可见对象中筛选玩家，排除死亡/隐身等不合条件的对象，再以 `ViewWidth` 和距离挑选近处目标。`boViewHuman` 参与感知，`boAttack` 参与是否保留攻击目标；看到玩家并不代表必然立即攻击。

`TAttackSkill.ProcessNone` 决定空闲状态下一步工作：

- 活力高于 `EscapeLife` 时，`boAutoAttack=true` 才对近处目标安排主动攻击，仇恨目标另有攻击分支；低于或等于该阈值时可进入逃跑分支。`EscapeLife` 是直接与当前活力比较的数值，不是百分比。
- 没有进入攻击/逃跑分支时，按 `ActionWidth`、出生点或跟随对象安排随机行走；不是整个可见矩形内任意巡逻。
- 特殊 `boPK` 怪物可通过地图玩家列表安排追击任务，不应把这条路径等同于普通近距离索敌。
- `ProcessNone` 只负责选择/排队；攻击、追击、逃跑和移动各有状态与更新逻辑。配置 `AttackSpeed` 或移动速度不会取消其它调度条件。

`RegenWidth` 和 `ActionWidth` 也不是同一个半径：`Regen` 在出生点附近以 `CreatedX/Y-RegenWidth+Random(2*RegenWidth)` 尝试落点（最多 10 次）；普通随机行走使用 `ActionWidth div 2` 及 `Random(ActionWidth)`。落点还必须通过地图通行/占位检查，不能保证配置范围内每个位置都能生成。

依据：[uMonster.pas](TGS核心源码/uMonster.pas) 的 `TMonster.FieldProc/SetAttackSkillData/Start/Regen/Update`；[uSkills.pas](TGS核心源码/uSkills.pas) 的 `TAttackSkill.ProcessNone`。

## 尸体消失与重生

怪物死亡、尸体退出、重新生成是不同阶段，模板的 `RegenInterval` 不是从受致命伤那一刻统一倒计时。

| 普通路径 | 当前实现 |
| --- | --- |
| 非整体刷新地图（地图 `RegenInterval=0`） | 死亡超过 1600 tick（正常倍率约 16 秒）后，允许重生的普通怪物调用 `EndProcess` 退出场景 |
| 退出状态 `los_exit` | 模板 `RegenInterval>0` 时，从 `RemovedTick` 再等待该间隔；等于 0 时直接尝试 `Regen`，负值没有自动重生分支 |
| 重新放置 | 正间隔到期后，`ActionWidth=0` 使用 `Start`，否则使用 `Regen`；找不到可用落点时本次失败，不能宣称固定时刻一定出现 |
| 整体刷新地图（地图 `RegenInterval>0`） | 普通尸体超过 800 tick（约 8 秒）后标记删除，等待地图重载重新创建，不走单体重生计时 |

上表不是全部怪物的硬性尸体时间：变身武功、受控/立即移除、召唤/归属对象、禁止重生实例都有优先或删除分支。默认 tick 为约 10 ms；实际执行受更新轮次影响，不能把这些阈值当作精确墙钟保证。

依据：[uMonster.pas](TGS核心源码/uMonster.pas) 的 `TMonster.Update`（`los_die/los_exit`）、`Start/Regen/EndProcess`；[uSkills.pas](TGS核心源码/uSkills.pas) 的 `TLifeObject.EndProcess`；[BasicObj.pas](TGS核心源码/BasicObj.pas) 的 `TBasicObject.EndProcess`。

## 地图整体刷新与脚本

地图 `RegenInterval>0` 到期时，`TManager.Regen` 按顺序执行：

1. 重置刷新计时；若配置了子地图列表，转出相关子地图玩家。
2. 本地图在 Target 坐标均大于 0 且未设置母地图时转出玩家。
3. 重载动态物件、怪物、NPC、虚拟物件和矿点，清空地面物品，再重新开放进入状态。

因此地图刷新不只是“让怪物复活”，也会影响玩家位置、地面掉落与对象脚本生命周期。`boItemDrop` 只控制玩家拖弃物品，不能用于关闭怪物掉落或阻止刷新清场。

地图 `OnTimer` 正常约每 6000 tick 调用一次，参数为空；普通对象 `OnTimer` 约每 100 tick 调用并传时、分、秒。`Attribute=6` 还会在地图剩余 30 秒条件满足时调用 `OnEventTimer`，没有独立的一次性触发锁。脚本发奖、刷怪等操作需要自己防止重复。

脚本 `checkitemregen` 按整张地图的同名地面对象计数，按包含上界的循环尝试生成；不是物品堆叠总数量，也没有独立刷新间隔参数。详见 [checkitemregen](../print/物品交易命令/checkitemregen.md)。

依据：[uManager.pas](TGS核心源码/uManager.pas) 的 `TManager.Update/Regen/CheckItemRegen`；[BasicObj.pas](TGS核心源码/BasicObj.pas) 的 `TBasicObject.Update`、`TItemList.AddItemSpecial`。

## 配置维护边界

- 地图资源、模板、实例表和脚本各有独立加载路径，修改一个表不代表其它对象自动同步；参见 [运行资源加载](RuntimeResources.md)。
- 传送门需要同时核对目标地图、坐标、年龄、物品及任务条件。部分物品先扣除、后检查任务，不提供失败自动返还；机制选择见 [地图传送机制总览](Teleportation.md)，字段与顺序见 [CreateGate.SDB](CreateGate.SDB.md)、[CreateGateEx.SDB](CreateGateEx.SDB.md)。
- 调整可见范围会影响共用的可见列表和局部消息处理，不能仅按客户端画布大小评估；怪物自己的 `ViewWidth`、攻击判断与通行限制仍然独立存在。
