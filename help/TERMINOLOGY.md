# 炎黄新章术语表

本文档统一官方源码、协议文档和原生客户端使用的名称。它只规定名称，
不替代对应的协议、常量和数据结构文档。

## 命名原则

1. 英文名称使用 Pascal 源码中实际声明的常量、类型和字段名，不自行翻译、改写或
   修正拼写。Pascal 不区分大小写，但文档应尽量保留声明处的大小写。
2. 面向玩家的中文名称以当前原版客户端界面为准；客户端未显示的概念，再参考随包
   游戏资料。物品、武功表应同时检查 `Name` 与 `ViewName`：前者用于内部查找，
   后者用于显示，不一定相同。例如物品内部名“技术密笈”的显示名是“卷轴”。
   历史资料与当前界面冲突时，以当前界面为准。
3. 无法从源码或客户端确认的中文含义保留源码名并标记“待确认”，不根据英文词面
   猜测。

## 核心状态属性

下表只解释 `TSAttribBase` 中的同名字段。其他 record 可能重复使用字段名，例如
`TSAttribValues.rMagic`，不能据此直接套用同一含义。

| Pascal 源码字段 | 客户端中文 | 说明 |
|---|---|---|
| `rAge` | 年龄 | 角色年龄 |
| `rCurLife` | 当前活力 | 当前值 |
| `rLife` | 活力 | 上限值 |
| `rCurMagic` | 当前武功 | 当前值 |
| `rMagic` | 武功 | 上限值 |
| `rCurOutPower` | 当前外功 | 当前值 |
| `rOutPower` | 外功 | 上限值 |
| `rCurInPower` | 当前内功 | 当前值 |
| `rInPower` | 内功 | 上限值 |
| `rCurEnergy` | 当前元气 | 当前值 |
| `rEnergy` | 元气 | 上限值，也是元气境界的判定依据 |
| `rLover` | 配偶 | 角色配偶名称 |

特别注意：`Life` 在本项目中对应“活力”，`Energy` 对应“元气”。“活力”和“元气”
不可因常见游戏或英文直译习惯而对调；正式名称也不额外添加“值”字。

源码依据：`1000ydef/deftype.pas` 的 `TSAttribBase`；客户端显示依据：
`client/FBottom.pas`、`client/FCharAttrib.pas` 及原客户端界面。

## 武功分类与协议流

原生客户端右下角的六个主菜单图标依次为“物品、武功、掌法、绝世武功、技术、
终止游戏”。“武功”主菜单内部再分“武功、基本、上层”三个切换卡片，分别对应
技术文档所称的普通武功、基本武功和上层武功；“掌法”和“绝世武功”是独立主菜单。

协议和角色状态可以将武功内容展开为五组，但这五组不是原生客户端中的五个同级
菜单。消息常量、窗口常量和数据层分类用途不同，不应机械地按英文词面翻译中文。

| Pascal 源码标识 | 客户端中文 | 使用说明 |
|---|---|---|
| `SM_HAVEMAGIC`、`WINDOW_MAGICS` | 武功 | 客户端分类标签只有“武功”二字；文档为消除歧义说明为“普通武功”，例如无影脚、打狗棒法 |
| `SM_BASICMAGIC`、`WINDOW_BASICFIGHT` | 基本武功 | 无名系列，例如无名剑法、无名拳法 |
| `SM_HAVERISEMAGIC`、`WINDOW_RISEMAGICS` | 上层武功 | 不写“升层武功”“上升武功”或“上乘武功” |
| `SM_HAVEMYSTERY`、`WINDOW_MYSTERYMAGICS` | 掌法 | 系统和分类称“掌法”，具体招式、秘笈及攻击称“掌风” |
| `SM_HAVEBESTMAGIC`、`WINDOW_BESTMAGIC` | 绝世武功 | 简称“绝世”只用于空间受限的分类标签 |

`MAGICCLASS_*` 是数据层分类，不能与上述客户端窗口机械地一一按英文名翻译：

| Pascal 源码常量 | 客户端中文 |
|---|---|
| `MAGICCLASS_MAGIC` | 普通武功；客户端分类标签为“武功” |
| `MAGICCLASS_RISEMAGIC` | 上层武功 |
| `MAGICCLASS_MYSTERY` | 掌法 |
| `MAGICCLASS_BESTMAGIC` | 绝世武功 |

为与“武功”总称区分，技术文档将“武功”主菜单中的同名卡片说明为“普通武功”。
基本武功使用独立的 `SM_BASICMAGIC` / `WINDOW_BASICFIGHT` 协议流，不是额外的
`MAGICCLASS_*` 常量。

原客户端 `client/FAttrib.pas` 的可见标签为“武功”“基本武功”“上层武功”。随包
[掌风介绍](<炎黄新章游戏资料/新手入门/武功介绍/掌风介绍.md>) 同时使用“掌法
系统”和“掌风名称”，因此术语表按概念层级保留这两个名称。

### 武功动作与绝世武功分组

| Pascal 源码标识 | 中文名称 | 说明或示例 |
|---|---|---|
| `MAGICTYPE_HAMMERING`、`DEFAULT_HAMMERING` | 槌法 | 无名槌法；沿用游戏中的“槌”字 |
| `MAGICTYPE_THROWING`、`DEFAULT_THROWING` | 投法 | 无名投法 |
| `MAGICTYPE_RUNNING`、`DEFAULT_RUNNING` | 步法（轻功） | 无名步法 |
| `MAGICTYPE_BREATHNG`、`DEFAULT_BREATHNG` | 心法 | 无名心法、伏式气功；英文拼写保留源码原样 |
| `MAGICTYPE_PROTECTING`、`DEFAULT_PROTECTING` | 护体 | 无名强身、黑沙刚体；游戏帮助也称强身类武功 |
| `HAVEBESTPROTECTMAGICSIZE`、`SM_SHOWBESTPROTECTMAGICWINDOW` | 神功（绝世护体） | 四大神功：日月神功、北冥神功、紫霞神功、血天魔功 |
| `MAGICTYPE_BESTSPECIAL`、`HAVEBESTSPECIALMAGICSIZE`、`SM_SHOWBESTSPECIALMAGICWINDOW` | 招式武功 | 凌波微步、乾坤大挪移等 |
| `HAVEBESTATTACKMAGICSIZE`、`SM_SHOWBESTATTACKMAGICWINDOW` | 绝世攻击武功 | 寒阴指、玉霄剑法、金刚指、金蛇剑法等 |

神功派别中，北冥、紫霞属正派，日月、血天属邪派；这里的派别不是玩家创建的门派。
`MAGIC_KIND_KYUNGSIN=1` 对应随包“凌波微步”的标记，不另造一个武功名称。
`MAGICSPECIAL_*` 的中文名称按 `Magic.sdb` 的 `MagicType=12`、`Function` 对照，
详见[武功类型常量](constants/MAGICTYPE.md)；`MAGICSPECIAL_LAST` 是数量边界，不是武功。

名称依据：[千年武功介绍](<炎黄新章游戏资料/新手入门/武功介绍/千年武功介绍.md>)、
[四大神功介绍](<炎黄新章游戏资料/新手入门/武功介绍/四大神功介绍.md>)、
[绝世武功介绍](<炎黄新章游戏资料/新手入门/武功介绍/绝世武功介绍.md>)及随包 `Init/Magic.sdb`。

## 职业与物品加工

| Pascal 源码标识 | 正式名称 | 说明 |
|---|---|---|
| `JOB_KIND_ALCHEMIST` | 铸造师 | 制造兵器 |
| `JOB_KIND_CHEMIST` | 炼丹师 | 制造试剂和药品 |
| `JOB_KIND_DESIGNER` | 裁缝 | 制造衣服、防具 |
| `JOB_KIND_CRAFTSMAN` | 工匠 | 制造拳套、帽子、护腕、靴子等附加装备 |
| `JOB_GRADE_NAMELESSWORKER` 至 `JOB_GRADE_VIRTUEMAN` | 初级工、技能工、熟练工、达人、名人、神工 | 值依次为 1～6，不按英文逐字翻译 |
| `ITEM_KIND_PICKAX`、`ITEM_KIND_HIGHPICKAX` | 十字镐、高级十字镐 | 例如青铜十字镐、高级象牙十字镐 |
| `ITEM_SPKIND_MUNJANG` | 灵符 | 属性加工材料，对应帽子、护腕、鞋类 |
| `ITEM_SPKIND_ZANGSIK` | 饰品 | 属性加工材料，对应衣服、铠甲类 |
| `ITEM_SPKIND_JUMOON` | 卷轴 | 属性加工材料，对应武器；与技术帮助用的“卷轴”不是同一用途 |
| `ITEM_ATTRIBUTE_LOWEST` 至 `ITEM_ATTRIBUTE_HIGHEST` | 低级、中级、高级、最高级、极品属性材料 | 值依次为 201～205；不是人物或装备的职业品级 |

职业、品级名称依据：[职业技能简介](<炎黄新章游戏资料/职业技能/【职业技能】简介.md>)和
`Init/JobGrade.sdb.ViewName`。材料类别及前四级名称见[重返王陵材料加工](<炎黄新章游戏资料/新手入门/版本介绍/重返王陵材料加工.md>)；
第五级“极品”取自 `Init/Item.sdb` 中天神灵符、金铜弥勒菩萨、圣灵卷轴的说明。

## 容器与特殊物品名称

| 源码标识或配置 | 游戏名称 | 说明 |
|---|---|---|
| `WINDOW_SSAMZIEITEM`、`SM_SSAMZIEITEM`、`swk_itemlog` | 福袋／物品保管窗 | 个人储物；服务端窗口标题为“物品保管窗”，不是日志窗口 |
| `WINDOW_GUILDITEMLOG` | 门派仓库 | 门派共享物品容器，不与个人福袋混用 |
| `ITEM_KIND_CHARM=36` | 护符类 | `Charm` 意为护符、护身符；这是类别译名，不是单件物品名。活力加成及耐久计时取决于配置和专门逻辑，见[护符类说明](constants/ITEM_KIND.md#护符类kind36) |
| `ITEM_ATTRIBUTE_PAPERBESTPROTECT=7` | 招式全集 | 随包物品显示名；不能由常量英文名反推为神功书 |
| `ITEM_ATTRIBUTE_PAPERBESTSPECIAL=8` | 四大神功全集 | 随包物品显示名；双击用途由该物品的 `Kind=56`、`Script=103` 决定 |
| `ITEM_KIND_GOLDBAG` | 雨中客锦囊 | 随包任务物品，不泛称金币袋 |
| `ITEM_KIND_DAGGEROFOS` | 玉仙的无情双刀 | 随包任务物品名称 |
| `FM_ADDVIRTUEEXP`、`TAttribClass.AddVirtue` | 浩然正气 | 角色经验相关；部分服务端提示写作“浩然之气”，不译成道德经验 |

源码依据：[uUserSub.pas](TGS核心源码/uUserSub.pas) 的 `TShowWindowClass.ShowItemLogWindow`、
`TAttribClass.AddVirtue`；物品名称、属性对应及使用边界见[物品数据库](Init_item.sdb.md)、
[物品属性常量](constants/ITEM_ATTRIBUTE.md)。内部枚举不等于玩家可见功能：保留定义、
未实现分支和有使用条件的标记必须单独说明。

竞技场对应 `MAP_TYPE_SPORTBATTLE`、`GATE_KIND_SPORTSWAR`；中文采用游戏中的“竞技场”，
不从 `SPORT` 直译为运动会。依据：[BasicObj.pas](TGS核心源码/BasicObj.pas) 中的竞技场传送门分支。

## 统一用词速查

| 应使用 | 不应混用 | 适用范围 |
|---|---|---|
| 活力 | 元气、生命、生命值 | `TSAttribBase.rLife` |
| 元气 | 活力、能量 | `TSAttribBase.rEnergy` |
| 武功 | 魔法、武功值 | 玩家属性和游戏技能总称 |
| 上层武功 | 升层武功、上升武功、上乘武功 | 客户端武功分类 |
| 掌法 | 掌风 | 系统、分类和修炼体系 |
| 掌风 | 掌法 | 具体招式、秘笈和攻击行为 |
| 武功 | — | 原客户端普通武功分类的显示名称；技术文档对照分类时写“普通武功” |
| 心法 | 呼吸、内功 | 武功动作分类；“内功”另指角色属性 |
| 护体 | 护身 | 武功动作分类；不改写既有物品或武功专名中的字词 |
| 神功、招式武功 | 公力、超式 | 绝世武功分组；源码英文及原始资料原文保留 |
| 招式全集、四大神功全集 | 公力全书、超式全书 | 随包物品显示名 |
| 福袋、物品保管窗 | 三三物品、物品日志 | `SSAMZIEITEM` 及个人 `ItemLog` 储物功能 |
| 浩然正气 | 道德经验 | 角色 `Virtue` 经验；不机械套用到所有含 `Virtue` 的内部字段 |

## 维护要求

- 新增英文名时，先在根目录 Pascal 源码中找到声明；文档记录声明名，不创造另一套
  “更自然”的英文名。
- 新增中文名时，先检查原客户端界面和客户端资源；若只能从随包资料确认，应在说明
  中注明来源。
- 修改玩家可见术语时，应同步检查对应协议、常量和游戏资料说明；额外开发工具的
  内部命名不纳入本术语表。
- 发现历史文档用词冲突时，修正文档概述；作为研究证据保留的原始 CP936/GBK 游戏
  资料不改写原文。

相关资料：

- [武功分类常量](constants/MAGICCLASS.md)
- [武功类型常量](constants/MAGICTYPE.md)
- [窗口类型常量](constants/WINDOW.md)
- [消息类型常量](constants/MESSAGES.md)
- [职业系统常量](constants/JOB.md)
- [物品特殊类型常量](constants/ITEM_SPKIND.md)
