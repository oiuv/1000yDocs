# OnApproach

其他对象从近身范围外进入近身范围时触发的事件回调，不等同于进入可见视野。

## 声明
```pascal
procedure OnApproach (aStr : String);
```

## 参数
| 参数 | 类型 | 说明 |
|------|------|------|
| aStr | String | 空字符串，无附加信息。可通过 `callfunc('getsenderrace')` 获取触发者的种族类型来判断是玩家还是其他对象 |

## 触发条件
`TBasicObject.FieldProc` 处理 `FM_MOVE` 时，用 `isApproach` 比较移动前后的位置：横、纵坐标差均不超过 2 格即在近身范围内（含边界，共 5×5 格）。由范围外移入范围内时，向双方发送 `FM_APPROACH`；接收对象绑定了本事件才执行脚本。

这与 `isRange` 判断的可见视野、`FM_SHOW` 显示消息是两套条件。不能据此假定创建、传送或任何一次显示对象都会触发本事件。可用于：

- 玩家靠近时自动播放语音或显示文字
- 根据接近者身份触发不同反应
- 实现区域感知逻辑

依据：[BasicObj.pas](../help/TGS核心源码/BasicObj.pas) 的 `TBasicObject.isApproach`、`TBasicObject.FieldProc`（`FM_MOVE`、`FM_APPROACH` 分支）。

## 适用对象
- NPC
- Monster
- DynamicObject

## 示例

### 示例 1：玩家靠近时显示对话
> 来源：`bin/Script/一级僧侣.txt`

```pascal
procedure OnApproach (aStr : String);
var
   Str : String;
   Race : Integer;
begin
   Str := callfunc ('getsenderrace');
   Race := StrToInt (Str);
   if Race = 1 then begin
      print ('say 施给僧侣，给您带来好运...');
      exit;
   end;
end;
```

此示例检测接近者的种族（Race=1 表示玩家），如果是玩家则让 NPC 说出祝福语。

## 相关事件
- [OnAway](OnAway.md) — 对象离开近身范围时触发
- [OnCreate](OnCreate.md) — 对象创建时触发
- [OnArrival](OnArrival.md) — 对象到达目的地时触发
