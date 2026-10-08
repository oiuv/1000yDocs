# JobGrade.sdb

制造职业等级数据表，保存区间字段、可制造物品品级、各品级成功率和工具名。当前职业判级由 `GetJobGrade` 的硬编码分支决定，不使用表中 `StartLevel/EndLevel` 查找等级。

## 文件路径

```
.\Init\JobGrade.SDB
```

## 文件格式

CSV 格式，逗号分隔，首行为列名。

## 字段说明

| 列名 | 类型 | 说明 | 源码依据 |
|------|------|------|----------|
| Name | Integer | 等级编号（1-6） | 行索引 |
| ViewName | String | 当前加载器不读取此列；等级显示名由 `game.ini` 的 `INI_DEF_NAMELESSWORKER` 至 `INI_DEF_VIRTUEMAN` 提供 | `TJobClass.LoadFromFile` 的 `case iNum` |
| Grade | Integer | 等级序号 | 用于映射常量 JOB_GRADE_NAMELESSWORKER 到 JOB_GRADE_VIRTUEMAN |
| StartLevel | Integer | 配置记录的技能值区间下限；当前 `GetJobGrade` 不使用此列判级 | `JobGradeData[iNum-1].StartLevel := Db.GetFieldValueInteger(iName, 'Startlevel')` |
| EndLevel | Integer | 配置记录的技能值区间上限；当前 `GetJobGrade` 不使用此列判级 | `JobGradeData[iNum-1].EndLevel := Db.GetFieldValueInteger(iName, 'EndLevel')` |
| MaxItemGrade | Integer | 该等级可制造的最高物品品级 | `JobGradeData[iNum-1].MaxItemGrade := Db.GetFieldValueInteger(iName, 'MaxItemGrade')` |
| 1Grade-10Grade | Integer | 制造对应品级物品的成功率（百分比） | `JobGradeData[iNum-1].Grade[j] := Db.GetFieldValueInteger(iName, IntToStr(j+1)+'Grade')` |
| Alchemist | String | 铸造师工具名称 | `AlchemistTool[aJobGrade-1]` |
| Chemist | String | 炼丹师工具名称 | `ChemistTool[aJobGrade-1]` |
| Designer | String | 裁缝工具名称 | `DesignerTool[aJobGrade-1]` |
| Craftsman | String | 工匠工具名称 | `CraftsmanTool[aJobGrade-1]` |
| MinerExp | String | 采矿经验范围，格式为"起始经验:结束经验:起始等级:结束等级" | `Miner_SExp`, `Miner_EExp`, `Miner_SLevel`, `Miner_ELevel` |

### 随包表中的等级区间

| 编号 | 名称 | 技能值范围 | 可制造最高品级 |
|------|------|-----------|--------------|
| 1 | 初级工 | 0 - 1999 | 9品 |
| 2 | 技能工 | 2000 - 3999 | 7品 |
| 3 | 熟练工 | 4000 - 5999 | 5品 |
| 4 | 达人 | 6000 - 7999 | 3品 |
| 5 | 名人 | 8000 - 9998 | 2品 |
| 6 | 神工 | 9999 - 9999 | 1品 |

以上区间是随包 `JobGrade.SDB` 的数据，不是实际判级算法。`svClass.pas:7099-7110` 使用人物 `Talent` 的技能值：100～1999为初级工，2000～3999技能工，4000～5999熟练工，6000～7999达人，8000～9998名人，其余值返回神工。尤其0～99也进入神工分支，与表中的初级区间不一致。仅修改表中区间不能改变该算法；这里记录现有源码行为，不将其当成设计意图。

## 数据示例

等级 1（初级工）制造成功率：9品=70%，10品=80%，其余品级=0（包括8品）。

等级 6（神工）制造成功率：1品=40%, 2品=50%, ..., 10品=89%

## 相关源码

- `svClass.pas` — `TJobClass` 加载逻辑（第 6996 行）
- `svClass.pas` — `TJobClass.GetJobGrade`（第 7099 行）
- `svClass.pas` — `TJobClass.GetJobGradeData`（第 7113 行）
- `svClass.pas` — `TJobClass.GetJobTool`（第 7195 行）
- `uUserSub.pas` — `THaveJobClass` 制造成功率计算（第 11779 行）
