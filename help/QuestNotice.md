# QuestNotice 任务文本与随机奖励

## 运行目录

服务器从 `tgs1000/bin/QuestNotice/` 读取任务详细文本和七组随机奖励表。文本与 SDB 均按实际运行环境的本地代码页维护；修改前应保留原编码。

## 任务详细文本

`TQuestSummaryClass.MakeQuestLogWindow` 使用任务编号拼接相对路径：

```pascal
Str := Format('.\questnotice\%d.txt', [aData.rQuestNumber]);
```

文件不存在时 `rDesc` 置空；存在时将全文装入任务窗口的“详细内容”。当前运行目录实际包含：`1100`、`1150`、`1200`、`1300`、`1350`、`1400`、`1450`、`1500`、`9998`、`9999` 共十个编号文本。`ReadMe.txt` 是运维说明，不是编号任务页。

任务标题、子标题和目标来自 `QuestSummary.sdb` 的 `QuestMainTitle`、`QuestSubTitle`、`Request` 字段；详细正文来自对应编号 TXT。业务流程应同时核对实际脚本，不能只凭编号推断任务阶段。

## 随机奖励表

`QuestNotice/ReadMe.txt` 定义 `getquestitem Int1` 的编号映射：

| Int1 | 文件 |
|---:|---|
| 1 | `QuestItem_1stBeginnerPrize.sdb` |
| 2 | `QuestItem_1stPrize.sdb` |
| 3 | `QuestItem_2ndPrize.sdb` |
| 4 | `QuestItem_GoldCoin.sdb` |
| 5 | `QuestItem_PickAx.sdb` |
| 6 | `QuestItem_AttributePiece.sdb` |
| 7 | `QuestItem_Weapon.sdb` |

七个文件的字段为 `No, ItemName, ItemCount, TotalRandom, randomrate, MaxValue, Kind`。具体奖项和概率必须直接查看部署文件，本文不复制易失效的数据行。

## 任务状态接口

- `changesendercurrentquest` / `getsendercurrentquest`
- `changesendercompletequest` / `getsendercompletequest`
- `changesenderfirstquest` / `getsenderfirstquest`
- `changesenderqueststr` / `getsenderqueststr`

这些字段的写入方法均为直接赋值；源码没有在接口层强制任务顺序或编号范围。

依据：`svClass.pas`、`uScriptManager.pas`、`UUser.pas`，以及 `bin/QuestNotice/` 实际文件。
