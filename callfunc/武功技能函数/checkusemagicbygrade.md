# checkusemagicbygrade

## 功能

检查玩家当前使用的绝世武功是否符合类别、循环等级和武功类型条件。

```pascal
Str := callfunc('checkusemagicbygrade 类别 循环等级 武功类型');
```

三个参数均经 `_StrToInt` 解析；类别和循环等级使用 Byte，武功类型使用 Integer：

- 类别 `5`：检查当前护体武功；必须属于 `MAGICCLASS_BESTMAGIC`、`rGrade` 等于循环等级、`rcSkillLevel=9999`。第三个参数不参与判断。
- 类别 `6`：检查当前攻击武功；除上述条件外，`rMagicType` 还必须等于第三个参数。第三个参数为 `-1` 时不限制武功类型，仍检查绝世类别、循环等级和修炼值。
- 当前实现的 `case` 没有 `else`；类别不是 5 或 6 时会直接走到末尾并返回 `true`，脚本不得用其他类别做校验。

返回值为小写字符串 `true` 或 `false`。

实际脚本用法包括：

```pascal
Str := callfunc('checkusemagicbygrade 6 0 0');
Str := callfunc('checkusemagicbygrade 6 1 4');
Str := callfunc('checkusemagicbygrade 6 1 -1');
```

依据：`uScriptManager.pas`、`UUser.pas` 的 `TUser.SCheckCurUseMagicByGrade`，以及 `bin/Script/` 的晋级脚本。
