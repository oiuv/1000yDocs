# CreateGate.SDB

普通传送门配置。各种传送机制的选择及相互区别见 [地图传送机制总览](Teleportation.md)。

实际随包表头包含 38 个字段，加载器为 [BasicObj.pas](TGS核心源码/BasicObj.pas) 的 `TGateList.LoadFromFile`，进入检查位于 `TGateObject.FieldProc`：

| 字段 | 类型 | 作用 |
|------|------|------|
| Name | String/Integer | SDB 记录索引；运行对象名称实际读取 `GateName` |
| GateName | String | 门对象内部名称 |
| ViewName | String | 玩家可见名称 |
| Kind | Integer | 门类型，见下表 |
| boShow | Boolean | 是否显示门对象 |
| Shape | Integer | `item.atz` 外形编号 |
| X / Y | Integer | 门所在坐标；均为 0 时才解析 `RandomPos` |
| TX / TY | Integer | 目标坐标 |
| EX / EY | Integer | 条件失败时弹回坐标 |
| MapId | Integer | 门所属 Manager/地图服务器编号，用于查找对象管理器 |
| ServerId | Integer | 目标服务器/地图编号 |
| Width | Integer | 门作用范围 |
| LimitAge / OverAge | Integer | 年龄上限 / 年龄下限 |
| LimitPowerLevel | Integer | 进入后允许的最高境界 |
| NeedAge / AgeNeedItem | Integer | 直接进入年龄 / 可凭 `NeedItem` 补充判断的最低年龄 |
| BelowEnergy / OverEnergy | Integer | 元气上限 / 下限，数值为界面元气的 100 倍：`Power >= BelowEnergy` 或 `Power < OverEnergy` 时拒绝进入；0 不启用对应限制 |
| NeedItem | String | 进入所需物品，`物品:数量`，最多 5 组 |
| DelItem | String | 进入时尝试删除的物品，最多 5 组 |
| AddItem | String | `GATE_KIND_ORDERADDITEM` 奖励，最多 5 组 |
| boRemainItem | Boolean | 年龄不足而凭物品进入时是否保留 `NeedItem` |
| Quest / QuestNOtice | Integer / String | 特殊任务条件及失败提示 |
| RegenInterval / ActiveInterval | Integer | 重新激活间隔 / 激活持续时间，单位见下文 |
| EjectNotice | String | 弹回时的提示文字 |
| RandomPos | String | `X:Y` 坐标对，最多 10 组，仅当 X、Y 都为 0 时解析 |
| OpenClock | String | 按 `Kind` 解析的开放时间列表 |
| boAlarmRemainTime / AlarmNotice | Boolean / String | 是否广播剩余时间及格式字符串 |
| MaxUser | Integer | 竞技场人数上限；0 表示不按此字段限制 |
| script | Integer | `Script.SDB` 脚本编号；大于 0 时绑定 |
| GuildName | String | 限定进入门派；非台湾版本还将非空值登记为禁止新建的保留门派名，见下文 |

- Kind见下文详细介绍
- Kind为GATE_KIND_FIXPOSITION时TX和TY设置为0，调用BattleMap.sdb中的坐标；ActiveInterval指定入口开放时长，不是场内对战时长
- Shape 为item.atz中的形状，主要是8、69和70，也可以使用其它值
- X、Y 均为 0 时使用 `RandomPos`；周期换点的适用类型和间隔组合见下文“随机入口位置”
- LimitPowerLevel为境界限制，超过境界的玩家进入后境界被限制到该值
- NeedAge 为直接进入年龄，年龄大于或等于该值即通过此项；否则进一步判断 AgeNeedItem 条件，并由 boRemainItem 决定是否删除物品
- 如果没有设置NeedAge，只设置了AgeNeedItem是无效的
- 符合NeedAge条件还会继续判断以下年龄限制
  - LimitAge为年龄上限，超过该年龄无法进入
  - OverAge为年龄下限，低于该年龄无法进入
- NeedAge 为 0 时，NeedItem 逐项按名称检查是否存在，不核对配置数量，也不在此分支扣除物品；AgeNeedItem 不参与此分支
- NeedItem、DelItem、AddItem最多可设置5种
- DelItem 为通过前置检查后尝试删除的物品：数量大于 0 时按数量删除，数量为 0 时删除全部同名物品；删除返回值不作为进入条件
- AddItem为GATE_KIND_ORDERADDITEM的奖励设置
- Quest 值为 3 种：1=本地图存活怪物和 NPC 数均为 0，2=当前使用的步法修炼值至少 8501，3=年龄小于 20 岁。依据：[svClass.pas](TGS核心源码/svClass.pas) 的 `TQuestClass.CheckQuest1`、`CheckQuest2`、`CheckQuest3`
- RegenInterval为传送门重新激活间隔，数值直接与 `mmAnsTick` 比较；`mmAnsTick` 每 10 ms 增加 1
- ActiveInterval为传送门生效状态时间，常和RegenInterval配合使用
- OpenClock 按 Kind 解析，最多 10 个时间；小时与指定日期两种写法见下文
- MaxUser限制Kind为GATE_KIND_SPORTSWAR时指定活动人数上限

## 定时开放

时间取 TGS 所在系统的本地时钟，开关在服务器更新轮次执行；不依赖玩家客户端时钟。

### 每日整点入口：Kind=4、8、9

`OpenClock` 用冒号分隔小时，例如 `8:12:20` 表示每天 8、12、20 点整。有效值为 `0..23`，其中 `0` 表示午夜。最多读取 10 个位置；空项、非数字、越界小时不产生场次，整列为空时不开放。未配置的位置使用内部值 255，不等同于午夜。

`ActiveInterval` 单位为百分之一秒，必须大于 0。窗口包含开始时刻、不包含结束时刻，允许跨小时或午夜。例如 `OpenClock=20`、`ActiveInterval=3000` 表示每日 **20:00:00 至 20:00:30 前**可以入场；不是整分钟开放，也不是每隔 `RegenInterval` 开一次。持续时间达到一天时，存在有效场次的入口会持续开放。

加载后即按当前时间确定开关状态；在窗口外重启不会临时放行。启用 `boAlarmRemainTime` 后，从开场前 10 分钟开始按分钟公告，午夜场次在前一天预告；`AlarmNotice` 的 `%d` 为剩余分钟数。每个场次不要重复填写同一小时，避免重复公告或预备处理。

Kind=4 在开场前一分钟、目标地图无人时进行重生准备，开放时设置战斗开始标记。Kind=8/9 在场次开始时清零入口人数计数，不依赖公告开关；Kind=9 再按竞技场规则分队入场。

### 指定日期入口：Kind=3

`OpenClock` 用 `/` 分隔**完整日期时间**，最多 10 项；每项由 Delphi `StrToDateTime` 按服务器系统日期格式解析。例如服务器使用 `yyyy-MM-dd` 日期格式时，可以填写 `2026-10-28 20:00/2026-10-29 20:00`。日期分隔符不要使用 `/`，否则会与列表分隔符冲突。

只填 `8:30/10:30` 会得到没有当前日期的时间值，不能作为每日重复入口；每日整点开放应使用上面的 Kind。无效日期文本会导致加载转换失败，发布前须核对部署环境的日期格式。

每项从指定时刻开始开放十分钟，结束时刻不再放行；这一路径不使用 `ActiveInterval` 决定时长。开关每轮更新，公告最多每 20 秒检查一次，公告节流不延迟关门。剩余时间选择尚未开始的最近场次，按总秒数拆分时、分、秒；无未来场次时显示剩余 0 秒。

依据：[BasicObj.pas](TGS核心源码/BasicObj.pas) 的 `TGateList.LoadFromFile`、`TGateObject.Initial/Update/GetOpenTime`。

## 门派专属入口与建派名称限制

`GuildName` 填写允许进入的门派名称，不是传送点的 `GateName` 或 `ViewName`。**非台湾版本不得新建与已加载传送点 `GuildName` 同名的门派。**当前中国版适用这条规则。

加载普通传送表时，`NATION_VERSION <> NATION_TAIWAN` 分支将每条记录的非空 `GuildName` 加入 `OwnGateGuildList`。玩家输入门派名称后，即使通过重名、门主和副门主身份检查，命中这个保留名单仍会提示“无法成立门派。”；名称检查不要求该门派实际已经存在。

因此，新增门派专属入口应按以下顺序操作：

1. 先创建并命名门派，确认门派存档已正常保存。
2. 再将该名称配置到传送点的 `GuildName`，维护时重启 TGS 加载。
3. 如果先配置了入口却尚未建派，应临时移除所有使用该 `GuildName` 的传送记录并重启 TGS，完成建派、正常关闭保存后，再恢复记录并启动。

已有门派不会因这条新建名称校验而被删除。仅将 `boShow` 设为 `FALSE` 不能解除保留：登记名称发生在创建门对象之前，不以显示状态或是否成功找到地图管理器为条件。清空 `GuildName` 会解除该入口的门派限制，因此临时处理时移除整条入口记录更合适。只编辑文件不会即时清除内存中的保留名单。

台湾版本跳过上述名称保留名单登记；这不表示传送点的门派准入限制也被取消。依据：[BasicObj.pas](TGS核心源码/BasicObj.pas) 的 `TGateList.LoadFromFile`、`IsOwnGateGuild`，[uUserSub.pas](TGS核心源码/uUserSub.pas) 的 `TShowWindowClass.SelectInputGuildNameWindow`，以及 [uGuild.pas](TGS核心源码/uGuild.pas) 的 `TGuildList.AllowGuildCondition`、`AllowGuildName`。

## 随机入口位置

`RandomPos` 随机的是**入口位置**，不是目的地。`ServerId/TX/TY` 仍指定同一个目标；随机目的地使用 [CreateGateEx.SDB](CreateGateEx.SDB.md)。

### 配置要求

- `X=0` 且 `Y=0` 才读取候选位置。任一非零就按固定坐标初始化。
- `RandomPos` 使用 `X1:Y1:X2:Y2:...`，最多读取十组。解析遇到任一坐标为 0 就停止，后面的坐标也不再读取；必须至少有一组有效位置。
- 普通门使用 `Kind=0`、`RegenInterval=0` 和正数 `ActiveInterval`，可避免重新激活分支干扰换点计时。这里的 0 不表示关闭随机换点。
- 默认 tick 约为 10 ms，例如 `ActiveInterval=9000` 约为 90 秒；实际执行取决于更新轮次。不要填 0 或负数，它们会让换点条件持续满足，而不是关闭轮换。

以下只展示字段关系，不是一行可直接部署的完整 SDB；坐标须换成目标地图上的实际合法位置：

```text
Kind = 0
X = 0
Y = 0
RandomPos = 10:20:30:40:50:60
RegenInterval = 0
ActiveInterval = 9000
```

### 运行过程

1. 每条记录只创建一个 `TGateObject`。`Initial` 调用 `Random(RandomPosCount)` 选一个位置，然后注册到地图。
2. 到达 `ActiveInterval` 后执行 `EndProcess → Initial → StartProcess`，注销旧位置并重新抽取；不是另外生成多个同时有效的门。
3. 允许连续抽中同一个位置。候选列表中每一项等概率，但重复填写同一坐标会增加该位置的权重。
4. 换点按时间执行，不由玩家使用次数触发，也不保证轮流经过全部候选点。地图上的其它阵图不会仅因被列为候选而获得触发能力。

例如七座传送阵只有一个有效入口，应使用一条记录加七组候选坐标，而不是七条相互独立的门记录。

`Initial` 的随机选点不限定 `Kind`，但 `Update` 中上述周期换点路径仅位于 `Kind=0/1/2/6` 分支。不要将它直接套用到所有门类型。若同时设置正数 `RegenInterval`，到达重新激活条件时会先更新时间戳并跳过本轮换点；不能简单理解为“关闭多少秒，再随机开放多少秒”。

依据：[BasicObj.pas](TGS核心源码/BasicObj.pas) 的 `TGateList.LoadFromFile`、`TGateObject.Initial/Update/StartProcess/EndProcess`。

## 物品检查与扣除顺序

普通进入路径不是“所有条件成功后一次性扣款”：

1. `NeedAge>0` 且年龄不足时，只有年龄达到 `AgeNeedItem>0` 才检查全部 `NeedItem`。正数量按配置数量检查，非正数量按 1 检查；全部通过且 `boRemainItem=false` 时，先扣除其中正数量物品。达到 `NeedAge` 的玩家跳过这组物品检查与扣除。
2. 随后还会检查 `LimitAge`、`OverAge` 等条件。`NeedAge=0` 的按名称检查位于另一分支。
3. 再处理 `DelItem`，之后才检查 `Quest`，最终由对应 `Kind` 分支执行传送。

因此，后续年龄或任务条件失败时，前面已经扣掉的物品不会自动返还。`NeedItem` 和 `DelItem` 不能当成同一个参数，也不能把 `DelItem` 当作“必须拥有这些物品”的门票校验。配置时使用有效物品名和明确的正数量，避免无意组合收费与可能失败的后置条件。

## Kind

```
   GATE_KIND_NORMAL        = 0;   # 传送门种类：普通传送门
   GATE_KIND_BS            = 1;   # 传送门种类：对战服务器传送门（单独的服务器）
   GATE_KIND_DOOR          = 2;   # 传送门种类：门
   GATE_KIND_SPECIALTIME   = 3;   # 传送门种类：指定完整日期时间开启，持续十分钟
   GATE_KIND_FIXPOSITION   = 4;   # 传送门种类：固定位置的对战传送门（MAP_TYPE_BATTLE）
   GATE_KIND_ORDERADDITEM  = 5;   # 传送门种类：过门后赠送物品（物品由AddItem参数指定第1、2名和3以后的奖励）
   GATE_KIND_LIMITUSER     = 6;   # 传送门种类：限制进入人数（固定上限10人，超过提示参赛人员已满，可设置RegenInterval）
   GATE_KIND_GUILDWAR      = 7;   # 传送门种类：门派对战，和4类似，但判断玩家门派（MAP_TYPE_GUILDBATTLE）
   GATE_KIND_FIXTIME       = 8;   # 传送门种类：只在特定小时开启
   GATE_KIND_SPORTSWAR     = 9;   # 传送门种类：竞技场战斗（炎黄版本）（MAP_TYPE_SPORTBATTLE）
   GATE_KIND_INTOZHUANG    = 10;  # 传送门种类：进入聚贤庄（炎黄版本）
```

扩展传送门使用另一套表头和加载器，参见 [CreateGateEx.SDB](CreateGateEx.SDB.md)。
