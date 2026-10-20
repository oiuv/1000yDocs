# 物品类型常量 (ITEM_KIND_*)

> 常量定义：[deftype.pas](../deftype.pas) 的 `ITEM_KIND_*` 段。行为依据见各节所列公开源码及方法名。

定义物品的功能和行为类型，对应 `Init/Item.sdb` 中的 `Kind` 字段。中文物品名以随包表的 `ViewName` 为准，内部键使用 `Name`；功能描述须结合使用分支，不能仅从英文常量名推断。

## 阅读与配置原则

- `Kind` 是行为分派条件之一，不是物品全部功能的定义。效果还取决于 `Attribute`、`SpecialKind`、穿戴位置、耐久字段、地图、物品名称和脚本。
- 按内部名称识别的疾速靴、九转金丹、门石等，以及配置指定名称的加工试剂，集中见[特殊物品清单](../SpecialItems.md)；不要把单件物品的专用条件推广为整类通用规则。
- 常量存在、表中有物品、源码注释描述用途，都不代表对应功能已经启用。下表区分有效处理与已注释/预留分支。
- “没有专用类型分支”不等于物品不能交易、用于配方或任务；这些通用路径可以按名称、标志位和配置处理。
- 可堆叠由 `boDouble` 等条件控制，不是“可以双击”。正常入包合并还比较名称、颜色、加工等级 `Upgrade` 和附加属性编号 `AddType`。任务类型 34、40 都不能只凭 Kind 判断是否堆叠。
- `boNotTrade`、`boNotExchange`、`boNotDrop`、`boNotSkill`、`boNotSSamzie` 等分别服务于特定操作检查，不能由类别名推导出所有操作权限。物品“唯一”也不是 36 类自带的全局约束。

依据：[uUserSub.pas](../TGS核心源码/uUserSub.pas) 的 `THaveItemClass.CheckAddable`、物品拖放/双击处理，以及 [Init_item.sdb.md](../Init_item.sdb.md) 的字段说明。

---

## 常量列表

下表覆盖 `deftype.pas` 定义的全部 **54 个** `ITEM_KIND_*` 常量；没有命名常量的表值另列于后文。

| 常量名 | 值 | 中文说明 | 详细说明 |
|--------|---:|----------|----------|
| `ITEM_KIND_NONE` | 0 | 未指定专用类型 | 无名槌、无名火炉等制造工具也使用 0；不是“空物品”，工具用途按其它字段/配置处理 |
| `ITEM_KIND_COLORDRUG` | 1 | 染色剂 | 拖到允许染色的穿戴物品或地面物品上使用；脱色剂名称另有配置分支，见下文 |
| `ITEM_KIND_BOOK` | 2 | 武功秘籍 | 双击按物品内部名称查武功记录，按武功分类学习；成功才消耗一个，并非任意书名都有效 |
| `ITEM_KIND_WEARITEM` | 6 | 通用穿戴物品 | 包括武器、衣服、护腕、鞋、帽、头发等；具体位置和攻击动作由穿戴/武器字段决定 |
| `ITEM_KIND_ARROW` | 7 | 箭矢 | 远程攻击的弓术分支从背包首个此类槽位扣一个，如箭、火箭 |
| `ITEM_KIND_FLYSWORD` | 8 | 投掷弹药 | 投掷分支从背包首个此类槽位扣一个，如飞刀、半月镖、仙鹤神针；不是御剑飞行 |
| `ITEM_KIND_GUILDSTONE` | 9 | 门派基石 | 拖到地面进入建派路径，检查区域、境界、已有门派、门石名称和占用状态；不是随地放置即建派 |
| `ITEM_KIND_DUMMY` | 10 | 门派娃娃 | 交给门派石，由门派对象按性别配置增加守卫 NPC，受守卫数量上限限制；成功后扣一个 |
| `ITEM_KIND_STATICITEM` | 11 | 临时静态场景物品 | 落地生成 `TStaticItem`，不是永久地图装饰；有独立存留时间，受攻击可缩短，见下文 |
| `ITEM_KIND_DRUG` | 13 | 药品 | 双击按内部名称查 `ItemDrug.sdb` 并进入药效槽；受地图用药限制及槽位容量限制，见药品子类型 |
| `ITEM_KIND_TICKET` | 18 | 传送卷轴 | 如回城卷轴；双击按 `ServerId/X/Y` 传送，受地图限制 |
| `ITEM_KIND_HIDESKILL` | 19 | 隐身符 | 双击成功后消耗一个并限时隐身；禁止隐身道具的地图拒绝使用，与 23 共用效果状态 |
| `ITEM_KIND_CANTMOVE` | 20 | 禁止交换的物品 | 如青龙牌；交换、交给其他角色的路径拒绝此类型，不表示不能放入背包 |
| `ITEM_KIND_ITEMLOG` | 21 | 福袋 | 双击建立一个个人储物房间；已有房间数达到 4 时拒绝，创建成功后消耗一个 |
| `ITEM_KIND_CHANGER` | 22 | 玫瑰脱色药类 | 随包物品名；没有有效双击分支，地面物品转换代码也已注释，不能认定脱色/变身已实现 |
| `ITEM_KIND_SHOWSKILL` | 23 | 透视符 | 双击消耗一个并限时显示隐身对象；与 19 互斥，到期撤销效果 |
| `ITEM_KIND_WEARITEM2` | 24 | 遮盖内衣外观的装备类型 | 如女子梅花战袍；穿在外衣槽 6 时隐藏内衣层 2、4，内衣物品未被删除；不是仅武器分类 |
| `ITEM_KIND_FOXMIRROR` | 25 | 妖华镜 | 随包正式物品名；当前背包双击分支无有效执行语句 |
| `ITEM_KIND_GUILDLETTER` | 26 | 门派推荐书预留类型 | 背包双击及交给门派对象的相关处理均已注释；随包物品表没有此类记录 |
| `ITEM_KIND_PICKAX` | 27 | 普通十字镐 | 青铜十字镐、钢铁十字镐、象牙十字镐；可穿戴并用于采矿，普通修理会降低耐久上限 |
| `ITEM_KIND_MINERAL` | 28 | 矿物等职业材料 | 有专用数量/说明显示处理；采集、提炼、制造用途取决于对应表和配方，不由 28 单独保证 |
| `ITEM_KIND_CAP` | 29 | 遮盖头发的帽类装备 | 如男子流星帽；位于帽槽 8 时隐藏头发层 7，不删除头发物品；并非所有帽子都必须为 29 |
| `ITEM_KIND_PROCESSDRUG` | 30 | 加工试剂 | 溶华素、逐龙丹、太极液、桂圆丹；加工入口实际按 `INI_DEF_ITEMPROCESS1..4` 的名称匹配，单改 Kind 不会注册试剂 |
| `ITEM_KIND_HELPDRUG` | 31 | 加工辅助试剂 | 精华素、草芥丹、生死梦幻丹；与主试剂搭配，按 `SuccessRate` 对基础加工成功率作比例增益 |
| `ITEM_KIND_GROWTHHERB` | 32 | 药草材料 | 如葛根、甘草、何首乌；载入背包合并同名可堆叠药草时比较 `Upgrade`；无按此 Kind 自动生长的处理 |
| `ITEM_KIND_SKILLROLLPAPER` | 33 | 卷轴（技术密笈） | 随包 `Name=技术密笈`、`ViewName=卷轴`；双击按职业编号打开对应帮助文件 |
| `ITEM_KIND_QUESTITEM` | 34 | 任务物品 | 被 `deletequestitem` 批量清理；是否堆叠取决于 `boDouble` 等检查，不由类型名决定 |
| `ITEM_KIND_WATERCASE` | 35 | 水容器 | 竹筒、大型竹筒；当前耐久表示余水，装水消息补满；有水时可阻止火属性地图的一项定时掉血，耗尽保留容器 |
| `ITEM_KIND_CHARM` | 36 | 护符类 | 支持背包携带时的活力上限加成和可配置的耐久计时消耗；是否加成、是否计时取决于物品字段及专门逻辑，见下方说明 |
| `ITEM_KIND_QUESTLOG` | 37 | 任务日志 | 随包为书函；双击按玩家当前任务编号显示任务概要，不消耗；也被 `deletequestitem` 清理 |
| `ITEM_KIND_SUBITEM` | 38 | 装备联动加成物品 | 如太极牌；要求物品 `Attribute` 与当前武器一致，且此类物品在背包中只占一个槽位 |
| `ITEM_KIND_NAMEDPOSQUEST` | 39 | 四大宝石类 | 珍珠、翡翠、水晶、琥珀；技术材料四槽各一个且 `SpecialKind=8/9/10/11` 齐全时，可将目标加工等级加一，见下文 |
| `ITEM_KIND_QUESTITEM2` | 40 | 任务物品2 | 同样被 `deletequestitem` 清理；不能仅凭 `Kind=40` 保证可堆叠 |
| `ITEM_KIND_FILL` | 41 | 五色药水类 | 在 `MAP_TYPE_FILL` 地图、有可用药水且人物未死亡时，按地图 `ChangeDelay/ChangeSize` 恢复活力、内功、外功、武功；不是一般双击药品 |
| `ITEM_KIND_SPECIALEFFECT` | 42 | 背包属性加成物品 | 将背包中首个此类型物品的 `rLifeData` 纳入属性加成，不是画面特效分类 |
| `ITEM_KIND_ADDATTRIBITEM` | 43 | 装备附加属性材料 | 如龙虎灵符、青铜武士、巫女卷轴；技术加工检查目标、`SpecialKind` 和材料数量，生成附加属性编号 |
| `ITEM_KIND_GOLDBAG` | 44 | 雨中客锦囊 | 背包计时耗尽删除；配合 `SpecialKind=5` 还触发关联物品清理，见耐久处理表 |
| `ITEM_KIND_DAGGEROFOS` | 45 | 玉仙的无情双刀 | 背包计时耗尽删除；配合 `SpecialKind=5` 还触发关联物品清理，见耐久处理表 |
| `ITEM_KIND_DUBU` | 46 | 流放地豆腐类型 | 刑期结束自动释放路径删除背包首个此类槽位；不能泛化为任意离开地图时清除全部 |
| `ITEM_KIND_DELATTRIBITEM` | 47 | 装备附加属性清除材料 | 随包为北海冰玉；技术加工把目标的 `AddType` 清零，保留颜色和加工等级，清空材料 |
| `ITEM_KIND_TRANSMONSTER` | 48 | 变身怪物预留类型 | 未见当前 TGS 的类型处理分支，不列为已实现功能 |
| `ITEM_KIND_RECOVERYHUMAN` | 49 | 恢复人形预留类型 | 未见当前 TGS 的类型处理分支，不列为已实现功能 |
| `ITEM_KIND_GRADEUPQUESTITEM` | 50 | 升级任务说明物品 | 如侠客任务卷轴、仙人卷轴；双击按物品 `QuestNum` 显示任务说明，不直接提升武功等级，也不消耗 |
| `ITEM_KIND_DURABILITY` | 51 | 普通耐久物品 | 背包计时耗尽删除，如万毒钥匙、血红色的玛瑙石；不在 `deletequestitem` 清理范围内，也不是所有有耐久度物品的共同 Kind |
| `ITEM_KIND_TOPLETTER` | 52 | 广播输入物品类型 | 双击打开广播输入窗口并消耗一个物品，不等于已经发送全服广播 |
| `ITEM_KIND_GUILDLOTTERY` | 53 | 门派奖券类型 | 背包替换时发送此类物品名称、增量数量的专用通知；没有通用双击兑奖分支，随包表无此类记录 |
| `ITEM_KIND_SET` | 54 | 套装加成配置类型 | 穿戴物品中恰有四件 `Attribute=5` 时，读取名为 `SetValue` 且 `Kind=54` 的记录叠加属性；不是每件套装装备的 Kind |
| `ITEM_KIND_DBLRANDOM` | 55 | 随机礼盒类 | 随包为礼盒；双击使用 `RandomEventItemList` 的第 0 组，非空结果先扣一个礼盒再发奖，不是从所有物品随机抽取 |
| `ITEM_KIND_USESCRIPT` | 56 | 脚本物品 | 如四大神功全集、储物袋；双击装载物品 `Script` 并调用 `OnDblClick`，是否消耗或发奖由脚本决定 |
| `ITEM_KIND_HIGHPICKAX` | 57 | 高级十字镐 | 随包为高级象牙十字镐；与 27 共用采矿入口，修理不减耐久上限，按缺少耐久计费 |
| `ITEM_KIND_SEAL` | 58 | 封印符 | 拖给 `MOP_KIND_SEAL` 怪物，且剩余活力不超过上限的三分之一时封印；不是对任意怪物双击捕捉 |
| `ITEM_KIND_EIGHTANGLES` | 59 | 八卦牌 | 内部名八卦牌1～15，均显示为八卦牌；属性重算取首个此类槽位，当前耐久不为零才加成；到期/修理边界见下文 |
| `ITEM_KIND_DURAWEAPON` | 60 | 耐久武器 | 近身攻击执行到扣耐久分支时消耗 1；穿戴时还可按配置计时消耗，不是只在使用时消耗 |
| `ITEM_KIND_EVENT1` | 200 | 活动抽奖材料 | 技术制造入口接受全为此类的原料，按 `SuccessRate × 数量` 汇总后查活动奖品表；有空槽/数量要求，不保证中奖 |

---

## 使用入口与特殊条件

### 双击、染色、弹药和穿戴

- **染色（1）**：穿戴染色要求目标为允许的衣物/头发槽并启用 `boColoring`；地面物品染色也检查目标的 `boColoring`，并拒绝目标本身为 1、22 类。普通染剂以自身 `Color` 覆盖目标颜色；名称等于 `INI_WHITEDRUG` 的染剂改为把该值加到原颜色上。背包双击染剂不执行染色。22 类通过 `NameParam` 转换地面物品的代码已注释，不能和这条有效路径混淆。`boColoring` 不控制初始配色显示；`Color` 色表范围和图标可染色区域见[物品图标与颜色](../Init_item.sdb.md#物品图标与颜色)。
- **秘籍（2）**：内部 `Name` 用于查找武功数据。入口分别处理普通武功、上层武功、掌法、绝世武功，并调用各自学习方法。上层武功还检查 `Virtue>6000`、`Energy>8000` 以及对应类型/相性的普通武功是否练满；后续学习函数仍有自身检查。书籍学习成功才删除一个。
- **弹药（7、8）**：`CommandBowing` 按当前武功 `MagicType=5/6` 分别查找 7/8 类并扣一个，弹道图像取弹药 `ActionImage`。扣弹药先于后续 `DecEventMagic` 检查，所以不能把一次扣除理解为一定命中。
- **穿戴（6、24、27、29、57、60）**：这是正常穿戴入口接受的类型集合，仍须通过当前窗口、人物状态、性别及武器/武功切换等检查。`WearPos`、`HitType` 等负责位置和动作，不能仅凭 Kind 认定是武器或防具。24、29 的遮盖只改外观与对应客户端显示，不卸下内衣或头发。
- **传送（18）**：检查当前地图是否为 `MAP_TYPE_DONTTICKET`，然后根据物品 `ServerId/X/Y` 设置目的地并扣一个。这里的地图限制不是“所有任务地图都禁用”。
- **隐身/透视（19、23）**：二者共用 `UseSkillKind`，已有任一效果时不能再用；持续时间分别取 `INI_HIDEPAPER_DELAY`、`INI_SHOWPAPER_DELAY`。隐身另检查地图 `boNotUseHideItem`；23 的双击分支没有对应的同名地图检查。到期恢复外观可见性或撤销透视显示。
- **任务说明（37、50）**：均从 `QuestSummaryClass` 取内容；37 使用玩家 `QuestNo`，50 使用物品 `QuestNum`。找不到内容则不弹窗；两者都不是直接完成任务的命令。
- **广播（52）**：打开输入窗口就扣一个，取消输入不在此分支返还；实际发言另走窗口提交路径。
- **随机礼盒（55）**：随机表返回空名称时不扣；返回非空名称则先扣礼盒，再调用 `SPutMagicItem(..., 'event', 4)`。该分支不能保证发奖失败会返还礼盒。
- **脚本物品（56）**：装载 `Script` 后，有有效 `OnDblClick` 入口才调用；事件的自身对象和发送者均为使用者。Kind 本身不自动消耗物品。

依据：[uUserSub.pas](../TGS核心源码/uUserSub.pas) 的 `THaveItemClass.DblClickProcess/DressOnProcess`、`TWearItemClass.AddColorDrug/AddItem/ChangeItem/GetFeature`；[BasicObj.pas](../TGS核心源码/BasicObj.pas) 的 `TItemObject.FieldProc`；[UUser.pas](../TGS核心源码/UUser.pas) 的 `TUserObject.CommandBowing`、`TUser.Update`。

### 场景、门派和封印

- **门派石（9）**：玩家拖到地面时检查落点区域编号 50～59、`PowerLevel>=5`、没有所属门派、指定区域与门石内部名称匹配以及据点未占用，再进入建派/输入门派名流程。管理器里旧的通用 `FM_ADDITEM` 建派代码已注释，不能只看那一段判定整个功能不可用。
- **门派娃娃（10）**：拖交门派石走 `TGuildObject.FieldProc`；已命名门派的存活/死亡守卫总数须小于 `MAX_GUILDNPC_COUNT`。按娃娃 `Sex` 选择男女守卫配置，在门派石坐标调用 `AddGuildNpc`。成功回执后，从背包扣一个娃娃。
- **静态物品（11）**：管理器落地分派调用 `TStaticItemList.AddStaticItemObject`，要求数量恰为 1 且目标格可行走。生成的对象采用独立的 `CurDurability=10*60*100`，不是物品表 `Durability`；正常 tick 下约 10 分钟到期。命中的 `FM_HIT` 每次减 `5*100`，缩短存留时间。它没有普通地面物品的拾取处理，不能描述成永久场景装饰。
- **水容器（35）**：`FM_CHANGEDURAWATERCASE` 找背包首个此类物品，把当前耐久补到上限。余水标记存在时，阻止 `MAP_TYPE_FIRE` 的环境掉血分支；不是免疫所有火攻击。地图中的直接喝水恢复 `FM_FILLLIFE` 是另一条路径，不要求该容器。
- **五色药水（41）**：恢复量和间隔取地图配置而非 `ItemDrug.sdb`；恢复活力、内功、外功、武功四项，不包括元气。物品计时与地图恢复各自执行，不能把耐久扣减次数等同于实际恢复次数。
- **流放地物品（46）**：仅在流放地刑期结束的自动释放路径调用 `RemoveItemKind(46)`；函数只删除背包找到的首个同类槽位。
- **封印符（58）**：拖放距离须通过 `GetCellLength<=3` 检查；目标为怪物/NPC，实际 `Monster.Kind=MOP_KIND_SEAL`，并满足 `CurLife<=MaxLife div 3`。成功路径令目标活力为 0，把符的 `OwnerName` 标为“封印成功”，扣原符后尝试通过 `FM_ADDITEM` 回交标记后的符，并触发配置的怪物死亡事件。不是直接获得一个宠物，也不是简单地把符用掉。

依据：[uUserSub.pas](../TGS核心源码/uUserSub.pas) 的 `THaveItemClass.PutOnScreenProcess`；[uGuild.pas](../TGS核心源码/uGuild.pas) 的 `TGuildObject.FieldProc`；[uManager.pas](../TGS核心源码/uManager.pas) 的 `TManagerList.FieldProc`；[BasicObj.pas](../TGS核心源码/BasicObj.pas) 的 `TStaticItem.FieldProc/Initial/Update`、`TStaticItemList.AddStaticItemObject`；[UUser.pas](../TGS核心源码/UUser.pas) 的 `TUser.FieldProc/Update/RemoveItemKind`。

### 技术制造与加工

这里的“原料槽”为技术窗 0～3 槽，“目标/成品槽”为 `PRODUCT_KEY`。以下都是进入制造或加工后的判断，不代表任意物品都允许放入技术窗。

| 类型 | 实际判断与结果 |
|---|---|
| 30 主加工试剂 | 主试剂按配置的内部名称匹配 1～4 段。原料只能占一个主试剂槽，或主试剂加一个 31 类辅助槽；常规加工还检查职业、目标可加工标志、最大等级、当前等级与试剂阶段是否匹配 |
| 31 辅助试剂 | 读取试剂模板 `SuccessRate`；最终成功率为 `基础成功率 + 基础成功率 × SuccessRate div 100`，不是直接加同样的百分点。成功率表取决于目标 `MaxUpgrade=3/4`；成功、失败都会清理材料，失败不会把目标放回成品槽 |
| 39 四大宝石 | 四个原料槽均须为 39、各一个，且 `SpecialKind` 的 8、9、10、11 各有一种。成品槽必须有目标且 `Upgrade<MaxUpgrade`；该分支不抽加工成功率，直接等级加一、消耗原料并重算属性。它位于普通职业/试剂检查之前，不能套用后面的普通试剂规则 |
| 43 附加属性 | 一种原料槽为 43，目标 `RoleType` 在 `1..ROLE_HANDMAN` 且尚无 `AddType`；后续要求其它原料槽为空。护腕/鞋/帽对应 `SpecialKind=1`，铠甲对应 2，武器对应 3；数量须等于附加属性表对目标 `Grade` 的要求。以材料 `Attribute` 和目标等级范围抽取附加属性编号，成功后清材料、保留目标 |
| 47 清除附加属性 | 至少一个原料槽为 47，且目标有非零 `AddType`。按目标名称重新取模板、保留颜色和加工等级、置 `AddType=0`，清空技术材料后放回结果。不是降低加工等级，也不是解除一切特殊效果 |
| 200 活动抽奖 | 走制造 `ConfirmMakeItem`，要求成品槽为空，至少一格原料且非空原料全部为 200；每槽数量不得大于 **3**。汇总各槽 `SuccessRate × 数量` 交给 `EventItemClass.GetEventItem`；无论中奖与否先清材料，中奖物放成品槽。数量提示写“5个”，但有效判断是 `rCount>3` 拒绝，配置应以判断为准 |

36 类另有一处局部限制：`THaveJobClass.MakeItem` 查到背包已有符合 `FindItem` 条件的 36 类产品时拒绝制造；该匹配检查同名、同 Kind、同加工等级和附加属性编号，且数量足够。这不是覆盖交易、任务发放、其它容器的全局唯一性保障。

依据：[uUserSub.pas](../TGS核心源码/uUserSub.pas) 的 `THaveJobClass.ConfirmMakeItem/ConfirmProcessItem/FindProcessDrug/ProcessItembyRate/Check3rdQuestItem/CheckAddAttribItem/CheckAddAttribKind/ProcessAddAttribItem/CheckDelAttribItem/ProcessDelAddAttribItem/CheckEventItemMaterial/GetEventItemSuccessRate/ProcessEventItemGive/MakeItem`。

### 携带加成、套装与非主动用途

- **38**：`SetEffectItemLifeData` 取首个 38 类，其 `Attribute` 要与当前武器相同，并要求背包此类型恰占一个槽位。这里统计槽位，不是堆叠总数量；换武器、入包/移除等触发属性更新时才按对应路径重算。
- **42**：重算时只取首个此类物品的 `rLifeData`，不遍历叠加全部同类；没有有效背包计时消耗分支，不是画面特效开关。
- **59**：重算时也只取首个此类物品，并检查当前耐久 `<>0`，不是 `>0`。计时耗尽分支只提示，不立即撤销已经加入的属性；若扣成负值，该重算条件仍会通过。不能据名称或耐久条推断“到零必删、立即失效”。修理见耐久度一节。
- **54**：这是 `Name=SetValue` 的加成模板类型。套装件由穿戴物品 `Attribute=ITEM_ATTRIBUTE_SET` 计数，**恰好四件**时读取模板的 `rLifeData`；超过四件不命中此条件。
- **28**：矿物说明有数量显示分支；背包物品说明窗口对该类传入的价格设为 0。这是显示处理，不表示交易价格或物品本身价值一定为 0。
- **32**：载入背包时，同名且可堆叠药草按 `Upgrade` 是否相同合并；这条载入分支与普通入包 `CheckAddable` 的颜色/等级/附加属性检查不能混为一谈。
- **53**：`CopyFromHaveItemClass` 在 `FAttribClass<>nil` 时比较新旧背包，针对新增差量中的此类记录调用 `SendLotteryInfo`，通过 UDP 队列发送内部名称和数量；不是双击使用，也不是每次入包都发奖。

依据：[uUserSub.pas](../TGS核心源码/uUserSub.pas) 的 `THaveItemClass.SetEffectItemLifeData/LoadFromSdb/CopyFromHaveItemClass/SelectItemWindow`、`TWearItemClass.SetLifeData`；[svClass.pas](../TGS核心源码/svClass.pas) 的 `GetItemDataInfo`；[uSendCls.pas](../TGS核心源码/uSendCls.pas) 的 `TSendClass.SendLotteryInfo`。

### 预留类型与数据分类约定

22 的地面转换代码、25 的双击代码、26 的双击及门派接收代码均无有效使用实现；48、49 只有类型定义，当前 TGS 未见按这两个 Kind 执行变身/恢复的分支。不要把已注释实现写成玩家可用功能。

物品表使用 3、4、5、17，但 `deftype.pas` 没有对应的 `ITEM_KIND_*` 命名常量，当前物品使用分支也没有赋予它们统一的专属功能。维护物品表时采用以下**数据分类约定**；它不是新增的引擎功能，既有发行包的分类可能不同：

| Kind | 维护约定与示例 | 可以确认的边界 |
|---:|---|---|
| 3 | 货币与兑换币：钱币、金元、银元、金钞、银钞、纸钱 | 交易通用货币仍按 `INI_GOLD` 指定的内部名称识别；不是所有 3 类都能直接付款 |
| 4 | 普通物品与一般材料：肉、皮、尖钩、垫子、饭团 | 配方、交易、脚本可按名称使用；不会因归为此类就自动可食用或可坐下 |
| 5 | 任务物品与凭证：黄金钥匙、书札、喜帖、新郎戒指、新娘戒指、聚贤庄进门券 | 任务作用由脚本或专用名称分支实现；不自动进入 `deletequestitem` 的清理范围，也不等同于 34/40 类 |
| 17 | 按名称使用的工具：追魂索、补血石、门派钱令 | 分别由 `INI_ROPE` 或固定内部名称处理；单改 Kind 不会赋予捆绑、门石修复或取款功能 |

重分类时保持内部 `Name`，连同脚本中的按 Kind 查询、配方、穿戴字段与权限标志核对；不把有有效专用分支的类别随意归入这四类。武功秘籍仍用 2，真正的普通服用药品用 13，药材可使用 28/32，可计时删除的普通物品用 51。表记录按 Kind 排序只是维护规则，不决定加载优先级。

婚戒是交给婚礼司仪领取礼服的凭证，不是穿戴装备；实际新郎套装、新娘套装仍按自己的穿戴字段处理。分类不能替代 `boNotSkill` 等操作限制，不能把技术窗当额外背包。

0 同时也是清空记录后数值字段的默认值；判断是否有物品应看名称/有效记录，不能只看 `Kind=0`。例如 `getsenderitemexistencebykind 0 0` 不能可靠区分真实 0 类工具与空槽。

## 护符类（Kind=36）

`Charm` 在物品语境中意为护符、护身符。“护符类”是 `ITEM_KIND_CHARM` 的类别译名，不是某件物品的正式名称，也不要求物品外形是符；不灭、侠客指环、九转金丹均使用此类型。

- **活力加成**：在背包中按 `cLife` 累加活力上限；`cLife` 为空或为 0 时不提供这项加成。配合 `SpecialKind=7`，还将同一数值加到头、手臂、腿部活力上限。这里增加的是上限，不是吃药回复当前活力。
- **耐久计时**：背包更新时，运行中的 `boDurability=true`、`DecDelay>0` 且当前耐久大于 0，才进入计时处理；间隔到达后按 `DecSize` 扣减，扣减至 0 或以下时删除物品。未启用耐久计时的护符不会仅因 `Kind=36` 就自动消失。
- **不是独占功能**：耐久字段是公共字段，计时耗尽后删除也不是 36 类独有。例如 `ITEM_KIND_DURABILITY` 同样会计时耗尽删除，而 `ITEM_KIND_WATERCASE` 耗尽后保留容器。只填写耐久字段，不代表任意类型都会按相同方式消耗或删除。
- **任务清理**：`deletequestitem` 会删除背包中所有 36 类物品，无论它是否用于当前任务、是否还有耐久；见下方清理范围。

随包 `Init/Item.sdb` 的示例：

| 物品 | `cLife` 配置值 | 说明 |
|---|---:|---|
| 不灭 | 4000 | 配合 `SpecialKind=7` 增加活力及部位活力上限；未启用耐久计时 |
| 侠客指环 | 1000 | 配合 `SpecialKind=7` 提供加成，并启用耐久计时 |
| 九转金丹 | 空 | 不提供活力加成；有耐久配置，初始 `boDurability=FALSE`，使用效果另由名称专用逻辑处理，不是 36 类的通用效果 |

依据：[uUserSub.pas](../TGS核心源码/uUserSub.pas) 的 `THaveItemClass.SetAttribData`、`Update`、`DblClickProcess`，以及随包 `Init/Item.sdb`。

## 任务清理范围

脚本 `print('deletequestitem')` 调用 `TUser.SDeleteQuestItem`，最终执行 `THaveItemClass.DeleteQuestItem`。它遍历玩家背包并清空下列类型的所有槽位：

| Kind | 常量 | 是否属于清理范围 |
|---:|---|---|
| 34 | `ITEM_KIND_QUESTITEM` | 是 |
| 36 | `ITEM_KIND_CHARM` | 是，包括不灭、九转金丹等此类型物品 |
| 37 | `ITEM_KIND_QUESTLOG` | 是 |
| 40 | `ITEM_KIND_QUESTITEM2` | 是 |
| 51 | `ITEM_KIND_DURABILITY` | 否，即使物品用于任务也不自动纳入 |

- 只扫描背包 `HaveItemArr`，不扫描穿戴栏、技术材料栏、个人商店或福袋。
- 不按任务编号、NPC、名称或耐久过滤，也不检查 `boNotDrop`、`boNotTrade` 等操作限制；整槽清空，包括其中全部数量。
- 删除护符会标记属性需要更新，并逐槽通知客户端。这不是耐久计时，也不要求耐久耗尽。
- 随包 `Script/玉仙.txt` 的 `remotequest` 分支使用此命令重置任务。按名称交付任务物品则是另一条路径，不应混为一谈。

命令用法和源码入口见 [deletequestitem](../../print/物品交易命令/deletequestitem.md)。

## 耐久度处理

### 字段与计时条件

`Durability`、`boDurability`、`DecDelay`、`DecSize`、`Abrasion` 是公共物品字段，`TItemClass` 不按 Kind 限制其读取。**能配置字段，不等于该类型在任何位置都会自动扣耐久或到期删除。**

- 新建物品模板时，`rDurability` 和 `rCurDurability` 均来自 `Durability`，`rDecTick` 初始为 0；载入玩家存档时还会读取已保存的耐久上限和当前耐久。
- 背包、穿戴栏的计时入口均要求运行时 `rboDurability=true`、`rDecDelay>0`、`rCurDurability>0`；满足 `rDecTick + rDecDelay <= CurTick` 时才扣 `DecSize`，并把 `rDecTick` 设为当前 tick。
- 默认每 tick 约 10 ms，耐久检查每 500 tick（约 5 秒）一次；一次检查只扣一次，不按漏过的间隔补扣。`DecDelay` 不是毫秒字段，也不保证精确的现实时间。
- 正常递减应配置 `Durability>0`、`DecDelay>0`、`DecSize>0`。**初始当前耐久为 0 不会进入计时分支，不等于扣到 0 后自动删除。** 直接把当前耐久写成 0，也不能代替删除命令。
- `boDurability` 是计时开关，不是所有耐久损耗的总开关；攻击、采矿的按次损耗见下文。

### 背包计时：按 Kind 分支

以下均指满足上述计时条件后，由正耐久扣到 0 或以下的处理：

| Kind | 类型 | 耗尽处理 |
|---:|---|---|
| 6 | `WEARITEM` | 提示并删除物品 |
| 35 | `WATERCASE` | 当前耐久归零、清空水容器计数并提示水喝没了；保留容器 |
| 36 | `CHARM` | 提示并删除物品，护符属性标记随删除更新 |
| 41 | `FILL` | 清空 `FillItemCount`，提示并删除物品 |
| 44 | `GOLDBAG` | 提示并删除物品；`SpecialKind=5` 时另清理关联物品 |
| 45 | `DAGGEROFOS` | 清空 `FillItemCount`，提示并删除物品；`SpecialKind=5` 时另清理关联物品 |
| 51 | `DURABILITY` | 清空 `FillItemCount`，提示并删除物品 |
| 59 | `EIGHTANGLES` | 提示但不删除，也不在此分支将负值钳制为 0；可通过对应修理路径恢复 |
| 其他 | 包括 24、27、29、34、37、40、42、57、60 | 无当前背包自动计时分支；42 的相关代码被注释，不能算作有效功能 |

`SpecialKind=5` 的关联清理仅在上述 44、45 分支调用：取 `DelItem` **第一项的名称**传给 `DeleteAllItembyName`，不按该项数量执行，也不遍历所有 `DelItem` 项。该函数分别尝试清理背包、个人商店、技术材料栏的首个同名槽位；个人商店还受国家版本分支限制。不处理穿戴栏或福袋，也不保证删尽同一容器中的多个同名槽位。详见 [getsenderallitem](../../print/物品交易命令/getsenderallitem.md)。单独给 36 或 51 设置 `SpecialKind=5` 不会触发这项联动。

59 类还有一个配置边界：若进入计时分支时 `DecSize=0`，代码直接退出本轮背包 `Update`，后续槽位也不再检查；启用计时应使用正的扣减量。

### 穿戴计时、按次损耗与修理

`TWearItemClass.Update` 扫描穿戴栏 0～9 槽，满足计时条件就扣耐久，耗尽后调用 `DeleteKeyItem` 删除，**此处没有 Kind 筛选**。正常双击穿戴入口支持 6、24、27、29、57、60；这不代表任意类型均可绕过穿戴检查放入装备栏。

| 路径 | 类型与触发点 | 处理 |
|---|---|---|
| 攻击损耗 | `TUserObject.CommandHit`，当前武器为 60，执行到末尾扣耐久分支 | 调用 `DecreaseDurability(ARR_WEAPON)` 扣 1；不是每次点击都扣 |
| 采矿损耗 | 收到 `FM_ADDMINEAMOUNT` 的采矿回包；通常使用 27、57 类镐 | 同样对武器槽调用 `DecreaseDurability` 扣 1 |
| 普通十字镐修理 | 穿戴栏 27 类 | 上限减 `Abrasion`，当前耐久恢复到新上限，费用为固定 `RepairPrice` |
| 高级镐、耐久武器修理 | 穿戴栏 57、60 类 | 保持上限，补满当前耐久，费用为缺少耐久乘 `RepairPrice` |
| 八卦牌修理 | 背包中找到的首个 59 类 | 保持上限，补满当前耐久，费用同上 |

`DecreaseDurability` 检查槽位、物品存在及耐久上限不为 0，不检查 `boDurability` 或 `DecDelay`。扣至 0 或以下会删除；60 类在该路径还会切回默认攻击武功。因而开启了穿戴计时的镐或耐久武器，可能同时受到计时和使用两种消耗。

修理还受物品名称、位置、金钱等条件限制；**有耐久字段不代表任意类别均可修理**。按名称修改背包当前耐久的命令是直接赋值，而不是扣减，也不立即执行删除或刷新客户端，见 [changesendercurdurabyname](../../print/物品交易命令/changesendercurdurabyname.md)。

### 计时起点与任务物品示例

`THaveItemClass.AddItem/AddKeyItem` 只为启用计时的 36 类新入包槽位将 `rDecTick` 重置为当前 tick；51 类没有这项重置。由 `GetItemData` 创建并直接发放的 51 类物品保留模板的 `rDecTick=0`，服务器计时已超过 `DecDelay` 时，首次扣减可能发生在下一轮检查。不能把 `Durability / DecSize × DecDelay` 无条件描述为“领取后完整可用时长”。

随包血红色的玛瑙石使用 `Kind=51`、`boDurability=TRUE`、`Durability=10`、`DecDelay=6000`、`DecSize=1`。萧郎发放、素莲检查和收走都按物品名称执行；它不需要 36 类的活力加成或玉仙任务重置清理。原有 `BoNotSave=TRUE` 表示保存玩家存档时不保留该背包物品，和耐久耗尽是独立机制。

源码依据：[svClass.pas](../TGS核心源码/svClass.pas) 的 `TItemClass.ReLoadFromFile/GetItemData/GetWearItemData`；[uUserSub.pas](../TGS核心源码/uUserSub.pas) 的 `THaveItemClass.Update/AddItem/AddKeyItem/SaveToSdb/RepairItem`、`TWearItemClass.Update/DecreaseDurability/IncreaseDurability/RepairItem`；[UUser.pas](../TGS核心源码/UUser.pas) 的 `CommandHit`、`FieldProc`、`DeleteAllItembyName`、`SPutMagicItem`、`SGetItem`。计时单位见服务端 `Common/uAnsTick.pas` 的 `mmTickTimerProc` 与 `timeSetEvent(10, ...)`。

---

## 药品子类型 (ITEM_DRUG_TYPE_*)

13 类双击后按内部 `Name` 查询 `Init/ItemDrug.sdb`，下列编号对应该表的 **`Type`**，不是 `Item.sdb` 的 `Kind` 或 `SpecialKind`。没有同名药效记录则不能进入药效槽。

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `ITEM_DRUG_TYPE_A` | 0 | 每轮按读取、缩放后的 `e*` 固定量恢复元气、内功、外功、武功、活力及部位活力；活力溢出量转加 `CurShield` |
| `ITEM_DRUG_TYPE_B` | 1 | 将对应上限的指定百分比除以 `UseCount`，逐轮恢复；不是每轮恢复完整百分比，整数除法会截断 |
| `ITEM_DRUG_TYPE_C` | 2 | 提供临时百分比上限/战斗属性加成，持续时间取 `StillInterval`；不是给角色永久增加基础属性 |

- 药效数组 `DRUGARR_SIZE=3`，最多同时占用三个槽；A/B 可同类并行。每轮所有占用槽各执行一次，`UsedCount>=UseCount` 后清空槽。
- 更新门槛为 `CurTick>CheckDrugTick+100`，正常 tick 下约一秒一轮；没有补算遗漏轮次。`UseInterval` 虽被读取，但这段执行代码没有使用它控制单种药物的节奏。
- C 类在已有临时属性效果、或已有同类型药效占槽时拒绝重复加入；最后一次执行重设 `DrugUseTick`，之后按 `StillInterval` 到期清除。地图不允许 `boUseChemistDrug` 时，现有临时属性效果也会被清除。
- 药品双击先检查地图 `boUseDrug`，`SpecialKind=6` 另受 `boUseChemistDrug` 限制；门派战/比武地图还有允许药品名称列表。只有成功加入药效槽才扣除一个背包药品。

**不能按表头推测的实现边界**：B 类当前没有恢复元气的语句，外功恢复量实际复用了 `InPower × eInPower`，不是 `OutPower × eOutPower`。C 类的内功/外功/武功/活力上限按百分比计算；战斗加成包括身体/部位攻防、躲闪、准确度、维持姿势，但 `SetDrugEffect` 中应用攻击速度、恢复的语句已注释。配置这些未生效的字段不等于已经具备该药效。

依据：[uUserSub.pas](../TGS核心源码/uUserSub.pas) 的 `DRUGARR_SIZE`、`TAttribClass.AddItemDrug/Update/SetDrugEffect/GetMaxInPower/GetMaxOutPower/GetMaxMagic/GetMaxLife`、`THaveItemClass.DblClickProcess`；[svClass.pas](../TGS核心源码/svClass.pas) 的 `TItemDrugClass.ReLoadFromFile`。

---

## 脚本中使用

```pascal
// 检查背包中是否存在类型34（ITEM_KIND_QUESTITEM）的物品
Str := callfunc('getsenderitemexistencebykind 34 0');
if Str = 'true' then begin
   print('say 你身上有任务物品');
end;
```

## 相关文档

- 源码依据：[uUserSub.pas](../TGS核心源码/uUserSub.pas) 的 `THaveItemClass.DblClickProcess`、`SetAttribData`、`SetEffectItemLifeData`、`PutOnExchangeProcess`，以及 `TWearItemClass.AddColorDrug`、`GetFeature`。
- 名称依据：随包 `Init/Item.sdb`；加工试剂说明见[职业技能简介](<../炎黄新章游戏资料/职业技能/【职业技能】简介.md>)。
- [Init_item.sdb.md](../Init_item.sdb.md) — 物品数据库结构
- [ITEM_ATTRIBUTE.md](ITEM_ATTRIBUTE.md) — 物品属性常量
- [ITEM_SPKIND.md](ITEM_SPKIND.md) — 物品特殊类型
