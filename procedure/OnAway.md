# OnAway

其他对象从近身范围内移到范围外时触发的事件回调，不等同于离开可见视野。

## 声明
```pascal
procedure OnAway (aStr : String);
```

## 参数
| 参数 | 类型 | 说明 |
|------|------|------|
| aStr | String | 空字符串，无附加信息。可通过 `callfunc('getsenderrace')` 获取离开者的种族类型 |

## 触发条件
`TBasicObject.FieldProc` 处理 `FM_MOVE` 时，用 `isApproach` 比较移动前后的位置：横、纵坐标差均不超过 2 格即在近身范围内（含边界，共 5×5 格）。从范围内移到范围外时，向双方发送 `FM_AWAY`；接收对象绑定了本事件才执行脚本。

离开近身范围后，对象可能仍在可见视野内；`FM_HIDE` 隐藏消息和销毁事件也不等同于本事件。可用于：

- 玩家离开时播放告别语音
- 重置因玩家靠近而改变的状态
- 清理与特定玩家相关的临时数据

依据：[BasicObj.pas](../help/TGS核心源码/BasicObj.pas) 的 `TBasicObject.isApproach`、`TBasicObject.FieldProc`（`FM_MOVE`、`FM_AWAY` 分支）。

## 适用对象
- NPC
- Monster
- DynamicObject

## 示例

### 示例 1：玩家离开时显示对话
> 来源：`bin/Script/一级僧侣.txt`

```pascal
procedure OnAway (aStr : String);
var
   Str : String;
   Race : Integer;
begin
   Str := callfunc ('getsenderrace');
   Race := StrToInt (Str);
   if Race = 1 then begin
      print ('say 南无阿弥陀佛...');
      exit;
   end;
end;
```

此示例检测离开者的种族（Race=1 表示玩家），如果是玩家则让 NPC 念诵佛号。

## 相关事件
- [OnApproach](OnApproach.md) — 对象进入近身范围时触发
- [OnCreate](OnCreate.md) — 对象创建时触发
- [OnDestroy](OnDestroy.md) — 对象销毁时触发
