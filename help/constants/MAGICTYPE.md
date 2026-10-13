# 武功类型常量 (MAGICTYPE_*)

> 源码: [deftype.pas](../deftype.pas) 第 329-355 行（`MAGICTYPE_*`）

定义武功的武器/招式类型，对应 `Init_magic.sdb` 中的 `type` 字段。

---

## 基本武功类型

| 常量名 | 值 | 中文说明 | 对应默认武功 |
|--------|---:|----------|-------------|
| `MAGICTYPE_WRESTLING` | 0 | 拳法 | 太极拳/拳法类 |
| `MAGICTYPE_FENCING` | 1 | 剑法 | 剑术类 |
| `MAGICTYPE_SWORDSHIP` | 2 | 刀法 | 刀术类 |
| `MAGICTYPE_HAMMERING` | 3 | 锤法 | 锤术类 |
| `MAGICTYPE_SPEARING` | 4 | 枪法 | 枪术类 |
| `MAGICTYPE_BOWING` | 5 | 弓术 | 弓箭类 |
| `MAGICTYPE_THROWING` | 6 | 投掷 | 飞镖/暗器类 |
| `MAGICTYPE_RUNNING` | 7 | 轻功 | 身法/步法类 |
| `MAGICTYPE_BREATHNG` | 8 | 呼吸 | 内功/调息类 |
| `MAGICTYPE_PROTECTING` | 9 | 护身 | 防御/护体类 |
| `MAGICTYPE_ECT` | 10 | 其他 | 不属于以上分类的特殊武功 |
| `MAGICTYPE_ONLYBOWING` | 11 | 专用弓术 | 仅限弓术使用的武功 |
| `MAGICTYPE_SPECIAL` | 12 | 特殊武功 | 含特殊功能的武功（见 MAGICSPECIAL_*） |
| `MAGICTYPE_WINDOFHAND` | 13 | 掌风 | 远程掌法攻击 |
| `MAGICTYPE_BESTSPECIAL` | 14 | 绝世特殊 | 绝世武功特殊类型 |

---

## 特殊武功功能 (MAGICSPECIAL_*)

当 `MAGICTYPE = SPECIAL(12)` 时，此字段定义具体功能：

| 常量名 | 值 | 中文说明 | 详细说明 |
|--------|---:|----------|----------|
| `MAGICSPECIAL_HIDE` | 0 | 隐身 | 隐身术 |
| `MAGICSPECIAL_SAME` | 1 | 相同 | 变身相同外观 |
| `MAGICSPECIAL_HEAL` | 2 | 治愈 | 治疗恢复类 |
| `MAGICSPECIAL_SWAP` | 3 | 交换 | 位置交换类 |
| `MAGICSPECIAL_EAT` | 4 | 吞噬 | 吞噬类技能 |
| `MAGICSPECIAL_KILL` | 5 | 即死 | 一击必杀类 |
| `MAGICSPECIAL_PICK` | 6 | 拾取 | 远程拾取类 |
| `MAGICSPECIAL_BLOOD` | 7 | 吸血 | 吸血类技能 |
| `MAGICSPECIAL_CALL` | 8 | 召唤 | 召唤类技能 |
| `MAGICSPECIAL_DEADBLOW` | 9 | 致命一击 | 死亡打击类 |
| `MAGICSPECIAL_SHOW` | 10 | 显示 | 显示/揭示类 |
| `MAGICSPECIAL_LAST` | 11 | 最后 | 终极技能 |

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
| `HITTYPE_HAMMERING` | 3 | 锤法命中 |
| `HITTYPE_SPEARING` | 4 | 枪法命中 |
| `HITTYPE_BOWING` | 5 | 弓术命中 |
| `HITTYPE_THROWING` | 6 | 投掷命中 |
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
