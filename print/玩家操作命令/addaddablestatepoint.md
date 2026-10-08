# addaddablestatepoint

## 功能描述
增加玩家的可分配状态点数。玩家可以使用这些点数自由分配到各项属性上。

## 语法格式
```pascal
print('addaddablestatepoint 点数');
```

## 参数说明
- **点数**：Integer - 要增加的可分配状态点数量

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'addaddablestatepoint' then begin
   TBasicObject (aSender).SAddAddableStatePoint (_StrToInt (Params [0]));
```

`TUser.SAddAddableStatePoint` 实现在 `UUser.pas` 中：

```pascal
procedure TUser.SAddAddableStatePoint (aPoint : Integer);
begin
   AttribClass.AddableStatePoint := AttribClass.AddableStatePoint + aPoint;
   SendClass.SendExtraAttribValues (AttribClass);
end;
```

## 使用示例

### 奖励状态点
```pascal
// 完成任务奖励5个可分配状态点
print ('addaddablestatepoint 5');
print ('say 恭喜你完成任务，获得5个状态点');
```

### 条件奖励
```pascal
// 根据任务进度奖励不同数量的状态点
quest_level := callfunc ('getsenderqueststr');

if quest_level = 'level1' then begin
   print ('addaddablestatepoint 3');
   print ('say 获得3个状态点');
end;
if quest_level = 'level2' then begin
   print ('addaddablestatepoint 5');
   print ('say 获得5个状态点');
end;
```

## 注意事项

1. **累加计算**：新点数在现有可分配点数基础上累加
2. **即时同步**：加点后会立即发送 `SendExtraAttribValues` 更新客户端显示
3. **与 addtotalstatepoint 区别**：本命令增加的是"可分配"点数（玩家可自由分配），`addtotalstatepoint` 增加的是"总"状态点数
4. **无脚本实例**：当前 bin/Script/ 目录下未找到此命令的实际使用脚本

## 相关命令
- `addtotalstatepoint` - 增加总状态点
