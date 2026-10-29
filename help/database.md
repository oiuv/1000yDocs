# 千年(1000y) 玩家数据库与存档维护

> 本文介绍账号与角色存档的分工、二进制布局、读写流程及备份注意事项。字节布局以文中注明的结构定义和编译对齐方式为准；不同程序中的同名 `TDBRecord` 不能混用。
>
> 主要参考源码：`db/FMain.pas`、`db/uConnector.pas`、`db/uRecordDef.pas`、`Common/uDBRecordDef.pas`、`Common/uDBProvider.pas`、`Common/uCookie.pas`、`Common/Usersdb.pas`、`Common/uLGRecordDef.pas`、`loginsql/uDBAdapter.pas`、`loginsdb/uDBAdapter.pas`

---

## 1. 数据库类型概览

| 数据库类型 | 文件扩展名 | 用途 | 使用模块 | 说明 |
|-----------|-----------|------|---------|------|
| **MSSQL** | — | SQL 登录实现的账号数据 | `loginsql/uDBAdapter.pas` | 通过 BDE `TQuery` 操作 `account1000y` 表 |
| **SDB** | `.sdb` | SDB 登录实现的账号数据 / 游戏配置 | `loginsdb/uDBAdapter.pas`、`Common/UserSdb.pas` | 纯文本 CSV 格式，`TUserStringDB` 类操作 |
| **FDB** | `.fdb` | 角色数据持久化 | `Common/uDBProvider.pas`、`db/uRecordDef.pas` | 自定义二进制格式，支持多文件扩展 |

### 1.1 各数据库的使用场景

- **FDB**：DB 服务器（默认端口 3051）使用 `TDBProvider` 管理角色数据。文件命名规则为 `XXX00.fdb`、`XXX01.fdb`……打开时最多扫描 64 个连续编号文件（`MAX_OPEN_FILE = 64`）；每个文件的槽位容量按 1 GiB 除以记录大小计算。
- **SDB**：`loginsdb` 使用 `TUserStringDB` 存储账号数据，文件位于 `.\Data\Login.sdb`。游戏配置数据（物品、怪物、地图等）也使用 SDB 格式。
- **MSSQL**：`loginsql` 使用 MSSQL 数据库，表名 `account1000y`。源码提供了两套 Login 实现，但没有把它们定义为通用的“开发/正式”模式；具体部署应以服务器实际启动的程序为准。

### 1.2 源码职责与同名结构

| 源码 | 职责 |
|------|------|
| `db/FMain.pas` | 读取 `DB.INI`、打开数据库、提供增加槽位/备份/文本导出入口 |
| `db/uConnector.pas` | 处理 Gate/TGS 的角色创建、查询、保存和锁定消息 |
| `Common/uDBProvider.pas` | FDB 文件读写、内存索引、空闲槽位及二进制备份；使用 `uRecordDef` |
| `db/uRecordDef.pas` | **磁盘记录**，`TDBRecord` 首字段为 `boUsed` |
| `Common/uDBRecordDef.pas` | **通信记录**，`TDBRecord` 从 `PrimaryKey` 开始，不包含 `boUsed` |
| `Common/uCookie.pas` | 存档使用的 `oz_CRC32` 自定义查表校验 |

`db/uRecordDef.pas` 使用普通 `record`，DB 工程的 `db.cfg` 指定 `-$A1`（1 字节对齐）；`Common/uDBRecordDef.pas` 则直接使用 `packed record`。在这一布局下：

| 对照项 | 通信记录 | 磁盘记录 |
|--------|----------|----------|
| 完整大小 | 5888 字节 | 5889 字节 |
| `boUsed` | 无 | 偏移 0，1 字节 |
| `PrimaryKey` | 偏移 0 | 偏移 1 |
| `CRCKey` | 偏移 5884 | 偏移 5885 |

下文第 2 节的字段偏移均相对于**通信记录起点**；定位磁盘槽位中的同一字段时，需要再加 1。部分等位字段的名称不同，如 `CurExtJobExp` / `CurJobExp`、`HaveMysteryArr` / `HaveMysteryMagicArr`、`rLockState` / `LockState`，不能仅凭字段名判断格式不同。

---

## 2. TDBRecord 完整字段说明

> 来源：`Common/uDBRecordDef.pas` 中的 `TDBRecord = packed record`
>
> **注意**：`packed record` 表示紧凑排列，无对齐填充。所有多字节整数均为小端序（Little-Endian）。字符串字段为固定长度字节数组，以 `\x00` 结尾（Pascal `StrPas` 语义）。

### 2.1 子结构定义

| 结构名 | 大小(字节) | 字段 |
|--------|-----------|------|
| `TDBBasicMagicData` | 4 | `Skill: integer` |
| `TDBMagicData` | 24 | `Name: array[0..19] of byte` + `Skill: integer` |
| `TDBItemData` | 35 | `Name(20)` + `Count(4)` + `Color(1)` + `Durability(2)` + `CurDurability(2)` + `UpGrade(1)` + `AddType(1)` + `Dummy(1)` + `rLockState(1)` + `runLockTime(2)` |
| `TDBMarketItemData` | 36 | `Name(20)` + `Count(4)` + `Color(1)` + `Durability(2)` + `CurDurability(2)` + `UpGrade(1)` + `AddType(1)` + `Cost(4)` + `Dummy(1)` |
| `TDBBestMagicData` | 45 | `Name(20)` + `Grade(1)` + `rDamageBody/Head/Arm/Leg/Energy(5×2=10)` + `rArmorBody/Head/Arm/Leg/Energy(5×2=10)` + `Skill(4)` |

### 2.2 TDBRecord 字段表

**总大小：5888 字节**（基于 `Common/uDBRecordDef.pas` packed record 精确计算）

#### 基础信息（偏移 0–126，共 127 字节）

| 偏移 | 大小 | 字段名 | 类型 | 说明 |
|------|------|--------|------|------|
| 0 | 20 | `PrimaryKey` | `array[0..19] of byte` | 角色名（主键） |
| 20 | 20 | `MasterName` | `array[0..19] of byte` | 账号名 |
| 40 | 10 | `Password` | `array[0..9] of byte` | 角色密码 |
| 50 | 2 | `GroupKey` | `Word` | 团体编号（门主/门员标识） |
| 52 | 20 | `Guild` | `array[0..19] of byte` | 门派名称 |
| 72 | 12 | `LastDate` | `array[0..11] of byte` | 最后登录日期 |
| 84 | 12 | `CreateDate` | `array[0..11] of byte` | 创建日期 |
| 96 | 6 | `Sex` | `array[0..5] of byte` | 性别 |
| 102 | 20 | `Lover` | `array[0..19] of byte` | 配偶名（2004-12-21 添加） |
| 122 | 1 | `ServerId` | `byte` | 当前地图编号 |
| 123 | 2 | `x` | `word` | X 坐标 |
| 125 | 2 | `y` | `word` | Y 坐标 |

#### 基础属性（偏移 127–182，共 56 字节，14 个 Integer）

| 偏移 | 大小 | 字段名 | 类型 | 说明 |
|------|------|--------|------|------|
| 127 | 4 | `Light` | `Integer` | 阳气 |
| 131 | 4 | `Dark` | `Integer` | 阴气 |
| 135 | 4 | `Energy` | `Integer` | 元气 |
| 139 | 4 | `InPower` | `Integer` | 内功 |
| 143 | 4 | `OutPower` | `Integer` | 外功 |
| 147 | 4 | `Magic` | `Integer` | 武功 |
| 151 | 4 | `Life` | `Integer` | 活力 |
| 155 | 4 | `Talent` | `Integer` | 才能 |
| 159 | 4 | `GoodChar` | `Integer` | 神圣 |
| 163 | 4 | `BadChar` | `Integer` | 魔性 |
| 167 | 4 | `Adaptive` | `Integer` | 耐性 |
| 171 | 4 | `Revival` | `Integer` | 再生 |
| 175 | 4 | `Immunity` | `Integer` | 免疫 |
| 179 | 4 | `Virtue` | `Integer` | 浩然之气 |

#### 当前状态（偏移 183–226，共 44 字节，11 个 Integer）

| 偏移 | 大小 | 字段名 | 类型 | 说明 |
|------|------|--------|------|------|
| 183 | 4 | `CurEnergy` | `Integer` | 当前元气 |
| 187 | 4 | `CurInPower` | `Integer` | 当前内功 |
| 191 | 4 | `CurOutPower` | `Integer` | 当前外功 |
| 195 | 4 | `CurMagic` | `Integer` | 当前武功 |
| 199 | 4 | `CurLife` | `Integer` | 当前活力 |
| 203 | 4 | `CurHealth` | `Integer` | 当前健康度 |
| 207 | 4 | `CurSatiety` | `Integer` | 当前饱食度 |
| 211 | 4 | `CurPoisoning` | `Integer` | 当前中毒度 |
| 215 | 4 | `CurHeadSeek` | `Integer` | 头部活力 |
| 219 | 4 | `CurArmSeek` | `Integer` | 手臂活力 |
| 223 | 4 | `CurLegSeek` | `Integer` | 腿部活力 |

#### 经验与等级（偏移 227–239，共 13 字节）

| 偏移 | 大小 | 字段名 | 类型 | 说明 |
|------|------|--------|------|------|
| 227 | 4 | `ExtraExp` | `Integer` | 额外经验 |
| 231 | 4 | `AddableStatePoint` | `Integer` | 可分配状态点 |
| 235 | 4 | `TotalStatePoint` | `Integer` | 总状态点 |
| 239 | 1 | `CurrentGrade` | `Byte` | 当前等级 |

#### 武功数组（偏移 240–519，共 280 字节）

| 偏移 | 大小 | 字段名 | 类型 | 说明 |
|------|------|--------|------|------|
| 240 | 40 | `BasicMagicArr` | `array[0..9] of TDBBasicMagicData` | 基本武功（10×4 字节） |
| 280 | 240 | `BasicRiseMagicArr` | `array[0..9] of TDBMagicData` | 浪人武功（10×24 字节） |

#### 装备与物品数组（偏移 520–1849，共 1330 字节）

| 偏移 | 大小 | 字段名 | 类型 | 说明 |
|------|------|--------|------|------|
| 520 | 280 | `WearItemArr` | `array[0..7] of TDBItemData` | 穿戴装备（8×35 字节） |
| 800 | 1050 | `HaveItemArr` | `array[0..29] of TDBItemData` | 持有物品（30×35 字节） |

#### 武功数组（续）（偏移 1850–4009，共 2160 字节）

| 偏移 | 大小 | 字段名 | 类型 | 说明 |
|------|------|--------|------|------|
| 1850 | 720 | `HaveMagicArr` | `array[0..29] of TDBMagicData` | 持有武功（30×24 字节） |
| 2570 | 720 | `HaveRiseMagicArr` | `array[0..29] of TDBMagicData` | 上层武功（30×24 字节） |
| 3290 | 720 | `HaveMysteryArr` | `array[0..29] of TDBMagicData` | 掌法武功（30×24 字节） |

#### 绝世武功数组（偏移 4010–5134，共 1125 字节）

| 偏移 | 大小 | 字段名 | 类型 | 说明 |
|------|------|--------|------|------|
| 4010 | 675 | `HaveBestSpecialMagicArr` | `array[0..14] of TDBBestMagicData` | 绝世武功-招式/必杀技（15×45 字节） |
| 4685 | 225 | `HaveBestProtectMagicArr` | `array[0..4] of TDBBestMagicData` | 绝世武功-功力（5×45 字节） |
| 4910 | 225 | `HaveBestAttackMagicArr` | `array[0..4] of TDBBestMagicData` | 绝世武功-攻击型（5×45 字节） |

#### 材料与个人商店（偏移 5135–5669，共 535 字节）

| 偏移 | 大小 | 字段名 | 类型 | 说明 |
|------|------|--------|------|------|
| 5135 | 175 | `HaveMaterialItemArr` | `array[0..4] of TDBItemData` | 材料窗口（5×35 字节） |
| 5310 | 360 | `HaveMarketItemArr` | `array[0..9] of TDBMarketItemData` | 个人贩卖窗口（10×36 字节） |

#### 个人信息与任务（偏移 5670–5751，共 82 字节）

| 偏移 | 大小 | 字段名 | 类型 | 说明 |
|------|------|--------|------|------|
| 5670 | 20 | `Person1` | `array[0..19] of byte` | 个人信息 1 |
| 5690 | 20 | `Person2` | `array[0..19] of byte` | 个人信息 2 |
| 5710 | 10 | `Key` | `array[0..9] of byte` | 快捷键设置 |
| 5720 | 4 | `CompleteQuestNo` | `Integer` | 已完成任务编号 |
| 5724 | 4 | `CurrentQuestNo` | `Integer` | 当前任务编号 |
| 5728 | 20 | `QuestStr` | `array[0..19] of byte` | 任务字符串 |
| 5748 | 4 | `FirstQuestNo` | `Integer` | 初学者村庄任务值 |

#### 职业系统（偏移 5752–5757，共 6 字节）

| 偏移 | 大小 | 字段名 | 类型 | 说明 |
|------|------|--------|------|------|
| 5752 | 1 | `JobKind` | `Byte` | 职业种类（0=无, 1=炼金术师, 2=炼丹术师, 3=服饰家, 4=匠人, 5=矿工） |
| 5753 | 1 | `ExtJobKind` | `Byte` | 扩展职业种类 |
| 5754 | 4 | `CurExtJobExp` | `Integer` | 当前职业经验 |

> 注：`db/uRecordDef.pas` 中此字段名为 `CurJobExp`，`Common/uDBRecordDef.pas` 中为 `CurExtJobExp`。

#### 其他字段（偏移 5758–5887，共 130 字节）

| 偏移 | 大小 | 字段名 | 类型 | 说明 |
|------|------|--------|------|------|
| 5758 | 20 | `Person3` | `array[0..19] of byte` | 祭司事件用 |
| 5778 | 20 | `Person4` | `array[0..19] of byte` | 预留个人信息 4 |
| 5798 | 20 | `EventRecord` | `array[0..19] of byte` | 事件记录 |
| 5818 | 66 | `Dummy` | `array[0..65] of byte` | 预留空间 |
| 5884 | 4 | `CRCKey` | `Cardinal` | `oz_CRC32` 自定义校验值 |

#### 总字节数验证

| 区段 | 偏移范围 | 字节数 |
|------|---------|--------|
| 基础信息（PrimaryKey → y） | 0–126 | 127 |
| 基础属性（Light → Virtue） | 127–182 | 56 |
| 当前状态（CurEnergy → CurLegSeek） | 183–226 | 44 |
| 经验等级（ExtraExp → CurrentGrade） | 227–239 | 13 |
| 武功数组（Basic + Rise） | 240–519 | 280 |
| 装备物品（Wear + Have） | 520–1849 | 1330 |
| 武功数组（Magic + Rise + Mystery） | 1850–4009 | 2160 |
| 绝世武功（Special + Protect + Attack） | 4010–5134 | 1125 |
| 材料 + 个人商店 | 5135–5669 | 535 |
| 个人信息 + 任务 | 5670–5751 | 82 |
| 职业系统 | 5752–5757 | 6 |
| 其他（Person3/4 + Event + Dummy + CRC） | 5758–5887 | 130 |
| **合计** | **0–5887** | **5888** |

> **说明**：本表的 5888 字节是通信记录大小，对应 FDB 文件头中的 `RecordDataSize`。`RecordFullSize` 是包含 `boUsed` 的磁盘记录大小，即 5889 字节。读取存档时应检查文件头与目标版本的结构是否一致，不能把两者当作同一个长度。

---

## 3. FDB 文件格式

> 来源：`db/uRecordDef.pas`（DB 工程按 1 字节对齐编译）和 `Common/uDBProvider.pas`（`TDBProvider` 实现）。本节的 `TDBRecord` 若未另行说明，均指包含 `boUsed` 的磁盘记录。

### 3.1 文件头 TDBHeader

> DB 实际使用 `db/uRecordDef.pas` 的 `TDBHeader`；按 `-$A1` 编译时，与 `Common/uDBRecordDef.pas` 中的 packed 文件头布局相同。

```
偏移  大小  字段             说明
0     4    ID               固定为 'DBID'（4 字节）
4     4    RecordCount      当前文件的总槽位数，包含空闲槽位
8     4    RecordDataSize   通信记录大小 = SizeOf(磁盘记录) - 1 = 5888
12    4    RecordFullSize   磁盘记录大小 = SizeOf(磁盘记录) = 5889
16    1    boSavedIndex     是否已保存索引（Boolean）
17    32   Dummy            保留空间（array[0..31] of byte）
```

**文件头总大小：49 字节**（1 字节对齐，4+4+4+4+1+32 = 49）。

### 3.2 索引头 TIndexHeader

```
偏移  大小  字段                说明
0     4    ID                  固定为 'IDX'（3 字节 + 1 字节 null）
4     4    IndexRecordCount    索引记录数量
8     4    BlankRecordCount    空白记录数量
12    32   FDBUpdateDate       FDB 更新日期字符串
44    32   Dummy               保留
```

**索引头总大小：76 字节**

### 3.3 文件布局

```
FDB 文件
├─ TDBHeader：49 字节
├─ Slot 0：boUsed(1) + Payload(5888) = 5889 字节
├─ Slot 1：boUsed(1) + Payload(5888) = 5889 字节
├─ ...
└─ Slot N-1：boUsed(1) + Payload(5888) = 5889 字节
```

图中的 `Payload` 是第 2 节的通信记录。每个磁盘槽位由 `boUsed`（1 字节）+ 通信记录（5888 字节）= **5889 字节**组成，整体才是 DB 端的 `TDBRecord`。

`boUsed` 字段标识该记录是否被使用：

- `boUsed = 1`：已分配，包含有效角色数据
- `boUsed = 0`：空白槽位，可被新角色复用

> 注：`boUsed` 是 `db/uRecordDef.pas` 中 DB 服务器端 `TDBRecord` 的第一个字段（`boUsed: byte`），后接与 `Common/uDBRecordDef.pas` 中 packed `TDBRecord` 对应的数据（5888 字节）。

### 3.4 多文件扩展策略

- 文件命名：`{名称}{序号}.fdb`，如 `createdb00.fdb`、`createdb01.fdb`
- 序号 < 10 时补零（`%s0%d%s`），≥ 10 不补零（`%s%d%s`）
- 每个文件的槽位容量：`1024 × 1024 × 1024 div 5889 = 182,330`；这是记录区的容量算法，文件还包含 49 字节文件头。
- 打开时最多扫描 64 个文件（`00`–`63`）。编号必须连续，遇到缺失编号即停止扫描后续文件。
- 新库初始化预分配 10,000 个槽位。后续通过 DB 界面的增加记录按钮（`cmdAddRecord`）增加空闲槽位，调用 `AddBlankRecord`；该方法按单文件容量分配，当前文件满后才创建下一个编号文件。
- **创建角色不自动增加槽位**：`Insert` 只从 `BlankList` 取现有空位；空位耗尽时返回 `DB_ERR_NOTENOUGHSPACE`。应根据界面剩余槽位安排扩容，而不是等待新角色创建时自动扩容。

### 3.5 记录定位算法

```
槽位起点 = 49(TDBHeader) + RecordNo × 5889(磁盘记录)
通信字段的文件内偏移 = 槽位起点 + 1(boUsed) + 第 2 节字段偏移
```

查找流程：

1. 通过 `TIndexClass` 的**二分查找**在内存索引中定位角色名 → 得到 `(FileNo, RecordNo)`
2. 选择对应的文件流 `DBStream[FileNo]`
3. `Seek(49 + RecordNo × 5889)`
4. 读取/写入完整磁盘记录（包含 `boUsed`）

索引在启动时从所有 FDB 文件扫描构建，按角色名排序后使用二分查找（`O(log n)`）。

### 3.6 索引文件（IDX）

索引文件存储 `TIndexHeader` + 所有 `TIndexData` + 所有 `TBlankData`：

```
┌──────────────────────────────────────┐
│ TIndexHeader (76 bytes)              │
├──────────────────────────────────────┤
│ TIndexData[0] (Name→FileNo→RecordNo) │
│ TIndexData[1]                        │
│ ...                                  │
├──────────────────────────────────────┤
│ TBlankData[0] (FileNo→RecordNo)      │
│ TBlankData[1]                        │
│ ...                                  │
└──────────────────────────────────────┘
```

> 注：当前实现中，索引文件加载功能已被注释掉（`OpenDB` 中），启动时直接扫描所有 FDB 文件构建内存索引。

### 3.7 oz_CRC32 存档校验

- 来源：`Common/uCookie.pas` 中的 `oz_CRC32` 函数。它使用源码内的 **256 项自定义查找表**，不是通用的标准 CRC32，不能用通用 CRC32 实现替代。
- 计算范围：**磁盘记录**的前 `5889 - 4 = 5885` 字节，从 `boUsed` 开始，直到 `CRCKey` 之前。只有通信数据时，需要先补上 `boUsed=1`，再计算；不能只对通信记录的前 5884 字节计算。
- 存储位置：磁盘记录偏移 5885，通信记录偏移 5884，均为最后 4 字节的 `Cardinal`。
- 写入策略：`DB_UPDATE` 直接保留传入的校验值；`DB_UPDATE_END`、`DB_CREATENEW` 和远程管理写入路径会重算校验。`DB_INSERT` 作为请求的处理见第 6.6 节。
- 读取校验：`DB_SELECT` 读取磁盘记录后重新计算；不匹配时返回 `DB_ERR_NOTFOUND`，不会把角色数据返回给 Gate。

```pascal
// db/uConnector.pas — RecordData 是包含 boUsed 的磁盘记录
RecordData.CRCKey := oz_CRC32(@RecordData, SizeOf(RecordData) - 4);
```

算法初始值为 `$FFFFFFFF`，对每个输入字节执行 `crc := (crc shr 8) xor crc32tab[byte xor (crc and $FF)]`，最后按 32 位取反。复现时必须使用 `Common/uCookie.pas` 的完整查找表。

可用不含玩家数据的校验向量验证实现：ASCII `123456789`（9 字节）的 `oz_CRC32` 结果为 **`$930A5BD6`**。

### 3.8 TCheckCharData 保存队列封装

```pascal
TCheckCharData = packed record
   rCharData : TDBRecord;
   rEnd : Byte;     // 结束标记
end;
```

这里的 `TDBRecord` 是 **5888 字节通信记录**，`TCheckCharData` 共 5889 字节。它只在 Game 的保存缓冲队列中把角色记录与发送类型标志放在一起：`rEnd=0` 发送 `DB_UPDATE`，`rEnd=1` 发送 `DB_UPDATE_END`。实际发往 DB 的只有 `rCharData`；尾部 `rEnd` 不随记录传输。虽然总长度与磁盘记录相同，两者布局不同，不能互换。

---

## 4. SDB 文件格式

> 来源：`Common/UserSdb.pas` 中的 `TUserStringDB` 类

### 4.1 文件结构

SDB 是**纯文本 CSV 格式**文件，使用 ANSI 编码（GBK/朝鲜语）：

```
字段名1,字段名2,字段名3,...,字段名N,
记录名1,值1,值2,值3,...,值N,
记录名2,值1,值2,值3,...,值N,
...
```

- **第 1 行**：字段定义行，逗号分隔，末尾有逗号
- **后续行**：每行一条记录，第 1 个字段为记录名（主键），后续字段按定义行顺序排列
- 行分隔符：`CR+LF`（`\r\n`）
- 删除标记：以 `,` 开头的行表示已删除记录（加载时自动跳过）

### 4.2 内存结构

```
TUserStringDB
├── FieldList: TStringList          // 字段名列表（有序）
├── LowerFieldList: TList           // 小写字段名索引
├── AnsIndexClass: TAnsIndexClass   // 字段名快速查找（ANSI 索引树）
├── NameList: TNameList             // 记录名列表（二分查找，按名称排序）
├── DbStringList: TStringList       // 原始数据行列表
└── Open_Data: TList                // 当前打开记录的字段值缓存
```

### 4.3 数据操作方式

- **查找记录**：通过 `NameList` 二分查找记录名 → 得到行索引 → 从 `DbStringList` 获取原始行
- **读取字段**：先 `OpenRecord(记录名)` 将行数据拆分到 `Open_Data` 缓存，再按字段索引取值
- **写入字段**：修改 `Open_Data` 中的值，`CloseRecord` 时重新拼合为逗号分隔字符串写回 `DbStringList`
- **保存文件**：`SaveToFile` 将字段行 + 所有数据行写入文件（整体重写）
- **布尔值**：存储为字符串 `'TRUE'` / `'FALSE'`
- **整数值**：存储为十进制数字字符串

### 4.4 SDB 在账号系统中的应用

`loginsdb/uDBAdapter.pas` 中的 `TSDBAdapter` 使用 `TUserStringDB` 存储账号数据。运行时读取工作目录下的 `Data/Login.sdb`。首次部署可从 `Data/Login.sdb.example` 创建仅含表头的空库，已有账号库必须保留，不用示例覆盖。表头为：

```
PrimaryKey,Password,CharInfo0,CharInfo1,CharInfo2,CharInfo3,CharInfo4,IpAddr,UserName,Birth,Telephone,MakeDate,LastDate,Address,Email,NativeNumber,MasterKey,PtName,PtNativeNumber,
```

`PrimaryKey` 是记录主键/账号名；`CharInfo0..4` 的值采用 `角色名:服务器名` 格式；`PtName`、`PtNativeNumber` 是当前文件保留的监护人字段。字段名和顺序必须以实际首行为准。

账号的 `Insert`、`Update` 在返回 `DB_OK` 前保存主文件：在目标目录创建临时文件，按原 SDB 表头、字段顺序和 ANSI/GBK 字节写入，使用 CRLF 换行；写入并刷新成功后才替换目标文件。保存失败返回 `DB_ERR_IO`，撤销本次内存变更，不把失败变更留给后续操作保存。正常退出不再额外重写账号文件，也不应依赖退出操作完成持久化。

保存仍是全表快照，不是逐条追加日志；账号数量较多时应实测写入耗时。`FMain.timerDisplayTimer` 检测到日期变化后，另存 `Backup/Login YYYY-MM-DD.SDB`（文件名使用变化前的日期），其内容为备份执行时的账号状态。备份使用相同写入方式，但它与主文件是两个独立文件。运行前应准备好 `Data`、`Backup` 目录及写入权限。

---

## 5. SQL 账号表结构

> 来源：`loginsql/uDBAdapter.pas`、`Common/uLGRecordDef.pas`

### 5.1 account1000y 表

> 源码没有提供 `CREATE TABLE` 或其他 MSSQL DDL。下表的列顺序来自 `TQuery.Fields[n]` 和 SQL 拼接代码；“Pascal 侧长度”来自 `TLGRecord` 的字符串缓冲区，只表示程序截取上限，不等同于 MSSQL 的真实列类型。

| 列序号 | 列名 | Pascal 侧长度 | 说明 |
|--------|------|----------------|------|
| 0 | `account` | `String[20]` | 账号名（主键） |
| 1 | `password` | `String[20]` | 密码 |
| 2 | `char1` | `String` | 角色 1（格式：`角色名:服务器名`） |
| 3 | `char2` | `String` | 角色 2 |
| 4 | `char3` | `String` | 角色 3 |
| 5 | `char4` | `String` | 角色 4 |
| 6 | `char5` | `String` | 角色 5 |
| 7 | `ipaddr` | `String[16]` | IP 地址 |
| 8 | `username` | `String[20]` | 用户名 |
| 9 | `birth` | `String[20]` | 生日 |
| 10 | `telephone` | `String[20]` | 电话 |
| 11 | `makedate` | `String[20]` | 创建日期 |
| 12 | `lastdate` | `String[20]` | 最后登录日期 |
| 13 | `address` | `String[50]` | 地址 |
| 14 | `email` | `String[50]` | 邮箱 |
| 15 | `nativenumber` | `String[20]` | 身份证号 |
| 16 | `masterkey` | `String[20]` | 主密钥 |

查询只读取序号 0～16。新增账号的 `INSERT` 还显式包含 `ptname`、`ptnativenumber` 两列，因此目标表必须具备这两列；语句共写入 19 列、19 个值。由于 `TLGRecord` 不包含监护人字段，新增时这两列写入空字符串，普通更新不修改它们。此要求来自适配器代码，不代表已经核实任一部署的真实表结构；部署时仍需检查列定义、约束及前 17 列的顺序。

查询、新增或更新发生数据库异常时返回 `DB_ERR_IO`，不继续按旧的影响行数判定成功；前置查询失败也不会继续执行写入。`DB_ERR_NOTFOUND` 表示没有找到记录，不能用来代替数据库连接或执行失败。

### 5.2 TLGRecord 结构

```pascal
TLGRecord = record
   PrimaryKey   : String[20];   // 账号名
   PassWord     : String[20];   // 密码
   UserName     : String[20];   // 用户名
   Birth        : String[20];   // 生日
   Address      : String[50];   // 地址
   NativeNumber : String[20];   // 身份证号
   MasterKey    : String[20];   // 主密钥
   Email        : String[50];   // 邮箱
   Phone        : String[20];   // 电话
   CharInfo     : array[0..4] of TCharData;  // 5 个角色槽位
   IpAddr       : String[16];   // IP 地址
   MakeDate     : String[20];   // 创建日期
   LastDate     : String[20];   // 最后登录
end;

TCharData = record
   CharName   : String[20];     // 角色名
   ServerName : String[20];     // 服务器名
end;
```

### 5.3 登录验证流程

```
客户端 → Balance(3053) → Gateway(3054)
                              │
                              ├─ 1. Gate 接收 LoginID + LoginPW
                              ├─ 2. Gate → Login：LG_SELECT，仅发送 PrimaryKey
                              ├─ 3. Login 使用自身适配器查询 MSSQL 或 Login.sdb
                              ├─ 4. Login → Gate：返回完整 TLGRecord
                              ├─ 5. Gate 比对 PrimaryKey 和 PassWord
                              ├─ 6. Gate → Login：LG_UPDATE，更新 IP/LastDate
                              ├─ 7. Gate 向客户端发送 CharInfo[0..4]
                              └─ 8. Gate 按配置向 Paid 校验账号付费状态
```

角色数据 DB（3051）不参与账号密码查询；它在玩家选择角色后按角色名处理 `DB_SELECT`。

### 5.4 两种 Login 实现的功能边界

两种 Login 都使用 `LG_SELECT`、`LG_INSERT`、`LG_UPDATE` 和同一份 `TLGRecord`，是账号服务的替代实现，不是需要串联启动的两个服务，也不决定角色属性和背包的 FDB 存储方式。

| 项目 | SDB Login | SQL Login |
| --- | --- | --- |
| 存储 | `Data/Login.sdb`，启动加载到内存 | BDE/ODBC 连接，访问 `account1000y` 表 |
| 写入 | 新增、更新成功前保存 SDB 快照 | 执行 SQL 新增、更新语句 |
| 备份 | 检测到跨日后另存 SDB 快照 | 程序未实现对应备份任务，需另行管理数据库备份 |
| 远程管理连接 | 监听 `REMOTEACCEPTPORT`，默认 TCP 1021 | 主动连接 `REMOTE_SERVER`，默认 `127.0.0.1:6060` |
| 管理协议 | 文本命令 | 封装的数据包，不能直接复用 SDB 管理连接 |
| 管理功能 | `FIELDS`、`READ`、`WRITE` | `FIELDS`、`READ`、`WRITE`，有读写结果回报 |
| 接入检查 | `sckAccept` 不调用 IP 检查器 | 使用 `IPList.txt`，规则见[配置说明](protocol.md#55-配置文件) |

两者管理接口中的 `CREATE`、`DELETE` 分支均为空，适配器 `Delete` 不执行删除并返回 `DB_ERR`，不能当作完整账号增删接口。Login 处理 `LG_INSERT` 不代表客户端注册已开放：当前 Gate 的 `CM_CREATEIDPASS`、`CM_CREATEIDPASS2`、`CM_CREATEIDPASS3` 分支直接退出。切换 Login 实现前应迁移账号数据并核对配置、SQL 表结构和管理工具协议，不能只替换 EXE。

---

## 6. 数据持久化流程

### 6.1 保存时机

角色状态收集和发送到 DB 是两个步骤：

1. **定期收集内存状态**：`UUser.pas` 每约 **10 分钟**（`10 * 60 * 100` 个默认 10ms tick）把角色状态写入 `Connector.CharData`，以下代码本身不发送 DB 请求。

   ```pascal
   // tgs1000/UUser.pas
   if CurTick >= SaveTick + 10 * 60 * 100 then begin
      SaveTick := CurTick;
      SaveUserData(Name);
      WearItemClass.SaveToSdb(@Connector.CharData);
      HaveItemClass.SaveToSdb(@Connector.CharData);
      AttribClass.SaveToSdb(@Connector.CharData);
      HaveMagicClass.SaveToSdb(@Connector.CharData);
      HaveJobClass.SaveToSdb(@Connector.CharData);
      HaveMarketClass.SaveToSdb(@Connector.CharData);
   end;
   ```

2. **定期发送保存**：`uConnect.pas` 的 `TConnector.Update` 在 TGS 主窗口 `chkSaveUserData` 勾选时，每约 10 分钟把 `CharData` 加入保存队列，设置 `rEnd=1`，由队列发送 `DB_UPDATE_END`。关闭该选项会停止这条定期入队路径，不等于关闭内存状态收集。

3. **角色下线**：`TConnector.Destroy` 在角色名有效时将最终记录按 `rEnd=1` 入队，并发送 `DB_UNLOCK`；普通状态（`bcs_none`）会先结束角色层。跨服转移还应结合角色层结束和目标服加载流程理解，不能仅凭调用 `SaveUserData` 判断已写入磁盘。

保存队列及 DB 回包处理见[系统架构的数据持久化章节](architecture.md#6-数据持久化流程)。备份前应确认最终保存已处理完成，不能把“已入队”等同于“已写盘”。网络发送缓冲接受记录后，TGS 就会将其从保存队列移除；DB 失败回包只记日志，不自动重新入队。正常关服也不逐条等待 DB 确认，具体边界见[保存失败与关服](architecture.md#66-保存失败与关服边界)。

### 6.2 保存数据收集流程

`TUser.SaveUserData` 方法（`tgs1000/UUser.pas`）收集以下数据到 `Connector.CharData`（即 `TDBRecord`）：

1. 密码（`Password`）
2. 团体编号（`GroupKey`）
3. 快捷键（`Key` ← `ShortCut`）
4. 配偶名（`Lover`）
5. 任务数据（`CompleteQuestNo`、`CurrentQuestNo`、`QuestStr`、`FirstQuestNo`）
6. 服务器 ID（`ServerId`）
7. 门派名（`Guild`）
8. 坐标（`x`、`y`）
9. 事件记录（`EventRecord`）

装备、物品、属性、武功、职业、商店数据由各自的 `SaveToSdb` 方法写入 `Connector.CharData` 的对应数组。

### 6.3 DB 校验与回包

```
TGS 发送通信记录（5888 字节）
  → DB 补 boUsed=1，组成磁盘记录（5889 字节）
  → DB_UPDATE_END 重算校验；DB_UPDATE 保留传入值
  → TDBProvider.Update 查找并写入磁盘槽位
  → 回包携带操作结果；成功时带角色名
```

校验算法和范围见第 3.7 节。`DB_SELECT` 成功时返回去掉 `boUsed` 的通信记录；失败时不返回记录。由于校验失败也映射为 `DB_ERR_NOTFOUND`，这个返回码并不总表示磁盘上没有该角色。

### 6.4 DB 服务器写入流程

```
1. 接收游戏服务器通过其自身 DB 连接发来的保存请求（`tgs1000/FGate.pas`）
2. 设置 boUsed=1，将通信数据复制到磁盘记录的 PrimaryKey 起始位置
3. DB_UPDATE_END 时重算 oz_CRC32 → 写入 CRCKey
4. IndexClass 查找角色名 → (FileNo, RecordNo)；UpdateDisk 读取旧记录并核对主键
5. Seek(SizeOf(TDBHeader) + RecordNo × Header[FileNo].RecordFullSize)
6. WriteBuffer 写入完整磁盘记录（本布局为 5889 字节）
```

### 6.5 错误码定义

> 来源：`1000ydef/deftype.pas`

| 常量 | 值 | 说明 |
|------|-----|------|
| `DB_OK` | 0 | 操作成功 |
| `DB_ERR` | 1 | 一般错误 |
| `DB_ERR_NOTFOUND` | 2 | 记录未找到 |
| `DB_ERR_DUPLICATE` | 3 | 重复的主键 |
| `DB_ERR_IO` | 4 | I/O 错误 |
| `DB_ERR_INVALIDDATA` | 5 | 无效数据 |
| `DB_ERR_NOTENOUGHSPACE` | 6 | 空间不足 |
| `DB_ERR_DATAEND` | 7 | 数据结束 |
| `DB_ERR_EMPTY` | 8 | 空数据 |

### 6.6 创建角色请求与回复

> 来源：`gate/uConnector.pas` 的建角发送分支，以及 `db/uConnector.pas` 的 `MessageProcess`。

| 方向 | 消息 | 当前处理 |
|------|------|----------|
| Gate → DB | `DB_CREATENEW = 10` | 有效的建角请求；DB 补 `boUsed`，设置初始角色数据，计算校验并插入空闲槽位 |
| DB → Gate | `DB_INSERT = 0` | 返回上述建角操作结果和角色名；回复消息号不是 `DB_CREATENEW` |
| 调用方 → DB | `DB_INSERT = 0` | 直接返回 `DB_ERR_DUPLICATE`，不创建角色；不能把回复消息号当成请求入口 |

角色查询仍使用 `DB_SELECT`。账号名和角色列表由 Login 保存，不在 FDB 中统一维护；迁移或恢复角色存档时，也需要核对对应 Login 数据中的账号绑定。

---

## 7. DB 配置与容量管理

### 7.1 DB.INI

`db/FMain.pas` 从进程工作目录读取 `.\DB.INI`。文件缺失时写入以下默认配置，键缺失时使用同样的默认值；这些是源码默认值，不代表实际部署值。

```ini
[DB_SERVER]
FileName=TESTDB.FDB
BufferSizeS2S=1048576
GateAcceptPort=3051
RemotePort=1024
ItemRemotePort=1020
```

| 配置项 | 含义 |
|--------|------|
| `FileName` | 数据库文件族的基础路径；`TESTDB.FDB` 对应实际文件 `TESTDB00.FDB`、`TESTDB01.FDB`…… |
| `BufferSizeS2S` | 主连接器使用的服务间通信缓冲区大小，单位为字节 |
| `GateAcceptPort` | Gate/TGS 连接 DB 的监听端口 |
| `RemotePort` | 角色远程管理连接的监听端口 |
| `ItemRemotePort` | 物品远程管理连接的监听端口 |

相对路径按进程工作目录解析。启动前应核对工作目录、数据库文件族和相关输出目录；远程连接还会读取 `.\RemoteIP.txt`，它与上述监听端口不是同一项配置。DB 及远程管理端口应限制在回环或可信内网，不能直接对玩家公网开放。

### 7.2 初始化与增加槽位

- 主窗口启动时先调用 `OpenDB`；失败后会进入创建/打开及预分配 10,000 个槽位的初始化分支。因此，路径错误或旧库打开失败时，应先核查原因，不能把“进入初始化”视为原库不存在的可靠证明。
- 界面的总记录数是**总槽位数**，已用数来自角色索引，未用数来自空闲槽位列表，不是三个不同的角色统计口径。
- 增加记录按钮（`cmdAddRecord`）接收要追加的正整数槽位数，调用 `AddBlankRecord`。操作前先备份，操作后核对槽位统计和实际文件；单文件分配规则见第 3.4 节。
- `OpenDB` 会以读写方式打开 FDB、扫描有效角色并重建索引。发现无效/重复索引记录时存在清空槽位的处理，**不是只读检查器**；分析存档时应使用副本。

---

## 8. 备份、文本导出与恢复检查

### 8.1 三种文件不能混为一谈

| 方式 | 内容与用途 |
|------|------------|
| 正常停服后的完整 FDB 文件族副本 | 保留文件头、已用/空闲槽位及分文件布局，适合作为角色库的完整恢复基础 |
| DB 界面的 FDB 备份 | `BackupFDB` 写出单个 `UserData/Backup年-月-日.FDB`，按内存索引逐条导出有效角色记录 |
| `UserData/*.SDB`、`Web/*.SDB` 文本导出 | 把收到保存更新的角色信息转换为文本；不是遍历全部 FDB 的完整二进制备份 |

角色 FDB 不包含 Login 账号库。完整恢复账号及角色关系还需要匹配的 Login 数据；不能只复制 FDB 就认为账号列表也已恢复。

### 8.2 内置 FDB 备份的行为

> 来源：`db/FMain.pas` 的 `BackupFDB`、`timerProcessTimer`，以及 `Common/uDBProvider.pas` 的 `BackupHeader`、`BackupRecord`。

- 手动备份按钮调用 `BackupFDB`；程序运行期间检测到日期跨月也会触发。日期检测不是任务补跑机制，不保证停机期间的月度备份会补生成。
- 文件名精确格式为 `.\UserData\Backup%d-%d-%d.FDB`。同一天再次备份会覆盖同名文件，应另行保留需要的历史副本。
- 备份按索引逐条执行，期间连接器仍在处理保存请求，因此不保证所有角色来自同一个时间点。
- **文件头计数需核对**：`BackupHeader` 写入的是原库总槽位数，`BackupRecord` 实际只输出索引中的有效角色。原库有空闲槽位时，两者可能不一致。生成文件不能未经验证就改名替换运行库。

### 8.3 文本导出的范围

`DB_UPDATE` / `DB_UPDATE_END` 写入成功后，主连接器把角色的文本快照加入 `TodayCharList` 和 `WebCharList`，同一角色更新时覆盖该列表中的旧快照。手动保存按钮和正常退出会将非空列表写到 `UserData/Today.SDB`、`Web/Today.SDB`。

中国版本在运行中检测到进入 3 点时，将 `TodayCharList` 导出为带日期的 `UserData/UserData日期.SDB` 并清空列表。其他地区版本的定时导出分支不同，不能套用同一时刻。启动时会读取已有 `Today.SDB` 恢复这些**文本缓存列表**并删除该临时文件，不会把它自动导入 FDB。

这些导出没有覆盖完整磁盘布局，也不保证包含所有角色；部分字段含账号、密码等敏感信息。应按玩家数据保管，不作为公开示例或仓库附件。

### 8.4 恢复前检查

1. **先保留原件。** 对现有库、候选备份和配置分别留存只读副本，记录来源和时间。所有格式分析先在副本上进行，不直接用 DB 程序试开唯一原件。
2. **检查文件族。** 核对 `FileName` 基础路径及从 `00` 开始的连续编号，避免混入另一个时间点的分文件；打开流程遇到编号缺口会停止。
3. **检查头和长度。** 核对 `DBID`、`RecordDataSize=5888`、`RecordFullSize=5889` 与目标程序布局。逐文件核对头部 `RecordCount` 和物理槽位数量；长度差异、残缺槽位及内置备份的计数差异都应先查清。
4. **检查记录。** 核对 `boUsed`、角色名唯一性及第 3.7 节的自定义校验。字段表基于通信偏移，磁盘定位必须计入 `boUsed`。
5. **检查账号对应关系。** 将 FDB 的 `MasterName`、角色名与 Login 的账号和角色列表核对，避免角色存在但账号无法选到。
6. **确认停服保存后再替换。** 完整快照应在阻止新登录、完成角色下线及最终保存、正常关闭写入服务后复制。恢复也应在相关服务停止写入时进行；先在隔离副本中验证角色列表、属性、背包、武功和保存后重登，再安排正式恢复，并保留可回退副本。

以上是恢复前的核对流程，不表示内置备份文件已具备直接恢复保证；未核实计数、布局或校验的问题，不应通过修改原始库头或清零记录来掩盖。

---

## 附录：职业等级对照表

> 来源：`1000ydef/deftype.pas`

| 职业代码 | 名称 | 说明 |
|---------|------|------|
| 0 | `JOB_KIND_NONE` | 无职业 |
| 1 | `JOB_KIND_ALCHEMIST` | 炼金术师 |
| 2 | `JOB_KIND_CHEMIST` | 炼丹术师 |
| 3 | `JOB_KIND_DESIGNER` | 服饰家 |
| 4 | `JOB_KIND_CRAFTSMAN` | 匠人 |
| 5 | `JOB_KIND_MINER` | 矿工 |

| 等级代码 | 名称 | 才能要求 |
|---------|------|---------|
| 0 | `JOB_GRADE_NONE` | 无 |
| 1 | `JOB_GRADE_NAMELESSWORKER` | 100–1999 |
| 2 | `JOB_GRADE_TECHNICIAN` | 2000–3999 |
| 3 | `JOB_GRADE_SKILLEDWORKER` | 4000–5999 |
| 4 | `JOB_GRADE_EXPERT` | 6000–7999 |
| 5 | `JOB_GRADE_MASTER` | 8000–9999 |
| 6 | `JOB_GRADE_VIRTUEMAN` | 9999 + 完成任务 |
