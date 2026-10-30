# 物品属性常量 (ITEM_ATTRIBUTE_*)

> 源码: [deftype.pas](../deftype.pas) 第 174-191 行（`ITEM_ATTRIBUTE_*`）

定义物品的属性和特殊功能标记，对应 `Init/Item.sdb` 中的 `Attribute` 字段。并非所有取值都是元素属性；英文常量名保留源码声明，物品中文名称以随包表中的 `Name`、`ViewName` 为准。

---

## 通用属性与功能标记

| 常量名 | 值 | 中文说明 | 详细说明 |
|--------|---:|----------|----------|
| `ITEM_ATTRIBUTE_NONE` | 0 | 无属性 | 未设置本字段的属性标记 |
| `ITEM_ATTRIBUTE_FIRE` | 1 | 火属性 | 火的性质物品 |
| `ITEM_ATTRIBUTE_WATER` | 2 | 水属性 | 水的性质物品 |
| `ITEM_ATTRIBUTE_ICE` | 3 | 冰属性 | 冰冷的性质物品 |
| `ITEM_ATTRIBUTE_FILL` | 4 | 恢复属性 | 恢复活力、内功、外功、武功的物品 |
| `ITEM_ATTRIBUTE_SET` | 5 | 套装属性 | 套装物品标记 |
| `ITEM_ATTRIBUTE_DIRECT` | 6 | 直接获取 | 直接进入物品栏（不掉落地面） |
| `ITEM_ATTRIBUTE_PAPERBESTPROTECT` | 7 | 招式全集标记 | 随包物品“招式全集”使用此值；物品说明窗口显示“废弃”按钮 |
| `ITEM_ATTRIBUTE_PAPERBESTSPECIAL` | 8 | 四大神功全集标记 | 随包物品“四大神功全集”使用此值；物品说明窗口显示“废弃”按钮 |
| `ITEM_ATTRIBUTE_QUESTSIGN` | 9 | 任务标记 | 任务相关标记 |

### 全集类物品的名称与用途

随包 `Init/Item.sdb` 中，两项物品的 `Name` 与 `ViewName` 一致：

| 正式物品名 | Kind | Attribute | Script | 表中说明 |
|---|---:|---:|---:|---|
| 招式全集 | 4 | 7 | 未设置 | 只要身上有就能获得招式牌 |
| 四大神功全集 | 56 | 8 | 103 | 记载着四大神功相关讯息 |

`Attribute=7/8` 用于区别物品说明窗口的“废弃”操作，不是武功分类。`THaveItemClass.SelectItemWindow` 分别发送按钮键 `0/1`；`TUser.MessageProcess` 的 `CM_ITEMBUTTON` 分支据此按属性类型删除物品。双击“四大神功全集”调用脚本，则由 `Kind=56` 与 `Script=103` 决定，`Script/Script.SDB` 将该编号映射到 `四大神功全集.txt`。

源码依据：[uUserSub.pas](../TGS核心源码/uUserSub.pas) 的 `SelectItemWindow`、`DblClickProcess`；[UUser.pas](../TGS核心源码/UUser.pas) 的 `CM_ITEMBUTTON` 分支。不要根据 `PAPERBESTPROTECT`、`PAPERBESTSPECIAL` 的英文词面或旧注释另译物品名称。

## 特殊属性

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `ITEM_ATTRIBUTE_TAEGUK` | 199 | 太极属性 |
| `ITEM_ATTRIBUTE_LOWEST` | 201 | 低级属性材料，如疾风灵符、黑马武士、罗刹卷轴 |
| `ITEM_ATTRIBUTE_LOWEER` | 202 | 中级属性材料，如龙虎灵符、青铜武士、巫女卷轴 |
| `ITEM_ATTRIBUTE_NORMAL` | 203 | 高级属性材料，如霸王灵符、四臂金刚、侠客卷轴 |
| `ITEM_ATTRIBUTE_HIGHER` | 204 | 最高级属性材料，如至尊灵符、溜金双龙、神合卷轴 |
| `ITEM_ATTRIBUTE_HIGHEST` | 205 | 极品属性材料，如天神灵符、金铜弥勒菩萨、圣灵卷轴 |

201～205 是附加属性材料使用的档次，不是玩家等级。201～204 的中文档次见[重返王陵材料加工](<../炎黄新章游戏资料/新手入门/版本介绍/重返王陵材料加工.md>)；205 的“极品”名称来自随包 `Item.sdb` 中天神灵符、圣灵卷轴等的 `Desc`。英文声明中的 `LOWEER` 拼写按源码保留。

---

## 穿戴冰火属性的检查顺序

冰火属性的环境防护不只对武器有效，防具也可提供。必须实际穿戴，仅放在背包中不会参与这项判断。

`TWearItemClass.SetLifeData` 先将 `SpecialItemType` 清为 `0`，再按穿戴数组槽位 `1～9` 依次检查。遇到火（`Attribute=1`）或冰（`Attribute=3`）就覆盖当前结果；空槽、无属性及其它属性不会清除已有的冰火结果。

| 检查顺序／槽位 | 常量 | 部位或用途 |
| ---: | --- | --- |
| 1 | `ARR_GLOVES` | 护腕、手臂防具；不是武器栏的拳套 |
| 2 | `ARR_UPUNDERWEAR` | 内层上衣 |
| 3 | `ARR_SHOES` | 鞋子 |
| 4 | `ARR_DOWNUNDERWEAR` | 裤子、裙子 |
| 5 | 无独立常量 | 手臂外观映射位，不是独立装备槽；`GetFeature` 将槽 1 的外观映射到此层 |
| 6 | `ARR_UPOVERWEAR` | 外衣、道袍、战甲 |
| 7 | `ARR_HAIR` | 头发 |
| 8 | `ARR_CAP` | 帽子、头盔 |
| 9 | `ARR_WEAPON` | 武器 |

槽位 `0` 是身体基础外观，不在上述循环内。槽位与外观层的完整说明见[装备部位](RACE_CLASS.md#装备部位-arr_)；不能因为循环经过某个编号，就把它当作可新增装备的独立位置。

**最后检查到的冰火属性生效，与玩家穿戴先后、装备品级和同属性装备数量无关。**常见战斗装备的覆盖优先级为：武器 ＞ 帽子 ＞ 外衣 ＞ 鞋子 ＞ 护腕；前提是该件装备确实带有冰火属性。角色只记录一种穿戴性质，不累加免疫强度，也不能靠混穿同时保留冰、火两种穿戴性质。

例如：火防具与冰武器同时穿戴，最终为冰；冰防具与火武器同时穿戴，最终为火；冰防具与无属性武器同时穿戴，仍为冰。

地图启用属性变化时，最终火性质可免除冰地图的严寒扣血，最终冰性质可免除火地图的炎热扣血。背包中尚有耐久的水容器提供炎热防护是独立条件，不受上述穿戴属性覆盖影响；这不等于同时取得两种穿戴性质。地图类型、伤害参数见[属性地图与天气](../Init_map.sdb.md#属性地图与天气)。装备与地图的 `Attribute` 使用不同枚举，不可混用。

源码依据：[uUserSub.pas](../TGS核心源码/uUserSub.pas) 的 `TWearItemClass.SetLifeData`、`GetFeature`，以及 [UUser.pas](../TGS核心源码/UUser.pas) 的 `MAP_TYPE_ICE`、`MAP_TYPE_FIRE` 环境伤害分支。

## 属性相克关系

本页常量定义不能证明火、冰、水之间存在循环相克。`AM_WHRelationTable` 读取 `AM&WHRelation.SDB`，调用处使用护体武功与掌法的 `rMagicRelation`，不是这里的 `ITEM_ATTRIBUTE_*`。

依据：[svClass.pas](../TGS核心源码/svClass.pas) 的 `GetValueFromRelationTable` 及 [UUser.pas](../TGS核心源码/UUser.pas) 的调用处。物品元素相克规则需另有对应实现依据，不能从该表推导。

---

## 相关文档

- [ITEM_KIND.md](ITEM_KIND.md) — 物品类型常量
- [Init_item.sdb.md](../Init_item.sdb.md) — 物品数据库结构
- [RACE_CLASS.md](RACE_CLASS.md#装备部位-arr_) — 装备槽位与外观层
- [Init_map.sdb.md](../Init_map.sdb.md#属性地图与天气) — 环境伤害与防护条件
