# 千年游戏开发手册

运维配置、协议、数据表及资料边界统一从 [千年服务端技术资料](help/README.md) 进入；
源码英文名与客户端中文名遵循 [统一术语表](help/TERMINOLOGY.md)；脚本事件可从
[过程事件索引](procedure/README.md) 和 [返回值事件索引](function/README.md) 查阅。

## 基本介绍

古老的千年使用的是pascal语言，开发相关目录结构如下：
```
├─event
├─Help
├─Init
├─NpcSetting
├─QuestNotice
├─Script
└─Setting
```

如果在游戏中新增一个交易NPC，开发涉及如下目录：

> 名称：杂货商

文件|说明
---|---
Help\杂货商.txt|交易界面内容
Init\Npc.sdb|初始化NPC设置
NpcSetting\杂货商.sdb|NPC自动说话内容（非必需）
NpcSetting\杂货商.txt|买卖物品列表
Script\Script.sdb|脚本索引
Script\杂货商.txt|交易脚本代码
Setting\CreateNpc88.sdb|在编号88的地图上生成NPC

本教程重点说明 `Script` 目录中的脚本开发。对象属性、地图生成、事件参数和运行资源还分别由 `Init`、`Setting`、`Event`、`NpcSetting`、`Help` 等目录控制，不能只修改脚本。

可绑定脚本的互动对象通过 `Script.SDB` 关联脚本文件；未配置脚本编号的对象不要求有对应文件。脚本使用类似 Pascal `unit` 的结构：

```pascal
unit Unit1;  

interface

// 过程或函数声明

implementation

// 过程或函数实现

end.
```

以下结构取自云端千年神武奇章线上优化版脚本 [`Script/储物袋.txt`](Script/储物袋.txt)。该文件名为“储物袋”，脚本内的单元名为“储物箱”，服务器按 `Script.SDB` 的文件映射加载，不要求二者同名：
```pascal
unit 储物箱;

interface

function  GetToken (aStr, aToken, aSep : String) : String;
function  CompareStr (aStr1, aStr2 : String) : Boolean;
function  callfunc (aText: string): string;
procedure print (aText: string);
function  Random (aScope: integer): integer;
function  Length (aText: string): integer;
procedure Inc (aInt: integer);
procedure Dec (aInt: integer);
function  StrToInt (astr: string): integer;
function  IntToStr (aInt: integer): string;
procedure exit;

procedure OnDblClick(aStr : String);

implementation

procedure OnDblClick(aStr : String);
var
   Str : String;
   Race : Integer;
begin
   Str := callfunc ('getsenderrace');
   Race := StrToInt (Str);
   if Race = 1 then begin
      Str := 'logitemwindow';
      print (Str);
      exit; 
   end;
end;

end.
```

以上代码中，`OnDblClick` 是物品双击入口，其余声明构成这批线上脚本的常用基础结构。实际只需声明当前脚本使用的内置函数和事件。

这套语言只是服务端自定义的 Pascal 子集，并非完整 Delphi/Pascal。游戏特定功能分为 `procedure` 事件/命令和 `function` 事件/查询，具体见 [Script.md](Script.md)。

## pascal游戏开发基础说明

* 脚本标识符和关键字**不区分大小写**；单引号内的字符串内容保持原样
* `function` 有返回值，`procedure` 无返回值
* 变量声明示例：`var Str: String;`
* 赋值使用 `:=`，相等比较使用 `=`
* 当前解释器支持 `Integer`、`String`、`Boolean` 三类变量；复杂表达式能力有限
* `_` 转空格、`,` 转换行只出现在部分命令的参数处理，不能视为所有字符串的全局规则
* `System.txt` 的 `OnUserStart` 由登录玩家作为 `Self` 调用；其它事件中的 `Self` 是绑定脚本的对象，`Sender` 是否为玩家取决于实际触发路径

更多语法限制请见 [help/Pascal.md](help/Pascal.md)。

脚本示例有两个版本来源：`gameserver-tgs1000/bin/Script` 是炎黄新章运行脚本基线，包含仓库已提交的接口和文本修复；[`docs/Script`](Script/README.md) 是云端千年神武奇章线上优化版脚本归档。云端脚本只能证明该运营版本的实际用法；定制奖励不能视为原版规则，移植前仍须以当前 Pascal 分派器确认接口兼容性。
