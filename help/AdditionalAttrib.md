# AdditionalAttrib 附加属性表

`AdditionalAttrib/` 是炎黄服务端启动时实际加载的装备附加属性目录。`TItemClass` 按固定顺序尝试读取 `A1.SDB` 至 `E4.SDB`，当前随包目录共有 20 个文件。

## 文件映射

文件字母由 `Item.SDB` 的 `WearPos` 决定，数字由 `RoleType` 决定：

| 文件 | 装备位置 | `1` | `2` | `3` | `4` |
|---|---|---|---|---|---|
| `A*.SDB` | 衣服 `ADDATTRIB_ARMOR` | 重武士 | 轻武士 | 弓手 | 拳师 |
| `B*.SDB` | 帽子 | 重武士 | 轻武士 | 弓手 | 拳师 |
| `C*.SDB` | 护腕 | 重武士 | 轻武士 | 弓手 | 拳师 |
| `D*.SDB` | 鞋 | 重武士 | 轻武士 | 弓手 | 拳师 |
| `E*.SDB` | 武器 | 重武士 | 轻武士 | 弓手 | 拳师 |

只有物品名称非空、`AddType` 和 `RoleType` 非 0，且职业与装备位置属于上表范围时才会套用数据。

## 行号与字段

`AddType` 是 **1 起始的行位置**：源码先执行 `dec(aAddType)`，再按列表索引取行。它不按 SDB 首列 `Name` 查找。插入、删除或调整行顺序会改变已有物品的属性对应关系。

`AddType=0` 表示无附加，字段存储为 Byte。新增属性还须与 `AddAttribProbability` 的行位置及 `AddAttribGrade.MaxRange` 配套；改首列数字不能代替迁移已有装备的 AddType。跨表规则见 [配置编号、索引与固定容量](ConfigurationIdentifiers.md)。

属性单元格格式为 `数值:限制等级`；第二项缺失时限制为 0。`BowAttackSpeed`、`HandSpeed`、`ApproachSpeed` 的数值在加载时取负，其余字段直接转为整数。

已加载字段分为：弓术速度/命中/恢复/闪躲/四部位防御，拳术速度/命中/恢复/最小值/最大值/身体防御，近身速度/命中/闪躲/恢复/四部位防御，四部位追加伤害，以及 `EnergyRegenDec`、`BasicValueDec`。`desc` 未被当前加载器读取。

## 运维注意

- 文件是 GBK 文本；修改时保留表头、逗号和行顺序。
- 新增字段不会自动生效，必须先确认 `svClass.pas` 存在对应读取代码。
- 上线前同时核对 `Item.SDB` 的 `AddType`、`RoleType`、`WearPos`，并在停服备份后替换。

源码依据：`svClass.pas` 的 `TItemClass.LoadFromFile` 与 `GetAddItemAttribData`。
