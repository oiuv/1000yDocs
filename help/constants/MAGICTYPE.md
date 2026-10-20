# 武功类型常量 (MAGICTYPE_*)

> 源码: [deftype.pas](../deftype.pas) 第 329-355 行（`MAGICTYPE_*`）

定义武功的武器、动作或特殊功能类型。`Init/Magic.sdb` 的字段名是 `MagicType`；加载时以 `MagicType mod 100` 取得类型，以 `MagicType div 100` 取得 `MAGICCLASS_*` 分类，不能把两者混用。

---

## 武功动作类型

| 常量名 | 值 | 中文说明 | 随包示例或说明 |
|--------|---:|----------|-------------|
| `MAGICTYPE_WRESTLING` | 0 | 拳法 | 无名拳法、太极拳 |
| `MAGICTYPE_FENCING` | 1 | 剑法 | 无名剑法 |
| `MAGICTYPE_SWORDSHIP` | 2 | 刀法 | 无名刀法 |
| `MAGICTYPE_HAMMERING` | 3 | 槌法 | 无名槌法 |
| `MAGICTYPE_SPEARING` | 4 | 枪法 | 无名枪术 |
| `MAGICTYPE_BOWING` | 5 | 弓术 | 无名弓术 |
| `MAGICTYPE_THROWING` | 6 | 投法 | 无名投法 |
| `MAGICTYPE_RUNNING` | 7 | 步法（轻功） | 无名步法 |
| `MAGICTYPE_BREATHNG` | 8 | 心法 | 无名心法、伏式气功；不是人物属性“内功” |
| `MAGICTYPE_PROTECTING` | 9 | 护体 | 无名强身、黑沙刚体 |
| `MAGICTYPE_ECT` | 10 | 其他 | 不属于以上分类的特殊武功 |
| `MAGICTYPE_ONLYBOWING` | 11 | 专用弓术 | 百鬼夜行术 |
| `MAGICTYPE_SPECIAL` | 12 | 特殊功能武功 | 怪物特殊武功功能分派使用的类型，见 `MAGICSPECIAL_*` |
| `MAGICTYPE_WINDOFHAND` | 13 | 掌风 | 远程掌法攻击 |
| `MAGICTYPE_BESTSPECIAL` | 14 | 招式武功 | 凌波微步、乾坤大挪移等绝世武功中的招式 |

---

## 特殊武功功能 (MAGICSPECIAL_*)

`Magic.sdb` 中 `MagicType=12` 的记录以 `Function` 字段区分特殊功能；`uMopSub.pas` 的怪物武功表按该字段索引。下表列出随包记录的真实名称，不按英文常量猜测效果，也不表示玩家能学习这些武功。

| 常量名 | 值 | 随包武功名称 | 说明 |
|--------|---:|----------|----------|
| `MAGICSPECIAL_HIDE` | 0 | 隐身术 | `Function=0` |
| `MAGICSPECIAL_SAME` | 1 | 分身术 | `Function=1` |
| `MAGICSPECIAL_HEAL` | 2 | 再生术 | `Function=2` |
| `MAGICSPECIAL_SWAP` | 3 | 变身术 | `Function=3`，不能译为位置交换 |
| `MAGICSPECIAL_EAT` | 4 | 医病术 | `Function=4`，不能译为吞噬 |
| `MAGICSPECIAL_KILL` | 5 | 千斤锥 | `Function=5`，名称不代表一击必杀 |
| `MAGICSPECIAL_PICK` | 6 | 搜集术 | `Function=6` |
| `MAGICSPECIAL_BLOOD` | 7 | 吸血术、东王吸血术 | `Function=7` |
| `MAGICSPECIAL_CALL` | 8 | 召唤术 | `Function=8` |
| `MAGICSPECIAL_DEADBLOW` | 9 | 必杀技 | `Function=9` |
| `MAGICSPECIAL_SHOW` | 10 | 透视 | `Function=10` |
| `MAGICSPECIAL_LAST` | 11 | — | 数量边界；数组使用 `0..MAGICSPECIAL_LAST-1`，不是一种武功 |

---

## 武功关系 (MAGICRELATION_*)

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `MAGICRELATION_0` | 0 | 速度武功系列 |
| `MAGICRELATION_1` | 1 | — |
| `MAGICRELATION_2` | 2 | — |
| `MAGICRELATION_3` | 3 | 无名系列 |
| `MAGICRELATION_4` | 4 | — |
| `MAGICRELATION_5` | 5 | — |
| `MAGICRELATION_6` | 6 | 力量武功系列 |

---

## 武功模式类型 (MAGICPATTERNTYPE_*)

| 常量名 | 值 | 中文说明 | 详细说明 |
|--------|---:|----------|----------|
| `MAGICPATTERNTYPE_PASSIVE` | 0 | 被动 | 被动触发的武功 |
| `MAGICPATTERNTYPE_CONTINUOUS` | 1 | 持续 | 持续生效的武功 |
| `MAGICPATTERNTYPE_LIMIT` | 2 | 限定 | 有限制条件的武功 |

---

## 武功功能 (MAGICFUNC_*)

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `MAGICFUNC_NONE` | 0 | 无 |
| `MAGICFUNC_REFILL` | 1 | 恢复类 |
| `MAGICFUNC_8HIT` | 2 | 8连击 |
| `MAGICFUNC_5HIT` | 3 | 5连击 |

---

## 攻击类型

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `ATTACKTYPE_NONE` | 0 | 无 |
| `ATTACKTYPE_RANDOM` | 1 | 随机攻击 |

## 命中类型 (HITTYPE_*)

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `HITTYPE_WRESTLING` | 0 | 拳法命中 |
| `HITTYPE_FENCING` | 1 | 剑法命中 |
| `HITTYPE_SWORDSHIP` | 2 | 刀法命中 |
| `HITTYPE_HAMMERING` | 3 | 槌法命中 |
| `HITTYPE_SPEARING` | 4 | 枪法命中 |
| `HITTYPE_BOWING` | 5 | 弓术命中 |
| `HITTYPE_THROWING` | 6 | 投法命中 |
| `HITTYPE_PICK` | 7 | 采矿命中 |
| `HITTYPE_WINDOFHAND` | 8 | 掌风命中 |

---

## 攻击范围类型 (RANGETYPE_*)

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `RANGETYPE_NONE` | 0 | 非范围攻击 |
| `RANGETYPE_CENTER_8` | 1 | 以自身为中心8方向范围攻击 |
| `RANGETYPE_CENTER_4` | 2 | 以自身为中心面向4方向范围攻击 |

## 暴击影响范围 (CRITICMAGIC_FUNC_*)

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `CRITICMAGIC_FUNC_NONE` | 0 | 仅影响目标坐标上的角色 |
| `CRITICMAGIC_FUNC_ME8` | 1 | 以攻击者为中心8方向 |
| `CRITICMAGIC_FUNC_ME4` | 2 | 以攻击者为中心4方向 |
| `CRITICMAGIC_FUNC_ME5` | 3 | 以攻击者为中心5方向（五线方） |
| `CRITICMAGIC_FUNC_YOU8` | 10 | 以被击中者为中心8方向 |
| `CRITICMAGIC_FUNC_YOU4` | 11 | 以被击中者为中心4方向 |

---

## 动作类型 (MOTIONTYPE_*)

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `MOTIONTYPE_NONE` | 0 | 无动作 |
| `MOTIONTYPE_CHARGE` | 1 | 举武器聚集气力 |
| `MOTIONTYPE_MAGIC` | 2 | 术法动作 |
| `MOTIONTYPE_CHARGE2` | 3 | 第二种聚集气力 |

---

## Stun 攻击

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `STUN_NONE` | 0 | 无Stun |
| `STUN_ON` | 1 | Stun攻击（解除对方攻击目标） |

---

## 相关文档

- [MAGICCLASS.md](MAGICCLASS.md) — 武功分类常量
- [MAGIC_KIND.md](MAGIC_KIND.md) — 武功门派常量
- [Init_magic.sdb.md](../Init_magic.sdb.md) — 武功数据库结构
- [uMopSub.pas](../TGS核心源码/uMopSub.pas) — 特殊功能索引及怪物武功处理
- [绝世武功介绍](../炎黄新章游戏资料/新手入门/武功介绍/绝世武功介绍.md) — 招式武功名称
