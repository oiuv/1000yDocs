# findobjectbyname

## 功能描述
在自身视野范围内按名称查找对象（玩家/NPC/怪物），返回其 ID。

## 语法格式
```pascal
Str := callfunc('findobjectbyname 对象名称');
```

## 参数说明
- **对象名称**：String - 要查找的对象名称

## 返回值
- **找到**：返回对象的 ID（字符串格式的数字）
- **未找到**：返回 '0'

## 源码实现
基于 `BasicObj.pas` 中的 `SFindObjectByName` 函数：

```pascal
function TBasicObject.SFindObjectByName(aName: string): Integer;
var
   i: Integer;
   BO: TBasicObject;
begin
   Result := 0;

   for i := 0 to ViewObjectList.Count - 1 do
   begin
      BO := ViewObjectList.Items[i];
      if StrPas(@BO.BasicData.Name) = aName then
      begin
         Result := BO.BasicData.ID;
         exit;
      end;
   end;
end;
```

在 `uScriptManager.pas` 的 `CallFunction` 中调用：
```pascal
end else if cmd = 'findobjectbyname' then begin
   Result := IntToStr(TBasicObject(FSelf).SFindObjectByName(Params[0]));
```

## 使用示例

### 查找指定名称的玩家
```pascal
// 在视野范围内查找名为"张三"的玩家
Str := callfunc('findobjectbyname 张三');
if Str = '0' then begin
   print('say 没有找到名为张三的人');
   exit;
end;
Cmd := 'say 找到了，ID为：' + Str;
print(Cmd);
```

### 查找NPC
```pascal
// 查找附近的NPC
Str := callfunc('findobjectbyname 捕盗大将');
if Str <> '0' then begin
   print('say 捕盗大将就在附近');
end;
```

## 注意事项

1. **返回值类型**：返回字符串格式的数字（对象 ID），未找到返回 '0'
2. **FSelf 上下文**：在自身（NPC/怪物）的视野范围内查找
3. **视野范围**：只搜索 `ViewObjectList` 中的对象，即自身视野可见范围内的对象
4. **精确匹配**：名称必须完全匹配
5. **首个匹配**：找到第一个匹配的对象后立即返回，不继续搜索
6. **脚本中无实际用例**：当前脚本目录中未发现该函数的使用示例

## 相关函数
- `checkobjectalive` - 检查地图中对象是否存活
- `getname` - 获取自身名称
- `getsendername` - 获取触发者名称
