# getsenderposition

获取当前触发脚本事件的玩家在地图上的位置坐标。

## 语法
```pascal
Str := callfunc('getsenderposition');
```

## 参数
无参数。

## 返回值
返回字符串，格式为 `X_Y`，其中 X 和 Y 分别为玩家在地图上的横纵坐标（整数）。可使用 `GetToken` 函数以 `_` 为分隔符提取坐标值。

## 源码实现
```pascal
TBasicObject(FSender).SGetPosition(MapId, Xpos, Ypos);
Result := IntToStr(Xpos) + '_' + IntToStr(Ypos);
```
通过 `SGetPosition` 获取地图ID和坐标，返回 `X_Y` 格式的字符串。

## 示例

### 获取玩家坐标并计算附近位置
基于 `密室太极老人.txt`：
```pascal
Str := callfunc ('getsenderposition');
Str := GetToken (Str, xStr, '_');
x := StrToInt (xStr);
Str := GetToken (Str, yStr, '_');
y := StrToInt (yStr);

// 使用获取的坐标计算附近位置
rdStr := 'getnearxy ' + xStr;
rdStr := rdStr + ' ';
rdStr := rdStr + yStr;
Str := callfunc (rdStr);
```

## 注意事项
1. 返回值使用 `_` 作为坐标分隔符，需要用 `GetToken` 拆分
2. 返回地图格坐标，不是屏幕像素；`BasicData.X/Y` 使用 Word 存储（0-65535），实际可用坐标还受地图边界与通行数据限制
3. 该函数会检查 `FSender` 是否为 nil，若为空则直接退出

## 相关函数
- `getposition` — 获取对象（自身）位置坐标
- `getnearxy` — 获取指定坐标附近的位置
- `getsendermapname` — 获取玩家所在地图名称
