unit uGuild;

interface

uses
  Windows, Classes, SysUtils, mmSystem, svClass, subutil, uAnsTick, AnsUnit,
  BasicObj, FieldMsg, MapUnit, DefType, Autil32, uMonster, UUser,
  IniFiles, uLevelexp, uGuildSub, uManager, AnsStringCls, UserSDB,uItemLog;

const
   // DEC_GUILD_DURA_TICK = 200;
   DEC_GUILD_DURA_TICK = 500;

   // 2000.09.16 巩颇檬籍狼 郴备己 刘啊摹 5000栏肺 荐沥 by Lee.S.G
   // ADD_GUILD_DURA_BY_SYSOP = 4000;
   ADD_GUILD_DURA_BY_SYSOP = 5000;
   ADD_GUILD_DURA_BY_SUBSYSOP = 1000;
   DEC_GUILD_DURA_BY_HIT = 10;

   MAX_GUILD_DURA = 1100000;
   MAX_GUILD_STONE1 = 500000;
   MAX_GUILD_STONE2 = 800000;
   MAX_GUILD_STONE3 = 1000000;

   GUILDSTONE_IMAGE_NUMBER = 67;

   MAX_SUBSYSOP_COUNT = 3;
   MAX_GUILDNPC_COUNT = 5;
   MAX_GUILDWEAR_COUNT = 2;

   EXITGUILD_TIME = TRUE;

type
    TGuildItemLogRecord = record
        boUsed : Boolean;
        boLocked : Boolean;
        GuildName : array [0..20 - 1] of byte;
        LockPassword : array [0..9 - 1] of byte;
        LastUpdate : array [0..11 - 1] of byte;
        ItemData : array [0..80 - 1] of TItemLogData;
        CRCKey : Cardinal;
    end;
    PTGuildItemLogRecord = ^TGuildItemLogRecord;

   TGuildObject = class (TBasicObject)
   private
      FGuildName : String;
      FWarAlarmStr : String;
      FWarAlarmStartTick : Integer;
      FWarAlarmTick : Integer;

      SelfData : TCreateGuildData;
      AllyGuildStr : String;

      AllyGuild : TStringList;
      GuildNpcList : TList;
      DieGuildNpcList : TList;
      GuildUserList : TGuildUserList;
      DuraTick : integer;

      FboLoginSysop : Boolean;
      FLoginUserCount : Integer;

      boAddGuildMagic : Boolean;
      AddGuildDurabilityTick : TDateTime;


      function    AddGuildNpc (aName : String; aX, aY : Integer; aSex : Byte): Boolean;
   protected
      procedure   Initial (aTeam : String);
      procedure   StartProcess; override;
      procedure   EndProcess; override;
      function    FieldProc (hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer; override;
      function    GetUserGrade (uname: string): string;
      function    GetGuildNpcbyName (aname: string): integer;

   public
      FGuildItemLog :TGuildItemLogRecord;
      rBoBank : Boolean;
      Bank : Integer;
      GuildType : Byte;
      GuildEnergy : Integer;
      GuildDestory : Boolean;
      GuildDestoryTime : TDateTime;
      GuildEnergyOpen : Boolean;

      constructor Create;
      destructor  Destroy; override;

      procedure   Clear;
      procedure   LoadFromFile (aGuildName: String);
      procedure   SaveToFile;

      function    GetUser (uname: string): PTGuildUserData;
      procedure    UserChange;
      procedure   GetGuildInfo (aUser: TUser);
      function   AddGuildDurability (aDurability : Integer) : Boolean;

      function    MoveStone (aServerID, ax, ay: integer) : Boolean;
      function    CreateStone (aSysopName : String; aServerID, ax, ay: integer) : Boolean;

      procedure   Update (CurTick: integer); override;

      function    IsGuildDelete : Boolean;
      function    IsGuildSysop (aName : String) : Boolean;
      function    IsGuildSubSysop (aName : String) : Boolean;
      function    IsGuildUser (aName : String) : Boolean;
      function    IsGuildNpc (aName : String) : Boolean;
      function    GetGuildSysop : String;
      function    SetGuildSysop (aName:String):String;
      function    GetGuildEnergyLevel:Byte;
      function    AddGuildEnergy(aEnergyLevel:Byte):Byte;
      function    DelGuildEnergy(aEnergyLevel:Byte):Byte;

      function    GetSelfData : PTCreateGuildData;
      function    GetGuildMagicString : String;
      function    GetInformation : String;
      function    GetInfo : TSGuildInfo;
      procedure   SetGuildDurability (aDurability : Integer);

      procedure   AddGuildMagic (aMagicName : String);
      procedure   ChangeGuildNpcName (aOldName, aNewName : String);

      procedure   SetWarAlarm (aName, aStr : String);
      procedure   SetStonePos (X, Y : integer);

      function    AddAllyGuild (aName : String) : String;
      function    DelAllyGuild (aName : String) : String;
      function    GetAllyGuildName (aIndex : Integer) : String;

      procedure   Login (aName : String);
      procedure   Logout (aName : String);
      procedure   AddUser (aName : String);
      function    MakeGuildLetterFile (aName : String) : String;

      property    GuildName : String read FGuildName;
   end;

   TGuildList = class (TBasicObjectList)
   private
   public
      constructor Create;
      destructor  Destroy; override;

      function    FieldProc (aName : String; Msg: Word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;

      procedure   LoadFromFile (aFileName : String);
      procedure   SaveToFile (aFileName : String);
      procedure   SaveToFileForWeb (aFileName : String);

      function    GetObjectByID(GuildObjectID : Integer) : TGuildObject;
      procedure   CompactGuild;

      function    isGuildSysop (aGuildName, aName : String) : Boolean;
      function    isGuildType (aGuildType : Byte) : Boolean;
      procedure    AllowGuildName (gid: integer; aboAllow: Boolean; aGuildName, aSysopName: string);
      function    AllowGuildCondition (gname, uname: string): Boolean;
      function    AddGuildObject (aGuildName, aOwnerName : String; aServerID, aX, aY,aGuildType: integer): TGuildObject;
      function    GetGuildByType (nGuildType : Byte): TGuildObject;
      function    GetUserGrade (aGuildName, uname: string): string;
      function    GetGuildServerID (aGuildName : String): Integer;
      procedure   GetGuildInfo (aGuildName: string; aUser: TUser);
      function    CheckGuildUser(aGuildName, aName : String) : Boolean;
      function    MoveStone (aGuildName : string; aServerID, ax, ay: integer) : Boolean;
      function    CreateStone (aGuildName, aSysopName : string; aServerID, ax, ay: integer) : Boolean;
      procedure   DeleteStone (aGuildName : String);

      function    GetBestGuild : String;
      function    GetGuildObject (aGuildName : String) : TGuildObject;
      function    GetGuildObjectByMagicName (aMagicName : String) : TGuildObject;
      function    GetCharInformation (aName : String) : String;
      function    GetInformation (aName : String) : String;

      procedure   Login (aGuildName, aName : String);
      procedure   Logout (aGuildName, aName : String);
      function    MakeGuildLetterFile (aGuildName, aName : String) : String;
   end;

    TExitGuildUser = record
        Name : String[20];
        ExitGuildName : String[10];
        ExitDate : TDateTime;
    end;
    PTExitGuildUser = ^TExitGuildUser;

   TExitGuildList = class (TList)
   private
   public
      constructor Create;
      destructor  Destroy; override;
      procedure   LoadFromFile (aFileName : String);
      procedure   SaveToFile (aFileName : String);
      procedure   AddExitUser (aName,aGuildName : String);
      function    GetExitUser (aName : String) : Boolean;
   end;
   
var
   GuildList : TGuildList;
   ExitGuildList : TExitGuildList;

implementation

uses
   SVMain, FSockets, uCharCheck;

////////////////////////////////////////////////////
//
//             ===  GuildObject  ===
//
////////////////////////////////////////////////////

constructor TGuildObject.Create;
begin
   inherited Create;

   FGuildName := '';

   FWarAlarmStr := '';
   FWarAlarmTick := 0;
   FWarAlarmStartTick := 0;

   FillChar (SelfData, SizeOf (TCreateGuildData), 0);

   AllyGuildStr := '';

   FboLoginSysop := false;
   FLoginUserCount := 0;

   AllyGuild := TStringList.Create;
   GuildNpcList := TList.Create;
   DieGuildNpcList := TList.Create;
   GuildUserList := TGuildUserList.Create;
end;

destructor  TGuildObject.Destroy;
begin
   Clear;
   AllyGuild.Free;
   GuildUserList.Free;
   GuildNpcList.Free;
   DieGuildNpcList.Free;

   inherited Destroy;
end;

procedure TGuildObject.Clear;
var
   i : Integer;
   GuildNpc : TGuildNpc;
begin
   AllyGuild.Clear;
   for i := 0 to DieGuildNpcList.Count - 1 do begin
      GuildNpc := DieGuildNpcList.Items [i];
      GuildNpc.Free;
   end;
   DieGuildNpcList.Clear;
   
   for i := 0 to GuildNpcList.Count - 1 do begin
      GuildNpc := GuildNpcList.Items [i];
      GuildNpc.EndProcess;
      GuildNpc.Free;
   end;
   GuildNpcList.Clear;
   GuildUserList.Clear;
end;

function TGuildObject.GetSelfData : PTCreateGuildData;
begin
   Result := @SelfData;
end;

function TGuildObject.GetInfo : TSGuildInfo;
var
    GuildInfo : TSGuildInfo;
begin
    GuildInfo.rGuildID := GuildType;
    GuildInfo.rGuildName := GuildName;
    GuildInfo.rSysopName := SelfData.Sysop;
    GuildInfo.rSubSysop0 := SelfData.SubSysop[0];
    GuildInfo.rSubSysop1 := SelfData.SubSysop[1];
    GuildInfo.rSubSysop2 := SelfData.SubSysop[2];
    GuildInfo.rGuildEnergy := GuildEnergy;
    GuildInfo.rGuildEnergy := GuildEnergy;
    GuildInfo.rGuildMember := GuildUserList.GetGuildCount;
    Result := GuildInfo;
end;

procedure TGuildObject.SetGuildDurability (aDurability : Integer);
begin
    SelfData.MaxDurability := aDurability;
    SelfData.Durability := aDurability + 10000;
end;

function TGuildObject.GetInformation : String;
var
   i : Integer;
   Str, tmpStr, rdStr : String;
begin
   Result := '';

   Str := format (Conv('<%s门派信息> '), [GuildName]) + #13;
   Str := Str + format (Conv('门主: %s'), [SelfData.Sysop]) + #13;
   for i := 0 to 3 - 1 do begin
      Str := Str + format (Conv('副门主%d: %s'), [i + 1, SelfData.SubSysop[i]]) + #13;
   end;
   Str := Str + format (Conv('位置: %d,%d'), [BasicData.X, BasicData.Y]) + #13;
   Str := Str + format (Conv('耐久度:%d'), [SelfData.Durability]) + #13;
   Str := Str + format (Conv('门派武功: %s　修炼值：%d'), [SelfData.GuildMagic, SelfData.MagicExp]) + #13;
   rdStr := ''; tmpStr := '';
   for i := 0 to AllyGuild.Count - 1 do begin
      if tmpStr <> '' then tmpStr := tmpStr + ', ';
      tmpStr := tmpStr + AllyGuild.Strings [i];
      if Length (tmpStr) > 40 then begin
         rdStr := rdStr + tmpStr + #13;
         tmpStr := '';
      end;
   end;
   if tmpStr <> '' then rdStr := rdStr + tmpStr;
   Str := Str + Conv('同盟:') + rdStr + #13;
   for i := 0 to 5 - 1 do begin
      Str := Str + format ('%s : %d,%d', [SelfData.GuildNpc[i].rName, SelfData.GuildNpc [i].rX, SelfData.GuildNpc [i].rY]) + #13;
   end;

   Result := Str;
end;

function TGuildObject.GetGuildMagicString : String;
begin
   Result := SelfData.GuildMagic;
end;

procedure TGuildObject.AddGuildMagic (aMagicName : String);
var
   GuildNpc : TGuildNpc;
begin
   GuildNpc := nil;
   SelfData.GuildMagic := aMagicName;
   SelfData.MagicExp := 100;
   if GuildNpcList.Count > 0 then begin
      GuildNpc := GuildNpcList.Items [0];
   end else if DieGuildNpcList.Count > 0 then begin
      GuildNpc := DieGuildNpcList.Items [0];
   end;
   if GuildNpc <> nil then begin
      GuildNpc.boMagicNpc := true;
      StrPCopy (@GuildNpc.BasicData.Guild, SelfData.GuildMagic);
      MagicClass.GetMagicData (SelfData.GuildMagic, GuildNpc.GuildMagicData, SelfData.MagicExp);
      GuildNpc.BocChangeProperty;
      boAddGuildMagic := true;
   end;
end;

function TGuildObject.IsGuildUser (aName : String) : boolean;
begin
   Result := GuildUserList.IsGuildUser(aName);
end;

// add by Orber at 2005-01-17 11:18:10
function TGuildObject.IsGuildDelete: Boolean;
begin
   Result := FboAllowDelete;
end;


function TGuildObject.IsGuildSysop (aName : String) : Boolean;
begin
   Result := false;
   if SelfData.Sysop = aName then Result := true;
end;

function TGuildObject.IsGuildSubSysop (aName : String) : Boolean;
var
   i : Integer;
begin
   Result := false;
   for i := 0 to 3 - 1 do begin
      if SelfData.SubSysop [i] = aName then begin
         Result := true;
         exit;
      end;
   end;
end;
function TGuildObject.GetGuildSysop:String;
begin
    Result := SelfData.Sysop;
end;

function TGuildObject.SetGuildSysop(aName:String):String;
var i:integer;
begin
    SelfData.Sysop := aName;
    for i := 0  to 3-1 do begin
        if SelfData.SubSysop[i] = aName then begin
            SelfData.SubSysop[i] := '';
            Break;
        end;
    end;
end;

function TGuildObject.GetGuildEnergyLevel:Byte;
begin
    case GuildEnergy of
      0..400 : result := 1;
      401..800 : result := 2;
      801..1200: result := 3;
      1201..1800: result := 4;
      1801..2600: result := 5;
      2601..3600: result := 6;
      3601..4800: result := 7;
      4801..6200: result := 8;
      6201..7800: result := 9;
      7801..9600: result := 10;
    end;
end;

function TGuildObject.AddGuildEnergy(aEnergyLevel:Byte):Byte;
begin
            Case aEnergyLevel of
                2: Inc(aEnergyLevel , 1);
                3: Inc(aEnergyLevel , 2);
                4: Inc(aEnergyLevel , 4);
                5: Inc(aEnergyLevel , 8);
                6: Inc(aEnergyLevel , 12);
                7: Inc(aEnergyLevel , 16);
                8: Inc(aEnergyLevel , 20);
                9: Inc(aEnergyLevel , 24);
                10: Inc(aEnergyLevel , 30);
                11: Inc(aEnergyLevel , 36);
                12: Inc(aEnergyLevel , 48);
                13: Inc(aEnergyLevel , 72);
            end;
end;

function TGuildObject.DelGuildEnergy(aEnergyLevel:Byte):Byte;
begin
            Case aEnergyLevel of
                2: Dec(aEnergyLevel , 1);
                3: Dec(aEnergyLevel , 2);
                4: Dec(aEnergyLevel , 4);
                5: Dec(aEnergyLevel , 8);
                6: Dec(aEnergyLevel , 12);
                7: Dec(aEnergyLevel , 16);
                8: Dec(aEnergyLevel , 20);
                9: Dec(aEnergyLevel , 24);
                10: Dec(aEnergyLevel , 30);
                11: Dec(aEnergyLevel , 36);
                12: Dec(aEnergyLevel , 48);
                13: Dec(aEnergyLevel , 72);
            end;
end;


function TGuildObject.IsGuildNpc (aName : String) : Boolean;
var
   i : Integer;
   GuildNpc : TGuildNpc;
begin
   Result := false;

   if aName = '' then exit;

   for i := 0 to GuildNpcList.Count - 1 do begin
      GuildNpc := GuildNpcList.Items [i];
      if GuildNpc.GuildNpcName = aName then begin
         Result := true;
         exit;
      end;
   end;
   for i := 0 to DieGuildNpcList.Count - 1 do begin
      GuildNpc := DieGuildNpcList.Items [i];
      if GuildNpc.GuildNpcName = aName then begin
         Result := true;
         exit;
      end;
   end;
end;

procedure TGuildObject.SaveToFile;
var
   i, nIndex : Integer;
   GuildNpc : TGuildNpc;
begin
   if SelfData.Name = '' then exit;

   FillChar (SelfData.GuildNpc, SizeOf (SelfData.GuildNpc), 0);
   nIndex := 0;
   for i := 0 to GuildNpcList.Count - 1 do begin
      GuildNpc := GuildNpcList.Items [i];
      if GuildNpc.boMagicNpc = true then begin
         SelfData.MagicExp := GuildNpc.GuildMagicData.rSkillExp;
         SelfData.GuildNpc[nIndex].rName := GuildNpc.GuildNpcName;
         SelfData.GuildNpc[nIndex].rX := GuildNpc.StartX;
         SelfData.GuildNpc[nIndex].rY := GuildNpc.StartY;
         SelfData.GuildNpc[nIndex].rSex := GuildNpc.Sex;
         Inc (nIndex);
      end;
   end;
   for i := 0 to DieGuildNpcList.Count - 1 do begin
      GuildNpc := DieGuildNpcList.Items [i];
      if GuildNpc.boMagicNpc = true then begin
         SelfData.MagicExp := GuildNpc.GuildMagicData.rSkillExp;
         SelfData.GuildNpc[nIndex].rName := GuildNpc.GuildNpcName;
         SelfData.GuildNpc[nIndex].rX := GuildNpc.StartX;
         SelfData.GuildNpc[nIndex].rY := GuildNpc.StartY;
         SelfData.GuildNpc[nIndex].rSex := GuildNpc.Sex;
         Inc (nIndex);
      end;
   end;

   for i := 0 to GuildNpcList.Count - 1 do begin
      GuildNpc := GuildNpcList.Items [i];
      if GuildNpc.boMagicNpc = false then begin
         SelfData.GuildNpc[nIndex].rName := GuildNpc.GuildNpcName;
         SelfData.GuildNpc[nIndex].rX := GuildNpc.StartX;
         SelfData.GuildNpc[nIndex].rY := GuildNpc.StartY;
         SelfData.GuildNpc[nIndex].rSex := GuildNpc.Sex;
         Inc (nIndex);
      end;
   end;
   for i := 0 to DieGuildNpcList.Count - 1 do begin
      GuildNpc := DieGuildNpcList.Items [i];
      if GuildNpc.boMagicNpc = false then begin
         SelfData.MagicExp := GuildNpc.GuildMagicData.rSkillExp;
         SelfData.GuildNpc[nIndex].rName := GuildNpc.GuildNpcName;
         SelfData.GuildNpc[nIndex].rX := GuildNpc.StartX;
         SelfData.GuildNpc[nIndex].rY := GuildNpc.StartY;
         SelfData.GuildNpc[nIndex].rSex := GuildNpc.Sex;
         Inc (nIndex);
      end;
   end;

   AllyGuildStr := '';
   for i := 0 to AllyGuild.Count - 1 do begin
      if AllyGuildStr <> '' then AllyGuildStr := AllyGuildStr + ':';
      AllyGuildStr := AllyGuildStr + AllyGuild.Strings [i];
   end;

   GuildUserList.SaveToFile ('.\Guild\' + SelfData.Name + 'GUser.sdb');
end;

procedure TGuildObject.LoadFromFile;
var
    Stream:TFileStream;
    aFileName :String;
begin
   if not FileExists ('.\Guild\' + SelfData.Name + 'GUser.SDB') then exit;

  // add by Orber at 2005-01-05 14:53:33
   aFileName := '.\Guild\' + SelfData.Name  + '_ITEMLOG.BIN';

   try
      Stream := TFileStream.Create (aFileName, fmOpenRead);
       Stream.Seek (0, soFromBeginning);
       Stream.ReadBuffer(FGuildItemLog,SizeOf(FGuildItemLog));
       Stream.Free;
   except
      exit;
   end;

   GuildUserList.LoadFromFile ('.\Guild\' + SelfData.Name + 'GUser.sdb');
end;

function TGuildObject.GetUserGrade (uName: String) : String;
var
   i : Integer;
begin
  // add by Orber at 2005-02-24 16:32:03
   {if SelfData.Durability < SelfData.MaxDurability + 100000 then begin
      if uName = SelfData.Sysop then
         Inc (SelfData.Durability, ADD_GUILD_DURA_BY_SYSOP);
      for i := 0 to MAX_SUBSYSOP_COUNT - 1 do begin
         if uName = SelfData.SubSysop[i] then
            Inc (SelfData.Durability, ADD_GUILD_DURA_BY_SUBSYSOP);
      end;
      SelfData.Durability := SelfData.MaxDurability;
   end;}



   Result := GuildUserList.GetGradeName (uName);
end;

function TGuildObject.GetUser (uname: string): PTGuildUserData;
begin
    result := GuildUserList.GetUser(uname);
end;

// add by Orber at 2005-01-12 02:39:58
procedure TGuildObject.UserChange;
begin
    GuildUserList.DoChange;
end;

function TGuildObject.AddGuildDurability (aDurability : Integer) : Boolean;
var
    PassTime : Single;
begin
    result := False;
    PassTime := Now-AddGuildDurabilityTick;

    if NATION_VERSION = NATION_TAIWAN then begin
      aDurability := aDurability * 2;
      PassTime := PassTime * 2;
    end;

    if PassTime * 24 > 7 then begin
        Inc(SelfData.Durability,aDurability);
        if SelfData.Durability > SelfData.MaxDurability then SelfData.Durability := SelfData.MaxDurability;
        AddGuildDurabilityTick := Now;
        Result := True;
    end;
end;

procedure TGuildObject.GetGuildInfo (aUser: TUser);
var
   i : Integer;
   tmpStr, rdStr, tStr, Sep : String;
begin
   tmpStr := SelfData.Name + ' (' + IntToStr (BasicData.X) + ',' + IntToStr (BasicData.Y) + ')';
   aUser.SendClass.SendChatMessage (Conv('门派名称:') + tmpStr, SAY_COLOR_NORMAL);
   aUser.SendClass.SendChatMessage (Conv('门主:') + SelfData.Sysop, SAY_COLOR_NORMAL);

   tmpStr := Conv('副门主:');
   Sep := '';
   for i := 0 to MAX_SUBSYSOP_COUNT - 1 do begin
      if SelfData.SubSysop[i] <> '' then begin
         tmpStr := tmpStr + Sep + SelfData.SubSysop[i];
         Sep := ', ';
      end;
   end;
   aUser.SendClass.SendChatMessage (tmpStr, SAY_COLOR_NORMAL);
   
   rdStr := ''; tStr := '';
   for i := 0 to AllyGuild.Count - 1 do begin
      if tStr <> '' then tStr := tStr + ', ';
      tStr := tStr + AllyGuild.Strings [i];
      if Length (tStr) > 40 then begin
         rdStr := rdStr + tStr + #13;
         tStr := '';
      end;
   end;
   if tStr <> '' then rdStr := rdStr + tStr;
   tmpStr := Conv('同盟:') + rdStr;
   aUser.SendClass.SendChatMessage (tmpStr, SAY_COLOR_NORMAL);
end;

function TGuildObject.AddGuildNpc (aName: string; ax, ay: integer; aSex : Byte): Boolean;
var
   i : integer;
   GuildNpc : TGuildNpc;
begin
   Result := FALSE;

   if GetGuildNpcByName (aName) <> -1 then exit;
   if aSex <> 2 then aSex := 1;

   for i := 0 to MAX_GUILDNPC_COUNT - 1 do begin
      if SelfData.GuildNpc[i].rName = '' then begin
         SelfData.GuildNpc[i].rName := aName;
         SelfData.GuildNpc[i].rX := aX;
         SelfData.GuildNpc[i].rY := aY;
         SelfData.GuildNpc[i].rSex := aSex;

         GuildNpc := TGuildNpc.Create;
         GuildNpc.SetManagerClass (Manager);

         GuildNpc.Initial (Self, aName, aX, aY, aSex);

         if (SelfData.GuildMagic <> '') and (boAddGuildMagic = false) then begin
            GuildNpc.boMagicNpc := true;
            StrPCopy (@GuildNpc.BasicData.Guild, SelfData.GuildMagic);
            MagicClass.GetMagicData (SelfData.GuildMagic, GuildNpc.GuildMagicData, SelfData.MagicExp);
            boAddGuildMagic := true;
         end;
         DieGuildNpcList.Add (GuildNpc);

         Result := TRUE;
         exit;
      end;
   end;
end;

function  TGuildObject.FieldProc (hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;
var
   i, n, percent : integer;
//   xx, yy: word;
   str1, str2, str3: string;
   str, gname : string;
   sayer, objectname, gradename: string;
   SubData: TSubData;
   BO: TBasicObject;
   GuildNpc : TGuildNpc;
   aUser : TUser;
   ItemData : TItemData;
begin
   Result := PROC_FALSE;
   if isRangeMessage ( hfu, Msg, SenderInfo) = FALSE then exit;
   Result := inherited FieldProc (hfu, Msg, Senderinfo, aSubData);
   if Result = PROC_TRUE then exit;
   //if Msg = FM_CLICK then Msg := FM_HIT;
   case Msg of
      FM_ADDITEM:
         begin
            if SelfData.Name = '' then Exit;

            if aSubData.ItemData.rKind = ITEM_KIND_DUMMY then begin
               if GuildNpcList.Count + DieGuildNpcList.Count >= MAX_GUILDNPC_COUNT then begin
                  BocSay (Conv('无法再制造。'));
                  exit;
               end;
               i := 0;
               while true do begin
                  if aSubData.ItemData.rSex = 2 then begin
                     gName := INI_GUILD_NPCWOMAN_NAME + IntToStr(i);
                     if GetGuildNpcByName (gName) = -1 then begin
                        AddGuildNpc (gName, BasicData.X, BasicData.Y, 2);
                        Result := PROC_TRUE;
                        break;
                     end;
                  end else begin
                     gName := INI_GUILD_NPCMAN_NAME + IntToStr(i);
                     if GetGuildNpcByName (gName) = -1 then begin
                        AddGuildNpc (gName, BasicData.X, BasicData.Y, 1);
                        Result := PROC_TRUE;
                        break;
                     end;
                  end;
                  Inc (i);
               end;
               exit;
            end;
         end;
      FM_HIT :
         begin
            if SelfData.Name <> '' then begin
               if isHitedArea (SenderInfo.dir, SenderInfo.x, SenderInfo.y, aSubData.HitData.HitFunction, percent) then begin
                  if TUser (SenderInfo.P).GetWeaponItemName = Conv('砸门锤') then begin
                      // add by minds 050902
                      if GateList.IsOwnGateGuild(GuildName) then exit;

                      if SelfData.Durability mod 100 = 0 then begin
                          UserList.GuildSay (SelfData.Name, SelfData.Name + ': ' + format (Conv('%s 被攻击'),[INI_GUILD_STONE]));
                      end;

                      Dec (SelfData.Durability, DEC_GUILD_DURA_BY_HIT);
                      if SelfData.Durability <= 0 then begin
                          UserList.SendTopMessage(GuildName + Conv('于')+ FormatDateTime(Conv('YYYY"年"MM"月"DD"日"'),Date) + Conv('被灭门了'));
                          GuildList.DeleteStone(GuildName);
                      end;
                      n := SelfData.Durability;
                      if n > SelfData.MaxDurability then n := SelfData.MaxDurability;
                      BocSay (IntToStr (n));
                      SubData.TargetId := SenderInfo.id;
                      for i := 0 to GuildNpcList.Count - 1 do begin
                         GuildNpc := GuildNpcList.Items [i];
                         if GuildNpc.FieldProc (NOTARGETPHONE, FM_GUILDATTACK, BasicData, SubData) = PROC_TRUE then begin
                            break;
                         end;
                      end;
                  end;
               end;
            end;
{
            xx := SenderInfo.x; yy := SenderInfo.y;
            GetNextPosition (SenderInfo.dir, xx, yy);
            if (BasicData.x = xx) and (BasicData.y = yy) then begin
               UserList.GuildSay (GuildName, GuildName+ ': '+format (Conv('%s 被攻击'),[INI_GUILD_STONE]));
               Dec (GuildDurability, DEC_GUILD_DURA_BY_HIT);
               BocSay (IntToStr (GuildDurability));
               SubData.TargetId := SenderInfo.id;
               for i := 0 to AnsList.Count -1 do
                  if TGuildNpc (AnsList[i]).FieldProc (NOTARGETPHONE, FM_GUILDATTACK, BasicData, SubData) = PROC_TRUE then break;
            end;
}
         end;
      FM_PICKUP :
         begin
            if FboAllowDelete then exit;
            if (SelfData.Name = '') and (SelfData.Sysop <> '') then begin
               if (StrPas (@SenderInfo.Name) = SelfData.Sysop) or (SysopClass.GetSysopScope (StrPas (@SenderInfo.Name)) >= 100) then begin
                  ItemClass.GetItemData (TUser(SenderInfo.P).aSetGuildStoneName, SubData.ItemData);
                  TUser(SenderInfo.P).aSetGuildStoneName := '';
                  SignToItem (SubData.ItemData, Manager.ServerID, SenderInfo, '');
                  SubData.ServerId := Manager.ServerId;
                  if TFieldPhone(Manager.Phone).SendMessage (SenderInfo.id, FM_ADDITEM, BasicData, SubData) = PROC_TRUE then begin
                     FboAllowDelete := TRUE;
                     exit;
                  end;
               end;
            end;
         end;
      FM_AGREEALLYGUILD :
         begin
            if UserList.FieldProc (SelfData.Sysop, Msg, SenderInfo, aSubData) = 0 then begin
               BocSay (Conv('门主没有连线'));
            end;
         end;
      FM_ADDALLYGUILD :
         begin
            Str := StrPas (@aSubData.GuildName);
            for i := 0 to AllyGuild.Count - 1 do begin
               if AllyGuild.Strings [i] = Str then exit;
            end;
            AllyGuild.Add (Str);
            UserList.GuildSay (GuildName, '<' + GuildName + '> : ' + format (Conv('设定与%s门派结盟 '), [Str]));
         end;
      FM_DELALLYGUILD :
         begin
            Str := StrPas (@aSubData.GuildName);
            for i := 0 to AllyGuild.Count - 1 do begin
               if AllyGuild.Strings [i] = Str then begin
                  AllyGuild.Delete (i);
                  UserList.GuildSay (GuildName, '<' + GuildName + '> : ' + format (Conv('解除与%s门派结盟'), [Str]));
                  break;
               end;
            end;
         end;
      FM_SAY :
         begin
            if FboAllowDelete then exit;
            if SenderInfo.id = BasicData.id then exit;

            if StrPas (@SenderInfo.Name) = SelfData.Sysop then begin
               str := GetWordString (aSubData.SayString);
               if ReverseFormat (str, Conv('%s: 设定与%s门派结盟'), str1, str2, str3, 2) then begin
                  Str := AddAllyGuild (Str2);
                  if Str <> '' then BocSay (Str);
                  exit;
               end;
               if ReverseFormat (str, Conv('%s: 解除与%s门派结盟'), str1, str2, str3, 2) then begin
                  Str := DelAllyGuild (Str2);
                  if Str <> '' then BocSay (Str);
                  exit;
               end;
               if ReverseFormat (str, Conv('%s: 打开门派境界'), str1, str2, str3, 2) then begin
                     BocSay ( Conv('门派境界已经打开'));
                  exit;
               end;
               if ReverseFormat (str, Conv('%s: 关闭门派境界'), str1, str2, str3, 2) then begin
                     BocSay ( Conv('门派境界已经关闭'));
                  exit;
               end;
               if ReverseFormat (str, Conv('%s: %s门派创建'), str1, str2, str3, 2) then begin
                  {
                  if (not isFullHangul (str2)) or (not isGrammarID(str2)) or (Length(str2) > 12) or (Length(str2) < 2) then begin
                     BocSay ( Conv('门派名字错误。'));
                     exit;
                  end;
                  }                  
                  if (CheckPascalString (str2) = 0) or (Length(str2) > 12) or (Length(str2) < 2) then begin
                     BocSay ( Conv('门派名字错误。'));
                     exit;
                  end;
                  SubData.ServerId := Manager.ServerId;
                  StrPCopy (@SubData.SubName, Str1);
                  StrPCopy (@SubData.GuildName, Str2);
                  if TFieldPhone (Manager.Phone).SendMessage (MANAGERPHONE, FM_ALLOWGUILDNAME, BasicData, SubData) = PROC_FALSE then begin
                     BocSay ( Conv('已有门派名称'));
                     BocSay ( Conv('该人物已是门主或副门主。'));
                     BocSay ( Conv('无法成立门派。'));
                     exit;
                  end else begin
                     BocChangeProperty;
                  end;
                  exit;
               end;
                // add by Orber at 2005-01-15 11:38:49
               if str = StrPas (@SenderInfo.Name) + ': ' + Conv('门派解体') then begin
                    GuildDestory := TRUE;
                    GuildDestoryTime := Now;
                    UserList.GuildSay(GuildName,GuildName + Conv('门派三日后将被解散'));
               end;
               if str = StrPas (@SenderInfo.Name) + ': ' + Conv('解除门派解体') then begin
                    GuildDestory := False;
                    GuildDestoryTime := Now;
                    UserList.GuildSay(GuildName,GuildName + Conv('门派取消解散'));
               end;
               if ReverseFormat (str, Conv('%s: 让位给%s'), str1, str2, str3, 2) then begin
                    if Not IsGuildSubSysop(Str2) then begin
                        BocSay (format (Conv('%s不是副门主'),[Str2]));
                        Exit;
                    end;
                    aUser := UserList.GetUserPointer(Str2);
                    if aUser = nil then begin
                        BocSay ( format (Conv('%s不在线'),[Str2]));
                        Exit;
                    end;

                    // add by minds 2005. 08. 25.
                    if aUser.GuildName <> StrPas(@SenderInfo.Guild) then begin
                        BocSay(Format(Conv('%s是别的门派'), [Str2]));
                        Exit;
                    end;

                    aUser.SendClass.SendShowGuildSubSysopWindow(Conv('门主希望将门主之位让位给你'));
                    BocSay ( format (Conv('正在向%s发送让位消息'),[Str2]));
                    exit;
               end;

            end;
            if SelfData.Name = '' then exit;

            str := GetwordString (aSubData.SayString);
            if Pos (Conv('退出门派'),str) > 0 then begin
               str := GetValidStr3 (str, sayer, ':');
               // 2000.09.18 NPC狼 捞抚苞 User狼 捞抚捞 鞍阑锭 八祸坷幅滚弊 荐沥 by Lee.S.G
               // 呕硼绰 RACE_HUMAN俊辑父 蜡瓤窍促
               Bo := GetViewObjectByName (sayer, RACE_HUMAN);
               if Bo = nil then exit;
               if not (Bo is TUser) then exit;
               if SelfData.Sysop = TUser(Bo).Name then begin
                   BocSay (Conv('门主退出门派前，请先让位。'));
                   exit;
               end;
               ItemClass.GetItemData(Conv('钱币'),ItemData);
               ItemData.rCount := 10000;
               Inc(Bank,10000);
               if Not TUser(Bo).DeleteItem(@ItemData) then begin
                    BocSay (Conv('没有足够的钱币，退门失败'));
                    Exit;
               end;
               for i := 0 to 3-1 do begin
                    if SelfData.SubSysop[i] = TUser(Bo).Name then begin
                        SelfData.SubSysop[i] := '';
                        Break;
                    end;
               end;
               ExitGuildList.AddExitUser(TUser(Bo).Name ,GuildName);
               Logout (sayer);
               TUser(Bo).GuildName := '';
               TUser(Bo).GuildGrade := '';
               StrPCopy(@TUser(Bo).BasicData.Guild, '');
               TUser(Bo).BocChangeProperty;
               BocSay (TUser(Bo).Name + Conv('已经逃脱了。'));
               exit;
            end;

            str := GetWordString (aSubData.SayString);
            if Pos (Conv('请将我的权力删除'), str) > 0 then begin
               str := GetValidStr3 (str, sayer, ':');
               Bo := GetViewObjectByName (sayer, RACE_HUMAN);
               if Bo = nil then exit;
               if not (Bo is TUser) then exit;
               if (sayer <> SelfData.SubSysop[0]) and (sayer <> SelfData.SubSysop[1]) and (sayer <> SelfData.SubSysop[2]) then begin
                  BocSay (Conv('并非是副门主。'));
                  exit;
               end;
               if sayer = SelfData.SubSysop[0] then SelfData.SubSysop[0] := ''
               else if sayer = SelfData.SubSysop[1] then SelfData.SubSysop[1] := ''
               else if sayer = SelfData.SubSysop[2] then SelfData.SubSysop[2] := '';
               BocSay (Conv('已将副门主权力删除。'));
               exit;
            end;

            str := GetwordString (aSubData.SayString);
            if ReverseFormat (str, '%s: ', sayer, str2, str3, 1) then begin
               if (sayer <> SelfData.Sysop) and (sayer <> SelfData.SubSysop[0])
                  and (sayer <> SelfData.SubSysop[1]) and (sayer <> SelfData.SubSysop[2]) then exit;
            end;

            if ReverseFormat (str, Conv('%s: 攻击%s'), sayer, objectname, str3, 2) then begin
               Bo := GetViewObjectByName (objectname, RACE_HUMAN);
               if Bo = nil then begin BocSay (format (Conv('%s不在。'),[objectname])); exit; end;
               if not (Bo is TUser) then begin BocSay (format (Conv('%s不是使用者。'),[objectname])); exit; end;
               if BO.BasicData.Feature.rfeaturestate = wfs_die then exit;
               SubData.TargetId := BO.BasicData.id;
               for i := 0 to GuildNpcList.Count - 1 do begin
                  GuildNpc := GuildNpcList.Items [i];
                  Bo := GetViewObjectByID (GuildNpc.BasicData.ID);
                  if Bo <> nil then begin
                     GuildNpc.FieldProc (NOTARGETPHONE, FM_GUILDATTACK, BasicData, SubData);
                  end;
               end;
               exit;
            end;
            if ReverseFormat (str, Conv('%s: 停止攻击'), sayer, objectname, str3, 1) then begin
               SubData.TargetId := 0;
               for i := 0 to GuildNpcList.Count - 1 do begin
                  GuildNpc := GuildNpcList.Items [i];
                  GuildNpc.FieldProc (NOTARGETPHONE, FM_GUILDATTACK, BasicData, SubData);
               end;
               exit;
            end;
            if ReverseFormat (str, Conv('%s: 加入成员%s'), sayer, objectname, str3, 2) then begin
               // 2000.09.18 NPC狼 捞抚苞 User狼 捞抚捞 鞍阑锭 八祸坷幅滚弊 荐沥 by Lee.S.G
               // 啊涝篮 RACE_HUMAN俊辑父 蜡瓤窍促
               Bo := GetViewObjectByName (objectname, RACE_HUMAN);
               if Bo = nil then begin BocSay (format (Conv('%s不在。'),[objectname])); exit; end;
               if not (Bo is TUser) then begin BocSay (format (Conv('%s不是玩家。'),[objectname])); exit; end;
               if not TUser(Bo).GuildEnable then begin BocSay (format (Conv('%s不接受任何门派的加入邀请。'),[objectname])); exit; end;
               if TUser(Bo).GuildName = SelfData.Name then begin BocSay (format (Conv('%s已被加入过'),[objectname])); exit; end;
               if TUser(Bo).GuildName <> '' then begin BocSay (format (Conv('%s是别的门派'),[objectname])); exit; end;
               if EXITGUILD_TIME then begin
                    if ExitGuildList.GetExitUser(objectname) then begin BocSay (format (Conv('%s退出其它门派不足3天,无法加入新门派'),[objectname])); exit; end;
               end;
               if TUser(Bo).Name <> SelfData.Sysop then begin
                 TUser(Bo).InviteGuildMaster := sayer;
                 TUser(Bo).GuildAnswerWindow('',format(Conv('%s邀请你加入%s门派'),[sayer,SelfData.Name]));
                 BocSay(format(Conv('正在向%s发送门派邀请'),[objectname]));
               end else begin
                 TUser(Bo).GuildName := SelfData.Name;
                 // 2000.09.16 巩林唱 何巩林狼 啊涝矫 巩颇檬籍狼 郴备己阑 刘啊矫虐扁 困秦
                 // GetUserGrade() 甫 龋免茄促 by Lee.S.G
                 TUser(Bo).GuildGrade := GetUserGrade (objectname);
                 StrPCopy (@TUser(Bo).BasicData.Guild, SelfData.Name);
                 GuildUserList.AddUser (objectname);
                 TUser(Bo).BocChangeProperty;
                 BocSay (format (Conv('加入了%s'),[objectname]));
               end;
            end;
            if ReverseFormat (str, Conv('%s: 逐出%s'), sayer, objectname, str3, 2) then begin
               if objectname = SelfData.Sysop then begin
                    BocSay (format (Conv('门主不能被逐出门派'),[objectname]));
                    Exit;
               end;
               if GuildUserList.DelUser (objectname) then begin
                   ExitGuildList.AddExitUser(TUser(Bo).Name ,GuildName);
                  Logout (objectname);
                  BocSay (format (Conv('脱离%s'),[objectname]));
                  SubData.ServerId := Manager.ServerId;
                  StrPCopy (@SubData.SubName, objectname);
                  StrPCopy (@SubData.GuildName, SelfData.Name);
                  TFieldPhone (Manager.Phone).SendMessage (MANAGERPHONE, FM_REMOVEGUILDMEMBER, BasicData, SubData);

                  // 2000.09.18 NPC狼 捞抚苞 User狼 捞抚捞 鞍阑锭 八祸坷幅滚弊 荐沥 by Lee.S.G
                  // 呕硼绰 RACE_HUMAN俊辑父 蜡瓤窍促
                  {
                  Bo := GetViewObjectByName (objectname, RACE_HUMAN);
                  if Bo = nil then exit;
                  if not (Bo is TUser) then exit;
                  TUser (Bo).GuildName := '';
                  // 2000.09.16 GuildGrade档 窃膊 檬扁拳 矫挪促 by Lee.S.G
                  TUser (Bo).GuildGrade := '';
                  StrPCopy (@TUser (Bo).BasicData.Guild, '');
                  TUser(Bo).BocChangeProperty;
                  }
               end else begin
                  BocSay (format (Conv('%s还没加入'),[objectname]));
               end;
            end;
            if ReverseFormat (str, Conv('%s: %s的职称是%s'), sayer, objectname, gradename, 3) then begin
               {
               if (not isFullHangul (gradename)) or (not isGrammarID(gradename)) or (Length(gradename) > 12) or (Length(gradename) < 2) then begin
                  BocSay ( Conv('错误的职称'));
                  exit;
               end;
               }
               if (CheckPascalString (gradename) = 0) or (Length(gradename) > 12) or (Length(gradename) < 2) then begin
                  BocSay ( Conv('错误的职称'));
                  exit;
               end;

               if GuildUserList.IsGuildUser (objectname) then begin
                  BocSay (format (Conv('获得的职称是%s'),[gradename]));
                  GuildUserList.SetGradeName (objectname, gradename);
               end else begin
                  BocSay (format (Conv('%s还没加入'),[objectname]));
               end;
            end;

            if ReverseFormat (str, Conv('%s: 将%s任命为副门主'), sayer, objectname, str3, 2) then begin
               if sayer <> SelfData.Sysop then exit;
               // 2000.09.18 NPC狼 捞抚苞 User狼 捞抚捞 鞍阑锭 八祸坷幅滚弊 荐沥 by Lee.S.G
               // 何巩林绰 RACE_HUMAN俊辑父 蜡瓤窍促
               Bo := GetViewObjectByName (objectname, RACE_HUMAN);
               if Bo = nil then begin BocSay (format (Conv('%s不在。'),[objectname])); exit; end;
               if not (Bo is TUser) then begin BocSay (format (Conv('%s不是使用者。'),[objectname])); exit; end;
               if TUser (Bo).GuildName <> SelfData.Name then begin BocSay (format (Conv('%s不是门员'),[objectname])); exit; end;

               if (objectname = SelfData.SubSysop[0]) or (objectname = SelfData.SubSysop[1]) or (objectname = SelfData.SubSysop[2]) then begin
                  BocSay (format (Conv('%s已经是副门主'),[objectname]));
                  exit;
               end;

               if (SelfData.SubSysop[0] <> '') and (SelfData.SubSysop[1] <> '') and (SelfData.SubSysop[2] <> '') then begin
                  BocSay (Conv('无法再任命'));
                  BocSay ( format (Conv('副门主是%s, %s, %s'), [SelfData.SubSysop[0],SelfData.SubSysop[1],SelfData.SubSysop[2]]));
                  exit;
               end;

               // 2000.09.20 促弗 巩颇狼 巩林唱 何巩林绰 何巩林肺 烙疙瞪荐 绝促 by Lee.S.G
               SubData.ServerId := Manager.ServerId;
               StrPCopy (@SubData.SubName, objectname);
               StrPCopy (@SubData.GuildName, '');
               if TFieldPhone(Manager.Phone).SendMessage (MANAGERPHONE, FM_ALLOWGUILDSYSOPNAME, BasicData, SubData) = PROC_FALSE then begin
                  BocSay ( Conv('已是其他门派的副门主或门主'));
                  //BocSay ( Conv('已经是'));
                  Exit;
               end;

               if SelfData.SubSysop[0] = '' then begin SelfData.SubSysop[0] := objectname; BocSay(format (Conv('任命%s为副门主'),[objectname])); exit; end;
               if SelfData.SubSysop[1] = '' then begin SelfData.SubSysop[1] := objectname; BocSay(format (Conv('任命%s为副门主'),[objectname])); exit; end;
               if SelfData.SubSysop[2] = '' then begin SelfData.SubSysop[2] := objectname; BocSay(format (Conv('任命%s为副门主'),[objectname])); exit; end;
            end;
            if ReverseFormat (str, Conv('%s: 将副门主%s权力删除'), sayer, objectname, str3, 2) then begin
               if sayer <> SelfData.Sysop then exit;
               if SelfData.SubSysop[0] = objectname then begin SelfData.SubSysop[0] := ''; BocSay(format (Conv('删除%s副门主的权力'),[objectname])); exit; end;
               if SelfData.SubSysop[1] = objectname then begin SelfData.SubSysop[1] := ''; BocSay(format (Conv('删除%s副门主的权力'),[objectname])); exit; end;
               if SelfData.SubSysop[2] = objectname then begin SelfData.SubSysop[2] := ''; BocSay(format (Conv('删除%s副门主的权力'),[objectname])); exit; end;
               BocSay (format (Conv('%s不是副门主'),[objectname]));
            end;

            if ReverseFormat (str, Conv('%s: 门派情报'), str1, str2, str3, 1) then begin
               Str := GetInformation;
               BocSay (Str);
               BocSay (Conv('门派卒兵情报'));
               for i := 0 to GuildNpcList.Count -1 do begin
                  GuildNpc := GuildNpcList.Items [i];
                  str := StrPas(@GuildNpc.BasicData.Name);
                  str := str + '  x:' + IntToStr (GuildNpc.BasicData.X);
                  str := str + '  y:' + IntToStr (GuildNpc.BasicData.Y);
                  BocSay (str);
               end;
               n := SelfData.Durability;
               if n > SelfData.MaxDurability then n := SelfData.MaxDurability;
               BocSay (format (Conv('门派石: %d/%d'),[n, SelfData.MaxDurability]));
               exit;
            end;
         end;
   end;
end;

procedure TGuildObject.Initial (aTeam : String);
var
   i : Integer;
   GuildNpc : TGuildNpc;
   MagicData : TMagicData;
   GuildPos: String;
begin
   inherited Initial (SelfData.Name, SelfData.Name);

   LoadFromFile (SelfData.Name);

   FGuildName := SelfData.Name;
   DuraTick := mmAnsTick;

   AllyGuildStr := aTeam;
   
   // if (SelfData.MaxDurability = 0) or (SelfData.MaxDurability = 110000) then begin
   // SelfData.MaxDurability := MAX_GUILD_DURA;
   // end;

   BasicData.id := GetNewStaticItemId;
   BasicData.x := SelfData.x;
   BasicData.y := SelfData.y;
   BasicData.ClassKind := CLASS_GUILDSTONE;
   BasicData.Feature.rrace := RACE_STATICITEM;
   BasicData.Feature.rImageNumber := 660;
   BasicData.Feature.rImageColorIndex := 0;

   MagicClass.GetMagicData (SelfData.GuildMagic, MagicData, SelfData.MagicExp);
   if MagicData.rName [0] = 0 then begin
      SelfData.GuildMagic := '';
      SelfData.MagicExp := 0;
   end;

   boAddGuildMagic := false;

   GuildEnergy := 0;
   AddGuildDurabilityTick := Now;

   DieGuildNpcList.Clear;
   for i := 0 to MAX_GUILDNPC_COUNT - 1 do begin
      if SelfData.GuildNpc[i].rName = '' then continue;

      GuildNpc := TGuildNpc.Create;
      if Manager <> nil then begin
         GuildNpc.SetManagerClass (Manager);
      end;
      GuildNpc.Initial (Self, SelfData.GuildNpc[i].rName, SelfData.GuildNpc[i].rX, SelfData.GuildNpc[i].rY, SelfData.GuildNpc[i].rSex);

      if (SelfData.GuildMagic <> '') and (boAddGuildMagic = false) then begin
         GuildNpc.boMagicNpc := true;
         StrPCopy (@GuildNpc.BasicData.Guild, SelfData.GuildMagic);
         MagicClass.GetMagicData (SelfData.GuildMagic, GuildNpc.GuildMagicData, SelfData.MagicExp);
         boAddGuildMagic := true;
      end;
      DieGuildNpcList.Add (GuildNpc);
   end;
end;

procedure TGuildObject.StartProcess;
var
   SubData : TSubData;
begin
   inherited StartProcess;

   SubData.EffectNumber := 0;
   SubData.EffectKind := lek_none;
   TFieldPhone(Manager.Phone).RegisterUser (BasicData.id, FieldProc, BasicData.X, BasicData.Y);
   TFieldPhone(Manager.Phone).SendMessage (0, FM_CREATE, BasicData, SubData);
end;

procedure TGuildObject.EndProcess;
var
   i : integer;
   SubData : TSubData;
   GuildNpc : TGuildNpc;
begin
   if FboRegisted = FALSE then exit;

   for i := DieGuildNpcList.Count - 1 downto 0 do begin
      GuildNpc := DieGuildNpcList.Items [i];
      GuildNpc.Free;
      DieGuildNpcList.Delete (i);
   end;

   for i := GuildNpcList.Count - 1 downto 0 do begin
      GuildNpc := GuildNpcList.Items [i];
      GuildNpc.EndProcess;
      GuildNpc.Free;
      GuildNpcList.Delete (i);
   end;

   TFieldPhone(Manager.Phone).SendMessage (0, FM_DESTROY, BasicData, SubData);
   TFieldPhone(Manager.Phone).UnRegisterUser (BasicData.id, BasicData.x, BasicData.y);

   inherited EndProcess;
end;

function TGuildObject.MoveStone (aServerID, ax, ay: integer) : Boolean;
var
   i, nX, nY : integer;
   nIndex : Byte;
   SubData : TSubData;
   tmpManager : TManager;
   GuildNpc : TGuildNpc;
begin
   Result := false;

   if Manager = nil then exit;

   tmpManager := ManagerList.GetManagerByServerID (aServerID);
   if tmpManager = nil then exit;
   if tmpManager.boMakeGuild = false then exit;
   nIndex := TMaper (tmpManager.Maper).GetAreaIndex (aX, aY);
   if nIndex = 0 then exit;
   if AreaClass.CanMakeGuild (nIndex) = false then exit;

   nX := aX; nY := aY;
   // TMaper (tmpManager.Maper).GetMoveableXY (nX, nY, 10);
   // if not TMaper (tmpManager.Maper).isMoveable (nX, nY) then exit;

   TFieldPhone(Manager.Phone).SendMessage (NOTARGETPHONE, FM_DESTROY, BasicData, SubData);
   TFieldPhone(Manager.Phone).UnRegisterUser (BasicData.id, BasicData.x, BasicData.y);

   SelfData.MapID := aServerID;
   SelfData.X := nX; SelfData.Y := nY;
   BasicData.x := nx; BasicData.y := ny;

   SetManagerClass (tmpManager);

   TFieldPhone(Manager.Phone).RegisterUser (BasicData.id, FieldProc, BasicData.X, BasicData.Y);
   TFieldPhone(Manager.Phone).SendMessage (NOTARGETPHONE, FM_CREATE, BasicData, SubData);

   for i := 0 to GuildNpcList.Count - 1 do begin
      GuildNpc := GuildNpcList.Items [i];
      GuildNpc.MoveGuildNpc (aServerID, nX, nY);
   end;

   for i := 0 to DieGuildNpcList.Count - 1 do begin
      GuildNpc := DieGuildNpcList.Items [i];
      GuildNpc.MoveDieGuildNpc (aServerID, nX, nY);
   end;

   Result := true;
end;

function TGuildObject.CreateStone (aSysopName : String; aServerID, ax, ay: integer) : Boolean;
var
   i, nX, nY : integer;
   nIndex : Byte;
   tmpManager : TManager;
   GuildNpc : TGuildNpc;
begin

   Result := false;

   if (aSysopName <> '') and (SelfData.Sysop <> aSysopName) then exit; 

   tmpManager := ManagerList.GetManagerByServerID (aServerID);
   if tmpManager = nil then exit;
   if tmpManager.boMakeGuild = false then exit;
   nIndex := TMaper (tmpManager.Maper).GetAreaIndex (aX, aY);
   if nIndex = 0 then exit;
   if AreaClass.CanMakeGuild (nIndex) = false then exit;

   nX := aX; nY := aY;
   if TMaper (tmpManager.Maper).isGuildStoneArea (nX, nY) = true then exit;
   // TMaper (tmpManager.Maper).GetMoveableXY (nX, nY, 10);
   // if not TMaper (tmpManager.Maper).isMoveable (nX, nY) then exit;

   SelfData.MapID := aServerID;
   SelfData.X := nX; SelfData.Y := nY;
   BasicData.x := nx; BasicData.y := ny;

   SetManagerClass (tmpManager);

   Initial ('');
   StartProcess;

   for i := 0 to GuildNpcList.Count - 1 do begin
      GuildNpc := GuildNpcList.Items [i];
      GuildNpc.MoveGuildNpc (aServerID, nX, nY);
   end;

   for i := 0 to DieGuildNpcList.Count - 1 do begin
      GuildNpc := DieGuildNpcList.Items [i];
      GuildNpc.MoveDieGuildNpc (aServerID, nX, nY);
   end;

end;

function TGuildObject.GetGuildNpcByName (aname: string): integer;
var
   i : integer;
   GuildNpc : TGuildNpc;
begin
   Result := -1;
   for i := 0 to GuildNpcList.Count -1 do begin
      GuildNpc := GuildNpcList.Items [i];
      if GuildNpc.GuildNpcName = aName then begin
         Result := i;
         exit;
      end;
   end;
end;

procedure TGuildObject.ChangeGuildNpcName (aOldName, aNewName : String);
var
   i : integer;
begin
   for i := 0 to MAX_GUILDNPC_COUNT - 1 do begin
      if SelfData.GuildNpc [i].rName = aOldName then begin
         SelfData.GuildNpc [i].rName := aNewName;
         exit;
      end;
   end;
end;

procedure TGuildObject.SetWarAlarm (aName, aStr : String);
var
   boFlag : Boolean;
begin
   boFlag := false;

   if isGuildSysop (aName) then boFlag := true;
   if boFlag = false then begin
      if isGuildSubSysop (aName) then boFlag := true; 
   end;

   if boFlag = false then exit;
   
   FWarAlarmStr := aStr;
   FWarAlarmTick := mmAnsTick;
   FWarAlarmStartTick := mmAnsTick;
end;

procedure  TGuildObject.SetStonePos (X, Y : integer);
begin


end;

function TGuildObject.AddAllyGuild (aName : String) : String;
var
   i : Integer;
   SubData : TSubData;
begin
   Result := '';

   if aName = '' then begin
      Result := Conv('没有指定门派名');
      exit;
   end;
   
   for i := 0 to AllyGuild.Count - 1 do begin
      if AllyGuild.Strings [i] = aName then begin
         Result := Conv('已有结盟关系');
         exit;
      end;
   end;

   StrPCopy (@SubData.GuildName, GuildName);
   if GuildList.FieldProc (aName, FM_AGREEALLYGUILD, BasicData, SubData) = 0 then begin
      Result := Conv('没有注册的门派');
      exit;
   end;
end;

function TGuildObject.DelAllyGuild (aName : String) : String;
var
   i : Integer;
   SubData : TSubData;
begin
   Result := '';
   for i := 0 to AllyGuild.Count - 1 do begin
      if AllyGuild.Strings [i] = aName then begin
         StrPCopy (@SubData.GuildName, aName); 
         GuildList.FieldProc (GuildName, FM_DELALLYGUILD, BasicData, SubData);
         StrPCopy (@SubData.GuildName, GuildName);
         GuildList.FieldProc (aName, FM_DELALLYGUILD, BasicData, SubData);
         exit;
      end;
   end;

   Result := Conv('没有设定结盟关系');
end;

function TGuildObject.GetAllyGuildName (aIndex : Integer) : String;
begin
   Result := '';

   if (aIndex < 0) or (aIndex >= AllyGuild.Count) then exit;

   Result := AllyGuild.Strings [aIndex];
end;

procedure TGuildObject.Update (CurTick: integer);
var
   i, nX, nY : integer;
   GuildNpc : TGuildNpc;
begin
   if FGuildName = '' then begin
      if CreateTick + 3 * 60 * 100 < CurTick then begin
         FboAllowDelete := TRUE;
      end;
   end;
  // add by Orber at 2005-01-17 10:12:28
  // 门派解散
   if GuildDestory then begin
        if Now - GuildDestoryTime > 3 then begin
            UserList.GuildSay(GuildName,GuildName + Conv('门派被解散了'));
            GuildList.DeleteStone(GuildName);
        end;
   end;
   // 2000.09.18 巩颇器凉捞 昏力登绰 泅惑阑 阜扁困秦 刚历 昏力窍绊
   // 第捞绢 官肺 积己茄促 by Lee.S.G
   for i := GuildNpcList.Count - 1 downto 0 do begin
      GuildNpc := GuildNpcList.Items [i];
      if GuildNpc.boAllowDelete then begin
         GuildNpc.EndProcess;
         GuildNpcList.Delete (i);
         DieGuildNpcList.Add (GuildNpc);
      end;
   end;

   {
   for i := 0 to 5 - 1 do begin
      nName := GuildNpcDataClass.GuildNpcDataArr[i].rname;
      if nname = '' then continue;

      ret := GetGuildNpcByName (nname);
      if ret = -1 then begin
         xx := GuildNpcDataClass.GuildNpcDataArr[i].rx;
         yy := GuildNpcDataClass.GuildNpcDataArr[i].ry;

         tempx := 0; tempy := 0;
         if not TMaper(Manager.Maper).IsMoveable (xx, yy) then begin
            for j := 0 to 32 do begin
               GetNearPosition (tempx, tempy);
               if TMaper(Manager.Maper).isMoveable (xx + tempx, yy + tempy) then begin
                  break;
               end;
            end;
            if not TMaper(Manager.Maper).isMoveable (xx + tempx, yy + tempy) then begin
               tempx := 0; tempy := 0;
            end;
         end;

         GuildNpc := TGuildNpc.Create;
         GuildNpc.SetManagerClass (Manager);
         GuildNpc.StartX := xx;
         GuildNpc.StartY := yy;
         GuildNpc.Initial (TBasicObject(Self), nname, xx+tempx, yy+tempy);
         GuildNpc.GuildNpcDataClass := GuildNpcDataClass;

         if (GuildMagicName <> '') and (i = 0) then begin
            GuildNpc.boMagicNpc := TRUE;
            StrPcopy (@GuildNpc.BasicData.Guild, GuildMagicName);
            MagicClass.GetMagicData (GuildMagicName, GuildNpc.GuildMagicData, GuildMagicExp);
         end;

         GuildNpc.StartProcess;
         // 2000.09.16 巩颇器凉吝 巩颇公傍捞 瘤沥等 器凉狼 困摹啊 函窍绰巴阑
         // 阜扁 困秦 TAnsList俊 Insert Method甫 眠啊窍绊 巩颇器凉狼 积己矫
         // 霉锅掳 器凉篮 府胶飘狼 急滴俊 火涝茄促 by Lee.S.G
         // AnsList.Add (GuildNpc);
         if i = 0 then GuildNpcList.Insert (0, GuildNpc)
         else GuildNpcList.Add (GuildNpc);
      end;
   end;
   }

   if (Manager <> nil) and (DieGuildNpcList.Count > 0) then begin
      for i := DieGuildNpcList.Count - 1 downto 0 do begin
         GuildNpc := DieGuildNpcList.Items [i];
         nX := GuildNpc.StartX - 3 + Random (6);
         nY := GuildNpc.StartY - 3 + Random (6);
         TMaper (Manager.Maper).GetMoveableXY (nX, nY, 10);
         if TMaper (Manager.Maper).isMoveable (nX, nY) then begin
            GuildNpc.BasicData.X := nX;
            GuildNpc.BasicData.Y := nY;
            GuildNpc.StartProcess;
            GuildNpcList.Add (GuildNpc);
            DieGuildNpcList.Delete (i);
         end;
      end;
   end;

   for i := 0 to GuildNpcList.Count - 1 do begin
      GuildNpc := GuildNpcList.Items [i];
      GuildNpc.Update (CurTick);
   end;

  // add by Orber at 2005-06-17 11:42:16
   //取消门石自动掉血
   {if CurTick > DuraTick + DEC_GUILD_DURA_TICK then begin
      DuraTick := CurTick;
      Dec (SelfData.Durability);
      if boShowGuildDuraValue then begin
         BocSay (IntToStr(SelfData.Durability) + '/' + IntToStr (SelfData.MaxDurability));
      end;
   end;}

   if (FWarAlarmStr <> '') and (CurTick > FWarAlarmTick + 1000) then begin
      UserList.GuildSay (SelfData.Name, SelfData.Name + ': ' + format ('%s', [FWarAlarmStr]));
      FWarAlarmTick := CurTick;
      if CurTick > FWarAlarmStartTick + 18000 then begin
         FWarAlarmTick := 0;
         FWArAlarmSTartTick := 0;
         FWarAlarmStr := '';
      end;
   end;
end;

procedure TGuildObject.Login (aName : String);
begin
   if aName = SelfData.Sysop then begin
      FboLoginSysop := true;
      exit;
   end;
   Inc (FLoginUserCount);
end;

procedure TGuildObject.Logout (aName : String);
var i :integer;
begin
   if aName = SelfData.Sysop then begin
      FboLoginSysop := false;
      exit;
   end;

   Dec (FLoginUserCount);
end;

procedure TGuildObject.AddUser (aName : String);
begin
    GuildUserList.AddUser(aName);
end;

function TGuildObject.MakeGuildLetterFile (aName : String) : String;
var
   StrList : TStringList;
begin
   Result := '';
   StrList := nil;
   try
      StrList := TStringList.Create;
      StrList.Add ('<guild>');
      StrList.Add ('<head>');
      StrList.Add (Conv('<title>门人推鉴书</title>'));
      StrList.Add ('<text>');
      StrList.Add (format (Conv('我是老侠客. %s门派希望 %s成为它的门人'), [GuildName, aName]));
      StrList.Add (Conv('恭喜你'));  
      StrList.Add ('</text>');
      StrList.Add ('</head>');
      StrList.Add ('<body>');
      StrList.Add (format (Conv('请去寻找 %s门派'), [GuildName]));
      StrList.Add (format (Conv('在长城以南(%d,%d)的座标'), [BasicData.X, BasicData.Y]));
      StrList.Add (Conv('把门人推鉴书拖到门石处就可加入为门人'));
      StrList.Add ('</body>');
      StrList.Add ('</guild>');
      Result := StrList.Text;
      //StrList.SaveToFile ('.\Help\guildletter.txt');
   finally
      if StrList <> nil then StrList.Free;
   end;
end;


////////////////////////////////////////////////////
//
//             ===  GuildList  ===
//
////////////////////////////////////////////////////

constructor TGuildList.Create;
begin
   inherited Create ('GUILD', nil);

   LoadFromFile ('.\Guild\CreateGuild.SDB');
end;

destructor TGuildList.Destroy;
begin
   SaveToFile ('.\Guild\CreateGuild.SDB');
   Clear;
   
   inherited Destroy;
end;

function TGuildList.GetUserGrade (aGuildName, uName: String): string;
var
   i : integer;
   GuildObject : TGuildObject;
begin
   Result := '';
   for i := 0 to DataList.Count - 1 do begin
      GuildObject := DataList.Items [i];
      if GuildObject.GuildName = aGuildName then begin
         Result := GuildObject.GetUserGrade (uname);
         exit;
      end;
   end;
end;

function TGuildList.GetGuildServerID (aGuildName : String): Integer;
var
   i : integer;
   GuildObject : TGuildObject;
begin
   Result := -1;
   for i := 0 to DataList.Count - 1 do begin
      GuildObject := DataList.Items [i];
      if GuildObject.GuildName = aGuildName then begin
         if GuildObject.boAllowDelete = false then begin
            Result := GuildObject.SelfData.MapID;
            exit;
         end;
      end;
   end;
end;

function TGuildList.IsGuildSysop (aGuildName , aName:String): Boolean;
var
    GuildObject : TGuildObject;
begin
               result := False;
               GuildObject := GetGuildObject (aGuildName);
               if GuildObject <> nil then begin
                  result := GuildObject.IsGuildSysop (aName);
               end;
end;

function TGuildList.isGuildType (aGuildType : Byte) : Boolean;
var
   i : integer;
    GuildObject : TGuildObject;
begin
    result := False;

   for i := 0 to DataList.Count -1 do begin
      GuildObject := DataList.Items [i];
      if GuildObject.GuildType = aGuildType then begin
         Result := True;
         Break;
      end;
   end;
end;

procedure TGuildList.GetGuildInfo (aGuildName: string; aUser: TUser);
var
   i : integer;
   GuildObject : TGuildObject;
begin
   for i := 0 to DataList.Count -1 do begin
      GuildObject := DataList.Items [i];
      if GuildObject.GuildName = aGuildName then begin
         GuildObject.GetGuildInfo (aUser);
         exit;
      end;
   end;
end;

function TGuildList.CheckGuildUser (aGuildName, aName : String) : Boolean;
var
   i : integer;
   GuildObject : TGuildObject;
begin
   Result := FALSE;
   for i := 0 to DataList.Count - 1 do begin
      GuildObject := DataList.Items [i];
      if GuildObject.GuildName <> aGuildName then continue;
      if GuildObject.IsGuildUser(aName) = true then begin
         Result := TRUE;
         exit;
      end;
   end;
end;

procedure TGuildList.AllowGuildName (gid: integer; aboAllow: Boolean; aGuildName, aSysopName: string);
var
   i,j : integer;
   pd : PTCreateGuildData;
   GuildObject,GuildObject1: TGuildObject;
   Stream : TFileStream;
   aFileName :String;
   GuildItemLog :TGuildItemLogRecord;
   aUser : TUser;
   ItemData:TItemData;
   ItemName :String;
   GuildInfo : TSGuildListInfo;
begin
   for i := 0 to DataList.Count - 1 do begin
      GuildObject := DataList.Items [i];
      if GuildObject.BasicData.id = gid then begin
         if aboAllow = true then begin
            pd := GuildObject.GetSelfData;
            GuildObject.BocSay (format (Conv('门派名称是 %s'),[aGuildName]));
            pd^.Sysop := aSysopName;
            StrPCopy (@GuildObject.BasicData.Name, aGuildName);
            StrPCopy (@GuildObject.BasicData.ViewName, aGuildName);
            pd^.Title := aGuildName;
            pd^.Name := aGuildName;
            GuildObject.FGuildName := aGuildName;
            GuildObject.BocChangeFeature;
            pd^.MakeDate := DateToStr (Date);
            // add by Orber at 2005-01-05 14:53:33
            case GuildObject.GuildType of
              50..54:
                begin
                    GuildObject.Bank := 5000000;
                    GuildObject.SetGuildDurability(MAX_GUILD_STONE1);
                end;
              55..57:
                begin
                    GuildObject.Bank := 8000000;
                    GuildObject.SetGuildDurability(MAX_GUILD_STONE2);
                end;
              58..59:
                begin
                    GuildObject.Bank := 10000000;
                    GuildObject.SetGuildDurability(MAX_GUILD_STONE3);
                end;
            end;
            for j := 0 to GuildList.Count -1 do begin
                GuildObject1 := GuildList.GetObjectByID(j);
                Move(GuildObject1.BasicData.Name,GuildInfo.rGuildName[GuildObject1.GuildType-50],SizeOf(GuildObject1.BasicData.Name));
                GuildInfo.rGuildID[GuildObject1.GuildType-50] := GuildObject1.GuildType;
            end;
            UserList.SendGuildInfo(GuildInfo);
             aFileName := '.\Guild\' + aGuildName + '_ITEMLOG.BIN';
             if FileExists (    aFileName) then DeleteFile (aFileName);
             try
               Stream := TFileStream.Create (aFileName, fmCreate);
               FillChar(GuildItemLog,SizeOf(GuildItemLog),0);
               StrPCopy(@GuildItemLog.GuildName,aGuildName);
               Stream.WriteBuffer(GuildItemLog,SizeOf(GuildItemLog));
               Stream.Free;
             except
                exit;
             end;

         end else begin
            GuildObject.BocSay (Conv('无法成立门派。'));
         end;
         exit;
      end;
   end;
end;

function TGuildList.AllowGuildCondition (gname, uname: string): Boolean;
var
   i, j : integer;
   pd : PTCreateGuildData;
   GuildObject: TGuildObject;
begin
   Result := TRUE;
   for i := 0 to DataList.Count -1 do begin
      GuildObject := DataList.Items [i];
      pd := GuildObject.GetSelfData;
      if pd^.Name = '' then continue;
      if pd^.Name = gname then begin Result := FALSE; exit; end;
      if pd^.Sysop = uname then begin Result := FALSE; exit; end;
      for j := 0 to MAX_SUBSYSOP_COUNT - 1 do begin
         if pd^.SubSysop[j] = uname then begin
            Result := FALSE;
            exit;
         end;
      end;
   end;
end;

function  TGuildList.MoveStone (aGuildName : String; aServerID, ax, ay: integer) : Boolean;
var
   i : integer;
   GuildObject : TGuildObject;
begin
   Result := false;
   for i := 0 to DataList.Count -1 do begin
      GuildObject := DataList.Items [i];
      if GuildObject.GuildName = aGuildName then begin
         Result := GuildObject.MoveStone (aServerID, ax, ay);
         exit;
      end;
   end;
end;

function TGuildList.CreateStone (aGuildName, aSysopName : String; aServerID, ax, ay: integer) : Boolean;
var
   i : integer;
   GuildObject : TGuildObject;
begin
   Result := false;
   for i := 0 to DataList.Count -1 do begin
      GuildObject := DataList.Items [i];
      if GuildObject.SelfData.Name = aGuildName then begin
         if GuildObject.boRegisted = false then begin
            Result := GuildObject.CreateStone (aSysopName, aServerID, ax, ay);
         end;
         exit;
      end;
   end;
end;

function TGuildList.AddGuildObject (aGuildName, aOwnerName : String; aServerID, aX, aY,aGuildType: integer): TGuildObject;
var
   Manager : TManager;
   GuildObject : TGuildObject;
   pd : PTCreateGuildData;
begin
   GuildObject := TGuildObject.Create;

   pd := GuildObject.GetSelfData;
   pd^.Name := aGuildName;
   pd^.MapID := aServerID;
   pd^.X := aX;
   pd^.Y := aY;
   pd^.Durability := MAX_GUILD_DURA + 100000;
   pd^.MaxDurability := MAX_GUILD_DURA;
   pd^.Sysop := aOwnerName;
   
   Manager := ManagerList.GetManagerByServerID (aServerID);
   GuildObject.SetManagerClass (Manager);
   GuildObject.Initial ('');
   GuildObject.StartProcess;
   GuildObject.GuildType := aGuildType;
   DataList.Add (GuildObject);
   
   Result := GuildObject;
end;

function TGuildList.GetGuildByType (nGuildType : Byte): TGuildObject;
var i :integer;
    GuildObject : TGuildObject;
begin
    result := nil;
    for i := 0 to DataList.Count - 1 do begin
        if TGuildObject(DataList.Items[i]).GuildType = nGuildType then begin
            GuildObject := DataList.Items[i];
            result := GuildObject;
            Break;
        end;
    end;
end;

procedure TGuildList.LoadFromFile (aFileName : String);
var
   i, j : Integer;
   str, rdstr : string;
   iName, AllyGuildStr : string;
   pd : PTCreateGuildData;
   DB : TUserStringDb;
   Manager : TManager;
   GuildObject : TGuildObject;
begin
   if not FileExists (aFileName) then exit;

   DB := TUserStringDb.Create;
   DB.LoadFromFile (aFileName);

   for i := 0 to Db.Count - 1 do begin
      iName := Db.GetIndexName (i);
      if iName = '' then continue;

      GuildObject := TGuildObject.Create;
      pd := GuildObject.GetSelfData;

      FillChar (pd^, SizeOf(TCreateGuildData), 0);

      pd^.Name := iName;
      pd^.Title := Db.GetFieldValueString (iName, 'Title');
      pd^.MapID := Db.GetFieldValueInteger (iName, 'MapID');
      pd^.x := Db.GetFieldValueInteger (iname, 'X');
      pd^.y := Db.GetFieldValueInteger (iname, 'Y');
      pd^.Durability := Db.GetFieldValueInteger (iName, 'Durability');
      pd^.MaxDurability := Db.GetFieldValueInteger (iName, 'MaxDurability');
      pd^.GuildMagic := Db.GetFieldValueString (iName, 'GuildMagic');
      pd^.MagicExp := Db.GetFieldValueInteger (iName, 'MagicExp');
      pd^.MakeDate := Db.GetFieldValueString (iName, 'MakeDate');
      pd^.Sysop := Db.GetFieldValueString (iname, 'Sysop');
      for j := 0 to MAX_SUBSYSOP_COUNT - 1 do begin
         pd^.SubSysop[j] := Db.GetFieldValueString (iName, 'SubSysop' + IntToStr (j));
      end;
      for j := 0 to MAX_GUILDNPC_COUNT - 1 do begin
         str := Db.GetFieldValueString (iName, 'Npc' + IntToStr(j));
         str := GetValidStr3 (str, rdstr, ':');
         pd^.GuildNpc[j].rName := rdstr;
         str := GetValidStr3 (str, rdstr, ':');
         pd^.GuildNpc[j].rx := _StrToInt (rdstr);
         str := GetValidStr3 (str, rdstr, ':');
         pd^.GuildNpc[j].ry := _StrToInt (rdstr);
         str := GetValidStr3 (str, rdstr, ':');
         pd^.GuildNpc[j].rSex := _StrToInt (rdstr);
      end;
      for j := 0 to MAX_GUILDWEAR_COUNT - 1 do begin
         str := Db.GetFieldValueString (iName, 'Wear0');
         str := GetValidStr3 (str, rdstr, ':');
         StrPCopy (@pd^.GuildWear[j].rName, rdstr);
         str := GetValidStr3 (str, rdstr, ':');
         pd^.GuildWear[j].rColor := _StrToInt (rdstr);
         str := GetValidStr3 (str, rdstr, ':');
         pd^.GuildWear[j].rCount := _StrToInt (rdstr);
      end;

      pd^.BasicPoint := Db.GetFieldValueInteger (iName, 'BasicPoint');
      pd^.AwardPoint := Db.GetFieldValueInteger (iName, 'AwardPoint');
      pd^.BattleRejectCount := Db.GetFieldValueInteger (iName, 'BattleRejectCount');
      pd^.ChallengeGuild := Db.GetFieldValueString (iName, 'ChallengeGuild');
      pd^.ChallengeGuildUser := Db.GetFieldValueString (iName, 'ChallengeGuildUser');
      pd^.ChallengeDate := Db.GetFieldValueString (iName, 'ChallengeDate');
      AllyGuildStr := Db.GetFieldValueString (iName, 'AllyGuild');
      GuildObject.rBoBank := Db.GetFieldValueBoolean (iName, 'rboBank');
      GuildObject.Bank := Db.GetFieldValueInteger (iName, 'Bank');
      GuildObject.GuildType := Db.GetFieldValueInteger(iName, 'GuildType');
      GuildObject.GuildEnergy := Db.GetFieldValueInteger(iName, 'GuildEnergy');
      GuildObject.GuildDestory := Db.GetFieldValueBoolean(iName,'Destory');
      GuildObject.GuildDestoryTime := StrToDateTime(Db.GetFieldValueString(iName,'DestoryTime'));
      Manager := ManagerList.GetManagerByServerID (pd^.MapID);
      if Manager <> nil then begin
         GuildObject.SetManagerClass (Manager);
         GuildObject.Initial (AllyGuildStr);
         GuildObject.StartProcess;
      end else begin
         GuildObject.Initial (AllyGuildStr);
      end;
      DataList.Add (GuildObject);
   end;

   for i := 0 to DataList.Count - 1 do begin
      GuildObject := DataList.Items [i];
      if GuildObject.AllyGuildStr <> '' then begin
         Str := GuildObject.AllyGuildStr;
         while Str <> '' do begin
            Str := GetValidStr3 (Str, rdStr, ':');
            if rdStr <> '' then begin
               if GetInformation (rdStr) <> '' then begin
                  GuildObject.AllyGuild.Add (rdStr);
               end;
            end;
         end;
      end;
   end;

   DB.Free;
end;

procedure TGuildList.SaveToFile (aFileName : String);
var
   i, j : integer;
   str : string;
   pd : PTCreateGuildData;
   GuildObject : TGuildObject;
   DB : TUserStringDb;
   Stream :TFileStream;
begin
   if not FileExists (aFileName) then exit;

   Db := TUserStringDb.Create;
   Db.LoadFromFile (aFileName);

   for i := 0 to Db.Count - 1 do begin
      Db.DeleteName (Db.GetIndexName (0));
   end;

   for i := 0 to DataList.Count - 1 do begin
      GuildObject := DataList.Items [i];
      pd := GuildObject.GetSelfData;
      if pd^.Name = '' then continue;

      GuildObject.SaveToFile;

      Db.AddName (pd^.Name);
      Db.SetFieldValueString (pd^.Name, 'Title', pd^.Title);
      Db.SetFieldValueInteger (pd^.Name, 'MapID', pd^.MapID);
      Db.SetFieldValueInteger (pd^.Name, 'X', pd^.x);
      Db.SetFieldValueInteger (pd^.Name, 'Y', pd^.y);
      Db.SetFieldValueInteger (pd^.Name, 'Durability', pd^.Durability);
      Db.SetFieldValueInteger (pd^.Name, 'MaxDurability', pd^.MaxDurability);
      Db.SetFieldValueString (pd^.Name, 'GuildMagic', pd^.GuildMagic);
      Db.SetFieldValueInteger (pd^.Name, 'MagicExp', pd^.MagicExp);
      Db.SetFieldValueString (pd^.Name, 'MakeDate', pd^.MakeDate);
      Db.SetFieldValueString (pd^.Name, 'Sysop', pd^.Sysop);
      for j := 0 to MAX_SUBSYSOP_COUNT - 1 do begin
         Db.SetFieldValueString (pd^.Name, 'SubSysop' + IntToStr (j), pd^.SubSysop[j]);
      end;
      for j := 0 to MAX_GUILDNPC_COUNT - 1 do begin
         str := pd^.GuildNpc[j].rName + ':';
         str := str + IntToStr (pd^.GuildNpc[j].rx) + ':';
         str := str + IntToStr (pd^.GuildNpc[j].ry) + ':';
         str := str + IntToStr (pd^.GuildNpc[j].rSex) + ':';
         if pd^.GuildNpc[j].rName = '' then str := '';
         Db.SetFieldValueString (pd^.Name, 'Npc' + IntToStr(j), str);
      end;
      for j := 0 to MAX_GUILDWEAR_COUNT - 1 do begin
         str := '';
         if pd^.GuildWear[j].rName [0] <> 0 then begin
            str := StrPas (@pd^.GuildWear[j].rName) + ':';
            str := str + IntToStr (pd^.GuildWear[j].rColor) + ':';
            str := str + IntToStr (pd^.GuildWear[j].rCount) + ':';
         end;
         Db.SetFieldValueString (pd^.Name, 'Wear' + IntToStr(j), str);
      end;
      Db.SetFieldValueInteger (pd^.Name, 'BasicPoint', pd^.BasicPoint);
      Db.SetFieldValueInteger (pd^.Name, 'AwardPoint', pd^.AwardPoint);
      Db.SetFieldValueInteger (pd^.Name, 'BattleRejectCount', pd^.BattleRejectCount);
      Db.SetFieldValueString (pd^.Name, 'ChallengeGuild', pd^.ChallengeGuild);
      Db.SetFieldValueString (pd^.Name, 'ChallengeGuildUser', pd^.ChallengeGuildUser);
      Db.SetFieldValueString (pd^.Name, 'ChallengeDate', pd^.ChallengeDate);
      Db.SetFieldValueString (pd^.Name, 'AllyGuild', GuildObject.AllyGuildStr);
  // add by Orber at 2005-01-12 05:05:25
      Db.SetFieldValueBoolean (pd^.Name, 'rBoBank', GuildObject.rBoBank);
      Db.SetFieldValueInteger (pd^.Name, 'Bank', GuildObject.Bank);
      Db.SetFieldValueInteger (pd^.Name, 'GuildType', GuildObject.GuildType);
      Db.SetFieldValueInteger (pd^.Name, 'GuildEnergy', GuildObject.GuildEnergy);
      Db.SetFieldValueBoolean (pd^.Name, 'Destory', GuildObject.GuildDestory);
      Db.SetFieldValueString (pd^.Name, 'DestoryTime', DateTimeToStr(GuildObject.GuildDestoryTime));

       try
         Stream := TFileStream.Create ('.\Guild\' + pd^.Name + '_ITEMLOG.BIN', fmCreate);
         Stream.WriteBuffer(GuildObject.FGuildItemLog,SizeOf(GuildObject.FGuildItemLog));
         Stream.Free;
       except
          exit;
       end;
   end;

   Db.SaveToFile ('.\Guild\CreateGuild.SDB');
   Db.Free;

end;

procedure TGuildList.SaveToFileForWeb (aFileName : String);
var
   i, j : integer;
   Str, rdStr : string;
   buffer : array [0..1024 - 1] of Char;
   pd : PTCreateGuildData;
   GuildObject : TGuildObject;
   Stream : TFileStream;
begin
   Stream := nil;

   try
      if FileExists (aFileName) then DeleteFile (aFileName);

      Stream := TFileStream.Create (aFileName, fmCreate);

      Str := 'Name,X,Y,Sysop,SubSysop0,SubSysop1,SubSysop2,Durability,GuildMagic,MakeDate,MagicExp,Npc0,Npc1,Npc2,Npc3,Npc4,Title,MapID,MaxDurability,Wear0,Wear1,BasicPoint,AwardPoint,BattleRejectCount,ChallengeGuild,ChallengeGuildUser,ChallengeDate,AllyGuild';
      StrPCopy (@buffer, Str + #13#10);
      Stream.WriteBuffer (buffer, StrLen (@buffer));

      for i := 0 to DataList.Count - 1 do begin
         GuildObject := DataList.Items [i];
         pd := GuildObject.GetSelfData;
         if pd^.Name = '' then continue;

         Str := pd^.Name + ',';
         Str := Str + IntToStr (pd^.x) + ',';
         Str := Str + IntToStr (pd^.y) + ',';
         Str := Str + pd^.Sysop + ',';
         for j := 0 to MAX_SUBSYSOP_COUNT - 1 do begin
            Str := Str + pd^.SubSysop[j] + ',';
         end;
         Str := Str + IntToStr (pd^.Durability) + ',';
         Str := Str + pd^.GuildMagic + ',';
         Str := Str + pd^.MakeDate + ',';
         Str := Str + IntToStr (pd^.MagicExp) + ',';

         for j := 0 to MAX_GUILDNPC_COUNT - 1 do begin
            rdStr := pd^.GuildNpc[j].rName + ':';
            rdstr := rdstr + IntToStr (pd^.GuildNpc[j].rx) + ':';
            rdstr := rdstr + IntToStr (pd^.GuildNpc[j].ry) + ':';
            rdstr := rdstr + IntToStr (pd^.GuildNpc[j].rSex) + ':';
            if pd^.GuildNpc[j].rName = '' then rdStr := '';
            Str := Str + rdStr + ',';
         end;

         Str := Str + pd^.Title + ',';
         Str := Str + IntToStr (pd^.MapID) + ',';
         Str := Str + IntToStr (pd^.MaxDurability) + ',';

         for j := 0 to MAX_GUILDWEAR_COUNT - 1 do begin
            rdstr := '';
            if pd^.GuildWear[j].rName [0] <> 0 then begin
               rdstr := StrPas (@pd^.GuildWear[j].rName) + ':';
               rdstr := rdstr + IntToStr (pd^.GuildWear[j].rColor) + ':';
               rdstr := rdstr + IntToStr (pd^.GuildWear[j].rCount) + ':';
            end;
            Str := Str + rdStr + ',';
         end;

         Str := Str + IntToStr (pd^.BasicPoint) + ',';
         Str := Str + IntToStr (pd^.AwardPoint) + ',';
         Str := Str + IntToStr (pd^.BattleRejectCount) + ',';
         Str := Str + pd^.ChallengeGuild + ',';
         Str := Str + pd^.ChallengeGuildUser + ',';
         Str := Str + pd^.ChallengeDate + ',';
         Str := Str + GuildObject.AllyGuildStr;

         StrPCopy (@buffer, Str + #13#10);
         Stream.WriteBuffer (buffer, StrLen (@buffer));
      end;
   finally
      if Stream <> nil then Stream.Free;
   end;
end;

function TGuildList.GetObjectByID(GuildObjectID : Integer) : TGuildObject;
begin
    Result := GuildList.DataList[GuildObjectID];
end;

procedure TGuildList.CompactGuild;
var
   i : Integer;
   GuildObject : TGuildObject;
   Str, iName : String;
   buffer : array [0..4096 - 1] of char;
   DB : TUserStringDB;
   Stream : TFileStream;
begin
   if not FileExists ('.\Guild\DeletedGuild.SDB') then begin
      Str := 'Index,DeletedDate,Name,Durability,X,Y,Sysop,SubSysop0,SubSysop1,SubSysop2,GuildMagic,MakeDate,MagicExp' + #13#10;
      StrPCopy (@buffer, Str);
      Stream := TFileStream.Create ('.\Guild\DeletedGuild.SDB', fmCreate);
      Stream.WriteBuffer (buffer, StrLen (@buffer));
      Stream.Free;
   end;

   DB := TUserStringDB.Create;
   DB.LoadFromFile ('.\Guild\DeletedGuild.SDB');

   for i := 0 to DataList.Count - 1 do begin
      GuildObject := DataList.Items [i];
      if GuildObject.GuildName = '' then continue;
      if GuildObject.SelfData.Durability <= 0 then begin
         iName := IntToStr (DB.Count);
         DB.AddName (iName);
         DB.SetFieldValueString (iName, 'DeletedDate', DateToStr (Date));
         DB.SetFieldValueString (iName, 'Name', GuildObject.GuildName);
         DB.SetFieldValueInteger (iName, 'Durability', GuildObject.SelfData.Durability);
         DB.SetFieldValueInteger (iName, 'X', GuildObject.SelfData.X);
         DB.SetFieldValueInteger (iName, 'Y', GuildObject.SelfData.Y);
         DB.SetFieldValueString (iName, 'Sysop', GuildObject.SelfData.Sysop);
         DB.SetFieldValueString (iName, 'SubSysop0', GuildObject.SelfData.SubSysop [0]);
         DB.SetFieldValueString (iName, 'SubSysop1', GuildObject.SelfData.SubSysop [1]);
         DB.SetFieldValueString (iName, 'SubSysop2', GuildObject.SelfData.SubSysop [2]);
         DB.SetFieldValueString (iName, 'GuildMagic', GuildObject.SelfData.GuildMagic);
         DB.SetFieldValueString (iName, 'MakeDate', GuildObject.SelfData.MakeDate);
         DB.SetFieldValueInteger (iName, 'MagicExp', GuildObject.SelfData.MagicExp);
         GuildObject.FGuildName := '';
         GuildObject.boAllowDelete := true;
         try DeleteFile ('.\Guild\' + GuildObject.GuildName + 'GUser.SDB'); except end;
      end;
   end;

   DB.SaveToFile ('.\Guild\DeletedGuild.SDB');
   DB.Free;

   MagicClass.CompactGuildMagic;
end;

procedure TGuildList.DeleteStone (aGuildName : String);
var
   i,j : Integer;
   GuildObject : TGuildObject;
   GuildInfo : TSGuildListInfo;
begin
   for i := 0 to DataList.Count - 1 do begin
      GuildObject := DataList.Items [i];
      if GuildObject.GuildName = aGuildName then begin
         GuildObject.SelfData.Durability := 0;
         CompactGuild;
            for j := 0 to GuildList.Count -1 do begin
                GuildObject := GuildList.GetObjectByID(j);
                Move(GuildObject.FGuildName,GuildInfo.rGuildName[GuildObject.GuildType-50],SizeOf(GuildObject.BasicData.Name));
                GuildInfo.rGuildID[GuildObject.GuildType-50] := GuildObject.GuildType;
            end;
            UserList.SendGuildInfo(GuildInfo);
         exit;
      end;
   end;
end;

function TGuildList.GetBestGuild : String;
var
   i, iRandom : Integer;
   GuildObject : TGuildObject;
   StrList : TStringList;
begin
   Result := '';
   if DataList.Count = 0 then exit;
   StrList := TStringList.Create;
   for i := 0 to DataList.Count - 1 do begin
      GuildObject := DataList.Items [i];
      if GuildObject.GuildName = '' then continue;
      if GuildObject.FboLoginSysop = true then begin
         if GuildObject.FLoginUserCount >= 5 then begin
            StrList.Add (GuildObject.GuildName);
         end;
      end;
   end;

   if StrList.Count = 0 then begin
      iRandom := Random (DataList.Count);
      GuildObject := DataList.Items [iRandom];
      Result := GuildObject.GuildName;
   end else begin
      iRandom := Random (StrList.Count);
      Result := StrList.Strings [iRandom];
   end;

   StrList.Free;
end;

function TGuildList.GetGuildObject (aGuildName : String) : TGuildObject;
var
   i : Integer;
   GuildObject : TGuildObject;
begin
   Result := nil;
   for i := 0 to DataList.Count - 1 do begin
      GuildObject := DataList.Items [i];
      if GuildObject.GuildName = aGuildName then begin
         Result := GuildObject;
         exit;
      end;
   end;
end;

function TGuildList.GetGuildObjectByMagicName (aMagicName : String) : TGuildObject;
var
   i : Integer;
   GuildObject : TGuildObject;
begin
   Result := nil;
   for i := 0 to DataList.Count - 1 do begin
      GuildObject := DataList.Items [i];
      if GuildObject.SelfData.GuildMagic = aMagicName then begin
         Result := GuildObject;
         exit;
      end;
   end;
end;

function TGuildList.GetCharInformation (aName : String) : String;
var
   i, j : Integer;
   GuildObject : TGuildObject;
begin
   Result := '';

   for i := 0 to DataList.Count - 1 do begin
      GuildObject := DataList.Items [i];
      if GuildObject.GuildName = '' then continue;
      if GuildObject.SelfData.Sysop = aName then begin
         Result := format (Conv('%s门派的门主'), [GuildObject.GuildName]);
         exit;
      end;
      for j := 0 to 3 - 1 do begin
         if GuildObject.SelfData.SubSysop[j] = aName then begin
            Result := format (Conv('%门派的副门主'), [GuildObject.GuildName]);
            exit;
         end;
      end;
   end;
end;

function TGuildList.GetInformation (aName : String) : String;
var
   i : Integer;
   GuildObject : TGuildObject;
begin
   Result := '';

   for i := 0 to DataList.Count - 1 do begin
      GuildObject := DataList.Items [i];
      if GuildObject.GuildName = '' then continue;
      if GuildObject.GuildName = aName then begin
         Result := GuildObject.GetInformation;
         exit;
      end;
   end;
end;

function TGuildList.FieldProc (aName : String; Msg: Word; var SenderInfo: TBasicData; var aSubData: TSubData) : Integer;
var
   i : Integer;
   GuildObject : TGuildObject;
begin
   Result := 0;

   for i := 0 to DataList.Count - 1 do begin
      GuildObject := DataList.Items [i];
      if GuildObject.GuildName = aName then begin
         GuildObject.FieldProc (GuildObject.BasicData.ID, Msg, SenderInfo, aSubData);
         Result := 1;
         exit;
      end;
   end;
end;

procedure TGuildList.Login (aGuildName, aName : String);
var
   i : Integer;
   GuildObject : TGuildObject;
begin
   for i := 0 to DataList.Count - 1 do begin
      GuildObject := DataList.Items [i];
      if GuildObject.GuildName = aGuildName then begin
         GuildObject.Login (aName);
         exit;
      end;
   end;
end;

procedure TGuildList.Logout (aGuildName, aName : String);
var
   i : Integer;
   GuildObject : TGuildObject;
begin
   for i := 0 to DataList.Count - 1 do begin
      GuildObject := DataList.Items [i];
      if GuildObject.GuildName = aGuildName then begin
         GuildObject.Logout (aName);
         exit;
      end;
   end;
end;

function TGuildList.MakeGuildLetterFile (aGuildName, aName : String) : String;
var
   i : Integer;
   GuildObject : TGuildObject;
begin
   Result := '';
   for i := 0 to DataList.Count - 1 do begin
      GuildObject := DataList.Items [i];
      if GuildObject.GuildName = aGuildName then begin
         Result := GuildObject.MakeGuildLetterFile (aName);
         exit;
      end;
   end;
end;

constructor TExitGuildList.Create;
begin
   inherited Create;

   LoadFromFile ('.\Guild\ExitGuildUser.SDB');
end;

destructor TExitGuildList.Destroy;
begin
   SaveToFile ('.\Guild\ExitGuildUser.SDB');
   Clear;

   inherited Destroy;
end;

procedure TExitGuildList.LoadFromFile (aFileName : String);
var
   i, j : Integer;
   str, rdstr : string;
   iName, AllyGuildStr : string;
   pd : PTExitGuildUser;
   DB : TUserStringDb;
   GuildObject : TGuildObject;
begin
   if not FileExists (aFileName) then exit;

   DB := TUserStringDb.Create;
   DB.LoadFromFile (aFileName);

   for i := 0 to Db.Count - 1 do begin
      iName := Db.GetIndexName (i);
      if iName = '' then continue;
      new(pd);
      FillChar (pd^, SizeOf(PTExitGuildUser), 0);
      pd^.Name := iName;
      pd^.ExitDate := StrToDateTime(Db.GetFieldValueString(iName, 'ExitDate'));
      pd^.ExitGuildName := Db.GetFieldValueString (iname, 'ExitGuildName');
      Add(pd);
   end;

   DB.Free;
end;

procedure TExitGuildList.SaveToFile (aFileName : String);
var
   i, j : integer;
   str : string;
   pd : PTExitGuildUser;
   DB : TUserStringDb;
begin
   if not FileExists (aFileName) then exit;

   Db := TUserStringDb.Create;
   Db.LoadFromFile (aFileName);

   for i := 0 to Db.Count - 1 do begin
      Db.DeleteName (Db.GetIndexName (0));
   end;

   for i := 0 to Count - 1 do begin
      pd := Items[i];
      if pd^.Name = '' then continue;
      if Now - pd^.ExitDate >=3 then continue; //超过3天不再做记录;
      Db.AddName (pd^.Name);
      Db.SetFieldValueString (pd^.Name, 'ExitDate', DateTimeToStr(pd^.ExitDate));
      Db.SetFieldValueString (pd^.Name, 'ExitGuildName', pd^.ExitGuildName);
      Dispose(pd);
   end;

   Db.SaveToFile (aFileName);
   Db.Free;
end;

procedure TExitGuildList.AddExitUser (aName,aGuildName : String);
var
    pd : PTExitGuildUser;
begin
    new(pd);
    pd^.Name := aName;
    pd^.ExitGuildName := aGuildName;
    pd^.ExitDate := Now;
    Add(pd);
end;

function TExitGuildList.GetExitUser (aName : String) : Boolean;
var
    pd : PTExitGuildUser;
    i : integer;
begin
    result := False;
   for i := 0 to Count - 1 do begin
      pd := Items[i];
      if pd^.Name = aName then begin
          if Now - pd^.ExitDate < 3 then begin  //退门3天内，返回True，不允许加入新盟;
            Result := True;
            Break;
          end;
          Dispose(pd);
          Delete(i);
          Break;
      end;
   end;
end;


end.
