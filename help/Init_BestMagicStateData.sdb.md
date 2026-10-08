# BestMagicStateData.sdb

绝世武功状态点转换系数表。按武功名称提供攻防计算系数；`GetStateDataofBestMagic` 将武功各项已分配状态点转换为 `rcLifeData` 的附加攻防值，不是将表中数值直接加到人物属性。

## 文件路径
`bin/Init/BestMagicStateData.sdb`

## 格式
CSV格式，第一行为列名。以武功名称为索引。

## 字段说明
| 字段名 | 类型 | 说明 |
|--------|------|------|
| Name | 字符串 | 武功名称（如日月神功、寒阴指等） |
| DamageBody | 整数 | 身体攻击状态点的转换系数 |
| DamageHead | 整数 | 头部攻击状态点的转换系数 |
| DamageArm | 整数 | 手臂攻击状态点的转换系数 |
| DamageLeg | 整数 | 腿部攻击状态点的转换系数 |
| DamageEnergy | 整数 | 元气攻击状态点的转换系数 |
| ArmorBody | 整数 | 身体防御状态点的转换系数 |
| ArmorHead | 整数 | 头部防御状态点的转换系数 |
| ArmorArm | 整数 | 手臂防御状态点的转换系数 |
| ArmorLeg | 整数 | 腿部防御状态点的转换系数 |
| ArmorEnergy | 整数 | 元气防御状态点的转换系数 |
| Desc | 字符串 | 随包备注；当前加载器不读取 |

## 数据示例
```
Name,DamageBody,DamageHead,DamageArm,DamageLeg,DamageEnergy,ArmorBody,ArmorHead,ArmorArm,ArmorLeg,ArmorEnergy,Desc
日月神功,,,,,,45,150,150,150,900,
北冥神功,,,,,,45,150,150,150,1050,
紫霞神功,,,,,,45,150,150,150,1250,
血天魔功,,,,,,45,150,150,150,1400,
寒阴指,88,200,200,200,940,,,,,,
金刚指,116,200,200,200,940,,,,,,
```

## 相关源码
```pascal
// svClass.pas - TMagicCycleClass.ReLoadFromFile
if FileExists ('.\Init\BestMagicStateData.sdb') then begin
   MagicStateDB := TUserStringDB.Create;
   MagicStateDB.LoadFromFile('.\Init\BestMagicStateData.sdb');
   for i := 0 to MagicStateDB.Count - 1 do begin
      mname := MagicStateDB.GetIndexName(i);
      new (psd);
      FillChar (psd^, sizeof(TStateData),0);
      psd^.ArmorBody := MagicStateDB.GetFieldValueInteger (mname,'ArmorBody');
      psd^.armorHead := MagicStateDB.GetFieldValueInteger (mname,'ArmorHead');
      psd^.armorArm := MagicStateDB.GetFieldValueInteger (mname,'ArmorArm');
      psd^.armorLeg := MagicStateDB.GetFieldValueInteger (mname,'ArmorLeg');
      psd^.armorenergy := MagicStateDB.GetFieldValueInteger (mname,'ArmorEnergy');
      psd^.damageBody := MagicStateDB.GetFieldValueInteger (mname,'DamageBody');
      psd^.DamageHead := MagicStateDB.GetFieldValueInteger (mname,'DamageHead');
      psd^.DamageArm := MagicStateDB.GetFieldValueInteger (mname,'DamageArm');
      psd^.DamageLeg := MagicStateDB.GetFieldValueInteger (mname,'DamageLeg');
      psd^.damageenergy := MagicStateDB.GetFieldValueInteger (mname,'DamageEnergy');
      StateDataList.Add(psd);
      StateKeyClass.Insert(mname, psd);
   end;
   MagicStateDB.Free;
end;
```

加载器以武功名称为键存入 `StateKeyClass`。例如身体攻击项调用 `GetResultSettingValueofBestMagic(rStatus.rDamageBody, 表的DamageBody, rcLifeData.damageBody)`；其余九项分别使用对应的状态点和系数。随包寒阴指填写攻击系数，日月神功填写防御系数。

转换函数的算法如下（`div` 为整数除法）：

```text
statePoint 不在 0..540 时返回
t = statePoint
对 x = 1..10：
    若 t < x * 10：
        n = (x - 1) * 10 + t div x
        total += (x * x + n) * sValue div 100
        返回
    t -= x * 10
```

例如身体攻击状态点为10、系数为88时：第一轮扣除10，第二轮得到 `n=10`，附加值为 `14*88 div 100=12`，不是直接增加88。实际结果还取决于调用时的基础 `rcLifeData`。

依据：`gameserver-tgs1000/svClass.pas:2603-2619` 的转换函数及 `:3410-3444` 的 `GetStateDataofBestMagic`。
