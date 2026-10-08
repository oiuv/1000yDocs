# getdistance

## 功能描述
获取触发者（玩家）与自身（NPC/怪物）之间的距离。

## 语法格式
```pascal
Str := callfunc('getdistance');
```

## 参数说明
无参数。

## 返回值
- **成功**：返回两者之间的距离值（字符串格式的数字），使用 `GetLargeLength` 计算大距离
`Self` 和 `Sender` 都必须有效；入口直接读取双方坐标，没有把无效对象转换为 `0` 的分支。

## 源码实现
在 `uScriptManager.pas` 的 `CallFunction` 中直接计算：

```pascal
end else if cmd = 'getdistance' then begin
   xx1 := TBasicObject(FSender).BasicData.x;
   yy1 := TBasicObject(FSender).BasicData.y;
   xx2 := TBasicObject(FSelf).BasicData.x;
   yy2 := TBasicObject(FSelf).BasicData.y;
   Result := IntToStr(GetLargeLength(xx1, yy1, xx2, yy2));
```

通过获取 FSender（触发者）和 FSelf（自身）的坐标，调用 `GetLargeLength` 计算两点间距离。

## 使用示例

### 距离检查
```pascal
// 检查玩家是否靠近 NPC
Dist := callfunc('getdistance');
Distance := StrToInt(Dist);
if Distance > 5 then begin
   print('say 请走近一些再和我说话');
   exit;
end;
print('say 你好，勇士！');
```

## 注意事项

1. **无参数**：该函数不需要任何参数
2. **返回值类型**：返回字符串格式的数字，需要使用 `StrToInt()` 转换
3. **距离计算**：使用 `GetLargeLength` 函数计算，该函数计算两点间的距离
4. **FSender 与 FSelf**：距离是在触发者（玩家）和自身（NPC/怪物）之间计算的
5. **坐标来源**：坐标来自 `BasicData.x` 和 `BasicData.y`

## 相关函数
- `getposition` - 获取自身坐标
- `getsenderposition` - 获取触发者坐标
- `getnearxy` - 获取附近可移动坐标
