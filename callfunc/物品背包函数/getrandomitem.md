# getrandomitem

## 功能

从 `Event/RandomEventItemN.sdb` 对应的随机池抽取一项，返回奖励文字；函数本身不发放物品、不扣除材料，也不检查任务资格，这些由调用脚本处理。

本页的容量与异常处理限制依据本仓库公开的原版炎黄新章源码副本。其他版本须核对实际源码与配置，不能将原版限制直接当作目标部署的现状。

```pascal
Item := callfunc('getrandomitem 0');
```

参数是池编号，不是由源码定义的“品质等级”。原版随包说明把 0、1、2、3 分别用于新手村比武、中央比武、活动和犀牛猎人奖励；用途由调用脚本决定，不是程序固定映射。原版编号 3 还存在下述越界问题。

## 返回值

成功时返回 `物品名:数量`，可直接拼入 `putsendermagicitem`：

```pascal
Item := callfunc('getrandomitem 0');
if Item <> '' then begin
   Cmd := 'putsendermagicitem ' + Item + ' @一级比武老人 4';
   print(Cmd);
end;
```

原版源码没有为非法编号、空列表或未覆盖的随机区间提供可靠失败保护，不能依赖其稳定返回空串；示例中的空串检查不能替代对奖池配置的校验。

## 随机表规则

加载器读取 `ItemName`、`Kind`、`ItemCount`、`TotalRandom` 和 `MaxValue`，忽略 `randomrate`。抽取时也不使用 `Kind`；以首行 `MaxValue` 为随机上限，选取第一条满足 `随机数 < TotalRandom` 的记录。

标准配置下，本行概率为“本行与上一行累计阈值之差 / 首行 `MaxValue`”（首行前值为 0）。数量只影响命中后的奖励份数；每次调用重新随机，没有累计次数保底。

列表必须非空，物品内部名称有效、数量为正，累计阈值递增且末值等于总权重。完整七字段说明、配置示例及维护要求见 [Event 随机物品池](../../help/Event.md#randomeventitemsdb)。

## 原版源码风险

原版 `DataList` 仅声明 0～2，但加载循环和随包数据包含编号 3，`犀牛猎人.txt` 也调用 3；这是原版源码/随包越界矛盾。云端神武版脚本还使用 4、5，该原版结构不支持，不能直接迁移。未命中任何行时 `nPos` 未赋值，也不能用不完整的概率区间表示“无奖励”。

源码依据：[uScriptManager.pas](../../help/TGS核心源码/uScriptManager.pas) 的 `getrandomitem` 分派及 [svClass.pas](../../help/TGS核心源码/svClass.pas) 的 `TRandomEventItemList`。
