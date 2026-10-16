# 武功门派常量 (MAGIC_KIND_*)

> 源码: [deftype.pas](../deftype.pas) 第 360-365 行（`MAGIC_KIND_*`）

记录神功派别及特殊步法标记，对应 `Init/Magic.sdb.Kind`。这里的正邪派别不是玩家创建、加入的门派（Guild）。

---

## 常量列表

| 常量名 | 值 | 中文说明 | 详细说明 |
|--------|---:|----------|----------|
| `MAGIC_KIND_NONE` | 0 | 无派别标记 | 未指定此类标记 |
| `MAGIC_KIND_KYUNGSIN` | 1 | 凌波微步标记 | 随包“凌波微步”的 `Kind=1`、`MagicType=314` |
| `MAGIC_KIND_SAPA1` | 2 | 血天魔功 | 邪派 — 血天魔功 |
| `MAGIC_KIND_SAPA2` | 3 | 日月神功 | 邪派 — 日月神功 |
| `MAGIC_KIND_JUNGPA1` | 4 | 紫霞神功 | 正派 — 紫霞神功 |
| `MAGIC_KIND_JUNGPA2` | 5 | 北冥神功 | 正派 — 北冥神功 |

> 数据来源：`Init/Magic.sdb.Kind`、`MAGIC_KIND_SAPA*` / `MAGIC_KIND_JUNGPA*` 定义，以及[四大神功介绍](../炎黄新章游戏资料/新手入门/武功介绍/四大神功介绍.txt)。例如金蛇剑法为 `Kind=2`，寒阴指为 `3`，金刚指为 `4`，玉霄剑法为 `5`。

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
