# PosByDie.sdb

地图重定位配置文件，定义特定地图的目标地图和坐标。除死亡后的定点复活外，角色重新登录时也可能使用本表。

## 文件路径

```
.\Init\PosByDie.SDB
```

## 文件格式

CSV 格式，逗号分隔，首行为列名。

## 字段说明

| 列名 | 类型 | 说明 | 源码依据 |
|------|------|------|----------|
| Name | Integer | 记录编号 | 行索引 |
| Server | Integer | 源地图（服务器）ID | `pd^.rServerID := StrDB.GetFieldValueInteger(iName, 'Server')` |
| DestServer | Integer | 目标地图（服务器）ID | `pd^.rDestServerID := StrDB.GetFieldValueInteger(iName, 'DestServer')` |
| DestX | Integer | 目标 X 坐标 | `pd^.rDestX := StrDB.GetFieldValueInteger(iName, 'DestX')` |
| DestY | Integer | 目标 Y 坐标 | `pd^.rDestY := StrDB.GetFieldValueInteger(iName, 'DestY')` |
| Notice | String | 随包参考备注，实际文件包含 GBK 中文；不是已确认会发送的死亡提示 | 当前加载器不读取此列 |

## 使用场景与优先级

### 死亡后的复活

`TUserObject.Update` 在角色处于死亡状态、且超过 `DiedTick + 3000` 后处理复活；默认 tick 下约为 30 秒。分支依次为：

1. 门派大战或竞技场地图，使用战场提供的复活位置。
2. 普通地图的 `boPosDie=true` 时，调用 `PosByDieClass.GetPosByDieData` 查本表并设置位置。
3. 其他情况在原位置复活；原格不可走时尝试寻找附近可走格。

因此，仅在本表新增一行，并不代表该地图所有死亡角色都会立即传送。还需核对 [Map.SDB](Init_map.sdb.md) 的地图属性和 `boPosDie`。

### 重新登录

`TUserList.InitialLayer` 也用本表修正登录位置，**不要求角色处于死亡状态，也不检查 `boPosDie`**。处理完监狱特殊路径后，普通角色按以下优先级选择位置：

1. `LoginX`、`LoginY` 均非零：使用配置的登录地图和坐标。
2. `RegenInterval > 0`：使用地图的 `TargetServerID/TargetX/TargetY`。
3. 本表有当前地图记录：使用本表的目标地图和坐标。
4. 再处理事件地图的年龄等后续条件。

`SysopScope >= 100` 的角色跳过这组普通登录位置调整。修改本表时，应同时评估死亡复活和重新登录的效果。

## 数据示例

| Server | DestServer | DestX | DestY | 说明 |
|--------|-----------|-------|-------|------|
| 3 | 1 | 699 | 689 | 地图3匹配本表时定位到地图1 |
| 19 | 1 | 148 | 309 | 地图19匹配本表时定位到地图1 |
| 33 | 33 | 71 | 167 | 地下采石场1层固定坐标（同地图，不是原位置） |
| 35 | 35 | 172 | 215 | 铁矿1层固定坐标（同地图，不是原位置） |

## 相关源码

- [svClass.pas](TGS核心源码/svClass.pas) — `TPosByDieClass.ReLoadFromFile`、`GetPosByDieData`。
- [deftype.pas](deftype.pas) — `TPosByDieData` 记录定义。
- [UUser.pas](TGS核心源码/UUser.pas) — `TUserObject.Update` 的死亡复活分支、`TUserList.InitialLayer` 的登录位置分支。
- [战斗与角色状态](TGSCombat.md) — 死亡、复活与状态更新概览。
