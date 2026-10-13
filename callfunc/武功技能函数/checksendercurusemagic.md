# checksendercurusemagic

检查触发玩家当前选用的武功是否满足指定条件，返回字符串 `'true'` 或 `'false'`。选用了攻击武功不等于角色此刻正在执行攻击动作。

## 语法

```pascal
Str := callfunc('checksendercurusemagic aType');
```

参数由 `_StrToInt` 转换后传给 `TUser.SCheckCurUseMagic(aType: Byte)`。

## 参数映射

| aType | 实际检查 |
| ---: | --- |
| 0 | `pCurAttackMagic` 非空且 `rGuildMagicType = 1`，门派攻击武功条件 |
| 1 | `pCurAttackMagic` 非空且 `rMagicClass = MAGICCLASS_MYSTERY`，掌法 |
| 2 | `pCurEctMagic` 非空且 `rMagicType = MAGICTYPE_ECT`，辅助类武功；不是护体指针 |
| 3 | `pCurAttackMagic` 非空且 `rMagicClass = MAGICCLASS_RISEMAGIC`，上层攻击武功 |
| 4 | `pCurProtectingMagic` 非空且 `rMagicClass = MAGICCLASS_RISEMAGIC`，上层护体武功 |
| 5 | `pCurProtectingMagic` 非空且 `rMagicClass = MAGICCLASS_BESTMAGIC`，绝世护体武功 |
| 6 | `pCurAttackMagic` 非空且 `rMagicClass = MAGICCLASS_BESTMAGIC`，绝世攻击武功 |

上述条件不满足时返回 `'false'`，通过后返回 `'true'`。源码的 `case` 没有兜底拒绝分支，未列出的 Byte 值会落到末尾返回 `'true'`，因此调用方必须限定 0–6，不能拿其它值做有效性判断。

## 示例

```pascal
Str := callfunc('checksendercurusemagic 1');
if Str = 'true' then begin
    print('say 当前选用的是掌法');
end;
```

本函数没有等级、满熟练度或指定攻击类型参数；5、6 分支也不检查这些条件。需要按等级检查时参见 [checkusemagicbygrade](checkusemagicbygrade.md)，不要混用两个函数的源码。

源码依据：[uScriptManager.pas](../../help/TGS核心源码/uScriptManager.pas) 的 `CallFunction`、[UUser.pas](../../help/TGS核心源码/UUser.pas) 的 `SCheckCurUseMagic`。
