# getpassmissiontime

获取触发玩家自任务计时起点以来的计数，返回十进制整数字符串；单位不是分钟。

## 语法与返回值

```pascal
Str := callfunc('getpassmissiontime');
nValue := StrToInt(Str);
```

无参数。先调用 [startmissiontime](startmissiontime.md) 设置起点，再查询：

```pascal
// TUser.SGetPassMissionTime
Result := (Now - MissionStartTick) * 1000 + 1;
// TScriptManager.CallFunction
Result := IntToStr(Trunc(TBasicObject(FSender).SGetPassMissionTime));
```

`Now` 的时间差以天为单位，每个计数单位为 1/1000 天，即 86.4 秒；表达式还加 1，再经 `Trunc` 取整。不能把返回值直接显示为“已经过去多少分钟”。

`MissionStartTick` 声明为 `Single`，把 `Now` 存入它会损失日期时间精度。加 1 不保证首次查询一定为 1，也不能保证起点精确等于调用瞬间。

## 示例

```pascal
Str := callfunc('getpassmissiontime');
nValue := StrToInt(Str);
if nValue > 30 then begin
    // 按公式相对存储起点约 43.2 分钟达到条件，不是 30 分钟
    print('say 任务已超时');
    exit;
end;
```

这里判断的是取整后的值大于 30，不是未经偏移的时间差大于 30。起点的 Single 精度损失和实际查询时机会影响边界观察，不能作为精确计时器。

## 注意事项

- 本接口调用 `FSender` 的虚方法；上述公式针对有效玩家 `TUser`。
- 未设置起点时不能把结果当作本次任务用时。
- 使用系统日期时间差，不是单调时钟；系统时钟调整会影响结果。
- 脚本台词写“分钟”不改变底层计时单位。

源码依据：[uScriptManager.pas](../../help/TGS核心源码/uScriptManager.pas) 的 `CallFunction`、[UUser.pas](../../help/TGS核心源码/UUser.pas) 的 `SGetPassMissionTime`。
