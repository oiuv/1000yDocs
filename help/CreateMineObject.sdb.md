# CreateMineObject%d.sdb

矿物生成点按服务器（地图）编号分别配置在 `Setting/CreateMineObject%d.sdb`。`TMineObjectList.ReLoadFromFile` 以当前 `Manager.ServerID` 代入 `%d`，因此每张地图只读取自己的文件，例如 `CreateMineObject41.sdb`。

| 字段 | 实际加载行为 |
| --- | --- |
| `Name` | SDB 行索引，同时写入生成点名称 |
| `GroupName` | 位置组名称；加载器按组登记并调用 `MineObjectClass.InitPosition` |
| `Shape` | 场景对象形状编号 |
| `X`、`Y` | 生成坐标 |

加载完成后，每行创建一个 `TMineObject`，调用 `Initial(Name, GroupName, X, Y, Shape)` 并启动处理。表内没有矿物掉落字段；矿物模板和产物由 `Init/MineObject.SDB` 等初始化数据决定。

## 校验依据

- 实例表头：`tgs1000/bin/Setting/CreateMineObject1.sdb`
- 加载器：`tgs1000/BasicObj.pas` 的 `TMineObjectList.ReLoadFromFile`
