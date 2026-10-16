# CreateGate.SDB

传送门

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
| BelowEnergy / OverEnergy | Integer | 元气上限 / 下限：`Power >= BelowEnergy` 或 `Power < OverEnergy` 时拒绝进入 |
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
| GuildName | String | 限定门派名称，并进入所属门派列表 |

- Kind见下文详细介绍
- Kind为GATE_KIND_FIXPOSITION时TX和TY设置为0，调用BattleMap.sdb中的坐标，由ActiveInterval指定对战时间
- Shape 为item.atz中的形状，主要是8、69和70，也可以使用其它值
- X,Y设置为(0,0)，使用RandomPos指定坐标，随机坐标刷新时间由ActiveInterval指定
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
- OpenClock可设置开启时间在几点（最多5个），Kind为GATE_KIND_SPECIALTIME(用`8:30/10:30`指定时间)、GATE_KIND_FIXPOSITION、GATE_KIND_FIXTIME、GATE_KIND_SPORTSWAR(用`8:10:12:14`指定小时)
- MaxUser限制Kind为GATE_KIND_SPORTSWAR时指定活动人数上限

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
   GATE_KIND_SPECIALTIME   = 3;   # 传送门种类：特定时间开启的传送门（时间获取不对，1899/12/30）
   GATE_KIND_FIXPOSITION   = 4;   # 传送门种类：固定位置的对战传送门（MAP_TYPE_BATTLE）
   GATE_KIND_ORDERADDITEM  = 5;   # 传送门种类：过门后赠送物品（物品由AddItem参数指定第1、2名和3以后的奖励）
   GATE_KIND_LIMITUSER     = 6;   # 传送门种类：限制进入人数（固定上限10人，超过提示参赛人员已满，可设置RegenInterval）
   GATE_KIND_GUILDWAR      = 7;   # 传送门种类：门派对战，和4类似，但判断玩家门派（MAP_TYPE_GUILDBATTLE）
   GATE_KIND_FIXTIME       = 8;   # 传送门种类：只在特定小时开启
   GATE_KIND_SPORTSWAR     = 9;   # 传送门种类：竞技场战斗（炎黄版本）（MAP_TYPE_SPORTBATTLE）
   GATE_KIND_INTOZHUANG    = 10;  # 传送门种类：进入聚贤庄（炎黄版本）
```

扩展传送门使用另一套表头和加载器，参见 [CreateGateEx.SDB](CreateGateEx.SDB.md)。
