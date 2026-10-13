# checkitemregen

按地图内同名地面物品对象的现有数量，尝试在指定区域补充物品。不是每次固定新增指定数量，也不保证恰好补足到参数值。

## 语法与参数

```pascal
print('checkitemregen 物品名 X Y 范围 数量上界');
```

- `X/Y`：地图坐标中心。
- `范围 aW`：生成坐标使用 `X-aW+Random(aW*2)`、`Y-aW+Random(aW*2)`；正范围时是每轴从中心减 aW 到中心加 aW 减 1。
- `数量上界 aCount`：循环上界，不是固定新增数。脚本应提供有效物品名、正范围及非负数量，并核对坐标。

## 实现与边界

命令由 `TScriptManager.CallEvent(aManager, ...)` 重载在 `CommandScript` 分派前处理，经 `TManager.CheckItemRegen` 调用 `TItemList.AddItemSpecial`。

`AddItemSpecial` 先遍历当前地图的 `ItemList.DataList`，按 `BasicData.Name` 统计同名物品**对象数** `nCount`，不是堆叠数量，也不只统计给定生成区域，然后执行：

```pascal
for i := nCount to aCount do
begin
   x := aX - aW + Random(aW * 2);
   y := aY - aW + Random(aW * 2);
   AddItemObject(SubData, 0, 0, x, y);
end;
```

Pascal 的 `to` 包含上界。因此当 `nCount <= aCount` 时，尝试新增 `aCount - nCount + 1` 个对象；已超过上界时不进入循环。不能改述为严格补足到 `aCount`。

实际生成仍受 `AddItemObject` 的容量检查等条件影响：其检查为 `DataList.Count > 3000` 时直接返回，不能把循环次数当作成功生成数。

## 示例

```pascal
procedure OnTimer(aStr: String);
begin
    // 范围参数为 10，数量上界为 60
    // 当前同名对象为 0 时尝试新增 61 个；为 60 时仍尝试新增 1 个
    print('checkitemregen 生肉 100 84 10 60');
end;
```

这是地图管理器事件中的命令，不应假定普通对象事件的另一 `CallEvent` 重载也会处理它。

源码依据：[uScriptManager.pas](../../help/TGS核心源码/uScriptManager.pas)、[uManager.pas](../../help/TGS核心源码/uManager.pas)、[BasicObj.pas](../../help/TGS核心源码/BasicObj.pas) 的上述方法。
