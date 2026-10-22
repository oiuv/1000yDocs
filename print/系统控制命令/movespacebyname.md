# movespacebyname

## 功能描述
按名称查找对象，把移动命令加入该对象的工作队列，固定延迟 1 tick。玩家分支支持跨地图；怪物和 NPC 分支只在当前地图重新定位，不使用传入的地图 ID 跨图。

机制选择见 [地图传送机制总览](../../help/Teleportation.md)。

## 语法格式
```pascal
print('movespacebyname <名称> <类型> <地图ID> <X坐标> <Y坐标>');
```

## 参数说明
| 参数 | 类型 | 说明 |
|------|------|------|
| 名称 | String | 玩家、怪物或 NPC 名称 |
| 类型 | String | 不区分大小写的 `user`、`monster` 或 `npc` |
| 地图ID | Integer | 仅玩家分支用于跨图；怪物和 NPC 分支忽略此值 |
| X坐标 | Integer | 目标 X 坐标 |
| Y坐标 | Integer | 目标 Y 坐标 |

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'movespacebyname' then begin
      TBasicObject (aSelf).SMoveSpaceByName (Params, Params [0], Params [1], 1);
```

`SMoveSpaceByName` 从全局 `UserList` 查找玩家，或从 `Self` 所在地图查找第一个同名存活怪物／NPC，然后将前五个参数压入该对象的 `CMD_MOVESPACE` 队列。`TLifeObject.WorkBoxCommand` 到期调用 `SMoveSpace`：玩家发送 `FM_GATE`，怪物和 NPC 调用同图 `CallMe`。

## 使用示例

### NPC 在当前地图随机换点
```pascal
// 三个候选位置的示意代码；NPC 必须已存在于脚本对象所在地图。
rInt := Random(3);
if rInt = 0 then begin
   print ('movespacebyname 彼岸花 NPC 98 30 191');
end;
if rInt = 1 then begin
   print ('movespacebyname 彼岸花 NPC 98 93 266');
end;
if rInt = 2 then begin
   print ('movespacebyname 彼岸花 NPC 98 133 207');
end;
```

### 玩家传送到固定坐标
```pascal
// 将发送者传送到地图 1 的 (165, 775)
Name := callfunc ('getsendername');
Str := 'movespacebyname ' + Name + ' user 1 165 775';
print (Str);
```

坐标后的额外参数不会参与移动逻辑，不能用来指定延迟或“传送到另一个 NPC”。

## 注意事项

1. **类型区分**：玩家可跨图；怪物和 NPC 只在当前地图查找与重定位。
2. **队列归属**：`movespace` 将命令加入 `Self` 队列；`movespacebyname` 加入找到的对象队列。两者都不是无延迟的直接操作。
3. **延迟单位**：固定为 1 tick，默认约 10 ms；实际执行取决于对象队列调度，不保证精确墙钟时间。

依据：[uScriptManager.pas](../../help/TGS核心源码/uScriptManager.pas)、[BasicObj.pas](../../help/TGS核心源码/BasicObj.pas) 的 `SMoveSpaceByName/SMoveSpace`、[uSkills.pas](../../help/TGS核心源码/uSkills.pas) 的 `TLifeObject.WorkBoxCommand`。

## 相关命令
- [movespace](movespace.md) — 在脚本对象队列中安排移动
- [directmovespace](directmovespace.md) — 不经过工作队列执行移动
