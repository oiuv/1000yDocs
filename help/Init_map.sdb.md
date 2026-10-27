# MAP.SDB

`Init/MAP.SDB` 定义每张地图的资源、规则与刷新设置。`TManagerList.LoadFromFile` 按记录索引创建 `TManager`，加载 `Smp` 障碍数据及各类对象列表。这里的 `MapID` / `ServerID` 是地图管理器编号，不等于独立的 TGS 进程。

本页区分“实际读取并使用”“仅加载”和“未读取”字段，不能根据表头名称推断功能已经实现。布尔值按表内 `TRUE/FALSE` 配置；时间字段除另有说明外为 `mmAnsTick`，正常倍率下 100 tick 约 1 秒。

加载依据：[uManager.pas](TGS核心源码/uManager.pas) 的 `TManagerList.LoadFromFile`。空间与刷新流程见 [地图、视野与对象生命周期](TGSWorld.md)。

## 地图编号与角色存档上限

**当前存档格式要求地图编号唯一且在 0～255 之间。** 编号不必连续，0 是有效地图编号，不代表空记录。地图资源文件名不必与编号相同，但传送、刷怪／NPC 投放、脚本、复活及重登位置必须引用正确编号；不能仅修改地图表中的主键。

地图加载器将编号读取为 `Integer`，但角色存档 `TDBRecord.ServerId` 是 `Byte`。`TUser.SaveUserData` 直接赋值，重登时再用该存档字段查找地图。关闭范围检查（`-$R-`）时，超出范围的正整数只保留低 8 位，例如 256 保存为 0、257 保存为 1、999 保存为 231；开启范围检查也只是产生越界异常，并不会扩大存档容量。地图能够加载或现场传送成功，不能证明断线、保存和重登正确。依据：[UUser.pas](TGS核心源码/UUser.pas) 的 `SaveUserData`、`TUserList.InitialLayer`，以及 `Common/uDBRecordDef.pas` 的 `TDBRecord` 定义。

0 在不同字段中含义不同：地图主键允许为 0，源码还将其用于新手村纸条限制；`SubMap` 的 0 项会跳过，`MotherMap=0` 表示无母地图。因此不要随意更换既有编号，或把地图 0 直接作为这些关联字段的普通目标。

调整编号前应让相关角色转移到编号不变的安全地图并保存，停服备份、核对离线存档后再同步配置。已经被截断的编号无法单凭该字段还原原地图，不能按截断结果批量迁移，以免误改原本就位于该地图的角色。扩大编号范围涉及存档及相关读写链路，不能只把地图管理器字段改大。

## 地图资源与声音

| 字段 | 类型 | 实际作用 |
| --- | --- | --- |
| `MapID` | Integer（存档限 0～255） | SDB 记录索引，转整数后成为 `Manager.ServerID`。编号应唯一；角色存档字段为 Byte，不能按运行时 Integer 的范围配置；源码将编号 0 用于新手村纸条限制 |
| `SmpName` | String | 服务端从 `./Smp/` 加载的通行与障碍数据文件名 |
| `MapName` | String | 发给客户端的 `.map` 地图布局文件名 |
| `TilName` | String | 发给客户端的地砖图库文件名 |
| `ObjName` | String | 发给客户端的物件图库文件名 |
| `RofName` | String | 发给客户端的屋顶/顶层图库文件名 |
| `MapTitle` | String | 地图标题；部分脚本按标题查找地图，应避免重名 |
| `SoundBase` | String | 背景音乐基名；进入地图时非空才追加 `.wav` 发送 |
| `SoundEffect` | String | 地图周期音效基名；与 `EffectInterval` 配合，发送时追加 `.wav`。不是整数字段 |
| `EffectInterval` | Integer | 周期音效间隔；由非空 `SoundEffect` 启用。源码不检查间隔必须为正，0/负值可能每轮地图更新都发送音效，不应用来关闭声音 |
| `SoundStart`、`SoundEnd` | String | 已加载到地图成员；当前地图运行逻辑未见消费，不等同于怪物/武功表中的同名音效字段 |
| `boDark`、`boRain` | Boolean | 进入地图时分别写入 `SM_NEWMAP.rboDark/rboRain` 发给客户端；与服务端 `boWeather` 不同 |

依据：[uSendCls.pas](TGS核心源码/uSendCls.pas) 的 `TSendClass.SendMap`、[uManager.pas](TGS核心源码/uManager.pas) 的 `TManager.Update`。

## 武功、装备与药品限制

| 字段 | 类型 | 实际作用 |
| --- | --- | --- |
| `boUseBowMagic` | Boolean | 是否允许弓术、投法及对应武器 |
| `boUseMagic` | Boolean | 是否允许 `MAGICCLASS_MAGIC`，即普通武功；不是全部武功的总开关 |
| `boUseRiseMagic` | Boolean | 是否允许上层武功 |
| `boUseWindMagic` | Boolean | 是否允许掌法（`MAGICCLASS_MYSTERY`） |
| `boUseBestMagic` | Boolean | 是否允许绝世武功 |
| `boUseBestSpecialMagic` | Boolean | 是否允许 `MAGICTYPE_BESTSPECIAL` 招式武功 |
| `boUseGuildMagic` | Boolean | 是否允许 `rGuildMagicType=1` 的门派武功 |
| `boUseEtcMagic` | Boolean | 是否允许 `MAGICTYPE_ECT` 辅助武功 |
| `boUsePowerLevel` | Boolean | 是否允许通过境界窗口调整境界；不是经验倍率 |
| `boUsePowerItem` | Boolean | 是否允许 `rboPower=true` 的装备；装备及武功自动换武器路径都会检查 |
| `boCanChangeMagic` | Boolean | 限制武器攻击类型变化及武功自动换武器路径；不是无条件禁止所有同武器武功切换 |
| `boUseDrug` | Boolean | 是否允许使用 `ITEM_KIND_DRUG` 药品 |
| `boUseChemistDrug` | Boolean | 为假时拒绝 `ITEM_SPKIND_DONTDRUG` 类药品；也参与炼丹属性药的效果处理，不等于普通药品总开关 |
| `UseDrugName` | String | 冒号分隔，最多 5 个药品名；仅门派大战、竞技场地图（Attribute 7、9）按此白名单允许服药，还需通过前两个药品开关 |
| `boNotUseHideItem` | Boolean | 为真时拒绝 `ITEM_KIND_HIDESKILL` 隐身物品 |

依据：[uUserSub.pas](TGS核心源码/uUserSub.pas) 的 `THaveItemClass.DblClickProcess`、`TWearItemClass.AddItem/ChangeItem`、`THaveMagicClass.DblClick*MagicProcess`；[UUser.pas](TGS核心源码/UUser.pas) 的 `TUser.MessageProcess`（`WINDOW_POWERLEVEL`）。传送门还会检查目标地图的部分武功/装备限制，见 [BasicObj.pas](TGS核心源码/BasicObj.pas) 的 `TGateObject.FieldProc`。

## 地图交互与玩家状态

| 字段 | 类型 | 实际作用 |
| --- | --- | --- |
| `boGetExp` | Boolean | 登录、换图时赋给属性类与武功类的 `SetAddExpFlag`，控制对应经验增长路径；不设置倍率 |
| `boBigSay` | Boolean | 控制大喊/全服喊话命令分支，不是普通聊天总开关 |
| `boMakeGuild` | Boolean | 门派石创建、移动等路径检查地图是否允许，不是简单显示开关 |
| `boItemDrop` | Boolean | 是否允许玩家从物品栏拖到地面；不是怪物死亡掉落的总开关 |
| `boNotDeal` | Boolean | 为真时拦截多条攻击/受击及物品转移路径，包括丢弃、交换等；不能只解释为“禁止交易” |
| `boPosDie` | Boolean | 在复活处理分支中查询 `PosByDie` 并转移位置；门派大战/竞技场有优先的复活分支，不是死亡瞬间统一传送 |
| `boHit` | Boolean | 决定部分玩家受击消息使用 `SendLocalMessage` 还是 `Phone.SendMessage` 分发；为假不等于禁止攻击或不扣活力 |
| `boPrison` | Boolean | 标识流放地图；囚禁玩家登录时定位到首个此类地图，并影响纸条等限制 |
| `boSetGroupKey` | Boolean | 换入地图时强制设置 `GroupKey` 并取消安全状态；为真时也不执行普通“设定团队”命令分支 |
| `GroupKey` | Integer | 上项启用时使用的团队标识；不是地图编号 |
| `boPK` | Boolean | 维护地图玩家列表，供怪物 `GetRandomUser` 选取追击对象；不是通用“允许玩家互杀”开关 |
| `boNotAllowPK` | Boolean | 允许无团队角色进入安全状态及“解除团队”；已有团队、战场规则仍另有判断，不能理解为全图绝对免伤 |
| `boPick` | Boolean | 采矿开关，矿点的 `FM_PICK` / `FM_DECDEPOSIT` 检查此值；不是地面物品拾取开关 |
| `boShop` | Boolean | 已加载；唯一摆摊命令消费分支被整块注释，当前不能靠此值开放摆摊 |
| `boShowMiniMap` | Boolean | 为真取动态物件位置，为假取 NPC 与传送门位置；两条分支都可追加队友位置。为假且最终字符串为空时不发小地图信息 |

依据：[UUser.pas](TGS核心源码/UUser.pas) 的 `TUserObject.CommandHited`、`TUser.UserSay/DragProcess/MessageProcess/Update`、`TUserList.InitialLayer`；[uManager.pas](TGS核心源码/uManager.pas) 的 `AddUser/DelUser/GetRandomUser`；[uMonster.pas](TGS核心源码/uMonster.pas) 的 `TMonster.Update`；[BasicObj.pas](TGS核心源码/BasicObj.pas) 的矿点消息处理；[uGuild.pas](TGS核心源码/uGuild.pas) 的 `TGuildObject.CreateStone/MoveStone`。

## 属性地图与天气

| 字段 | 类型 | 实际作用 |
| --- | --- | --- |
| `Attribute` | Integer | 地图类型，见下表；不同功能分别按类型判断，不是统一执行所有类型效果 |
| `boChangeLife` | Boolean | 是否执行冰、火、补给、境界地图的周期属性变化 |
| `ChangeDelay` | Integer | 上述变化的 tick 间隔 |
| `ChangePercentage` | Integer | 冰地图每次减活力的比例，计算为 `(活力上限 div 100) * ChangePercentage` |
| `ChangeSize` | Integer | 火/境界地图每次减活力数，或补给地图每次增加活力、内功、外功、武功数 |
| `boWeather` | Boolean | 是否向此地图玩家发送服务端天气消息；还受 TGS 的 Weather 开关控制 |

| Attribute | 常量 | 实际规则摘要 |
| ---: | --- | --- |
| 1 | `MAP_TYPE_ICE` | `boChangeLife=true` 时按比例减活力；火属性装备可免除此项 |
| 2 | `MAP_TYPE_FIRE` | 同上，按 `ChangeSize` 减活力；持有水类容器物品或装备冰属性物品可免除此项 |
| 3 | `MAP_TYPE_FILL` | 持有补给物品（`FillItemCount<>0`）且启用属性变化时，周期恢复上述四项属性 |
| 4 | `MAP_TYPE_BATTLE` | 对战地图，参与战场人数、结算及团队限制等分支 |
| 5 | `MAP_TYPE_DONTTICKET` | 拒绝使用 `ITEM_KIND_TICKET` 传送物品 |
| 6 | `MAP_TYPE_KILLONLYONE` | 地图刷新倒计时剩余 30 秒时调用地图脚本 `OnEventTimer`；名称不代表引擎自动只允许击杀一只怪 |
| 7 | `MAP_TYPE_GUILDBATTLE` | 门派大战，使用战场复活与药品白名单等规则 |
| 8 | `MAP_TYPE_POWERLEVEL` | 境界低于 2 且启用属性变化时按 `ChangeSize` 减活力 |
| 9 | `MAP_TYPE_SPORTBATTLE` | 竞技场，使用战场复活与药品白名单等规则 |

天气使用服务器当前月份：触发天气时，1 月为雪；2 月、12 月由 `Random(10)` 的 0、1、2 选择雪，即 **30%**，其余为雨；3 至 11 月为雨。概率是在选择一次天气类型时应用，不是每轮玩家更新都重新抽取。依据：[SVMain.pas](TGS核心源码/SVMain.pas) 的 `TimerRainTimer`、`MRainClick`，以及 [UUser.pas](TGS核心源码/UUser.pas) 的 `TUserList.SendRaining`。

属性变化依据：[UUser.pas](TGS核心源码/UUser.pas) 的 `TUser.Update`；物品白名单与传送符依据：[uUserSub.pas](TGS核心源码/uUserSub.pas) 的 `THaveItemClass.DblClickProcess`。

## 刷新、脚本与登录位置

| 字段 | 类型 | 实际作用 |
| --- | --- | --- |
| `RegenInterval` | Integer | 地图整体刷新间隔，正值才自动刷新；例如 180000 tick 约 30 分钟。此类地图怪物死亡后走移除分支，等待整体重建 |
| `TargetServerID`、`TargetX`、`TargetY` | Integer | 地图刷新时的传出目标；也用于该地图重新登录的回退位置 |
| `SubMap` | String | 冒号分隔的子地图 ID；母图刷新时可把这些地图的玩家移到母图的 Target 位置。数组仅 10 项，加载循环无长度保护，不得超过 10 项 |
| `MotherMap` | Integer | 母地图 ID；非 0 时本地图刷新不执行自身 Target 转出分支 |
| `Script` | Integer | 地图脚本编号，绑定 `OnTimer`、`OnEventTimer`；地图 `OnTimer` 约每 6000 tick 调用一次，参数为空字符串 |
| `LoginServerID`、`LoginX`、`LoginY` | Integer | 普通玩家重新登录时的转入位置，仅 X、Y 都非 0 才生效；权限达到 100 的 GM 跳过这组普通位置重定向 |
| `boEvent` | Boolean | 启用登录时的年龄分流；仅当前面的 Login、定时刷新地图、PosByDie 分支都未选中时才检查 |
| `EventAge` | Integer | 与 `GetLevel(Light+Dark)` 的返回值比较，严格大于才分流；不是武功修炼等级 |
| `EventID` | Integer | 年龄分流的目标地图 ID |
| `EventX`、`EventY` | String | 各最多 2 个冒号分隔坐标；随机选同一下标组成 `(X,Y)`，不是随机矩形。两组必须配齐 |

刷新时先重置计时。只有 `SubMap` 第一项非 0 才遍历这 10 个子地图槽；自身玩家只有在 `TargetX>0`、`TargetY>0` 且 `MotherMap=0` 时才按 Target 转出。随后重载动态物件、怪物、NPC、虚拟物件、矿点，清空地面物品。不要把设置 Target 字段理解为无条件传送，也不要让玩家在刷新前继续依赖地面掉落。

登录位置不是地图出生点的简单覆盖：先处理囚禁状态；普通登录再依次考虑 Login 坐标、定时刷新地图 Target、`PosByDie`、Event 年龄分流。当前地图编号不存在则进入代码的回退地图分支。目标地图必须实际存在，坐标需合法。

`Attribute=6` 的 `OnEventTimer` 判断是“剩余时、分为 0 且秒为 30”；源码没有只执行一次的锁，脚本应自行避免重复发奖或重复生成对象。详见 [OnTimer](../procedure/OnTimer.md)、[OnEventTimer](../procedure/OnEventTimer.md)。

依据：[uManager.pas](TGS核心源码/uManager.pas) 的 `TManager.Update/Regen/SetScript`；[UUser.pas](TGS核心源码/UUser.pas) 的 `TUserList.InitialLayer`。

## 表头中未读取的字段

| 字段 | 当前状态 |
| --- | --- |
| `boFirstPickUp` | 当前地图加载器未读取，不能靠此字段配置掉落优先拾取 |
| `UseDay`、`StartHour`、`EndHour` | 当前地图加载器未读取，不能靠这些字段设置地图开放日期或时段；传送门开放时间使用独立配置 |

相关资料：[地图文件格式](MapFiles.md)、[普通传送门](CreateGate.SDB.md)、[扩展传送门](CreateGateEx.SDB.md)、[运行资源加载](RuntimeResources.md)。
