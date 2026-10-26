# AreaData.sdb

区域数据。定义游戏中的区域信息，包括区域名称、描述、索引编号和功能标识。

## 文件路径
`bin/Init/AreaData.sdb`

## 格式
CSV格式，第一行为列名

## 字段说明
| 字段名 | 类型 | 说明 |
|--------|------|------|
| Name | 字符串 | 区域名称 |
| Desc | 字符串 | 区域描述 |
| Index | 整数 | 区域索引编号 |
| Func | 字符串 | 功能标识（如为数字则表示特殊功能启用） |

## 数据示例
```
Name,Desc,Index,Func,
树林,树林,0,,
地下采石场,地下采石场,1,,
关帝庙,关帝庙,2,,
高丽剑士宅,高丽剑士宅,3,,
平原,field,4,1,
竹林,竹林,5,,
狐狸洞,狐狸洞,6,,
佣兵仓库,佣兵仓库,7,,
石头山,石头山,8,,
```

## 相关源码
```pascal
// svClass.pas - TAreaClass.LoadFromFile
procedure TAreaClass.LoadFromFile (aFileName : String);
var
   i : Integer;
   iName : String;
   pd : PTAreaClassData;
   AreaDB : TUserStringDb;
begin
   Clear;
   if not FileExists (aFileName) then exit;
   AreaDB := TUserStringDb.Create;
   AreaDB.LoadFromFile (aFileName);
   for i := 0 to AreaDB.Count - 1 do begin
      iName := AreaDB.GetIndexName (i);
      if iName = '' then continue;
      New (pd);
      FillChar (pd^, sizeof(TAreaClassData), 0);
      pd^.Name := AreaDB.GetFieldValueString (iName, 'Name');
      pd^.Desc := AreaDB.GetFieldValueString (iName, 'Desc');
      pd^.Func := AreaDB.GetFieldValueString (iName, 'Func');
      pd^.Index := AreaDB.GetFieldValueInteger (iName, 'Index');
      DataList.Add (pd);
   end;
   AreaDB.Free;
end;
```

加载逻辑：在 `TAreaClass.Create` 构造函数中自动调用 `LoadFromFile`。每条记录存入 `TAreaClassData` 结构体并加入 `DataList`。`CanMakeGuild` 方法读取 `Func` 判断区域的建派标记；十大门派门石的地面使用分支另按下述区域索引判断。

## 十大门派的触发区域与生成坐标

`Index=50～59` 对应十大门派。其 `Desc` 使用 `X.Y` 格式，例如血狮石对应的区域记录为：

```text
门派石9,389.396,58,,
```

这里的 `389.396` 是建派后门石的生成坐标。实际创建触发区来自地图同名的 `.sma` 文件，不能仅根据 `Desc` 确定拖放落点。

`THaveItemClass.PutOnScreenProcess` 用拖放目标坐标调用 `TMaper.GetAreaIndex`，要求返回值在 50～59，并检查对应门石名称、境界、已有门派和位置占用情况。满足条件后，才从 `Desc` 读取门石生成坐标并打开名称输入框；落点不在这些区域时直接返回，没有提示。

`TMaper.LoadSMAFromFile` 从地图同目录加载 `.sma`，`GetAreaIndex(x, y)` 读取其中 `y * Width + x` 位置的区域字节。例如当前长城以南的 `south.sma` 中，血狮石区域 58 为 `X=394～396、Y=387～389`；`(395,388)` 是可用创建落点，门石仍生成在 `(389,396)`。

维护坐标说明时，同时核对 `.sma` 区域索引与 `.smp` 通行标记。玩家位置参考见[门派石坐标](<炎黄新章游戏资料/新手入门/【门派】简介/【门派】门派石坐标.md>)。落点有效不代表该位置尚未被占领；更换地图资源后应重新核对。

公开源码参考：[MapUnit.pas](<TGS核心源码/MapUnit.pas>)、[uUserSub.pas](<TGS核心源码/uUserSub.pas>)、[uGuild.pas](<TGS核心源码/uGuild.pas>)。
