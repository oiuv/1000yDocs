unit uSendCls;

interface

uses
  Windows, SysUtils, Classes, Usersdb, Deftype, AnsUnit, AnsImg2, AUtil32,
  subutil, uConnect, Dialogs, uManager, ComObj, ActiveX;

type
   TSendClass = class
   private
     Name : String; 
     Connector : TConnector;
   public
     constructor Create;
     destructor Destroy; override;

     procedure SetConnector (aConnector : TConnector);
     procedure SetName (aName : String);

     procedure  SendCancelExChange;
     procedure  SendShowExChange (pexleft, pexright: PTExChangedata);
     procedure  SendShowCount (aCountId, aSourKey, aDestKey, aCntMax: integer; acaption: string);
     procedure  SendShowMarketCount (aSourKey, aDestKey, aCntMax: Integer);     

     procedure  SendShowInputString (aInputStringId: integer; aCaptionString: string; aListString: string);
     procedure  SendShiftAttack (abo: Boolean);
     procedure  SendAttribFightBasic (astr: string);
     procedure  SendAttribBase (aAttribClass : Pointer);
     procedure  SendAttribValues (aAttribClass : Pointer);
     procedure  SendExtraAttribValues (aAttribClass : Pointer); //2003-10-01
     procedure  SendAbilityAttrib (aLifeData : TLifeData; aRealAddAttribData : TRealAddAttribData; pAttackMagicData : PTMagicData);  // 2004.02.13     
     procedure  SendChangeState (var aSenderinfo: TBasicData);
     procedure  SendChangeFeature (var aSenderinfo: TBasicData);
     procedure  SendChangeProperty (var aSenderinfo: TBasicData);
     procedure  SendSay (var aSenderinfo: TBasicData; astr: string);
     procedure  SendSayUseMagic (var aSenderinfo: TBasicData; astr: string);
     procedure  SendEventString (astr: string);
     procedure  SendUsedMagicString (astr: string);
     procedure  SendShootMagic (var aSenderinfo: TBasicData; atid: integer; ax, ay, abowimage, abowspeed : word; aType : Byte; aeen : word; aeek : TLightEffectKind);
     procedure  SendTurn (var aSenderinfo: TBasicData; relativity_x : integer = 0; relativity_y : integer =0);
     procedure  SendBackMove (var aSenderinfo: TBasicData; relativity_x : integer = 0; relativity_y : integer =0);
     procedure  SendMove (var aSenderinfo: TBasicData ; relativity_x : integer = 0; relativity_y : integer =0);
     procedure  SendMotion (aid, amotion: integer; aMagicState, aMagicKind, aEffectColor : Byte);
     procedure  SendStructed (var aSenderInfo : TBasicData; aPercent: integer);
     procedure  SendChatMessage (const astr: string; aColor: byte);
     procedure  SendMessenger (const aTimeStr, aStr : String);
     procedure  SendSideMessage (const aStr : String);
     procedure  SendStatusMessage (const astr: string);
     procedure  SendCenterMessage (const aStr : String);
     procedure  SendTopMessage (const aStr : String);
     procedure  SendTopLetterMessage (const aName, aStr1, aStr2 : String);
     procedure  SendShow (var aSenderinfo: TBasicData; aEffectNumber : Word; aEffectKind : TLightEffectKind; relativity_x : integer = 0; relativity_y : integer =0);
     procedure  SendHide (var aSenderinfo: TBasicData);
     procedure  SendMarketItem (akey: word; var ItemData: TItemData);
     procedure  SendMaterialItem (akey: word; var ItemData: TItemData);
     procedure  SendHaveItem (akey: word; var ItemData: TItemData);
  // add by Orber at 2005-01-12 03:51:26
     procedure  SendGuildInfo (GuildInfo: TSGuildListInfo);
     procedure  SendGuildEnergy(aGuildEnergyLevel : Byte);

     procedure  SendHaveMagic (akey: word; var MagicData: TMagicData);
     procedure  SendHaveRiseMagic (akey: word; var MagicData: TMagicData);
     procedure  SendBasicMagic (akey: word; var MagicData: TMagicData);
     procedure  SendHaveMystery (akey: word; var MagicData: TMagicData);
     procedure  SendHaveBestSpecialMagic (akey: word; var MagicData: TMagicData);
     procedure  SendHaveBestProtectMagic (akey: word; var MagicData: TMagicData);
     procedure  SendHaveBestAttackMagic (akey: word; var MagicData: TMagicData);
          
     procedure  SendWearItem (akey: word; var ItemData: TItemData);
     procedure  SendMap (var aSenderInfo: TBasicData; aManager : TManager);
     procedure  SendSetPosition (var aSenderinfo: TBasicData);
     procedure  SendSoundEffect (asoundname: string; ax, ay : Word);

     procedure  SendSoundBase (asoundname: string; aRoopCount: integer);
     procedure  SendSoundBase2 (asoundname: string; aRoopCount: integer);

     procedure  SendItemMoveInfo (ainfostr, ainfoip: string);
     procedure  SendRainning (aRain : TSRainning);

     procedure  SendSsamzieItem (akey: word; var ItemData: TItemData);
     procedure  SendGuildItem (akey: word; var ItemData: TItemData);
     procedure  SendShowSpecialWindow (aUser : Pointer; aWindow : Byte; aType : Byte; aCaption : String; aComment : String);
     procedure  SendShowGuildMagicWindow (aMagicWindowData : PTSShowGuildMagicWindow);
     procedure  SendShowPasswordWindow (aOption : Byte);
     procedure  SendShowPowerLevel (aName : String; aLevel : Integer);
     procedure  SendNetState (aID, aTick : Integer; var aQuestion: array of byte);
     procedure  SendMiniMapInfo (aStr : String);
     procedure  SendSetShortCut (aPos : PByte);
     procedure  SendShowHelpWindow (aFileName, aHelpText : String);
     procedure  SendShowItemWindow (aName : String; aColor : Byte);
     procedure  SendShowItemWindow2 (aViewName, aContents : String; aShape, aColor, aPrice : Integer; aGrade : Byte ; rLockState:Byte ; runLockTime:Word);
     procedure  SendShowItemWindow3 (aViewName, aContents, aButton : String; aShape, aColor : Integer; aKey : Byte);
     procedure  SendShowBestAttackMagicWindow (aViewName, aContents : String; aKey: Byte; aGrade,aShape: Integer;damageBody, damageHead, damageArm, damageLeg, damageEnergy : word);
     procedure  SendShowBestProtectMagicwindow (aViewName, aContents: String; aKey: Byte; aGrade, aShape: Integer; armorBody, armorHead, armorArm, armorLeg, armorEnergy : word);
     procedure  SendShowBestSpecialMagicWindow (aViewName, aContents : String; aKey: Byte; aNeedStatePoint,aShape: integer);

     //Author:Steven Date: 2005-01-10 17:28:57
     //Note:µ¯³öÊäÈëGuildName¶Ô»°¿ò
     procedure  SendShowInputGuildNameWindow(aHelpText : String; SenderID : LongInt);
     procedure  SendShowGuildInfoWindow(aGuildInfo : TSGuildInfo);

     // add by Orber at 2004-12-23 10:48:27
     procedure  SendShowMarryWindow (aHelpText : String);
     procedure  SendShowUnMarryWindow (aHelpText : String);
     procedure  SendShowMarryAnswerWindow (aHelpText : String);
     // add by Orber at 2004-12-23 10:48:27
     procedure  SendShowInputMoneyChipWindow (aHelpText : String);
     procedure  SendShowGuildApplyMoneyWindow (aHelpText : String);
     procedure  SendShowGuildSubSysopWindow (aHelpText : String);
     procedure  SendShowArenaWindow (aHelpText : String);
     procedure  SendShowJoinArenaWindow (aHelpText : String);
     procedure  SendShowGuildAnswerWindow (aHelpText : String);


     procedure  SendShowTradeWindow (aFileName, aHelpText : String);
     procedure  SendShowMarketWindow (aMarketCount : Integer);
     procedure  SendSkillWindow (aShape : Byte; aJobKind, aJobGrade, aJobTool : String; AExtJobGrade: String; AExtJobLevel: Integer);
     procedure  SendTopLetterWindow;
     procedure  SendJobResult (aboSuccess : Boolean; aWorkSound, aResultSound, aMsgStr : String);
     procedure  SendMarketResult (aSuccessKey : Integer);
     procedure  SendTime (aTimeStr : String);
     procedure  SendBattleBar (aLeftName, aRightName : String; aLeftWin, aRightWin : Byte; aLeftPercent, aRightPercent, aBattleType : Integer);     
     procedure  SendLotteryInfo (ainfostr : string);

     procedure  SendEffect (var aSenderinfo: TBasicData; aDelay : integer; aEffectKind : TLightEffectKind; aEffectNumber: integer);
     procedure  SendScreenEffect (aseffectnum :Byte; aDelay : integer);
     procedure  SendActionState (var aSenderInfo: TBasicData);

     // procedure  SendProcessItem (aKey : Integer; aMsgStr : String);

     procedure  SendSystemInfo;

     procedure  SendData (var aComData : TWordComData);

    //Author:Steven Date: 2004-12-08 17:14:35
    //Note:
    procedure SendIsInviteTeam(AUserName: string; ACaption: string; AText:
      string; var AKey: String);

    procedure SendTeamMemberList(AMemberList: array of TNameString);
    //======================================
   end;

implementation

uses
   FSockets, svClass, uUser, uUserSub, Graphics,AnsStringCls;

function MaskValue(id: integer; adir: byte; n, n2: word): word;
var
   t: word;
begin
   t := Word(n xor id);
   Result := Word(t shl adir) or Word(t shr (16-adir)) + n2;
end;

///////////////////////////////////
//         TSendClass
///////////////////////////////////
procedure  TSendClass.SendShowCount (aCountID, aSourKey, aDestKey, aCntMax: Integer; aCaption: String);
var
   ComData : TWordComData;
   psCount : PTSCount;
begin
   psCount := @ComData.Data;
   with psCount^ do begin
      rMsg := SM_SHOWCOUNT;
      rCountID := aCountID;
      rSourKey := aSourKey;
      rDestKey := aDestKey;
      rCountCur := 0;
      rCountMax := aCntMax;
      SetWordString (rCountName, aCaption);
      ComData.Size := SizeOf(TSCount) - sizeof(TWordString) + sizeofWordstring(rCountName);
   end;
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure TSendClass.SendShowMarketCount (aSourKey, aDestKey, aCntMax: Integer);
var
   ComData : TWordComData;
   psMarketCount : PTSMarketCount;
begin
   psMarketCount := @ComData.Data;
   with psMarketCount^ do begin
      rMsg := SM_SHOWMARKETCOUNT;
      rSourKey := aSourKey;
      rDestKey := aDestKey;
      rCountMax := aCntMax;
      ComData.Size := SizeOf(TSMarketCount);
   end;
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure  TSendClass.SendCancelExChange;
var
   ComData : TWordComData;
   pcKey : PTCKey;
begin
   pcKey := @ComData.Data;
   with pcKey^ do begin
      rmsg := SM_HIDEEXCHANGE;
      ComData.Size := SizeOf (TCKey);
   end;
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure  TSendClass.SendShowExChange (pexleft, pexright: PTExChangedata);
var
   ComData : TWordComData;
   i : integer;
   str : string;
   psExChange : PTSExChange;
begin
   psExChange := @ComData.Data;
   with psExChange^ do begin
      rmsg := SM_SHOWEXCHANGE;
      rCheckLeft := pexleft^.rboCheck;
      rCheckRight := pexright^.rboCheck;

      str := format ('%s,%s,', [pexright^.rExChangeName, pexleft^.rExChangeName]);

      for i := 0 to 4 - 1 do begin
         if pexleft^.rItems[i].rItemCount <> 0 then begin
            rIcons[i] := pexleft^.rItems[i].ricon;
            rColors[i] := pexleft^.rItems[i].rColor;
            str := str + pexleft^.rItems[i].rItemViewName + ':' + InttoStr (pexleft^.rItems[i].rItemCount) + ',';
         end else begin
            rIcons[i] := 0;
            rColors[i] := 0;
            str := str + ',';
         end;
      end;

      for i := 0 to 4-1 do begin
         if pexright^.rItems[i].rItemCount <> 0 then begin
            rIcons[i+4] := pexright^.rItems[i].ricon;
            rColors[i+4] := pexright^.rItems[i].rColor;
            str := str + pexright^.rItems[i].rItemViewName + ':' + InttoStr (pexright^.rItems[i].rItemCount) + ',';
         end else begin
            rIcons[i+4] := 0;
            rColors[i+4] := 0;
            str := str + ',';
         end;
      end;

      SetWordString (rWordString, str);

      ComData.Size := Sizeof(TSExChange) - sizeof(TWordString) + SizeofWordString(rWordString);
   end;
   
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure  TSendClass.SendShowInputString (aInputStringId: integer; aCaptionString: string; aListString: string);
var
   ComData : TWordComData;
   psShowInputString: PTSShowInputString;
begin
   psShowInputString := @ComData.Data;
   with psShowInputString^ do begin
      rmsg := SM_SHOWINPUTSTRING;
      rInputStringid := aInputStringId;
      SetWordString (rWordString, aCaptionString + ',' + aListString);
      ComData.Size := sizeof(TSShowInputString) - sizeof(TWordString) + sizeofwordstring(rWordString);
   end;
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure  TSendClass.SendRainning (aRain : TSRainning);
var
   ComData : TWordComData;
   psRainning : PTSRainning;
begin
   psRainning := @ComData.Data;
   Move (aRain, psRainning^, SizeOf (TSRainning));
   ComData.Size := SizeOf (TSRainning);
   
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure  TSendClass.SendItemMoveInfo (ainfostr, ainfoip: string);
var
   cnt : integer;
   usd : TStringData;
begin
   usd.rmsg := 1;
   if ainfoip = '' then begin
      SetWordString (usd.rWordString, ainfostr + Connector.IpAddr + ',');
   end else begin
      SetWordString (usd.rWordString, ainfostr + ainfoip + ',');
   end;
   cnt := sizeof(usd) - sizeof(TWordString) + sizeofwordstring (usd.rwordstring);
   
   FrmSockets.UdpItemMoveInfoAddData (cnt, @usd);
end;

constructor TSendClass.Create;
begin
   Connector := nil;
end;

destructor TSendClass.Destroy;
begin
   inherited destroy;
end;

procedure TSendClass.SetConnector (aConnector : TConnector);
begin
   Connector := aConnector;
end;

procedure TSendClass.SetName (aName : String);
begin
   Name := aName;
end;

procedure  TSendClass.SendShiftAttack (abo: Boolean);
var
   ComData : TWordComData;
   pcKey: PTCKey;
begin
   pcKey := @ComData.Data;
   with pcKey^ do begin
      rmsg := SM_BOSHIFTATTACK;
      if abo then rkey := 0
      else rkey := 1;
      ComData.Size := SizeOf (TCKey);
   end;
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure  TSendClass.SendAttribFightBasic (astr: string);
var
   ComData : TWordComData;
   psAttribFightBasic: PTSAttribFightBasic;
begin
   psAttribFightBasic := @ComData.Data;
   with psAttribFightBasic^ do begin
      rmsg := SM_ATTRIB_FIGHTBASIC;
      SetWordString (rWordString, astr);
      ComData.Size := sizeof(TSAttribFightBasic) - sizeof(TWordString) + sizeofwordstring(rwordstring);
   end;
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure  TSendClass.SendAttribValues (aAttribClass : Pointer);
var
   ComData : TWordComData;
   psAttribValues: PTSAttribValues;
   AttribClass : TAttribClass;
begin
   AttribClass := TAttribClass (aAttribClass);

   psAttribValues := @ComData.Data;
   with psAttribValues^ do begin
      rmsg := SM_ATTRIB_VALUES;

      rLight := AttribClass.Light;
      rDark := AttribClass.Dark;
      rMagic := AttribClass.Magic;

      rTalent := AttribClass.Talent;
      rGoodChar := AttribClass.GoodChar;
      rBadChar := AttribClass.BadChar;
      rLucky := AttribClass.Lucky;
      rAdaptive := AttribClass.Adaptive;
      rRevival := AttribClass.Revival;
      rimmunity := AttribClass.immunity;
      rVirtue := AttribClass.Virtue;

      rhealth := AttribClass.CurHealth * 10000 div AttribClass.Health;
      rsatiety := AttribClass.CurSatiety * 10000 div AttribClass.Satiety;
      rpoisoning := AttribClass.CurPoisoning * 10000 div AttribClass.Poisoning;

      rHeadSeak := AttribClass.CurHeadLife * 10000 div AttribClass.HeadLife;
      rArmSeak := AttribClass.CurArmLife * 10000 div AttribClass.ArmLife;
      rLegSeak := AttribClass.CurLegLife * 10000 div AttribClass.LegLife;
      ComData.Size := SizeOf (TSAttribValues);
   end;

   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure  TSendClass.SendExtraAttribValues (aAttribClass : Pointer);
var
   ComData : TWordComData;
   psExtraAttribValues: PTSExtraAttribValues;
   AttribClass : TAttribClass;
begin
   AttribClass := TAttribClass (aAttribClass);

   psExtraAttribValues := @ComData.Data;
   with psExtraAttribValues^ do begin
      rmsg := SM_EXTRAATTRIB_VALUES;
      ExtraExp := AttribClass.ExtraExp;
      AddableStatePoint := AttribClass.AddableStatePoint;      
      ComData.Size := SizeOf (TSExtraAttribValues);
   end;

   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure TSendClass.SendAbilityAttrib (aLifeData : TLifeData; aRealAddAttribData : TRealAddAttribData; pAttackMagicData : PTMagicData);
var
   ComData : TWordComData;
   psAbilityAttrib : PTSAbilityAttrib;
begin
   psAbilityAttrib := @ComData.Data;
   with psAbilityAttrib^ do begin
      rmsg := SM_ABILITYATTRIB;

      if pAttackMagicData = nil then begin
         rAttackSpeed := aLifeData.AttackSpeed;
         rAvoid := aLifeData.avoid;
         rAccuracy := aLifeData.Accuracy;
         rKeepRecovery := aLifeData.KeepRecovery;
         rArmorBody := aLifeData.armorBody;
         rArmorHead := aLifeData.armorHead;
         rArmorArm := aLifeData.armorArm;
         rArmorLeg := aLifeData.armorLeg;
      end else begin
         case pAttackMagicData^.rMagicType of
            MAGICTYPE_BOWING, MAGICTYPE_THROWING : begin
               rAttackSpeed := aLifeData.AttackSpeed + aRealAddAttribData.rBowAttSpd;
               rAvoid := aLifeData.avoid + aRealAddAttribData.rBowAvoid;
               rAccuracy := aLifeData.Accuracy + aRealAddAttribData.rBowAccuracy;
               rKeepRecovery := aLifeData.KeepRecovery + aRealAddAttribData.rBowKeepRecovery;
               rArmorBody := aLifeData.armorBody + aRealAddAttribData.rBowBodyArmor;
               rArmorHead := aLifeData.armorHead + aRealAddAttribData.rBowHeadArmor;
               rArmorArm := aLifeData.armorArm + aRealAddAttribData.rBowArmArmor;
               rArmorLeg := aLifeData.armorLeg + aRealAddAttribData.rBowLegArmor;
            end;
            MAGICTYPE_WINDOFHAND : begin
               rAttackSpeed := aLifeData.AttackSpeed + aRealAddAttribData.rHandSpd;
               rAvoid := aLifeData.avoid;
               rAccuracy := aLifeData.Accuracy + aRealAddAttribData.rHandAccuracy;
               rKeepRecovery := aLifeData.KeepRecovery + aRealAddAttribData.rHandKeepRecovery;
               rArmorBody := aLifeData.armorBody + aRealAddAttribData.rHandBodyArmor;
               rArmorHead := aLifeData.armorHead;
               rArmorArm := aLifeData.armorArm;
               rArmorLeg := aLifeData.armorLeg;
            end;
            Else begin
               rAttackSpeed := aLifeData.AttackSpeed + aRealAddAttribData.rApproachSpd;
               rAvoid := aLifeData.avoid + aRealAddAttribData.rApproachAvoid;
               rAccuracy := aLifeData.Accuracy + aRealAddAttribData.rApproachAccuracy;
               rKeepRecovery := aLifeData.KeepRecovery + aRealAddAttribData.rApproachKeepRecovery;
               rArmorBody := aLifeData.armorBody + aRealAddAttribData.rApproachBodyArmor;
               rArmorHead := aLifeData.armorHead + aRealAddAttribData.rApproachHeadArmor;
               rArmorArm := aLifeData.armorArm + aRealAddAttribData.rApproachArmArmor;
               rArmorLeg := aLifeData.armorLeg + aRealAddAttribData.rApproachLegArmor;
            end;
         end;
      end;

      rRecovery := aLifeData.recovery;
      rDamageBody := aLifeData.damageBody + aRealAddAttribData.rAddBodyDamage;
      rDamageHead := aLifeData.damageHead + aRealAddAttribData.rAddHeadDamage;
      rDamageArm := aLifeData.damageArm + aRealAddAttribData.rAddArmDamage;
      rDamageLeg := aLifeData.damageLeg + aRealAddAttribData.rAddLegDamage;

      ComData.Size := SizeOf (TSAbilityAttrib);
   end;

   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure  TSendClass.SendAttribBase (aAttribClass : Pointer);
var
   ComData : TWordComData;
   psAttribBase : PTSAttribBase;
   AttribClass : TAttribClass;
begin
   AttribClass := TAttribClass (aAttribClass);

   psAttribBase := @ComData.Data;
   with psAttribBase^ do begin
      rmsg := SM_ATTRIBBASE;
      rAge := AttribClass.Age;
      // add by Orber at 2004-12-22 14:45:30

      StrPCopy(@rLover,AttribClass.Lover);
      rEnergy := AttribClass.Energy;
      rCurEnergy := AttribClass.CurEnergy;

      rInPower := AttribClass.InPower;
      rCurInPower := AttribClass.CurInPower;

      rOutPower := AttribClass.OutPower;
      rCurOutPower := AttribClass.CurOutPower;

      rMagic := AttribClass.Magic;
      rCurMagic := AttribClass.CurMagic;

      rLife := AttribClass.Life;
      rCurLife := AttribClass.CurLife;
      ComData.Size := SizeOf (TSAttribBase);
   end;
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure  TSendClass.SendChangeState (var aSenderinfo: TBasicData);
var
   ComData : TWordComData;
   psChangeState : PTSChangeState;
begin
   psChangeState := @ComData.Data;
   with psChangeState^ do begin
      rmsg := SM_CHANGESTATE;
      rId := aSenderInfo.id;
      rState := aSenderInfo.Feature.rHitMotion;
      rFrameStart := aSenderInfo.nx;
      rFrameEnd := aSenderInfo.ny;
      ComData.Size := SizeOf (TSChangeState);
   end;
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure  TSendClass.SendChangeFeature (var aSenderinfo: TBasicData);
var
   ComData : TWordComData;
   psChangeFeature : PTSChangeFeature;
begin
   psChangeFeature := @ComData.Data;
   with psChangeFeature^ do begin
      rmsg := SM_CHANGEFEATURE;
      rId := aSenderInfo.id;
      rFeature := aSenderInfo.Feature;
//      if aSenderInfo.MonType <> 0 then begin rFeature.rrace := RACE_HUMAN; end;
//change by minds
      if aSenderInfo.MonType <> 0 then rFeature.rrace := RACE_HUMAN;
      if rFeature.rTeamColor >= 100 then
         rFeature.rTeamColor := (rFeature.rTeamColor - 100) mod 18 + 103;

      if rFeature.rrace = RACE_NPC then rFeature.rrace := RACE_MONSTER;
//change by minds
//      SetWordString (rWordString, StrPas (@aSenderInfo.MarketName));
      ComData.Size := SizeOf (TSChangeFeature);
   end;
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure  TSendClass.SendChangeProperty (var aSenderinfo: TBasicData);
var
   ComData : TWordComData;
   psChangeProperty : PTSChangeProperty;
   str : String;
begin
   psChangeProperty := @ComData.Data;
   with psChangeProperty^ do begin
      str := StrPas (@aSenderInfo.ViewName);
      if aSenderInfo.Guild[0] <> 0 then
         str := str + ',' + StrPas (@aSenderInfo.Guild);
      if Length (str) >= 18 then str := Copy (str, 1, 18);

      rmsg := SM_CHANGEPROPERTY;
      rId := aSenderInfo.id;
      StrPCopy(@rNameString, str);
      ComData.Size := SizeOf (TSChangeProperty);
   end;

   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure  TSendClass.SendEventString (astr: string);
var
   ComData : TWordComData;
   psEventString : PTSEventString;
begin
   psEventString := @ComData.Data;
   with psEventString^ do begin
      rmsg := SM_EVENTSTRING;
      SetWordString (rWordString, astr);
      ComData.Size := sizeof(TSEventString) - sizeof(TWordString) + sizeofwordstring(rwordstring);
   end;
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure  TSendClass.SendUsedMagicString (astr: string);
var
   ComData : TWordComData;
   psEventString : PTSEventString;
begin
   psEventString := @ComData.Data;
   with psEventString^ do begin
      rmsg := SM_USEDMAGICSTRING;
      SetWordString (rWordString, astr);
      ComData.Size := sizeof(TSEventString) - sizeof(TWordString) + sizeofwordstring(rwordstring);
   end;
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure TSendClass.SendShootMagic (var aSenderinfo: TBasicData; atid: integer; ax, ay, abowimage, abowspeed : word; aType : Byte; aeen : word; aeek : TLightEffectKind);
var
   ComData : TWordComData;
   psMovingMagic: PTSMovingMagic;
begin
   psMovingMagic := @ComData.Data;
   with psMovingMagic^ do begin
      rmsg := SM_MOVINGMAGIC;
      rsid := aSenderInfo.id;
      reid := atid;
      rtx := ax;
      rty := ay;
      rMoveingstyle := 0;
      rsf := 0;
      rmf := abowimage;
      ref := 0;
      rspeed := abowspeed; //rspeed := 20;

      rafterimage := 0;
      rafterover := 0;
      rtype := atype;
      rsEffectNumber := 0;
      rsEffectKind := lek_none;
      reEffectNumber := aeen;
      reEffectKind := aeek;

      ComData.Size := SizeOf (TSMovingMagic);
   end;
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;


procedure  TSendClass.SendSayUseMagic (var aSenderinfo: TBasicData; astr: string);
var
   ComData : TWordComData;
   psSay : PTSSay;
begin
   psSay := @ComData.Data;
   with psSay^ do begin
      rmsg := SM_SAYUSEMAGIC;
      rId  := aSenderInfo.id;
      rkind := 0;
      SetWordString (rWordString, astr);
      ComData.Size := sizeof(TSSay) - sizeof(TWordString) + sizeofwordstring(rwordstring);
   end;
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure  TSendClass.SendSay (var aSenderinfo: TBasicData; astr: string);
var
   ComData : TWordComData;
   psSay : PTSSay;
begin
   psSay := @ComData.Data;
   with psSay^ do begin
      rmsg := SM_SAY;
      rId  := aSenderInfo.id;
      rkind := 0;
      SetWordString (rWordString, astr);
      ComData.Size := sizeof(TSSay) - sizeof(TWordString) + sizeofwordstring(rwordstring);
   end;
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure  TSendClass.SendTurn (var aSenderinfo: TBasicData ;relativity_x : integer = 0; relativity_y : integer =0);
var
   ComData : TWordComData;
   psTurn : PTSTurn;
begin
   psTurn := @ComData.Data;
   with psTurn^ do begin
      rmsg := SM_TURN;
      rId := aSenderInfo.id;
      rdir := aSenderInfo.dir;
// change by minds 050221
      rx := aSenderInfo.x;
      ry := aSenderInfo.y;
{
      if (relativity_x = 0) and (relativity_y = 0) then begin
         rx := aSenderInfo.x;
         ry := aSenderInfo.y;
      end else begin
         rx := MaskValue(rid, rdir, aSenderInfo.x, relativity_x);
         ry := MaskValue(rid, rdir, aSenderInfo.y, relativity_y);
      end;
}
      ComData.Size := SizeOf (TSTurn);
   end;
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure  TSendClass.SendMove (var aSenderinfo: TBasicData ;relativity_x : integer =0 ;relativity_y : integer =0);
var
   ComData : TWordComData;
   psMove : PTSMove;
begin
   psMove := @ComData.Data;
   with psMove^ do begin
      rmsg := SM_MOVE;
      rId := aSenderInfo.id;
      rdir := aSenderInfo.dir;
// change by minds 050221
      rx := aSenderInfo.nx;
      ry := aSenderInfo.ny;
{      if (relativity_x = 0) and (relativity_y = 0) then begin
         rx := aSenderInfo.nx;
         ry := aSenderInfo.ny;
      end else begin
         rx := MaskValue(rid, rdir, aSenderInfo.nx, relativity_x);
         ry := MaskValue(rid, rdir, aSenderInfo.ny, relativity_y);
      end;}
      ComData.Size := SizeOf (TSMove);
   end;
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure  TSendClass.SendBackMove (var aSenderinfo: TBasicData ; relativity_x : integer = 0; relativity_y : integer =0);
var
   ComData : TWordComData;
   psMove : PTSMove;
begin
   psMove := @ComData.Data;
   with psMove^ do begin
      rmsg := SM_BACKMOVE;
      rId := aSenderInfo.id;
      rdir := aSenderInfo.dir;
// change by minds 050221
      rx := aSenderInfo.nx;
      ry := aSenderInfo.ny;
      {if (relativity_x = 0) and (relativity_y = 0) then begin
         rx := aSenderInfo.nx;
         ry := aSenderInfo.ny;
      end else begin
         rx := MaskValue(rid, rdir, aSenderInfo.nx, relativity_x);
         ry := MaskValue(rid, rdir, aSenderInfo.ny, relativity_y);
      end;}

      ComData.Size := SizeOf (TSMove);
   end;
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure TSendClass.SendSetPosition (var aSenderinfo: TBasicData);
var
   ComData : TWordComData;
   psSetPosition : PTSSetPosition;
begin
   psSetPosition := @ComData.Data;
   with psSetPosition^ do begin
      rmsg := SM_SETPOSITION;
      rid := aSenderInfo.id;
      rdir := aSenderInfo.dir;
      rx := aSenderInfo.x;
      ry := aSenderInfo.y;
      ComData.Size := SizeOf (TSSetPosition);
   end;
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure  TSendClass.SendMap (var aSenderInfo: TBasicData; aManager : TManager);
var
   ComData : TWordComData;
   psNewMap : PTSNewMap;
begin
   SendSoundBase ('', 100);

   psNewMap := @ComData.Data;
   FillChar (psNewMap^, SizeOf (TSNewMap), 0);
   with psNewMap^ do begin
      rmsg := SM_NEWMAP;
      StrPCopy (@rMapName, aManager.MapName);
      StrCopy (@rCharName, @aSenderInfo.ViewName);
      rId := aSenderInfo.id;
      rx := aSenderInfo.x;
      ry := aSenderInfo.y;
      StrPCopy (@rObjName, aManager.ObjName);
      StrPCopy (@rRofName, aManager.RofName);
      StrPCopy (@rTilName, aManager.TilName);
      rboDark := aManager.boDark;
      rboRain := aManager.boRain;
      ComData.Size := SizeOf (TSNewMap);
   end;
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));

   if aManager.SoundBase <> '' then begin
      SendSoundBase (aManager.SoundBase + '.wav', 100);
   end;
end;

procedure  TSendClass.SendActionState (var aSenderInfo: TBasicData);
var
   ComData : TWordComData;
   psSetAction : PTSSetActionState;
begin
   psSetAction := @ComData.Data;
   with psSetAction^ do begin
      rmsg := SM_SETACTIONSTATE;
      rId := aSenderInfo.id;
      rActionState := aSenderInfo.Feature.rActionState;
      ComData.Size := sizeof(TSSetActionState);
   end;
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure  TSendClass.SendEffect (var aSenderinfo: TBasicData; aDelay : integer; aEffectKind : TLightEffectKind; aEffectNumber : integer);
var
   ComData : TWordComData;
   psEffect : PTSSetEffect;
begin
   psEffect := @ComData.Data;
   with psEffect^ do begin
      rmsg := SM_SETEFFECT;
      rId := aSenderInfo.id;
      rEffectNumber := aEffectNumber;
      rEffectKind := aEffectKind;
      rDelay := aDelay;
      ComData.Size := sizeof(TSSetEffect);
   end;
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure  TSendClass.SendScreenEffect (aseffectnum :Byte; aDelay : integer);
var
   ComData : TWordComData;
   psSEffect : PTSScreenEffect;
begin
   psSEffect := @ComData.Data;
   with psSEffect^ do begin
      rmsg := SM_SCREENEFFECT;
      rScreenEffectNum := aseffectnum;
      rDelay := aDelay;
      ComData.Size := sizeof(TSScreenEffect);
   end;
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure  TSendClass.SendShow (var aSenderinfo: TBasicData; aEffectNumber : Word; aEffectKind : TLightEffectKind; relativity_x : integer = 0; relativity_y : integer =0);
var
   ComData : TWordComData;
   i : integer;
   psShow : PTSShow;
   psShowItem : PTSShowItem;
   psShowDynamicObject : PTSShowDynamicObject;
   str : shortstring;
   // dod : TDynamicObjectData;
begin
   if aSenderInfo.ClassKind = CLASS_SERVEROBJ then exit;
   if (aSenderInfo.Feature.rrace = RACE_HUMAN) or (aSenderInfo.Feature.rRace = RACE_MONSTER)
      or (aSenderInfo.Feature.rRace = RACE_NPC) then begin
      psShow := @ComData.Data;
      with psShow^ do begin
         str := StrPas (@aSenderInfo.ViewName);
         if aSenderInfo.Guild[0] <> 0 then
            str := str + ',' + StrPas (@aSenderInfo.Guild);

         rmsg := SM_SHOW;
         rId := aSenderInfo.id;
         //by minds
         //StrPCopy (@rNameString, str);

         rdir := aSenderInfo.dir;
// change by minds 050221
         rx := aSenderInfo.x;
         ry := aSenderInfo.y;
         {if (relativity_x = 0) and (relativity_y = 0) then begin
            rx := aSenderInfo.x;
            ry := aSenderInfo.y;
         end else begin
            rx := MaskValue(rid, rdir, aSenderInfo.x, relativity_x);
            ry := MaskValue(rid, rdir, aSenderInfo.y, relativity_y);
         end;}

         rFeature := aSenderInfo.Feature;

         // add by Orber at 2004-09-27 17:07

         if StrPas(@aSenderInfo.ViewName) = Conv('±Ë°¶»¨') then begin
             aEffectNumber := 8001;
             aEffectKind := lek_continue;
         end;
         if StrPas(@aSenderInfo.ViewName) = Conv('æ¿¾ê»¨') then begin
             aEffectNumber := 8004;
             aEffectKind := lek_continue;
         end;

         if rFeature.rrace = RACE_NPC then rFeature.rrace := RACE_MONSTER;
         if aSenderInfo.MonType <> 0 then rFeature.rrace := RACE_HUMAN;

         if rFeature.rTeamColor >= 100 then
            rFeature.rTeamColor := (rFeature.rTeamColor - 100) mod 18 + 103;

         rFeature.rEffectNumber := aEffectNumber;
         rFeature.rEffectKind := aEffectKind;
         //by minds
         //SetWordString (rWordStangring, StrPas (@aSenderInfo.MarketName));
         SetWordString (rWordString, str);
         ComData.Size := sizeof(TSShow) - sizeof(twordstring) + sizeofwordstring(rwordstring);
      end;
      Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));

      for i := 0 to MAXCONDITIONCOUNT-1 do begin
         if aSenderInfo.conditionData[i].rEffectNumber <> 0 then begin
            SendEffect(aSenderInfo,0,lek_continue,aSenderInfo.conditionData[i].rEffectNumber);
         end;
      end;
      exit;
   end;

   if (aSenderInfo.Feature.rRace = RACE_ITEM)
      or (aSenderInfo.Feature.rRace = RACE_STATICITEM) then begin
      psShowItem := @ComData.Data;
      with psShowItem^ do begin
         rmsg := SM_SHOWITEM;
         rid := aSenderInfo.id;
         rNameString := aSenderInfo.ViewName;
         rx := aSenderInfo.x;
         ry := aSenderInfo.y;
         rShape := aSenderInfo.Feature.rImageNumber;
         rColor := aSenderInfo.Feature.rImageColorIndex;
         rRace := aSenderInfo.Feature.rRace;
         rEffectNumber := aEffectNumber;
         rEffectKind := aEffectKind;
         ComData.Size := SizeOf (TSShowItem);
      end;
      Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
      exit;
   end;

   if aSenderInfo.Feature.rrace = RACE_DYNAMICOBJECT then begin
      psShowDynamicObject := @ComData.Data;
      FillChar (psShowDynamicObject^, SizeOf (TSShowDynamicObject), 0);
      
      // DynamicObjectClass.GetDynamicObjectData (StrPas (@aSenderInfo.Name), dod);
      with psShowDynamicObject^ do begin
         rmsg := SM_SHOWDYNAMICOBJECT;
         rid := aSenderInfo.id;
         rNameString := aSenderInfo.ViewName;
         rx := aSenderInfo.x;
         ry := aSenderInfo.y;
         rShape := aSenderInfo.Feature.rImageNumber;
         rState := aSenderInfo.Feature.rHitMotion;
         rFrameStart := aSenderInfo.nx;
         rFrameEnd := aSenderInfo.ny;
         ComData.Size := SizeOf (TSShowDynamicObject);
      end;

      for i := 0 to 20 - 1 do begin
         if (aSenderInfo.GuardX [i] = 0) and (aSenderInfo.GuardY [i] = 0) then break;
         psShowDynamicObject^.rGuardX [i] := aSenderInfo.GuardX [i];
         psShowDynamicObject^.rGuardY [i] := aSenderInfo.GuardY [i];
      end;
      
      Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
      exit;
   end;
end;

procedure TSendClass.SendHide (var aSenderinfo: TBasicData);
var
   ComData : TWordComData;
   psHide : PTSHide;
begin
   if aSenderInfo.ClassKind = CLASS_SERVEROBJ then exit;
   
   psHide := @ComData.Data;
   with psHide^ do begin
      rmsg := SM_HIDE;
      if isObjectItemId (aSenderInfo.id) or isStaticItemId (aSenderInfo.id) then rmsg := SM_HIDEITEM;
      if isDynamicObjectID (aSenderInfo.id) then rmsg := SM_HIDEDYNAMICOBJECT;

      rid := aSenderInfo.id;
      ComData.Size := SizeOf (TSHide);
   end;
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure TSendClass.SendMotion (aid, amotion: integer; aMagicState, aMagicKind, aEffectColor : Byte);
var
   ComData : TWordComData;
   psMotion : PTSMotion;
begin
   psMotion := @ComData.Data;
   with psMotion^ do begin
      rmsg := SM_MOTION;
      rId := aid;
      rmotion := amotion;
      rMagicState := aMagicState + 1;     //±âº»¹«°ø°ú »ó½Â¹«°øÀÇ ±¸ºÐ.
      rMagicKind := aMagicKind + 1;       //¹«°øÀÇ Á¾·ù.
      rEffectColor := aEffectColor;       //±ØÀÎ ¹«°øÀÇ ÀÌÆåÆ® »ö±ò
      ComData.Size := SizeOf (TSMotion);
   end;
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure  TSendClass.SendStructed (var aSenderInfo : TBasicData; aPercent: integer);
var
   ComData : TWordComData;
   psStructed : PTSStructed;
begin
   psStructed := @ComData.Data;
   with psStructed^ do begin
      rmsg := SM_STRUCTED;
      rId := aSenderInfo.ID;
      if aSenderInfo.Feature.rRace <> RACE_DYNAMICOBJECT then begin
         rRace := RACE_HUMAN;
      end else begin
         rRace := aSenderInfo.Feature.rRace;
      end;
      rpercent := apercent;
      ComData.Size := SizeOf (TSStructed);
   end;
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure TSendClass.SendChatMessage (const astr: string; aColor: byte);
var
   ComData : TWordComData;
   psChatMessage : PTSChatMessage;
begin
   psChatMessage := @ComData.Data;
   with psChatMessage^ do begin
      rmsg := SM_CHATMESSAGE;
      case acolor of
         SAY_COLOR_NORMAL : begin rFColor := WinRGB (22,22,22); rBColor := WinRGB (0, 0 ,0); end;
         SAY_COLOR_SHOUT  : begin rFColor := WinRGB (22,22,22); rBColor := WinRGB (0, 0 ,24); end;
         SAY_COLOR_SYSTEM : begin rFColor := WinRGB (22,22, 0); rBColor := WinRGB (0, 0 ,0); end;
         SAY_COLOR_NOTICE : begin rFColor := WinRGB (255 div 8, 255 div 8, 255 div 8); rBColor := WinRGB (133 div 8, 133 div 8, 133 div 8); end;

         SAY_COLOR_GRADE0 : begin rFColor := WinRGB (18, 16, 14); rBColor := WinRGB (2,4,5); end;
         SAY_COLOR_GRADE1 : begin rFColor := WinRGB (26, 23, 21); rBColor := WinRGB (2,4,5); end;
         SAY_COLOR_GRADE2 : begin rFColor := WinRGB (31, 29, 27); rBColor := WinRGB (2,4,5); end;
         SAY_COLOR_GRADE3 : begin rFColor := WinRGB (22, 18,  8); rBColor := WinRGB (1,4,11); end;
         SAY_COLOR_GRADE4 : begin rFColor := WinRGB (23, 13,  4); rBColor := WinRGB (1,4,11); end;
         SAY_COLOR_GRADE5 : begin rFColor := WinRGB (31, 29, 21); rBColor := WinRGB (1,4,11); end;

         else begin rFColor := WinRGB (22,22,22); rBColor := WinRGB (0, 0 ,0); end;
      end;

      SetWordString (rWordstring, aStr);
      ComData.Size := Sizeof(TSChatMessage) - Sizeof(TWordString) + sizeofwordstring(rWordString);
   end;
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure TSendClass.SendMessenger (const aTimeStr, aStr : String);
var
   ComData : TWordComData;
   psMessenger : PTSMessenger;
begin
   psMessenger := @ComData.Data;
   psMessenger^.rmsg := SM_MESSENGER;
   StrPCopy (@psMessenger^.rTime, aTimeStr);
   SetWordString (psMessenger^.rWordString, aStr);
   ComData.Size := SizeOf (TSMessenger) - SizeOf (TWordString) + SizeOfWordString (psMessenger^.rWordString);

   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word)); 
end;

procedure TSendClass.SendSideMessage (const aStr : String);
var
   ComData : TWordComData;
   psMsg : PTWordInfoString;
begin
   psMsg := @ComData.Data;
   psMsg^.rmsg := SM_SIDEMESSAGE;
   SetWordString (psMsg^.rWordString, aStr);
   ComData.Size := SizeOf (TWordInfoString) - SizeOf (TWordString) + SizeOfWordString (psMsg^.rWordString);

   Connector.AddSendData (@ComData, ComData.Size + SizeOF (Word));
end;

procedure TSendClass.SendStatusMessage (const astr: string);
var
   ComData : TWordComData;
   psMessage : PTSMessage;
begin
   psMessage := @ComData.Data;
   with psMessage^ do begin
      rmsg := SM_MESSAGE;
      rkey := MESSAGE_GAMEING;
      SetWordString (rWordstring, astr);
      ComData.Size := Sizeof(TSMessage) - Sizeof(TWordString) + sizeofwordstring(rWordString);
   end;
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure TSendClass.SendCenterMessage (const aStr : String);
var
   ComData : TWordComData;
   psMessage : PTSShowCenterMsg;
begin
   psMessage := @ComData.Data;
   psMessage^.rMsg := SM_SHOWCENTERMSG;
   psMessage^.rColor := SAY_COLOR_SYSTEM;
   SetWordString (psMessage^.rText, aStr);
   ComData.Size := Sizeof(TSShowCenterMsg) - Sizeof(TWordString) + sizeofwordstring(psMessage^.rText);

   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure TSendClass.SendTopMessage (const aStr : String);
var
   ComData : TWordComData;
   psMessage : PTSShowCenterMsg;
begin
   psMessage := @ComData.Data;
   psMessage^.rMsg := SM_SHOWTOPMSG;
   psMessage^.rColor := SAY_COLOR_SYSTEM;
   SetWordString (psMessage^.rText, aStr);
   ComData.Size := Sizeof(TSShowCenterMsg) - Sizeof(TWordString) + sizeofwordstring(psMessage^.rText);

   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure TSendClass.SendTopLetterMessage (const aName, aStr1, aStr2 : String);
var
   ComData : TWordComData;
   psEventMessage : PTSEventMessage;
begin
   FillChar(ComData, SizeOf(ComData), 0);
   psEventMessage := @ComData.Data;

   psEventMessage^.rMsg := SM_SHOWEVENTMSG;
   StrPCopy (@psEventMessage^.rName, aName);
   psEventMessage^.rMsg1 := aStr1;
   psEventMessage^.rMsg2 := aStr2;
   ComData.Size := SizeOf (TSEventMessage);

   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word)); 
end;

procedure TSendClass.SendMarketItem (akey: word; var ItemData: TItemData);
var
   ComData : TWordComData;
   psHaveItem : PTSHaveMarketItem;
begin
   psHaveItem := @ComData.Data;
   with psHaveItem^ do begin
      rmsg := SM_MARKETITEM;
      rkey := akey;
      rName := ItemData.rViewName;
      rCount := ItemData.rCount;
      rColor := Itemdata.rcolor;
      rShape := Itemdata.rShape;
      rPrice := ItemData.rPrice;
      ComData.Size := SizeOf (TSHaveMarketItem);
   end;
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure TSendClass.SendMaterialItem (akey: word; var ItemData: TItemData);
var
   ComData : TWordComData;
   psHaveItem : PTSHaveItem;
begin
   psHaveItem := @ComData.Data;
   with psHaveItem^ do begin
      rmsg := SM_MATERIALITEM;
      rkey := akey;
      rName := ItemData.rViewName;
      rCount := ItemData.rCount;
      rColor := Itemdata.rcolor;
      rShape := Itemdata.rShape;
      ComData.Size := SizeOf (TSHaveItem);
   end;
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

{
procedure TSendClass.SendHaveItem (akey: word; var ItemData: TItemData);
var
   ComData : TWordComData;
   psHaveItem : PTSHaveItem;
begin
   psHaveItem := @ComData.Data;
   with psHaveItem^ do begin
      rmsg := SM_HAVEITEM;
      rkey := akey;
      rName := ItemData.rViewName;
      rCount := ItemData.rCount;
      rColor := Itemdata.rcolor;
      rShape := Itemdata.rShape;
      ComData.Size := SizeOf (TSHaveItem);
   end;
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;
}

procedure TSendClass.SendHaveItem (akey: word; var ItemData: TItemData);
var
   ComData : TWordComData;
   psHaveItem : PTSHaveItemNew;
begin
   psHaveItem := @ComData.Data;
   with psHaveItem^ do begin
      rmsg := SM_HAVEITEM;
      rkey := akey;
      rName := ItemData.rViewName;
      rCount := ItemData.rCount;
      rColor := Itemdata.rcolor;
      rShape := Itemdata.rShape;
      if ItemData.rAddType <> 0 then begin
         rViewColor := clYellow;
      end else begin
         rViewcolor := clWhite;
      end;
      //add by Orber at 2004-09-07 10:33
      rLockState := ItemData.rLockState;
      runLockTime := ItemData.runLockTime;

      ComData.Size := SizeOf (TSHaveItemNew);
   end;
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;
  // add by Orber at 2005-01-12 03:46:47
  // ·¢ËÍÃÅÅÉÐÅÏ¢
procedure TSendClass.SendGuildInfo (GuildInfo: TSGuildListInfo);
var
   ComData : TWordComData;
   psGuildInfo : PTSGuildListInfo;
begin
   psGuildInfo := @ComData.Data;
   Move(GuildInfo,psGuildInfo^,SizeOf(GuildInfo));
   psGuildInfo^.rMsg := SM_GUILDINFO;
   ComData.Size := SizeOf (GuildInfo);
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure TSendClass.SendWearItem (akey: word; var ItemData: TItemData);
var
   ComData : TWordComData;
   psWearItem : PTSWearItem;
begin
   psWearItem := @ComData.Data;
   with psWearItem^ do begin
      rmsg := SM_WEARITEM;
      rkey := akey;
      rName := Itemdata.rViewName;
      rColor := Itemdata.rcolor;
      rShape := Itemdata.rShape;
      ComData.Size := SizeOf (TSWearItem);
   end;
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));

   if aKey = 1 then begin
      with psWearItem^ do begin
         rmsg := SM_WEARITEM;
         rkey := 5;
         rName := Itemdata.rViewName;
         rColor := Itemdata.rcolor;
         rShape := Itemdata.rShape;
         ComData.Size := SizeOf (TSWearItem);
      end;
      Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
   end;
end;

procedure TSendClass.SendHaveMagic (akey: word; var MagicData: TMagicData);
var
   ComData : TWordComData;
   psHaveMagic : PTSHaveMagic;
begin
   psHaveMagic := @ComData.Data;
   with psHaveMagic^ do begin
      rmsg := SM_HAVEMAGIC;
      rkey := akey;
      rShape := MagicData.rShape;
      rName := MagicData.rname;
      rSkillLevel := MagicData.rcSkillLevel;
      rpercent := 0;
      ComData.Size := SizeOf (TSHaveMagic);
   end;
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure TSendClass.SendHaveRiseMagic (akey: word; var MagicData: TMagicData);
var
   ComData : TWordComData;
   psHaveRiseMagic : PTSHaveRiseMagic;
begin
   psHaveRiseMagic := @ComData.Data;
   with psHaveRiseMagic^ do begin
      rMsg := SM_HAVERISEMAGIC;
      rKey := akey;
      rShape := MagicData.rShape;
      rName := MagicData.rname;
      rSkillLevel := MagicData.rcSkillLevel;
      rPercent := 0;
      ComData.Size := SizeOf (TSHaveMagic);
   end;
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure TSendClass.SendBasicMagic (akey: word; var MagicData: TMagicData);
var
   ComData : TWordComData;
   psHaveMagic : PTSHaveMagic;
begin
   psHaveMagic := @ComData.Data;
   with psHaveMagic^ do begin
      rmsg := SM_BASICMAGIC;
      rkey := akey;
      rShape := Magicdata.rShape;
      rName := MagicData.rname;
      rSkillLevel := Magicdata.rcSkillLevel;
      rpercent := 0;
      ComData.Size := SizeOf (TSHaveMagic);
   end;
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure TSendClass.SendHaveMystery (akey: word; var MagicData: TMagicData);
var
   ComData : TWordComData;
   psHaveMystery : PTSHaveMystery;
begin
   psHaveMystery := @ComData.Data;
   with psHaveMystery^ do begin
      rMsg := SM_HAVEMYSTERY;
      rKey := akey;
      rShape := MagicData.rShape;
      rName := MagicData.rname;
      rSkillLevel := MagicData.rcSkillLevel;
      rPercent := 0;
      ComData.Size := SizeOf (TSHaveMystery);
   end;
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure TSendClass.SendHaveBestSpecialMagic (akey: word; var MagicData: TMagicData);
var
   ComData : TWordComData;
   psHaveBestMagic : PTSHaveBestMagic;
begin
   psHaveBestMagic := @ComData.Data;
   with psHaveBestMagic^ do begin
      rMsg := SM_HAVEBESTMAGIC;
      rKey := akey;
      rShape := MagicData.rShape;
      rName := MagicData.rname;
      rSkillLevel := MagicData.rcSkillLevel;
      rPercent := 0;
      ComData.Size := SizeOf (TSHaveBestMagic);
   end;
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure TSendClass.SendHaveBestProtectMagic (akey: word; var MagicData: TMagicData);
var
   ComData : TWordComData;
   psHaveBestMagic : PTSHaveBestMagic;
begin
   psHaveBestMagic := @ComData.Data;
   with psHaveBestMagic^ do begin
      rMsg := SM_HAVEBESTMAGIC;
      rKey := akey+15;
      rShape := MagicData.rShape;
      rName := MagicData.rname;
      rSkillLevel := MagicData.rcSkillLevel;
      rPercent := 0;
      ComData.Size := SizeOf (TSHaveBestMagic);
   end;
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure TSendClass.SendHaveBestAttackMagic (akey: word; var MagicData: TMagicData);
var
   ComData : TWordComData;
   psHaveBestMagic : PTSHaveBestMagic;
begin
   psHaveBestMagic := @ComData.Data;
   with psHaveBestMagic^ do begin
      rMsg := SM_HAVEBESTMAGIC;
      rKey := akey+20;
      rShape := MagicData.rShape;
      rName := MagicData.rname;
      rSkillLevel := MagicData.rcSkillLevel;
      rPercent := 0;
      ComData.Size := SizeOf (TSHaveBestMagic);
   end;
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure  TSendClass.SendSoundEffect (asoundname: string; ax, ay : Word);
var
   ComData : TWordComData;
   psSoundString: PTSSoundString;
begin
   psSoundString := @ComData.Data;
   with psSoundString^ do begin
      rmsg := SM_SOUNDEFFECT;
      rHiByte := Length (asoundname);
      rLoByte := 0;
      StrPCopy (@rSoundName, asoundname);
      rX := ax;
      rY := ay;
      ComData.Size := SizeOf (TSSoundString);
   end;
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure  TSendClass.SendSoundBase (asoundname: string; aRoopCount: integer);
var
   ComData : TWordComData;
   psSoundBaseString: PTSSoundBaseString;
begin
   psSoundBaseString := @ComData.Data;
   with psSoundBaseString^ do begin
      rmsg := SM_SOUNDBASESTRING;
      rRoopCount := aroopcount;
      SetWordString (rWordString, asoundname);
      ComData.Size := Sizeof(TSSoundBaseString) - Sizeof(TWordString) + sizeofwordstring(rWordString);
   end;
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure TSendClass.SendSoundBase2 (asoundname: string; aRoopCount: integer);
var
   ComData : TWordComData;
   psSoundBaseString: PTSSoundBaseString;
begin
   psSoundBaseString := @ComData.Data;
   with psSoundBaseString^ do begin
      rmsg := SM_SOUNDBASESTRING2;
      rRoopCount := aroopcount;
      SetWordString (rWordString, aSoundName);
      ComData.Size := Sizeof(TSSoundBaseString) - Sizeof(TWordString) + sizeofwordstring(rWordString);
   end;
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure TSendClass.SendShowSpecialWindow (aUser : Pointer; aWindow : Byte; aType : Byte; aCaption : String; aComment : String);
var
   ComData : TWordComData;
   pSShowSpecialWindow : PTSShowSpecialWindow;
begin
   psShowSpecialWindow := @ComData.Data;

   with psShowSpecialWindow^ do begin
      rmsg := SM_SHOWSPECIALWINDOW;
      rWindow := aWindow;
      rKind := aType;
      StrPCopy (@rCaption, aCaption);
      SetWordString (rWordString, aComment);
      ComData.Size := sizeof(TSShowSpecialWindow) - sizeof(TWordString) + sizeofwordstring(rwordstring);
   end;
   
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure TSendClass.SendSsamzieItem (akey: word; var ItemData: TItemData);
var
   ComData : TWordComData;
   psLogItem : PTSLogItem;
begin
   psLogItem := @ComData.Data;
   with psLogItem^ do begin
      rmsg := SM_SSAMZIEITEM;
      rkey := aKey;
      rName := ItemData.rViewName;
      rCount := ItemData.rCount;
      rColor := Itemdata.rcolor;
      rShape := Itemdata.rShape;
      rLockState := ItemData.rLockState;
      runLockTime := ItemData.runLockTime;
      ComData.Size := SizeOf (TSLogItem);
   end;
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure TSendClass.SendGuildItem (akey: word; var ItemData: TItemData);
var
   ComData : TWordComData;
   psLogItem : PTSLogItem;
begin
   psLogItem := @ComData.Data;
   with psLogItem^ do begin
      rmsg := SM_GUILDITEM;
      rkey := aKey;
      rName := ItemData.rViewName;
      rCount := ItemData.rCount;
      rColor := Itemdata.rcolor;
      rShape := Itemdata.rShape;
      rLockState := ItemData.rLockState;
      runLockTime := ItemData.runLockTime;
      ComData.Size := SizeOf (TSLogItem);
   end;
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure  TSendClass.SendShowGuildMagicWindow (aMagicWindowData : PTSShowGuildMagicWindow);
var
   ComData : TWordComData;
begin
   ComData.Size := SizeOf (TSShowGuildMagicWindow);
   Move (aMagicWindowData^, ComData.Data, SizeOf (TSShowGuildMagicWindow));

   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure TSendClass.SendShowPasswordWindow (aOption : Byte);  // ºñ¹øÃ¢¶ç¿ì´Â°Å
var
   ComData : TWordComData;
   pSWindow : PTSPasswordWindow;
begin
   pSWindow := @ComData.Data;

   pSWindow^.rMsg := SM_PASSWORD;
   pSWindow^.rOption := aOption;

   ComData.Size := SizeOf (TSHideSpecialWindow);
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure TSendClass.SendShowPowerLevel (aName : String; aLevel : Integer);
var
   ComData : TWordComData;
   pSSetPowerLevel : PTSSetPowerLevel;
begin
   ComData.Size := SizeOf (TSSetPowerLevel);

   pSSetPowerLevel := @ComData.Data;
   pSSetPowerLevel^.rMsg := SM_SETPOWERLEVEL;
   StrPCopy (@pSSetPowerLevel^.rName, aName);
   pSSetPowerLevel^.rLevel := aLevel;

   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure  TSendClass.SendNetState (aID, aTick : Integer; var aQuestion: array of byte);
var
   ComData : TWordComData;
   pSNetState : PTSNetState;
begin
   ComData.Size := SizeOf (TSNetState);

   pSNetState := @ComData.Data;
   pSNetState^.rMsg := SM_NETSTATE;
   pSNetState^.rID := aID;
   pSNetState^.rMadeTick := aTick;
   Move(aQuestion, pSNetState.rQuestion, 16); 
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure TSendClass.SendMiniMapInfo (aStr : String);
var
   ComData : TWordComData;
   pSMiniMap : PTSMiniMap;
begin
   pSMiniMap := @ComData.Data;
   pSMiniMap^.rMsg := SM_MINIMAP;
   SetWordString (pSMiniMap^.rWordString, aStr);
   ComData.Size := sizeof(TSMiniMap) - sizeof(TWordString) + sizeofwordstring(pSMiniMap^.rWordString);

   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure TSendClass.SendSetShortCut (aPos : PByte);
var
   i : Integer;
   ComData : TWordComData;
   pSShortCut : PTSSetShortCut;
   Ptr : PByte;
begin
   Ptr := aPos;
   
   ComData.Size := SizeOf (TSSetShortCut);
   pSShortCut := @ComData.Data;
   pSShortCut^.rMsg := SM_SETSHORTCUT;
   for i := 0 to 8 - 1 do begin
      pSShortCut^.rPosition [i] := Ptr^;
      Inc (Ptr);
   end;

   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure TSendClass.SendShowHelpWindow (aFileName, aHelpText : String);
var
   ComData : TWordComData;
   pStartHelpWindow : PTSStartHelpWindow;
begin
   pStartHelpWindow := @ComData.Data;
   pStartHelpWindow^.rMsg := SM_STARTHELPWINDOW;
   StrPCopy (@pStartHelpWindow^.rFileName, aFileName);
   SetWordString (pStartHelpWindow^.rHelpText, aHelpText);
   ComData.Size := SizeOf (TSStartHelpWindow) - SizeOf (TWordString) + SizeOfWordString (pStartHelpWindow^.rHelpText);

   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure TSendClass.SendShowItemWindow (aName : String; aColor : Byte);
var
   ComData : TWordComData;
   psItemWindow : PTSItemWindow;
begin
   psItemWindow := @ComData.Data;
   psItemWindow^.rMsg := SM_ITEMHELPWINDOW;
   StrPCopy (@psItemWindow^.rName, aName); 
   psItemWindow^.rColor := aColor;

   ComData.Size := SizeOf (TSItemWindow);

   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word)); 
end;

{procedure TSendClass.SendShowItemWindow2 (aViewName, aContents : String; aShape, aColor, aPrice : Integer; aGrade : Byte);
var
   ComData : TWordComData;
   psItemWindow : PTSItemWindow2;
begin
   psItemWindow := @ComData.Data;
   psItemWindow^.rMsg := SM_ITEMHELPWINDOW2;
   StrPCopy (@psItemWindow^.rViewName, aViewName);
   psItemWindow^.rShape := aShape;
   psItemWindow^.rColor := aColor;
   psItemWindow^.rPrice := aPrice;
   psItemWindow^.rGrade := aGrade;
   SetWordString (psItemWindow^.rWordString, aContents);

   ComData.Size := SizeOf (TSItemWindow2) - SizeOf (TWordString) + SizeOfWordString (psItemWindow^.rWordString);

   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end; }

// add by Orber at 2004-09-07 14:09
procedure TSendClass.SendShowItemWindow2 (aViewName, aContents : String; aShape, aColor, aPrice : Integer ; aGrade : Byte; rLockState:Byte ; runLockTime:Word);
var
   ComData : TWordComData;
   psItemWindow : PTSItemWindow2;
begin
   psItemWindow := @ComData.Data;
   psItemWindow^.rMsg := SM_ITEMHELPWINDOW2;
   StrPCopy (@psItemWindow^.rViewName, aViewName);
   psItemWindow^.rShape := aShape;
   psItemWindow^.rColor := aColor;
   psItemWindow^.rPrice := aPrice;
   psItemWindow^.rGrade := aGrade;
   psItemWindow^.rLockState := rLockState;
   psItemWindow^.runLockTime := runLockTime;
   SetWordString (psItemWindow^.rWordString, aContents);

   ComData.Size := SizeOf (TSItemWindow2) - SizeOf (TWordString) + SizeOfWordString (psItemWindow^.rWordString);

   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;
procedure TSendClass.SendShowItemWindow3 (aViewName, aContents, aButton : String; aShape, aColor : Integer; aKey : Byte);
var
   ComData : TWordComData;
   psItemWindow : PTSItemWindow3;
begin
   psItemWindow := @ComData.Data;
   psItemWindow^.rMsg := SM_ITEMHELPWINDOW3;
   StrPCopy (@psItemWindow^.rViewName, aViewName);
   psItemWindow^.rShape := aShape;
   psItemWindow^.rColor := aColor;
   psItemWindow^.rKey := aKey;
   StrPCopy (@psItemWindow^.rButton, aButton);
   SetWordString (psItemWindow^.rWordString, aContents);

   ComData.Size := SizeOf (TSItemWindow3) - SizeOf (TWordString) + SizeOfWordString (psItemWindow^.rWordString);

   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure TSendClass.SendShowBestAttackMagicWindow (aViewName, aContents : String; aKey : Byte; aGrade, aShape: Integer;damageBody, damageHead, damageArm, damageLeg, damageEnergy : word);
var
   ComData : TWordComData;
   psBestAttackMagicWindow : PTSBestAttackMagicWindow;
begin
   psBestAttackMagicWindow := @ComData.Data;
   psBestAttackMagicWindow^.rMsg := SM_SHOWBESTATTACKMAGICWINDOW;
   StrPCopy (@psBestAttackMagicWindow^.rViewName, aViewName);
   psBestAttackMagicWindow^.rKey := aKey;
   psBestAttackMagicWindow^.rShape := aShape;
   psBestAttackMagicWindow^.rGrade := aGrade;
   psBestAttackMagicWindow^.rDamageBody := damageBody;
   psBestAttackMagicWindow^.rDamageHead := damageHead;
   psBestAttackMagicWindow^.rDamageArm := damageArm;
   psBestAttackMagicWindow^.rDamageLeg := damageLeg;
   psBestAttackMagicWindow^.rDamageEnergy := damageEnergy;
   SetWordString (psBestAttackMagicWindow^.rContents, aContents);

   ComData.Size := SizeOf (TSBestAttackMagicWindow) - SizeOf (TWordString) + SizeOfWordString (psBestAttackMagicWindow^.rContents);

   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure  TSendClass.SendShowBestProtectMagicwindow (aViewName, aContents: String; aKey : Byte; aGrade, aShape: integer; armorBody, armorHead, armorArm, armorLeg, armorEnergy : word);
var
   ComData : TWordComData;
   psBestProtectMagicWindow : PTSBestProtectMagicWindow;
begin
   psBestProtectMagicWindow := @ComData.Data;
   psBestProtectMagicWindow^.rMsg := SM_SHOWBESTPROTECTMAGICWINDOW;
   StrPCopy (@psBestProtectMagicWindow^.rViewName, aViewName);
   psBestProtectMagicWindow^.rKey := aKey;
   psBestProtectMagicWindow^.rShape := aShape;
   psBestProtectMagicWindow^.rGrade := aGrade;
   psBestProtectMagicWindow^.rArmorBody := armorBody;
   psBestProtectMagicWindow^.rArmorHead := armorHead;
   psBestProtectMagicWindow^.rArmorArm := armorArm;
   psBestProtectMagicWindow^.rArmorLeg := armorLeg;
   psBestProtectMagicWindow^.rArmorEnergy := armorEnergy;
   SetWordString (psBestProtectMagicWindow^.rContents, aContents);

   ComData.Size := SizeOf (TSBestProtectMagicWindow) - SizeOf (TWordString) + SizeOfWordString (psBestProtectMagicWindow^.rContents);

   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure  TSendClass.SendShowBestSpecialMagicWindow (aViewName, aContents : String; aKey: Byte; aNeedStatePoint,aShape: integer);
var
   ComData : TWordComData;
   psBestSpecialMagicwindow : PTSBestSpecialMagicWindow;
begin
   psBestSpecialMagicwindow := @ComData.Data;
   psBestSpecialMagicwindow^.rMsg := SM_SHOWBESTSPECIALMAGICWINDOW;
   StrPCopy (@psBestSpecialMagicwindow^.rViewName, aViewName);
   psBestSpecialMagicwindow^.rKey := aKey;
   psBestSpecialMagicwindow^.rShape := aShape;
   psBestSpecialMagicwindow^.rNeedStatePoint := aNeedStatePoint;
   SetWordString (psBestSpecialMagicwindow^.rContents, aContents);
   ComData.Size := SizeOf (TSBestSpecialMagicWindow) - SizeOf (TWordString) + SizeOfWordString (psBestSpecialMagicwindow^.rContents);

   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

//Author:Steven Date: 2005-01-10 17:32:30
//Note:ÊäÈëÃÅÅÉÃû³Æ
procedure TSendClass.SendShowInputGuildNameWindow(aHelpText : String ; SenderID : LongInt);
var
   ComData : TWordComData;
   pStartHelpWindow : PTSStartGuildInputWindow;
begin
   pStartHelpWindow := @ComData.Data;
   pStartHelpWindow^.rMsg := SM_INPUTGUILDNAMEWINDOW;
   pStartHelpWindow^.rSenderID := SenderID;
   SetWordString (pStartHelpWindow^.rHelpText, aHelpText);
   ComData.Size := SizeOf (TSStartHelpWindow) - SizeOf (TWordString) + SizeOfWordString (pStartHelpWindow^.rHelpText);
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

//Author:Steven Date: 2005-01-10 17:32:30
//Note:ÏÔÊ¾ÃÅÅÉÐÅÏ¢
procedure TSendClass.SendShowGuildInfoWindow(aGuildInfo : TSGuildInfo);
var
   ComData : TWordComData;
   psGuildInfo : PTSGuildInfo;
begin
   psGuildInfo := @ComData.Data;
   Move(aGuildInfo,psGuildInfo^,SizeOf(aGuildInfo));
   psGuildInfo^.rMsg := SM_GUILDINFOWINDOW;
   ComData.Size := SizeOf (aGuildInfo);
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;
//==============================================================


  // add by Orber at 2005-01-04 10:37:02
procedure TSendClass.SendShowMarryWindow (aHelpText : String);
var
   ComData : TWordComData;
   pStartHelpWindow : PTSStartHelpWindow;
begin
   pStartHelpWindow := @ComData.Data;
   pStartHelpWindow^.rMsg := SM_MARRYWINDOW;
   SetWordString (pStartHelpWindow^.rHelpText, aHelpText);
   ComData.Size := SizeOf (TSStartHelpWindow) - SizeOf (TWordString) + SizeOfWordString (pStartHelpWindow^.rHelpText);

   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure TSendClass.SendShowUnMarryWindow (aHelpText : String);
var
   ComData : TWordComData;
   pStartHelpWindow : PTSStartHelpWindow;
begin
   pStartHelpWindow := @ComData.Data;
   pStartHelpWindow^.rMsg := SM_UNMARRY;
   SetWordString (pStartHelpWindow^.rHelpText, aHelpText);
   ComData.Size := SizeOf (TSStartHelpWindow) - SizeOf (TWordString) + SizeOfWordString (pStartHelpWindow^.rHelpText);

   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure TSendClass.SendShowGuildApplyMoneyWindow (aHelpText : String);
var
   ComData : TWordComData;
   pStartHelpWindow : PTSStartHelpWindow;
begin
   pStartHelpWindow := @ComData.Data;
   pStartHelpWindow^.rMsg := SM_GUILDMONEYAPPLYWINDOW;
   SetWordString (pStartHelpWindow^.rHelpText, aHelpText);
   ComData.Size := SizeOf (TSStartHelpWindow) - SizeOf (TWordString) + SizeOfWordString (pStartHelpWindow^.rHelpText);

   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure TSendClass.SendShowGuildSubSysopWindow (aHelpText : String);
var
   ComData : TWordComData;
   pStartHelpWindow : PTSStartHelpWindow;
begin
   pStartHelpWindow := @ComData.Data;
   pStartHelpWindow^.rMsg := SM_GUILDSUBSYSOP;
   SetWordString (pStartHelpWindow^.rHelpText, aHelpText);
   ComData.Size := SizeOf (TSStartHelpWindow) - SizeOf (TWordString) + SizeOfWordString (pStartHelpWindow^.rHelpText);

   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure TSendClass.SendShowMarryAnswerWindow (aHelpText : String);
var
   ComData : TWordComData;
   pStartHelpWindow : PTSStartHelpWindow;
begin
   pStartHelpWindow := @ComData.Data;
   pStartHelpWindow^.rMsg := SM_MARRYANSWERWINDOW;
   SetWordString (pStartHelpWindow^.rHelpText, aHelpText);
   ComData.Size := SizeOf (TSStartHelpWindow) - SizeOf (TWordString) + SizeOfWordString (pStartHelpWindow^.rHelpText);

   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure TSendClass.SendShowGuildAnswerWindow (aHelpText : String);
var
   ComData : TWordComData;
   pStartHelpWindow : PTSStartHelpWindow;
begin
   pStartHelpWindow := @ComData.Data;
   pStartHelpWindow^.rMsg := SM_GUILDANSWERWINDOW;
   SetWordString (pStartHelpWindow^.rHelpText, aHelpText);
   ComData.Size := SizeOf (TSStartHelpWindow) - SizeOf (TWordString) + SizeOfWordString (pStartHelpWindow^.rHelpText);

   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure TSendClass.SendShowArenaWindow (aHelpText : String);
var
   ComData : TWordComData;
   pStartHelpWindow : PTSStartHelpWindow;
begin
   pStartHelpWindow := @ComData.Data;
   pStartHelpWindow^.rMsg := SM_ARENAWINDOW;
   SetWordString (pStartHelpWindow^.rHelpText, aHelpText);
   ComData.Size := SizeOf (TSStartHelpWindow) - SizeOf (TWordString) + SizeOfWordString (pStartHelpWindow^.rHelpText);

   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure TSendClass.SendShowJoinArenaWindow (aHelpText : String);
var
   ComData : TWordComData;
   pStartHelpWindow : PTSStartHelpWindow;
begin
   pStartHelpWindow := @ComData.Data;
   pStartHelpWindow^.rMsg := SM_ARENAJOINWINDOW;
   SetWordString (pStartHelpWindow^.rHelpText, aHelpText);
   ComData.Size := SizeOf (TSStartHelpWindow) - SizeOf (TWordString) + SizeOfWordString (pStartHelpWindow^.rHelpText);

   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure TSendClass.SendShowInputMoneyChipWindow (aHelpText : String);
var
   ComData : TWordComData;
   pStartHelpWindow : PTSStartHelpWindow;
begin
   pStartHelpWindow := @ComData.Data;
   pStartHelpWindow^.rMsg := SM_GUILDMONEYCHIPWINDOW;
   SetWordString (pStartHelpWindow^.rHelpText, aHelpText);
   ComData.Size := SizeOf (TSStartHelpWindow) - SizeOf (TWordString) + SizeOfWordString (pStartHelpWindow^.rHelpText);

   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;


procedure TSendClass.SendShowTradeWindow (aFileName, aHelpText : String);
var
   ComData : TWordComData;
   pStartHelpWindow : PTSStartHelpWindow;
begin
   pStartHelpWindow := @ComData.Data;
   pStartHelpWindow^.rMsg := SM_TRADEWINDOW;
   StrPCopy (@pStartHelpWindow^.rFileName, aFileName);
   SetWordString (pStartHelpWindow^.rHelpText, aHelpText);
   ComData.Size := SizeOf (TSStartHelpWindow) - SizeOf (TWordString) + SizeOfWordString (pStartHelpWindow^.rHelpText);

   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure TSendClass.SendShowMarketWindow (aMarketCount : Integer);
var
   ComData : TWordComData;
   pShowMarketWindow : PTSShowMarketWindow;
begin
   pShowMarketWindow := @ComData.Data;
   pShowMarketWindow^.rMsg := SM_MARKETWINDOW;
   pShowMarketWindow^.rMarketCount := aMarketCount;
   ComData.Size := SizeOf (TSShowMarketWindow);

   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word)); 
end;

procedure TSendClass.SendSkillWindow (aShape : Byte; aJobKind, aJobGrade, aJobTool : String;
   AExtJobGrade: String; AExtJobLevel: Integer);
var
   ComData : TWordComData;
   pShowJobWindow : PTSShowJobWindow;
begin
   pShowJobWindow := @ComData.Data;
   pShowJobWindow^.rMsg := SM_SKILLWINDOW;
   pShowJobWindow^.rShape := aShape;
   StrPCopy (@pShowJobWindow^.rJobKind, aJobKind);
   StrPCopy (@pShowJobWindow^.rJobGrade, aJobGrade);
   StrPCopy (@pShowJobWindow^.rJobTool, aJobTool);
   //Author:Steven Date: 2005-02-03 16:46:12
   //Note:²É¼¯¼¼ÄÜ
   StrPCopy (@pShowJobWindow^.rExtJobGrade, AExtJobGrade);
   pShowJobWindow^.rExtJobLevel := AExtJobLevel;
   //======================================
   ComData.Size := SizeOf (TSShowJobWindow);

   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure TSendClass.SendTopLetterWindow;
var
   ComData : TWordComData;
   pcKey : PTCKey;
begin
   FillChar(ComData, SizeOf(ComData), 0);
   pcKey := @ComData.Data;
   with pcKey^ do begin
      rmsg := SM_SHOWEVENTINPUT;
      ComData.Size := SizeOf (TCKey);
   end;
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure TSendClass.SendGuildEnergy(aGuildEnergyLevel : Byte);
var
   ComData : TWordComData;
   pcKey : PTCKey;
begin
   pcKey := @ComData.Data;
   with pcKey^ do begin
      rmsg := SM_GUILDENERGY;
      rkey := aGuildEnergyLevel;
      ComData.Size := SizeOf (TCKey);
   end;
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure TSendClass.SendJobResult (aboSuccess : Boolean; aWorkSound, aResultSound, aMsgStr : String);
var
   ComData : TWordComData;
   pSJobResult : PTSJobResult;
begin
   pSJobResult := @ComData.Data;
   pSJobResult^.rMsg := SM_JOBRESULT;
   pSJobResult^.rboSuccess := aboSuccess; // ¼º°ø/½ÇÆÐ ¿©ºÎ
   StrPCopy (@pSJobResult^.rWorkSound, aWorkSound);
   StrPCopy (@pSJobResult^.rResultSound, aResultSound);
   SetWordString (pSJobResult^.rWordString, aMsgStr);

   ComData.Size := SizeOf (TSJobResult) - SizeOf (TWordString) + SizeOfWordString (pSJobResult^.rWordString);
   Connector.AddSendData (@ComDAta, ComData.Size + SizeOf (Word));
end;

procedure TSendClass.SendMarketResult (aSuccessKey : Integer);
var
   ComData : TWordComData;
   pKey : PTCKey;
begin
   pKey := @ComData.Data;
   pKey^.rmsg := SM_CONFIRMMARKET;
   pKey^.rkey := aSuccessKey;

   ComData.Size := SizeOf (TCKey);
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure TSendClass.SendTime (aTimeStr : String);
var
   ComData : TWordComData;
   pWordInfo : PTWordInfoString;
begin
   pWordInfo := @ComData.Data;
   pWordInfo^.rmsg := SM_TIME;
   SetWordString (pWordInfo^.rWordString, aTimeStr);

   ComData.Size := SizeOf (TWordInfoString) - SizeOf (TWordString) + SizeOfWordString (pWordInfo^.rWordString);
   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word)); 
end;

procedure TSendClass.SendBattleBar (aLeftName, aRightName : String; aLeftWin, aRightWin : Byte; aLeftPercent, aRightPercent, aBattleType : Integer);
var
   ComData : TWordComData;
   psShowBar : PTSShowBattleBar;
begin
   psShowBar := @ComData.Data;

   with psShowBar^ do begin
      rMsg := SM_SHOWBATTLEBAR;
      rWinType := aBattleType;
      StrPCopy (@rLeftName, aLeftName);
      rLeftWin := aLeftWin;
      rLeftPercent := aLeftPercent;
      StrPCopy (@rRightName, aRightName);
      rRightWin := aRightWin;
      rRightPercent := aRightPercent;
      ComData.Size := SizeOf (TSShowBattleBar);
   end;

   Connector.AddSendData (@ComData, ComData.Size + SizeOf (Word));
end;

procedure TSendClass.SendLotteryInfo (ainfostr : string);
var
   cnt : integer;
   usd : TStringData;
begin
   usd.rmsg := 5;

   SetWordString (usd.rWordString, aInfoStr);

   cnt := sizeof(usd) - sizeof(TWordString) + sizeofwordstring (usd.rwordstring);
   
   FrmSockets.UdpObjectAddData (cnt, @usd);
end;


{
procedure TSendClass.SendProcessItem (aKey : Integer; aMsgStr : String);
var
   ComData : TWordComData;
   pMessage : PTSMessage;
begin
   pMessage := @ComData.Data;
   pMessage^.rMsg := SM_PROCESSITEM;
   pMessage^.rKey := aKey;                       // key  0 : ½ÇÆÐ   1 : ¼º°ø
   SetWordString (pMessage^.rWordString, aMsgStr);

   ComData.Size := SizeOf (TSMessage) - SizeOf (TWordString) + SizeOfWordString (pMessage^.rWordString);
   Connector.AddSendData (@ComDAta, ComData.Size + SizeOf (Word));
end;
}

procedure TSendClass.SendSystemInfo;
var
   Comdata : TWordComData;
   pKey : PTCKey;
begin
   pKey := @ComData.Data;
   pKey^.rmsg := SM_SYSTEMINFO;
   pKey^.rkey := 0;

   ComData.Size := SizeOf (TCKey);
   Connector.AddSendData (@ComData, ComData.Size + SizeOF (Word));
end;

procedure TSendClass.SendData (var aComData : TWordComData);
begin
   Connector.AddSendData (@aComData, aComData.Size + SizeOf (Word));
end;
//Author:Steven Date: 2004-12-08 17:14:35
//Note:
procedure TSendClass.SendIsInviteTeam(AUserName: string; ACaption: string;
  AText: string; var AKey: String);
var
  Comdata: TWordComData;
  pSShowInviteConfirm: PTSShowInviteConfirm;
  Guid: TGUID;
  Caption, Text: string;
begin
  pSShowInviteConfirm := @ComData.Data;
  with pSShowInviteConfirm^ do
  begin
    rMsg := SM_ISINVITETEAM;
    rWindow := WINDOW_CONFIRM;
    rKind := AGREE_INVITATION;
    StrPCopy(@rCaption, ACaption);
    StrPCopy(@rInvitedSender, AUserName);
    SetWordString(rWordString, AText);
    CoCreateGuid(Guid);
    StrPCopy(@rKey, GuidToString(Guid));
    AKey := GuidToString(Guid);
    ComData.Size := SizeOf(TSShowInviteConfirm) - SizeOf(TWordString) +
      SizeofWordString(rWordString);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendTeamMemberList(AMemberList: array of TNameString);
var
  Comdata: TWordComData;
  pSTeamMemberList: PTSTeamMemberList;
  i: Integer;
begin
  pSTeamMemberList := @ComData.Data;
  with pSTeamMemberList^ do
  begin
    rMsg := SM_TEAMMEMBERLIST;
    rWindow := WINDOW_TEAMMEMBERLIST;
    for i := 0 to MAX_TEAM_MEMBER - 1 do
      rMember[i] := AMemberList[i];
    ComData.Size := SizeOf(TSTeamMemberList);
    Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
  end;
end;
//===========================================

end.











