# getsenderallitem

按物品内部名称，在当前触发玩家的背包、个人商店和技术材料栏中，分别尝试删除**首个匹配槽位的全部数量**。函数名中的 `all` 不代表遍历删除所有同名槽位。

## 语法

```pascal
print('getsenderallitem <物品名>');
```

只有物品名参数，不使用 `名称:数量` 格式。

## 实际范围

调用链：`uScriptManager` 的 `getsenderallitem` 分派 → `TUser.SGetAllItem` → `TUserObject.DeleteAllItembyName`。

| 容器 | 查找与删除 |
|---|---|
| 背包 | `HaveItemClass.FindItemKeybyName` 找首个同名槽位，再用 `DeleteItem(index)` 清空 |
| 个人商店 | `HaveMarketClass.FindItemKeybyName`、`DeleteKeyMarketItem`；`NATION_CHINA_1` 和 `NATION_CHINA_1_TEST` 分支不执行查找/删除 |
| 技术材料栏 | `HaveJobClass.FindItemKeybyName` 找首个同名槽位，再用 `DeletekeyMaterialItem(index)` 清空 |
| 穿戴栏、福袋 | 不处理 |

每个容器最多删除一个匹配槽位。该槽有多个堆叠数量时一并删除，但同一容器后面还有同名槽位时，不会继续查找。例如背包第一个同名槽位有2个、第二个有3个，本次只删除前2个。

源码依据：[UUser.pas](../../help/TGS核心源码/UUser.pas) 的 `SGetAllItem`、`DeleteAllItembyName`；[uUserSub.pas](../../help/TGS核心源码/uUserSub.pas) 中三个容器的 `FindItemKeybyName` 与对应单槽删除方法。

## 使用示例

```pascal
// 分别尝试回收三个容器中首个同名槽位；并非全容器清空
print('getsenderallitem 布条');
```

如果任务要求精确回收背包中的指定数量，应检查持有数量并使用 [getsenderitem](getsenderitem.md)。如果希望按类别清理整个背包，应先确认 [deletequestitem](deletequestitem.md) 的固定四类范围，尤其是其中包含护符类。

## 耐久关联调用

背包中44、45类物品计时耗尽且 `SpecialKind=5` 时，也调用同一个 `DeleteAllItembyName`，参数取 `DelItem` 第一项的名称。因此这条耐久联动同样受上述单槽和容器范围限制；不会自动遍历所有 `DelItem` 配置项。详见[耐久度处理](../../help/constants/ITEM_KIND.md#耐久度处理)。
