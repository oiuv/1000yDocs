# getposition

## 功能描述
获取自身（NPC/怪物）当前所在的坐标位置。

## 语法格式
```pascal
Str := callfunc('getposition');
```

## 参数说明
无参数。

## 返回值
- **成功**：返回坐标字符串，格式为 `X_Y`（如 `14_21`）
- 源码没有单独的失败返回分支；`0_0` 也可能只是对象坐标，不能作为失败标志。调用前须保证 `FSelf` 及其地图上下文有效。

## 源码实现
基于 `BasicObj.pas` 中的 `SGetPosition` 过程：

```pascal
procedure TBasicObject.SGetPosition(var aMapID: Integer; var aX, aY: Word);
begin
   aMapID := Manager.ServerID;
   aX := BasicData.X;
   aY := BasicData.Y;
end;
```

在 `uScriptManager.pas` 的 `CallFunction` 中调用：
```pascal
end else if cmd = 'getposition' then begin
   TBasicObject(FSelf).SGetPosition(MapId, Xpos, Ypos);
   Result := IntToStr(Xpos) + '_' + IntToStr(Ypos);
```

## 使用示例

### 获取自身坐标并解析
```pascal
// 获取 NPC 自身坐标
Str := callfunc('getposition');
// Str 格式为 "X_Y"，如 "14_21"

// 使用 GetToken 解析坐标
Str := GetToken(Str, xStr, '_');
x := StrToInt(xStr);
Str := GetToken(Str, yStr, '_');
y := StrToInt(yStr);
```

### 结合 getnearxy 查找附近可移动位置
```pascal
// 获取自身坐标，然后查找附近可移动点
Str := callfunc('getposition');
Str := GetToken(Str, xStr, '_');
x := StrToInt(xStr);
Str := GetToken(Str, yStr, '_');
y := StrToInt(yStr);

rdStr := 'getnearxy ' + xStr + ' ' + yStr;
Str := callfunc(rdStr);
```

## 注意事项

1. **无参数**：该函数不需要任何参数
2. **返回值格式**：返回 `X_Y` 格式的字符串，X 和 Y 之间用下划线 `_` 分隔
3. **FSelf 上下文**：返回的是脚本所属对象（NPC/怪物）的坐标，不是触发者（玩家）的坐标
4. **获取玩家坐标**：如需获取触发者（玩家）坐标，应使用 `getsenderposition`
5. **解析坐标**：使用 `GetToken` 函数和 `_` 分隔符解析 X 和 Y 坐标值

## 相关函数
- `getsenderposition` - 获取触发者（玩家）坐标
- `getnearxy` - 获取附近可移动坐标
- `getmoveablexy` - 检查坐标是否可移动
- `getmapname` - 获取自身所在地图名
