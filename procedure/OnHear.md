# OnHear

## 声明

```pascal
procedure OnHear (aStr : String);
```

## 参数

| 参数 | 类型 | 说明 |
|------|------|------|
| aStr | String | 说话的内容字符串（已去除说话者名字前缀） |

## 触发条件

收到附近对象的 `FM_SAY` 消息时触发，当前有两条路径：

- DynamicObject：必须处于 `dos_Closed`。若启用 `DYNOBJ_EVENT_SAY`，代码执行内建问答分支后退出，不调用脚本 `OnHear`；未走该分支且已登记事件时才调用脚本回调。
- NPC：排除死亡的 Sender、NPC 自身及非 HUMAN 的说话者，再执行已登记的 `OnHear`；不需要动态对象标记。

`Self` 是监听说话的对象，`Sender` 是说话者。两条路径都从 `SayString` 中去掉说话者前缀，将剩余正文传入 `aStr`。

源码位置：`BasicObj.pas` 第 6446-6482 行、`uNpc.pas` 第 615-637 行

## 适用对象

- DynamicObject（动态对象）
- NPC

## 示例

> 以下为按当前接口编写的参考结构，不代表随包已部署该玩法。需先确认所在地图存在名为“铁闸门”的动态对象；`selfchangedynobjstate` 分支只适用于 Self 为动态对象的事件。

```pascal
procedure OnHear (aStr : String);
var
   Str, Name : String;
begin
   // 监听玩家说话并响应
   if aStr = '开门' then begin
      print ('changedynobjstate 铁闸门 true');
      print ('say 听到指令，开启大门');
      exit;
   end;

   if aStr = '点火' then begin
      print ('selfchangedynobjstate TRUE');
      exit;
   end;
end;
```

## 相关事件

- [OnTimer](OnTimer.md) — 定时触发事件
- [OnDropItem](OnDropItem.md) — 投放物品事件
- [OnChangeState](OnChangeState.md) — 状态变化事件
