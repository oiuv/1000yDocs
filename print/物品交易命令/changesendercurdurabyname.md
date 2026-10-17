# changesendercurdurabyname

按名称修改当前触发玩家背包内第一个匹配物品的当前耐久。

## 语法

```pascal
print('changesendercurdurabyname <物品名> <当前耐久>');
```

实现调用 `HaveItemClass.ChangeCurDuraByName`：先用 `FindItemKeybyName` 定位，未找到或槽位为空时直接返回；名称再次精确匹配后，将 `rCurDurability` 直接赋为参数值。

```pascal
print('changesendercurdurabyname 竹筒 0');
```

源码没有在此方法中限制最小值、最大值，也没有同步修改 `rDurability`。该命令只处理背包 `HaveItemArr`，不处理穿戴栏。

此方法不立即删除物品、不重置 `rDecTick`，也不发送物品更新包。尤其是设为0或负数后，背包自动计时的 `rCurDurability>0` 条件不再成立，因此不能将此命令当作“立即到期删除”。回收物品应使用相应删除命令。

依据：[uUserSub.pas](../../help/TGS核心源码/uUserSub.pas) 的 `THaveItemClass.ChangeCurDuraByName`、`Update`。各类别的计时与耗尽处理见[耐久度处理](../../help/constants/ITEM_KIND.md#耐久度处理)。
