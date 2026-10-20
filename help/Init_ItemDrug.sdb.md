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
| AttackSpeed | Integer | 加载并复制到临时结构，但 `SetDrugEffect` 未应用此项，不能配置出攻击加速效果 | `TAttribClass.Update/SetDrugEffect` |
| Avoid | Integer | 闪避加成 | `pd^.rAvoid := Db.GetFieldValueinteger (iName, 'Avoid')` |
| Recovery | Integer | Type 2 缩短受击恢复延迟的百分比；15 表示延迟减少 15%，不是恢复活力。结果下限为 0 | `TAttribClass.SetDrugEffect` |
| Accuracy | Integer | 命中加成 | `pd^.rAccuracy := Db.GetFieldValueinteger (iName, 'Accuracy')` |
| KeepRecovery | Integer | 维持恢复加成 | `pd^.rKeepRecovery := Db.GetFieldValueinteger (iName, 'KeepRecovery')` |
| LightDark | Integer | 加载到 `rLightDark`；当前工程除加载和结构定义外没有读取该成员的代码，不能据此认定有运行时效果 | `pd^.rLightDark := Db.GetFieldValueinteger (iName, 'LightDark')` |

### 药品类型说明

- **Type 0**（固定值恢复）：每轮把加载后的效果值加到当前属性，并按上限截断。活力超过上限的部分会转入 `CurShield`（护体罡气），不是直接丢弃。加载时会应用下方倍率，其中活力及部位活力倍率为 `15/10`。
- **Type 1**（百分比恢复）：每轮按属性**上限**计算恢复量，公式为 `(属性上限 × 效果值 div 100) div UseCount`，每步均为整数除法。内功、外功、武功、活力及部位活力分别使用自己的上限和效果值，不处理元气。例如外功使用 `OutPower` 和 `eOutPower`，不是内功上限。
- **Type 2**（临时属性加成）：把内功、外功、武功、活力及攻防等字段写入临时加成结构，不增加元气，也不应用头、臂、腿的活力恢复字段。内外武功和活力效果作用于属性上限，不是立即补满当前值；活力百分比只乘基础上限，不乘背包护符另加的活力。每次执行时重设 `DrugUseTick` 和 `DrugInterval`；最后一次执行后经过 `StillInterval` 清除加成。时间单位为 10ms tick，例如 120000 为 20 分钟。

所有类型的效果槽在 `CurTick > CheckDrugTick + 100` 时统一处理一轮，默认 tick 下约为 1 秒；`UseCount` 控制处理次数，不表示物品可被玩家重复服用的次数。恢复期间达到属性上限，也不会提前释放药效槽。

### 并发、互斥与地图限制

- `DRUGARR_SIZE=3`：角色共有三个药效槽，不是每种属性各三个。Type 0/1 可以同时占用多个空槽，每轮各自生效；三个槽都占用时，新的药效加入失败。
- 每轮执行后增加 `rUsedCount`，达到 `UseCount` 才清空对应槽。比如 `UseCount=10` 通常需十轮药效处理；实际释放时间还取决于服药时与统一更新周期的相位，不能由 `UseInterval` 推算。
- Type 2 在已有临时属性加成 `boDrugAttrib=true`，或已有待执行的 Type 2 药效时，拒绝再加入另一份 Type 2。临时加成持续时间与药效槽占用时间是两回事：槽可已释放，加成仍未到期。
- 地图 `boUseChemistDrug=false` 时，属性更新会清除现有 Type 2 临时加成；Type 0/1 恢复不属于这个清理分支。地图条件另见 [Map.SDB](Init_map.sdb.md)。
- 物品使用入口还检查地图 `boUseDrug`；`SpecialKind=6` 的职业药品受 `boUseChemistDrug` 限制。这些入口限制与 Type 2 加成清理分开理解，不因 Type 1 是恢复药就绕过职业药限制。

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
| 青盐精 | 1 | `UseCount=3`，内功、外功、武功字段为 50，其余恢复字段为空；分别恢复各自上限的 50%，整数除法可能使三轮总量略低于 50% |
| 阴阳丹 | 2 | 内功、外功、武功上限提高 50%，持续 20 分钟；不增加活力上限，也不改变阴阳值 |
| 千年山参 | 2 | `StillInterval=180000`（30 分钟）；身体及部位攻防、闪避、准确字段为 50，不是全部属性增加 |
| 凝神丸 | 2 | `Recovery=15`，受击恢复延迟缩短 15%，持续 15 分钟；不增加活力恢复速度 |
| 金刚丹 | 2 | 身体及部位防御、躲闪提高 30%，持续 20 分钟；不增加攻击、反弹伤害或免疫攻击 |

### 可食用小补给与调息药配置

下面是物品表配套的普通药品配置，均为 `Kind=13`，按 `Name` 与药效表关联，不需要新增客户端功能。数值是**服务器内部值**；Type 0 的活力已计入加载倍率，不能把表格数字直接当作界面显示点数。

| 名称 | 配置与实际恢复 | 获取与定位 |
|---|---|---|
| 糖果 | `Type=0, UseCount=3, eLife=200`；每轮活力 +300，三轮合计 900，不补内外武功 | 老板娘出售；`Price=100`，短时小补给，释放槽位较快 |
| 比比路 | `Type=0, UseCount=5, eInPower=200, eOutPower=200`；内外功每轮各 +200，五轮各合计 1000 | 老板娘出售；`Price=500`，双属性补给，不补活力 |
| 中和汤 | `Type=2, UseCount=1, StillInterval=60000`；内功、外功、武功上限提高 30%，基础活力上限提高 20%，持续 10 分钟 | 炼丹师制造，`Grade=6`、沙参 50 + 鹿茸一 10；`Price=10000, BuyPrice=5000` |

糖果、比比路保留物品表原有定价，`BuyPrice` 留空，加载时沿用 `Price`；NPC 是否收购另由交易清单决定。两者提供不同的用药节奏，不作为同效低价替代品：生药售价 20、十轮共恢复活力 1500，并附带其它属性恢复；仙豆一售价 50、十轮共恢复活力 3000。糖果虽然每轮活力恢复与仙豆一相同，但总量较少、售价更高，优势只是短时补给与较快释放槽位。汤药、丸药各售价 10，比比路同时补内外功的便利需以更高价格换取，不降低基础药的经济价值。

糖果、比比路分别占用药效槽三轮、五轮，通常约为 3/5 秒，并非双击后立即恢复全部；Type 0 活力溢出仍走原有罡气规则。中和汤首轮建立临时加成后释放药效槽，加成持续十分钟；不能和阴阳丹、金玉水等其它 Type 2 增益药叠加，也不能重复服用刷新时间。它不直接恢复活力或三功，不增加头臂腿活力上限，不改变阴阳值、年龄或元气。

中和汤的定位是中档综合增益：阴阳丹（Grade 8）提供更强、更持久的三功上限加成；金玉水（Grade 7）提供更强的单项活力上限加成（30%，10 分钟）；保身精（Grade 5）直接增加身体攻击力（30%，10 分钟）。中和汤兼顾三功与活力，不取代这些专门药品，也不提供攻防加成或经验倍率。

配方价值应连同职业门槛核对：中和汤材料按表内 `Price` 合计为 6000，成品价为 10000，不能把成品价当作玩家市场成交价。`JobGrade.sdb` 中熟练工才能制造 Grade 6，制造仍有失败损耗；配方数量不是批量产出数量。职业、配方、成功率路径见 [制造配方](manufacture.md)、[uUserSub.pas](TGS核心源码/uUserSub.pas) 的 `ConfirmMakeItem/MakeItemByRate`。

## 相关源码

- [svClass.pas](TGS核心源码/svClass.pas) — `TItemDrugClass.ReLoadFromFile`、`GetItemDrugData`；字段表中的倍率表达式仅用于 Type 0，其他类型直接加载原值。
- [uUserSub.pas](TGS核心源码/uUserSub.pas) — `DRUGARR_SIZE`、`TAttribClass.AddItemDrug`、`TAttribClass.Update`。
- [deftype.pas](deftype.pas) — `TItemDrugData` 记录与药品类型常量；加载倍率在 [svClass.pas](TGS核心源码/svClass.pas) 的 `ITEMDRUG_MUL_*`、`ITEMDRUG_DIV_VALUE` 中定义。
- [药材原始资料](<炎黄新章游戏资料/新手入门/【物品】简介/【物品】简介：药材.md>) — 汤药等药品的原始字段值；实际效果还需应用加载倍率和运行分支。
