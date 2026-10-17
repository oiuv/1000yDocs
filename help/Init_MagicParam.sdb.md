# MagicParam.SDB

`Init/MagicParam.SDB` 为怪物特殊武功提供参数。`TMagicParamClass` 以 `ObjectName + MagicName`（中间没有分隔符）建立索引；怪物初始化时根据 `Monster.SDB.HaveMagic` 中的名称逐项查询。

| 字段 | 加载结果 |
| --- | --- |
| `Name` | SDB 行索引，不写入 `TMagicParamData` |
| `ObjectName` | 怪物对象名称 |
| `MagicName` | 用于查询 `Magic.SDB` 的武功名称 |
| `NameParam1..5` | `NameParam[0..4]` |
| `NumberParam1..5` | `NumberParam[0..4]` |

只有查询到的武功在 `Magic.SDB` 中属于 `MAGICTYPE_SPECIAL` 时，才按该武功的 `Function` 值登记到特殊武功槽。参数含义因此由 `Function` 决定，而不是由中文武功名直接决定。

## Function 参数

| 常量（值） | 名称参数 | 数值参数的实际用途 |
| --- | --- | --- |
| `MAGICSPECIAL_HIDE` (0) | 无 | 1=允许百分比下限，2=上限且作为冷却间隔，3>0 时启用冷却检查 |
| `MAGICSPECIAL_SAME` (1) | 无 | 1=百分比阈值，2=`HitData.ToHit`；每个对象只成功触发一次 |
| `MAGICSPECIAL_HEAL` (2) | 1..5=允许的名称列表 | 1=百分比阈值，2=`HitData.ToHit`，3=冷却间隔 |
| `MAGICSPECIAL_SWAP` (3) | 1=`SubData.SubName` | 1=百分比阈值，2=`SubData.Percent` |
| `MAGICSPECIAL_EAT` (4) | 1=必须持有并删除的物品名 | 1=百分比阈值，2=`HitData.ToHit`，3=冷却间隔 |
| `MAGICSPECIAL_KILL` (5) | — | 本类能识别是否持有，但没有读取参数的 `RunHaveKillMagic` 实现 |
| `MAGICSPECIAL_PICK` (6) | 1..5=可选名称过滤；第 1 项空则不过滤 | 1=百分比阈值 |
| `MAGICSPECIAL_BLOOD` (7) | 无 | 1=冷却，2=`SpellDamage`，3=范围，4=对方效果，5=自身效果 |
| `MAGICSPECIAL_CALL` (8) | 各项格式 `怪物名:数量` | 1=范围，2=0 时仅允许成功一次 |
| `MAGICSPECIAL_DEADBLOW` (9) | 无 | 1=功能种类，2=修炼值 |
| `MAGICSPECIAL_SHOW` (10) | 无 | 当前执行函数不读取数值参数 |

表中没有列出的参数，在对应执行函数中没有被读取。时间相关值均直接与 `mmAnsTick` 比较。

## 校验依据

- 表头：`tgs1000/bin/Init/MagicParam.SDB`
- 加载与索引：`tgs1000/svClass.pas` 的 `TMagicParamClass`
- 消费逻辑：`tgs1000/uMopSub.pas` 的 `TMopHaveMagicClass`
- 常量：`1000ydef/deftype.pas` 的 `MAGICSPECIAL_*`
