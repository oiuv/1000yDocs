# getmapname

## 功能描述
获取自身（NPC/怪物）所在地图的名称。

## 语法格式
```pascal
Str := callfunc('getmapname');
```

## 参数说明
无参数。

## 返回值
- **成功**：返回当前地图名称（字符串），如 '捕盗将军洞'
调用上下文必须有有效的 `Self` 和地图 `Manager`；实现直接读取 `Manager.Title`，没有专门的失败返回分支。

## 源码实现
基于 `BasicObj.pas` 中的 `SGetMapName` 函数：

```pascal
function TBasicObject.SGetMapName: string;
begin
   Result := Manager.Title;
end;
```

在 `uScriptManager.pas` 的 `CallFunction` 中调用：
```pascal
end else if cmd = 'getmapname' then begin
   Result := TBasicObject(FSelf).SGetMapName;
```

## 使用示例

### 获取自身所在地图名
```pascal
// NPC 获取自己所在的地图名称
MapName := callfunc('getmapname');
Cmd := 'say 我现在位于：' + MapName;
print(Cmd);
```

## 注意事项

1. **无参数**：该函数不需要任何参数
2. **返回值类型**：返回字符串格式的地图名称
3. **FSelf 上下文**：返回的是脚本所属对象（NPC/怪物）所在地图的名称，不是触发者（玩家）的地图名
4. **获取玩家地图名**：如需获取触发者（玩家）所在地图名，应使用 `getsendermapname`

## 相关函数
- `getsendermapname` - 获取触发者（玩家）所在地图名
- `getposition` - 获取自身坐标
- `getremainmaptime` - 获取地图剩余时间
