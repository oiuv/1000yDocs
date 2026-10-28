# AM&WHRelation.sdb

护体功与掌法相性表。行对应护体功相性类别，六列对应掌法相性类别；不是武功与武器类型的配合表。

## 文件路径
`bin/Init/AM&WHRelation.sdb`

## 格式
CSV格式，第一行为列名

## 字段说明
| 字段名 | 类型 | 说明 |
|--------|------|------|
| Name | 字符串 | 行标识（Armor1～Armor7）；运行时按数据行顺序取护体相性下标 0～6 |
| WindOfHand1 | 整数 | 对掌法相性类别 0 的相性值 |
| WindOfHand2 | 整数 | 对掌法相性类别 1 的相性值 |
| WindOfHand3 | 整数 | 对掌法相性类别 2 的相性值 |
| WindOfHand4 | 整数 | 对掌法相性类别 3 的相性值 |
| WindOfHand5 | 整数 | 对掌法相性类别 4 的相性值 |
| WindOfHand6 | 整数 | 对掌法相性类别 5 的相性值 |
| Desc | 字符串 | 随包护体功名称备注；当前加载器不读取 |

## 数据示例
```
Name,WindOfHand1,WindOfHand2,WindOfHand3,WindOfHand4,WindOfHand5,WindOfHand6,Desc
Armor1,0,20,10,50,40,60,僵尸功
Armor2,10,0,20,40,60,50,气甲体
Armor3,20,10,0,60,50,40,金结
Armor4,30,30,30,30,30,30,不羁浪人心法
Armor5,40,50,60,0,10,20,黄土大力体
Armor6,50,60,40,20,0,10,回转圆型障
Armor7,60,40,50,10,20,0,不灭体
```

## 相关源码
```pascal
// svClass.pas - TMagicClass.ReLoadFromFile
if FileExists ('.\Init\AM&WHRelation.SDB') then begin
   TempDB := TUserStringDB.Create;
   TempDB.LoadFromFile ('.\Init\AM&WHRelation.SDB');
   for idx := 0 to TempDb.Count -1 do begin
      if idx > High (AM_WHRelationTable) then begin
         FrmMain.WriteLogInfo ('Init\AM&WHRelation.SDB: excess rows ignored (maximum 7)');
         break;
      end;
      iname := TempDb.GetIndexName (idx);
      AM_WHRelationTable[idx][0] := TempDb.GetFieldValueInteger (iname,'WindOfHand1');
      AM_WHRelationTable[idx][1] := TempDb.GetFieldValueInteger (iname,'WindOfHand2');
      AM_WHRelationTable[idx][2] := TempDb.GetFieldValueInteger (iname,'WindOfHand3');
      AM_WHRelationTable[idx][3] := TempDb.GetFieldValueInteger (iname,'WindOfHand4');
      AM_WHRelationTable[idx][4] := TempDb.GetFieldValueInteger (iname,'WindOfHand5');
      AM_WHRelationTable[idx][5] := TempDb.GetFieldValueInteger (iname,'WindOfHand6');
   end;
   TempDb.Free;
end;
```

加载器把数据行依次存入 `AM_WHRelationTable[0..6,0..5]`。受掌法攻击时，`GetValueFromRelationTable` 使用防御方当前护体功和来袭掌法的 `rMagicRelation` 取值 `m`。

- 伤害分支先按护体功类别和熟练度修正 `m`，再计算 `damageBody - damageBody * m div 100`，随后还有其他防御计算。因此表值不是最终伤害减免百分比。
- 原始相性值为 60 时进入元气吸收分支，吸收量还与掌法消耗、护体类别及熟练度有关。

## 编号与边界注意

最多配置 7 行，六个 WindOfHand 列固定。加载器遇到第八行时记录日志并停止读取后续行，不能通过追加记录扩展护体相性。

`Magic.sdb` 的 MagicRelation 原样进入查表参数，不会自动减一：护体相性下标应为 0～6，掌法为 0～5。`GetValueFromRelationTable` 分别校验两维，任一参数越界均返回 0，不访问数组；0 表示没有此项相性加成，不影响后续其它防御计算。非法系别仍须修正，不能用这个回退代替有效配置。

表名、行名中的“1”与内部下标“0”不可混用。其它同类规则见 [配置编号、索引与固定容量](ConfigurationIdentifiers.md)。

依据：[svClass.pas](TGS核心源码/svClass.pas) 的 `TMagicClass.ReLoadFromFile`、`GetValueFromRelationTable`；[UUser.pas](TGS核心源码/UUser.pas) 的 `CommandAttackedMagic`。
