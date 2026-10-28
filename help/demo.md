# 新增交易 NPC 完整示例

在游戏中增加一个杂货商，需要怎么做？具体需要做的工作如下：

1. 需要增加一个NPC到游戏中
2. 需要实现点击NPC弹出交易界面
3. 需要设置交易界面内容
4. 需要设置NPC买卖内容
5. 需要设置NPC自动说话提醒玩家
6. 需要把这个NPC放到地图指定坐标

相关配置各司其职，不能只增加脚本文件：

| 文件 | 用途 |
|---|---|
| `Init/Npc.sdb` | NPC 名称、属性、外形与交易文件设置 |
| `Help/杂货商.txt` | 交互菜单内容 |
| `NpcSetting/杂货商.txt` | 买卖物品列表 |
| `NpcSetting/杂货商.sdb` | 自动说话内容，可选 |
| `Script/杂货商.txt` | 点击、说话和菜单事件脚本 |
| `Script/Script.sdb` | 脚本登记表 |
| `Setting/CreateNpc88.sdb` | 在编号 88 的地图投放 NPC |

示例中的物品、地图和脚本编号须按目标配置核对。尤其不能直接照用示例脚本编号，应遵循[登记顺序与绑定规则](Script.md#scriptsdb)。语法基础见[脚本开发入门](../Script.md)。

### 初始化NPC设置

在`Init`目录下的`Npc.sdb`中增加杂货商NPC，内容如下：

    杂货商,杂货商,-100,,杂货商.txt,TRUE,,TRUE,,,,TRUE,14,33,131,150,30,,,,3500,0,0,0,0,,4,,,,,,,,,,,,,,,,

这里指定了 NPC 名称、属性和外形，并把交易数据文件设为 `杂货商.txt`。`TNpc.Initial` 对销售/回收 NPC 会从 `NpcSetting` 目录加载 `NpcText` 指定的文件。

### 买卖物品列表

在`NpcSetting`目录下新建`杂货商.txt`，内容如下：
```
SELLTITLE:杂货商
SELLCAPTION:要买什么呢?
SELLIMAGE:131
SELLITEM:牛黄
SELLITEM:木皮
SELLITEM:骨头一
SELLITEM:鹿角一
SELLITEM:鹿茸一
SELLITEM:葛根
SELLITEM:甘草
SELLITEM:沙参
SELLITEM:何首乌
SELLITEM:地种参
SELLITEM:天然参
SELLITEM:生铁
SELLITEM:青铜原石
SELLITEM:黄铜原石
SELLITEM:砂金原石
SELLITEM:黄金原石
SELLITEM:白金原石
SELLITEM:千年纯金原石
SELLITEM:硅石原石
SELLITEM:黑石原石
SELLITEM:月石原石
SELLITEM:玄石原石
SELLITEM:耀阳原石
SELLITEM:千年金刚石原石
SELLITEM:青玉原石
SELLITEM:绿玉原石
SELLITEM:黄玉原石
SELLITEM:白玉原石
SELLITEM:黑珍珠原石
SELLITEM:千年水晶原石
SELLITEM:普通水石
SELLITEM:碳酸水石
SELLITEM:冷却水石
SELLITEM:温泉水石
SELLITEM:矿泉水石
SELLITEM:吸着水石
SELLITEM:爆裂水石
SELLITEM:千年水石
BUYTITLE:杂货商
BUYCAPTION:我只收购异宝！
BUYIMAGE:131
BUYITEM:珍珠
BUYITEM:翡翠
BUYITEM:水晶
BUYITEM:琥珀
BUYITEM:王妃金冠
BUYITEM:公主戒指
BUYITEM:王子宝剑
BUYITEM:公主项链
```

这是`Npc.sdb`中杂货商参数设置的脚本文件，设定了NPC可交易的列表。

上述物品名已按当前炎黄 `Init/Item.sdb` 校验。云端神武版脚本使用的银月魂、蓝月魂、金月魂、赤月魂、翠月魂不在当前炎黄物品表中，不能直接加入本示例；这些奖励也不能视为原版神武或当前炎黄规则。

### NPC自动说话内容

在`NpcSetting`目录下新建`杂货商.sdb`，内容如下：

```
Name,boSelfSay,boMain,MainNumber,HearString,SayString,NeedItem,GiveItem,CountLimit,RecoverTime,DelayTime,
1,TRUE,,,,廉价出售各种加工材料,,,,,1500,
2,TRUE,,,,走过路过不要错过啊,,,,,2100,
3,TRUE,,,,收购各种宝物啦,,,,,3000,

```

这个文件指定了NPC自动说话内容，把NPC放到地图上时需要用到。

### 交易界面内容

在`Help`目录中新建`杂货商.txt`，内容如下：
```
<trade>
<head>
<title>杂货商</title>
<image name=z33 value=131>
<text>
材料廉价出售，宝物高价回收，你懂的！
</text>
<command send='close'>关闭</command>
<command send="sell">买 物品</command>
<command send="buy">卖 物品</command>
</trade>
```

这里指定了交易界面的内容，包括说明和菜单，在脚本中调用。

### 交易脚本代码

在`Script`目录下新建`杂货商.txt`，内容如下：

```pascal
unit 杂货商;

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

procedure OnHear (aStr : String);
procedure OnGetResult (aStr : String);
procedure OnLeftClick (aStr : String);

var
   iCallCount : Integer = 0;

implementation

procedure OnLeftClick (aStr : String);
var
   Str : String;
   Race : Integer;
begin
   Str := callfunc ('getsenderrace');
   Race := StrToInt (Str);
   if Race = 1 then begin
      Str := 'showwindow .\help\杂货商.txt 1';
      print (Str);
      exit; 
   end;
end;

procedure OnGetResult (aStr : String);
var
   Str, Name : String;
begin
   if aStr = 'close' then begin
      exit;
   end;
   if aStr = 'sell' then begin
      Name := callfunc ('getsendername');
      Str := 'tradewindow ' + Name;
      Str := Str + ' 0';
      print (Str);
      exit;
   end;
   if aStr = 'buy' then begin
      Name := callfunc ('getsendername');
      Str := 'tradewindow ' + Name;
      Str := Str + ' 1';
      print (Str);
      exit;
   end;
end;

procedure OnHear (aStr : String);
var
   Str, Str1, Str2, Str3, num : String;
   Race, n, p : Integer;
begin
   Str := callfunc ('getsenderrace');
   Race := StrToInt (Str);
   if Race <> 1 then exit;
   Str := aStr;
   Str := GetToken (Str, Str1, '_');
   Str := GetToken (Str, Str2, '_');
   Str := GetToken (Str, Str3, '_');
   n := StrToInt (Str3);
   Str3 := IntToStr (n);
   if n = 0 then exit;
   if Str <> '' then exit;
   if Str1 = '买' then begin
      p := 0;
      if Str2 = '葛根' then p := 60;
      if Str2 = '牛黄' then p := 260;
      p := n*p;
      if p = 0 then begin
         print ('say 现在只有以下物品可以快捷交易：');
         print ('say 葛根、牛黄 100');
         exit;
      end;
      num := IntToStr (p);
      Str := 'getsenderitemexistence 钱币:' + num;
      Str := callfunc (Str);
      if Str = 'false' then begin
         Str := 'say 你没有这么多钱币买';
         Str := Str + Str2;
         print (Str);
         exit;
      end;
      Str := callfunc ('checkenoughspace');
      if Str = 'false' then begin
         print ('say 您的物品栏已满~');
         exit;
      end;
      Str := 'getsenderitem 钱币:' + num;
      print (Str);
      Str := 'putsendermagicitem ' + Str2;
      Str := Str + ':';
      Str := Str + Str3;
      Str := Str + ' @杂货商 4';
      print (Str);
      print ('say 交易完毕，请问还要买什么吗？');
      exit;
   end;
end;

end.
```

脚本指定了点击NPC的功能和交易相关功能。

### 脚本索引

在`Script`目录下的`Script.SDB`中增加杂货商脚本的索引，编号请按顺序增加，编号会在配置NPC到地图上时用到。

### 在编号88的地图上生成NPC

在`Setting`目录下的`CreateNpc88.sdb`中增加以下内容，其中`杂货商.sdb`是NPC自动随机说话的内容。

    3,杂货商,62,77,1,2,139,杂货商.sdb,

这里指定了NPC的名称、坐标、互动脚本和自动发言内容文件，名称、脚本和发言都是前面配置好的文件。

-------

以上示例是比较完整的演示，实际开发中可以选择性的配置，比如只增加一个NPC到地图，那就不需要交易和脚本相关的配置。
