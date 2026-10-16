# CreateDynamicObject%d.SDB

按地图服务器编号创建动态对象，例如箱子、可破坏机关或脚本对象。`%d` 使用 `Manager.ServerID`；以 `@CreateDynamicObject*.sdb` 命名的文件不会被这条加载路径读取。

## 数据结构

当前有效表头为：

```text
No,Name,Script,NeedAge,NeedSkill,NeedItem,GiveItem,DropItem,DropMop,CallNpc,X,Y,DropX,DropY,Width,boDelay
```

| 字段 | 类型 | 说明 |
|------|------|------|
| No | String/Integer | SDB 记录索引；加载器只用于遍历记录 |
| Name | String | 动态对象名称，必须能在 `Init/DynamicObject.sdb` 找到 |
| Script | Integer | `Script/Script.SDB` 编号；大于 0 时绑定 |
| NeedAge | Integer | 开启对象所需最低年龄 |
| NeedSkill | String | `武功名:等级`，最多 5 组 |
| NeedItem | String | `物品名:数量`，最多 5 组；验证通过后删除 |
| GiveItem | String | `物品名:数量:判定周期长度`，最多 5 组；周期小于等于 0 时按 1 登记，实际发放调用限制见下文 |
| DropItem | String | `物品名:数量:判定周期长度`，最多 5 组；周期小于等于 0 时按 1 登记 |
| DropMop | String | `怪物名:数量`，最多 5 组 |
| CallNpc | String | `NPC名:数量`，最多 5 组 |
| X / Y | String | 冒号分隔的坐标列表，各最多解析 5 个值 |
| DropX / DropY | Integer | 怪物和 NPC 的固定召唤坐标；任一为 0 时改在对象附近寻找可移动位置 |
| Width | Integer | 对象创建/作用范围 |
| boDelay | Boolean | `FALSE` 时加载后立即 `StartProcess`；`TRUE` 时只创建并加入列表，不在加载阶段启动 |

## 运行注意

- `Name` 无法在 `DynamicObject.sdb` 解析时，整条记录不会加入对象列表。
- `NeedSkill`、物品、怪物和 NPC 名称都会先回查各自当前数据表；无效名称不会形成有效运行数据。
- `GiveItem` 和 `DropItem` 的第三项会按“对象名＋物品名”登记到 `RandomClass`，不是物品间的相对权重。周期与共享计数语义见 [HaveItem 周期判定](Init_monster.sdb.md#haveitem独立周期判定)。
- `DropItem` 在对象已打开、允许移除且打开时长达到配置值的分支，通过 `GetCheckItemData` 判定；不能直接按攻击次数或每次交互次数统计周期。
- 同名对象的同名物品共用匹配键，`GiveItem`、`DropItem`、`EventDropItem` 不因字段名称不同而自动拥有独立计数。缺失登记时会记录 `Random Chance Not Found`，但当前 `GetChance` 默认返回 `true`，不是拒绝发放。
- 对象被攻击致死前会依次执行年龄、武功和物品条件；条件通过后才删除 `NeedItem`、推进对象步骤并进入 `GiveItem` 发放分支。不能据此保证物品实际发放成功。

`GiveItem` 当前存在调用限制：`CommandAttackedMagic` 和 `FieldProc` 将“对象名、物品名”依次传给 `GetChanceItemData`，而该函数要求的前两项为“物品名:颜色:数量、对象名”；调用方也没有检查返回值。不能仅凭加载阶段登记了周期，就把该字段描述为可靠的周期奖励功能。配置验证时须检查实际发放结果。

## 源码依据

- `svClass.pas` — `LoadCreateDynamicObject`
- `BasicObj.pas` — `TDynamicObjectList.ReLoadFromFile`、`TDynamicObject.CommandAttackedMagic`
- `1000ydef/deftype.pas` — `TCreateDynamicObjectData`
- 公开源码：[svClass.pas](TGS核心源码/svClass.pas) 的 `TRandomClass`、`GetCheckItemData`、`GetChanceItemData`；[BasicObj.pas](TGS核心源码/BasicObj.pas) 的 `CommandAttackedMagic`、`FieldProc`、`Update`
