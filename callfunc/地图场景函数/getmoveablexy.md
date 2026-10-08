# getmoveablexy

## 功能描述
检查指定坐标在当前地图上是否可移动（是否可行走）。

## 语法格式
```pascal
Str := callfunc('getmoveablexy X坐标 Y坐标');
```

## 参数说明
- **X坐标**：Integer - 要检查的 X 坐标
- **Y坐标**：Integer - 要检查的 Y 坐标

## 返回值
- **可移动**：返回 'true'
- **不可移动**：返回 'false'

## 源码实现
基于 `BasicObj.pas` 中的 `SGetMoveableXY` 函数：

```pascal
function TBasicObject.SGetMoveableXY(aX, aY: Word): string;
begin
   Result := 'false';
   if TMaper(Maper).isMoveable(aX, aY) = true then
   begin
      Result := 'true';
   end;
end;
```

在 `uScriptManager.pas` 的 `CallFunction` 中调用：
```pascal
end else if cmd = 'getmoveablexy' then begin
   Result := TBasicObject(FSelf).SGetMoveableXY(_StrToInt(Params[0]), _StrToInt(Params[1]));
```

## 使用示例

### 检查坐标是否可行走
```pascal
// 检查坐标 (100, 200) 是否可移动
Str := callfunc('getmoveablexy 100 200');
if Str = 'true' then begin
   print('say 该坐标可以行走');
end;
if Str = 'false' then begin
   print('say 该坐标不可行走');
end;
```

## 注意事项

1. **返回值类型**：返回字符串 'true' 或 'false'
2. **地图约束**：通过 `TMaper(Maper).isMoveable` 检查，基于当前地图的地形数据
3. **FSelf 上下文**：通过自身对象调用，使用自身的地图数据
4. **脚本中无实际用例**：当前脚本目录中未发现该函数的直接使用示例
5. **数值转换**：参数先经 `_StrToInt`，再传入 `Word` 类型的坐标参数；脚本应传入当前地图的有效非负坐标

## 相关函数
- `getnearxy` - 获取附近可移动坐标
- `getposition` - 获取自身坐标
- `getsenderposition` - 获取触发者坐标
