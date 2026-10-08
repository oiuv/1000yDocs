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
| `FallItem` | 重复的 `物品名:数量:随机值`，最多 5 组 |
| `FallItemRandomCount` | 写入怪物掉落随机计数成员 |
| `HaveItem` | 重复的 `物品名:数量:随机权重`，最多 10 组；权重交给 `RandomClass.AddData` |
| `QuestNum` | 任务编号 |
| `QuestHaveItem` | 重复的 `物品名:数量:颜色`，最多 3 组 |

解析遇到空名称、空数量或非正数量时会提前停止；随机值非正时按 1 处理。

## 人形外观

`MonType` 为 0 时，加载器在核心数据完成后跳过人形外观部分。非 0 时读取 `sex`、`Guild`、`GroupKey`，并处理 `arr_body`、`arr_gloves`、`arr_upunderwear`、`arr_shoes`、`arr_downunderwear`、`arr_upoverwear`、`arr_hair`、`arr_cap`、`arr_weapon`。外观项先按物品名查询 `Item.SDB`；除 `arr_upunderwear` 使用物品自身颜色外，其余项从后续 `:颜色` 读取。武器还会按物品 `HitType` 设置攻击动作。

## 当前未加载字段

表头中的 `boOnlyOnce`、`CallInterval`、`HideInterval` 没有被当前 `LoadMonsterData` 读取。不能仅凭字段名推断它们在本版本中生效。

## 校验依据

`Virtue`/`VirtueLevel` 经 `uMonster.pas:291-292` 写入怪物的 `VirtueValue`/`VirtueLevel`。战斗经验分支在 `uSkills.pas:714-739` 用人物浩然正气等级差修正奖励，并通过 `FM_ADDVIRTUEEXP` 交给 `UUser.pas:8746-8748` 的 `AttribClass.AddVirtue`。

- 配置表头：`gameserver-tgs1000/bin/Init/Monster.SDB`
- 加载器：`gameserver-tgs1000/svClass.pas` 的 `TMonsterClass.LoadMonsterData`
- 数据结构与常量：`1000ydef/deftype.pas` 的 `TMonsterData`、`MOP_KIND_*`
