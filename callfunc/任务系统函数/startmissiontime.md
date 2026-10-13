# startmissiontime

设置触发玩家的任务计时起点。与 [getpassmissiontime](getpassmissiontime.md) 配合使用。

## 语法

```pascal
Str := callfunc('startmissiontime');
```

无参数。有效玩家实现执行：

```pascal
MissionStartTick := Now;
Result := MissionStartTick;
```

`MissionStartTick` 声明为 `Single`，存入 `Now` 会损失日期时间精度。脚本入口对返回值 `Trunc` 后用 `IntToStr` 转成字符串。它是转换后日期时间值的整数部分，不是“0 分钟”、成功布尔值或任务 ID。通常只需要调用以设置起点。

## 示例

```pascal
// 接任务时
Str := callfunc('startmissiontime');

// 后续事件中检查
Str := callfunc('getpassmissiontime');
nValue := StrToInt(Str);
if nValue > 30 then begin
    // 按公式相对存储起点约为 43.2 分钟，实际边界受起点精度影响
    print('say 任务已超时');
    exit;
end;
print('say 尚未超过任务时限');
```

`getpassmissiontime` 使用 `Trunc((Now - MissionStartTick) * 1000 + 1)`，不是分钟计数。再次调用本函数会覆盖原起点，不要在每次查询前重置。

源码依据：[uScriptManager.pas](../../help/TGS核心源码/uScriptManager.pas) 的 `CallFunction`、[UUser.pas](../../help/TGS核心源码/UUser.pas) 的 `SStartMissionTime`。
