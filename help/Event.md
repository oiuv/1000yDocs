# Event 运行数据

本页依据本仓库公开的原版炎黄新章源码副本及配套资料，说明 `Event/` 数据的加载和使用规则。奖池容量、编号用途及缺陷是否已修复，应以目标版本的源码、配置和调用脚本核对，不将原版限制视为所有部署的现状。

云端千年神武奇章线上优化版脚本仅证明该运营版本的调用方式，参数编号不能直接套用到其他版本，也不能据此推断原版神武行为。

## 原版随包文件

| 文件 | 原版加载情况 | 用途 |
|---|---|---|
| `BattleMap.sdb` | 启动加载 | 对战地图的两方位置、人数和传送信息 |
| `RandomEventItem0.sdb`～`3.sdb` | 源码尝试加载 | `getrandomitem` 的随机物品池 |
| `RandomEventItem.sdb` | 未被该加载器读取 | 随包保留文件，不能当作无编号默认池 |
| `Marry.sdb` | 启动加载、正常析构时保存 | 婚姻运行数据 |
| `EventItem1.sdb`～`4.sdb` | 原版随包不存在 | 职业制造抽奖的可选奖励表 |
| `TransMonsterList.sdb` | 原版随包不存在 | 可选的随机变身怪物名表 |

文本 SDB 延续随包的 GBK/CP936 编码。

## BattleMap.sdb

实际表头为 `No,MapID,PosX,PosY,GroupKey,MaxUser,DynName,TargetID,TargetX,TargetY,DieX,DieY,GuildName,MopName,`。`No` 只作行索引，其余字段均由 `TBattleMapList` 读取。

同一 `MapID` 必须至少有两行。`SetBattleMapData` 找到匹配行后直接取第 1、2 行，没有“只有一行”的保护；多余行也不会成为第三方队伍。修改后应核对双方出生点、死亡点、人数上限及目标地图坐标。

## RandomEventItem*.sdb

### 文件与调用

[`getrandomitem N`](../callfunc/物品背包函数/getrandomitem.md) 直接选择 `Event/RandomEventItemN.sdb` 对应的池，返回 `物品名:数量`，不在该函数内发放物品。编号不是品质等级，奖励用途由调用脚本决定。

原版随包 `ReadMe.txt` 把 0～3 分别标为新手村比武、中央比武高级、活动和犀牛猎人奖励。这是配套资料的用途标注，不是程序固定的对应关系，也不代表所有编号均安全可用。

### 字段说明

表头为 `No,ItemName,ItemCount,TotalRandom,randomrate,MaxValue,Kind,`。末尾逗号表示空列，不是另一项功能参数。

| 字段 | 含义与配置要求 |
| --- | --- |
| `No` | SDB 记录索引，保持唯一；不是概率、次数或奖池编号。建议连续编号，记录排列顺序与累计阈值顺序一致。 |
| `ItemName` | 奖励物品的内部名称，对应 `Init/Item.SDB` 的 `Name`，不一定等于游戏中显示的名称。 |
| `ItemCount` | 命中该行后返回的物品数量，应为正整数；不影响命中概率。 |
| `TotalRandom` | 累计权重上限。程序按加载后的记录顺序，选中第一条满足“随机数小于该值”的记录。不是该行单独的权重。 |
| `randomrate` | 加载器不读取，修改它不会改变抽奖结果。若用来记录单行权重，应填写本行 `TotalRandom` 减去上一行 `TotalRandom`，首行以前值 0 计算。 |
| `MaxValue` | 随机范围上限，只使用首条记录的值；必须为正整数。随机数范围为 `0` 至 `MaxValue - 1`，建议各行填写相同总权重。 |
| `Kind` | 加载器读取，但 `GetItemNamebyRandom` 不用它筛选、分组或计算概率；不是物品表的物品类型，也不是奖池编号，可留空。 |

### 抽取算法与概率

1. 从指定池首条记录取 `MaxValue`，生成一个 `0..MaxValue-1` 的随机整数。
2. 依次检查记录，命中第一条 `随机数 < TotalRandom` 的记录。
3. 返回该行的 `ItemName:ItemCount`。

标准配置中，累计阈值递增，末行 `TotalRandom` 等于首行 `MaxValue`。此时：

```text
本行权重 = 本行 TotalRandom - 上一行 TotalRandom（首行前值为 0）
本行概率 = 本行权重 / 首行 MaxValue
```

例如下面仅用于说明概率，不是默认奖励配置：

```csv
No,ItemName,ItemCount,TotalRandom,randomrate,MaxValue,Kind,
1,钱币,100,70,70,100,,
2,银元,1,95,25,100,,
3,金元,1,100,5,100,,
```

| 随机数 | 奖励 | 概率 |
| --- | --- | --- |
| 0～69 | 钱币 ×100 | 70% |
| 70～94 | 银元 ×1 | 25% |
| 95～99 | 金元 ×1 | 5% |

每次调用重新抽取，不累计抽奖次数，也没有“抽满一定次数必出”的保底。调整某一行权重后，应重算该行及后续累计阈值和总权重；只修改 `randomrate` 无效。

### 原版限制与维护注意

- 池不能为空，物品内部名称必须存在，数量必须为正，累计阈值必须覆盖完整随机范围。阈值相同会使后一行权重为零；阈值倒退或超过总权重会使概率与填写意图不符。
- 原版函数直接访问指定列表及其首项，没有非法编号、空池保护；未命中任何行时，局部变量 `nPos` 未赋值，不能把未覆盖区间当作安全的“未中奖”。
- 原版 `TRandomEventItemList.DataList` 只声明并初始化 0～2 三个列表，加载循环却访问 0～3，随包 `犀牛猎人.txt` 又调用 3，存在越界矛盾。云端神武版脚本中的 4、5 同样不能直接套用到该原版结构。目标程序若已调整容量和校验，应按其实际实现核对，不能只看文件是否存在。
- `Init/Item.SDB` 中物品 `Kind=55` 的原版双击路径固定从池 0 抽取；这里的物品类型与本表 `Kind` 列不是同一用途。

## Marry.sdb

字段为 `Girl,Boy,Party,GirlClothes,BoyClothes,MarryDate,UnMarry,UnMarryDate,BoyUnMarry,GirlUnMarry`。它是运行数据，不是静态模板；服务正常结束时会用内存状态整体覆盖文件。

公开的原版源码中存在四处已确认风险：

- `AddMarry` 新建记录时没有清零或赋值 `BoyUnMarry`、`GirlUnMarry`，两项初值不确定；
- `UnMarry` 把日期设为 `Now + 7`，完成判断又要求 `Now - UnMarryDate >= 7`，按代码实际需要约 14 天；
- 保存时把 `MarryDate` 写进 `UnMarryDate` 列，正常退出后会丢失原离婚日期；
- `Search` 同时要求姓名等于男方和女方，普通婚姻记录无法命中。

这些是源码行为，不应靠手改 SDB 掩盖。在线维护前先停服并备份；需要婚姻功能稳定时应单独修复、编译并回归测试程序。

## 可选但未部署的表

`EventItem1.sdb`～`4.sdb` 的加载字段为 `ItemName,ItemCount,Width`，供职业制造奖励路径使用；`TransMonsterList.sdb` 每行读取 `Name` 并要求名称存在于 `Monster.SDB`。原版随包均无这些文件，因此不能宣称原版随包已配置相关奖励池或随机变身。

原版源码还检查 `Event/NameList.SDB`，却实际从 `EtcSetting/NameList.SDB` 加载；原版随包两处都不存在，名单功能没有配套可用数据。

源码依据：[svClass.pas](TGS核心源码/svClass.pas) 的 `TBattleMapList`、`TRandomEventItemList`、`TEventItemClass`、`TTransMonsterListClass`、`TNameClass` 和 `TMarryClass`，以及 [uUserSub.pas](TGS核心源码/uUserSub.pas)。
