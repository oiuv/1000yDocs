# Arena.sdb

旧比武招亲擂台配置，定义区域坐标、参赛者出生点、庄主位置及退出位置。它与地图 Attribute=9、Event/BattleMap.sdb 的竞技场机制不是同一编号系统。

## 文件路径
`bin/Init/Arena.sdb`

## 格式
CSV格式，第一行为列名

## 字段说明
| 字段名 | 类型 | 说明 |
|--------|------|------|
| ID | 整数 | 表内记录键；实际擂台编号按加载行位置从 0 开始，不采用此列数值 |
| MasterX | 整数 | 庄主/裁判 X 坐标 |
| MasterY | 整数 | 庄主/裁判 Y 坐标 |
| X1 | 整数 | 竞技场区域左上角 X 坐标 |
| Y1 | 整数 | 竞技场区域左上角 Y 坐标 |
| X2 | 整数 | 竞技场区域右下角 X 坐标 |
| Y2 | 整数 | 竞技场区域右下角 Y 坐标 |
| M1X ~ M8X | 整数 | 参赛者1~8的出生点 X 坐标 |
| M1Y ~ M8Y | 整数 | 参赛者1~8的出生点 Y 坐标 |
| MemberAmount | 整数 | 参赛人数 |
| OutX | 整数 | 退出竞技场后的 X 坐标 |
| OutY | 整数 | 退出竞技场后的 Y 坐标 |

## 编号与地图依赖

加载器执行 `aArena.ID := i`，查询和加入擂台时按列表下标取对象。因此下例两行的实际编号为 0、1，`getintoarena 0` 对应第一行，而不是 ID 列写 0 的记录或地图 0。重排行序会改变调用对应的擂台。

旧擂台流程多处通过 `GetManagerByIndex(1)` 取地图表第二条记录，维护时须保留该位置为长城以南。不能把 Arena 的表内编号、地图 ID 和地图表位置混用。更多规则见 [配置编号、索引与固定容量](ConfigurationIdentifiers.md)。

## 数据示例
```
ID,MasterX,MasterY,X1,Y1,X2,Y2,M1X,M1Y,M2X,M2Y,M3X,M3Y,M4X,M4Y,M5X,M5Y,M6X,M6Y,M7X,M7Y,M8X,M8Y,MemberAmount,OutX,OutY,
1,258,924,251,922,248,925,246,924,247,925,248,926,249,927,250,920,251,921,252,922,253,923,2,257,927,
2,267,881,260,879,257,882,255,881,256,882,257,883,258,884,259,877,260,878,261,879,262,880,2,266,884,
```

## 相关源码
```pascal
// uArena.pas - TArenaObjList.LoadFromFile
function TArenaObjList.LoadFromFile (aFileName : String) : Boolean;
var
   i,j : Integer;
   iName : String;
   DB : TUserStringDB;
   aArena : TArenaObject;
begin
   if not FileExists (aFileName) then exit;
   Clear;
   DB := TUserStringDB.Create;
   DB.LoadFromFile (aFileName);
   for i := 0 to DB.Count - 1 do begin
      iName := DB.GetIndexName (i);
      if iName = '' then continue;
      aArena := TArenaObject.Create;
      aArena.ID := i;
      aArena.MasterX  := DB.GetFieldValueInteger (iName, 'MasterX');
      aArena.MasterY  := DB.GetFieldValueInteger (iName, 'MasterY');
      aArena.X1       := DB.GetFieldValueInteger (iName, 'X1');
      aArena.Y1       := DB.GetFieldValueInteger (iName, 'Y1');
      aArena.X2       := DB.GetFieldValueInteger (iName, 'X2');
      aArena.Y2       := DB.GetFieldValueInteger (iName, 'Y2');
      for j := 0 to 8 -1 do begin
         aArena.MX[j] := DB.GetFieldValueInteger (iName, 'M' + IntToStr(j+1) + 'X');
         aArena.MY[j] := DB.GetFieldValueInteger (iName, 'M' + IntToStr(j+1) + 'Y');
      end;
      aArena.MemberAmount := DB.GetFieldValueInteger (iName, 'MemberAmount');
      aArena.OutX := DB.GetFieldValueInteger (iName, 'OutX');
      aArena.OutY := DB.GetFieldValueInteger (iName, 'OutY');
      DataList.Add(aArena);
   end;
   DB.Free;
end;
```

加载逻辑：每个竞技场配置创建一个 `TArenaObject` 实例。最多支持8个参赛者出生点（M1~M8），由 `MemberAmount` 指定实际使用的人数。竞技场通过 `TArenaObjList` 管理，支持选择庄主、加入成员、开始/结束竞技等操作。
