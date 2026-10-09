# 源码校核与运行注意事项

## 资料归属

本文说明官方炎黄新章源码的运行约束。行为以当前 Pascal 服务端源码为准，配置与数据以 `gameserver-tgs1000/bin` 的实际加载文件为准；[炎黄新章游戏资料](README.md) 用于核对玩家可见规则。

`Script/` 中的云端千年神武奇章脚本是经授权保存的运营版参考，包含运营优化。它们不能证明原版神武奖励规则，也不能覆盖炎黄新章接口定义。迁移脚本必须核对函数入口、参数、事件上下文及目标版本的数据表。

本子模块公开提供的服务端源码副本用于独立阅读和核对；其公开范围不代表主仓库其他代码也可以公开。

## 已确认的源码风险

以下是现行源码的限制或缺陷，不应描述为已修复或可靠的安全措施：

| 位置或功能 | 实际问题与维护要求 |
| --- | --- |
| `RandomEventItem` | 分配范围为 0～2，加载和调用却包含编号 3；云端脚本中的编号 4、5也不兼容此结构。不可照搬编号。 |
| `Marry.SDB` | 新记录标志初始化、离婚日期计算、保存列和姓名查询存在缺陷；修改资料前核对加载、查询和保存全过程。 |
| `Event/NameList.SDB` | 存在性检查与实际加载路径不一致，不能只凭文件存在判断生效。 |
| `NpcSetting` | `DeallerSkill.ProcessMessage` 被注释；`BadIpAddr.txt` 有加载但未见拦截调用，不能用它替代防火墙。 |
| 未启用数据 | `NpcFunc.SDB` 无随包数据及消费调用；`BestMagicEnergyPoint.sdb` 的加载代码被注释。 |
| `TPacketSender.PutPacket` | Data 可达 8192 字节，但加密临时缓冲区同为 8192 字节。考虑 4/3 扩张及边界标记，安全 Data 上限为 6133 字节。 |
| Gate 心跳 | `BalanceSendTick` 未更新，三秒判断在启动后持续成立，实际随一秒显示定时器发送。 |
| Gate 限包 | 环形槽约每 80ms 覆盖；稳定运行时 `CheckTime >= 1000` 通常不成立，不能当作有效的一秒限包。 |
| 矿物加载 | `TMineObjectClass.LoadFromFile` 清零 `TMineObjectAvailData` 时错误使用 `SizeOf(TMineObjectShapeData)`。 |
| 后端接入检查 | SDB Login 接入不调用 IP 检查器；DB/SQL Login 在缺少 `IPList.txt` 时放行全部来源。后端必须隔离。 |

## 网络与持久化

- 外部 Gateway 和 TGS 内部 `TfrmGate` 不是同一组件。角色保存由 TGS 的 DB 连接直接发送，不经过外部 Gateway。
- 保存队列按 10 个 tick（100ms）尝试出队，一次一项，发送成功后移除；周期保存的 `rEnd=1` 对应 `DB_UPDATE_END`。
- 角色列表先于 Paid 查询返回；启用计费校验时，付费确认后才能完成角色接入。
- 只有 Balance 和 Gateway 应对外开放。Login、DB、Game、付费后端、管理接口及 UDP 日志接收端须限制来源。

## 文档校核规范

1. 同时核对声明、加载器、调用点和实际配置，不能按字段名猜测功能。
2. 文件位于目录内不代表已加载；脚本须检查 `Script.SDB`，场景表须检查地图加载入口。
3. 保留原始 SDB/TXT 和脚本的 GBK/CP936、CRLF；说明文档使用 UTF-8。
4. 索引齐全、镜像一致或编译成功，不等于所有运行分支已经实机验证。外部 Battle、Notice 等未提供实现的组件，只说明已知接口，不宣称完整行为。
5. 修改协议及数据说明后检查相对链接；公开文档不得依赖私有仓库中的文件。

参见：[架构](architecture.md)、[协议](protocol.md)、[客户端通信](client-communication.md)、[运行数据](RuntimeData.md)。
