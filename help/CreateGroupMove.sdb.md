# CreateGroupMove.sdb

`Setting/CreateGroupMove.SDB` 配置累计投物后触发的多人传送物件，由 `TGroupMoveList.LoadFromFile` 加载。它是独立的动态场景对象，不是 `CreateGate.sdb` 的一种 `Kind`，也不依赖玩家的正式组队关系。

传送机制比较见 [地图传送机制总览](Teleportation.md)。

## 字段

| 字段 | 实际作用 |
| --- | --- |
| `Name` | SDB 行索引；对象内部名称读取 `GateName` |
| `GateName`、`ViewName` | 内部名称与显示名称 |
| `Shape` | 动态对象外观编号，不是普通传送门的物品图标编号；须有配套客户端资源 |
| `SStep`、`EStep` | 对象展示使用的起止步阶；不是传送间隔 |
| `X`、`Y`、`MapID` | 投物物件所在坐标和地图编号 |
| `TargetX`、`TargetY`、`TargetMapID` | 传送目的地；不是普通门的 `TX/TY/ServerId` 字段 |
| `AddWidth` | 接收投物时检查玩家与物件的最大坐标轴距离；不替代客户端和物品拖放入口的其它限制 |
| `MoveNum` | 触发一轮传送所需的成功投物次数，应设为 `1..8`；不是经过去重的玩家人数 |
| `AddItem` | 指定物品的内部名称。加载器可解析冒号后的数量，但实际接收分支只接受每次一份，按名称匹配 |
| `Width` | 随包表头保留，当前加载器不读取；不能用它控制投物或集体传送范围 |

## 投物与传送流程

1. 物件收到 `FM_ADDITEM`，要求投物者是其当前可见列表中的玩家，并通过 `AddWidth` 距离检查。
2. 本次物品数量必须为 1，内部名称必须匹配 `AddItem`；不是一次拖入八份就完成八次投放。
3. 向玩家发送扣物请求，成功后记录其姓名并累加 `AddItemCount`。未达到阈值时，计数和名单留在物件内存中等待后续投放。
4. 达到 `MoveNum` 后，遍历物件当前可见玩家，将姓名匹配本轮登记记录者传往 `TargetMapID/TargetX/TargetY`。
5. 发送传送消息后清空本轮计数和名单；不是等待所有玩家确认到达后才结算。

## 人数、等待与消耗限制

- **不要求组队**：不检查队长、队伍或 `GroupKey`。没投物的队友不会因组队关系而被带走。
- **同一人可以重复投物**：源码没有姓名去重。`MoveNum=8` 表示累计成功投入八次，并不保证八个不同玩家；重复姓名也没有“一人只发送一次传送消息”的处理。
- **只处理当前可见者**：投物者在触发时已经离开物件视野或离线，不会被全服查找或稍后补传。触发范围也不是用 `AddWidth` 再检查一次。
- **没有超时退款**：物品逐次扣除，`Update` 没有超时、取消或返还逻辑。未凑满时不会自动退回；对象销毁／服务重启也不会持久化恢复本轮名单和计数。
- **容量只有八项**：`Member[0..7]` 是固定数组，写入前没有边界校验。`MoveNum>8` 会产生越界风险，不是增加参与人数的有效方式；0 和负数也不是停用开关。
- **提示文本写死为八份**：剩余数量提示使用 `8-AddItemCount`，不是 `MoveNum-AddItemCount`。设置小于 8 虽可提前触发，但提示不会同步改变。
- **不复用普通门的资格检查**：本物件没有加载 `NeedAge`、`NeedItem`、`Quest` 或 `script` 等普通门字段，不能靠给表头追加这些列开启门票以外的检查。

因此，这个机制适合明确接受上述规则的累计投物入口，不能直接当成“八名不同队员全部在场、资格一致、失败全退”的队伍副本系统。

## 随包示例

炎黄采石场配置为：

| 配置项 | 值 |
| --- | --- |
| 所在地图及坐标 | `MapID=33`，`X=169,Y=72` |
| 目的地图及坐标 | `TargetMapID=34`，`TargetX=50,TargetY=82` |
| 物件外观及步阶 | `Shape=62`，`SStep=0,EStep=9` |
| 接收距离检查 | `AddWidth=7` |
| 投放物品与次数 | `AddItem=乌矿石`，`MoveNum=8` |

即地下采石场 1 层通往 2 层的投物入口。实际操作仍须遵守物品拖放的距离与交互限制；不能只把 `AddWidth=7` 理解为客户端可从七格外投物。

## 校验依据

- [BasicObj.pas](TGS核心源码/BasicObj.pas)：`TGroupMoveObject.Create/Initial/FieldProc/Update`、`TGroupMoveList.LoadFromFile`。
- [deftype.pas](TGS核心源码/deftype.pas)：`TCreateGroupMoveData.Member` 的八项容量。
- [SVMain.pas](TGS核心源码/SVMain.pas)：启动创建 `GroupMoveList`。

以下保留对应处理代码，字段及限制按上面的说明阅读。

## 相关代码

```pascal
function TGroupMoveObject.FieldProc(hfu: Longint; Msg: word; var SenderInfo:
   TBasicData; var aSubData: TSubData): Integer;
var
   SubData: TSubData;
   i, j, index, aLength: Integer;
   oldposx, oldposy: Integer;
   BO: TBasicObject;
begin
   Result := PROC_FALSE;
   if isRangeMessage(hfu, Msg, SenderInfo) = FALSE then
      exit;
   Result := inherited FieldProc(hfu, Msg, Senderinfo, aSubData);
   if Result = PROC_TRUE then
      exit;

   case Msg of
      FM_ADDITEM:
         begin
            BO := GetViewObjectByID(SenderInfo.ID);
            if BO = nil then
               exit;
            if BO.BasicData.Feature.rRace <> RACE_HUMAN then
               exit;

            aLength := GetLargeLength(BasicData.x, BasicData.y, SenderInfo.x,
               SenderInfo.y);
            if aLength > SelfData.AddWidth then
            begin
               TUser(BO).SSendChatMessage(Conv('距离太远'),
                  SAY_COLOR_SYSTEM);
               exit;
            end;

            if aSubData.ItemData.rCount <> 1 then
               exit;
            if StrPas(@aSubData.ItemData.rName) <>
               StrPas(@SelfData.AddItem.rName) then
               exit;

            Move(aSubData.ItemData, SubData.ItemData, SizeOf(TItemData));
            if SendLocalMessage(SenderInfo.ID, FM_DELITEM, BasicData, SubData) =
               PROC_FALSE then
               exit;

            Strcopy(@selfData.Member[AddItemCount], @BO.BasicData.Name);

            Inc(AddItemCount);
            // AddItemUserIDArr [AddItemCount - 1] := SenderInfo.id;

            SetWordString(SubData.SayString,
               format(Conv('%s放入 %s. 总共剩%d个'),
               [StrPas(@BO.BasicData.Name), StrPas(@SelfData.AddItem.rName), 8 -
               AddItemCount]));
            SendLocalMessage(NOTARGETPHONE, FM_SAYSYSTEM, BasicData, SubData);

            if AddItemCount >= SelfData.MoveNum then
            begin
               for i := 0 to ViewObjectList.Count - 1 do
               begin
                  BO := ViewObjectList.Items[i];
                  if BO.BasicData.Feature.rRace = RACE_HUMAN then
                  begin
                     for j := 0 to 8 - 1 do
                     begin
                        if StrPas(@Bo.BasicData.Name) =
                           StrPas(@SelfData.Member[j]) then
                        begin
                           oldposx := BasicData.nx;
                           oldposy := BasicData.ny;

                           SubData.ServerId := SelfData.TargetMapID;
                           BasicData.nx := SelfData.TargetX;
                           BasicData.ny := SelfData.TargetY;

                           SendLocalMessage(BO.BasicData.ID, FM_GATE, BasicData,
                              SubData);

                           BasicData.nx := oldposx;
                           BasicData.ny := oldposy;
                        end;
                     end;
                  end;
               end;
               AddItemCount := 0;
               FillChar(selfdata.Member, sizeof(SelfData.Member), 0);
            end;
         end;
   end;
end;

procedure TGroupMoveList.LoadFromFile(aFileName: string);
var
   DB: TUserStringDB;
   i, j: Integer;
   iName, str, dest: string;
   UMO: TGroupMoveObject;
   pd: PTCreateGroupMoveData;
   ItemData: TItemData;
   Manager: TManager;
begin
   Clear;

   if not FileExists(aFileName) then
      exit;

   DB := TUserStringDB.Create;
   DB.LoadFromFile(aFileName);

   for i := 0 to DB.Count - 1 do
   begin
      iName := DB.GetIndexName(i);
      if iName = '' then
         continue;

      UMO := TGroupMoveObject.Create;
      pd := UMO.GetSelfData;

      pd^.Name := DB.GetFieldValueString(iName, 'GateName');
      pd^.ViewName := Db.GetFieldValueString(iName, 'ViewName');
      pd^.X := Db.GetFieldValueInteger(iName, 'X');
      pd^.Y := Db.GetFieldValueInteger(iName, 'Y');
      pd^.TargetX := Db.GetFieldValueInteger(iName, 'TargetX');
      pd^.TargetY := Db.GetFieldValueInteger(iName, 'TargetY');
      pd^.AddWidth := Db.GetFieldValueInteger(iName, 'AddWidth');
      pd^.MapID := Db.GetFieldValueInteger(iName, 'MapID');
      pd^.TargetMapID := Db.GetFieldValueInteger(iName, 'TargetMapID');
      pd^.Shape := Db.GetFieldValueInteger(iName, 'Shape');
      pd^.SStep := Db.GetFieldValueInteger(iName, 'SStep');
      pd^.EStep := Db.GetFieldValueInteger(iName, 'EStep');

      str := DB.GetFieldValueString(iName, 'AddItem');
      if str <> '' then
      begin
         str := GetValidStr3(str, dest, ':');
         if dest <> '' then
         begin
            ItemClass.GetItemData(dest, ItemData);
            if ItemData.rName[0] <> 0 then
            begin
               str := GetValidStr3(str, dest, ':');
               ItemData.rCount := _StrToInt(dest);
               StrCopy(@pd^.AddItem.rName, @ItemData.rName);
               pd^.AddItem.rCount := ItemData.rCount;
            end;
         end;
      end;

      pd^.MoveNum := Db.GetFieldValueInteger(iName, 'MoveNum');

      Manager := ManagerList.GetManagerByServerID(pd^.MapID);
      if Manager <> nil then
      begin
         UMO.SetManagerClass(Manager);
         UMO.Initial;
         UMO.StartProcess;
         DataList.Add(UMO);
      end
      else
      begin
         UMO.Free;
      end;
   end;

   Db.Free;
end;

```
