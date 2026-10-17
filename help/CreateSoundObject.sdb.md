# CreateSoundObject.sdb

`Setting/CreateSoundObject.sdb` 由 `TSoundObjList.LoadFromFile` 加载，用于在场景中周期性广播音效。

| 字段 | 实际加载行为 |
| --- | --- |
| `Name` | SDB 行索引和音效对象名称 |
| `SoundName` | 播放名称；发送时程序追加 `.wav` |
| `MapID` | 所属地图/服务器编号；找不到对应 `Manager` 时跳过该行 |
| `X`、`Y` | 声音对象坐标 |
| `PlayInterval` | 两次播放之间的 tick 间隔 |

对象每 100 tick 才进入一次更新检查；当 `CurTick >= PlayedTick + PlayInterval` 时，通过本地 `FM_SOUND` 消息发送 `SoundName + '.wav'`。

## 校验依据

- 表头：`tgs1000/bin/Setting/CreateSoundObject.sdb`
- 加载与播放逻辑：`tgs1000/uDoorGen.pas` 的 `TSoundObjList.LoadFromFile`、`TSoundObj.Update`
