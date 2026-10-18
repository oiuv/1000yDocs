# 运行时 SDB 与 Guild 数据

程序根目录和 `Guild/` 中有一组会被服务器主动回写的数据。它们不是只读模板，在线编辑可能被内存状态覆盖。

## 根目录数据

### Sysop.SDB

表头为 `Name,SysopScope,`。服务器按角色名读取整数权限范围。主要 GM 命令要求 `SysopScope >= 100`；角色初始化时，达到 100 的权限转为 101。`@解除躲闪`、`@设定躲闪` 分别切换为 100、101，影响相关战斗保护分支，不是修改装备躲闪数值。

`TSysopClass` 构造时读取文件，虽然存在 `ReLoadFromFile` 方法，但聊天命令 `@READ` 已被注释，不能据此宣称支持在线重载权限表。`@syssop` 只修改操作者的当前权限，不保存文件。变更权限表应安排服务重新加载和角色重新登录，并核验实际权限；完整指令见 [GM 管理命令](GMCommands.md)。

### Prison.SDB

表头为 `UserName,PrisonTime,ElaspedTime,PrisonType,Reason,`。加载时服务器读取用户名、类型、已过时间和原因，但不信任文件中的 `PrisonTime`，而是根据 `PrisonType` 重新计算：`A<n>` 从 3 天起按次数翻倍，`B<n>` 为 n 天，`M<n>` 最多 3 天。

服务器按 `5 * 60 * 100` tick 保存；正常 10 ms tick 且无测试加速时约为 5 分钟，退出时也会保存。不要在运行中手工修改。

囚禁时间以分钟存储，但类型中的 `B<n>`、`M<n>` 按天换算。当前加载行为还造成两项管理限制：`@追加囚禁资料` 的累计刑期会在重启后按最后保存的类型重算；`@设定囚禁时间` 写出的类型为 `C`，加载器不支持该类型，重算为 0。不能将 SDB 保存成功等同于这两种操作已经可靠持久化。具体参数见 [断线与囚禁](GMCommands.md#断线与囚禁)。

### MagicForGuild.SDB

门派武功在启动时并入武功列表，创建、压缩门派武功时又会更新并保存该文件，然后重载武功。它与 `Init/Magic.SDB` 字段相近但增加 `GuildName` 等运行字段，应保留实际表头，不要手工重排行或拿静态武功表覆盖。

### MacroData/MCYYYYMMDD.SDB

反外挂检测命中时，`TMacroChecker` 按日期追加 `DateTime, Name, Case` 记录。文件只是追加式检测记录，不会在启动时载入；目录不存在或写入失败时异常会被吞掉，因此空目录不代表检测一定没有触发。归档时可按日期移动旧文件，但不要在进程写入当日文件时改名或编辑。

## LOG 目录输出

- `LOG/SystemInfoYYYYMMDD.SDB`：客户端回传硬件信息后按日追加 `MasterName,CPUSpeed,RAM,VGA`。同一账号在本次进程生命周期内只记录一次；`LOG/` 不存在或不可写会直接影响该处理路径。
- `LOG/USERINFO.SDB`：不是自动周期文件，仅在管理员执行 `@使用者情报` 且不带角色参数时，由当前在线用户列表生成。

随包 `LOG/` 只有占位文件属于正常初始状态。归档运行日志时应保留日期和编码，不要把输出文件误当作启动输入。

## Guild 目录

- `CreateGuild.SDB`：门派主数据，启动加载、每小时和正常退出保存。实际随包表头中 `Title`、`MapID` 各出现两次，维护工具必须保留真实表头，不能自行去重。
- `DeletedGuild.SDB`：销毁门派的追加记录。
- `ExitGuildUser.SDB`：退出门派用户记录，启动加载、退出保存。
- `<门派名>GUser.SDB`：该门派成员数据，由门派对象保存和加载。
- `<门派名>_ITEMLOG.BIN`：门派仓库二进制结构，不是 SDB 文本。

## 备份与恢复

1. 停止游戏服务并确认进程退出。
2. 整体备份 `Sysop.SDB`、`Prison.SDB`、`MagicForGuild.SDB` 和完整 `Guild/`，不要只复制单个门派主表。
3. 文本 SDB 保留 GBK、原表头和尾随逗号；`_ITEMLOG.BIN` 禁止文本编辑。
4. 恢复时使用同一程序版本的一致快照，再检查启动日志和门派/监狱功能。

福袋主库另见 [ITEMLOG](ITEMLOG.md)；它是长期保持打开的二进制文件，不属于本页的文本 SDB 编辑范围。

源码依据：`svClass.pas` 的 `TSysopClass`、`TPrisonClass`、`TMagicClass`，以及 `uGuild.pas`。
