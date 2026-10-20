# 物品特殊类型常量 (ITEM_SPKIND_*)

> 源码: [deftype.pas](../deftype.pas) 第 193-204 行（`ITEM_SPKIND_*`）

定义物品的特殊分类，对应 `Init/Item.sdb` 中的 `SpecialKind` 字段。它与 `Kind`、`Attribute` 是不同字段；名称和效果需按实际物品及使用分支区分。

---

## 常量列表

| 常量名 | 值 | 中文说明 | 详细说明 |
|--------|---:|----------|----------|
| `ITEM_SPKIND_NONE` | 0 | 无 | 普通物品 |
| `ITEM_SPKIND_MUNJANG` | 1 | 灵符 | 疾风灵符、龙虎灵符等；加工检查对应帽子、护腕、鞋类的属性添加 |
| `ITEM_SPKIND_ZANGSIK` | 2 | 饰品 | 黑马武士、青铜武士等；加工检查对应铠甲类的属性添加 |
| `ITEM_SPKIND_JUMOON` | 3 | 卷轴 | 罗刹卷轴、巫女卷轴等；加工检查对应武器的属性添加 |
| `ITEM_SPKIND_GOLBANG` | 4 | 普通玩家制造许可标记 | 普通玩家 `@item` 指令检查此值；不是仓库存取许可 |
| `ITEM_SPKIND_DELALLBYDURA` | 5 | 耐久耗尽关联清理标记 | 仅在44、45类背包计时耗尽分支生效，按 `DelItem` 第一项名称调用关联清理，不是所有耐久物品通用规则 |
| `ITEM_SPKIND_DONTDRUG` | 6 | 受地图限制的药品标记 | 如玉露丸、阴阳丹；地图 `boUseChemistDrug=false` 时拒绝服用，不是永久禁用 |
| `ITEM_SPKIND_ADDALLLIFE` | 7 | 部位活力上限加成标记 | 在护符类（`Kind=36`）按 `cLife` 增加活力上限的基础上，将同一数值加到头、手臂、腿部活力上限；`cLife` 为空或为 0 时不提供这些加成 |
| `ITEM_SPKIND_1` | 8 | 珍珠 | 珍珠类宝石 |
| `ITEM_SPKIND_2` | 9 | 翡翠 | 翡翠类宝石 |
| `ITEM_SPKIND_3` | 10 | 水晶 | 水晶类宝石 |
| `ITEM_SPKIND_4` | 11 | 琥珀 | 琥珀类宝石 |

---

## 用途说明

- **灵符／饰品／卷轴**（1～3）：用于装备附加属性加工，不是外观分类；制造职业分别为工匠、裁缝、铸造师。原料是否直接可用于加工，还要符合品级、数量等检查。
- **制造许可**（4）：普通玩家 `@item` 的检查标记，不能据此放宽交易、福袋或技术窗限制。
- **耐久耗尽关联清理**（5）：雨中客锦囊（44）、玉仙的无情双刀（45）在背包计时耗尽时，取 `DelItem[0].Name` 调用 `DeleteAllItembyName`。不按配置数量删除，不遍历后续 `DelItem` 项；该函数分别尝试清理背包、个人商店和技术材料栏的首个同名槽位，个人商店还受国家版本分支限制。36、51类没有此联动；详见[耐久度处理](ITEM_KIND.md#耐久度处理)。
- **药品限制**（6）：属于物品使用时的地图检查；药品效果还受 `ItemDrug.sdb`、并发药效槽及其他地图规则约束。
- **宝石标记**（8～11）：珍珠、翡翠、水晶、琥珀分别使用这些值；不能只凭标记认定为某个加工系统的材料。随包也有部分装备使用值 9，应结合 `Kind` 和实际调用判断。

源码依据：[uUserSub.pas](../TGS核心源码/uUserSub.pas) 的 `THaveJobClass.CheckAddAttribKind`、`THaveItemClass.SetAttribData`、`DblClickProcess`、`Update`；[UUser.pas](../TGS核心源码/UUser.pas) 的 `@item` 处理分支和 `TUserObject.DeleteAllItembyName`。中文类别见[重返王陵材料加工](<../炎黄新章游戏资料/新手入门/版本介绍/重返王陵材料加工.md>)。

---

## 相关文档

- [ITEM_KIND.md](ITEM_KIND.md) — 物品类型常量
- [ITEM_ATTRIBUTE.md](ITEM_ATTRIBUTE.md) — 物品属性常量
- [Init_item.sdb.md](../Init_item.sdb.md) — 物品数据库结构
