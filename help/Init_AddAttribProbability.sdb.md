# AddAttribProbability.sdb

附加属性编号抽取权重表。列由已给定的材料品质选择，行权重用于随机决定物品的 `rAddType`；本表不随机生成材料品质。

## 文件路径
`bin/Init/AddAttribProbability.sdb`

## 格式
CSV格式，第一行为列名

## 字段说明
| 字段名 | 类型 | 说明 |
|--------|------|------|
| Name | 字符串 | 行标识；抽取出的属性编号按数据行顺序从 1 开始，不是物品品级 |
| Lowest | 整数 | 材料品质为最低时，本行属性编号的权重 |
| Lower | 整数 | 材料品质为较低时，本行属性编号的权重 |
| Normal | 整数 | 材料品质为普通时，本行属性编号的权重 |
| Higher | 整数 | 材料品质为较高时，本行属性编号的权重 |
| Highest | 整数 | 材料品质为最高时，本行属性编号的权重 |

## 数据示例
```
Name,Lowest,Lower,Normal,Higher,Highest
1,60,20,10,5,1
2,50,30,10,5,1
3,40,40,10,5,1
4,30,50,10,5,1
5,10,60,20,10,5
6,10,50,30,10,5
7,10,40,40,10,5
8,10,30,50,10,5
9,5,10,60,20,10
```

## 相关源码
```pascal
// svClass.pas - TAddAttribClass.LoadFromFile
if FileExists ('.\Init\AddAttribProbability.SDB') then begin
   DB := TUserStringDB.Create;
   DB.LoadFromFile ('.\Init\AddAttribProbability.SDB');
   for i := 0 to Db.Count - 1 do begin
      iName := DB.GetIndexName (i);
      if iName = '' then continue;
      New (pp);
      FillChar (pp^, sizeof (TProbabilityData), 0);
      pp^.rLowestValue := DB.GetFieldValueInteger (iName, 'Lowest');
      pp^.rLowerValue := DB.GetFieldValueInteger (iName, 'Lower');
      pp^.rNormalValue := DB.GetFieldValueInteger (iName, 'Normal');
      pp^.rHigherValue := DB.GetFieldValueInteger (iName, 'Higher');
      pp^.rHighestValue := DB.GetFieldValueInteger (iName, 'Highest');
      FDataList.Add (pp);
   end;
   DB.Free;
end;

// 加载后计算累积概率表
for i := 1 to FDataList.Count - 1 do begin
   pp := FDataList.Items[i];
   pBefore := FDataList.Items[i-1];
   pp^.rLowestValue := pp^.rLowestValue + pBefore^.rLowestValue;
   pp^.rLowerValue := pp^.rLowerValue + pBefore^.rLowerValue;
   pp^.rNormalValue := pp^.rNormalValue + pBefore^.rNormalValue;
   pp^.rHigherValue := pp^.rHigherValue + pBefore^.rHigherValue;
   pp^.rHighestValue := pp^.rHighestValue + pBefore^.rHighestValue;
end;
```

加载器分别对五列计算前缀和。`ProcessAddAttribItem(iWorth)` 先用产品品级从 `AddAttribGrade.sdb` 取得 `aMaxRange`，再调用 `GetAddTypeNum(aMaxRange, iWorth)`：以已给定的品质选择一列，取该列第 `aMaxRange` 行的累计值为随机范围，返回属性编号并写入产品 `rAddType`。

例如品质为最低、`aMaxRange=2` 时，只在前两行抽取：属性编号 1 权重 60，编号 2 权重 50，总权重 110；不会根据同一行的五列随机抽取品质。品质常量是 `ITEM_ATTRIBUTE_LOWEST`、`ITEM_ATTRIBUTE_LOWEER`（源码拼写）、`ITEM_ATTRIBUTE_NORMAL`、`ITEM_ATTRIBUTE_HIGHER`、`ITEM_ATTRIBUTE_HIGHEST`。

依据：`gameserver-tgs1000/svClass.pas:9043-9103`；`gameserver-tgs1000/uUserSub.pas:12067-12079`。
