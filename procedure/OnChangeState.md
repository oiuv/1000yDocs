# OnChangeState

## 声明

```pascal
procedure OnChangeState (aStr : String);
```

## 参数

| 参数 | 类型 | 说明 |
|------|------|------|
| aStr | String | 状态字符串：`'normal'`（正常）或 `'die'`（死亡） |

## 触发条件

NPC/Monster 收到附近其它对象的 `FM_CHANGEFEATURE` 消息时触发。`Self` 是接收消息并执行脚本的 NPC/Monster，`Sender` 是状态变化的对象；这两条接收路径均排除自身 ID。`aStr='die'` 表示 Sender 死亡，其它状态返回 `normal`。

NPC 路径还要求 `AttackSkill` 有效，并排除隐藏程度为 `hs_0` 或商店状态的 Sender；Monster 路径排除受控怪物。这两条路径不要求 `DYNOBJ_EVENT_CHANGESTATE` 标记。

源码位置：`uNpc.pas` 第 508-521 行、`uMonster.pas` 第 590-602 行

## 适用对象

- NPC
- Monster

## 示例

### 示例：比武 NPC 观察玩家死亡（3级黑捕校.txt）

当附近玩家死亡时，NPC 检查 Sender 的种族，发送提示并将该玩家移出比武场：

```pascal
procedure OnChangeState (aStr : String);
var
   Str, Name : String;
begin
   if aStr <> 'die' then exit;

   Str := callfunc ('getsenderrace');
   if Str <> '1' then exit;

   print ('say 别想蒙混过关,我很严厉的.');
   print ('say 很遗憾.等下次吧.. 300');

   Name := callfunc ('getsendername');
   Str := 'movespace ' + Name;
   Str := Str + ' user 1 305 371 600';
   print (Str);
end;
```

## 与 OnDie 的区别

`OnChangeState` 观察其它对象；[OnDie](OnDie.md) 处理脚本对象自身死亡。二者不是同一对象死亡流程中固定先后执行的一对事件，脚本必须分别判断 Self 与 Sender。

## 相关事件

- [OnDie](OnDie.md) — 脚本对象自身死亡
- [OnCreate](OnCreate.md) — 创建事件
- [OnRegen](OnRegen.md) — 重生事件
