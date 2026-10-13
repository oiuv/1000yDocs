# attack

## 功能描述
令NPC攻击指定目标。将攻击命令（CMD_ATTACK）推入NPC的工作队列，使NPC主动攻击目标对象。

## 语法格式
```pascal
print('attack 目标ID');
```

## 参数说明
- **目标ID**：Integer - 要攻击的目标对象的 ServerID

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'attack' then begin
   TBasicObject (aSelf).PushCommand (CMD_ATTACK, Params, 0);
```

通过 `PushCommand` 将 `CMD_ATTACK`（值为 1）推入 aSelf（NPC）的工作队列。工作队列处理中：

```pascal
CMD_ATTACK:
   begin
      WorkSet.Priority := wsp_giga;
      WorkSet.AddiParam(wpt_integer, _StrToInt(aParams[0]));
   end;
```

优先级为 `wsp_giga`，参数为目标 ServerID。它不是最高级别：`TWorkSetPriority` 按 `wsp_byte`、`wsp_kilo`、`wsp_mega`、`wsp_giga`、`wsp_tera` 递增，见 [uWorkBox.pas](../../help/TGS核心源码/uWorkBox.pas)。

## 使用示例

### NPC攻击玩家
```pascal
// 获取玩家的 ServerID 并令NPC攻击
sender_id := callfunc ('getsenderserverid');
Str := 'attack ' + sender_id;
print (Str);
```

### 条件触发攻击
```pascal
// 玩家触发陷阱后NPC攻击
trap_triggered := callfunc ('getsenderqueststr');

if trap_triggered = 'trap_active' then begin
   sender_id := callfunc ('getsenderserverid');
   Str := 'attack ' + sender_id;
   print (Str);
   print ('say 你触发了陷阱！');
end;
```

## 注意事项

1. **作用于NPC**：命令使 aSelf（NPC）发起攻击，不是玩家攻击
2. **目标ID**：参数为目标对象的 ServerID，可通过 `getsenderserverid` 获取玩家的 ServerID
3. **队列优先级**：攻击命令为 `wsp_giga`，不能抢在更高的 `wsp_tera` 任务之前；推入队列不等于立即执行
4. **无脚本实例**：当前 bin/Script/ 目录下未找到此命令的实际使用脚本

## 相关命令
- `getsenderserverid` - 获取玩家的 ServerID（callfunc 函数）
- `setallowhitbyname` - 设置允许攻击
- `returndamage` - 反弹伤害
