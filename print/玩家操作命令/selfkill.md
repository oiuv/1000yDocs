# selfkill

## 功能描述
将自杀命令（CMD_SELFKILL）推入脚本自身对象 `aSelf` 的工作队列，由该对象处理；不是让事件发送者 `aSender` 自杀。NPC 脚本中通常由 NPC 自身执行。

## 语法格式
```pascal
print('selfkill');
```

## 参数说明
无参数。

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'selfkill' then begin
   TBasicObject (aSelf).PushCommand (CMD_SELFKILL, Params, 0);
```

通过 `PushCommand` 将 `CMD_SELFKILL`（值为 5）推入 `aSelf` 的工作队列，间隔参数为 0；实际执行仍受工作队列调度约束，不是同步立即执行。

## 使用示例

### NPC自杀
```pascal
// 任务完成后NPC消失
print ('say 我的使命已经完成了...');
print ('selfkill');
```

### 条件触发NPC消失
```pascal
// 检查任务状态后NPC自杀
quest_status := callfunc ('getsendercompletequest');

if quest_status = '1' then begin
   print ('say 谢谢你救了我');
   print ('selfkill');
end;
```

## 注意事项

1. **作用对象**：命令作用于 `aSelf`，具体行为取决于对象类型及其自杀处理，不能按命令名推断为操作触发玩家
2. **队列执行**：通过 `PushCommand` 推入工作队列，不保证立即执行
3. **与重生配合**：NPC自杀后可通过 `regen` 命令在指定时间后重新生成
4. **无脚本实例**：当前 bin/Script/ 目录下未找到此命令的实际使用脚本

## 相关命令
- `regen` - 重生NPC
- `changedynobjstate` - 改变动态对象状态
