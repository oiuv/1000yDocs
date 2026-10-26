# getevent

## 功能描述
获取触发者（玩家）的事件状态值。每个玩家有 20 个事件记录位（0-19），每位存储 0 或 1。

## 语法格式
```pascal
Str := callfunc('getevent 事件编号');
```

## 参数说明
- **事件编号**：Integer - 事件代码，范围 0-19。超出范围返回 '1'

## 返回值
- **未触发**：返回 '0'
- **已触发**：返回 '1'
- **参数越界**：返回 '1'（EventCode > 19 或 < 0 时）

## 源码实现
基于 `UUser.pas` 中的 `SGetEvent` 函数：

```pascal
function TUser.SGetEvent(EventCode: Integer): String;
begin
    if (EventCode > 20 - 1) or (EventCode < 0) then begin
        result := '1';
        Exit;
    end;
    result := IntToStr(aEventRecord[EventCode]);
end;
```

在 `uScriptManager.pas` 的 `CallFunction` 中调用：
```pascal
end else if cmd = 'getevent' then begin
   Result := TBasicObject(FSender).SGetEvent(StrToIntDef(Params[0], 0));
```

## 使用示例

### 检查任务事件状态（来自一级老板娘脚本）
```pascal
// 检查事件2是否已触发
Str := callfunc('getevent 2');
FirstQuest := StrToInt(Str);
if FirstQuest <> 0 then begin
   print('say 我们似乎在哪儿见过...');
   Exit;
end;
```

### 任务完成判断（来自犀牛猎人脚本）
```pascal
// 检查事件0的状态
Str := callfunc('getevent 0');
FirstQuest := StrToInt(Str);

if FirstQuest = 0 then begin
   // 事件未触发，给予奖励
   print('putsendermagicitem 九转金丹:1 @犀牛猎人 4');
   Str := callfunc('getsetevent 0');
end;
```

### 剧情事件检查（来自萧郎脚本）
```pascal
// 检查事件1是否已触发
Str := callfunc('getevent 1');
FirstQuest := StrToInt(Str);
if FirstQuest <> 0 then begin
   print('say 我们似乎在哪儿见过...');
   Exit;
end;
```

## 注意事项

1. **返回值类型**：返回字符串 '0' 或 '1'，需要 `StrToInt()` 转换
2. **事件编号范围**：有效范围 0-19，共 20 个事件位
3. **越界处理**：EventCode 超出 0-19 范围时直接返回 '1'
4. **FSender 上下文**：操作的是触发者（玩家）的事件记录
5. **配合 setevent**：通常先用 `getevent` 检查状态，再用 `setevent` 设置状态；旧名称 `getsetevent` 同样有效
6. **持久化**：事件状态保存在玩家数据中，重启后仍然保留

## 相关函数
- [`setevent`](setevent.md) / [`getsetevent`](getsetevent.md) - 将未完成标记置为已完成，不会切换或清零
- `getsenderfirstquest` - 获取触发者首次任务状态
