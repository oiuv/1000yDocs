# getsenderdestroyitem

按穿戴槽和物品种类调用触发玩家的销毁接口。不是通用的“物品区域 + 物品 ID”删除命令。

## 语法

```pascal
Str := callfunc('getsenderdestroyitem aKey aKind');
```

- `aKey`：穿戴槽位；只有八卦牌背包分支忽略它，不表示背包/装备区域。
- `aKind`：`ITEM_KIND_*` 常量，不是单件物品 ID。

## 分派与返回值

`TUser.SDestroyItembyKind` 按第二个参数分派：

| 条件 | 行为 |
| --- | --- |
| `aKind = ITEM_KIND_EIGHTANGLES (59)` | 在背包按种类寻找八卦牌，走 `THaveItemClass.DestroyItembyKind`；第一个参数不参与寻找 |
| 其它种类 | 走 `TWearItemClass.DestroyItembyKind(aKey, aKind)`；当前有效销毁分支为 `ITEM_KIND_DURAWEAPON (60)` |

返回十进制字符串：`'1'` 为执行销毁；`'0'` 为槽位无效或未找到对应物品；其它不匹配/未处理分支可能返回初始值 `'-1'`。不能仅用“非 0”当作成功。

## 示例

```pascal
// 按种类寻找背包中的八卦牌；0 不是“背包区域代码”
Str := callfunc('getsenderdestroyitem 0 59');

// 检查穿戴武器槽 9，销毁符合种类 60 的物品
Str := callfunc('getsenderdestroyitem 9 60');
if Str = '1' then begin
    print('say 已销毁对应物品');
end;
```

这两条是独立调用示例，不应直接连续执行作为任务流程。销毁不可逆；仅使用已核对的种类及槽位，不把此接口扩大解释为任意物品删除。

源码依据：[UUser.pas](../../help/TGS核心源码/UUser.pas) 的 `SDestroyItembyKind`、[uUserSub.pas](../../help/TGS核心源码/uUserSub.pas) 的背包/穿戴同名方法、[物品种类](../../help/constants/ITEM_KIND.md)。

相关接口：[getsenderrepairitem](getsenderrepairitem.md)、[getsenderitemexistence](getsenderitemexistence.md)。
