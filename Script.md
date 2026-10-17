# Script 脚本入口

千年脚本由 `ScriptCls.pas` 的定制解释器执行，不是完整的 Object Pascal。`Script/Script.SDB` 将数字脚本编号映射到 `.txt` 文件；`Item.sdb`、`Map.sdb`、`EventParam.sdb` 以及多类 `Setting` 表通过该编号绑定脚本。

## 版本与证据来源

- `tgs1000/bin/Script/`：炎黄新章随包脚本，与当前源码配套核对。
- [`docs/Script/`](Script/README.md)：云端千年神武奇章线上优化版脚本，适合参考业务流程，但定制内容和接口必须先做兼容检查。
- `uScriptManager.pas`、`ScriptCls.pas`、`Common/ScriptBasic.pas`：当前接口和解释器语义的最终标准。

两套真实 `System.txt` 都使用玩家自身的 `FirstQuestNo` 判断首次登录。核心逻辑如下：

```pascal
procedure OnUserStart (aStr : String);
var
   Str : String;
   FirstQuest : Integer;
begin
   Str := callfunc ('getfirstquest');
   FirstQuest := StrToInt (Str);
   if FirstQuest < 1 then begin
      // 发送欢迎消息
      Str := 'changefirstquest 1';
      print (Str);
      exit;
   end;
end;
```

`TUser` 以登录玩家作为 `Self` 调用 `OnUserStart`，所以这里的无 `sender` 版本确实读写玩家任务字段；这不表示其它 NPC 脚本中的 `Self` 也是玩家。

## 解释器支持范围

- 关键字和标识符不区分大小写；单引号内的字符串不会转小写。因此 `print`/`callfunc` 字符串中的接口名必须使用索引所列的精确拼写与大小写。
- 数据类型只有 `Integer`、`String`、`Boolean`；变量创建时先清零，未显式初始化时分别为 `0`、空字符串和 `False`。
- 支持 `unit`、`interface`、`extern`、`var`、`implementation`、过程/函数、`if`、`for` 以及有限的表达式。
- 不支持原生 Pascal 的 `program`、`uses`、`const`、`type`、数组、`writeln`、`readln` 等通用语法。
- 当前词法器只实际跳过 `//` 行注释；不要使用 `{...}` 或 `(*...*)`。
- 表达式编译器能力有限，线上脚本通常把长字符串拼接和复杂计算拆成多条赋值。

完整限制和安全写法见 [Pascal 脚本语法](help/Pascal.md)。

## 内置函数

| 函数 | 说明 |
|---|---|
| `callfunc(Text)` | 调用游戏查询函数并返回字符串；有效名称见 [`callfunc/`](callfunc/README.md) |
| `CompareStr(A, B)` | 字符串相等时返回 `True` |
| `GetToken(Source, Token, Sep)` | 取出第一个分段写入 `Token`，返回剩余字符串 |
| `IntToStr(Value)` | 整数转字符串 |
| `StrToInt(Text)` | 字符串转整数 |
| `Length(Text)` | 返回字符串长度 |
| `Random(N)` | 返回 `0` 到 `N-1`；上界 `N` 不会返回 |

## 内置过程

| 过程 | 说明 |
|---|---|
| `print(Text)` | 将字符串交给 `TScriptManager.CommandScript`；第一个空格前必须是已注册命令 |
| `Inc(Value)` / `Dec(Value)` | 对整数变量加一/减一 |
| `exit` | 立即结束当前事件 |

有效 `print` 命令见 [`print/`](print/README.md)。`print` 不是通用日志或文本输出函数；直接写 `print('普通文本')` 不会自动显示给玩家。

## 事件入口

事件名以 `On...` 开头，由对象加载脚本时注册，再由具体游戏路径调用。当前共登记 29 个事件，分别记录在 [`procedure/`](procedure/) 和 [`function/`](function/README.md)。

事件的 `Self`、`Sender`、参数和返回值必须按调用点判断：

- `Self` 是本次执行脚本的对象；`System.OnUserStart` 的 `Self` 是玩家。
- `Sender` 通常是触发交互或攻击的玩家，也可能为 `nil`。
- 只有调用方读取返回值的事件才具备拦截语义，例如传送门路径中的 `OnMove` 和攻击前的 `OnDanger`。

编写新脚本时，先从当前 `bin/Script` 复制结构，再查对应事件和接口页面；迁移云端神武版脚本时还要检查 [版本兼容说明](Script/README.md)。
