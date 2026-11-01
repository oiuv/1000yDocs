unit uSkills;

interface

uses
   Windows, Classes, SysUtils, BasicObj, DefType, uAnsTick, AnsStringCls,
   uMopSub, uWorkBox;

const
   DIVRESULT_NONE = 0;
   DIVRESULT_WHATSELL = 1;
   DIVRESULT_WHATBUY = 2;
   DIVRESULT_SELLITEM = 3;
   DIVRESULT_BUYITEM = 4;
   DIVRESULT_HOWMUCH = 5;

type
   TExpLinkData = record
      ID : Integer;
      DecLife : Integer;
   end;
   PTExpLinkData = ^TExpLinkData;

   TSpeechData = record
      rSayString : String;
      rSpeechTick : integer;
      rDelayTime : integer;
   end;
   PTSpeechData = ^TSpeechData;

   TDeallerData = record
      rHearString : String;
      rSayString : String;
      rNeedItem : array[0..5 - 1] of TCheckItem;
      rGiveItem : array[0..5 - 1] of TCheckItem;
   end;
   PTDeallerData = ^TDeallerData;

   TSaleData = record
      rItem : TItemData;
      rCount : Integer;
   end;
   PTSaleData = ^TSaleData;

   TGroupSkill = class;
   TAttackSkill = class;

   TLifeObject = class (TBasicObject)             // À¯Àú´Â Á¦¿Ü....
   private
      OldPos : TPoint;
      ExpLink : array [0..10 - 1] of TExpLinkData;

      procedure AddExpLink (aID, aValue : Integer);
      procedure ClearExpLink;
   protected
      CreatedX, CreatedY, ActionWidth : word;
      RegenWidth : Word;  // ¿òÁ÷ÀÌÁö ¸øÇÏ°Ô ÇÏ´Â°Å..
      FboRegen : Boolean;

      FKind : Byte;      

      DontAttacked : Boolean; // ºñ¹«Àå...
      SoundStart : TEffectData;
      SoundNormal : TEffectData;
      SoundAttack : TEffectData;
      SoundDie : TEffectData;
      SoundStructed : TEffectData;

      EffectStart : Integer;
      EffectStructed : Integer;
      EffectEnd : Integer;


      FreezeTick : integer;
      DiedTick : integer;
      RemovedTick : Integer;
      HitedTick : integer;
      WalkTick : integer;
      UpdateTick : Integer;

      WalkSpeed : integer;
      LifeData : TLifeData;
      LifeObjectState : TLifeObjectState;
      FCurLife, FMaxLife : integer;
      CurHeadLife, MaxHeadLife : Integer;
      CurArmLife, MaxArmLife : Integer;
      CurLegLife, MaxLegLife : Integer;
      VirtueValue : Integer;
      VirtueLevel : Integer;

      FBoCopy : Boolean;
      CopiedList : TList;
      CopyBoss : TLifeObject;

      HaveItemClass : TMopHaveItemClass;
      HaveMagicClass : TMopHaveMagicClass;
      AttackedMagicClass : TAttackedMagicClass;
      AttackSkill : TAttackSkill;

      FboHit : Boolean;
      FboNotBowHit : Boolean;

      //°íÁ¤ÀûÀ¸·Î ÁÖ´Â °æÇèÄ¡
      FShortExp, FRiseShortExp, FLongExp, FRiseLongExp, FHandExp,
         FBestShortExp, FBestShortExp2, FBestShortExp3, FExtraExp, F3HitExp, FLimitSkill : Integer; //2003-09-29 giltae

      //FboSpecialExp : Boolean;  // Çã¼ö¾Æºñ¶§¹®¿¡
      FboBattle : Boolean;      // ºñ¹«Àå NPC¶§¹®¿¡
      FArmorWindOfHandPercent : Integer;

      FIceTick, FIceInterval : Integer;
      FboIce : Boolean;
      FQuestNum : Integer;

      procedure InitialEx;
      procedure Initial (aMonsterName, aViewName : String);
      procedure StartProcess; override;
      procedure EndProcess; override;
      function  AllowCommand (CurTick: integer): Boolean;
      function  CommandSpell (aAttacker : Integer; aSpellType : Byte; aDecPercent : Integer) : Integer;
      function  CommandHited (aAttacker: integer; aHitData: THitData; apercent: integer): integer;
      function  CommandBowed (aAttacker: integer; aHitData: THitData; apercent: integer): integer;
      function  CommandCriticalAttacked (var aSenderInfo : TBasicData; var aSubData : TSubData) : integer;            
      procedure CommandHit (CurTick: integer);
      procedure CommandTurn (adir: word);
      procedure CommandSay (astr: string);
      procedure CommandSayUseMagicStr (aStr : String);
      function  ShootMagic (var aMagic: TMagicData; Bo : TBasicObject) : Boolean;
      function  GotoXyStand (ax, ay: word): integer;
      function  GotoXyStandAI (ax, ay : word) : Integer;
      function  FieldProc (hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer; override;

      function  FindBestExpLink : Integer;
      procedure ShowEffect (aEffectNumber : Word; aEffectKind : TLightEffectKind);
      procedure ShowEffect2 (aEffectNumber : Word; aEffectKind : TLightEffectKind; aDelay: Integer);      
   public
      GroupKey : Integer;

      constructor Create;
      destructor  Destroy; override;

      procedure Update (CurTick: integer); override;

      procedure CommandChangeCharState (aFeatureState: TFeatureState; var SenderInfo : TBasicData);
      procedure CommandAttackedMagic (var aWindOfHandData : TWindOfHandData);

      procedure CopyDie (aBasicObject : TBasicObject);
      procedure CopyBossDie;

      procedure SetHideState (aHideState : THiddenState);
      procedure SetIceInterval (aInterval : Integer);

      procedure WorkBoxCommand (aCmd : Byte);

      procedure SSay (aStr : String); override;
      procedure SAttack (aID : Integer); override;
      procedure SSelfKill; override;
      procedure SGotoXY (aX, aY : Word); override;
      procedure SSetAutoMode; override;

      procedure SCommandIce (aInterval : Integer); override;
      procedure SSetAllowHit (aHit : String); override;

      property boRegen : Boolean read FboRegen write FboRegen;
      property GetVirtueValue : Integer read VirtueValue;
      property boHit : Boolean read FboHit write FboHit;
      property boNotBowHit : Boolean read FboNotBowHit write FboNotBowHit;

      property HandExp : Integer read FHandExp write FHandExp;
      property ShortExp : Integer read FShortExp write FShortExp;
      property RiseShortExp : Integer read FRiseShortExp write FRiseShortExp;
      property BestShortExp : Integer read FBestShortExp write FBestShortExp; //2003-09-29 giltae
      property BestShortExp2 : Integer read FBestShortExp2 write FBestShortExp2;
      property BestShortExp3 : Integer read FBestShortExp3 write FBestShortExp3;

      property LongExp : Integer read FLongExp write FLongExp;
      property RiseLongExp : Integer read FRiseLongExp write FRiseLongExp;
      property ExtraExp : Integer read FExtraExp write FExtraExp;
      
      //property boSpecialExp : Boolean read FboSpecialExp write FboSpecialExp;
      property boBattle : Boolean read FboBattle write FboBattle;
      property State : TLifeObjectState read LifeObjectState write LifeObjectState;
      property ArmorWindOfHandPercent : Integer read FArmorWindOfHandPercent write FArmorWindOfHandPercent;
      property QuestNum : Integer read FQuestNum write FQuestNum;
      property Kind : Byte read FKind;
      property CurLife : Integer read FCurLife write FCurLife;
      property MaxLife : Integer read FMaxLife write FMaxLife;
   end;

   TBuySellSkill = class
   private
      BasicObject : TBasicObject;

      boLogItem : Boolean;

      BuyItemList : TList;
      SellItemList : TList;

      FileName : String;

      procedure Clear;

      function DivHearing (aHearStr: string; var Sayer, aItemName: string; var aItemCount: integer): integer;

   public
      BuyTitle : String;
      BuyCaption : String;
      BuyImage : Integer;

      SellTitle : String;
      SellCaption : String;
      SellImage : Integer;

      constructor Create (aBasicObject : TBasicObject);
      destructor Destroy; override;

      function LoadFromFile (aFileName : String) : Boolean;
      function ProcessMessage (aStr : String; SenderInfo : TBasicData) : Boolean;

      function GetSellItemString : String;
      function GetBuyItemString : String;

      property CanLogItem : Boolean read boLogItem;
   end;

   TSpeechSkill = class
   private
      BasicObject : TBasicObject;

      SpeechList : TList;
      CurSpeechIndex : Integer;
      SpeechTick : Integer;

      procedure Clear;
   public
      constructor Create (aBasicObject : TBasicObject);
      destructor Destroy; override;

      function LoadFromFile (aFileName : String) : Boolean;
      procedure ProcessMessage (CurTick : Integer);
   end;

   TDeallerSkill = class
   private
      BasicObject : TBasicObject;

      DataList : TList;

      procedure Clear;
   public
      constructor Create (aBasicObject : TBasicObject);
      destructor Destroy; override;

      function LoadFromFile (aFileName : String) : Boolean;
      function ProcessMessage (aStr : String; SenderInfo : TBasicData) : Boolean;
   end;

   TAttackSkill = class
   private
      BasicObject : TBasicObject;
      Boss : TBasicObject;
      ObjectBoss : TDynamicObject;

      MasterName : String;
      DeadAttackName : String;

      SaveID : Integer;
      TargetID : Integer;
      EscapeID : Integer;

      SaveNextState : TLifeObjectState;

      TargetIDTick : Integer;
      TargetPosTick : Integer;
      BattleTick : Integer;

      AttackMagic : TMagicData;

      boGroupSkill : Boolean;
      GroupSkill : TGroupSkill;

      BowCount : Integer;
      BowAvailTick : Integer;
      BowAvailInterval : Integer;
      boBowAvail : Boolean;

      TargetStartTick : Integer;
      TargetArrivalTick : Integer;
      ReTargetTick : Integer;
   public
      TargetX : Integer;
      TargetY : Integer;

      HateHumanID : Integer;
      CurNearViewHumanId : Integer;
      EscapeLife : Integer;

      ViewWidth : integer;

      boGroup : Boolean;
      boBoss : Boolean;
      boVassal: Boolean;
      boAutoAttack : Boolean;
      boGoodHeart : Boolean;
      boAttack : Boolean;
      boChangeTarget : Boolean;
      boViewHuman : Boolean;
      boObserver : Boolean;

      VassalCount: integer;

      AttackType : Byte;

      boSelfTarget : Boolean;
   public
      constructor Create (aBasicObject : TBasicObject);
      destructor Destroy; override;

      procedure SetSelf (aSelf : TBasicObject);
      procedure SetBoss (aBoss : TBasicObject);

      procedure SetObjectBoss (aBoss : TDynamicObject);
      function  GetObjectBoss : TDynamicObject;

      procedure SetDeadAttackName (aName : String);
      procedure SetMasterName (aName : String);
      procedure SetTargetID (aTargetID : Integer; boCaller : Boolean);
      procedure SetHelpTargetID (aTargetID : Integer);
      procedure SetHelpTargetIDandPos (aTargetID, aX, aY : Integer);

      procedure SetSaveIDandPos (aTargetID : Integer; aTargetX, aTargetY : Word; aNextState : TLifeObjectState);

      procedure SetEscapeID (aEscapeID : Integer);
      procedure SetAttackMagic (aAttackMagic : TMagicData);
      procedure SetSelfTarget (boFlag : Boolean);

      procedure SetGroupSkill;
      procedure AddGroup (aBasicObject : TBasicObject);

      function ProcessNone (CurTick : Integer) : Integer;
      procedure ProcessEscape (CurTick : Integer);
      procedure ProcessFollow (CurTick : Integer);
      function  ProcessAttack (CurTick : Integer; aBasicObject : TBasicObject) : Boolean;
      procedure ProcessMoveAttack (CurTick : Integer);
      procedure ProcessDeadAttack (CurTick : Integer);
      procedure ProcessMoveWork (CurTick : Integer);
      function ProcessMove (CurTick : Integer) : Boolean;
      function ProcessControl (CurTick : Integer; aXControl, aYControl : Integer) : Boolean;

      procedure HelpMe (aMeID, aTargetID, aX, aY : Integer);
      procedure CancelHelp (aTargetID : Integer);

      procedure NoticeDie;
      procedure MemberDie (aBasicObject : TBasicObject);

      property GetTargetID : Integer read TargetID;
      property GetSaveID : Integer read SaveID;
      property GetNextState : TLifeObjectState read SaveNextState;
      property GetDeadAttackName : String read DeadAttackName;
      property ArrivalTick : Integer read TargetArrivalTick;
      property SetObserver : Boolean read boObserver write boObserver;
   end;

   TGroupSkill = class
   private
      BasicObject : TBasicObject;
      MemberList : TList;
   public
      constructor Create (aBasicObject : TBasicObject);
      destructor Destroy; override;

      procedure AddMember (aBasicObject : TBasicObject);
      procedure DeleteMember (aBasicObject : TBasicObject);
      procedure BossDie;
      procedure ChangeBoss (aBasicObject : TBasicObject);

      procedure FollowMe;
      procedure FollowEachOther;
      procedure Attack (aTargetID : Integer);
      procedure MoveAttack (aTargetID, aX, aY : Integer);
      procedure CancelTarget (aTargetID : Integer);
   end;

   TSaleSkill = class
   private
      BasicObject : TBasicObject;
      SaleItemList : TList;

      procedure Clear;
   public
      SaleTitle : String;
      SaleCaption : String;
      SaleImage : Integer;

      constructor Create (aBasicObject : TBasicObject);
      destructor Destroy; override;

      function LoadFromFile (aFileName : String) : Boolean;
      function GetSellItemString : String;
      function GetBuyItemString : String;

      procedure AddItembyName (aName : String; aCount : Integer);
      function CheckItembyName (aName : String; aCount : Integer) : Boolean;
      function DelItembyName (aName : String; aCount : Integer) : Boolean;
   end;

implementation

uses
   svMain, SubUtil, aUtil32, svClass, uNpc, uMonster, uAIPath, FieldMsg,
   MapUnit, UserSDB, uUser, uItemLog, uScriptManager;

///////////////////////////////////
//         LifeObject
///////////////////////////////////
constructor TLifeObject.Create;
begin
   inherited Create;

   FBoCopy := false;
   CopiedList := nil;
   CopyBoss := nil;
   FboRegen := true;

   FIceTick := 0;
   FIceInterval := 0;
   FQuestNum := 0;

   GroupKey := -1;   

   AttackedMagicClass   := TAttackedMagicClass.Create (Self);
   HaveItemClass        := TMopHaveItemClass.Create (Self);
   HaveMagicClass       := TMopHaveMagicClass.Create (SElf);

   AttackSkill := nil;
end;

destructor  TLifeObject.Destroy;
begin
   AttackedMagicClass.Free;
   HaveMagicClass.Free;
   HaveItemClass.Free;

   ClearExpLink;

   FBoCopy := false;
   CopiedList := nil;
   CopyBoss := nil;
   
   inherited destroy;
end;

procedure TLifeObject.AddExpLink (aID, aValue : Integer);              // È£¿¬Áö±â ÁÖ´Â°Å
var
   i : Integer;
begin
   for i := 0 to 10 - 1 do begin
      if ExpLink [i].ID = aID then begin
         ExpLink [i].DecLife := ExpLink [i].DecLife + aValue;
         exit;
      end;
   end;

   for i := 0 to 10 - 1 do begin
      if ExpLink [i].ID = 0 then begin
         ExpLink [i].ID := aID;
         ExpLink [i].DecLife := aValue;
         exit;
      end;
   end;
end;

function TLifeObject.FindBestExpLink : Integer;                // È£¿¬Áö±â ÁÙ ¾Öµé Ã£´Â°Å
var
   i, MaxID, MaxValue : Integer;
begin

   MaxID := 0; MaxValue := 0;
   for i := 0 to 10 - 1 do begin
      if ExpLink [i].ID = 0 then continue;
      if ExpLink [i].DecLife > MaxValue then begin
         MaxID := ExpLink [i].ID;
         MaxValue := ExpLink [i].DecLife;
      end;
   end;

   Result := MaxID;
end;

procedure TLifeObject.ClearExpLink;
var
   i : Integer;
begin
   for i := 0 to 10 - 1 do begin
      FillChar (ExpLink [i], SizeOf (TExpLinkData), 0);
   end;
end;

procedure TLifeObject.CopyDie (aBasicObject : TBasicObject);
var
   i : Integer;
begin
   if CopiedList = nil then exit;
   for i := 0 to CopiedList.Count - 1 do begin
      if aBasicObject = CopiedList[i] then begin
         CopiedList.Delete (i);
         exit;
      end;
   end;
end;

procedure TLifeObject.CopyBossDie;
begin
   CopyBoss := nil;
   FboAllowDelete := true;
end;

procedure TLifeObject.SetHideState (aHideState : THiddenState);
begin
   BasicData.Feature.rHideState := aHideState;
   BocChangeFeature;
end;

procedure TLifeObject.InitialEx;
begin
   LifeData.damageBody    := 55;
   LifeData.damageHead    := 0;
   LifeData.damageArm     := 0;
   LifeData.damageLeg     := 0;
   LifeData.armorBody     := 0;
   LifeData.armorHead     := 0;
   LifeData.armorArm      := 0;
   LifeData.armorLeg      := 0;
   LifeData.AttackSpeed   := 150;
   LifeData.avoid         := 25;
   LifeData.recovery      := 70;

   VirtueValue := 0;

   DontAttacked := FALSE;

   FIceTick := 0;
   FIceInterval := 0;

   LifeObjectState := los_none;
   BasicData.Feature.rfeaturestate := wfs_normal;
end;

procedure  TLifeObject.Initial (aMonsterName, aViewName : String);
begin
   inherited Initial (aMonsterName, aViewName);

   LifeData.damageBody    := 55;
   LifeData.damageHead    := 0;
   LifeData.damageArm     := 0;
   LifeData.damageLeg     := 0;
   LifeData.armorBody     := 0;
   LifeData.armorHead     := 0;
   LifeData.armorArm      := 0;
   LifeData.armorLeg      := 0;
   LifeData.AttackSpeed   := 150;
   LifeData.avoid         := 25;
   LifeData.recovery      := 70;
   LifeData.Accuracy         := 25;
   LifeData.KeepRecovery      := 70;

   VirtueValue := 0;

   DontAttacked := FALSE;

   FIceTick := 0;
   FIceInterval := 0;

   LifeObjectState := los_init;
end;

procedure   TLifeObject.StartProcess;
var
   CurTick : integer;
begin
   inherited StartProcess;
   
   CurTick := mmAnsTick;

   UpdateTick := CurTick;
   FreezeTick := CurTick;
   DiedTick := CurTick;
   RemovedTick := CurTick;
   HitedTick := CurTick;
   WalkTick := CurTick;

   FIceTick := 0;
   FIceInterval := 0;

   LifeObjectState := los_none;

   ClearExpLink;
end;

procedure TLifeObject.EndProcess;
var
   i : Integer;
begin
   LifeObjectState := los_exit;

   if CopyBoss <> nil then begin
      CopyBoss.CopyDie (Self);
      CopyBoss := nil;
   end;
   if CopiedList <> nil then begin
      for i := 0 to CopiedList.Count - 1 do begin
         TLifeObject (CopiedList[i]).CopyBossDie;
      end;
      CopiedList.Free;
      CopiedList := nil;
   end;
   
   inherited EndProcess;
end;

function  TLifeObject.AllowCommand (CurTick: integer): Boolean;
begin
   Result := TRUE;
   if FreezeTick > CurTick then Result := FALSE;
   if BasicData.Feature.rFeatureState = wfs_die then Result := FALSE;
end;

function TLifeObject.CommandSpell (aAttacker : Integer; aSpellType : Byte; aDecPercent : Integer) : Integer;
var
   Rate : Byte;
   SubData : TSubData;
begin
   Result := 0;

   if aSpellType > SPELLTYPE_MAX then exit;

   Rate := 100 - LifeData.SpellResistRate [aSpellType - 1];
   if Rate <= 0 then exit;

   CurLife := CurLife - (aDecPercent * Rate div 100);
   if CurLife < 0 then CurLife := 0;

   SubData.percent := 100 * CurLife div MaxLife;
   SendLocalMessage (NOTARGETPHONE, FM_LIFEPERCENT, BasicData, SubData);
end;

function  TLifeObject.CommandCriticalAttacked (var aSenderInfo : TBasicData; var aSubData : TSubData) : integer;
var
   n, declife, declifeexp, exp, Levelgap,UserVirtueLevel, aExtraExp, x : integer;
   decHead, decArm, decLeg, dir : Integer;
   SubData : TSubData;
   User : TUser;
   pMagicData : PTMagicData;
begin
   Result := 0;

   if DontAttacked then exit;
   if FboIce = true then exit;

   if (aSubData.HitData.Race <> RACE_HUMAN) and (BasicData.Feature.rrace = aSubData.HitData.Race) then exit;

   declifeexp := 0;
   decHead := 0;
   decArm := 0;
   decLeg := 0;

   //È¸ÇÇ °è»ê
   n := LifeData.avoid + aSubData.HitData.ToHit + aSubData.HitData.Accuracy;
   n := Random (n);
   if n < LifeData.avoid then exit;// ÇÇÇßÀ½.

   declife := aSubData.HitData.damageBody - LifeData.armorBody;
   declifeexp := aSubData.HitData.damageExp - LifeData.armorExp;
   if FboBattle = true then begin
      decHead := aSubData.HitData.damagehead - LifeData.armorHead;
      decArm := aSubData.HitData.damageArm - LifeData.armorArm;
      decLeg := aSubData.HitData.damageLeg - LifeData.armorLeg;
   end;

   // Monster ³ª NPC ÀÇ ÀÚÃ¼ ¹æ¾î·Â¿¡ ÀÇÇÑ ºñÀ²Àû Ã¼·Â°¨¼Ò
   if LifeData.HitArmor > 0 then begin
      declife := declife - ((declife * LifeData.HitArmor) div 100);
      declifeexp := declifeexp - ((declifeexp * LifeData.HitArmor) div 100);
   end;

   if declife <= 0 then declife := 1;
   if declifeexp <= 0 then declifeexp := 1;
   if FboBattle = true then begin
      if decHead <= 0 then decHead := 1;
      if decArm <= 0 then decArm := 1;
      if decLeg <= 0 then decLeg := 1;
   end;

   AddExpLink (aSubData.attacker, declife);

   CurLife := CurLife - declife;
   if FboBattle = true then begin
      CurHeadLife := CurHeadLife - declife;
      CurArmLife := CurArmLife - declife;
      CurLegLife := CurLegLife - declife;
   end;
   
   //È£¿¬Áö±â °è»ê
   if CurLife <= 0 then begin
      n := FindBestExpLink;
      if n > 0 then begin
         User := UserList.GetUserPointerById (n);
         if User <> nil then begin
            if QuestNum <> 0 then begin
               if User.CheckHaveQuestItem (QuestNum) = true then begin
                  HaveItemClass.DropQuestItemGround(n);
               end;
            end;
            
            UserVirtueLevel := User.GetAttribCurVirtue;

            LevelGap := UserVirtueLevel div 100 - VirtueLevel div 100;

            if (VirtueValue < 0) or (LevelGap <= 5) then begin
               SubData.ExpData.Exp := VirtueValue;
            end else begin
               case LevelGap of
                  -99..5 :
                     begin
                        // log..
                        frmMain.WriteLogInfo ('LevelGap : -99..5');
                        SubData.ExpData.Exp := 0;
                     end;
                  6..13:  SubData.ExpData.Exp := VirtueValue - VirtueValue * (LevelGap-5) div 10;
                  14..99: SubData.ExpData.Exp := VirtueValue div 10;
                  else
                     begin
                        // log..
                        frmMain.WriteLogInfo ('LevelGap : else gap...');
                        SubData.ExpData.Exp := 0;
                     end;
               end;
            end;

            if SubData.ExpData.Exp <> 0 then begin
               if SubData.ExpData.Exp > -200 then begin
                  SendLocalMessage (n, FM_ADDVIRTUEEXP, BasicData, SubData);
               end else begin
                  //Log..
                  frmMain.WriteLogInfo ('LevelGap : SubData.ExpData.Exp < -200');
               end;
            end;

            //2003-10
            pMagicData := User.GetCurAttackMagic;
            if pMagicData <> nil then begin
               if ExtraExp <> 0 then aExtraExp := ExtraExp
                  else aExtraExp := VirtueValue;

               case pMagicData^.rMagicClass of
                  MAGICCLASS_BESTMAGIC : SubData.ExpData.Exp := aExtraExp; //Àý¼¼¹«°øÀÏ °æ¿ì 100% Àû¿ë
                  else
                     begin
                        SubData.ExpData.Exp := aExtraExp * 6 div 10; // Virtue ValueÀÇ 60%¸¸ Àû¿ë, ÀÏ¹Ý,»ó½Â,ÀåÇ³
                     end;
               end;
               SendLocalMessage (n, FM_ADDEXTRAEXP, BasicData, SubData);
               BoSysopMessage(format('ExtraExp: %d',[SubData.ExpData.Exp]),10);
            end;
         end;
      end;
      
      CurLife := 0;
   end;

   //ÀÚ¼¼º¸Á¤
   FreezeTick := mmAnsTick + LifeData.recovery;

   if MaxLife <= 0 then begin
      FboAllowDelete := true;
      exit;
   end;

   //Ã¼·ÂÇ¥Çö
   if MaxLife <= 0 then BasicData.LifePercent := 0
   else BasicData.LifePercent := CurLife * 100 div MaxLife;

   SubData.Percent := BasicData.LifePercent;
   SubData.attacker := aSubData.attacker;
   SubData.HitData.HitType := aSubData.HitData.HitType;

   SendLocalMessage (NOTARGETPHONE, FM_STRUCTED, BasicData, SubData);

   if aSubData.PushLength <> 0 then begin
      dir := GetNextDirection (aSenderInfo.x, aSenderInfo.y, BasicData.x, BasicData.y);
      PushMove(dir,aSubData.PushLength);
   end;
   
   //´ÜÅ¸ °æÇèÄ¡ Á¦¿Ü
   if SoundStructed.rWavNumber <> 0 then begin
      SetWordString (SubData.SayString, IntToStr (SoundStructed.rWavNumber) + '.wav');
      SendLocalMessage (NOTARGETPHONE, FM_SOUND, BasicData, SubData);
   end;

   //ÇÊ»ì±â ¸ÂÀ» °æ¿ì
   if aSubData.EffectNumber <> 0 then ShowEffect2 (aSubData.EffectNumber+1, lek_none, 0);
   ShowEffect2 (EffectStructed, lek_follow, 0);

   Result := 1;
end;

function TLifeObject.CommandHited (aattacker: integer; aHitData: THitData; apercent: integer): integer;
var
   n, declife, declifeexp, exp, UserVirtueLevel, Levelgap, tmpExtraExp, x : integer;
   decHead, decArm, decLeg : Integer;
   SubData : TSubData;
   User : TUser;
   pMagicData : PTMagicData;
   Str:String;
   tmpBattleMap: TBattleMap;
   a : TMonster;
   aItem : TItemData;
begin
   Result := 0;

   if DontAttacked then exit;
   if FboIce = true then exit;
   if (GroupKey > 0) and (aHitData.GroupKey = GroupKey) then exit;

   if (aHitData.HitFunction <> MAGICFUNC_NONE) and (aHitData.Race <> RACE_HUMAN)
      and (BasicData.Feature.rRace = aHItData.Race) then exit;

   declifeexp := 0;
   decHead := 0;
   decArm := 0;
   decLeg := 0;

   //È¸ÇÇ °è»ê
   n := LifeData.avoid + aHitData.ToHit + aHitData.Accuracy;
   n := Random (n);
   if n < LifeData.avoid then exit;// ÇÇÇßÀ½.

   if apercent = 100 then begin
      declife := aHitData.damageBody - LifeData.armorBody;
      declifeexp := aHitData.damageExp - LifeData.armorExp;
      if FboBattle = true then begin
         decHead := aHitData.damagehead - LifeData.armorHead;
         decArm := aHitData.damageArm - LifeData.armorArm;
         decLeg := aHitData.damageLeg - LifeData.armorLeg;
      end;
   end else begin
      declife := (aHitData.damageBody * apercent div 100) * aHitData.HitFunctionSkill div 10000 -LifeData.armorBody;
      declifeexp := (aHitData.damageExp * apercent div 100) * aHitData.HitFunctionSkill div 10000 -LifeData.armorExp;
      if FboBattle = true then begin
         decHead := (aHitData.damagehead * apercent div 100) * aHitData.HitFunctionSkill div 10000 - LifeData.armorHead;
         decArm :=  (aHitData.damageArm * apercent div 100) * aHitData.HitFunctionSkill div 10000 - LifeData.armorArm;
         decLeg :=  (aHitData.damageLeg * apercent div 100) * aHitData.HitFunctionSkill div 10000 - LifeData.armorLeg;
      end;
   end;

   // Monster ³ª NPC ÀÇ ÀÚÃ¼ ¹æ¾î·Â¿¡ ÀÇÇÑ ºñÀ²Àû Ã¼·Â°¨¼Ò
   if LifeData.HitArmor > 0 then begin
      declife := declife - ((declife * LifeData.HitArmor) div 100);
      declifeexp := declifeexp - ((declifeexp * LifeData.HitArmor) div 100);
   end;

   if declife <= 0 then declife := 1;
   if declifeexp <= 0 then declifeexp := 1;
   if FboBattle = true then begin
      if decHead <= 0 then decHead := 1;
      if decArm <= 0 then decArm := 1;
      if decLeg <= 0 then decLeg := 1;
   end;

   AddExpLink (aAttacker, declife);

   CurLife := CurLife - declife;
   if FboBattle = true then begin
      CurHeadLife := CurHeadLife - declife;
      CurArmLife := CurArmLife - declife;
      CurLegLife := CurLegLife - declife;
   end;

   if (Manager.MapAttribute = MAP_TYPE_GUILDBATTLE) or
      (Manager.MapAttribute = MAP_TYPE_SPORTBATTLE) then begin
      if (Manager.BattleMop [0] <> nil) and (Manager.BattleMop [1] <> nil) then begin
         UserList.SendBattleBarbyMapID (TMonster (Manager.BattleMop [0]).MonsterName,
            TMonster (Manager.BattleMop [1]).MonsterName, 0, 0, TMonster (Manager.BattleMop [0]).BasicData.LifePercent,
            TMonster (Manager.BattleMop [1]).BasicData.LifePercent, 0, Manager.ServerID);

      end;
   end;

   //È£¿¬Áö±â °è»ê
   //ËÀÍö
   // add by Orber at 2004-10-29 10:50  //×¥¿ñÏ¬Å£ÍõµÄËÀ
   Str:= StrPas(@BasicData.Name);
   if Str = Conv('Ï¬Å£Íõ1') then begin
        User := UserList.GetUserPointerById (aAttacker);
        Str := User.GetWeaponItemName;
        if Str = Conv('ÊÉÔÂµ¶') then begin
            ItemClass.GetItemData(Conv('Ï¬Å£Íõºó½Ç'),aItem);
            aItem.rCount := 1;
            if User.FindItem(@aItem) then begin
                Self.SSay(Conv('Äã¾¹È»É±ËÀÁËÎÒµÄÍõºó¡­¡­'));
                CurLife := 0;
            end;
        end;
   end;
   if CurLife <= 0 then begin
   n := FindBestExpLink;
      if n > 0 then begin
         User := UserList.GetUserPointerById (aAttacker);
         if User <> nil then begin
            if QuestNum <> 0 then begin
               if User.CheckHaveQuestItem(QuestNum) = true then begin
                  HaveItemClass.DropQuestItemGround(n);
               end;
            end;

            UserVirtueLevel := User.GetAttribCurVirtue;
            LevelGap := UserVirtueLevel div 100 - VirtueLevel div 100;

            if (VirtueValue < 0) or (LevelGap <= 5) then begin
               SubData.ExpData.Exp := VirtueValue;
            end else begin
               case LevelGap of
                  -99..5 :
                     begin
                        // log..
                        frmMain.WriteLogInfo ('LevelGap : -99..5');
                        SubData.ExpData.Exp := 0;
                     end;
                  6..13:  SubData.ExpData.Exp := VirtueValue - VirtueValue * (LevelGap-5) div 10;
                  14..99: SubData.ExpData.Exp := VirtueValue div 10;
                  else
                     begin
                        // log..
                        frmMain.WriteLogInfo ('LevelGap : else gap...');
                        SubData.ExpData.Exp := 0;
                     end;
               end;
            end;

            if SubData.ExpData.Exp <> 0 then begin
               if SubData.ExpData.Exp > -200 then begin
                  SendLocalMessage (n, FM_ADDVIRTUEEXP, BasicData, SubData);
               end else begin
                  //Log..
                  frmMain.WriteLogInfo ('LevelGap : SubData.ExpData.Exp < -200');
               end;
            end;

            pMagicData := User.GetCurAttackMagic;
            if pMagicData <> nil then begin
               if ExtraExp <> 0 then tmpExtraExp := ExtraExp
                  else tmpExtraExp := VirtueValue;

               case pMagicData^.rMagicClass of
                  MAGICCLASS_BESTMAGIC : SubData.ExpData.Exp := tmpExtraExp; //Àý¼¼¹«°øÀÏ °æ¿ì 100% Àû¿ë
                  else
                     begin
                        SubData.ExpData.Exp := tmpExtraExp * 6 div 10; // Virtue ValueÀÇ 60%¸¸ Àû¿ë, ÀÏ¹Ý,»ó½Â,ÀåÇ³
                     end;
               end;
               SendLocalMessage (n, FM_ADDEXTRAEXP, BasicData, SubData);
               BoSysopMessage(format('ExtraExp: %d',[SubData.ExpData.Exp]),10);
            end;
         end;
      end;
      CurLife := 0;



      if (Manager.MapAttribute = MAP_TYPE_GUILDBATTLE) or
         (Manager.MapAttribute = MAP_TYPE_SPORTBATTLE) then begin
         if Manager.FboSuccess = true then exit;
         // change by minds 050926
         UserList.SendCenterMessage(format (Conv ('%s ±»¶Ô·½´ò±¬ '), [StrPas (@BasicData.Name)]));
         //UserList.SendCenterMessagebyMapID (format (Conv ('%s ±»¶Ô·½´ò±¬ '), [StrPas (@BasicData.Name)]), Manager.ServerID);

         //Author:Steven Date: 2005-01-20 16:46:40
         //Note:¾º¼¼³¡
         //È»ºó¸øÊ¤Àû·½·¢¶«Î÷,ÆäÊµ¿ÉÒÔÐ´µ½½Å±¾Àï

         tmpBattleMap := BattleMapList.GetPositionbyGuildName(Format('%s%d', [Conv('ºì·½'), Manager.ServerID]));
         if not Assigned(tmpBattleMap) then Exit;

         if tmpBattleMap.MopName = StrPas(@BasicData.Name) then
         begin
            UserList.SendCenterMessagebyMapID (Format(Conv('%s ±»´ò±¬, À¶·½»ñÊ¤, ½«»ñµÃ¶Ò½±È¯'), [StrPas (@BasicData.Name)]), Manager.ServerID);
            tmpBattleMap := BattleMapList.GetPositionbyGuildName(Format('%s%d', [Conv('À¶·½'), Manager.ServerID]));
            if not Assigned(tmpBattleMap) then Exit;
            UserList.AddItemUserByGruopAndMapID(tmpBattleMap.MapID, tmpBattleMap.GroupKey, Conv('¾º¼¼³¡'), Conv('¾º¼¼³¡¶Ò½±È¯'));
            TMonsterList(Manager.MonsterList).DeleteMonster (tmpBattleMap.MopName);
         end;

         tmpBattleMap := BattleMapList.GetPositionbyGuildName(Format('%s%d', [Conv('À¶·½'), Manager.ServerID]));
         if not Assigned(tmpBattleMap) then Exit;
         if tmpBattleMap.MopName = StrPas(@BasicData.Name) then
         begin
            UserList.SendCenterMessagebyMapID(Format(Conv('%s ±»´ò±¬, ºì·½»ñÊ¤, ½«»ñµÃ¶Ò½±È¯'), [StrPas (@BasicData.Name)]), Manager.ServerID);
            tmpBattleMap := BattleMapList.GetPositionbyGuildName(Format('%s%d', [Conv('ºì·½'), Manager.ServerID]));
            if not Assigned(tmpBattleMap) then Exit;
            UserList.AddItemUserByGruopAndMapID(tmpBattleMap.MapID, tmpBattleMap.GroupKey, Conv('¾º¼¼³¡'), Conv('¾º¼¼³¡¶Ò½±È¯'));
            TMonsterList(Manager.MonsterList).DeleteMonster (tmpBattleMap.MopName);
         end;

         //================================================
         Manager.FboSuccess := true;
      end;
   end;

   //ÀÚ¼¼º¸Á¤
   FreezeTick := mmAnsTick + LifeData.recovery;

   if MaxLife <= 0 then begin
      FboAllowDelete := true;
      exit;
   end;

   //Ã¼·ÂÇ¥Çö
   if MaxLife <= 0 then BasicData.LifePercent := 0
   else BasicData.LifePercent := CurLife * 100 div MaxLife;

   SubData.Percent := BasicData.LifePercent;
   SubData.attacker := aAttacker;
   SubData.HitData.HitType := aHitData.HitType;

   SendLocalMessage (NOTARGETPHONE, FM_STRUCTED, BasicData, SubData);
   
   //  °æÇèÄ¡ ´õÇÏ±â(°ø°Ý¹«°ø)  //
   Exp := 0;
   if (aPercent = 100) and (aHitData.Race = RACE_HUMAN) then begin
      case aHitData.MagicType of
         MAGICCLASS_BESTMAGIC:
            begin
               case aHitData.Grade of
                  0 : begin
                     if FBestShortExp > 0 then begin
                        Exp := FBestShortExp;
                     end else begin
                        x := 1280;
                        n := MaxLife div declifeexp;
                        if n >= 20 then n := 20;
                        exp := x * n * n div (20 * 20);

                        if FKind = MOP_KIND_NEWSKILL then
                           exp := exp + (aHitData.CurMagicDamage - 1200);
                     end;
                  end;
                  1 : begin
                     if FBestShortExp2 > 0 then begin
                        Exp := FBestShortExp2;
                     end else begin
                        x := 640;
                        n := MaxLife div declifeexp;
                        if n >= 20 then n := 20;
                        exp := x * n * n div (20 * 20);

                        if FKind = MOP_KIND_NEWSKILL then
                           exp := exp + (((aHitData.CurMagicDamage - 1200) * 5) div 10);
                     end;
                  end;
                  2 : begin
                     if FBestShortExp3 > 0 then begin
                        Exp := FBestShortExp3;
                     end else begin
                        x := 320;
                        n := MaxLife div declifeexp;
                        if n >= 20 then n := 20;
                        exp := x * n * n div (20 * 20);

                        if FKind = MOP_KIND_NEWSKILL then
                           exp := exp + (((aHitData.CurMagicDamage - 1200) * 25) div 100);
                     end;
                  end;
               end;
            end;
         MAGICCLASS_RISEMAGIC:
            begin
               if FRiseShortExp > 0 then begin
                  Exp := FRiseShortExp;
               end else begin
                  n := MaxLife div declifeexp;
                  if n >= 30 then n := 29;
                  Exp := 8000 * ((15 - ABS (15 - n)) * (15 - ABS (15 - n)) + 30) div (15 * 15);

                  if FKind = MOP_KIND_NEWSKILL then
                     exp := exp + aHitData.CurMagicDamage * 2;
               end;
            end;
         MAGICCLASS_MAGIC:
            begin
               if FShortExp > 0 then begin
                  Exp := FShortExp;
               end else begin
                  n := MaxLife div declifeexp;
                  if n > 15 then exp := DEFAULTEXP                // 10´ëÀÌ»ó ¸ÂÀ»¸¸ ÇÏ´Ù¸é 1000
                  else exp := DEFAULTEXP * n * n div (15 * 15);   // 20´ë ¸ÂÀ¸¸é Á×±¸µµ ³²À¸¸é 10 => 500   n 15 => 750   5=>250

                  if FKind = MOP_KIND_NEWSKILL then
                     exp := exp + aHitData.CurMagicDamage * 5;
               end;
            end;
      end;

      BoSysopMessage (format ('exp : %d curdamage : %d', [exp, aHitData.CurMagicDamage]), 10);      

      if Exp > 0 then begin
         SubData.ExpData.Exp := exp;
         SubData.ExpData.ExpType := 0;
         SubData.HitData.LimitSkill := FLimitSkill;
         SendLocalMessage (aAttacker, FM_ADDATTACKEXP, BasicData, SubData);
      end;
   end;
   BoSysopMessage (IntToStr(declife) + ' : ' + IntTostr(exp), 10);

   if SoundStructed.rWavNumber <> 0 then begin
      SetWordString (SubData.SayString, IntToStr (SoundStructed.rWavNumber) + '.wav');
      SendLocalMessage (NOTARGETPHONE, FM_SOUND, BasicData, SubData);
   end;

   ShowEffect2 (EffectStructed, lek_follow, 0);
   if aHitData.EffectNumber <> 0 then ShowEffect2 (aHitData.EffectNumber+1, lek_none, 0);

   Result := 1;
end;

function TLifeObject.CommandBowed (aattacker: integer; aHitData: THitData; apercent: integer): integer;
var
   n, declife, declifeexp, exp, UserVirtueLevel, Levelgap, tmpExtraExp : integer;
   decHead, decArm, decLeg : Integer;
   SubData : TSubData;
   User : TUser;
   pMagicData : PTMagicData;
begin
   Result := 0;

   if DontAttacked then exit;
   if FboIce = true then exit;
   if (GroupKey > 0) and (aHitData.GroupKey = GroupKey) then exit;
   
   if (aHitData.HitFunction <> MAGICFUNC_NONE) and (aHitData.Race <> RACE_HUMAN)
      and (BasicData.Feature.rRace = aHItData.Race) then exit;

   declifeexp := 0;
   decHead := 0;
   decArm := 0;
   decLeg := 0;

   n := LifeData.avoid + aHitData.ToHit + aHitData.Accuracy;
   n := Random (n);
   if n < LifeData.avoid then exit;    // ÇÇÇßÀ½.

   if apercent = 100 then begin
      declife := aHitData.damageBody - LifeData.armorBody;
      declifeexp := aHitData.damageExp - LifeData.armorExp;
      if FboBattle = true then begin
         decHead := aHitData.damagehead - LifeData.armorHead;
         decArm := aHitData.damageArm - LifeData.armorArm;
         decLeg := aHitData.damageLeg - LifeData.armorLeg;
      end;
   end else begin
      declife := (aHitData.damageBody * apercent div 100) * aHitData.HitFunctionSkill div 10000 -LifeData.armorBody;
      declifeexp := (aHitData.damageExp * apercent div 100) * aHitData.HitFunctionSkill div 10000 -LifeData.armorExp;
      if FboBattle = true then begin
         decHead := (aHitData.damagehead * apercent div 100) * aHitData.HitFunctionSkill div 10000 - LifeData.armorHead;
         decArm :=  (aHitData.damageArm * apercent div 100) * aHitData.HitFunctionSkill div 10000 - LifeData.armorArm;
         decLeg :=  (aHitData.damageLeg * apercent div 100) * aHitData.HitFunctionSkill div 10000 - LifeData.armorLeg;
      end;
   end;

   // Monster ³ª NPC ÀÇ ÀÚÃ¼ ¹æ¾î·Â¿¡ ÀÇÇÑ ºñÀ²Àû Ã¼·Â°¨¼Ò
   if LifeData.HitArmor > 0 then begin
      declife := declife - ((declife * LifeData.HitArmor) div 100);
      declifeexp := declifeexp - ((declifeexp * LifeData.HitArmor) div 100);
   end;

   if declife <= 0 then declife := 1;
   if declifeexp <= 0 then declifeexp := 1;
   if FboBattle = true then begin
      if decHead <= 0 then decHead := 1;
      if decArm <= 0 then decArm := 1;
      if decLeg <= 0 then decLeg := 1;
   end;

   AddExpLink (aAttacker, declife);
   CurLife := CurLife - declife;
   if FboBattle = true then begin
      CurHeadLife := CurHeadLife - declife;
      CurArmLife := CurArmLife - declife;
      CurLegLife := CurLegLife - declife;
   end;

   if (Manager.MapAttribute = MAP_TYPE_GUILDBATTLE) or
         (Manager.MapAttribute = MAP_TYPE_SPORTBATTLE) then begin
      if (Manager.BattleMop [0] <> nil) and (Manager.BattleMop [1] <> nil) then begin
         UserList.SendBattleBarbyMapID (TMonster (Manager.BattleMop [0]).MonsterName,
            TMonster (Manager.BattleMop [1]).MonsterName, 0, 0, TMonster (Manager.BattleMop [0]).BasicData.LifePercent,
            TMonster (Manager.BattleMop [1]).BasicData.LifePercent, 0, Manager.ServerID);
      end;
   end;

   //È£¿¬Áö±â °è»ê
   if CurLife <= 0 then begin
      n := FindBestExpLink;
      if n > 0 then begin
         User := UserList.GetUserPointerById (aAttacker);
         if User <> nil then begin
            if QuestNum <> 0 then begin
               if User.CheckHaveQuestItem(QuestNum) = true then begin
                  HaveItemClass.DropQuestItemGround(n);
               end;
            end;

            UserVirtueLevel := User.GetAttribCurVirtue;
            LevelGap := UserVirtueLevel div 100 - VirtueLevel div 100;

            if (VirtueValue < 0) or (LevelGap <= 5) then begin
               SubData.ExpData.Exp := VirtueValue;
            end else begin
               case LevelGap of
                  -99..5 :
                     begin
                        // log..
                        frmMain.WriteLogInfo ('LevelGap : -99..5');
                        SubData.ExpData.Exp := 0;
                     end;
                  6..13:  SubData.ExpData.Exp := VirtueValue - VirtueValue * (LevelGap-5) div 10;
                  14..99: SubData.ExpData.Exp := VirtueValue div 10;
                  else
                     begin
                        // log..
                        frmMain.WriteLogInfo ('LevelGap : else gap...');
                        SubData.ExpData.Exp := 0;
                     end;
               end;
            end;

            if SubData.ExpData.Exp <> 0 then begin
               if SubData.ExpData.Exp > -200 then begin
                  SendLocalMessage (n, FM_ADDVIRTUEEXP, BasicData, SubData);
               end else begin
                  //Log..
                  frmMain.WriteLogInfo ('LevelGap : SubData.ExpData.Exp < -200');
               end;
            end;

            pMagicData := User.GetCurAttackMagic;
            if pMagicData <> nil then begin
               if ExtraExp <> 0 then tmpExtraExp := ExtraExp
                  else tmpExtraExp := VirtueValue;

               case pMagicData^.rMagicClass of
                  MAGICCLASS_BESTMAGIC : SubData.ExpData.Exp := tmpExtraExp; //Àý¼¼¹«°øÀÏ °æ¿ì 100% Àû¿ë
                  else
                     begin
                        SubData.ExpData.Exp := tmpExtraExp * 6 div 10; // Virtue ValueÀÇ 60%¸¸ Àû¿ë, ÀÏ¹Ý,»ó½Â,ÀåÇ³
                     end;
               end;
               SendLocalMessage (n, FM_ADDEXTRAEXP, BasicData, SubData);
               BoSysopMessage(format('ExtraExp: %d',[SubData.ExpData.Exp]),10);
            end;
         end;
      end;
      CurLife := 0;

      if (Manager.MapAttribute = MAP_TYPE_GUILDBATTLE)  or
         (Manager.MapAttribute = MAP_TYPE_SPORTBATTLE) then begin
         if Manager.FboSuccess = true then exit;
         // change by minds 050926
         UserList.SendCenterMessage(format (Conv ('%s ±»¶Ô·½´ò±¬ '), [StrPas (@BasicData.Name)]));
         //UserList.SendCenterMessagebyMapID (format (Conv ('%s ±»¶Ô·½´ò±¬ '), [StrPas (@BasicData.Name)]), Manager.ServerID);
         Manager.FboSuccess := true;
      end;
   end;
   
   //ÀÚ¼¼º¸Á¤
   FreezeTick := mmAnsTick + LifeData.recovery;

   if MaxLife <= 0 then begin
      FboAllowDelete := true;
      exit;
   end;

   //Ã¼·ÂÇ¥Çö
   if MaxLife <= 0 then BasicData.LifePercent := 0
   else BasicData.LifePercent := CurLife * 100 div MaxLife;

   SubData.Percent := BasicData.LifePercent;
   SubData.attacker := aAttacker;
   SubData.HitData.HitType := aHitData.HitType;

   SendLocalMessage (NOTARGETPHONE, FM_STRUCTED, BasicData, SubData);
   
   //  °æÇèÄ¡ ´õÇÏ±â(°ø°Ý¹«°ø)  //
   Exp := 0;
   if (aPercent = 100) and (aHitData.Race = RACE_HUMAN) then begin
      case aHitData.MagicType of
         MAGICCLASS_RISEMAGIC:
            begin
               if FRiseLongExp > 0 then begin
                  Exp := FRiseLongExp;
               end else begin
                  n := MaxLife div declifeexp;
                  if n >= 30 then n := 29;
                  Exp := 8000 * ((15 - ABS (15 - n)) * (15 - ABS (15 - n)) + 30) div (15 * 15);
               end;
            end;
         MAGICCLASS_MAGIC:
            begin
               if FLongExp > 0 then begin
                  Exp := FLongExp;
               end else begin
                  n := MaxLife div declifeexp;
                  if n > 15 then exp := DEFAULTEXP                // 10´ëÀÌ»ó ¸ÂÀ»¸¸ ÇÏ´Ù¸é 1000
                  else exp := DEFAULTEXP * n * n div (15 * 15);   // 20´ë ¸ÂÀ¸¸é Á×±¸µµ ³²À¸¸é 10 => 500   n 15 => 750   5=>250
               end;
            end;
      end;

      if Exp > 0 then begin
         SubData.ExpData.Exp := exp;
         SubData.ExpData.ExpType := 0;
         SubData.HitData.LimitSkill := FLimitSkill;
         SendLocalMessage (aAttacker, FM_ADDATTACKEXP, BasicData, SubData);
      end;
   end;
   BoSysopMessage (IntToStr(declife) + ' : ' + IntTostr(exp), 10);

   if SoundStructed.rWavNumber <> 0 then begin
      SetWordString (SubData.SayString, IntToStr (SoundStructed.rWavNumber) + '.wav');
      SendLocalMessage (NOTARGETPHONE, FM_SOUND, BasicData, SubData);
   end;

   ShowEffect2 (EffectStructed, lek_follow, 0);

   Result := 1;
end;

procedure TLifeObject.CommandAttackedMagic (var aWindOfHandData : TWindOfHandData);
var
   n, declife, declifeexp, exp, UserVirtueLevel, Levelgap, tmpExtraExp : integer;
   SubData : TSubData;
   User : TUser;
   pMagicData : PTMagicData;
begin
   if DontAttacked then exit;
   if FboIce = true then exit;

   if aWindOfHandData.rRace <> RACE_HUMAN then exit;
   if aWindOfHandData.rRace = BasicData.Feature.rrace then exit;
   if BasicData.Feature.rfeaturestate = wfs_die then exit;

   declife := aWindOfHandData.rDamageBody - aWindOfHandData.rDamageBody * ArmorWindOfHandPercent div 100;
   declifeexp := aWindOfHandData.rDamageExp - aWindOfHandData.rDamageExp * ArmorWindOfHandPercent div 100;

   if declife <= 0 then declife := 1;
   if declifeexp <= 0 then declifeexp := 1;

   AddExpLink (aWindOfHandData.rAttacker, declife);

   CurLife := CurLife - declife;

   if (Manager.MapAttribute = MAP_TYPE_GUILDBATTLE) or
      (Manager.MapAttribute = MAP_TYPE_SPORTBATTLE) then begin
      if (Manager.BattleMop [0] <> nil) and (Manager.BattleMop [1] <> nil) then begin
         UserList.SendBattleBarbyMapID (TMonster (Manager.BattleMop [0]).MonsterName,
            TMonster (Manager.BattleMop [1]).MonsterName, 0, 0, TMonster (Manager.BattleMop [0]).BasicData.LifePercent,
            TMonster (Manager.BattleMop [1]).BasicData.LifePercent, 0, Manager.ServerID);
      end;
   end;

   //È£¿¬Áö±â °è»ê
   if CurLife <= 0 then begin
      n := FindBestExpLink;
      if n > 0 then begin
         User := UserList.GetUserPointerById (n);
         if User <> nil then begin
            if QuestNum <> 0 then begin
               if User.CheckHaveQuestItem(QuestNum) = true then begin
                  HaveItemClass.DropQuestItemGround(n);
               end;
            end;

            UserVirtueLevel := User.GetAttribCurVirtue;
            LevelGap := UserVirtueLevel div 100 - VirtueLevel div 100;

            if (VirtueValue < 0) or (LevelGap <= 5) then begin
               SubData.ExpData.Exp := VirtueValue;
            end else begin
               case LevelGap of
                  -99..5 :
                     begin
                        // log..
                        frmMain.WriteLogInfo ('LevelGap : -99..5');
                        SubData.ExpData.Exp := 0;
                     end;
                  6..13:  SubData.ExpData.Exp := VirtueValue - VirtueValue * (LevelGap-5) div 10;
                  14..99: SubData.ExpData.Exp := VirtueValue div 10;
                  else
                     begin
                        // log..
                        frmMain.WriteLogInfo ('LevelGap : else gap...');
                        SubData.ExpData.Exp := 0;
                     end;
               end;
            end;

            if SubData.ExpData.Exp <> 0 then begin
               if SubData.ExpData.Exp > -200 then begin
                  SendLocalMessage (n, FM_ADDVIRTUEEXP, BasicData, SubData);
               end else begin
                  //Log..
                  frmMain.WriteLogInfo ('LevelGap : SubData.ExpData.Exp < -200');
               end;
            end;

            pMagicData := User.GetCurAttackMagic;
            if pMagicData <> nil then begin
               if ExtraExp <> 0 then tmpExtraExp := ExtraExp
                  else tmpExtraExp := VirtueValue;

               case pMagicData^.rMagicClass of
                  MAGICCLASS_BESTMAGIC : SubData.ExpData.Exp := tmpExtraExp; //Àý¼¼¹«°øÀÏ °æ¿ì 100% Àû¿ë
                  else begin
                     SubData.ExpData.Exp := tmpExtraExp * 6 div 10; // Virtue ValueÀÇ 60%¸¸ Àû¿ë, ÀÏ¹Ý,»ó½Â,ÀåÇ³
                  end;
               end;
               SendLocalMessage (n, FM_ADDEXTRAEXP, BasicData, SubData);
               BoSysopMessage(format('ExtraExp: %d',[SubData.ExpData.Exp]),10);
            end;
         end;
      end;
      CurLife := 0;

      if (Manager.MapAttribute = MAP_TYPE_GUILDBATTLE) or
         (Manager.MapAttribute = MAP_TYPE_SPORTBATTLE) then begin
         if Manager.FboSuccess = true then exit;
         // change by minds 050926
         UserList.SendCenterMessage(format (Conv ('%s ±»¶Ô·½´ò±¬ '), [StrPas (@BasicData.Name)]));
         //UserList.SendCenterMessagebyMapID (format (Conv ('%s ±»¶Ô·½´ò±¬ '), [StrPas (@BasicData.Name)]), Manager.ServerID);
         Manager.FboSuccess := true;
      end;
   end;

   //ÀÚ¼¼º¸Á¤.
   FreezeTick := mmAnsTick + LifeData.recovery;

   if MaxLife <= 0 then begin
      FboAllowDelete := true;
      exit;
   end;

   //Ã¼·ÂÇ¥Çö
   if MaxLife <= 0 then BasicData.LifePercent := 0
   else BasicData.LifePercent := CurLife * 100 div MaxLife;

   SubData.Percent := BasicData.LifePercent;
   SubData.attacker := aWindOfHandData.rAttacker;
   SubData.HitData.HitType := aWindOfHandData.rHitType;
   SendLocalMessage (NOTARGETPHONE, FM_STRUCTED, BasicData, SubData);

   //  °æÇèÄ¡ ´õÇÏ±â(°ø°Ý¹«°ø)  //
   Exp := 0;
   if aWindOfHandData.rRace = RACE_HUMAN then begin
      if FHandExp > 0 then begin
         exp := FHandExp;
      end else begin
         n := MaxLife div declifeexp;
         if n >= 16 then Exp := 500
         else Exp := ( 8000 * (8 - ABS (8 - n)) * (8 - ABS (8 - n)) + 32000) div (8 * 8);
      end;

      if Exp > 0 then begin
         SubData.ExpData.Exp := exp;
         SubData.ExpData.ExpType := 0;
         SubData.HitData.MagicType := MAGICCLASS_MYSTERY;
         SubData.HitData.LimitSkill := FLimitSkill;
         SendLocalMessage (SubData.attacker, FM_ADDWINDOFHANDEXP, BasicData, SubData);
      end;
   end;
   BoSysopMessage (IntToStr(declife) + ' : ' + IntTostr(exp), 10);

   SetWordString (SubData.SayString, StrPas (@aWindOfHandData.rSayString));
   SendLocalMessage (NOTARGETPHONE, FM_SOUND, BasicData, SubData);

   ShowEffect2 (aWindOfHandData.rEffectNumber, lek_follow, 0);
   if CurLife <= 0 then begin
      if SOnDie <> 0 then begin
         if User <> nil then CommandChangeCharState (wfs_die, User.BasicData);
      end else begin
         CommandChangeCharState(wfs_die, BasicData);
      end;
   end;
end;

procedure TLifeObject.CommandHit (CurTick: integer);
var
   SubData : TSubData;
   Kind : Byte;
   SkillLevel : Integer;
begin
   if not AllowCommand (mmAnsTick) then exit;

   if HitedTick + LifeData.AttackSpeed < CurTick then begin
      HitedTick := CurTick;
      SubData.HitData.damageBody := LifeData.damageBody;
      SubData.HitData.damageHead := LifeData.damageHead;
      SubData.HitData.damageArm := LifeData.damageArm;
      SubData.HitData.damageLeg := LifeData.damageLeg;

      SubData.HitData.damageEnergy := 0;
      SubData.LockDown := 0;
      SubData.LockDownDecLife := 0;
      SubData.HitData.Stun := STUN_NONE;
      SubData.HitData.Grade := 0;
      SubData.HitData.LifeStealValue := 0;
      SubData.HitData.EnergyStealValue := 0;

      SubData.HitData.ToHit := 75;
      SubData.HitData.HitType := 0;
      SubData.HitData.HitLevel := 7500;
      SubData.HitData.HitFunction := 0;
      SubData.HitData.HitFunctionSkill := 0;

      SubData.HitData.boHited := FALSE;
      SubData.HitData.HitFunction := 0;
      SubData.HitData.Virtue := VirtueValue;

      SubData.HitData.Accuracy := LifeData.Accuracy;

      SubData.HitData.damageExp := LifeData.damageBody;
      SubData.HitData.MagicType := 0;
      SubData.HitData.Race := BasicData.Feature.rRace;
      SubData.HitData.GroupKey := 0;
      SubData.HitData.EffectNumber := 0;      

      if HaveMagicClass.isHaveDeadBlowMagic = true then begin
         Kind := 0; SkillLevel := 0;
         if HaveMagicClass.RunHaveDeadBlowMagic (Kind, SkillLevel) = true then begin
            SubData.HitData.HitFunction := Kind;
            SubData.HitData.HitFunctionSkill := SkillLevel;
         end;
      end;

      SubData.HitData.CurMagicDamage := 0;      
      SendLocalMessage (NOTARGETPHONE, FM_HIT, BasicData, SubData);

      if SoundAttack.rWavNumber <> 0 then begin
         SetWordString (SubData.SayString, IntToStr (SoundAttack.rWavNumber) + '.wav');
         SendLocalMessage (NOTARGETPHONE, FM_SOUND, BasicData, SubData);
      end;

      SubData.MagicState := 0;
      SubData.MagicKind := 0;
      SubData.MagicColor := 0;
      SubData.motion := BasicData.Feature.rhitmotion;
      SendLocalMessage ( NOTARGETPHONE, FM_MOTION, BasicData, SubData);
   end;
end;

procedure TLifeObject.CommandSay (astr: string);
var
   SubData : TSubData;
begin
   SetWordString (SubData.SayString, StrPas (@BasicData.ViewName) + ': '+ astr);
   SendLocalMessage (NOTARGETPHONE, FM_SAY, BasicData, SubData);
end;

procedure TLifeObject.CommandSayUseMagicStr (aStr : String);
var
   SubData : TSubData;
begin
   SetWordString (SubData.SayString, astr);
   SendLocalMessage (NOTARGETPHONE, FM_SAYUSEMAGIC, BasicData, SubData);
end;

procedure TLifeObject.CommandTurn (adir: word);
var
   SubData : TSubData;
begin
   if not AllowCommand (mmAnsTick) then exit;
   BasicData.dir := adir;
   SendLocalMessage (NOTARGETPHONE, FM_TURN, BasicData, SubData);
end;

procedure TLifeObject.CommandChangeCharState (aFeatureState: TFeatureState; var SenderInfo : TBasicData);
var
   i : Integer;
   SubData : TSubData;
   BO : TLifeObject;
begin
   if aFeatureState = wfs_die then begin
      LifeObjectState := los_die;
      BasicData.Feature.rfeaturestate := aFeatureState;

      if BasicData.Feature.rHideState <> hs_100 then begin
         BasicData.Feature.rHideState := hs_100;
         SendLocalMessage (NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);
      end;
      if FboCopy = true then begin
         ShowEffect2 (1, lek_none, 0);
      end;
      if CopiedList <> nil then begin
         for i := 0 to CopiedList.Count - 1 do begin
            BO := CopiedList[i];
            if BO <> nil then begin
               BO.CommandChangeCharState (aFeatureState, SenderInfo);
            end;
         end;
      end;
      DiedTick := mmAnsTick;
      if SoundDie.rWavNumber <> 0 then begin
         SetWordString (SubData.SayString, IntToStr (SoundDie.rWavNumber) + '.wav');
         SendLocalMessage (NOTARGETPHONE, FM_SOUND, BasicData, SubData);
      end;

      if SOnDie <> 0 then begin
         if BasicData.id <> SenderInfo.ID then begin
            ScriptManager.CallEvent (Self, SenderInfo.P, SOnDie, 'OnDie', ['']);
         end;
      end;
   end;

   BasicData.Feature.rfeaturestate := aFeatureState;
   SendLocalMessage (NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);
end;

procedure TLifeObject.ShowEffect (aEffectNumber : Word; aEffectKind : TLightEffectKind);
var
   SubData : TSubData;
begin
   BasicData.Feature.rEffectNumber := aEffectNumber;
   BasicData.Feature.rEffectKind := aEffectKind;

   SendLocalMessage (NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);

   BasicData.Feature.rEffectNumber := 0;
   BasicData.Feature.rEffectKind := lek_none;
end;

procedure TLifeObject.ShowEffect2 (aEffectNumber : Word; aEffectKind : TLightEffectKind; aDelay: Integer);
var
   SubData : TSubData;
begin
   if aEffectNumber = 0 then exit;

   SubData.EffectNumber := aEffectNumber;
   SubData.EffectKind := aEffectKind;
   SubData.Delay := aDelay;
   SendLocalMessage (NOTARGETPHONE, FM_SETEFFECT, BasicData, SubData);
end;

function TLifeObject.ShootMagic (var aMagic: TMagicData; Bo : TBasicObject) : Boolean;
var
   SubData : TSubData;
   CurTick : Integer;
   Kind : Byte;
   SkillLevel : Integer;
begin
   Result := false;
   
   CurTick := mmAnsTick;
   
   if not AllowCommand (CurTick) then exit;

   if HitedTick + LifeData.AttackSpeed >= CurTick then exit;

   HitedTick := mmAnsTick;
   
   if GetViewDirection (BasicData.x, BasicData.y, bo.PosX, bo.posy) <> basicData.dir then
      CommandTurn ( GetViewDirection (BasicData.x, BasicData.y, bo.posx, bo.posy));

   SubData.MagicState := 0;
   SubData.MagicKind := 0;
   SubData.MagicColor := 0;
   SubData.motion := BasicData.Feature.rhitmotion;
   SendLocalMessage ( NOTARGETPHONE, FM_MOTION, BasicData, SubData);

   SubData.HitData.damageBody := aMagic.rLifeData.damageBody;
   SubData.HitData.damageHead := aMagic.rLifeData.damageHead;
   SubData.HitData.damageArm := aMagic.rLifeData.damageArm;
   SubData.HitData.damageLeg := aMagic.rLifeData.damageLeg;

   SubData.HitData.ToHit := 75;
   SubData.HitData.HitType := 1;
   SubData.HitData.HitLevel := aMagic.rcSkillLevel;

   SubData.HitData.Accuracy := 0;

   SubData.HitData.damageExp := aMagic.rLifeData.damageBody;
   SubData.HitData.MagicType := 0;
   SubData.HitData.Race := BasicData.Feature.rRace;
   SubData.HitData.GroupKey := 0;   

   SubData.TargetId := Bo.BasicData.id;
   SubData.tx := Bo.PosX;
   SubData.ty := Bo.PosY;
   SubData.BowImage := aMagic.rBowImage;
   SubData.BowSpeed := aMagic.rBowSpeed;
   SubData.BowType := aMagic.rBowType;
   SubData.EffectNumber := aMagic.rEEffectNumber;
   SubData.EffectKind := lek_none;
   SubData.HitData.HitFunction := 0;
   SubData.HitData.HitFunctionSkill := 0;

   if HaveMagicClass.isHaveDeadBlowMagic = true then begin
      Kind := 0; SkillLevel := 0;
      if HaveMagicClass.RunHaveDeadBlowMagic (Kind, SkillLevel) = true then begin
         SubData.HitData.HitFunction := Kind;
         SubData.HitData.HitFunctionSkill := SkillLevel;
      end;
   end;

   SendLocalMessage (NOTARGETPHONE, FM_BOW, BasicData, SubData);

   if aMagic.rSoundStrike.rWavNumber <> 0 then begin
      SetWordString (SubData.SayString, IntTostr (aMagic.rSoundStrike.rWavNumber) + '.wav');
      SendLocalMessage (NOTARGETPHONE, FM_SOUND, BasicData, SubData);
   end;

   Result := true;
end;

procedure TLifeObject.SetIceInterval (aInterval : Integer);
begin
   if aInterval = 0 then begin
      FIceTick := 0;
      FIceInterval := 0;
      exit;
   end;

   if FIceTick > 0 then exit;

   FIceTick := mmAnsTick;
   FIceInterval := aInterval;
end;

function TLifeObject.GotoXyStandAI (ax, ay : word) : Integer;
var
   x, y : Integer;
   key : word;
   SubData : TSubData;
begin
   Result := 2;

   if ActionWidth = 0 then exit;     // °íÁ¤¸ó½ºÅÍ¸¦ À§ÇØ
   if FboIce = true then exit;        // ¾ó¾îÀÖ´Â ¸ó½ºÅÍ¸¦ À§ÇØ

   if FIceTick > 0 then begin
      if mmAnsTick < FIceTick + FIceInterval then exit;
      SetIceInterval (0);
   end;

   x := 0;
   y := 0;
   if (ax = BasicData.x) and (ay = BasicData.y) then begin
      Result := 0;
      exit;
   end;

   SearchPathClass.SetMaper (Maper);
   SearchPathClass.GotoPath (BasicData.x, BasicData.y, ax, ay, x, y);
   if (x <> 0) and (y <> 0) then begin
      key := GetNextDirection (BasicData.x, BasicData.y, x, y);
      if BasicData.dir <> key then begin
         CommandTurn(key);
         Result := 1;
         exit;
      end;
      if Maper.isMoveable (x, y) then begin
         BasicData.nx := x;
         BasicData.ny := y;
         Phone.SendMessage ( NOTARGETPHONE, FM_MOVE, BasicData, SubData);
         Maper.MapProc (BasicData.Id, MM_MOVE, BasicData.x, BasicData.y, x, y, BasicData);
         BasicData.x := x; BasicData.y := y;
      end;
   end;
end;

function TLifeObject.GotoXyStand (ax, ay: word): integer;
   function _Gap ( a1, a2: word): integer;
   begin
      if a1 > a2 then Result := a1-a2
      else Result := a2-a1;
   end;

var
   i : integer;
   SubData: TSubData;
   key, len : word;
   boarr : array [0..8-1] of Boolean;
   lenarr : array [0..8-1] of word;
   mx, my: word;
begin
   Result := 2;

   if ActionWidth = 0 then exit;     // °íÁ¤¸ó½ºÅÍ¸¦ À§ÇØ
   if FboIce = true then exit;        // ¾ó¾îÀÖ´Â ¸ó½ºÅÍ¸¦ À§ÇØ

   if FIceTick > 0 then begin
      if mmAnsTick < FIceTick + FIceInterval then exit;
      SetIceInterval (0);
   end;

   len := _Gap (BasicData.x,ax) + _Gap(BasicData.y,ay);
   if (len = 0) then begin // µµÂø
      WorkOver;
      Result := 0;
      exit;
   end;

   key := GetNextDirection ( BasicData.x, BasicData.y, ax, ay);
   // µµÂø
   mx := BasicData.x;
   my := BasicData.y;
   GetNextPosition (key, mx, my);
   if (mx = ax) and (my = ay) and  not Maper.IsMoveable (ax, ay) then begin
      if BasicData.dir <> key then CommandTurn (key);
      Result := 1;
      exit;
   end;
   for i := 0 to 8-1 do lenarr[i] := 65535;

   boarr[0]  := Maper.isMoveable ( BasicData.x, BasicData.y-1);
   if (OldPos.x = BasicData.x) and (OldPos.y = BasicData.y-1) then boarr[0] := FALSE;
   if boarr[0] then lenarr[0] := (BasicData.x-ax)*(BasicData.x-ax) + (BasicData.y-1-ay)*(BasicData.y-1-ay);

   boarr[1]  := Maper.isMoveable ( BasicData.x+1, BasicData.y-1);
   if (OldPos.x = BasicData.x+1) and (OldPos.y = BasicData.y-1) then boarr[1] := FALSE;
   if boarr[1] then lenarr[1] := (BasicData.x+1-ax)*(BasicData.x+1-ax) + (BasicData.y-1-ay)*(BasicData.y-1-ay);

   boarr[2]  := Maper.isMoveable ( BasicData.x+1, BasicData.y);
   if (OldPos.x = BasicData.x+1) and (OldPos.y = BasicData.y) then boarr[2] := FALSE;
   if boarr[2] then lenarr[2] := (BasicData.x+1-ax)*(BasicData.x+1-ax) + (BasicData.y-ay)*(BasicData.y-ay);

   boarr[3]  := Maper.isMoveable ( BasicData.x+1, BasicData.y+1);
   if (OldPos.x = BasicData.x+1) and (OldPos.y = BasicData.y+1) then boarr[3] := FALSE;
   if boarr[3] then lenarr[3] := (BasicData.x+1-ax)*(BasicData.x+1-ax) + (BasicData.y+1-ay)*(BasicData.y+1-ay);

   boarr[4]  := Maper.isMoveable (   BasicData.x, BasicData.y+1);
   if (OldPos.x = BasicData.x) and (OldPos.y = BasicData.y+1) then boarr[4] := FALSE;
   if boarr[4] then lenarr[4] := (BasicData.x-ax)*(BasicData.x-ax) + (BasicData.y+1-ay)*(BasicData.y+1-ay);

   boarr[5]  := Maper.isMoveable ( BasicData.x-1, BasicData.y+1);
   if (OldPos.x = BasicData.x-1) and (OldPos.y = BasicData.y+1) then boarr[5] := FALSE;
   if boarr[5] then lenarr[5] := (BasicData.x-1-ax)*(BasicData.x-1-ax) + (BasicData.y+1-ay)*(BasicData.y+1-ay);

   boarr[6]  := Maper.isMoveable ( BasicData.x-1, BasicData.y);
   if (OldPos.x = BasicData.x-1) and (OldPos.y = BasicData.y) then boarr[6] := FALSE;
   if boarr[6] then lenarr[6] := (BasicData.x-1-ax)*(BasicData.x-1-ax) + (BasicData.y-ay)*(BasicData.y-ay);

   boarr[7]  := Maper.isMoveable ( BasicData.x-1, BasicData.y-1);
   if (OldPos.x = BasicData.x-1) and (OldPos.y = BasicData.y-1) then boarr[7] := FALSE;
   if boarr[7] then lenarr[7] := (BasicData.x-1-ax)*(BasicData.x-1-ax) + (BasicData.y-1-ay)*(BasicData.y-1-ay);


   len := 65535;
   for i := 0 to 8-1 do begin
      if len > lenarr[i] then begin
         key := i;
         len := lenarr[i];
      end;
   end;

   mx := BasicData.x; my := BasicData.y;
   GetNextPosition (key, mx, my);
   if key <> BasicData.dir then CommandTurn (key)
   else begin
      if Maper.isMoveable ( mx, my) then begin
         OldPos.x := BasicData.x;
         Oldpos.y := BasicData.y;
         BasicData.dir := key;
         BasicData.nx := mx;
         BasicData.ny := my;
         Phone.SendMessage (NOTARGETPHONE, FM_MOVE, BasicData, SubData);
         Maper.MapProc (BasicData.Id, MM_MOVE, BasicData.x, BasicData.y, mx, my, BasicData);
         BasicData.x := mx; BasicData.y := my;
      end else begin
         OldPos.x := 0; OldPos.y := 0;
      end;
   end;
end;

function  TLifeObject.FieldProc (hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;
var
   n, percent: integer;
   Ret, Str : String;
   aDistance : Integer;
begin
   Result := inherited FieldProc (hfu, Msg, Senderinfo, aSubData);
   if Result = PROC_TRUE then exit;
   case Msg of
      FM_BOW :
         begin
            if BasicData.Feature.rfeaturestate = wfs_die then exit;

            if FboHit = false then exit;
            if FboNotBowHit = true then exit;

            if (aSubData.TargetId = Basicdata.id) or
               (isBowArea (SenderInfo.dir, aSubData.tx, aSubData.ty, aSubData.HitData.HitFunction, percent)) then begin
               if SOnDanger <> 0 then begin
                  Str := GetWordString (aSubData.SayString);
                  Ret := ScriptManager.CallEvent (Self, SenderInfo.P, SOnDanger, 'OnDanger', [Str]);
                  if Ret = 'false' then exit;
               end;

               if aSubData.TargetID = BasicData.ID then Percent := 100;
               n := CommandBowed (SenderInfo.id, aSubData.HitData, percent);
               if CurLife <= 0 then CommandChangeCharState (wfs_die, SenderInfo);
               if n <> 0 then begin
                  aSubData.HitData.boHited := TRUE;
                  aSubData.HitData.HitedCount := aSubData.HitData.HitedCount + 1;
               end;

               if SOnBow <> 0 then begin
                  Str := GetWordString (aSubData.SayString);
                  ScriptManager.CallEvent (Self, SenderInfo.P, SOnBow, 'OnBow', [Str]);
               end;
            end;
         end;
      FM_CRITICAL :
         begin
            if FboHit = false then exit;
            if BasicData.Feature.rfeaturestate = wfs_die then exit;
            
            if isCriticalAttackArea(aSubData.TargetId, aSubData.RangeType,
               SenderInfo.x, SenderInfo.y, SenderInfo.dir, aSubData.tx, aSubData.ty,
               0, aSubData.MinRange, aSubData.MaxRange, aSubData.HitData.HitFunction, 100) then begin

               if SOnDanger <> 0 then begin
                  Ret := ScriptManager.CallEvent (Self, SenderInfo.P, SOnDanger, 'OnDanger', ['']);
                  if Ret = 'false' then exit;
               end;
                  
               n := CommandCriticalAttacked (SenderInfo, aSubData);
               if CurLife <= 0 then CommandChangeCharState (wfs_die, SenderInfo);
               if n <> 0 then begin
                  aSubData.HitData.boHited := true;
                  aSubData.HitData.HitedCount := aSubData.HitData.HitedCount + 1;
               end;
            end;
         end;
      FM_WINDOFHAND :
         begin
            if BasicData.Feature.rfeaturestate = wfs_die then exit;
            if FboHit = false then exit;
            if FboNotBowHit = true then exit;

            if aSubData.TargetId = Basicdata.id then begin
               if (GroupKey > 0) and (aSubData.HitData.GroupKey = GroupKey) then exit;            
               if isWindOfHandArea ( SenderInfo.x, SenderInfo.y, aSubData.MinRange, aSubData.MaxRange, aDistance ) then begin
                  if SOnDanger <> 0 then begin
                     Ret := ScriptManager.CallEvent (Self, SenderInfo.P, SOnDanger, 'OnDanger', ['']);
                     if Ret = 'false' then exit;
                  end;
//                  if (CurLife <= 0) then CommandChangeCharState (wfs_die, SenderInfo);
                  
                  n := LifeData.avoid + aSubData.HitData.ToHit + aSubData.HitData.Accuracy;
                  n := random (n);
                  if n < LifeData.avoid then exit;

                  //¹ßÈ¿½Ã°£°è»ê.
                  aSubData.Delay := aDistance;

                  AttackedMagicClass.AddWindOfHand (aSubData);

                  if SOnHit <> 0 then begin
                     Str := IntToStr (aSubData.HitData.damageExp);
                     ScriptManager.CallEvent (Self, SenderInfo.P, SOnHit, 'OnHit', [str]);
                  end;
               end else begin
                  TUser (SenderInfo.P).SendClass.SendChatMessage (Conv('²»ÔÚÓÐÐ§¾àÀëÖ®ÄÚ´òÆ«ÁË'),SAY_COLOR_SYSTEM);
               end;
            end;
         end;
      FM_HIT :
         begin
            if FboHit = false then exit;

            if BasicData.Feature.rfeaturestate = wfs_die then exit;
            if isHitedArea (SenderInfo.dir, SenderInfo.x, SenderInfo.y, aSubData.HitData.HitFunction, percent) then begin
               if SOnDanger <> 0 then begin
                  Ret := ScriptManager.CallEvent (Self, SenderInfo.P, SOnDanger, 'OnDanger', ['']);
                  if Ret = 'false' then exit;
               end;
               n := CommandHited (SenderInfo.id, aSubData.HitData, percent);
               if (CurLife <= 0) then CommandChangeCharState (wfs_die, SenderInfo);
               if n <> 0 then begin
                  aSubData.HitData.boHited := TRUE;
                  aSubData.HitData.HitedCount := aSubData.HitData.HitedCount +1;

                  if mmAnsTick - aSubData.HitData._3HitTick <= 300 then begin
                     inc (aSubData.HitData._3HitCount);
                     aSubData.HitData._3HitTick := mmAnsTick;
                     aSubData.HitData._3HitExp := F3HitExp;
                  end else begin
                     aSubData.HitData._3HitCount := 1;
                     aSubData.HitData._3HitTick := mmAnsTick;
                  end;
               end;
               if SOnHit <> 0 then begin
                  Str := IntToStr (aSubData.HitData.damageExp);
                  ScriptManager.CallEvent (Self, SenderInfo.P, SOnHit, 'OnHit', [str]);
               end;
            end;
         end;
      FM_SPELL :
         begin
            if SenderInfo.id = BasicData.id then exit;
            if BasicData.Feature.rFeatureState = wfs_die then begin
               Result := PROC_TRUE;
               exit;
            end;
            if isSpellArea (SenderInfo.x, SenderInfo.y, aSubData.ShoutColor) then begin
               CommandSpell (SenderInfo.id, aSubData.SpellType, aSubData.SpellDamage);
               if CurLife = 0 then CommandChangeCharState (wfs_die, SenderInfo);
            end;
         end;
   end;
end;

procedure TLifeObject.WorkBoxCommand (aCmd : Byte);
var
   pWorkParam : array [0..10 - 1] of PTWorkParam;
   tmpbyte : Byte;
   tmpUser : TUser;
begin
   Case FWorkBox.WorkSet.Cmd of
      CMD_ATTACK :
         begin
            pWorkParam [0] := FWorkBox.WorkSet.GetParam (0);
            AddTrace (format ('%s ATTACK ID:%d', [StrPas (@BasicData.Name), pWorkParam [0]^.iValue]));
            SAttack (pWorkParam [0]^.iValue);
         end;
      CMD_MOVEATTACK :
         begin
            pWorkParam [0] := FWorkBox.WorkSet.GetParam (0);
            AddTrace (format ('%s MOVEATTACK ID:%d', [StrPas (@BasicData.Name), pWorkParam [0]^.iValue]));
            SAttack (pWorkParam [0]^.iValue);
         end;
      CMD_GOTOXY :
         begin
            pWorkParam [0] := FWorkBox.WorkSet.GetParam (0);
            pWorkParam [1] := FWorkBox.WorkSet.GetParam (1);
            AddTrace (format ('%s GOTOXY (%d,%d)', [StrPas (@BasicData.Name), pWorkParam [0]^.iValue, pWorkParam [1]^.iValue]));
            SGotoXy (pWorkParam [0]^.iValue, pWorkParam [1]^.iValue);
            exit;
         end;
      CMD_SAY :
         begin
            pWorkParam [0] := FWorkBox.WorkSet.GetParam (0);
            AddTrace (format ('%s SAY', [StrPas (@BasicData.Name)]));
            SSay (pWorkParam [0]^.sValue);
         end;
      CMD_SOUND :
         begin
            pWorkParam [0] := FWorkBox.WorkSet.GetParam (0);
            AddTrace (format ('%s SOUND', [StrPas (@BasicData.Name)]));
         end;
      CMD_SELFKILL :
         begin
            AddTrace (format ('%s SELFKILL', [StrPas (@BasicData.Name)]));
            SSelfKill;
         end;
      CMD_CHANGESTATE :
         begin
            pWorkParam [0] := FWorkBox.WorkSet.GetParam (0);
            tmpByte := pWorkParam [0]^.iValue;
            AddTrace (format ('%s CHANGESTATE', [StrPas (@BasicData.Name)]));
            SChangeState (tmpByte);
         end;
      CMD_SENDCENTERMSG :
         begin
            pWorkParam [0] := FWorkBox.WorkSet.GetParam (0);
            pWorkParam [1] := FWorkBox.WorkSet.GetParam (1);
            AddTrace (format ('%s SENDCENTERMSG', [StrPas (@BasicData.Name)]));
            tmpUser := UserList.GetUserPointer (pWorkParam [0]^.sValue);
            if tmpUser <> nil then begin
               tmpUser.SendClass.SendCenterMessage (pWorkParam [1]^.sValue);
            end;
         end;
      CMD_CHANGESTEP :
         begin
            pWorkParam [0] := FWorkBox.WorkSet.GetParam (0);
            pWorkParam [1] := FWorkBox.WorkSet.GetParam (1);
            AddTrace (format ('%s CHANGESTEP', [StrPas (@BasicData.Name)]));
            if UpperCase (pWorkParam [1]^.sValue) = 'TRUE' then begin
               TDynamicObjectList (Manager.DynamicObjectList).ChangeStep (pWorkParam [0]^.sValue, true);
            end else begin
               TDynamicObjectList (Manager.DynamicObjectList).ChangeStep (pWorkParam [0]^.sValue, false);
            end;
         end;
      CMD_MOVESPACE :
         begin
            pWorkParam [0] := FWorkBox.WorkSet.GetParam (0);
            pWorkParam [1] := FWorkBox.WorkSet.GetParam (1);
            pWorkParam [2] := FWorkBox.WorkSet.GetParam (2);
            pWorkParam [3] := FWorkBox.WorkSet.GetParam (3);
            pWorkParam [4] := FWorkBox.WorkSet.GetParam (4);

            AddTrace (format ('%s MOVESPACE', [StrPas (@BasicData.Name)]));
            SMoveSpace (pWorkParam [0]^.sValue, pWorkParam [1]^.sValue,
               pWorkParam [2]^.iValue, pWorkParam [3]^.iValue, pWorkParam [4]^.iValue);
         end;
      CMD_MAPREGEN :
         begin
            pWorkParam [0] := FWorkBox.WorkSet.GetParam (0);
            AddTrace (format ('%s MAPREGEN', [StrPas (@BasicData.Name)]));
            SMapRegen (pWorkParam [0]^.iValue);
         end;
      CMD_ALLOWHIT :
         begin
            pWorkParam [0] := FWorkBox.WorkSet.GetParam (0);
            AddTrace (format ('%s ALLOWHIT', [StrPas (@BasicData.Name)]));
            SSetAllowHit (pWorkParam [0]^.sValue);
         end;
      CMD_ADDMOP :
         begin
            pWorkParam [0] := FWorkBox.WorkSet.GetParam (0);
            pWorkParam [1] := FWorkBox.WorkSet.GetParam (1);
            pWorkParam [2] := FWorkBox.WorkSet.GetParam (2);
            pWorkParam [3] := FWorkBox.WorkSet.GetParam (3);
            pWorkParam [4] := FWorkBox.WorkSet.GetParam (4);
            pWorkParam [5] := FWorkBox.WorkSet.GetParam (5);
            AddTrace (format ('%s REGEN', [StrPas (@BasicData.Name)]));

            if pWorkParam [5]^.sValue = 'true' then begin
               TMonsterList (Manager.MonsterList).MakeMonster (pWorkParam [0]^.sValue, pWorkParam [1]^.iValue,
                  pWorkParam [2]^.iValue, pWorkParam [3]^.iValue, pWorkParam [4]^.iValue, true);
            end else if pWorkParam [5]^.sValue = 'false' then begin
               TMonsterList (Manager.MonsterList).MakeMonster (pWorkParam [0]^.sValue, pWorkParam [1]^.iValue,
                  pWorkParam [2]^.iValue, pWorkParam [3]^.iValue, pWorkParam [4]^.iValue, false);
            end;
         end;
   end;

   WorkOver;
end;

procedure TLifeObject.SSay (aStr : String);
begin
   BocSay (aStr);
end;

procedure TLifeObject.SAttack (aID : Integer);
begin
   AttackSkill.SetTargetID (aID, true);
end;

procedure TLifeObject.SSelfKill;
begin
//   BasicData.Feature.rfeaturestate := wfs_die;
   LifeObjectState := los_die;
end;

procedure TLifeObject.SGotoXY (aX, aY : Word);
begin
   AttackSkill.TargetX := aX;
   AttackSkill.TargetY := aY;
   GotoXyStand (aX, aY);
end;

procedure TLifeObject.SSetAutoMode;
begin
   if (FWorkBox.AutoMode = wcm_manual) and (AttackSkill.GetTargetID <> 0) then exit;

   FWorkBox.AutoMode := wcm_auto;
end;

procedure TLifeObject.SCommandIce (aInterval : Integer);
begin
   SetIceInterval (aInterval);
end;

procedure TLifeObject.SSetAllowHit (aHit : String);
begin
   if UpperCase (aHit) = 'TRUE' then begin
      FboHit := true;
   end else begin
      FboHit := false;
   end;
end;

procedure TLifeObject.Update (CurTick: integer);
begin
   inherited Update (CurTick);

   if (FWorkBox.WorkState <> ws_ing) and (FWorkBox.WorkSet <> nil) then begin
      if FWorkBox.WorkSet.isTimeOver (CurTick) = true then begin
         FWorkBox.WorkState := ws_ing;
         WorkBoxCommand (FWorkBox.WorkSet.Cmd);
      end;
   end;
   try
      AttackedMagicClass.Update (CurTick);
   except
      FboAllowDelete := true;
      frmMain.WriteLogInfo (format ('AttackedMagicClass Update Failed (%s)', [StrPas (@BasicData.Name)]));
   end;
end;

/////////////////////////////////////////////////
//                 TBuySellSkill
/////////////////////////////////////////////////

constructor TBuySellSkill.Create (aBasicObject : TBasicObject);
begin
   BasicObject := aBasicObject;

   BuyTitle := StrPas (@BasicObject.BasicData.ViewName);
   BuyCaption := '';
   BuyImage := 0;

   SellTitle := StrPas (@BasicObject.BasicData.ViewName);
   SellCaption := '';
   SellImage := 0;

   BuyItemList := TList.Create;
   SellItemList := TList.Create;

   boLogItem := false;

   LoadFromFile ('test.txt');
end;

destructor TBuySellSkill.Destroy;
begin
   Clear;
   
   if BuyItemList <> nil then BuyItemList.Free;
   if SellItemList <> nil then SellItemList.Free;
   
   inherited Destroy;
end;

procedure TBuySellSkill.Clear;
var
   i : Integer;
   pItemData : PTItemData;
begin
   if BuyItemList <> nil then begin
      for i := 0 to BuyItemList.Count - 1 do begin
         pItemData := BuyItemList.Items [i];
         if pItemData <> nil then Dispose (pItemData);
      end;
      BuyItemList.Clear;
   end;
   if SellItemList <> nil then begin
      for i := 0 to SellItemList.Count - 1 do begin
         pItemData := SellItemList.Items [i];
         if pItemData <> nil then Dispose (pItemData);
      end;
      SellItemList.Clear;
   end;
end;

function TBuySellSkill.LoadFromFile (aFileName : String) : Boolean;
var
   i : Integer;
   mStr, KindStr, ItemName : String;
   StringList : TStringList;
   ItemData : TItemData;
   pItemData : PTItemData;
begin
   Result := false;

   if FileExists (aFileName) then begin
      FileName := aFileName;
      Clear;

      StringList := TStringList.Create;
      StringList.LoadFromFile (aFileName);
      for i := 0 to StringList.Count - 1 do begin
         mStr := StringList.Strings[i];
         if mStr <> '' then begin
            mStr := GetValidStr3 (mStr, KindStr, ':');
            mStr := GetValidStr3 (mStr, ItemName, ':');

            if KindStr <> '' then begin
               if UpperCase (KindStr) = 'SELLITEM' then begin
                  ItemClass.GetItemData (ItemName, ItemData);
                  if ItemData.rName[0] <> 0 then begin
                     New (pItemData);
                     Move (ItemData, pItemData^, sizeof (TItemData));
                     SellItemList.Add (pItemData)
                  END;
               end else if UpperCase (KindStr) = 'BUYITEM' then begin
                  ItemClass.GetItemData (ItemName, ItemData);
                  if ItemData.rName[0] <> 0 then begin
                     New (pItemData);
                     Move (ItemData, pItemData^, sizeof (TItemData));
                     BuyItemList.Add (pItemData)
                  end;
               end else if UpperCase (KindStr) = 'SELLTITLE' then begin
                  SellTitle := ItemName;
               end else if UpperCase (KindStr) = 'SELLCAPTION' then begin
                  SellCaption := ItemName;
               end else if UpperCase (KindStr) = 'SELLIMAGE' then begin
                  SellImage := _StrToInt (ItemName);
               end else if UpperCase (KindStr) = 'BUYTITLE' then begin
                  BuyTitle := ItemName;
               end else if UpperCase (KindStr) = 'BUYCAPTION' then begin
                  BuyCaption := ItemName;
               end else if UpperCase (KindStr) = 'BUYIMAGE' then begin
                  BuyImage := _StrToInt (ItemName);
               end;
            end;
         end;
      end;
      StringList.Free;
      Result := true;
   end;
end;

function TBuySellSkill.DivHearing (aHearStr: string; var Sayer, aItemName: string; var aItemCount: integer): integer;
var
   str: string;
   str1, str2, str3: string;
begin
   Result := DIVRESULT_NONE;
//   exit;    // Ã¢À¸·Î ¹Ù²å±â ¶§¹®¿¡...        // ³ëÇù°´ÀÌº¥¶§¹®¿¡ Àá±ñ...

   if not ReverseFormat (aHearStr, '%s: %s', str1, str2, str3, 2) then exit;
   sayer := str1;

   str := str2;



   {
   if Pos (Conv('ÂôÊ²Ã´'), str) = 1 then Result := DIVRESULT_WHATSELL;
   if Pos (Conv('ÂòÊ²Ã´'), str) = 1 then Result := DIVRESULT_WHATBUY;
   if Pos (Conv('ÂòÈë'), str) = 1 then Result := DIVRESULT_WHATSELL;
   if Pos (Conv('Âô³ö'), str) = 1 then Result := DIVRESULT_WHATBUY;
   if Result <> DIVRESULT_NONE then exit;

   if ReverseFormat (str, Conv('%s ¶àÉÙÇ®'), str1, str2, str3, 1) then begin
      aItemName := str1;
      Result := DIVRESULT_HOWMUCH;
      exit;
   end;

   if ReverseFormat (str, Conv('Âò %s %s¸ö'), str1, str2, str3, 2) then begin
      aItemName := str1;
      aItemCount := _StrToInt (str2);
      Result := DIVRESULT_BUYITEM;
      exit;
   end;
   if ReverseFormat (str, Conv('Âò %s %s¸ö'), str1, str2, str3, 2) then begin
      aItemName := str1;
      aItemCount := _StrToInt (str2);
      Result := DIVRESULT_BUYITEM;
      exit;
   end;


   if ReverseFormat (str, Conv('Âô %s %s¸ö'), str1, str2, str3, 2) then begin
      aItemName := str1;
      aItemCount := _StrToInt(str2);
      if aItemCount < 0 then aItemCount := 0;
      Result := DIVRESULT_SELLITEM;
      exit;
   end;
   if ReverseFormat (str, Conv('Âô %s %s¸ö'), str1, str2, str3, 2) then begin
      aItemName := str1;
      aItemCount := _StrToInt(str2);
      if aItemCount < 0 then aItemCount := 0;
      Result := DIVRESULT_SELLITEM;
      exit;
   end;

   if ReverseFormat (str, Conv('ÂòÈë%s'), str1, str2, str3, 1) then begin
      aItemName := str1;
      aItemCount := 1;
      Result := DIVRESULT_BUYITEM;
      exit;
   end;
   if ReverseFormat (str, Conv('ÂòÈë%s'), str1, str2, str3, 1) then begin
      aItemName := str1;
      aItemCount := 1;
      Result := DIVRESULT_BUYITEM;
      exit;
   end;

   if ReverseFormat (str, Conv('Âô³ö%s'), str1, str2, str3, 1) then begin
      aItemName := str1;
      aItemCount := 1;
      Result := DIVRESULT_SELLITEM;
      exit;
   end;
   if ReverseFormat (str, Conv('Âô³ö%s'), str1, str2, str3, 1) then begin
      aItemName := str1;
      aItemCount := 1;
      Result := DIVRESULT_SELLITEM;
      exit;
   end;
   }
end;

function TBuySellSkill.ProcessMessage (aStr : String; SenderInfo : TBasicData) : Boolean;
var
   i, icnt, ipos, jpos, ret : Integer;
   str, sayer, iname : String;
   pItemData : PTItemData;
   ItemData, MoneyItemData : TItemData;
   SubData : TSubData;
begin
   Result := true;

   ret := DivHearing (aStr, sayer, iname, icnt);
   case ret of
      {
      DIVRESULT_ITEMLOG :
         begin
            User := UserList.GetUserPointer (StrPas (@SenderInfo.Name));
            if User <> nil then begin
               RetStr := User.ShowItemLogWindow;
               if RetStr <> '' then begin
                  TLIfeObject (BasicObject).CommandSay (RetStr);
               end;
            end;
         end;
      }
      DIVRESULT_HOWMUCH:
         begin
            ipos := -1; jpos := -1;
            for i := 0 to SellItemList.Count - 1 do begin
               pitemdata := SellItemList[i];
               if iname = Strpas (@pitemdata^.rname) then begin
                  ipos := i;
                  break;
               end;
            end;
            for i := 0 to BuyItemList.Count - 1 do begin
               pItemData := BuyItemList[i];
               if iname = Strpas (@pitemdata^.rname) then begin
                  jpos := i;
                  break;
               end;
            end;

            if (ipos >= 0) and (jpos >= 0) then begin
               ItemClass.GetItemData (iName, ItemData);
               TLifeObject (BasicObject).CommandSay (format (Conv('%sÒÔ %dÇ§Äê±ÒÂô³ö ÒÔ %dÇ§Äê±ÒÂòÈë'),[iname,ItemData.rPrice, ItemData.rBuyPrice]));
            end else if ipos >= 0 then begin
               ItemClass.GetItemData (iName, ItemData);
               TLifeObject (BasicObject).CommandSay (format (Conv('%sÒÔ %dÇ§Äê±ÒÂô³ö'),[iname,ItemData.rPrice]));
            end else if jpos >= 0 then begin
               ItemClass.GetItemData (iname, ItemData);
               TLifeObject (BasicObject).CommandSay (format (Conv('%sÒÔ %dÇ§Äê±ÒÂòÈë'),[iname,ItemData.rBuyPrice]));
            end else begin
               TLifeObject (BasicObject).CommandSay (format (Conv('Ã»ÓÐ%s¡£'),[iname]));
            end;
         end;
      DIVRESULT_SELLITEM:
         begin
            if icnt <= 0 then exit;
            if icnt > 1000 then begin
               TLifeObject(BasicObject).CommandSay (Conv('ÊýÁ¿Ì«¶à¡£'));
               exit;
            end;

            ipos := -1;
            for i := 0 to BuyItemList.count-1 do begin
               pitemdata := Buyitemlist[i];
               if iname = Strpas (@pitemdata^.rname) then begin ipos := i; break; end;
            end;
            if ipos = -1 then begin
               TLIfeObject (BasicObject).CommandSay (format (Conv('²»Âò%s¡£'),[iname]));
               exit;
            end;
            if TFieldPhone (BasicObject.Manager.Phone).SendMessage (SenderInfo.id, FM_ENOUGHSPACE, BasicObject.BasicData, SubData) = PROC_FALSE then begin
               TLIfeObject (BasicObject).CommandSay (Conv('Ð¯´øµÄÎïÆ·Ì«¶àÁË¡£'));
               exit;
            end;

            ItemClass.GetItemData (INI_GOLD, MoneyItemData);
            ItemClass.GetItemData (iname, ItemData);

            SignToItem (ItemData, BasicObject.Manager.ServerID, BasicObject.BasicData, '');
            SubData.ItemData := ItemData;
            SubData.ItemData.rCount := icnt;
            if TFieldPhone(BasicObject.Manager.Phone).SendMessage (SenderInfo.id, FM_DELITEM, BasicObject.BasicData, SubData) = PROC_FALSE then begin
               TLIfeObject (BasicObject).CommandSay (format (Conv('Ã»ÓÐÐ¯´ø%s¡£'),[iname]));
               exit;
            end;

            MoneyItemData.rCount := ItemData.rBuyPrice * icnt;
            SignToItem (MoneyItemData, BasicObject.Manager.ServerID, BasicObject.BasicData, '');
            SubData.ItemData := MoneyItemData;
            SubData.ServerId := BasicObject.Manager.ServerId;
            TFieldPhone (BasicObject.Manager.Phone).SendMessage (SenderInfo.id, FM_ADDITEM, BasicObject.BasicData, SubData);
            TLIfeObject (BasicObject).CommandSay (format (Conv('ÂòÈëÁË%s¡£'), [iname]));
         end;
      DIVRESULT_BUYITEM:
         begin
            if icnt <= 0 then exit;
            if icnt > 1000 then begin
               TLIfeObject (BasicObject).CommandSay (Conv('ÊýÁ¿Ì«¶à'));
               exit;
            end;
            ipos := -1;
            for i := 0 to SellItemList.count-1 do begin
               pitemdata := sellitemlist[i];
               if iname = Strpas (@pitemdata^.rname) then begin ipos := i; break; end;
            end;
            if ipos = -1 then begin
               TLIfeObject (BasicObject).CommandSay (format (Conv('Ã»ÓÐ%s¡£'),[iname]));
               exit;
            end;

            ItemClass.GetItemData (INI_GOLD, MoneyItemData);
            ItemClass.GetItemData (iname, ItemData);

            if (ItemData.rboDouble = false) and (icnt > 1) then begin
               TLIfeObject (BasicObject).CommandSay (format (Conv('%sÖ»ÂôÒ»¸ö'), [StrPas(@ItemData.rName)]));
               exit;
            end;
            if TFieldPhone(BasicObject.Manager.Phone).SendMessage (SenderInfo.id, FM_ENOUGHSPACE, BasicObject.BasicData, SubData) = PROC_FALSE then begin
               TLIfeObject (BasicObject).CommandSay (Conv('Ð¯´øµÄÎïÆ·Ì«¶àÁË¡£'));
               exit;
            end;

            SignToItem (MoneyItemData, BasicObject.Manager.ServerID, BasicObject.BasicData, '');
            MoneyItemData.rCount := ItemData.rPrice * icnt;
            SubData.ItemData := MoneyItemData;
            if TFieldPhone(BasicObject.Manager.Phone).SendMessage (SenderInfo.id, FM_DELITEM, BasicObject.BasicData, SubData) = PROC_FALSE then begin
               TLIfeObject (BasicObject).CommandSay (Conv('Ëù´øµÄÇ®Ì«ÉÙ'));
               exit;
            end;

            ItemData.rCount := icnt;
            SignToItem (ItemData, BasicObject.Manager.ServerID, BasicObject.BasicData, '');
            SubData.ItemData := ItemData;
            SubData.ServerId := BasicObject.Manager.ServerId;
            TFieldPhone(BasicObject.Manager.Phone).SendMessage (SenderInfo.id, FM_ADDITEM, BasicObject.BasicData, SubData);
            TLIfeObject (BasicObject).CommandSay (format (Conv('ÂôµôÁË%s¡£'),[iname]));
         end;
      DIVRESULT_WHATSELL:
         begin
            str := '';
            for i := 0 to SellItemList.count-1 do begin
               pitemdata := sellitemlist[i];
               if i < SellItemList.count-1 then str := str + Strpas (@pitemdata^.rname) + ','
               else                             str := str + Strpas (@pitemdata^.rname);
            end;
            if SellItemList.Count <> 0 then
               TLIfeObject (BasicObject).CommandSay (format (Conv('Âô³ö%s¡£'),[str]))
            else
               TLIfeObject (BasicObject).CommandSay (Conv('ÎÒ²»ÂôÎïÆ·'));
         end;
      DIVRESULT_WHATBUY:
         begin
            str := '';
            for i := 0 to BuyItemList.count-1 do begin
               pitemdata := Buyitemlist[i];
               if i < BuyItemList.count-1 then str := str + Strpas (@pitemdata^.rname) + ','
               else                             str := str + Strpas (@pitemdata^.rname);
            end;
            if BuyItemList.Count <> 0 then
               TLIfeObject (BasicObject).CommandSay (format (Conv('ÂòÈë%s¡£'),[str]))
            else
               TLIfeObject (BasicObject).CommandSay (Conv('ÎÒ²»ÂòÎïÆ·'));
         end;
      else begin
         Result := false;
      end;
   end;
end;

function TBuySellSkill.GetSellItemString : String;
var
   i : Integer;
   Str : String;
   pItemData : PTItemData;
begin
   Result := '';

   Str := '';
   for i := 0 to SellItemList.Count - 1 do begin
      pItemData := SellItemList.Items [i];
      if pItemData <> nil then begin
         if Str <> '' then Str := Str + ',';
         Str := Str + StrPas (@pItemData^.rName);
      end;
   end;

   Result := Str;
end;

function TBuySellSkill.GetBuyItemString : String;
var
   i : Integer;
   Str : String;
   pItemData : PTItemData;
begin
   Result := '';

   Str := '';
   for i := 0 to BuyItemList.Count - 1 do begin
      pItemData := BuyItemList.Items [i];
      if pItemData <> nil then begin
         if Str <> '' then Str := Str + ',';
         Str := Str + StrPas (@pItemData^.rName);
      end;
   end;

   Result := Str;
end;

/////////////////////////////////////////////////
//                 TSpeechSkill
/////////////////////////////////////////////////

constructor TSpeechSkill.Create (aBasicObject : TBasicObject);
begin
   BasicObject := aBasicObject;

   SpeechList := TList.Create;
   CurSpeechIndex := 0;
   SpeechTick := 0;
end;

destructor TSpeechSkill.Destroy;
begin
   if SpeechList <> nil then begin
      Clear();
      SpeechList.Free;
   end;
end;

procedure TSpeechSkill.Clear;
var
   i : Integer;
begin
   for i := 0 to SpeechList.Count - 1 do dispose (SpeechList[i]);
   SpeechList.Clear;
   CurSpeechIndex := 0;
   SpeechTick := 0;
end;

function TSpeechSkill.LoadFromFile (aFileName : String) : Boolean;
var
   i : integer;
   SpeechDB : TUserStringDB;
   iname : String;
   pd : PTSpeechData;
begin
   Result := false;
   
   if aFileName = '' then exit;
   if FileExists(aFileName) = FALSE then exit;

   Clear;

   SpeechDB := TUserStringDb.Create;
   SpeechDB.LoadFromFile (aFileName);

   for i := 0 to SpeechDB.Count -1 do begin
      iname := SpeechDB.GetIndexName (i);
      if SpeechDB.GetFieldValueBoolean(iname, 'boSelfSay') = TRUE then begin
         New (pd);
         FillChar (pd^, sizeof(TSpeechData), 0);
         pd^.rSayString := SpeechDB.GetFieldValueString (iname, 'SayString');
         pd^.rDelayTime := SpeechDB.GetFieldValueInteger (iname, 'DelayTime');
         pd^.rSpeechTick := pd^.rDelayTime;
         SpeechList.Add(pd);
      end;
   end;
   SpeechDB.Free;
end;

procedure TSpeechSkill.ProcessMessage (CurTick : Integer);
var
   pd : PTSpeechData;
begin
   if SpeechList.Count > 0 then begin
      pd := SpeechList[CurSpeechIndex];
      if SpeechTick + pd^.rDelayTime < CurTick then begin
         TLIfeObject(BasicObject).CommandSay(pd^.rSayString);
         SpeechTick := CurTick;
         if CurSpeechIndex < SpeechList.Count - 1 then Inc(CurSpeechIndex)
         else CurSpeechIndex := 0;
      end;
   end;
end;


/////////////////////////////////////////////////
//                 TDeallerSkill
/////////////////////////////////////////////////

constructor TDeallerSkill.Create (aBasicObject : TBasicObject);
begin
   BasicObject := aBasicObject;
   DataList := TList.Create;
end;

destructor TDeallerSkill.Destroy;
begin
   if DataList <> nil then begin
      Clear;
      DataList.Free;
   end;
   inherited Destroy;
end;

procedure TDeallerSkill.Clear;
var
   i : Integer;
begin
   for i := 0 to DataList.Count - 1 do dispose (DataList[i]);
   DataList.Clear;
end;

function TDeallerSkill.LoadFromFile (aFileName : String) : Boolean;
var
   i, j, iCount : integer;
   DeallerDB : TUserStringDB;
   iname : String;
   pd : PTDeallerData;
   str, mName, mCount : String;
begin
   Result := false;

   if aFileName = '' then exit;
   if FileExists(aFileName) = FALSE then exit;

   Clear;

   DeallerDB := TUserStringDb.Create;
   DeallerDB.LoadFromFile (aFileName);

   for i := 0 to DeallerDB.Count -1 do begin
      iname := DeallerDB.GetIndexName (i);
      if DeallerDB.GetFieldValueBoolean(iname, 'boSelfSay') <> TRUE then begin
         new (pd);
         FillChar (pd^, sizeof(TDeallerData), 0);
         pd^.rHearString := DeallerDB.GetFieldValueString (iname, 'HearString');
         pd^.rSayString := DeallerDB.GetFieldValueString (iname, 'SayString');
         str := DeallerDB.GetFieldValueString (iname, 'NeedItem');
         for j := 0 to 5 - 1 do begin
            if str = '' then break;
            str := GetValidStr3 (str, mName, ':');
            if mName = '' then break;
            str := GetValidStr3 (str, mCount, ':');
            if mCount = '' then break;
            iCount := _StrToInt (mCount);
            if iCount <= 0 then iCount := 1;
            StrPCopy (@pd^.rNeedItem[j].rName, mName);
            pd^.rNeedItem[j].rCount := iCount;
         end;
         str := DeallerDB.GetFieldValueString (iname, 'GiveItem');
         for j := 0 to 5 - 1 do begin
            if str = '' then break;
            str := GetValidStr3 (str, mName, ':');
            if mName = '' then break;
            str := GetValidStr3 (str, mCount, ':');
            if mCount = '' then break;
            iCount := _StrToInt (mCount);
            if iCount <= 0 then iCount := 1;
            StrPCopy (@pd^.rGiveItem[j].rName, mName);
            pd^.rGiveItem[j].rCount := iCount;
         end;
         DataList.Add(pd);
      end;
   end;
   DeallerDB.Free;
   Result := true;
end;

function TDeallerSkill.ProcessMessage (aStr : String; SenderInfo : TBasicData) : Boolean;
var
   i, j, k : Integer;
   sayer, dummy1, dummy2 : String;
   pd : PTDeallerData;
   BO : TBasicObject;
   SubData : TSubData;
   ItemData : TItemData;
begin
   Result := false;

   if DataList.Count <= 0 then exit;

   for i := 0 to DataList.Count - 1 do begin
      pd := DataList[i];
      if ReverseFormat (astr, '%s: ' + pd^.rHearString, sayer, dummy1, dummy2, 1) then begin
         BO := TLifeObject (BasicObject).GetViewObjectByID (SenderInfo.id);
         if BO = nil then exit;
         if SenderInfo.Feature.rRace <> RACE_HUMAN then exit;
         for j := 0 to 5 - 1 do begin
            if pd^.rNeedItem[j].rName [0] = 0 then break;
            ItemClass.GetItemData (StrPas (@pd^.rNeedItem[j].rName), ItemData);
            if ItemData.rName[0] <> 0 then begin
               ItemData.rCount := pd^.rNeedItem[j].rCount;
               if TUser (BO).FindItem (@ItemData) = false then begin
                  TUser (BO).SendClass.SendChatMessage (format (Conv('%s ÎïÆ·ÐèÒª %d¸ö'), [StrPas (@ItemData.rName), ItemData.rCount]), SAY_COLOR_SYSTEM);
                  exit;
               end;
            end;
         end;

         BasicObject.BasicData.nx := SenderInfo.x;
         BasicObject.BasicData.ny := SenderInfo.y;
         for j := 0 to 5 - 1 do begin
            if pd^.rGiveItem[j].rName [0] = 0 then break;
            ItemClass.GetItemData (StrPas (@pd^.rGiveItem[j].rName), ItemData);
            ItemData.rCount := pd^.rGiveItem[j].rCount;
            ItemData.rOwnerName[0] := 0;

            SubData.ItemData := ItemData;
            SubData.ServerId := BasicObject.ServerId;
            if TFieldPhone (BasicObject.Manager.Phone).SendMessage (SenderInfo.id, FM_ENOUGHSPACE, BasicObject.BasicData, SubData) = PROC_FALSE then begin
               for k := 0 to j - 1 do begin
                  if pd^.rGiveItem[j].rName [0] = 0 then break;
                  ItemClass.GetItemData (StrPas (@pd^.rGiveItem[j].rName), ItemData);
                  ItemData.rCount := pd^.rGiveItem[j].rCount;
                  ItemData.rOwnerName[0] := 0;
                  TUser (BO).DeleteItem (@ItemData);
               end;
               TLIfeObject (BasicObject).CommandSay(Conv('ÎïÆ·´°µÄ¿Õ¼ä²»×ã'));
               exit;
               // TFieldPhone (BasicObject.Phone).SendMessage (MANAGERPHONE, FM_ADDITEM, BasicObject.BasicData, SubData);
            end else begin
               TFieldPhone(BasicObject.Manager.Phone).SendMessage (SenderInfo.id, FM_ADDITEM, BasicObject.BasicData, SubData);
            end;
         end;

         for j := 0 to 5 - 1 do begin
            if pd^.rNeedItem[j].rName [0] = 0 then break;
            ItemClass.GetItemData (StrPas (@pd^.rNeedItem[j].rName), ItemData);
            if ItemData.rName[0] <> 0 then begin
               ItemData.rCount := pd^.rNeedItem[j].rCount;
               TUser (BO).DeleteItem (@ItemData);
            end;
         end;
         TLIfeObject (BasicObject).CommandSay(pd^.rSayString);

         Result := true;
         exit;
      end;
   end;
end;

/////////////////////////////////////////////////
//                 TAttackSkill;
/////////////////////////////////////////////////

constructor TAttackSkill.Create (aBasicObject : TBasicObject);
begin
   BasicObject := aBasicObject;

   if Pointer (BasicObject) = Pointer ($150) then begin
      BasicObject := nil;
   end;

   Boss := nil;
   ObjectBoss := nil;

   MasterName := '';
   DeadAttackName := '';
   TargetID := 0;
   EscapeID := 0;
   EscapeLife := 0;

   boGroup := false;
   boBoss := false;

   TargetIDTick := 0;
   TargetPosTick := 0;
   BattleTick := 0;
   CurNearViewHumanId := 0;
   HateHumanId := 0;

   boGroupSkill := false;
   GroupSkill := nil;

   boSelfTarget := true;
   boObserver := false;

   BowCount := 5;
   boBowAvail := true;
   BowAvailTick := 0;
   BowAvailInterval := 500;

   AttackType := ATTACKTYPE_NONE;
end;

destructor TAttackSkill.Destroy;
begin
   NoticeDie;
   if ObjectBoss <> nil then begin
      ObjectBoss.MemberDie (BasicObject);
   end;
   if GroupSkill <> nil then begin
      GroupSkill.BossDie;
      GroupSkill.Free;
      GroupSkill := nil;
      boGroupSkill := false;
   end;
   inherited Destroy;
end;

procedure TAttackSkill.HelpMe (aMeID, aTargetID, aX, aY : Integer);
begin
   if aTargetID <> 0 then begin
      if TargetID <> aTargetID then begin
         SetHelpTargetIDandPos (aTargetID, aX, aY);
      end;
      if GroupSkill <> nil then begin
         GroupSkill.MoveAttack (aTargetID, aX, aY);
      end else begin
         GroupSkill := nil;
      end;
   end;
end;

procedure TAttackSkill.CancelHelp (aTargetID : Integer);
begin
   if aTargetID <> 0 then begin
      if GroupSkill <> nil then begin
         GroupSkill.CancelTarget (aTargetID);
      end else begin
         GroupSkill := nil;
      end;
   end;
end;

procedure TAttackSkill.SetSelf (aSelf : TBasicObject);
begin
   BasicObject := aSelf;
end;

procedure TAttackSkill.SetBoss (aBoss : TBasicObject);
begin
   Boss := aBoss;
end;

procedure TAttackSkill.SetObjectBoss (aBoss : TDynamicObject);
begin
   ObjectBoss := aBoss;
end;

function TAttackSkill.GetObjectBoss : TDynamicObject;
begin
   Result := ObjectBoss;
end;

procedure TAttackSkill.SetDeadAttackName (aName : String);
begin
   if TLifeObject (BAsicObject).LifeObjectState = los_die then exit;

   DeadAttackName := aName;
   if aName <> '' then begin
      TLifeObject (BasicObject).LifeObjectState := los_deadattack;
   end;
end;

procedure TAttackSkill.SetMasterName (aName : String);
begin
   MasterName := aName;
end;

procedure TAttackSkill.SetSaveIDandPos (aTargetID : Integer; aTargetX, aTargetY : Word; aNextState : TLifeObjectState);
begin
   TargetStartTick := mmAnsTick;
   
   SaveID := aTargetID;
   TargetX := aTargetX;
   TargetY := aTargetY;

   SaveNextState := aNextState;
end;

procedure TAttackSkill.SetTargetID (aTargetID : Integer; boCaller : Boolean);
var
   tmpAttackSkill : TAttackSkill;
   tmpTargetID : Integer;
   BO : TBasicObject;
begin
   if (TLifeObject (BasicObject).LifeObjectState = los_die)
      or (TLifeObject (BasicObject).LifeObjectState = los_init) then exit;

   if TLifeObject (BasicObject).LifeObjectState = los_deadattack then exit;

   if aTargetID = BasicObject.BasicData.id then exit;
   if (aTargetID = 0) and (TargetID <> 0) then begin
      tmpTargetID := TargetID;
      TargetId := aTargetID;
      if (Boss <> nil) and (boSelfTarget = true) then begin
         if Boss.BasicData.Feature.rrace = RACE_NPC then
            // tmpAttackSkill := TNpc(Boss).GetAttackSkill;
            tmpAttackSkill := nil
         else
            tmpAttackSkill := TMonster(Boss).GetAttackSkill;
         if tmpAttackSkill <> nil then begin
            tmpAttackSkill.CancelHelp (tmpTargetID);
         end;
      end;
   end;

   if aTargetID = 0 then begin
      if TargetID <> 0 then BasicObject.WorkOver;
      TargetId := aTargetID;
      TLifeObject (BasicObject).LifeObjectState := los_none;
      exit;
   end;

   BasicObject.SetManualMode;

   boSelfTarget := true;

   TargetIDTick := mmAnsTick;
   TargetId := aTargetID;
   TLifeObject (BasicObject).LifeObjectState := los_attack;
   if GroupSkill <> nil then begin
      BO := TLifeObject (BasicObject).GetViewObjectByID (TargetID);
      if BO <> nil then begin
         GroupSkill.MoveAttack (TargetID, BO.BasicData.X, BO.BasicData.Y);
      end;
   end else if Boss <> nil then begin
      if Boss.BasicData.Feature.rRace = RACE_NPC then
         tmpAttackSkill := TNpc(Boss).GetAttackSkill
      else
         tmpAttackSkill := TMonster(Boss).GetAttackSkill;

      if tmpAttackSkill <> nil then begin
         if tmpAttackSkill.GetTargetID <> TargetID then begin
            BO := TLifeObject (BasicObject).GetViewObjectByID (TargetID);
            if BO <> nil then begin
               if BO.BasicData.Feature.rFeatureState = wfs_die then begin
                  BO := nil;
                  exit;
               end;
               if tmpAttackSkill.GroupSkill <> nil then begin
                  tmpAttackSkill.HelpMe (BasicObject.BasicData.id, TargetID, BO.BasicData.x, BO.BasicData.y);
               end else begin
                  BO := nil;
               end;
            end;
         end;
      end;
   end else begin
   {
      if (boCaller = true) and (boVassal = true) then begin
         SubData.TargetId := TargetID;
         SubData.VassalCount := VassalCount;
         TLifeObject (BasicObject).SendLocalMessage (NOTARGETPHONE, FM_GATHERVASSAL, BasicObject.BasicData, SubData);
      end;
   }      
   end;
end;

procedure TAttackSkill.SetHelpTargetID (aTargetID : Integer);
var
   tmpAttackSkill : TAttackSkill;
begin
   if (TLifeObject (BasicObject).LifeObjectState = los_die)
      or (TLifeObject (BasicObject).LifeObjectState = los_init) then exit;

   if aTargetID = BasicObject.BasicData.id then exit;
   if aTargetID = 0 then begin
      if Boss <> nil then begin
         if Boss.BasicData.Feature.rrace = RACE_NPC then
            // tmpAttackSkill := TNpc(Boss).GetAttackSkill;
            tmpAttackSkill := nil
         else
            tmpAttackSkill := TMonster(Boss).GetAttackSkill;
         if tmpAttackSkill <> nil then begin
            if tmpAttackSkill.GetTargetID <> TargetID then begin
               tmpAttackSkill.CancelHelp (TargetID);
            end;
         end;
      end;
      TargetId := aTargetID;
      TLifeObject (BasicObject).LifeObjectState := los_none;
      exit;
   end;

   boSelfTarget := false;

   TargetId := aTargetID;
   TLifeObject (BasicObject).LifeObjectState := los_attack;
   if GroupSkill <> nil then begin
      GroupSkill.Attack (TargetID);
   end;
end;

procedure TAttackSkill.SetHelpTargetIDandPos (aTargetID, aX, aY : Integer);
begin
   if (TLifeObject (BasicObject).LifeObjectState = los_die)
      or (TLifeObject (BasicObject).LifeObjectState = los_init) then exit;

   if aTargetID = BasicObject.BasicData.id then exit;
   if (aTargetID = 0) or (aTargetID = TargetID) then exit;

   boSelfTarget := false;   
   TargetId := aTargetID;

   if aTargetID = 0 then begin
      TLifeObject (BasicObject).LifeObjectState := los_none;
      exit;
   end;
   TLifeObject (BasicObject).LifeObjectState := los_moveattack;
end;

procedure TAttackSkill.SetEscapeID (aEscapeID : Integer);
var
   i, xx, yy, mx, my, len: integer;
   bo : TBasicObject;
begin
   if aEscapeID = BasicObject.BasicData.id then exit;
   TargetId := aEscapeID;
   TLifeObject (BasicObject).LifeObjectState := los_escape;

   bo := TBasicObject (TLifeObject (BasicObject).GetViewObjectById (TargetId));
   if bo = nil then begin
      TLifeObject (BasicObject).LifeObjectState := los_none
   end else begin
      mx := BasicObject.BasicData.x;
      my := BasicObject.BasicData.y;
      len := 0;

      for i := 0 to 10-1 do begin
         xx := BasicObject.BasicData.X - 6 + Random (12);
         yy := BasicObject.BasicData.y - 6 + Random (12);

         if (len < GetLargeLength (bo.PosX, bo.PosY, xx, yy))
            and BasicObject.Maper.isMoveable (xx, yy) then  begin
            Len := GetLargeLength (bo.PosX, bo.PosY, xx, yy);
            mx := xx; my := yy;
         end;
      end;

      if (mx <> BasicObject.BasicData.x) or (my <> BasicObject.BasicData.y) then begin
         TargetX := mx;
         TargetY := my;
      end;
   end;
end;

procedure TAttackSkill.SetAttackMagic (aAttackMagic : TMagicData);
begin
   AttackMagic := aAttackMagic;

   if AttackMagic.rMagicType = MAGICTYPE_BOWING then begin
      BowCount := 5;
      BowAvailInterval := 500;
   end else begin
      BowCount := 5;
      BowAvailInterval := 300;
   end;
end;

procedure TAttackSkill.SetSelfTarget (boFlag : Boolean);
begin
   boSelfTarget := boFlag;
end;

procedure TAttackSkill.SetGroupSkill;
begin
   if GroupSkill = nil then begin
      boGroupSkill := true;
      GroupSkill := TGroupSkill.Create (BasicObject);
   end else begin
      boGroupSkill := true;
   end;
end;

procedure TAttackSkill.AddGroup (aBasicObject : TBasicObject);
begin
   if GroupSkill <> nil then begin
      GroupSkill.AddMember (aBasicObject);
   end;
end;
                                  
function TAttackSkill.ProcessNone (CurTick : Integer) : Integer;
var
   ret : Integer;
   SubData : TSubData;
begin
   Result := -1;

   ret := -1;
   if BasicObject.BasicData.Feature.rRace = RACE_NPC then begin
      if TargetPosTick + 3000 < CurTick then begin
         TargetPosTick := CurTick;
         if BasicObject.isAutoMode = false then begin
            if (BasicObject.isWorkOver = true) or (BasicObject.isWalking = false) then begin
               TargetX := BasicObject.CreateX - TLifeObject (BasicObject).ActionWidth div 2 + Random (TLifeObject (BasicObject).ActionWidth);
               TargetY := BasicObject.CreateY - TLifeObject (BasicObject).ActionWidth div 2 + Random (TLifeObject (BasicObject).ActionWidth);
            end;
         end;
         exit;
      end;

      if TLifeObject (BasicObject).WalkTick + 200 < CurTick then begin
         TLifeObject (BasicObject).WalkTick := CurTick;
         {
         nDis := GetLargeLength (BasicObject.BasicData.X, BasicObject.BasicData.Y, TargetX, TargetY);
         if nDis > 10 then
            TLifeObject (BasicObject).GotoXyStandAI (TargetX, TargetY)
         else
         }
         if TLifeObject (BasicObject).GetVirtueValue >= BOSSVIRTUEVALUE then begin
            ret := TLifeObject (BasicObject).GotoXyStandAI (TargetX, TargetY);
         end else begin
            ret := TLifeObject (BasicObject).GotoXyStand (TargetX, TargetY);
         end;
      end;
   end else begin
      if boAttack = false then begin
         CurNearViewHumanId := 0;
         HateHumanId := 0;
      end;

      try
         if boAutoAttack and (EscapeLife < TLifeObject (BasicObject).CurLife)
            and (CurNearViewHumanId <> 0) then begin
            SetTargetId (CurNearViewHumanId, true);
            CurNearViewHumanId := 0;
            exit;
         end;
      except
         BasicObject.boAllowDelete := true;
         frmMain.WriteLogInfo ('AttackProcessNone failed_1');
         frmMain.WriteDumpInfo (@BasicObject.BasicData, SizeOf (TBasicData));
         exit;
      end;

      try
         if (EscapeLife < TLifeObject (BasicObject).CurLife)
            and (HateHumanId <> 0) then begin
            SetTargetId (HateHumanId, true);
            HateHumanId := 0;
            exit;
         end;
      except
         BasicObject.boAllowDelete := true;
         frmMain.WriteLogInfo ('AttackProcessNone failed_2');
         frmMain.WriteDumpInfo (@BasicObject.BasicData, SizeOf (TBasicData));
         exit;
      end;
      try
         if (EscapeLife >= TLifeObject (BasicObject).CurLife)
            and (CurNearViewHumanId <> 0) then begin
            SetEscapeId (CurNearViewHumanId);
            CurNearViewHumanId := 0;
            exit;
         end;
      except
         BasicObject.boAllowDelete := true;
         frmMain.WriteLogInfo ('AttackProcessNone failed_3');
         frmMain.WriteDumpInfo (@BasicObject.BasicData, SizeOf (TBasicData));
         exit;
      end;

      try
         if (EscapeLife >= TLifeObject (BasicObject).CurLife)
            and (HateHumanId <> 0) then begin
            SetEscapeId (HateHumanId);
            HateHumanId := 0;
            exit;
         end;
      except
         BasicObject.boAllowDelete := true;
         frmMain.WriteLogInfo ('AttackProcessNone failed_4');
         frmMain.WriteDumpInfo (@BasicObject.BasicData, SizeOf (TBasicData));
         exit;
      end;

      try
         if TargetPosTick + 2000 < CurTick then begin
            TargetPosTick := CurTick;
            if Boss <> nil then begin
               TargetX := Boss.BasicData.x - TLifeObject (BasicObject).ActionWidth div 2 + Random (TLifeObject (BasicObject).ActionWidth);
               TargetY := Boss.BasicData.y - TLifeObject (BasicObject).ActionWidth div 2 + Random (TLifeObject (BasicObject).ActionWidth);
            end else begin
               TargetX := BasicObject.CreateX - TLifeObject (BasicObject).ActionWidth div 2 + Random (TLifeObject (BasicObject).ActionWidth);
               TargetY := BasicObject.CreateY - TLifeObject (BasicObject).ActionWidth div 2 + Random (TLifeObject (BasicObject).ActionWidth);
            end;
            if TLifeObject (BasicObject).SoundNormal.rWavNumber <> 0 then begin
               SetWordString (SubData.SayString, IntToStr (TLifeObject (BasicObject).SoundNormal.rWavNumber) + '.wav');
               TLifeObject (BasicObject).SendLocalMessage (NOTARGETPHONE, FM_SOUND, BasicObject.BasicData, SubData);
            end;
            exit;
         end;
      except
         BasicObject.boAllowDelete := true;
         frmMain.WriteLogInfo ('AttackProcessNone failed_5');
         frmMain.WriteDumpInfo (@BasicObject.BasicData, SizeOf (TBasicData));
         exit;
      end;

      if TLifeObject (BasicObject).WalkTick + TLifeObject (BasicObject).WalkSpeed * 2 < CurTick then begin
         TLifeObject (BasicObject).WalkTick := CurTick;
         {
         nDis := GetLargeLength (BasicObject.BasicData.X, BasicObject.BasicData.Y, TargetX, TargetY);
         if nDis > 10 then
            TLifeObject (BasicObject).GotoXyStandAI (TargetX, TargetY)
         else
         }
         if TLifeObject (BasicObject).GetVirtueValue >= BOSSVIRTUEVALUE then begin
            try
               ret := TLifeObject (BasicObject).GotoXyStandAI (TargetX, TargetY);
            except
               BasicObject.boAllowDelete := true;
               frmMain.WriteLogInfo ('AttackProcessNone failed_7');
               frmMain.WriteDumpInfo (@BasicObject.BasicData, SizeOf (TBasicData));
               exit;
            end;
         end else begin
            try
               ret := TLifeObject (BasicObject).GotoXyStand (TargetX, TargetY);
            except
               BasicObject.boAllowDelete := true;
               frmMain.WriteLogInfo ('AttackProcessNone failed_8');
               frmMain.WriteDumpInfo (@BasicObject.BasicData, SizeOf (TBasicData));
               exit;
            end;
         end;
      end;
   end;

   Result := ret;
end;

procedure TAttackSkill.ProcessEscape (CurTick : Integer);
begin
   if BasicObject.BasicData.Feature.rrace = RACE_NPC then begin
   end else begin
      if TargetPosTick + 2000 < CurTick then begin
         TargetPosTick := CurTick;
         TLifeObject (BasicObject).LifeObjectState := los_none;
         exit;
      end;

      // if TLifeObject (BasicObject).WalkTick + TLifeObject (BasicObject).WalkSpeed div 2 < CurTick then begin
      if TLifeObject (BasicObject).WalkTick + TLifeObject (BasicObject).WalkSpeed < CurTick then begin
         TLifeObject (BasicObject).WalkTick := CurTick;
         TLifeObject (BasicObject).GotoXyStand (TargetX, TargetY);
         if (BasicObject.BasicData.x = TargetX) and (BasicObject.BasicData.y = TargetY) then
            TLifeObject (BasicObject).LifeObjectState := los_none;
      end;
   end;
end;

procedure TAttackSkill.ProcessFollow (CurTick : Integer);
begin

end;

function TAttackSkill.ProcessAttack (CurTick : Integer; aBasicObject : TBasicObject) : Boolean;
var
   bo : TBasicObject;
   key : word;
   boFlag : Boolean;
   i, iCount, nDis : Integer;
   tx, ty : Word;
   xx, yy : Integer;
begin
   Result := true;

   boFlag := false;

   if AttackType = ATTACKTYPE_RANDOM then begin
      if CurTick >= TargetIDTick + 1000 then begin
         iCount := 0;
         for i := 0 to BasicObject.ViewObjectList.Count - 1 do begin
            bo := BasicObject.ViewObjectList [i];
            if bo = nil then break;
            if bo.BasicData.Feature.rRace <> RACE_HUMAN then begin
               iCount := i;
               break;
            end;
         end;
         bo := BasicObject.ViewObjectList [Random (iCount + 1)];
         if bo <> nil then begin
            if bo.BasicData.ID <> TargetID then begin
               if bo.BasicData.Feature.rrace = RACE_HUMAN then begin
                  if bo.BasicData.Feature.rfeaturestate <> wfs_die then begin
                     SetTargetID (bo.BasicData.ID, true);
                  end;
               end;
            end;
         end;
         TargetIDTick := CurTick;
      end;
   end;

   if TLifeObject(BasicObject).FboBattle = true then begin
      if CurTick > BattleTick + 500 then begin
         TNpc (BasicObject).CurBattleMagic := TNpc (BasicObject).SelectRandomBattleAttackMagic;
         TNpc (BasicObject).SetNpcAttrib;

         TLifeObject (BasicObject).CommandSayUseMagicStr (StrPas (@TNpc (BasicObject).CurBattleMagic.rViewName));
         BattleTick := CurTick;
      end;
   end;

   try
      bo := TBasicObject (TLifeObject(BasicObject).GetViewObjectById (TargetId));
   except
      bo := nil;
   end;
   if bo = nil then begin
      boFlag := true;
   end else if bo.BasicData.Feature.rRace = RACE_HUMAN then begin
      if TUser(bo).GetLifeObjectState = los_die then boFlag := true;
   end else begin
      if TLifeObject(bo).LifeObjectState = los_die then boFlag := true;
   end;

   if (boflag = false) and (bo <> nil) then begin
      if (bo.BasicData.Feature.rHideState = hs_0) or (bo.BasicData.Feature.rfeaturestate = wfs_shop) then begin
         if TLifeObject (BasicObject).HaveMagicClass.isHaveShowMagic = false then begin
            if TLifeObject (BasicObject).HaveMagicClass.RunHaveShowMagic = false then begin
               boFlag := true;
            end;
         end else begin
            if TUser (bo).SysopScope = 101 then boFlag := true; // Åõ½ÃÇÑ ¸ó½ºÅÍ¶óµµ ¿î¿µÀÚ¸é Áö³ªÄ¡°Ô   03-09-23 saset
         end;
      end;
   end;

   if boFlag = true then begin
      if TLifeObject (aBasicObject).FboCopy = false then begin
         if AttackType = ATTACKTYPE_RANDOM then begin
            for i := 0 to BasicObject.ViewObjectList.Count - 1 do begin
               bo := BasicObject.ViewObjectList [i];
               if bo = nil then break;
               if bo.BasicData.Feature.rRace <> RACE_HUMAN then break;
               if bo.BasicData.Feature.rfeaturestate <> wfs_die then begin
                  SetTargetID (bo.BasicData.ID, true);
                  exit;
               end;
            end;
         end;

         SetTargetID (0, true);
         Result := false;
      end;
      exit;
   end;

   if aBasicObject.BasicData.Feature.rRace = RACE_NPC then begin
      if GetLargeLength (aBasicObject.BasicData.X, aBasicObject.BasicData.Y, bo.PosX, bo.PosY) = 1 then begin
         key := GetNextDirection (aBasicObject.BasicData.X, aBasicObject.BasicData.Y, bo.PosX, bo.PosY);
         if key = DR_DONTMOVE then exit;   // À§ÂÊÀÌ 0 ÀÏ¶§ÀÇ °æ¿ìÀÎµ¥ À§ÂÊÀÌ 1ÀÓ..
         if key <> aBasicObject.BasicData.dir then begin
            TLifeObject(aBasicObject).CommandTurn (key);
         end;
         TLifeObject(aBasicObject).CommandHit (CurTick);
      end else begin
         if TLifeObject(aBasicObject).WalkTick + 50 < CurTick then begin
            TLifeObject(aBasicObject).Walktick := CurTick;
            if TLifeObject (aBasicObject).GetVirtueValue >= BOSSVIRTUEVALUE then begin
               TLifeObject (aBasicObject).GotoXyStandAI (bo.Posx, bo.Posy);
            end else begin
               TLifeObject(aBasicObject).GotoXyStand (bo.Posx, bo.Posy);
            end;
         end;
      end;
   end else begin
      if EscapeLife >= TLifeObject(aBasicObject).CurLife then begin
         SetEscapeID (TargetID);
         exit;
      end;

      nDis := GetLargeLength (aBasicObject.BasicData.X, aBasicObject.BasicData.Y, bo.PosX, bo.PosY);
      if ((AttackMagic.rMagicType = MAGICTYPE_ONLYBOWING) or (AttackMagic.rMagicType = MAGICTYPE_BOWING)) and (boBowAvail = true) then begin
         if (BowCount > 5) or ((nDis >= 3) and (nDis <= 5)) then begin
         // if (nDis >= 3) and (nDis <= 5) then begin
            key := GetNextDirection (aBasicObject.BasicData.X, aBasicObject.BasicData.Y, bo.PosX, bo.PosY);
            if key = DR_DONTMOVE then exit;   // À§ÂÊÀÌ 0 ÀÏ¶§ÀÇ °æ¿ìÀÎµ¥ À§ÂÊÀÌ 1ÀÓ..
            if key <> aBasicObject.BasicData.dir then begin
               TLifeObject (aBasicObject).CommandTurn (key);
               exit;
            end;

            if TLifeObject(aBasicObject).ShootMagic (AttackMagic, bo) = true then begin
               Dec (BowCount);
               if BowCount <= 0 then begin
                  boBowAvail := false;
                  Case AttackMagic.rMagicType of
                     MAGICTYPE_BOWING :
                        begin
                           BowCount := 5;
                           BowAvailTick := CurTick;
                        end;
                     MAGICTYPE_ONLYBOWING :
                        begin
                           BowCount := 5;
                           BowAvailTick := CurTick;
                        end;
                  end;
               end;
            end;
         end else if nDis < 3 then begin
            {
            key := GetViewDirection (aBasicObject.BasicData.X, aBasicObject.BasicData.Y, BO.PosX, BO.PosY);
            if key = DR_DONTMOVE then exit; // À§ÂÊÀÌ 0 ÀÏ¶§ÀÇ °æ¿ìÀÎµ¥ À§ÂÊÀÌ 1ÀÓ..
            if key <> aBasicObject.BasicData.dir then begin
               TLifeObject (aBasicObject).CommandTurn (key);
               exit;
            end;
            }
            if CurTick >= ReTargetTick + 1000 then begin
               boBowAvail := false;
               BowCount := 10;
            end else begin
               GetOppositeDirection (aBasicObject.BasicData.X, aBasicObject.BasicData.Y, bo.PosX, bo.PosY, tx, ty);
               if not aBasicObject.Maper.isMoveable (tx, ty) then begin
                  xx := tx; yy := ty;
                  aBasicObject.Maper.GetNearXy (xx, yy);
                  tx := xx; ty := yy;
               end;
               if TLifeObject (aBasicObject).GetVirtueValue >= BOSSVIRTUEVALUE then begin
                  TLifeObject (aBasicObject).GotoXyStandAI (tX, tY);
               end else begin
                  TLifeObject(aBasicObject).GotoXyStand (tx, ty);
               end;
            end;
         end else begin
            if CurTick >= ReTargetTick + 1000 then begin
               boBowAvail := false;
               BowCount := 10;
            end else begin
               if TLifeObject (aBasicObject).GetVirtueValue >= BOSSVIRTUEVALUE then begin
                  TLifeObject (aBasicObject).GotoXyStandAI (bo.PosX, bo.PosY);
               end else begin
                  TLifeObject(aBasicObject).GotoXyStand (bo.PosX, bo.PosY);
               end;
            end;
         end;
      end else begin
         if AttackMagic.rMagicType <> MAGICTYPE_ONLYBOWING then begin
            if nDis = 1 then begin
               key := GetNextDirection (aBasicObject.BasicData.X, aBasicObject.BasicData.Y, bo.PosX, bo.PosY);
               if key = DR_DONTMOVE then exit;   // À§ÂÊÀÌ 0 ÀÏ¶§ÀÇ °æ¿ìÀÎµ¥ À§ÂÊÀÌ 1ÀÓ..
               if key <> aBasicObject.BasicData.dir then begin
                  TLifeObject (aBasicObject).CommandTurn (key);
               end else begin
                  TLifeObject (aBasicObject).CommandHit (CurTick);
               end;
            end else begin
               if TLifeObject(aBasicObject).WalkTick + TLifeObject(aBasicObject).WalkSpeed < CurTick then begin
                  TLifeObject(aBasicObject).WalkTick := CurTick;
                  if TLifeObject (aBasicObject).GetVirtueValue >= BOSSVIRTUEVALUE then begin
                     TLifeObject (aBasicObject).GotoXyStandAI (bo.Posx, bo.Posy);
                  end else begin
                     TLifeObject(aBasicObject).GotoXyStand (bo.Posx, bo.Posy);
                  end;
               end;
            end;
         end;
         if BowAvailTick + BowAvailInterval < CurTick then begin
            boBowAvail := true;
            ReTargetTick := CurTick;
         end;
      end;
   end;
end;

procedure TAttackSkill.ProcessMoveAttack (Curtick : Integer);
var
   BO : TBasicObject;
begin
   bo := TBasicObject (TLifeObject(BasicObject).GetViewObjectById (TargetId));
   if bo <> nil then begin
      TLifeObject(BasicObject).LifeObjectState := los_attack;
      exit;
   end;
   if BasicObject.BasicData.Feature.rRace = RACE_NPC then begin
      if TLifeObject (BasicObject).WalkTick + 200 < CurTick then begin
         TLifeObject (BasicObject).WalkTick := CurTick;
         TLifeObject (BasicObject).GotoXyStand (TargetX, TargetY);
      end;
   end else begin
      if TLifeObject (BasicObject).WalkTick + TLifeObject (BasicObject).WalkSpeed * 2 < CurTick then begin
         TLifeObject (BasicObject).WalkTick := CurTick;
         TLifeObject (BasicObject).GotoXyStand (TargetX, TargetY);
      end;
   end;
end;

procedure TAttackSkill.ProcessDeadAttack (CurTick : Integer);
var
   pUser : TUser;
   key : word;
   boFlag : Boolean;
   nDis : Integer;
   tx, ty : Word;
   xx, yy : Integer;
begin
   boFlag := false;

   pUser := UserList.GetUserPointer (DeadAttackName);
   if pUser = nil then begin
      boFlag := true;
   end else begin
      if pUser.GetLifeObjectState = los_die then boFlag := true;
      if pUser.ServerID <> BasicObject.ServerID then boFlag := true;
   end;

   if boFlag = true then begin
      DeadAttackName := '';
      // TLifeObject (BasicObject).LifeObjectState := los_none;
      if boObserver = false then begin
         TLifeObject (BasicObject).FboAllowDelete := true;
      end else begin
         TLifeObject (BasicObject).LifeObjectState := los_none;
         SetTargetID (0, true);
      end;
      exit;
   end;

   if GetLargeLength (BasicObject.BasicData.X, BasicObject.BasicData.Y, pUser.PosX, pUser.PosY) = 1 then begin
      key := GetNextDirection (BasicObject.BasicData.X, BasicObject.BasicData.Y, pUser.PosX, pUser.PosY);
      if key = DR_DONTMOVE then exit;
      if key <> BasicObject.BasicData.dir then begin
         TLifeObject(BasicObject).CommandTurn (key);
      end;
      TLifeObject(BasicObject).CommandHit (CurTick);
   end else begin
      nDis := GetLargeLength (BasicObject.BasicData.X, BasicObject.BasicData.Y, pUser.PosX, pUser.PosY);
      if ((AttackMagic.rMagicType = MAGICTYPE_ONLYBOWING) or (AttackMagic.rMagicType = MAGICTYPE_BOWING)) and (boBowAvail = true) then begin
         if (BowCount < 3) or ((nDis >= 3) and (nDis <= 5)) then begin
         // if (nDis >= 3) and (nDis <= 5) then begin
            key := GetNextDirection (BasicObject.BasicData.X, BasicObject.BasicData.Y, pUser.PosX, pUser.PosY);
            if key = DR_DONTMOVE then exit;   // À§ÂÊÀÌ 0 ÀÏ¶§ÀÇ °æ¿ìÀÎµ¥ À§ÂÊÀÌ 1ÀÓ..
            if key <> BasicObject.BasicData.dir then begin
               TLifeObject (BasicObject).CommandTurn (key);
               exit;
            end;

            if TLifeObject(BasicObject).ShootMagic (AttackMagic, pUser) = true then begin
               Dec (BowCount);
               if BowCount <= 0 then begin
                  boBowAvail := false;
                  Case AttackMagic.rMagicType of
                     MAGICTYPE_BOWING :
                        begin
                           BowCount := 5;
                           BowAvailTick := CurTick;
                        end;
                     MAGICTYPE_ONLYBOWING :
                        begin
                           BowCount := 5;
                           BowAvailTick := CurTick;
                        end;
                  end;
               end;
            end;
         end else if nDis < 3 then begin
            {
            key := GetViewDirection (aBasicObject.BasicData.X, aBasicObject.BasicData.Y, BO.PosX, BO.PosY);
            if key = DR_DONTMOVE then exit; // À§ÂÊÀÌ 0 ÀÏ¶§ÀÇ °æ¿ìÀÎµ¥ À§ÂÊÀÌ 1ÀÓ..
            if key <> aBasicObject.BasicData.dir then begin
               TLifeObject (aBasicObject).CommandTurn (key);
               exit;
            end;
            }
            GetOppositeDirection (BasicObject.BasicData.X, BasicObject.BasicData.Y, pUser.PosX, pUser.PosY, tx, ty);
            if not BasicObject.Maper.isMoveable (tx, ty) then begin
               xx := tx; yy := ty;
               BasicObject.Maper.GetNearXy (xx, yy);
               tx := xx; ty := yy;
            end;
            if TLifeObject (BasicObject).GetVirtueValue >= BOSSVIRTUEVALUE then begin
               TLifeObject (BasicObject).GotoXyStandAI (tX, tY);
            end else begin
               TLifeObject(BasicObject).GotoXyStand (tx, ty);
            end;
         end else begin
            if TLifeObject (BasicObject).GetVirtueValue >= BOSSVIRTUEVALUE then begin
               TLifeObject (BasicObject).GotoXyStandAI (pUser.PosX, pUser.PosY);
            end else begin
               TLifeObject(BasicObject).GotoXyStand (pUser.PosX, pUser.PosY);
            end;
         end;
      end else begin
         if AttackMagic.rMagicType <> MAGICTYPE_ONLYBOWING then begin
            if nDis = 1 then begin
               key := GetNextDirection (BasicObject.BasicData.X, BasicObject.BasicData.Y, pUser.PosX, pUser.PosY);
               if key = DR_DONTMOVE then exit;   // À§ÂÊÀÌ 0 ÀÏ¶§ÀÇ °æ¿ìÀÎµ¥ À§ÂÊÀÌ 1ÀÓ..
               if key <> BasicObject.BasicData.dir then begin
                  TLifeObject (BasicObject).CommandTurn (key);
               end else begin
                  TLifeObject (BasicObject).CommandHit (CurTick);
               end;
            end else begin
               if TLifeObject(BasicObject).WalkTick + TLifeObject(BasicObject).WalkSpeed < CurTick then begin
                  TLifeObject(BasicObject).WalkTick := CurTick;
                  if TLifeObject (BasicObject).GetVirtueValue >= BOSSVIRTUEVALUE then begin
                     TLifeObject (BasicObject).GotoXyStandAI (pUser.Posx, pUser.Posy);
                  end else begin
                     TLifeObject(BasicObject).GotoXyStand (pUser.Posx, pUser.Posy);
                  end;
               end;
            end;
         end;
         if BowAvailTick + BowAvailInterval < CurTick then begin
            boBowAvail := true;
         end;
      end;
   end;
end;

procedure TAttackSkill.ProcessMoveWork (CurTick : Integer);
var
   iLen : Integer;
begin
   // Á¤È®È÷ ¸ñÀûÁö¿¡ µµÂø
   if (BasicObject.BasicData.X = TargetX) and (BasicObject.BasicData.Y = TargetY) then begin
      TargetArrivalTick := CurTick;
      TLifeObject (BasicObject).LifeObjectState := SaveNextState;
      exit;
   end;
   // ÇÑ¼¿ ¹üÀ§ ÀÌ³»·Î µµÂø
   iLen := GetLargeLength (BasicObject.BasicData.X, BasicObject.BasicData.Y, TargetX, TargetY);
   if iLen <= 1 then begin
      TargetArrivalTick := CurTick;
      TLifeObject (BasicObject).LifeObjectState := SaveNextState;
      exit;
   end;
   
   if CurTick >= TargetStartTick + 1500 then begin
      TargetArrivalTick := CurTick;
      if TargetID <> 0 then TLifeObject (BasicObject).LifeObjectState := los_attack
      else TLifeObject (BasicObject).LifeObjectState := los_none;
      exit;
   end;
   if BasicObject.BasicData.Feature.rRace = RACE_NPC then begin
      if TLifeObject (BasicObject).WalkTick + 200 < CurTick then begin
         TLifeObject (BasicObject).WalkTick := CurTick;
         TLifeObject (BasicObject).GotoXyStand (TargetX, TargetY);
      end;
   end else begin
      if TLifeObject (BasicObject).WalkTick + TLifeObject (BasicObject).WalkSpeed < CurTick then begin
         TLifeObject (BasicObject).WalkTick := CurTick;
         TLifeObject (BasicObject).GotoXyStand (TargetX, TargetY);
      end;
   end;
end;

function TAttackSkill.ProcessMove (CurTick : Integer) : Boolean;
begin
   Result := false;

   if (BasicObject.BasicData.X = TargetX) and (BasicObject.BasicData.Y = TargetY) then begin
      TargetArrivalTick := CurTick;
      Result := true;
      exit;
   end;
   if BasicObject.BasicData.Feature.rRace = RACE_NPC then begin
      if TLifeObject (BasicObject).WalkTick + 200 < CurTick then begin
         TLifeObject (BasicObject).WalkTick := CurTick;
         TLifeObject (BasicObject).GotoXyStand (TargetX, TargetY);
      end;
   end else begin
      if TLifeObject (BasicObject).WalkTick + TLifeObject (BasicObject).WalkSpeed < CurTick then begin
         TLifeObject (BasicObject).WalkTick := CurTick;
         TLifeObject (BasicObject).GotoXyStand (TargetX, TargetY);
      end;
   end;
end;

function TAttackSkill.ProcessControl (CurTick : Integer; aXControl, aYControl : Integer) : Boolean;
var
   xx, yy, key : Word;
   Monster : TMonster;
begin
   Result := false;

   if (TargetX = BasicObject.BasicData.X) and (TargetY = BasicObject.BasicData.Y) then begin
      TargetX := BasicObject.BasicData.X + aXControl;
      TargetY := BasicObject.BasicData.Y + aYControl;

      while (aXControl <> 0) or (aYControl <> 0) do begin
         if BasicObject.Maper.isMoveTile (TargetX, TargetY) = false then begin
            Dec (TargetX, aXControl);
            Dec (TargetY, aYControl);
            break;
         end;
         Inc (TargetX, aXControl);
         Inc (TargetY, aYControl);
      end;
   end;

   if (BasicObject.BasicData.X = TargetX) and (BasicObject.BasicData.Y = TargetY) then begin
      Result := true;
      exit;
   end;

   if BasicObject.BasicData.Feature.rRace = RACE_MONSTER then begin
      key := GetNextDirection (BasicObject.BasicData.X, BasicObject.BasicData.Y, TargetX, TargetY);
      if key = DR_DONTMOVE then exit;
      if key <> BasicObject.BasicData.dir then begin
         TLifeObject (BasicObject).CommandTurn (key);
         exit;
      end;

      Monster := TMonster (BasicObject);

      xx := BasicObject.BasicData.X;
      yy := BasicObject.BasicData.Y;
      GetNextPosition (key, xx, yy);
      Monster.KillSomeone (xx, yy);

      xx := BasicObject.BasicData.X - 1;
      yy := BasicObject.BasicData.Y;
      GetNextPosition (key, xx, yy);
      Monster.KillSomeone (xx, yy);

      xx := BasicObject.BasicData.X + 1;
      yy := BasicObject.BasicData.Y + 1;
      GetNextPosition (key, xx, yy);
      Monster.KillSomeone (xx, yy);

      xx := BasicObject.BasicData.X - 1;
      yy := BasicObject.BasicData.Y + 1;
      GetNextPosition (key, xx, yy);
      Monster.KillSomeone (xx, yy);

      xx := BasicObject.BasicData.X + 1;
      yy := BasicObject.BasicData.Y - 1;
      GetNextPosition (key, xx, yy);
      Monster.KillSomeone (xx, yy);

      xx := BasicObject.BasicData.X;
      yy := BasicObject.BasicData.Y + 1;
      GetNextPosition (key, xx, yy);
      Monster.KillSomeone (xx, yy);

      xx := BasicObject.BasicData.X + 1;
      yy := BasicObject.BasicData.Y;
      GetNextPosition (key, xx, yy);
      Monster.KillSomeone (xx, yy);

      if TLifeObject (BasicObject).WalkTick + TLifeObject (BasicObject).WalkSpeed < CurTick then begin
         TLifeObject (BasicObject).WalkTick := CurTick;
         TLifeObject (BasicObject).GotoXyStand (TargetX, TargetY);
      end;
   end;
end;

procedure TAttackSkill.NoticeDie;
var
   tmpAttackSkill : TAttackSkill;
begin
   if Boss <> nil then begin
      if Boss.BasicData.Feature.rRace = RACE_NPC then
         tmpAttackSkill := TNpc(Boss).GetAttackSkill
      else
         tmpAttackSkill := TMonster(Boss).GetAttackSkill;

      if tmpAttackSkill <> nil then begin
         tmpAttackSkill.MemberDie (BasicObject);
      end;
   end;
end;

procedure TAttackSkill.MemberDie (aBasicObject : TBasicObject);
begin
   if GroupSkill <> nil then begin
      GroupSkill.DeleteMember (aBasicObject);
   end;
end;

/////////////////////////////////////////////////
//                TGroupSkill;
/////////////////////////////////////////////////

constructor TGroupSkill.Create (aBasicObject : TBasicObject);
begin
   BasicObject := aBasicObject;
   MemberList := TList.Create;
end;

destructor TGroupSkill.Destroy;
begin
   if MemberList <> nil then MemberList.Free;
   inherited Destroy;
end;

procedure TGroupSkill.AddMember (aBasicObject : TBasicObject);
begin
   MemberList.Add (aBasicObject);
end;

procedure TGroupSkill.DeleteMember (aBasicObject : TBasicObject);
var
   i : Integer;
begin
   if aBasicObject = nil then exit;
   for i := 0 to MemberList.Count - 1 do begin
      if aBasicObject = MemberList[i] then begin
         MemberList.Delete (i);
         exit;
      end;
   end;
end;

procedure TGroupSkill.ChangeBoss (aBasicObject : TBasicObject);
var
   i : Integer;
   BO : TBasicObject;
   AttackSkill : TAttackSkill;
begin
   for i := 0 to MemberList.Count - 1 do begin
      BO := MemberList.Items [i];
      if BO <> nil then begin
         if BO.BasicData.Feature.rRace = RACE_MONSTER then begin
            AttackSkill := TMonster (BO).GetAttackSkill;
         end else if BO.BasicData.Feature.rRace = RACE_NPC then begin
            AttackSkill := TNpc (BO).GetAttackSkill;
         end else begin
            AttackSkill := nil;
         end;
         if AttackSkill <> nil then begin
            AttackSkill.SetBoss (aBasicObject);
         end;
      end;
   end;
end;

procedure TGroupSkill.BossDie;
var
   i : Integer;
   BO : TBasicObject;
   AttackSkill : TAttackSkill;
begin
   for i := 0 to MemberList.Count - 1 do begin
      BO := MemberList.Items [i];
      if BO <> nil then begin
         if BO.BasicData.Feature.rRace = RACE_MONSTER then
            AttackSkill := TMonster (BO).GetAttackSkill
         else
            AttackSkill := TNpc (BO).GetAttackSkill;

         if AttackSkill <> nil then begin
            AttackSkill.SetBoss (nil);
         end;
      end;
   end;
end;

procedure TGroupSkill.FollowMe;
var
   i : Integer;
   BO : TBasicObject;
   AttackSkill : TAttackSkill;
begin
   for i := 0 to MemberList.Count - 1 do begin
      BO := MemberList.Items [i];
      if BO <> nil then begin
         if BO.BasicData.Feature.rRace = RACE_MONSTER then
            AttackSkill := TMonster (BO).GetAttackSkill
         else
            AttackSkill := TNpc (BO).GetAttackSkill;

         if AttackSkill <> nil then begin
            AttackSkill.TargetX := BasicObject.BasicData.x;
            AttackSkill.TargetY := BasicObject.BasicData.y;
         end;
      end;
   end;
end;

procedure TGroupSkill.FollowEachOther;
begin

end;

procedure TGroupSkill.Attack (aTargetID : Integer);
var
   i : Integer;
   BO : TBasicObject;
   AttackSkill : TAttackSkill;
begin
   for i := 0 to MemberList.Count - 1 do begin
      BO := MemberList.Items [i];
      if BO <> nil then begin
         if BO.BasicData.Feature.rRace = RACE_MONSTER then
            AttackSkill := TMonster (BO).GetAttackSkill
         else
            AttackSkill := TNpc (BO).GetAttackSkill;

         if AttackSkill <> nil then begin
            AttackSkill.SetHelpTargetID (aTargetID);
         end;
      end;
   end;
end;

procedure TGroupSkill.MoveAttack (aTargetID, aX, aY : Integer);
var
   i : Integer;
   BO : TBasicObject;
   AttackSkill : TAttackSkill;
begin
   for i := 0 to MemberList.Count - 1 do begin
      BO := MemberList.Items [i];
      if BO <> nil then begin
         if BO.BasicData.Feature.rRace = RACE_MONSTER then
            AttackSkill := TMonster (BO).GetAttackSkill
         else
            AttackSkill := TNpc (BO).GetAttackSkill;

         if AttackSkill <> nil then begin
            AttackSkill.SetHelpTargetIDandPos (aTargetID, aX, aY);
         end;
      end;
   end;
end;

procedure TGroupSkill.CancelTarget (aTargetID : Integer);
var
   i : Integer;
   BO : TBasicObject;
   AttackSkill : TAttackSkill;
begin
   for i := 0 to MemberList.Count - 1 do begin
      BO := MemberList.Items [i];
      if BO <> nil then begin
         if BO.BasicData.Feature.rRace = RACE_MONSTER then begin
            AttackSkill := TMonster (BO).GetAttackSkill;
         end else if BO.BasicData.Feature.rRace = RACE_NPC then begin
            AttackSkill := TNpc (BO).GetAttackSkill;
         end else begin
            AttackSkill := nil;
         end;

         if AttackSkill <> nil then begin
            if AttackSkill.TargetID = aTargetID then begin
               AttackSkill.SetTargetID (0, true);
            end;
         end;
      end;
   end;
end;

/////////////////////////////////////////////////
//                TSaleSkill;
/////////////////////////////////////////////////

constructor TSaleSkill.Create (aBasicObject : TBasicObject);
begin
   BasicObject := aBasicObject;

   SaleTitle := StrPas (@BasicObject.BasicData.ViewName);
   SaleCaption := '';
   SaleImage := 0;

   SaleItemList := TList.Create;
end;

destructor TSaleSkill.Destroy;
begin
   Clear;
   SaleItemList.Free;

   inherited Destroy;
end;

procedure TSaleSkill.Clear;
var
   i : Integer;
   pItemData : PTItemData;
begin
   if SaleItemList <> nil then begin
      for i := 0 to SaleItemList.Count - 1 do begin
         pItemData := SaleItemList.Items [i];
         if pItemData <> nil then DisPose (pItemData);
      end;
      SaleItemList.Clear;
   end;
end;

function TSaleSkill.LoadFromFile (aFileName : String) : Boolean;
var
   StrList : TStringList;
   i : Integer;
   Str, KindStr, ItemName : String;
   ItemData : TItemData;
   pSaleData : PTSaleData;
begin
   Result := false;

   if not FileExists (aFileName) then exit;
   Clear;

   StrList := TStringList.Create;
   StrList.LoadFromFile (aFileName);

   for i := 0 to StrList.Count - 1 do begin
      Str := StrList.Strings [i];
      if Str <> '' then begin
         Str := GetValidStr3 (Str, KindStr, ':');
         Str := GetValidStr3 (Str, ItemName, ':');

         if KindStr <> '' then begin
            if UpperCase (KindStr) = 'SALEITEM' then begin
               ItemClass.GetItemData(ItemName, ItemData);
               if ItemData.rName [0] <> 0 then begin
                  New (pSaleData);
                  Move (ItemData, pSaleData^.rItem, SizeOF (TItemData));
                  pSaleData^.rCount := 0;
                  SaleItemList.Add (pSaleData); 
               end; 
            end else if UpperCase (KindStr) = 'SALETITLE' then begin
               SaleTitle := ItemName;
            end else if UpperCase (KindStr) = 'SALECAPTION' then begin
               SaleCaption := ItemName;
            end else if UpperCase (KindStr) = 'SALEIMAGE' then begin
               SaleImage := _StrToInt (ItemName);
            end;
         end; 
      end;
   end;

   StrList.Free;
   Result := true;
end;

function TSaleSkill.GetSellItemString : String;
var
   i : Integer;
   Str : String;
   pSaleData : PTSaleData;
begin
   Result := '';

   Str := '';
   for i := 0 to SaleItemList.Count - 1 do begin
      pSaleData := SaleItemList.Items [i];
      if pSaleData <> nil then begin
         if pSaledata^.rCount > 0 then begin
            if Str <> '' then Str := Str + ',';
            Str := Str + StrPas (@pSaleData^.rItem.rName) + ':' + IntToStr (pSaleData^.rCount);
         end;
      end;
   end;

   Result := Str;
end;

function TSaleSkill.GetBuyItemString : String;
var
   i : Integer;
   Str : String;
   pSaleData : PTSaleData;
begin
   Result := '';

   Str := '';
   for i := 0 to SaleItemList.Count - 1 do begin
      pSaleData := SaleItemList.Items [i];
      if pSaleData <> nil then begin
         if Str <> '' then Str := Str + ',';
         Str := Str + StrPas (@pSaleData^.rItem.rName);
      end;
   end;

   Result := Str;
end;

procedure TSaleSkill.AddItembyName (aName : String; aCount : Integer);
var
   i : Integer;
   pSaleData : PTSaleData;
begin
   for i := 0 to SaleItemList.Count - 1 do begin
      pSaleData := SaleItemList.Items [i];
      if StrPas (@pSaleData^.rItem.rName) = aName then begin
         pSaleData^.rCount := pSaleData^.rCount + aCount;
         exit;
      end;
   end;
end;

function TSaleSkill.CheckItembyName (aName : String; aCount : Integer) : Boolean;
var
   i : Integer;
   pSaleData : PTSaleData;
begin
   Result := false;
   for i := 0 to SaleItemList.Count - 1 do begin
      pSaleData := SaleItemList.Items [i];
      if StrPas (@pSaleData^.rItem.rName) = aName then begin
         Result := (pSaleData^.rCount >= aCount) and (pSaleData^.rCount > 0);
         exit;
      end;
   end;
end;

function TSaleSkill.DelItembyName (aName : String; aCount : Integer) : Boolean;
var
   i : Integer;
   pSaleData : PTSaleData;
begin
   Result := false;

   for i := 0 to SaleItemList.Count - 1 do begin
      pSaleData := SaleItemList.Items [i];
      if StrPas (@pSaleData^.rItem.rName) = aName then begin
         if (pSaleData^.rCount < aCount) or (pSaleData^.rCount <= 0) then exit;
         pSaleData^.rCount := pSaleData^.rCount - aCount;
         Result := true;
         exit;
      end; 
   end;
end;

end.

