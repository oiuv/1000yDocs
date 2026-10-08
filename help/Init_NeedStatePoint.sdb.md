# NeedStatePoint.sdb

绝世超式（`MAGICTYPE_BESTSPECIAL`）升重所需的可分配状态点表，不是所有绝世武功初次学习的条件表。

## 文件路径

```
.\Init\NeedStatePoint.sdb
```

## 文件格式

CSV 格式，逗号分隔，首行为列名。

## 字段说明

| 列名 | 类型 | 说明 | 源码依据 |
|------|------|------|----------|
| Name | Integer | 数据行标识；数组下标按数据行顺序从 0 开始，不取此列的数值 | `GetIndexName(i)` 后写入 `FNeedStatePoint[i]` |
| NeedPoint | Integer | 从当前重数升级到下一重需扣除的可分配状态点 | `FNeedStatePoint[i] := NeedStateDB.GetFieldValueInteger(mname, 'NeedPoint')` |

### 使用场景

`TMagicCycleClass` 按数据行顺序加载。在超式升重分支，系统以当前 `rGrade` 查询 `NeedStatePoint`，检查 `AddableStatePoint`，满足条件后扣除所需点数、增加 `rGrade` 并重新取得武功数据。超式窗口也使用该值显示升级需求。

## 数据示例

| Name | 数组下标（当前 rGrade） | 升重 | 需要状态点 |
|------|----------------------|------|-----------|
| 1 | 0 | 一重 → 二重 | 200 |
| 2 | 1 | 二重 → 三重 | 300 |

## 相关源码

- `svClass.pas` — `TMagicCycleClass` 加载逻辑（第 3288 行）
- `svClass.pas` — `GetNeedStatePoint` 属性（第 3146 行）
- `uUserSub.pas` — 超式升重判断、扣点及重数更新（第 8689-8715 行）
- `uUserSub.pas` — 绝世武功窗口显示（第 9606 行）
- `uSendCls.pas` — `SendShowBestSpecialMagicWindow`（第 1705 行）
