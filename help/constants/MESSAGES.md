# 消息类型常量

> 源码: `1000ydef/deftype.pas`

本文档整理了服务间通信和场景消息的常量定义。这些常量主要用于服务端内部通信，脚本开发中一般不直接使用，但了解它们有助于理解系统架构。

---

## 包消息类型 (PACKET_*)

定义服务间通信的包类型：

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `PACKET_NONE` | 0 | 无 |
| `PACKET_GAME` | 1 | 游戏服务器包 |
| `PACKET_CLIENT` | 2 | 客户端包 |
| `PACKET_GATE` | 3 | 网关包 |
| `PACKET_DB` | 4 | 数据库包 |
| `PACKET_LOGIN` | 5 | 登录包 |
| `PACKET_PAID` | 6 | 计费包 |
| `PACKET_NOTICE` | 7 | 公告包 |

---

## 场景消息 (FM_*)

Field Message — 场景内对象间通信消息，通过 `TFieldPhone.SendMessage` 分发。

### 基础消息

| 常量名 | 值 | 中文说明 |
|--------|---:|----------|
| `FM_NONE` | 0 | 无 |
| `FM_CREATE` | 1 | 创建对象 |
| `FM_DESTROY` | 2 | 销毁对象 |
| `FM_SHOW` | 3 | 显示对象 |
| `FM_HIDE` | 4 | 隐藏对象 |
| `FM_MOVE` | 5 | 移动 |
| `FM_HIT` | 8 | 近战攻击 |
| `FM_SAY` | 9 | 说话 |
| `FM_PICKUP` | 11 | 拾取 |
| `FM_TURN` | 12 | 转向 |
| `FM_STRUCTED` | 15 | 硬直/僵直 |
| `FM_CHANGEFEATURE` | 16 | 改变外观 |
| `FM_GIVEMEADDR` | 20 | 获取地址 |
| `FM_ADDATTACKEXP` | 23 | 增加攻击经验 |
| `FM_ADDWINDOFHANDEXP` | 24 | 增加掌风经验 |
| `FM_ADDEXTRAEXP` | 25 | 增加额外经验 |
| `FM_ADDITEM` | 27 | 添加物品 |
| `FM_DELKEYITEM` | 28 | 删除关键物品 |
| `FM_ADDMONEY` | 29 | 增加金钱 |
| `FM_DELMONEY` | 30 | 减少金钱 |
| `FM_TURNDAMAGE` | 31 | 转身伤害（2003-10） |

### 战斗消息

| 常量名 | 值 | 中文说明 |
|--------|---:|----------|
| `FM_BOW` | 104 | 弓术攻击 |
| `FM_GUILDATTACK` | 109 | 门派攻击 |
| `FM_DEADHIT` | 121 | 致命攻击 |
| `FM_HEAL` | 122 | 治疗 |
| `FM_KILL` | 123 | 击杀 |
| `FM_WINDOFHAND` | 147 | 掌风攻击 |
| `FM_WINDOFHANDEFFECT` | 148 | 掌风效果 |
| `FM_CRITICAL` | 152 | 暴击（2003-10） |

### 交互消息

| 常量名 | 值 | 中文说明 |
|--------|---:|----------|
| `FM_SHOUT` | 100 | 喊叫 |
| `FM_WITHME` | 101 | 与我相关 |
| `FM_SYSOPMESSAGE` | 103 | 管理员消息 |
| `FM_CURRENTUSER` | 105 | 当前用户 |
| `FM_SOUND` | 106 | 音效 |
| `FM_CLICK` | 107 | 点击 |
| `FM_SAYUSEMAGIC` | 108 | 使用武功说话 |
| `FM_GATE` | 110 | 传送门 |
| `FM_ENOUGHSPACE` | 111 | 空间足够 |
| `FM_CANCELEXCHANGE` | 114 | 取消交换 |
| `FM_SHOWEXCHANGE` | 115 | 显示交换 |
| `FM_REFILL` | 116 | 恢复 |
| `FM_DBLCLICK` | 117 | 双击 |
| `FM_CHANGEPROPERTY` | 118 | 改变属性 |
| `FM_CHECKGUILDUSER` | 120 | 检查门派成员 |
| `FM_LIFEPERCENT` | 124 | 生命百分比 |
| `FM_IAMHERE` | 125 | 我在这里 |
| `FM_ADDALLYGUILD` | 126 | 添加同盟门派 |
| `FM_DELALLYGUILD` | 127 | 删除同盟门派 |
| `FM_AGREEALLYGUILD` | 128 | 同意同盟门派 |
| `FM_SELFSAY` | 129 | 自己说话 |
| `FM_SPELL` | 130 | 法术 |
| `FM_ADDVIRTUEEXP` | 131 | 增加道德经验 |
| `FM_APPROACH` | 132 | 接近 |
| `FM_AWAY` | 133 | 离开 |
| `FM_ZONEEFFECT` | 134 | 区域效果 |
| `FM_CHANGESTATE` | 135 | 改变状态 |
| `FM_CHANGESTEP` | 136 | 改变步骤 |
| `FM_AFTERCREATE` | 137 | 创建后 |
| `FM_BEFOREDESTROY` | 138 | 销毁前 |
| `FM_PICK` | 139 | 采集 |
| `FM_ADDHERBAMOUNT` | 140 | 增加药草数量 |
| `FM_ADDMINEAMOUNT` | 141 | 增加矿产数量 |
| `FM_DECDEPOSIT` | 142 | 减少存款 |
| `FM_REPOSITION` | 143 | 重新定位 |
| `FM_BACKMOVE` | 144 | 后退移动 |
| `FM_SAYSYSTEM` | 145 | 系统说话 |
| `FM_CHANGEDURAWATERCASE` | 146 | 改变水桶耐久 |
| `FM_SETPOSITION` | 149 | 设置位置 |
| `FM_FILLLIFE` | 150 | 恢复活力（新手村药水池） |
| `FM_SETEFFECT` | 151 | 设置效果（2003-10） |
| `FM_ADDLIFEORENERGY` | 153 | 增加活力或元气（2003-10） |
| `FM_ADDMINEREXP` | 154 | 增加矿工经验 |

### 特殊消息

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `FM_STRING` | 253 | 字符串消息 |
| `FM_REBOOT` | 254 | 重启消息 |
| `FM_GOTOXY` | 73 | 传送到坐标 |
| `FM_MOTION` | 74 | 动作 |
| `FM_DELITEM` | 75 | 删除物品 |
| `FM_GATHERVASSAL` | 76 | 聚集仆从 |
| `FM_SOUNDBASE` | 64 | 基础音效 |
| `FM_ADDPROTECTEXP` | 102 | 增加护身经验 |
| `FM_ALLOWGUILDNAME` | 112 | 允许门派名 |
| `FM_ALLOWGUILDSYSOPNAME` | 113 | 允许门派管理员名 |
| `FM_REMOVEGUILDMEMBER` | 119 | 移除门派成员 |
| `FM_ADDALLYGUILD` | 126 | 添加同盟 |

---

## 服务端消息 (SM_*)

Server Message — 服务端发送给客户端的消息。

### 系统消息

| 常量名 | 值 | 中文说明 |
|--------|---:|----------|
| `SM_NONE` | 0 | 无 |
| `SM_WINDOW` | 1 | 窗口消息 |
| `SM_MESSAGE` | 2 | 消息 |
| `SM_CHARINFO` | 3 | 角色信息 |
| `SM_CHATMESSAGE` | 4 | 聊天消息 |
| `SM_SETCLIENTCONDITION` | 2 | 设置客户端条件 |
| `SM_MSGANDCLOSE` | 252 | 消息并关闭 |
| `SM_CONNECTTHRU` | 253 | 连接穿透（Balance返回Gate地址） |
| `SM_RECONNECT` | 254 | 重连 |
| `SM_CLOSE` | 255 | 关闭 |
| `SM_CHECK` | 52 | 检查 |

### 角色属性消息

| 常量名 | 值 | 中文说明 |
|--------|---:|----------|
| `SM_ATTRIBBASE` | 5 | 基础属性 |
| `SM_HAVEITEM` | 6 | 持有物品 |
| `SM_HAVEMAGIC` | 7 | 持有武功 |
| `SM_WEARITEM` | 8 | 穿戴物品 |
| `SM_ATTRIB_VALUES` | 23 | 属性值 |
| `SM_ATTRIB_FIGHTBASIC` | 24 | 战斗基础属性 |
| `SM_ATTRIB_LIFE` | 25 | 活力属性 |
| `SM_EXTRAATTRIB_VALUES` | 87 | 额外属性值 |
| `SM_ABILITYATTRIB` | 96 | 角色能力属性 |

### 场景消息

| 常量名 | 值 | 中文说明 |
|--------|---:|----------|
| `SM_NEWMAP` | 9 | 新地图 |
| `SM_SHOW` | 10 | 显示 |
| `SM_HIDE` | 11 | 隐藏 |
| `SM_SAY` | 12 | 说话 |
| `SM_MOVE` | 13 | 移动 |
| `SM_TURN` | 15 | 转向 |
| `SM_SETPOSITION` | 16 | 设置位置 |
| `SM_CHANGEFEATURE` | 18 | 改变外观 |
| `SM_MAGIC` | 19 | 武功 |
| `SM_MOTION` | 22 | 动作 |
| `SM_STRUCTED` | 27 | 硬直 |
| `SM_SHOWITEM` | 28 | 显示物品 |
| `SM_SHOWMONSTER` | 29 | 显示怪物 |
| `SM_HIDEITEM` | 30 | 隐藏物品 |
| `SM_HIDEMONSTER` | 31 | 隐藏怪物 |
| `SM_SHOWDYNAMICOBJECT` | 47 | 显示动态对象 |
| `SM_HIDEDYNAMICOBJECT` | 48 | 隐藏动态对象 |
| `SM_CHANGESTATE` | 49 | 改变状态 |

### 武功消息

| 常量名 | 值 | 中文说明 |
|--------|---:|----------|
| `SM_USEDMAGICSTRING` | 32 | 使用武功字符串 |
| `SM_MOVINGMAGIC` | 33 | 飞行武功 |
| `SM_BASICMAGIC` | 34 | 基础武功 |
| `SM_SAYUSEMAGIC` | 36 | 使用武功说话 |
| `SM_BOSHIFTATTACK` | 37 | BOSS偏移攻击 |
| `SM_HAVERISEMAGIC` | 61 | 持有上层武功 |
| `SM_HAVEMYSTERY` | 76 | 持有掌法 |
| `SM_HAVEBESTMAGIC` | 86 | 持有绝世武功 |
| `SM_SHOWBESTATTACKMAGICWINDOW` | 88 | 显示绝世必杀窗口 |
| `SM_SHOWBESTPROTECTMAGICWINDOW` | 89 | 显示绝世公力窗口 |
| `SM_SHOWBESTSPECIALMAGICWINDOW` | 90 | 显示绝世超式窗口 |

### 窗口消息

| 常量名 | 值 | 中文说明 |
|--------|---:|----------|
| `SM_SHOWSPECIALWINDOW` | 50 | 显示特殊窗口 |
| `SM_HIDESPECIALWINDOW` | 55 | 隐藏特殊窗口 |
| `SM_SHOWINPUTSTRING` | 42 | 显示输入字符串窗口 |
| `SM_HIDEEXCHANGE` | 43 | 隐藏交换窗口 |
| `SM_SHOWEXCHANGE` | 44 | 显示交换窗口 |
| `SM_SHOWCOUNT` | 45 | 显示数量窗口 |
| `SM_SHOWTOPMSG` | 58 | 显示顶部消息 |
| `SM_SHOWCENTERMSG` | 54 | 显示中央消息 |
| `SM_SHOWBATTLEBAR` | 53 | 显示对战血条 |
| `SM_SHOWEVENTINPUT` | 94 | 显示事件输入窗口 |
| `SM_SHOWEVENTMSG` | 95 | 显示事件消息 |
| `SM_STARTHELPWINDOW` | 63 | 启动帮助窗口 |
| `SM_ITEMHELPWINDOW` | 64 | 物品帮助窗口 |
| `SM_ITEMHELPWINDOW2` | 73 | 物品帮助窗口2 |
| `SM_ITEMHELPWINDOW3` | 97 | 物品帮助窗口3 |

### 交易/商店消息

| 常量名 | 值 | 中文说明 |
|--------|---:|----------|
| `SM_TRADEWINDOW` | 65 | 交易窗口 |
| `SM_SHOWTRADEWINDOW` | 66 | 显示交易窗口 |
| `SM_SETTRADEITEM` | 67 | 设置交易物品 |
| `SM_SHOWSALEWINDOW` | 71 | 显示商店窗口 |
| `SM_SETSALEITEM` | 72 | 设置商店物品 |
| `SM_MARKETWINDOW` | 77 | 个人销售窗口 |
| `SM_MARKETITEM` | 78 | 个人销售物品 |
| `SM_SHOWMARKETCOUNT` | 79 | 个人销售数量窗口 |
| `SM_SHOWINDIVIDUALMARKETWINDOW` | 80 | 个人购买窗口 |
| `SM_CONFIRMMARKET` | 81 | 确认交易 |
| `SM_SSAMZIEITEM` | 51 | 三三物品 |
| `SM_GUILDITEM` | 103 | 门派物品 |

### 门派消息

| 常量名 | 值 | 中文说明 |
|--------|---:|----------|
| `SM_INPUTGUILDNAMEWINDOW` | 104 | 输入门派名窗口 |
| `SM_GUILDINFOWINDOW` | 105 | 门派信息窗口 |
| `SM_GUILDMONEYCHIPWINDOW` | 106 | 门派银票窗口 |
| `SM_GUILDMONEYAPPLYWINDOW` | 107 | 门派银票申请窗口 |
| `SM_GUILDINFO` | 108 | 门派信息 |
| `SM_GUILDENERGY` | 109 | 门派能量 |
| `SM_GUILDSUBSYSOP` | 200 | 门派副管理员 |
| `SM_GUILDANSWERWINDOW` | 203 | 门派回复窗口 |

### 其他消息

| 常量名 | 值 | 中文说明 |
|--------|---:|----------|
| `SM_SOUNDSTRING` | 35 | 音效字符串 |
| `SM_SOUNDBASE` | 21 | 基础音效 |
| `SM_SOUNDBASESTRING` | 39 | 基础音效字符串 |
| `SM_SOUNDBASESTRING2` | 40 | 基础音效字符串2 |
| `SM_SOUNDEFFECT` | 41 | 音效效果 |
| `SM_RAINNING` | 38 | 下雨 |
| `SM_EVENTSTRING` | 26 | 事件字符串 |
| `SM_MINIMAP` | 57 | 小地图 |
| `SM_SETSHORTCUT` | 59 | 设置快捷键 |
| `SM_PASSWORD` | 60 | 密码（包裹密码/物品密码） |
| `SM_SETPOWERLEVEL` | 62 | 设置元气等级 |
| `SM_SKILLWINDOW` | 68 | 技术窗口 |
| `SM_JOBRESULT` | 69 | 职业结果 |
| `SM_MATERIALITEM` | 70 | 材料物品 |
| `SM_BACKMOVE` | 74 | 后退移动 |
| `SM_SYSTEMINFO` | 75 | 系统信息 |
| `SM_TIME` | 82 | 时间 |
| `SM_MESSENGER` | 83 | 消息（03.03.03） |
| `SM_SIDEMESSAGE` | 84 | 侧面消息（聊天分离 03.02.24） |
| `SM_BATTLEINFO` | 85 | 对战信息（排名 03.06.23） |
| `SM_SETEFFECT` | 91 | 设置效果（2003-10） |
| `SM_SETACTIONSTATE` | 92 | 设置动作状态（2003-10） |
| `SM_SCREENEFFECT` | 93 | 屏幕效果（2003-10） |
| `SM_ISINVITETEAM` | 98 | 是否邀请组队 |
| `SM_TEAMMEMBERLIST` | 99 | 队伍成员列表 |
| `SM_MARRYWINDOW` | 100 | 结婚窗口 |
| `SM_MARRYANSWERWINDOW` | 101 | 结婚回复窗口 |
| `SM_UNMARRY` | 102 | 离婚 |
| `SM_ARENAWINDOW` | 201 | 竞技场窗口 |
| `SM_ARENAJOINWINDOW` | 202 | 竞技场加入窗口 |
| `SM_NETSTATE` | 56 | 网络状态 |
| `SM_CHARMOVEFRONTDIEFLAG` | 255 | 角色可穿过死亡玩家标记 |

---

## 客户端消息 (CM_*)

Client Message — 客户端发送给服务端的消息。

| 常量名 | 值 | 中文说明 |
|--------|---:|----------|
| `CM_NONE` | 0 | 无 |
| `CM_CLOSE` | 1 | 关闭 |
| `CM_VERSION` | 2 | 版本 |
| `CM_IDPASS` | 3 | 账号密码 |
| `CM_CREATEIDPASS` | 4 | 创建账号 |
| `CM_CHANGEPASSWORD` | 5 | 修改密码 |
| `CM_CREATECHAR` | 6 | 创建角色 |
| `CM_DELETECHAR` | 7 | 删除角色 |
| `CM_SELECTCHAR` | 8 | 选择角色 |
| `CM_SOUND` | 9 | 音效 |
| `CM_TURN` | 10 | 转向 |
| `CM_MOVE` | 11 | 移动 |
| `CM_SAY` | 12 | 说话 |
| `CM_HIT` | 13 | 攻击 |
| `CM_PICKUP` | 14 | 拾取 |
| `CM_KEYDOWN` | 19 | 按键 |
| `CM_CLICK` | 20 | 点击 |
| `CM_DBLCLICK` | 21 | 双击 |
| `CM_DRAGDROP` | 22 | 拖放 |
| `CM_CLICKPERCENT` | 23 | 点击百分比 |
| `CM_CREATEIDPASS2` | 24 | 创建账号2 |
| `CM_IDPASSAZACOM` | 25 | AZACOM账号 |
| `CM_INPUTSTRING` | 26 | 输入字符串 |
| `CM_SELECTCOUNT` | 27 | 选择数量 |
| `CM_CANCELEXCHANGE` | 28 | 取消交换 |
| `CM_MOUSEEVENT` | 29 | 鼠标事件 |
| `CM_WINDOWCONFIRM` | 30 | 窗口确认 |
| `CM_CHECK` | 31 | 检查 |
| `CM_MAKEGUILDDATA` | 32 | 创建门派数据 |
| `CM_GUILDINFODATA` | 33 | 门派信息数据 |
| `CM_AGREEDATA` | 34 | 确认数据 |
| `CM_MAKEGUILDMAGIC` | 35 | 创建门派武功 |
| `CM_NETSTATE` | 36 | 网络状态 |
| `CM_CREATEIDPASS3` | 37 | 创建账号3 |
| `CM_MINIMAP` | 38 | 小地图 |
| `CM_SETSHORTCUT` | 39 | 设置快捷键 |
| `CM_PASSWORD` | 40 | 密码 |
| `CM_SELECTHELPWINDOW` | 41 | 选择帮助窗口 |
| `CM_SELECTITEMWINDOW` | 42 | 选择物品窗口 |
| `CM_TRADEWINDOW` | 43 | 交易窗口 |
| `CM_SKILLWINDOW` | 44 | 技术窗口 |
| `CM_MAKEITEM` | 45 | 制造物品 |
| `CM_PROCESSITEM` | 46 | 加工物品 |
| `CM_SYSTEMINFO` | 47 | 系统信息 |
| `CM_CONFIRMMARKET` | 48 | 确认交易 |
| `CM_SELECTMARKETCOUNT` | 49 | 选择交易数量 |
| `CM_GETTIME` | 50 | 获取时间 |
| `CM_BATTLECONFIRM` | 51 | 对战确认 |
| `CM_BATTLEINFO` | 52 | 对战信息 |
| `CM_ADDSTATEPOINT` | 53 | 增加状态点（2003-10） |
| `CM_EVENTINPUT` | 54 | 事件输入 |
| `CM_SETMATERIAL` | 55 | 设置材料 |
| `CM_ITEMBUTTON` | 56 | 物品按钮 |
| `CM_LOCKITEM` | 57 | 锁定物品 |
| `CM_UNLOCKITEM` | 58 | 解锁物品 |
| `CM_COMFIRMINVITATION` | 59 | 确认邀请 |
| `CM_TEAMMEMBERLIST` | 60 | 队伍成员列表 |
| `CM_IPADDR` | 251 | IP地址 |

---

## NPC功能类型 (NPCFT_*)

定义 NPC 的功能类型：

| 常量名 | 值 | 中文说明 |
|--------|---:|----------|
| `NPCFT_NONE` | 0 | 无 |
| `NPCFT_SELL` | 1 | 出售 |
| `NPCFT_BUY` | 2 | 购买 |
| `NPCFT_DEAL` | 3 | 交易 |
| `NPCFT_SAY` | 4 | 对话 |
| `NPCFT_HELP` | 5 | 帮助 |
| `NPCFT_QUEST` | 6 | 任务 |
| `NPCFT_GUILDWAR` | 7 | 门派大战 |

---

## 说话颜色 (SAY_COLOR_*)

| 常量名 | 值 | 中文说明 |
|--------|---:|----------|
| `SAY_COLOR_NORMAL` | 0 | 普通说话 |
| `SAY_COLOR_SHOUT` | 1 | 喊叫 |
| `SAY_COLOR_SYSTEM` | 2 | 系统消息 |
| `SAY_COLOR_NOTICE` | 3 | 公告 |
| `SAY_COLOR_TEAM` | 4 | 队伍消息 |
| `SAY_COLOR_GRADE0` | 10 | 等级0颜色 |
| `SAY_COLOR_GRADE1` | 11 | 等级1颜色 |
| `SAY_COLOR_GRADE2` | 12 | 等级2颜色 |
| `SAY_COLOR_GRADE3` | 13 | 等级3颜色 |
| `SAY_COLOR_GRADE4` | 14 | 等级4颜色 |
| `SAY_COLOR_GRADE5` | 15 | 等级5颜色 |

---

## 动作消息 (AM_*)

Action Message — 定义角色/怪物的动作类型。

| 常量名 | 值 | 中文说明 |
|--------|---:|----------|
| `AM_NONE` | 0 | 无 |
| `AM_DIE` | 1 | 死亡 |
| `AM_STRUCTED` | 2 | 硬直 |
| `AM_SEATDOWN` | 3 | 坐下 |
| `AM_STANDUP` | 4 | 站起 |
| `AM_HELLO` | 5 | 打招呼 |
| `AM_MOTION` | 6 | 动作 |
| `AM_TURN` ~ `AM_TURN9` | 10-19 | 转向动作状态序列 |
| `AM_MOVE` ~ `AM_MOVE9` | 20-29 | 移动动作状态序列 |
| `AM_HIT` ~ `AM_HIT9` | 30-39 | 攻击动作状态序列 |
| `AM_TURNNING` ~ `AM_TURNNING9` | 40-49 | 旋转动作状态序列 |
| `AM_HIT10` | 50 | 第10段攻击 |
| `AM_HIT10_READY` | 51 | 第10段攻击准备 |
| `AM_HIT11` | 52 | 第11段攻击 |
| `AM_HIT11_READY` | 53 | 第11段攻击准备 |

这些常量表示动作状态，不表示方向数量；方向由独立的 `Dir` 字段传递，常规移动和转向使用 `0..7` 八方向。

---

## 相关文档

- [README.md](README.md) — 常量定义总览
- [WINDOW.md](WINDOW.md) — 窗口类型常量
