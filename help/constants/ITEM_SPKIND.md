# 物品特殊类型常量 (ITEM_SPKIND_*)

> 源码: [deftype.pas](../deftype.pas) 第 193-204 行（`ITEM_SPKIND_*`）

定义物品的特殊分类，对应 `Init_Item.sdb` 中的 `spkind` 字段。

---

## 常量列表

| 常量名 | 值 | 中文说明 | 详细说明 |
|--------|---:|----------|----------|
| `ITEM_SPKIND_NONE` | 0 | 无 | 普通物品 |
| `ITEM_SPKIND_MUNJANG` | 1 | 纹章 | 纹章类物品 |
| `ITEM_SPKIND_ZANGSIK` | 2 | 装饰 | 装饰类物品 |
| `ITEM_SPKIND_JUMOON` | 3 | 珠宝 | 珠宝类物品 |
| `ITEM_SPKIND_GOLBANG` | 4 | 仓库物品 | 可用 @ 创建的物品（可放入仓库） |
| `ITEM_SPKIND_DELALLBYDURA` | 5 | 耐久消失 | 耐久度耗尽时连同 delitem 指定的物品一起消失 |
| `ITEM_SPKIND_DONTDRUG` | 6 | 禁药 | 炼丹术士制作的药品无法服用 |
| `ITEM_SPKIND_ADDALLLIFE` | 7 | 全属性加血 | Item.sdb 中 cLife 字段值同时加到头部/手臂/腿部血量 |
| `ITEM_SPKIND_1` | 8 | 珍珠 | 珍珠类宝石 |
| `ITEM_SPKIND_2` | 9 | 翡翠 | 翡翠类宝石 |
| `ITEM_SPKIND_3` | 10 | 水晶 | 水晶类宝石 |
| `ITEM_SPKIND_4` | 11 | 琥珀 | 琥珀类宝石 |

---

## 用途说明

- **纹章/装饰/珠宝** (1-3): 装备外观分类，影响角色显示效果
- **宝石** (8-11): 用于装备附加属性的宝石材料
- **仓库物品** (4): 标记物品是否可放入仓库存储
- **耐久消失** (5): 特殊装备机制，耐久归零时触发连锁消失

---

## 相关文档

- [ITEM_KIND.md](ITEM_KIND.md) — 物品类型常量
- [ITEM_ATTRIBUTE.md](ITEM_ATTRIBUTE.md) — 物品属性常量
- [Init_item.sdb.md](../Init_item.sdb.md) — 物品数据库结构
