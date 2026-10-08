# Zhuang.sdb

聚贤庄门派状态文件。保存占领门派、争夺队列及门票价格；当前加载器只恢复门派名称，不恢复门票价格。

## 文件路径

```
.\Init\Zhuang.SDB
```

## 文件格式

CSV 格式，逗号分隔，首行为列名。

## 字段说明

| 列名 | 类型 | 说明 | 源码依据 |
|------|------|------|----------|
| MasterGuildName | String | 占领山庄的主门派名称 | `GuildName := DB.GetFieldValueString(iName, 'MasterGuildName')` → `MasterGuild := GuildList.GetGuildObject(GuildName)` |
| SlaveGuildName | String | 争夺队列首位门派名称，战斗时作为攻击方 | `SlaveGuild[0] := GuildList.GetGuildObject(GuildName)` |
| SlaveGuildName1 | String | 争夺队列第二位门派名称 | `SlaveGuild[1] := GuildList.GetGuildObject(GuildName)` |
| SlaveGuildName2 | String | 争夺队列第三位门派名称 | `SlaveGuild[2] := GuildList.GetGuildObject(GuildName)` |
| SlaveGuildName3 | String | 争夺队列第四位门派名称 | `SlaveGuild[3] := GuildList.GetGuildObject(GuildName)` |
| TicketPrice | Integer | 保存时写出的门票价格；`LoadFromFile` 不读取此列 | `SaveToFile` / `Initialize` / `SetTicketPrice` |

### 山庄机制

- 山庄是门派争夺据点，`MasterGuild` 保存占领门派，`SlaveGuild[0..3]` 保存争夺队列
- 开战及战斗结束重置旗帜时，将 `ZhuangFlag` 生命值设为 5000000、防御设为 1000
- 旗帜生命值降至 0 后，攻击方 `SlaveGuild[0]` 接管 `MasterGuild`，后续队列前移，旗帜重置并结束战斗；不是清空占领门派
- 门票价格由占领门派的掌门设置
- 初始化时加载门派名称；析构及明确调用 `SaveToFile` 的管理入口保存文件，正常战斗状态变化分支没有即时保存调用

### 门票价格设置

占领门派的掌门（GuildSysop）可以设置门票价格。`SetTicketPrice` 将输入限制在 10000～100000；初始化先设置 50000，随后加载文件时不读取 `TicketPrice`，不能依靠修改这一列恢复自定义票价。

## 数据示例

当前配置为空（无门派占领）：
```
MasterGuildName,SlaveGuildName,SlaveGuildName1,SlaveGuildName2,SlaveGuildName3,TicketPrice
,,,,,50000
```

默认门票价格为 50000。

## 相关源码

- `uZhuang.pas` — `TZhuangObject` 类完整实现；初始化（第 153-157 行）、攻方接管（第 194-215 行）、析构保存（第 60 行）
- `uZhuang.pas` — `SaveToFile`（第 243 行）
- `uZhuang.pas` — `LoadFromFile`（第 263 行）
- `uZhuang.pas` — `SetTicketPrice/GetTicketPrice`（第 64/71 行）
- `uZhuang.pas` — `isZhuangMaster`（第 76 行）
- `uZhuang.pas` — `GetZhuangInto`（第 86 行）
- `UUser.pas` — 山庄进入/门票设置逻辑（第 7994-8015 行、第 5225-5228 行）
- `UUser.pas` — 管理入口调用 `SaveToFile`（第 6091、6100 行）
