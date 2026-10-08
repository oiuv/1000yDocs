# getsenderitemexistencebykind

按整数类型编号检查事件发送者的背包物品或当前穿戴武器，返回字符串 `true` 或 `false`。

## 语法

```pascal
Str := callfunc('getsenderitemexistencebykind 类型编号 选项');
```

| 参数 | 源码行为 |
| --- | --- |
| 类型编号 | 经 `_StrToInt` 转换为整数，对应物品的 `rKind` / `ITEM_KIND_*`，不是中文类别名称 |
| 选项 | `0` 检查背包，`1` 检查当前穿戴武器；省略时 `_StrToInt('')` 得到 `0` |

`uScriptManager.pas` 调用：

```pascal
Result := TBasicObject(FSender).SGetItemExistenceByKind(
  _StrToInt(Params[0]), _StrToInt(Params[1]));
```

`UUser.pas` 的 `TUser.SGetItemExistenceByKind(aKind, aOption: Integer)` 先令结果为 `false`：

- 选项 `0`：调用 `HaveItemClass.FindKindItem(aKind)`，在背包数组中比较 `rKind`，找不到（`-1`）则退出。
- 选项 `1`：比较 `WearItemClass.GetWeaponKind`（武器格的 `rKind`）与 `aKind`，不相等则退出。
- 正常应传有效非空物品类型。空背包格的 `rKind` 为 `0`，未装备武器时 `GetWeaponKind` 也返回 `0`，不能用类型 `0` 判断存在实际物品。
- 检查通过后返回 `true`。其它选项在当前代码中跳过检查而直接返回 `true`；脚本只能使用 `0`、`1`，不能依赖非法选项判断物品。

依据：`UUser.pas` 第 10026-10043 行、`uUserSub.pas` 第 2809-2819、5346-5351 行。

## 真实脚本示例

当前工作区炎黄 `bin/Script/quest老侠客.txt` 使用以下调用，云端神武归档也有相同用法：

```pascal
Str := callfunc('getsenderitemexistencebykind 59');
Str := callfunc('getsenderitemexistencebykind 60 1');
```

两次查询分别检查背包中的类型 `59` 和穿戴武器的类型 `60`，不是按“武器”“任务物品”等中文类别名称查询。判断返回值应使用字符串比较：

```pascal
Str := callfunc('getsenderitemexistencebykind 59 0');
if Str = 'false' then begin
   print('say 没有找到所需类型的背包物品');
   exit;
end;
```

## 相关函数

- [getsenderitemexistence](getsenderitemexistence.md)：按名称及数量查询物品。
- [getsenderitemcountbyname](getsenderitemcountbyname.md)：查询同名物品数量。
- [checkenoughspace](../玩家属性函数/checkenoughspace.md)：检查背包空位。
