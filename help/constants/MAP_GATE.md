# 地图与传送门常量

> 源码: [deftype.pas](../deftype.pas)，`GATE_KIND_*` 在第 213-223 行，`MAP_TYPE_*` 在第 231-241 行

---

## 地图类型 (MAP_TYPE_*)

定义地图的特殊属性，对应 `Init/Map.sdb` 中的 `Attribute` 字段。类型名不等于完整规则；还需结合地图开关、人物状态和持有物品。详见[地图属性说明](../Init_map.sdb.md)。

| 常量名 | 值 | 中文说明 | 详细说明 |
|--------|---:|----------|----------|
| `MAP_TYPE_ICE` | 1 | 冰属性地图 | 启用属性变化时按比例减活力；火属性装备可免除此项 |
| `MAP_TYPE_FIRE` | 2 | 火属性地图 | 启用属性变化时减活力；水类容器或冰属性装备可免除此项 |
| `MAP_TYPE_FILL` | 3 | 补给地图（新手村使用） | 启用属性变化且持有补给物品时恢复活力、内功、外功、武功 |
| `MAP_TYPE_BATTLE` | 4 | 对战地图 | 分组对战（如砸瓶活动 031001） |
| `MAP_TYPE_DONTTICKET` | 5 | 禁止传送卷轴 | 禁用回城卷轴等 `ITEM_KIND_TICKET` 物品，不等于禁止所有传送 |
| `MAP_TYPE_KILLONLYONE` | 6 | 特殊活动地图标记 | 刷新倒计时剩余 30 秒时调用 `OnEventTimer`；不能据名称推断怪物锁定规则 |
| `MAP_TYPE_GUILDBATTLE` | 7 | 门派大战 | 使用战场复活和药品白名单等规则，不是仅限一种药 |
| `MAP_TYPE_POWERLEVEL` | 8 | 元气境界限制地图 | 境界低于 2 且启用属性变化时按 `ChangeSize` 减活力 |
| `MAP_TYPE_SPORTBATTLE` | 9 | 竞技场 | 使用战场复活和药品白名单等规则 |

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
| `GATE_KIND_SPORTSWAR` | 9 | 竞技场 | 竞技场入场传送门，使用红方、蓝方分组 |
| `GATE_KIND_INTOZHUANG` | 10 | 进入聚贤庄 | 检查聚贤庄战争状态和门票，允许时传送；不是通用玩家住宅 |

---

## 虚拟对象类型 (VIRTUALOBJ_KIND_*)

定义虚拟对象（如水池、恢复区）的功能，对应 `CreateVirtualObject.sdb`。

| 常量名 | 值 | 中文说明 | 详细说明 |
|--------|---:|----------|----------|
| `VIRTUALOBJ_KIND_NONE` | 0 | 无 | — |
| `VIRTUALOBJ_KIND_OASIS` | 1 | 沙漠绿洲 | 帝王石窟沙漠绿洲 |
| `VIRTUALOBJ_KIND_FILLLIFE` | 2 | 恢复区 | 新手村恢复活力/内/外/武功 |
| `VIRTUALOBJ_KIND_FILLOASISLIFE` | 3 | 绿洲与恢复区 | 补满水容器耐久，并恢复元气、活力、内功、外功、武功 |

---

## 动态对象事件 (DYNOBJ_EVENT_*)

定义动态对象可触发的事件类型，对应 `CreateDynamicObject.SDB`。

| 常量名 | 值 | 中文说明 | 详细说明 |
|--------|---:|----------|----------|
| `DYNOBJ_EVENT_NONE` | 0 | 无事件 | 不触发任何事件 |
| `DYNOBJ_EVENT_HIT` | 1 | 打击事件 | 攻击时触发 |
| `DYNOBJ_EVENT_ADDITEM` | 2 | 放入物品 | 放入物品时触发 |
| `DYNOBJ_EVENT_SAY` | 4 | 说话事件 | 对话时触发 |
| `DYNOBJ_EVENT_BOW` | 8 | 弓箭事件 | 处理 `FM_BOW`；此分支没有限定为火箭 |
| `DYNOBJ_EVENT_MOVETICK` | 9 | 定时移动 | 按 Tick 定时生成/消失 |

### 事件组合与特殊值

`HIT`、`ADDITEM`、`SAY`、`BOW` 使用按位检查；`MOVETICK=9` 另有相等判断的定时处理。9 同时含有 1 和 8 两个位，因此不能解释为排除打击、弓箭事件的独立位标记。

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
| 8 | 弓箭事件 |
| 9 | 启用定时显示/再生处理；按位检查时也满足打击和弓箭事件条件 |

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
- [uManager.pas](../TGS核心源码/uManager.pas) — 地图 `Attribute` 加载与活动倒计时
- [BasicObj.pas](../TGS核心源码/BasicObj.pas) — `GATE_KIND_SPORTSWAR` 的竞技场入场分支
