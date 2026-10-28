# Script 脚本开发入门

千年脚本由 `ScriptCls.pas` 的定制解释器执行，是 Pascal 子集。互动对象通过 `Script/Script.SDB` 绑定脚本；物品、NPC、地图及场景生成还需要配套数据表。

## 阅读顺序

| 步骤 | 文档 | 解决的问题 |
|---|---|---|
| 1 | [脚本语法](help/Pascal.md) | 文件结构、变量、条件、表达式、内置函数和语法限制 |
| 2 | [Script.SDB 与脚本绑定](help/Script.md) | 登记顺序、对象绑定、加载与 Self/Sender 上下文 |
| 3 | [过程事件](procedure/README.md)、[返回值事件](function/README.md) | 何时触发、参数含义、返回值是否影响流程 |
| 4 | [print 命令](print/README.md)、[callfunc 查询](callfunc/README.md) | 可执行的游戏操作及可读取的数据 |
| 5 | [新增交易 NPC 完整示例](help/demo.md) | 将 NPC、菜单、商品、脚本和地图投放组合起来 |

`uScriptManager.pas` 负责游戏接口分派，`ScriptCls.pas`、`Common/ScriptBasic.pas` 负责解释器语义。源码获取和路径见[引用说明](help/source-reference.md)；参考历史运营脚本时，先阅读[Script 归档与迁移说明](Script/README.md)。

## 示例：首次登录标记

`System.txt` 的 `OnUserStart` 可用玩家自身的 `FirstQuestNo` 判断首次登录。下面是事件核心片段；完整单元结构及接口声明见[文件结构](help/Pascal.md#文件结构)。

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

## 示例：双击打开个人仓库

归档中的[储物袋脚本](Script/储物袋.txt)展示了 `OnDblClick`、`getsenderrace` 和 `print('logitemwindow')` 的组合。文件名为“储物袋”，单元名为“储物箱”；二者不要求同名，加载规则见[脚本绑定](help/Script.md#scriptsdb)。该实例属于云端神武运营版，移植时须核对目标版本的物品及仓库接口。

## 编写前确认

- `print` 是游戏命令分派入口，不是普通文字输出；显示消息应使用对应的消息命令。
- 单引号内字符串保持原样，命令名须使用接口索引中的拼写与大小写。
- `Self` 是执行脚本的对象，`Sender` 由触发路径决定；NPC 点击和玩家登录不能套用同一个对象假设。
- 声明或登记了事件不代表它一定会触发；是否执行、能否用返回值阻止操作，应查对应事件的调用条件。

完成后按[编码与调试](help/Script.md#编码与调试)检查加载日志，并实际触发正常、拒绝和重复操作路径。
