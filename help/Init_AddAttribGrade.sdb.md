# AddAttribGrade.sdb

附加属性品级数据。定义每个品级对应的最大范围和可附加属性条目数量，用于附加属性系统的品级判定。

## 文件路径
`bin/Init/AddAttribGrade.sdb`

## 格式
CSV格式，第一行为列名

## 字段说明
| 字段名 | 类型 | 说明 |
|--------|------|------|
| Name | 字符串 | 表内记录键，按品级顺序填写便于维护；真正品级由从 1 开始的行位置决定 |
| MaxRange | 整数 | 该品级的最大范围值 |
| AttribItemCount | 整数 | 该品级可附加的属性条目数量 |

## 数据示例
```
Name,MaxRange,AttribItemCount
1,20,8
2,18,6
3,16,4
4,14,2
5,12,2
6,10,1
7,8,1
8,6,1
9,4,1
```

## 相关源码
```pascal
// svClass.pas - TAddAttribClass.LoadFromFile
if FileExists ('.\Init\AddAttribGrade.SDB') then begin
   DB := TUserStringDB.Create;
   DB.LoadFromFile ('.\Init\AddAttribGrade.SDB');
   for i := 1 to Db.Count do begin
      if i > High (GradeData) then begin
         FrmMain.WriteLogInfo ('Init\AddAttribGrade.SDB: excess rows ignored (maximum 10)');
         break;
      end;
      iName := DB.GetIndexName (i-1);
      if iName = '' then continue;
      GradeData[i].rMaxRange := DB.GetFieldValueInteger (iName, 'MaxRange');
      GradeData[i].rAttribItemCount := DB.GetFieldValueInteger (iName, 'AttribItemCount');
   end;
   DB.Free;
end;
```

加载逻辑：将每个品级的 `MaxRange` 和 `AttribItemCount` 存入 `GradeData` 数组。通过 `GetRange(iGrade)` 和 `GetNeedItemCount(iGrade)` 方法对外提供查询，品级有效范围为 1~10。

最多配置 10 行。加载循环按行位置写入 `GradeData[i]`，不按 Name 的数值查找；超出部分记录日志并忽略。不得跳过某个中间品级后期待后续记录仍按首列数字定位；调整行序还须核对 MaxRange 对应的附加属性概率表。参见 [配置编号、索引与固定容量](ConfigurationIdentifiers.md)。
