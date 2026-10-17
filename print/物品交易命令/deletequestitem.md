# deletequestitem

按固定 Kind 集合清空当前触发玩家背包中的物品。**不是只删除当前任务的物品，也不是只删除名称看起来像任务道具的物品。**

## 语法

```pascal
print('deletequestitem');
```

无参数。

## 清理范围

| Kind | 常量 | 说明 |
|---:|---|---|
| 34 | `ITEM_KIND_QUESTITEM` | 任务物品 |
| 36 | `ITEM_KIND_CHARM` | 护符类，包括不灭、九转金丹等此类型物品 |
| 37 | `ITEM_KIND_QUESTLOG` | 任务日志 |
| 40 | `ITEM_KIND_QUESTITEM2` | 任务物品2 |

遍历 `HaveItemArr` 的全部槽位，匹配后整槽清零，包括堆叠数量；不检查任务编号、NPC、名称、当前耐久、`boNotDrop`、`boNotTrade` 等字段。只处理背包，不扫描穿戴栏、技术材料栏、个人商店或福袋。

51 类普通耐久物品不在该集合内；它即使用于任务，也不会被此命令删除。按名称交付收走、耐久耗尽删除、`BoNotSave` 不保存是独立的处理机制。

## 源码入口

调用链：`uScriptManager` 的 `deletequestitem` 分派 → `TUser.SDeleteQuestItem` → `THaveItemClass.DeleteQuestItem`。

底层选择条件：

```pascal
if (HaveItemArr[i].rKind = ITEM_KIND_QUESTITEM) or
   (HaveItemArr[i].rKind = ITEM_KIND_QUESTITEM2) or
   (HaveItemArr[i].rKind = ITEM_KIND_QUESTLOG) or
   (HaveItemArr[i].rKind = ITEM_KIND_CHARM) then
```

实现要求 `FAttribClass` 非空；收集匹配槽位后，通过 `FillChar` 清空并调用 `SendHaveItem` 逐槽通知客户端。包含护符时设置 `FboAttribData := true`，标记属性需要更新。

源码：[uScriptManager.pas](../../help/TGS核心源码/uScriptManager.pas)、[UUser.pas](../../help/TGS核心源码/UUser.pas)、[uUserSub.pas](../../help/TGS核心源码/uUserSub.pas)。

## 使用示例

随包 `Script/玉仙.txt` 的任务重置分支：

```pascal
if aStr = 'remotequest' then begin
  print('deletequestitem');
  print('changesendercompletequest 100');
  print('changesendercurrentquest 100');
  exit;
end;
```

这里先执行全背包的四类清理，再修改玩家任务编号；不是根据随后设置的编号筛选待删除物品。

## 相关文档

- [物品类型与任务清理范围](../../help/constants/ITEM_KIND.md#任务清理范围)
- [耐久度处理](../../help/constants/ITEM_KIND.md#耐久度处理)
- [getsenderitem](getsenderitem.md)：按名称和数量回收背包物品。
- [getsenderallitem](getsenderallitem.md)：按名称在背包、个人商店、技术材料栏分别尝试删除首个匹配槽位；不能据名称推断为遍历删除所有同名槽位。
