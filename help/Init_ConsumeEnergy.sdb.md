# ConsumeEnergy.sdb

掌法元气消耗系数表。按人物最大元气 `FAttribClass.Energy` 查找区间；字段名虽含 `Skill`，当前调用并不传入武功等级。

## 文件路径
`bin/Init/ConsumeEnergy.sdb`

## 格式
CSV格式，第一行为列名

## 字段说明
| 字段名 | 类型 | 说明 |
|--------|------|------|
| Name | 字符串 | 索引名（序号标识） |
| StartSkill | 整数 | 最大元气区间起始值，含边界 |
| EndSkill | 整数 | 最大元气区间结束值，含边界 |
| ConsumePercent | 整数 | 从公式中的 150 扣除的系数，不是最终消耗百分比 |

## 数据示例
```
Name,StartSkill,EndSkill,ConsumePercent
1,0,9999,0
2,10000,19999,10
3,20000,29999,20
4,30000,39999,30
5,40000,49999,40
6,50000,59999,50
7,60000,69999,60
8,70000,79999,70
9,80000,89999,80
```

## 相关源码
```pascal
// svClass.pas - TMagicClass.ReLoadFromFile
if FileExists ('.\Init\ConsumeEnergy.SDB') then begin
   TempDB := TUserStringDB.Create;
   TempDB.LoadFromFile ('.\Init\ConsumeEnergy.SDB');
   for idx := 0 to TempDb.Count -1 do begin
      iname := TempDb.GetIndexName (idx);
      sn := TempDb.GetFieldValueInteger (iname,'StartSkill');
      en := TempDb.GetFieldValueInteger (iname,'EndSkill');
      if sn <= 0 then sn := 0;
      if en >= 999999 then en := 999999;
      SkillConsumeEnergyArr[idx].rStartSkill    := sn;
      SkillConsumeEnergyArr[idx].rEndSkill      := en;
      SkillConsumeEnergyArr[idx].rCosumeValue   := TempDb.GetFieldValueInteger (iname, 'ConsumePercent');
   end;
   TempDb.Free;
end;
```

加载器将区间和系数存入 `SkillConsumeEnergyArr`；`GetSkillConsumeEnergy` 按输入元气匹配区间。掌法分支的实际消耗为：

```text
n = Energy * (150 - GetSkillConsumeEnergy(Energy)) div 1000
n = n * (100 - DecValue) div 100
```

`div` 为整数除法，`DecValue` 来自人物对象的减耗值；当前元气不足 `n` 时使用失败，否则扣除 `n`。随包系数 0～80 对应减耗修正前的比例 15%～7%，不能解释为消耗 0%～80%。

依据：`gameserver-tgs1000/svClass.pas` 的 `TMagicClass.GetSkillConsumeEnergy`；`gameserver-tgs1000/uUserSub.pas:7294-7305` 的 `MAGICCLASS_MYSTERY` 分支。
