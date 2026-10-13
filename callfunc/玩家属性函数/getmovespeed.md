# getmovespeed

## 功能与语法

读取脚本自身对象的移动速度接口值。

```pascal
Str := callfunc('getmovespeed');
```

无参数。返回字符串；数值结果由 `IntToStr` 转换为十进制文本。

## 源码依据

`TScriptManager.CallFunction` 的有效分支执行：

```pascal
Result := IntToStr(TBasicObject(FSelf).SGetMoveSpeed);
```

`TBasicObject.SGetMoveSpeed` 固定返回 0；`TMonster.SGetMoveSpeed` 覆盖该方法，返回怪物资料的 `pSelfData.rWalkSpeed`。因此结果取决于 `FSelf` 的实际类型，不能一律解释为 0，也不能直接当作每秒移动格数。当前 `TUser` 没有覆盖该方法。

源码依据：[BasicObj.pas](../../help/TGS核心源码/BasicObj.pas)、[uMonster.pas](../../help/TGS核心源码/uMonster.pas)。

## 注意事项

- 作用对象是 `FSelf`，不要与带 `sender` 的玩家版本混用。
- 仅在对应对象有效的脚本事件中调用；源码没有为每个分支单独检查空指针。
