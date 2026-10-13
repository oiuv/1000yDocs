# 地图与传送门常量

> 源码: [deftype.pas](../deftype.pas)，`GATE_KIND_*` 在第 213-223 行，`MAP_TYPE_*` 在第 231-241 行

---

## 地图类型 (MAP_TYPE_*)

定义地图的特殊属性，对应 `Init_map.sdb` 中的 `maptype` 字段。

| 常量名 | 值 | 中文说明 | 详细说明 |
|--------|---:|----------|----------|
| `MAP_TYPE_ICE` | 1 | 冰属性地图 | 冰冷属性，影响冰系伤害 |
| `MAP_TYPE_FIRE` | 2 | 火属性地图 | 滚烫属性，影响火系伤害 |
| `MAP_TYPE_FILL` | 3 | 新手村 | 自动恢复活力/内/外/武功 |
| `MAP_TYPE_BATTLE` | 4 | 对战地图 | 分组对战（如砸瓶活动 031001） |
| `MAP_TYPE_DONTTICKET` | 5 | 禁止传送 | 无法使用移动符的区域 |
| `MAP_TYPE_KILLONLYONE` | 6 | 单一击杀 | 怪物锁定一个目标攻击 |
| `MAP_TYPE_GUILDBATTLE` | 7 | 门派大战 | 门派对战（仅能使用一种药 040310） |
| `MAP_TYPE_POWERLEVEL` | 8 | 元气等级 | 根据元气等级消耗活力 |
| `MAP_TYPE_SPORTBATTLE` | 9 | 运动会 | 运动会对战（2005-01-19） |

---

## 传送门类型 (GATE_KIND_*)

定义传送门的行为模式，对应 `CreateGate.SDB` 中的 `kind` 字段。

| 常量名 | 值 | 中文说明 | 详细说明 |
|--------|---:|----------|----------|
| `GATE_KIND_NORMAL` | 0 | 普通 | 标准传送门 |
| `GATE_KIND_BS` | 1 | 战斗 | 战斗传送门 |
| `GATE_KIND_DOOR` | 2 | 门 | 门类型（可开关） |
| `GATE_KIND_SPECIALTIME` | 3 | 特殊时间 | 仅在特定时间段开放 |
| `GATE_KIND_FIXPOSITION` | 4 | 固定位置 | 传送到固定坐标 |
| `GATE_KIND_ORDERADDITEM` | 5 | 有序给物品 | 通过时按顺序给物品（活动用 031002 秋季运动会） |
| `GATE_KIND_LIMITUSER` | 6 | 限制人数 | 限制进入人数（活动用 031224 驯鹿） |
| `GATE_KIND_GUILDWAR` | 7 | 门派大战 | 中国门派大战传送门（040307） |
| `GATE_KIND_FIXTIME` | 8 | 定时开放 | 仅在指定时间可通过 |
| `GATE_KIND_SPORTSWAR` | 9 | 运动会大战 | 运动会传送门 |
| `GATE_KIND_INTOZHUANG` | 10 | 进入山庄 | 进入玩家山庄的传送门 |

---

## 虚拟对象类型 (VIRTUALOBJ_KIND_*)

定义虚拟对象（如水池、恢复区）的功能，对应 `CreateVirtualObject.sdb`。

| 常量名 | 值 | 中文说明 | 详细说明 |
|--------|---:|----------|----------|
| `VIRTUALOBJ_KIND_NONE` | 0 | 无 | — |
| `VIRTUALOBJ_KIND_OASIS` | 1 | 沙漠绿洲 | 帝王石窟沙漠绿洲 |
| `VIRTUALOBJ_KIND_FILLLIFE` | 2 | 恢复区 | 新手村恢复活力/内/外/武功 |
| `VIRTUALOBJ_KIND_FILLOASISLIFE` | 3 | 绿洲+恢复 | 综合型（竹筒加水 + 恢复属性） |

---

## 动态对象事件 (DYNOBJ_EVENT_*)

定义动态对象可触发的事件类型，对应 `CreateDynamicObject.SDB`。

| 常量名 | 值 | 中文说明 | 详细说明 |
|--------|---:|----------|----------|
| `DYNOBJ_EVENT_NONE` | 0 | 无事件 | 不触发任何事件 |
| `DYNOBJ_EVENT_HIT` | 1 | 打击事件 | 攻击时触发 |
| `DYNOBJ_EVENT_ADDITEM` | 2 | 放入物品 | 放入物品时触发 |
| `DYNOBJ_EVENT_SAY` | 4 | 说话事件 | 对话时触发 |
| `DYNOBJ_EVENT_BOW` | 8 | 弓箭事件 | 火箭射击触发 |
| `DYNOBJ_EVENT_MOVETICK` | 9 | 定时移动 | 按 Tick 定时生成/消失 |

### 事件组合（可叠加）

| 值 | 组合说明 |
|---:|----------|
| 0 | 无事件 |
| 1 | 打击触发 |
| 2 | 放入物品触发 |
| 3 | 打击 + 放入物品 |
| 4 | 说话触发 |
| 5 | 打击 + 说话 |
| 6 | 放入物品 + 说话 |
| 7 | 打击 + 放入物品 + 说话 |
| 8 | 火箭射击触发 |
| 9 | 定时生成/消失（非事件触发） |

---

## 动态对象类型 (DYNOBJ_TYPE_*)

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `DYNOBJ_TYPE_NONE` | 0 | 无 |
| `DYNOBJ_TYPE_CHECKMOVE` | 1 | 阻止在不可通行位置生成（04.02.10） |

---

## 魔物类型 (MOP_KIND_*)

定义怪物的特殊行为，对应 `Init_monster.sdb`。

| 常量名 | 值 | 中文说明 | 详细说明 |
|--------|---:|----------|----------|
| `MOP_KIND_NONE` | 0 | 普通 | 普通怪物 |
| `MOP_KIND_AUTOCALL` | 1 | 自动召唤 | 每隔数秒自动召唤 member 字段中的怪物 |
| `MOP_KIND_AUTODIE` | 2 | 自动死亡 | 到达指定时间后自动死亡 |
| `MOP_KIND_NEWSKILL` | 3 | 新技能 | 使用新修炼值公式的怪物 |
| `MOP_KIND_SEAL` | 4 | 封印 | 封印的九尾狐相关 |

---

## 相关文档

- [Init_map.sdb.md](../Init_map.sdb.md) — 地图数据库结构
- [CreateGate.SDB.md](../CreateGate.SDB.md) — 传送门配置
- [CreateDynamicObject.SDB.md](../CreateDynamicObject.SDB.md) — 动态对象配置
- [CreateMonster.SDB.md](../CreateMonster.SDB.md) — 怪物创建配置
