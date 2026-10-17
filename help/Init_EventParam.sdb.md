# EventParam.SDB

`Init/EventParam.SDB` 保存 `Event.SDB` 事件的执行参数。`Code` 与 `Event.SDB.ParamCode` 匹配；加载器固定读取 5 个名称参数和 5 个整数参数。

| 字段 | 类型 | 加载结果 |
| --- | --- | --- |
| `Code` | Word | 参数记录编号 |
| `NameParam1..5` | String[50] | `TEventParamData.NameParam[0..4]` |
| `NumberParam1..5` | Integer | `TEventParamData.NumberParam[0..4]` |

## 动态对象死亡事件

`RunDynObjDieEvent` 使用字段如下：

- `NameParam1`：被查找并处理的原对象名称；`NameParam2`：目标怪物或 NPC 名称。
- `NameParam3`：全服公告正文；公告前缀使用 `NameParam2`。
- `NameParam4`：音效名称，发送时追加 `.wav`。
- `NumberParam1`、`NumberParam2`：原对象和目标对象的种族值，用于和 `RACE_MONSTER`、`RACE_NPC` 比较。
- `NameParam5`、`NumberParam3..5`：当前函数未读取。

## 怪物死亡事件

`RunMopDieEvent` 使用 `NameParam1`、`NameParam2` 和 `NumberParam1`、`NumberParam2` 完成原对象处理及目标怪物/NPC 创建。`NumberParam3` 作为 `ScriptNo` 传给 `AddMonster`。`NameParam3` 虽被赋给局部变量 `BookName`，后续没有使用；`NameParam4..5`、`NumberParam4..5` 也未读取。

以上两个执行函数都只处理首条 `Code` 相符记录，然后退出。

## 校验依据

- 表头：`tgs1000/bin/Init/EventParam.SDB`
- 结构、加载与执行：`tgs1000/uEvent.pas` 的 `TEventParamData`、`LoadFromFile`、`RunDynObjDieEvent`、`RunMopDieEvent`
