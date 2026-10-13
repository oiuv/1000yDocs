# getsendermagiccountbyskill

检查触发玩家是否具有符合武功类型和熟练度条件的武功。名字中虽含 `count`，实际返回字符串 `'true'` 或 `'false'`，不返回数量。

## 语法与参数

```pascal
Str := callfunc('getsendermagiccountbyskill 武功类型 熟练度阈值');
```

- 第一个参数为 `aMagicType`。非负值按 `rMagicType` 匹配；负值遍历类型 0–4。
- 第二个参数为 `aSkillLevel`，与 `rcSkillLevel` 比较；满足 `rcSkillLevel >= aSkillLevel` 即通过。
- 查询遍历 `DefaultMagic` 和 `HaveMagicArr`，不是全部武功分类数组的总统计。

玩家包装直接将 `HaveMagicClass.FindMagicByTypeAndSkill` 的布尔结果转成 `'true'/'false'`。

## 示例

```pascal
// 检查拳类基本/普通武功是否达到熟练度 9999
Str := callfunc('getsendermagiccountbyskill 0 9999');
if Str = 'true' then begin
    print('say 已满足武功熟练度条件');
end;
```

不要对返回值调用 `StrToInt`。本函数也不能回答“学会了几种武功”。

源码依据：[UUser.pas](../../help/TGS核心源码/UUser.pas) 的 `SGetMagicCountBySkill`、[uUserSub.pas](../../help/TGS核心源码/uUserSub.pas) 的 `THaveMagicClass.FindMagicByTypeAndSkill`。

相关接口：[getsendermagicskilllevel](getsendermagicskilllevel.md)、[checksendercurusemagic](checksendercurusemagic.md)。
