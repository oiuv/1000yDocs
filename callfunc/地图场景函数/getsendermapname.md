# getsendermapname

## 功能描述
获取触发者（玩家）所在地图的名称。

## 语法格式
```pascal
Str := callfunc('getsendermapname');
```

## 参数说明
无参数。

## 返回值
- **成功**：返回触发者所在地图的名称（字符串）
- 源码直接返回 `Manager.Title`，没有单独的失败返回分支；空字符串不能当作约定的失败标志。调用前须保证 `FSender` 及其地图上下文有效。

## 源码实现
在 `uScriptManager.pas` 的 `CallFunction` 中调用：

```pascal
end else if cmd = 'getsendermapname' then begin
   Result := TBasicObject(FSender).SGetMapName;
```

底层调用与 `getmapname` 相同的 `SGetMapName` 方法：
```pascal
function TBasicObject.SGetMapName: string;
begin
   Result := Manager.Title;
end;
```

区别在于 `getmapname` 使用 `FSelf`（自身对象），而 `getsendermapname` 使用 `FSender`（触发者/玩家对象）。

## 使用示例

### 检查玩家所在地图
```pascal
// 获取玩家当前所在地图名
MapName := callfunc('getsendermapname');
if MapName = '捕盗将军洞' then begin
   print('say 你在捕盗将军洞中');
end;
```

### 根据玩家地图执行不同逻辑
```pascal
MapName := callfunc('getsendermapname');
// 根据玩家所在地图执行不同操作
```

## 注意事项

1. **无参数**：该函数不需要任何参数
2. **返回值类型**：返回字符串格式的地图名称
3. **FSender 上下文**：返回的是触发者（玩家）所在地图的名称
4. **与 getmapname 区别**：
   - `getmapname`：返回自身（NPC/怪物）所在地图名
   - `getsendermapname`：返回触发者（玩家）所在地图名
5. **脚本中无实际用例**：当前脚本目录中未发现该函数的直接使用示例

## 相关函数
- `getmapname` - 获取自身所在地图名
- `getposition` - 获取自身坐标
- `getsenderposition` - 获取触发者坐标
