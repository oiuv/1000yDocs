# checkobjectalive

## 功能描述
检查指定地图中某个对象（怪物/NPC）是否存活。通过地图名称、对象类型和对象名称在全局管理器中查找。

## 语法格式
```pascal
Str := callfunc('checkobjectalive 地图名称 对象类型 对象名称');
```

## 参数说明
- **地图名称**：String - 地图的名称（Title），如 '捕盗将军洞'
- **对象类型**：String - 对象类型，如 'monster'、'npc' 等
- **对象名称**：String - 要检查的对象名称

## 返回值
- **存活**：返回 'true'
- **不存在或死亡**：返回 'false'

## 源码实现
在 `uScriptManager.pas` 的 `CallFunction` 中调用：

```pascal
end else if cmd = 'checkobjectalive' then begin
   if ManagerList.CheckObjectAlive(Params[0], Params[1], Params[2]) = true then begin
      Result := 'true';
   end else begin
      Result := 'false';
   end;
```

底层通过 `TManagerList.CheckObjectAlive` 实现：
```pascal
function TManagerList.CheckObjectAlive(aMapTitle, aRace, aName: String): Boolean;
var
   Manager: TManager;
begin
   Result := false;
   Manager := GetManagerByTitle(aMapTitle);
   if Manager = nil then exit;
   Result := Manager.CheckObjectAlive(aRace, aName);
end;
```

## 使用示例

### 检查特定地图中的NPC是否存活
```pascal
// 检查"捕盗将军洞"地图中的"捕盗大将"NPC是否存活
Str := callfunc('checkobjectalive 捕盗将军洞 npc 捕盗大将');
if Str = 'true' then begin
   print('say 捕盗大将还活着');
end;
if Str = 'false' then begin
   print('say 捕盗大将已经不在了');
end;
```

### 检查怪物是否存活
```pascal
// 检查某个地图中的Boss怪物
Str := callfunc('checkobjectalive 魔人洞 monster 魔人B');
if Str = 'false' then begin
   print('say Boss已被击败');
end;
```

## 注意事项

1. **返回值类型**：返回字符串 'true' 或 'false'
2. **地图名称匹配**：使用地图的 Title（显示名称）而非 ServerID 进行查找
3. **对象类型**：必须与游戏内定义的类型一致（如 'monster'、'npc'）
4. **全局查找**：通过 `ManagerList` 全局查找，不限于当前地图
5. **与 checkalivemopcount 区别**：
   - `checkobjectalive` 通过地图名称查找，返回 true/false
   - `checkalivemopcount` 通过地图编号查找，返回存活数量
6. **参数顺序**：严格按照地图名称、对象类型、对象名称的顺序传递

## 相关函数
- `checkalivemopcount` - 检查指定地图中存活怪物数量
- `findobjectbyname` - 按名称查找对象
- `getusercount` - 获取地图内用户数量
