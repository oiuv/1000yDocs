# 千年服务端技术资料

本目录公开提供官方游戏源码的通用技术资料，包括 TGS 运维、配置和脚本开发说明；不收录额外开发的客户端辅助、Python 工具或私有运行记录。事实核对只使用项目 Pascal 源码、`gameserver-tgs1000/bin` 实际程序目录、[炎黄新章游戏资料](炎黄新章游戏资料/README.md)，以及用户提供的 [云端千年神武奇章线上优化版脚本](../Script/README.md)。当前接口和加载语义以未修改的炎黄源码/随包为准；云端脚本只证明该运营版本的真实用法，其中的奖励和活动可能是定制内容。不要根据字段名猜测行为，也不要把两个版本的同名脚本默认视为相同。

## 核心指南

- [统一术语表](TERMINOLOGY.md)
- [系统架构与登录链路](architecture.md)
- [Windows 全量编译与构建日志](build.md)
- [客户端连接与通信](client-communication.md)
- [网络协议与封包结构](protocol.md)
- [数据库与 SDB 文件](database.md)
- [sv1000.Ini 运维配置](sv1000.ini.md)
- [game.ini 游戏参数](game.ini.md)
- [常量索引](constants/README.md)
- [Pascal 脚本说明](Pascal.md)、[Script.SDB 与脚本入口](Script.md)
- [事件配置](Event.md)、[任务公告](QuestNotice.md)、[ITEMLOG 福袋数据](ITEMLOG.md)
- [制造配置](manufacture.md)、[材料配置](Material.md)

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

`TGS核心源码/` 和本目录的 `deftype.pas` 是便于查阅的镜像，权威版本仍是仓库根目录下的项目源码；源码更新后必须同步镜像。`readme.chm`、`TGS2011.chm` 属于历史帮助文件，只能作为辅助线索，不能覆盖当前源码与实际配置。版本脚本的比较结论和迁移检查见 [Script 归档说明](../Script/README.md)。

原始炎黄文本使用 CP936/GBK；技术 Markdown 统一使用 UTF-8。
