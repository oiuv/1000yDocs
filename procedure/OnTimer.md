# OnTimer

## 声明

```pascal
procedure OnTimer (aStr : String);
```

## 参数

| 参数 | 类型 | 说明 |
|------|------|------|
| aStr | String | BasicObject 级别传递 "时 分 秒" 格式（如 `"14 30 25"`）；Manager（地图）级别传递空字符串 |

## 触发条件

- **BasicObject 级别**：每 1 秒触发一次，传递当前时间字符串，格式为 `"时 分 秒"`（如 `"14 30 25"`）
- **Manager（地图脚本）级别**：每 60 秒触发一次，传递空字符串

源码位置：`BasicObj.pas` 第 1739-1745 行

## 适用对象

- DynamicObject（动态对象）— 每 1 秒
- NPC / Monster
- Map Script（地图脚本，通过 `ScriptMap.txt`）— 每 60 秒

## 示例

### 示例 1：地图脚本定时器（ScriptMap.txt）

每 60 秒触发，累计 10 次（约 10 分钟）后发送顶部消息并重置计数器：

```pascal
procedure OnTimer (aStr : String)
begin
   Inc(n);
   if n = 10 then begin
      n := 0;
      print ('sendsendertopmsg MapScript测试');
   end;
end;
```

### 示例 2：动态对象倒计时刷怪（东天王火炉.txt）

炉火开启后设置计数器，OnTimer 中倒计时，到 0 时召唤 Boss 和护卫怪物：

```pascal
procedure OnTurnOn (aStr : String);
var
   Str : String;
begin
   // ...检查条件后设置计时器
   n := 1;
   boCall := 'true';
end;

procedure OnTimer (aStr : String)
begin
   Dec(n);
   if n = 0 then begin
      if boCall = 'true' then begin
         print ('mapaddobjbyname monster 东天王魂1 458 59 2 0 false');
         print ('mapaddobjbyname monster 远距离野神族3 456 59 2 0 false');
         print ('mapaddobjbyname monster 远距离野神族3 458 55 2 0 false');
         print ('mapaddobjbyname monster 远距离野神族3 458 62 2 0 false');
         print ('mapaddobjbyname monster 远距离野神族3 463 60 2 0 false');
         boCall := 'false';
         exit;
      end;
   end;
end;
```

### 示例 3：定期检查物品刷新（狐狸洞.txt）

这是地图脚本用法，按 Manager 的 `OnTimer` 周期检查物品刷新，正常 tick 倍率下约每 60 秒执行一次。`checkitemregen` 只在 Manager 重载的 `CallEvent` 入口中处理；普通对象定时器不会执行该命令。最后的 `60` 是命令自己的刷新间隔参数，不改变地图 `OnTimer` 周期：

```pascal
procedure OnTimer (aStr : String);
begin
   print ('checkitemregen 生肉 100 84 10 60');
end;
```

## 相关事件

- [OnEventTimer](OnEventTimer.md) — 事件定时器
- [OnTurnOn](OnTurnOn.md) / [OnTurnOff](OnTurnOff.md) — 开关状态事件（常与 OnTimer 配合实现延时逻辑）
- [OnRegen](OnRegen.md) — 重生事件
