# 配置编号、索引与固定容量

本页汇总地图、脚本、任务、属性表及奖励配置的编号规则，供新增记录、整理配置和调整编号时查阅。路径均相对 TGS 程序目录；不涉及某台服务器的投放规划或玩家数据。

规则依据本资料库的[公开源码镜像](TGS核心源码/)及对应调用流程。存在版本差异的地方单独说明；新增配置前仍须核对目标程序，不能把某一版本的容量当作通用能力。源码入口及版本核对方法见[公开源码与引用说明](source-reference.md)。

## 先区分编号的含义

| 类型 | 判断依据 | 调整时的重点 |
| --- | --- | --- |
| 显式 ID | 把字段转成数值，再按值查找，如 MapID | 唯一、取值范围及所有引用；通常不要求连续 |
| 行位置索引 | 按加载顺序加入列表，再用下标取值，如脚本、装备附加属性 | 保留行序；修改首列数字不一定改变真正索引 |
| 名称键 | 按内部名称或名称组合查找，如物品、怪物、MagicParam | 内部名称与显示名称分开；数字首列可能只是表内记录键 |
| 固定枚举或槽位 | 代码中的常量、数组、固定文件名/列名 | 不能只加行、加列或加文件扩容 |
| 持久化编号 | 存入角色、装备或其他运行记录 | 静态引用更新不等于历史数据同步迁移 |

`Name`、`No`、`ID` 这些列名不能单独证明编号的含义。表内记录键应非空且唯一；同一数字出现在不同表中不一定冲突。

## 地图、脚本与任务

| 配置或接口 | 实际规则 | 维护注意 |
| --- | --- | --- |
| [Map.SDB](Init_map.sdb.md) 的 MapID | 唯一，0～255，允许跳号 | 运行时 Integer 不改变角色存档 Byte 上限；另有固定地图用途和行序依赖，见下文 |
| `Setting/CreateMonsterN`、`CreateNpcN`、`CreateDynamicObjectN`、`CreateMineObjectN`、`CreateVirtualObjectN` | N 为地图 ID，不是第几个文件 | 改图号须同步文件后缀；无编号文件或 `@` 前缀备份不因放入目录就自动加载 |
| [Script.SDB](Script.md) | 从 1 起按登记行顺序寻址；0 表示不绑定 | 缺失文件保留空脚本槽；维护时仍保持 Name=1、2、3……与行序一致，不适合跳号或删除中间记录 |
| 各表 Script、[NPC 投放](CreateNpc.SDB.md)的 Notice | 引用实际脚本索引 | Notice 在这里是脚本号，不是提示文本编号；0 或已登记正整数，不使用负数 |
| [PowerLevel](Init_PowerLevel.sdb.md) 的 Name | 转整数后写入 `[编号-1]`；加载和查询的有效编号为 1～99 | 已配置等级从 1 连续；遇空项会停止境界判定。不能使用 0；此范围不代表任意扩展境界都已配套客户端 |
| [getevent](../callfunc/地图场景函数/getevent.md)、[getsetevent](../callfunc/地图场景函数/getsetevent.md) | 角色事件标记 0～19，共 20 个 | 可只使用部分，但同一角色的所有脚本共享这些编号；已用编号不能随意改成另一任务 |
| [setevent](../callfunc/地图场景函数/setevent.md) | 支持此别名的版本，与 getsetevent 共用同一组标记 | 旧程序须先确认接口存在；不是另增 20 个标记 |
| CurrentQuestNo、CompleteQuestNo、FirstQuestNo 与 [QuestSummary](Init_QuestSummary.sdb.md) | 存档整数状态；摘要按 QuestNum 等值查找，不要求连续 | 不是每个任务一份独立状态；旧脚本可能使用大小比较，不能只替换等号中的编号 |
| [Event.SDB](Init_Event.SDB.md) 的 ParamCode → [EventParam.SDB](Init_EventParam.sdb.md) 的 Code | 有效事件连接使用 1～255，可跳号；0 表示未找到事件 | 部分成员虽为 Word，事件查询返回值和执行参数却为 Byte；与角色事件标记不是同一编号系统 |
| [AreaData](Init_AreaData.sdb.md) 的 Index | 0～255，与 SMA 区域字节对应，可跳号 | 不是地图号；50～59 有门派石相关固定用途，不能只改文本表而不管区域数据 |
| [Arena](Init_Arena.sdb.md) | 旧擂台按 0 起始的加载行位置使用 | 首列即便写 1、2，调用仍对应 0、1；getintoarena 的参数不是 MapID |
| [BattleMap](Event.md#battlemapsdb) | 按 MapID 筛选后取前两条作为双方 | 同图必须至少两条有效记录，多配不会自动增加第三队；No 不要求连续，双方行序有意义 |
| 地图、怪物等 GroupKey | 阵营标签；0 为无分组 | 同值可以有意表示同阵营，不要求全表唯一；战斗传递存在 Word 字段，配置不得超出 0～65535 |
| [PosByDie](Init_PosByDie.sdb.md) | 按 Server 查询 DestServer | 两个字段都是地图号；首列不必连续。同一 Server 多条记录并不会形成随机复活点，先命中者生效 |

### 地图 0、1 与表中位置

- 地图 0 是有效主键，源码还有按 `ServerID=0` 判断的新手村纸条限制；改显示名称不会改变此判断。不能反过来认为所有新手村功能都由编号 0 自动决定。
- 地图 1 被登录位置回退、聚贤庄等流程直接引用，不能只因重新分类就随意改号。
- 旧比武招亲的 `TArenaObject` 多处调用 `GetManagerByIndex(1)`，取的是**地图表第二条记录**，不是按 MapID=1 查找。保留第二条为长城以南，不能把地图表任意按名称排序。
- MapID=0 合法，不代表每个关联字段的 0 都指向它：SubMap 中 0 是空槽，MotherMap=0 表示无母地图。

依据：[uManager.pas](TGS核心源码/uManager.pas) 的 `LoadFromFile`、`GetManagerByServerID`、`GetManagerByIndex`、`Regen`；[UUser.pas](TGS核心源码/UUser.pas) 的 `SaveUserData`、`InitialLayer`；[uArena.pas](TGS核心源码/uArena.pas)；[uZhuang.pas](TGS核心源码/uZhuang.pas)。存档范围详见 [Map.SDB](Init_map.sdb.md#地图编号与角色存档上限)。

### 脚本顺序与文件存在性

加载器不把 Name 建成独立数字字典，而是按登记行顺序建立 DataList，调用时访问 `Items[编号-1]`。例如把第二条的 Name 改成 100，不会使这份脚本成为 100 号。缺失文件会记录日志并保留没有事件处理函数的空脚本槽，后续编号不前移；非正数或超出列表的调用不执行脚本。

新增优先末尾追加。停用旧逻辑时可以保留登记与可加载的空实现，避免删除中间位置。改文件名时同步 FileName，并保持位置和引用不变；另需留意 `绣球.txt` 的文件名特判，它会把首列数值记为 MarryBallID。

依据：[uScriptManager.pas](TGS核心源码/uScriptManager.pas) 的 `LoadFromFile`、`CheckScriptEvent`、`CallEvent`。详细流程见 [Script.SDB 与脚本入口](Script.md)。

### 角色事件标记不是任意任务号

这 20 个标记随角色保存，不因重登自动清空。超出 0～19 时，getevent 返回 `'1'`，getsetevent/setevent 返回 `'0'`，可能表现为“已完成”或“无法设置”，不能依赖报错发现误配。参数转换失败还可能按编号 0 处理，不能用空参数代表无标记。

新增用途应维护部署自己的编号登记；改号前检查已有角色保存的含义。Event.SDB 的 ParamCode、Map.SDB 的 EventID（年龄分流目标地图）和任务状态字段均不与这组编号互通。

## 职业、装备与武功表

| 配置 | 真正的索引与范围 | 维护注意 |
| --- | --- | --- |
| [JobGrade](Init_JobGrade.sdb.md) | Grade=1～6 | 依 Grade 而非首列名称/行序入数组；增加第七行不能扩展职业等级 |
| [JobTalent](Init_JobTalent.sdb.md) | ItemGrade=1～10 | 与物品 Grade 配套，不能自行重新排列等级含义 |
| [JobUpgrade](Init_JobUpgrade.sdb.md) | Upgrade=1～4 | 与装备段数配套，增加“5段”记录不会扩容 |
| [AdditionalAttrib](AdditionalAttrib.md) | 固定 A～E、1～4 文件；文件内第 1 行对应 AddType=1 | AddType=0 无附加，存储字段为 Byte；行内 Name 不决定编号。重排会改变已有装备的解释 |
| [AddAttribProbability](Init_AddAttribProbability.sdb.md) | 行位置对应附加编号 | 与附加属性表、MaxRange 配套，不能单独按名称或概率排序 |
| [AddAttribGrade](Init_AddAttribGrade.sdb.md) | 第 1～10 行写入 GradeData[1..10] | 最多 10 行；Name 不决定目标槽位，超出部分记录日志并忽略 |
| [ConsumeEnergy](Init_ConsumeEnergy.sdb.md) | 行位置写入数组 0～10，再按元气区间匹配 | 最多 11 行；区间重叠时先后顺序有意义，不是任意长度的配置列表 |
| [AM&WHRelation](Init_AM_WHRelation.sdb.md) | 7 行 × 6 列，实际下标为 0～6、0～5 | Armor1 对应第 0 行，WindOfHand1 对应第 0 列；不能用列名数字代替实际下标 |
| [AddDamage](Init_AddDamage.sdb.md)、[AddArmor](Init_AddArmor.sdb.md)、[AddPalmDamage](Init_AddPalmDamage.sdb.md) | StartSkill～EndSkill 覆盖数组区间，不按 Name 顺序编号 | 重叠区间后写覆盖前写，缺口不自动插值；还须遵循加载端与调用端的等级边界 |
| [BestMagic1Cycle](Init_BestMagic1Cycle.sdb.md)～[3Cycle](Init_BestMagic3Cycle.sdb.md) | 文件尾数固定为 1、2、3；内部层次下标 0～2；行按武功内部名查询 | 仅增加 4Cycle 文件不会支持第四层 |
| [NeedStatePoint](Init_NeedStatePoint.sdb.md) | 前两条记录的行位置 | 对应两次升级所需点数；首列数字不能改变目标层次，后续行不继续读取 |
| [BestMagicStateData](Init_BestMagicStateData.sdb.md) | 状态名称键 | 不是顺序编号，必须匹配查询名称 |
| [MagicParam](Init_MagicParam.sdb.md) | ObjectName + MagicName 组合 | 数字首列只是表内记录键；组合键应唯一，内部名称必须与对象和技能一致 |

上述加载与查询见 [svClass.pas](TGS核心源码/svClass.pas) 的 `TJobClass`、`TItemClass`、`TAddAttribClass`、`TMagicClass`、`TMagicCycleClass`、`TMagicParamClass`。

### 防止固定数组越界

- PowerLevel 只加载编号 1～99；0、负数、非数字或超出上限的记录写日志后跳过。合法编号区间不等于可以留空洞，CalcPowerLevel 遇到第一个空名称就停止。
- ConsumeEnergy、AM&WHRelation、AddAttribGrade 按文件行数写固定数组，分别最多 11、7、10 行。超过容量时记录日志并停止读取该表后续行；不会自动扩容，发布前仍须修正多余配置。
- AM&WHRelation 直接使用护体与掌法的 MagicRelation 作下标，没有减一。护体必须落在 0～6、掌法在 0～5。`GetValueFromRelationTable` 任一参数越界均返回 0，不进行查表；这只是安全回退，不代表非法系别是有效配置。
- 普通武功关系索引只登记 0～6；掌风索引只登记 0～5，`SetMysteryMagicIndex` 忽略范围外的编号。配置须以实际数组容量为准。

这些是配置和维护边界，不证明任意具体玩家报错由此导致。相关数组与函数见 [svClass.pas](TGS核心源码/svClass.pas)、[uUserSub.pas](TGS核心源码/uUserSub.pas)；掌风调用见 [UUser.pas](TGS核心源码/UUser.pas) 的 `CommandAttackedMagic`。

## 奖励池、采集及名称型资料

| 配置 | 编号规则 | 关联说明 |
| --- | --- | --- |
| [RandomEventItemN](Event.md#randomeventitemsdb) | 文件尾数 N 是池索引；有效范围以目标版本容量为准 | 公开镜像声明/初始化 0～2，却加载 0～3，存在越界矛盾；不能写成通用支持 0～9。统一扩为 10 组的版本才可使用 0～9，须同时核对声明、创建/释放、加载和查询。行内 No 不要求连续，但累计概率按行序判定 |
| [QuestNotice](QuestNotice.md) | getquestitem 的 1～7 为固定类型 | 1 新手奖励、2 第一阶段奖励、3 第二阶段奖励、4 金币、5 十字镐、6 属性牌、7 武器；不是任意文件编号 |
| [EventItem1～4](Event.md) | 固定四份材料兑奖表，内部下标 0～3 | GetEventItem 按总值 1～14、15～29、30～40、41～45 选组，不是直接把参数当文件号 |
| [MineObjectShape](Init_MineObjectShape.sdb.md) | 按 Shape 查找，可跳号 | Name 不是图像编号；资源号须有效，避免同 Shape 多条造成查找歧义 |
| [MineObjectAvail](Init_MineObjectAvail.sdb.md)、[矿点投放](CreateMineObject.sdb.md) | GroupName、地图号、矿物/位置名称关联 | 不应把位置名称视为无意义行号，矿区还有已用/未用位置管理 |
| [ToolRate](Init_ToolRate.sdb.md) | Mine + Tool 组合；产物槽 1～10 | ItemN 与 SFreqN/EFreqN 对应，不能各自独立排序；带逐产物等级限制的版本还要同步同槽等级条件 |
| [NpcSetting](NpcSetting.md) | 模板指定文件、指令字符串、物品内部名 | 不存在统一的“从 1 连续”要求；数字首列不等于全局 NPC 编号 |
| 可选 NpcFunc/NpcFunc.SDB | 首列数值转换为 Index，再按值查询 | 可以跳号，不是按行位置。只有相应加载与调用流程存在时才有意义 |

Item、Monster、Npc、DynamicObject、Magic、MineObject、ItemDrug、SmeltItem 等主体资料主要按**内部名称**关联。显示名称、Shape 与内部名称不能互相替代。

普通怪物/NPC 投放的数字首列主要用于读取该行，实际模板由 MonsterName/NpcName 指定；但 GateName、物件 Name、采集位置名称等还可能被脚本或运行记录引用，不能把所有 Name 一概当作可任意重编号的序号。

## 固定槽位、枚举与资源编号

| 配置 | 容量或约定 |
| --- | --- |
| Map.SubMap | 最多 10 项，0 是空槽；超出部分记录日志并忽略 |
| Map.EventX/EventY | 各最多 2 项，同一下标组成一对坐标 |
| 普通 Gate.RandomPos | 最多 10 组 X/Y，必须成对 |
| GateEx 非随机目标 | 固定读取 TargetServerID0～4、TargetX/Y0～4 |
| GateEx.RandomCount | 内部 TargetData 下标 0～11；启用随机时使用 1～12 个展开槽，范围外记录日志并跳过该传送门 |
| GateEx.RandomTotal | 控制非首目标的循环取列；不是独立于实际目标列的任意数量。当前表头提供 0～4，目标列须齐全 |
| MagicParam / EventParam | NameParam1～5、NumberParam1～5，参数含义由技能/事件决定 |
| 动态物件动画 | 固定 SStep0～2、EStep0～2 三组状态帧 |
| Arena 参赛落点 | M1～M8，不会因新增 M9 列而扩容 |

随机传送第 0 组目标单独占一槽，其余目标按 1～RandomTotal-1 循环填充，因此 RandomCount 不必等于不同目的地的数量。完整字段说明见 [CreateGateEx](CreateGateEx.SDB.md)，传送类型区别见[地图传送机制总览](Teleportation.md)。

Kind、Attribute、Function、WearPos、JobKind、RoleType 等是代码定义的枚举，不是按配置记录数递增的编号；地图 Attribute=5 与 8 不能相加成 13 来组合效果。MagicType 则用 `div 100` 与 `mod 100` 分离武功类别和类型，不能当普通连续 ID。

Shape、WearShape、特效和音效号属于不同资源命名空间。物品 Shape 为 Word、WearShape 为 Byte，二者范围不同；数值能装入字段也不代表客户端存在对应素材、动作或帧。查阅[常量索引](constants/README.md)、[物品表](Init_item.sdb.md)及[协议定义](deftype.pas)。

## 调整编号的检查清单

1. 先查加载和使用两端，确定是显式 ID、行位置、名称键、枚举还是资源号。
2. 核对运行时、协议、存档的字段宽度，以整条链路中最窄的有效范围为准。
3. 行位置型数据保留原位置，优先末尾追加；不为排版整齐重排脚本、附加属性或旧擂台记录。
4. 地图改号同步所有传送目标、复活/重登/Event 位置、SubMap/MotherMap、战场、传送物品、采集配置、脚本参数及按图号命名的投放文件。
5. 检查历史角色位置、任务标记、装备 AddType 等持久数据；静态配置正确不等于旧记录已迁移。先备份并制定迁移安排，不直接批量猜测旧值含义。
6. 区分 0 是有效编号、空槽、默认值还是无绑定；防止空字段或转换失败意外落到编号 0。
7. 检查键唯一性、连续性、文件存在性、固定数组容量及组合键。不能仅凭“启动没有报错”证明安全。
8. 验证正常查询、未绑定、非法编号、保存重登等相关路径；离线检查与游戏实测分别记录。
