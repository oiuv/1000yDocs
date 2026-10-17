# 特殊物品内部名称与专用机制

部分物品由 TGS 按 `Item.sdb.Name` 识别，或由 `game.ini` 指定其内部名称。`Kind` 仍可能参与使用、穿戴、耐久和清理判断；不能只改类别或复制属性，就让另一件物品获得相同功能。

本清单以本资料库的[公开 TGS 源码](TGS核心源码/)及炎黄随包配置为基线，汇总直接写入程序的 **22 个物品内部名称**，另列可配置名称和未启用分支。不统计脚本、配方、任务表中的普通名称引用，也不把同名武功或场景对象当作物品。九转金丹的经验实现须特别区分，见下文。

## 1. 固定内部名称清单

下表的 `Kind` 是随包记录值；“条件与作用”说明实际名称分支，不代表该 Kind 的所有物品都有此效果。

| 内部名称 | Kind | 条件与作用 | 消耗与限制 |
|---|---:|---|---|
| `疾速靴` | 6 | 鞋子栏为此名称时，装备及移动路径可把角色切换为 `wfs_running`；脱下有恢复普通状态的处理 | 必须穿在鞋子栏，不是背包携带加速；不是给物品增加一个移动速度数值，也没有通过该分支学习或提升步法 |
| `九转金丹` | 36 | 双击名称分支启用耐久递减；攻击经验还存在同名专用判断 | 公开副本的经验判断有缺陷，不能将其描述为已经正确实现的个人限时双倍，详见第 3 节 |
| `噬月刀`、`犀牛王后角` | 6、28 | 受击者内部名为 `犀牛王1`（随包显示名“抓狂犀牛王”），攻击者装备噬月刀且背包通过王后角的 `FindItem` 检查时，令怪物当前活力为 0 | 位于命中检查之后；此分支只查王后角、不扣除它。不是对全部怪物增加伤害，也不是只要持刀就无条件击杀 |
| `补血石` | 17 | 拖放接收对象的相应分支，以目标坐标 `(nx, ny-5)` 的区域编号查找门派；要求使用者属于该门且为门主，调用 `AddGuildDurability(100000)` | 门石修复成功后删除传入物品；恢复不超过门石最大耐久，并受修复时间限制。不是玩家补活力药品，也不是直接丢地就修复 |
| `门派钱令` | 17 | 随包显示名为“钱令”。拖给同门门主时，在银行及成员条件满足后发起取款审批 | 发起分支要求银行余额大于 2000000、成员钱令记录大于 0、最后取款日期不是今天、累计借款小于 300000；并非直接把物品换成钱币 |
| `砸门锤` | 60 | 装备后可在静态对象点击路径设置目标；门石受击分支只接受该名称武器，并继续检查守城门派等限制 | 背包 `RepairItem` 和穿戴 `RepairItem` 均按名称拒绝修理；不能仅通过增加 `RepairPrice` 使这两条修理路径接受它 |
| 十种门石，见下表 | 9 | `Kind=ITEM_KIND_GUILDSTONE` 后再按内部名称匹配区域编号，进入创建门派流程 | 还要求境界编号不低于 5、当前没有门派，并检查区域是否占用等条件；消耗门石不等于门派创建已完整成功 |
| `聚贤庄进门券` | 5 | 普通入场分支按名称删除 1 张票，成功后累计票款 | 占领门派成员和争夺战参与方另有免票/准入分支；非参战方可能被拒绝，详见 [getintozhuang](../callfunc/地图场景函数/getintozhuang.md) |
| `SetValue` | 54 | 穿戴物品中恰好四件 `Attribute=5` 时，读取此记录并确认 `Kind=54`，叠加其 `rLifeData` | 非实物加成模板，不需要放进背包或发给玩家；不是套装装备各自的 Kind，也不是按名称识别“英雄”二字 |
| `钱币` | 3 | 门派银行存取、婚姻及部分门派业务直接按此固定名称取物品记录 | 通用货币路径另用 `INI_GOLD`；只修改 `game.ini.GOLD` 不能替换所有写死“钱币”的业务 |
| `金元` | 3 | 申请门派武功的入口和确认流程按此名称检查费用，成功流程扣除 40 个 | 3 类是数据维护中的货币分类约定，不是全部自动可付款，也不是任意同价值物品都可代替 |
| `喜帖` | 5 | 正常求婚成功时固定向双方各发放 10 张；比武招亲结束路径也引用此名称发放 | 这是固定奖励引用，不是喜帖本身的主动特效；比武招亲还依赖其擂主、参赛及婚姻状态，见 [Arena.sdb](Init_Arena.sdb.md) |

### 门石与区域编号

编号是 `Maper.GetAreaIndex` 返回的**地图区域标记**，不是地图 `ServerID`。

| 内部名称 | 区域编号 | 内部名称 | 区域编号 |
|---|---:|---|---:|
| `人龙石` | 50 | `玉犬石` | 55 |
| `巨象石` | 51 | `玉猿石` | 56 |
| `金鸡石` | 52 | `玉蟾石` | 57 |
| `花窟石` | 53 | `血狮石` | 58 |
| `河马石` | 54 | `血陵石` | 59 |

补血石的修复间隔也不是物品自身的药效冷却：`TGuildObject.AddGuildDurability` 按 `Now-AddGuildDurabilityTick` 计算，普通分支要求超过 7 小时；`NATION_TAIWAN` 分支把恢复量和经过时间都乘 2。实际采用哪一分支以编译地区定义为准。

源码入口：

- [uUserSub.pas](TGS核心源码/uUserSub.pas)：`THaveItemClass.PutOnScreenProcess/DblClickProcess/RepairItem`、`TWearItemClass.SetLifeData/RepairItem`、`THaveMagicClass.AddItemMagic/DelItemMagic/AddAttackExp`、`TShowWindowClass.SelectMarryAnswerWindow/MakeGuildMagic`。
- [UUser.pas](TGS核心源码/UUser.pas)：`TUser.MessageProcess` 的点击/移动处理、`TUser.UserSay` 的存钱及门派武功申请入口。
- [uSkills.pas](TGS核心源码/uSkills.pas)：`TLifeObject.CommandHited` 的犀牛王判定；[uGuild.pas](TGS核心源码/uGuild.pas)：门石 `FM_HIT`、`TGuildObject.AddGuildDurability`。
- [uZhuang.pas](TGS核心源码/uZhuang.pas)：`TZhuangObject.GetZhuangInto`；[uArena.pas](TGS核心源码/uArena.pas)：`TArenaObject.Update` 的喜帖发放。

## 2. 由配置指定名称的专用逻辑

以下名称来自随包 `game.ini`，不是写死在分支中的中文名称。配置值仍必须对应 `Item.sdb.Name`，不能用任意 `ViewName` 代替。

| 配置节和键 | 随包名称 | 专用判断 |
|---|---|---|
| `[STRINGS] GOLD` | 钱币 | `INI_GOLD` 用于通用金钱统计、交易及钱袋等路径；另有第 1 节的固定名称引用 |
| `[STRINGS] ROPE` | 追魂索 | `INI_ROPE`：拖给死亡玩家，接收方设置 `RopeTarget`、`RopeTick`；接收成功后发送方扣除 1 个 |
| `[STRINGS] WHITEDRUG` | 脱色药 | `INI_WHITEDRUG`：在染色分支中将药品 `Color` 加到目标原颜色值上；普通染剂则直接覆盖颜色。仍要求染剂 Kind、目标允许染色等条件，并非无条件重置为初始色 |
| `[JOB_SYSTEM] DEF_ITEMPROCESS1` | 溶华素 | `FindProcessDrug` 按内部名称识别为第 1 段加工试剂 |
| `[JOB_SYSTEM] DEF_ITEMPROCESS2` | 逐龙丹 | 同上，第 2 段 |
| `[JOB_SYSTEM] DEF_ITEMPROCESS3` | 太极液 | 同上，第 3 段 |
| `[JOB_SYSTEM] DEF_ITEMPROCESS4` | 桂圆丹 | 同上，第 4 段 |

加工还要满足目标、职业、材料及成功率等条件，不是放入名称匹配的试剂就必然成功。详见 [Kind 加工分支](constants/ITEM_KIND.md)、[game.ini](game.ini.md)。

源码：[svClass.pas](TGS核心源码/svClass.pas) 的 `LoadGameIni`；[uUserSub.pas](TGS核心源码/uUserSub.pas) 的 `PutOnScreenProcess`、`TWearItemClass.AddColorDrug`、`THaveJobClass.FindProcessDrug`；[UUser.pas](TGS核心源码/UUser.pas) 的 `FM_ADDITEM`；[BasicObj.pas](TGS核心源码/BasicObj.pas) 的地面物品染色分支。

## 3. 九转金丹的类别和经验实现

### Kind 36 承担的职责

`ITEM_KIND_CHARM=36` 的“护符类”是程序类别，不要求外观必须是符，也不要求一定增加活力上限。九转金丹的随包配置为：

| 字段 | 值 | 含义 |
|---|---:|---|
| `cLife` | 空 | 不提供此字段对应的活力上限加成 |
| `boDurability` | FALSE | 初始不执行耐久递减；双击专用分支可将其启用 |
| `Durability` | 120 | 初始耐久额度 |
| `DecDelay` | 6000 | 耐久递减间隔，单位为服务器 tick |
| `DecSize` | 1 | 每次耐久递减量 |

背包 `THaveItemClass.Update` 对启用计时且参数有效的 36 类递减耐久，到期删除物品。这适合承载有剩余使用时间的携带型物品，但**不会自动产生双倍经验**。`boDouble` 则是堆叠标志，与经验倍率无关。

36 类还有连带规则：脚本调用 [deletequestitem](../print/物品交易命令/deletequestitem.md) 会清理背包中的此类物品，不检查它是否启用或是否还有剩余耐久。把九转金丹改为其它 Kind 会改变这些类别行为，不能只因外观是丹药就改成普通药品 13 类；13 类使用的是独立的药效处理机制。

### 公开源码的经验分支边界

公开副本的 `DblClickProcess` 按名称设置 `rboDurability=True`；但 `AddAttackExp` 并未据此判断效果是否开启，而是只检查背包第 0 格是否名为九转金丹，然后执行 `ExpMulti := ExpMulti * 2`。该处不检查当前耐久，恢复倍率的语句也已注释。

因此，这份公开实现会重复修改进程级经验倍率，不能据双击提示承诺正确的个人双倍、到期停止、禁止叠加或离线恢复规则。部署时应核对实际服务端的经验实现；不要把“36 类负责计时删除”和“经验倍率正确受计时控制”当作同一件事。参见 [TGS 战斗与角色状态](TGSCombat.md#4-经验与奖励不是一条通用加值路径)。

源码：[uUserSub.pas](TGS核心源码/uUserSub.pas) 的 `THaveItemClass.DblClickProcess/Update/DeleteQuestItem`、`THaveMagicClass.AddAttackExp`；类别通用行为见 [护符类说明](constants/ITEM_KIND.md#护符类kind36)。

## 4. 婚礼宴堂花雨由婵娟花提供

**婚礼宴堂的常驻花雨由“婵娟花”NPC 实现，与玩家是否穿礼服无关；新郎套装、新娘套装不额外叠加花雨。** 礼服自身的穿戴、外观和属性配置保持正常，不把场景装饰效果附加到每个穿礼服的角色身上。

随包配置与代码的对应关系如下：

1. `Init/Map.sdb` 中地图 `89` 为“婚礼宴堂”。
2. `Setting/CreateNpc89.sdb` 在 `(47,53)` 配置内部名 `彼岸花1` 的 NPC；`Init/Npc.sdb` 将其显示名设为 `婵娟花`。
3. [uSendCls.pas](TGS核心源码/uSendCls.pas) 的 `TSendClass.SendShow` 按被显示对象的 `ViewName=婵娟花`，将特效编号设为 `8004`、类型设为 `lek_continue`，随角色显示包发送。该分支不检查玩家装备、婚姻状态或人数，也不限定地图编号；在其它地图放置同名 NPC，同样会触发。
4. 客户端把协议特效编号减 1，再按 `_%d.eft` 加载，因此 **8004 对应 `effect/_8003.eft`**。核对的炎黄资源是大范围飘落花瓣；`lek_continue` 使动画循环播放，具体画面以客户端资源包为准。

所以即使宴堂只有一名未穿礼服的玩家，也会看到这套场景花雨。`Script/婵娟花.txt` 的点击事件只负责说话，花雨不是点击或举行婚礼后才启动的脚本效果。客户端读取流程见 `CharCls.pas` 的 `TCharClass.AddEffect`、`TEffectClass.Initialize/SetFrame`。

[UUser.pas](TGS核心源码/UUser.pas) 的 `TUser.FieldProc` → `FM_SHOW` 中，新郎套装对应 `8005` 的整段代码包在 `{ ... }` 注释内，不参与执行；该编号对应 `_8004.eft`，不是当前婵娟花使用的 `_8003.eft`。维护时保持礼服分支禁用，不因“未穿礼服也有花雨”而误判装备条件失效或重新启用该分支。

## 5. 配置维护边界

- `Name` 是内部索引和判断依据；仅改 `ViewName` 或 `Desc` 不会改写上述专用条件。改内部名时必须连同源码、脚本、配方、任务及已有物品记录评估，不能只改表里一行。
- 复制同一物品的 Kind、外观、属性到另一个内部名称，不能自动复制名称专用效果；反过来，保留名称也不能绕过该路径的 Kind、槽位、地图或任务条件。
- `SetValue` 属于配置模板；钱币、金元、喜帖属于固定业务引用。它们与可主动使用的特殊道具分开理解。
- `新郎套装` 的注释块不计入 22 个生效名称；`绿绣球`、`红绣球` 在 `TArenaObject.AddMaster` 中取的是动态场景对象模板，也不因物品表有同名记录就计为物品特效。
- 脚本按名称发放、回收某物品，不表示该物品在 Pascal 中有专用效果；普通任务物品可通过脚本实现，不必新增硬编码判断。
