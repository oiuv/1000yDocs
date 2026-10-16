# TGS 战斗与角色状态

本文说明公开 Pascal 源码中的战斗处理路径，连接协议入口、人物状态和配置表。数值以目标服务器实际配置为准；人物受击、怪物受击、近身、远程和掌法有不同分支，不能用一个“攻击减防御”公式代替全部规则。

## 1. 请求准入与攻击分派

游戏命令进入 `TUser.MessageProcess` 后，先受角色状态与交互窗口限制：

- 死亡状态正常放行 `CM_SAY`、`CM_WINDOWCONFIRM`、`CM_NETSTATE`、`CM_GETTIME`，不会继续执行普通移动、攻击或服药请求。格式正确的材料数量确认/取消另有收尾路径，只结束先前打开的材料数量窗，仍不允许转移物品。
- `CM_HIT` 要求没有特殊交互窗口、通过消息间隔检查、允许攻击且已有当前攻击武功。中国地区分支还要求服务端已有 `TargetID`，不能只靠攻击包中的目标字段推断已建立目标。
- `CM_HIT` 的 `50 tick` 消息间隔只是入口节流，不是人物实际攻击间隔。近身攻击还按 `HitedTick`、实际攻速和腿部活力计算能否出手；`AllowCommand` 另行检查僵直、死亡和 `boCanAttack`。

攻击分派如下：

```text
CM_HIT
  ├─ 已选特殊攻击 → CommandCriticalAttack
  ├─ 弓术/投法    → CommandBowing
  ├─ 掌风         → CommandWindOfHand_new
  └─ 其他近身攻击 → CommandHit
```

源码：[UUser.pas](TGS核心源码/UUser.pas) 的 `TUser.MessageProcess`、`TUserObject.AllowCommand`、`CommandHit`。报文结构另见 [通信协议](protocol.md)。

## 2. 施放与伤害结算

近身攻击在出手前调用 `THaveMagicClass.DecEventMagic`，资源条件不满足会返回失败。服务器组合当前武功、装备、附加属性及部位状态生成 `THitData`，通过 `FM_HIT` 交给场景中的受击对象处理；攻击请求不是客户端直接指定最终掉血量。

例如，`TLifeObject.CommandHited` 的普通怪物受击分支先做闪避判定，再计算伤害、防御与 `HitArmor` 修正、记录伤害贡献并扣除活力。人物受击则走 `TUserObject.CommandHited` 等对应方法，包含不同的保护和状态分支。调伤害时应同时核对攻击方数据生成和受击方计算。

掌法通过 `MagicStep` 分阶段施放，不是收到一次请求就直接完成全部效果：

- `ms_none` 检查目标、自身攻击限制、节奏及资源消耗，随后进入准备阶段。
- 后续阶段处理方向、动作与伤害数据。
- 元气消耗由最大元气及 [ConsumeEnergy.SDB](Init_ConsumeEnergy.sdb.md) 的系数计算。
- 降低当前境界时，伤害公式使用的元气折算量受 [PowerLevel.SDB](Init_PowerLevel.sdb.md) 的 `LimitEnergy` 限制；不是修改人物元气上限。
- 受击方护体功与掌法的相性由 [AM&WHRelation.SDB](Init_AM_WHRelation.sdb.md) 参与计算；相性值不是最终减伤百分比。

源码：[UUser.pas](TGS核心源码/UUser.pas) 的 `CommandHit`、`CommandWindOfHand_new`、`CommandAttackedMagic`；[uSkills.pas](TGS核心源码/uSkills.pas) 的 `TLifeObject.CommandHited`、`CommandBowed`；[uUserSub.pas](TGS核心源码/uUserSub.pas) 的 `DecEventMagic`。

## 3. 属性、武功维持与补给

### 属性与状态的职责

| 对象/结构 | 主要职责 |
| --- | --- |
| `TAttribClass` | 当前/最大活力、武功、外功、内功、元气，以及药效和属性更新 |
| `THaveMagicClass` | 已有武功、当前攻击/步法/心法/护体等选择、资源消耗及保持条件 |
| `TWearItemClass` | 装备对属性、外观的贡献 |
| `TUserObject` | 组合实际战斗数据，管理动作、受击、目标和死亡状态 |

字段中文以 [术语表](TERMINOLOGY.md) 为准。`Life` 是活力，`Energy` 是元气；`Magic` 既出现在武功数据结构中，也用于人物武功属性，需结合所在 record 判断。

### 保持武功不等于反复施放

`THaveMagicClass.Update` 对当前攻击武功、步法和护体按各自计时进行周期消耗及保持条件检查。普通 `boKeepingMagic` 比较当前内功、外功、武功和活力与 `rKeep*` 下限；绝世相关分支还通过 `boKeepingBestMagic` 检查元气。

`TUserObject.Update` 根据返回值处理状态：步法不足时恢复普通动作并清除步法；护体不足时清除护体；绝世护体元气不足时有切换关联武功的分支。`RET_CLOSE_ATTACK` 在该调用端没有清除攻击武功，因此不能概括成“任意属性不足都会取消所有武功”。选中攻击武功也不保证下一次攻击的资源检查会成功。

周期字段必须结合消费方法理解：`Dec5SecAttrib` 处理内功、外功、武功、活力，`Dec1SecAttribForBestSpecial` 对招式武功按一秒周期消耗元气百分比，不能把所有 `5*` 字段机械解释为每五秒固定扣点。

源码：[uUserSub.pas](TGS核心源码/uUserSub.pas) 的 `THaveMagicClass.Update`、`boKeepingMagic`、`boKeepingBestMagic`、`Dec5SecAttrib`、`Dec1SecAttribForBestSpecial`；[UUser.pas](TGS核心源码/UUser.pas) 的 `TUserObject.Update`。

### 药品恢复

角色共享三个药效槽。普通恢复药可并发，槽满时拒绝加入新药效；每轮药效处理增加执行次数，达到 `UseCount` 后释放槽。Type 2 临时属性药还受互斥和地图条件限制，不能把槽释放等同于属性加成到期。Type 0 活力恢复的溢出量转入 `CurShield`。

详细字段、整数计算、地图限制及药品实例见 [ItemDrug.SDB](Init_ItemDrug.sdb.md)；实现为 [uUserSub.pas](TGS核心源码/uUserSub.pas) 的 `TAttribClass.AddItemDrug`、`Update`。

## 4. 经验与奖励不是一条通用加值路径

| 类别 | 主要路径 | 核对重点 |
| --- | --- | --- |
| 攻击武功修炼 | 受击计算 → `FM_ADDATTACKEXP` → `THaveMagicClass.AddAttackExp` | 当前武功、怪物的分类型经验字段、`LimitSkill`、手臂活力等条件 |
| 护体修炼 | `FM_ADDPROTECTEXP` → `AddProtectExp` | 当前护体与受击来源；与攻击修炼分开 |
| 浩然正气 | 怪物死亡奖励计算 → `FM_ADDVIRTUEEXP` → `TAttribClass.AddVirtue` | 怪物 `Virtue/VirtueLevel`、人物等级差及奖励归属 |
| 真气/状态点相关经验 | `FM_ADDEXTRAEXP` → `AddExtraExp` 或队伍分配 | 独立累计与状态点限制，不应直接称为攻击武功经验 |

例如，`FM_ADDATTACKEXP` 会检查 `LimitSkill`，并在手臂活力计算比例不高于 50 时提示攻击力太弱，不能获得这次经验。怪物死亡奖励使用 `FindBestExpLink` 选择伤害贡献记录，不应假定所有死亡奖励都直接给最后出手者。

公开源码中 `UUser.pas` 的 `ExpMulti`、`VirtueMulti` 初值均为 1；它们分别在经验计算路径使用，不代表所有成长、脚本奖励和道具效果都统一乘这两个值。

公开副本的 `AddAttackExp` 还存在九转金丹缺陷：仅检查背包第 0 格物品名称，每次命中该条件都执行 `ExpMulti := ExpMulti * 2`，恢复倍率的语句被注释。这会反复改变进程级倍率，不是一次启用、限时生效的个人双倍经验；不能据此配置或承诺正常的道具奖励规则。这里记录的是公开副本保留的实现，不代表其他部署也采用这一行为。

源码：[uSkills.pas](TGS核心源码/uSkills.pas) 的受击、死亡奖励及 `FindBestExpLink`；[UUser.pas](TGS核心源码/UUser.pas) 的 `TUser.FieldProc` 和倍率变量；[uUserSub.pas](TGS核心源码/uUserSub.pas) 的 `AddPermitExp`、`AddAttackExp`、`AddProtectExp`、`AddVirtue`、`AddExtraExp`。怪物配置见 [Monster.SDB](Init_monster.sdb.md)。

## 5. 死亡、复活与重新登录

`CommandChangeCharState(wfs_die)` 设置死亡状态、清除当前目标和受击武功效果，并记录 `DiedTick`；普通命令随之受死亡准入限制。不能把模型外观、当前活力、攻击目标和允许操作混成同一个布尔状态。

默认计时下，死亡约 30 秒后进入复活处理：战场优先使用专门复活位置；其他地图在 `boPosDie=true` 时使用 `PosByDie.SDB`；否则尝试原地或附近可走格。地图脚本及其他特殊分支需另行核对，不能承诺所有死亡都回新手村。

重新登录是另一条位置初始化路径，`PosByDie.SDB` 在其中也可生效，而且不要求死亡、不检查 `boPosDie`。它与 `LoginX/LoginY`、`RegenInterval` 的优先级见 [PosByDie.SDB](Init_PosByDie.sdb.md)。

源码：[UUser.pas](TGS核心源码/UUser.pas) 的 `CommandChangeCharState`、`TUserObject.Update`、`TUserList.InitialLayer`；地图条件见 [Map.SDB](Init_map.sdb.md)。

## 6. 修改与排查顺序

1. 先确认角色、地图、当前武功及目标状态，区分“请求被拒绝”“已经出手但未命中”“命中但未获得经验”。
2. 检查 [Magic.SDB](Init_magic.sdb.md)、[game.ini](game.ini.md) 的加载转换，再读实际消费分支；SDB 原始数值不一定等于运行时属性。
3. 检查双方属性、距离/动作/资源条件及当前地图规则，不能只改攻击方数值。
4. 对恢复问题同时检查药效槽、执行次数、药品类型和地图开关；对位置问题分别检查死亡路径与登录路径。

本文给出主干路径和配置边界，不替代每一种绝世武功、特殊怪物、PK/门派战和脚本效果的独立规则核对。
