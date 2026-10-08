# checkenoughspace

## 功能描述
检查当前玩家背包是否有足够的空位。

## 语法格式
```pascal
Str := callfunc('checkenoughspace');
Str := callfunc('checkenoughspace 需要的空位数');
```

## 参数说明
- **需要空位数**：Integer（可选）- 检查是否至少有指定数量的空位；省略时源码使用 `1`

## 返回值
- **'true'**：背包有足够的空位
- **'false'**：背包空间不足

## 源码实现
基于当前 `UUser.pas` 中的 `SCheckEnoughSpace` 函数：

```pascal
function TUser.SCheckEnoughSpace (aCount : Integer) : String;
begin
   Result := 'false';

   if HaveItemClass.FreeSpace >= aCount then begin
      Result := 'true';
   end;
end;
```

## 使用示例

### 基础示例
```pascal
// 检查是否有任何空位
space_status := callfunc('checkenoughspace');
if space_status = 'true' then begin
    print('say 背包有空间');
end;
if space_status = 'false' then begin
    print('say 背包已满');
end;
```

### 指定空位数量检查
```pascal
// 检查是否有5个空位
space_status := callfunc('checkenoughspace 5');
if space_status = 'true' then begin
    print('say 背包有足够空间');
end;
if space_status = 'false' then begin
    print('say 背包空间不足，需要至少5个空位');
end;
```

### 真实游戏示例
基于 `quest神医.txt` 中的使用：

```pascal
if aStr = 'quest' then begin
   Str := callfunc ('checkenoughspace');
   if Str = 'false' then begin
      print ('say 物品栏满了...');
      exit;
   end;
   // 继续任务逻辑...
end;
```

基于其他脚本中的使用：

```pascal
if aStr = 'close_1' then begin
   Str := callfunc ('checkenoughspace');
   if Str = 'false' then begin
      print ('say 物品栏满了...');
      exit;
   end;
   // 继续给予物品逻辑...
end;
```

## 注意事项

1. **返回值格式**：返回字符串 'true' 或 'false'，需要进行字符串比较
2. **空位计算**：`HaveItemClass.FreeSpace` 表示当前背包的空闲格子数量
3. **参数处理**：显式参数经 `_StrToInt` 转换；源码不限制正数，传入 `0` 或负数时比较 `FreeSpace >= aCount` 会成立
4. **调用对象**：入口固定在 `FSender` 上调用，正常脚本上下文中即事件发送者玩家

## 相关函数
- `getsenderitemcountbyname` - 获取指定物品的数量
- `getsenderitemexistence` - 检查物品是否存在
