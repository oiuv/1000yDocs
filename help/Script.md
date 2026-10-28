# Script.SDB 与脚本绑定

本页说明脚本的登记、绑定与执行上下文。首次编写脚本可从[开发入门](../Script.md)开始。语法细节见 [千年脚本语法](Pascal.md)，全部接口见 [`../print/`](../print/) 和 [`../callfunc/`](../callfunc/)，完整 NPC 开发示例见 [demo.md](demo.md)。

源码获取与路径见[公开源码引用说明](source-reference.md)；历史运营脚本的版本区别和迁移检查集中见[Script 归档说明](../Script/README.md)。

## Script.SDB

`Script.SDB` 当前表头有三列：

```text
Name,FileName,Desc,
1,System.txt,System,
2,某对象.txt,用途说明,
```

`Name` 按约定填写配置引用的脚本编号，`FileName` 是相对 `Script` 目录的文件名，`Desc` 只作说明。文件名、`unit` 名和游戏对象名不要求相同，但保持一致更便于维护。

**实际绑定使用登记行顺序，不是按 `Name` 建立编号映射。** [加载器](TGS核心源码/uScriptManager.pas) 的 `LoadFromFile` 为表中每条有效登记创建一个脚本槽；`CheckScriptEvent` 和两个 `CallEvent` 重载均通过 `DataList[aIndex - 1]` 取脚本。因此表内 `Name` 必须与从 1 开始的登记序号一致。

缺少文件时记录 `Not Found`，保留没有事件处理函数的空脚本槽，后续脚本不前移。恢复文件并重新加载后仍使用原位置。0、负数或超出列表的索引不执行脚本；缺文件仍是发布前需要修复的配置错误。

不同配置不能照搬这个连续编号要求；地图 ID、角色事件标记及旧擂台分别有自己的起点与查找方式，见 [配置编号、索引与固定容量](ConfigurationIdentifiers.md)。

修改索引后应确认：

1. 数据行按 `Name=1,2,3,...` 连续排列；不要单独排序、跳号或删除中间行；
2. 每一个索引文件均存在且可正常加载，并保持 GBK/CP936；前序缺文件也必须修复后再发布；
3. `Init`/`Setting` 中的 `Script` 字段与实际加载序号一致；调整顺序须同步全部引用；
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

## 登记范围与启用

`TScriptManager.LoadFromFile` 只遍历 `Script/Script.SDB` 的 `FileName` 字段，并逐个加载被索引的脚本，不会扫描目录中的全部 `.txt`。实际加载范围以目标部署的登记表为准，不能以目录中的文件总数判断。

未登记文件可以用于分析备用实现，但“文件存在”不等于“服务器当前会执行”。启用时应在索引末尾追加连续编号并检查引用该编号的 `Init`/`Setting` 对象；不能只复制文件，也不能把任意空闲数字当作可独立使用的编号。

## Self 与 Sender

`TScriptManager.CallEvent` 在事件调用期间保存当前 `Self` 和 `Sender`。带 `aManager` 参数的重载还处理 `checkitemregen` 等地图命令，再调用 `CommandScript` 分派其它命令，见 [uScriptManager.pas](TGS核心源码/uScriptManager.pas)：

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

脚本命令需要通过脚本事件中的 `print(...)` 调用；源代码中的 GM 管理指令与脚本语法不是同一入口。聊天指令的权限、参数与实现限制见 [GM 管理命令](GMCommands.md)，不能把脚本 `print` 命令直接作为聊天指令输入。创建测试对象时优先使用现有脚本中的已验证形式，例如：

```pascal
print ('mapaddobjbyname monster 年兽 40 55 1 154 true');
print ('mapaddobjbyname dynamicobject 幸运女神 44 55 1 0 false');
print ('mapregen 115');
```

测试完成后清理动态对象，并确认 `setallowdelete`、地图名和对象名与当前配置一致。
