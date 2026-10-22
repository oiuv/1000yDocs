# 地图传送机制总览

本页汇总炎黄新章服务端的地图入口、随机传送、多人投物传送及相关脚本、管理命令。字段和限制以当前 Pascal 实现为准；配置示例不代表某个运营服务器已经开放对应玩法。

这里的“传送门”是 TGS 游戏世界中的对象，不是转发客户端网络连接的 Gate 服务。表中的 `MapID`、`ServerId`、`TargetMapID` 用于查找地图管理器，也不等同于公网端口或独立服务器进程。

## 按需求选择机制

| 需求 | 配置或入口 | 实际作用 |
| --- | --- | --- |
| 从固定地点进入另一张地图 | [CreateGate.SDB](CreateGate.SDB.md) | 普通门 `Kind=0`；入口用 `X/Y`，落点用 `ServerId/TX/TY` |
| 多个入口位置中，只保留一个有效入口并定时换点 | [CreateGate.SDB：随机入口](CreateGate.SDB.md#随机入口位置) | `X=0,Y=0`，从 `RandomPos` 抽一个入口；随机的是门的位置，不是玩家落点 |
| 同一个入口，每次进入可能去不同地方 | [CreateGateEx.SDB：目标选择](CreateGateEx.SDB.md#目标选择) | `boRandom=true`，每次符合条件的进入请求从目标池抽一个落点 |
| 同一个入口按条件送往两个目的地 | [CreateGateEx.SDB](CreateGateEx.SDB.md) | `boCondition=true`；当前条件处理是年龄比较，不是通用表达式 |
| 投入指定物品，累计足够后多人一起进入 | [CreateGroupMove.sdb](CreateGroupMove.sdb.md) | 记录成功投物者，达到 `MoveNum` 后向仍在物件视野内的登记玩家发送传送消息 |
| 限时、限人数、战场或门派入口 | [CreateGate.SDB 的 Kind](CreateGate.SDB.md#kind)、[BattleMap.sdb](Event.md#battlemapsdb) | 各 `Kind` 有独立分支；部分依赖地图属性、战场双方配置及开放时间 |
| NPC 对话、任务或活动触发玩家传送 | [脚本传送命令](#脚本传送与门禁) | 在实际回调中检查资格、材料及目标，再使用相应移动命令 |
| 使用回城类物品 | [Item.SDB](Init_item.sdb.md) | `Kind=18`（`ITEM_KIND_TICKET`）读取物品的 `ServerId/X/Y`，不是读取传送门表 |
| 死亡复活、重新登录或地图刷新后转移 | [PosByDie.sdb](Init_PosByDie.sdb.md)、[Map.SDB](Init_map.sdb.md)、[地图生命周期](TGSWorld.md) | 属于角色与地图生命周期，不是玩家踩门或投物触发 |
| GM 定位、召回或按团队编号搬移 | [GM 管理命令](GMCommands.md#移动定位与召集) | 管理权限入口，不应当作玩家组队传送配置 |

普通门、扩展门和多人投物物件分别从 `Setting/CreateGate.SDB`、`Setting/CreateGateEx.SDB`、`Setting/CreateGroupMove.SDB` 加载；TGS 启动时分别创建对应列表。三个表的字段和对象类不能互换，也不是给普通门换一个 `Kind` 就能启用所有机制。

## 三种容易混淆的机制

### 随机入口位置

一个普通门记录可以保存最多十组候选坐标。加载时随机选一组作为实际入口；在普通门的随机位置配置下，`ActiveInterval` 到期后移除旧位置的门并重新抽取。

例如地图画面上有七座传送阵，可以只配置一个门，将七个中心坐标写入 `RandomPos`。此时只有选中的位置存在该门的触发区域，其余图案不会自行产生传送功能。

- 同一记录同一时刻只有一个实际入口，不是七个独立门轮流开关。
- 按计时重新抽取，不是每使用一次就换点；允许连续抽到同一个位置，不保证依次轮遍全部位置。
- 所有位置仍使用同一组目的地及进入条件。
- 常用配置为 `Kind=0`、`RegenInterval=0`、`ActiveInterval>0`。默认计时下 `9000` tick 约为 90 秒；不是 9000 毫秒。

候选坐标语法、计时组合和无效配置限制见 [随机入口位置](CreateGate.SDB.md#随机入口位置)。

### 随机目的地

扩展门的入口坐标固定，随机发生在玩家进入时。`RandomCount` 是候选池长度，`RandomTotal` 参与填充该池，不能把二者解释为“开启几个门”或“每轮传送几个人”。

例如 `RandomCount=5`、`RandomTotal=3` 的目标池为 `[目标0, 目标1, 目标2, 目标1, 目标2]`，不是三个目标等概率。此机制不保证一队人落到同一目的地，也没有使用普通门的 `RandomPos`。

池容量、目标字段和条件分支的注意事项见 [CreateGateEx.SDB](CreateGateEx.SDB.md)。

### 累计投物后多人传送

这类物件接收指定物品，每次成功投入一份就扣物、记录投放者姓名并增加计数。达到 `MoveNum` 时，只遍历物件当前的可见对象，向姓名匹配登记记录的玩家发送传送消息，随后清空本轮名单和计数。

“多人”不等于游戏中的正式组队系统：

- 不检查队长、队员关系或 `GroupKey`，也不会顺带传送未投物的队友。
- 同一玩家可以重复投物；阈值统计成功投放次数，不是不同玩家人数。
- 投过物品但在触发时已经离开物件视野或离线的玩家，不会被全服查找、补传或自动退款。
- 登记数组只有八项，`MoveNum` 应设为 `1..8`；源码没有对此字段做安全范围校验。

完整字段、实际采石场示例及等待期间的限制见 [CreateGroupMove.sdb](CreateGroupMove.sdb.md)。

## 脚本传送与门禁

| 接口 | 执行方式 | 需要区分的事项 |
| --- | --- | --- |
| [movespace](../print/系统控制命令/movespace.md) | 将命令放入 `Self` 的工作队列，按指定 tick 延迟执行 | 命令参数指定玩家和落点；队列持有者与被传送玩家不一定是同一对象 |
| [movespacebyname](../print/系统控制命令/movespacebyname.md) | 按名称找到对象，将命令放入该对象队列，固定延迟 1 tick | 与 `movespace` 的队列归属不同；玩家可跨图，怪物和 NPC 只在当前地图重定位 |
| [directmovespace](../print/系统控制命令/directmovespace.md) | 不进入工作队列，直接调用 `SMoveSpace` | `USER` 分支发送跨图消息；怪物、NPC 分支在当前地图查找并调用 `CallMe`，不使用地图 ID 跨图 |
| [OnMove](../function/OnMove.md) | 绑定入口脚本的移动回调 | 门禁路径只有精确返回小写 `false` 才拒绝；普通对象移动回调不保证读取返回值 |

脚本调用这些接口不等于自动执行某条 `CreateGate` 记录的年龄、物品和任务条件。入口资格应在实际回调中核对；排队、扣物、后续传送不是一项保证成功或失败退款的事务。

[gotoxy](../print/玩家操作命令/gotoxy.md) 是让脚本对象在当前地图移动，不是传送玩家；[reposition](../print/玩家操作命令/reposition.md) 是同图对向重定位，也不是跨图入口。

## 其它转移路径与边界

- **传送物品**：`ITEM_KIND_TICKET` 使用成功时消耗一份物品；当前地图为 `MAP_TYPE_DONTTICKET` 时拒绝该类物品。该属性不是“禁止所有传送”的总开关，不能据此推断脚本、GM 或普通门也被禁用。
- **战场分配**：对战、门派战和竞技场按各自分支确定阵营或出生位置，不等于投物名单式的集体传送。`BattleMap.sdb` 的双方记录和人数限制见 [事件配置](Event.md)。
- **GM 团队移动**：`@团队移动 地图标题 X Y 团队编号` 只遍历操作者当前视野内、`GroupKey` 匹配的玩家，不是按正式组队名单全服召集。
- **复活与登录**：`PosByDie.sdb` 不只参与死亡复活，还可能参与重新登录定位；登录路径和复活路径的优先级不同，不能只按表名配置。
- **地图刷新**：`Map.SDB` 的目标位置与母／子地图规则可能转出玩家；配置入口之外，还须核对刷新、死亡和重登后的去向。

## 配置与验收清单

1. 确认机制及实际加载文件；地图画面上的门、阵、楼梯不等于已经配置入口。
2. 核对源／目标地图编号、客户端 MAP 资源和服务端 SMP 通行数据；地图标题与内部编号分开处理。
3. 分别验证入口、目标落点、拒绝时弹回点；留出落地空间，避免落在障碍或另一入口触发区而往返传送。
4. 时间按相应路径的 tick 或时钟字段解释；不要把 `OpenClock`、`ActiveInterval`、`RegenInterval` 当作通用同义参数。
5. 核对成功与拒绝路径中的检查、扣物顺序。普通门和扩展门规则不同；多人投物会逐次扣除，未完成一轮不自动退款。
6. 随机入口验证候选点、重复抽取及换点；随机目的地验证每个目标与池权重；多人投物验证重复投放、有人离开和触发后清空。
7. 配置修改后按对应加载路径安排维护和验收；不要把离线表结构正确、GM 可到达或文档示例当作玩家入口已经可用。

## 源码与关联资料

- [BasicObj.pas](TGS核心源码/BasicObj.pas)：`TGateList`、`TGateObject`、`TGateListEx`、`TGateObjectEx`、`TGroupMoveList`、`TGroupMoveObject`，以及脚本移动方法。
- [SVMain.pas](TGS核心源码/SVMain.pas)：`GateList`、`GateListEx`、`GroupMoveList` 的启动创建。
- [deftype.pas](TGS核心源码/deftype.pas)：`TCreateGateData`、`TCreateGateDataEx`、`TCreateGroupMoveData`。
- [uScriptManager.pas](TGS核心源码/uScriptManager.pas)、[uSkills.pas](TGS核心源码/uSkills.pas)：脚本命令分派与 `CMD_MOVESPACE` 队列执行。
- [UUser.pas](TGS核心源码/UUser.pas)、[uUserSub.pas](TGS核心源码/uUserSub.pas)：玩家换图、GM 指令、复活／登录定位及传送物品使用。
- [Map.SDB](Init_map.sdb.md)、[SMP/SMA 地图文件](MapFiles.md)、[Script.SDB](Script.md)、[GM 管理命令](GMCommands.md)。
