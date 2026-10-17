# CreateMirror.sdb

`Setting/CreateMirror.sdb` 由 `TMirrorList.LoadFromFile` 加载，用于在指定地图创建镜像对象。

| 字段 | 实际加载行为 |
| --- | --- |
| `Name` | 镜像对象名称；`AddViewer` 也用此名称查找对象 |
| `X`、`Y` | 对象坐标 |
| `MapID` | 所属地图/服务器编号；找不到对应 `Manager` 时该行不会创建对象 |
| `boActive` | 写入镜像对象的初始激活标志 |

成功匹配地图后，加载器为该行调用 `Initial`、`StartProcess` 并加入镜像列表。

## 校验依据

- 表头：`tgs1000/bin/Setting/CreateMirror.sdb`
- 加载器：`tgs1000/BasicObj.pas` 的 `TMirrorList.LoadFromFile`
