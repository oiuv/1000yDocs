unit uManager;

interface

uses
   SysUtils, Classes, DefType, AUtil32, uAnsTick, AnsStringCls;

type
   TManager = class
   private
      timerTick : Integer;
      eventtimerTick : Integer;
   protected
      SOnTimer : Integer;
      SOnEventTimer : Integer;      
   public
      RegenedTick : Integer;
      
      ServerID : integer;
      SmpName : String;
      MapName : String;
      ObjName : String;
      RofName : String;
      TilName : String;
      Title : String;

      OldSoundBase : String;   // 황룡계곡 시간되면 바꾸려고
      SoundBase : String;
      SoundEffect : String;
      SoundStart : String;
      SoundEnd : String;
      Phone : Pointer;
      Maper : Pointer;
      boUseChemistDrug : Boolean;
      boUseDrug : Boolean;
      boUsePowerItem : Boolean;          // 능력치 아이템 사용유무
      boUseGuildMagic : Boolean;
      boUseMagic : Boolean;      
      boUseRiseMagic : Boolean;
      boUseWindMagic : Boolean;
      boUseBestMagic : Boolean;           //2003-09-22
      boUseBestSpecialMagic : Boolean;
      boCanChangeMagic : Boolean;
      boUsePowerLevel : Boolean;
      boUseEtcMagic : Boolean;
      boUseBowMagic : Boolean;
      
      boItemDrop : Boolean;
      boGetExp : Boolean;
      boBigSay : Boolean;
      boMakeGuild : Boolean;
      boPosDie : Boolean;
      boHit : Boolean;
      boWeather : Boolean;
      boPrison : Boolean;
      boChangeLife : Boolean;
      //2002-08-01 giltae
      ChangeDelay : integer;
      ChangeSize : Integer;
      MapAttribute : Integer;
      //-------------------------
      boDark : Boolean;
      boRain : Boolean;
      ChangePercentage : Integer;
      boPick : Boolean;
      boNotDeal : Boolean;
      
      EffectTick : Integer;
      EffectInterval : Integer;
      RegenInterval : Integer;

      TargetServerID : Integer;
      TargetX, TargetY : Word;

      LoginServerID : Integer;
      LoginX, LoginY : Word;

      boSetGroupKey : Boolean;
      GroupKey : Integer;
      boPK : Boolean;
      BattleTick : Integer;

      boEvent : Boolean;
      EventAge : Integer;
      EventID : Integer;
      EventX, EventY : array [0..2 - 1] of Integer; // 토요이벤트마다 초보마을 제한두려구... 10.12 saset
      SubMapIDs : array [0..10 - 1] of Integer; //같이 리젠되는 Map들의 번호
      MotherMapId : Integer; //부모맵
      boNotAllowPK : Boolean;
      boShop : Boolean;

      TotalHour, TotalMin, TotalSec : Word;
      RemainHour, RemainMin, RemainSec : Word;
      UseDrugName : array [0..5 - 1] of String;

      MonsterList : Pointer;
      ItemList : Pointer;
      StaticItemList : Pointer;
      DynamicObjectList : Pointer;
      VirtualObjectList : Pointer;
      NpcList : Pointer;
      MineObjectList : Pointer;
      UserCount : integer;
      boEnter : Boolean;   // 들어갈 수 있는지 없는지 (한사람들어가면 더이상 못들어가는거) 03.05.06 saset
      FboSuccess : Boolean;         
      boBattleStart : Boolean;  // 경기시작하는지 안하는지 (가을운동회이벤트) 031002 saset

      boShowMiniMap : Boolean;      
      boNotUseHideItem : Boolean;
      FMapUserList : TList;

      BattleMop : array [0..2 - 1] of Pointer;    // 문파대전때문에      
   public
      constructor Create;
      destructor Destroy; override;

      function Update (CurTick : LongInt) : Integer;
      procedure Regen;

      procedure SetScript (aIndex : Integer);

      function CheckObjectAlive (aRace : String; aName : String) : Boolean;
      procedure CheckItemRegen (aName : String; aX, aY, aW, aCount : Integer);      
      procedure CalcTime (nTick : Integer; var nHour, nMin, nSec : Word);

      function AddUser ( aUser : Pointer) : Boolean;
      function DelUser ( aUser : Pointer) : Boolean;
      function GetRandomUser : Pointer;

      procedure GetOut (aMopName, aGift, aDelItem : String; aMapID, aTargetMapId, aX, aY : Integer);      
   end;

   TManagerList = class
   private
      DataList : TList;
      FProcessPos, FProcessCount : Integer;
      function    GetCount : Integer;
   public
      constructor Create;
      destructor  Destroy; override;

      procedure   Clear;
      function    LoadFromFile (aFileName : String) : Boolean;
      procedure   ReLoadFromFile;

      procedure   Update (CurTick : LongInt);
      function    FieldProc (hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;

      function    GetManagerByIndex (aIndex : Integer) : TManager;
      function    GetManagerByServerID (aServerID : Integer) : TManager;
      function    GetManagerByTitle (aTitle : String) : TManager;
      // function    GetManagerByGuild (aGuild, aName : String) : TManager;

      function    CheckObjectAlive (aMapTitle : String; aRace : String; aName : String) : Boolean;
      function    GetObjectByName (aRace : Byte; aName : String) : Pointer;

      procedure   RegenById (aMapID : Integer);

      property    Count : Integer read GetCount;
   end;

var
   ManagerList : TManagerList;

implementation

uses
   svMain, svClass, UserSDB, MapUnit, FieldMsg, uMonster, uNpc, BasicObj,
   uGuild, uUser, uDoorGen, uScriptManager;

constructor TManager.Create;
begin
   boNotUseHideItem := false;
   boShowMiniMap := false;      
   
   EffectTick := 0;
   EffectInterval := 0;
   BattleTick := mmAnsTick;      
   RegenedTick := mmAnsTick;
   boNotAllowPK := false;

   MonsterList := nil;
   ItemList := nil;
   StaticItemList := nil;
   DynamicObjectList := nil;
   NpcList := nil;
   MineObjectList := nil;
   VirtualObjectList := nil;

   Phone := nil;
   Maper := nil;

   timerTick := 0;
   eventtimerTick := 0;
   SOnTimer := 0;
   SOnEventTimer := 0;
   UserCount := 0;
   boEnter := true;
   FboSuccess := false;   
   boBattleStart := false;      

   FillChar (SubMapIDs, sizeof(SubMapIDs), 0);
   MotherMapID := 0;
   FMapUserList := TList.Create;

   FillChar (BattleMop, SizeOf (BattleMop), 0);   
end;

destructor TManager.Destroy;
begin
   if MonsterList <> nil then TMonsterList (MonsterList).Free;
   if ItemList <> nil then TItemList (ItemList).Free;
   if StaticItemList <> nil then TStaticItemList (StaticItemList).Free;
   if DynamicObjectList <> nil then TDynamicObjectList (DynamicObjectList).Free;
   if VirtualObjectList <> nil then TVirtualObjectList (VirtualObjectList).Free;   
   if NpcList <> nil then TNpcList (NpcList).Free;
   if MineObjectList <> nil then TMineObjectList (MineObjectList).Free;

   if Phone <> nil then TFieldPhone (Phone).Free;
   if Maper <> nil then TMaper (Maper).Free;
   if FMapUserList <> nil then FMapUserList.Free;        //2002-10-02 gii-tae
   inherited Destroy;
end;

procedure TManager.SetScript (aIndex : Integer);
begin
   SOnTimer := ScriptManager.CheckScriptEvent (aIndex, 'OnTimer');
   SOnEventTimer := ScriptManager.CheckScriptEvent (aIndex, 'OnEventTimer');   
end;

procedure TManager.CalcTime (nTick : Integer; var nHour, nMin, nSec : Word);
var
   SecValue : Integer;
begin
   SecValue := nTick div 100;
   nHour := SecValue div 3600;
   SecValue := SecValue - nHour * 3600;
   nMin := SecValue div 60;
   SecValue := SecValue - nMin * 60;
   nSec := SecValue;
end;

function TManager.AddUser ( aUser : Pointer) : Boolean;
begin
   Result := false;
   if aUser = nil then exit;
   FMapUserList.Add( aUser);
   Result := true;
end;

function TManager.DelUser ( aUser : Pointer) : Boolean;
begin
   Result := false;
   if aUser = nil then exit;
   FMapUserList.Remove( aUser);
   Result := true;
end;

function TManager.GetRandomUser : Pointer;
var
   n : integer;
begin
   Result := nil;
   if FMapUserList.Count <= 0 then exit;
   n := Random (FMapUserList.Count);
   Result := FMapUserList.Items[n];
end;

function TManager.Update (CurTick : LongInt) : Integer;
begin
   Result := 0;

   if MapAttribute = MAP_TYPE_BATTLE then begin
      if boBattleStart = true then begin
         if CurTick >= BattleTick + 100 then begin
            if BattleMapList.CheckSameJoinCount = true then begin
               if boEnter = true then
                  UserList.SayByServerID (ServerID, Conv ('궐힙역迦'), SAY_COLOR_SYSTEM);
               
               UserList.SetActionStateByServerID (ServerID, as_free);
               boBattleStart := false;
               boEnter := false;
            end;
            BattleTick := CurTick;
         end;
      end;
   end;

   if CurTick >= timerTick + 6000 then begin
      if SOnTimer <> 0 then begin
         ScriptManager.CallEvent (Self, nil, nil, SOnTimer, 'OnTimer', ['']);
      end;
      timerTick := CurTick;
   end;

   if (RegenInterval > 0) and (RegenedTick + 100 <= CurTick) then begin
      CalcTime (RegenedTick + RegenInterval - CurTick, RemainHour, RemainMin, RemainSec);

      if MapAttribute = MAP_TYPE_KILLONLYONE then begin
         if (RemainHour = 0) and (RemainMin = 0) and (RemainSec = 30) then begin
            if SOnEventTimer <> 0 then begin
               ScriptManager.CallEvent (Self, nil, nil, SOnEventTimer, 'OnEventTimer', ['']);
            end;
         end;
      end;
   end;
   if (RegenInterval > 0) and (RegenedTick + RegenInterval <= CurTick) then begin
      Regen;
   end else begin
      TDynamicObjectList (DynamicObjectList).Update (CurTick);
      TMonsterList (MonsterList).Update (CurTick);
      TItemList (ItemList).Update (CurTick);
      TStaticItemList (StaticItemList).Update (CurTick);
      TVirtualOBjectList (VirtualObjectList).Update (CurTick);
      TNpcList (NpcList).Update (CurTick);
      TMineObjectList (MineObjectList).Update (CurTick);

      if SoundEffect <> '' then begin
         if CurTick >= EffectTick + EffectInterval then begin
            UserList.SendSoundMessage (format ('%s.wav', [SoundEffect]), ServerID);
            EffectTick := CurTick;
         end;
      end;

      Result := TMonsterList (MonsterList).Count;
   end;
end;

procedure TManager.Regen;
var
   i : integer;
begin
   RegenedTick := mmAnsTick;

   //종속맵에 속한 사람들을 모두 밖으로 빠져나가게 한다.
   if SubMapIds[0] <> 0 then begin
      for i := 0 to 10 - 1 do begin
         if SubMapIds[i] <> 0 then begin
            UserList.MoveByServerID (SubMapIds[i], TargetServerID, TargetX, TargetY);
         end;
      end;
   end;

   if (TargetX > 0) and (TargetY > 0) and (MotherMapID = 0) then begin
      UserList.MoveByServerID (ServerID, TargetServerID, TargetX, TargetY);
   end;

   TDynamicObjectList (DynamicObjectList).ReLoadFromFile;
   TMonsterList (MonsterList).ReLoadFromFile;
   TNpcList (NpcList).ReLoadFromFile;
   TVirtualObjectList (VirtualObjectList).ReLoadFromFile;
   TMineObjectList (MineObjectList).ReLoadFromFile;
   TItemList (ItemList).Clear;

   //FillChar (BattleMop, SizeOf (BattleMop), 0);
      
   boEnter := true;   
end;

function TManager.CheckObjectAlive (aRace : String; aName : String) : Boolean;
var
   BO : TBasicObject;
begin
   Result := false;

   BO := nil;
   if UpperCase (aRace) = 'MONSTER' then begin
      BO := TMonsterList(MonsterList).GetMonsterByName (aName, false);
   end else if UpperCase (aRace) = 'NPC' then begin
      BO := TNpcList(NpcList).GetNpcByName (aName, false);
   end else if UpperCase (aRace) = 'DYNAMICOBJECT' then begin
      BO := TDynamicObjectList(DynamicObjectList).GetDynamicObjectbyName (aName);
   end;

   if BO <> nil then Result := true;
end;

procedure TManager.CheckItemRegen (aName : String; aX, aY, aW, aCount : Integer);
begin
   TItemList (ItemList).AddItemSpecial (aName, ax, ay, aw, aCount);
end;

procedure TManager.GetOut (aMopName, aGift, aDelItem : String; aMapID, aTargetMapId, aX, aY : Integer);
var
   iCount : Integer;
begin
   iCount := TMonsterList (MonsterList).GetAliveCountbyMonsterName (aMopName);

   if iCount >= 3 then begin
      TUserList (UserList).SayByServerID (aMapID, Conv ('價적죄,龍붕콱'), SAY_COLOR_SYSTEM);
      TUserList (UserList).AddItemAllUserByMapID (aMapID, aMopName, aGift);
      TUserList (UserList).DeleteItemAllUserbyName (aMapID, aDelItem);
      TUserList (UserList).MoveByServerID (aMapID, aTargetMapID, aX, aY);
   end else begin
      TUserList (UserList).SayByServerID (aMapID, Conv ('헝된덤苟늴궐힙'), SAY_COLOR_SYSTEM);   
      TUserList (UserList).DeleteItemAllUserbyName (aMapID, aDelItem);
      TUserList (UserList).MoveByServerID (aMapID, aTargetMapID, aX, aY);
   end;
end;



// TManagerList;
constructor TManagerList.Create;
begin
   DataList := TList.Create;
   LoadFromFile ('.\Init\MAP.SDB');

   FProcessPos := 0;
   FProcessCount := 10;
end;

destructor TManagerList.Destroy;
begin
   Clear;
   DataList.Free;

   inherited Destroy;
end;

function TManagerList.GetCount : Integer;
begin
   Result := DataList.Count;
end;

procedure TManagerList.Clear;
var
   i : Integer;
   Manager : TManager;
begin
   for i := 0 to DataList.Count - 1 do begin
      Manager := DataList.Items[i];
      if Manager <> nil then Manager.Free;
   end;
   DataList.Clear;
end;

function TManagerList.LoadFromFile (aFileName : String) : Boolean;
var
   i, j : Integer;
   Manager : TManager;
   MapDB : TUserStringDB;
   iName : String;
   Str, Dest, StrID, StrX, StrY, DestX, DestY : String;
begin
   Result := false;

   Clear;

   MapDB := TUserStringDB.Create;
   MapDB.LoadFromFile (aFileName);

   for i := 0 to MapDB.Count - 1 do begin
      iName := MapDB.GetIndexName (i);
      if iName <> '' then begin
         Manager := TManager.Create;

         Manager.ServerId := StrToInt (iName);
         Manager.SmpName := MapDB.GetFieldValueString (iName, 'SmpName');
         Manager.MapName := MapDB.GetFieldValueString (iName, 'MapName');
         Manager.ObjName := MapDB.GetFieldValueString (iName, 'ObjName');
         Manager.RofName := MapDB.GetFieldValueString (iName, 'RofName');
         Manager.TilName := MapDB.GetFieldValueString (iName, 'TilName');
         Manager.Title := MapDB.GetFieldValueString (iName, 'MapTitle');
         Manager.SoundBase := MapDB.GetFieldValueString (iName, 'SoundBase');
         Manager.OldSoundBase := Manager.SoundBase;
         Manager.SoundEffect := MapDB.GetFieldValueString (iName, 'SoundEffect');
         Manager.SoundStart := MapDB.GetFieldValueString (iName, 'SoundStart');
         Manager.SoundEnd := MapDB.GetFieldValueString (iName, 'SoundEnd');
         Manager.boUseChemistDrug := MapDB.GetFieldValueBoolean (iName, 'boUseChemistDrug');         
         Manager.boUseDrug := MapDB.GetFieldValueBoolean (iName, 'boUseDrug');
         Manager.boUsePowerItem := MapDB.GetFieldValueBoolean (iName, 'boUsePowerItem');
         Manager.boUseGuildMagic := MapDB.GetFieldValueBoolean (iName, 'boUseGuildMagic');
         Manager.boUseWindMagic := MapDB.GetFieldValueBoolean (iName, 'boUseWindMagic');
         Manager.boUseBestMagic := MapDB.GetFieldValueBoolean (iName, 'boUseBestMagic');
         Manager.boUseBestSpecialMagic := MapDB.GetFieldValueBoolean (iName, 'boUseBestSpecialMagic');
         Manager.boCanChangeMagic := MapDB.GetFieldValueBoolean (iName, 'boCanChangeMagic');
         Manager.boUseMagic := MapDB.GetFieldValueBoolean (iName, 'boUseMagic');
         Manager.boUseRiseMagic := MapDB.GetFieldValueBoolean (iName, 'boUseRiseMagic');
         Manager.boUsePowerLevel := MapDB.GetFieldValueBoolean (iName, 'boUsePowerLevel');
         Manager.boUseEtcMagic := MapDB.GetFieldValueBoolean (iName, 'boUseEtcMagic');
         Manager.boUseBowMagic := MapDB.GetFieldValueBoolean (iName, 'boUseBowMagic');
         Manager.boItemDrop := MapDB.GetFieldValueBoolean (iName, 'boItemDrop');
         Manager.boGetExp := MapDB.GetFieldValueBoolean (iName, 'boGetExp');
         Manager.boBigSay := MapDB.GetFieldValueBoolean (iName, 'boBigSay');
         Manager.boMakeGuild := MapDB.GetFieldValueBoolean (iName, 'boMakeGuild');
         Manager.boPosDie := MapDB.GetFieldValueBoolean (iName, 'boPosDie');
         Manager.boHit := MapDB.GetFieldValueBoolean (iName, 'boHit');
         Manager.boWeather := MapDB.GetFieldValueBoolean (iName, 'boWeather');
         Manager.boPrison := MapDB.GetFieldValueBoolean (iName, 'boPrison');
         Manager.boChangeLife := MapDB.GetFieldValueBoolean (iName, 'boChangeLife');
         Manager.ChangeDelay := MapDB.GetFieldValueInteger (iName, 'ChangeDelay');
         Manager.ChangeSize := MapDB.GetFieldValueInteger (iName, 'ChangeSize');
         Manager.MapAttribute := MapDB.GetFieldValueInteger(iName, 'Attribute');
         Manager.boDark := MapDB.GetFieldValueBoolean (iName, 'boDark');
         Manager.boRain := MapDB.GetFieldValueBoolean (iName, 'boRain');
         Manager.ChangePercentage := MapDB.GetFieldValueInteger (iName, 'ChangePercentage');
         Manager.boPick := MapDb.GetFieldValueBoolean(iName, 'boPick');
         Manager.boNotDeal := MapDB.GetFieldValueBoolean (iName, 'boNotDeal');

         Manager.RegenInterval := MapDB.GetFieldValueInteger (iName, 'RegenInterval');
         Manager.EffectInterval := MapDB.GetFieldValueInteger (iName, 'EffectInterval');

         Manager.TargetServerID := MapDB.GetFieldValueInteger (iName, 'TargetServerID');
         Manager.TargetX := MapDB.GetFieldValueInteger (iName, 'TargetX');
         Manager.TargetY := MapDB.GetFieldValueInteger (iName, 'TargetY');

         Manager.LoginServerID := MapDB.GetFieldValueInteger (iName, 'LoginServerID');
         Manager.LoginX := MapDB.GetFieldValueInteger (iName, 'LoginX');
         Manager.LoginY := MapDB.GetFieldValueInteger (iName, 'LoginY');
         Manager.boSetGroupKey := MapDB.GetFieldValueBoolean (iName, 'boSetGroupKey');
         Manager.GroupKey := MapDB.GetFieldValueInteger (iName, 'GroupKey');
         Manager.boPK := MapDB.GetFieldValueBoolean(iName, 'boPK'); //10-02
         Manager.boEvent := MapDB.GetFieldValueBoolean (iName, 'boEvent'); 
         Manager.EventAge := MapDB.GetFieldValueInteger (iName, 'EventAge');  // 10-12
         Manager.EventID := MapDB.GetFieldValueInteger (iName, 'EventID');
         StrX := MapDB.GetFieldValueString (iName, 'EventX');
         if StrX <> '' then begin
            for j := 0 to 2 - 1 do begin
               if StrX = '' then break;
               StrX := GetValidStr3 (StrX, DestX, ':');
               Manager.EventX [j] := _StrToInt (DestX);
            end;
         end;

         StrY := MapDB.GetFieldValueString (iName, 'EventY');
         if StrY <> '' then begin
            for j := 0 to 2 - 1 do begin
               if StrY = '' then break;
               StrY := GetValidStr3 (StrY, DestY, ':');
               Manager.EventY [j] := _StrToInt (DestY);
            end;
         end;

         //2003-05-13
         Str := MapDB.GetFieldValueString (iName, 'SubMap');
         if Str <> '' then begin
            j := 0;
            while Str <> '' do begin
               if j > High (Manager.SubMapIDs) then begin
                  FrmMain.WriteLogInfo (Format ('Map %s: excess SubMap entries ignored (maximum 10)', [iName]));
                  break;
               end;
               Str := GetValidStr3 (Str, StrID, ':');
               Manager.SubMapIDs[j] := _StrToInt (StrID);
               inc(j);
            end;
         end;

         Manager.MotherMapId := MapDB.GetFieldValueInteger (iName, 'MotherMap');
         Manager.boNotAllowPK := MapDB.GetFieldValueBoolean (iName, 'boNotAllowPK');
         Manager.boShop := MapDB.GetFieldValueBoolean (iName, 'boShop'); 
                  
         Manager.CalcTime (Manager.RegenInterval, Manager.TotalHour, Manager.TotalMin, Manager.TotalSec);
         Manager.CalcTime (Manager.RegenInterval, Manager.RemainHour, Manager.RemainMin, Manager.RemainSec);

         Str := MapDB.GetFieldValueString (iName, 'UseDrugName');
         if Str <> '' then begin
            for j := 0 to 5 - 1 do begin
               if Str = '' then break;
               Str := GetValidStr3 (Str, Dest, ':');
               Manager.UseDrugName [j] := Dest;
            end;
         end;
          
         Manager.Maper := TMaper.Create ('.\Smp\' + Manager.SmpName);
         Manager.Phone := TFieldPhone.Create (Manager);

         Manager.MonsterList := TMonsterList.Create (Manager);
         Manager.ItemList := TItemList.Create (Manager);
         Manager.StaticItemList := TStaticItemList.Create (Manager);
         Manager.DynamicObjectList := TDynamicObjectList.Create (Manager);
         Manager.VirtualObjectList := TVirtualObjectList.Create (Manager);
         Manager.MineObjectList := TMineObjectList.Create (Manager);
         Manager.NpcList := TNpcList.Create (Manager);

         Manager.SetScript (MapDB.GetFieldValueInteger (iName, 'Script'));
         Manager.boShowMiniMap := MapDB.GetFieldValueBoolean (iName, 'boShowMiniMap');                  
         Manager.boNotUseHideItem := MapDB.GetFieldValueBoolean (iName, 'boNotUseHideItem');
         DataList.Add (Manager);
      end;
   end;

   MapDB.Free;

   Result := true;
end;

procedure TManagerList.ReLoadFromFile;
var
   i : Integer;
   Manager : TManager;
begin
   for i := 0 to DataList.Count - 1 do begin
      Manager := DataList[i];
      if Manager <> nil then begin
         TMonsterList (Manager.MonsterList).Free;
         TNpcList (Manager.NpcList).Free;
         TVirtualObjectList (Manager.VirtualObjectList).Free;

         Manager.MonsterList := nil;
         Manager.NpcList := nil;
         Manager.VirtualObjectList := nil;
         
         Manager.MonsterList := TMonsterList.Create (Manager);
         Manager.NpcList := TNpcList.Create (Manager);
         Manager.VirtualObjectList := TVirtualObjectList.Create (Manager);         
      end;
   end;
end;

function TManagerList.GetManagerByIndex (aIndex : Integer) : TManager;
begin
   Result := nil;

   if (aIndex < 0) or (aIndex >= DataList.Count) then exit;

   Result := DataList.Items[aIndex];
end;

function TManagerList.GetManagerByServerID (aServerID : Integer) : TManager;
var
   i : Integer;
   Manager : TManager;
begin
   Result := nil;

   for i := 0 to DataList.Count - 1 do begin
      Manager := DataList.Items [i];
      if Manager <> nil then begin
         if Manager.ServerID = aServerID then begin
            Result := Manager;
            exit;
         end;
      end;
   end;
end;

function TManagerList.GetManagerByTitle (aTitle : String) : TManager;
var
   i : Integer;
   Manager : TManager;
begin
   Result := nil;

   for i := 0 to DataList.Count - 1 do begin
      Manager := DataList.Items [i];
      if Manager <> nil then begin
         if Manager.Title = aTitle then begin
            Result := Manager;
            exit;
         end;
      end;
   end;
end;

{
function TManagerList.GetManagerByGuild (aGuild, aName : String) : TManager;
var
   i : Integer;
   Manager : TManager;
begin
   Result := nil;

   if DataList = nil then exit;

   for i := 0 to DataList.Count - 1 do begin
      Manager := DataList.Items [i];
      if Manager <> nil then begin
         if TGuildList(Manager.GuildList).CheckGuildUser(aGuild, aName) = TRUE then begin
            Result := Manager;
            exit;
         end;
      end;
   end;
end;
}

function TManagerList.GetObjectByName (aRace : Byte; aName : String) : Pointer;
var
   i : Integer;
   Manager : TManager;
   Npc : TNpc;
   Monster : TMonster;
   DynamicObject : TDynamicObject;
begin
   Result := nil;

   for i := 0 to DataList.Count - 1 do begin
      Manager := DataList.Items [i];
      if aRace = RACE_MONSTER then begin
         Monster := TMonsterList (Manager.MonsterList).GetMonsterByName (aName, true);
         if Monster <> nil then begin
            Result := Monster;
            exit;
         end;
      end else if aRace = RACE_NPC then begin
         Npc := TNpcList (Manager.NpcList).GetNpcByName (aName, true);
         if Npc <> nil then begin
            Result := Npc;
            exit;
         end;
      end else if aRace = RACE_DYNAMICOBJECT then begin
         DynamicObject := TDynamicObjectList (Manager.DynamicObjectList).GetDynamicObjectByName (aName);
         if DynamicObject <> nil then begin
            Result := DynamicObject;
            exit;
         end;
      end;
   end;

end;

procedure TManagerList.RegenById (aMapID : Integer);
var
   i : Integer;
   Manager : TManager;
begin
   for i := 0 to DataList.Count - 1 do begin
      Manager := DataList.Items [i];
      if Manager.ServerID = aMapID then begin
         Manager.Regen;
      end;
   end;
end;

procedure TManagerList.Update (CurTick : LongInt);
var
    i : Integer;
    Manager : TManager;
begin
   // if FProcessPos >= DataList.Count then FProcessPos := 0;

   {
   FProcessCount := 10;
   for i := 0 to FProcessCount - 1 do begin
      if DataList.Count = 0 then break;
      if FProcessPos >= DataList.Count then FProcessPos := 0;

      Manager := DataList.Items [FProcessPos];
      Manager.Update (CurTick);
      Inc (FProcessPos);
   end;
   }

   for i := 0 to DataList.Count - 1 do begin
      Manager := DataList.Items [i];
      if Manager <> nil then begin
         Manager.Update (CurTick);
      end;
   end;
end;

function  TManagerList.FieldProc (hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;
var
   nByte : Byte;
   SenderName, GuildName: String;
   tmpUser : TUser;
   tmpManager : TManager;
begin
   Result := PROC_FALSE;

   case Msg of
      FM_CHECKGUILDUSER :
         begin
            SenderName := StrPas (@aSubData.SubName);
            GuildName := StrPas (@aSubData.GuildName);
            if GuildList.CheckGuildUser(GuildName, SenderName) = TRUE then begin
               Result := PROC_TRUE;
               exit;
            end;
            Result := PROC_FALSE;
         end;
      FM_REMOVEGUILDMEMBER :
         begin
            SenderName := StrPas (@aSubData.SubName);
            GuildName := StrPas (@aSubData.GuildName);
            tmpUser := UserList.GetUserPointer (SenderName);
            if tmpUser <> nil then begin
               if tmpUser.GuildName = GuildName then begin
                  tmpUser.GuildName := '';
                  tmpUser.GuildGrade := '';
                  StrPCopy(@tmpUser.BasicData.Guild, '');
                  tmpUser.BocChangeProperty;
                  tmpUser.SendClass.SendChatMessage(GuildName + Conv('콱綠쒔錮잼쳔탰죄。'), SAY_COLOR_NORMAL);
                  Result := PROC_TRUE;
               end;
            end;
         end;
      FM_ALLOWGUILDSYSOPNAME :
         begin
            SenderName := StrPas (@aSubData.SubName);
            GuildName := StrPas (@aSubData.GuildName);
            if not GuildList.AllowGuildCondition (GuildName, SenderName) then begin
               Result := PROC_FALSE;
               exit;
            end;
            Result := PROC_TRUE;
         end;
      FM_ALLOWGUILDNAME :
         begin
            SenderName := StrPas (@aSubData.SubName);
            GuildName := StrPas (@aSubData.GuildName);
            if not GuildList.AllowGuildCondition (GuildName, SenderName) then begin
               Result := PROC_FALSE;
               exit;
            end;

            GuildList.AllowGuildName (SenderInfo.id, TRUE, GuildName, SenderName);
            Result := PROC_TRUE;
         end;
      FM_CURRENTUSER :
         begin
            SetWordString (aSubData.SayString, UserList.GetUserList);
         end;
      FM_ADDITEM :
         begin
            tmpManager := GetManagerByServerID (aSubData.ServerId);
            if tmpManager <> nil then begin
               case aSubData.ItemData.rKind of
                  ITEM_KIND_GUILDSTONE :
                     begin
                        {if aSubData.PowerLevel < 5 then begin
                           Result := PROC_DONTDROP;
                           exit;
                        end;

                        if tmpManager.boMakeGuild = true then begin
                           if TMaper (tmpManager.Maper).isMoveable (SenderInfo.nx, SenderInfo.ny) = false then exit;
                           nByte := TMaper (tmpManager.Maper).GetAreaIndex (SenderInfo.nX, SenderInfo.nY);
                           if AreaClass.CanMakeGuild (nByte) = true then begin
                              if TMaper (tmpManager.Maper).isGuildStoneArea (SenderInfo.nX, SenderInfo.nY) = false then begin
  // add by Orber at 2005-01-11 15:46:33
//                                 GuildList.AddGuildObject ('', StrPas (@SenderInfo.Name), tmpManager.ServerID, SenderInfo.nx, SenderInfo.ny);
                                 Result := PROC_TRUE;
                              end;
                           end;
                        end;}
                     end;
                  ITEM_KIND_STATICITEM :
                     begin
                        Result := TStaticItemList(tmpManager.StaticItemList).AddStaticItemObject (aSubData.ItemData, SenderInfo.Id, SenderInfo.nx, SenderInfo.ny);
                     end;
                  else
                     begin
                        if SenderInfo.Feature.rrace <> RACE_HUMAN then begin
                           if (aSubData.ItemData.rCount <= 0) or (aSubData.ItemData.rCount > 100) then exit;
                        end;

                        TItemList(tmpManager.ItemList).AddItemObject (aSubData, SenderInfo.Id, aSubData.TargetId, SenderInfo.nx, SenderInfo.ny);
                        Result := PROC_TRUE;
                     end;
               end;
            end else begin
               frmMain.WriteLogInfo (format ('TManagerList.FieldProc (FM_ADDITEM) failed ServerID=%d', [aSubData.ServerID]));
            end;
         end;

   end;
end;

function TManagerList.CheckObjectAlive (aMapTitle : String; aRace : String; aName : String) : Boolean;
var
   Manager : TManager;
begin
   Result := false;

   Manager := GetManagerByTitle (aMapTitle);
   if Manager = nil then exit;

   Result := Manager.CheckObjectAlive (aRace, aName);
end;

end.
