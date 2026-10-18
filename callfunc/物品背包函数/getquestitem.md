# getquestitem

## 功能

从 `QuestNotice/` 中指定的任务奖励池随机抽取一项。

```pascal
Item := callfunc('getquestitem 1');
```

## 参数对应

| 编号 | 当前加载文件 |
|---|---|
| 1 | `QuestItem_1stBeginnerPrize.sdb` |
| 2 | `QuestItem_1stPrize.sdb` |
| 3 | `QuestItem_2ndPrize.sdb` |
| 4 | `QuestItem_GoldCoin.sdb` |
| 5 | `QuestItem_PickAx.sdb` |
| 6 | `QuestItem_AttributePiece.sdb` |
| 7 | `QuestItem_Weapon.sdb` |

该映射同时由炎黄源码常量、加载分支和随包 `QuestNotice/ReadMe.txt` 证明。

## 返回值与随机规则

成功时返回 `物品名:数量`，不是单独的物品名。各表读取 `ItemName`、`ItemCount`、`TotalRandom` 和 `MaxValue`；抽取以首行 `MaxValue` 为上限，再按累计阈值 `TotalRandom` 命中。

```pascal
Item := callfunc('getquestitem 4');
if Item <> '' then begin
   Cmd := 'putsendermagicitem ' + Item + ' @任务奖励 4';
   print(Cmd);
end;
```

非法编号、缺文件或空表、非正数 `MaxValue`、随机值未命中累计区间、命中项名称为空或数量非正时，返回空字符串，不补发其它奖项。脚本应先检查返回值，再执行发奖。

读取奖池时不校验物品名是否存在于 `Init/Item.SDB`。部署前仍应核对物品内部名称、正整数数量和累计阈值；若希望每次必中奖，阈值须覆盖 `0..MaxValue-1`。

完整配置说明见 [QuestNotice 任务公告与奖励](../../help/QuestNotice.md)。源码依据：`uScriptManager.pas` 的 `getquestitem` 分派及 `svClass.pas` 的 `TRandomEventItemList.GetQuestItembyRandom`。
