# 脚本开发指南

本页说明脚本如何进入当前游戏服务器。语法细节见 [千年脚本语法](Pascal.md)，全部接口见 [`../print/`](../print/) 和 [`../callfunc/`](../callfunc/)，完整 NPC 开发示例见 [demo.md](demo.md)。

## 版本来源

| 位置 | 版本与用途 |
|---|---|
| `gameserver-tgs1000/bin/Script/` | 炎黄新章运行脚本基线，含仓库后续修复；用于核对当前配置引用和基础示例 |
| [`docs/Script/`](../Script/README.md) | 云端千年神武奇章线上优化版脚本；用于参考该运营版业务流程 |
| `gameserver-tgs1000/uScriptManager.pas` | 当前 `print`、`callfunc` 注册和 `Self/Sender` 分派标准 |
| `gameserver-tgs1000/ScriptCls.pas` | 当前语法编译和执行标准 |

云端神武版脚本不能直接覆盖当前目录。迁移时要检查接口名、脚本编号、对象/物品/地图名称以及配套 `Help`、`NpcSetting` 文件，并区分云端运营定制与版本演进。当前炎黄 `龙师父.txt` 已改用 `getsenderjobgrade`；云端归档仍使用未注册的 `getjobgrade`，迁移时应替换。当前炎黄的 `say` 分隔符和 `绣球.txt` 文本命令也已修复，归档状态见 [Script 说明](../Script/README.md)。

脚本关键字和变量名不区分大小写，但单引号内的字符串保持原样。当前 `print`/`callfunc` 分派器不会自动转换命令名大小写；接口名应使用索引页所列的精确形式。

## Script.SDB

`Script.SDB` 当前表头有三列：

```text
Name,FileName,Desc,
1,System.txt,System,
2,某对象.txt,用途说明,
```

`Name` 是配置表引用的脚本编号，`FileName` 是相对 `Script` 目录的文件名，`Desc` 只作说明。加载器以编号查找脚本；文件名、`unit` 名和游戏对象名不要求相同，但保持一致更便于维护。

修改索引后应确认：

1. 编号唯一且大于零；
2. 文件存在并保持 GBK/CP936；
3. `Init`/`Setting` 中的 `Script` 字段指向正确编号；
4. 当前源码确实注册脚本使用的全部接口和事件。

## 支持的绑定位置

当前配置可从 `Item.sdb`、`Map.sdb`、`EventParam.sdb`、`CreateGate*.sdb`、`CreateNpc*.sdb`、`CreateMonster*.sdb`、`CreateDynamicObject*.sdb` 等位置引用脚本。具体字段以对应配置页面和 Pascal 加载器为准。

常见对象入口：

- `Item`：实际随包用例主要通过 `OnDblClick` 处理可双击物品。
- `Map`：管理器注册 `OnTimer` 和 `OnEventTimer`。
- `Gate`：除定时事件外，真实 `gate*_*.txt` 还实现 `OnMove` 作为进入判定。
- NPC/Monster/DynamicObject：按各自行为触发点击、说话、攻击、死亡、机关状态等事件。
- `System.txt`：登录时以玩家为 `Self` 调用 `OnUserStart`。

不要把“某类对象的常见事件”写成解释器限制；能否触发取决于服务器是否存在对应 `CallEvent` 调用路径。

## 当前随包的实际加载边界

`TScriptManager.LoadFromFile` 只遍历 `Script/Script.SDB` 的 `FileName` 字段，并逐个加载被索引的脚本，不会扫描目录中的全部 `.txt`。当前炎黄随包有 164 个脚本 `.txt`，`Script.SDB` 索引 145 个且引用文件全部存在；其余 19 个文件默认不加载：

- `火炉1.txt`、`物品回收商.txt`、`event龙师父.txt`；
- `event西域魔人虚像1.txt`～`event西域魔人虚像4.txt`；
- `gateA_A.txt`～`gateA_C.txt`、`gateB_A.txt`～`gateB_C.txt`、`gateC_A.txt`～`gateC_C.txt`、`gateD_A.txt`～`gateD_C.txt`。

这些文件可以用于分析备用实现，但“文件存在”不等于“服务器当前会执行”。启用其中任何脚本都必须先分配 `Script.SDB` 编号，再检查引用该编号的 `Init`/`Setting` 对象；不能只复制文件。

## Self 与 Sender

`TScriptManager.ScriptCommand` 在事件调用期间保存当前 `Self` 和 `Sender`：

- 无 `sender` 前缀的接口通常作用于 `Self`；
- `getsender...`、`changesender...` 等接口通常作用于 `Sender`；
- 名称只是提示，最终仍以 `uScriptManager.pas` 分支和虚方法实现为准；
- `Sender=nil` 的自动事件不能安全调用玩家专用 sender 接口。

尤其不要把 `Self` 固定解释成 NPC。`System.OnUserStart` 的 `Self` 是玩家，因此 `getfirstquest/changefirstquest` 会读写该玩家；普通 NPC 上调用同一基础虚方法只会得到默认值或空操作。

## 编码与调试

- 运行脚本、`Script.SDB`、`Help` 和 `NpcSetting` 采用 GBK/CP936；技术 Markdown 使用 UTF-8。
- 解释器只可靠支持 `//` 注释。
- `print` 不是日志函数，文本首词必须是已注册命令。
- 修改后先在独立测试对象上触发对应事件，查看 `TGS1000.LOG` 的脚本加载异常，再验证玩家可见结果。
- 线上脚本按年运行时也不要原地大批量覆盖；保留当前 `Script.SDB` 与脚本目录快照，分批替换并记录编号变化。

## GM 测试说明

脚本命令需要通过脚本事件中的 `print(...)` 调用；源代码中的 GM 管理指令与脚本语法不是同一入口。创建测试对象时优先使用现有脚本中的已验证形式，例如：

```pascal
print ('mapaddobjbyname monster 年兽 40 55 1 154 true');
print ('mapaddobjbyname dynamicobject 幸运女神 44 55 1 0 false');
print ('mapregen 115');
```

测试完成后清理动态对象，并确认 `setallowdelete`、地图名和对象名与当前配置一致。
