# 公开源码与引用说明

本资料库提供炎黄新章的通用运维、协议、数据表和脚本说明。读者可通过以下公开仓库核对原生实现，无需访问私有开发工作区。

## 源码入口与范围

| 仓库 | 查阅范围 |
| --- | --- |
| [Cl1000](https://github.com/oiuv/Cl1000) | 原生客户端工程、窗体、登录与游戏消息处理、共享协议及客户端依赖 |
| [TGS1000](https://github.com/oiuv/TGS1000) | TGS 游戏逻辑、世界调度、角色状态、配置加载、脚本解释器及配套依赖 |

两者是维护者提供的升级前公开源码参考基线，不保证包含后续版本的全部修正。不能仅凭“原版”名称推断通信版本、倍率或其它默认值；必须查看所引用提交的实现及目标运行配置。

TGS 是游戏逻辑服务，不等于整套服务端。Balance 分流、Gate 登录校验、Login 账号验证和 DB 持久化应分别核对对应服务；不能仅凭这两个仓库证明整条登录链路已完整验证。各服务职责见 [系统架构](architecture.md)。

## 文档路径与公开仓库路径

文档中的 `client/`、`tgs1000/` 是模块位置标识；在独立源码仓库中，对应模块的主源码位于仓库根目录。

| 文档中的代码位置 | 公开仓库中的位置 |
| --- | --- |
| `client/Client.dpr`、`client/FLogOn.pas`、`client/FMain.pas` | Cl1000 根目录下的同名文件 |
| `client/Lib/ALib/` | Cl1000 的 `Lib/ALib/` |
| `tgs1000/tgs1000.dpr`、`tgs1000/UUser.pas`、`tgs1000/svClass.pas` | TGS1000 根目录下的同名文件 |
| `1000ydef/` | 对应公开仓库的 `Kor/1000ydef/` |
| `Common/` | 对应公开仓库的 `Kor/Common/` |

共享单元须使用所研究仓库同一提交中的副本；名称相同不代表两端文件内容、结构宽度或编译条件相同。下载与构建要求分别以两个源码仓库的 README 为准，本资料库本身不作为完整构建工程。

## 主题查阅入口

- 客户端登录与收发：Cl1000 的 `FLogOn.pas`、`uHostAddr.pas`、`Lib/ALib/uClientPackets.pas`，结合 [客户端连接与通信](client-communication.md)。
- 客户端游戏消息处理：Cl1000 的 `FMain.pas`，按消息号对查服务端发送与处理分支。
- TGS 启动与调度：TGS1000 的 `tgs1000.dpr`、`SVMain.pas`、`svClass.pas`，结合 [运行生命周期](TGSRuntime.md)。
- 角色与物品：TGS1000 的 [UUser.pas](https://github.com/oiuv/TGS1000/blob/main/UUser.pas)、`uUserSub.pas`，结合 [战斗与状态](TGSCombat.md)、[物品表](Init_item.sdb.md)。
- 脚本分派与解释：TGS1000 的 `uScriptManager.pas`、`ScriptCls.pas`、`Kor/Common/ScriptBasic.pas`，结合 [脚本入口](Script.md) 和 [Pascal 子集说明](Pascal.md)。

## 引用与版本核对

1. 仓库首页和 `main` 链接只作导航。为具体结论提供证据时，记录已核实的 commit、文件、函数或消息号，并优先使用 GitHub 的提交固定链接；行号只对该提交有效。
2. 核对编译条件、调用方与被调用方、发送与接收两端，以及配置的读取和使用位置。注释、README 和字段名称不能单独证明实际行为。
3. 原始基线用于理解机制与对照变化；现行功能以目标版本实现及实际资源为准。文档若涉及公开基线之外的通用修正，应注明适用条件，提供已公开证据，不能把基线链接当作修正后的实现证明。
4. 保留本资料库的 [TGS 核心源码镜像](TGS核心源码/) 和 [协议定义](deftype.pas)，便于独立阅读；镜像与外部仓库按实际版本核对，不要求无条件整目录同步。未核实的差异明确标注。
5. 引用公开仓库不扩大本文档的收录范围：不加入私有辅助实现、Python 工具、内部部署资料、玩家记录或凭据。尚未公开的代码不能直接复制到本资料库充当证据。

游戏文本与 Pascal 源码保留各自既有编码，不能因为浏览器显示乱码就整体转码。历史帮助、游戏资料及运营脚本的证据边界见 [技术资料索引](README.md) 与 [Script 归档说明](../Script/README.md)。
