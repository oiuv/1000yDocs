# 种族与对象分类常量

> 源码: [deftype.pas](../deftype.pas) 第 425-445 行（`RACE_*`、`CLASS_*`）

---

## 种族 (RACE_*)

定义游戏对象的基本种族类型，对应 `TBasicData.Feature` 中的种族字段。

| 常量名 | 值 | 中文说明 | 详细说明 |
|--------|---:|----------|----------|
| `RACE_NONE` | 0 | 无 | — |
| `RACE_HUMAN` | 1 | 人类 | 玩家角色 |
| `RACE_ITEM` | 2 | 物品 | 地面上的物品 |
| `RACE_MONSTER` | 3 | 怪物 | NPC 怪物 |
| `RACE_NPC` | 4 | NPC | 非玩家角色（商人/任务NPC等） |
| `RACE_DYNAMICOBJECT` | 5 | 动态对象 | 可交互的场景对象（机关/宝箱等） |
| `RACE_STATICITEM` | 6 | 静态物品 | 不可移动的场景装饰物 |

---

## 对象分类 (CLASS_*)

更细粒度的对象分类，对应 `TBasicData.ClassKind` 字段。

| 常量名 | 值 | 中文说明 | 详细说明 |
|--------|---:|----------|----------|
| `CLASS_NONE` | 0 | 无 | — |
| `CLASS_HUMAN` | 1 | 人类 | 玩家角色 |
| `CLASS_MONSTER` | 2 | 怪物 | 普通怪物 |
| `CLASS_NPC` | 3 | NPC | 非玩家角色 |
| `CLASS_ITEM` | 4 | 物品 | 地面物品 |
| `CLASS_DYNOBJECT` | 5 | 动态对象 | 可交互对象 |
| `CLASS_GUILDSTONE` | 6 | 门派基石 | 门派的基石对象 |
| `CLASS_GUILDNPC` | 7 | 门派NPC | 门派专属 NPC |
| `CLASS_GATE` | 8 | 传送门 | 传送门对象 |
| `CLASS_STATICITEM` | 9 | 静态物品 | 场景装饰 |
| `CLASS_DOOR` | 10 | 门 | 可开关的门 |
| `CLASS_SERVEROBJ` | 11 | 服务器对象 | 服务器内部对象 |
| `CLASS_MINEOBJECT` | 12 | 采矿对象 | 矿点 |

---

## 装备部位 (ARR_*)

定义装备穿戴的部位，对应 `WearItemArr` 数组索引。

| 常量名 | 值 | 中文说明 | 装备栏索引 |
|--------|---:|----------|-----------|
| `ARR_BODY` | 0 | 身体 | 上衣 |
| `ARR_GLOVES` | 1 | 手套 | 手套 |
| `ARR_UPUNDERWEAR` | 2 | 上身内衣 | 内衣（上） |
| `ARR_SHOES` | 3 | 鞋子 | 鞋 |
| `ARR_DOWNUNDERWEAR` | 4 | 下身内衣 | 内衣（下） |
| *(5 未使用)* | 5 | — | — |
| `ARR_UPOVERWEAR` | 6 | 上身外衣 | 外套 |
| `ARR_HAIR` | 7 | 头发 | 发型 |
| `ARR_CAP` | 8 | 帽子 | 头饰 |
| `ARR_WEAPON` | 9 | 武器 | 武器 |

### 附加属性装备部位

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `ADDATTRIB_ARMOR` | 6 | 衣服附加属性 |
| `ADDATTRIB_CAP` | 8 | 帽子附加属性 |
| `ADDATTRIB_ARMARMOR` | 1 | 手臂护甲附加属性 |
| `ADDATTRIB_SHOES` | 3 | 鞋子附加属性 |
| `ADDATTRIB_WEAPON` | 9 | 武器附加属性 |

---

## 角色定位 (ROLE_*)

定义玩家的角色定位/职业方向。

| 常量名 | 值 | 中文说明 | 详细说明 |
|--------|---:|----------|----------|
| `ROLE_NONE` | 0 | 无 | — |
| `ROLE_HEAVY_FIGHTER` | 1 | 重装战士 | 高防御近战型 |
| `ROLE_LIGHT_FIGHTER` | 2 | 轻装战士 | 灵活近战型 |
| `ROLE_BOWMAN` | 3 | 弓手 | 远程攻击型 |
| `ROLE_HANDMAN` | 4 | 拳师 | 徒手格斗型 |

---

## 创建类型 (CREATE_*)

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `CREATE_NONE` | 0 | 无 |
| `CREATE_ITEM` | 1 | 创建物品 |
| `CREATE_MONSTER` | 2 | 创建怪物 |

---

## 方向常量 (DR_*)

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `DR_0` ~ `DR_7` | 0-7 | 8个方向（顺时针：北/东北/东/东南/南/西南/西/西北） |
| `DR_DONTMOVE` | 8 | 不可移动 |

---

## 相关文档

- [Init_monster.sdb.md](../Init_monster.sdb.md) — 怪物数据库
- [Init_item.sdb.md](../Init_item.sdb.md) — 物品数据库
