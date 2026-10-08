# 源码与资料审查记录

最近复核：2026-10-08；保留 2026-08-20 的资料清点和历史构建记录。本轮对照源码修正专题页，并同步总报告；未修改 Delphi、运行配置或原始资料，也未登录正式服。

## 资料边界

现行行为只由仓库 Pascal 源码和 `gameserver-tgs1000/bin` 实际文件确定；`炎黄新章游戏资料` 用于核对玩家可见规则。`docs/Script` 是用户实际运营的云端千年神武奇章线上优化版脚本，只证明该运营版本用法；定制奖励不能视为原版神武规则，也不能覆盖炎黄接口定义。未使用网络资料或按字段名猜测。

## 已完成校核

- 对照全部 197 个云端神武版 `.txt` 及 `Script.SDB`：与炎黄目录有 164 个同名数据文件（含 `Script.SDB`），其中 60 个相同、104 个不同；另有 34 个云端版独有 `.txt`，炎黄独有 `火炉1.txt`。差异可能同时包含版本演进和云端运营优化。
- 复核脚本解释器、`callfunc`/`print` 分派、`Self`/`Sender` 上下文和现有事件页；修正任务函数、对象创建/删除、冻结、延迟 tick、事件返回值等错误说明。
- 用当前分派器反向校验索引：109 个有效 `callfunc`、76 个有效 `print`（含入口专用 `checkitemregen`）和 29 个实际事件名均有独立页面；`getjobgrade`、`changequeststr` 只作为未实现迁移说明，不计入有效接口。
- 当前 `Init/` 的 38 个主数据表均有对应页，未单列的 4 个文件是随包备份/改名副本；11 类有效 `Setting` 场景表均已有入口页，`@CreateDynamicObject*` 作为备份名不算加载族。本轮进一步按真实表头和加载器补全 `CreateGate`、`CreateVirtualObject`、`CreateDynamicObject`、`CreateMonster`，不能把“有页面”等同于“字段已经完整”。
- 对照 `Init/Item.SDB` 和玩家资料修正制造配方；补齐 AdditionalAttrib、地图二进制、NpcSetting、help 窗口、Event、ITEMLOG、根目录资源、Guild/运行数据等文档。
- 清理脚本示例中的对象名乱码，建立云端神武优化版/炎黄基线的版本标注和迁移检查规则，并确认 96 篇炎黄玩家资料均已进入目录索引。
- 复核 `Script.SDB` 实际加载边界：炎黄目录有 164 个 `.txt`，索引 145 个且引用文件全部存在；另外 19 个目录文件默认不加载，已在脚本文档中明确列出。
- 修正协议外层、加密载荷、7 路 UDP 日志、Paid 双缺省端口、SDB/SQL Login 配置差异，以及服务接入白名单、Gate 心跳和限包的实际源码行为。
- 将材料页中的云端神武版获取方式与炎黄基线明确隔离，修正杂货商示例的 Help 文件名和当前物品表不存在的五种月魂。

## 已确认但未修改的程序问题

这些不是文档待猜项，且本轮按约束不改游戏源码：

- `RandomEventItem` 只分配 0～2，却加载并调用编号 3；云端神武版脚本的 4、5 也不兼容当前结构。
- `Marry.SDB` 的新记录标志初始化、离婚日期计算、保存列和姓名查询各有明确源码缺陷。
- `Event/NameList.SDB` 的存在检查与实际加载目录不一致。
- `NpcSetting` 的 `DeallerSkill.ProcessMessage` 被注释；`BadIpAddr.txt` 只加载未见拦截调用。
- `NpcFunc.SDB` 无随包数据且无消费调用；`BestMagicEnergyPoint.sdb` 加载代码被注释。
- `TPacketSender.PutPacket` 允许 8192 字节 Data，但加密路径使用同为 8192 字节的固定临时缓冲区；4/3 扩张和边界标记使安全 Data 上限只有 6133 字节。
- Gate 的 `BalanceSendTick` 从未更新，三秒条件在启动后持续为真，实际随一秒显示定时器发送心跳。
- Gate 限包环形槽约每 80 毫秒被覆盖，`CheckTime >= 1000` 在稳定运行后通常不成立，不能视为有效的一秒限包。
- `TMineObjectClass.LoadFromFile` 给 `TMineObjectAvailData` 清零时错误使用 `SizeOf(TMineObjectShapeData)`。
- SDB Login 接受连接时不调用 IP 检查器；DB/SQL Login 的 `IPList.txt` 缺失时检查器会放行全部来源，必须依靠内网和防火墙边界。

## 维护要求

原始 SDB/TXT 和线上脚本保留 GBK/CP936；Markdown 使用 UTF-8。更新说明前必须同时核对加载器、调用点和随包文件，代码缺陷应明确标为缺陷，不得用推测补成“可用功能”。

## 2026-10-08 文档修订

### 网络与持久化

- TGS 内部 `TfrmGate` 不等于外部 Gateway。角色保存由 TGS 的 DB 连接直接发送，不绕经外部 Gate；保存队列按 10 个 tick（100 ms）出队尝试，一次一项，成功后移除。周期保存的 `rEnd=1` 对应 `DB_UPDATE_END`，不能写成 `rEnd=0`。依据：`FGate.pas`、`uConnect.pas` 和 `Common/uAnsTick.pas`。
- 修正 Client/Balance/Gate 的 TCP 3053、TCP 3054 和 UDP 3030 方向；Balance 保留的 TCP 3000 监听不证明当前 Gate 使用它。角色列表先于 Paid 查询，付费确认后才能完成角色接入。
- 校正 `uCrypt.pas` 置换表例值、`TComData.Size` 的正文长度语义，以及原生客户端状态校验的 packed 结构、CRC 和时间检查；补齐 `SM_NETSTATE` / `CM_NETSTATE` 调用链。详见 [协议](protocol.md)、[架构](architecture.md) 和 [客户端通信](client-communication.md)。

### 数据表及脚本

- 修正耗能计算、绝世武功升层属性点、护体/掌法关系、附加属性抽取、庄园状态/票价、物品条件与数量、守卫格、死亡复活位置、职业等级及绝世属性加成。核对的是实际加载器和消费点，不以表头名称代替行为；参见各 `Init_*.md` 专题页。
- 纠正 `getsenderitemexistencebykind` 的两参数和字符串布尔返回；背包与佩戴武器查询不可混用。`getsenderposition` 返回格坐标，`senderrefill` 不只恢复三项属性，职业天赋也并非固定不变。
- 区分 `Self` 与 `Sender`，修正 `OnChangeState`、`OnGetChangeStep`、`OnBow`、`OnHear`、`OnDie` 的对象范围、发送者和触发时机；狐狸洞地图计时使用 6000 tick，即 60 秒。
- 删除脚本示例中解释器不支持的 `else`、内嵌函数调用及多参数 `print`；保留用于解释实现的原生 Pascal 语法。修正窗口 ID 与物品种类示例、动画常量的状态/方向含义。

### 已解决脚本问题与版本边界

当前 `bin/Script` 的 `龙师父.txt` 已使用 `getsenderjobgrade`，三个脚本的 `say` 分隔和 `绣球.txt` 的正文显示已修正，不再列为当前待修问题。`docs/Script` 仍是云端神武运营版的历史对照，其旧调用需要迁移检查；本轮没有改写该原始档案。

### 完整性与验证限制

受控 Python 文件已增至 83 个，其中 33 个测试文件；CLI 已能登录、查询、移动、战斗和执行辅助任务，不应再归为仅抓包代理。Python 实现状态参考受控代码，实服结果只引用 [客户端测试记录](../../py1000y/client/docs/LIVE_PLAYTEST.md)，不作为炎黄游戏规则的新增标准资料来源。

文档索引覆盖不等于所有语义正确或已实机验收。当前静态校核覆盖接口入口、常量数值、源码镜像和资料索引；真实服务端分支、外部 Battle/Notice 实现及 CLI 掌法首次施放、默认危险低活保护、自然延迟掉落、卡住/绕圈和近期安全补丁仍需专项验收。本轮不重新执行历史 Delphi 构建，也不以旧编译成功证明当前运行可靠性。

本轮修订后检查：309 篇 Markdown 中的 587 个相对文件链接有效；HTML 的 29 个链接与嵌套结构检查通过；27 份 Pascal 镜像与原源码字节一致。197 个云端脚本、96 篇炎黄原始资料和 164 个炎黄脚本仍可按 GBK 解码，无 UTF-8 BOM 或独立 LF。改动文件仅为 Markdown/HTML；两个仓库按现有配置执行 `git diff --check` 通过。链接检查只保证文件存在，不代表已校验全部 Markdown 标题锚点。
