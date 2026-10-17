# Monster.SDB

`Init/Monster.SDB` 定义怪物模板，由 `TMonsterClass.LoadMonsterData` 加载。字段名称和行为以下列源码实际访问为准。

## 基本字段

| 字段组 | 加载结果 |
| --- | --- |
| `Name`、`ViewName`、`Kind` | 行主键、显示名和怪物类型 |
| `Animate`、`Shape`、`WalkSpeed`、`FirstDir` | 动画、外形、移动速度和初始方向 |
| `Damage`、`DamageHead`、`DamageArm`、`DamageLeg` | 攻击及部位伤害 |
| `Armor`、`Life`、`AttackSpeed`、`Avoid`、`Recovery`、`Accuracy`、`SpendLife`、`HitArmor` | 基础战斗数据，直接写入 `TMonsterData` 对应成员 |
| `SpellResistRate`、`ActionWidth`、`EscapeLife`、`ViewWidth`、`ArmorWHPercent` | 抗性、行动范围、逃跑阈值、视野和防具武功百分比成员 |
| `virtue`、`VirtueLevel`、`RegenInterval` | 浩然正气经验相关的值、等级及再生间隔；不是人物活力 |

`Kind` 使用 `MOP_KIND_NONE=0`、`AUTOCALL=1`、`AUTODIE=2`、`NEWSKILL=3`、`SEAL=4`。这些是源码常量名称；实际行为由创建出的怪物对象逻辑决定。

## 行为、攻击与效果

- 布尔/控制字段：`boSeller`、`boViewHuman`、`boAutoAttack`、`boGoodHeart`、`boHit`、`boNotBowHit`、`boIce`、`boControl`、`boRightRemove`、`boAttack`、`boBoss`、`boVassal`、`boChangeTarget`、`boRandom`、`boPK`，以及 `XControl`、`YControl`、`VassalCount`。
- 攻击字段：`AttackType`；`AttackMagic` 按 `武功名:修炼值` 拆分并调用 `MagicClass.GetMagicData`；`HaveMagic` 原样写入长度 64 的字符串成员。
- 音效字段：`SoundStart`、`SoundAttack`、`SoundDie`、`SoundNormal`、`SoundStructed`，均经 `StrToEffectData` 转换。
- 效果字段：`EffectStart`、`EffectStructed`、`EffectEnd`。
- 经验字段：`ExtraExp`、`ShortExp`、`LongExp`、`RiseShortExp`、`RiseLongExp`、`HandExp`、`BestShortExp`、`BestShortExp2`、`BestShortExp3`、`3HitExp`、`LimitSkill`。

## 掉落、持有与任务物品

| 字段 | 实际格式与上限 |
| --- | --- |
| `HaveItem` | 重复的 `物品名:每次数量:判定周期长度`，最多 10 组；各物品分别登记到 `RandomClass` |
| `FallItem` | 重复的 `物品名:每份数量:份数`，最多 5 组；触发后按份数重复发放 |
| `FallItemRandomCount` | `FallItem` 整组触发参数：0 关闭，1 必触发，正整数 N≥2 表示每次以 1/N 的概率触发 |
| `QuestNum` | 任务编号 |
| `QuestHaveItem` | 重复的 `物品名:数量:颜色`，最多 3 组 |

物品名使用 [Item.SDB](Init_item.sdb.md) 的 `Name` 主键，不是 `ViewName`。以下示例是字段填写示例，不代表任何特定怪物的实际奖励。

`HaveItem`、`FallItem` 解析到空名称、空数量、非正数量或缺失的第三项时，停止读取该字段后续所有条目。已填写的第三项若为非正数，则按 1 处理；这不适用于独立字段 `FallItemRandomCount`。取消某项掉落应删除完整的三元组，不要用数量 0 或第三项 0 代替。

### HaveItem：独立周期判定

格式为 `物品名:每次数量:N`。`N` 是判定周期长度，不是物品间的相对权重，也不是每次独立抽取的概率分母。

`TRandomClass` 按“对象配置名＋物品名”登记状态：周期长度 N、当前位置和本周期的命中位置。算法如下，位置从 0 开始：

```text
登记时：
    当前位置 = 0
    命中位置 = 随机整数 [0, N-1]

每次调用该项判定：
    本次命中 = (当前位置 == 命中位置)
    当前位置增加 1
    若已完成 N 次：
        当前位置 = 0
        重新随机选择下一周期的命中位置
    返回本次是否命中
```

命中后不会立即重置计数，必须走完当前周期。每个完整周期恰好命中一次，命中时生成配置数量的物品；在连续完整周期上，每次判定的平均生成数量是“配置数量 ÷ N”。

例如 `男子黄龙弓服:1:500`：第一周期随机选中第 127 次，第二周期选中第 386 次，则累计第 127、886 次判定分别生成一件。两次间隔并不固定；任意截取的连续 500 次可能跨越两个周期，不能保证其中恰好掉一件。

共享范围与计数口径：

- 同一个 TGS 进程内，以对象配置名和物品名匹配；不同玩家、地图及同名怪物实例不单独计数。不同配置名或不同 TGS 进程不共用这份计数。
- 正常死亡掉落、每次调用该物品判定一次时，可理解为所有玩家对该配置怪物的累计击杀数。未进入掉落流程、物品定义无效等情况不能按击杀数直接折算。
- 不命中也推进计数；是否被玩家拾取不影响这次判定。不是个人保底，更不是统计“已掉落次数”。
- 状态仅保存在内存，进程重启后重新登记、从 0 开始并随机选择命中位置；没有恢复旧计数的持久化逻辑。

多物品示例：

```text
HaveItem = 男子黄龙弓服:1:500:女子黄龙弓服:1:500
```

两种物品各自维护周期和命中位置。各完成 500 次判定时，分别命中一次；可以同次生成，也可以分开生成。整个列表在完整周期内合计生成两件，物品之间不分摊权重。

### FallItem：整组随机触发、多份发放

格式为 `物品名:每份数量:份数`。加载器将第三项存入 `rColor`，但此处它用作重复发放次数，不表示染色、权重或判定周期。

`FallItemRandomCount` 在每次进入这段掉落流程时只判定一次：

| 值 | 当前行为 |
| --- | --- |
| 0 | 不触发整组 `FallItem` |
| 1 | 每次触发整组 |
| N≥2 | 通过 `Random(N) = 1` 判定，单次触发概率 1/N |

这里只使用非负整数配置。该分支没有 `RandomClass` 周期计数：N 次判定可能一次都不触发，也可能触发多次。

触发后遍历所有有效条目，每项按“份数”重复生成，每份使用配置数量；普通物品通过地图管理器以随机落点发放，`ITEM_ATTRIBUTE_DIRECT` 物品走直接发送到目标的分支。某项物品定义无效时跳过该项，不会从其余项中择一替代。

例如下面的整组配置：

```text
FallItem = 男子黄龙弓服:1:1:女子黄龙弓服:1:1
FallItemRandomCount = 500
```

每次以 1/500 的概率触发，触发时生成男装、女装各一份，每份一件；不是累计 500 次必出。另如 `白酒一:5:3`，一次触发生成三份、每份五个，合计十五个。

### 配置与排查注意

| 对比项 | HaveItem | FallItem |
| --- | --- | --- |
| 第三项 | 判定周期长度；越大，长期产出越少 | 发放份数；越大，单次产出越多 |
| 多项关系 | 不同物品各自计数判定 | 整组触发，所有有效项一起发放 |
| 控制参数 | 每个条目的周期长度 | 独立字段 `FallItemRandomCount` |

- 两套机制可在同一次掉落流程中分别执行，不是二选一；`FallItemRandomCount=0` 不会关闭 `HaveItem`。同一物品写在两边可能重复产出。
- 不能原样互抄第三项：`HaveItem` 的 `男子黄龙弓服:1:500` 若照搬到 `FallItem`，会变成整组触发时发放 500 份男装。
- 同一对象名下不要重复登记相同物品来模拟独立奖池；`GetChance` 使用第一个匹配的登记项，没有按玩家或配置行隔离。
- `Random Chance Not Found` 表示对象与物品组合没有匹配登记。当前 `GetChance` 记录日志后仍返回默认的 `true`，不能把缺失登记当作禁止掉落。
- 上述数量描述的是生成/发放请求，实际落地、入包和拾取还受对应处理流程限制，不能仅凭拾取日志反推全部击杀或全部生成数量。
- SDB 的 `HaveItem` 被装入 `DropItemArr`。`DropItemGround` 内另有运行时 `HaveItemArr` 的 `Random(2)` 分支，不能把它误当成此配置项额外乘以 50%。

同一周期算法也用于 [NPC 的 HaveItem](Init_npc.sdb.md#haveitem-掉落配置)；动态对象的登记与调用区别见 [CreateDynamicObject](CreateDynamicObject.SDB.md#运行注意)。

## 人形外观

`MonType` 为 0 时，加载器在核心数据完成后跳过人形外观部分。非 0 时读取 `sex`、`Guild`、`GroupKey`，并处理 `arr_body`、`arr_gloves`、`arr_upunderwear`、`arr_shoes`、`arr_downunderwear`、`arr_upoverwear`、`arr_hair`、`arr_cap`、`arr_weapon`。外观项先按物品名查询 `Item.SDB`；除 `arr_upunderwear` 使用物品自身颜色外，其余项从后续 `:颜色` 读取。武器还会按物品 `HitType` 设置攻击动作。

## 当前未加载字段

表头中的 `boOnlyOnce`、`CallInterval`、`HideInterval` 没有被当前 `LoadMonsterData` 读取。不能仅凭字段名推断它们在本版本中生效。

## 校验依据

`Virtue`/`VirtueLevel` 经 `uMonster.pas:291-292` 写入怪物的 `VirtueValue`/`VirtueLevel`。战斗经验分支在 `uSkills.pas:714-739` 用人物浩然正气等级差修正奖励，并通过 `FM_ADDVIRTUEEXP` 交给 `UUser.pas:8746-8748` 的 `AttribClass.AddVirtue`。

- 配置表头：`tgs1000/bin/Init/Monster.SDB`
- 加载器：`tgs1000/svClass.pas` 的 `TMonsterClass.LoadMonsterData`
- 数据结构与常量：`1000ydef/deftype.pas` 的 `TMonsterData`、`MOP_KIND_*`
- 掉落参数加载与周期算法：[svClass.pas](TGS核心源码/svClass.pas) 的 `TMonsterClass.LoadMonsterData`、`TRandomClass.AddData/GetChance`、`TItemClass.GetCheckItemData`
- 参数传递与实际发放：[uMonster.pas](TGS核心源码/uMonster.pas)、[uMopSub.pas](TGS核心源码/uMopSub.pas) 的 `AddDropItem`、`AddFallItem`、`DropItemGround`；10/5 项上限由该单元常量和加载器共同限定
