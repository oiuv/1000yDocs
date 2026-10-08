# OnGetChangeStep

## 声明

```pascal
procedure OnGetChangeStep (aStr : String);
```

## 参数

- `aStr`：附近动态对象的当前步阶 `FCurrentStep` 的十进制字符串，如 `'1'`。不是玩家的移动次数或动作编号。

## 触发条件

当前发送点是 `TDynamicObject.IncStep` / `DecStep`，它们把当前步阶写入 `SubData.Motion` 后广播 `FM_CHANGESTEP`。NPC 在收到消息后调用本事件：`Self` 是 NPC，`Sender` 是改变步阶的动态对象。

接收路径排除自身、`hs_0` 隐藏状态和商店状态的发送者。玩家普通移动发送的是 `FM_MOVE`，不会据此触发本事件。

## 适用对象

NPC 脚本对象，可用于响应附近机关的步阶变化。

## 示例

### 密室太极老人（密室太极老人.txt）—— 响应机关步阶变化

```pascal
procedure OnGetChangeStep (aSTr : String);
var
   Str, rdStr, xStr, yStr : String;
   x, y, xx, yy : Integer;
begin
   if aStr <> '1' then begin
      exit;
   end;

   // 获取 Sender 动态对象的当前位置
   Str := callfunc ('getsenderposition');
   Str := GetToken (Str, xStr, '_');
   x := StrToInt (xStr);
   Str := GetToken (Str, yStr, '_');
   y := StrToInt (yStr);

   // 委托当前地图修正这组坐标
   rdStr := 'getnearxy ' + xStr;
   rdStr := rdStr + ' ';
   rdStr := rdStr + yStr;
   Str := callfunc (rdStr);

   Str := GetToken (Str, xStr, '_');
   xx := StrToInt (xStr);
   Str := GetToken (Str, yStr, '_');
   yy := StrToInt (yStr);

   // 若地图修正后的坐标不变，则结束
   if x = xx then begin
      if y = yy then begin
         exit;
      end;
   end;

   Str := 'gotoxy ' + xStr;
   Str := Str + ' ';
   Str := Str + yStr;
   print (Str);

   // 请求改变与 Sender 同名的动态对象步阶
   rdStr := callfunc ('getsendername');
   Str := 'changesenderdynobjstate ' + rdStr;
   Str := Str + ' false';
   print (Str);
end;
```

> 来源：当前工作区炎黄 `bin/Script/密室太极老人.txt`。参数名 `aSTr` 的大小写不影响解释。

`gotoxy` 给 Self NPC 加入移动工作队列，不传送 Sender。`changesenderdynobjstate` 虽含 `sender`，也在 Self 上加入队列，按名称请求改变动态对象步阶；不是隐藏玩家。`getnearxy` 的地图内部搜索实现不在当前源码中，不能保证固定半径或一定得到合法位置。

## 源码位置

- `uNpc.pas` 第 498-505 行（接收与事件调用）
- `BasicObj.pas` 第 7405-7406、7440-7441 行（发送步阶变化）
- `uScriptManager.pas` 的 `gotoxy`、`changesenderdynobjstate` 分支

## 相关事件

- [`OnGetResult`](OnGetResult.md) —— 玩家选择选项后触发
- [`OnCreate`](OnCreate.md) —— 邻近对象创建后触发
