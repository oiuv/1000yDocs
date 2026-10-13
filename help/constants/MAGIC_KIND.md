# 武功门派常量 (MAGIC_KIND_*)

> 源码: [deftype.pas](../deftype.pas) 第 360-365 行（`MAGIC_KIND_*`）

定义武功所属门派，用于绝世武功的门派限制和说明。

---

## 常量列表

| 常量名 | 值 | 中文说明 | 详细说明 |
|--------|---:|----------|----------|
| `MAGIC_KIND_NONE` | 0 | 无门派 | 不属于任何门派 |
| `MAGIC_KIND_KYUNGSIN` | 1 | 经神无痕 | 特殊标记 |
| `MAGIC_KIND_SAPA1` | 2 | 血天魔功 | 邪派 — 血天魔功 |
| `MAGIC_KIND_SAPA2` | 3 | 日月神功 | 邪派 — 日月神功 |
| `MAGIC_KIND_JUNGPA1` | 4 | 紫霞神功 | 正派 — 紫霞神功 |
| `MAGIC_KIND_JUNGPA2` | 5 | 北冥神功 | 正派 — 北冥神功 |

> 数据来源: `bin/Init/BestMagicStateData.sdb`

---

## 门派体系

```
武功门派
├── 正派 (JUNGPA)
│   ├── 紫霞神功 (JUNGPA1 = 4)
│   └── 北冥神功 (JUNGPA2 = 5)
└── 邪派 (SAPA)
    ├── 血天魔功 (SAPA1 = 2)
    └── 日月神功 (SAPA2 = 3)
```

---

## 相关文档

- [MAGICCLASS.md](MAGICCLASS.md) — 武功分类常量
- [MAGICTYPE.md](MAGICTYPE.md) — 武功类型常量
- [Init_magic.sdb.md](../Init_magic.sdb.md) — 武功数据库结构
