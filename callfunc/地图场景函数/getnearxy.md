# getnearxy

让脚本自身对象所在地图修正一组坐标，并返回修正结果。

## 语法

```pascal
XY := callfunc('getnearxy <X> <Y>');
```

`X`、`Y` 经 `_StrToInt` 转换后传给 `TBasicObject(FSelf).SGetNearXY`。该方法调用当前 `Maper.GetNearXY(xx, yy)`，再返回：

```text
X_Y
```

```pascal
XY := callfunc('getnearxy 100 200');
```

实现见 [MapUnit.pas](../../help/TGS核心源码/MapUnit.pas) 的 `TMaper.GetNearXY`：

- 原坐标满足 `isMoveable` 时直接保留。
- 否则循环 `i := 0 to 32`，最多调用 33 次 `GetNearPosition`，找到满足 `isMoveable` 的偏移后停止。
- 全部失败时偏移归零，坐标不变，底层返回 `false`。

[BasicObj.pas](../../help/TGS核心源码/BasicObj.pas) 的 `SGetNearXY` 忽略这个布尔返回值，只返回坐标。因此拿到 `X_Y` 不等于找到了可移动位置；也不能把 33 次尝试解释为 33 格搜索半径。
