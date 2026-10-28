# Event.SDB

事件主要有2类，魔物死亡(或被封印)触发或动态物品被摧毁触发，触发效果为在地图上增加Mop和NPC，理论上使用脚本编程比事件系统更方便。但事件可以用来在其它地图上增加活动而不需要重启服务器，比如在要开放活动的地图设置一个特殊NPC，触发事件时把NPC变为有活动脚本的MOP（但也仅限增加MOP或移除NPC，无法增加动态对象）。

触发判断机制如下：

```pascal
// 死亡时判断是否有同名事件存在
   Code := EventClass.isMopDieEvent (StrPas (@BasicData.Name));
   if Code > 0 then begin
      EventClass.RunMopDieEvent (Code);
   end;

   Code := EventClass.isDynObjDieEvent(StrPas(@BasicData.Name));
   if Code > 0 then
   begin
      EventClass.RunDynObjDieEvent(Code);
   end;

// 如果有同名事件，返回ParamCode
function TEventClass.isMopDieEvent (aSelfName : String) : Byte;
var
   i : Integer;
   ped : PTEventData;
begin
   Result := 0;

   for i := 0 to DataList.Count - 1 do begin
      ped := DataList.Items [i];
      if ped^.Kind = EVENTKIND_DIE_MOP then begin
         if ped^.NameParam = aSelfName then begin
            Result := ped^.ParamCode;
            exit;
         end;
      end;
   end;
end;

function TEventClass.isDynObjDieEvent (aSelfName : String) : Byte;
var
   i : Integer;
   ped : PTEventData;
begin
   Result := 0;

   for i := 0 to DataList.Count - 1 do begin
      ped := DataList.Items [i];
      if ped^.Kind = EVENTKIND_DIE_DYNOBJ then begin
         if ped^.NameParam = aSelfName then begin
            Result := ped^.ParamCode;
            exit;
         end;
      end;
   end;
end;

// 根据ParamCode调用EventParam.sdb的参数
function TEventClass.RunDynObjDieEvent (aCode : Byte) : Boolean;
var
   i : Integer;
   ppd : PTEVentparamData;
   Name1, Name2, SayStr : String;
   Kind1, Kind2 : Byte;
   MapID, MapX, MapY : Word;
   Npc : TNpc;
   Monster : TMonster;
   Manager : TManager;
   Sound : String;
begin
   Result := true;

   for i := 0 to ParamList.Count - 1 do begin
      ppd := ParamList.Items [i];
      if ppd^.Code = aCode then begin
         Name1 := ppd^.NameParam [0];
         Name2 := ppd^.NameParam [1];
         Kind1 := ppd^.NumberParam [0];
         Kind2 := ppd^.NumberParam [1];
         SayStr := ppd^.NameParam [2];
         Sound := ppd^.NameParam [3];

         MapID := 0; MapX := 0; MapY := 0;
         if Kind1 = RACE_MONSTER then begin
            // Npc := ManagerList.GetObjectByName (RACE_NPC, Name2);
            // if Npc <> nil then exit;

            Monster := ManagerList.GetObjectByName (Kind1, Name1);
            if Monster <> nil then begin
               Monster.boAllowDelete := true;
               MapID := Monster.Manager.ServerID;
               MapX := Monster.CreateX;
               MapY := Monster.CreateY;
            end;
         end else if Kind1 = RACE_NPC then begin
            Monster := ManagerList.GetObjectByName (RACE_MONSTER, Name2);
            if Monster <> nil then exit;

            Npc := ManagerList.GetObjectByName (Kind1, Name1);
            if Npc <> nil then begin
               if Npc.State <> los_break then begin
                  Npc.State := los_dieandbreak;
                  MapID := Npc.Manager.ServerID;
                  MapX := Npc.CreateX;
                  MapY := Npc.CreateY;
               end;
            end;
         end;

         Manager := ManagerList.GetManagerByServerID (MapID);
         if Manager <> nil then begin
            if Kind2 = RACE_MONSTER then begin
               TMonsterList(Manager.MonsterList).AddMonster (Name2, MapX, MapY, 2, 0, '');
            end else if Kind2 = RACE_NPC then begin
               Npc := ManagerList.GetObjectByName (Kind2, Name2);
               if Npc <> nil then begin
                  if Npc.State = los_break then begin
                     Npc.State := los_exit;                     
                  end;
               end;
            end;
         end;

         UserList.SendNoticeMessage ('<' + Name2 + '>: ' + SayStr, SAY_COLOR_GRADE5);
         UserList.SendSoundMessage (Sound + '.wav', -1);
         exit;
      end;
   end;
end;

function TEventClass.RunMopDieEvent (aCode : Byte) : Boolean;
var
   i, ScriptNo : Integer;
   ppd : PTEVentparamData;
   Name1, Name2, BookName : String;
   Kind1, Kind2 : Byte;
   MapID, MapX, MapY : Word;
   Npc : TNpc;
   Monster : TMonster;
   Manager : TManager;
begin
   Result := true;

   for i := 0 to ParamList.Count - 1 do begin
      ppd := ParamList.Items [i];
      if ppd^.Code = aCode then begin
         Name1 := ppd^.NameParam [0];
         Name2 := ppd^.NameParam [1];
         BookName := ppd^.NameParam [2];
         Kind1 := ppd^.NumberParam [0];
         Kind2 := ppd^.NumberParam [1];
         ScriptNo := ppd^.NumberParam [2];

         MapID := 0; MapX := 0; MapY := 0;
         if Kind1 = RACE_MONSTER then begin
            // Npc := ManagerList.GetObjectByName (RACE_NPC, Name2);
            // if Npc <> nil then exit;

            Monster := ManagerList.GetObjectByName (Kind1, Name1);
            if Monster <> nil then begin
               Monster.boRegen := false;
               MapID := Monster.Manager.ServerID;
               MapX := Monster.CreateX;
               MapY := Monster.CreateY;
            end;
         end else if Kind1 = RACE_NPC then begin
            Monster := ManagerList.GetObjectByName (RACE_MONSTER, Name2);
            if Monster <> nil then exit;

            Npc := ManagerList.GetObjectByName (Kind1, Name1);
            if Npc <> nil then begin
               if Npc.State <> los_break then begin
                  Npc.State := los_dieandbreak;
                  MapID := Npc.Manager.ServerID;
                  MapX := Npc.CreateX;
                  MapY := Npc.CreateY;
               end;
            end;
         end;

         Manager := ManagerList.GetManagerByServerID (MapID);
         if Manager <> nil then begin
            if Kind2 = RACE_MONSTER then begin
               TMonsterList(Manager.MonsterList).AddMonster (Name2, MapX, MapY, 2, ScriptNo, '');
            end else if Kind2 = RACE_NPC then begin
               Npc := ManagerList.GetObjectByName (Kind2, Name2);
               if Npc <> nil then begin
                  if Npc.State = los_break then begin
                     Npc.State := los_exit;                     
                  end;
               end;
            end;
         end;
         exit;
      end;
   end;
end;
```

当前游戏事件触发流程：

1. 杀死妖华（动态物品类型）触发同名EVENTKIND_DIE_DYNOBJ
2. 事件调用RunDynObjDieEvent在地图上召唤九尾狐变身（MONSTER类型）
3. 杀死九尾狐变身（MONSTER类型）触发同名EVENTKIND_DIE_MOP
4. 事件调用 `RunMopDieEvent`，将已存在且处于隐藏状态的九尾狐酒母（NPC 类型）恢复为出场状态；此分支不为 NPC 重新指定脚本。

### Kind（类型）

```
   EVENTKIND_NONE       = 0;
   EVENTKIND_DIE_DYNOBJ = 1;
   EVENTKIND_DIE_MOP    = 2;
```

## EventParam.sdb（事件参数）

`Event.sdb.ParamCode` 对应 `EventParam.sdb.Code`。各参数在动态物件死亡和怪物死亡两条路径中含义不同，字段表和使用限制统一见[EventParam.sdb](Init_EventParam.sdb.md)。

特别注意：怪物死亡路径的 `NameParam3` 虽读入 `BookName`，后续未使用；`NumberParam3` 只传给新生成怪物的脚本参数，不为已有 NPC 设置脚本。
