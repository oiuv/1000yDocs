# ItemDrug.sdb

药品数据配置文件，定义游戏中各种药品的服用效果，包括恢复属性、加成效果及持续时间等。

## 文件路径

```
.\Init\ItemDrug.SDB
```

## 文件格式

CSV 格式，逗号分隔，首行为列名。

## 字段说明

| 列名 | 类型 | 说明 | 源码依据 |
|------|------|------|----------|
| Name | String | 药品名称（主键） | `StrPCopy (@pd^.rName, DB.GetFieldValueString (iName, 'Name'))` |
| Type | Integer | 药品类型。0=固定值恢复，1=按属性上限百分比恢复，2=有持续时间的临时属性加成 | `pd^.rType := DB.GetFieldValueInteger (iName, 'Type')` |
| UseInterval | Integer | 使用间隔（单位：10ms tick，即值 100 = 1 秒）。源码中已加载但服务端未实际使用此字段做时间判定 | `pd^.rUseInterval := DB.GetFieldValueInteger (iName, 'UseInterval')` |
| UseCount | Integer | 效果执行次数。服务端每秒执行一次 Type 0/1/2 分支并增加 `rUsedCount`，达到此值后清空药品效果槽 | `pd^.rUseCount := DB.GetFieldValueInteger (iName, 'UseCount')` |
| StillInterval | Integer | 药效持续时间（单位：10ms tick，即值 120000 = 20 分钟），仅 Type=2 的药品使用。药效到期判定：`CurTick >= DrugUseTick + DrugInterval` | `pd^.rStillInterval := DB.GetFieldValueInteger (iName, 'StillInterval')` |
| eEnergy | Integer | 元气效果值。Type 0 加载时应用下方倍率并用于恢复；Type 1/2 虽读取原值，但对应效果分支不使用元气字段 | `TItemDrugClass.ReLoadFromFile`、`TAttribClass.Update` |
| eInPower | Integer | 内功增加量 | `pd^.rEventInPower := Db.GetFieldValueinteger (iName, 'eInPower') * ITEMDRUG_MUL_EVENTINPOWER div ITEMDRUG_DIV_VALUE` |
| eOutPower | Integer | 外功效果值；Type 1 的实际计算见下文 | `pd^.rEventOutPower := Db.GetFieldValueinteger (iName, 'eOutPower') * ITEMDRUG_MUL_EVENTOUTPOWER div ITEMDRUG_DIV_VALUE` |
| eMagic | Integer | 武功效果值 | `pd^.rEventMagic := Db.GetFieldValueinteger (iName, 'eMagic') * ITEMDRUG_MUL_EVENTMAGIC div ITEMDRUG_DIV_VALUE` |
| eLife | Integer | 活力增加量 | `pd^.rEventLife := Db.GetFieldValueinteger (iName, 'eLife') * ITEMDRUG_MUL_EVENTLIFE div ITEMDRUG_DIV_VALUE` |
| eHeadLife | Integer | 头部活力增加量 | `pd^.rEventHeadLife := Db.GetFieldValueinteger (iName, 'eHeadLife') * ITEMDRUG_MUL_EVENTHEADLIFE div ITEMDRUG_DIV_VALUE` |
| eArmLife | Integer | 手臂活力增加量 | `pd^.rEventArmLife := Db.GetFieldValueinteger (iName, 'eArmLife') * ITEMDRUG_MUL_EVENTARMLIFE div ITEMDRUG_DIV_VALUE` |
| eLegLife | Integer | 腿部活力增加量 | `pd^.rEventLegLife := Db.GetFieldValueinteger (iName, 'eLegLife') * ITEMDRUG_MUL_EVENTLEGLIFE div ITEMDRUG_DIV_VALUE` |
| DamageBody | Integer | 身体攻击力加成 | `pd^.rDamageBody := Db.GetFieldValueinteger (iName, 'DamageBody')` |
| DamageHead | Integer | 头部攻击力加成 | `pd^.rDamageHead := Db.GetFieldValueinteger (iName, 'DamageHead')` |
| DamageArm | Integer | 手臂攻击力加成 | `pd^.rDamageArm := Db.GetFieldValueinteger (iName, 'DamageArm')` |
| DamageLeg | Integer | 腿部攻击力加成 | `pd^.rDamageLeg := Db.GetFieldValueinteger (iName, 'DamageLeg')` |
| ArmorBody | Integer | 身体防御力加成 | `pd^.rArmorBody := Db.GetFieldValueinteger (iName, 'ArmorBody')` |
| ArmorHead | Integer | 头部防御力加成 | `pd^.rArmorHead := Db.GetFieldValueinteger (iName, 'ArmorHead')` |
| ArmorArm | Integer | 手臂防御力加成 | `pd^.rArmorArm := Db.GetFieldValueinteger (iName, 'ArmorArm')` |
| ArmorLeg | Integer | 腿部防御力加成 | `pd^.rArmorLeg := Db.GetFieldValueinteger (iName, 'ArmorLeg')` |
| AttackSpeed | Integer | 攻击速度加成 | `pd^.rAttackSpeed := Db.GetFieldValueinteger (iName, 'AttackSpeed')` |
| Avoid | Integer | 闪避加成 | `pd^.rAvoid := Db.GetFieldValueinteger (iName, 'Avoid')` |
| Recovery | Integer | 恢复力加成 | `pd^.rRecovery := Db.GetFieldValueinteger (iName, 'Recovery')` |
| Accuracy | Integer | 命中加成 | `pd^.rAccuracy := Db.GetFieldValueinteger (iName, 'Accuracy')` |
| KeepRecovery | Integer | 维持恢复加成 | `pd^.rKeepRecovery := Db.GetFieldValueinteger (iName, 'KeepRecovery')` |
| LightDark | Integer | 加载到 `rLightDark`；当前工程除加载和结构定义外没有读取该成员的代码，不能据此认定有运行时效果 | `pd^.rLightDark := Db.GetFieldValueinteger (iName, 'LightDark')` |

### 药品类型说明

- **Type 0**（固定值恢复）：每轮把加载后的效果值加到当前属性，并按上限截断。活力超过上限的部分会转入 `CurShield`（护体罡气），不是直接丢弃。加载时会应用下方倍率，其中活力及部位活力倍率为 `15/10`。
- **Type 1**（百分比恢复）：每轮按属性**上限**计算恢复量，公式为 `(属性上限 × 效果值 div 100) div UseCount`，每步均为整数除法。处理内功、外功、武功、活力及部位活力，不处理元气。源码的外功计算实际沿用了 `InPower` 和 `eInPower`；不能据此承诺恢复外功上限的指定百分比。
- **Type 2**（临时属性加成）：把内功、外功、武功、活力及攻防等字段写入临时加成结构，不增加元气。每次执行时重设 `DrugUseTick` 和 `DrugInterval`；最后一次执行后经过 `StillInterval` 清除加成。时间单位为 10ms tick，例如 120000 为 20 分钟。

所有类型的效果槽在 `CurTick > CheckDrugTick + 100` 时统一处理一轮，默认 tick 下约为 1 秒；`UseCount` 控制处理次数，不表示物品可被玩家重复服用的次数。恢复期间达到属性上限，也不会提前释放药效槽。

### 并发、互斥与地图限制

- `DRUGARR_SIZE=3`：角色共有三个药效槽，不是每种属性各三个。Type 0/1 可以同时占用多个空槽，每轮各自生效；三个槽都占用时，新的药效加入失败。
- 每轮执行后增加 `rUsedCount`，达到 `UseCount` 才清空对应槽。比如 `UseCount=10` 通常需十轮药效处理；实际释放时间还取决于服药时与统一更新周期的相位，不能由 `UseInterval` 推算。
- Type 2 在已有临时属性加成 `boDrugAttrib=true`，或已有待执行的 Type 2 药效时，拒绝再加入另一份 Type 2。临时加成持续时间与药效槽占用时间是两回事：槽可已释放，加成仍未到期。
- 地图 `boUseChemistDrug=false` 时，属性更新会清除现有 Type 2 临时加成；Type 0/1 恢复不属于这个清理分支。地图条件另见 [Map.SDB](Init_map.sdb.md)。

这些限制由 `TAttribClass.AddItemDrug` 和 `Update` 执行。请求使用物品与成功加入药效不是同一件事。

### 常量定义

```pascal
ITEMDRUG_DIV_VALUE         = 10;
ITEMDRUG_MUL_EVENTENERGY   = 10;
ITEMDRUG_MUL_EVENTINPOWER  = 10;
ITEMDRUG_MUL_EVENTOUTPOWER = 10;
ITEMDRUG_MUL_EVENTMAGIC    = 10;
ITEMDRUG_MUL_EVENTLIFE     = 15;
ITEMDRUG_MUL_EVENTHEADLIFE = 15;
ITEMDRUG_MUL_EVENTARMLIFE  = 15;
ITEMDRUG_MUL_EVENTLEGLIFE  = 15;
```

## 数据示例

| Name | Type | 说明 |
|------|------|------|
| 汤药 | 0 | `eEnergy` 为空；每轮内功恢复 100，另有外功、武功及活力等恢复 |
| 仙豆一 | 0 | `eLife=200`，Type 0 倍率后每轮恢复活力 300；另有内外功等恢复 |
| 承气汤 | 0 | 大量恢复元气（eEnergy=700） |
| 青盐精 | 1 | `UseCount=3`，内功、外功、武功字段为 50，其余恢复字段为空；外功沿用内功算法，整数除法可能使三轮总量略低于 50% |
| 阴阳丹 | 2 | 持续型药品，StillInterval=120000（20 分钟） |
| 千年山参 | 2 | `StillInterval=180000`（30 分钟）；身体及部位攻防、闪避、准确字段为 50，不是全部属性增加 |

## 相关源码

- [svClass.pas](TGS核心源码/svClass.pas) — `TItemDrugClass.ReLoadFromFile`、`GetItemDrugData`；字段表中的倍率表达式仅用于 Type 0，其他类型直接加载原值。
- [uUserSub.pas](TGS核心源码/uUserSub.pas) — `DRUGARR_SIZE`、`TAttribClass.AddItemDrug`、`TAttribClass.Update`。
- [deftype.pas](deftype.pas) — `TItemDrugData` 记录与药品类型常量；加载倍率在 [svClass.pas](TGS核心源码/svClass.pas) 的 `ITEMDRUG_MUL_*`、`ITEMDRUG_DIV_VALUE` 中定义。
- [药材原始资料](<炎黄新章游戏资料/新手入门/【物品】简介/【物品】简介：药材.txt>) — 汤药等药品的原始字段值；实际效果还需应用加载倍率和运行分支。
