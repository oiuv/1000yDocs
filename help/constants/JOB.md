# 职业系统常量

> 源码: `1000ydef/deftype.pas` 第 259-283 行

---

## 职业种类 (JOB_KIND_*)

定义玩家的生活/生产职业，对应 `TDBRecord.JobKind` 字段。

> 数据来源: `docs/help/炎黄新章游戏资料/职业技能/【职业技能】简介.txt`

| 常量名 | 值 | 中文说明 | 详细说明 |
|--------|---:|----------|----------|
| `JOB_KIND_NONE` | 0 | 无职业 | 未选择职业 |
| `JOB_KIND_ALCHEMIST` | 1 | 铸造师 | 制作兵器（刀、枪、剑、斧）等近战兵器 |
| `JOB_KIND_CHEMIST` | 2 | 炼丹师 | 制作各类加强属性与成功率的试剂、强身护体药品 |
| `JOB_KIND_DESIGNER` | 3 | 裁缝 | 制作战甲等防具 |
| `JOB_KIND_CRAFTSMAN` | 4 | 工匠 | 制作拳套、帽子、头盔、护腕、靴子等附加装备 |
| `JOB_KIND_MINER` | 5 | 矿工 | 采矿系，开采矿石/宝石 |
| `JOB_KIND_SMELT` | 99 | 冶炼 | 冶炼用定义常量（非玩家职业） |

### 职业师傅 NPC

| 职业 | 师傅 NPC |
|------|----------|
| 铸造师 | 牛美 |
| 炼丹师 | 神医 |
| 工匠 | 风兄 |
| 裁缝 | 梅花夫人 |

### 职业上限

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `JOB_KIND_MAX` | 4 | 职业种类最大值（不含矿工） |

---

## 职业品级 (JOB_GRADE_*)

定义制造职业的晋升等级。人物职业来自 `TDBRecord.JobKind`，`THaveJobClass` 以人物 `Talent` 技能值调用 `TJobClass.GetJobGrade` 计算 `FJobGrade`，不是读取 `TDBRecord.ExtJobKind`（后者属于扩展采集职业）。

> 数据来源: `bin/Init/JobGrade.sdb` + `docs/help/炎黄新章游戏资料/职业技能/【职业技能】简介.txt`

| 常量名 | 值 | 中文说明 | 技能值要求 | 可制作品级 | 说明 |
|--------|---:|----------|-----------:|-----------:|------|
| `JOB_GRADE_NONE` | 0 | 无品级 | — | — | 未评定 |
| `JOB_GRADE_NAMELESSWORKER` | 1 | 初级工 | 1.00-19.99 | 10、9品 | 初始品级 |
| `JOB_GRADE_TECHNICIAN` | 2 | 技能工 | 20.00-39.99 | 8、7品 | 能力3级 |
| `JOB_GRADE_SKILLEDWORKER` | 3 | 熟练工 | 40.00-59.99 | 6、5品 | 能力2级 |
| `JOB_GRADE_EXPERT` | 4 | 达人 | 60.00-79.99 | 4、3品 | 能力2级 |
| `JOB_GRADE_MASTER` | 5 | 名人 | 80.00-99.98 | 2品 | 能力1级 |
| `JOB_GRADE_VIRTUEMAN` | 6 | 神工 | 99.99+任务 | 1品 | 最高品级，需完成神工任务 |

上表的晋升要求来自游戏帮助资料；当前源码判级需另行区分：`GetJobGrade` 使用100～9998的硬编码分段，其余值（包括0～99）均返回神工，不是按 `JobGrade.SDB.StartLevel/EndLevel` 查表。数据与执行逻辑的差异见 [JobGrade.sdb](../Init_JobGrade.sdb.md)。依据：`gameserver-tgs1000/uUserSub.pas:11262-11264`、`gameserver-tgs1000/svClass.pas:7099-7110`。

### 品级上限

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `JOB_GRADE_MAX` | 6 | 职业品级最大值 |

---

## 职业音效

| 常量名 | 值 | 说明 |
|--------|-----|------|
| `JOB_SOUND_TRUE` | '9210' | 职业操作成功音效 |
| `JOB_SOUND_FALSE` | '9211' | 职业操作失败音效 |

---

## 职业相关系统

### 制造系统

- 配方来自 `Init/Item.SDB` 的 `Material` 字段；[manufacture.md](../manufacture.md) 是整理对照表，不是服务端加载文件。当前仓库和随包程序目录未找到 `manufacture.atd` 加载文件
- 四种职业各有独立的制造配方
- 制造成功率与品级、技能值相关
- 四种职业：**铸造师**（兵器）、**炼丹师**（药品）、**工匠**（附加装备）、**裁缝**（防具）

### 采矿系统

- `JOB_KIND_MINER=5` 是定义常量，不能据此认定所有采矿检查均要求人物 `JobKind=5`；当前扩展采集代码独立使用 `ExtJobKind`，采集经验更新分支检查 `ExtJobKind=1`（`UUser.pas:4142-4146`）
- 需要曲柄 (`ITEM_KIND_PICKAX`) 或高级曲柄 (`ITEM_KIND_HIGHPICKAX`)
- 采矿点通过 `CreateMineObject.SDB` 配置

### 冶炼系统

- `JOB_KIND_SMELT`(99) 为冶炼专用常量
- 通过 `SmeltItem.sdb` / `SmeltItem2.sdb` 定义配方

---

## 脚本中使用

```pascal
// 每条命令及其参数放在一个完整字符串中；职业1是铸造师
print('setsenderjobkind 1');

// 独立查询示例：callfunc返回字符串，不假定上面的排队命令已执行
if callfunc('getsenderjobkind') = '1' then
begin
  print('say 你当前的职业是铸造师 0');
end;
```

此示例只说明命令格式和制造职业查询，不用于判断采矿资格。接口依据：`gameserver-tgs1000/uScriptManager.pas:164-172,226-228,350-351,425-430,595-596`。

---

## 相关文档

- [manufacture.md](../manufacture.md) — 制造系统材料表
- [Material.md](../Material.md) — 材料获取说明
- [ITEM_KIND.md](ITEM_KIND.md) — 物品类型（采矿工具/矿物）
