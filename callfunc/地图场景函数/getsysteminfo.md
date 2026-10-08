# getsysteminfo

## 功能描述
获取系统信息。目前支持的命令为 `getbestguild`，用于获取最强门派名称。

## 语法格式
```pascal
Str := callfunc('getsysteminfo 命令');
```

## 参数说明
- **命令**：String - 系统信息命令，目前支持：
  - `getbestguild` - 获取最强门派名称

## 返回值
- **getbestguild**：返回最强门派的名称（字符串）
- **未知命令**：返回空字符串

## 源码实现
基于 `BasicObj.pas` 中的 `SGetSystemInfo` 函数：

```pascal
function TBasicObject.SGetSystemInfo(aCmd: string): string;
begin
   Result := '';
   if LowerCase(aCmd) = 'getbestguild' then
   begin
      Result := GuildList.GetBestGuild;
      exit;
   end;
end;
```

在 `uScriptManager.pas` 的 `CallFunction` 中调用：
```pascal
if cmd = 'getsysteminfo' then begin
   Result := TBasicObject(FSelf).SGetSystemInfo(Params[0]);
```

## 使用示例

### 获取最强门派
```pascal
// 获取当前最强门派名称
BestGuild := callfunc('getsysteminfo getbestguild');
if BestGuild = '' then begin
   print('say 暂无最强门派');
   exit;
end;
Cmd := 'say 当前最强门派是：' + BestGuild;
print(Cmd);
```

## 注意事项

1. **返回值类型**：返回字符串
2. **命令不区分大小写**：内部使用 `LowerCase` 转换后比较
3. **FSelf 上下文**：通过自身对象调用
4. **可扩展性**：该函数设计为可扩展的系统信息查询入口，未来可添加更多命令
5. **脚本中无实际用例**：当前脚本目录中未发现该函数的使用示例

## 相关函数
- `getmapname` - 获取自身所在地图名
- `getname` - 获取自身名称
