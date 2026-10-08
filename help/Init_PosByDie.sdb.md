# PosByDie.sdb

死亡后传送位置配置文件，定义玩家在各地图死亡后被传送到的目标地图和坐标。

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

### 使用场景

当玩家在某个地图中死亡时，系统通过 `PosByDieClass.GetPosByDieData(Manager.ServerID, ...)` 查找对应的死亡传送位置，将玩家传送到指定的目标地图坐标。

## 数据示例

| Server | DestServer | DestX | DestY | 说明 |
|--------|-----------|-------|-------|------|
| 3 | 1 | 699 | 689 | 地图3死亡→地图1 |
| 19 | 1 | 148 | 309 | 地图19死亡→地图1 |
| 33 | 33 | 71 | 167 | 地下采石场1层固定坐标复活（同地图，不是原死亡坐标） |
| 35 | 35 | 172 | 215 | 铁矿1层固定坐标复活（同地图，不是原死亡坐标） |

## 相关源码

- `svClass.pas` — `TPosByDieClass.ReLoadFromFile`（第 7755 行）
- `svClass.pas` — `TPosByDieClass.GetPosByDieData`（第 7784 行）
- `1000ydef/deftype.pas` — `TPosByDieData` 记录定义
- `UUser.pas` — 死亡传送逻辑（第 4297 行、第 10707 行）
