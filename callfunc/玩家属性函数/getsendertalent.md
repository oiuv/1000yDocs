# getsendertalent

获取触发脚本事件玩家的职业技术熟练值（源码 `AttribClass.Talent`）。

## 语法
```pascal
Str := callfunc('getsendertalent');
```

## 参数
无参数。

## 返回值
返回该数值的十进制字符串。实际值来自 `TUser.SGetTalent`，需要数值比较时先用 `StrToInt` 转换。

## 源码实现
```pascal
Result := IntToStr(TBasicObject(FSender).SGetTalent);
```

## 示例

### 龙师父中的天赋检查
基于 `龙师父.txt` 的门槛逻辑；示例先将字符串转为整数（`Value: Integer`）：
```pascal
Str := callfunc ('getsendertalent');
Value := StrToInt(Str);
if Value < 9998 then begin
    print ('showwindow .\help\龙师父2.txt 1');
    exit;
end;
```

### 一级风兄中的天赋检查
基于 `一级风兄.txt`：
```pascal
Name := callfunc ('getsendertalent');
// 配合职业类型和职业等级一起判断玩家是否满足条件
```

### 神医中的天赋检查
基于 `神医.txt` 的门槛逻辑，`Value` 为 Integer：
```pascal
Str := callfunc ('getsendertalent');
Value := StrToInt(Str);
if Value < 9998 then begin
    // 天赋不足，提示玩家
    exit;
end;
```

## 注意事项
1. 该字段会变化：职业制作成功路径可调用 `TAttribClass.AddTalent` 增长；`THaveJobClass.SetJobKind` 会把 Talent 清零并重算职业等级（`uUserSub.pas` 第 11815-11820、12527-12530 行），不是创建时固定的天赋属性
2. 常见的使用场景是检查天赋值是否达到某个阈值（如 9998）
3. 通常与 `getsenderjobkind`、`getsenderjobgrade` 配合使用进行职业判定

## 相关函数
- `getsenderjobkind` — 获取玩家职业类型
- `getsenderjobgrade` — 获取玩家职业等级
- `getsendervirtue` — 获取玩家品德值
