# 窗口类型常量 (WINDOW_*)

> 源码: `1000ydef/deftype.pas` 第 960-1020 行

定义客户端 UI 窗口编号，供相应客户端/服务端消息使用；这些编号不是脚本 `showwindow` 的类型参数。

---

## 常量列表

| 常量名 | 值 | 中文说明 | 详细说明 |
|--------|---:|----------|----------|
| `WINDOW_NONE` | 0 | 无 | 关闭窗口 |
| `WINDOW_ITEMS` | 1 | 物品栏 | 背包物品窗口 |
| `WINDOW_WEARS` | 2 | 装备栏 | 穿戴装备窗口 |
| `WINDOW_SCREEN` | 3 | 屏幕 | 主游戏画面 |
| `WINDOW_BASICFIGHT` | 4 | 基础武功 | 基础武功窗口 |
| `WINDOW_MAGICS` | 5 | 武功 | 已学武功窗口 |
| `WINDOW_EXCHANGE` | 6 | 交换 | 玩家间物品交换窗口 |
| `WINDOW_SSAMZIEITEM` | 7 | 三三物品 | 特殊物品窗口 |
| `WINDOW_ALERT` | 8 | 警告 | 弹窗警告 |
| `WINDOW_AGREE` | 9 | 确认 | 确认对话框 |
| `WINDOW_GUILDMAKE` | 10 | 创建门派 | 创建门派窗口 |
| `WINDOW_GUILDINFO` | 11 | 门派信息 | 门派信息查看窗口 |
| `WINDOW_GUILDWAR1` | 12 | 门派战1 | 门派大战窗口1 |
| `WINDOW_GUILDWAR2` | 13 | 门派战2 | 门派大战窗口2 |
| `WINDOW_GUILDMAGIC` | 14 | 门派武功 | 门派武功窗口 |
| `WINDOW_RISEMAGICS` | 15 | 上层武功 | 上层武功窗口 |
| `WINDOW_POWERLEVEL` | 16 | 元气等级 | 元气阶段窗口 |
| `WINDOW_HELP` | 17 | 帮助 | F1帮助/任务窗口 |
| `WINDOW_TRADE` | 18 | 买卖 | NPC 交易窗口 |
| `WINDOW_SKILL` | 19 | 技术 | 制造/加工技能窗口 |
| `WINDOW_GROUPWINDOW` | 20 | 组队 | 组队窗口（对战服务器用） |
| `WINDOW_ROOMWINDOW` | 21 | 房间 | 房间窗口（对战服务器用） |
| `WINDOW_GRADEWINDOW` | 22 | 品级 | 品级窗口（对战服务器用） |
| `WINDOW_SALE` | 23 | 商店买卖 | NPC 商店买卖窗口 |
| `WINDOW_MYSTERYMAGICS` | 24 | 掌法 | 掌法窗口（2002-11-07） |
| `WINDOW_MARKET` | 25 | 个人销售 | 玩家摆摊销售窗口 |
| `WINDOW_INDIVIDUALMARKET` | 26 | 个人购买 | 购买其他玩家摆摊物品窗口 |
| `WINDOW_BESTMAGIC` | 28 | 绝世武功 | 绝世武功窗口 |
| `WINDOW_SHORTCUT` | 29 | 快捷栏 | 快捷技能栏窗口 |
| `WINDOW_CONFIRM` | 30 | 确认 | 确认对话框（2004-12-12） |
| `WINDOW_TEAMMEMBERLIST` | 31 | 队伍列表 | 队伍成员列表窗口 |
| `WINDOW_GUILDITEMLOG` | 32 | 门派仓库 | 历史常量名含 `ITEMLOG`；实际用于门派共享物品窗口 |

---

## 警告类型 (ALERT_*)

配合 `WINDOW_ALERT` 使用：

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `ALERT_NONE` | 0 | 无 |
| `ALERT_MESSAGE` | 1 | 消息 |
| `ALERT_INFORMATION` | 2 | 信息 |
| `ALERT_GAMEAGREE` | 3 | 游戏确认 |

---

## 确认类型 (AGREE_*)

配合 `WINDOW_AGREE` 使用：

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `AGREE_NONE` | 0 | 无 |
| `AGREE_ALLYGUILD` | 1 | 门派同盟 |
| `AGREE_GUILDMAKE` | 0 | 创建门派 |
| `AGREE_INVITATION` | 0 | 邀请确认 |
| `DISAGREE_INVITATION` | 1 | 拒绝邀请 |

---

## 脚本中使用

`showwindow` 接收一个命令字符串，格式为 `showwindow 文件路径 类型`。`类型=0` 走帮助窗口分支，非 `0` 走交易窗口分支；不能把 `WINDOW_TRADE=18` 等常量直接当作打开窗口的脚本命令。NPC 买卖窗口另见 [tradewindow](../../print/物品交易命令/tradewindow.md)。

```pascal
// 当前炎黄bin/Script/龙师父.txt中的帮助文件调用
print('showwindow .\help\龙师父.txt 1');
```

---

## 相关文档

- [print/系统命令/showwindow.md](../../print/系统命令/showwindow.md) — showwindow 命令文档
