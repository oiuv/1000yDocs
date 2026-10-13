# getsendermovespeed

## 功能与语法

读取触发脚本玩家的移动速度接口值。

```pascal
Str := callfunc('getsendermovespeed');
```

无参数。返回字符串；数值结果由 `IntToStr` 转换为十进制文本。

## 源码依据

`TScriptManager.CallFunction` 的有效分支执行：

```pascal
Result := IntToStr(TBasicObject(FSender).SGetMoveSpeed);
```

`TBasicObject.SGetMoveSpeed` 固定返回 0，当前 `TUser` 没有覆盖，所以 `FSender` 为普通玩家对象时返回 `'0'`。`TMonster` 另有覆盖，返回 `pSelfData.rWalkSpeed`；若事件发送者是怪物，应按其实际类型解释结果，不能把本接口当作玩家实际移动速度查询。

源码依据：[BasicObj.pas](../../help/TGS核心源码/BasicObj.pas)、[uMonster.pas](../../help/TGS核心源码/uMonster.pas)。

## 注意事项

- 作用对象是 `FSender`，不要与不带 `sender` 的自身对象版本混用。
- 仅在对应对象有效的脚本事件中调用；源码没有为每个分支单独检查空指针。
