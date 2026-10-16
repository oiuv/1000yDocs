# CreateVirtualObject%d.sdb

为指定地图创建可点击的虚拟对象，例如绿洲或恢复池。`%d` 使用当前 `Manager.ServerId`，加载路径为 `Setting/CreateVirtualObject%d.sdb`。

## 数据结构

当前随包表头为：

```text
Name,X,Y,Width,Height,Kind,Life
```

| 字段 | 类型 | 说明 |
|------|------|------|
| Name | String | 记录索引，同时复制为对象名称 |
| X / Y | Integer | 对象坐标 |
| Width / Height | Integer | 对象作用区域宽度和高度 |
| Kind | Integer | 点击效果类型，见下表 |
| Life | Integer | `Kind=2/3` 时每次恢复的数值；源码直接累加，不做百分比换算 |

## Kind 类型

| 值 | 常量 | 点击后的实际行为 |
|---:|------|------------------|
| 0 | `VIRTUALOBJ_KIND_NONE` | 无专用效果 |
| 1 | `VIRTUALOBJ_KIND_OASIS` | 发送 `FM_CHANGEDURAWATERCASE`，把玩家持有的 `ITEM_KIND_WATERCASE`（`Item.sdb` Kind=35）当前耐久补满 |
| 2 | `VIRTUALOBJ_KIND_FILLLIFE` | 发送 `FM_FILLLIFE`，按 `Life` 同时增加活力、内功、外功和武功 |
| 3 | `VIRTUALOBJ_KIND_FILLOASISLIFE` | 先补满水容器耐久，再按 `Life` 增加元气、活力、内功、外功和武功 |

玩家处理 `FM_FILLLIFE` 时使用 `FillTick + 1500` 限制连续饮用；`FillTick` 与 `mmAnsTick` 使用服务器逻辑 tick。源码对上述属性采用直接加法，最终上限由后续属性同步/约束逻辑决定。

## 源码依据

- `BasicObj.pas` — `TVirtualObject.FieldProc`、`TVirtualObjectList.LoadFromFile`
- `UUser.pas` — `FM_CHANGEDURAWATERCASE`、`FM_FILLLIFE`
