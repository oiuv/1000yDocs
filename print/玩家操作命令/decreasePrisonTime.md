# decreasePrisonTime

## 功能描述
减少玩家的监狱关押时间。以分钟为单位减少玩家的剩余刑期。

## 语法格式
```pascal
print('decreasePrisonTime 分钟数');
```

## 参数说明
- **分钟数**：Integer - 要减少的监狱时间（单位：分钟）

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'decreasePrisonTime' then begin
   TBasicObject (aSender).SDecreasePrisonTime(_StrToInt(Params[0]));
```

`TUser.SDecreasePrisonTime` 实现在 `UUser.pas` 中：

```pascal
procedure TUser.SDecreasePrisonTime(aTime: Integer);
begin
   PrisonClass.IncreaseElaspedTime (Name, aTime * 60);
end;
```

内部将分钟数转换为秒数（`aTime * 60`），然后调用 `PrisonClass.IncreaseElaspedTime` 增加已流逝时间，从而减少剩余关押时间。

## 使用示例

### 减少监狱时间
```pascal
// 减少30分钟监狱时间
print ('decreasePrisonTime 30');
print ('say 你的刑期减少了30分钟');
```

### 任务奖励减刑
```pascal
// 完成减刑任务
quest_done := callfunc ('getsenderqueststr');

if quest_done = 'prison_mission' then begin
   print ('decreasePrisonTime 60');
   print ('say 完成任务，刑期减少60分钟');
end;
```

### 缴罚金减刑
```pascal
// 检查玩家是否有足够金钱
Str := callfunc ('getsenderitemexistence 金元:10');
if Str = 'true' then begin
   print ('getsenderitem 金元:10');
   print ('decreasePrisonTime 120');
   print ('say 缴纳罚金，刑期减少120分钟');
end;
if Str = 'false' then begin
   print ('say 你没有足够的金元来减刑');
end;
```

## 注意事项

1. **单位为分钟**：参数以分钟为单位，内部自动转换为秒
2. **减少剩余时间**：通过增加已流逝时间来减少剩余关押时间
3. **不会超出**：减少的时间不会使剩余时间变为负数
4. **无脚本实例**：当前 bin/Script/ 目录下未找到此命令的实际使用脚本

## 相关命令
- `gotoxy` - 传送到指定位置（可用于出狱后传送）
