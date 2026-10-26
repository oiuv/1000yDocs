unit uScriptManager;

interface

uses
   Windows, SysUtils, Classes, UserSDB, ScriptCls, AUtil32,SubUtil, uManager,AnsStringCls;
  // add by Orber at 2005-01-28 03:04:15
   //Windows, SysUtils, Classes, UserSDB, ScriptCls, AUtil32,Deftype, SubUtil, uManager;

type
   TScriptManager = class
   private
      DataList : TList;

      FManager : TManager;
      FSelf : Pointer;
      FSender : Pointer;

      function GetCount : Integer;
   public
      constructor Create;
      destructor Destroy; override;

      procedure Clear;

      procedure LoadFromFile (aFileName : String);

      procedure Update (CurTick : Integer);

      function CheckScriptEvent (aIndex : Integer; aName : String) : Integer;
      function CallEvent (aSelf : Pointer; aSender : Pointer; aIndex : Integer; aName : String; aParams: array of string) : String; overload;
      function CallEvent (aManager : TManager; aSelf : Pointer; aSender : Pointer; aIndex : Integer; aName : String; aParams: array of string) : String; overload;
      procedure CommandScript (aSelf : Pointer; aSender : Pointer; Cmd : String; Params : array of string);      
      function CallFunction (aStr : String) : String;

      property Count : Integer read GetCount;
   end;

var
   ScriptManager : TScriptManager = nil;

implementation

uses
   SVMain, BasicObj, uWorkBox, uSendCls, uGuild, uUser, svClass;

constructor TScriptManager.Create;
begin
   FSelf := nil;
   FSender := nil;

   DataList := TList.Create;
end;

destructor TScriptManager.Destroy;
begin
   Clear;
   DataList.Free;
   inherited Destroy;
end;

function TScriptManager.GetCount : Integer;
begin
   Result := DataList.Count;
end;

procedure TScriptManager.Clear;
var
   i : Integer;
   Script : TScriptClass;
begin
   FSelf := nil;
   FSender := nil;

   for i := 0 to DataList.Count - 1 do begin
      Script := DataList.Items [i];
      Script.Free;
   end;
   DataList.Clear;
end;

procedure TScriptManager.LoadFromFile (aFileName : String);
var
   i : Integer;
   iName : String;
   FileName : String;
   DB : TUserStringDB;
   Script : TScriptClass;
begin
   if not FileExists (aFileName) then exit;

   Clear;

   DB := TUserStringDB.Create;
   DB.LoadFromFile (aFileName);
   for i := 0 to DB.Count - 1 do begin
      iName := DB.GetIndexName (i);
      if iName = '' then continue;
      FileName := DB.GetFieldValueString (iName, 'FileName');
      // add by Orber at 2005-02-23 15:32:59
      if FileName = Conv('ÐåÇò.txt') then MarryBallID := StrToInt(iName);

      if FileExists ('.\Script\' + FileName) then begin
         Script := TScriptClass.Create;
         Script.LoadFromFile ('.\Script\' + FileName);
         DataList.Add (Script);
      end else begin
         FrmMain.WriteLogInfo ( format('.\Script\%s Not Found', [FileName]));
      end;
   end;
   DB.Free;
end;

procedure TScriptManager.Update (CurTick : Integer);
begin
   
end;

function TScriptManager.CheckScriptEvent (aIndex : Integer; aName : String) : Integer;
var
   Script : TScriptClass;
   Func : TFunctionClass;
begin
   Result := 0;

   if aIndex = 0 then exit;
   if aIndex > DataList.Count then exit;

   Script := DataList.Items [aIndex - 1];

   Func := Script.GetFunctionClass (aName);
   if Func <> nil then begin
      Result := aIndex;
   end;
end;

function TScriptManager.CallEvent (aSelf : Pointer; aSender : Pointer; aIndex : Integer; aName : String; aParams: array of string) : String;
var
   i : Integer;
   Script : TScriptClass;
   Str : String;
   Cmd : String;
   Params : array [0..10 - 1] of String;
   ParamCount : Integer;
begin
   Result := '';

   if aIndex = 0 then exit;
   if aIndex > DataList.Count then exit;
   if ManagerList = nil then exit;
   if GuildList = nil then exit;
   if UserList = nil then exit;

   FManager := nil;
   FSelf := aSelf;
   FSender := aSender;
   Script := DataList.Items [aIndex - 1];

   Result := Script.FunctionCallbyName (aName, aParams);

   while true do begin
      Str := Script.GetResult;
      if Str = '' then break;
      Str := GetValidStr3 (Str, Cmd, ' ');
      ParamCount := 0;
      for i := 0 to 10 - 1 do begin
         Str := GetValidStr3 (Str, Params [i], ' ');
         if Str = '' then break;
         Inc (ParamCount);
      end;

      CommandScript (aSelf, aSender, Cmd, Params);
   end;

   FSelf := nil;
end;

function TScriptManager.CallEvent (aManager : TManager; aSelf : Pointer; aSender : Pointer; aIndex : Integer; aName : String; aParams: array of string) : String;
var
   i : Integer;
   Script : TScriptClass;
   Str : String;
   Cmd : String;
   Params : array [0..10 - 1] of String;
   ParamCount : Integer;
begin
   Result := '';

   if aIndex = 0 then exit;
   if aIndex > DataList.Count then exit;
   if ManagerList = nil then exit;
   if GuildList = nil then exit;
   if UserList = nil then exit;

   FManager := aManager;
   FSelf := aSelf;
   FSender := aSender;
   Script := DataList.Items [aIndex - 1];

   Result := Script.FunctionCallbyName (aName, aParams);

   while true do begin
      Str := Script.GetResult;
      if Str = '' then break;
      Str := GetValidStr3 (Str, Cmd, ' ');
      ParamCount := 0;
      for i := 0 to 10 - 1 do begin
         Str := GetValidStr3 (Str, Params [i], ' ');
         if Str = '' then break;
         Inc (ParamCount);
      end;

      if Cmd = 'checkitemregen' then begin
         FManager.CheckItemRegen (Params [0], _StrToInt (Params [1]), _StrToInt (Params [2]), _StrToInt (Params [3]), _StrToInt (Params [4]));
      end;

      CommandScript (aSelf, aSender, Cmd, Params);
   end;
   FSelf := nil;
end;

procedure TScriptManager.CommandScript (aSelf : Pointer; aSender : Pointer; Cmd : String; Params : array of string);
var
   Str : String;
begin
   if Cmd = 'say' then begin
      Str := ChangeScriptString (Params [0], '_', ' ');
      TBasicObject (aSelf).PushCommand (CMD_SAY, Str, _StrToInt (Params [1]));
   end else if Cmd = 'saybyname' then begin
      Str := ChangeScriptString (Params [2], '_', ' ');
      TBasicObject (aSelf).SSayByName (Params [0], Params[1], Str, _StrToInt (Params [3]));
   end else if Cmd = 'attack' then begin
      TBasicObject (aSelf).PushCommand (CMD_ATTACK, Params, 0);
   end else if Cmd = 'selfkill' then begin
      TBasicObject (aSelf).PushCommand (CMD_SELFKILL, Params, 0);
   end else if Cmd = 'gotoxy' then begin
      TBasicObject (aSelf).PushCommand (CMD_GOTOXY, Params, 0);
   end else if Cmd = 'changestate' then begin
      TBasicObject (aSelf).PushCommand (CMD_CHANGESTATE, Params, 0);
   end else if Cmd = 'sendnoticemsgformapuser' then begin
      Str := ChangeScriptString (Params [1], '_', ' ');   
      TBasicObject (aSelf).SSendNoticeMessageForMapUser (_StrToInt (Params [0]), Str, _StrToInt (Params [2]));
   end else if Cmd = 'sendcentermsg' then begin                        // for test;
      Str := ChangeScriptString (Params [1], '_', ' ');
      Params [1] := Str;
      TBasicObject (aSelf).PushCommand (CMD_SENDCENTERMSG, Params, 0);
   end else if Cmd = 'sendsendertopmsg' then begin                    
      Str := ChangeScriptString (Params [0], '_', ' ');
      Params [0] := Str;
      TBasicObject (aSender).SSendTopMessage (Params [0]);
   end else if cmd = 'showwindow' then begin
      TBasicObject (aSender).SShowWindow (FSelf, Params [0], _StrToInt (Params [1]));
   end else if cmd = 'tradewindow' then begin
      TBasicObject (aSelf).STradeWindow (Params [0], _StrToInt (Params [1]));
   end else if cmd = 'startwindow' then begin
      TBasicObject (aSelf).SShowWindow (FSelf, Params [0], _StrToInt (Params [1]));
   end else if cmd = 'logitemwindow' then begin
      TBasicObject (aSender).SLogItemWindow (FSelf);
   end else if cmd = 'guilditemwindow' then begin
      TBasicObject (aSender).SGuildItemWindow (FSelf);
   end else if cmd = 'setautomode' then begin
      TBasicObject (aSelf).SSetAutoMode;
   end else if cmd = 'putsendermagicitem' then begin
      TBasicObject (aSender).SPutMagicItem (Params [0], Params [1], _StrToInt (Params [2]));
   end else if cmd = 'getsenderitem' then begin
      TBasicObject (aSender).SGetItem (Params [0]);
   end else if cmd = 'getsenderitem2' then begin
      TBasicObject (aSender).SGetItem2 (Params [0]);
   end else if cmd = 'getsenderallitem' then begin
      TBasicObject (aSender).SGetAllItem (Params [0]);
   end else if cmd = 'deletequestitem' then begin
      TBasicObject (aSender).SDeleteQuestItem;
   end else if cmd = 'changecompletequest' then begin
      TBasicObject (aSelf).SChangeCompleteQuest (_StrToInt (Params [0]));
   end else if cmd = 'changecurrentquest' then begin
      TBasicObject (aSelf).SChangeCurrentQuest (_StrToInt (Params [0]));
   end else if cmd = 'changefirstquest' then begin
      TBasicObject (aSelf).SChangeFirstQuest (_StrToInt (Params [0]));
   end else if cmd = 'changesendercompletequest' then begin
      TBasicObject (aSender).SChangeCompleteQuest (_StrToInt (Params [0]));
   end else if cmd = 'changesendercurrentquest' then begin
      TBasicObject (aSender).SChangeCurrentQuest (_StrToInt (Params [0]));
   end else if cmd = 'changesenderqueststr' then begin
      TBasicObject (aSender).SChangeQuestStr (Params [0]);
   end else if cmd = 'changesenderfirstquest' then begin
      TBasicObject (aSender).SChangeFirstQuest (_StrToInt (Params [0]));
   end else if cmd = 'addaddablestatepoint' then begin
      TBasicObject (aSender).SAddAddableStatePoint (_StrToInt (Params [0])); 
   end else if cmd = 'addtotalstatepoint' then begin
      TBasicObject (aSender).STotalAddableStatePoint (_StrToInt (Params [0]));
   end else if cmd = 'changedynobjstate' then begin
      if UpperCase (Params [1]) = 'TRUE' then begin
         TBasicObject (aSelf).SChangeDynobjState (Params[0], true);
      end else begin
         TBasicObject (aSelf).SChangeDynobjState (Params[0], false);
      end;
   end else if cmd = 'changesenderdynobjstate' then begin
      TBasicObject (aSelf).PushCommand (CMD_CHANGESTEP, Params, 0);
   end else if cmd = 'sendzoneeffectmsg' then begin
      TBasicObject (aSelf).SSendZoneEffectMessage (Params [0]);
   end else if cmd = 'sendsenderchatmessage' then begin
      if aSender <> nil then begin
         Str := ChangeScriptString (Params [0], '_', ' ');
         TBasicObject (aSender).SSendChatMessage (Str, _StrToInt (Params[1]));
      end;
   end else if cmd = 'movespace' then begin
      TBasicObject (aSelf).PushCommand (CMD_MOVESPACE, Params, _StrToInt (Params [5]));
   end else if cmd = 'directmovespace' then begin
      TBasicObject (aSelf).SMoveSpace (Params [0], Params [1], _StrToInt (Params[2]), _StrToInt (Params [3]), _StrToInt (Params [4]));
   end else if cmd = 'movespacebyname' then begin
//      TBasicObject (aSelf).SMoveSpaceByName (Params, Params [5], Params [6], _StrToInt (Params [7]));
// add by Orber at 2004-09-29 10:51
      TBasicObject (aSelf).SMoveSpaceByName (Params, Params [0], Params [1], 1);
   end else if cmd = 'setallowhitbyname' then begin
      TBasicObject (aSelf).SSetAllowHitByName (Params [0], Params [1], Params [2]);
   end else if cmd = 'setallowhitbytick' then begin
      TBasicObject (aSelf).PushCommand (CMD_ALLOWHIT, Params, _StrToInt (Params [1])); 
   end else if cmd = 'setallowhit' then begin
      TBasicObject (aSelf).SSetAllowHit (Params [0]);
   end else if cmd = 'setallowdelete' then begin
      TBasicObject (aSelf).SSetAllowDelete (Params [0], Params [1]);
   end else if cmd = 'showeffect' then begin
      TBasicObject (aSelf).SShowEffect (_StrToInt (Params [0]), _StrToInt (Params [1]));
   end else if cmd = 'commandice' then begin
      TBasicObject (aSelf).SCommandIce (_StrToInt (Params [0]));
   end else if cmd = 'commandicebyname' then begin
      TBasicObject (aSelf).SCommandIceByName (Params [0], Params [1], _StrToInt (Params [2]));
   end else if cmd = 'clearworkbox' then begin
      TBasicObject (aSelf).SClearWorkBox;
   end else if cmd = 'regen' then begin
      TBasicObject (aSelf).SRegen (Params [0], Params [1]);
   end else if cmd = 'mapregen' then begin
      TBasicObject (aSelf).SMapRegen (_StrToInt (Params [0]));
   end else if cmd = 'mapregenbyname' then begin
      TBasicObject (aSelf).SMapRegenByName (Params, Params [1], Params [2]);
   //2002-07-23 giltae
   end else if cmd = 'mapdelobjbyname' then begin
      TBasicObject (aSelf).SMapDelObjByName (Params [0], Params [1]);
   //-----------------------
   end else if cmd = 'mapaddobjbyname' then begin
      TBasicObject (aSelf).SMapAddObjByName (Params [0], Params);
   end else if cmd = 'mapaddobjbytick' then begin
      TBasicObject (aSelf).PushCommand (CMD_ADDMOP, Params, _StrToInt (Params [7]));
   end else if cmd = 'sendsound' then begin
      TBasicObject (aSelf).SSendSound (Params [0], _StrToInt (Params [1]));
   // end else if cmd = 'setsenderjobtool' then begin
   //    TBasicObject (aSender).SSetJobTool (Params [0]);
   end else if cmd = 'senditemmoveinfo' then begin
      TBasicObject (aSender).SSendItemMoveInfo (Params [0]);
   end else if cmd = 'setsenderjobkind' then begin
      TBasicObject (aSender).SSetJobKind (_StrToInt (Params [0]));
   end else if cmd = 'setsendervirtueman' then begin
      TBasicObject (aSender).SSetVirtueman;
   // end else if cmd = 'setsenderjobgrade' then begin
   //    TBasicObject (aSender).SSetJobGrade (Params [0]);
   end else if cmd = 'sendersmeltitem' then begin
      TBasicObject (aSender).SSmeltItem (Params [0]);
   end else if cmd = 'sendersmeltitem2' then begin           // Á¦·ÃÇÑ°Å ±³È¯¶§¹®¿¡
      TBasicObject (aSender).SSmeltItem2 (Params [0]);
   {
   end else if cmd = 'senderinitialtalent' then begin
      TBasicObject (aSender).SInitialTalent(_StrToInt (Params [0]));
   }
   end else if cmd = 'boiceallbyname' then begin
      TBasicObject (aSelf).SboIceAllbyName(Params [0], Params [1], Params [2]);
   end else if cmd = 'bohitallbyname' then begin
     TBasicObject (aSelf).SboHitAllbyName(Params [0], Params [1], Params [2]);
   end else if cmd = 'bopickbymapname' then begin
      TBasicObject (aSelf).SboPickbyMapName(Params [0], Params [1]);
   end else if cmd = 'reposition' then begin
      TBasicObject (aSelf).SRePosition(aSender);
   end else if cmd = 'returndamage' then begin
      TBAsicObject (aSelf).SReturnDamage (aSender, _StrToInt (Params [0]), _StrToInt (Params [1]));
   end else if cmd = 'selfchangedynobjstate' then begin           //2002-08-06 giltae
      if Uppercase (Params[0]) = 'TRUE' then begin
         TBasicObject (aSelf).SSelfChangeDynobjState (true);
      end else begin
         TBasicObject (aSelf).SSelfChangeDynobjState (false);
      end;
   end else if cmd = 'questcomplete' then begin
      TBasicObject (aSelf).SQuestComplete(Params[0], Params[1] );
   end else if cmd = 'senderrefill' then begin
      TBasicObject (aSender).SRefill;
   end else if cmd = 'changesendercurdurabyname' then begin   // ¾ÆÀÌÅÛ ³»±¸¼º ¹Ù²ãÁÖ´Â°Å... 03.04.03
      TBasicObject (aSender).SChangeCurDuraByName (Params [0], _StrToInt (Params [1]));
   end else if cmd = 'boMapEnter' then begin                  // ¸Ê¿¡ µé¾î°¥¼ö ÀÖ´ÂÁö ¾ø´ÂÁö 03.05.06 saset
      TBasicObject (aSender).SboMapEnter (_StrToInt (Params [0]), Params [1]);
   end else if cmd = 'usemagicgradeup' then begin
      TBasicObject (aSender).SUseMagicGradeup(_StrToInt(Params[0]),_StrToInt(Params[1]));
   end else if cmd = 'decreasePrisonTime' then begin
      TBasicObject (aSender).SDecreasePrisonTime(_StrToInt(Params[0]));
   end else if cmd = 'athleticprocess' then begin
      UserList.AddItemByEventTeam (_StrToInt (Params [0]), Params [1], Params [2]);
      UserList.MoveByServerID (_StrToInt (Params [0]), 1, 554, 119);
    end else if cmd = 'marry' then begin
      TUser(aSender).MarryWindow(Params[0]);
    end else if cmd = 'unmarry' then begin
        TUser(aSender).UnMarryWindow(Params [0]);
    end else if cmd = 'activebank' then begin
        TUser(aSender).GuildActiveBank;
    end else if cmd = 'buymoneychip' then begin
        TUser(aSender).GuildBuyMoneyChip;
    end else if cmd = 'setmarryclothes' then begin
        MarryList.SetClothes(TUser(aSender).Name);
    end else if cmd = 'setoutzhuang' then begin
        TUser(aSender).inZhuang := False;
    end;

end;

function TScriptManager.CallFunction (aStr : String) : String;
var
   i, MapID : Integer;
   cmd, str : String;
   Params : array [0..10 - 1] of String;
   Xpos, Ypos, xx1, yy1, xx2, yy2 : Word;
begin
   Result := '';

   if FSelf = nil then exit;
   if ManagerList = nil then exit;
   if GuildList = nil then exit;
   if UserList = nil then exit;

   Str := aStr;
   Str := GetValidStr3 (Str, cmd, ' ');
   for i := 0 to 10 - 1 do begin
      if Str = '' then break;
      Str := GetValidStr3 (Str, Params [i], ' ');
      if Params [i] = '' then break;
   end;

   if cmd = 'getsysteminfo' then begin
      Result := TBasicObject (FSelf).SGetSystemInfo (Params [0]);
   end else if cmd = 'getname' then begin
      Result := TBasicObject (FSelf).SGetName;
   end else if cmd = 'getsendername' then begin
      Result := TBasicObject (FSender).SGetName;
   end else if cmd = 'getsenderguildname' then begin
      if TObject (FSender) is TUser then
         Result := TUser (FSender).GuildName;
   end else if cmd = 'getage' then begin
      Result := IntToStr (TBasicObject (FSelf).SGetAge);
   end else if cmd = 'getsenderage' then begin
      Result := IntToStr (TBasicObject (FSender).SGetAge);
   end else if cmd = 'getsex' then begin
      Result := IntToStr (TBasicObject (FSelf).SGetSex);
   end else if cmd = 'getsendersex' then begin
      Result := IntToStr (TBasicObject (FSender).SGetSex);
   end else if cmd = 'getid' then begin
      Result := IntToStr (TBasicObject (FSelf).SGetId);
   end else if cmd = 'getsenderid' then begin
      Result := IntToStr (TBasicObject (FSender).SGetId);
   end else if cmd = 'getserverid' then begin
      Result := IntToStr (TBasicObject (FSelf).SGetServerId);
   end else if cmd = 'getsenderserverid' then begin
      Result := IntToStr (TBasicObject (FSender).SGetServerId);
   end else if cmd = 'findobjectbyname' then begin
      Result := IntToStr (TBasicObject (FSelf).SFindObjectByName (Params [0]));
   end else if cmd = 'getposition' then begin
      TBasicObject (FSelf).SGetPosition (MapId, Xpos, Ypos);
      Result := IntToStr (Xpos) + '_' + IntToStr (Ypos);
   end else if cmd = 'getsenderposition' then begin
      if FSender = nil then exit;
      TBasicObject (FSender).SGetPosition (MapId, Xpos, Ypos);
      Result := IntToStr (Xpos) + '_' + IntToStr (Ypos);
   end else if cmd = 'getnearxy' then begin
      Result := TBasicObject (FSelf).SGetNearXY (_StrToInt (Params[0]), _StrToInt (Params [1]));
   end else if cmd = 'getmapname' then begin
      Result := TBasicObject (FSelf).SGetMapName;
   end else if cmd = 'getsendermapname' then begin
      Result := TBasicObject (FSender).SGetMapName;
   end else if cmd = 'getmoveablexy' then begin
      Result := TBasicObject (FSelf).SGetMoveableXY (_StrToInt (Params[0]), _StrToInt (Params [1]));
   end else if cmd = 'getrace' then begin
      Result := IntToStr (TBasicObject (FSelf).SGetRace);
   end else if cmd = 'getsenderrace' then begin
      Result := IntToStr (TBasicObject (FSender).SGetRace);
   end else if cmd = 'getmaxlife' then begin
      Result := IntToStr (TBasicObject (FSelf).SGetMaxLife);
   end else if cmd = 'getsendermaxlife' then begin
      Result := IntToStr (TBasicObject (FSender).SGetMaxLife);
   end else if cmd = 'getmaxinpower' then begin
      Result := IntToStr (TBasicobject (FSelf).SGetMaxInPower);
   end else if cmd = 'getsendermaxinpower' then begin
      Result := IntToStr (TBasicObject (FSender).SGetMaxInPower);
   end else if cmd = 'getmaxoutpower' then begin
      Result := IntToStr (TBasicObject (FSelf).SGetMaxOutPower);
   end else if cmd = 'getsendermaxoutpower' then begin
      Result := IntToStr (TBasicObject (FSender).SGetMaxOutPower);
   end else if cmd = 'getmaxmagic' then begin
      Result := IntToStr (TBasicObject (FSelf).SGetMaxMagic);
   end else if cmd = 'getsendermaxmagic' then begin
      Result := IntToStr (TBasicObject (FSender).SGetMaxMagic);
   end else if cmd = 'getlife' then begin
      Result := IntToStr (TBasicObject (FSelf).SGetLife);
   end else if cmd = 'getsenderlife' then begin
      Result := IntToStr (TBasicObject (FSender).SGetLife);
   end else if cmd = 'getheadlife' then begin
      Result := IntToStr (TBasicObject (FSelf).SGetHeadLife);
   end else if cmd = 'getsenderheadlife' then begin
      Result := IntToStr (TBasicObject (FSender).SGetLife);
   end else if cmd = 'getarmlife' then begin
      Result := IntToStr (TBasicObject (FSelf).SGetArmLife);
   end else if cmd = 'getsenderarmlife' then begin
      Result := IntToStr (TBasicObject (FSender).SGetArmLife);
   end else if cmd = 'getleglife' then begin
      Result := IntToStr (TBasicObject (FSelf).SGetLegLife);
   end else if cmd = 'getsenderleglife' then begin
      Result := IntToStr (TBasicObject (FSender).SGetLegLife);
   end else if cmd = 'getpower' then begin
      Result := IntToStr (TBasicObject (FSelf).SGetPower);
   end else if cmd = 'getsenderpower' then begin
      Result := IntToStr (TBasicObject (FSender).SGetPower);
   end else if cmd = 'getinpower' then begin
      Result := IntToStr (TBasicObject (FSelf).SGetInPower);
   end else if cmd = 'getsenderinpower' then begin
      Result := IntToStr (TBasicObject (FSender).SGetInPower);
   end else if cmd = 'getoutpower' then begin
      Result := IntToStr (TBasicObject (FSelf).SGetOutPower);
   end else if cmd = 'getsenderoutpower' then begin
      Result := IntToStr (TBasicObject (FSender).SGetOutPower);
   end else if cmd = 'getmagic' then begin
      Result := IntToStr (TBasicObject (FSelf).SGetMagic);
   end else if cmd = 'getsendermagic' then begin
      Result := IntToStr (TBasicObject (FSender).SGetMagic);
   end else if cmd = 'getvirtue' then begin
      Result := IntToStr (TBasicObject (FSelf).SGetVirtue); //2002-07-31 giltae
   end else if cmd = 'getsendervirtue' then begin
      Result := IntToStr (TBasicObject (FSender).SGetVirtue);//2002-07-31 giltae
   end else if cmd = 'getsendertalent' then begin
      Result := IntToStr (TBasicObject (FSender).SGetTalent);
   end else if cmd = 'getmovespeed' then begin
      Result := IntToStr (TBasicObject (FSelf).SGetMoveSpeed);
   end else if cmd = 'getsendermovespeed' then begin
      Result := IntToStr (TBasicObject (FSender).SGetMoveSpeed);
   end else if cmd = 'getuseattackmagic' then begin
      Result := TBasicObject (FSelf).SGetUseAttackMagic;
   end else if cmd = 'getsenderuseattackmagic' then begin
      Result := TBasicObject (FSender).SGetUseAttackMagic;
   end else if cmd = 'getuseattackskilllevel' then begin
      Result := IntToStr (TBasicObject (FSelf).SGetUseAttackSkillLevel);
   end else if cmd = 'getsenderuseattackskilllevel' then begin
      Result := IntToStr (TBasicObject (FSender).SGetUseAttackSkillLevel);
   end else if cmd = 'getsendermagicskilllevel' then begin
      Result := IntToStr (TBasicObject (FSender).SGetMagicSkillLevel (Params [0]));
   end else if cmd = 'getuseprotectmagic' then begin
      Result := TBasicObject (FSelf).SGetUseProtectMagic;
   end else if cmd = 'getsenderuseprotectmagic' then begin
      Result := TBasicObject (FSender).SGetUseProtectMagic;
   end else if cmd = 'getcompletequest' then begin
      Result := IntToStr (TBasicObject (FSelf).SGetCompleteQuest);
   end else if cmd = 'getsendercompletequest' then begin
      Result := IntToStr (TBasicObject (FSender).SGetCompleteQuest);
   end else if cmd = 'getcurrentquest' then begin
      Result := IntToStr (TBasicObject (FSelf).SGetCurrentQuest);
   end else if cmd = 'getsendercurrentquest' then begin
      Result := IntToStr (TBasicObject (FSender).SGetCurrentQuest);
   end else if cmd = 'getsenderqueststr' then begin
      Result := TBasicObject (FSender).SGetQuestStr;
   end else if cmd = 'getfirstquest' then begin
      Result := IntToStr (TBasicObject (FSelf).SGetFirstQuest);
   end else if cmd = 'getsenderfirstquest' then begin
      Result := IntToStr (TBasicObject (FSender).SGetFirstQuest);
   end else if cmd = 'getdistance' then begin
      xx1 := TBasicObject (FSender).BasicData.x;
      yy1 := TBasicObject (FSender).BasicData.y;
      xx2 := TBasicObject (FSelf).BasicData.x;
      yy2 := TBasicObject (FSelf).BasicData.y;
      Result := IntToStr (GetLargeLength (xx1, yy1, xx2, yy2));
   end else if cmd = 'getsenderitemexistence' then begin
      Result := TBasicObject (FSender).SGetItemExistence (Params [0], _StrToInt (Params [1]));
   end else if cmd = 'getsenderitemexistencebykind' then begin
      Result := TBasicObject (FSender).SGetItemExistenceByKind (_StrToInt (Params [0]), _StrToInt (Params [1]));
   end else if cmd = 'startmissiontime' then begin
      Result := IntToStr(Trunc(TBasicObject (FSender).SStartMissionTime));
   end else if cmd = 'getpassmissiontime' then begin
      Result := IntToStr(Trunc(TBasicObject (FSender).SGetPassMissionTime));
   end else if cmd = 'getintoarena' then begin
      Result := IntToStr(TBasicObject (FSender).SGetIntoArenaGame (_StrToInt (Params [0])));
   end else if cmd = 'getstartarena' then begin
      Result := IntToStr(TBasicObject (FSender).SStartArenaGame);
   end else if cmd = 'checkenoughspace' then begin
      if Params[0] = '' then begin
         i := 1;
      end else begin
         i := _StrToInt(Params[0]);
      end;
      Result := TBasicObject (FSender).SCheckEnoughSpace (i);
   end else if cmd = 'gethavegradequestitem' then begin
      Result := TBasicObject (FSender).SGetHaveGradeQuestItem;
   end else if cmd = 'getpossiblegrade' then begin
      Result := TBasicObject (FSender).SGetPossibleGrade(_StrToInt(Params[0]),_StrToInt(Params[1]));
   end else if cmd = 'checkalivemopcount' then begin
      Result := IntToStr (TBasicObject (FSelf).SCheckAliveMonsterCount (_StrToInt (Params [0]), Params [1], Params [2]));
   end else if cmd = 'getusercount' then begin
      Result := IntToStr (TBasicObject (FSelf).SGetUserCount (_StrToInt (Params [0])));
   end else if cmd = 'getsenderjobkind' then begin
      Result := IntToStr (TBasicObject (FSender).SGetJobKind);
   end else if cmd = 'getsenderjobgrade' then begin
      Result := IntToStr (TBasicObject (FSender).SGetJobGrade);
   end else if cmd = 'getsenderitemcurdurability' then begin
      Result := IntToStr (TBasicObject (FSender).SGetWearItemCurDurability (_StrToInt (Params [0])));
   end else if cmd = 'getsenderitemmaxdurability' then begin
      Result := IntToStr (TBasicObject (FSender).SGetWearItemMaxDurability (_StrToInt (Params [0])));
   end else if cmd = 'getsenderwearitemname' then begin
      Result := TBasicObject (FSender).SGetWearItemName (_StrToInt (Params [0]));
   end else if cmd = 'checkobjectalive' then begin
      if ManagerList.CheckObjectAlive (Params [0], Params [1], Params [2]) = true then begin
         Result := 'true';
      end else begin
         Result := 'false';
      end;
   end else if cmd = 'getsendermagiccountbyskill' then begin
      Result := TBasicObject (FSender).SGetMagicCountBySkill (_StrToInt (Params [0]), _StrToInt (Params [1]));       
   end else if cmd = 'getsenderrepairitem' then begin
      Result := IntToStr (TBasicObject (FSender).SRepairItem (_StrToInt (Params [0]), _StrToInt (Params [1])));
   end else if cmd = 'getsenderdestroyitem' then begin
      Result := IntToStr (TBasicObject (FSender).SDestroyItembyKind (_StrToInt (Params [0]), _StrToInt (Params [1])));
   end else if cmd = 'getsenderitemcountbyname' then begin
      Result := TBasicObject (FSender).SFindItemCount (Params [0]);
   end else if cmd = 'checksenderpowerwearitem' then begin      // ´É·ÂÄ¡¾ÆÀÌÅÛÀÖ´ÂÁö °Ë»ç
      Result := IntToStr (TBasicObject (FSender).SCheckPowerWearItem);
   end else if cmd = 'checksendercurusemagic' then begin
      Result := TBasicObject (FSender).SCheckCurUseMagic (_StrToInt (Params [0]));
   end else if cmd = 'checkusemagicbygrade' then begin
      Result := TBasicObject (FSender).SCheckCurUseMagicByGrade (_StrToInt (Params [0]), _StrToInt(Params[1]), _StrToInt(Params[2]));
   end else if cmd = 'getsendercurpowerlevelname' then begin
      Result := TBasicObject (FSender).SGetCurPowerLevelName;
   end else if cmd = 'getsendercurpowerlevel' then begin
      Result := IntToStr (TBasicObject (FSender).SGetCurPowerLevel);
   end else if cmd = 'getsendercurdurawatercase' then begin    // Á×ÅëµéÀÇ ³»±¸¼ºÀÌ 0ÀÎÁö ¾Æ´ÑÁö (¹°ÀÌ ³²¾ÆÀÖ´ÂÁö)
      Result := IntToStr (TBasicObject (FSender).SGetCurDuraWaterCase);
   end else if cmd = 'getremainmaptime' then begin             // ÇöÀç ¸Ê½Ã°£ÀÌ ¾ó¸¶³ª ³²¾Ò´ÂÁö Á¶»ç
      Result := TBasicObject (FSender).SGetRemainMapTime (_StrToInt (Params [0]), _StrToInt (Params [1]));
   end else if cmd = 'checkentermap' then begin     // µé¾î°¥ ¼ö ÀÖ´ÂÁö ¾ø´ÂÁö Á¶»ç
      Result := TBasicObject (FSender).SCheckEnterMap (_StrToInt (Params [0]));
   end else if cmd = 'getrandomitem' then begin
      Result := RandomEventItemList.GetItemNamebyRandom (_StrToInt (Params [0]));
   end else if cmd = 'getquestitem' then begin
      Result := RandomEventItemList.GetQuestItembyRandom (_StrToInt (Params [0]));
   end else if cmd = 'checkmagic' then begin
      Result := TBasicObject (FSelf).SCheckMagic (_StrToInt (Params [0]), _StrToInt (Params [1]), Params [2]);
   end else if cmd = 'checksenderattribitem' then begin
      Result := TBasicObject (FSender).SCheckAttribItem (_StrToInt (Params [0])); 
   end else if cmd = 'conditionbestattackmagic' then begin
      Result := TBasicObject (FSender).SConditionBestAttackMagic (Params [0]);
   end else if cmd = 'getmarryclothes' then begin
      Result := TBasicObject (FSender).SGetMarryClothes;
   end else if cmd = 'getzhuangticketprice' then begin //»ñÈ¡¾ÛÏÍ×¯ÃÅÆ±¼Û¸ñ
      Result := TBasicObject (FSender).SGetZhuangTicketPrice;
   end else if cmd = 'getintozhuang' then begin //½øÈë¾ÛÏÍ×¯
      Result := TBasicObject (FSender).SGetZhuangInto;
   end else if cmd = 'getmarryinfo' then begin
      Result := TBasicObject (FSender).SGetMarryInfo;
   end else if cmd = 'getzhuangfight' then begin //ÌôÕ½¾ÛÏÍ×¯
      Result := TBasicObject (FSender).SGetAskConquer;
   end else if cmd = 'getaddmember' then begin
      Result := TBasicObject (FSender).SAddArenaMember (Params [0]);
   end else if cmd = 'getcheckpickup' then begin
      Result := TBasicObject (FSender).SCheckPickup;
   end else if cmd = 'getevent' then begin
      Result := TBasicObject (FSender).SGetEvent (StrToIntDef(Params [0],0));
   end else if cmd = 'getsetevent' then begin
      Result := TBasicObject (FSender).SGetSetEvent (StrToIntDef(Params [0],0));
   end else if cmd = 'getparty' then begin
      Result := TBasicObject (FSender).SGetParty;
   end else if cmd = 'setparty' then begin
      Result := TBasicObject (FSender).SSetParty;
   end

end;

initialization
begin
   ScriptManager := TScriptManager.Create;
   // ScriptManager.LoadFromFile ('.\Script\Script.SDB');
end;

finalization
begin
   ScriptManager.Free;
end;

end.
