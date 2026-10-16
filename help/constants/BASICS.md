# 游戏基础常量

> 源码: `1000ydef/deftype.pas`

本文档整理了游戏中的基础容量、尺寸、版本等常量。

---

## 版本信息

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `PROGRAM_VERSION` | 40 | 公开源码基线的通信版本，不是 EXE 文件版本或线上部署证明 |

## 国家版本 (NATION_*)

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `NATION_KOREA` | 1 | 韩国 |
| `NATION_TAIWAN` | 2 | 台湾 |
| `NATION_CHINA_1` | 3 | 中国大陆 |
| `NATION_TAIWAN_TEST` | 4 | 台湾测试 |
| `NATION_CHINA_1_TEST` | 5 | 中国测试 |
| `NATION_KOREA_TEST` | 6 | 韩国测试 |

通过条件编译 `_CHINA` / `_TAIWAN` 确定 `NATION_VERSION`。

---

## 容量限制

### 背包与物品

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `HAVEITEMSIZE` | 30 | 背包物品格数 |
| `HAVEMATERIALITEMSIZE` | 5 | 技术窗物品数组容量：4 格材料和 1 格加工物品/产物，不能全部用于放料 |
| `HAVEMARKETITEMSIZE` | 10 | 个人商店栏格数 |
| `MONEYMAX` | 61000 | 保留常量；当前客户端与 TGS 未检出引用，不能作为实际金钱上限 |

### 武功容量

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `HAVEBASICMAGICSIZE` | 20 | 基本武功最大数量 |
| `HAVEMAGICSIZE` | 30 | 普通武功最大数量 |
| `HAVERISEMAGICSIZE` | 30 | 上层武功最大数量 |
| `HAVEMYSTERYMAGICSIZE` | 30 | 掌法武功最大数量 |
| `HAVEBESTSPECIALMAGICSIZE` | 15 | 招式武功最大数量 |
| `HAVEBESTPROTECTMAGICSIZE` | 5 | 神功（绝世护体）最大数量 |
| `HAVEBESTATTACKMAGICSIZE` | 5 | 绝世攻击武功最大数量 |
| `TOTALBESTMAGICNUM` | 25 | 绝世武功总数上限 |

### 视野与地图

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `VIEWRANGEWIDTH` | 10 | 视野横向半径（格） |
| `VIEWRANGEHEIGHT` | 8 | 视野纵向半径（格） |

公开原版的 `TBasicObject.isRange` 按 `x±10`、`y±8` 判断，包含边界，完整矩形为 21×17 格，并非 10×8 格。`OnApproach` / `OnAway` 使用另一套 `x±2`、`y±2` 的近身判断。依据：[BasicObj.pas](../TGS核心源码/BasicObj.pas) 的 `isRange`、`isApproach`；运行关系见 [地图、视野与对象生命周期](../TGSWorld.md)。

### 名称长度

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `NAME_SIZE` | 19 | `TNameString` 的字节容量；零结尾字符串需留 1 字节，最多容纳 18 字节文本（如 9 个 GBK 双字节汉字） |
| `CAPTION_SIZE` | 40 | `TCaptionString` 的字节容量；零结尾字符串需留 1 字节，不能等同于允许输入 20 个汉字 |

---

## 游戏参数

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `DEFAULTEXP` | 10000 | 事件获得的基本经验值 |
| `OBJECTUPDATETICK` | 20 | 怪物/NPC 更新的最小 TICK 间隔 |
| `BOSSVIRTUEVALUE` | 10000 | 怪物 `VirtueValue` 的 BOSS 判定阈值，用于部分 AI 分支 |
| `STARTNEWID` | 10000 | 新 ID 起始值 |
| `USERMANAGERPOST` | 1000 | 用户管理器端口偏移 |
| `FIELDPOST` | 100 | 场景端口偏移 |
| `MAXCONDITIONCOUNT` | 3 | 最大条件计数 |
| `SAVE_USERDATA_DELAY_TIME` | 30000 | 用户数据保存延迟（5×60×100 = 5分钟，单位10ms） |

---

## 场景消息路由标识

`TFieldPhone.SendMessage` 使用这些值选择接收对象，是服务端内部消息路由，不是玩家电话或邮件功能。

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `NOTARGETPHONE` | 0 | 无指定目标；向发送者及周边分区中的对象分发，再由接收者检查范围和状态 |
| `MANAGERPHONE` | 1 | 转交 `ManagerList.FieldProc` 处理 |

---

## 效果开关

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `EFFECT_OFF` | 0 | 效果关闭 |
| `EFFECT_ON` | 1 | 效果开启 |

## 战斗效果类型

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `BTEFFECT_KIND_NONE` | 0 | 无战斗效果 |
| `BTEFFECT_KIND_DECLIFE` | 1 | 减少活力的区域效果 |

---

## 事件类型 (EVENTKIND_*)

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `EVENTKIND_NONE` | 0 | 无事件 |
| `EVENTKIND_DIE_DYNOBJ` | 1 | 动态对象死亡事件 |
| `EVENTKIND_DIE_MOP` | 2 | 怪物死亡事件 |

---

## 默认武功索引 (DEFAULT_*)

| 常量名 | 值 | 中文说明 |
|--------|---:|----------|
| `DEFAULT_WRESTLING` | 0 | 拳法 |
| `DEFAULT_FENCING` | 1 | 剑法 |
| `DEFAULT_SWORDSHIP` | 2 | 刀法 |
| `DEFAULT_HAMMERING` | 3 | 槌法 |
| `DEFAULT_SPEARING` | 4 | 枪法 |
| `DEFAULT_BOWING` | 5 | 弓术 |
| `DEFAULT_THROWING` | 6 | 投法 |
| `DEFAULT_RUNNING` | 7 | 步法（轻功） |
| `DEFAULT_BREATHNG` | 8 | 心法 |
| `DEFAULT_PROTECTING` | 9 | 护体 |

---

## 武功秘籍图标

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `MAGIC_BOOK_ICON` | 53 | 武功秘籍图标编号 |

---

## 关闭原因 (RET_CLOSE_*)

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `RET_CLOSE_NONE` | 0 | 无 |
| `RET_CLOSE_RUNNING` | 1 | 步法关闭 |
| `RET_CLOSE_BREATHNG` | 2 | 心法关闭 |
| `RET_CLOSE_ATTACK` | 3 | 攻击关闭 |
| `RET_CLOSE_PROTECTING` | 4 | 护体关闭 |
| `RET_CLOSE_BESTSPECIAL` | 5 | 招式武功关闭 |
| `RET_CLOSE_ECTMAGIC` | 6 | 其他武功关闭 |
| `RET_CLOSE_BESTPROTECT` | 7 | 神功关闭 |

---

## 选择武功结果 (SELECTMAGIC_RESULT_*)

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `SELECTMAGIC_RESULT_FALSE` | -1 | 失败 |
| `SELECTMAGIC_RESULT_NONE` | 0 | 无 |
| `SELECTMAGIC_RESULT_NORMAL` | 1 | 正常 |
| `SELECTMAGIC_RESULT_SITDOWN` | 2 | 坐下 |
| `SELECTMAGIC_RESULT_RUNNING` | 3 | 跑步中 |

---

## 拖放动作 (DRAGACTION_*)

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `DRAGACTION_NONE` | 0 | 无 |
| `DRAGACTION_ADDEXCHANGEITEM` | 15 | 添加到交换 |
| `DRAGACTION_DROPITEM` | 2 | 丢弃物品 |
| `DRAGACTION_FROMITEMTOLOG` | 16 | 背包→福袋 |
| `DRAGACTION_FROMLOGTOITEM` | 17 | 福袋→背包 |
| `DRAGACTION_FROMITEMTOTRADE` | 18 | 物品→交易 |
| `DRAGACTION_FROMTRADETOITEM` | 19 | 交易→物品 |
| `DRAGACTION_FROMITEMTOSKILL` | 20 | 物品→制造 |
| `DRAGACTION_FROMSKILLTOITEM` | 21 | 制造→物品 |
| `DRAGACTION_FROMITEMTOSALE` | 22 | 物品→商店 |
| `DRAGACTION_FROMSALETOITEM` | 23 | 商店→物品 |
| `DRAGACTION_SMELTITEM` | 24 | 冶炼物品 |
| `DRAGACTION_SMELTITEM2` | 25 | 冶炼交换 |
| `DRAGACTION_FROMINDIVIDUALMARKETTOITEM` | 26 | 个人购买→物品 |
| `DRAGACTION_FROMGUILDTOITEM` | 27 | 门派→物品 |
| `DRAGACTION_FROMITEMTOGUILD` | 28 | 物品→门派 |

---

## 挂起状态 (HANGON_*)

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `HANGON_NONE` | 0 | 无挂起 |

---

## 结果码

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `INTRESULT_FALSE` | -1 | 整数结果-假 |
| `INTRESULT_ARREADY` | -2 | 已存在 |
| `PROC_TRUE` | 0 | 过程-成功 |
| `PROC_FALSE` | -1 | 过程-失败 |
| `PROC_ARREAY` | -2 | 过程-已存在 |
| `PROC_DONTDROP` | -3 | 过程-禁止丢弃（门派初石不能扔地上） |
| `UPDATE_TRUE` | 0 | 更新-成功 |
| `UPDATE_FALSE` | -1 | 更新-失败 |

---

## 相关文档

- [README.md](README.md) — 常量定义总览
- [TERMINOLOGY.md](../TERMINOLOGY.md) — 玩家可见术语
- [地图、视野与对象生命周期](../TGSWorld.md) — 场景消息分发与接收对象的范围检查
- [uUserSub.pas](../TGS核心源码/uUserSub.pas) — `DRAGACTION_FROMITEMTOLOG`、`DRAGACTION_FROMLOGTOITEM` 的福袋物品移动分支
