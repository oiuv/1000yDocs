# getremainmaptime

按触发者所在地图的重置计时分量与给定阈值比较，返回字符串 `'true'` 或 `'false'`。它不是通用的“剩余时间充足”判断，也不是查询指定地图的剩余时长。

## 语法

```pascal
Str := callfunc('getremainmaptime 分钟阈值 秒阈值');
```

两个参数经 `_StrToInt` 转换，调用 `TBasicObject(FSender).SGetRemainMapTime`。

## 实际分支

| 条件 | 返回结果 |
| --- | --- |
| `Manager.RegenInterval <= 0` | `'true'`，不比较时间 |
| 剩余小时和分钟均为 0，且秒阈值 > 0 | 秒阈值 < 剩余秒时为 `'false'`；否则为 `'true'` |
| 剩余小时和分钟均为 0，且秒阈值 <= 0 | `'true'` |
| 其它情况，且分钟阈值 > 0 | 分钟阈值 < `RemainMin` 时为 `'false'`；否则为 `'true'` |
| 其它情况，且分钟阈值 <= 0 | `'true'` |

分钟分支只比较 `RemainMin`，没有把 `RemainHour` 换算后相加；两个参数也不会合成为一个总秒数。不能把这些分支概括为对完整剩余时长的大小判断。

## 示例

在启用重置计时且剩余时间不足一小时的地图中：

```pascal
Str := callfunc('getremainmaptime 5 0');
if Str = 'true' then begin
    print('say 本轮即将结束，暂不进入');
    exit;
end;
```

这个条件在剩余分钟分量不大于 5 时成立；不足一分钟时，由于秒阈值为 0，也返回 `'true'`。在不重置的地图上同样返回 `'true'`，所以不能不核对地图条件就照搬示例。

源码依据：[BasicObj.pas](../../help/TGS核心源码/BasicObj.pas) 的 `SGetRemainMapTime`、[uScriptManager.pas](../../help/TGS核心源码/uScriptManager.pas) 的 `CallFunction`。

相关接口：[checkentermap](checkentermap.md)、[getusercount](getusercount.md)。
