# 千年(1000y) 数据库结构

> 本文档基于源码分析自动生成，所有字节偏移和大小均经过精确计算。
>
> 主要参考源码：`db/uRecordDef.pas`、`Common/uDBRecordDef.pas`、`Common/uDBProvider.pas`、`Common/Usersdb.pas`、`Common/UserSdb.pas`、`Common/uLGRecordDef.pas`、`loginsql/uDBAdapter.pas`、`loginsdb_biscuit/uDBAdapter.pas`

---

## 1. 数据库类型概览

| 数据库类型 | 文件扩展名 | 用途 | 使用模块 | 说明 |
|-----------|-----------|------|---------|------|
| **MSSQL** | — | SQL 登录实现的账号数据 | `loginsql/uDBAdapter.pas` | 通过 BDE `TQuery` 操作 `account1000y` 表 |
| **SDB** | `.sdb` | SDB 登录实现的账号数据 / 游戏配置 | `loginsdb_biscuit/uDBAdapter.pas`、`Common/UserSdb.pas` | 纯文本 CSV 格式，`TUserStringDB` 类操作 |
| **FDB** | `.fdb` | 角色数据持久化 | `Common/uDBProvider.pas`、`Common/uDBRecordDef.pas` | 自定义二进制格式，支持多文件扩展 |

### 1.1 各数据库的使用场景

- **FDB**：DB 服务器（端口 3051）使用 `TDBProvider` 管理角色数据。文件命名规则为 `XXX00.fdb`、`XXX01.fdb`...最多 64 个文件（`MAX_OPEN_FILE = 64`），每个文件最大 1GB。
- **SDB**：`loginsdb_biscuit` 使用 `TUserStringDB` 存储账号数据，文件位于 `.\Data\Login.sdb`。游戏配置数据（物品、怪物、地图等）也使用 SDB 格式。
- **MSSQL**：`loginsql` 使用 MSSQL 数据库，表名 `account1000y`。源码提供了两套 Login 实现，但没有把它们定义为通用的“开发/正式”模式；具体部署应以服务器实际启动的程序为准。

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
| 135 | 4 | `Energy` | `Integer` | 元気 |
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
| 5884 | 4 | `CRCKey` | `Cardinal` | CRC32 校验值 |

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

> **说明**：总大小 5888 字节由 `Common/uDBRecordDef.pas` 的 `packed record` 定义精确计算得出。实际运行时由 Delphi 编译器 `SizeOf(TDBRecord)` 决定，写入 FDB 文件头的 `RecordFullSize` 字段。Python 读取器 `fdb_reader.py` 从文件头动态读取此值。

---

## 3. FDB 文件格式

> 来源：`Common/uDBRecordDef.pas`、`db/uRecordDef.pas`（结构定义），以及 `Common/uDBProvider.pas`（`TDBProvider` 实现）

### 3.1 文件头 TDBHeader

> 来源：`Common/uDBRecordDef.pas`（packed record）

```
偏移  大小  字段             说明
0     4    ID               固定为 'DBID'（4 字节）
4     4    RecordCount      当前文件中的记录总数
8     4    RecordDataSize   记录数据大小 = SizeOf(TDBRecord) - 1
12    4    RecordFullSize   记录完整大小 = SizeOf(TDBRecord)
16    1    boSavedIndex     是否已保存索引（Boolean）
17    32   Dummy            保留空间（array[0..31] of byte）
```

**文件头总大小：49 字节**（`packed record`，4+4+4+4+1+32 = 49）

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
┌─────────────────────────────────────────────┐
│ TDBHeader (49 bytes)                        │
├─────────────────────────────────────────────┤
│ Slot 0: boUsed(1) + TDBRecord(5888) = 5889  │
│ Slot 1: boUsed(1) + TDBRecord(5888) = 5889  │
│ Slot 2: boUsed(1) + TDBRecord(5888) = 5889  │
│ ...                                         │
│ Slot N-1: boUsed(1) + TDBRecord(5888)       │
└─────────────────────────────────────────────┘
```

每个磁盘槽位由 `boUsed`（1 字节）+ `TDBRecord`（5888 字节）= **5889 字节**组成。

`boUsed` 字段标识该记录是否被使用：
- `boUsed = 1`：已分配，包含有效角色数据
- `boUsed = 0`：空白槽位，可被新角色复用

> 注：`boUsed` 是 `db/uRecordDef.pas` 中 DB 服务器端 `TDBRecord` 的第一个字段（`boUsed: byte`），后接与 `Common/uDBRecordDef.pas` 中 packed `TDBRecord` 对应的数据（5888 字节）。

### 3.4 多文件扩展策略

- 文件命名：`{名称}{序号}.fdb`，如 `createdb00.fdb`、`createdb01.fdb`
- 序号 < 10 时补零（`%s0%d%s`），≥ 10 不补零（`%s%d%s`）
- 每个文件最大记录数：`1024 × 1024 × 1024 div 5889 = 182,330` 条记录
- 最多 64 个文件（`MAX_OPEN_FILE = 64`）
- 当当前文件已满时，自动创建下一个文件

### 3.5 记录定位算法

```
文件内偏移 = 49(TDBHeader) + RecordNo × 5889(boUsed + TDBRecord)
```

查找流程：
1. 通过 `TIndexClass` 的**二分查找**在内存索引中定位角色名 → 得到 `(FileNo, RecordNo)`
2. 选择对应的文件流 `DBStream[FileNo]`
3. `Seek(49 + RecordNo × 5889)`
4. 读取/写入记录数据（boUsed + TDBRecord）

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

### 3.7 CRC32 校验机制

- 来源：`Common/uCookie.pas` 中的 `oz_CRC32` 函数
- 计算范围：`TDBRecord` 的前 `SizeOf(TDBRecord) - 4` 字节（即除 `CRCKey` 字段外的所有数据）
- 存储位置：`TDBRecord.CRCKey`（最后 4 字节，`Cardinal` 类型）
- 主要更新路径：普通 `DB_UPDATE` 直接写入传入记录；`DB_UPDATE_END` 会先重算 CRC 再写入。`DB_INSERT` 以及远程管理写入路径也会重算 CRC，不能概括为“仅 DB_UPDATE_END 计算”。

```pascal
// db/uConnector.pas — DB_UPDATE_END 处理
RecordData.CRCKey := oz_CRC32(@RecordData, SizeOf(RecordData) - 4);
```

- CRC32 算法：标准 CRC32（初始值 `$FFFFFFFF`，最终取反），使用 256 项查找表

### 3.8 TCheckCharData 保存队列封装

```pascal
TCheckCharData = packed record
   rCharData : TDBRecord;
   rEnd : Byte;     // 结束标记
end;
```

该结构只在 Game 的保存缓冲队列中把角色记录与发送类型标志放在一起：`rEnd=0` 发送 `DB_UPDATE`，`rEnd=1` 发送 `DB_UPDATE_END`。实际发往 DB 的是 `rCharData`，`rEnd` 本身不随记录传输，也不承担完整性校验。

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

`loginsdb_biscuit/uDBAdapter.pas` 中的 `TSDBAdapter` 使用 `TUserStringDB` 存储账号数据。随程序提供的 `bin/Data/Login.sdb` 实际表头为：

```
PrimaryKey,Password,CharInfo0,CharInfo1,CharInfo2,CharInfo3,CharInfo4,IpAddr,UserName,Birth,Telephone,MakeDate,LastDate,Address,Email,NativeNumber,MasterKey,PtName,PtNativeNumber,
```

`PrimaryKey` 是记录主键/账号名；`CharInfo0..4` 的值采用 `角色名:服务器名` 格式；`PtName`、`PtNativeNumber` 是当前文件保留的监护人字段。字段名和顺序必须以实际首行为准。

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

源码还保留了对序号 17、18（监护人姓名和身份证号）的注释代码，但没有读取它们，且不足以证明当前数据库实际存在这两列。

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

---

## 6. 数据持久化流程

### 6.1 保存时机

角色数据在以下时机保存：

1. **定期自动保存**：游戏服务器每 **10 分钟**（实际代码使用 `10 * 60 * 100`，单位为 10ms tick）自动保存所有在线角色数据

   ```pascal
   // gameserver-tgs1000/UUser.pas
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

2. **角色下线**：用户断开连接时调用 `SaveUserData` 保存最终状态

3. **跨服务器移动**：角色转移到其他服务器前保存

### 6.2 保存数据收集流程

`TUser.SaveUserData` 方法（`gameserver-tgs1000/UUser.pas`）收集以下数据到 `Connector.CharData`（即 `TDBRecord`）：

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

### 6.3 CRC 校验流程

```
游戏服务器（TGS 的 FGate）          DB 服务器
    │                                 │
    ├── 收集 CharData ──────────────→ │
    │                                 ├── DB_UPDATE: 直接写入数据（不计算 CRC）
    │                                 ├── DB_UPDATE_END: 计算 CRC32
    │                                 │   CRCKey = oz_CRC32(@RecordData, SizeOf - 4)
    │                                 ├── 写入 TDBRecord
    │                                 ├── Seek 到记录位置
    │                                 └── WriteBuffer(RecordData)
```

主连接器在 `DB_UPDATE_END` 和插入记录时计算 CRC；`uSRemoteConnector.pas`、`uCRemoteConnector.pas` 在远程写入记录时也直接计算 CRC。计算范围均覆盖记录除最后 4 字节（`CRCKey` 本身）外的所有数据。

### 6.4 DB 服务器写入流程

```
1. 接收游戏服务器通过其自身 DB 连接发来的保存请求（`gameserver-tgs1000/FGate.pas`）
2. 通过 IndexClass 二分查找角色名 → (FileNo, RecordNo)
3. 填充 TDBRecord 数据
4. DB_UPDATE_END 时计算 CRC32 校验值 → 写入 CRCKey 字段
5. DBStream[FileNo].Seek(49 + RecordNo × 5889)
6. DBStream[FileNo].WriteBuffer(RecordData, SizeOf(TDBRecord))
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
