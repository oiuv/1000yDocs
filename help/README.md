# 千年服务端技术资料

本目录公开提供官方游戏源码的通用技术资料，包括 TGS 运维、配置和脚本开发说明；不收录额外开发的客户端辅助、Python 工具或私有运行记录。事实核对使用项目 Pascal 源码、`tgs1000/bin` 实际程序目录、[炎黄新章游戏资料](炎黄新章游戏资料/README.md)，以及 [云端千年神武奇章线上优化版脚本](../Script/README.md)。接口和加载语义以公开炎黄源码及对应随包为基线；云端脚本只证明该运营版本的真实用法，其中的奖励和活动可能是定制内容。不要根据字段名猜测行为，也不要把两个版本的同名脚本默认视为相同。

## 核心指南

- [统一术语表](TERMINOLOGY.md)
- [系统架构与登录链路](architecture.md)
- [TGS 运行与生命周期](TGSRuntime.md)：启动、主调度、角色接入、保存与关服边界。
- [GM 管理命令](GMCommands.md)：权限、参数、作用范围、危险操作及当前不可可靠使用的入口。
- [TGS 战斗与角色状态](TGSCombat.md)：攻击与资源检查、武功、药效、经验和死亡复活。
- [TGS 世界与怪物运行](TGSWorld.md)：场景广播、视野、近身事件、AI、尸体和地图刷新。
- [Windows 全量编译与构建日志](build.md)
- [客户端连接与通信](client-communication.md)
- [原版客户端补丁更新](client-patch.md)：`cl1000.exe`、Divider、Patch 配置、补丁发布及文件大小与传输速度注意事项。
- [网络协议与封包结构](protocol.md)
- [玩家数据库、SDB 与存档维护](database.md)：记录布局、读写消息、配置扩容、备份与恢复检查
- [sv1000.Ini 运维配置](sv1000.ini.md)
- [game.ini 游戏参数](game.ini.md)
- [常量索引](constants/README.md)
- [特殊物品内部名称与专用机制](SpecialItems.md)：固定名称、配置指定名称、触发条件、消耗和未启用分支。
- [Pascal 脚本说明](Pascal.md)、[Script.SDB 与脚本入口](Script.md)
- [事件配置](Event.md)、[任务公告](QuestNotice.md)、[ITEMLOG 福袋数据](ITEMLOG.md)
- [制造配置](manufacture.md)、[材料配置](Material.md)
- [怪物掉落机制](Init_monster.sdb.md#掉落持有与任务物品)：`HaveItem` 周期计数、`FallItem` 整组触发、参数区别与共享范围。

## 运行资源与扩展数据

- [AdditionalAttrib 附加属性表](AdditionalAttrib.md)
- [SMP/SMA 地图文件](MapFiles.md)
- [NpcSetting 配置](NpcSetting.md)
- [help 窗口文本](HelpFiles.md)
- [程序根目录文本资源](RuntimeResources.md)
- [运行时 SDB 与 Guild 数据](RuntimeData.md)
- [源码校核与运行注意事项](AuditReport.md)

## Init 数据表

基础对象与地图：

- [Item.SDB](Init_item.sdb.md)、[ItemDrug.SDB](Init_ItemDrug.sdb.md)
- [NPC.SDB](Init_npc.sdb.md)、[Monster.SDB](Init_monster.sdb.md)
- [Map.SDB](Init_map.sdb.md)、[AreaData.SDB](Init_AreaData.sdb.md)
- [DynamicObject.SDB](Init_DynamicObject.Sdb.md)
- [MineObject.SDB](Init_MineObject.sdb.md)、[MineObjectAvail.SDB](Init_MineObjectAvail.sdb.md)、[MineObjectShape.SDB](Init_MineObjectShape.sdb.md)

武功与属性：

- [Magic.SDB](Init_magic.sdb.md)、[MagicParam.SDB](Init_MagicParam.SDB.md)
- [BestMagic1Cycle](Init_BestMagic1Cycle.sdb.md)、[BestMagic2Cycle](Init_BestMagic2Cycle.sdb.md)、[BestMagic3Cycle](Init_BestMagic3Cycle.sdb.md)、[BestMagicStateData](Init_BestMagicStateData.sdb.md)
- [AddDamage](Init_AddDamage.sdb.md)、[AddPalmDamage](Init_AddPalmDamage.sdb.md)、[AddArmor](Init_AddArmor.sdb.md)
- [AddAttribGrade](Init_AddAttribGrade.sdb.md)、[AddAttribProbability](Init_AddAttribProbability.sdb.md)、[AM_WHRelation](Init_AM_WHRelation.sdb.md)
- [ConsumeEnergy](Init_ConsumeEnergy.sdb.md)、[EnergyLimitTable](Init_EnergyLimitTable.sdb.md)、[NeedStatePoint](Init_NeedStatePoint.sdb.md)、[PowerLevel](Init_PowerLevel.sdb.md)

事件、任务与职业：

- [Event.SDB](Init_Event.SDB.md)、[EventParam.SDB](Init_EventParam.SDB.md)
- [Arena.SDB](Init_Arena.sdb.md)、[PosByDie.SDB](Init_PosByDie.sdb.md)、[QuestSummary.SDB](Init_QuestSummary.sdb.md)、[Zhuang.SDB](Init_Zhuang.sdb.md)
- [JobGrade](Init_JobGrade.sdb.md)、[JobTalent](Init_JobTalent.sdb.md)、[JobUpgrade](Init_JobUpgrade.sdb.md)
- [SmeltItem](Init_SmeltItem.sdb.md)、[SmeltItem2](Init_SmeltItem2.sdb.md)、[ToolRate](Init_ToolRate.sdb.md)

## Setting 场景表

- [CreateGate](CreateGate.SDB.md)、[CreateGateEx](CreateGateEx.SDB.md)
- [CreateMonster%d](CreateMonster.SDB.md)、[CreateNpc%d](CreateNpc.SDB.md)
- [CreateDynamicObject%d](CreateDynamicObject.SDB.md)、[CreateMineObject%d](CreateMineObject.sdb.md)
- [CreateGroupMove](CreateGroupMove.sdb.md)、[CreateMirror](CreateMirror.sdb.md)
- [CreateSoundObject](CreateSoundObject.sdb.md)、[CreateVirtualObject](CreateVirtualObject.sdb.md)、[CreateZoneEffect](CreateZoneEffect.sdb.md)

`%d` 表示加载器按当前地图/服务器编号选择文件，不能简单复制成无编号文件。

## 源码镜像与历史资料

`TGS核心源码/` 和本目录的 `deftype.pas` 是便于独立查阅的公开源码镜像。公开范围内的通用修正应同步核对；部署定制的通信版本、倍率和视野数值不覆盖公开基线。文档引用以对应公开实现和实际配置为准，不把文件整体相同作为必要条件。`readme.chm`、`TGS2011.chm` 属于历史帮助文件，只能作为辅助线索，不能覆盖源码与实际配置。版本脚本的比较结论和迁移检查见 [Script 归档说明](../Script/README.md)。

原始炎黄文本使用 CP936/GBK；技术 Markdown 统一使用 UTF-8。
