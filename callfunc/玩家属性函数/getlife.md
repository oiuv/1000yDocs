# getlife

## 功能

取得当前脚本关联对象 `FSelf` 的生命值，并以十进制字符串返回。

## 语法

```pascal
Str := callfunc('getlife');
Life := StrToInt(Str);
```

无参数。入口调用：

```pascal
Result := IntToStr(TBasicObject(FSelf).SGetLife);
```

## 对象类型差异

`SGetLife` 是虚方法，返回值由 `FSelf` 的实际类型决定：

- `TBasicObject.SGetLife` 的基础实现固定返回 `0`。
- `TDynamicObject.SGetLife` 返回 `CurLife`。
- `TUser.SGetLife` 返回 `AttribClass.CurLife`（当前活力）。

当前 `TMonster` 和 `TNpc` 继承 `TLifeObject`，源码中没有覆盖 `SGetLife`，因此沿用基础实现返回 `0`。不能笼统地把本函数解释为“怪物或 NPC 当前生命值”。

## 与 getsenderlife 的区别

- `getlife` 在 `FSelf` 上调用。
- `getsenderlife` 在事件发送者 `FSender` 上调用。

源码依据：[UUser.pas](../../help/TGS核心源码/UUser.pas) 的 `TUser.SGetLife`。
