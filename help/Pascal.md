# 千年脚本语法

千年脚本外观接近 Pascal，但实际由 `ScriptCls.pas` 和 `Common/ScriptBasic.pas` 的定制解释器加载。这里只记录当前解释器可确认的语法；通用 Pascal 教程中的写法不能直接套用。

## 文件结构

```pascal
unit 单元名称;

interface

function callfunc (aText : String) : String;
procedure print (aText : String);
procedure OnLeftClick (aStr : String);

var
   Counter : Integer = 0;

implementation

procedure OnLeftClick (aStr : String);
var
   Str, Cmd : String;
begin
   Str := callfunc ('getsendername');
   Cmd := 'sendsenderchatmessage 欢迎_' + Str;
   print (Cmd);
end;

end.
```

加载器识别 `unit`、`interface`、`extern`、`var`、`implementation` 和 `end.`。`unit` 名会被保存，但当前加载器没有强制它与 `.txt` 文件名相同；脚本文件由 `Script.SDB` 映射。

不支持 `program`、`uses`、`const`、`type`、类、数组、集合、异常处理、`writeln`、`readln` 等完整 Pascal 功能。

## 标识符、字符串与注释

- 非字符串记号会统一转成小写，因此关键字、变量、过程和函数名不区分大小写。
- 单引号内的字符串保持原始大小写。`uScriptManager.pas` 直接比较 `print`/`callfunc` 字符串中的接口名，并不会先调用 `LowerCase`；必须使用索引所列的精确拼写与大小写。CallFunc 名称均为小写，Print 中还存在 `boMapEnter`、`decreasePrisonTime` 这样的历史混合大小写名称。对象名、地图名和物品名同样保持实际名称。
- 当前 `SkipBlank` 只实现 `//` 行注释。源码注释虽然提到 `{...}` 和 `(*...*)`，解析器并没有跳过它们；脚本中不要使用。
- 字符串常用 `_` 表示命令参数中的空格，部分窗口或消息命令使用逗号表示换行；是否替换由具体命令实现决定。

## 变量与类型

只支持三种类型：

```pascal
var
   Count : Integer;
   Name : String;
   Enabled : Boolean;
```

解释器为变量分配结构后会先清零，所以未显式初始化的值分别是 `0`、空字符串和 `False`。声明时可为整数和字符串提供初值：

```pascal
var
   Count : Integer = 1;
   Name : String = '测试';
```

过程参数、局部变量、全局 `var` 和 `extern` 变量均由解释器自己的变量表管理。不要假设原生 Delphi 的作用域、类型转换或内存行为。

## 赋值与表达式

赋值使用 `:=`，比较使用 `=`、`<>`、`>`、`<`、`>=`、`<=`。当前执行器实现整数 `+`、`-`、`*`、`/`、`div`、`mod` 和字符串 `+`，但编译器按固定记号位置生成指令，复杂或连续表达式应拆开：

```pascal
Cmd := 'sendsendertopmsg ' + Name;
Cmd := Cmd + '_获得奖励';
Count := Count + 1;
```

不要把函数调用直接嵌入长表达式；先接收返回值，再参与计算或拼接。

## 条件与循环

`if ... then begin ... end;` 已实现，当前词法/编译器没有 `else` 分支：

```pascal
if Str = 'false' then begin
   exit;
end;
```

`for` 由编译器展开为初始化、比较和递增指令。仓库脚本极少依赖复杂循环，新增逻辑应先用测试对象验证边界。

## 内置函数与过程

脚本只能调用 `interface` 中声明且解释器实现的内置项：

| 名称 | 行为 |
|---|---|
| `callfunc(Text)` | 调用当前 `TScriptManager.CallFunction` 注册的查询接口 |
| `print(Text)` | 把文本作为游戏命令交给 `CommandScript`，不是普通输出 |
| `GetToken` | 按分隔符取出第一个分段并返回剩余字符串 |
| `CompareStr` | 比较两个字符串是否相等 |
| `IntToStr` / `StrToInt` | 整数与字符串转换 |
| `Length` | 字符串长度 |
| `Random(N)` | `0..N-1` 的随机整数 |
| `Inc` / `Dec` | 整数变量加一/减一 |
| `exit` | 结束当前事件 |

有效的游戏接口分别见 [`../callfunc/`](../callfunc/) 和 [`../print/`](../print/)。

## Self、Sender 与返回值

`Self` 是正在执行脚本的对象，`Sender` 是触发者；二者的真实类型由事件调用点决定：

- `System.OnUserStart`：`Self` 是登录玩家，`Sender=nil`。
- NPC 点击、说话等交互：`Self` 通常是 NPC，`Sender` 通常是玩家。
- 动态对象机关事件：`Self` 是 `DynamicObject`，某些自动事件没有 `Sender`。
- 攻击事件：`Self` 是受击对象，`Sender` 通常是攻击者。

基础 `TBasicObject` 的许多玩家专用虚方法只返回默认值或不执行操作；只有对象实际为 `TUser` 时，任务、职业、背包等接口才会读写玩家数据。

事件返回值也只有调用方主动检查时才生效。`OnDanger` 返回精确字符串 `false` 可取消对应攻击路径；传送门检查路径中的 `OnMove` 返回 `false` 可阻止进入。普通过程返回内容不会自动改变游戏流程。

## 版本兼容

[`../Script/`](../Script/README.md) 是云端千年神武奇章线上优化版归档；`gameserver-tgs1000/bin/Script` 是当前炎黄运行脚本基线，包含仓库后续修复。当前炎黄 `龙师父.txt` 已使用有效接口 `getsenderjobgrade`；云端归档仍保留未注册的 `getjobgrade`，不能直接照搬。炎黄脚本的 `say` 分隔符和 `绣球.txt` 普通文本分派错误也已修复，详见 [归档与迁移说明](../Script/README.md)。
