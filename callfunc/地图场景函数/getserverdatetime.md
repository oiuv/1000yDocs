# getserverdatetime

读取服务器操作系统的当前本地日期时间。只读，无参数，函数名使用小写。

```pascal
Stamp := callfunc('getserverdatetime');
// 例如：2026_10_28_20_30_00
```

## 返回格式

固定为 `年_月_日_时_分_秒`，格式 `YYYY_MM_DD_HH_NN_SS`：年份四位，其余两位补零；小时使用 24 小时制，不包含毫秒、星期或时区偏移。采用公历，不计算农历节日。

一次调用只读取一次当前时间，日期和时分秒来自同一时刻。每次调用重新读取，不缓存。时间取决于运行 TGS 的系统时钟和时区，不是玩家电脑时间、UTC 或服务器运行时长；系统校时、改时区或夏令时可能使结果跳变，不应用它测量严格的经过时长。

## 适用上下文

NPC、怪物、动态对象、物品及地图脚本均可调用，不要求 `Self` 或 `Sender` 存在。此查询独立于人物和世界对象；其它 `callfunc` 原有的上下文限制不变。

本函数不改变 [OnTimer](../../procedure/OnTimer.md) 的参数或触发频率，也不会自动开启活动。定时脚本在活动时间段内会多次执行，发奖或开场逻辑仍需自行记录状态，避免重复执行。

## 拆分示例

以下为事件处理片段；声明 `Stamp`、`Rest`、`Year`、`Month`、`Day`、`Hour`、`Minute`、`Second` 为 `String`，并在脚本接口中声明已有的 `callfunc`、`GetToken` 和 `exit`：

```pascal
Stamp := callfunc('getserverdatetime');
if Stamp = '' then exit;
Rest := GetToken(Stamp, Year, '_');
Rest := GetToken(Rest, Month, '_');
Rest := GetToken(Rest, Day, '_');
Rest := GetToken(Rest, Hour, '_');
Rest := GetToken(Rest, Minute, '_');
Second := Rest;
```

需要数值判断时再对字段使用 `StrToInt`；只需要月份和日期时，拆到 `Day` 即可。

## 服务程序要求

须部署包含 `getserverdatetime` 分支的 TGS 程序；只更新脚本不能为旧程序增加接口。未知函数在旧程序中返回空字符串，示例因此先检查空值。无需更改客户端、网络协议或通信版本。

依据：[uScriptManager.pas](../../help/TGS核心源码/uScriptManager.pas) 的 `TScriptManager.CallFunction`。查询在人物上下文检查前执行，使用 `FormatDateTime('yyyy_mm_dd_hh_nn_ss', Now)` 返回结果。
