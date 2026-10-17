unit uUserSub;

interface

uses
  Windows, SysUtils, Classes, Usersdb, Deftype, AnsUnit, Math,
  AnsImg2, AUtil32, uSendCls, uAnstick, uLevelexp, svClass, AnsStringCls,
  uDBRecordDef, BasicObj, uItemLog, uKeyClass, uScriptManager ,uCookie;

const
   DRUGARR_SIZE = 3;
   RISEMAGIC_ADDDAMAGE = 200;

   KIND_SELL      = 0;
   KIND_BUY       = 1;
   KIND_SALESELL  = 3;
   KIND_SALEBUY   = 4;

   PRODUCT_KEY    = 4;

   TRADELISTMAX   = 40;
   SALELISTMAX    = 40;

   HAVEITEM_UPDATE_DELAY = 500;
   MARKET_GOLD_KEY = 0;        // 捣焊包窃??
   REGENERATE_SHIELD_DELAY = 3000;
   //ENERGY_REGEN_DELAY = 2000; //苞芭
   ENERGY_REGEN_DELAY = 1800; //菩摹瞪郴侩
   RUNNING_EFFECT_NUM = 5000; //2003-02-19
   UPGRADE_EFFECT_NUM = 4000;
   UPGRADE_EFFECT_SOUND_NUM = 10013;

   MAXEXTRA_EXP = 500000;    //MAXEXTRA_EXP = 5000000;
   LEVELEXTRA_EXP = 50000;   //LEVELEXTRA_EXP = 500000;
   MAXADDABLEPOINT = 10000;
   STUN_EFFECT_NUM = 5500;

   CEFFECT_START_DELAY = 50;   
   
type
   // 背券芒, 沤祸芒, 荐樊芒, 巩颇公傍脚没, 悼竿夸没, 焊包芒
   TSpecialWindowKind = ( swk_none, swk_exchange, swk_search, swk_count,
                          swk_guildmagic, swk_bloodguild, swk_itemlog,
                          swk_alert, swk_help, swk_trade, swk_sale,
                          swk_market, swk_individualmarket,
                          swk_marry , swk_marryanswer,swk_arena,swk_guildanswer,
                          swk_inputguildname, swk_guildinfo ,swk_guildsubsysop);
   TSpecialSubType =    ( sst_none, sst_message, sst_info, sst_gameagree,
                          sst_allyguild, sst_sell, sst_buy, sst_salesell,
                          sst_salebuy );

   TAttribClass = class;
   THaveItemClass = class;
   THaveMagicClass = class;
   TWearItemClass = class;
   THaveJobClass = class;
   THaveMarketClass = class;
   TShowWindowClass = class;
   TUserQuestClass = class;
   
   TAttribClass = class
   private
     FBasicObject : TBasicObject;

     boAddExp : Boolean;
     boMan : Boolean;

     boSendValues : Boolean;
     boSendBase : Boolean;
     boSendExtraValues : Boolean; //2003-10     

     boRevivalFlag : Boolean;
     // boEnergyFlag : Boolean;
     boInPowerFlag : Boolean;
     boOutPowerFlag : Boolean;
     boMagicFlag : Boolean;

     FFeatureState : TFeatureState;

     StartTick                : integer;
     CheckIncreaseEnergyTick  : integer;     // 20檬俊 茄锅
     CheckIncreaseTick        : integer;     // 9 檬俊 茄锅
     CheckDrugTick            : integer;     // 1 檬俊 茄锅

     FSendClass : TSendClass;

     ItemDrugArr : array [0..DRUGARR_SIZE-1] of TItemDrugData;
     CurAttribData : TCurAttribData;
     AttribData : TAttribData;
     DrugAttribData : TAttribData;
     HaveItemAttribData : TAttribData;   //2002-08-02 giltae

     AttribLifeData : TLifeData;
     DrugAttribLifeData : TLifeData;

     boIsOverMaxEnergy : Boolean;
     boDrugAttrib : Boolean;
     DrugUseTick : Integer;
     DrugInterval : Integer;

     function  GetAge : Integer;
     function  GetLover :String;
     function  GetVirtue : Integer;
     function  GetAdaptive : Integer;
     function  GetTalent : Integer;
     function  GetLight : Integer;
     function  GetDark : Integer;

     function  GetGoodChar : Integer;
     function  GetBadChar : Integer;
     function  GetLucky : Integer;
     function  GetRevival : Integer;
     function  GetImmunity : Integer;
     function  GetHealth : Integer;
     function  GetSatiety : Integer;
     function  GetPoisoning : Integer;
     function  GetCurHealth: integer;
     function  GetCurSatiety: integer;
     function  GetCurPoisoning: integer;
     procedure SetCurHealth (value: integer);
     procedure SetCurSatiety (value: integer);
     procedure SetCurPoisoning (value: integer);

     procedure SetEnergyValue (aValue : Integer);

     function  GetCurEnergy : Integer;
     procedure SetCurEnergy (value: Integer);
     function  GetMaxEnergy : Integer;
     function  GetCurInPower: integer;
     procedure SetCurInPower (value: integer);
     function  GetMaxInPower: integer;
     function  GetCurOutPower: integer;
     procedure SetCurOutPower (value: integer);
     function  GetMaxOutPower: integer;
     function  GetCurMagic: integer;
     procedure SetCurMagic (value: integer);
     function  GetMaxMagic: integer;
     function  GetCurLife: integer;
     procedure SetCurLife (value: integer);
     function  GetMaxLife: integer;
     function  GetCurHeadLife: integer;
     procedure SetCurHeadLife (value: integer);
     function  GetMaxHeadLife: integer;
     function  GetCurArmLife: integer;
     procedure SetCurArmLife (value: integer);
     function  GetMaxArmLife: integer;
     function  GetCurLegLife: integer;
     procedure SetCurLegLife (value: integer);
     function  GetMaxLegLife: integer;
     procedure SetExtraExp (value : integer);
     function  GetExtraExp: Integer;
     procedure SetAddableStatePoint (value : integer);
     function  GetAddableStatePoint: integer;
     procedure SetTotalStatePoint (value : integer);
     function  GetTotalStatePoint: integer;

     function  CheckRevival: Boolean;
     function  CheckInPower: Boolean;
     function  CheckOutPower: Boolean;
     function  CheckMagic: Boolean;

     procedure SetLifeData;
     //Author:Steven Date: 2005-02-02 13:05:07
     //Note:采集技能
     function GetExtJobLevel: Integer;
     procedure SetExtJobExp(AValue: Integer);
     function GetExtJobExp: Integer;
     function GetExtJobKind: Byte;
     procedure SetExtJobKind(AValue: Byte);
     //=====================================
   public
     // add by Orber at 2004-12-22 14:34:20

     HaveItemLifeData : TLifeData;       // 2003-03-11 saset

     ReQuestPlaySoundNumber : integer;
     CheckAccelDecreaseTick   : integer;
     constructor Create (aBasicObject : TBasicObject; aSendClass: TSendClass);
     destructor Destroy; override;

     procedure Update (CurTick : integer);
     function  AddItemDrug (aDrugName: string): Boolean;

     procedure LoadFromSdb (aCharData : PTDBRecord);
     procedure SaveToSdb (aCharData : PTDBRecord);
     procedure Calculate;

     procedure AddAdaptive (aexp: integer);
     procedure AddTalent (aExp : Integer);
     procedure AddVirtue (aExp : Integer);
     procedure DecVirtue (aExp : Integer);
     procedure AddExtraExp (aExp : Integer); //2003-10

     procedure GetLifeData (var aLifeData : TLifeData);
     procedure GetAttribData (var aAttribData : TAttribData);
     procedure SetHaveItemAttribData(var aAttribData : TAttribData);
     procedure SetDrugEffect (var aLifeData : TLifeData);


     property  Age : Integer read GetAge;
     property  Lover : String read GetLover;
     property  Virtue : Integer read GetVirtue;
     property  Adaptive : Integer read GetAdaptive;
     property  Talent : Integer read GetTalent;
     property  Light : Integer read GetLight;
     property  Dark : Integer read GetDark;
     property  GoodChar : Integer read GetGoodChar;
     property  BadChar : Integer read GetBadChar;
     property  Lucky : Integer read GetLucky;
     property  Revival : Integer read GetRevival;
     property  Immunity : Integer read GetImmunity;
     property  Health : Integer read GetHealth;
     property  Satiety : Integer read GetSatiety;
     property  Poisoning : Integer read GetPoisoning;

     property  Energy : Integer read GetMaxEnergy;
     property  InPower : Integer read GetMaxInPower;
     property  OutPower : Integer read GetMaxOutPower;
     property  Magic : Integer read GetMaxMagic;
     property  Life : Integer read GetMaxLife;
     property  HeadLife : Integer read GetMaxHeadLife;
     property  ArmLife : Integer read GetMaxArmLife;
     property  LegLife : Integer read GetMaxLegLife;

     property  CurHealth : Integer read GetCurHealth write SetCurHealth;
     property  CurSatiety : Integer read GetCurSatiety write SetCurSatiety;
     property  CurPoisoning : Integer read GetCurPoisoning write SetCurPoisoning;

     property  CurEnergy : Integer read GetCurEnergy write SetCurEnergy;
     property  CurInPower : Integer read GetCurInPower write SetCurInPower;
     property  CurOutPower : Integer read GetCurOutPower write SetCurOutPower;
     property  CurMagic : Integer read GetCurMagic write SetCurMagic;
     property  CurLife : Integer read GetCurLife write SetCurLife;
     property  CurHeadLife : Integer read GetCurHeadLife write SetCurHeadLife;
     property  CurArmLife : Integer read GetCurArmLife write SetCurArmLife;
     property  CurLegLife : Integer read GetCurLegLife write SetCurLegLife;
     property  ExtraExp : Integer read GetExtraExp write SetExtraExp;
     property  AddableStatePoint : Integer read GetAddableStatePoint write SetAddableStatePoint;
     property  TotalStatePoint : Integer read GetTotalStatePoint write SetTotalStatePoint;

     property  FeatureState : TFeatureState write FFeatureState;

     property  SetAddExpFlag : Boolean write boAddExp;
     property  FboMan : Boolean read boMan;
     property  boExtraValues : Boolean read boSendExtraValues write boSendExtraValues;

     //Author:Steven Date: 2005-02-02 13:02:11
     //Note:采集技能
     property ExtJobKind: Byte read GetExtJobKind write SetExtJobKind;
     property ExtJobExp: Integer read GetExtJobExp write SetExtJobExp;
     property ExtJobLevel: Integer read GetExtJobLevel;
     //====================================
   end;

   THaveMagicClass = class
   private
     FBasicObject : TBasicObject;

     boAddExp : Boolean;

     //盔扁 焊呈胶 痢荐甫 困茄 Indexing Table
     MagicIndexTable       : array [MAGICTYPE_WRESTLING..MAGICTYPE_PROTECTING, MAGICRELATION_0..MAGICRELATION_6] of Integer;
     RiseMagicIndexTable   : array [MAGICTYPE_WRESTLING..MAGICTYPE_PROTECTING, MAGICRELATION_0..MAGICRELATION_6] of Integer;
     MysteryMagicIndexTable : array [MAGICRELATION_0..MAGICRELATION_5] of Integer;
     HaveItemType : integer;
     HaveMagicArr : array [0..HAVEMAGICSIZE-1] of TMagicData;
     HaveRiseMagicArr : array [0..HAVERISEMAGICSIZE - 1] of TMagicData;
     HaveMysteryMagicArr : array [0..HAVEMYSTERYMAGICSIZE - 1] of TMagicData; //2002-11-06 giltae

     HaveBestSpecialMagicArr : array [0..HAVEBESTSPECIALMAGICSIZE-1] of TMagicData; //2003-09-19
     HaveBestProtectMagicArr : array [0..HAVEBESTPROTECTMAGICSIZE-1] of TMagicData;
     HaveBestAttackMagicArr : array [0..HAVEBESTATTACKMAGICSIZE-1] of TMagicData;

     FCurrentGrade : byte;     
     FCurPowerLevel : Integer;
     FPowerLevel : Integer;
     FPowerLevelName : String;
     FCurrentShield : Integer;
     FMaxShield : Integer;

     FRegenerateShieldTick : Integer;

     WalkingCount : integer;

     FpCurAttackMagic     : PTMagicData;
     FpPrevAttackMagic    : PTMagicData;
     FpCurBreathngMagic   : PTMagicData;
     FpCurRunningMagic    : PTMagicData;
     FpCurProtectingMagic : PTMagicData;
     FpCurEctMagic        : PTMagicData;
     FpCurSpecialMagic    : PTMagicData;     //2003-10

     FSendClass : TSendClass;
     FAttribClass : TAttribClass;
     
     function  boKeepingMagic (pMagicData: PTMagicData): Boolean;
     function  boKeepingBestMagic (pMagicData: PTMagicData): Boolean; //2003-10
     procedure DecBreathngAttrib (pMagicData: PTMagicData);

     procedure Dec5SecAttrib (pMagicData: PTMagicData);
     procedure Dec1SecAttribForBestSpecial (pMagicData: PTMagicData); //2003-10
     procedure DecEventAttrib (pMagicData: PTMagicData);
     procedure SetLifeData;
     procedure FindAndSendMagic (pMagicData: PTMagicData);
     procedure MaxShieldCalculate;
     procedure RegenerateShield (CurTick : Integer);
   public
     DefaultMagic : array [0..HAVEBASICMAGICSIZE - 1] of TMagicData;
     HaveMagicLifeData : TLifeData;

     ReQuestPlaySoundNumber : integer;
     ConsumeEnergy : Integer;
     
     constructor Create (aBasicObject : TBasicObject; aSendClass: TSendClass; aAttribClass: TAttribClass);
     destructor Destroy; override;
     
     function   Update (CurTick : integer): integer;

     procedure LoadFromSdb (aCharData : PTDBRecord);
     procedure SaveToSdb (aCharData : PTDBRecord);
     function  ViewMagic (akey: integer; aMagicData: PTMagicData): Boolean;
     function  ViewRiseMagic (akey: integer; aMagicData: PTMagicData): Boolean;
     function  ViewBasicMagic (akey: integer; aMagicData: PTMagicData): Boolean;
     function  ViewMysteryMagic (akey : integer; aMagicData: PTMagicData): Boolean;//2002-11-06 giltae
     function  ViewBestMagic (akey : integer; aMagicData: PTMagicData): Boolean;//2003-09-22
     function  AddMagic  (aMagicData: PTMagicData): Boolean;
     function  AddRiseMagic  (aMagicData: PTMagicData): Boolean;
     function  AddMysteryMagic (aMagicData: PTMagicData): Boolean;//2002-11-06
     function  AddBestMagic (aMagicData: PTMagicData): Boolean;//2003-09-22
     function  DeleteMagicByName (aMagicName: string): Boolean;
     function  DeleteMagic (akey: integer): Boolean;
     function  DeleteRiseMagic (akey: integer): Boolean;
     function  DeleteMysteryMagic (akey: integer): Boolean;//2002-11-06
     function  DeleteBestMagic (akey: integer): Boolean;//2003-09-22
     function  DeleteBestAttackMagic (aKey : Integer) : Boolean;
     function  DeleteBestProtectMagic (akey: integer): Boolean;
     function  DeleteBestSpecialMagic (akey: integer): Boolean;     
     function  AddWindOfHandExp ( atype, aexp: integer; aFlag : Boolean): integer;
     //function  AddAttackExp ( atype, aexp: integer; aFlag : Boolean): integer;
    // add by Orber at 2004-10-08 09:07
     function  AddAttackExp ( atype, aexp: integer; aFlag : Boolean ; aHaveItemClass : THaveItemClass): integer;

     function  AddProtectExp ( atype, aexp: integer; aFlag : Boolean): integer;
     function  AddEctExp ( atype, aexp: integer): integer;
     function  AddStatePoint (pcAddStatePoint : PTCAddStatePoint) : Boolean;
     procedure AddPowerLevelLifeData;

     procedure SetAttackMagic (aMagic : PTMagicData);
     procedure SetBreathngMagic (aMagic: PTMagicData);
     procedure SetRunningMagic (aMagic: PTMagicData);
     procedure SetProtectingMagic (aMagic: PTMagicData);
     procedure SetEctMagic (aMagic: PTMagicData);
     procedure SetSpecialMagic (aMagic : PTMagicData);
     procedure SetPrevAttackMagic (aMagic : PTMagicData);
     
     function  AddWalking(aSItemName:String): Boolean;

     // function  SetHaveMagicPercent (akey: integer; aper: integer): Boolean;
     // function  SetDefaultMagicPercent (akey: integer; aper: integer): Boolean;
     // function  FindBasicMagic (akey : Integer) : Integer;
     function  SetHaveItemMagicType (aType: byte; aboFirst : Boolean): Boolean;
     function  AllowSelectMagic (aType: Integer; aFlag : Boolean) : Boolean; //2003-10
     function  AllowSelectBestMagic (pMagicData : PTMagicData) : Boolean; //2003-10
     // function  PreSelectBasicMagic (akey, aper: integer; var RetStr: string): Boolean;
     // function  PreSelectHaveMagic (akey, aper: integer; var RetStr: string): Boolean;
     // function  PreSelectHaveRiseMagic (akey, aper: integer; var RetStr: string): Boolean;
     function  SelectBasicMagic (akey : Integer; aflag : Boolean): integer;
     function  SelectHaveMagic (akey : Integer; aflag : Boolean): integer;
     function  SelectHaveRiseMagic (akey : Integer; aflag : Boolean): integer;
     function  SelectHaveMysteryMagic (akey : Integer; aflag : Boolean): integer;
     function  SelectHaveBestMagic (akey : Integer; aflag : Boolean): integer;

     function  SetUseMagicGradeUp (atype, tg : byte): Boolean;
     function  GetPossibleGrade (atype,agrade: byte): Boolean;

     function  ChangeMagic (asour, adest: integer): Boolean;
     function  ChangeBasicMagic (asour, adest: integer): Boolean;
     function  ChangeRiseMagic (asour, adest: integer): Boolean;
     function  ChangeMysteryMagic (aSour, aDest: integer): Boolean;
     function  ChangeBestMagic (aSour, aDest: integer): Boolean;

     function  DecEventMagic (apmagic: PTMagicData): Boolean;

     function  GetUsedMagicList: string;
     function  GetMagicIndex(aMagicName: string): integer;
     function  GetRiseMagicIndex(aMagicName: string): integer;
     function  GetBestAttackMagicIndex (aMagicName : String) : Integer;     
     function  GetBestProtectMagicIndex (aMagicName : String) : Integer;     
     function  GetBestSpecialMagicIndex (aMagicName : String) : Integer;
     // add by Orber at 2004-12-02 14:46:24
     function  GetBestAttackMagicGrade (akey : Integer) : Byte;
     function  GetBestAttackMagicExp (akey : Integer) : Integer;

     procedure EditHaveMagicByName (aMagicName : String; aSkillLevel : Integer);
     procedure EditHaveMagicByName2 (aMagicName : String; aMainSkill, aSubSkill : Integer);
     procedure EditHaveBestMagicByName (aMagicName: String; aSkillLevel,aGrade: Integer; strStateDamage, strStateArmor: String);//2003-09-23

     function  FindMagicByName (aMagicName : String) : Integer;
     function  FindHaveMagicByName (aMagicName : String) : Integer;
     function  FindHaveRiseMagicByName (aMagicName : String) : Integer;
     function  FindHaveMagicByExtream (aMagicType, aMagicRelation : Integer) : Boolean;
     function  FindMagicByTypeAndSkill (aMagicType, aSkillLevel : Integer) : Boolean;

     // add by Orber at 2004-09-29 at 14:22
     procedure DblClickItemMagic(pcClick : PTCClick; aWearItemClass : TWearItemClass; aHaveItemClass : THaveItemClass);
     procedure AddItemMagic(aWearItemClass : TWearItemClass);
     procedure DelItemMagic(ItemData :TItemData);
     procedure DblClickBasicMagicProcess (pcClick : PTCClick; aShowWindowClass : TShowWindowClass; aWearItemClass : TWearItemClass; aHaveItemClass : THaveItemClass);
     procedure DblClickMagicProcess (pcClick : PTCClick; aShowWindowClass : TShowWindowClass; aWearItemClass : TWearItemClass; aHaveItemClass : THaveItemClass);
     procedure DblClickRiseMagicProcess (pcClick : PTCClick; aShowWindowClass : TShowWindowClass; aWearItemClass : TWearItemClass; aHaveItemClass : THaveItemClass);
     procedure DblClickMysteryMagicProcess (pcClick : PTCClick; aShowWindowClass : TShowWindowClass; aWearItemClass : TWearItemClass; aHaveItemClass : THaveItemClass);
     procedure DblClickBestMagicProcess (pcClick : PTCClick; aShowWindowClass : TShowWindowClass; aWearItemClass : TWearItemClass; aHaveItemClass : THaveItemClass);
     function  PowerLevelUP : Boolean;
     function  PowerLevelDOWN : Boolean;
     procedure ChangeCurPowerLevel (aLevel : Integer); 
     procedure SelectItemWindow (pcClick : PTCClick);
     procedure ShowBestMagicWindow (aKey: Byte;var MagicData : TMagicData);
     function  GetMiniMagicContents (var aMagicData: TMagicData): String;
     function  GetContentsOfBestMagic(var aMagicData: TMagicData): String;

     procedure SetMagicIndex (boRise : Boolean; aRow, aColumn, aIndex : Integer);
     procedure SetMysteryMagicIndex (aColumn, aIndex : Integer);
     procedure ChangeMagicIndex (boRise : Boolean; aRow1, aColumn1, aRow2, aColumn2 : Integer);
     function  GetMagicTypeName (boRise : Boolean; aMagicType : Integer): String;
     function  GetMagicRelationName (boRise : Boolean; aMagicRelation : Integer): String;
     function  boBingGoRow (boRise : Boolean; aRow, aColumn : Integer): Boolean;
     function  boBingGoColumn (boRise : Boolean; aRow, aColumn : Integer): Boolean;
     function  boBingGoMystery: Boolean;
     function  boHaveOneRiseProtectingMagic: Boolean; //2003-10
     function  boHaveThreeRiseAttackMagic(aMagicType: integer): Boolean;
     function  boHaveOneBestAttackMagic(aMagicType: integer): Boolean;
     function  GetMaxStatePointByGrade: Integer; //2003-10

     function  CheckMagic (aMagicClass, aMagicType : Integer; aMagicName : String) : Boolean;
     function  ConditionBestAttackMagic (aMagicName : String) : Boolean;
     function  ChangeRelationMagic (aMagicType : Integer) : Boolean;
     procedure AddAttributeRelationBestMagic;

     property  pCurAttackMagic: PTMagicData read FpCurAttackMagic;
     property  pPrevAttackMagic: PTMagicData read FpPrevAttackMagic;
     property  pCurBreathngMagic: PTMagicData read FpCurBreathngMagic;
     property  pCurRunningMagic: PTMagicData read FpCurRunningMagic;
     property  pCurProtectingMagic: PTMagicData read FpCurProtectingMagic;

     property  pCurEctMagic: PTMagicData read FpCurEctMagic;
     property  pCurSpecialMagic: PTMagicData read FpCurSpecialMagic;    //2003-10
     property  SetAddExpFlag : Boolean write boAddExp;

     property  PowerLevel : Integer read FPowerLevel;
     property  CurPowerLevel : Integer read FCurPowerLevel write FCurPowerLevel;
     property  PowerLevelName : String read FPowerLevelName;
     property  CurShield : Integer read FCurrentShield write FCurrentShield;
     property  MaxShield : Integer read FMaxShield;
     property  CurrentGrade : Byte read FCurrentGrade write FCurrentGrade;     
   end;

   TWearItemClass = class
   private
     FBasicObject : TBasicObject;
     UpdateItemTick :integer;
     WearFeature : TFeature;
     WearItemArr : array [ARR_BODY..ARR_WEAPON] of TItemData;
     FSendClass : TSendClass;
     FAttribClass : TAttribClass;
     FHaveMagicClass : THaveMagicClass;
     FHaveJobClass : THaveJobClass;
     FHaveItemClass : THaveItemClass;
     FUpdateTick : Integer;

     procedure SetLifeData;
   public
     SetItemCount : Integer;    // 付牢矫府令   
     SpecialItemCount : Integer;
     SpecialItemType : Integer;
     WearItemLifeData : TLifeData;
     AddAttribLifeData : TRealAddAttribData;     
     ReQuestPlaySoundNumber : integer;

     constructor Create (aBasicObject : TBasicObject; aSendClass: TSendClass; aAttribClass: TAttribClass; aHaveMagicClass : THaveMagicClass; aHaveJobClass : THaveJobClass; aHaveItemClass : THaveItemClass);
     destructor Destroy; override;
     procedure Update (CurTick : integer);

     function  GetFeature : TFeature;
     procedure LoadFromSdb (aCharData : PTDBRecord);
     procedure SaveToSdb (aCharData : PTDBRecord);

     function  ViewItem (akey: integer; aItemData: PTItemData): Boolean;
     function  FindItemByAttrib (aAttrib : Integer) : Boolean;
     function  AddColorDrug (aKey : Integer; var aItemData : TItemData) : Boolean;
     function  AddItem  (var aItemData : TItemData; aboChangeMagic : Boolean): Boolean;
     function  DeleteKeyItem (aKey: integer; aboChangeMagic : Boolean) : Boolean;
     function  ChangeItem  (var aItemData: TItemData; var aOldItemData : TItemData; aboChangeMagic : Boolean): Boolean;
     function  GetWeaponType : Integer;
     function  GetWeaponKind : Integer;
     function  GetWeaponAttrib : Integer;
     // add by Orber at 2004-10-09 11:48
     function  GetWeaponItemName : String;
     //---------------------------------

     procedure DecreaseDurability (aKey : Integer);
     function  IncreaseDurability (aKey : Integer) : Boolean;
     function  GetWearItemName (aKey : Integer) : String;
     function  RepairItem (aKey, aKind : Integer) : Integer;
     function  DestroyItembyKind (aKey, aKind : Integer) : Integer;     

     procedure SetFeatureState (aFeatureState : TFeatureState);
     procedure SetHiddenState (aHiddenState : THiddenState);
     procedure SetActionState (aActionState : TActionState);
     function  GetHiddenState : THiddenState;
     function  GetActionState : TActionState;
     procedure SetTeamColor (aIndex : Word);
     procedure SetNameColor (aIndex : Word);

     procedure DressOffProcess (pcDragDrop : PTCDragDrop; aShowWindowClass : TShowWindowClass; aHaveItemClass : THaveItemClass ;aHaveMagicClass: THaveMagicClass);
     function CheckPowerWearItem : Integer;
   end;

   THaveItemClass = class
   private
     boLocked : Boolean;
     UpdateItemTick : Integer;
     FUserName : string;
     FBasicObject : TBasicObject;
     FSendClass : TSendClass;
     FAttribClass : TAttribClass;
     FUserQuestClass : TUserQuestClass;
     FUpdateTick : Integer;

     FBoAttribData : Boolean;
     FBoLifeData : Boolean;
   public
     HaveItemArr : array [0..HAVEITEMSIZE - 1] of TItemData;
     WaterCaseItemCount : Integer;
     FillItemCount : Integer;    
     ReQuestPlaySoundNumber : integer;

     AddAttribLifeData : TRealAddAttribData;     

     constructor Create (aBasicObject: TBasicObject; aSendClass: TSendClass; aAttribClass: TAttribClass;
         aUserQuestClass: TUserQuestClass); overload;
     constructor Create (aHaveItemClass : THaveItemClass); overload;

     destructor Destroy; override;
     procedure Update (CurTick : integer);

     procedure LoadFromSdb (aCharData : PTDBRecord);
     procedure SaveToSdb (aCharData : PTDBRecord);
    // add by Orber by 2004-09-07
     procedure SaveOneToSdb (rkey:byte; aCharData : PTDBRecord);


     procedure CopyFromHaveItemClass (aHaveItemClass : THaveItemClass; aSignStr, aSignIp : String);
     procedure CopyFromHaveItem (aItemArr : PTItemData);

     function  FreeSpace: integer;
     function  boHaveGradeQuestItem : boolean;
     function  CheckHaveQuestItem (aQuestNum: integer) : boolean;
     
     function  GetItemByKey ( aKey : integer ) : PTItemData;
     function  ViewItem (akey: integer; aItemData: PTItemData): Boolean;
     function  FindItem (aItemData : PTItemData): Boolean;
     function  FindItembyCount (aItemData : PTItemData; aCount, aOption : Integer): Boolean;
     function  FindAllItembyKind (aKind : Integer) : Integer;     // 酒捞袍芒俊 倔付父怒 啊瘤绊 乐绰瘤... (般媚瘤瘤臼绰巴父)
     function  FindKindItem (akind: integer): integer;
     function  FindAttribKindItem (aAttribkind: integer): integer;     
     function  FindSpecialKindItem (aSKind : Integer) : Integer;
     function  FindItemByMagicKind (aKind: integer): integer;
     function  FindNoPowerItemByMagicKind (aKind : Integer) : Integer;
     function  FindItemKeybyName (aName : String) : Integer;
     function  FindItembyKindAttrib (aKind, aAttrib : integer ) : PTItemData;     
     function  FindItemCountbyName (aItemName : String) : Integer;
     function  FindItemByName (aName : String) : Boolean;
     function  FindKeyExchangeItem (aKey : Integer; aExchangeItemData : PTExchangeItem) : Boolean;
     function  AddItem  (var aItemData: TItemData): Boolean;
     function  AddKeyItem  (akey : Integer; var aItemData: TItemData): Boolean;

     function  DeletekeyItem (akey, aCount: integer; aItemData : PTItemData): Boolean;
     function  DeleteItem (aItemData: PTItemData): Boolean; overload;
     function  DeleteItem (aIndex : integer): Boolean; overload;
     function  DeleteItembyName (aItemData : PTItemData) : Boolean;
     function  ChangeItem (asour, adest: integer): Boolean;
     function  AddableKey (aKey : Integer; aItemData : TItemData) : Boolean;

     function  CheckBlankAfterDelete (aKey, aCount : Integer) : Boolean;
     function  CheckAddable (var aItemData : TItemData) : Integer;
     function  HaveMoney : Integer;
     function  PayMoney (aPrice : Integer) : Boolean;

     //
     procedure ChangeItemProcess (pcDragDrop : PTCDragDrop; aShowWindowClass : TShowWindowClass);
     procedure DressOnProcess (pcDragDrop : PTCDragDrop; aShowWindowClass : TShowWindowClass; aWearItemClass : TWearItemClass ; aHaveMagicClass : THaveMagicClass);
     procedure PutOnExchangeProcess (pcDragDrop : PTCDragDrop; aShowWindowClass : TShowWindowClass);
     procedure PutOnMaterialProcess (pcDragDrop : PTCDragDrop; aShowWindowClass : TShowWindowClass; aHaveJobClass : THaveJobClass);
     procedure PutOnMarketProcess (pcDragDrop : PTCDragDrop; aShowWindowClass : TShowWindowClass; aHaveMarketClass : THaveMarketClass);     
     procedure PutOnItemLogProcess (pcDragDrop : PTCDragDrop; aShowWindowClass : TShowWindowClass);
     // add by Orber at 2005-01-06 16:17:43
     procedure PutOnGuildItemLogProcess (pcDragDrop : PTCDragDrop; aShowWindowClass : TShowWindowClass);
     procedure PutOnScreenProcess (pcDragDrop : PTCDragDrop; aShowWindowClass : TShowWindowClass);
     procedure DblClickProcess (pcClick : PTCClick; aShowWindowClass : TShowWindowClass; aWearItemClass : TWearItemClass;
      aHaveMagicClass : THaveMagicClass; aUserQuestClass : TUserQuestClass; aHaveJobClass : THaveJobClass);
     procedure SelectItemWindow (pcClick : PTCClick);

     procedure DeleteAllItem;
     procedure DeleteQuestItem;

     procedure Refresh;
     procedure SetAttribData;
     procedure SetLifeData;
     procedure SetWaterCaseItemCount;
     procedure SetFillItemCount;
     procedure SetEffectItemLifeData;
     procedure ChangeCurDuraByName (aName : String; aCurDura : Integer);
     function  RepairItem (aKind : Integer) : Integer;
     function  DestroyItembyKind (aKind : Integer) : Integer;
     function  DestroyItembyAttribKind (aAttribKind : Integer) : Integer;            

     property Locked : Boolean read boLocked write boLocked;
   end;

   THaveJobClass = class
   private
      FBasicObject : TBasicObject;
      FSendClass : TSendClass;
      FAttribClass : TAttribClass;
      FHaveItemClass : THaveItemClass;

      FJobKind : Byte;    // 流辆
      FJobGrade : Byte;   // 流鞭

      FToolConst : Integer;

      FMinePickAmount : Integer;
      FMinePickObjectID : Integer;

      FPickCount : Integer;
      FWorkSound : Integer;

      FSmeltItem : String;
      FSmeltItem2 : String;      

      HaveMaterialArr : array [0..5 - 1] of TItemData;

      function GetJobKindStr : String;
      function GetJobGradeStr : String;
      function GetMaterialStr : String;
      function GetJobImageShape : Byte;
      function GetJobToolStr : String;
      function GetProductItem : TItemData;      
   public
      FToolName : String;
      FToolMagic : TMagicData;
      
      constructor Create (aBasicObject : TBasicObject; aSendClass : TSendClass; aAttribClass : TAttribClass; aHaveItemClass : THaveItemClass);
      destructor Destroy; override;

      procedure LoadFromSdb (aCharData : PTDBRecord);
      procedure SaveToSdb (aCharData : PTDBRecord);

      procedure PutOnAutoMaterialProcess (pcSetMaterial : PTCSetMaterial);
      
      function  AddMaterialItem  (var aItemData: TItemData): Boolean;
      function  AddKeyMaterialItem  (akey : Integer; var aItemData: TItemData): Boolean;
      function  PutProductItem  (var aItemData: TItemData): Boolean;
      function  PutProductItem_2  (var aItemData: TItemData) : Boolean; // 疙家啊傍 版肺      
      function  DeletekeyMaterialItem (akey, aCount: integer; aItemData : PTItemData): Boolean; overload;
      function  DeletekeyMaterialItem (akey : integer): Boolean; overload;
      function  DeleteMaterialItem (aItemData: PTItemData): Boolean;
      function  FindItemKeybyName (aName : String) : Integer;
      function  FindItemCountbyName (aItemName : String) : Integer;      
      function  ViewMaterialItem (akey: integer; aItemData: PTItemData): Boolean;

      procedure FromSkillToItemWindow (pcDragDrop : PTCDragDrop; aShowWindowClass : TShowWindowClass);      

      procedure  Update (CurTick : integer);

      function CheckProductBlankData : Boolean;
      function CheckMaterialBlankData (aItemData : TItemData) : Integer;
      function CheckBlankData : Boolean;

      procedure ClearMaterialData;
      procedure ClearJobData;
      procedure SetJobTalent (aExp : Integer);

      procedure ConfirmMakeItem;
      procedure ConfirmProcessItem;
      function Check3rdQuestItem : Boolean;
      function CheckAddAttribItem : Boolean;
      function CheckAddAttribKind (var iWorth : Integer): Boolean;
      function CheckDelAttribItem : Boolean;
      function CheckEventItemMaterial : Boolean;
      
      procedure ProcessAddAttribItem (iWorth : Integer);
      procedure ProcessDelAddAttribItem;
      procedure ProcessEventItemGive;
      function GetEventItemSuccessRate : integer;
      function GetRandomValue(aValue : integer) : integer;

      function MakeItembyRate (aItemName : String) : Boolean;
      function MakeItem (aItemName : String) : Boolean;
      function FindProcessDrug (var aProcessDrug : Word; var aSubDrugRate : Integer) : Boolean;
      function ProcessItembyRate (aItemData : TItemData; aUpgrade : Word; aSubDrugRate : Integer) : Boolean;
      function DecEventPick : Boolean;
      procedure SmeltItem (aMakeName : String; aShowWindowClass : TShowWindowClass);
      procedure SmeltItem2 (aMakeName : String; aShowWindowClass : TShowWindowClass);      

      function AddPickMineAmount (aID : Integer; var aSubData : TSubData) : Boolean;

      procedure ChangeJobTool (var ItemData : TItemData);
      procedure SetJobKind (aKind : Byte);
      procedure SetVirtueman;

      property JobKind : Byte read FJobKind;
      property JobGrade : Byte read FJobGrade;
      property JobImageShape : Byte read GetJobImageShape;
      property JobKindStr : String read GetJobKindStr;
      property JobGradeStr : String read GetJobGradeStr;
      property JobToolStr : String read GetJobToolStr;
      property ProductItem : TItemData read GetProductItem;      
   end;

   TTradeItem = record
      rName : TNameString;
      rCount : Integer;
      rColor : Integer;
      rShape : Word;
      rPrice : Integer;
   end;
   PTTradeItem = ^TTradeItem;

   TSaleItem = record
      rName : TNameString;
      rCount : Integer;
      rColor : Integer;
      rShape : Word;
      rPrice : Integer;
      rTotalCount : Integer;
   end;
   PTSaleItem = ^TSaleItem;

   TIndividualMarketItem = record
      rName : TNameString;
      rCount : Integer;
      rColor : Integer;
      rShape : Word;
      rCost : Integer;
      rCurDurability : Integer;
      rDurability : Integer;
      rUpgrade : Integer;
      rAddType : Integer;
      rTotalCount : Integer;
   end;
   PTIndividualMarketItem = ^TIndividualMarketItem;

   TShowWindowClass = class
   private
      FCurrentWindow : TSpecialWindowKind;
      FCurrentSubType : TSpecialSubType;

      FUser : Pointer;
      FCommander : TBasicObject;

      FSendClass : TSendClass;
      FHaveItemClass : THaveItemClass;
      FHaveJobClass : THaveJobClass;
      FHaveMarketClass : THaveMarketClass;
      // add by Orber at 2004-09-08 16:21
      UpdateItemLogTick : integer;
      ItemLogData : array [0..4 - 1] of TItemLogRecord;
      ExChangeData : TExChangeData;
      TradeDataArr : array [0..TRADELISTMAX - 1] of TTradeItem;
      SaleDataArr : array [0..SALELISTMAX - 1] of TSaleItem;
      CopyMarketDataList : TList;

      CountWindowState : integer;

      CopyHaveItem : THaveItemClass;
      boActiveExchange : Boolean;      

      function GetCurrentWindowStr : String;
      function GetUserWindowStateStr : String;
      procedure PutOnMaterialCount (pcCount : PTCSelectCount);
   public
      SaleNpc, MarketUser : Pointer;
      SaleItemList : TList;      

      constructor Create (aUser : Pointer; aSendClass : TSendClass; aHaveItemClass : THaveItemClass;
         aHaveJobClass : THaveJobClass; aHaveMarketClass : THaveMarketClass);
      destructor Destroy; override;

      function  AddableExChangeData (pex : PTExChangedata): Boolean;
      procedure AddExChangeData (var aSenderInfo : TBasicData; pex : PTExChangedata; aSenderIP : String);
      procedure DelExChangeData (pex : PTExChangedata);
      function FindExChangeData (pex : PTExChangedata) : Boolean;
      function CheckExchangeBlankData (aItemData : TItemData) : Boolean;
      procedure ExChangeStart (aId : Integer);
      function isCheckExChangeData : Boolean;
      procedure ClickExChange (awin:byte; aclickedid:longInt; akey:word);
      procedure SelectCount (pcCount : PTCSelectCount);
      procedure SelectMarketCount (pcMarketCount : PTCSelectMarketCount);
      procedure Update (CurTick : integer);

      // screen
      procedure PickUpScreenProcess (pcDragDrop : PTCDragDrop);
      procedure PickUpItemWindowProcess (pcDragDrop : PTCDragDrop);
      // itemlog 焊包芒率
      procedure FromItemLogToItemWindow (pcDragDrop : PTCDragDrop);
      // add by Orber at 2005-01-06 13:46:40
      procedure FromGuildItemLogToItemWindow (pcDragDrop : PTCDragDrop);

      // 林葛, 矫距惑 芒
      procedure FromTradeToItemWindow (pcDragDrop : PTCDragDrop);
      procedure FromItemToTradeWindow (pcDragDrop : PTCDragDrop);
      // 惑痢
      procedure FromSaleToItemWindow (pcDragDrop : PTCDragDrop);
      procedure FromItemToSaleWindow (pcDragDrop : PTCDragDrop);
      // 俺牢概概惑痢
      procedure FromIndividualMarketToItemWindow (pcDragDrop : PTCDragDrop);
      
      procedure MakeGuildMagic (aGuildName : String; aCode : TWordComData);
      procedure ConfirmWindowProcess (pcWindowConfirm : PTCWindowConfirm);

      procedure ShowCountWindow (aCountWindowState : Integer; pcDragDrop : PTCDragDrop; aItemData : TItemData);
      procedure ShowMarketCountWindow (pcDragDrop : PTCDragDrop; aItemData : TItemData);
      
      function ShowItemLogWindow : String;
      function ShowGuildItemLogWindow(sPage : Word) : String;
      procedure ShowGuildMagicWindow (pMagicWindowData : PTSShowGuildMagicWindow);
      procedure ShowExchangeWindow (pexleft, pexright: PTExChangedata);
      procedure ShowSearchWindow (aInputStringId: integer; aCaptionString: string; aListString: string);
      procedure ShowHelpWindow (aFileName, aHelpText : String);
      procedure ShowHelpWindow2 (aStr : String);
      procedure ShowTradeWindow (aFileName, aHelpText : String);
      procedure TradeWindow (aTitle, aCaption : String; aImageNum, aImageValue : Word; aItemStr : String; aKind : Byte);
      procedure SaleWindow (aBasicObject : TBasicObject; aTitle, aCaption : String; aImageNum, aImageValue : Word; aItemStr : String; aKind : Byte);
//      procedure ShowMarketWindow;
      procedure IndividualMarketWindow;
      // add by Orber at 2004-12-23 10:47:02
      procedure ShowMarry (aHelpText : String);
      procedure ShowUnMarry (aHelpText : String);
      procedure ShowMarryAnswer (aHelpText : String);
      procedure ShowArenaWindow (aHelpText : String);
      procedure ShowGuildAnswer (aHelpText : String);


      procedure ShowInputMoneyChip (aHelpText : String);
      procedure ShowGuildApplyMoney (aHelpText,aUser : String);
      procedure ShowGuildSubSysop (aHelpText :String);

      //Author:Steven Date: 2005-01-10 18:12:20
      //Note:
      procedure ShowInputGuildName (aHelpText : String ; SenderID : LongInt);
      procedure ShowGuildInfo (aHelpText : String);
      //=========================================

      procedure SetTradeItem;
      procedure SetSaleItem;
      procedure SetIndividualMarketItem;      

      // add by Orber at 2004-12-23 16:57:37
      procedure Marry(aUser:String;aAnswer:Byte);
      procedure SelectMarryWindow (aData : PChar);
      procedure SelectUnMarryWindow (aData : PChar);
      procedure SelectMarryAnswerWindow (aData : PChar);
      procedure SelectGuildItemWindow (aData : PChar);
      procedure SelectInputGuildNameWindow (aData : PChar);
      procedure SelectInputGuildMoneyChipWindow (aData : PChar);
      procedure SelectInputGuildMoneyApplyWindow (aData : PChar);
      procedure SelectInputGuildSubSysopWindow (aData : PChar);
      procedure SelectInputArenaWindow (aData : PChar);
      procedure SelectInputArenaJoinWindow (aData : PChar);
      procedure SelectGuildAnswerWindow (aData : PChar);


      procedure SelectHelpWindow (aData : PChar);
      procedure SelectTradeWindow (aData : PChar);
      procedure SelectItemWindow (pcClick : PTCClick);

      procedure GetExchangeData (var aExchangeData : TExchangeData);
      procedure SetExchangeData (aExchangeData : TExchangeData);
      function AllowWindowAction (aAllowWindowKind : TSpecialWindowKind) : Boolean;
      procedure CancelExchange;
      procedure SetCurrentWindow (aSWK : TSpecialWindowKind; aSST : TSpecialSubType);

      procedure AddSaleItem (aName : String; aCount : Integer);
      procedure ClearCopyMarketDataList;
      
      property CurrentWindow : TSpecialWindowKind read FCurrentWindow;
      property CurrentSubType : TSpecialSubType read FCurrentSubType;
      property CurrentWindowStr : String read GetCurrentWindowStr;
      property Commander : TBasicObject read FCommander write FCommander;
   end;

   THaveMarketClass = class
   private
      FBasicObject : TBasicObject;
      FSendClass : TSendClass;
      FAttribClass : TAttribClass;
      FHaveItemClass : THaveItemClass;
      HaveMarketArr : array [0..10 - 1] of TItemData;  // 0: 魄概茄捣  1-9: 魄概酒捞袍

      FboMarketing : Boolean;  // 魄概吝牢啊 酒囱啊
   public
      MarketCaption : String;      
      FMarketCount : Integer;  // 龋楷瘤扁俊 蝶弗 魄概俺荐

      constructor Create (aBasicObject : TBasicObject; aSendClass : TSendClass; aAttribClass : TAttribClass;
         aHaveItemClass : THaveItemClass);
      destructor Destroy; override;

      procedure LoadFromSdb (aCharData : PTDBRecord);
      procedure SaveToSdb (aCharData : PTDBRecord);

      function AddMarketItem  (var aItemData: TItemData): Boolean;
      function AddKeyMarketItem  (akey : Integer; var aItemData: TItemData): Boolean;
      function AddGoldItem (var aItemData : TItemData) : Boolean;
      function DeletekeyMarketItem (akey, aCount: integer; aItemData : PTItemData): Boolean; overload;
      function DeleteKeyMarketItem (aKey : Integer) : Boolean; overload;
      function DeleteMarketItem (aItemData: PTItemData): Boolean;
      function FindItemKeybyName (aName : String) : Integer;
      function CheckAddableMarketData (aItemData : TItemData) : Integer;
      function ViewMarketItem (akey: integer; aItemData: PTItemData): Boolean;
      procedure ClearMarketData;

      function SellItembyUser (aMarketList : TList; aName : String) : Boolean; overload;
      function SellItembyUser (aItemData : TItemData; aName : String) : Boolean; overload;

      procedure FromMarketToItemWindow (pcDragDrop : PTCDragDrop; aShowWindowClass : TShowWindowClass);
      procedure ConfirmMarketProcess (pcMarketConfirm : PTCMarketConfirm; aShowWindowClass : TShowWindowClass);
      procedure CopyMarketItem (var aMarketDataList : TList);

      procedure SetMarketCount;
      procedure SelectItemWindow (pcClick : PTCClick);      

      property MarketCount : Integer read FMarketCount;
      property boMarketing : Boolean read FboMarketing write FboMarketing;
   end;

   TUserQuestClass = class
   private
      FCompleteQuestNo : Integer;
      FCurrentQuestNo : Integer;
      FQuestStr : String;
      FFirstQuestNo : Integer;
   public
      constructor Create;
      destructor Destroy; override;

      property CompleteQuestNo : Integer read FCompleteQuestNo write FCompleteQuestNo;
      property CurrentQuestNo : Integer read FCurrentQuestNo write FCurrentQuestNo;
      property QuestStr : String read FQuestStr write FQuestStr;
      property FirstQuestNo : Integer read FFirstQuestNo write FFirstQuestNo;
   end;

   TUserSystemInfoClass = class
   private
      KeyClass : TStringKeyClass;
   public
      constructor Create;
      destructor Destroy; override;

      procedure Clear;
      procedure AddUserInfo (aMasterName : String; aSystemInfo : PTCSystemInfoData);
   end;

var
   UserSystemInfoClass : TUserSystemInfoClass;   

implementation

uses
   FSockets, svMain, uUser, SubUtil, uConnect, uGuild, uGuildSub, uNpc, uUtil, uMonster,
   uEvent,uArena;

function  GetPermitExp (aLevel, addvalue: integer): integer;
var n : integer;
begin
   n := GetLevelMaxExp (aLevel);
   if n > addvalue then n := addvalue;
   Result := n;
end;

function  AddPermitExp (var aLevel, aExp: integer; addvalue: integer; aFlag : Boolean): integer;
var n : integer;
begin
   n := GetLevelMaxExp (aLevel) * 3;
   if n > addvalue then n := addvalue;

   if aFlag = true then begin
      inc (aExp, n * ExpMulti);
   end else begin
      inc (aExp, n);
   end;
   aLevel := GetLevel (aExp);
   Result := n;

{  // 沥惑
   n := GetLevelMaxExp (aLevel);
   if n > addvalue then n := addvalue;
   inc (aExp, n);
   aLevel := GetLevel (aExp);
   Result := n;
}
{  // 傈何倾侩
   n := GetLevelMaxExp (aLevel);
   if n <> 0 then n := addvalue;
   inc (aExp, n);
   aLevel := GetLevel (aExp);
   Result := n;
}
end;

function  AddPermitExpByRate (var aLevel, aExp: integer; addvalue, aRate : integer): integer;
var
   n : integer;
begin
   n := GetLevelMaxExp (aLevel) * 3;
   if n > addvalue then n := addvalue;
   n := n * aRate div 100;

   inc (aExp, n);
   aLevel := GetLevel (aExp);
   Result := n;
end;

function  AddVirtuePermitExp (var aLevel, aExp: integer; addvalue: integer): integer;
var
   n : integer;
begin
   n := GetLevelMaxExp (aLevel);
   if n > addvalue then n := addvalue;
   inc (aExp, n * VirtueMulti);
   aLevel := GetLevel (aExp);
   Result := n;
end;

function AddTalentPermitExp (var aLevel, aExp: integer; addvalue: integer): integer;
begin
   Result := 0;
//   n := GetLevelMaxExp (aLevel);
//   if n > addvalue then n := addvalue;
   if aLevel >= 9999 then exit;
   inc (aExp, addvalue);
   aLevel := GetLevel (aExp);

   Result := addvalue;
end;

function Get10000To100 (avalue: integer): string;
var
   n : integer;
   str : string;
begin
   str := InttoStr (avalue div 100) + '.';
   n := avalue mod 100;
   if n >= 10 then str := str + IntToStr (n)
   else str := str + '0'+InttoStr(n);

   Result := str;
end;

function Get10000To120 (avalue: integer): string;
var
   n : integer;
   str : string;
begin
   avalue := avalue * 12 div 10;
   str := InttoStr (avalue div 100) + '.';
   n := avalue mod 100;
   if n >= 10 then str := str + IntToStr (n)
   else str := str + '0'+InttoStr(n);

   Result := str;
end;


///////////////////////////////////
//         TAttribClass
///////////////////////////////////

constructor TAttribClass.Create (aBasicObject : TBasicObject; aSendClass: TSendClass);
begin
   FBasicObject := aBasicObject;
   boAddExp := true;
   ReQuestPlaySoundNumber := 0;
   FSendClass := aSendClass;

   FillChar (AttribData, SizeOf (TAttribData), 0);
   FillChar (AttribLifeData, SizeOf (TLifeData), 0);
   FillChar (DrugAttribData, SizeOf (TAttribData), 0);
   FillChar (HaveItemAttribData, SizeOf (TAttribData), 0);   
   FillChar (DrugAttribLifeData, SizeOf (TLifeData), 0);
   FillChar (HaveItemLifeData, SizeOf (TLifeData), 0);   

   boDrugAttrib := false;
   boIsOverMaxEnergy := false;
   DrugUseTick := 0;
   DrugInterval := 0;
end;

destructor TAttribClass.Destroy;
begin
   inherited Destroy;
end;

procedure TAttribClass.SetHaveItemAttribData(var aAttribData : TAttribData);
begin
   HaveItemAttribData := aAttribData;
   //Move (aAttribData , HaveItemAttribData, sizeof(TAttribData) );
   if CurLife > Life then CurLife := Life;
   if CurHeadLife > HeadLife then CurHeadLife := HeadLife;
   if CurArmLife > ArmLife then CurArmLife := ArmLife;
   if CurLegLife > LegLife then CurLegLife := LegLife;
   
   boSendBase := true;
   boSendValues := true;
end;

procedure TAttribClass.SetLifeData;
var
   i : Integer;
begin
   FillChar (AttribLifeData, sizeof(TLifeData), 0);

   AttribLifeData.damageBody   := 41;
   AttribLifeData.damageHead   := 41;
   AttribLifeData.damageArm    := 41;
   AttribLifeData.damageLeg    := 41;

   AttribLifeData.AttackSpeed  := 70;
   AttribLifeData.avoid        := 25;
   AttribLifeData.recovery     := 50;
   AttribLifeData.accuracy     := 0;
   AttribLifeData.keeprecovery := 0;
   AttribLifeData.armorBody    := 0;
   AttribLifeData.armorHead    := 0;
   AttribLifeData.armorArm     := 0;
   AttribLifeData.armorLeg     := 0;

   AttribLifeData.damageExp    := 41;
   AttribLifeData.armorExp     := 0;

   for i := 0 to SPELLTYPE_MAX - 1 do begin
      AttribLifeData.SpellResistRate [i] := 0;
   end;

   TUserObject (FBasicObject).SetLifeData;
end;

procedure TAttribClass.GetLifeData (var aLifeData : TLifeData);
begin
   aLifeData := AttribLifeData;
end;

procedure TAttribClass.GetAttribData (var aAttribData : TAttribData);
begin
   aAttribData := AttribData;
end;

procedure TAttribClass.SetDrugEffect (var aLifeData : TLifeData);
begin
   aLifeData.DamageBody     := aLifeData.DamageBody     + (aLifeData.damageBody * DrugAttribLifeData.damageBody div 100);
   aLifeData.DamageHead     := aLifeData.DamageHead     + (aLifeData.damageHead * DrugAttribLifeData.damageHead div 100);
   aLifeData.DamageArm      := aLifeData.DamageArm      + (aLifeData.damageArm * DrugAttribLifeData.damageArm div 100);
   aLifeData.DamageLeg      := aLifeData.DamageLeg      + (aLifeData.damageLeg * DrugAttribLifeData.damageLeg div 100);
   aLifeData.armorBody      := aLifeData.armorBody      + (aLifeData.armorBody * DrugAttribLifeData.armorBody div 100);
   aLifeData.armorhead      := aLifeData.armorHead      + (aLifeData.armorHead * DrugAttribLifeData.armorHead div 100);
   aLifeData.armorArm       := aLifeData.armorArm       + (aLifeData.armorArm * DrugAttribLifeData.armorArm div 100);
   aLifeData.armorLeg       := aLifeData.armorLeg       + (aLifeData.armorLeg * DrugAttribLifeData.armorLeg div 100);

   // Recovery is a delay: a positive potion bonus shortens the delay.
   aLifeData.Recovery := aLifeData.Recovery - (aLifeData.Recovery * DrugAttribLifeData.Recovery div 100);
   if aLifeData.Recovery < 0 then aLifeData.Recovery := 0;
   aLifeData.avoid          := aLifeData.avoid          + (aLifeData.avoid * DrugAttribLifeData.Avoid div 100);
   aLifeData.Accuracy       := aLifeData.Accuracy       + (aLifeData.Accuracy * DrugAttribLifeData.Accuracy div 100);
   aLifeData.KeepRecovery   := aLifeData.KeepRecovery   + (aLifeData.KeepRecovery * DrugAttribLifeData.KeepRecovery div 100);
end;

function TAttribClass.GetAge : Integer;
begin
   Result := AttribData.cAge;
end;

function TAttribClass.GetLover : String;
begin
   Result := TUser(FBasicObject).Lover
end;

function TAttribClass.GetVirtue : Integer;
begin
   Result := AttribData.cVirtue;
end;

function TAttribClass.GetAdaptive : Integer;
begin
   Result := AttribData.cAdaptive;
end;

function TAttribClass.GetTalent : Integer;
begin
   Result := AttribData.cTalent;
end;

function TAttribClass.GetLight : Integer;
begin
   Result := AttribData.cLight;
end;

function TAttribClass.GetDark : Integer;
begin
   Result := AttribData.cDark;
end;

function TAttribClass.GetGoodChar : Integer;
begin
   Result := AttribData.cGoodChar;
end;

function TAttribClass.GetBadChar : Integer;
begin
   Result := AttribData.cBadChar;
end;

function TAttribClass.GetLucky : Integer;
begin
   Result := AttribData.cLucky;
end;

function TAttribClass.GetRevival : Integer;
begin
   Result := AttribData.cRevival;
end;

function TAttribClass.GetImmunity : Integer;
begin
   Result := AttribData.cImmunity;
end;

function TAttribClass.GetHealth : Integer;
begin
   Result := AttribData.cHealth;
end;

function TAttribClass.GetSatiety : Integer;
begin
   Result := AttribData.cSatiety;
end;

function TAttribClass.GetPoisoning : Integer;
begin
   Result := AttribData.cPoisoning;
end;

function TAttribClass.GetCurHealth: integer;
begin
   Result := CurAttribData.CurHealth;
end;

function TAttribClass.GetCurSatiety: integer;
begin
   Result := CurAttribData.CurSatiety;
end;

function TAttribClass.GetCurPoisoning: integer;
begin
   Result := CurAttribData.CurPoisoning;
end;

procedure TAttribClass.SetCurHealth (value: integer);
begin
   if Value < 0 then Value := 0;
   if CurAttribData.CurHealth = Value then exit;
   CurAttribData.CurHealth := Value;
   if CurAttribData.CurHealth > Health then CurAttribData.CurHealth := Health;
   boSendValues := TRUE;
end;

procedure TAttribClass.SetCurSatiety (value: integer);
begin
   if Value < 0 then Value := 0;
   if CurAttribData.CurSatiety = Value then exit;
   CurAttribData.CurSatiety := Value;
   if CurAttribData.CurSatiety > Satiety then CurAttribData.CurSatiety := Satiety;
   boSendValues := TRUE;
end;

procedure TAttribClass.SetCurPoisoning (value: integer);
begin
   if Value < 0 then Value := 0;
   if CurAttribData.CurPoisoning = Value then exit;
   CurAttribData.CurPoisoning := Value;
   if CurAttribData.CurPoisoning > Poisoning then CurAttribData.CurPoisoning := Poisoning;
   boSendValues := TRUE;
end;

function  TAttribClass.GetCurHeadLife: integer;
begin
   Result := CurAttribData.CurHeadSeak;
end;

function  TAttribClass.GetCurArmLife: integer;
begin
   Result := CurAttribData.CurArmSeak;
end;

function  TAttribClass.GetCurLegLife: integer;
begin
   Result := CurAttribData.CurLegSeak;
end;

function TAttribClass.GetExtraExp: Integer;
begin
   Result := AttribData.ExtraExp;
end;

procedure TAttribClass.SetExtraExp (value : integer);
begin
   if Value<0 then Value := 0;
   if AttribData.ExtraExp = value then exit;
   AttribData.ExtraExp := value;
   if AttribData.ExtraExp > MAXEXTRA_EXP then AttribData.ExtraExp := MAXEXTRA_EXP;
   boSendValues := TRUE;
end;

function TAttribClass.GetAddableStatePoint: Integer;
begin
   Result := AttribData.AddableStatePoint;
end;

procedure TAttribClass.SetAddableStatePoint (value : integer);
begin
   if Value<0 then Value := 0;
   if AttribData.AddableStatePoint = value then exit;
   AttribData.AddableStatePoint := value;
   if AttribData.AddableStatePoint > MAXADDABLEPOINT then AttribData.AddableStatePoint := MAXADDABLEPOINT;
   boSendValues := TRUE;
end;

function TAttribClass.GetTotalStatePoint: Integer;
begin
   Result := AttribData.TotalStatePoint;
end;

procedure TAttribClass.SetTotalStatePoint (value : integer);
begin
   if Value<0 then Value := 0;
   if AttribData.TotalStatePoint = value then exit;
   AttribData.TotalStatePoint := value;
   if AttribData.TotalStatePoint > MAXADDABLEPOINT then AttribData.TotalStatePoint := MAXADDABLEPOINT;
   boSendValues := TRUE;
end;

procedure TAttribClass.SetEnergyValue (aValue : Integer);
begin
   AttribData.Energy := aValue;
   //CurAttribData.CurEnergy := aValue;
   Calculate;
   boSendBase := true;
end;

function TAttribClass.GetMaxEnergy : Integer;
begin
   Result := AttribData.cEnergy;
end;

function  TAttribClass.GetCurEnergy : Integer;
begin
   Result := CurAttribData.CurEnergy;
end;

procedure TAttribClass.SetCurEnergy (value: Integer);
begin
   if Value < 0 then Value := 0;
   if CurAttribData.CurEnergy = Value then exit;
   CurAttribData.CurEnergy := Value;
   boSendBase := TRUE;
end;

function  TAttribClass.GetCurInPower : integer;
begin
   Result := CurAttribData.CurInPower;
end;

function  TAttribClass.GetMaxInPower: integer;
begin
   Result := AttribData.cInPower + (AttribData.cInPower * DrugAttribData.cInPower div 100);
end;

function  TAttribClass.GetCurOutPower : integer;
begin
   Result := CurAttribData.CurOutPower;
end;

function  TAttribClass.GetMaxOutPower: integer;
begin
   Result := AttribData.cOutPower + (AttribData.cOutPower * DrugAttribData.cOutPower div 100);
end;

function  TAttribClass.GetCurMagic : integer;
begin
   Result := CurAttribData.CurMagic;
end;

function  TAttribClass.GetMaxMagic : integer;
begin
   Result := AttribData.cMagic + (AttribData.cMagic * DrugAttribData.cMagic div 100);
end;

function  TAttribClass.GetCurLife : integer;
begin
   Result := CurAttribData.CurLife;
end;

function  TAttribClass.GetMaxLife: integer;
begin
   Result := AttribData.cLife + (AttribData.cLife * DrugAttribData.cLife div 100)
      + HaveItemAttribData.cLife;
end;

function  TAttribClass.GetMaxHeadLife: integer;
begin
   Result := AttribData.cHeadSeak + HaveItemAttribData.cHeadSeak;
end;

function  TAttribClass.GetMaxArmLife: integer;
begin
   Result := AttribData.cArmSeak + HaveItemAttribData.cArmSeak;
end;

function  TAttribClass.GetMaxLegLife: integer;
begin
   Result := AttribData.cLegSeak + HaveItemAttribData.cLegSeak;
end;

procedure TAttribClass.SetCurHeadLife (value: integer);
begin
   if Value < 0 then Value := 0;
   if CurAttribData.CurHeadSeak = Value then exit;
   CurAttribData.CurHeadSeak := Value;
   if CurAttribData.CurHeadSeak > HeadLife then CurAttribData.CurHeadSeak := HeadLife;
   boSendValues := TRUE;
end;

procedure TAttribClass.SetCurArmLife (value: integer);
begin
   if Value < 0 then Value := 0;
   if CurAttribData.CurArmSeak = Value then exit;
   CurAttribData.CurArmSeak := Value;
   if CurAttribData.CurArmSeak > ArmLife then CurAttribData.CurArmSeak := ArmLife;
   boSendValues := TRUE;
end;

procedure TAttribClass.SetCurLegLife (value: integer);
begin
   if Value < 0 then Value := 0;
   if CurAttribData.CurLegSeak = Value then exit;
   CurAttribData.CurLegSeak := Value;
   if CurAttribData.CurLegSeak > LegLife then CurAttribData.CurLegSeak := LegLife;
   boSendValues := TRUE;
end;

procedure TAttribClass.SetCurInPower (Value: integer);
begin
   if Value < 0 then Value := 0;
   if CurAttribData.CurInPower = Value then exit;
   CurAttribData.CurInPower := Value;
   if CurAttribData.CurInPower > InPower then CurAttribData.CurInPower := InPower;
   boSendBase := TRUE;
end;

procedure TAttribClass.SetCurOutPower (Value: integer);
begin
   if Value < 0 then Value := 0;
   if CurAttribData.CurOutPower = Value then exit;
   CurAttribData.CurOutPower := Value;
   if CurAttribData.CurOutPower > OutPower then CurAttribData.CurOutPower := OutPower;
   boSendBase := TRUE;
end;

procedure TAttribClass.SetCurMagic (Value: integer);
begin
   if Value < 0 then Value := 0;
   if CurAttribData.CurMagic = Value then exit;
   CurAttribData.CurMagic := Value;
   if CurAttribData.CurMagic > Magic then CurAttribData.CurMagic := Magic;
   boSendBase := TRUE;
end;

procedure TAttribClass.SetCurLife (Value: integer);
begin
   if Value < 0 then Value := 0;
   if CurAttribData.CurLife = Value then exit;
   CurAttribData.CurLife := Value;
   if CurAttribData.CurLife > Life then CurAttribData.CurLife := Life;
   boSendBase := TRUE;
end;

procedure TAttribClass.AddAdaptive (aexp: integer);
var oldslevel : integer;
begin
   if boAddExp = false then exit;
   oldslevel := AttribData.cAdaptive;
   if AddPermitExp (AttribData.cAdaptive, AttribData.Adaptive, DEFAULTEXP, false) <> 0 then
      FSendClass.SendEventString (Conv('耐性'));
   if oldslevel <> AttribData.cAdaptive then boSendValues := TRUE;
end;

procedure TAttribClass.AddTalent (aExp : Integer);
var
   oldslevel, oldsexp : integer;
begin
   if boAddExp = false then exit;

   oldslevel := AttribData.cTalent;
   oldsexp := AttribData.Talent;

   if AddTalentPermitExp (AttribData.cTalent, AttribData.Talent, aExp) <> 0 then begin
      if AttribData.cTalent < 9998 then begin
         FSendClass.SendEventString (Conv('技术'));
      end;
   end;

   if (oldslevel <= 9998) and (AttribData.cTalent = 9999) then begin
      AttribData.cTalent := 9998;
      AttribData.Talent := GetLevelExpDetail (99, 98);
   end;

   if oldslevel <> AttribData.cTalent then begin
      boSendValues := TRUE;
   end;
end;

procedure TAttribClass.AddVirtue (aExp : Integer);
var
   oldslevel : integer;
begin
   if boAddExp = false then exit;

   oldslevel := AttribData.cVirtue;
   if AddVirtuePermitExp (AttribData.cVirtue, AttribData.Virtue, aExp) <> 0 then
      FSendClass.SendEventString (Conv('浩然正气'));
   if oldslevel <> AttribData.cVirtue then boSendValues := TRUE;
end;

procedure TAttribClass.DecVirtue (aExp : Integer);
var
   oldlevel, tmpVirtue, DecExp, LimitExp : integer;
begin
   if boAddExp = false then exit;

   if aExp <= 0 then exit;

   LimitExp := GetLevelExp (AttribData.cVirtue);
   if LimitExp > AttribData.Virtue - aExp then begin
      DecExp := AttribData.Virtue - LimitExp;
   end else begin
      DecExp := aExp;
   end;

   oldlevel := AttribData.cVirtue;
   tmpVirtue := AttribData.virtue - DecExp;

   AttribData.Virtue := tmpVirtue;
   AttribData.cVirtue := GetLevel (AttribData.Virtue);

   if oldlevel <> AttribData.cVirtue then boSendValues := TRUE;
end;

procedure TAttribClass.AddExtraExp (aExp : Integer);
var
   oldslevel, newlevel : integer;
begin
   if boAddExp = false then exit;

  //Author:Steven Date: 2004-12-16 17:36:54
  //Note:这里是真气增加的地方

   if AttribData.TotalStatePoint >= TUserObject(FBasicObject).MaxLimitStatePoint then exit;

   oldslevel := AttribData.ExtraExp div LEVELEXTRA_EXP;
   Inc(AttribData.ExtraExp, aExp * ExpMulti);
   newlevel := AttribData.ExtraExp div LEVELEXTRA_EXP;
   if oldslevel <> newlevel then FSendClass.SendEventString (Conv ('真气'));

   if AttribData.ExtraExp >= MAXEXTRA_EXP then begin
      AttribData.ExtraExp := AttribData.ExtraExp - MAXEXTRA_EXP;
      inc (AttribData.AddableStatePoint);
      inc (AttribData.TotalStatePoint);
      FSendClass.SendEventString (Conv ('真气'));
      TUser (FBasicObject).ShowEffect2 (4101, lek_none, 0);  // 眠啊版氰摹 eft      
   end;
   
   boSendExtraValues := TRUE;
end;

function  TAttribClass.CheckRevival: Boolean;
var
   oldslevel : integer;
begin
   Result := FALSE;

   if boAddExp = false then exit;

   if boRevivalFlag then begin
      if CurLife <= 0 then begin
         oldslevel := AttribData.cRevival;
         if AddPermitExp (AttribData.cRevival, AttribData.Revival, DEFAULTEXP, false) <> 0 then
            FSendClass.SendEventString (Conv('再生'));
         if oldslevel <> AttribData.cRevival then boSendValues := TRUE;

         boRevivalFlag := FALSE;
         // boEnergyFlag := FALSE;
         boInPowerFlag := FALSE;
         boOutPowerFlag := FALSE;
         boMagicFlag := FALSE;

         Result := TRUE;
      end;
      exit;
   end;
   if (Life - Life div 10) < CurLife then boRevivalFlag := TRUE;
end;

{
function  TAttribClass.CheckEnegy: Boolean;
var curslevel, oldslevel : integer;
begin
   Result := FALSE;

   if boAddExp = false then exit;

   if boEnergyFlag then begin
      if (AttribData.cEnergy - AttribData.cEnergy div 10) < CurAttribData.CurEnergy then begin
         curslevel := GetLevel (AttribData.Energy);
         oldslevel := curslevel;
         if AddPermitExp (curslevel, AttribData.Energy, DEFAULTEXP) <> 0 then
            FSendClass.SendEventString (Conv('元气'));
         if oldslevel <> curslevel then boSendBase := TRUE;
         boEnergyFlag := FALSE;
         Result := TRUE;
      end;
      exit;
   end;
   if (AttribData.cEnergy div 10) > CurAttribData.CurEnergy then boEnergyFlag := TRUE;
end;
}

function  TAttribClass.CheckInPower: Boolean;
var
   curslevel, oldslevel : integer;
begin
   Result := FALSE;

   if boAddExp = false then exit;

   if boInPowerFlag then begin
      if (InPower - InPower div 10) < CurInPower then begin
         curslevel := GetLevel (AttribData.InPower);
         oldslevel := curslevel;
         if AddPermitExp (curslevel, AttribData.InPower, DEFAULTEXP, false) <> 0 then
            FSendClass.SendEventString (Conv('内功'));
         if oldslevel <> curslevel then boSendBase := TRUE;
         boInPowerFlag := FALSE;
         Result := TRUE;
      end;
      exit;
   end;
   if (InPower div 10) > CurInPower then boInPowerFlag := TRUE;
end;

function  TAttribClass.CheckOutPower: Boolean;
var curslevel, oldslevel : integer;
begin
   Result := FALSE;

   if boAddExp = false then exit;

   if boOutPowerFlag then begin
      if (OutPower - OutPower div 10) < CurOutPower then begin
         curslevel := GetLevel (AttribData.OutPower);
         oldslevel := curslevel;
         if AddPermitExp (curslevel, AttribData.OutPower, DEFAULTEXP, false) <> 0 then
            FSendClass.SendEventString (Conv('外功'));
         if oldslevel <> curslevel then boSendBase := TRUE;
         boOutPowerFlag := FALSE;
         Result := TRUE;
      end;
      exit;
   end;
   if (OutPower div 10) > CurOutPower then boOutPowerFlag := TRUE;
end;

function  TAttribClass.CheckMagic: Boolean;
var curslevel, oldslevel : integer;
begin
   Result := FALSE;

   if boAddExp = false then exit;

   if boMagicFlag then begin
      if (Magic - Magic div 10) < CurMagic then begin
         curslevel := GetLevel (AttribData.Magic);
         oldslevel := curslevel;
         if AddPermitExp (curslevel, AttribData.Magic, DEFAULTEXP, false) <> 0 then
            FSendClass.SendEventString (Conv('武功'));
         if oldslevel <> curslevel then boSendBase := TRUE;
         boMagicFlag := FALSE;
         Result := TRUE;
      end;
      exit;
   end;
   if (Magic div 10) > CurMagic then boMagicFlag := TRUE;
end;

procedure TAttribClass.LoadFromSdb (aCharData : PTDBRecord);
var
   AddAttribData : TRealAddAttribData;
begin
   ReQuestPlaySoundNumber := 0;
   StartTick := mmAnsTick;
   FFeatureState := wfs_normal;

   boRevivalFlag := FALSE;
   // boEnergyFlag := FALSE;
   boInPowerFlag := FALSE;
   boOutPowerFlag := FALSE;
   boMagicFlag := FALSE;

   FillChar (AttribData, sizeof(AttribData), 0);
   FillChar (CurAttribData, sizeof(CurAttribData), 0);
   FillChar (DrugAttribData, sizeof(TAttribData), 0);
   FillChar (DrugAttribLifeData, sizeof(TLifeData), 0);
   FillChar (ItemDrugArr, sizeof(ItemDrugArr), 0);
   FillChar (HaveItemLifeData, SizeOf (TLifeData), 0);

   FillChar (AddAttribData, SizeOf (TRealAddAttribData), 0);   

   CheckIncreaseEnergyTick := StartTick;
   CheckIncreaseTick := StartTick;
   CheckDrugTick := StartTick;

   boMan := FALSE;

   //boMan := false;
   if StrPas (@aCharData^.Sex) = Conv('男') then boMan := true;
   //
   AttribData.Light    := aCharData^.Light;
   AttribData.Dark     := aCharData^.Dark;
   AttribData.Age      := AttribData.Light + AttribData.Dark;
   AttribData.Energy   := aCharData^.Energy;
   AttribData.InPower  := aCharData^.InPower;
   AttribData.OutPower := aCharData^.OutPower;
   AttribData.Magic    := aCharData^.Magic;
   AttribData.Life     := aCharData^.Life;

   //2003-10
   AttribData.ExtraExp := aCharData^.ExtraExp;
   AttribData.AddableStatePoint := aCharData^.AddableStatePoint;
   AttribData.TotalStatePoint := aCharData^.TotalStatePoint;

   with AttribData do begin
      Talent := aCharData^.Talent;
      GoodChar := aCharData^.GoodChar;
      BadChar := aCharData^.BadChar;
{
      str := UserData.GetFieldValueString (aName, Conv('制造日期'));
      if str <> '' then begin
         try
            lucky := Round (Date - StrToDate (str)) mod 50 + 50;
         except
            lucky := 50;
         end;
      end else begin
         lucky := 50;
      end;
}
      lucky := 50;
      lucky := lucky * 100;
      adaptive := aCharData^.Adaptive;
      revival := aCharData^.Revival;
      immunity := aCharData^.Immunity;

      if aCharData^.Virtue < 0 then begin   // 龋楷瘤扁 付捞呈胶蔼锭巩俊 持菌澜.
         Virtue := 0;
      end else begin
         virtue := aCharData^.Virtue;
      end;
   end;

   //Author:Steven Date: 2005-02-03 10:45:36
   //Note:采集技能
   ExtJobKind := aCharData^.ExtJobKind;
   CurAttribData.CurExtJobExp := aCharData^.CurExtJobExp;
   //=======================================


   CurAttribData.CurEnergy    := aCharData^.CurEnergy;
   CurAttribData.CurInPower   := aCharData^.CurInPower;
   CurAttribData.CurOutPower  := aCharData^.CurOutPower;
   CurAttribData.CurMagic     := aCharData^.CurMagic;
   CurAttribData.CurLife      := aCharData^.CurLife;
   CurAttribData.Curhealth    := aCharData^.CurHealth;
   CurAttribData.Cursatiety   := aCharData^.CurSatiety;
   CurAttribData.Curpoisoning := aCharData^.CurPoisoning;
   CurAttribData.CurHeadSeak  := aCharData^.CurHeadSeek;
   CurAttribData.CurArmSeak   := aCharData^.CurArmSeek;
   CurAttribData.CurLegSeak   := aCharData^.CurLegSeek;

   Calculate;

   FSendClass.SendAttribBase (Self);
   FSendClass.SendAttribValues (Self);
   FSendClass.SendExtraAttribValues (Self);

   boSendBase := FALSE;
   boSendValues := FALSE;
   boSendExtraValues := FALSE;
end;

procedure TAttribClass.SaveToSdb (aCharData : PTDBRecord);
var n : integer;
begin
   if GrobalLightDark = gld_light then begin
      n := aCharData^.Light;
      n := n + (mmAnsTick - StartTick) div 100;
      aCharData^.Light := n;
   end else begin
      n := aCharData^.Dark;
      n := n + (mmAnsTick - StartTick) div 100;
      aCharData^.Dark := n; 
   end;

   aCharData^.CurEnergy := CurAttribData.CurEnergy;
   aCharData^.CurInPower := CurAttribData.CurInPower;
   aCharData^.CurOutPower := CurAttribData.CurOutPower;
   aCharData^.CurMagic := CurAttribData.CurMagic;
   aCharData^.CurLife := CurAttribData.CurLife;
   aCharData^.CurHealth := CurAttribData.Curhealth;
   aCharData^.CurSatiety := CurAttribData.Cursatiety;
   aCharData^.CurPoisoning := CurAttribData.Curpoisoning;
   aCharData^.CurHeadSeek := CurAttribData.CurHeadSeak;
   aCharData^.CurArmSeek := CurAttribData.CurArmSeak;
   aCharData^.CurLegSeek := CurAttribData.CurLegSeak;
   aCharData^.Energy := AttribData.Energy;
   aCharData^.InPower := AttribData.InPower;
   aCharData^.OutPower := AttribData.OutPower;
   aCharData^.Magic := AttribData.Magic;
   aCharData^.Life := AttribData.Life;

   //2003-10
   aCharData^.ExtraExp := AttribData.ExtraExp;
   aCharData^.AddableStatePoint := AttribData.AddableStatePoint;
   aCharData^.TotalStatePoint := AttribData.TotalStatePoint;

   aCharData^.ExtJobKind := AttribData.ExtJobKind;
   aCharData^.CurExtJobExp :=  CurAttribData.CurExtJobExp;

   with AttribData do begin
      aCharData^.Talent := Talent;
      aCharData^.GoodChar := GoodChar;
      aCharData^.BadChar := BadChar;
      aCharData^.Adaptive := adaptive;
      aCharData^.Revival := revival;
      aCharData^.Immunity := immunity;
      aCharData^.Virtue := virtue;
   end;

   StartTick := mmAnsTick;

   AttribData.Light    := aCharData^.Light;
   AttribData.Dark     := aCharData^.Dark;
   AttribData.Age      := AttribData.Light + AttribData.Dark;

   Calculate;
end;

procedure TAttribClass.Calculate;
begin
   // AttribData.cEnergy   := GetLevel (AttribData.Energy) + 500;     // 扁夯盔扁 = 5.00
   AttribData.cEnergy   := AttribData.Energy;

   AttribData.cInPower  := GetLevel (AttribData.InPower) + 1000;   // 扁夯郴傍 = 10.00
   AttribData.cOutPower := GetLevel (AttribData.OutPower) + 1000;  // 扁夯寇傍 = 10.00
   AttribData.cMagic    := GetLevel (AttribData.Magic) + 500;      // 扁夯公傍 = 5.00
   AttribData.cLife     := GetLevel (AttribData.Life) + 2000;      // 扁夯劝仿 = 20.00

   //AttribData.cAge   := GetAgeLevel (AttribData.Age);
   AttribData.cAge   := GetLevel (AttribData.Age);
   AttribData.cLight := GetLevel (AttribData.Light + 664);    // 剧沥扁
   AttribData.cDark  := GetLevel (AttribData.Dark + 664);     // 澜沥扁

   // 盔扁 = 扁夯盔扁(5) + 唱捞(50) + 距(20) + 畴仿(25);
   // AttribData.cEnergy := AttribData.cEnergy + (AttribData.cAge div 2);
   // 郴傍 = 扁夯郴傍 (10) + 唱捞(50) + ...
   AttribData.cInPower := AttribData.cInPower + (AttribData.cAge div 2);
   // 寇傍 = 扁夯寇傍 (10) + 唱捞(50) + ...
   AttribData.cOutPower := AttribData.cOutPower + (AttribData.cAge div 2);
   // 公傍 = 扁夯公傍 (10) + 唱捞(50) + ...
   AttribData.cMagic := AttribData.cMagic + (AttribData.cAge div 2);
   // 劝仿 = 扁夯劝仿(20) + 唱捞(100) + 流诀劝仿 + ...
   AttribData.cLife := AttribData.cLife + AttribData.cAge;

   with AttribData do begin
//      cTalent := GetLevel (Talent) + (AttribData.cAge div 2);
      cTalent := GetLevel (Talent);
      cGoodChar := GetLevel (GoodChar);
      cBadChar := GetLevel (BadChar);
//      clucky := GetLevel (lucky);
      clucky := lucky;
      cadaptive := GetLevel (adaptive);
      crevival := GetLevel (revival);
      cimmunity := GetLevel (immunity);
      cvirtue := GetLevel (virtue);

      cHeadSeak := cLife;
      cArmSeak := cLife;
      cLegSeak := cLife;

      cHealth := cLife;
      cSatiety := cLife;
      cPoisoning := cLife;
   end;
   SetLifeData;
end;

function  TAttribClass.AddItemDrug (aDrugName: string): Boolean;
var
   i : integer;
   ItemDrugData : TItemDrugData;
begin
   Result := FALSE;

   ItemDrugClass.GetItemDrugData (aDrugName, ItemDrugData);
   if ItemDrugData.rName[0] = 0 then exit;

   if (ItemDrugData.rType <> ITEM_DRUG_TYPE_A) and
      (ItemDrugData.rType <> ITEM_DRUG_TYPE_B) then begin
      if boDrugAttrib = true then exit;
      for i := 0 to DRUGARR_SIZE -1 do begin
         if ItemDrugArr[i].rName [0] <> 0 then begin
            if ItemDrugArr[i].rType = ItemDrugData.rType then begin
               exit;
            end;
         end;
      end;
   end;

   for i := 0 to DRUGARR_SIZE -1 do begin
      if ItemDrugArr[i].rName[0] = 0 then begin
         ItemDrugArr[i] := ItemDrugData;
         ItemDrugArr[i].rUsedCount := 0;
         ItemDrugArr[i].rUsedTick := mmAnsTick;
         Result := TRUE;
         CurAttribData.CurPoisoning := CurAttribData.CurPoisoning - CurAttribData.CurPoisoning div 10;
         exit;
      end;
   end;
end;

procedure TAttribClass.Update (CurTick : integer);
   function AddLimitValue (var curvalue: integer; maxvalue, addvalue: integer): Boolean;
   begin
      Result := FALSE;
      if curvalue = maxvalue then exit;
      curvalue := curvalue + addvalue;
      if curvalue > maxvalue then curvalue := maxvalue;
      if curvalue < 0 then curvalue := 0;
      Result := TRUE;
   end;
var
   n, i, temp : integer;
   nEnergy : LongWord;
begin
   if FBasicObject.Manager.boUseChemistDrug = true then begin
      if boDrugAttrib = true then begin
         if CurTick >= DrugUseTick + DrugInterval then begin
            FillChar (DrugAttribData, SizeOf (TAttribData), 0);
            FillChar (DrugAttribLifeData, SizeOf (TLifeData), 0);

            DrugUseTick := 0;
            DrugInterval := 0;
            boDrugAttrib := false;

            boSendBase := TRUE;
            boSendValues := TRUE;
         end;
      end;
   end else begin
      if boDrugAttrib = true then begin
         FillChar (DrugAttribData, SizeOf (TAttribData), 0);
         FillChar (DrugAttribLifeData, SizeOf (TLifeData), 0);

         DrugUseTick := 0;
         DrugInterval := 0;
         boDrugAttrib := false;

         boSendBase := TRUE;
         boSendValues := TRUE;
      end;
   end;

   if CheckRevival  then Calculate;
   // if CheckEnegy    then Calculate;
   if CheckInpower  then Calculate;
   if CheckOutpower then Calculate;
   if CheckMagic    then Calculate;

   if CurTick > CheckDrugTick + 100 then begin
      CheckDrugTick := CurTick;
      for i := 0 to DRUGARR_SIZE - 1 do begin
         if ItemDrugArr[i].rName[0] = 0 then continue;

         Case ItemDrugArr [i].rType of
            ITEM_DRUG_TYPE_A : begin  // 老沥剧阑 老沥矫埃悼救 坷福霸 窃
               CurHeadLife := CurHeadLife + ItemDrugArr[i].rEventHeadLife;
               CurArmLife := CurArmLife + ItemDrugArr[i].rEventArmLife;
               CurLegLife := CurLegLife + ItemDrugArr[i].rEventLegLife;
               if CurHeadLife > HeadLife then CurHeadLife := HeadLife;
               if CurArmLife > ArmLife then CurArmLife := ArmLife;
               if CurLegLife > LegLife then CurLegLife := LegLife;
               
               if CurEnergy < Energy then begin
                  CurEnergy := CurEnergy + ItemDrugArr[i].rEventEnergy;
                  if CurEnergy > Energy then CurEnergy := Energy;
               end;

               CurInPower := CurInPower + ItemDrugArr[i].rEventInPower;
               CurOutPower := CurOutPower + ItemDrugArr[i].rEventOutPower;
               CurMagic := CurMagic + ItemDrugArr[i].rEventMagic;


               if CurInPower > InPower then CurInPower := InPower;
               if CurOutPower > OutPower then CurOutPower := OutPower;
               if CurMagic > Magic then CurMagic := Magic;

               temp := CurLife + ItemDrugArr[i].rEventLife;
               //唱赣瘤绰 龋脚碍扁甫 棵妨霖促.
               if temp > Life then begin
                  CurLife := Life;
                  temp := temp - Life;
                  TUserObject (FBasicObject).CurShield := TUserObject (FBasicObject).CurShield + temp;
               end else begin
                  CurLife := temp;
               end;
            end;
            ITEM_DRUG_TYPE_B : begin // 傈眉剧狼 割%沥档甫 老沥矫埃悼救 坷福霸窃
               n := HeadLife * ItemDrugArr[i].rEventHeadLife div 100;
               CurHeadLife := CurHeadLife + (n div ItemDrugArr [i].rUseCount);
               n := ArmLife * ItemDrugArr[i].rEventArmLife div 100;
               CurArmLife := CurArmLife + (n div ItemDrugArr [i].rUseCount);
               n := LegLife * ItemDrugArr[i].rEventLegLife div 100;
               CurLegLife := CurLegLife + (n div ItemDrugArr [i].rUseCount);
               if CurHeadLife > HeadLife then CurHeadLife := HeadLife;
               if CurArmLife > ArmLife then CurArmLife := ArmLife;
               if CurLegLife > LegLife then CurLegLife := LegLife;

               n := InPower * ItemDrugArr[i].rEventInPower div 100;
               CurInPower := CurInPower + (n div ItemDrugArr [i].rUseCount);
               n := OutPower * ItemDrugArr[i].rEventOutPower div 100;
               CurOutPower := CurOutPower + (n div ItemDrugArr [i].rUseCount);
               n := Magic * ItemDrugArr[i].rEventMagic div 100;
               CurMagic := CurMagic + (n div ItemDrugArr [i].rUseCount);
               n := Life * ItemDrugArr[i].rEventLife div 100;
               CurLife := CurLife + (n div ItemDrugArr [i].rUseCount);
               if CurInPower > InPower then CurInPower := InPower;
               if CurOutPower > OutPower then CurOutPower := OutPower;
               if CurMagic > Magic then CurMagic := Magic;
               if CurLife > Life then CurLife := Life;
            end;
            ITEM_DRUG_TYPE_C : begin // 弥措摹/加己阑 刘啊矫难 老沥 矫埃 蜡瘤窃
               FillChar (DrugAttribData, SizeOf (TAttribData), 0);

               DrugAttribData.cInPower := ItemDrugArr [i].rEventInPower;
               DrugAttribData.cOutPower := ItemDrugArr [i].rEventOutPower;
               DrugAttribData.cMagic := ItemDrugArr [i].rEventMagic;
               DrugAttribData.cLife := ItemDrugArr [i].rEventLife;

               DrugAttribLifeData.damageBody := ItemDrugArr [i].rdamageBody;
               DrugAttribLifeData.damageHead := ItemDrugArr [i].rdamageHead;
               DrugAttribLifeData.damageArm := ItemDrugArr [i].rdamageArm;
               DrugAttribLifeData.damageLeg := ItemDrugArr [i].rdamageLeg;

               DrugAttribLifeData.ArmorBody := ItemDrugArr [i].rarmorBody;
               DrugAttribLifeData.ArmorHead := ItemDrugArr [i].rarmorHead;
               DrugAttribLifeData.ArmorArm := ItemDrugArr [i].rarmorArm;
               DrugAttribLifeData.ArmorLeg := ItemDrugArr [i].rarmorLeg;

               DrugAttribLifeData.AttackSpeed := ItemDrugArr [i].rAttackSpeed;
               DrugAttribLifeData.Avoid := ItemDrugArr [i].rAvoid;
               DrugAttribLifeData.Recovery := ItemDrugArr [i].rRecovery;
               DrugAttribLifeData.Accuracy := ItemDrugArr [i].rAccuracy;
               DrugAttribLifeData.KeepRecovery := ItemDrugArr [i].rKeepRecovery;

               boDrugAttrib := true;
               DrugUseTick := CurTick;
               DrugInterval := ItemDrugArr [i].rStillInterval;
            end;
         end;

         Inc (ItemDrugArr[i].rUsedCount);

         boSendBase := TRUE;
         boSendValues := TRUE;
         if ItemDrugArr[i].rUsedCount >= ItemDrugArr [i].rUseCount then begin
            FillChar (ItemDrugArr[i], SizeOf(TItemDrugData), 0);
         end;
      end;
   end;

   if CurTick > CheckIncreaseEnergyTick + ENERGY_REGEN_DELAY + TUserObject (FBasicObject).RegenDec then begin
      CheckIncreaseEnergyTick := CurTick;
      if CurEnergy >= Energy then begin
      end else begin
         if ((TUser (FBasicObject).pCurAttackMagic <> nil) and (TUser (FBasicObject).pCurAttackMagic^.rMagicClass <> MAGICCLASS_BESTMAGIC)) or
            ((TUser (FBasicObject).pCurProtectingMagic <> nil) and (TUser (FBasicObject).pCurProtectingMagic^.rMagicClass <> MAGICCLASS_BESTMAGIC)) then begin  // 例技公傍, 脚傍 荤侩吝俊绰 盔扁磊悼雀汗捞 吝瘤 040422
            CurEnergy := CurEnergy + Energy * 10 div 100;
            if CurEnergy > Energy then CurEnergy := Energy;
            boSendBase := true;
         end;
      end;
   end;

   if CurEnergy > Energy then begin
//      if CurTick > CheckAccelDecreaseTick + 500 then begin
      if CurTick > CheckAccelDecreaseTick + 3000 then begin
         nEnergy := CurEnergy;
         nEnergy := nEnergy - (nEnergy div 100) * (nEnergy div 100) * 400 div Energy;  // overflow锭巩俊 longword肺 官厕  030730 saset
         CurEnergy := nEnergy;

         if CurEnergy <= Energy then begin
            CurEnergy := Energy;
         end else begin
            CheckAccelDecreaseTick := CurTick;
         end;
         boSendBase := true;
      end;
   end;

   if CurTick > CheckIncreaseTick + 900 then begin
      CheckIncreaseTick := CurTick;
      boSendBase := FALSE;

      //n := GetAgeLevel ( (AttribData.Age+(CurTick-StartTick) div 100) );
      n := GetLevel ( (AttribData.Age+(CurTick-StartTick) div 100) );
      if AttribData.cAge <> n then begin
         if (AttribData.cAge div 100) <> (n div 100) then begin
            Calculate;
            FSendClass.SendChatMessage (format (Conv('年龄已达 %d岁。'),[n div 100]), SAY_COLOR_SYSTEM);
         end;
         AttribData.cAge := n;
         boSendBase := TRUE;
      end;

      if GrobalLightDark = gld_light then begin
         n := GetLevel (AttribData.Light+664+(CurTick-StartTick) div 100);
         if AttribData.cLight <> n then begin
            AttribData.cLight := n;
            FSendClass.SendEventString (Conv('阳气'));
            boSendBase := TRUE;
         end;
      end else begin
         n := GetLevel (AttribData.Dark+664+(CurTick-StartTick) div 100);
         if AttribData.cDark <> n then begin
            AttribData.cDark := n;
            FSendClass.SendEventString (Conv('阴气'));
            boSendBase := TRUE;
         end;
      end;

      case FFeatureState of
         wfs_normal   : n := 80;
         wfs_care     : n := 10;
         wfs_sitdown  : n := 150;
         wfs_die      : n := 300;
         else n :=50;
      end;
      n := n + n * AttribData.crevival div 10000;

      Curhealth    := Curhealth + n;
      Cursatiety   := Cursatiety + n;
      Curpoisoning := Curpoisoning + n;
      CurHeadLife  := CurHeadLife + n;
      CurArmLife   := CurArmLife + n;
      CurLegLife   := CurLegLife + n;
      if Curhealth    > Health then Curhealth := Health;
      if Cursatiety   > Satiety then Cursatiety := Satiety;
      if Curpoisoning > Poisoning then Curpoisoning := Poisoning;
      if CurHeadLife  > HeadLife then CurHeadLife := HeadLife;
      if CurArmLife   > ArmLife then CurArmLife := ArmLife;
      if CurLegLife   > LegLife then CurLegLife := LegLife;
      boSendValues := TRUE;

      case FFeatureState of
         wfs_normal   : n := 50;
         wfs_care     : n := 20;
         wfs_sitdown  : n := 70;
         wfs_die      : n := 100;
         else n :=50;
      end;
      n := n + n * AttribData.crevival div 10000;

      // if AddLimitValue (CurAttribData.CurEnergy, Attribdata.cEnergy, n div 4) then boSendBase := TRUE;
      if AddLimitValue (CurAttribData.CurInPower, InPower, n) then boSendBase := TRUE;
      if AddLimitValue (CurAttribData.CurOutPower, OutPower, n) then boSendBase := TRUE;
      if AddLimitValue (CurAttribData.CurMagic, Magic, n div 2) then boSendBase := TRUE;
      if AddLimitValue (CurAttribData.CurLife, Life, n) then boSendBase := TRUE;

      boSendBase := TRUE;
   end;

   if boSendBase then FSendClass.SendAttribBase (Self);
   if boSendValues then FSendClass.SendAttribValues (Self);
   if boSendExtraValues then FSendClass.SendExtraAttribValues (Self);

   boSendBase := FALSE;
   boSendValues := FALSE;
   boSendExtraValues := FALSE;
end;




///////////////////////////////////
//         THaveItemClass
///////////////////////////////////

constructor THaveItemClass.Create (aBasicObject: TBasicObject; aSendClass: TSendClass; aAttribClass: TAttribClass;
   aUserQuestClass: TUserQuestClass);
begin
   boLocked := false;
   ReQuestPlaySoundNumber := 0;
   UpdateItemTick := 0;
   FBasicObject := aBasicObject;
   FSendClass := aSendClass;
   FAttribClass := aAttribClass;
   FUserQuestClass := aUserQuestClass;
   FUserName := '';
end;

constructor THaveItemClass.Create (aHaveItemClass : THaveItemClass);
begin
   boLocked := false;
   ReQuestPlaySoundNumber := 0;
   
   FBasicObject := aHaveItemClass.FBasicObject;
   FSendClass := aHaveItemClass.FSendClass;
   FAttribClass := aHaveItemClass.FAttribClass;
   FUserQuestClass := aHaveItemClass.FUserQuestClass;
   FUserName := '';
   FUpdateTick := mmAnsTick;
   FBoAttribData := true;
   FBoLifeData := true;
end;

destructor THaveItemClass.Destroy;
begin
   inherited destroy;
end;

procedure THaveItemClass.Update (CurTick : integer);
var
   i,j : integer;
   aCharData:PTDBRecord;
begin
   if FBoAttribData = true then begin
      SetAttribData;
      FBoAttribData := false;
   end;

   if FBoLifeData = true then begin
      SetLifeData;
      FBoLifeData := false;
   end;
   if UpdateItemTick = 0 then UpdateItemTick := CurTick;
   // add by Orber 2004-09-08 11:42
   if frmMain.chkSaveUserData.Checked then begin
        if UpdateItemTick + 60 * 100 < CurTick then begin
            for i := 0 to HAVEITEMSIZE - 1 do begin
                if HaveItemArr[i].rLockState = 2 then begin
                    //HaveItemArr[i].runLockTime := 24 * 60 -1;
                    Inc(HaveItemArr[i].runLockTime);
                    if HaveItemArr[i].runLockTime >= INI_ITEMUNLOCKTIME then begin
                        HaveItemArr[i].rLockState := 0;
                        HaveItemArr[i].runLockTime := 0;
                        FSendClass.SendHaveItem(i,HaveItemArr[i]);
                    end;
                end; 
            end;
{
            for i := 0 to 4 - 1  do begin
                if ShowWindowClass.ItemLogData[i].Header.boUsed = false then continue;
                for j := 0 to 10 - 1 do begin
                    if aShowWindowClass.ItemLogData[ret].ItemData[j mod 10].Name[0] = 0 then continue;
                    if sShowWindowClass.
                end;
            end;
}
{            aCharData := @CharData;
            for i := 0 to HAVEITEMSIZE - 1 do begin
                if aCharData^.HaveItemArr[i].rLockState = 2 then begin
                    Inc(HaveItemClass.HaveItemArr[i].runLockTime);
                    Inc(aCharData^.HaveItemArr[i].runLockTime);
                    if aCharData^.HaveItemArr[i].runLockTime >= 24 * 60 then begin
                        aCharData^.HaveItemArr[i].rLockState := 0;
                    end;
                end;
            end;
             for i := 0 to 7 do begin
                 if aCharData^.WearItemArr[i].rLockState = 2 then begin
                      Inc(aCharData^.WearItemArr[i].runLockTime);
                      if aCharData^.WearItemArr[i].runLockTime >= 24 * 60 then begin
                          aCharData^.WearItemArr[i].rLockState := 0;
                      end;
                 end;
             end;}
        UpdateItemTick := CurTick;
        end;
   end;

   if CurTick < FUpdateTick + HAVEITEM_UPDATE_DELAY then exit;
   FUpdateTick := mmAnsTick;
   for i := 0 to HAVEITEMSIZE - 1 do begin
      if (HaveItemArr[i].rboDurability = true) and (HaveItemArr[i].rDecDelay > 0) and (HaveItemArr[i].rCurDurability > 0) then begin
         Case HaveItemArr[i].rKind of
            ITEM_KIND_WATERCASE : begin
               if HaveItemArr[i].rDecTick + HaveItemArr[i].rDecDelay <= CurTick then begin
                  HaveItemArr[i].rCurDurability := HaveItemArr[i].rCurDurability - HaveItemArr[i].rDecSize;
                  HaveItemArr[i].rDecTick := CurTick;

                  if HaveItemArr[i].rCurDurability <= 0 then begin
                     HaveItemArr[i].rCurDurability := 0;
                     WaterCaseItemCount := 0;
                     FSendClass.SendChatMessage(Conv('水喝没了'),SAY_COLOR_SYSTEM);
                     continue;
                  end;
               end;
            end;
            ITEM_KIND_CHARM : begin
               if HaveItemArr[i].rDecTick + HaveItemArr[i].rDecDelay <= CurTick then begin
                  Dec (HaveItemArr[i].rCurDurability, HaveItemArr[i].rDecSize);
                  HaveItemArr[i].rDecTick := CurTick;
                  if HaveItemArr[i].rCurDurability <= 0 then begin
                     FSendClass.SendChatMessage (format(Conv('%S已经磨损的再不能用了'), [StrPas (@HaveItemArr[i].rViewName)]), SAY_COLOR_SYSTEM);
                     DeleteItem (i);
                  end;
               end;
            end;
            ITEM_KIND_FILL : begin // 坷祸距荐
               if HaveItemArr[i].rDecTick + HaveItemArr[i].rDecDelay <= CurTick then begin
                  Dec (HaveItemArr[i].rCurDurability, HaveItemArr[i].rDecSize);
                  HaveItemArr[i].rDecTick := CurTick;
                  if HaveItemArr[i].rCurDurability <= 0 then begin
                     FillItemCount := 0;
                     FSendClass.SendChatMessage (format(Conv('%S已经磨损的再不能用了'), [StrPas (@HaveItemArr[i].rViewName)]), SAY_COLOR_SYSTEM);
                     DeleteItem (i);
                  end;
               end;
            end;
            ITEM_KIND_GOLDBAG : begin       // 快吝按狼陛扯
               if HaveItemArr[i].rDecTick + HaveItemArr[i].rDecDelay <= CurTick then begin
                  Dec (HaveItemArr[i].rCurDurability, HaveItemArr[i].rDecSize);
                  HaveItemArr[i].rDecTick := CurTick;
                  if HaveItemArr[i].rCurDurability <= 0 then begin
                     FSendClass.SendChatMessage (format(Conv('%S已经磨损的再不能用了'), [StrPas (@HaveItemArr[i].rViewName)]), SAY_COLOR_SYSTEM);
                     if HaveItemArr [i].rSpecialKind = ITEM_SPKIND_DELALLBYDURA then begin
                        TUser (FBasicObject).DeleteAllItembyName (StrPas (@HaveItemArr [i].rDelItem [0].rName))
                     end;
                     DeleteItem (i);
                  end;
               end;
            end;
            ITEM_KIND_DAGGEROFOS : begin    // 苛急狼公沥街档
               if HaveItemArr[i].rDecTick + HaveItemArr[i].rDecDelay <= CurTick then begin
                  Dec (HaveItemArr[i].rCurDurability, HaveItemArr[i].rDecSize);
                  HaveItemArr[i].rDecTick := CurTick;
                  if HaveItemArr[i].rCurDurability <= 0 then begin
                     FillItemCount := 0;
                     FSendClass.SendChatMessage (format(Conv('%S已经磨损的再不能用了'), [StrPas (@HaveItemArr[i].rViewName)]), SAY_COLOR_SYSTEM);
                     if HaveItemArr [i].rSpecialKind = ITEM_SPKIND_DELALLBYDURA then begin
                        TUser (FBasicObject).DeleteAllItembyName (StrPas (@HaveItemArr [i].rDelItem [0].rName))                     end;
                     DeleteItem (i);
                  end;
               end;
            end;
            ITEM_KIND_DURABILITY : begin    // 郴备己乐绰 酒捞袍
               if HaveItemArr[i].rDecTick + HaveItemArr[i].rDecDelay <= CurTick then begin
                  Dec (HaveItemArr[i].rCurDurability, HaveItemArr[i].rDecSize);
                  HaveItemArr[i].rDecTick := CurTick;
                  if HaveItemArr[i].rCurDurability <= 0 then begin
                     FillItemCount := 0;
                     FSendClass.SendChatMessage (format(Conv ('%S已经磨损的再不能用了'), [StrPas (@HaveItemArr[i].rViewName)]), SAY_COLOR_SYSTEM);
                     DeleteItem (i);
                  end;
               end;
            end;
            ITEM_KIND_EIGHTANGLES : begin    // 迫阿鲍
               if HaveItemArr [i].rDecSize = 0 then exit;
               if HaveItemArr[i].rDecTick + HaveItemArr[i].rDecDelay <= CurTick then begin
                  Dec (HaveItemArr[i].rCurDurability, HaveItemArr[i].rDecSize);
                  HaveItemArr[i].rDecTick := CurTick;
                  if HaveItemArr[i].rCurDurability <= 0 then begin
                     FSendClass.SendChatMessage (format(Conv('%S已经磨损的再不能用了'), [StrPas (@HaveItemArr[i].rViewName)]), SAY_COLOR_SYSTEM);
                     // 促 粹酒档 绝局柳 臼绰促.
                  end;
               end;
            end;
            ITEM_KIND_WEARITEM : begin
               if HaveItemArr[i].rDecTick + HaveItemArr[i].rDecDelay <= CurTick then begin
                  Dec (HaveItemArr[i].rCurDurability, HaveItemArr[i].rDecSize);
                  HaveItemArr[i].rDecTick := CurTick;
                  if HaveItemArr[i].rCurDurability <= 0 then begin
                     FSendClass.SendChatMessage (format(Conv('%S已经磨损的再不能用了'), [StrPas (@HaveItemArr[i].rViewName)]), SAY_COLOR_SYSTEM);
                     DeleteItem (i);
                  end;
               end;
            end;
            {
            ITEM_KIND_SPECIALEFFECT : begin  // 酒捞袍芒俊 乐栏搁辑 漂喊茄 瓷仿阑 惯戎窍绰巴
               if HaveItemArr [i].rDecSize = 0 then exit;
               if HaveItemArr[i].rDecTick + HaveItemArr[i].rDecDelay <= CurTick then begin
                  Dec (HaveItemArr[i].rCurDurability, HaveItemArr[i].rDecSize);
                  HaveItemArr[i].rDecTick := CurTick;
                  if HaveItemArr[i].rCurDurability <= 0 then begin
                     FSendClass.SendChatMessage (format(Conv('%S已经磨损的再不能用了'), [StrPas (@HaveItemArr[i].rViewName)]), SAY_COLOR_SYSTEM);
                     DeleteItem (i);
                  end;
               end;
            end;
            }
         end;
      end;
   end;
end;

procedure THaveItemClass.LoadFromSdb (aCharData : PTDBRecord);
var
   i, j : integer;
   ItemData : TItemData;
   str : String;
begin
   boLocked := false;
   ReQuestPlaySoundNumber := 0;
   
   FUserName := StrPas (@aCharData^.PrimaryKey);
   for i := 0 to HAVEITEMSIZE - 1 do begin
      // str := StrPas (@aCharData^.HaveItemArr[i].Name) + ':' + IntToStr (aCharData^.HaveItemArr[i].Color) + ':' + IntToStr (aCharData^.HaveItemArr[i].Count) + ':' + StrPas (@aCharData^.HaveItemArr [i].Code);
      {str := StrPas (@aCharData^.HaveItemArr[i].Name) + ':' +
         IntToStr (aCharData^.HaveItemArr[i].Color) + ':' +
         IntToStr (aCharData^.HaveItemArr[i].Count) + ':' +
         IntToStr (aCharData^.HaveItemArr[i].Durability) + ':' +
         IntToStr (aCharData^.HaveItemArr[i].CurDurability) + ':' +
         IntToStr (aCharData^.HaveItemArr[i].UpGrade) + ':' +
         IntToStr (aCharDasas萨Tta^.HaveItemArr[i].AddType);
      }
      //add by Orber at 2004-09-07 11:07
      str := StrPas (@aCharData^.HaveItemArr[i].Name) + ':' +
         IntToStr (aCharData^.HaveItemArr[i].Color) + ':' +
         IntToStr (aCharData^.HaveItemArr[i].Count) + ':' +
         IntToStr (aCharData^.HaveItemArr[i].Durability) + ':' +
         IntToStr (aCharData^.HaveItemArr[i].CurDurability) + ':' +
         IntToStr (aCharData^.HaveItemArr[i].UpGrade) + ':' +
         IntToStr (aCharData^.HaveItemArr[i].AddType) + ':' +
         IntToStr (aCharData^.HaveItemArr[i].rLockState) + ':' +
         IntToStr (aCharData^.HaveItemArr[i].runLockTime) ;

      ItemClass.GetWearItemData (str, HaveItemArr[i]);

      JobClass.GetUpgradeItemLifeData (HaveItemArr [i]);
      ItemClass.GetAddItemAttribData (HaveItemArr[i]);      
   end;

   for i := 0 to HAVEITEMSIZE-1 do begin
      if HaveItemArr[i].rName[0] <> 0 then begin
         if HaveItemArr[i].rboDouble = true then begin
            if HaveItemArr[i].rKind = 1 then begin
               ItemClass.GetItemData (StrPas(@HaveItemArr[i].rName), ItemData);
               if StrPas(@ItemData.rName) = StrPas (@HaveItemArr[i].rName) then begin
                  if HaveItemArr[i].rColor <> ItemData.rcolor then begin
                     HaveItemArr[i].rColor := ItemData.rColor;
                  end;
               end;
            end;
         end;
      end;
      //add by Orber at 2004-09-07 21:00
      HaveItemArr[i].runLockTime := aCharData^.HaveItemArr[i].runLockTime;
      HaveItemArr[i].rLockState  := aCharData^.HaveItemArr[i].rLockState;
   end;

   for i := 0 to HAVEITEMSIZE-1 do begin
      if HaveItemArr[i].rName[0] <> 0 then begin
         if HaveItemArr[i].rboDouble = true then begin
            for j := i + 1 to HAVEITEMSIZE - 1 do begin
               if StrPas(@HaveItemArr[i].rName) = StrPas(@HaveItemArr[j].rName) then begin
                  if HaveItemArr[i].rKind = ITEM_KIND_GROWTHHERB then begin
                     if HaveItemArr [i].rUpgrade = HaveItemArr [j].rUpgrade then begin
                        HaveItemArr[i].rCount := HaveItemArr[i].rCount + HaveItemArr[j].rCount;
                        FillChar (HaveItemArr[j], SizeOf (TItemData), 0);
                     end;
                  end else begin
                     if HaveItemArr[i].rColor = HaveItemArr[j].rColor then begin
                        HaveItemArr[i].rCount := HaveItemArr[i].rCount + HaveItemArr[j].rCount;
                        FillChar (HaveItemArr[j], SizeOf (TItemData), 0);
                     end;
                  end;
               end;
            end;
         end else begin
            for j := 0 to HAVEITEMSIZE - 1 do begin
               if HaveItemArr[i].rCount <= 1 then break;
               if HaveItemArr[j].rName[0] = 0 then begin
                  HaveItemArr[i].rCount := HaveItemArr[i].rCount - 1;
                  Move (HaveItemArr[i], HaveItemArr[j], SizeOf (TItemData));
                  HaveItemArr[j].rCount := 1;
               end;
            end;
         end;
      end;
   end;

   for i := 0 to HAVEITEMSIZE-1 do begin
      FSendClass.SendHaveItem (i, HaveItemArr[i]);
   end;

   SetAttribData;
   SetWaterCaseItemCount;
   SetFillItemCount;
   SetEffectItemLifeData;
   SetLifeData;
end;

procedure THaveItemClass.CopyFromHaveItemClass (aHaveItemClass : THaveItemClass; aSignStr, aSignIp : String);
var
   i, j : Integer;
   ItemData : TItemData;
   OldItemArr, NewItemArr : array [0..HAVEITEMSIZE - 1] of TItemData;
begin
   if FAttribClass <> nil then begin
      CopyFromHaveItem (@OldItemArr);
      aHaveItemClass.CopyFromHaveItem (@NewItemArr);
      for i := 0 to HAVEITEMSIZE - 1 do begin
         if OldItemArr[i].rName[0] <> 0 then begin
            for j := 0 to HAVEITEMSIZE - 1 do begin
               if NewItemArr[j].rName[0] <> 0 then begin
                  if StrPas (@OldItemArr[i].rName) = StrPas (@NewItemArr[j].rName) then begin
                     if OldItemArr[i].rColor = NewItemArr[j].rColor then begin
                        if OldItemArr [i].rUpgrade = NewItemArr [j].rUpgrade then begin
                           if OldItemArr[i].rCount = NewItemArr[j].rCount then begin
                              FillChar (OldItemArr [i], SizeOf (TItemData), 0);
                              FillChar (NewItemArr [j], SizeOf (TItemData), 0);
                              break;
                           end else if OldItemArr[i].rCount < NewItemArr[j].rCount then begin
                              NewItemArr[j].rCount := NewItemArr[j].rCount - OldItemArr[i].rCount;
                              FillChar (OldItemArr [i], SizeOf (TItemData), 0);
                              break;
                           end else begin
                              OldItemArr[i].rCount := OldItemArr[i].rCount - NewItemArr[j].rCount;
                              FillChar (NewItemArr [j], SizeOf (TItemData), 0);
                           end;
                        end;
                     end;
                  end;
               end;
            end;
         end;
      end;
      for i := 0 to HAVEITEMSIZE - 1 do begin
         if NewItemArr[i].rName[0] <> 0 then begin
            for j := 0 to HAVEITEMSIZE - 1 do begin
               if OldItemArr[j].rName[0] <> 0 then begin
                  if StrPas (@NewItemArr[i].rName) = StrPas (@OldItemArr[j].rName) then begin
                     if NewItemArr[i].rColor = OldItemArr[j].rColor then begin
                        if NewItemArr [i].rUpgrade = OldItemArr [j].rUpgrade then begin
                           if NewItemArr[i].rCount = OldItemArr[j].rCount then begin
                              FillChar (NewItemArr [i], SizeOf (TItemData), 0);
                              FillChar (OldItemArr [j], SizeOf (TItemData), 0);
                              break;
                           end else if NewItemArr[i].rCount < OldItemArr[j].rCount then begin
                              OldItemArr[j].rCount := OldItemArr[j].rCount - NewItemArr[i].rCount;
                              FillChar (NewItemArr [i], SizeOf (TItemData), 0);
                              break;
                           end else begin
                              NewItemArr[i].rCount := NewItemArr[i].rCount - OldItemArr[j].rCount;
                              FillChar (OldItemArr [j], SizeOf (TItemData), 0);
                           end;
                        end;
                     end;
                  end;
               end;
            end;
         end;
      end;

      for i := 0 to HAVEITEMSIZE - 1 do begin
         if OldItemArr[i].rName [0] <> 0 then begin
            FSendClass.SendItemMoveInfo (FUserName + ',' + aSignStr + ',' +
               StrPas(@OldItemArr[i].rName) + ':' + IntToStr (OldItemArr[i].rUpgrade) + ':' +
               IntToStr (OldItemArr[i].rAddType) + ',' + IntToStr(OldItemArr[i].rCount) + ',' +
               IntToStr(0) + ',' + IntToStr(0) + ',' + IntToStr(0) + ',' + TUser (FBasicObject).IP + ',', aSignip);
         end;
      end;
      for i := 0 to HAVEITEMSIZE - 1 do begin
         if NewItemArr[i].rName [0] <> 0 then begin
            FSendClass.SendItemMoveInfo (aSignStr + ',' + FUserName + ',' +
               StrPas(@NewItemArr[i].rName) + ':' + IntToStr (NewItemArr[i].rUpgrade) + ':' +
               IntToStr (NewItemArr[i].rAddType) + ',' + IntToStr(NewItemArr[i].rCount) + ',' +
               IntToStr(0) + ',' + IntToStr(0) + ',' + IntToStr(0) + ',' + aSignIp + ',', '');

            if NewItemArr [i].rKind = ITEM_KIND_GUILDLOTTERY then begin
               FSendClass.SendLotteryInfo (format ('%s,%d', [StrPas (@NewItemArr [i].rName), NewItemArr [i].rCount]));
            end;
         end;
      end;
   end;

   FillChar (HaveItemArr, SizeOf (TItemData) * HAVEITEMSIZE, 0);
   WaterCaseItemCount := 0;
   FillItemCount := 0;
   for i := 0 to HAVEITEMSIZE - 1 do begin
      if aHaveItemClass.ViewItem (i, @ItemData) = true then begin
         if ItemData.rName [0] <> 0 then begin
            HaveItemArr[i] := ItemData;
         end;
      end;
   end;
end;

procedure THaveItemClass.CopyFromHaveItem (aItemArr : PTItemData);
begin
   Move (HaveItemArr, aItemArr^, SizeOf (HaveItemArr));
end;

procedure THaveItemClass.SaveToSdb (aCharData : PTDBRecord);
var
   i : integer;
   str, rdstr : String;
begin
   for i := 0 to HAVEITEMSIZE - 1 do begin
          // add by Orber at 2004-09-16 12:34
      if HaveItemArr[i].rboNotSave then begin
          rdstr := '0';
          StrPCopy (@aCharData^.HaveItemArr[i].Name, '');
          aCharData^.HaveItemArr[i].Color := _StrToInt (rdstr);
          aCharData^.HaveItemArr[i].Count := _StrToInt (rdstr);
          aCharData^.HaveItemArr[i].Durability := _StrToInt (rdstr);
          aCharData^.HaveItemArr[i].CurDurability := _StrToInt (rdstr);
          aCharData^.HaveItemArr[i].Upgrade := _StrToInt (rdstr);
          aCharData^.HaveItemArr[i].AddType := _StrToInt (rdstr);
          // add by Orber at 2004-09-08 10:40
          aCharData^.HaveItemArr[i].rLockState := StrToInt (rdstr);
          aCharData^.HaveItemArr[i].runLockTime := StrToInt (rdstr);
          continue;
      end;
      str := ItemClass.GetWearItemString (HaveItemArr[i]);
      str := GetValidStr3 (str, rdstr, ':');
      StrPCopy (@aCharData^.HaveItemArr[i].Name, rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      aCharData^.HaveItemArr[i].Color := _StrToInt (rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      aCharData^.HaveItemArr[i].Count := _StrToInt (rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      aCharData^.HaveItemArr[i].Durability := _StrToInt (rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      aCharData^.HaveItemArr[i].CurDurability := _StrToInt (rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      aCharData^.HaveItemArr[i].Upgrade := _StrToInt (rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      aCharData^.HaveItemArr[i].AddType := _StrToInt (rdstr);
      // add by Orber at 2004-09-08 10:40
      str := GetValidStr3 (str, rdstr, ':');
      aCharData^.HaveItemArr[i].rLockState := StrToInt (rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      aCharData^.HaveItemArr[i].runLockTime := StrToInt (rdstr);


   end;
end;
// add by Orber at 2004-09-07 18:52
procedure THaveItemClass.SaveOneToSdb (rkey:byte; aCharData : PTDBRecord);
begin
    aCharData^.HaveItemArr[rkey].runLockTime := HaveItemArr[rkey].runLockTime;
    aCharData^.HaveItemArr[rkey].rLockState := HaveItemArr[rkey].rLockState;
end;

function  THaveItemClass.FreeSpace: integer;
var
   i: integer;
begin
   Result := 0;
   for i := 0 to HAVEITEMSIZE - 1 do begin
      if HaveItemArr[i].rName[0] = 0 then Result := Result + 1;
   end;
end;

function  THaveItemClass.boHaveGradeQuestItem : boolean;
var
   i : integer;
begin
   Result := false;
   for i := 0 to HAVEITEMSIZE - 1 do begin
      if HaveItemArr[i].rName[0] = 0 then continue;
      if HaveItemArr[i].rKind = ITEM_KIND_GRADEUPQUESTITEM then begin
         Result := true;
         exit;
      end;
   end;
end;

function  THaveItemClass.CheckHaveQuestItem(aQuestNum: integer) : boolean;
var
   i : integer;
begin
   Result := false;
   for i := 0 to HAVEITEMSIZE - 1 do begin
      if HaveItemArr[i].rName[0] = 0 then continue;
      if HaveItemArr[i].rQuestNum = aQuestNum then begin
         Result := true;
         exit;
      end;
   end;
end;

function  THaveItemClass.ViewItem (akey: integer; aItemData: PTItemData): Boolean;
begin
   FillChar (aItemData^, sizeof(TItemData), 0);
   Result := FALSE;

   if boLocked = true then exit;

   if (akey < 0) or (akey > HAVEITEMSIZE-1) then exit;
   if HaveItemArr[akey].rName[0] = 0 then exit;
   Move (HaveItemArr[akey], aItemData^, SizeOf (TItemData));
   
   Result := TRUE;
end;

function THaveItemClass.GetItemByKey ( aKey : integer ) : PTItemData;
begin
   Result := nil;
   if ( aKey < 0 ) or ( aKey > HAVEITEMSIZE - 1) then exit;

   Result := @HaveItemArr[aKey];
end;


function  THaveItemClass.FindItem (aItemData : PTItemData): Boolean;
var
   i : integer;
begin
   Result := false;
   for i := 0 to HAVEITEMSIZE-1 do begin
      if StrPas (@HaveItemArr[i].rName) = StrPas (@aItemData^.rName) then begin
         if HaveItemArr[i].rUpgrade = aItemData^.rUpgrade then begin
            if HaveItemArr[i].rAddType = aItemData^.rAddType then begin
               if HaveItemArr[i].rCount >= aItemData^.rCount then begin
                  if HaveItemArr [i].rKind = aItemData^.rKind then begin
                     Result := true;
                     exit;
                  end;
               end;
            end;
         end;
      end;
   end;
end;


function  THaveItemClass.FindItembyCount (aItemData : PTItemData; aCount, aOption : Integer): Boolean;
var
   i : integer;
begin
   Result := false;
   for i := 0 to HAVEITEMSIZE-1 do begin
      if StrPas (@HaveItemArr[i].rName) = StrPas (@aItemData^.rName) then begin
         if aOption = 0 then begin
            if HaveItemArr[i].rUpgrade = aItemData^.rUpgrade then begin
               if HaveItemArr[i].rAddType = aItemData^.rAddType then begin
                  if HaveItemArr[i].rCount >= aCount then begin
                     Result := true;
                     exit;
                  end;
               end;
            end;
         end else if aOption = 1 then begin
            if HaveItemArr[i].rCount >= aCount then begin
               Result := true;
               exit;
            end;
         end;
      end;
   end;
end;

function THaveItemClass.FindAllItembyKind (aKind : Integer) : Integer;
var
   i, nCount : Integer;
begin
   Result := 0;

   nCount := 0;
   for i := 0 to HAVEITEMSIZE-1 do begin
      if HaveItemArr[i].rkind = akind then begin
         inc (nCount);
      end;
   end;

   if nCount > 0 then Result := nCount;
end;

function THaveItemClass.FindKindItem (akind: integer): integer;
var
   i : integer;
begin
   Result := -1;
   for i := 0 to HAVEITEMSIZE-1 do begin
      if HaveItemArr[i].rkind = akind then begin
         Result := i;
         exit;
      end;
   end;
end;

function THaveItemClass.FindAttribKindItem (aAttribkind: integer): integer;
var
   i : integer;
begin
   Result := -1;
   for i := 0 to HAVEITEMSIZE-1 do begin
      if HaveItemArr[i].rAttribute = aAttribkind then begin
         Result := i;
         exit;
      end;
   end;
end;

function THaveItemClass.FindSpecialKindItem (aSKind : Integer) : Integer;
var
   i : integer;
begin
   Result := -1;
   for i := 0 to HAVEITEMSIZE-1 do begin
      if HaveItemArr[i].rSpecialKind = aSKind then begin
         Result := i;
         exit;
      end;
   end;
end;

function  THaveItemClass.FindItemByMagicKind (aKind: integer): integer;
var
   i : integer;
begin
   Result := -1;
   for i := 0 to HAVEITEMSIZE - 1 do begin
      if aKind = MAGICTYPE_WRESTLING then begin
         if HaveItemArr[i].rName[0] = 0 then begin
            Result := i;
            exit;
         end;
      end;
      if (HaveItemArr[i].rName[0] <> 0) and
         (HaveItemArr[i].rWearArr = ARR_WEAPON) and
         (HaveItemArr[i].rHitType = aKind) and
         (HaveItemArr[i].rKind = ITEM_KIND_WEARITEM) then begin
         Result := i;
         exit;
      end;
   end;
end;

function THaveItemClass.FindNoPowerItemByMagicKind (aKind : Integer) : Integer;
var
   i : integer;
begin
   Result := -1;
   for i := 0 to HAVEITEMSIZE - 1 do begin
      if aKind = MAGICTYPE_WRESTLING then begin
         if HaveItemArr[i].rName[0] = 0 then begin
            Result := i;
            exit;
         end;
      end;
      if (HaveItemArr[i].rName[0] <> 0) and
         (HaveItemArr[i].rWearArr = ARR_WEAPON) and
         (HaveItemArr[i].rHitType = aKind) and
         (HaveItemArr[i].rKind = ITEM_KIND_WEARITEM) and
         (HaveItemArr[i].rboPower = false) then begin
         Result := i;
         exit;
      end;
   end;
end;

function THaveItemClass.FindItemKeybyName (aName : String) : Integer;
var
   i : Integer;
begin
   Result := -1;

   for i := 0 to HAVEITEMSIZE - 1 do begin
      if StrPas (@HaveItemArr [i].rName) = aName then begin
         Result := i;
         exit;
      end; 
   end;
end;

function THaveItemClass.FindItembyKindAttrib (aKind, aAttrib : integer) : PTItemData;
var
   i : integer;
begin
   Result := nil;
   
   for i := 0 to HAVEITEMSIZE - 1 do begin
      if (HaveItemArr[i].rKind = aKind) and (HaveItemArr[i].rAttribute = aAttrib) then begin
         Result := @HaveItemArr [i];
         exit;
      end;
   end;
end;

function THaveItemClass.FindItemCountbyName (aItemName : String) : Integer;
var
   i : Integer;
begin
   Result := 0;

   for i := 0 to HAVEITEMSIZE - 1 do begin
      if StrPas (@HaveItemArr [i].rName) = aItemName then begin
         Result := Result + HaveItemArr [i].rCount;
      end;
   end;
end;

function THaveItemClass.FindItemByName (aName : String) : Boolean;
var
   i : Integer;
begin
   Result := false;
   for i := 0 to HAVEITEMSIZE - 1 do begin
      if StrPas (@HaveItemArr[i].rName) = aName then begin
         Result := true;
         exit;
      end;
   end;
end;

function THaveItemClass.FindKeyExchangeItem (aKey : Integer; aExchangeItemData : PTExchangeItem) : Boolean;
begin
   Result := false;

   if StrPas (@HaveItemArr [aKey].rName) = aExchangeItemData^.rItemName then begin
      if HaveItemArr [aKey].rcolor = aExchangeItemData^.rcolor then begin
         if HaveItemArr [aKey].rCount >= aExchangeItemData^.rItemCount then begin
            if HaveItemArr [aKey].rCurDurability = aExchangeItemData^.rCurDurability then begin
               if HaveItemArr [aKey].rDurability = aExchangeItemData^.rDurability then begin
                  if HaveItemArr [aKey].rUpgrade = aExchangeItemData^.rUpgrade then begin
                     if HaveItemArr [aKey].rAddType = aExchangeItemData^.rAddType then begin
                            Result := true;
                            exit;
                     end;
                  end;
               end;
            end;
         end;
      end;
   end; 
end;

function  THaveItemClass.AddKeyItem (aKey : Integer; var aItemData: TItemData): Boolean;
var
   i : Integer;
   nPos, nCount : Integer;
begin
   Result := FALSE;

   if boLocked = true then exit;
   if (aKey < 0) or (aKey > HAVEITEMSIZE - 1) then exit;
   if aItemData.rName[0] = 0 then exit;
   if CheckAddable (aItemData) = -1 then exit;

   nPos := aKey;
   for i := 0 to HAVEITEMSIZE - 1 do begin
      if StrPas (@HaveItemArr[i].rName) = StrPas (@aItemData.rName) then begin
         if (HaveItemArr[i].rAddType = aItemData.rAddType) and
            (HaveItemArr[i].rUpgrade = aItemData.rUpgrade) and
            (HaveItemArr[i].rcolor = aItemData.rcolor) then
         begin
            if HaveItemArr[i].rboDouble = true then begin
               nPos := i;
               break;
            end;
         end;
      end;
   end;

   if HaveItemArr[nPos].rName[0] <> 0 then begin
      if StrPas (@HaveItemArr[nPos].rName) <> StrPas (@aItemData.rName) then exit;
      if HaveItemArr[nPos].rUpgrade <> aItemData.rUpgrade then exit;
      if HaveItemArr[nPos].rAddType <> aItemData.rAddType then exit;      
      if aItemData.rboDouble = false then exit;
      HaveItemArr[nPos].rCount := HaveItemArr[nPos].rCount + aItemData.rCount;
      // add by Orber at 2004-09-08 21:35
      if (HaveItemArr[nPos].rLockState = 1) or (aItemData.rLockState = 1) then begin
        aItemData.rLockState := 1;
        HaveItemArr[nPos].rLockState := 1;
      end else if (HaveItemArr[nPos].rLockState = 2) or (aItemData.rLockState = 2) then begin
        aItemData.rLockState := 2;
        HaveItemArr[nPos].rLockState := 2;
      end;

   end else begin
      HaveItemArr [nPos] := aItemData;
      if FAttribClass <> nil then begin
         Case HaveItemArr[nPos].rKind of
            ITEM_KIND_CHARM : begin
               if HaveItemArr[nPos].rboDurability then begin
                  HaveItemArr[nPos].rDecTick := mmAnsTick;
               end;
               FboAttribData := true;
            end;
            ITEM_KIND_SUBITEM : begin
               if TUser (FBasicObject).GetWeaponItemAttrib = HaveItemArr[nPos].rAttribute then begin
                  nCount := FindAllItembyKind (ITEM_KIND_SUBITEM);
                  if nCount = 1 then begin
                     GatherLifeData (FAttribClass.HaveItemLifeData, HaveItemArr [nPos].rLifeData);
                     SetLifeData;
                  end;
               end;
            end;
            ITEM_KIND_WATERCASE : begin
               if HaveItemArr[nPos].rCurDurability > 0 then begin
                  WaterCaseItemCount := 1;
               end;
            end;
            ITEM_KIND_FILL : begin
               if HaveItemArr [nPos].rCurDurability > 0 then begin
                  FillItemCount := 1;
               end;
            end;
            ITEM_KIND_SPECIALEFFECT : begin
               nCount := FindAllItembyKind (ITEM_KIND_SPECIALEFFECT);
               if nCount = 1 then begin
                  GatherLifeData (FAttribClass.HaveItemLifeData, HaveItemArr [nPos].rLifeData);
                  SetLifeData;
               end;
            end;
            ITEM_KIND_EIGHTANGLES : begin
               FillChar (AddAttribLifeData, sizeof(TRealAddAttribData), 0);   // 迫阿鲍
               GatherAddAttribLifeData (AddAttribLifeData, HaveItemArr[nPOs].rAddAttribData, TUserObject (FBasicObject).PowerLevel);
               GatherLifeData (FAttribClass.HaveItemLifeData, HaveItemArr [nPos].rLifeData);
               SetLifeData;
            end;
         end;
      end;
   end;

   FSendClass.SendHaveItem (nPos, HaveItemArr [nPos]);
   ReQuestPlaySoundNumber := HaveItemArr[nPos].rSoundEvent.rWavNumber;

   Result := true;
end;

function THaveItemClass.AddItem  (var aItemData: TItemData): Boolean;
var
   i, nCount, LimitCount : integer;
   str : String;
begin
   Result := FALSE;                         

   if boLocked = true then exit;
   if CheckAddable (aItemData) = -1 then exit;

   if (NATION_VERSION = NATION_CHINA_1) or (NATION_VERSION = NATION_CHINA_1_TEST) then begin
      LimitCount := 250;
   end else begin
      LimitCount := 100;
   end;

   if aItemData.rboDouble then begin
      for i := 0 to HAVEITEMSIZE - 1 do begin
         if StrPas (@HaveItemArr[i].rName) <> StrPas (@aItemData.rName) then continue;
         if HaveItemArr[i].rColor <> aItemData.rcolor then continue;
         if HaveItemArr[i].rUpgrade <> aItemData.rUpgrade then continue;
         if HaveItemArr[i].rAddType <> aItemData.rAddType then continue;         

         HaveItemArr[i].rCount := HaveItemArr[i].rCount + aItemData.rCount;
         FSendClass.SendHaveItem (i, HaveItemArr[i]);
         ReQuestPlaySoundNumber := HaveItemArr[i].rSoundEvent.rWavNumber;

         if (aItemData.rPrice * aItemData.rCount >= LimitCount) or (aItemData.rcolor <> 1) then begin
            if (FUserName <> '') and (aItemData.rOwnerName[0] <> 0) then begin
               str := StrPas (@aItemData.rOwnerName) + ',' +
                  FUserName + ',' + StrPas (@aItemData.rName) + ':' +
                  IntToStr (aItemData.rUpgrade) + ':' + IntToStr (aItemData.rAddType) + ',' +
                  IntToStr (aItemData.rCount) + ',' +
                  IntToStr(aItemData.rOwnerServerID) + ',' +
                  IntToStr(aItemData.rOwnerX) + ',' +
                  IntToStr(aItemData.rOwnerY) + ',' +
                  StrPas (@aItemData.rOwnerIP) + ',';
               FSendClass.SendItemMoveInfo (str, '');
            end;
         end;
         Result := TRUE;
         exit;
      end;
   end;

   for i := 0 to HAVEITEMSIZE - 1 do begin
      if HaveItemArr[i].rName[0] = 0 then begin
         Move (aItemData, HaveItemArr[i], SizeOf (TItemData));

         //CopyHaveItem俊辑狼 Add绰 绊妨窍瘤 臼绰促.
         if FAttribClass <> nil then begin
            Case HaveItemArr[i].rKind of
               ITEM_KIND_CHARM : begin
                  if HaveItemArr[i].rboDurability then begin
                     HaveItemArr[i].rDecTick := mmAnsTick;
                  end;
                  FboAttribData := true;
               end;
               ITEM_KIND_SUBITEM : begin
                  if TUser (FBasicObject).GetWeaponItemAttrib = HaveItemArr[i].rAttribute then begin
                     nCount := FindAllItembyKind (ITEM_KIND_SUBITEM);
                     if nCount = 1 then begin
                        GatherLifeData (FAttribClass.HaveItemLifeData, HaveItemArr [i].rLifeData);
                        SetLifeData;
                     end;
                  end;
               end;
               ITEM_KIND_WATERCASE : begin
                  if HaveItemArr[i].rCurDurability > 0 then begin
                     WaterCaseItemCount := 1;
                  end;
               end;
               ITEM_KIND_FILL : begin
                  if HaveItemArr [i].rCurDurability > 0 then begin
                     FillItemCount := 1;
                  end;
               end;
               ITEM_KIND_SPECIALEFFECT : begin
                  nCount := FindAllItembyKind (ITEM_KIND_SPECIALEFFECT);
                  if nCount = 1 then begin
                     GatherLifeData (FAttribClass.HaveItemLifeData, HaveItemArr [i].rLifeData);
                     SetLifeData;
                  end;
               end;
               ITEM_KIND_EIGHTANGLES : begin
                  FillChar (AddAttribLifeData, sizeof(TRealAddAttribData), 0);   // 迫阿鲍
                  GatherAddAttribLifeData (AddAttribLifeData, HaveItemArr[i].rAddAttribData, TUserObject (FBasicObject).PowerLevel);
                  GatherLifeData (FAttribClass.HaveItemLifeData, HaveItemArr [i].rLifeData);
                  SetLifeData;
               end;
            end;
         end;

         FSendClass.SendHaveItem (i, HaveItemArr[i]);
         ReQuestPlaySoundNumber := HaveItemArr[i].rSoundEvent.rWavNumber;

         if (aItemData.rPrice * aItemData.rCount >= LimitCount) or (aItemData.rcolor <> 1) then begin
            if (FUserName <> '') and (aItemData.rOwnerName[0] <> 0) then begin
               str := StrPas (@aItemData.rOwnerName) + ',' +
                  FUserName + ',' + StrPas (@aItemData.rName) + ':' +
                  IntToStr (aItemData.rUpgrade) + ':' + IntToStr (aItemData.rAddType) + ',' +
                  IntToStr (aItemData.rCount) + ',' +
                  IntToStr(aItemData.rOwnerServerID) + ',' +
                  IntToStr(aItemData.rOwnerX) + ',' +
                  IntToStr(aItemData.rOwnerY) + ',' +
                  StrPas (@aItemData.rOwnerIP) + ',';
               FSendClass.SendItemMoveInfo (str, '');
            end;
         end;
         Result := TRUE;
         exit;
      end;
   end;
end;

procedure THaveItemClass.SetAttribData;
var
   i : integer;
   tmpAttribData : TAttribData;
begin
   if FAttribClass = nil then exit;
   
   FillChar (tmpAttribData, sizeof(TAttribData) , 0);
   for i := 0 to HAVEITEMSIZE - 1 do begin
      if HaveItemArr [i].rKind <> ITEM_KIND_CHARM then continue;
      if HaveItemArr [i].rSpecialKind = ITEM_SPKIND_ADDALLLIFE then begin
         tmpAttribData.cHeadSeak := tmpAttribData.cHeadSeak + HaveItemArr [i].cLife;
         tmpAttribData.cArmSeak := tmpAttribData.cArmSeak + HaveItemArr [i].cLife;
         tmpAttribData.cLegSeak := tmpAttribData.cLegSeak + HaveItemArr [i].cLife;         
      end;
      tmpAttribData.cLife := tmpAttribData.cLife + HaveItemArr[i].cLife;
   end;

   FAttribClass.SetHaveItemAttribData(tmpAttribData);
end;

procedure THaveItemClass.SetLifeData;
begin
   if FAttribClass = nil then exit;

   TUserObject (FBasicObject).SetLifeData;
end;

procedure THaveItemClass.SetWaterCaseItemCount;
var
   pos : integer;
begin
   WaterCaseItemCount := 0;
   
   pos := FindKindItem (ITEM_KIND_WATERCASE);
   if pos <> -1 then begin
      if HaveItemArr[pos].rCurDurability > 0 then begin
         WaterCaseItemCount := 1;
      end;
   end;
end;

procedure THaveItemClass.SetFillItemCount;
var
   pos : integer;
begin
   FillItemCount := 0;

   pos := FindKindItem (ITEM_KIND_FILL);
   if pos <> -1 then begin
      if HaveItemArr[pos].rCurDurability > 0 then begin
         FillItemCount := 1;
      end;
   end;
end;

procedure THaveItemClass.SetEffectItemLifeData;
var
   pos, nCount : Integer;
begin
   if FAttribClass = nil then exit;
   FillChar (FAttribClass.HaveItemLifeData, SizeOf (TLifeData), 0);

   pos := FindKindItem (ITEM_KIND_SPECIALEFFECT);
   if pos <> -1 then begin
      GatherLifeData (FAttribClass.HaveItemLifeData, HaveItemArr [pos].rLifeData);
   end;

   pos := FindKindItem (ITEM_KIND_EIGHTANGLES);
   if pos <> -1 then begin
      if HaveItemArr [pos].rCurDurability <> 0 then begin
         GatherLifeData (FAttribClass.HaveItemLifeData, HaveItemArr [pos].rLifeData);
      end;
   end;
   
   pos := FindKindItem (ITEM_KIND_SUBITEM);
   if pos <> -1 then begin
      if TUser (FBasicObject).GetWeaponItemAttrib = HaveItemArr[Pos].rAttribute then begin
         nCount := FindAllItembyKind (ITEM_KIND_SUBITEM);
         if nCount = 1 then begin
            GatherLifeData (FAttribClass.HaveItemLifeData, HaveItemArr [Pos].rLifeData);
         end;
      end;
   end;
end;

function  THaveItemClass.DeleteKeyItem (akey, aCount: integer; aItemData : PTItemData): Boolean;
var
   nCount, LimitCount : Integer;
begin
   Result := FALSE;

   if boLocked = true then exit;
   if (akey < 0) or (akey > HAVEITEMSIZE - 1) then exit;

   if (NATION_VERSION = NATION_CHINA_1) or (NATION_VERSION = NATION_CHINA_1_TEST) then begin
      LimitCount := 250;
   end else begin
      LimitCount := 100;
   end;

   if (aItemData^.rPrice * aItemData^.rCount >= LimitCount) or (aItemData^.rcolor <> 1) then begin
      if (FUserName <> '') and (aItemData^.rOwnerName[0] <> 0) then begin
         FSendClass.SendItemMoveInfo (FUserName + ',' + StrPas(@aItemData^.rOwnerName) + ',' +
            StrPas(@aItemData^.rName) + ':' + IntToStr (aItemData^.rUpgrade) + ':' + IntToStr (aItemData^.rAddType) + ',' +
            IntToStr(aItemData^.rCount) + ',' + IntToStr(aItemData^.rOwnerServerID) + ',' +
            IntToStr(aItemData^.rOwnerX) + ',' + IntToStr(aItemData^.rOwnerY) + ',' + StrPas (@aItemData^.rOwnerIP) + ',', '');
      end;
   end;

   HaveItemArr[akey].rCount := HaveItemArr[akey].rCount - aCount;
   if HaveItemArr [aKey].rCount <= 0 then begin
      if FAttribClass <> nil then begin
         Case HaveItemArr [akey].rKind of
            ITEM_KIND_CHARM : FboAttribData := true;
            ITEM_KIND_SUBITEM : begin
               nCount := FindAllItembyKind (ITEM_KIND_SUBITEM);
               if nCount = 1 then begin
                  FillChar (FAttribClass.HaveItemLifeData, SizeOf (TLifeData), 0);
                  //SetEffectItemLifeData;
                  SetLifeData;
               end;
            end;
            ITEM_KIND_WATERCASE : WaterCaseItemCount := 0;
            ITEM_KIND_FILL : FillItemCount := 0;
            ITEM_KIND_SPECIALEFFECT : begin
               nCount := FindAllItembyKind (ITEM_KIND_SPECIALEFFECT);
               if nCount = 1 then begin
                  FillChar (FAttribClass.HaveItemLifeData, SizeOf (TLifeData), 0);
                  //SetEffectItemLifeData;
                  SetLifeData;
               end;
            end;
            ITEM_KIND_EIGHTANGLES : begin
               FillChar (AddAttribLifeData, sizeof(TRealAddAttribData), 0);   // 迫阿鲍
               FillChar (FAttribClass.HaveItemLifeData, SizeOf (TLifeData), 0);
               //SetEffectItemLifeData;
               SetLifeData;
            end;
         end;
      end;

      FillChar (HaveItemArr [aKey], SizeOf (TItemData), 0);
   end;

   FSendClass.SendHaveItem (aKey, HaveItemArr[akey]);

   Result := TRUE;
end;

function THaveItemClass.DeleteItem (aIndex : integer) :Boolean;
var
   aItemData : PTItemData;
   nCount, LimitCount : Integer;
begin
   Result := false;
   if ( aIndex > HAVEITEMSIZE - 1 ) or ( aIndex < 0 ) then exit;

   aItemData := @HaveItemArr[aIndex];

   if (NATION_VERSION = NATION_CHINA_1) or (NATION_VERSION = NATION_CHINA_1_TEST) then begin
      LimitCount := 250;
   end else begin
      LimitCount := 100;
   end;

   if (aItemData^.rPrice * aItemData^.rCount >= LimitCount) or (aItemData^.rcolor <> 1) then begin
      if (FUserName <> '') and (aItemData^.rOwnerName[0] <> 0) then begin
         FSendClass.SendItemMoveInfo (FUserName + ',' + StrPas(@aItemData^.rOwnerName) + ',' +
            StrPas(@aItemData^.rName) + ':' + IntToStr (aItemData^.rUpgrade) + ':' + IntToStr (aItemData^.rAddType) + ',' +
            IntToStr(aItemData^.rCount) + ',' + IntToStr(aItemData^.rOwnerServerID) + ',' +
            IntToStr(aItemData^.rOwnerX) + ',' + IntToStr(aItemData^.rOwnerY) + ',' + StrPas (@aItemData^.rOwnerIP) + ',', '');
      end;
   end;

   if FAttribClass <> nil then begin
      Case HaveItemArr [aIndex].rKind of
         ITEM_KIND_CHARM : FboAttribData := true;
         ITEM_KIND_SUBITEM : begin
            nCount := FindAllItembyKind (ITEM_KIND_SUBITEM);
            if nCount = 1 then begin
               FillChar (FAttribClass.HaveItemLifeData, SizeOf (TLifeData), 0);
               //SetEffectItemLifeData;
               SetLifeData;
            end;
         end;
         ITEM_KIND_WATERCASE : WaterCaseItemCount := 0;
         ITEM_KIND_FILL : FillItemCount := 0;
         ITEM_KIND_SPECIALEFFECT : begin
            nCount := FindAllItembyKind (ITEM_KIND_SPECIALEFFECT);
            if nCount = 1 then begin
               FillChar (FAttribClass.HaveItemLifeData, SizeOf (TLifeData), 0);
               //SetEffectItemLifeData;
               SetLifeData;
            end;
         end;
         ITEM_KIND_EIGHTANGLES : begin
            FillChar (AddAttribLifeData, sizeof(TRealAddAttribData), 0);   // 迫阿鲍
            FillChar (FAttribClass.HaveItemLifeData, SizeOf (TLifeData), 0);
            //SetEffectItemLifeData;
            SetLifeData;
         end;
      end;
   end;
   FillChar (HaveItemArr[aIndex], sizeof(TItemData), 0);
   FSendClass.SendHaveItem (aIndex, HaveItemArr[aIndex]);
end;

procedure THaveItemClass.DeleteQuestItem;
var
   i : integer;
   tempList : TList;
   pIndex : ^Integer;
begin
   if FAttribClass = nil then exit;

   tempList := TList.Create;

   for i := 0 to HAVEITEMSIZE - 1 do begin
      if (HaveItemArr[i].rKind = ITEM_KIND_QUESTITEM) or
         (HaveItemArr[i].rKind = ITEM_KIND_QUESTITEM2) or
         (HaveItemArr[i].rKind = ITEM_KIND_QUESTLOG) or
         (HaveItemArr[i].rKind = ITEM_KIND_CHARM) then
      begin
         if HaveItemArr[i].rKind = ITEM_KIND_CHARM then begin
            FboAttribData := true;
         end;

         new (pIndex);
         pIndex^ := i; 
         tempList.Add(pIndex);
      end;
   end;

   for i := 0 to tempList.Count - 1 do begin
      pIndex := tempList.Items[i];
      FillChar (HaveItemArr[pIndex^],sizeof(TItemData), 0);
      FSendClass.SendHaveItem (pIndex^, HaveItemArr[pIndex^]);
   end;

   for i := 0 to tempList.Count - 1 do begin
      pIndex := tempList.Items[i];
      dispose (pIndex);
   end;
   tempList.Free;
end;

procedure THaveItemClass.DeleteAllItem;
var
   i : Integer;
begin
   if FAttribClass = nil then exit;

   for i := 0 to HAVEITEMSIZE - 1 do begin
      Case HaveItemArr [i].rKind of
         ITEM_KIND_CHARM : if FboAttribData <> true then FboAttribData := true;
         ITEM_KIND_SUBITEM : begin
            FillChar (FAttribClass.HaveItemLifeData, SizeOf (TLifeData), 0);
            //SetEffectItemLifeData;
            SetLifeData;
         end;
         ITEM_KIND_WATERCASE : if WaterCaseItemCount <> 0 then WaterCaseItemCount := 0;
         ITEM_KIND_FILL : if FillItemCount <> 0 then FillItemCount := 0;
         ITEM_KIND_SPECIALEFFECT : begin
            FillChar (FAttribClass.HaveItemLifeData, SizeOf (TLifeData), 0);
            //SetEffectItemLifeData;
            SetLifeData;
         end;
         ITEM_KIND_EIGHTANGLES : begin
            FillChar (AddAttribLifeData, sizeof(TRealAddAttribData), 0);   // 迫阿鲍
            FillChar (FAttribClass.HaveItemLifeData, SizeOf (TLifeData), 0);
            //SetEffectItemLifeData;
            SetLifeData;
         end;
      end;

      FillChar (HaveItemArr [i], SizeOf (TItemData), 0);
      FSendClass.SendHaveItem (i, HaveItemArr[i]);
   end;
end;

function  THaveItemClass.DeleteItem (aItemData: PTItemData): Boolean;
var
   i, LimitCount : integer;
begin
   Result := FALSE;

   if (NATION_VERSION = NATION_CHINA_1) or (NATION_VERSION = NATION_CHINA_1_TEST) then begin
      LimitCount := 250;
   end else begin
      LimitCount := 100;
   end;

   if boLocked = true then exit;
   for i := 0 to HAVEITEMSIZE-1 do begin
      if StrPas (@HaveItemArr[i].rName) = StrPas (@aItemData^.rName) then begin
         if HaveItemArr[i].rUpgrade = aItemData^.rUpgrade then begin
            if HaveItemArr[i].rAddType = aItemData^.rAddType then begin
               if HaveItemArr[i].rCount < aItemData^.rCount then aItemData^.rCount := HaveItemArr[i].rCount;
               if HaveItemArr[i].rCount >= aItemData^.rCount then begin
                  if (aItemData^.rPrice * aItemData^.rCount >= LimitCount) or (aItemData^.rcolor <> 1) then begin
                     if (FUserName <> '') and (aItemData^.rOwnerName[0] <> 0) then begin
                        FSendClass.SendItemMoveInfo (FUserName + ',' + StrPas(@aItemData^.rOwnerName) + ',' + StrPas(@aItemData^.rName) + ':' + IntToStr (aItemData^.rUpgrade) + ':' + IntToStr (aItemData^.rAddType) + ',' + IntToStr(aItemData^.rCount)
                        + ',' + IntToStr(aItemData^.rOwnerServerID) + ',' + IntToStr(aItemData^.rOwnerX) + ',' + IntToStr(aItemData^.rOwnerY) + ',' + StrPas (@aItemData^.rOwnerIP) + ',', '');
                     end;
                  end;

                  Case HaveItemArr [i].rKind of
                     ITEM_KIND_CHARM : FboAttribData := true;
                     ITEM_KIND_SUBITEM : begin
                        FillChar (FAttribClass.HaveItemLifeData, SizeOf (TLifeData), 0);
                        //SetEffectItemLifeData;
                        SetLifeData;
                     end;
                     ITEM_KIND_WATERCASE : WaterCaseItemCount := 0;
                     ITEM_KIND_FILL : FillItemCount := 0;
                     ITEM_KIND_SPECIALEFFECT : begin
                        FillChar (FAttribClass.HaveItemLifeData, SizeOf (TLifeData), 0);
                        //SetEffectItemLifeData;
                        SetLifeData;
                     end;
                     ITEM_KIND_EIGHTANGLES : begin
                        FillChar (AddAttribLifeData, sizeof(TRealAddAttribData), 0);   // 迫阿鲍
                        FillChar (FAttribClass.HaveItemLifeData, SizeOf (TLifeData), 0);
                        //SetEffectItemLifeData;
                        SetLifeData;
                     end;
                  end;
               
                  HaveItemArr[i].rCount := HaveItemArr[i].rCount - aItemData.rCount;
                  if HaveItemArr[i].rCount = 0 then begin
                     FillChar (HaveItemArr[i], sizeof(TItemData), 0);
                  end;

                  FSendClass.SendHaveItem (i, HaveItemArr[i]);
                  Result := TRUE;
                  exit;
               end;
            end;
         end;
      end;
   end;
end;

function THaveItemClass.DeleteItembyName (aItemData : PTItemData) : Boolean;
var
   i, LimitCount : integer;
begin
   Result := FALSE;

   if (NATION_VERSION = NATION_CHINA_1) or (NATION_VERSION = NATION_CHINA_1_TEST) then begin
      LimitCount := 250;
   end else begin
      LimitCount := 100;
   end;

   if boLocked = true then exit;
   for i := 0 to HAVEITEMSIZE-1 do begin
      if StrPas (@HaveItemArr[i].rName) = StrPas (@aItemData^.rName) then begin
         if HaveItemArr[i].rCount >= aItemData^.rCount then begin
            if (aItemData^.rPrice * aItemData^.rCount >= LimitCount) or (aItemData^.rcolor <> 1) then begin
               if (FUserName <> '') and (aItemData^.rOwnerName[0] <> 0) then begin
                  FSendClass.SendItemMoveInfo (FUserName + ',' + StrPas(@aItemData^.rOwnerName) + ',' + StrPas(@aItemData^.rName) + ':' + IntToStr (aItemData^.rUpgrade) + ':' + IntToStr (aItemData^.rAddType) + ',' + IntToStr(aItemData^.rCount)
                  + ',' + IntToStr(aItemData^.rOwnerServerID) + ',' + IntToStr(aItemData^.rOwnerX) + ',' + IntToStr(aItemData^.rOwnerY) + ',' + StrPas (@aItemData^.rOwnerIP) + ',', '');
               end;
            end;

            Case HaveItemArr [i].rKind of
               ITEM_KIND_CHARM : FboAttribData := true;
               ITEM_KIND_SUBITEM : begin
                  FillChar (FAttribClass.HaveItemLifeData, SizeOf (TLifeData), 0);
                  //SetEffectItemLifeData;
                  SetLifeData;
               end;
               ITEM_KIND_WATERCASE : WaterCaseItemCount := 0;
               ITEM_KIND_FILL : FillItemCount := 0;
               ITEM_KIND_SPECIALEFFECT : begin
                  FillChar (FAttribClass.HaveItemLifeData, SizeOf (TLifeData), 0);
                  //SetEffectItemLifeData;
                  SetLifeData;
               end;
               ITEM_KIND_EIGHTANGLES : begin
                  FillChar (AddAttribLifeData, sizeof(TRealAddAttribData), 0);   // 迫阿鲍
                  SetEffectItemLifeData;
                  SetLifeData;
               end;
            end;

            HaveItemArr[i].rCount := HaveItemArr[i].rCount - aItemData.rCount;
            if HaveItemArr[i].rCount = 0 then begin
               FillChar (HaveItemArr[i], sizeof(TItemData), 0);
            end;

            FSendClass.SendHaveItem (i, HaveItemArr[i]);
            Result := TRUE;
            exit;
         end;
      end;
   end;
end;

function  THaveItemClass.ChangeItem (asour, adest: integer): Boolean;
var
   ItemData : TItemData;
begin
   Result := FALSE;
   if boLocked = true then exit;
   if (asour < 0) or (asour > HAVEITEMSIZE-1) then exit;
   if (adest < 0) or (adest > HAVEITEMSIZE-1) then exit;

   ItemData := HaveItemArr[asour];
   HaveItemArr[asour] := HaveItemArr[adest];
   HaveItemArr[adest] := ItemData;

   FSendClass.SendHaveItem (asour, HaveItemArr[asour]);
   FSendClass.SendHaveItem (adest, HaveItemArr[adest]);
   Result := TRUE;
end;

function THaveItemClass.AddableKey (aKey : Integer; aItemData : TItemData) : Boolean;
begin
   Result := false;

   if (aKey < 0) or (aKey > HAVEITEMSIZE - 1) then exit;
   if HaveItemArr [aKey].rName [0] <> 0 then begin
      if HaveItemArr [aKey].rboDouble = false then exit;

      if StrPas (@HaveItemArr [aKey].rName) <> StrPas (@aItemData.rName) then exit;
      if HaveItemArr [aKey].rcolor <> aItemData.rcolor then exit;
   end;

   Result := true;    
end;

function  THaveItemClass.CheckBlankAfterDelete (aKey, aCount : Integer) : Boolean;
begin
   Result := false;
   
   if (aKey < 0) or (aKey > HAVEITEMSIZE - 1) then exit;
   if HaveItemArr [aKey].rName [0] = 0 then exit;
   if HaveItemArr [aKey].rCount <> aCount then exit;

   Result := true;
end;

function  THaveItemClass.CheckAddable (var aItemData : TItemData) : Integer;
var
   i, iCount : Integer;
begin
   Result := -1;

   if (aItemData.rCount <= 0) or (aItemData.rCount > 100000000) then exit;

   for i := 0 to HAVEITEMSIZE - 1 do begin
      if aItemData.rboDouble = false then begin
         if HaveItemArr [i].rName [0] = 0 then begin
            Result := i;
            exit;
         end;
      end else begin
         if StrPas (@HaveItemArr [i].rName) = StrPas (@aItemData.rName) then begin
            if (HaveItemArr[i].rAddType = aItemData.rAddType) and
               (HaveItemArr[i].rColor = aItemData.rColor) and
               (HaveItemArr [i].rUpgrade = aItemData.rUpgrade) and
               (HaveItemArr [i].rboDouble = true) then
            begin
               iCount := HaveItemArr [i].rCount + aItemData.rCount;
               if (iCount <= 0) or (iCount > 100000000) then exit;
               Result := i;
               exit;
            end;
         end;
      end;
   end;

   if aItemData.rboDouble = true then begin
      for i := 0 to HAVEITEMSIZE - 1 do begin
         if HaveItemArr [i].rName [0] = 0 then begin
            Result := i;
            exit;
         end;
      end;
   end;
end;

function  THaveItemClass.HaveMoney : Integer;
var
   i : Integer;
begin
   Result := 0;

   for i := 0 to HAVEITEMSIZE - 1 do begin
      if HaveItemArr [i].rName [0] = 0 then continue;
      if StrPas (@HaveItemArr [i].rName) = INI_GOLD then begin
         Result := HaveItemArr [i].rCount;
         exit;
      end;
   end;
end;

function THaveItemClass.PayMoney (aPrice : Integer) : Boolean;
var
   i : Integer;
begin
   Result := false;

   for i := 0 to HAVEITEMSIZE - 1 do begin
      if HaveItemArr [i].rName [0] = 0 then continue;
      if StrPas (@HaveItemArr [i].rName) = INI_GOLD then begin
         if HaveItemArr [i].rCount >= aPrice then begin
            HaveItemArr [i].rCount := HaveItemArr [i].rCount - aPrice;
            if HaveItemArr [i].rCount <= 0 then begin
               FillChar (HaveItemArr [i], SizeOf (TItemData), 0);
            end;
            FSendClass.SendHaveItem (i, HaveItemArr[i]);
            Result := true;
            exit;
         end;
      end;
   end;
end;

procedure THaveItemClass.Refresh;
var
   i : Integer;
begin
   for i := 0 to HAVEITEMSIZE - 1 do begin
      FSendClass.SendHaveItem (i, HaveItemArr[i]);
   end;
   SetWaterCaseItemCount;
   SetFillItemCount;
   SetEffectItemLifeData;
   SetAttribData;
   SetLifeData;
end;

procedure THaveItemClass.ChangeItemProcess (pcDragDrop : PTCDragDrop; aShowWindowClass : TShowWindowClass);
begin
   if aShowWindowClass.AllowWindowAction (swk_none) = false then exit;
   ChangeItem (pcDragDrop^.rSourKey, pcDragDrop^.rDestKey);
end;

procedure THaveItemClass.DressOnProcess (pcDragDrop : PTCDragDrop; aShowWindowClass : TShowWindowClass; aWearItemClass : TWearItemClass; aHaveMagicClass :THaveMagicClass);
var
   ItemData : TItemData;
begin
   if aShowWindowClass.AllowWindowAction (swk_none) = false then exit;

   if ViewItem (pcDragDrop^.rsourkey, @ItemData) = FALSE then exit;

   if TUser (FBasicObject).Manager.boUsePowerItem = false then begin
      if ItemData.rboPower = true then begin
         FSendClass.SendChatMessage (Conv('不能使用技能造物品'), SAY_COLOR_SYSTEM);
         exit;
      end;
   end;
   if ItemData.rKind = ITEM_KIND_COLORDRUG then begin
      if aWearItemClass.AddColorDrug (pcDragDrop^.rDestKey, ItemData) = false then exit;
   end else begin
      if aWearItemClass.AddItem (ItemData, true) = false then exit;
   end;
   aHaveMagicClass.AddItemMagic(aWearItemClass);
   FillChar (ItemData, SizeOf (TItemData), 0);
   DeleteKeyItem (pcDragDrop^.rsourkey, 1, @ItemData);
end;

procedure THaveItemClass.PutOnExchangeProcess (pcDragDrop : PTCDragDrop; aShowWindowClass : TShowWindowClass);
var
   ItemData : TItemData;
begin
   // 肮荐甫 拱绢焊扁 傈俊 固府 八荤茄促 start
   if not ViewItem (pcDragDrop^.rsourkey, @ItemData) then exit;

   //2002-07-22 gil-tae
   if ( ItemData.rKind = ITEM_KIND_CANTMOVE ) or ( ItemData.rboNotExchange = true )then begin
      FSendClass.SendChatMessage (Conv('无法交换的物品'), SAY_COLOR_SYSTEM);
      exit;
   end;

   if aShowWindowClass.CheckExchangeBlankData (ItemData) = true then
      aShowWindowClass.ShowCountWindow (DRAGACTION_ADDEXCHANGEITEM, pcDragDrop, ItemData);
end;

procedure THaveItemClass.PutOnMaterialProcess (pcDragDrop : PTCDragDrop; aShowWindowClass : TShowWindowClass; aHaveJobClass : THaveJobClass);
var
   cSelectCount : TCSelectCount;
   ItemData : TItemData;
begin
   if not TUser (FBasicObject).AllowMaterialMove (swk_none) then exit;
   if pcDragDrop^.rDestKey > PRODUCT_KEY then exit;
   if not ViewItem (pcDragDrop^.rsourkey, @ItemData) then exit;
   if ItemData.rName [0] = 0 then exit;
   if ItemData.rLockState <> 0 then begin
      FSendClass.SendChatMessage (Conv('物品锁定中,无法升级.'), SAY_COLOR_SYSTEM);
      exit;
   end;
   if ItemData.rboNotSkill = true then begin
      FSendClass.SendChatMessage (Conv('此物品无法放入'), SAY_COLOR_SYSTEM);
      exit;
   end;

   if pcDragDrop^.rDestKey = PRODUCT_KEY then begin
      if ItemData.rMaxUpgrade = 0 then begin
         FSendClass.SendChatMessage (Conv('此物品无法放入'), SAY_COLOR_SYSTEM);
         exit;
      end;

      if aHaveJobClass.CheckProductBlankData = false then begin
         FSendClass.SendChatMessage (Conv('无法放入'), SAY_COLOR_SYSTEM);
         exit;
      end;

      {
      if DeleteKeyItem (pcDragDrop^.rsourkey, ItemData.rCount, @ItemData) = false then exit;

      ItemData.rCount := 1;
      if aHaveJobClass.AddKeymaterialItem (PRODUCT_KEY, ItemData) = false then exit;
      }
      cSelectCount.rboOk := true;
      cSelectCount.rsourkey := pcDragDrop^.rsourkey;
      cSelectCount.rdestkey := pcDragDrop^.rdestkey;
      cSelectCount.rCount := 1;
      cSelectCount.rCountid := DRAGACTION_FROMITEMTOSKILL;
      aShowWindowClass.CountWindowState := DRAGACTION_FROMITEMTOSKILL;
      aShowWindowClass.FCurrentWindow := swk_count;
      aShowWindowClass.SelectCount (@cSelectCount);
   end else begin
      {
      if (ItemData.rKind <> ITEM_KIND_MINERAL) and
         (ItemData.rKind <> ITEM_KIND_GROWTHHERB) and
         (ItemData.rKind <> ITEM_KIND_PROCESSDRUG) and
         (ItemData.rKind <> ITEM_KIND_HELPDRUG) and
         FSendClass.SendChatMessage (Conv('此物品无法放入'), SAY_COLOR_SYSTEM);
         exit;
      end;
      }
      if ItemData.rUpgrade <> 0 then begin
         FSendClass.SendChatMessage (Conv('已经加工完成的物品'), SAY_COLOR_SYSTEM);
      end;

      if aHaveJobClass.CheckMaterialBlankData (ItemData) = -1 then begin
         FSendClass.SendChatMessage (Conv('无法继续添加'), SAY_COLOR_SYSTEM);
         exit;
      end;

      if ItemData.rCount = 1 then begin
         cSelectCount.rboOk := true;
         cSelectCount.rsourkey := pcDragDrop^.rsourkey;
         cSelectCount.rdestkey := pcDragDrop^.rdestkey;
         cSelectCount.rCount := 1;
         cSelectCount.rCountid := DRAGACTION_FROMITEMTOSKILL;
         aShowWindowClass.CountWindowState := DRAGACTION_FROMITEMTOSKILL;
         aShowWindowClass.FCurrentWindow := swk_count;
         aShowWindowClass.SelectCount (@cSelectCount);
      end else begin
         aShowWindowClass.ShowCountWindow (DRAGACTION_FROMITEMTOSKILL, pcDragDrop, ItemData);
      end;
   end;

   SetWaterCaseItemCount;
   SetFillItemCount;
   SetEffectItemLifeData;
   SetAttribData;
   SetLifeData;
end;

procedure THaveItemClass.PutOnMarketProcess (pcDragDrop : PTCDragDrop; aShowWindowClass : TShowWindowClass; aHaveMarketClass : THaveMarketClass);
var
   ItemData : TItemData;
   nCount : Integer;   
begin
   if (NATION_VERSION = NATION_CHINA_1) or (NATION_VERSION = NATION_CHINA_1_TEST) then exit;
   
   if aHaveMarketClass.boMarketing = true then begin
      FSendClass.SendChatMessage (Conv('无法移动'), SAY_COLOR_SYSTEM);
      exit;
   end;

   if aShowWindowClass.AllowWindowAction (swk_none) = false then exit;

   if not ViewItem (pcDragDrop^.rsourkey, @ItemData) then exit;
   if ItemData.rName [0] = 0 then exit;
   if (ItemData.rboNotSsamzie = true) or (ItemData.rboNotTrade = true) or
      (ItemData.rboNotExchange = true) or (ItemData.rboNotDrop = true) or
      (ItemData.rboNotSkill = true) or (StrPas (@ItemData.rName) = INI_GOLD) then begin
      FSendClass.SendChatMessage (Conv('此物品无法放入'), SAY_COLOR_SYSTEM);
      exit;
   end;

   nCount := aHaveMarketClass.CheckAddableMarketData (ItemData);
   if nCount = -1 then begin
      FSendClass.SendChatMessage (Conv('无法继续添加'), SAY_COLOR_SYSTEM);
      exit;
   end;
   if nCount > aHaveMarketClass.FMarketCount then begin
      FSendClass.SendChatMessage (Conv('再放不进去了'), SAY_COLOR_SYSTEM);
      exit;
   end;

   aShowWindowClass.ShowMarketCountWindow (pcDragDrop, ItemData);
end;

procedure THaveItemClass.PutOnItemLogProcess (pcDragDrop : PTCDragDrop; aShowWindowClass : TShowWindowClass);
var
   cSelectCount : TCSelectCount;
   ret : Integer;
   ItemData : TItemData;
   Str : String;
begin
   if aShowWindowClass.FCurrentWindow <> swk_itemlog then begin
      str := aShowWindowClass.GetUserWindowStateStr;
      str := str + ',' + 'FromItemWindowToItemLog';
      aShowWindowClass.CopyHaveItem.Free;
      aShowWindowClass.CopyHaveItem := nil;
      frmMain.WriteBadUserLog(str);
      ConnectorList.CloseConnectByCharName (TUser (FBasicObject).Name);
      exit;
   end;

   if aShowWindowClass.CopyHaveItem = nil then begin
      frmMain.WriteLogInfo (format ('CopyHaveItem = nil, PutOnItemLogProcess, Name=%s', [StrPas (@FBasicObject.BasicData.Name)]));
      exit;
   end;
   if not aShowWindowClass.CopyHaveItem.ViewItem (pcDragDrop^.rsourkey, @ItemData) then exit;

   if ItemData.rboNotSsamzie = true then begin
      FSendClass.SendChatMessage(Conv('不能放入福袋的物品'),SAY_COLOR_SYSTEM);
      exit;
   end;

   if pcDragDrop^.rdestkey < 10 then ret := 0
   else if pcDragDrop^.rdestkey < 20 then ret := 1
   else if pcDragDrop^.rdestkey < 30 then ret := 2
   else ret := 3;
   if aShowWindowClass.ItemLogData[ret].Header.boUsed = false then exit;
   if aShowWindowClass.ItemLogData[ret].ItemData[pcDragDrop^.rdestkey mod 10].Name[0] <> 0 then begin
      if ItemData.rboDouble = false then exit;
      if StrPas (@aShowWindowClass.ItemLogData[ret].ItemData[pcDragDrop^.rdestkey mod 10].Name) <> StrPas (@ItemData.rName) then exit;
      if aShowWindowClass.ItemLogData[ret].ItemData[pcDragDrop^.rdestkey mod 10].Color <> ItemData.rColor then exit;
      if aShowWindowClass.ItemLogData[ret].ItemData[pcDragDrop^.rdestkey mod 10].Upgrade <> ItemData.rUpgrade then exit;
      if aShowWindowClass.ItemLogData[ret].ItemData[pcDragDrop^.rdestkey mod 10].AddType <> ItemData.rAddType then exit;
   end;

   if ItemData.rCount > 1 then begin
      aShowWindowClass.ShowCountWindow (DRAGACTION_FROMITEMTOLOG, pcDragDrop, ItemData);
//      FSendClass.SendShowCount (DRAGACTION_FROMITEMTOLOG, pcDragDrop^.rSourKey, pcDragDrop^.rDestKey, ItemData.rCount, StrPas (@ItemData.rViewName));
   end else begin
      cSelectCount.rboOk := true;
      cSelectCount.rsourkey := pcDragDrop^.rsourkey;
      cSelectCount.rdestkey := pcDragDrop^.rdestkey;
      cSelectCount.rCount := 1;
      cSelectCount.rCountid := DRAGACTION_FROMITEMTOLOG;
      aShowWindowClass.SelectCount (@cSelectCount);
   end;
end;

procedure THaveItemClass.PutOnGuildItemLogProcess (pcDragDrop : PTCDragDrop; aShowWindowClass : TShowWindowClass);
var
   cSelectCount : TCSelectCount;
   ret : Integer;
   ItemData : TItemData;
   Str : String;
   GuildObject : TGuildObject;
begin
   if aShowWindowClass.FCurrentWindow <> swk_itemlog then begin
      str := aShowWindowClass.GetUserWindowStateStr;
      str := str + ',' + 'FromItemWindowToGuildItemLog';
      frmMain.WriteBadUserLog(str);
      ConnectorList.CloseConnectByCharName (TUser (FBasicObject).Name);
      exit;
   end;

   BoLocked := False;

   if not ViewItem (pcDragDrop^.rsourkey, @ItemData) then exit;

   if ItemData.rboNotSsamzie = true then begin
      FSendClass.SendChatMessage(Conv('不能放入福袋的物品'),SAY_COLOR_SYSTEM);
      exit;
   end;

   GuildObject := GuildList.GetGuildObject(TUser (FBasicObject).GuildName);
   if GuildObject = nil then Exit;
   if Not GuildObject.IsGuildSysop(TUser (FBasicObject).Name) then Exit;

   if pcDragDrop^.rdestkey >= 80 then Exit;


   if GuildObject.FGuildItemLog.ItemData[pcDragDrop^.rdestkey].Name[0] <> 0 then begin
      if ItemData.rboDouble = false then exit;
      if StrPas (@GuildObject.FGuildItemLog.ItemData[pcDragDrop^.rdestkey].Name) <> StrPas (@ItemData.rName) then exit;
      if GuildObject.FGuildItemLog.ItemData[pcDragDrop^.rdestkey].Color <> ItemData.rColor then exit;
      if GuildObject.FGuildItemLog.ItemData[pcDragDrop^.rdestkey].Upgrade <> ItemData.rUpgrade then exit;
      if GuildObject.FGuildItemLog.ItemData[pcDragDrop^.rdestkey].AddType <> ItemData.rAddType then exit;
   end;


   if ItemData.rCount > 1 then begin
      aShowWindowClass.ShowCountWindow (DRAGACTION_FROMITEMTOGUILD, pcDragDrop, ItemData);
//      FSendClass.SendShowCount (DRAGACTION_FROMITEMTOLOG, pcDragDrop^.rSourKey, pcDragDrop^.rDestKey, ItemData.rCount, StrPas (@ItemData.rViewName));
   end else begin
      cSelectCount.rboOk := true;
      cSelectCount.rsourkey := pcDragDrop^.rsourkey;
      cSelectCount.rdestkey := pcDragDrop^.rdestkey;
      cSelectCount.rCount := 1;
      cSelectCount.rCountid := DRAGACTION_FROMITEMTOGUILD;
      aShowWindowClass.SelectCount (@cSelectCount);
   end;
end;


procedure THaveItemClass.PutOnScreenProcess (pcDragDrop : PTCDragDrop; aShowWindowClass : TShowWindowClass);
var
   ItemData, tmpItemData : TItemData;
   SubData : TSubData;
   BObject : TBasicObject;
   ret, Code : Integer;
   tmpBasicData : TBasicData;
   tmpExchangeData : TExchangeData;
   Monster : TMonster;
   nByte : Byte;
   GuildObject :TGuildObject;
   GuildUser : PTGuildUserData;
   GuildPos : String;
begin
   if aShowWindowClass.AllowWindowAction (swk_none) = false then exit;

   if ViewItem (pcDragDrop^.rsourkey, @ItemData) = FALSE then exit;

   if ItemData.rKind = ITEM_KIND_CANTMOVE then begin
      FSendClass.SendChatMessage (Conv('无法交换的物品'), SAY_COLOR_SYSTEM);
      exit;
   end;

   if GetCellLength (FBasicObject.BasicData.x, FBasicObject.BasicData.y, pcDragDrop^.rdx, pcDragDrop^.rdy) > 3 then begin
      FSendClass.SendChatMessage (Conv('距离太远'), SAY_COLOR_SYSTEM);
      exit;
   end;

   //舅嘎篮 青悼阑 秒窃.
   FBasicObject.BasicData.nx := pcDragDrop^.rdx;
   FBasicObject.BasicData.ny := pcDragDrop^.rdy;
   SubData.ServerId := FBasicObject.ServerID;
   if pcDragDrop^.rdestid <> 0 then begin // 背券芒
      if TUser (FBasicObject).Manager.boPrison = true then begin
         FSendClass.SendChatMessage (Conv('流放地不能交易'), SAY_COLOR_SYSTEM);
         exit;
      end;

      if pcDragDrop^.rdestid <> FBasicObject.BasicData.id then begin
         if aShowWindowClass.CurrentWindow <> swk_none then exit;

         BObject := TBasicObject (FBasicObject.SendLocalMessage (pcDragDrop^.rDestid, FM_GIVEMEADDR, FBasicObject.BasicData, SubData));
         if (Integer (BObject) = -1) or (Integer(BObject) = 0) then exit;

         case BObject.BasicData.Feature.rrace of
            RACE_HUMAN : begin
               //器铰临阑 捞侩茄 贸府
               if (BObject.BasicData.Feature.rfeaturestate = wfs_die) and (StrPas (@ItemData.rName) = INI_ROPE) then begin
                  SignToItem (ItemData, FBasicObject.ServerID, FBasicObject.BasicData, TUser (FBasicObject).IP);
                  SubData.ItemData := ItemData;
                  SubData.ItemData.rCount := 1;
                  FBasicObject.BasicData.nx := pcDragDrop^.rdx;
                  FBasicObject.BasicData.ny := pcDragDrop^.rdy;
                  ret := FBasicObject.Phone.SendMessage (pcDragDrop^.rdestid, FM_ADDITEM, FBasicObject.BasicData, SubData);     //  鸥牢俊霸 林扁...
                  if ret = PROC_TRUE then begin
                     tmpItemData.rOwnerName[0] := 0;
                     DeleteKeyItem (pcDragDrop^.rsourkey, 1, @tmpItemData);
                  end;
                  exit;
               end;

               if BObject.BasicData.Feature.rfeaturestate = wfs_die then exit;

               //2002-08-11 giltae
               if ItemData.rboNotExchange = true then begin
                  FSendClass.SendChatMessage(Conv('无法交换的物品'), SAY_COLOR_SYSTEM);
                  exit;
               end;
               //-----------------------------

                // add by Orber at 2005-01-12 00:19:05

               if (StrPas (@ItemData.rName) = Conv('门派钱令')) then begin
                   if (TUser(FBasicObject).GuildName = TUser(BObject).GuildName) then begin
                      GuildObject := GuildList.GetGuildObject(TUser(FBasicObject).GuildName);
                      if GuildObject.IsGuildSysop(TUser(BObject).Name) then begin
                          if GuildObject.Bank > 2000000 then begin
                              GuildUser := GuildObject.GetUser(TUser(FBasicObject).Name);
                              if (GuildUser^.rMoneyChip > 0) and (GuildUser^.rLastDate <> DateToStr(Date)) and (GuildUser^.rLoadMoney < 300000) then begin
                                  TUser(FBasicObject).SSendChatMessage(Conv('正在等待门主的回复'), SAY_COLOR_SYSTEM);
                                  if not TUser(BObject).GuildApplyMoney(TUser(FBasicObject).Name,GuildUser^.rMoneyChip) then begin
                                      FSendClass.SendChatMessage(Conv('正在受理其他人的取款业务'), SAY_COLOR_SYSTEM);
                                  end;
                              end else begin
                                  FSendClass.SendChatMessage(Conv('您不符合门派银行取款标准'), SAY_COLOR_SYSTEM);
                              end;
                          end;
                      end else begin
                          FSendClass.SendChatMessage(Conv('对方不是门主，无法使用该道具'), SAY_COLOR_SYSTEM);
                      end;
                    end;
                    Exit;
               end;

               if TUser(BObject).GetCurrentWindow <> swk_none then begin
                  FSendClass.SendChatMessage(TUser(BObject).Name + Conv('此人在无法进行交换物品的状态下。'), SAY_COLOR_SYSTEM);
                  exit;
               end;

               if TUser (BObject).boExchange = false then begin
                  FSendClass.SendChatMessage(TUser(BObject).Name + Conv('此人在无法进行交换物品的状态下。'), SAY_COLOR_SYSTEM);
                  exit;
               end;

               if TUser (BObject).GetboMarketing = true then begin       // 俺牢魄概芒捞 凯妨乐栏搁 背券且 荐 绝促.
                  FSendClass.SendChatMessage(TUser(BObject).Name + Conv('此人在无法进行交换物品的状态下。'), SAY_COLOR_SYSTEM);
                  exit;
               end;


               TUser (BObject).GetExchangeData (tmpExchangeData);
               if tmpExchangeData.rExchangeId <> 0 then begin
                  FSendClass.SendChatMessage(Conv('对方与其他人交易中。'), SAY_COLOR_SYSTEM);
                  exit;
               end;

               aShowWindowClass.ExChangeStart (pcDragDrop^.rDestid);
               pcDragDrop^.rdestwindow := WINDOW_EXCHANGE;
               PutOnExchangeProcess (pcDragDrop, aShowWindowClass);
            end;
            RACE_MONSTER, RACE_NPC : begin
               if ItemData.rKind = ITEM_KIND_SEAL then begin
                  Monster := TMonster (BObject);
                  if Monster.Kind = MOP_KIND_SEAL then begin  // 备固龋扼搁
                     if Monster.CurLife <= (Monster.MaxLife div 3) then begin   // 劝仿捞 1/3捞窍啊 灯促搁
                        Monster.CurLife := 0;
                        StrPCopy(@ItemData.rOwnerName, Conv('封印成功'));
                        DeleteKeyItem (pcDragDrop^.rsourkey, 1, @tmpItemData);

                        SubData.ItemData := ItemData;
                        if FBasicObject.Phone.SendMessage (FBasicObject.BasicData.id, FM_ADDITEM, FBasicObject.BasicData, SubData) = PROC_TRUE then begin
                           FSendClass.SendChatMessage (format (Conv ('%s 封印成功'), [Monster.MonsterViewName]), SAY_COLOR_SYSTEM);
                        end;

                        Code := EventClass.isMopDieEvent (Monster.MonsterName);
                        if Code > 0 then begin
                           EventClass.RunMopDieEvent (Code);
                        end;
                     end;
                  end;
               end;
            end;
            Else begin
            // add by Orber at 2005-01-17 13:51:15
            // 补血石
                if StrPas(@ItemData.rName) = Conv('补血石') then begin
                    nByte := TUser(FBasicObject).Maper.GetAreaIndex (FBasicObject.BasicData.nx, FBasicObject.BasicData.ny -5 );
                    if (nByte <= 49) or (nByte >= 60) then Exit;
                    GuildObject := GuildList.GetGuildByType(nByte);
                    if GuildObject =  nil then Exit;
                    if TUser(FBasicObject).GuildName <> GuildObject.GuildName then Exit;
                    if Not GuildObject.IsGuildSysop(TUser(FBasicObject).Name) then Exit;
                    if GuildObject.AddGuildDurability(100000) then begin
                      TUser(FBasicObject).SSendChatMessage(Conv('修理门石成功') ,SAY_COLOR_SYSTEM);
                      TUser(FBasicObject).DeleteItem(@ItemData);
                    end else begin
                      TUser(FBasicObject).SSendChatMessage(Conv('抱歉,您现在不能使用补血石') ,SAY_COLOR_SYSTEM);
                    end;
                    Exit;
                end;
               ItemData.rCount := 1;
               SignToItem (ItemData, FBasicObject.ServerID, FBasicObject.BasicData, TUser (FBasicObject).IP);
               SubData.ItemData := ItemData;
               FBasicObject.BasicData.nx := pcDragDrop^.rdx;
               FBasicObject.BasicData.ny := pcDragDrop^.rdy;
               ret := FBasicObject.Phone.SendMessage (pcDragDrop^.rdestid, FM_ADDITEM, FBasicObject.BasicData, SubData);     //  鸥牢俊霸 林扁...
               if ret = PROC_TRUE then begin
                  tmpBasicData.Feature.rRace := RACE_NPC;
                  Case ItemData.rKind of
                     ITEM_KIND_COLORDRUG : StrPCopy (@tmpBasicData.Name, Conv('染色物品'));
                     ITEM_KIND_DUMMY : StrPCopy (@tmpBasicData.Name, Conv('门派卒兵'));
                     // ITEM_KIND_GUILDLETTER : StrPCopy (@tmpBasicData.Name, '巩颇眠玫辑');    2002/12/17 绝绢咙
                     Else StrPCopy (@tmpBasicData.Name, Conv('消耗物品'));
                  end;
                  tmpBasicData.x := FBasicObject.BasicData.x;
                  tmpBasicData.y := FBasicObject.BasicData.y;
                  SignToItem (ItemData, FBasicObject.ServerID, tmpBasicData, '');
                  DeleteKeyItem (pcDragDrop^.rsourkey, 1, @ItemData);
               end;
               exit;
            end;
         end;
      end;
   end else begin // 官蹿俊 酒捞袍 郴妨初扁
      //2002-08-11 gil-tae
      if ItemData.rboNotDrop = true then begin
         FSendClass.SendChatMessage(Conv('不能丢在地下的物品'),SAY_COLOR_SYSTEM);
         exit;
      end;

      if TUser(FBasicObject).GetCurrentWindow <> swk_none then exit;

{  // add by Orber at 2005-01-17 13:51:15
  // 补血石
      if StrPas(@ItemData.rName) = '补血石' then begin
          nByte := TUser(FBasicObject).Maper.GetAreaIndex (FBasicObject.BasicData.nx, FBasicObject.BasicData.ny -5 );
          if (nByte <= 49) or (nByte >= 60) then Exit;
          GuildObject := GuildList.GetGuildByType(nByte);
          if GuildObject =  nil then Exit;
          TUser(FBasicObject).SSendChatMessage(Conv('修理门石成功，门石耐久度:') + IntToStr(GuildObject.AddGuildDurability(100000)) ,SAY_COLOR_SYSTEM);
      end;}
  // add by Orber at 2005-01-17 13:51:15
  // 建立门派
      if ItemData.rKind = ITEM_KIND_GUILDSTONE then begin
          nByte := TUser(FBasicObject).Maper.GetAreaIndex (FBasicObject.BasicData.nx, FBasicObject.BasicData.ny);
          if (nByte > 49) and (nByte < 60) then
          begin
                if TUser(FBasicObject).GetCurPowerLevel < 5 then begin
                    FSendClass.SendChatMessage(Conv('境界太低，无法建立门派'),SAY_COLOR_SYSTEM);
                    Exit;
                end;
                if TUser(FBasicObject).GuildName <> '' then begin
                    FSendClass.SendChatMessage(Conv('已经加入其它门派，无法建立门派'),SAY_COLOR_SYSTEM);
                    Exit;
                end;
                 Case nByte of
                    51 :
                        begin
                            if StrPas(@ItemData.rName) <> Conv('巨象石') then begin
                                FSendClass.SendChatMessage(Conv('你持有的门石与门派石不匹配'),SAY_COLOR_SYSTEM);
                                Exit;
                            end;
                        end;
                    54 :
                        begin
                            if StrPas(@ItemData.rName) <> Conv('河马石') then begin
                                FSendClass.SendChatMessage(Conv('你持有的门石与门派石不匹配'),SAY_COLOR_SYSTEM);
                                Exit;
                            end;
                        end;
                    52 :
                        begin
                            if StrPas(@ItemData.rName) <> Conv('金鸡石') then begin
                                FSendClass.SendChatMessage(Conv('你持有的门石与门派石不匹配'),SAY_COLOR_SYSTEM);
                                Exit;
                            end;
                        end;
                    50 :
                        begin
                            if StrPas(@ItemData.rName) <> Conv('人龙石') then begin
                                FSendClass.SendChatMessage(Conv('你持有的门石与门派石不匹配'),SAY_COLOR_SYSTEM);
                                Exit;
                            end;
                        end;
                    53 :
                        begin
                            if StrPas(@ItemData.rName) <> Conv('花窟石') then begin
                                FSendClass.SendChatMessage(Conv('你持有的门石与门派石不匹配'),SAY_COLOR_SYSTEM);
                                Exit;
                            end;
                        end;
                    55 :
                        begin
                            if StrPas(@ItemData.rName) <> Conv('玉犬石') then begin
                                FSendClass.SendChatMessage(Conv('你持有的门石与门派石不匹配'),SAY_COLOR_SYSTEM);
                                Exit;
                            end;
                        end;
                    56 :
                        begin
                            if StrPas(@ItemData.rName) <> Conv('玉猿石') then begin
                                FSendClass.SendChatMessage(Conv('你持有的门石与门派石不匹配'),SAY_COLOR_SYSTEM);
                                Exit;
                            end;
                        end;
                    57 :
                        begin
                            if StrPas(@ItemData.rName) <> Conv('玉蟾石') then begin
                                FSendClass.SendChatMessage(Conv('你持有的门石与门派石不匹配'),SAY_COLOR_SYSTEM);
                                Exit;
                            end;
                        end;
                    58 :
                        begin
                            if StrPas(@ItemData.rName) <> Conv('血狮石') then begin
                                FSendClass.SendChatMessage(Conv('你持有的门石与门派石不匹配'),SAY_COLOR_SYSTEM);
                                Exit;
                            end;
                        end;
                    59 :
                        begin
                            if StrPas(@ItemData.rName) <> Conv('血陵石') then begin
                                FSendClass.SendChatMessage(Conv('你持有的门石与门派石不匹配'),SAY_COLOR_SYSTEM);
                                Exit;
                            end;
                        end;
                 end;
                  // add by Orber at 2005-02-28 16:05:25 保存门石名称，便于取回
                  TUser(FBasicObject).aSetGuildStoneName := StrPas(@ItemData.rName);
                  if GuildList.isGuildType(nByte) = false then begin
                    GuildPos := AreaClass.GetAreaDesc(nByte);
                    if Pos('.',GuildPos) > 0 then begin
                        if Not TUser(FBasicObject).DeleteItem(@ItemData) then Exit;
                            FBasicObject.BasicData.x := StrToInt(Copy(GuildPos,0,3));
                            FBasicObject.BasicData.y := StrToInt(Copy(GuildPos,5,3));
                         GuildObject := GuildList.AddGuildObject ('', TUser(FBasicObject).Name, TUser(FBasicObject).Manager.ServerID, StrToInt(Copy(GuildPos,0,3)), StrToInt(Copy(GuildPos,5,3)),nByte);
                         aShowWindowClass.ShowInputGuildName(Conv('输入门派名称'),GuildObject.BasicData.ID);
                     end;
                  end else begin
                     FSendClass.SendChatMessage(Conv('该门派石已经被占领'),SAY_COLOR_SYSTEM);
                  end;
          end;
          Exit;
      end;
      aShowWindowClass.ShowCountWindow (DRAGACTION_DROPITEM, pcDragDrop, ItemData);
      exit;
   end;
end;

procedure THaveItemClass.DblClickProcess (pcClick : PTCClick; aShowWindowClass : TShowWindowClass; aWearItemClass : TWearItemClass; aHaveMagicClass : THaveMagicClass; aUserQuestClass : TUserQuestClass; aHaveJobClass : THaveJobClass);
var
   ItemData, tmpItemData : TItemData;
   BObject : TBasicObject;
   tmpBasicData : TBasicData;
   MagicData : TMagicData;
   SubData : TSubData;
   i, n : Integer;
   JobKind : Byte;
   rboDrugItem : Boolean;
   iName, str : String;
begin
   if ViewItem (pcclick^.rkey, @ItemData) = FALSE then exit;
   ItemData.rCount := 1;
   // add by Orber at 2004-10-08 09:59
   if StrPas(@ItemData.rName) = Conv('九转金丹') then begin
        HaveItemArr[pcclick^.rkey].rboDurability := True;
        FSendClass.SendChatMessage (format ('九转金丹已经开始起作用，离线之前都将有效。', [TUser (FBasicObject).Name]), SAY_COLOR_SYSTEM);
   end;

   case ItemData.rKind of
      ITEM_KIND_SKILLROLLPAPER :
         begin
            JobKind := aHaveJobClass.JobKind;
            iName := format ('.\help\%s%d.txt', [StrPas (@ItemData.rName), JobKind]);
            Str := HelpFiles.FindFile (iName);
            if Str <> '' then begin
               aShowWindowClass.ShowHelpWindow ('', Str);
            end;
         end;
      ITEM_KIND_GUILDLETTER :
         begin
            {  2002/12/17 绝绢咙
            Str := GuildList.MakeGuildLetterFile (aUserQuestClass.QuestStr, StrPas (@FBasicObject.BasicData.Name));
            aShowWindowClass.ShowHelpWindow ('', Str);
            }
         end;
      ITEM_KIND_ITEMLOG :
         begin
            if aShowWindowClass.AllowWindowAction (swk_none) = false then exit;

            n := ItemLog.GetRoomCount (TUser(FBasicObject).Name);
            if n >= 4 then begin
               FSendClass.SendChatMessage (format (Conv('%s的福袋数量已满'), [TUser (FBasicObject).Name]), SAY_COLOR_SYSTEM);
               exit;
            end;

            if ItemLog.CreateRoom (TUser(FBasicObject).Name) = true then begin
               tmpItemData.rOwnerName[0] := 0;
               DeleteKeyItem (pcclick^.rkey, 1, @tmpItemData);
               FSendClass.SendChatMessage (Conv('物品已使用。'), SAY_COLOR_SYSTEM);
               FSendClass.SendChatMessage (format (Conv('%s的福袋一共有 %d个'), [TUser(FBasicObject).Name, n + 1]), SAY_COLOR_SYSTEM);
            end else begin
               FSendClass.SendChatMessage (Conv('为了系统的稳定，所以无法再增加福袋。'), SAY_COLOR_SYSTEM);
            end;
         end;
      ITEM_KIND_PICKAX,
      ITEM_KIND_HIGHPICKAX,      
      ITEM_KIND_CAP,
      ITEM_KIND_WEARITEM2,
      ITEM_KIND_WEARITEM,
      ITEM_KIND_DURAWEAPON :
         begin
            if aShowWindowClass.AllowWindowAction (swk_none) = false then exit;
            if TUserObject(FBasicObject).AllowLifeObjectState = false then exit;

            aWearItemClass.ViewItem (ItemData.rWearArr, @tmpItemData);
            if TUser (FBasicObject).Manager.boUsePowerItem = false then begin
               if ItemData.rboPower = true then begin
                  FSendClass.SendChatMessage (Conv('不能使用技能造物品'), SAY_COLOR_SYSTEM);
                  exit;
               end;
            end;
            if TUser (FBasicObject).Manager.boUseBowMagic = false then begin
               if (ItemData.rHitType = HITTYPE_BOWING) or (ItemData.rHitType = HITTYPE_THROWING) then begin
                  FSendClass.SendChatMessage (Conv('无法使用的地带'), SAY_COLOR_SYSTEM);
                  exit;
               end;
            end;

            if tmpItemData.rName[0] <> 0 then begin
               if CheckBlankAfterDelete (pcClick^.rKey, 1) = false then begin
                  if CheckAddable (tmpItemData) = -1 then begin
                     exit;
                  end;
               end;
            end;
            if aWearItemClass.ChangeItem (ItemData, tmpItemData, true) = true then begin
               ItemData.rOwnerName[0] := 0;
               DeleteKeyItem (pcclick^.rkey, 1, @ItemData);
               if tmpItemData.rName[0] <> 0 then begin
                  ViewItem (pcClick^.rKey, @ItemData);
                  tmpItemData.rCount := 1;
                  if ItemData.rName [0] = 0 then begin
                     AddKeyItem (pcclick^.rkey, tmpItemData);
                  end else begin
                     AddItem (tmpItemData);
                  end;
               end;
            end;
         end;
      ITEM_KIND_HIDESKILL :
         begin
            if aShowWindowClass.AllowWindowAction (swk_none) = false then exit;
            if TUser (FBasicObject).Manager.boNotUseHideItem = true then begin
               FSendClass.SendChatMessage (Conv('无法使用的地带'), SAY_COLOR_SYSTEM);
               exit;
            end;
            if TUser (FBasicObject).UseSkillKind <> -1 then begin
               FSendClass.SendChatMessage (Conv('现在无法使用'), SAY_COLOR_SYSTEM);
               exit;
            end;
            if TUser (FBasicObject).UseSkillKind = ItemData.rKind then begin
               FSendClass.SendChatMessage (Conv('无法重复使用。'), SAY_COLOR_SYSTEM);
               exit;
            end;
            TUser (FBasicObject).UseSkillKind := ItemData.rKind;
            TUser (FBasicObject).SkillUsedTick := mmAnsTick;
            TUser (FBasicObject).SkillUsedMaxTick := INI_HIDEPAPER_DELAY * 100;
            aWearItemClass.SetHiddenState (hs_0);
            FBasicObject.SendLocalMessage (NOTARGETPHONE, FM_CHANGEFEATURE, FBasicObject.BasicData, SubData);

            tmpItemData.rOwnerName[0] := 0;
            DeleteKeyItem (pcclick^.rkey, 1, @tmpItemData);
            FSendClass.SendChatMessage (Conv('物品已使用'),SAY_COLOR_SYSTEM);
         end;
      ITEM_KIND_SHOWSKILL :
         begin
            if aShowWindowClass.AllowWindowAction (swk_none) = false then exit;
            
            if TUser (FBasicObject).UseSkillKind <> -1 then begin
               FSendClass.SendChatMessage (Conv('现在无法使用'), SAY_COLOR_SYSTEM);
               exit;
            end;
            if TUser (FBasicObject).UseSkillKind = ItemData.rKind then begin
               FSendClass.SendChatMessage (Conv('无法重复使用。'), SAY_COLOR_SYSTEM);
               exit;
            end;

            TUser (FBasicObject).UseSkillKind := ItemData.rKind;
            TUser (FBasicObject).SkillUsedTick := mmAnsTick;
            TUser (FBasicObject).SkillUsedMaxTick := INI_SHOWPAPER_DELAY * 100;

            for i := 0 to FBasicObject.ViewObjectList.Count - 1 do begin
               BObject := FBasicObject.ViewObjectList.Items [i];
               if BObject.BasicData.Feature.rHideState = hs_0 then begin
                  FBasicObject.SendLocalMessage (FBasicObject.BasicData.ID, FM_CHANGEFEATURE, BObject.BasicData, SubData);
               end;
            end;

            tmpItemData.rOwnerName[0] := 0;
            DeleteKeyItem (pcclick^.rkey, 1, @tmpItemData);
            FSendClass.SendChatMessage (Conv('物品已使用'),SAY_COLOR_SYSTEM);
         end;
      ITEM_KIND_TICKET:
         begin
            if aShowWindowClass.AllowWindowAction (swk_none) = false then exit;

            if TUser (FBasicObject).Manager.MapAttribute = MAP_TYPE_DONTTICKET then begin
               FSendClass.SendChatMessage (Conv ('无法使用的地带'), SAY_COLOR_SYSTEM);
               exit;
            end;

            if ItemData.rServerId <> FBasicObject.ServerID then begin
               TUser (FBasicObject).boNewServer := TRUE;
               FBasicObject.ServerID := ItemData.rServerId;
            end;
            TUser (FBasicObject).PosMoveX := ItemData.rx; TUser (FBasicObject).PosMoveY := ItemData.ry;
            tmpItemData.rOwnerName[0] := 0;
            DeleteKeyItem (pcclick^.rkey, 1, @tmpItemData);
            FSendClass.SendChatMessage (Conv('物品已使用'),SAY_COLOR_SYSTEM);
         end;
      ITEM_KIND_DRUG:
         begin
            if aShowWindowClass.AllowWindowAction (swk_none) = false then exit;

            if TUser (FBasicObject).Manager.boUseDrug = false then begin
               FSendClass.SendChatMessage (Conv('此地无法服用药物。'), SAY_COLOR_SYSTEM);
               exit;
            end;
            if TUser (FBasicObject).Manager.boUseChemistDrug = false then begin
               if ViewItem (pcclick^.rkey, @ItemData) = true then begin
                  if ItemData.rName [0] = 0 then exit;
                  if ItemData.rSpecialKind = ITEM_SPKIND_DONTDRUG then begin
                     FSendClass.SendChatMessage (Conv('不能服用此药'), SAY_COLOR_SYSTEM);
                     exit;
                  end;
               end;
            end;
            
            iname := StrPas (@ItemData.rName);
            if (TUser (FBasicObject).Manager.MapAttribute = MAP_TYPE_GUILDBATTLE) or
               (TUser (FBasicObject).Manager.MapAttribute = MAP_TYPE_SPORTBATTLE) then begin
               rboDrugItem := False;
               for i := 0 to 5 - 1 do begin
  // add by Orber at 2005-05-13 10:57:03
                  if iName = TUser (FBasicObject).Manager.UseDrugName [i] then begin
                    rboDrugItem := True;
                    Break;
                  end;
{
                  if iName <> TUser (FBasicObject).Manager.UseDrugName [i] then begin
                     FSendClass.SendChatMessage (Conv('不能服用此药'), SAY_COLOR_SYSTEM);
                     exit;
                  end;
}
               end;
               if not rboDrugItem then begin
                     FSendClass.SendChatMessage (Conv('不能服用此药'), SAY_COLOR_SYSTEM);
                     exit;
               end;
            end;

            if FAttribClass.AddItemDrug (iname) then begin
               if ViewItem (pcclick^.rkey, @ItemData) then begin
                  if ItemData.rSoundEvent.rWavNumber <> 0 then begin
                     SetWordString (SubData.SayString, IntToStr (ItemData.rSoundEvent.rWavNumber) + '.wav');
                     FBasicObject.SendLocalMessage (NOTARGETPHONE, FM_SOUND, FBasicObject.BasicData, SubData);
                  end;
               end;
               tmpBasicData.Feature.rrace := RACE_NPC;
               StrPCopy(@tmpBasicData.Name, Conv('使用'));
               tmpBasicData.x := FBasicObject.BasicData.x;
               tmpBasicData.y := FBasicObject.BasicData.y;
               ItemData.rCount := 1;
               SignToItem(ItemData, FBasicObject.ServerID, tmpBasicData, '');
               DeleteKeyItem (pcclick^.rkey, 1, @ItemData);
               FSendClass.SendSideMessage (format (Conv('服用了%s。'), [iname]));
            end else begin
               FSendClass.SendSideMessage (Conv('无法再服用。'));
            end
         end;
      ITEM_KIND_COLORDRUG:
         begin

         end;
      ITEM_KIND_BOOK:
         begin
            if aShowWindowClass.AllowWindowAction (swk_none) = false then exit;
            
            str := StrPas (@ItemData.rname);
            if MagicClass.GetMagicData (str, MagicData, 0) = false then exit;
            Case MagicData.rMagicClass of
               MAGICCLASS_MAGIC :
                  begin
                     if aHaveMagicClass.AddMagic (@MagicData) then begin
                        tmpItemData.rOwnerName[0] := 0;
                        DeleteKeyItem (pcclick^.rkey, 1, @tmpItemData);
                     end else begin
                        FSendClass.SendChatMessage (Conv('修练武功失败。'), SAY_COLOR_SYSTEM);
                        exit;
                     end;

                  end;
               MAGICCLASS_RISEMAGIC :
                  begin
                     if (FAttribClass.Virtue > 6000) and
                        (FAttribClass.Energy > 8000) and
                        (aHaveMagicClass.FindHaveMagicByExtream (MagicData.rMagicType, MagicData.rMagicRelation) = true) then begin
                        if aHaveMagicClass.AddRiseMagic (@MagicData) then begin
                           tmpItemData.rOwnerName[0] := 0;
                           DeleteKeyItem (pcclick^.rkey, 1, @tmpItemData);
                        end else begin
                           FSendClass.SendChatMessage (Conv('修练武功失败。'), SAY_COLOR_SYSTEM);
                           exit;
                        end;
                     end else begin
                        FSendClass.SendChatMessage (Conv('修练条件不足'), SAY_COLOR_SYSTEM);
                        exit;
                     end;
                  end;
               MAGICCLASS_MYSTERY :
                  begin
                     if aHaveMagicClass.AddMysteryMagic (@MagicData) then begin
                        tmpItemData.rOwnerName[0] := 0;
                        DeleteKeyItem (pcclick^.rkey, 1, @tmpItemData);
                     end else begin
                        FSendClass.SendChatMessage (Conv('修练武功失败。'), SAY_COLOR_SYSTEM);
                        exit;
                     end;
                  end;
               MAGICCLASS_BESTMAGIC :
                  begin
                     if aHaveMagicClass.AddBestMagic (@MagicData) then begin
                        tmpItemData.rOwnerName[0] := 0;
                        DeleteKeyItem (pcclick^.rkey, 1, @tmpItemData);
                     end else begin
                        FSendClass.SendChatMessage (Conv ('修练武功失败。'), SAY_COLOR_SYSTEM);
                        exit;
                     end;
                  end;
               Else
                  begin
                  end;
            end;

         end;
      ITEM_KIND_FOXMIRROR :
         begin
            // TMonsterList (Manager.MonsterList).AddMonster (ItemData.rNameParam [0], BasicData.x, BasicData.y, 2, '');
         end;
      ITEM_KIND_QUESTITEM :
         begin

         end;
      ITEM_KIND_QUESTLOG :
         begin
            if aShowWindowClass.AllowWindowAction (swk_none) = false then exit;
            i := FUserQuestClass.CurrentQuestNo;
            Str := QuestSummaryClass.Items[i];
            if Str <> '' then begin
               TUserObject (FBasicObject).SShowWindow2 (nil,Str,0);
            end;
            exit;
         end;
      ITEM_KIND_GRADEUPQUESTITEM :
         begin
            if aShowWindowClass.AllowWindowAction (swk_none) = false then exit;
            Str := QuestSummaryClass.Items [ItemData.rQuestNum];
            if Str <> '' then begin
               TUserObject (FBasicObject).SShowWindow2 (nil,Str,0);
            end;
            exit;
         end;
      ITEM_KIND_TOPLETTER : begin
         if ViewItem (pcclick^.rkey, @ItemData) = false then exit;

         TUser (FBasicObject).SendClass.SendTopLetterWindow;

         if ItemData.rSoundEvent.rWavNumber <> 0 then begin
            SetWordString (SubData.SayString, IntToStr (ItemData.rSoundEvent.rWavNumber) + '.wav');
            FBasicObject.SendLocalMessage (NOTARGETPHONE, FM_SOUND, FBasicObject.BasicData, SubData);
         end;

         tmpItemData.rOwnerName[0] := 0;
         DeleteKeyItem (pcclick^.rkey, 1, @tmpItemData);
         FSendClass.SendChatMessage (Conv ('物品已使用'), SAY_COLOR_SYSTEM);
      end;
      ITEM_KIND_DBLRANDOM : begin
         if ViewItem (pcclick^.rkey, @ItemData) = false then exit;

         Str := RandomEventItemList.GetItemNamebyRandom (0);
         if Str = '' then exit;

         tmpBasicData.Feature.rrace := RACE_NPC;
         StrPCopy(@tmpBasicData.Name, Conv ('使用'));
         tmpBasicData.x := FBasicObject.BasicData.x;
         tmpBasicData.y := FBasicObject.BasicData.y;
         ItemData.rCount := 1;
         SignToItem(ItemData, FBasicObject.ServerID, tmpBasicData, '');
         DeleteKeyItem (pcclick^.rkey, 1, @ItemData);
         FSendClass.SendSideMessage (format (Conv ('使用了%s'), [StrPas (@ItemData.rName)]));

         TUser (FBasicObject).SPutMagicItem (Str, 'event', 4);
      end;
      ITEM_KIND_USESCRIPT : begin
         if ViewItem (pcclick^.rkey, @ItemData) = false then exit;

         FBasicObject.SetScript (ItemData.rScript);
         if FBasicObject.SOnDblClick <> 0 then begin
            ScriptManager.CallEvent (FBasicObject, FBasicObject, FBasicObject.SOnDblClick, 'OnDblClick', ['']);
         end;
      end;
   end;
end;

procedure THaveItemClass.SelectItemWindow (pcClick : PTCClick);
var
   ItemData : TItemData;
   Str, ViewName : String;
begin
   if ViewItem (pcClick^.rkey, @ItemData) = false then exit;
   if ItemData.rName [0] = 0 then exit;

   case ItemData.rKind of
      ITEM_KIND_WEARITEM, ITEM_KIND_WEARITEM2, ITEM_KIND_CAP, ITEM_KIND_PICKAX, ITEM_KIND_HIGHPICKAX, ITEM_KIND_DURAWEAPON :
         begin
            if ItemData.rUpgrade <> 0 then begin
               ViewName := format (Conv('%s %d级'), [StrPas (@ItemData.rViewName), ItemData.rUpgrade]);
            end else begin
               ViewName := StrPas (@ItemData.rViewName);
            end;
         end;
      Else
         begin
            ViewName := StrPas (@ItemData.rViewName);
         end;
   end;
   
   JobClass.GetUpgradeItemLifeData (ItemData);


   Str := GetMiniItemContents2 (ItemData, TUserObject (FBasicObject).PowerLevel);

   if ItemData.rKind = ITEM_KIND_MINERAL then ItemData.rPrice := 0;

   case ItemData.rAttribute of
      ITEM_ATTRIBUTE_PAPERBESTPROTECT : begin
         FSendClass.SendShowItemWindow3 (ViewName, Str, Conv ('废弃'), ItemData.rShape, ItemData.rcolor, 0);
      end;
      ITEM_ATTRIBUTE_PAPERBESTSPECIAL : begin
         FSendClass.SendShowItemWindow3 (ViewName, Str, Conv ('废弃'), ItemData.rShape, ItemData.rcolor, 1);
      end;
      Else begin
         FSendClass.SendShowItemWindow2 (ViewName, Str, ItemData.rShape, ItemData.rcolor, ItemData.rPrice, ItemData.rGrade , ItemData.rLockState , ItemData.runLockTime);
      end;
   end;
end;

procedure THaveItemClass.ChangeCurDuraByName (aName : String; aCurDura : Integer);
var
   nKey : Integer;
begin
   nKey := FindItemKeybyName (aName);
   if nKey = -1 then exit;
   if HaveItemArr [nKey].rName [0] = 0 then exit;

   if Strpas (@HaveItemArr [nKey].rName) = aName then begin
      HaveItemArr [nKey].rCurDurability := aCurDura;
   end;    
end;

function THaveItemClass.RepairItem (aKind : Integer) : Integer;
var
   nPos, RepairPrice, GapDura : Integer;
begin
   Result := -1;

   nPos := FindKindItem (aKind);
   if nPos = -1 then begin                           // 酒捞袍芒俊 粮犁窍瘤臼绰促
      Result := 0;
      exit;
   end;

   if HaveItemArr [nPos].rName [0] = 0 then begin       // 酒捞袍芒俊 粮犁窍瘤臼绰促
      Result := 0;   
      exit;
   end;

   if StrPas(@HaveItemArr [nPos].rName) = Conv('砸门锤') then begin       // 酒捞袍芒俊 粮犁窍瘤臼绰促
      Result := 0;
      exit;
   end;

   if HaveItemArr [nPos].rDurability = 0 then begin             // 郴备己捞 绝绰芭 : 1
      Result := 1;
      exit;
   end;

   if HaveItemArr [nPos].rDurability = HaveItemArr [nPos].rCurDurability then begin     // 郴备己捞 粹瘤臼疽阑锭 : 2
      Result := 2;
      exit;
   end;

   if HaveItemArr [nPos].rKind = aKind then begin
      case aKind of
         ITEM_KIND_EIGHTANGLES : begin        // 迫阿鲍绰 郴备档 1寸 荐府厚侩捞 电促. 040427
            GapDura := HaveItemArr [nPos].rDurability - HaveitemArr [nPos].rCurDurability;
            if GapDura > 0 then begin
               RepairPrice := HaveItemArr [nPos].rRepairPrice * GapDura;

               if HaveMoney < RepairPrice then begin
                  FSendClass.SendChatMessage (format (Conv('维修费是%d.所持金额太少'), [RepairPrice]), SAY_COLOR_SYSTEM);
                  exit;
               end;
               if PayMoney (RepairPrice) = false then exit;

               HaveItemArr [nPos].rCurDurability := HaveItemArr [nPos].rDurability;
               FSendClass.SendChatMessage (format (Conv('%s已修护'), [StrPas (@HaveItemArr [nPos].rName)]), SAY_COLOR_SYSTEM);
               Result := 4;
            end;
         end;
      end;
   end;
end;

function THaveItemClass.DestroyItembyKind (aKind : Integer) : Integer;
var
   nPos : Integer;
begin
   Result := -1;

   nPos := FindKindItem (aKind);
   if nPos = -1 then begin                           // 酒捞袍芒俊 粮犁窍瘤臼绰促
      Result := 0;
      exit;
   end;
   if HaveItemArr [nPos].rName [0] = 0 then begin       // 酒捞袍芒俊 粮犁窍瘤臼绰促
      Result := 0;   
      exit;
   end;
   if HaveItemArr [nPos].rKind = aKind then begin
      case aKind of
         ITEM_KIND_EIGHTANGLES : begin        // 迫阿鲍颇鲍茄促. 040427
            FSendClass.SendChatMessage (format (Conv('%s 废弃物品'), [StrPas (@HaveItemArr [nPos].rViewName)]), SAY_COLOR_SYSTEM);
            DeleteItem (nPos);
            Result := 1;
         end;
      end;
   end;
end;

function THaveItemClass.DestroyItembyAttribKind (aAttribKind : Integer) : Integer;
var
   nPos : Integer;
begin
   Result := -1;

   nPos := FindAttribKindItem (aAttribKind);
   if nPos = -1 then begin                           // 酒捞袍芒俊 粮犁窍瘤臼绰促
      Result := 0;
      exit;
   end;
   if HaveItemArr [nPos].rName [0] = 0 then begin       // 酒捞袍芒俊 粮犁窍瘤臼绰促
      Result := 0;   
      exit;
   end;
   if HaveItemArr [nPos].rAttribute = aAttribKind then begin
      FSendClass.SendChatMessage (format (Conv('%s 废弃物品'), [StrPas (@HaveItemArr [nPos].rViewName)]), SAY_COLOR_SYSTEM);
      DeleteItem (nPos);
      Result := 1;
   end;
end;


///////////////////////////////////
//         TWearItemClass
///////////////////////////////////

constructor TWearItemClass.Create (aBasicObject : TBasicObject; aSendClass: TSendClass; aAttribClass: TAttribClass; aHaveMagicClass : THaveMagicClass; aHaveJobClass : THaveJobClass; aHaveItemClass : THaveItemClass);
begin
   FBasicObject := aBasicObject;
   ReQuestPlaySoundNumber := 0;
   UpdateItemTick := 0;
   FSendClass := aSendClass;
   FAttribClass := aAttribClass;
   FHaveMagicClass := aHaveMagicClass;
   FHaveJobClass := aHaveJobClass;
   FHaveItemClass := aHaveItemClass;

   SpecialItemType := 0;
end;

destructor TWearItemClass.Destroy;
begin
   inherited destroy;
end;

procedure TWearItemClass.SetLifeData;
var
   i, SetCount : integer;
   ItemData : TItemData;
begin
   FillChar (WearItemLifeData, sizeof(TLifeData), 0);
   FillChar (AddAttribLifeData, sizeof(TRealAddAttribData), 0);   

   FHaveJobClass.ChangeJobTool (WearItemArr [ARR_WEAPON]);

   SpecialItemType := 0;
   SetCount := 0;
   for i := ARR_GLOVES to ARR_WEAPON do begin
      GatherLifeData (WearItemLifeData, WearItemArr[i].rLifeData);
      GatherAddAttribLifeData (AddAttribLifeData, WearItemArr[i].rAddAttribData, TUserObject (FBasicObject).PowerLevel);      

      if ViewItem (i, @ItemData) = true then begin
         case ItemData.rAttribute of
            ITEM_ATTRIBUTE_FIRE : begin
               SpecialItemType := ITEM_ATTRIBUTE_FIRE;
            end;
            ITEM_ATTRIBUTE_ICE : begin
               SpecialItemType := ITEM_ATTRIBUTE_ICE;
            end;
            ITEM_ATTRIBUTE_SET : begin
               inc (SetCount);
            end;
         end;
      end;
   end;

   if SetCount = 4 then begin   // 获矮, 癌冠, 档器, 傈捧拳
      ItemClass.GetItemData ('SetValue', ItemData);
      if ItemData.rName [0] <> 0 then begin
         if ItemData.rKind = ITEM_KIND_SET then begin
            GatherLifeData (WearItemLifeData, ItemData.rLifeData);
         end;
      end;
   end;

   WearItemLifeData.damageExp := 0;
   WearItemLifeData.armorExp := 0;

   TUserObject (FBasicObject).SetLifeData;
end;

procedure TWearItemClass.Update (CurTick : integer);
var i:integer;
begin
   if UpdateItemTick = 0 then UpdateItemTick := CurTick;
   // add by Orber 2004-09-08 11:42
   if frmMain.chkSaveUserData.Checked then begin
        if UpdateItemTick + 60 * 100 < CurTick then begin
             for i := 0 to 9 do begin
                 if WearItemArr[i].rLockState = 2 then begin
                      Inc(WearItemArr[i].runLockTime);
                      if WearItemArr[i].runLockTime >= INI_ITEMUNLOCKTIME then begin
                          WearItemArr[i].rLockState := 0;
                          WearItemArr[i].runLockTime := 0;
                      end;
                 end;
             end;
        UpdateItemTick := CurTick;
        end;
   end;

   if CurTick < FUpdateTick + HAVEITEM_UPDATE_DELAY then exit;
   FUpdateTick := mmAnsTick;
   for i := 0 to 9 do begin
      if (WearItemArr[i].rboDurability = true) and (WearItemArr[i].rDecDelay > 0) and (WearItemArr[i].rCurDurability > 0) then begin
               if WearItemArr[i].rDecTick + WearItemArr[i].rDecDelay <= CurTick then begin
                  Dec (WearItemArr[i].rCurDurability, WearItemArr[i].rDecSize);
                  WearItemArr[i].rDecTick := CurTick;
                  if WearItemArr[i].rCurDurability <= 0 then begin
                     FSendClass.SendChatMessage (format(Conv('%S已经磨损的再不能用了'), [StrPas (@WearItemArr[i].rViewName)]), SAY_COLOR_SYSTEM);
                     Self.DeleteKeyItem(i,FALSE);
                  end;
               end;
      end;
   end;

end;

procedure TWearItemClass.LoadFromSdb (aCharData : PTDBRecord);
var
   i : integer;
   str : String;
begin
   ReQuestPlaySoundNumber := 0;
   FillChar (WearItemArr, sizeof(WearItemArr), 0);
   Fillchar (WearFeature, sizeof(WearFeature), 0);

   if StrPas (@aCharData^.Sex) = INI_SEX_FIELD_MAN then WearFeature.rboMan := TRUE
   else WearFeature.rboMan := FALSE;

   WearFeature.rArr[ARR_BODY*2] := 0;
   str := StrPas (@aCharData^.WearItemArr[4].Name) + ':' +
      IntToStr(aCharData^.WearItemArr[4].Color) + ':' +
      IntToStr(aCharData^.WearItemArr[4].Count) + ':' +
      IntToStr (aCharData^.WearItemArr[4].Durability) + ':' +
      IntToStr (aCharData^.WearItemArr[4].CurDurability) + ':' +
      IntToStr (aCharData^.WearItemArr[4].UpGrade) + ':' +
      IntToStr (aCharData^.WearItemArr[4].AddType)
      {//add by Orber at 2004-09-08 14:44}
      + ':' + IntToStr (aCharData^.WearItemArr[4].rLockState)
      + ':' + IntToStr (aCharData^.WearItemArr[4].runLockTime);

   ItemClass.GetWearItemData (str, WearItemArr[ARR_DOWNUNDERWEAR]);
   ItemClass.GetAddItemAttribData(WearItemArr[ARR_DOWNUNDERWEAR]);
   JobClass.GetUpgradeItemLifeData (WearItemArr [ARR_DOWNUNDERWEAR]);

   str := StrPas (@aCharData^.WearItemArr[2].Name) + ':' +
      IntToStr(aCharData^.WearItemArr[2].Color) + ':' +
      IntToStr(aCharData^.WearItemArr[2].Count) + ':' +
      IntToStr (aCharData^.WearItemArr[2].Durability) + ':' +
      IntToStr (aCharData^.WearItemArr[2].CurDurability) + ':' +
      IntToStr (aCharData^.WearItemArr[2].UpGrade) + ':' +
      IntToStr (aCharData^.WearItemArr[2].AddType)
      {//add by Orber at 2004-09-08 14:44}
      + ':' + IntToStr (aCharData^.WearItemArr[2].rLockState)
      + ':' + IntToStr (aCharData^.WearItemArr[2].runLockTime);

   ItemClass.GetWearItemData (str, WearItemArr[ARR_UPUNDERWEAR]);
   ItemClass.GetAddItemAttribData(WearItemArr[ARR_UPUNDERWEAR]);
   JobClass.GetUpgradeItemLifeData (WearItemArr [ARR_UPUNDERWEAR]);

   str := StrPas (@aCharData^.WearItemArr[6].Name) + ':' +
      IntToStr(aCharData^.WearItemArr[6].Color) + ':' +
      IntToStr(aCharData^.WearItemArr[6].Count) + ':' +
      IntToStr (aCharData^.WearItemArr[6].Durability) + ':' +
      IntToStr (aCharData^.WearItemArr[6].CurDurability) + ':' +
      IntToStr (aCharData^.WearItemArr[6].UpGrade) + ':' +
      IntToStr (aCharData^.WearItemArr[6].Addtype)
      {//add by Orber at 2004-09-08 14:44}
      + ':' + IntToStr (aCharData^.WearItemArr[6].rLockState)
      + ':' + IntToStr (aCharData^.WearItemArr[6].runLockTime);

   ItemClass.GetWearItemData (str, WearItemArr[ARR_SHOES]);
   ItemClass.GetAddItemAttribData(WearItemArr[ARR_SHOES]);
   JobClass.GetUpgradeItemLifeData (WearItemArr [ARR_SHOES]);

   str := StrPas (@aCharData^.WearItemArr[3].Name) + ':' +
      IntToStr(aCharData^.WearItemArr[3].Color) + ':' +
      IntToStr(aCharData^.WearItemArr[3].Count) + ':' +
      IntToStr (aCharData^.WearItemArr[3].Durability) + ':' +
      IntToStr (aCharData^.WearItemArr[3].CurDurability) + ':' +
      IntToStr (aCharData^.WearItemArr[3].UpGrade) + ':' +
      IntToStr (aCharData^.WearItemArr[3].AddType)
      {//add by Orber at 2004-09-08 14:44}
      + ':' + IntToStr (aCharData^.WearItemArr[3].rLockState)
      + ':' + IntToStr (aCharData^.WearItemArr[3].runLockTime);

   ItemClass.GetWearItemData (str, WearItemArr[ARR_UPOVERWEAR]);
   ItemClass.GetAddItemAttribData(WearItemArr[ARR_UPOVERWEAR]);
   JobClass.GetUpgradeItemLifeData (WearItemArr [ARR_UPOVERWEAR]);

   str := StrPas (@aCharData^.WearItemArr[5].Name) + ':' +
      IntToStr(aCharData^.WearItemArr[5].Color) + ':' +
      IntToStr(aCharData^.WearItemArr[5].Count) + ':' +
      IntToStr (aCharData^.WearItemArr[5].Durability) + ':' +
      IntToStr (aCharData^.WearItemArr[5].CurDurability) + ':' +
      IntToStr (aCharData^.WearItemArr[5].UpGrade) + ':' +
      IntToStr (aCharData^.WearItemArr[5].AddType)
      {//add by Orber at 2004-09-08 14:44}
      + ':' + IntToStr (aCharData^.WearItemArr[5].rLockState)
      + ':' + IntToStr (aCharData^.WearItemArr[5].runLockTime);

   ItemClass.GetWearItemData (str, WearItemArr[ARR_GLOVES]);
   ItemClass.GetAddItemAttribData(WearItemArr[ARR_GLOVES]);
   JobClass.GetUpgradeItemLifeData (WearItemArr [ARR_GLOVES]);

   str := StrPas (@aCharData^.WearItemArr[0].Name) + ':' +
      IntToStr(aCharData^.WearItemArr[0].Color) + ':' +
      IntToStr(aCharData^.WearItemArr[0].Count) + ':' +
      IntToStr (aCharData^.WearItemArr[0].Durability) + ':' +
      IntToStr (aCharData^.WearItemArr[0].CurDurability) + ':' +
      IntToStr (aCharData^.WearItemArr[0].UpGrade) + ':' +
      IntToStr (aCharData^.WearItemArr[0].AddType)
         {//add by Orber at 2004-09-08 14:44}
      + ':' + IntToStr (aCharData^.WearItemArr[0].rLockState)
      + ':' + IntToStr (aCharData^.WearItemArr[0].runLockTime);

   ItemClass.GetWearItemData (str, WearItemArr[ARR_HAIR]);
   ItemClass.GetAddItemAttribData(WearItemArr[ARR_HAIR]);
   JobClass.GetUpgradeItemLifeData (WearItemArr [ARR_HAIR]);

   str := StrPas (@aCharData^.WearItemArr[1].Name) + ':' +
      IntToStr(aCharData^.WearItemArr[1].Color) + ':' +
      IntToStr(aCharData^.WearItemArr[1].Count) + ':' +
      IntToStr (aCharData^.WearItemArr[1].Durability) + ':' +
      IntToStr (aCharData^.WearItemArr[1].CurDurability) + ':' +
      IntToStr (aCharData^.WearItemArr[1].UpGrade) + ':' +
      IntToStr (aCharData^.WearItemArr[1].AddType)
      {//add by Orber at 2004-09-08 14:44}
      + ':' + IntToStr (aCharData^.WearItemArr[1].rLockState)
      + ':' + IntToStr (aCharData^.WearItemArr[1].runLockTime);

   ItemClass.GetWearItemData (str, WearItemArr[ARR_CAP]);
   ItemClass.GetAddItemAttribData(WearItemArr[ARR_CAP]);
   JobClass.GetUpgradeItemLifeData (WearItemArr [ARR_CAP]);

   str := StrPas (@aCharData^.WearItemArr[7].Name) + ':' +
      IntToStr(aCharData^.WearItemArr[7].Color) + ':' +
      IntToStr(aCharData^.WearItemArr[7].Count) + ':' +
      IntToStr (aCharData^.WearItemArr[7].Durability) + ':' +
      IntToStr (aCharData^.WearItemArr[7].CurDurability) + ':' +
      IntToStr (aCharData^.WearItemArr[7].UpGrade) + ':' +
      IntToStr (aCharData^.WearItemArr[7].AddType)
      {//add by Orber at 2004-09-08 14:44}
      + ':' + IntToStr (aCharData^.WearItemArr[7].rLockState)
      + ':' + IntToStr (aCharData^.WearItemArr[7].runLockTime);

   ItemClass.GetWearItemData (str, WearItemArr[ARR_WEAPON]);
   ItemClass.GetAddItemAttribData(WearItemArr[ARR_WEAPON]);
   JobClass.GetUpgradeItemLifeData (WearItemArr [ARR_WEAPON]);

   WearFeature.rrace := RACE_HUMAN;
   WearFeature.rFeaturestate := wfs_normal;
   WearFeature.rNameColor := WinRGB (25, 25, 25);
   WearFeature.rTeamColor := aCharData^.GroupKey;
   WearFeature.rFlyHeight := 0;

   for i := ARR_GLOVES to ARR_WEAPON do begin
      if WearItemArr[i].rName[0] <> 0 then begin
         WearFeature.rArr [i*2] := WearItemArr[i].rWearShape;
         WearFeature.rArr [i*2+1] := WearItemArr[i].rColor;

         if WearItemArr [6].rKind = ITEM_KIND_WEARITEM2 then begin
            if (i = 2) or (i = 4) then continue;
         end;
         if WearItemArr [8].rKind = ITEM_KIND_CAP then begin
            if i = 7 then continue;
         end;
         FSendClass.SendWearItem (i, WearItemArr[i]);
      end;
   end;
    {if WearItemArr[ARR_SHOES].rName[0] <> 0 then
        if StrPas(@WearItemArr[ARR_SHOES].rName) = '疾速靴' then begin
            if TUser(FBasicObject).State <> wfs_running then begin
                TUser(FBasicObject).CommandChangeCharState (wfs_running);
            end;
        end;}

   SetLifeData;
end;

procedure TWearItemClass.SaveToSdb (aCharData : PTDBRecord);
var
   str, rdstr : String;
   i:integer;
begin
   str := ItemClass.GetWearItemString (WearItemArr[ARR_DOWNUNDERWEAR]);
   str := GetValidStr3 (str, rdstr, ':');
   StrPCopy (@aCharData^.WearItemArr[4].Name, rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[4].Color := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[4].Count := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[4].Durability := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[4].CurDurability := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[4].Upgrade := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[4].AddType := _StrToInt (rdstr);
   // add by Orber at 2004-09-08 10:40
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[4].rLockState := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[4].runLockTime := _StrToInt (rdstr);


   str := ItemClass.GetWearItemString (WearItemArr[ARR_UPUNDERWEAR]);
   str := GetValidStr3 (str, rdstr, ':');
   StrPCopy (@aCharData^.WearItemArr[2].Name, rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[2].Color := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[2].Count := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[2].Durability := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[2].CurDurability := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[2].Upgrade := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[2].AddType := _StrToInt (rdstr);
   // add by Orber at 2004-09-08 10:40
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[2].rLockState := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[2].runLockTime := _StrToInt (rdstr);

   str := ItemClass.GetWearItemString (WearItemArr[ARR_SHOES]);
   str := GetValidStr3 (str, rdstr, ':');
   StrPCopy (@aCharData^.WearItemArr[6].Name, rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[6].Color := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[6].Count := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[6].Durability := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[6].CurDurability := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[6].Upgrade := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[6].AddType := _StrToInt (rdstr);
   // add by Orber at 2004-09-08 10:40
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[6].rLockState := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[6].runLockTime := _StrToInt (rdstr);

   str := ItemClass.GetWearItemString (WearItemArr[ARR_UPOVERWEAR]);
   str := GetValidStr3 (str, rdstr, ':');
   StrPCopy (@aCharData^.WearItemArr[3].Name, rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[3].Color := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[3].Count := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[3].Durability := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[3].CurDurability := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[3].Upgrade := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[3].AddType := _StrToInt (rdstr);
   // add by Orber at 2004-09-08 10:40
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[3].rLockState := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[3].runLockTime := _StrToInt (rdstr);

   str := ItemClass.GetWearItemString (WearItemArr[ARR_GLOVES]);
   str := GetValidStr3 (str, rdstr, ':');
   StrPCopy (@aCharData^.WearItemArr[5].Name, rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[5].Color := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[5].Count := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[5].Durability := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[5].CurDurability := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[5].Upgrade := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[5].AddType := _StrToInt (rdstr);
   // add by Orber at 2004-09-08 10:40
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[5].rLockState := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[5].runLockTime := _StrToInt (rdstr);

   str := ItemClass.GetWearItemString (WearItemArr[ARR_HAIR]);
   str := GetValidStr3 (str, rdstr, ':');
   StrPCopy (@aCharData^.WearItemArr[0].Name, rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[0].Color := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[0].Count := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[0].Durability := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[0].CurDurability := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[0].Upgrade := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[0].AddType := _StrToInt (rdstr);
   // add by Orber at 2004-09-08 10:40
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[0].rLockState := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[0].runLockTime := _StrToInt (rdstr);

   str := ItemClass.GetWearItemString (WearItemArr[ARR_CAP]);
   str := GetValidStr3 (str, rdstr, ':');
   StrPCopy (@aCharData^.WearItemArr[1].Name, rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[1].Color := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[1].Count := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[1].Durability := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[1].CurDurability := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[1].Upgrade := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[1].AddType := _StrToInt (rdstr);
   // add by Orber at 2004-09-08 10:40
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[1].rLockState := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[1].runLockTime := _StrToInt (rdstr);

   str := ItemClass.GetWearItemString (WearItemArr[ARR_WEAPON]);
   str := GetValidStr3 (str, rdstr, ':');
   StrPCopy (@aCharData^.WearItemArr[7].Name, rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[7].Color := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[7].Count := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[7].Durability := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[7].CurDurability := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[7].Upgrade := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[7].AddType := _StrToInt (rdstr);

   // add by Orber at 2004-09-08 10:40
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[7].rLockState := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   aCharData^.WearItemArr[7].runLockTime := _StrToInt (rdstr);



end;

function TWearItemClass.GetFeature : TFeature;
var
   i : integer;
   pm : PTMagicData;
begin
   WearFeature.rrace := RACE_HUMAN;
   for i := ARR_GLOVES to ARR_WEAPON do begin
      WearFeature.rArr [i*2] := WearItemArr[i].rWearShape;
      WearFeature.rArr [i*2+1] := WearItemArr[i].rColor;
      if WearItemArr[6].rKind = ITEM_KIND_WEARITEM2 then begin
         if (i = 2) or (i = 4) then begin
            WearFeature.rArr [i*2] := 0;
            WearFeature.rArr [i*2+1] := 0;
         end;
      end;
      if WearItemArr[8].rKind = ITEM_KIND_CAP then begin
         if i = 7 then begin
            WearFeature.rArr [i*2] := 0;
            WearFeature.rArr [i*2+1] := 0;
         end;
      end;
   end;

   if WearFeature.rArr [ARR_GLOVES*2] <> 0 then begin
      WearFeature.rArr [5*2] := WearItemArr[ARR_GLOVES].rWearShape;
      WearFeature.rArr [5*2+1] := WearItemArr[ARR_GLOVES].rColor;
   end;

   case WearItemArr[ARR_WEAPON].rHitMotion of
      0 :
         begin
            pm := FHaveMagicClass.FpCurAttackMagic;
            WearFeature.rhitmotion := AM_HIT;
            if pm <> nil then begin
               if pm^.rMagicType = MAGICTYPE_WINDOFHAND then begin
                  WearFeature.rhitmotion := AM_HIT10;
               end;
            end;
         end;
      1 : WearFeature.rhitmotion := AM_HIT1;
      2 : WearFeature.rhitmotion := AM_HIT2;
      3 : WearFeature.rhitmotion := AM_HIT3;
      4 : WearFeature.rhitmotion := AM_HIT4;
      5 : WearFeature.rhitmotion := AM_HIT5;
      6 : WearFeature.rhitmotion := AM_HIT6;
      10: WearFeature.rhitmotion := AM_HIT10;
      11: WearFeature.rhitmotion := AM_HIT11;
      // add by Orber at 2005-01-12 18:16:23
      12: WearFeature.rhitmotion := AM_HIT8;
   end;

   Result := WearFeature;
end;

function TWearItemClass.GetWeaponAttrib : Integer;
begin
   Result := 0;
   if WearItemArr[ARR_WEAPON].rName[0] = 0 then exit;
   Result := WearItemArr[ARR_WEAPON].rAttribute;
end;

// add by Orber at 2004-10-09 11:48
function TWearItemClass.GetWeaponItemName : String;
begin
   Result := '';
   if WearItemArr[ARR_WEAPON].rName[0] = 0 then exit;
   Result := StrPas(@WearItemArr[ARR_WEAPON].rName);
end;

function  TWearItemClass.GetWeaponType : Integer;
begin
   if WearItemArr[ARR_WEAPON].rName[0] = 0 then begin
      if FHaveMagicClass.FpCurAttackMagic = nil then begin
         Result := MAGICTYPE_WRESTLING;
      end else begin
         Result := FHaveMagicClass.FpCurAttackMagic^.rMagicType;
      end;
      exit;
   end;

   Result := WearItemArr[ARR_WEAPON].rHitType;
end;

function TWearItemClass.GetWeaponKind : Integer;
begin
   Result := 0;
   if WearItemArr[ARR_WEAPON].rName[0] = 0 then exit;

   Result := WearItemArr[ARR_WEAPON].rKind;
end;

procedure TWearItemClass.DecreaseDurability (aKey : Integer);
begin
   if (akey < ARR_BODY) or (akey > ARR_WEAPON) then exit;
   if WearItemArr [aKey].rName [0] = 0 then exit;
   if WearItemArr [aKey].rDurability = 0 then exit;

   WearItemArr [aKey].rCurDurability := WearItemArr [aKey].rCurDurability - 1;

   if WearItemArr [aKey].rCurDurability < 20 then begin
      FSendClass.SendChatMessage (format (Conv('%s的耐久度快没了'), [StrPas (@WearItemArr [aKey].rViewName)]), SAY_COLOR_SYSTEM);      
   end;

   if WearItemArr [aKey].rCurDurability <= 0 then begin
      FSendClass.SendChatMessage (format (Conv('%s 物品无法继续使用'), [StrPas (@WearItemArr [aKey].rViewName)]), SAY_COLOR_SYSTEM);
      if WearItemArr [aKey].rKind = ITEM_KIND_DURAWEAPON then begin
         FHaveMagicClass.FpCurAttackMagic := @FHaveMagicClass.DefaultMagic [0];
      end;

      DeleteKeyItem (aKey, false);
   end;
end;

function TWearItemClass.IncreaseDurability (aKey : Integer) : Boolean;
var
   Dura : Integer;
begin
   Result := false;
   if (akey < ARR_BODY) or (akey > ARR_WEAPON) then exit;
   if WearItemArr [akey].rName [0] = 0 then exit;

   Dura := WearItemArr [akey].rDurability;
   Dura := Dura - WearItemArr [akey].rAbrasion;
   if Dura < 0 then exit;
   //if WearItemArr [akey].rDurability < 0 then WearItemArr [akey].rDurability := 0;
   WearItemArr [akey].rCurDurability := Dura;
   WearItemArr [akey].rDurability := Dura;

   Result := true;
end;

function TWearItemClass.RepairItem (aKey, aKind : Integer) : Integer;
var
   RepairPrice, GapDura : Integer;
begin
   Result := -1;

   if (aKey < ARR_BODY) or (aKey > ARR_WEAPON) then begin       // 酒公巴档 绝阑锭 : 0
      Result := 0;
      exit;
   end;
   if WearItemArr [aKey].rName [0] = 0 then begin
      Result := 0;
      exit;
   end;

   if StrPas(@WearItemArr [aKey].rName) = Conv('砸门锤') then begin       // 酒捞袍芒俊 粮犁窍瘤臼绰促
      Result := 0;
      exit;
   end;

   if WearItemArr [aKey].rDurability = 0 then begin             // 郴备己捞 绝绰芭 : 1
      Result := 1;
      exit;
   end;

   if WearItemArr [aKey].rDurability = WearItemArr [aKey].rCurDurability then begin     // 郴备己捞 粹瘤臼疽阑锭 : 2
      Result := 2;
      exit;
   end;

   if WearItemArr [aKey].rKind = aKind then begin
      case aKind of
         ITEM_KIND_PICKAX : begin
            // 促 荐府沁阑锭 : 3
            RepairPrice := WearItemArr [aKey].rRepairPrice;
            if FHaveItemClass.HaveMoney < RepairPrice then begin
               FSendClass.SendChatMessage (format (Conv('维修费是%d.所持金额太少'), [RepairPrice]), SAY_COLOR_SYSTEM);
               exit;
            end;
            if IncreaseDurability (aKey) = false then begin
               Result := 3;
               exit;
            end;

            if FHaveItemClass.PayMoney (RepairPrice) = false then exit;

            FSendClass.SendChatMessage (format (Conv('%s已修护'), [StrPas (@WearItemArr [aKey].rName)]), SAY_COLOR_SYSTEM);
            Result := 4;
         end;
         ITEM_KIND_HIGHPICKAX, ITEM_KIND_DURAWEAPON : begin        // 绊鞭邦豹捞绰 郴备档 1寸 荐府厚侩捞 电促. 040424
            GapDura := WearItemArr [aKey].rDurability - WearitemArr [aKey].rCurDurability;
            if GapDura > 0 then begin
               RepairPrice := WearItemArr [aKey].rRepairPrice * GapDura;
               
               if FHaveItemClass.HaveMoney < RepairPrice then begin
                  FSendClass.SendChatMessage (format (Conv('维修费是%d.所持金额太少'), [RepairPrice]), SAY_COLOR_SYSTEM);
                  exit;
               end;
               if FHaveItemClass.PayMoney (RepairPrice) = false then exit;

               WearItemArr [aKey].rCurDurability := WearItemArr [aKey].rDurability;
               FSendClass.SendChatMessage (format (Conv('%s已修护'), [StrPas (@WearItemArr [aKey].rName)]), SAY_COLOR_SYSTEM);
               Result := 4;
            end;
         end;
      end;
   end;
end;

function TWearItemClass.DestroyItembyKind (aKey, aKind : Integer) : Integer;
begin
   Result := -1;

   if (aKey < ARR_BODY) or (aKey > ARR_WEAPON) then begin       // 酒公巴档 绝阑锭 : 0
      Result := 0;
      exit;
   end;
   if WearItemArr [aKey].rName [0] = 0 then begin
      Result := 0;
      exit;
   end;
   if WearItemArr [aKey].rKind = aKind then begin
      case aKind of
         ITEM_KIND_DURAWEAPON : begin
            FSendClass.SendChatMessage (format (Conv('%s 废弃物品'), [StrPas (@WearItemArr [aKey].rViewName)]), SAY_COLOR_SYSTEM);
            DeleteKeyItem (aKey, false);
            FHaveMagicClass.FpCurAttackMagic := @FHaveMagicClass.DefaultMagic [0];
            FHaveMagicClass.SetLifeData;
            Result := 1;
         end;
      end;
   end;
end;

function TWearItemClass.GetWearItemName (aKey : Integer) : String;
begin
   Result := StrPas (@WearItemArr [aKey].rName);
end;

function  TWearItemClass.ViewItem (akey: integer; aItemData: PTItemData): Boolean;
begin
   Result := FALSE;
   if (akey < ARR_BODY) or (akey > ARR_WEAPON) then begin
      FillChar (aItemData^, sizeof(TItemData), 0);
      exit;
   end;
   if WearItemArr[akey].rName[0] = 0 then begin
      FillChar (aItemData^, sizeof(TItemData), 0);
      exit;
   end;
   Move (WearItemArr[akey], aItemData^, SizeOf (TItemData));
   Result := TRUE;
end;

function  TWearItemClass.FindItemByAttrib (aAttrib : Integer) : Boolean;
var
   i : Integer;
begin
   Result := false;
   for i := ARR_BODY to ARR_WEAPON do begin
      if WearItemArr[i].rAttribute = aAttrib then begin
         Result := true;
         exit;
      end;
   end;
end;

function  TWearItemClass.AddColorDrug (aKey : Integer; var aItemData : TItemData) : Boolean;
var
   DestKey : Integer;
   ItemData : TItemData;
   SubData : TSubData;
begin
   Result := false;
   
   if aItemData.rName [0] = 0 then exit;
   if aItemData.rKind <> ITEM_KIND_COLORDRUG then exit;
   if (aKey < ARR_GLOVES) or (aKey > ARR_HAIR) then exit;

   DestKey := aKey;
   if DestKey = 5 then DestKey := ARR_GLOVES;

   ViewItem (DestKey, @ItemData);
   if ItemData.rName [0] = 0 then exit;
   if ItemData.rboColoring = false then exit;

   if INI_WHITEDRUG <> StrPas (@aItemData.rName) then begin
      WearItemArr [DestKey].rColor := aItemData.rColor;
   end else begin
      WearItemArr [DestKey].rColor := WearItemArr [DestKey].rColor + aItemData.rColor;
   end;

   FSendClass.SendWearItem (WearItemArr [DestKey].rWearArr, WearItemArr [DestKey]);

   FBasicObject.BasicData.Feature := GetFeature;
   FBasicObject.SendLocalMessage (NOTARGETPHONE, FM_CHANGEFEATURE, FBasicObject.BasicData, SubData);

   Result := true;
end;

function  TWearItemClass.AddItem  (var aItemData: TItemData; aboChangeMagic : Boolean): Boolean;
var
   ItemData : TItemData;
   SubData : TSubData;
   pItemData : PTItemData;
begin
   Result := FALSE;

   if WearItemArr[aItemData.rWearArr].rName[0] <> 0 then exit;
   if aItemData.rName[0] = 0 then exit;
   if (aItemData.rKind <> ITEM_KIND_WEARITEM) and (aItemData.rKind <> ITEM_KIND_WEARITEM2)
      and (aItemData.rKind <> ITEM_KIND_CAP) and (aItemData.rKind <> ITEM_KIND_PICKAX)
      and (aItemData.rKind <> ITEM_KIND_HIGHPICKAX) and (aItemData.rKind <> ITEM_KIND_DURAWEAPON) then exit;

  // add by Orber at 2004-10-11 10:52:00

     case aItemData.rSex of
        0: begin
            if WearFeature.rboMan then begin
                aItemData.rSex := 1;
            end else begin
                aItemData.rSex := 2;
            end;
        end;
        1: if not WearFeature.rboMan then exit;
        2: if WearFeature.rboMan then exit;
     end;

   if aboChangeMagic = true then begin
      if aItemData.rWearArr = ARR_WEAPON then begin
         if aItemData.rHitType <> WearItemArr [ARR_WEAPON].rHitType then begin
            if FBasicObject.Manager.boCanChangeMagic = false then begin
               TUserObject(FBasicObject).SendClass.SendChatMessage(Conv ('不能更换武功的地区'), SAY_COLOR_SYSTEM);
               exit;
            end;

            if FHaveMagicClass.SetHaveItemMagicType (aItemData.rHitType, false) = false then begin
               exit;
            end;
         end else if (FHaveMagicClass.pCurAttackMagic <> nil) and (FHaveMagicClass.pCurAttackMagic^.rMagicClass = MAGICCLASS_MYSTERY) then begin
            if FHaveMagicClass.SetHaveItemMagicType (aItemData.rHitType, false) = false then begin
               exit;
            end;
         end;
      end;
   end;

   Move (aItemData, WearItemArr[aItemData.rWearArr], SizeOf (TItemData));
   WearItemArr[aItemData.rWearArr].rCount := 1;

   if (aItemData.rWearArr = ARR_UPOVERWEAR) and (aItemData.rKind = ITEM_KIND_WEARITEM2) then begin
      FillChar (ItemData, SizeOf (TItemData), 0);
      FSendClass.SendWearItem (ARR_UPUNDERWEAR, ItemData);
      FSendClass.SendWearItem (ARR_DOWNUNDERWEAR, ItemData);
      FSendClass.SendWearItem (aItemData.rWearArr, aItemData);
   end else if (aItemData.rWearArr = ARR_CAP) and (aItemData.rKind = ITEM_KIND_CAP) then begin
      FillChar (ItemData, SizeOf (TItemData), 0);
      FSendClass.SendWearItem (ARR_HAIR, ItemData);
      FSendClass.SendWearItem (aItemData.rWearArr, aItemData);
   end else if (aItemData.rWearArr = ARR_UPUNDERWEAR) or (aItemData.rWearArr = ARR_DOWNUNDERWEAR) then begin
      if (WearItemArr [ARR_UPOVERWEAR].rKind <> ITEM_KIND_WEARITEM2) then begin
         FSendClass.SendWearItem (aItemData.rWearArr, aItemData);
      end;
   end else begin
      FSendClass.SendWearItem (aItemData.rWearArr, aItemData);
   end;

   if aItemData.rWearArr = ARR_WEAPON then begin
      //烙矫利栏肺 加己阑 TAEGUK俊父 惫茄矫挪促.
      if aItemData.rAttribute = ITEM_ATTRIBUTE_TAEGUK then begin
         pItemData := FHaveItemClass.FindItembyKindAttrib (ITEM_KIND_SUBITEM, ITEM_ATTRIBUTE_TAEGUK);
         if pItemData <> nil then begin
            //FillChar (FAttribClass.HaveItemLifeData, SizeOf (TLifeData), 0);
            FHaveItemClass.SetEffectItemLifeData;          
            //GatherLifeData (FAttribClass.HaveItemLifeData, pItemData^.rLifeData);
         end;
      end;
   end;
   
   FBasicObject.BasicData.Feature := GetFeature;
   FBasicObject.SendLocalMessage (NOTARGETPHONE, FM_CHANGEFEATURE, FBasicObject.BasicData, SubData);

   ReQuestPlaySoundNumber := aItemData.rSoundEvent.rWavNumber;

   SetLifeData;

   Result := TRUE;
end;

function  TWearItemClass.ChangeItem  (var aItemData: TItemData; var aOldItemData : TItemData; aboChangeMagic : Boolean): Boolean;
var
   ItemData : TItemData;
   SubData : TSubData;
   pItemData : PTItemData;
begin
   Result := FALSE;

   if aItemData.rName[0] = 0 then exit;
   if (aItemData.rKind <> ITEM_KIND_WEARITEM) and (aItemData.rKind <> ITEM_KIND_WEARITEM2)
      and (aItemData.rKind <> ITEM_KIND_CAP) and (aItemData.rKind <> ITEM_KIND_PICKAX)
      and (aItemData.rKind <> ITEM_KIND_HIGHPICKAX) and (aItemData.rKind <> ITEM_KIND_DURAWEAPON) then exit;

   case aItemData.rSex of
      0:;
      1: if not WearFeature.rboMan then exit;
      2: if WearFeature.rboMan then exit;
   end;

   if aboChangeMagic = true then begin
      if aItemData.rWearArr = ARR_WEAPON then begin
         if aItemData.rHitType <> WearItemArr [ARR_WEAPON].rHitType then begin
            if FBasicObject.Manager.boCanChangeMagic = false then begin
               TUserObject(FBasicObject).SendClass.SendChatMessage(Conv ('不能更换武功的地区'), SAY_COLOR_SYSTEM);
               exit;
            end;

            if FHaveMagicClass.SetHaveItemMagicType (aItemData.rHitType, false) = false then begin
               exit;
            end;
         end else if (FHaveMagicClass.pCurAttackMagic <> nil) and (FHaveMagicClass.pCurAttackMagic^.rMagicClass = MAGICCLASS_MYSTERY) then begin
            if FHaveMagicClass.SetHaveItemMagicType (aItemData.rHitType, false) = false then begin
               exit;
            end;
         end;
      end;
   end;

   if WearItemArr[aItemData.rWearArr].rName[0] = 0 then begin
      FillChar (aOldItemData, SizeOf (TItemData), 0);
   end else begin
      Move (WearItemArr[aItemData.rWearArr], aOldItemData, SizeOf (TItemData));
      FillChar (WearItemArr[aItemDAta.rWearArr], SizeOf (TItemData), 0);
      aOldItemData.rCount := 1;
   end;

   Move (aItemData, WearItemArr[aItemData.rWearArr], SizeOf (TItemData));
   WearItemArr[aItemData.rWearArr].rCount := 1;

   //2002-08-12 giltae
   if aItemData.rWearArr = ARR_WEAPON then begin
      //烙矫利栏肺 加己阑 TAEGUK俊父 惫茄矫挪促.
      if aItemData.rAttribute = ITEM_ATTRIBUTE_TAEGUK then begin
         pItemData := FHaveItemClass.FindItembyKindAttrib (ITEM_KIND_SUBITEM, ITEM_ATTRIBUTE_TAEGUK);
         if pItemData <> nil then begin
            //FillChar (FAttribClass.HaveItemLifeData, SizeOf (TLifeData), 0);
            FHaveItemClass.SetEffectItemLifeData;
            //GatherLifeData (FAttribClass.HaveItemLifeData, pItemData^.rLifeData);
         end;
      end else begin
         //FillChar (FAttribClass.HaveItemLifeData, SizeOf (TLifeData), 0);
         FHaveItemClass.SetEffectItemLifeData;
      end;
   end;

   if (aItemData.rWearArr = ARR_UPOVERWEAR) and (aItemData.rKind = ITEM_KIND_WEARITEM2) then begin
      FillChar (ItemData, SizeOf (TItemData), 0);
      FSendClass.SendWearItem (ARR_UPUNDERWEAR, ItemData);
      FSendClass.SendWearItem (ARR_DOWNUNDERWEAR, ItemData);
      FSendClass.SendWearItem (aItemData.rWearArr, aItemData);
   end else if (aItemData.rWearArr = ARR_CAP) and (aItemData.rKind = ITEM_KIND_CAP) then begin
      FillChar (ItemData, SizeOf (TItemData), 0);
      FSendClass.SendWearItem (ARR_HAIR, ItemData);
      FSendClass.SendWearItem (aItemData.rWearArr, aItemData);
   end else if (aItemData.rWearArr = ARR_UPUNDERWEAR) or (aItemData.rWearArr = ARR_DOWNUNDERWEAR) then begin
      if WearItemArr [ARR_UPOVERWEAR].rKind <> ITEM_KIND_WEARITEM2 then begin
         FSendClass.SendWearItem (aItemData.rWearArr, aItemData);
      end;
   end else begin
      FSendClass.SendWearItem (aItemData.rWearArr, aItemData);
   end;

   FBasicObject.BasicData.Feature := GetFeature;
   FBasicObject.SendLocalMessage (NOTARGETPHONE, FM_CHANGEFEATURE, FBasicObject.BasicData, SubData);

   ReQuestPlaySoundNumber := aItemData.rSoundEvent.rWavNumber;

   SetLifeData;
   Result := TRUE;
end;

function TWearItemClass.DeleteKeyItem (aKey: integer; aboChangeMagic : Boolean) : Boolean;
var
   SubData : TSubData;
begin
   Result := false;

   if (akey < ARR_BODY) or (akey > ARR_WEAPON) then exit;

   if aboChangeMagic = true then begin
      if aKey = ARR_WEAPON then begin
         if WearItemArr [ARR_WEAPON].rHitType <> 0 then begin
            if FBasicObject.Manager.boCanChangeMagic = false then begin
               TUserObject(FBasicObject).SendClass.SendChatMessage(Conv ('不能更换武功的地区'), SAY_COLOR_SYSTEM);
               exit;
            end;

            if FHaveMagicClass.SetHaveItemMagicType (0, false) = false then begin
               exit;
            end;
         end;
      end;
   end;

   if (aKey = ARR_UPOVERWEAR) and (WearItemArr[aKey].rKind = ITEM_KIND_WEARITEM2) then begin
      FSendClass.SendWearItem (ARR_UPUNDERWEAR, WearItemArr[ARR_UPUNDERWEAR]);
      FSendClass.SendWearItem (ARR_DOWNUNDERWEAR, WearItemArr[ARR_DOWNUNDERWEAR]);
   end;
   if (aKey = ARR_CAP) and (WearItemArr[aKey].rKind = ITEM_KIND_CAP) then begin
      FSendClass.SendWearItem (ARR_HAIR, WearItemArr[ARR_HAIR]);
   end;

   if akey = ARR_WEAPON then begin
      if WearitemArr [aKey].rAttribute = ITEM_ATTRIBUTE_TAEGUK then begin
         FillChar (FAttribClass.HaveItemLifeData, SizeOf (TLifeData), 0);
         //FHaveItemClass.SetEffectItemLifeData;
      end;
   end;

   FillChar (WearItemArr[akey], sizeof(TItemData), 0);
   FSendClass.SendWearItem (akey, WearItemArr[akey]);
   FBasicObject.BasicData.Feature := GetFeature;
   FBasicObject.SendLocalMessage (NOTARGETPHONE, FM_CHANGEFEATURE, FBasicObject.BasicData, SubData);

   SetLifeData;

   Result := true;
end;

procedure TWearItemClass.SetFeatureState (aFeatureState: TFeatureState);
begin
   WearFeature.rfeaturestate := aFeatureState;
end;

procedure TWearItemClass.SetTeamColor (aIndex : Word);
begin
   FBasicObject.BasicData.Feature.rTeamColor := aIndex;
   WearFeature.rTeamColor := aIndex;
end;

procedure TWearItemClass.SetNameColor (aIndex : Word);
begin
   FBasicObject.BasicData.Feature.rNameColor := aIndex;
   WearFeature.rNameColor := aIndex;
end;

procedure TWearItemClass.SetHiddenState (aHiddenState : THiddenState);
begin
   FBasicObject.BasicData.Feature.rHideState := aHiddenState;
   WearFeature.rHideState := aHiddenState;
end;

procedure TWearItemClass.SetActionState (aActionState : TActionState);
begin
   FBasicObject.BasicData.Feature.rActionState := aActionState;
   WearFeature.rActionState := aActionState;
end;

function TWearItemClass.GetHiddenState : THiddenState;
begin
   Result := WearFeature.rHideState;
end;

function TWearItemClass.GetActionState : TActionState;
begin
   Result := WearFeature.rActionState;
end;

procedure TWearItemClass.DressOffProcess (pcDragDrop : PTCDragDrop; aShowWindowClass : TShowWindowClass; aHaveItemClass : THaveItemClass; aHaveMagicClass: THaveMagicClass);
var
   SourceKey, DestKey, AddableKey : Integer;
   ItemData, tmpItemData : TItemData;
begin
   if aShowWindowClass.AllowWindowAction (swk_none) = false then exit;

   SourceKey := pcDragDrop^.rSourKey;
   DestKey := pcDragDrop^.rDestKey;

   if SourceKey = 5 then SourceKey := ARR_GLOVES;

   ViewItem (SourceKey, @ItemData);
   if ItemData.rName [0] = 0 then exit;

   AddableKey := -1;
   if (DestKey >= 0) and (DestKey <= HAVEITEMSIZE - 1) then begin
      aHaveItemClass.ViewItem (DestKey, @tmpItemData);
      if tmpItemData.rName [0] = 0 then begin
         AddableKey := DestKey;
      end;
   end;

   if AddableKey < 0 then begin
      AddableKey := aHaveItemClass.CheckAddable (ItemData);
      if AddableKey < 0 then exit;
   end;

   ItemData.rCount := 1;
   ItemData.rOwnerName [0] := 0;
   if DeleteKeyItem (ItemData.rWearArr, true) = true then begin
      aHaveItemClass.AddKeyItem (AddableKey, ItemData);
      aHaveMagicClass.DelItemMagic(ItemData);
   end;
end;

function TWearItemClass.CheckPowerWearItem : Integer;
var
   i, nCount : Integer;
begin
   nCount := 0;
   for i := ARR_BODY to ARR_WEAPON do begin
      if WearItemArr[i].rboPower = true then begin
         inc (nCount);
      end;
   end;

   Result := nCount;
end;

///////////////////////////////////
//         THaveMagicClass
///////////////////////////////////

constructor THaveMagicClass.Create (aBasicObject : TBasicObject; aSendClass: TSendClass; aAttribClass: TAttribClass);
begin
   FBasicObject := aBasicObject;
   boAddExp := true;
   ReQuestPlaySoundNumber := 0;
   ConsumeEnergy := 0;

   FSendClass := aSendClass;
   FAttribClass := aAttribclass;

   FillChar (MagicIndexTable, sizeof(MagicIndexTable), -1);
   FillChar (RiseMagicIndexTable, sizeof(RiseMagicIndexTable), -1);
   FillChar (MysteryMagicIndexTable, sizeof(MysteryMagicIndexTable), -1);
end;

destructor THaveMagicClass.Destroy;
begin
   inherited destroy;
end;

procedure THaveMagicClass.AddPowerLevelLifeData;
begin
   with HaveMagicLifeData do begin
      //盔扁单固瘤 利侩 规侥阑 函版窍绰巴篮 闺繁胶饶俊 甸绢皑.
      //DamageBody := DamageBody + DamageBody * MagicClass.GetPowerLevelDamage (FCurPowerLevel) div 1000;

      //扁粮 盔扁单固瘤规侥
      DamageBody := DamageBody + MagicClass.GetPowerLevelDamage (FCurPowerLevel);
      DamageHead := DamageHead; // + MagicClass.GetPowerLevelDamage (FCurPowerLevel);
      DamageArm := DamageArm; // + MagicClass.GetPowerLevelDamage (FCurPowerLevel);
      DamageLeg := DamageLeg; // + MagicClass.GetPowerLevelDamage (FCurPowerLevel);
      ArmorBody := armorBody + MagicClass.GetPowerLevelArmor (FCurPowerLevel);
      ArmorHead := armorHead; // + MagicClass.GetPowerLevelArmor (FCurPowerLevel);
      ArmorArm := armorArm; // + MagicClass.GetPowerLevelArmor (FCurPowerLevel);
      ArmorLeg := armorLeg; // + MagicClass.GetPowerLevelArmor (FCurPowerLevel);

      AttackSpeed := AttackSpeed + MagicClass.GetPowerLevelAttackSpeed (FCurPowerLevel);
      Avoid := avoid + MagicClass.GetPowerLevelAvoid (FCurPowerLevel);
      Recovery := recovery + MagicClass.GetPowerLevelRecovery (FCurPowerLevel);
      Accuracy := accuracy + MagicClass.GetPowerLevelAccuracy (FCurPowerLevel);
      Keeprecovery := keeprecovery + MagicClass.GetPowerLevelKeepRecovery (FCurPowerLevel);
   end;
end;

procedure THaveMagicClass.SetLifeData;
   procedure AddLifeData (p: PTMagicData);
   var
      i, SkillLevel : Integer;
   begin
      if p = nil then exit;

      SkillLevel := p^.rcSkillLevel;
      if p^.rMagicClass = MAGICCLASS_RISEMAGIC then begin // 惑铰公傍
         HaveMagicLifeData.DamageBody      := HaveMagicLifeData.DamageBody      + p^.rLifeData.damageBody + p^.rLifeData.damageBody * SkillLevel div 3000;
         HaveMagicLifeData.DamageHead      := HaveMagicLifeData.DamageHead      + p^.rLifeData.damageHead + p^.rLifeData.damageHead * SkillLevel div INI_SKILL_DIV_DAMAGE2;
         HaveMagicLifeData.DamageArm       := HaveMagicLifeData.DamageArm       + p^.rLifeData.damageArm  + p^.rLifeData.damageArm  * SkillLevel div INI_SKILL_DIV_DAMAGE2;
         HaveMagicLifeData.DamageLeg       := HaveMagicLifeData.DamageLeg       + p^.rLifeData.damageLeg  + p^.rLifeData.damageLeg  * SkillLevel div INI_SKILL_DIV_DAMAGE2;

         HaveMagicLifeData.AttackSpeed     := HaveMagicLifeData.AttackSpeed     + p^.rLifeData.AttackSpeed - p^.rLifeData.AttackSpeed * SkillLevel div 15000;
         HaveMagicLifeData.avoid           := HaveMagicLifeData.avoid           + p^.rLifeData.avoid;
         HaveMagicLifeData.recovery        := HaveMagicLifeData.recovery        + p^.rLifeData.recovery;
         HaveMagicLifeData.accuracy        := HaveMagicLifeData.accuracy        + p^.rLifeData.accuracy - p^.rLifeData.accuracy * (10000-SkillLevel) div 10000; // 瘤陛
         HaveMagicLifeData.keeprecovery    := HaveMagicLifeData.keeprecovery    + p^.rLifeData.keeprecovery - p^.rLifeData.keeprecovery * (10000-SkillLevel) div 10000; // 瘤陛
         HaveMagicLifeData.armorBody       := HaveMagicLifeData.armorBody       + p^.rLifeData.armorBody + p^.rLifeData.armorBody * SkillLevel div INI_SKILL_DIV_ARMOR2;
         HaveMagicLifeData.armorHead       := HaveMagicLifeData.armorHead       + p^.rLifeData.armorHead + p^.rLifeData.armorHead * SkillLevel div INI_SKILL_DIV_ARMOR2;
         HaveMagicLifeData.armorArm        := HaveMagicLifeData.armorArm        + p^.rLifeData.armorArm  + p^.rLifeData.armorArm  * SkillLevel div INI_SKILL_DIV_ARMOR2;
         HaveMagicLifeData.armorLeg        := HaveMagicLifeData.armorLeg        + p^.rLifeData.armorLeg  + p^.rLifeData.armorLeg  * SkillLevel div INI_SKILL_DIV_ARMOR2;
      end else if p^.rMagicClass = MAGICCLASS_MYSTERY then begin
         //厘过篮 个烹 傍拜仿父 啊咙
         HaveMagicLifeData.DamageBody      := HaveMagicLifeData.DamageBody      + p^.rLifeData.damageBody + p^.rLifeData.damageBody * SkillLevel div 2500;
         HaveMagicLifeData.AttackSpeed     := HaveMagicLifeData.AttackSpeed     + p^.rLifeData.AttackSpeed - p^.rLifeData.AttackSpeed * SkillLevel div INI_SKILL_DIV_ATTACKSPEED3;
         HaveMagicLifeData.avoid           := HaveMagicLifeData.avoid           + p^.rLifeData.avoid + p^.rLifeData.avoid * SkillLevel div 9999;
         HaveMagicLifeData.accuracy        := HaveMagicLifeData.accuracy        + p^.rLifeData.accuracy + p^.rLifeData.accuracy * SkillLevel div 9999; // 瘤陛
         HaveMagicLifeData.recovery        := HaveMagicLifeData.recovery        + p^.rLifeData.recovery;
         HaveMagicLifeData.keeprecovery    := HaveMagicLifeData.keeprecovery    + p^.rLifeData.keeprecovery + p^.rLifeData.keeprecovery * SkillLevel div INI_SKILL_DIV_KEEPRECOVERY3;
      end else if p^.rMagicClass = MAGICCLASS_MAGIC then begin
         HaveMagicLifeData.DamageBody      := HaveMagicLifeData.DamageBody      + p^.rLifeData.damageBody + p^.rLifeData.damageBody * p^.rcSkillLevel div INI_SKILL_DIV_DAMAGE;
         HaveMagicLifeData.DamageHead      := HaveMagicLifeData.DamageHead      + p^.rLifeData.damageHead + p^.rLifeData.damageHead * p^.rcSkillLevel div INI_SKILL_DIV_DAMAGE;
         HaveMagicLifeData.DamageArm       := HaveMagicLifeData.DamageArm       + p^.rLifeData.damageArm  + p^.rLifeData.damageArm  * p^.rcSkillLevel div INI_SKILL_DIV_DAMAGE;
         HaveMagicLifeData.DamageLeg       := HaveMagicLifeData.DamageLeg       + p^.rLifeData.damageLeg  + p^.rLifeData.damageLeg  * p^.rcSkillLevel div INI_SKILL_DIV_DAMAGE;
         HaveMagicLifeData.AttackSpeed     := HaveMagicLifeData.AttackSpeed     + p^.rLifeData.AttackSpeed - p^.rLifeData.AttackSpeed * p^.rcSkillLevel div INI_SKILL_DIV_ATTACKSPEED;
         HaveMagicLifeData.avoid           := HaveMagicLifeData.avoid           + p^.rLifeData.avoid;
         HaveMagicLifeData.recovery        := HaveMagicLifeData.recovery        + p^.rLifeData.recovery;
         HaveMagicLifeData.Accuracy        := HaveMagicLifeData.Accuracy        + p^.rLifeData.Accuracy;
         HaveMagicLifeData.KeepRecovery    := HaveMagicLifeData.KeepRecovery    + p^.rLifeData.KeepRecovery;
         HaveMagicLifeData.armorBody       := HaveMagicLifeData.armorBody       + p^.rLifeData.armorBody + p^.rLifeData.armorBody * p^.rcSkillLevel div INI_SKILL_DIV_ARMOR;
         HaveMagicLifeData.armorHead       := HaveMagicLifeData.armorHead       + p^.rLifeData.armorHead + p^.rLifeData.armorHead * p^.rcSkillLevel div INI_SKILL_DIV_ARMOR;
         HaveMagicLifeData.armorArm        := HaveMagicLifeData.armorArm        + p^.rLifeData.armorArm  + p^.rLifeData.armorArm  * p^.rcSkillLevel div INI_SKILL_DIV_ARMOR;
         HaveMagicLifeData.armorLeg        := HaveMagicLifeData.armorLeg        + p^.rLifeData.armorLeg  + p^.rLifeData.armorLeg  * p^.rcSkillLevel div INI_SKILL_DIV_ARMOR;
      end else if p^.rMagicClass = MAGICCLASS_BESTMAGIC then begin
         HaveMagicLifeData.damageBody     := HaveMagicLifeData.damageBody + p^.rcLifeData.damageBody;
         HaveMagicLifeData.damageHead     := HaveMagicLifeData.damageHead + p^.rcLifeData.damageHead;
         HaveMagicLifeData.damageArm      := HaveMagicLifeData.damageArm + p^.rcLifeData.damageArm;
         HaveMagicLifeData.damageLeg      := HaveMagicLifeData.damageLeg + p^.rcLifeData.damageLeg;
         HaveMagicLifeData.damageEnergy   := HaveMagicLifeData.damageEnergy + p^.rcLifeData.damageEnergy;
         HaveMagicLifeData.armorBody      := HaveMagicLifeData.armorBody + p^.rcLifeData.armorBody;
         HaveMagicLifeData.armorHead      := HaveMagicLifeData.armorHead + p^.rcLifeData.armorHead;
         HaveMagicLifeData.armorArm       := HaveMagicLifeData.armorArm  + p^.rcLifeData.armorArm;
         HaveMagicLifeData.armorLeg       := HaveMagicLifeData.armorLeg + p^.rcLifeData.armorLeg;
         HaveMagicLifeData.armorEnergy    := HaveMagicLifeData.armorEnergy + p^.rcLifeData.armorEnergy;

         HaveMagicLifeData.AttackSpeed    := HaveMagicLifeData.AttackSpeed + p^.rcLifeData.AttackSpeed;
         HaveMagicLifeData.recovery       := HaveMagicLifeData.recovery + p^.rcLifeData.recovery;
         HaveMagicLifeData.Accuracy       := HaveMagicLifeData.Accuracy + p^.rcLifeData.Accuracy;
         HaveMagicLifeData.avoid          := HaveMagicLifeData.avoid + p^.rcLifeData.avoid;
         HaveMagicLifeData.KeepRecovery   := HaveMagicLifeData.KeepRecovery + p^.rcLifeData.KeepRecovery;
      end;
      
      for i := 0 to SPELLTYPE_MAX - 1 do begin
         if p^.rLifeData.SpellResistRate [i] > 0 then begin
            HaveMagicLifeData.SpellResistRate [i] := HaveMagicLifeData.SpellResistRate [i] + p^.rLifeData.SpellResistRate [i];
            if HaveMagicLifeData.SpellResistRate [i] > 100 then HaveMagicLifeData.SpellResistRate [i] := 100;
         end;
      end;
   end;
var
   str : string;
begin
   FillChar (HaveMagicLifeData, sizeof(TLifeData), 0);

   if pCurAttackMagic <> nil then begin
      AddLifeData (pCurAttackMagic);
      case pCurAttackMagic^.rMagicClass of
         MAGICCLASS_MYSTERY : begin
            HaveMagicLifeData.damageBody := HaveMagicLifeData.damageBody + HaveMagicLifeData.DamageBody * MagicClass.GetSkillDamageBodyForPalm (pCurAttackMagic^.rcSkillLevel) div 100;
            HaveMagicLifeData.longavoid := MagicClass.GetSkillLongAvoidForPalm (pCurAttackMagic^.rcSkillLevel);
         end;
         MAGICCLASS_BESTMAGIC : begin
//            AddAttributeRelationBestMagic;
         end;
         Else begin
            HaveMagicLifeData.damageBody := HaveMagicLifeData.damageBody + HaveMagicLifeData.DamageBody * MagicClass.GetSkillDamageBody (pCurAttackMagic^.rcSkillLevel) div 100;
         end;
      end;
      {
      HaveMagicLifeData.damageHead := HaveMagicLifeData.damageHead;
      HaveMagicLifeData.damageArm  := HaveMagicLifeData.damageArm;
      HaveMagicLifeData.damageLeg  := HaveMagicLifeData.damageLeg;
      }
   end;

   AddLifeData (pCurBreathngMagic);
   AddLifeData (pCurRunningMagic);
   AddLifeData (pCurProtectingMagic);
   if pCurProtectingMagic <> nil then begin
      HaveMagicLifeData.ArmorBody := HaveMagicLifeData.ArmorBody + HaveMagicLifeData.ArmorBody * MagicClass.GetSkillArmorBody (pCurProtectingMagic^.rcSkillLevel) div 100;
   end;

   AddLifeData (pCurEctMagic);

   AddAttributeRelationBestMagic;

   str := '';
   if pCurAttackMagic <> nil then str := str + StrPas (@pCurAttackMagic^.rName) + ',';
   if pCurBreathngMagic <> nil then str := str + StrPas (@pCurBreathngMagic^.rName) + ',';
   if pCurRunningMagic <> nil then str := str + StrPas (@pCurRunningMagic^.rName) + ',';
   if pCurProtectingMagic <> nil then str := str + StrPas (@pCurProtectingMagic^.rName) + ',';
   if pCurEctMagic <> nil then str := str + StrPas (@pCurEctMagic^.rName) + ',';
   if pCurSpecialMagic <> nil then str := str + StrPas (@pCurSpecialMagic^.rName) + ',';   
   FSendClass.SendUsedMagicString (str);

   HaveMagicLifeData.damageExp := HaveMagicLifeData.damageBody;
   HaveMagicLifeData.armorExp := HaveMagicLifeData.armorBody;

   if pCurAttackMagic <> nil then begin
      if pCurAttackMagic^.rMagicClass = MAGICCLASS_RISEMAGIC then begin  // 惑铰公傍
         HaveMagicLifeData.damageBody     := HaveMagicLifeData.damageBody + RISEMAGIC_ADDDAMAGE + RISEMAGIC_ADDDAMAGE div 2;
         HaveMagicLifeData.damageHead     := HaveMagicLifeData.damageHead + RISEMAGIC_ADDDAMAGE;
         HaveMagicLifeData.damageArm      := HaveMagicLifeData.damageArm + RISEMAGIC_ADDDAMAGE;
         HaveMagicLifeData.damageLeg      := HaveMagicLifeData.damageLeg + RISEMAGIC_ADDDAMAGE;
//         HaveMagicLifeData.damageenergy   := HaveMagicLifeData.damageenergy + RISEMAGIC_ADDDAMAGE + RISEMAGIC_ADDDAMAGE div 2;
         HaveMagicLifeData.armorBody      := HaveMagicLifeData.armorBody + RISEMAGIC_ADDDAMAGE div 2;
      end;
      if pCurAttackMagic^.rMagicClass <> MAGICCLASS_MYSTERY then begin
         AddPowerLevelLifeData;
      end;
   end;


   TUserObject (FBasicObject).SetLifeData;
end;

procedure THaveMagicClass.LoadFromSdb (aCharData : PTDBRecord);
var
   i, n, PowerValue : integer;
   str : String;
   tmpMagicData : TMagicData;
   boRet : Boolean;
begin
   ReQuestPlaySoundNumber := 0;

   MagicClass.GetMagicData (INI_DEF_WRESTLING, DefaultMagic[default_wrestling], aCharData^.BasicMagicArr[0].Skill);
   MagicClass.GetMagicData (INI_DEF_FENCING, DefaultMagic[default_fencing], aCharData^.BasicMagicArr[1].Skill);
   MagicClass.GetMagicData (INI_DEF_SWORDSHIP, DefaultMagic[default_swordship], aCharData^.BasicMagicArr[2].Skill);
   MagicClass.GetMagicData (INI_DEF_HAMMERING, DefaultMagic[default_hammering], aCharData^.BasicMagicArr[3].Skill);
   MagicClass.GetMagicData (INI_DEF_SPEARING, DefaultMagic[default_spearing], aCharData^.BasicMagicArr[4].Skill);
   MagicClass.GetMagicData (INI_DEF_BOWING, DefaultMagic[default_bowing], aCharData^.BasicMagicArr[5].Skill);
   MagicClass.GetMagicData (INI_DEF_THROWING, DefaultMagic[default_throwing], aCharData^.BasicMagicArr[6].Skill);
   MagicClass.GetMagicData (INI_DEF_RUNNING, DefaultMagic[default_running], aCharData^.BasicMagicArr[8].Skill);
   MagicClass.GetMagicData (INI_DEF_BREATHNG, DefaultMagic[default_breathng], aCharData^.BasicMagicArr[7].Skill);
   MagicClass.GetMagicData (INI_DEF_PROTECTING, DefaultMagic[default_Protecting], aCharData^.BasicMagicArr[9].Skill);

   for i := 0 to 10 - 1 do begin
      MagicClass.Calculate_cLifeData (@DefaultMagic[i]);
      FSendClass.SendBasicMagic (i, DefaultMagic[i]);
   end;

   for i := 10 to 20 - 1 do begin
      str := StrPas (@aCharData^.BasicRiseMagicArr[i - 10].Name) + ':' + IntToStr (aCharData^.BasicRiseMagicArr[i - 10].Skill);
      MagicClass.GetHaveMagicData (str, DefaultMagic [i]);
      MagicClass.Calculate_cLifeData (@DefaultMagic [i]);
      FSendClass.SendBasicMagic (i, DefaultMagic [i]);
   end;

   for i := 0 to 10 - 1 do begin
      if (FAttribClass.Virtue > 6000) and (FAttribClass.Energy > 8000) then begin
         if DefaultMagic [i].rcSkillLevel = 9999 then begin
            if DefaultMagic [10 + i].rname [0] = 0 then begin
               Case DefaultMagic [i].rMagicType of
                  MAGICTYPE_WRESTLING :
                     begin
                        if MagicClass.GetMagicData (INI_DEF_WRESTLING2, tmpMagicData, 0) = true then begin
                           n := 10 + tmpMagicData.rMagicType;
                           Move (tmpMagicData, DefaultMagic [n], SizeOf (TMagicData));
                           FSendClass.SendBasicMagic (n, DefaultMagic [n]);
                        end;
                     end;
                  MAGICTYPE_FENCING :
                     begin
                        if MagicClass.GetMagicData (INI_DEF_FENCING2, tmpMagicData, 0) = true then begin
                           n := 10 + tmpMagicData.rMagicType;
                           Move (tmpMagicData, DefaultMagic [n], SizeOf (TMagicData));
                           FSendClass.SendBasicMagic (n, DefaultMagic [n]);
                        end;
                     end;
                  MAGICTYPE_SWORDSHIP :
                     begin
                        if MagicClass.GetMagicData (INI_DEF_SWORDSHIP2, tmpMagicData, 0) = true then begin
                           n := 10 + tmpMagicData.rMagicType;
                           Move (tmpMagicData, DefaultMagic [n], SizeOf (TMagicData));
                           FSendClass.SendBasicMagic (n, DefaultMagic [n]);
                        end;
                     end;
                  MAGICTYPE_HAMMERING :
                     begin
                        if MagicClass.GetMagicData (INI_DEF_HAMMERING2, tmpMagicData, 0) = true then begin
                           n := 10 + tmpMagicData.rMagicType;
                           Move (tmpMagicData, DefaultMagic [n], SizeOf (TMagicData));
                           FSendClass.SendBasicMagic (n, DefaultMagic [n]);
                        end;
                     end;
                  MAGICTYPE_SPEARING :
                     begin
                        if MagicClass.GetMagicData (INI_DEF_SPEARING2, tmpMagicData, 0) = true then begin
                           n := 10 + tmpMagicData.rMagicType;
                           Move (tmpMagicData, DefaultMagic [n], SizeOf (TMagicData));
                           FSendClass.SendBasicMagic (n, DefaultMagic [n]);
                        end;
                     end;
                  MAGICTYPE_BOWING :
                     begin
                        if MagicClass.GetMagicData (INI_DEF_BOWING2, tmpMagicData, 0) = true then begin
                           n := 10 + tmpMagicData.rMagicType;
                           Move (tmpMagicData, DefaultMagic [n], SizeOf (TMagicData));
                           FSendClass.SendBasicMagic (n, DefaultMagic [n]);
                        end;
                     end;
                  MAGICTYPE_THROWING :
                     begin
                        if MagicClass.GetMagicData (INI_DEF_THROWING2, tmpMagicData, 0) = true then begin
                           n := 10 + tmpMagicData.rMagicType;
                           Move (tmpMagicData, DefaultMagic [n], SizeOf (TMagicData));
                           FSendClass.SendBasicMagic (n, DefaultMagic [n]);
                        end;
                     end;
                  MAGICTYPE_RUNNING :
                     begin
                        {
                        if MagicClass.GetMagicData (INI_DEF_RUNNING2, tmpMagicData, 0) = true then begin
                           n := 10 + tmpMagicData.rMagicType;
                           Move (tmpMagicData, DefaultMagic [n], SizeOf (TMagicData));
                           FSendClass.SendBasicMagic (n, DefaultMagic [n]);
                        end;
                        }
                     end;
                  MAGICTYPE_BREATHNG :
                     begin
                        if MagicClass.GetMagicData (INI_DEF_BREATHNG2, tmpMagicData, 0) = true then begin
                           n := 10 + tmpMagicData.rMagicType;
                           Move (tmpMagicData, DefaultMagic [n], SizeOf (TMagicData));
                           FSendClass.SendBasicMagic (n, DefaultMagic [n]);
                        end;
                     end;
                  MAGICTYPE_PROTECTING :
                     begin
                        if MagicClass.GetMagicData (INI_DEF_PROTECTING2, tmpMagicData, 0) = true then begin
                           n := 10 + tmpMagicData.rMagicType;
                           Move (tmpMagicData, DefaultMagic [n], SizeOf (TMagicData));
                           FSendClass.SendBasicMagic (n, DefaultMagic [n]);
                        end;
                     end;
               end;
            end;
         end;
      end;
   end;

   PowerValue := FAttribClass.Age div 2;
   for i := 0 to 20 - 1 do begin
      if DefaultMagic[i].rname[0] = 0 then continue;
      if DefaultMagic[i].rMagicClass = 0 then begin
         SetMagicIndex (false, DefaultMagic[i].rMagicType, MAGICRELATION_3, i);
      end else begin
         SetMagicIndex (true, DefaultMagic[i].rMagicType, MAGICRELATION_3, i);
      end;

      if DefaultMagic[i].rMagicClass = MAGICCLASS_MAGIC then begin
         //盔扁拌魂. 扁夯公傍何盒 盔扁利侩
         case DefaultMagic[i].rcSkillLevel of
            5000..5999 : begin
               PowerValue := PowerValue + DefaultMagic[i].rEnergyPoint div 10;
            end;
            6000..6999 : begin
               PowerValue := PowerValue + DefaultMagic[i].rEnergyPoint * 2 div 10;
            end;
            7000..7999 : begin
               PowerValue := PowerValue + DefaultMagic[i].rEnergyPoint * 3 div 10;
            end;
            8000..8999 : begin
               PowerValue := PowerValue + DefaultMagic[i].rEnergyPoint * 4 div 10;
            end;
            9000..9998 : begin
               PowerValue := PowerValue + DefaultMagic[i].rEnergyPoint * 5 div 10;
            end;
            9999 : begin
               PowerValue := PowerValue + DefaultMagic[i].rEnergyPoint;
            end;
         end;
      end else begin
         if DefaultMagic [i].rcSkillLevel = 9999 then begin
            PowerValue := PowerValue + DefaultMagic [i].rEnergyPoint;
          end;
      end;
   end;

   for i := 0 to HAVEMAGICSIZE-1 do begin
      str := StrPas (@aCharData^.HaveMagicArr[i].Name) + ':' + IntToStr (aCharData^.HaveMagicArr[i].Skill);
      MagicClass.GetHaveMagicData (str, HaveMagicArr[i]);
      MagicClass.Calculate_cLifeData (@HaveMagicArr[i]);
      FSendClass.SendHaveMagic (i, HaveMagicArr[i]);

      if HaveMagicArr[i].rname[0] = 0 then continue;
      if HaveMagicArr[i].rGuildMagictype = 0  then
         SetMagicIndex(false, HaveMagicArr[i].rMagicType, HaveMagicArr[i].rMagicRelation, i);
      //盔扁拌魂. 厘过 何盒 盔扁利侩
         case HaveMagicArr[i].rcSkillLevel of
            5000..5999 : begin
               PowerValue := PowerValue + HaveMagicArr[i].rEnergyPoint div 10;
            end;
            6000..6999 : begin
               PowerValue := PowerValue + HaveMagicArr[i].rEnergyPoint * 2 div 10;
            end;
            7000..7999 : begin
               PowerValue := PowerValue + HaveMagicArr[i].rEnergyPoint * 3 div 10;
            end;
            8000..8999 : begin
               PowerValue := PowerValue + HaveMagicArr[i].rEnergyPoint * 4 div 10;
            end;
            9000..9998 : begin
               PowerValue := PowerValue + HaveMagicArr[i].rEnergyPoint * 5 div 10;
            end;
            9999 : begin
               PowerValue := PowerValue + HaveMagicArr[i].rEnergyPoint;
            end;
         end;
   end;

   for i := 0 to HAVERISEMAGICSIZE-1 do begin
       str := StrPas (@aCharData^.HaveRiseMagicArr[i].Name) + ':' + IntToStr (aCharData^.HaveRiseMagicArr[i].Skill);
      MagicClass.GetHaveMagicData (str, HaveRiseMagicArr[i]);
      MagicClass.Calculate_cLifeData (@HaveRiseMagicArr[i]);
      FSendClass.SendHaveRiseMagic (i, HaveRiseMagicArr[i]);
      if HaveRiseMagicArr[i].rname[0] = 0 then continue;
      SetMagicIndex (true, HaveRiseMagicArr[i].rMagicType, HaveRiseMagicArr[i].rMagicRelation, i);
      if HaveRiseMagicArr [i].rcSkillLevel = 9999 then begin
         PowerValue := PowerValue + HaveRiseMagicArr [i].rEnergyPoint;
      end;
   end;

   //2002-11-06 giltae
   for i := 0 to HAVEMYSTERYMAGICSIZE-1 do begin
      str := StrPas (@aCharData^.HaveMysteryArr[i].Name) + ':' + IntToStr (aCharData^.HaveMysteryArr[i].Skill);
      MagicClass.GetHaveMagicData (str, HaveMysteryMagicArr[i]);
      MagicClass.Calculate_cLifeData (@HaveMysteryMagicArr[i]);
      FSendClass.SendHaveMystery (i, HaveMysteryMagicArr[i]);
      if HaveMysteryMagicArr[i].rname[0] = 0 then continue;
      SetMysteryMagicIndex (HaveMysteryMagicArr[i].rMagicRelation, i);

      //盔扁拌魂. 厘过 何盒 盔扁利侩
      case HaveMysteryMagicArr[i].rcSkillLevel of
         5000..5999 : begin
            PowerValue := PowerValue + HaveMysteryMagicArr[i].rEnergyPoint div 10;
         end;
         6000..6999 : begin
            PowerValue := PowerValue + HaveMysteryMagicArr[i].rEnergyPoint * 2 div 10;
         end;
         7000..7999 : begin
            PowerValue := PowerValue + HaveMysteryMagicArr[i].rEnergyPoint * 3 div 10;
         end;
         8000..8999 : begin
            PowerValue := PowerValue + HaveMysteryMagicArr[i].rEnergyPoint * 4 div 10;
         end;
         9000..9998 : begin
            PowerValue := PowerValue + HaveMysteryMagicArr[i].rEnergyPoint * 5 div 10;
         end;
         9999 : begin
            PowerValue := PowerValue + HaveMysteryMagicArr[i].rEnergyPoint;
         end;
      end;
   end;

   //2003-09-19 檬荐绰 醚 15俺鳖瘤, 傍仿篮 5俺, 例技公傍篮 5俺鳖瘤 登绢 乐澜
   //努扼捞攫飘惑俊辑 焊捞绰 困摹啊 力茄利捞扼 25俺甫 鞍捞 苟摹瘤 臼澜
   for i := 0 to HAVEBESTSPECIALMAGICSIZE-1 do begin
      str := GetBestMagicString(aCharData^.HaveBestSpecialMagicArr[i]);
      MagicClass.GetHaveBestMagicData (str, HaveBestSpecialMagicArr[i]);
      MagicClass.Calculate_cLifeData (@HaveBestSpecialMagicArr[i]);
      FSendClass.SendHaveBestSpecialMagic (i, HaveBestSpecialMagicArr[i]);
      if HaveBestSpecialMagicArr[i].rname[0] = 0 then continue;
      {
      if HaveBestSpecialMagicArr [i].rcSkillLevel = 9999 then begin
         PowerValue := PowerValue + HaveBestSpecialMagicArr [i].rEnergyPoint;
      end;
      }
   end;
   for i := 0 to HAVEBESTPROTECTMAGICSIZE-1 do begin
      str := GetBestMagicString(aCharData^.HaveBestProtectMagicArr[i]);
      MagicClass.GetHaveBestMagicData (str, HaveBestProtectMagicArr[i]);
      MagicClass.Calculate_cLifeData (@HaveBestProtectMagicArr[i]);
      FSendClass.SendHaveBestProtectMagic (i, HaveBestProtectMagicArr[i]);
      if HaveBestProtectMagicArr[i].rname[0] = 0 then continue;
      MagicCycleClass.GetEnergyPointData (@HaveBestProtectMagicArr[i]);

      PowerValue := PowerValue + HaveBestProtectMagicArr [i].rEnergyPoint;
   end;
   for i := 0 to HAVEBESTATTACKMAGICSIZE-1 do begin
      str := GetBestMagicString(aCharData^.HaveBestAttackMagicArr[i]);
      MagicClass.GetHaveBestMagicData (str, HaveBestAttackMagicArr[i]);
      MagicClass.Calculate_cLifeData (@HaveBestAttackMagicArr[i]);
      FSendClass.SendHaveBestAttackMagic (i, HaveBestAttackMagicArr[i]);
      if HaveBestAttackMagicArr[i].rname[0] = 0 then continue;
      MagicCycleClass.GetEnergyPointData (@HaveBestAttackMagicArr[i]);

      PowerValue := PowerValue + HaveBestAttackMagicArr [i].rEnergyPoint;
   end;

   //俺喊利牢 盔扁甫 歹沁促.
   //盔扁焊呈胶甫 利侩茄促.
   //啊肺葫绊
   for i := MAGICTYPE_WRESTLING to MAGICTYPE_SPEARING do begin
      boRet := boBingGoColumn(false, i, 0);
      if boRet = true then PowerValue := PowerValue + 700;
      //惑铰啊肺葫绊
      boRet := boBingGoColumn(true, i, 0);
      if boRet = true then PowerValue := PowerValue + 1050;
   end;
   //货肺葫绊
   for i := MAGICRELATION_0 to MAGICRELATION_6 do begin
      boRet := boBingGoRow (false, 0, i);
      if boRet = true then PowerValue := PowerValue + 500;
      //惑铰技肺葫绊
      boRet := boBingGoRow (true, 0, i);
      if boRet = true then PowerValue := PowerValue + 750;
   end;
   //碍脚葫绊
   boRet := boBingGoColumn (false, MAGICTYPE_PROTECTING, 0);
   if boRet = true then PowerValue := PowerValue + 700;
   //惑铰碍脚葫绊
   boRet := boBingGoColumn (true, MAGICTYPE_PROTECTING, 0);
   if boRet = true then PowerValue := PowerValue + 1050;

   //厘过葫绊
   boRet := boBingGoMystery;
   if boRet = true then PowerValue := PowerValue + 1500;

   FAttribClass.SetEnergyValue (PowerValue);

   FPowerLevel := MagicClass.CalcPowerLevel (PowerValue);
   FCurPowerLevel := FPowerLevel;

   MaxShieldCalculate;
   FCurrentShield := FMaxShield;

   FPowerLevelName := MagicClass.GetPowerLevelName (FPowerLevel);
   FSendClass.SendShowPowerLevel (FPowerLevelName, FCurPowerLevel);

   WalkingCount := 0;
   FpCurAttackMagic     := nil;
   FpCurBreathngMagic   := nil;
   FpCurRunningMagic    := nil;
   FpCurProtectingMagic := nil;
   FpCurEctMagic        := nil;
   FCurrentGrade := aCharData^.CurrentGrade;   

   SetLifeData;
end;

procedure THaveMagicClass.SaveToSdb (aCharData : PTDBRecord);
var
   i : integer;
   str, rdstr : String;
begin
   aCharData^.CurrentGrade := FCurrentGrade;
   
   aCharData^.BasicMagicArr[0].Skill := DefaultMagic[default_wrestling].rSkillExp;
   aCharData^.BasicMagicArr[1].Skill := DefaultMagic[default_fencing].rSkillExp;
   aCharData^.BasicMagicArr[2].Skill := DefaultMagic[default_swordship].rSkillExp;
   aCharData^.BasicMagicArr[3].Skill := DefaultMagic[default_hammering].rSkillExp;
   aCharData^.BasicMagicArr[4].Skill := DefaultMagic[default_spearing].rSkillExp;
   aCharData^.BasicMagicArr[5].Skill := DefaultMagic[default_bowing].rSkillExp;
   aCharData^.BasicMagicArr[6].Skill := DefaultMagic[default_throwing].rSkillExp;
   aCharData^.BasicMagicArr[8].Skill := DefaultMagic[default_running].rSkillExp;
   aCharData^.BasicMagicArr[7].Skill := DefaultMagic[default_breathng].rSkillExp;
   aCharData^.BasicMagicArr[9].Skill := DefaultMagic[default_Protecting].rSkillExp;

   for i := 10 to 20 - 1 do begin
      str := MagicClass.GetHaveMagicString (DefaultMagic [i]);
      str := GetValidStr3 (str, rdstr, ':');
      StrPCopy (@aCharData^.BasicRiseMagicArr[i - 10].Name, rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      aCharData^.BasicRiseMagicArr[i - 10].Skill := _StrToInt (rdstr);
   end;

   for i := 0 to HAVEMAGICSIZE-1 do begin
      str := MagicClass.GetHaveMagicString (HaveMagicArr[i]);
      str := GetValidStr3 (str, rdstr, ':');
      StrPCopy (@aCharData^.HaveMagicArr[i].Name, rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      aCharData^.HaveMagicArr[i].Skill := _StrToInt (rdstr);
   end;

   for i := 0 to HAVERISEMAGICSIZE - 1 do begin
      str := MagicClass.GetHaveMagicString (HaveRiseMagicArr[i]);
      str := GetValidStr3 (str, rdstr, ':');
      StrPCopy (@aCharData^.HaveRiseMagicArr[i].Name, rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      aCharData^.HaveRiseMagicArr[i].Skill := _StrToInt (rdstr);
   end;

   //2002-11-13
   for i := 0 to HAVEMYSTERYMAGICSIZE - 1 do begin
      str := MagicClass.GetHaveMagicString (HaveMysteryMagicArr[i]);
      str := GetValidStr3 (str, rdstr, ':');
      StrPCopy (@aCharData^.HaveMysteryArr[i].Name, rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      aCharData^.HaveMysteryArr[i].Skill := _StrToInt (rdstr);
   end;
   //2003-09-19
   for i := 0 to HAVEBESTSPECIALMAGICSIZE - 1 do begin
      str := MagicClass.GetHaveBestMagicString (HaveBestSpecialMagicArr[i]);
      str := GetValidStr3 (str, rdstr, ':');
      StrPCopy (@aCharData^.HaveBestSpecialMagicArr[i].Name, rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      aCharData^.HaveBestSpecialMagicArr[i].Skill := _StrToInt (rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      aCharData^.HaveBestSpecialMagicArr[i].Grade := _StrToInt(rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      aCharData^.HaveBestSpecialMagicArr[i].rDamageBody := _StrToInt(rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      aCharData^.HaveBestSpecialMagicArr[i].rDamageHead := _StrToInt(rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      aCharData^.HaveBestSpecialMagicArr[i].rDamageArm := _StrToInt(rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      aCharData^.HaveBestSpecialMagicArr[i].rDamageLeg := _StrToInt(rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      aCharData^.HaveBestSpecialMagicArr[i].rDamageEnergy := _StrToInt(rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      aCharData^.HaveBestSpecialMagicArr[i].rArmorBody := _StrToInt(rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      aCharData^.HaveBestSpecialMagicArr[i].rArmorHead := _StrToInt(rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      aCharData^.HaveBestSpecialMagicArr[i].rArmorArm := _StrToInt(rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      aCharData^.HaveBestSpecialMagicArr[i].rArmorLeg := _StrToInt(rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      aCharData^.HaveBestSpecialMagicArr[i].rArmorEnergy := _StrToInt(rdstr);
   end;

   for i := 0 to HAVEBESTPROTECTMAGICSIZE - 1 do begin
      str := MagicClass.GetHaveBestMagicString (HaveBestProtectMagicArr[i]);
      str := GetValidStr3 (str, rdstr, ':');
      StrPCopy (@aCharData^.HaveBestProtectMagicArr[i].Name, rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      aCharData^.HaveBestProtectMagicArr[i].Skill := _StrToInt (rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      aCharData^.HaveBestProtectMagicArr[i].Grade := _StrToInt(rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      aCharData^.HaveBestProtectMagicArr[i].rDamageBody := _StrToInt(rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      aCharData^.HaveBestProtectMagicArr[i].rDamageHead := _StrToInt(rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      aCharData^.HaveBestProtectMagicArr[i].rDamageArm := _StrToInt(rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      aCharData^.HaveBestProtectMagicArr[i].rDamageLeg := _StrToInt(rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      aCharData^.HaveBestProtectMagicArr[i].rDamageEnergy := _StrToInt(rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      aCharData^.HaveBestProtectMagicArr[i].rArmorBody := _StrToInt(rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      aCharData^.HaveBestProtectMagicArr[i].rArmorHead := _StrToInt(rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      aCharData^.HaveBestProtectMagicArr[i].rArmorArm := _StrToInt(rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      aCharData^.HaveBestProtectMagicArr[i].rArmorLeg := _StrToInt(rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      aCharData^.HaveBestProtectMagicArr[i].rArmorEnergy := _StrToInt(rdstr);
   end;

   for i := 0 to HAVEBESTATTACKMAGICSIZE - 1 do begin
      str := MagicClass.GetHaveBestMagicString (HaveBestAttackMagicArr[i]);
      str := GetValidStr3 (str, rdstr, ':');
      StrPCopy (@aCharData^.HaveBestAttackMagicArr[i].Name, rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      aCharData^.HaveBestAttackMagicArr[i].Skill := _StrToInt (rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      aCharData^.HaveBestAttackMagicArr[i].Grade := _StrToInt(rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      aCharData^.HaveBestAttackMagicArr[i].rDamageBody := _StrToInt(rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      aCharData^.HaveBestAttackMagicArr[i].rDamageHead := _StrToInt(rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      aCharData^.HaveBestAttackMagicArr[i].rDamageArm := _StrToInt(rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      aCharData^.HaveBestAttackMagicArr[i].rDamageLeg := _StrToInt(rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      aCharData^.HaveBestAttackMagicArr[i].rDamageEnergy := _StrToInt(rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      aCharData^.HaveBestAttackMagicArr[i].rArmorBody := _StrToInt(rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      aCharData^.HaveBestAttackMagicArr[i].rArmorHead := _StrToInt(rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      aCharData^.HaveBestAttackMagicArr[i].rArmorArm := _StrToInt(rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      aCharData^.HaveBestAttackMagicArr[i].rArmorLeg := _StrToInt(rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      aCharData^.HaveBestAttackMagicArr[i].rArmorEnergy := _StrToInt(rdstr);
   end;
end;

procedure THaveMagicClass.FindAndSendMagic (pMagicData: PTMagicData);
var
   i : integer;
begin
   if pMagicData = nil then exit;

   case pMagicData^.rMagicClass of
      MAGICCLASS_MAGIC:
         begin
            for i := 0 to 20 -1 do begin
               if pMagicData = @DefaultMagic[i] then begin
                  FSendClass.SendBasicMagic (i, DefaultMagic[i]);
                  exit;
               end;
            end;

            for i := 0 to HAVEMAGICSIZE-1 do begin
               if pMagicData = @HaveMagicArr[i] then begin
                  FSendClass.SendHaveMagic (i, HaveMagicArr[i]);
                  exit;
               end;
            end;
         end;
      MAGICCLASS_RISEMAGIC:
         begin
            for i := 0 to 20 -1 do begin
               if pMagicData = @DefaultMagic[i] then begin
                  FSendClass.SendBasicMagic (i, DefaultMagic[i]);
                  exit;
               end;
            end;

            for i := 0 to HAVERISEMAGICSIZE-1 do begin
               if pMagicData = @HaveRiseMagicArr[i] then begin
                  FSendClass.SendHaveRiseMagic (i, HaveRiseMagicArr[i]);
                  exit;
               end;
            end;
         end;
      MAGICCLASS_MYSTERY:
         begin
            for i := 0 to HAVEMYSTERYMAGICSIZE-1 do begin
               if pMagicData = @HaveMysteryMagicArr[i] then begin
                  FSendClass.SendHaveMystery (i, HaveMysteryMagicArr[i]);
                  exit;
               end;
            end;
         end;
      MAGICCLASS_BESTMAGIC:
         begin
            for i := 0 to HAVEBESTPROTECTMAGICSIZE-1 do begin
               if pMagicData = @HaveBestProtectMagicArr[i] then begin
                  FSendClass.SendHaveBestProtectMagic (i, HaveBestProtectMagicArr[i]);
                  exit;
               end;
            end;

            for i := 0 to HAVEBESTATTACKMAGICSIZE-1 do begin
               if pMagicData = @HaveBestAttackMagicArr[i] then begin
                  FSendClass.SendHaveBestAttackMagic (i, HaveBestAttackMagicArr[i]);
                  exit;
               end;
            end;

            for i := 0 to HAVEBESTSPECIALMAGICSIZE-1 do begin
               if pMagicData = @HaveBestSpecialMagicArr[i] then begin
                  FSendClass.SendHaveBestSpecialMagic (i, HaveBestSpecialMagicArr[i]);
                  exit;
               end;
            end;
         end;
   end;
end;
procedure THaveMagicClass.MaxShieldCalculate;
begin
   if CurPowerLevel <> 0 then begin
      FMaxShield := (CurPowerLevel-1) * 500;
   end else begin
      FMaxShield := 0;
   end;

   if FMaxShield < FCurrentShield then FCurrentShield := FMaxShield;
end;

procedure THaveMagicClass.RegenerateShield (CurTick : Integer);
begin
   if CurTick > FRegenerateShieldTick + REGENERATE_SHIELD_DELAY then begin
      FRegenerateShieldTick := CurTick;
      FCurrentShield := FCurrentShield + FMaxShield div 10;
      if FCurrentShield > FMaxShield then FCurrentShield := FMaxShield;
   end;
end;

function  THaveMagicClass.ViewMagic (akey: integer; aMagicData: PTMagicData): Boolean;
begin
   Result := FALSE;
   fillchar (aMagicData^, sizeof (TMagicData), 0);

   if (akey < 0) or (akey > HAVEMAGICSIZE-1) then exit;
   if HaveMagicArr[akey].rName[0] = 0 then exit;
   Move (HaveMagicArr[akey], aMagicData^, SizeOf (TMagicData));
   Result := TRUE;
end;

function THaveMagicClass.ViewRiseMagic (akey: integer; aMagicData: PTMagicData): Boolean;
begin
   Result := FALSE;
   fillchar (aMagicData^, sizeof (TMagicData), 0);

   if (akey < 0) or (akey > HAVERISEMAGICSIZE-1) then exit;
   if HaveRiseMagicArr[akey].rName[0] = 0 then exit;
   Move (HaveRiseMagicArr[akey], aMagicData^, SizeOf (TMagicData));
   Result := TRUE;
end;

function  THaveMagicClass.ViewBasicMagic (akey: integer; aMagicData: PTMagicData): Boolean;
begin
   Result := FALSE;
   fillchar (aMagicData^, sizeof (TMagicData), 0);

   if (akey < 0) or (akey > 20 - 1) then exit;
   if DefaultMagic[akey].rName[0] = 0 then exit;
   Move (DefaultMagic[akey], aMagicData^, SizeOf (TMagicData));
   Result := TRUE;
end;

//2002-11-06 giltae
function THaveMagicClass.ViewMysteryMagic (akey : integer; aMagicData: PTMagicData): Boolean;
begin
   Result := false;
   FillChar (aMagicData^, sizeof(TMagicData),0);

   if (akey < 0) or (akey > HAVEMYSTERYMAGICSIZE - 1) then exit;
   if HaveMysteryMagicArr[akey].rName[0] = 0 then exit;
   Move (HaveMysteryMagicArr[akey], aMagicData^, sizeof(TMagicData));
   Result := true;
end;

//2003-09-22
function THaveMagicClass.ViewBestMagic (akey : integer; aMagicData: PTMagicData): Boolean;
var
   rkey : integer;
begin
   Result := false;
   FillChar (aMagicData^, sizeof(TMagicData),0);

   if (akey < 0) or (akey > TOTALBESTMAGICNUM - 1) then exit;

   case aKey of
      //鞘混扁
      0..15-1:
         begin
            rkey := akey;
            if HaveBestSpecialMagicArr[rkey].rname[0] = 0 then exit;
            Move (HaveBestSpecialMagicArr[rkey], aMagicData^, sizeof(TMagicData));
            Result := true;
         end;
      //傍仿
      15..20-1:
         begin
            rkey := akey-HAVEBESTSPECIALMAGICSIZE;
            if HaveBestProtectMagicArr[rkey].rname[0] = 0 then exit;
            Move (HaveBestProtectMagicArr[rkey], aMagicData^, sizeof(TMagicData));
            Result := true;
         end;
      else
         //例技公傍(傍拜屈)
         begin
            rkey := akey - (HAVEBESTSPECIALMAGICSIZE+HAVEBESTPROTECTMAGICSIZE);
            if HaveBestAttackMagicArr[rkey].rname[0] = 0 then exit;
            Move (HaveBestAttackMagicArr[rkey], aMagicData^, sizeof(TMagicData));
            Result := true;
         end;
   end;
end;

function  THaveMagicClass.AddMagic  (aMagicData: PTMagicData): Boolean;
var
   i: integer;
   boFlag : boolean;
   //min, mini : integer;
begin
   Result := FALSE;

   if aMagicData^.rName [0] = 0 then exit;
   
   if (aMagicData^.rMagicType = MAGICTYPE_ECT) and (aMagicData^.rFunction = MAGICFUNC_5HIT) then begin 
   // if StrPas (@aMagicData^.rName) = '坷急规' then begin
      // 绢恫 傍拜公傍捞 99.99啊 绝阑版快 FALSE 府畔
      boFlag := false;
      for i := 0 to 20 - 1 do begin
         Case DefaultMagic[i].rMagicType of
            MAGICTYPE_WRESTLING  ,
            MAGICTYPE_FENCING    ,
            MAGICTYPE_SWORDSHIP  ,
            MAGICTYPE_HAMMERING  ,
            MAGICTYPE_SPEARING   :
               begin
                  if DefaultMagic[i].rcSkillLevel >= 9999 then begin
                     boFlag := true;
                     break;
                  end;
               end;
         end;
      end;
      if boFlag = false then begin
         for i := 0 to HAVEMAGICSIZE - 1 do begin
            Case HaveMagicArr[i].rMagicType of
               MAGICTYPE_WRESTLING  ,
               MAGICTYPE_FENCING    ,
               MAGICTYPE_SWORDSHIP  ,
               MAGICTYPE_HAMMERING  ,
               MAGICTYPE_SPEARING   :
                  begin
                     if HaveMagicArr[i].rcSkillLevel >= 9999 then begin
                        boFlag := true;
                        break;
                     end;
                  end;
            end;
         end;
      end;
      if boFlag = false then exit;
   end;

   if (aMagicData^.rMagicType = MAGICTYPE_ECT) and (aMagicData^.rFunction = MAGICFUNC_8HIT) then begin
   // if StrPas (@aMagicData^.rName) = '迫柳拜' then begin
      // 坷急规捞 99.99啊 酒匆版快 FALSE 府畔..
      boFlag := false;
      for i := 0 to HAVEMAGICSIZE - 1 do begin
         if (HaveMagicArr[i].rMagicType = MAGICTYPE_ECT) and (HaveMagicArr[i].rFunction = MAGICFUNC_5HIT) then begin
         // if StrPas(@HaveMagicArr[i].rName) = '坷急规' then begin
            if HaveMagicArr[i].rcSkillLevel >= 9999 then begin
               boFlag := true;
               break;
            end;
         end;
      end;
      if boFlag = false then exit;
   end;

   if aMagicData^.rGuildMagicType <> 0 then begin
      for i := 0 to HAVEMAGICSIZE - 1 do
         if HaveMagicArr[i].rGuildMagicType <> 0 then exit;
   end;

   for i := 0 to HAVEMAGICSIZE - 1 do
      if StrComp (@HaveMagicArr[i].rName, @aMagicData^.rName) = 0 then exit;

   for i := 0 to HAVEMAGICSIZE - 1 do begin
      if HaveMagicArr[i].rName[0] = 0 then begin
         Move (aMagicData^, HaveMagicArr[i], SizeOf (TMagicData));
         if aMagicData^.rGuildMagictype = 0 then begin
            if aMagicData^.rMagicType <> MAGICTYPE_ECT then begin
               SetMagicIndex(false, aMagicData^.rMagicType, aMagicData^.rMagicRelation, i);
            end;
         end;
         FSendClass.SendHaveMagic (i, HaveMagicArr[i]);
         Result := TRUE;
         exit;
      end;
   end;
end;

function  THaveMagicClass.DeleteMagic (akey: integer): Boolean;
begin
   Result := FALSE;
   if (akey < 0) or (akey > HAVEMAGICSIZE-1) then exit;
   if FpCurAttackMagic     = @HaveMagicArr[akey] then exit;
   if FpCurBreathngMagic   = @HaveMagicArr[akey] then exit;
   if FpCurRunningMagic    = @HaveMagicArr[akey] then exit;
   if FpCurProtectingMagic = @HaveMagicArr[akey] then exit;
   if FpCurEctMagic        = @HaveMagicArr[akey] then exit;
   if ( HaveMagicArr[akey].rGuildMagictype = 0 ) then begin
      SetMagicIndex(false, HaveMagicArr[akey].rMagicType, HaveMagicArr[akey].rMagicRelation, -1);
   end;
   FillChar (HaveMagicArr[akey], sizeof(TMagicData), 0);
   FSendClass.SendHaveMagic (akey, HaveMagicArr[akey]);
   Result := TRUE;
end;

function THaveMagicClass.AddRiseMagic (aMagicData: PTMagicData): Boolean;
var
   i : integer;
begin
   Result := FALSE;

   if aMagicData^.rGuildMagictype <> 0 then begin
      for i := 0 to HAVERISEMAGICSIZE-1 do
         if HaveRiseMagicArr[i].rGuildMagictype <> 0 then exit;
   end;

   for i := 0 to HAVERISEMAGICSIZE-1 do
      if StrComp (@HaveRiseMagicArr[i].rName, @aMagicData^.rName) = 0 then exit;

   for i := 0 to HAVERISEMAGICSIZE-1 do begin
      if HaveRiseMagicArr[i].rName[0] = 0 then begin
         Move (aMagicData^, HaveRiseMagicArr[i], SizeOf (TMagicData));
         FSendClass.SendHaveRiseMagic (i, HaveRiseMagicArr[i]);
         Result := TRUE;
         exit;
      end;
   end;
end;

function  THaveMagicClass.AddMysteryMagic (aMagicData: PTMagicData): Boolean;
var
   i : integer;
begin
   Result := FALSE;

   for i := 0 to HAVEMYSTERYMAGICSIZE-1 do
      if StrComp (@HaveMysteryMagicArr[i].rName, @aMagicData^.rName) = 0 then exit;

   for i := 0 to HAVEMYSTERYMAGICSIZE-1 do begin
      if HaveMysteryMagicArr[i].rName[0] = 0 then begin
         Move (aMagicData^, HaveMysteryMagicArr[i], SizeOf (TMagicData));
         FSendClass.SendHaveMystery (i, HaveMysteryMagicArr[i]);
         Result := TRUE;
         exit;
      end;
   end;
end;

//2003-09-22
function  THaveMagicClass.AddBestMagic (aMagicData: PTMagicData): Boolean;
var
   i : integer;
   n : integer;   
   magicname : string;
begin
   Result := FALSE;

   case aMagicData^.rMagicType of
      MAGICTYPE_BESTSPECIAL  :   //例技公傍吝 檬侥甸(鞘混扁)
         begin
            if TUser (FBasicObject).PassWord <> '' then begin
               FSendClass.SendChatMessage (Conv ('有密码设定'), SAY_COLOR_SYSTEM);
               exit;
            end;

            if FAttribClass.AddableStatePoint < 100 then begin
               FSendClass.SendChatMessage (Conv ('要想修炼需要更多的真气'), SAY_COLOR_SYSTEM);
               exit;
            end;

            for i := 0 to HAVEBESTSPECIALMAGICSIZE -1 do begin
               if StrComp (@HaveBestSpecialMagicArr[i].rName, @aMagicData^.rName) = 0 then exit;
            end;

            for i := 0 to HAVEBESTSPECIALMAGICSIZE -1 do begin
               if HaveBestSpecialMagicArr[i].rName[0] = 0 then begin
                  magicname := StrPas(@aMagicData.rname);
                  MagicClass.GetHaveBestMagicData (magicname, HaveBestSpecialMagicArr[i]);
                  MagicClass.Calculate_cLifeData(@HaveBestSpecialMagicArr[i]);
                  FSendClass.SendHaveBestSpecialMagic (i, HaveBestSpecialMagicArr[i]);

                  FAttribClass.AddableStatePoint := FAttribClass.AddableStatePoint - 100;
                  FSendClass.SendExtraAttribValues(FAttribClass);

                  Result := TRUE;
                  exit;
               end;
            end;
         end;
      MAGICTYPE_PROTECTING    :  //脚傍
         begin
            //惑铰公傍 吝 碍脚茄俺啊 必捞绢具 登绰 炼扒
            if boHaveOneRiseProtectingMagic = false then begin
               FSendClass.SendChatMessage(Conv ('上层护体中要有一个满级的'), SAY_COLOR_SYSTEM);
               exit;
            end;

            //龋楷瘤扁 65.00阑 逞扁绰啊
            if FAttribClass.Virtue < 6501 then begin
               FSendClass.SendChatMessage(Conv ('浩然之气要在65.01以上'), SAY_COLOR_SYSTEM);
               exit;
            end;

            //唱捞 40.01
            if FAttribClass.Age < 4001 then begin
               FSendClass.SendChatMessage (Conv ('年龄要在40岁以上'), SAY_COLOR_SYSTEM);
               exit;
            end;

            //秦寸夸扒捞 登骨肺 公傍芒俊 嚼垫捞 啊瓷茄 惑怕->后公傍芒阑 茫绰苞沥
            for i := 0 to HAVEBESTPROTECTMAGICSIZE -1 do begin
               if StrComp (@HaveBestProtectMagicArr[i].rName, @aMagicData^.rName) = 0 then exit;
            end;

            for i := 0 to HAVEBESTPROTECTMAGICSIZE -1 do begin
               if HaveBestProtectMagicArr[i].rName[0] = 0 then begin
                  magicname := StrPas(@aMagicData.rname);
                  MagicClass.GetHaveBestMagicData (magicname, HaveBestProtectMagicArr[i]);
                  MagicClass.Calculate_cLifeData(@HaveBestProtectMagicArr[i]);
                  FSendClass.SendHaveBestProtectMagic (i, HaveBestProtectMagicArr[i]);
                  Result := TRUE;
                  exit;
               end;
            end;
         end;
      else
         begin
            //龋楷瘤扁 65.00阑 逞扁绰啊
            if FAttribClass.Virtue < 6501 then begin
               FSendClass.SendChatMessage(Conv ('浩然之气要在65.01以上'), SAY_COLOR_SYSTEM);
               exit;
            end;

            //秦寸拌凯狼 惑铰公傍吝 3俺捞惑捞 必捞绢具凳
            if boHaveThreeRiseAttackMagic(aMagicData^.rMagicType) = false then begin
               FSendClass.SendChatMessage(Conv ('要想修炼此系列武功,必需要有同一系列的3个上层武功满级'), SAY_COLOR_SYSTEM);
               exit;
            end;

            for i := 0 to HAVEBESTATTACKMAGICSIZE -1 do begin
               if StrComp (@HaveBestAttackMagicArr[i].rName, @aMagicData^.rName) = 0 then exit;
            end;

            for i := 0 to HAVEBESTATTACKMAGICSIZE -1 do begin
               if HaveBestAttackMagicArr[i].rName[0] = 0 then begin
                  magicname := StrPas(@aMagicData.rname);
                  MagicClass.GetHaveBestMagicData (magicname, HaveBestAttackMagicArr[i]);
                  MagicClass.Calculate_cLifeData(@HaveBestAttackMagicArr[i]);
                  FSendClass.SendHaveBestAttackMagic (i, HaveBestAttackMagicArr[i]);
                  Result := TRUE;
                  exit;
               end;
            end;
         end;
   end;
end;

function THaveMagicClass.DeleteRiseMagic (akey: integer): Boolean;
begin
   Result := FALSE;
   if (akey < 0) or (akey > HAVERISEMAGICSIZE-1) then exit;
   if FpCurAttackMagic     = @HaveRiseMagicArr[akey] then exit;
   if FpCurBreathngMagic   = @HaveRiseMagicArr[akey] then exit;
   if FpCurRunningMagic    = @HaveRiseMagicArr[akey] then exit;
   if FpCurProtectingMagic = @HaveRiseMagicArr[akey] then exit;
   if FpCurEctMagic        = @HaveRiseMagicArr[akey] then exit;
   FillChar (HaveRiseMagicArr[akey], sizeof(TMagicData), 0);
   FSendClass.SendHaveRiseMagic (akey, HaveRiseMagicArr[akey]);
   Result := TRUE;
end;

function  THaveMagicClass.DeleteMysteryMagic (akey: integer): Boolean;
begin
   Result := false;
   if (akey < 0) or (akey > HAVEMYSTERYMAGICSIZE-1) then exit;
   if FpCurAttackMagic     = @HaveMysteryMagicArr[akey] then exit;
   if FpCurBreathngMagic   = @HaveMysteryMagicArr[akey] then exit;
   if FpCurRunningMagic    = @HaveMysteryMagicArr[akey] then exit;
   if FpCurProtectingMagic = @HaveMysteryMagicArr[akey] then exit;
   if FpCurEctMagic        = @HaveMysteryMagicArr[akey] then exit;
   FillChar (HaveMysteryMagicArr[akey], sizeof(TMagicData), 0);
   FSendClass.SendHaveRiseMagic (akey, HaveMysteryMagicArr[akey]);
   Result := TRUE;
end;

function THaveMagicClass.DeleteBestAttackMagic (aKey : Integer) : Boolean;
begin
   Result := false;
   if (akey < 0) or (akey > HAVEBESTATTACKMAGICSIZE - 1) then exit;
   if FpCurAttackMagic = @HaveBestAttackMagicArr[akey] then exit;

   FillChar (HaveBestAttackMagicArr[akey], sizeof(TMagicData), 0);
   FSendClass.SendHaveBestAttackMagic (akey, HaveBestAttackMagicArr[akey]);
   Result := true;
end;

function THaveMagicClass.DeleteBestProtectMagic (akey: integer): Boolean;
begin
   Result := false;
   if (akey < 0) or (akey > HAVEBESTPROTECTMAGICSIZE - 1) then exit;
   if FpCurProtectingMagic = @HaveBestProtectMagicArr[akey] then exit;

   FillChar (HaveBestProtectMagicArr[akey], sizeof(TMagicData), 0);
   FSendClass.SendHaveBestProtectMagic (akey, HaveBestProtectMagicArr[akey]);
   Result := TRUE;
end;

function THaveMagicClass.DeleteBestSpecialMagic (akey: integer): Boolean;
begin
   Result := false;
   if (akey < 0) or (akey > HAVEBESTSPECIALMAGICSIZE - 1) then exit;
   if FpCurEctMagic = @HaveBestSpecialMagicArr[akey] then exit;
   if FpCurSpecialMagic = @HaveBestSpecialMagicArr[akey] then exit;

   FillChar (HaveBestSpecialMagicArr[akey], sizeof(TMagicData), 0);
   FSendClass.SendHaveBestSpecialMagic (akey, HaveBestSpecialMagicArr[akey]);
   Result := TRUE;
end;

function THaveMagicClass.DeleteMagicByName (aMagicName: string): Boolean;
var
   i : integer;
begin
   Result := false;
   //扁夯
   for i := 0 to HAVEBASICMAGICSIZE - 1 do begin
      if StrPas(@DefaultMagic[i].rName) = aMagicName then begin
         if (pCurAttackMagic = @DefaultMagic[i]) or
            (pCurBreathngMagic = @DefaultMagic[i]) or
            (pCurRunningMagic = @DefaultMagic[i]) or
            (pCurProtectingMagic = @DefaultMagic[i]) or
            (pCurEctMagic = @DefaultMagic[i]) then begin
            exit;
         end;

         FillChar (DefaultMagic[i],sizeof(TMagicData),0);
         FSendClass.SendBasicMagic(i,DefaultMagic[i]);
         Result := true;
         exit;
      end;
   end;

   //老馆
   for i := 0 to HAVEMAGICSIZE - 1 do begin
      if StrPas(@HaveMagicArr[i].rName) = aMagicName then begin
         if (pCurAttackMagic = @HaveMagicArr[i]) or
            (pCurBreathngMagic = @HaveMagicArr[i]) or
            (pCurRunningMagic = @HaveMagicArr[i]) or
            (pCurProtectingMagic = @HaveMagicArr[i]) or
            (pCurEctMagic = @HaveMagicArr[i]) then begin
            exit;
         end;

         FillChar (HaveMagicArr[i],sizeof(TMagicData),0);
         FSendClass.SendHaveMagic(i,HaveMagicArr[i]);
         Result := true;
         exit;
      end;
   end;
   
   //惑铰
   for i := 0 to HAVERISEMAGICSIZE - 1 do begin
      if StrPas(@HaveRiseMagicArr[i].rName) = aMagicName then begin
         if (pCurAttackMagic = @HaveRiseMagicArr[i]) or
            (pCurBreathngMagic = @HaveRiseMagicArr[i]) or
            (pCurRunningMagic = @HaveRiseMagicArr[i]) or
            (pCurProtectingMagic = @HaveRiseMagicArr[i]) or
            (pCurEctMagic = @HaveRiseMagicArr[i]) then begin
            exit;
         end;
         
         FillChar (HaveRiseMagicArr[i],sizeof(TMagicData),0);
         FSendClass.SendHaveRiseMagic(i,HaveRiseMagicArr[i]);
         Result := true;
         exit;
      end;
   end;
   
   //厘过
   for i := 0 to HAVEMYSTERYMAGICSIZE -1 do begin
      if StrPas(@HaveMysteryMagicArr[i].rName) = aMagicName then begin
         if (pCurAttackMagic = @HaveMysteryMagicArr[i]) or
            (pCurBreathngMagic = @HaveMysteryMagicArr[i]) or
            (pCurRunningMagic = @HaveMysteryMagicArr[i]) or
            (pCurProtectingMagic = @HaveMysteryMagicArr[i]) or
            (pCurEctMagic = @HaveMysteryMagicArr[i]) then begin
            exit;
         end;
         
         FillChar (HaveMysteryMagicArr[i],sizeof(TMagicData),0);
         FSendClass.SendHaveMystery(i,HaveMysteryMagicArr[i]);
         Result := true;
         exit;
      end;
   end;
   
   //例技
   for i := 0 to HAVEBESTSPECIALMAGICSIZE - 1 do begin
      if StrPas(@HaveBestSpecialMagicArr[i].rName) = aMagicName then begin
         if (pCurAttackMagic = @HaveBestSpecialMagicArr[i]) or
            (pCurBreathngMagic = @HaveBestSpecialMagicArr[i]) or
            (pCurRunningMagic = @HaveBestSpecialMagicArr[i]) or
            (pCurProtectingMagic = @HaveBestSpecialMagicArr[i]) or
            (pCurEctMagic = @HaveBestSpecialMagicArr[i]) then begin
            exit;
         end;
         
         FillChar (HaveBestSpecialMagicArr[i],sizeof(TMagicData),0);
         FSendClass.SendHaveBestSpecialMagic(i,HaveBestSpecialMagicArr[i]);
         Result := true;
         exit;
      end;
   end;

   for i := 0 to HAVEBESTPROTECTMAGICSIZE - 1 do begin
      if StrPas(@HaveBestProtectMagicArr[i].rName) = aMagicName then begin
         if (pCurAttackMagic = @HaveBestProtectMagicArr[i]) or
            (pCurBreathngMagic = @HaveBestProtectMagicArr[i]) or
            (pCurRunningMagic = @HaveBestProtectMagicArr[i]) or
            (pCurProtectingMagic = @HaveBestProtectMagicArr[i]) or
            (pCurEctMagic = @HaveBestProtectMagicArr[i]) then begin
            exit;
         end;
         
         FillChar (HaveBestProtectMagicArr[i],sizeof(TMagicData),0);
         FSendClass.SendHaveBestProtectMagic(i,HaveBestProtectMagicArr[i]);
         Result := true;
         exit;
      end;
   end;

   for i := 0 to HAVEBESTATTACKMAGICSIZE - 1 do begin
      if StrPas(@HaveBestAttackMagicArr[i].rName) = aMagicName then begin
         if (pCurAttackMagic = @HaveBestAttackMagicArr[i]) or
            (pCurBreathngMagic = @HaveBestAttackMagicArr[i]) or
            (pCurRunningMagic = @HaveBestAttackMagicArr[i]) or
            (pCurProtectingMagic = @HaveBestAttackMagicArr[i]) or
            (pCurEctMagic = @HaveBestAttackMagicArr[i]) then begin
            exit;
         end;
         
         FillChar (HaveBestAttackMagicArr[i],sizeof(TMagicData),0);
         FSendClass.SendHaveBestAttackMagic(i,HaveBestAttackMagicArr[i]);
         Result := true;
         exit;
      end;
   end;
end;

//2003-09-22
function  THaveMagicClass.DeleteBestMagic (akey: integer): Boolean;
var
   rkey : integer;
begin
   Result := false;
   case akey of
      0..14:
         begin
            if FpCurAttackMagic     = @HaveBestSpecialMagicArr[akey] then exit;
            if FpCurBreathngMagic   = @HaveBestSpecialMagicArr[akey] then exit;
            if FpCurRunningMagic    = @HaveBestSpecialMagicArr[akey] then exit;
            if FpCurProtectingMagic = @HaveBestSpecialMagicArr[akey] then exit;
            if FpCurEctMagic        = @HaveBestSpecialMagicArr[akey] then exit;
            FillChar (HaveBestSpecialMagicArr[akey], sizeof(TMagicData), 0);
            FSendClass.SendHaveBestSpecialMagic (akey, HaveBestSpecialMagicArr[akey]);
            Result := TRUE;
         end;
      15..19:
         begin
            rkey := akey - 15;
            if FpCurAttackMagic     = @HaveBestProtectMagicArr[rkey] then exit;
            if FpCurBreathngMagic   = @HaveBestProtectMagicArr[rkey] then exit;
            if FpCurRunningMagic    = @HaveBestProtectMagicArr[rkey] then exit;
            if FpCurProtectingMagic = @HaveBestProtectMagicArr[rkey] then exit;
            if FpCurEctMagic        = @HaveBestProtectMagicArr[rkey] then exit;
            FillChar (HaveBestProtectMagicArr[rkey], sizeof(TMagicData), 0);
            FSendClass.SendHaveBestProtectMagic (rkey, HaveBestProtectMagicArr[rkey]);
            Result := TRUE;
         end;
      20..24:
         begin
            rkey := akey - 20;
            if FpCurAttackMagic     = @HaveBestAttackMagicArr[rkey] then exit;
            if FpCurBreathngMagic   = @HaveBestAttackMagicArr[rkey] then exit;
            if FpCurRunningMagic    = @HaveBestAttackMagicArr[rkey] then exit;
            if FpCurProtectingMagic = @HaveBestAttackMagicArr[rkey] then exit;
            if FpCurEctMagic        = @HaveBestAttackMagicArr[rkey] then exit;
            FillChar (HaveBestAttackMagicArr[rkey], sizeof(TMagicData), 0);
            FSendClass.SendHaveBestAttackMagic (rkey, HaveBestAttackMagicArr[rkey]);
            Result := TRUE;
         end;
      else
         begin
            exit;
         end;
   end;
end;

function  THaveMagicClass.GetMagicIndex(aMagicName: string): integer;
var i: integer;
begin
   Result := -1;
   for i := 0 to HAVEMAGICSIZE-1 do begin
      if StrPas(@HaveMagicArr[i].rName) = aMagicName then begin
         Result := i;
         exit;
      end;
   end;
end;

function THaveMagicClass.GetRiseMagicIndex(aMagicName: string): integer;
var
   i : Integer;
begin
   Result := -1;
   for i := 0 to HAVERISEMAGICSIZE-1 do begin
      if StrPas(@HaveRiseMagicArr[i].rName) = aMagicName then begin
         Result := i;
         exit;
      end;
   end;
end;

function THaveMagicClass.GetBestAttackMagicIndex (aMagicName : String) : Integer;
var
   i : Integer;
begin
   Result := -1;
   for i := 0 to HAVEBESTATTACKMAGICSIZE - 1 do begin
      if StrPas (@HaveBestAttackMagicArr [i].rName) = aMagicName then begin
         Result := i;
         exit;
      end;
   end;
end;

function THaveMagicClass.GetBestProtectMagicIndex (aMagicName : String) : Integer;
var
   i : Integer;
begin
   Result := -1;
   for i := 0 to HAVEBESTPROTECTMAGICSIZE - 1 do begin
      if StrPas (@HaveBestProtectMagicArr [i].rName) = aMagicName then begin
         Result := i;
         exit;
      end;
   end;
end;

function THaveMagicClass.GetBestSpecialMagicIndex (aMagicName : String) : Integer;
var
   i : Integer;
begin
   Result := -1;
   for i := 0 to HAVEBESTSPECIALMAGICSIZE - 1 do begin
      if StrPas (@HaveBestSpecialMagicArr [i].rName) = aMagicName then begin
         Result := i;
         exit;
      end;
   end;
end;

// add by Orber at 2004-12-02 14:47:44
function  THaveMagicClass.GetBestAttackMagicGrade (akey : Integer) : Byte;
begin
    if akey <= HAVEBESTATTACKMAGICSIZE -1 then begin
        Result :=  HaveBestAttackMagicArr [akey].rGrade;
    end;
end;

// add by Orber at 2004-12-02 14:47:44
function  THaveMagicClass.GetBestAttackMagicExp (akey : Integer) : integer;
begin
    if akey <= HAVEBESTATTACKMAGICSIZE -1 then begin
        Result :=  HaveBestAttackMagicArr [akey].rSkillExp;
    end;
end;

function  THaveMagicClass.GetUsedMagicList: string;
begin
   Result := '';

   if FpCurAttackMagic     <> nil then Result := Result + ' ' + StrPas (@FpCurAttackMagic^.rName);
   if FpCurBreathngMagic   <> nil then Result := Result + ' ' + StrPas (@FpCurBreathngMagic^.rName);
   if FpCurRunningMagic    <> nil then Result := Result + ' ' + StrPas (@FpCurRunningMagic^.rName);
   if FpCurProtectingMagic <> nil then Result := Result + ' ' + StrPas (@FpCurProtectingMagic^.rName);
   if FpCurEctMagic        <> nil then Result := Result + ' ' + StrPas (@FpCurEctMagic^.rName);
end;

function  THaveMagicClass.DecEventMagic (apmagic: PTMagicData): Boolean;
var
   n, aDecLife, aDecMagic, aDecInPower, aDecOutPower, aDecEnergy, aBasicValue : Integer;
begin
   Result := FALSE;
   aBasicValue := TUserObject (FBasicObject).DecValue;
   
   case apmagic^.rMagicClass of
      MAGICCLASS_MYSTERY :
         begin
            ConsumeEnergy := 0;
            n := FAttribClass.Energy * (150 - MagicClass.GetSkillConsumeEnergy (FAttribClass.Energy)) div 1000;
            n := n * (100 - aBasicValue) div 100;
            if FAttribClass.CurEnergy < n then exit;
            ConsumeEnergy := n;
            FAttribClass.CurEnergy := FAttribClass.CurEnergy - n;
            Result := true;
         end;
      MAGICCLASS_BESTMAGIC :
         begin
            case apmagic^.rMagicType of
               MAGICTYPE_BESTSPECIAL :
                  begin
                     if apmagic^.rKeepEnergy > FAttribClass.CurEnergy then exit;

                     aDecEnergy := FAttribClass.Energy * apmagic^.rEventDecEnergy div 100;
                     FAttribClass.CurEnergy := FAttribClass.CurEnergy - aDecEnergy;
                     Result := TRUE;
                  end;
               else
                  begin
                     if aBasicValue = 0 then begin
                        aDecLife := apmagic^.rEventDecLife;
                        aDecMagic := apmagic^.rEventDecMagic;
                        aDecInPower := apmagic^.rEventDecInPower;
                        aDecOutPower := apmagic^.rEventDecOutPower;
                        aDecEnergy := apmagic^.rEventDecEnergy;
                     end else begin
                        aDecLife := apmagic^.rEventDecLife * ( 100 - aBasicValue) div 100;
                        aDecMagic := apmagic^.rEventDecMagic * ( 100 - aBasicValue) div 100;
                        aDecInPower := apmagic^.rEventDecInPower * ( 100 - aBasicValue) div 100;
                        aDecOutPower := apmagic^.rEventDecOutPower * ( 100 - aBasicValue) div 100;
                        aDecEnergy := apmagic^.rEventDecEnergy * ( 100 - aBasicValue) div 100;
                     end;

                     if FAttribClass.CurLife < aDecLife then exit;
                     if FAttribClass.CurMagic < aDecMagic then exit;
                     if FAttribClass.CurInPower < aDecInPower then exit;
                     if FAttribClass.CurOutPower < aDecOutPower then exit;
                     if FAttribClass.CurEnergy < aDecEnergy then exit;

                     FAttribClass.CurLife := FAttribClass.CurLife - aDecLife;
                     FAttribClass.CurMagic := FAttribClass.CurMagic - aDecMagic;
                     FAttribClass.CurInPower := FAttribClass.CurInPower - aDecInPower;
                     FAttribClass.CurOutPower := FAttribClass.CurOutPower - aDecOutPower;
                     FAttribClass.CurEnergy := FAttribClass.CurEnergy - aDecEnergy;
                     Result := TRUE;
                  end;
            end;
            
         end;
      else
         begin
            if aBasicValue = 0 then begin
               aDecLife := apmagic^.rEventDecLife;
               aDecMagic := apmagic^.rEventDecMagic;
               aDecInPower := apmagic^.rEventDecInPower;
               aDecOutPower := apmagic^.rEventDecOutPower;
               aDecEnergy := apmagic^.rEventDecEnergy;
            end else begin
               aDecLife := apmagic^.rEventDecLife * ( 100 - aBasicValue) div 100;
               aDecMagic := apmagic^.rEventDecMagic * ( 100 - aBasicValue) div 100;
               aDecInPower := apmagic^.rEventDecInPower * ( 100 - aBasicValue) div 100;
               aDecOutPower := apmagic^.rEventDecOutPower * ( 100 - aBasicValue) div 100;
               aDecEnergy := apmagic^.rEventDecEnergy * ( 100 - aBasicValue) div 100;
            end;

            if FAttribClass.CurLife < aDecLife then exit;
            if FAttribClass.CurMagic < aDecMagic then exit;
            if FAttribClass.CurInPower < aDecInPower then exit;
            if FAttribClass.CurOutPower < aDecOutPower then exit;
            if FAttribClass.CurEnergy < aDecEnergy then exit;

            FAttribClass.CurLife := FAttribClass.CurLife - aDecLife;
            FAttribClass.CurMagic := FAttribClass.CurMagic - aDecMagic;
            FAttribClass.CurInPower := FAttribClass.CurInPower - aDecInPower;
            FAttribClass.CurOutPower := FAttribClass.CurOutPower - aDecOutPower;
            FAttribClass.CurEnergy := FAttribClass.CurEnergy - aDecEnergy;
            Result := TRUE;
         end;
   end;
end;

function  THaveMagicClass.ChangeMagic (asour, adest: integer): Boolean;
var
   MagicData : TMagicData;
begin
   Result := FALSE;
   if (asour < 0) or (asour > HAVEMAGICSIZE-1) then exit;
   if (adest < 0) or (adest > HAVEMAGICSIZE-1) then exit;

   if FpCurAttackMagic     = @HaveMagicArr[asour] then exit;
   if FpCurBreathngMagic   = @HaveMagicArr[asour] then exit;
   if FpCurRunningMagic    = @HaveMagicArr[asour] then exit;
   if FpCurProtectingMagic = @HaveMagicArr[asour] then exit;
   if FpCurEctMagic        = @HaveMagicArr[asour] then exit;

   if FpCurAttackMagic     = @HaveMagicArr[adest] then exit;
   if FpCurBreathngMagic   = @HaveMagicArr[adest] then exit;
   if FpCurRunningMagic    = @HaveMagicArr[adest] then exit;
   if FpCurProtectingMagic = @HaveMagicArr[adest] then exit;
   if FpCurEctMagic        = @HaveMagicArr[adest] then exit;

   if (HaveMagicArr[asour].rname[0] <> 0 ) and
      (HaveMagicArr[asour].rMagicType >= MAGICTYPE_WRESTLING) and
      (HaveMagicArr[asour].rMagicType <= MAGICTYPE_PROTECTING) and
      (HaveMagicArr[asour].rGuildMagictype = 0) then
   begin
      SetMagicIndex (false, HaveMagicArr[asour].rMagicType, HaveMagicArr[asour].rMagicRelation, -1);
   end;

   if (HaveMagicArr[adest].rname[0] <> 0 ) and
      (HaveMagicArr[adest].rMagicType >= MAGICTYPE_WRESTLING) and
      (HaveMagicArr[adest].rMagicType <= MAGICTYPE_PROTECTING) and
      (HaveMagicArr[adest].rGuildMagictype = 0) then
   begin
      SetMagicIndex (false, HaveMagicArr[adest].rMagicType, HaveMagicArr[adest].rMagicRelation, -1);
   end;

   MagicData := HaveMagicArr[asour];
   HaveMagicArr[asour] := HaveMagicArr[adest];
   HaveMagicArr[adest] := MagicData;

   if (HaveMagicArr[asour].rname[0] <> 0) and
      (HaveMagicArr[asour].rGuildMagictype = 0) and
      (HaveMagicArr[asour].rMagicType >= MAGICTYPE_WRESTLING) and
      (HaveMagicArr[asour].rMagicType <= MAGICTYPE_PROTECTING) then
   begin
      SetMagicIndex (false, HaveMagicArr[asour].rMagicType, HaveMagicArr[asour].rMagicRelation, asour);
   end;

   if (HaveMagicArr[adest].rname[0] <> 0) and
      (HaveMagicArr[adest].rGuildMagictype = 0) and
      (HaveMagicArr[adest].rMagicType >= MAGICTYPE_WRESTLING) and
      (HaveMagicArr[adest].rMagicType <= MAGICTYPE_PROTECTING) then
   begin
      SetMagicIndex (false, HaveMagicArr[adest].rMagicType, HaveMagicArr[adest].rMagicRelation, adest);
   end;

   FSendClass.SendHaveMagic (asour, HaveMagicArr[asour]);
   FSendClass.SendHaveMagic (adest, HaveMagicArr[adest]);
   
   Result := TRUE;
end;

function THaveMagicClass.ChangeRiseMagic (aSour, aDest: integer): Boolean;
var
   MagicData : TMagicData;
begin
   Result := FALSE;
   if (aSour < 0) or (aSour > HAVERISEMAGICSIZE-1) then exit;
   if (aDest < 0) or (aDest > HAVERISEMAGICSIZE-1) then exit;

   if FpCurAttackMagic     = @HaveRiseMagicArr[aSour] then exit;
   if FpCurBreathngMagic   = @HaveRiseMagicArr[aSour] then exit;
   if FpCurRunningMagic    = @HaveRiseMagicArr[aSour] then exit;
   if FpCurProtectingMagic = @HaveRiseMagicArr[aSour] then exit;
   if FpCurEctMagic        = @HaveRiseMagicArr[aSour] then exit;

   if FpCurAttackMagic     = @HaveRiseMagicArr[aDest] then exit;
   if FpCurBreathngMagic   = @HaveRiseMagicArr[aDest] then exit;
   if FpCurRunningMagic    = @HaveRiseMagicArr[aDest] then exit;
   if FpCurProtectingMagic = @HaveRiseMagicArr[aDest] then exit;
   if FpCurEctMagic        = @HaveRiseMagicArr[aDest] then exit;

   if HaveRiseMagicArr[asour].rMagicClass = MAGICCLASS_RISEMAGIC then begin
      SetMagicIndex (true, HaveRiseMagicArr[asour].rMagicType, HaveRiseMagicArr[asour].rMagicRelation, -1);
   end;

   if HaveRiseMagicArr[asour].rMagicClass = MAGICCLASS_RISEMAGIC then begin
      SetMagicIndex (true, HaveRiseMagicArr[adest].rMagicType, HaveRiseMagicArr[adest].rMagicRelation, -1);
   end;

   MagicData := HaveRiseMagicArr[aSour];
   HaveRiseMagicArr[aSour] := HaveRiseMagicArr[aDest];
   HaveRiseMagicArr[aDest] := MagicData;

   if HaveRiseMagicArr[asour].rMagicClass = MAGICCLASS_RISEMAGIC then begin
      SetMagicIndex (true, HaveRiseMagicArr[asour].rMagicType, HaveRiseMagicArr[asour].rMagicRelation, asour);
   end;
   if HaveRiseMagicArr[adest].rMagicClass = MAGICCLASS_RISEMAGIC then begin
      SetMagicIndex (true, HaveRiseMagicArr[adest].rMagicType, HaveRiseMagicArr[adest].rMagicRelation, adest);
   end;

   FSendClass.SendHaveRiseMagic (aSour, HaveRiseMagicArr[aSour]);
   FSendClass.SendHaveRiseMagic (aDest, HaveRiseMagicArr[aDest]);
   Result := TRUE;
end;

function THaveMagicClass.ChangeMysteryMagic (aSour, aDest: integer): Boolean;
var
   MagicData : TMagicData;
begin
   Result := FALSE;
   if (aSour < 0) or (aSour > HAVEMYSTERYMAGICSIZE-1) then exit;
   if (aDest < 0) or (aDest > HAVEMYSTERYMAGICSIZE-1) then exit;

   if FpCurAttackMagic     = @HaveMysteryMagicArr[aSour] then exit;
   if FpCurBreathngMagic   = @HaveMysteryMagicArr[aSour] then exit;
   if FpCurRunningMagic    = @HaveMysteryMagicArr[aSour] then exit;
   if FpCurProtectingMagic = @HaveMysteryMagicArr[aSour] then exit;
   if FpCurEctMagic        = @HaveMysteryMagicArr[aSour] then exit;

   if FpCurAttackMagic     = @HaveMysteryMagicArr[aDest] then exit;
   if FpCurBreathngMagic   = @HaveMysteryMagicArr[aDest] then exit;
   if FpCurRunningMagic    = @HaveMysteryMagicArr[aDest] then exit;
   if FpCurProtectingMagic = @HaveMysteryMagicArr[aDest] then exit;
   if FpCurEctMagic        = @HaveMysteryMagicArr[aDest] then exit;

   if HaveMysteryMagicArr[asour].rMagicClass = MAGICCLASS_MYSTERY then begin
      SetMysteryMagicIndex (HaveMysteryMagicArr[asour].rMagicRelation, -1);
   end;
   if HaveMysteryMagicArr[adest].rMagicClass = MAGICCLASS_MYSTERY then begin
      SetMysteryMagicIndex (HaveMysteryMagicArr[adest].rMagicRelation, -1);
   end;

   MagicData := HaveMysteryMagicArr[aSour];
   HaveMysteryMagicArr[aSour] := HaveMysteryMagicArr[aDest];
   HaveMysteryMagicArr[aDest] := MagicData;

   if HaveMysteryMagicArr[aSour].rMagicClass = MAGICCLASS_MYSTERY then begin
      SetMysteryMagicIndex(HaveMysteryMagicArr[aSour].rMagicRelation, aSour);
   end;

   if HaveMysteryMagicArr[aDest].rMagicClass = MAGICCLASS_MYSTERY then begin
      SetMysteryMagicIndex(HaveMysteryMagicArr[aDest].rMagicRelation, aDest);
   end;

   FSendClass.SendHaveMystery (aSour, HaveMysteryMagicArr[aSour]);
   FSendClass.SendHaveMystery (aDest, HaveMysteryMagicArr[aDest]);
   Result := TRUE;
end;

function  THaveMagicClass.ChangeBasicMagic (asour, adest: integer): Boolean;
var
   MagicData : TMagicData;
begin
   Result := FALSE;

   if (asour < 0) or (asour > 20-1) then exit;
   if (adest < 0) or (adest > 20-1) then exit;

   if FpCurAttackMagic     = @DefaultMagic[asour] then exit;
   if FpCurBreathngMagic   = @DefaultMagic[asour] then exit;
   if FpCurRunningMagic    = @DefaultMagic[asour] then exit;
   if FpCurProtectingMagic = @DefaultMagic[asour] then exit;

   if FpCurAttackMagic     = @DefaultMagic[adest] then exit;
   if FpCurBreathngMagic   = @DefaultMagic[adest] then exit;
   if FpCurRunningMagic    = @DefaultMagic[adest] then exit;
   if FpCurProtectingMagic = @DefaultMagic[adest] then exit;


   MagicData := DefaultMagic[asour];
   DefaultMagic[asour] := DefaultMagic[adest];
   DefaultMagic[adest] := MagicData;

   FSendClass.SendBasicMagic (asour, DefaultMagic[asour]);
   FSendClass.SendBasicMagic (adest, DefaultMagic[adest]);
   Result := TRUE;
end;

function THaveMagicClass.ChangeBestMagic (aSour, aDest: integer): Boolean;
var
   MagicData : TMagicData;
   sType, dType, srkey, drkey : integer;

begin
   Result := FALSE;

   case aSour of
      0..14:      sType := 1;
      15..19:     sType := 2;
      20..24:     sType := 3;
      else exit;
   end;

   case aDest of
      0..14:      dType := 1;
      15..19:     dType := 2;
      20..24:     dType := 3;
      else exit;
   end;

   if sType <> dType then exit;
   case sType of
      1:
         begin
            if FpCurAttackMagic     = @HaveBestSpecialMagicArr[aSour] then exit;
            if FpCurBreathngMagic   = @HaveBestSpecialMagicArr[aSour] then exit;
            if FpCurRunningMagic    = @HaveBestSpecialMagicArr[aSour] then exit;
            if FpCurProtectingMagic = @HaveBestSpecialMagicArr[aSour] then exit;
            if FpCurEctMagic        = @HaveBestSpecialMagicArr[aSour] then exit;

            if FpCurAttackMagic     = @HaveBestSpecialMagicArr[aDest] then exit;
            if FpCurBreathngMagic   = @HaveBestSpecialMagicArr[aDest] then exit;
            if FpCurRunningMagic    = @HaveBestSpecialMagicArr[aDest] then exit;
            if FpCurProtectingMagic = @HaveBestSpecialMagicArr[aDest] then exit;
            if FpCurEctMagic        = @HaveBestSpecialMagicArr[aDest] then exit;
            MagicData := HaveBestSpecialMagicArr[aSour];
            HaveBestSpecialMagicArr[aSour] := HaveBestSpecialMagicArr[aDest];
            HaveBestSpecialMagicArr[aDest] := MagicData;

            FSendClass.SendHaveBestSpecialMagic (aSour, HaveBestSpecialMagicArr[aSour]);
            FSendClass.SendHaveBestSpecialMagic (aDest, HaveBestSpecialMagicArr[aDest]);
            Result := TRUE;
         end;
      2:
         begin
            srkey := aSour - 15;
            drkey := aDest - 15;
            if FpCurAttackMagic     = @HaveBestProtectMagicArr[srkey] then exit;
            if FpCurBreathngMagic   = @HaveBestProtectMagicArr[srkey] then exit;
            if FpCurRunningMagic    = @HaveBestProtectMagicArr[srkey] then exit;
            if FpCurProtectingMagic = @HaveBestProtectMagicArr[srkey] then exit;
            if FpCurEctMagic        = @HaveBestProtectMagicArr[srkey] then exit;

            if FpCurAttackMagic     = @HaveBestProtectMagicArr[drkey] then exit;
            if FpCurBreathngMagic   = @HaveBestProtectMagicArr[drkey] then exit;
            if FpCurRunningMagic    = @HaveBestProtectMagicArr[drkey] then exit;
            if FpCurProtectingMagic = @HaveBestProtectMagicArr[drkey] then exit;
            if FpCurEctMagic        = @HaveBestProtectMagicArr[drkey] then exit;
            MagicData := HaveBestProtectMagicArr[srkey];
            HaveBestProtectMagicArr[srkey] := HaveBestProtectMagicArr[drkey];
            HaveBestProtectMagicArr[drkey] := MagicData;

            FSendClass.SendHaveBestProtectMagic (srkey, HaveBestProtectMagicArr[srkey]);
            FSendClass.SendHaveBestProtectMagic (drkey, HaveBestProtectMagicArr[drkey]);
            Result := TRUE;
         end;
      3:
         begin
            srkey := aSour - 20;
            drkey := aDest - 20;
            if FpCurAttackMagic     = @HaveBestAttackMagicArr[srkey] then exit;
            if FpCurBreathngMagic   = @HaveBestAttackMagicArr[srkey] then exit;
            if FpCurRunningMagic    = @HaveBestAttackMagicArr[srkey] then exit;
            if FpCurProtectingMagic = @HaveBestAttackMagicArr[srkey] then exit;
            if FpCurEctMagic        = @HaveBestAttackMagicArr[srkey] then exit;

            if FpCurAttackMagic     = @HaveBestAttackMagicArr[drkey] then exit;
            if FpCurBreathngMagic   = @HaveBestAttackMagicArr[drkey] then exit;
            if FpCurRunningMagic    = @HaveBestAttackMagicArr[drkey] then exit;
            if FpCurProtectingMagic = @HaveBestAttackMagicArr[drkey] then exit;
            if FpCurEctMagic        = @HaveBestAttackMagicArr[drkey] then exit;
            MagicData := HaveBestAttackMagicArr[srkey];
            HaveBestAttackMagicArr[srkey] := HaveBestAttackMagicArr[drkey];
            HaveBestAttackMagicArr[drkey] := MagicData;

            FSendClass.SendHaveBestAttackMagic (srkey, HaveBestAttackMagicArr[srkey]);
            FSendClass.SendHaveBestAttackMagic (drkey, HaveBestAttackMagicArr[drkey]);
            Result := TRUE;
         end;
   end;
end;

procedure THaveMagicClass.SetAttackMagic (aMagic : PTMagicData);
begin
   if FpCurAttackMagic <> nil then begin
      FSendClass.SendChatMessage (StrPas (@FpCurAttackMagic^.rName) + ' ' + Conv ('终止'), SAY_COLOR_SYSTEM);
      ReQuestPlaySoundNumber := FpCurAttackMagic.rSoundEnd.rWavNumber;
   end;

   FpCurAttackMagic := aMagic;
   if FpCurAttackMagic <> nil then begin
      FSendClass.SendChatMessage (StrPas (@FpCurAttackMagic^.rName) + ' ' + Conv ('开始'), SAY_COLOR_SYSTEM);
      FpCurAttackMagic.rMagicProcessTick := mmAnsTick;
      ReQuestPlaySoundNumber := FpCurAttackMagic.rSoundStart.rWavNumber;
   end else begin
      if FpCurEctMagic <> nil then begin
         FSendClass.SendChatMessage (StrPas (@FpCurEctMagic^.rName) + ' ' + Conv ('终止'), SAY_COLOR_SYSTEM);
         ReQuestPlaySoundNumber := FpCurEctMagic.rSoundEnd.rWavNumber;
         FpCurEctMagic := nil;
      end;
   end;

   SetLifeData;
end;

procedure THaveMagicClass.SetBreathngMagic (aMagic: PTMagicData);
begin
   if FpCurBreathngMagic <> nil then begin
      FSendClass.SendChatMessage (StrPas (@FpCurBreathngMagic^.rName) + ' ' + Conv ('终止'), SAY_COLOR_SYSTEM);
      FpCurBreathngMagic := nil;
   end else begin
      FpCurBreathngMagic := aMagic;
      if aMagic <> nil then begin
         FSendClass.SendChatMessage (StrPas (@FpCurBreathngMagic^.rName) + ' ' + Conv ('开始'), SAY_COLOR_SYSTEM);
         FpCurBreathngMagic.rMagicProcessTick := mmAnsTick;
      end;
   end;
   SetLifeData;
end;

procedure THaveMagicClass.SetRunningMagic (aMagic: PTMagicData);
begin
   if FpCurRunningMagic <> nil then begin
      FSendClass.SendChatMessage (StrPas (@FpCurRunningMagic^.rName) + ' ' + Conv ('终止'), SAY_COLOR_SYSTEM);
      FpCurRunningMagic := nil;
   end else begin
      FpCurRunningMagic := aMagic;
      if aMagic <> nil then begin
         FSendClass.SendChatMessage (StrPas (@FpCurRunningMagic^.rName) + ' ' + Conv ('开始'), SAY_COLOR_SYSTEM);
      end;
   end;
   SetLifeData;
end;

procedure THaveMagicClass.SetProtectingMagic (aMagic: PTMagicData);
begin
   if FpCurProtectingMagic <> nil then begin
      FSendClass.SendChatMessage (StrPas (@FpCurProtectingMagic^.rName) + ' ' + Conv ('终止'), SAY_COLOR_SYSTEM);
      ReQuestPlaySoundNumber := FpCurProtectingMagic.rSoundEnd.rWavNumber;

      if aMagic = FpCurProtectingMagic then begin
         if (FpCurProtectingMagic^.rMagicClass = MAGICCLASS_BESTMAGIC) and
            (FpCurEctMagic <> nil) and (FpCurEctMagic^.rMagicClass = MAGICCLASS_BESTMAGIC) then begin
               if FpCurEctMagic^.rRelationMagic = TYPE_MAGICRELATION_BESTPROTECT then SetEctMagic(nil);
         end;
         FpCurProtectingMagic := nil;
         SetLifeData;
         exit;
      end;
      FpCurProtectingMagic := nil;
   end;

   FpCurProtectingMagic := aMagic;
   if aMagic <> nil then begin
      if (FpCurEctMagic <> nil) and (FpCurEctMagic^.rMagicClass = MAGICCLASS_BESTMAGIC) and
         (FpCurEctMagic^.rRelationMagic = TYPE_MAGICRELATION_BESTPROTECT) then begin
         if (aMagic^.rMagicClass <> MAGICCLASS_BESTMAGIC) then SetEctMagic(nil);
      end;
      
      FSendClass.SendChatMessage (StrPas (@FpCurProtectingMagic^.rName) + ' ' + Conv ('开始'), SAY_COLOR_SYSTEM);
      ReQuestPlaySoundNumber := FpCurProtectingMagic.rSoundStart.rWavNumber;
   end;
   SetLifeData;
end;

procedure THaveMagicClass.SetEctMagic (aMagic: PTMagicData);
var
   SubData : TSubData;
begin
   if FpCurEctMagic <> nil then begin
      FSendClass.SendChatMessage (StrPas (@FpCurEctMagic^.rName) + ' ' + Conv ('终止'), SAY_COLOR_SYSTEM);
      ReQuestPlaySoundNumber := FpCurEctMagic.rSoundEnd.rWavNumber;      

      if FpCurEctMagic^.rMagicClass = MAGICCLASS_BESTMAGIC then begin
         if FpCurEctMagic^.rCEffectNumber <> 0 then begin
            TUserObject(FBasicObject).ShowEffect2(FpCurEctMagic^.rCEffectNumber+1, lek_off, 0);
            TUserObject(FBasicObject).SetCondition (EFFECT_OFF, FpCurEctMagic^.rCEffectNumber+1,0);
         end;
         {  // 吝惫篮 版脚公如 捞犯霸 利侩 救凳
         if FpCurEctMagic^.rMoveSpeed <> 0 then begin
            if (FpCurRunningMagic<> nil) and (FpCurRunningMagic^.rcSkillLevel = 9999) then begin
               FBasicObject.BasicData.Feature.rFlyHeight := 4;
               FBasicObject.SendLocalMessage (NOTARGETPHONE, FM_CHANGEFEATURE, FBasicObject.BasicData, SubData);
            end;
         end;
         }
      end;

      FpCurEctMagic := nil;
   end else begin
      if aMagic = nil then exit;
      FpCurEctMagic := aMagic;

      if FpCurEctMagic^.rMagicClass = MAGICCLASS_BESTMAGIC then begin
         if FpCurEctMagic^.rSEffectNumber <> 0 then begin
            TUserObject(FBasicObject).ShowEffect2(FpCurEctMagic^.rSEffectNumber+1, lek_follow, 0);
         end;
         if FpCurEctMagic^.rCEffectNumber <> 0 then begin
            TUserObject(FBasicObject).ShowEffect2(FpCurEctMagic^.rCEffectNumber+1, lek_continue, CEFFECT_START_DELAY);
            TUserObject(FBasicObject).SetCondition (EFFECT_ON, FpCurEctMagic^.rCEffectNumber+1,0);
         end;
         {  // 吝惫篮 版脚公如 捞犯霸 利侩 救凳         
         if FpCurEctMagic^.rMoveSpeed <> 0 then begin
            if (FpCurRunningMagic<> nil) and (FpCurRunningMagic^.rcSkillLevel = 9999) then begin
               FBasicObject.BasicData.Feature.rFlyHeight := 4 + FpCurEctMagic^.rMoveSpeed;
               FBasicObject.SendLocalMessage (NOTARGETPHONE, FM_CHANGEFEATURE, FBasicObject.BasicData, SubData);
            end;
         end;
         }
      end;
      FSendClass.SendChatMessage (StrPas (@FpCurEctMagic^.rName) + ' ' + Conv ('开始'), SAY_COLOR_SYSTEM);
      ReQuestPlaySoundNumber := FpCurEctMagic.rSoundStart.rWavNumber;      
   end;
   SetLifeData;
end;

procedure THaveMagicClass.SetSpecialMagic (aMagic : PTMagicData);
begin
   if FpCurSpecialMagic <> nil then begin
      FSendClass.SendChatMessage (StrPas (@FpCurSpecialMagic^.rName) + ' ' + Conv ('终止'), SAY_COLOR_SYSTEM);
      ReQuestPlaySoundNumber := FpCurSpecialMagic.rSoundEnd.rWavNumber;

      if FBasicObject.BasicData.Feature.rActionState <> as_free then TUserObject(FBasicObject).SetActionState (as_free);
      FpCurSpecialMagic := nil;
   end else begin
      if aMagic = nil then exit;
      FpCurSpecialMagic := aMagic;
      FSendClass.SendChatMessage (StrPas (@FpCurSpecialMagic^.rName) + ' ' + Conv ('开始'), SAY_COLOR_SYSTEM);
      ReQuestPlaySoundNumber := FpCurSpecialMagic.rSoundStart.rWavNumber;
                  
      if FBasicObject.BasicData.Feature.rActionState <> as_ice then TUserObject(FBasicObject).SetActionState (as_ice);
   end;
   SetLifeData;   
end;

procedure THaveMagicClass.SetPrevAttackMagic (aMagic : PTMagicData);
begin
   FpPrevAttackMagic := aMagic;
end;

{
function  THaveMagicClass.SetHaveMagicPercent (akey: integer; aper: integer): Boolean;
begin
   Result := FALSE;
   if (akey < 0) or (akey > HAVEMAGICSIZE-1) then exit;
   if (aper < 1) or (akey > 10) then exit;

   // HaveMagicArr[akey].rPercent := aper;
   FSendClass.SendHaveMagic (akey, HaveMagicArr[akey]);
   Result := TRUE;
end;
}

{
function  THaveMagicClass.SetDefaultMagicPercent (akey: integer; aper: integer): Boolean;
begin
   Result := FALSE;
   if (akey < 0) or (akey > 10-1) then exit;
   if (aper < 1) or (akey > 10) then exit;

   DefaultMagic[akey].rPercent := aper;

   FSendClass.SendBasicMagic (akey, DefaultMagic[akey]);
   Result := TRUE;
end;
}

function THaveMagicClass.SetHaveItemMagicType (aType: Byte; aboFirst : Boolean) : Boolean;
begin
   Result := false;

   if aType = HITTYPE_PICK then begin
      if TUser (FBasicObject).GetLifeObjectState = los_attack then begin
         TUser (FBasicObject).SetTargetId (0);
      end;
      if (FpCurEctMagic <> nil) and (FpCurEctMagic^.rMagicClass = MAGICCLASS_BESTMAGIC) and
         (FpCurEctMagic^.rRelationMagic = TYPE_MAGICRELATION_BESTPROTECT) then begin
         SetEctMagic(nil);
      end;
      
      SetAttackMagic (nil);

      FSendClass.SendChatMessage (Conv('恢复到可开采原料的状态'), SAY_COLOR_SYSTEM);
      Result := true;
      exit;
   end else begin
      if TUser (FBasicObject).GetLifeObjectState = los_pick then begin
         TUser (FBasicObject).SetTargetId (0);
      end;
      
      if SelectBasicMagic (aType, aboFirst) <> SELECTMAGIC_RESULT_FALSE then begin
         HaveItemType := aType;
         Result := true;
         exit;
      end;
   end;
end;

function  THaveMagicClass.AllowSelectMagic (aType : Integer; aFlag : Boolean) : Boolean;
var
   HeadSeekRate : Integer;
begin
   Result := true;

   if aflag = true then HeadSeekRate := 100
   else HeadSeekRate := FAttribClass.CurHeadLife * 100 div FAttribClass.Life;

   case aType of
      MAGICTYPE_WRESTLING,
      MAGICTYPE_FENCING,
      MAGICTYPE_SWORDSHIP,
      MAGICTYPE_HAMMERING,
      MAGICTYPE_SPEARING,
      MAGICTYPE_BOWING,
      MAGICTYPE_THROWING : begin
         if HeadSeekRate <= 10 then begin
            FSendClass.SendChatMessage (Conv('因头的活力不足，所以选择武功失败'), SAY_COLOR_SYSTEM);
            Result := false;
            exit;
         end;
      end;
      MAGICTYPE_ECT :
         begin
            if FpCurAttackMagic = nil then begin
               FSendClass.SendChatMessage (Conv('无法使用辅助性武功'), SAY_COLOR_SYSTEM);
               Result := false;
               exit;
            end;
            
            if FpCurAttackMagic^.rcSkillLevel < 9999 then begin
               FSendClass.SendChatMessage (Conv('辅助武功要在使用攻击性武功的状态下才能使用。'), SAY_COLOR_SYSTEM);
               Result := false;
               exit;
            end;
         end;
      MAGICTYPE_WINDOFHAND :
         if HeadSeekRate <= 10 then begin
            FSendClass.SendChatMessage (Conv('因头的活力不足，所以选择武功失败'), SAY_COLOR_SYSTEM);
            Result := false;
            exit;
         end;
   end;
end;

function THaveMagicClass.AllowSelectBestMagic (pMagicData : PTMagicData) : Boolean;
var
   i : integer;
begin
   Result := true;
   i := 0;
   
   //鞘夸盔扁 厚背
   if pMagicData^.rKeepEnergy >= FAttribClass.CurEnergy then begin
      FSendClass.SendChatMessage (Conv ('元气不足'), SAY_COLOR_SYSTEM);
      Result := false;
      exit;
   end;

   //荤侩窍绊磊 窍绰 公傍狼 包访己阑 犬牢茄促
   if pMagicData^.rPatternType <> TYPE_MAGICRELATION_NONE then begin
      case pMagicData^.rRelationMagic of
         TYPE_MAGICRELATION_BASIC:
            begin
               if (pCurAttackMagic <> nil) and (pCurAttackMagic^.rMagicClass = MAGICCLASS_MAGIC) then begin
               end else begin
                  inc (i);
               end;
               if (pCurProtectingMagic <> nil) and (pCurProtectingMagic^.rMagicClass = MAGICCLASS_MAGIC) then begin
               end else begin
                  inc (i);
               end;

               if i = 2 then begin
                  FSendClass.SendChatMessage (Conv ('可以搭配一级武功使用'), SAY_COLOR_SYSTEM);
                  Result := false;
                  exit;
               end;
            end;
         TYPE_MAGICRELATION_RISE:
            begin
               if (pCurAttackMagic <> nil) and (pCurAttackMagic^.rMagicClass = MAGICCLASS_RISEMAGIC) then begin
               end else begin
                  inc (i);
               end;
               if (pCurProtectingMagic <> nil) and (pCurProtectingMagic^.rMagicClass = MAGICCLASS_RISEMAGIC) then begin
               end else begin
                  inc (i);
               end;

               if i = 2 then begin
                  FSendClass.SendChatMessage (Conv ('只限开上层武功时使用'), SAY_COLOR_SYSTEM);
                  Result := false;
                  exit;
               end;
            end;
         TYPE_MAGICRELATION_BESTPROTECT:
            begin
               if (pCurProtectingMagic <> nil) and (pCurProtectingMagic^.rMagicClass = MAGICCLASS_BESTMAGIC) then begin
               end else begin
                  FSendClass.SendChatMessage (Conv ('只限开功力时使用'), SAY_COLOR_SYSTEM);
                  Result := false;
                  exit;
               end;
            end;
         TYPE_MAGICRELATION_BESTATTACK:
            begin
               if (pCurAttackMagic <> nil) and (pCurAttackMagic^.rMagicClass = MAGICCLASS_BESTMAGIC) then begin
               end else begin
                  FSendClass.SendChatMessage (Conv ('只限开绝世武功时使用'), SAY_COLOR_SYSTEM);
                  Result := false;
                  exit;
               end;
            end;
      end;
   end;

   // 秦寸 公傍阑 荤侩窍扁 困秦 荤侩吝捞绢具 窍绰 公傍捞 荤侩吝牢瘤 犬牢

   if pMagicData^.rNeedMagic[0] = 0 then exit;
   if (pCurAttackMagic <> nil) and (StrPas(@pCurAttackMagic^.rname) = StrPas(@pMagicData^.rNeedMagic)) then exit;
   if (pCurProtectingMagic <> nil) and (StrPas(@pCurProtectingMagic^.rname) = StrPas(@pMagicData^.rNeedMagic)) then exit;

   FSendClass.SendChatMessage (format(Conv ('只限开%s武功'), [StrPas(@pMagicData^.rname)]), SAY_COLOR_SYSTEM);
   Result := false;
end;

function  THaveMagicClass.SelectBasicMagic (akey : integer; aflag : Boolean): integer;
begin
   Result := SELECTMAGIC_RESULT_NONE;

   if akey < 0 then exit;
   if akey > HAVEBASICMAGICSIZE - 1 then exit;
   if DefaultMagic [aKey].rName [0] = 0 then exit;

   if AllowSelectMagic (DefaultMagic[akey].rMagicType, aFlag) = false then begin
      Result := SELECTMAGIC_RESULT_FALSE;
      exit;
   end;

   case DefaultMagic[akey].rMagicType of
      MAGICTYPE_WRESTLING..MAGICTYPE_THROWING : begin
         if (FpCurAttackMagic <> nil) and (@DefaultMagic[akey] <> FpCurAttackMagic) then begin
            TUserObject(FBasicObject)._3HitCount := 0;
            TUserObject(FBasicObject)._3HitTick := 0;
         end;

         FpCurAttackMagic := @DefaultMagic[akey];
         if FpCurEctMagic <> nil then begin
            if FpCurEctMagic^.rMagicClass <> MAGICCLASS_BESTMAGIC then begin
               if FpCurAttackMagic^.rcSkillLevel < 9999 then SetEctMagic (nil);
            end else begin
               if FpCurEctMagic^.rRelationMagic = TYPE_MAGICRELATION_BESTATTACK then SetEctMagic(nil);
            end;
         end;

         if FpCurSpecialMagic <> nil then SetSpecialMagic(nil);
      end;
      MAGICTYPE_RUNNING    :
         begin
            SetRunningMagic ( @DefaultMagic[akey]);
            if FpCurRunningMagic <> nil then Result := SELECTMAGIC_RESULT_RUNNING
            else Result := SELECTMAGIC_RESULT_NORMAL;
         end;
      MAGICTYPE_BREATHNG   :
         begin
            SetBreathngMagic ( @DefaultMagic[akey]);
            if FpCurBreathngMagic <> nil then Result := SELECTMAGIC_RESULT_SITDOWN
            else Result := SELECTMAGIC_RESULT_NORMAL;

            if FpCurBreathngMagic <> nil then begin
               SetProtectingMagic (nil);
               if (FpCurEctMagic <> nil) and (FpCurEctMagic^.rMagicClass = MAGICCLASS_BESTMAGIC) then begin
                  SetEctMagic (nil);
               end;
            end;
         end;
      MAGICTYPE_PROTECTING :
         begin
            SetProtectingMagic ( @DefaultMagic[akey]);

            if FpCurProtectingMagic <> nil then SetBreathngMagic (nil);
         end;
   end;

   SetLifeData;
end;

function  THaveMagicClass.SelectHaveMagic (akey : integer; aflag : Boolean): integer;
begin
   Result := SELECTMAGIC_RESULT_NONE;

   if akey < 0 then exit;
   if akey > HAVEMAGICSIZE - 1 then exit;
   if HaveMagicArr[akey].rName[0] = 0 then exit;

   if AllowSelectMagic (HaveMagicArr[akey].rMagicType, aFlag) = false then begin
      Result := SELECTMAGIC_RESULT_FALSE;
      exit;
   end;

   Result := SELECTMAGIC_RESULT_NONE;
   case HaveMagicArr[akey].rMagicType of
      MAGICTYPE_WRESTLING..MAGICTYPE_THROWING : begin
         if (FpCurAttackMagic <> nil) and (@HaveMagicArr[akey] <> FpCurAttackMagic) then begin
            TUserObject(FBasicObject)._3HitCount := 0;
            TUserObject(FBasicObject)._3HitTick := 0;
         end;
         FpCurAttackMagic := @HaveMagicArr[akey];
         if FpCurEctMagic <> nil then begin
            if FpCurEctMagic^.rMagicClass <> MAGICCLASS_BESTMAGIC then begin
               if FpCurAttackMagic^.rcSkillLevel < 9999 then SetEctMagic (nil);
            end else begin
               if FpCurEctMagic^.rRelationMagic = TYPE_MAGICRELATION_BESTATTACK then SetEctMagic(nil);
            end;
         end;

         if FpCurSpecialMagic <> nil then SetSpecialMagic(nil);
      end;
      MAGICTYPE_RUNNING    :
         begin
            SetRunningMagic ( @HaveMagicArr[akey]);
            if FpCurRunningMagic <> nil then Result := SELECTMAGIC_RESULT_RUNNING
            else Result := SELECTMAGIC_RESULT_NORMAL;
         end;
      MAGICTYPE_BREATHNG   :
         begin
            SetBreathngMagic ( @HaveMagicArr[akey]);
            if FpCurBreathngMagic <> nil then Result := SELECTMAGIC_RESULT_SITDOWN
            else Result := SELECTMAGIC_RESULT_NORMAL;
            if FpCurBreathngMagic <> nil then SetProtectingMagic (nil);
         end;
      MAGICTYPE_PROTECTING :
         begin
            SetProtectingMagic ( @HaveMagicArr[akey]);
            if FpCurProtectingMagic <> nil then SetBreathngMagic (nil);
         end;
      MAGICTYPE_ECT :
         begin
            if FpCurAttackMagic <> nil then begin
               if FpCurAttackMagic^.rMagicClass = MAGICCLASS_MYSTERY then begin
                  FSendClass.SendChatMessage (Conv('开掌法就不能用灵动八方'),SAY_COLOR_SYSTEM);
                  exit;
               end else begin
                  SetEctMagic (@HaveMagicArr[akey]);
               end;
            end;

         end;
   end;
   SetLifeData;
end;

function  THaveMagicClass.SelectHaveRiseMagic (akey : integer; aflag : Boolean): integer;
begin
   Result := SELECTMAGIC_RESULT_NONE;
   
   if akey < 0 then exit;
   if akey > HAVERISEMAGICSIZE - 1 then exit;
   if HaveRiseMagicArr[akey].rName[0] = 0 then exit;

   if AllowSelectMagic (HaveRiseMagicArr[akey].rMagicType, aFlag) = false then begin
      Result := SELECTMAGIC_RESULT_FALSE;
      exit;
   end;

   case HaveRiseMagicArr[akey].rMagicType of
      MAGICTYPE_WRESTLING..MAGICTYPE_THROWING :
         begin
            if (FpCurAttackMagic <> nil) and (@HaveRiseMagicArr[akey] <> FpCurAttackMagic) then begin
               TUserObject(FBasicObject)._3HitCount := 0;
               TUserObject(FBasicObject)._3HitTick := 0;
            end;

            FpCurAttackMagic := @HaveRiseMagicArr[akey];
            if FpCurEctMagic <> nil then begin
               if FpCurEctMagic^.rMagicClass <> MAGICCLASS_BESTMAGIC then begin
                  if FpCurAttackMagic^.rcSkillLevel < 9999 then SetEctMagic (nil);
               end else begin
                  if FpCurEctMagic^.rRelationMagic = TYPE_MAGICRELATION_BESTATTACK then SetEctMagic(nil);
               end;
            end;

            if FpCurSpecialMagic <> nil then SetSpecialMagic(nil);
         end;
      MAGICTYPE_RUNNING    :
         begin
            SetRunningMagic ( @HaveRiseMagicArr[akey]);
            if FpCurRunningMagic <> nil then Result := SELECTMAGIC_RESULT_RUNNING
            else Result := SELECTMAGIC_RESULT_NORMAL;
         end;
      MAGICTYPE_BREATHNG   :
         begin
            SetBreathngMagic ( @HaveRiseMagicArr[akey]);
            if FpCurBreathngMagic <> nil then Result := SELECTMAGIC_RESULT_SITDOWN
            else Result := SELECTMAGIC_RESULT_NORMAL;
            if FpCurBreathngMagic <> nil then SetProtectingMagic (nil);
         end;
      MAGICTYPE_PROTECTING :
         begin
            SetProtectingMagic ( @HaveRiseMagicArr[akey]);
            if FpCurProtectingMagic <> nil then SetBreathngMagic (nil);
         end;
      MAGICTYPE_ECT :
         begin
            SetEctMagic ( @HaveRiseMagicArr[akey]);
         end;
   end;
   SetLifeData;
end;

function  THaveMagicClass.GetPossibleGrade (atype, agrade: byte): Boolean;
var
   i : integer;
begin
   Result := false;
   case atype of
      0: begin //傍仿
         for i := 0 to HAVEBESTPROTECTMAGICSIZE-1 do begin
            if HaveBestProtectMagicArr[i].rname[0] <> 0 then begin
               if (HaveBestProtectMagicArr[i].rcSkillLevel = 9999) and
                  (HaveBestProtectMagicArr[i].rGrade = agrade) then begin
                  Result := true;
                  exit;
               end;
            end;
         end;
      end;
      1: begin //例技公傍
         for i := 0 to HAVEBESTATTACKMAGICSIZE-1 do begin
            if HaveBestAttackMagicArr[i].rname[0] <> 0 then begin
               if (HaveBestAttackMagicArr[i].rcSkillLevel = 9999) and
                  (HaveBestAttackMagicArr[i].rGrade = agrade) then begin
                  Result := true;
                  exit;
               end;
            end;
         end;
      end;
   end;
end;

function  THaveMagicClass.SetUseMagicGradeUp (atype, tg : byte): Boolean;
var
   Str, amagicname : string;
   i : integer;
   akey : byte;
begin
   Result := false;
   if (atype < 0) or (atype > 3) then exit;
   if (tg > 2) or (tg < 0) then exit;

   case atype of
      0: //脚傍
         begin
            if pCurProtectingMagic = nil then exit;
            if pCurProtectingMagic^.rMagicClass <> MAGICCLASS_BESTMAGIC then exit;
            if pCurProtectingMagic^.rMagicType <> MAGICTYPE_PROTECTING then exit;
            if pCurProtectingMagic^.rcSkillLevel <> 9999 then exit;
            if pCurProtectingMagic^.rGrade + 1 <> tg then exit;

            for i := 0 to HAVEBESTPROTECTMAGICSIZE-1 do begin
               if pCurProtectingMagic = @HaveBestProtectMagicArr[i] then begin
                  amagicname := StrPas(@HaveBestProtectMagicArr[i].rName);
                  HaveBestProtectMagicArr[i].rGrade := HaveBestProtectMagicArr[i].rGrade + 1;
                  HaveBestProtectMagicArr[i].rSkillExp := 0;
                  HaveBestProtectMagicArr[i].rcSkillLevel := GetLevel (0);
                  //HaveBestProtectMagicArr[i].
                  MagicCycleClass.GetData(amagicname, HaveBestProtectMagicArr[i].rGrade, HaveBestProtectMagicArr[i]);
                  MagicClass.Calculate_cLifeData (@HaveBestProtectMagicArr[i]);
                  FSendClass.SendHaveBestProtectMagic(i, HaveBestProtectMagicArr[i]);
                  Str := format (Conv ('%s 恭喜你'), [StrPas (@FBasicObject.BasicData.Name)]) + ',';
                  Str := Str + format (Conv ('%s升到了%d级'), [StrPas (@HaveBestProtectMagicArr[i].rName), HaveBestProtectMagicArr[i].rGrade+1]);

                  UserList.SendTopMessage(str);
                  exit;
               end;
            end;

         end;
      1: //例技公傍
         begin
            if pCurAttackMagic = nil then exit;
            if pCurAttackMagic^.rMagicClass <> MAGICCLASS_BESTMAGIC then exit;
            if pCurAttackMagic^.rcSkillLevel <> 9999 then exit;
            if pCurAttackMagic^.rGrade + 1 <> tg then exit;

            for i := 0 to HAVEBESTATTACKMAGICSIZE-1 do begin
               if pCurAttackMagic = @HaveBestAttackMagicArr[i] then begin
                  amagicname := StrPas(@HaveBestAttackMagicArr[i].rName);

                  HaveBestAttackMagicArr[i].rGrade := HaveBestAttackMagicArr[i].rGrade + 1;
                  HaveBestAttackMagicArr[i].rSkillExp := 0;
                  HaveBestAttackMagicArr[i].rcSkillLevel := GetLevel (0);
                  
                  MagicCycleClass.GetData(amagicname, HaveBestAttackMagicArr[i].rGrade, HaveBestAttackMagicArr[i]);
                  MagicClass.Calculate_cLifeData (@HaveBestAttackMagicArr[i]);
                  FSendClass.SendHaveBestAttackMagic(i, HaveBestAttackMagicArr[i]);
                  Str := format (Conv ('%s 恭喜你'), [StrPas (@FBasicObject.BasicData.Name)]) + ',';
                  Str := Str + format (Conv ('%s升到了%d级'), [StrPas (@HaveBestAttackMagicArr[i].rName), HaveBestAttackMagicArr[i].rGrade+1]);

                  UserList.SendTopMessage(str);

                  if HaveBestAttackMagicArr[i].rGrade > CurrentGrade then begin
                     CurrentGrade := HaveBestAttackMagicArr[i].rGrade;
                     FAttribClass.AddableStatePoint := FAttribClass.AddableStatePoint + CurrentGrade * 100;
                     FSendClass.SendChatMessage (format(Conv ('升级获得%d真气'), [CurrentGrade * 100]),SAY_COLOR_SYSTEM);
                     FSendClass.SendExtraAttribValues(FAttribClass);
                  end;
                  exit;
               end;
            end;
         end;
      2: //檬侥
         begin
         end;
   end;

end;

function  THaveMagicClass.SelectHaveBestMagic (akey : Integer; aflag : Boolean): integer;
var
   pMagicData : PTMagicData;
begin
   Result := SELECTMAGIC_RESULT_NONE;

   case akey of
      0..14:      pMagicData := @HaveBestSpecialMagicArr[akey];
      15..19:     pMagicData := @HaveBestProtectMagicArr[akey-15];
      20..24:     pMagicData := @HaveBestAttackMagicArr[akey-20];
      else exit;
   end;

   if pMagicData^.rname[0] = 0 then exit;

   if AllowSelectMagic (pMagicData^.rMagicType, aFlag) = false then begin
      Result := SELECTMAGIC_RESULT_FALSE;
      exit;
   end;

   if AllowSelectBestMagic (pMagicData) = false then begin
      Result := SELECTMAGIC_RESULT_FALSE;
      exit;
   end;

   case pMagicData^.rMagicType of
      MAGICTYPE_WRESTLING  : begin
         if (FpCurAttackMagic <> nil) and (pMagicData <> FpCurAttackMagic) then begin
            TUserObject(FBasicObject)._3HitCount := 0;
            TUserObject(FBasicObject)._3HitTick := 0;
         end;
         FpCurAttackMagic := pMagicData;
         if (FpCurEctMagic <> nil) and (FpCurEctMagic^.rMagicClass <> MAGICCLASS_BESTMAGIC) and
            (FpCurAttackMagic^.rcSkillLevel < 9999) then SetEctMagic (nil);
      end;
      MAGICTYPE_FENCING    : begin
         if (FpCurAttackMagic <> nil) and (pMagicData <> FpCurAttackMagic) then begin
            TUserObject(FBasicObject)._3HitCount := 0;
            TUserObject(FBasicObject)._3HitTick := 0;
         end;
         FpCurAttackMagic := pMagicData;
         if (FpCurEctMagic <> nil) and (FpCurEctMagic^.rMagicClass <> MAGICCLASS_BESTMAGIC) and
            (FpCurAttackMagic^.rcSkillLevel < 9999) then SetEctMagic (nil);
      end;
      MAGICTYPE_SWORDSHIP  : begin
         if (FpCurAttackMagic <> nil) and (pMagicData <> FpCurAttackMagic) then begin
            TUserObject(FBasicObject)._3HitCount := 0;
            TUserObject(FBasicObject)._3HitTick := 0;
         end;
         FpCurAttackMagic := pMagicData;
         if (FpCurEctMagic <> nil) and (FpCurEctMagic^.rMagicClass <> MAGICCLASS_BESTMAGIC) and
            (FpCurAttackMagic^.rcSkillLevel < 9999) then SetEctMagic (nil);
      end;
      MAGICTYPE_HAMMERING  : begin
         if (FpCurAttackMagic <> nil) and (pMagicData <> FpCurAttackMagic) then begin
            TUserObject(FBasicObject)._3HitCount := 0;
            TUserObject(FBasicObject)._3HitTick := 0;
         end;
         FpCurAttackMagic := pMagicData;
         if (FpCurEctMagic <> nil) and (FpCurEctMagic^.rMagicClass <> MAGICCLASS_BESTMAGIC) and
            (FpCurAttackMagic^.rcSkillLevel < 9999) then SetEctMagic (nil);
      end;
      MAGICTYPE_SPEARING   : begin
         if (FpCurAttackMagic <> nil) and (pMagicData <> FpCurAttackMagic) then begin
            TUserObject(FBasicObject)._3HitCount := 0;
            TUserObject(FBasicObject)._3HitTick := 0;
         end;
         FpCurAttackMagic := pMagicData;
         if (FpCurEctMagic <> nil) and (FpCurEctMagic^.rMagicClass <> MAGICCLASS_BESTMAGIC) and
            (FpCurAttackMagic^.rcSkillLevel < 9999) then SetEctMagic (nil);
      end;
      MAGICTYPE_BOWING     : begin
         if (FpCurAttackMagic <> nil) and (pMagicData <> FpCurAttackMagic) then begin
            TUserObject(FBasicObject)._3HitCount := 0;
            TUserObject(FBasicObject)._3HitTick := 0;
         end;
         FpCurAttackMagic := pMagicData;
         if (FpCurEctMagic <> nil) and (FpCurEctMagic^.rMagicClass <> MAGICCLASS_BESTMAGIC) and
            (FpCurAttackMagic^.rcSkillLevel < 9999) then SetEctMagic (nil);
      end;
      MAGICTYPE_THROWING   : begin
         if (FpCurAttackMagic <> nil) and (pMagicData <> FpCurAttackMagic) then begin
            TUserObject(FBasicObject)._3HitCount := 0;
            TUserObject(FBasicObject)._3HitTick := 0;
         end;
         FpCurAttackMagic := pMagicData;
         if (FpCurEctMagic <> nil) and (FpCurEctMagic^.rMagicClass <> MAGICCLASS_BESTMAGIC) and
            (FpCurAttackMagic^.rcSkillLevel < 9999) then SetEctMagic (nil);
      end;

      MAGICTYPE_RUNNING    :
         begin
            SetRunningMagic ( pMagicData);
            if FpCurRunningMagic <> nil then Result := SELECTMAGIC_RESULT_RUNNING
            else Result := SELECTMAGIC_RESULT_NORMAL;
         end;
      MAGICTYPE_BREATHNG   :
         begin
            SetBreathngMagic ( pMagicData);
            if FpCurBreathngMagic <> nil then Result := SELECTMAGIC_RESULT_SITDOWN
            else Result := SELECTMAGIC_RESULT_NORMAL;
            if FpCurBreathngMagic <> nil then SetProtectingMagic (nil);
         end;
      MAGICTYPE_PROTECTING :
         begin
            SetProtectingMagic (pMagicData);
            if FpCurProtectingMagic <> nil then SetBreathngMagic (nil);
         end;
      MAGICTYPE_ECT :
         begin
            SetEctMagic (pMagicData);
         end;
      MAGICTYPE_BESTSPECIAL :
         begin
            //傍拜冉荐 墨款飘 檬扁拳
            TUserObject(FBasicObject).SpecialAttackCount := 0;
            case pMagicData^.rPatternType of
               MAGICPATTERNTYPE_CONTINUOUS : SetEctMagic (pMagicData);
               MAGICPATTERNTYPE_LIMIT : SetSpecialMagic (pMagicData);
            end;
         end;
   end;
   SetLifeData;
end;

function THaveMagicClass.SelectHaveMysteryMagic (akey : Integer; aflag : Boolean): integer;
begin
   Result := SELECTMAGIC_RESULT_NONE;
   
   if akey < 0 then exit;
   if akey > HAVEMYSTERYMAGICSIZE - 1 then exit;
   if HaveMysteryMagicArr[akey].rName[0] = 0 then exit;

   if AllowSelectMagic (HaveMysteryMagicArr[akey].rMagicType, aFlag) = false then begin
      Result := SELECTMAGIC_RESULT_FALSE;
      exit;
   end;

   case HaveMysteryMagicArr[akey].rMagicType of
      MAGICTYPE_WINDOFHAND  : begin
         if (FpCurAttackMagic <> nil) and (@HaveMysteryMagicArr[akey] <> FpCurAttackMagic) then begin
            TUserObject(FBasicObject)._3HitCount := 0;
            TUserObject(FBasicObject)._3HitTick := 0;
         end;
         FpCurAttackMagic := @HaveMysteryMagicArr[akey];

         //2003-10
         if FpCurEctMagic <> nil then begin
            SetEctMagic (nil);
         end;

         if FpCurSpecialMagic <> nil then SetSpecialMagic(nil);
      end;
   end;
   SetLifeData;
end;

function  THaveMagicClass.AddWalking(aSItemName:String): Boolean;
var
   oldslevel, n : integer;
   exp : integer;
   Str : String;
begin
   Result := FALSE;
   if boAddExp = false then exit;

   if FpCurRunningMagic <> nil then begin
      inc (WalkingCount);
      //2003-02-19
      if pCurRunningMagic^.rcSkillLevel = 9999 then begin
         n := Walkingcount mod 2;
         if n = 0 then begin
            if TUser (FBasicObject).BasicData.Feature.rHideState <> hs_0 then begin      // 篮脚借阑订 救焊捞霸 03-06-11
               TUserObject (FBasicObject).ShowEffect2 (RUNNING_EFFECT_NUM + 1, lek_followdir, 0);
            end;
         end;
      end;

      if WalkingCount >= 10 then begin
         WalkingCount := 0;
         exp := DEFAULTEXP;

         case pCurRunningMagic^.rcSkillLevel of
            0..4999: ReQuestPlaySoundNumber := FpCurRunningMagic.rSoundEvent.rWavNumber;
            5000..8999: ReQuestPlaySoundNumber := FpCurRunningMagic.rSoundEvent.rWavNumber+1;
            else ReQuestPlaySoundNumber := FpCurRunningMagic.rSoundEvent.rWavNumber+2;
         end;

         oldslevel := pCurRunningMagic^.rcSkillLevel;
         AddPermitExp (pCurRunningMagic^.rcSkillLevel, pCurRunningMagic^.rSkillExp, exp, false);
         if oldslevel <> pCurRunningMagic^.rcSkillLevel then begin
            if pCurRunningMagic^.rcSkillLevel = 9999 then begin
               Str := format (Conv('%s 恭喜你'), [StrPas (@FBasicObject.BasicData.Name)]) + ',';
               Str := Str + format (Conv('%s 修练值已到顶点'), [StrPas (@pCurRunningMagic^.rName)]);
               UserList.SendTopMessage (Str);
            end;
            FindAndSendMagic (pCurRunningMagic);
            FSendClass.SendEventString (StrPas (@pCurRunningMagic^.rname));
         end;
         DecEventAttrib (FpCurRunningMagic);
         Result := TRUE;
      end;
   end;
end;

function  THaveMagicClass.AddWindOfHandExp (atype, aexp: integer; aFlag : Boolean): integer;
var
   oldslevel, oldValue,newValue : integer;
   Str : String;
   boRet : Boolean;
   User : TUserObject;
   SubData : TSubData;
begin
   Result := 0;
   if boAddExp = false then exit;
   if pPrevAttackMagic = nil then exit;

   oldslevel := pPrevAttackMagic^.rcSkillLevel;
   oldValue := pPrevAttackMagic^.rcSkillLevel div 1000;

   Result := AddPermitExp (pPrevAttackMagic^.rcSkillLevel, pPrevAttackMagic^.rSkillExp, aexp, aFlag);
   if oldslevel <> pPrevAttackMagic^.rcSkillLevel then begin
      if pPrevAttackMagic^.rGuildMagicType = 0 then begin

         newValue := pPrevAttackMagic^.rcSkillLevel div 1000;
         if oldValue <> newValue then begin
            TUserObject (FBasicObject).ShowEffect2 ( UPGRADE_EFFECT_NUM + 1,lek_follow, 0);
            SetWordString (SubData.SayString, IntToStr (UPGRADE_EFFECT_NUM) + '.wav');
            TUserObject (FBasicObject).SendLocalMessage (NOTARGETPHONE, FM_SOUND, FBasicObject.BasicData, SubData);
         end;

         if pPrevAttackMagic^.rcSkillLevel = 9999 then begin
            Str := format (Conv('%s 恭喜你'), [StrPas (@FBasicObject.BasicData.Name)]) + ',';
            Str := Str + format (Conv('%s 修练值已到顶点'), [StrPas (@pPrevAttackMagic^.rName)]);
            UserList.SendTopMessage (Str);
            user := TUserObject (FBasicObject);
            boRet := boBingGoMystery;
            if boRet = true then begin
               if user.GuildName = '' then begin
                  Str := format (Conv('%s 恭喜你'), [StrPas (@FBasicObject.BasicData.Name)]) + ',';
               end else begin
                  Str := format (Conv('恭喜%s'), [StrPas (@FBasicObject.BasicData.Name), user.GuildName]) + ',';
               end;
               Str := Str + Conv('掌法都满了');
               UserList.SendTopMessage (Str);
            end;
         end;
      end;

      FindAndSendMagic (pPrevAttackMagic);
      FSendClass.SendEventString (StrPas (@pPrevAttackMagic^.rname));
      MagicClass.Calculate_cLifeData (pPrevAttackMagic);
   end;
end;

function  THaveMagicClass.AddAttackExp (atype, aexp: integer; aFlag : Boolean ; aHaveItemClass : THaveItemClass): integer;
var
   oldslevel, oldValue,newValue : integer;
   Str : String;
   boRet,boRise : Boolean;
   User : TUserObject;
   SubData : TSubData;
begin
   Result := 0;

   if boAddExp = false then exit;

   boRise := false;
   oldslevel := pCurAttackMagic^.rcSkillLevel;
   oldValue := pCurAttackMagic^.rcSkillLevel div 1000;

   // add by Orber at 2004-10-07 08:40
   if (StrPas(@aHaveItemClass.HaveItemArr[0].rName) = Conv('九转金丹')) then begin
        ExpMulti := ExpMulti * 2;
   end;

   Result := AddPermitExp (pCurAttackMagic^.rcSkillLevel, pCurAttackMagic^.rSkillExp, aexp, aFlag);

   // add by Orber at 2004-10-07 08:40
   // ExpMulti := 1;

   if oldslevel <> pCurAttackMagic^.rcSkillLevel then begin
      if pCurAttackMagic^.rGuildMagicType = 0 then begin
         newValue := pCurAttackMagic^.rcSkillLevel div 1000;
         if oldValue <> newValue then begin
            TUserObject (FBasicObject).ShowEffect2 ( UPGRADE_EFFECT_NUM + 1,lek_follow, 0);
            SetWordString (SubData.SayString, IntToStr (UPGRADE_EFFECT_NUM) + '.wav');
            TUserObject (FBasicObject).SendLocalMessage (NOTARGETPHONE, FM_SOUND, FBasicObject.BasicData, SubData);
         end;

         if pCurAttackMagic^.rcSkillLevel = 9999 then begin
            case pCurAttackMagic^.rMagicClass of
               MAGICCLASS_BESTMAGIC : begin
                  Str := format (Conv ('%s 恭喜你'), [StrPas (@FBasicObject.BasicData.Name)]) + ',';
                  Str := Str + format (Conv ('%s (%d级)修炼已满'), [StrPas (@pCurAttackMagic^.rName), pCurAttackMagic^.rGrade + 1]);
                  UserList.SendTopMessage (Str);
               end;
               Else begin
                  Str := format (Conv ('%s 恭喜你'), [StrPas (@FBasicObject.BasicData.Name)]) + ',';
                  Str := Str + format (Conv ('%s 修练值已到顶点'), [StrPas (@pCurAttackMagic^.rName)]);
                  UserList.SendTopMessage (Str);
               end;
            end;

            user := TUserObject (FBasicObject);
            case pCurAttackMagic^.rMagicClass of
               MAGICCLASS_MAGIC, MAGICCLASS_RISEMAGIC :
                  begin
                     if pCurAttackMagic^.rMagicClass = MAGICCLASS_MAGIC then boRise := false
                     else if pCurAttackMagic^.rMagicClass = MAGICCLASS_RISEMAGIC then boRise := true;

                     boRet := boBingGoRow(boRise, pCurAttackMagic^.rMagicType, pCurAttackMagic^.rMagicRelation);
                     if boRet = true then begin
                        if user.GuildName = '' then begin
                           Str := format (Conv ('%s 恭喜你'), [StrPas (@FBasicObject.BasicData.Name)]) + ',';
                        end else begin
                           Str := format (Conv ('恭喜%s'), [StrPas (@FBasicObject.BasicData.Name), user.GuildName]) + ',';
                        end;
                        Str := Str + format (Conv ('%系列武功满级了'), [GetMagicRelationName(boRise, pCurAttackMagic^.rMagicRelation)]);
                        UserList.SendTopMessage (Str);
                     end;




                     boRet := boBingGoColumn(boRise, pCurAttackMagic^.rMagicType, pCurAttackMagic^.rMagicRelation);
                     if boRet = true then begin
                        if user.GuildName = '' then begin
                           Str := format (Conv ('%s 恭喜你'), [StrPas (@FBasicObject.BasicData.Name)]) + ',';
                        end else begin
                           Str := format (Conv ('恭喜%s'), [StrPas (@FBasicObject.BasicData.Name), user.GuildName]) + ',';
                        end;
                        Str := Str + format (Conv ('%s都满了'), [GetMagicTypeName(boRise,pCurAttackMagic^.rMagicType)]);
                        UserList.SendTopMessage (Str);
                     end;


                  end;
               MAGICCLASS_MYSTERY :
                  begin
                     boRet := boBingGoMystery;
                     if boRet = true then begin
                        if user.GuildName = '' then begin
                           Str := format (Conv ('%s 恭喜你'), [StrPas (@FBasicObject.BasicData.Name)]) + ',';
                        end else begin
                           Str := format (Conv ('恭喜%s'), [StrPas (@FBasicObject.BasicData.Name), user.GuildName]) + ',';
                        end;
                        Str := Str + Conv ('掌法都满了');
                        UserList.SendTopMessage (Str);
                     end;
                  end;
            end;
         end;
      end;

      FindAndSendMagic (pCurAttackMagic);
      FSendClass.SendEventString (StrPas (@pCurAttackMagic^.rname));
      MagicClass.Calculate_cLifeData (pCurAttackMagic);
   end;

   if (pCurEctMagic <> nil) and (pCurEctMagic^.rMagicClass <> MAGICCLASS_BESTMAGIC) then begin
      Result := GetPermitExp (pCurEctMagic.rcSkillLevel, aexp);
   end;
end;

function THaveMagicClass.AddStatePoint (pcAddStatePoint : PTCAddStatePoint): Boolean;
var
   akey, aidx, n, needstp : integer;
   needx, stp : integer;
   pMagicData : PTMagicData;
   amagicname : string;
begin
   Result := false;

   if (pcAddStatePoint^.rkey < 0) or (pcAddStatePoint^.rkey > 25 - 1) then exit;
   if (pcAddStatePoint^.ridx < 0) or (pcAddStatePoint^.ridx > 5 - 1) then exit; 

   case pcAddStatePoint^.rkey of
      0..14 :
         begin
            akey := pcAddStatePoint^.rkey;
            pMagicData := @HaveBestSpecialMagicArr[pcAddStatePoint^.rkey];
         end;
      15..19:
         begin
            akey := pcAddStatePoint^.rkey - 15;
            pMagicData := @HaveBestProtectMagicArr[pcAddStatePoint^.rkey - 15];
         end;
      20..24:
         begin
            akey := pcAddStatePoint^.rkey - 20;
            pMagicData := @HaveBestAttackMagicArr[pcAddStatePoint^.rkey - 20];
         end;
   end;

   if pMagicData^.rname[0] = 0 then exit;

   case pMagicData^.rMagicType of
      MAGICTYPE_BESTSPECIAL:
         begin
            n := HaveBestSpecialMagicArr[akey].rGrade;
            needstp := MagicCycleClass.NeedStatePoint[n];
            
            if FAttribClass.AddableStatePoint = 0 then begin
               FSendClass.SendChatMessage (Conv ('没有真气'), SAY_COLOR_SYSTEM);
               exit;
            end;

            if HaveBestSpecialMagicArr[akey].rGrade > CURRENT_CYCLE_MAXNUM - 2 then begin
               FSendClass.SendChatMessage (Conv ('无法继续升级'), SAY_COLOR_SYSTEM);
               exit;
            end;

            if FAttribClass.AddableStatePoint < needstp then begin
               FSendClass.SendChatMessage (format (Conv ('真气不足%d'), [needstp - FAttribClass.AddableStatePoint]), SAY_COLOR_SYSTEM);
               exit;
            end;

            FAttribClass.AddableStatePoint := FAttribClass.AddableStatePoint - needstp;
            inc (HaveBestSpecialMagicArr[akey].rGrade);
            amagicname := StrPas(@HaveBestSpecialMagicArr[akey].rname);
            MagicCycleClass.GetData(amagicname, HaveBestSpecialMagicArr[akey].rGrade, HaveBestSpecialMagicArr[akey]);
            MagicClass.Calculate_cLifeData (@HaveBestSpecialMagicArr[akey]);
            FSendClass.SendHaveBestSpecialMagic(akey, HaveBestSpecialMagicArr[akey]);
         end;
      MAGICTYPE_PROTECTING:
         begin
            case pcAddstatePoint^.ridx of
               0:
                  begin
                     stp := pMagicData^.rStatus.rArmorBody;
                     needx := GetNeedXByTotalPoint(stp);
                     if needx = 0 then exit;
                     
                     if needx > FAttribClass.AddableStatePoint then begin
                        FSendClass.SendChatMessage (format (Conv ('真气不足%d'), [needx-FAttribClass.AddableStatePoint]), SAY_COLOR_SYSTEM);
                        exit;
                     end;
                     FAttribClass.AddableStatePoint := FAttribClass.AddableStatePoint - needx;
                     inc (pMagicData^.rStatus.rArmorBody, needx);
                  end;
               1:
                  begin
                     stp := pMagicData^.rStatus.rArmorHead;
                     needx := GetNeedXByTotalPoint(stp);
                     if needx = 0 then exit;

                     if needx > FAttribClass.AddableStatePoint then begin
                        FSendClass.SendChatMessage (format (Conv ('真气不足%d'), [needx-FAttribClass.AddableStatePoint]), SAY_COLOR_SYSTEM);
                        exit;
                     end;
                     FAttribClass.AddableStatePoint := FAttribClass.AddableStatePoint - needx;
                     inc (pMagicData^.rStatus.rArmorHead, needx);
                  end;
               2:
                  begin
                     stp := pMagicData^.rStatus.rArmorArm;
                     needx := GetNeedXByTotalPoint(stp);
                     if needx = 0 then exit;

                     if needx > FAttribClass.AddableStatePoint then begin
                        FSendClass.SendChatMessage (format (Conv ('真气不足%d'), [needx-FAttribClass.AddableStatePoint]), SAY_COLOR_SYSTEM);
                        exit;
                     end;
                     FAttribClass.AddableStatePoint := FAttribClass.AddableStatePoint - needx;
                     inc (pMagicData^.rStatus.rArmorArm, needx);
                  end;
               3:
                  begin
                     stp := pMagicData^.rStatus.rArmorLeg;
                     needx := GetNeedXByTotalPoint(stp);
                     if needx = 0 then exit;

                     if needx > FAttribClass.AddableStatePoint then begin
                        FSendClass.SendChatMessage (format (Conv ('真气不足%d'), [needx-FAttribClass.AddableStatePoint]), SAY_COLOR_SYSTEM);
                        exit;
                     end;
                     FAttribClass.AddableStatePoint := FAttribClass.AddableStatePoint - needx;
                     inc (pMagicData^.rStatus.rArmorLeg, needx);
                  end;
               4:
                  begin
                     stp := pMagicData^.rStatus.rArmorEnergy;
                     needx := GetNeedXByTotalPoint(stp);
                     if needx = 0 then exit;

                     if needx > FAttribClass.AddableStatePoint then begin
                        FSendClass.SendChatMessage (format (Conv ('真气不足%d'), [needx-FAttribClass.AddableStatePoint]), SAY_COLOR_SYSTEM);
                        exit;
                     end;
                     FAttribClass.AddableStatePoint := FAttribClass.AddableStatePoint - needx;
                     inc (pMagicData^.rStatus.rArmorEnergy, needx);
                  end;
               else
                  begin
                     exit;
                  end;
            end; 
         end;
      else
         begin
               case pcAddstatePoint^.ridx of
               0:
                  begin
                     stp := pMagicData^.rStatus.rDamageBody;
                     needx := GetNeedXByTotalPoint(stp);
                     if needx = 0 then exit;

                     if needx > FAttribClass.AddableStatePoint then begin
                        FSendClass.SendChatMessage (format (Conv ('真气不足%d'), [needx-FAttribClass.AddableStatePoint]), SAY_COLOR_SYSTEM);
                        exit;
                     end;
                     FAttribClass.AddableStatePoint := FAttribClass.AddableStatePoint - needx;
                     inc (pMagicData^.rStatus.rDamageBody, needx);
                  end;
               1:
                  begin
                     stp := pMagicData^.rStatus.rDamageHead;
                     needx := GetNeedXByTotalPoint(stp);
                     if needx = 0 then exit;

                     if needx > FAttribClass.AddableStatePoint then begin
                        FSendClass.SendChatMessage (format (Conv ('真气不足%d'), [needx-FAttribClass.AddableStatePoint]), SAY_COLOR_SYSTEM);
                        exit;
                     end;
                     FAttribClass.AddableStatePoint := FAttribClass.AddableStatePoint - needx;
                     inc (pMagicData^.rStatus.rDamageHead, needx);
                  end;
               2:
                  begin
                     stp := pMagicData^.rStatus.rDamageArm;
                     needx := GetNeedXByTotalPoint(stp);
                     if needx = 0 then exit;

                     if needx > FAttribClass.AddableStatePoint then begin
                        FSendClass.SendChatMessage (format (Conv ('真气不足%d'), [needx-FAttribClass.AddableStatePoint]), SAY_COLOR_SYSTEM);
                        exit;
                     end;
                     FAttribClass.AddableStatePoint := FAttribClass.AddableStatePoint - needx;
                     inc (pMagicData^.rStatus.rDamageArm, needx);
                  end;
               3:
                  begin
                     stp := pMagicData^.rStatus.rDamageLeg;
                     needx := GetNeedXByTotalPoint(stp);
                     if needx = 0 then exit;

                     if needx > FAttribClass.AddableStatePoint then begin
                        FSendClass.SendChatMessage (format (Conv ('真气不足%d'), [needx-FAttribClass.AddableStatePoint]), SAY_COLOR_SYSTEM);
                        exit;
                     end;
                     FAttribClass.AddableStatePoint := FAttribClass.AddableStatePoint - needx;
                     inc (pMagicData^.rStatus.rDamageLeg, needx);
                  end;
               4:
                  begin
                     stp := pMagicData^.rStatus.rDamageEnergy;
                     needx := GetNeedXByTotalPoint(stp);
                     if needx = 0 then exit;
                     
                     if needx > FAttribClass.AddableStatePoint then begin
                        FSendClass.SendChatMessage (format (Conv ('真气不足%d'), [needx-FAttribClass.AddableStatePoint]), SAY_COLOR_SYSTEM);
                        exit;
                     end;
                     FAttribClass.AddableStatePoint := FAttribClass.AddableStatePoint - needx;
                     inc (pMagicData^.rStatus.rDamageEnergy, needx);
                  end;
               else
                  begin
                     exit;
                  end;
            end;
         end;
   end;

   MagicClass.Calculate_cLifeData(pMagicData);
   case pMagicData^.rMagicType of
      MAGICTYPE_BESTSPECIAL:
         begin
            FSendClass.SendHaveBestSpecialMagic (akey,HaveBestSpecialMagicArr[akey]);
         end;
      MAGICTYPE_PROTECTING:
         begin
            FSendClass.SendHaveBestProtectMagic (akey, HaveBestProtectMagicArr[akey]);
         end;
      else
         begin
            FSendClass.SendHaveBestAttackMagic (akey, HaveBestAttackMagicArr[akey]);
         end;
   end;

   //酒贰狼 鉴辑 吝夸. 官操搁 救凳
   //努扼捞攫飘 滚畔 焊咯林扁 魄窜且锭 柳扁狼 樊阑 焊绊 魄窜窍骨肺
   FSendClass.SendExtraAttribValues(FAttribClass);
   ShowBestMagicWindow(pcAddStatePoint^.rkey, pMagicData^);
end;

function  THaveMagicClass.AddProtectExp (atype, aexp: integer; aFlag : Boolean): integer;
var
   oldslevel : integer;
   Str : String;
   boRet, boRise : Boolean;
   User : TUser;
begin
   Result := 0;

   if boAddExp = false then exit;

   if pCurProtectingMagic = nil then exit;
   oldslevel := pCurProtectingMagic.rcSkillLevel;
   Result := AddPermitExp (pCurProtectingMagic.rcSkillLevel, pCurProtectingMagic.rSkillExp, aexp, aFlag);
   if oldslevel <> pCurProtectingMagic.rcSkillLevel then begin
      if pCurProtectingMagic^.rcSkillLevel = 9999 then begin
         Str := format (Conv ('%s 恭喜你'), [StrPas (@FBasicObject.BasicData.Name)]) + ',';
         Str := Str + format (Conv ('%s 修练值已到顶点'), [StrPas (@pCurProtectingMagic^.rName)]);
         UserList.SendTopMessage (Str);

         User := TUser (FBasicObject);         
         if pCurProtectingMagic^.rMagicClass = MAGICCLASS_MAGIC then boRise := false
         else if pCurProtectingMagic^.rMagicClass = MAGICCLASS_RISEMAGIC then boRise := true;

         boRet := boBingGoColumn (boRise, MAGICTYPE_PROTECTING, 0);
         if boRet = true then begin
            if User.GuildName = '' then begin
               Str := format (Conv ('%s 恭喜你'), [StrPas (@FBasicObject.BasicData.Name)]) + ',';
            end else begin
               Str := format (Conv ('恭喜%s'), [StrPas (@FBasicObject.BasicData.Name), user.GuildName]) + ',';
            end;
            Str := Str + Conv ('护体已满');
            UserList.SendTopMessage (Str);
         end;
      end;

      FindAndSendMagic (pCurProtectingMagic);
      FSendClass.SendEventString (StrPas (@pCurProtectingMagic^.rname));
      MagicClass.Calculate_cLifeData (pCurProtectingMagic);
   end;
end;

function  THaveMagicClass.AddEctExp ( atype, aexp: integer): integer;
var
   oldslevel : integer;
   Str : String;
begin
   Result := 0;

   if boAddExp = false then exit;
   
   if pCurEctMagic = nil then exit;
   if pCurEctMagic^.rMagicClass = MAGICCLASS_BESTMAGIC then exit;
      
   oldslevel := pCurEctMagic.rcSkillLevel;
   Result := AddPermitExp (pCurEctMagic.rcSkillLevel, pCurEctMagic.rSkillExp, aexp, false);
   if oldslevel <> pCurEctMagic.rcSkillLevel then begin
      if pCurEctMagic^.rcSkillLevel = 9999 then begin
         Str := format (Conv('%s 恭喜你'), [StrPas (@FBasicObject.BasicData.Name)]) + ',';
         Str := Str + format (Conv('%s 修练值已到顶点'), [StrPas (@pCurEctMagic^.rName)]);
         UserList.SendTopMessage (Str);
      end;
      FindAndSendMagic (pCurEctMagic);
      FSendClass.SendEventString (StrPas (@pCurEctMagic^.rname));
      MagicClass.Calculate_cLifeData (pCurEctMagic);
   end;
end;

function THaveMagicClass.boKeepingMagic (pMagicData: PTMagicData): Boolean;
begin
   Result := TRUE;
   if FAttribClass.CurInPower < pMagicData^.rKeepInPower  then Result := FALSE;
   if FAttribClass.CurOutPower < pMagicData^.rKeepOutPower  then Result := FALSE;
   if FAttribClass.CurMagic < pMagicData^.rKeepMagic  then Result := FALSE;
   if FAttribClass.CurLife < pMagicData^.rKeepLife  then Result := FALSE;
end;

function THaveMagicClass.boKeepingBestMagic (pMagicData: PTMagicData): Boolean;
begin
   Result := TRUE;
   if FAttribClass.CurEnergy < pMagicData^.rKeepEnergy then Result := false;
end;

procedure THaveMagicClass.Dec1SecAttribForBestSpecial (pMagicData: PTMagicData);
var
   decvalue : integer;
begin
   with FAttribClass do begin
      //2003-10
      //例技公傍俊辑绰 r5SecDecEnergy绰 1檬窜困肺 盔扁皑家 Percentage甫 狼固窃
      decvalue := Energy * pMagicData^.r5SecDecEnergy div 100;
      CurEnergy := CurEnergy - decvalue;

      if CurEnergy < 0 then CurEnergy := 0;
      if CurLife < 0 then CurLife := 0;
      if CurEnergy > Energy then CurEnergy := Energy;
   end;
end;

procedure THaveMagicClass.Dec5SecAttrib (pMagicData: PTMagicData);
begin
   with FAttribClass do begin
      CurInPower := CurInPower - pMagicData^.r5SecDecInPower;
      CurOutPower := CurOutPower - pMagicData^.r5SecDecOutPower;
      CurMagic := CurMagic - pMagicData^.r5SecDecMagic;
      CurLife := CurLife - pMagicData^.r5SecDecLife;

      if CurInPower < 0 then CurInPower := 0;
      if CurOutPower < 0 then CurOutPower := 0;
      if CurMagic < 0 then CurMagic := 0;
      if CurLife < 0 then CurLife := 0;

      if CurInPower > InPower then CurInPower := InPower;
      if CurOutPower > OutPower then CurOutPower := OutPower;
      if CurMagic > Magic then CurMagic := Magic;
      if CurLife > Life then CurLife := Life;
   end;
end;

procedure THaveMagicClass.DecEventAttrib (pMagicData: PTMagicData);
var
   n : integer;
begin
   with FAttribClass do begin
      n := pMagicData^.rEventDecInPower + pMagicData^.rEventDecInPower * pMagicData^.rcSkillLevel div INI_SKILL_DIV_EVENT;
      CurInPower := CurInPower - n;

      n := pMagicData^.rEventDecOutPower + pMagicData^.rEventDecOutPower * pMagicData^.rcSkillLevel div INI_SKILL_DIV_EVENT;
      CurOutPower := CurOutPower - n;

      n := pMagicData^.rEventDecMagic + pMagicData^.rEventDecMagic * pMagicData^.rcSkillLevel div INI_SKILL_DIV_EVENT;
      CurMagic := CurMagic - n;

      n := pMagicData^.rEventDecLife + pMagicData^.rEventDecLife * pMagicData^.rcSkillLevel div INI_SKILL_DIV_EVENT;
      CurLife := CurLife - n;

      if CurInPower < 0 then CurInPower := 0;
      if CurOutPower < 0 then CurOutPower := 0;
      if CurMagic < 0 then CurMagic := 0;
      if CurLife < 0 then CurLife := 0;

      if CurInPower > InPower then CurInPower := InPower;
      if CurOutPower > OutPower then CurOutPower := OutPower;
      if CurMagic > Magic then CurMagic := Magic;
      if CurLife > Life then CurLife := Life;
   end;
end;

procedure THaveMagicClass.DecBreathngAttrib (pMagicData: PTMagicData);
var
   max : integer;
begin
   with FAttribClass do begin
      max := AttribData.cHeadSeak div (6+(12000 - pMagicData^.rcSkillLevel) * 14 div 12000);
      max := max * pMagicData^.rEventBreathngDamageHead div 100;
      CurHeadLife := CurHeadLife - max;

      max := AttribData.cArmSeak div (6+(12000 - pMagicData^.rcSkillLevel) * 14 div 12000);
      max := max * pMagicData^.rEventBreathngDamageArm div 100;
      CurArmLife := CurArmLife - max;

      max := AttribData.cLegSeak div (6+(12000 - pMagicData^.rcSkillLevel) * 14 div 12000);
      max := max * pMagicData^.rEventBreathngDamageLeg div 100;
      CurLegLife := CurLegLife - max;

      max := AttribData.cInPower div (6+(12000 - pMagicData^.rcSkillLevel) * 14 div 12000);
      max := max * pMagicData^.rEventBreathngInPower div 100;
      CurInPower := CurInPower - max;

      max := AttribData.cOutPower div (6+(12000 - pMagicData^.rcSkillLevel) * 14 div 12000);
      max := max * pMagicData^.rEventBreathngOutPower div 100;
      CurOutPower := CurOutPower - max;

      max := AttribData.cMagic div (6+(12000 - pMagicData^.rcSkillLevel) * 14 div 12000);
      max := max * pMagicData^.rEventBreathngMagic div 100;
      CurMagic := CurMagic - max;

      max := AttribData.cLife div (6+(12000 - pMagicData^.rcSkillLevel) * 14 div 12000);
      max := max * pMagicData^.rEventBreathngLife div 100;
      CurLife := CurLife - max;

      if CurHeadLife < 0 then CurHeadLife := 0;
      if CurArmLife < 0 then CurArmLife := 0;
      if CurLegLife < 0 then CurLegLife := 0;

      if CurInPower < 0  then CurInPower := 0;
      if CurOutPower < 0  then CurOutPower := 0;
      if CurMagic < 0  then CurMagic := 0;
      if CurLife < 0  then CurLife := 0;

      if CurHeadLife > HeadLife then CurHeadLife := HeadLife;
      if CurArmLife > ArmLife then CurArmLife := ArmLife;
      if CurLegLife > LegLife then CurLegLife := LegLife;

      if CurInPower > InPower  then CurInPower := InPower;
      if CurOutPower > OutPower  then CurOutPower := OutPower;
      if CurMagic > Magic  then CurMagic := Magic;
      if CurLife > Life  then CurLife := Life;
   end;
end;

function THaveMagicClass.FindMagicByName (aMagicName : String) : Integer;
var
   i, SkillLevel : Integer;
begin
   Result := 0;
   if aMagicName = '' then exit;

   for i := 0 to HAVEBASICMAGICSIZE - 1 do begin
      if StrPas (@DefaultMagic [i].rName) = aMagicName then begin
         Result := DefaultMagic [i].rcSkillLevel;
         exit;
      end;
   end;

   SkillLevel := FindHaveMagicByName (aMagicName);
   if SkillLevel > 0 then begin
      Result := SkillLevel;
      exit;
   end;

   SkillLevel := FindHaveRiseMagicByName (aMagicName);
   if SkillLevel > 0 then begin
      Result := SkillLevel;
      exit;
   end;
end;

function THaveMagicClass.FindHaveMagicByName (aMagicName : String) : Integer;
var
   i : Integer;
begin
   Result := -1;
   for i := 0 to HAVEMAGICSIZE - 1 do begin
      if StrPas (@HaveMagicArr[i].rName) = aMagicName then begin
         Result := HaveMagicArr[i].rcSkillLevel;
         exit;
      end;
   end;
end;

function THaveMagicClass.FindHaveRiseMagicByName (aMagicName : String) : Integer;
var
   i : Integer;
begin
   Result := -1;
   for i := 0 to HAVERISEMAGICSIZE - 1 do begin
      if StrPas (@HaveRiseMagicArr[i].rName) = aMagicName then begin
         Result := HaveRiseMagicArr[i].rcSkillLevel;
         exit;
      end;
   end;
end;

function THaveMagicClass.FindHaveMagicByExtream (aMagicType, aMagicRelation : Integer) : Boolean;
var
   i : Integer;
begin
   Result := false;
   
   for i := 0 to HAVEMAGICSIZE - 1 do begin
      if HaveMagicArr [i].rGuildMagictype = 1 then continue;

      if HaveMagicArr [i].rMagicType = aMagicType then begin
         if HaveMagicArr [i].rMagicRelation = aMagicRelation then begin
            if HaveMagicArr [i].rcSkillLevel = 9999 then begin
               Result := true;
               exit;
            end;
         end;
      end;
   end;
end;

function THaveMagicClass.FindMagicByTypeAndSkill (aMagicType, aSkillLevel : Integer) : Boolean;
var
   i, j : Integer;
begin
   Result := False;

   if aMagicType < 0 then begin       // 鼻, 八, 档, 芒, 硼 葛滴 八荤
      for j := 0 to 5 - 1 do begin
         for i := 0 to 10 - 1 do begin
            if DefaultMagic [i].rMagicType = j then begin
               if DefaultMagic [i].rcSkillLevel >= aSkillLevel then begin
                  Result := true;
                  exit;
               end;
            end;
         end;

         for i := 0 to HAVEMAGICSIZE - 1 do begin
            if HaveMagicArr [i].rMagicType = j then begin
               if HaveMagicArr [i].rcSkillLevel >= aSkillLevel then begin
                  Result := true;
                  exit;
               end;
            end;
         end;
      end;
   end else begin
      for i := 0 to 10 - 1 do begin
         if DefaultMagic [i].rMagicType = aMagicType then begin
            if DefaultMagic [i].rcSkillLevel >= aSkillLevel then begin
               Result := true;
               exit;
            end;
         end;
      end;

      for i := 0 to HAVEMAGICSIZE - 1 do begin
         if HaveMagicArr [i].rMagicType = aMagicType then begin
            if HaveMagicArr [i].rcSkillLevel >= aSkillLevel then begin
               Result := true;
               exit;
            end;
         end;
      end;
   end;
end;

procedure THaveMagicClass.EditHaveMagicByName (aMagicName : String; aSkillLevel : Integer);
var
   i : Integer;
begin
   if aMagicName = '' then exit;
   if (aSkillLevel < 100) or (aSkillLevel > 9999) then exit;

   for i := 0 to 20 - 1 do begin
      if StrPas (@DefaultMagic[i].rName) = aMagicName then begin
         DefaultMagic[i].rSkillExp := GetExpOverLevel (aSkillLevel);
         DefaultMagic[i].rcSkillLevel := GetLevel (DefaultMagic[i].rSkillExp);
         FSendClass.SendBasicMagic (i, DefaultMagic[i]);
         MagicClass.Calculate_cLifeData (@DefaultMagic[i]);
         exit;
      end;
   end;
   for i := 0 to HAVEMAGICSIZE - 1 do begin
      if StrPas (@HaveMagicArr[i].rName) = aMagicName then begin
         HaveMagicArr[i].rSkillExp := GetExpOverLevel (aSkillLevel);
         HaveMagicArr[i].rcSkillLevel := GetLevel (HaveMagicArr[i].rSkillExp);
         FSendClass.SendHaveMagic (i, HaveMagicArr[i]);
         MagicClass.Calculate_cLifeData (@HaveMagicArr[i]);
         exit;
      end;
   end;
   for i := 0 to HAVERISEMAGICSIZE - 1 do begin
      if StrPas (@HaveRiseMagicArr[i].rName) = aMagicName then begin
         HaveRiseMagicArr[i].rSkillExp := GetExpOverLevel (aSkillLevel);
         HaveRiseMagicArr[i].rcSkillLevel := GetLevel (HaveRiseMagicArr[i].rSkillExp);
         FSendClass.SendHaveRiseMagic (i, HaveRiseMagicArr[i]);
         MagicClass.Calculate_cLifeData (@HaveRiseMagicArr[i]);
         exit;
      end;
   end;

   for i := 0 to HAVEMYSTERYMAGICSIZE - 1 do begin
      if StrPas (@HaveMysteryMagicArr[i].rName) = aMagicName then begin
         HaveMysteryMagicArr[i].rSkillExp := GetExpOverLevel (aSkillLevel);
         HaveMysteryMagicArr[i].rcSkillLevel := GetLevel (HaveMysteryMagicArr[i].rSkillExp);
         FSendClass.SendHaveMystery (i, HaveMysteryMagicArr[i]);
         MagicClass.Calculate_cLifeData (@HaveMysteryMagicArr[i]);
         exit;
      end;
   end;
   //2003-09-23
   for i := 0 to HAVEBESTSPECIALMAGICSIZE - 1 do begin
      if StrPas (@HaveBestSpecialMagicArr[i].rName) = aMagicName then begin
         HaveBestSpecialMagicArr[i].rSkillExp := 0;
         HaveBestSpecialMagicArr[i].rcSkillLevel := 0;
         FSendClass.SendHaveBestSpecialMagic (i, HaveBestSpecialMagicArr[i]);
         MagicClass.Calculate_cLifeData (@HaveBestSpecialMagicArr[i]);
         exit;
      end;
   end;
   for i := 0 to HAVEBESTPROTECTMAGICSIZE - 1 do begin
      if StrPas (@HaveBestProtectMagicArr[i].rName) = aMagicName then begin
         HaveBestProtectMagicArr[i].rSkillExp := GetExpOverLevel (aSkillLevel);
         HaveBestProtectMagicArr[i].rcSkillLevel := GetLevel (HaveBestProtectMagicArr[i].rSkillExp);
         FSendClass.SendHaveBestProtectMagic (i, HaveBestProtectMagicArr[i]);
         MagicClass.Calculate_cLifeData (@HaveBestProtectMagicArr[i]);
         exit;
      end;
   end;
   for i := 0 to HAVEBESTATTACKMAGICSIZE - 1 do begin
      if StrPas (@HaveBestAttackMagicArr[i].rName) = aMagicName then begin
         HaveBestAttackMagicArr[i].rSkillExp := GetExpOverLevel (aSkillLevel);
         HaveBestAttackMagicArr[i].rcSkillLevel := GetLevel (HaveBestAttackMagicArr[i].rSkillExp);
         FSendClass.SendHaveBestAttackMagic (i, HaveBestAttackMagicArr[i]);
         MagicClass.Calculate_cLifeData (@HaveBestAttackMagicArr[i]);
         exit;
      end;
   end;
end;

procedure THaveMagicClass.EditHaveMagicByName2 (aMagicName : String;  aMainSkill, aSubSkill : Integer);
var
   i : Integer;
begin
   if aMagicName = '' then exit;
   if (aMainSkill < 1) or (aMainSkill > 99) then exit;
   if (aSubSkill < 0) or (aSubSkill > 99) then exit;


   for i := 0 to 20 - 1 do begin
      if StrPas (@DefaultMagic[i].rName) = aMagicName then begin
         DefaultMagic[i].rSkillExp := GetLevelExpDetail (aMainSkill, aSubSkill);
         DefaultMagic[i].rcSkillLevel := GetLevel (DefaultMagic[i].rSkillExp);
         FSendClass.SendBasicMagic (i, DefaultMagic[i]);
         MagicClass.Calculate_cLifeData (@DefaultMagic[i]);
         exit;
      end;
   end;
   for i := 0 to HAVEMAGICSIZE - 1 do begin
      if StrPas (@HaveMagicArr[i].rName) = aMagicName then begin
         HaveMagicArr[i].rSkillExp := GetLevelExpDetail (aMainSkill, aSubSkill);
         HaveMagicArr[i].rcSkillLevel := GetLevel (HaveMagicArr[i].rSkillExp);
         FSendClass.SendHaveMagic (i, HaveMagicArr[i]);
         MagicClass.Calculate_cLifeData (@HaveMagicArr[i]);
         exit;
      end;
   end;
   for i := 0 to HAVERISEMAGICSIZE - 1 do begin
      if StrPas (@HaveRiseMagicArr[i].rName) = aMagicName then begin
         HaveRiseMagicArr[i].rSkillExp := GetLevelExpDetail (aMainSkill, aSubSkill);
         HaveRiseMagicArr[i].rcSkillLevel := GetLevel (HaveRiseMagicArr[i].rSkillExp);
         FSendClass.SendHaveRiseMagic (i, HaveRiseMagicArr[i]);
         MagicClass.Calculate_cLifeData (@HaveRiseMagicArr[i]);
         exit;
      end;
   end;

   for i := 0 to HAVEMYSTERYMAGICSIZE - 1 do begin
      if StrPas (@HaveMysteryMagicArr[i].rName) = aMagicName then begin
         HaveMysteryMagicArr[i].rSkillExp := GetLevelExpDetail (aMainSkill, aSubSkill);
         HaveMysteryMagicArr[i].rcSkillLevel := GetLevel (HaveMysteryMagicArr[i].rSkillExp);
         FSendClass.SendHaveMystery (i, HaveMysteryMagicArr[i]);
         MagicClass.Calculate_cLifeData (@HaveMysteryMagicArr[i]);
         exit;
      end;
   end;
   //2003-09-23
   for i := 0 to HAVEBESTSPECIALMAGICSIZE - 1 do begin
      if StrPas (@HaveBestSpecialMagicArr[i].rName) = aMagicName then begin
         HaveBestSpecialMagicArr[i].rSkillExp := GetLevelExpDetail (aMainSkill, aSubSkill);
         HaveBestSpecialMagicArr[i].rcSkillLevel := GetLevel (HaveBestSpecialMagicArr[i].rSkillExp);
         FSendClass.SendHaveBestSpecialMagic (i, HaveBestSpecialMagicArr[i]);
         MagicClass.Calculate_cLifeData (@HaveBestSpecialMagicArr[i]);
         exit;
      end;
   end;
   for i := 0 to HAVEBESTPROTECTMAGICSIZE - 1 do begin
      if StrPas (@HaveBestProtectMagicArr[i].rName) = aMagicName then begin
         HaveBestProtectMagicArr[i].rSkillExp := GetLevelExpDetail (aMainSkill, aSubSkill);
         HaveBestProtectMagicArr[i].rcSkillLevel := GetLevel (HaveBestProtectMagicArr[i].rSkillExp);
         FSendClass.SendHaveBestProtectMagic (i, HaveBestProtectMagicArr[i]);
         MagicClass.Calculate_cLifeData (@HaveBestProtectMagicArr[i]);
         exit;
      end;
   end;
   for i := 0 to HAVEBESTATTACKMAGICSIZE - 1 do begin
      if StrPas (@HaveBestAttackMagicArr[i].rName) = aMagicName then begin
         HaveBestAttackMagicArr[i].rSkillExp := GetLevelExpDetail (aMainSkill, aSubSkill);
         HaveBestAttackMagicArr[i].rcSkillLevel := GetLevel (HaveBestAttackMagicArr[i].rSkillExp);
         FSendClass.SendHaveBestAttackMagic (i, HaveBestAttackMagicArr[i]);
         MagicClass.Calculate_cLifeData (@HaveBestAttackMagicArr[i]);
         exit;
      end;
   end;
end;

procedure THaveMagicClass.EditHaveBestMagicByName (aMagicName: String; aSkillLevel,aGrade: Integer; strStateDamage, strStateArmor: String);//2003-09-23
var
   i, aexp : integer;
   aDamageBody, aDamageHead, aDamageArm, aDamageLeg, aDamageEnergy,
   aArmorBody, aArmorHead, aArmorArm, aArmorLeg, aArmorEnergy: integer;
   aMagicData : TMagicData;
   str : string;
begin
   if (aGrade <0) or (aGrade>CURRENT_CYCLE_MAXNUM) then exit;
   aexp := 0;

   MagicClass.GetMagicData(aMagicName, aMagicData, aexp);
   if aMagicData.rname[0] = 0 then exit;

   //单捞磐函屈 Damage
   strStateDamage := GetValidStr3 ( strStateDamage, str, '/');
   aDamageBody := _StrToInt(str);
   if (aDamageBody > 99) or (aDamageBody <0) then aDamageBody := 0;

   strStateDamage := GetValidStr3 ( strStateDamage, str, '/');
   aDamageHead := _StrToInt(str);
   if (aDamageHead > 99) or (aDamageHead <0) then aDamageHead := 0;

   strStateDamage := GetValidStr3 ( strStateDamage, str, '/');
   aDamageArm := _StrToInt(str);
   if (aDamageArm > 99) or (aDamageArm <0) then aDamageArm := 0;

   strStateDamage := GetValidStr3 ( strStateDamage, str, '/');
   aDamageLeg := _StrToInt(str);
   if (aDamageLeg > 99) or (aDamageLeg <0) then aDamageLeg := 0;

   strStateDamage := GetValidStr3 ( strStateDamage, str, '/');
   aDamageEnergy := _StrToInt(str);
   if (aDamageEnergy > 99) or (aDamageEnergy <0) then aDamageEnergy := 0;

   //单捞磐函屈 Armor
   strStateArmor := GetValidStr3 ( strStateArmor, str, '/');
   aArmorBody := _StrToInt(str);
   if (aArmorBody > 99) or (aArmorBody <0) then aArmorBody := 0;

   strStateArmor := GetValidStr3 ( strStateArmor, str, '/');
   aArmorHead := _StrToInt(str);
   if (aArmorHead > 99) or (aArmorHead <0) then aArmorHead := 0;

   strStateArmor := GetValidStr3 ( strStateArmor, str, '/');
   aArmorArm := _StrToInt(str);
   if (aArmorArm > 99) or (aArmorArm <0) then aArmorArm := 0;

   strStateArmor := GetValidStr3 ( strStateArmor, str, '/');
   aArmorLeg := _StrToInt(str);
   if (aArmorLeg > 99) or (aArmorLeg <0) then aArmorLeg := 0;

   strStateArmor := GetValidStr3 ( strStateArmor, str, '/');
   aArmorEnergy := _StrToInt(str);
   if (aArmorEnergy > 99) or (aArmorEnergy <0) then aArmorEnergy := 0;

   //2003-09-28
   //款康磊啊 涝仿茄 蔼狼 函券
   aDamageBody    := GetStatePointByUserState(aDamageBody);
   aDamageHead    := GetStatePointByUserState(aDamageHead);
   aDamageArm     := GetStatePointByUserState(aDamageArm);
   aDamageLeg     := GetStatePointByUserState(aDamageLeg);
   aDamageEnergy  := GetStatePointByUserState(aDamageEnergy);

   aArmorBody     := GetStatePointByUserState(aArmorBody);
   aArmorHead     := GetStatePointByUserState(aArmorHead);
   aArmorArm      := GetStatePointByUserState(aArmorArm);
   aArmorLeg      := GetStatePointByUserState(aArmorLeg);
   aArmorEnergy   := GetStatePointByUserState(aArmorEnergy);

   //2003-09-23
   for i := 0 to HAVEBESTSPECIALMAGICSIZE - 1 do begin
      if StrPas (@HaveBestSpecialMagicArr[i].rName) = aMagicName then begin
         HaveBestSpecialMagicArr[i].rSkillExp := 0;
         HaveBestSpecialMagicArr[i].rcSkillLevel := 0;
         HaveBestSpecialMagicArr[i].rGrade := Byte(aGrade);
         HaveBestSpecialMagicArr[i].rStatus.rDamageBody := aDamageBody;
         HaveBestSpecialMagicArr[i].rStatus.rDamageHead := aDamageHead;
         HaveBestSpecialMagicArr[i].rStatus.rDamageArm := aDamageArm;
         HaveBestSpecialMagicArr[i].rStatus.rDamageLeg := aDamageLeg;
         HaveBestSpecialMagicArr[i].rStatus.rDamageEnergy := aDamageEnergy;

         HaveBestSpecialMagicArr[i].rStatus.rArmorBody := aArmorBody;
         HaveBestSpecialMagicArr[i].rStatus.rArmorHead := aArmorHead;
         HaveBestSpecialMagicArr[i].rStatus.rArmorArm := aArmorArm;
         HaveBestSpecialMagicArr[i].rStatus.rArmorLeg := aArmorLeg;
         HaveBestSpecialMagicArr[i].rStatus.rArmorEnergy := aArmorEnergy;

         MagicCycleClass.GetData(aMagicName, aGrade, HaveBestSpecialMagicArr[i]);
         FSendClass.SendHaveBestSpecialMagic (i, HaveBestSpecialMagicArr[i]);
         MagicClass.Calculate_cLifeData (@HaveBestSpecialMagicArr[i]);
         exit;
      end;
   end;
   for i := 0 to HAVEBESTPROTECTMAGICSIZE - 1 do begin
      if StrPas (@HaveBestProtectMagicArr[i].rName) = aMagicName then begin
         HaveBestProtectMagicArr[i].rSkillExp := GetExpOverLevel (aSkillLevel);
         HaveBestProtectMagicArr[i].rcSkillLevel := GetLevel (HaveBestProtectMagicArr[i].rSkillExp);
         HaveBestProtectMagicArr[i].rGrade := Byte(aGrade);
         HaveBestProtectMagicArr[i].rStatus.rDamageBody := aDamageBody;
         HaveBestProtectMagicArr[i].rStatus.rDamageHead := aDamageHead;
         HaveBestProtectMagicArr[i].rStatus.rDamageArm := aDamageArm;
         HaveBestProtectMagicArr[i].rStatus.rDamageLeg := aDamageLeg;
         HaveBestProtectMagicArr[i].rStatus.rDamageEnergy := aDamageEnergy;

         HaveBestProtectMagicArr[i].rStatus.rArmorBody := aArmorBody;
         HaveBestProtectMagicArr[i].rStatus.rArmorHead := aArmorHead;
         HaveBestProtectMagicArr[i].rStatus.rArmorArm := aArmorArm;
         HaveBestProtectMagicArr[i].rStatus.rArmorLeg := aArmorLeg;
         HaveBestProtectMagicArr[i].rStatus.rArmorEnergy := aArmorEnergy;

         MagicCycleClass.GetData(aMagicName, aGrade, HaveBestProtectMagicArr[i]);
         MagicClass.Calculate_cLifeData (@HaveBestProtectMagicArr[i]);

         FSendClass.SendHaveBestProtectMagic (i, HaveBestProtectMagicArr[i]);
         exit;
      end;
   end;
   for i := 0 to HAVEBESTATTACKMAGICSIZE - 1 do begin
      if StrPas (@HaveBestAttackMagicArr[i].rName) = aMagicName then begin
         HaveBestAttackMagicArr[i].rSkillExp := GetExpOverLevel (aSkillLevel);
         HaveBestAttackMagicArr[i].rcSkillLevel := GetLevel (HaveBestAttackMagicArr[i].rSkillExp);
         HaveBestAttackMagicArr[i].rGrade := Byte(aGrade);
         HaveBestAttackMagicArr[i].rStatus.rDamageBody := aDamageBody;
         HaveBestAttackMagicArr[i].rStatus.rDamageHead := aDamageHead;
         HaveBestAttackMagicArr[i].rStatus.rDamageArm := aDamageArm;
         HaveBestAttackMagicArr[i].rStatus.rDamageLeg := aDamageLeg;
         HaveBestAttackMagicArr[i].rStatus.rDamageEnergy := aDamageEnergy;

         HaveBestAttackMagicArr[i].rStatus.rArmorBody := aArmorBody;
         HaveBestAttackMagicArr[i].rStatus.rArmorHead := aArmorHead;
         HaveBestAttackMagicArr[i].rStatus.rArmorArm := aArmorArm;
         HaveBestAttackMagicArr[i].rStatus.rArmorLeg := aArmorLeg;
         HaveBestAttackMagicArr[i].rStatus.rArmorEnergy := aArmorEnergy;

         MagicCycleClass.GetData(aMagicName, aGrade, HaveBestAttackMagicArr[i]);
         MagicClass.Calculate_cLifeData (@HaveBestAttackMagicArr[i]);
         
         FSendClass.SendHaveBestAttackMagic (i, HaveBestAttackMagicArr[i]);
         exit;
      end;
   end;  
end;

function  THaveMagicClass.PowerLevelUP : Boolean;
begin
   Result := false;

   if FCurPowerLevel = FPowerLevel then exit;
   Inc (FCurPowerLevel);
   FPowerLevelName := MagicClass.GetPowerLevelName (FCurPowerLevel);
   MaxShieldCalculate;
   
   FSendClass.SendShowPowerLevel (FPowerLevelName, FCurPowerLevel);

   SetLifeData;
   TUser (FBasicObject).SetLifeData;

   Result := true;
end;

function  THaveMagicClass.PowerLevelDOWN : Boolean;
begin
   Result := false;

   if FCurPowerLevel = 0 then exit;

   Dec (FCurPowerLevel);
   FPowerLevelName := MagicClass.GetPowerLevelName (FCurPowerLevel);
   MaxShieldCalculate;
   
   FSendClass.SendShowPowerLevel (FPowerLevelName, FCurPowerLevel);

   SetLifeData;
   TUser (FBasicObject).SetLifeData;

   Result := true;
end;

procedure THaveMagicClass.ChangeCurPowerLevel (aLevel : Integer);
var
   PowerLevelName : String;
begin
   CurPowerLevel := aLevel;
   PowerLevelName := MagicClass.GetPowerLevelName (aLevel);
   FSendClass.SendShowPowerLevel (PowerLevelName, aLevel);
   MaxShieldCalculate;
   SetLifeData;
end;

procedure THaveMagicClass.SelectItemWindow (pcClick : PTCClick);
var
   ItemData : TItemData;
   MagicData : TMagicData;
   Str, ViewName : String;
begin
   Case pcClick^.rwindow of
      WINDOW_BASICFIGHT : begin
         if not ViewBasicMagic (pcClick^.rKey, @MagicData) then exit;
      end;
      WINDOW_MAGICS : begin
         if not ViewMagic (pcClick^.rKey, @MagicData) then exit;
      end;
      WINDOW_RISEMAGICS : begin
         if not ViewRiseMagic (pcClick^.rKey, @MagicData) then exit;
      end;
      WINDOW_MYSTERYMAGICS : begin
         if not ViewMysteryMagic (pcClick^.rKey, @MagicData) then exit;
      end;
      WINDOW_BESTMAGIC : begin
         if not ViewBestMagic (pcClick^.rKey, @MagicData) then exit;
      end;
      Else exit;
   end;

   if MagicData.rMagicClass = MAGICCLASS_BESTMAGIC then begin
      ShowBestMagicWindow(pcClick^.rKey, MagicData);
   end else begin
      ViewName := StrPas (@MagicData.rName);
      Str := GetMiniMagicContents (MagicData);
      FSendClass.SendShowItemWindow2 (ViewName, Str, MAGIC_BOOK_ICON, ItemData.rColor, ItemData.rPrice, ItemData.rGrade , ItemData.rLockState , ItemData.runLockTime);
   end;
end;

procedure THaveMagicClass.ShowBestMagicWindow (aKey: Byte; var MagicData : TMagicData);
var
   ViewName, Str : String;
   damagebody,damagehead,damagearm,damageleg,damageenergy,
   armorbody,armorhead,armorarm,armorleg,armorenergy : word;
   NeedPoint : integer;
begin
   Str := GetContentsOfBestMagic(MagicData);
   ViewName := format (Conv ('%s(%d级)'), [StrPas(@Magicdata.rName), MagicData.rGrade+1]);
   case MagicData.rMagicType of
      MAGICTYPE_PROTECTING :
         begin
            armorbody := GetStatePointByTotalPoint(MagicData.rStatus.rArmorBody);
            armorhead := GetStatePointByTotalPoint(MagicData.rStatus.rArmorHead);
            armorarm := GetStatePointByTotalPoint(MagicData.rStatus.rArmorArm);
            armorleg := GetStatePointByTotalPoint(MagicData.rStatus.rArmorLeg);
            armorenergy := GetStatePointByTotalPoint(MagicData.rStatus.rArmorEnergy);

            FSendClass.SendShowBestProtectMagicWindow(ViewName, Str,aKey, MagicData.rcSkillLevel, MagicData.rShape,armorbody,armorhead,armorarm,armorleg,armorenergy);
         end;
      MAGICTYPE_BESTSPECIAL :
         begin
            FSendClass.SendShowBestSpecialMagicWindow(ViewName, Str, aKey, MagicCycleClass.NeedStatePoint[MagicData.rGrade], MagicData.rShape);         end;
      else
         begin
            damagebody := GetStatePointByTotalPoint(MagicData.rStatus.rDamageBody);
            damagehead := GetStatePointByTotalPoint(MagicData.rStatus.rDamageHead);
            damagearm := GetStatePointByTotalPoint(MagicData.rStatus.rDamageArm);
            damageleg := GetStatePointByTotalPoint(MagicData.rStatus.rDamageLeg);
            damageenergy := GetStatePointByTotalPoint(MagicData.rStatus.rDamageEnergy);
            FSendClass.SendShowBestAttackMagicWindow(ViewName, Str, aKey, MagicData.rcSkillLevel, MagicData.rShape, damagebody,damagehead,damagearm,damageleg,damageenergy);
         end;
   end;
end;

function THaveMagicClass.GetMiniMagicContents (var aMagicData: TMagicData): String;
begin
   Result := '';

   if aMagicData.rName [0] = 0 then exit;


   Result := format (Conv('修炼级别: %s'), [Get10000to100 (aMagicDAta.rcSkillLevel)]) + '<br>';

   with aMagicData.rcLifeData do begin
      Result := Result + format (Conv('攻击速度: %d'), [AttackSpeed]) + '<br>';
      Result := Result + format (Conv('恢复: %d 躲闪: %d'), [Recovery, Avoid]) + '<br>';
      Result := Result + format (Conv('准确度: %d 姿势维持: %d'), [Accuracy, KeepRecovery]) + '<br>';
      Result := Result + format (Conv('破坏力: %d / %d / %d / %d'),[DamageBody, DamageHead, DamageArm, DamageLeg]) + '<br>';
      Result := Result + format (Conv('防御力:  %d / %d / %d / %d'),[ArmorBody, ArmorHead, ArmorArm, ArmorLeg]) + '<br>';
   end;
end;

function THaveMagicClass.GetContentsOfBestMagic(var aMagicData: TMagicData): String;
begin
   Result := '';

   if aMagicData.rName [0] = 0 then exit;
   case aMagicData.rMagicType of
      MAGICTYPE_PROTECTING:
         begin
            with aMagicData.rcLifeData do begin
               Result := format (Conv ('防御力: :%d/%d/%d/%d/%d%%-%d'), [ArmorBody, ArmorHead, ArmorArm, ArmorLeg, ArmorEnergy, ArmorEValue]);
            end;
         end;
      MAGICTYPE_BESTSPECIAL:
         begin
            if aMagicData.rKind = MAGIC_KIND_KYUNGSIN then begin    // 版脚公如父... 040426
               Result := Result + Conv ('所能看到的画面上用鼠标点击无障碍物的点则可以移动') + ',';
               if aMagicData.rKeepEnergy <> 0 then begin
                  Result := Result + format (Conv ('所需 元气量: %d'), [aMagicData.rKeepEnergy div 100]) + ',';
               end;
            end;
            if aMagicData.rMoveSpeed <> 0 then begin
               Result := Result + format(Conv ('提升 移动速度: %d'), [aMagicData.rMoveSpeed]) + ',';
            end;
            if aMagicData.rboNotRecovery = TRUE then begin
               Result := Result + Conv ('使用必杀技时的姿势维持达到 100%') + ',';
            end;
            if aMagicData.r3Attrib <> 0 then begin
               Result := Result + format(Conv ('内/外/武功 %d%% 攻击'), [aMagicData.r3Attrib]) + ',';
            end;
            if (aMagicData.rMaxRange <> 0) or (aMagicData.rMinRange <>0) then begin
               Result := Result + format(Conv ('范围: 最小(%d) 最大(%d)'), [aMagicData.rMinRange, aMagicData.rMaxRange])+',';
            end;
            if (aMagicData.rAttackCount <> 0) and (aMagicData.rAttackCount <>1) then begin
               Result := Result + format(Conv ('攻击 次数: %d'), [aMagicData.rAttackCount]) + ',';
            end;
            if aMagicData.rNeedMagic[0] <> 0 then begin
               Result := Result + format(Conv ('所需武功: %s'), [StrPas(@aMagicData.rNeedMagic)]) + ',';
            end;
            case aMagicData.rRangeType of
               RANGETYPE_CENTER_8:  Result := Result + Conv ('攻击范围:八面攻击') + ',';
               RANGETYPE_CENTER_4:  Result := Result + Conv ('攻击范围:四面攻击') + ',';
            end;
            if aMagicData.rEnergySteal <> 0 then begin
               Result := Result + format(Conv ('吸收 %d%%武功元气伤害力'), [aMagicData.rEnergySteal]) + ',';            
//               Result := Result + format(Conv ('盔扁软荐 : %d%%'), [aMagicData.rEnergySteal]) + ',';
//               Result := Result + Conv ('惑措规狼 盔扁乔秦父怒 软荐') + ',';
            end;
            if aMagicData.rLifeSteal <> 0 then begin
               Result := Result + format(Conv ('将武功伤害力%d%%添加到我的活力上'), [aMagicData.rLifeSteal]) + ',';            
//               Result := Result + format(Conv ('劝仿软荐 : %d%%'), [aMagicData.rLifeSteal]) + ',';
//               Result := Result + Conv ('惑措规狼 个烹乔秦父怒 软荐') + ',';
            end;
            if aMagicData.rStun <> 0 then begin
               Result := Result + Conv ('终止对方攻击') + ',';
            end;
            if aMagicData.rPushLength <> 0 then begin
               Result := Result + format(Conv ('推力: %d'), [aMagicData.rPushLength]) + ',';
            end;
            if aMagicData.rLockDown <> 0 then begin
               Result := Result + format(Conv ('不能活动: %d秒'), [aMagicData.rLockDown]);
               Result := Result + format(Conv ('成功率: %d%%'), [aMagicData.rSuccessRate]) + ',';
            end;
            if aMagicData.rPassDamagePer <> 0 then begin
               Result := Result + format(Conv ('转移%d%%对方武功破坏力'), [aMagicData.rPassDamagePer]);
               Result := Result + format(Conv ('(成功率: %d%%)'), [aMagicData.rSuccessRate])+',';
            end;
            if aMagicData.rGetDamagePer <> 0 then begin
               Result := Result + format (Conv ('得到扣除了对方武功杀伤力中减少的%d%%值后的值'), [aMagicData.rGetDamagePer]) + ',';
            end;
            with aMagicData.rcLifeData do begin
               if AttackSpeed <> 0 then Result := Result + format(Conv ('移动速度增加: %d'), [AttackSpeed]) + ',';
               if (Recovery <>0) or (Avoid<>0) then Result := Result + format (Conv ('恢复: %d 躲闪: %d'), [-Recovery, Avoid]) + ',';
               if (Accuracy<>0) or (KeepRecovery<>0) then Result := Result + format (Conv ('准确度: %d 姿势维持: %d'), [Accuracy, KeepRecovery]) + ',';
               if DamageBody <> 0 then Result := Result + format (Conv ('破坏力: %d/%d/%d/%d/%d'), [DamageBody, DamageHead, DamageArm, DamageLeg, DamageEnergy]) + ',';
               if ArmorBody <> 0 then Result := Result + format (Conv ('防御力: %d/%d/%d/%d/%d'), [ArmorBody, ArmorHead, ArmorArm, ArmorLeg, ArmorEnergy]) + ',';
            end;
         end;
      else
         begin
            with aMagicData.rcLifeData do begin
               if AttackSpeed <> 0 then Result := Result + format (Conv ('攻击速度: %d'), [AttackSpeed]) + ' ';
               if (Recovery <>0) or (Avoid<>0) then Result := Result + format (Conv ('恢复: %d 躲闪: %d'), [Recovery, Avoid]) + ',';
               if (Accuracy<>0) or (KeepRecovery<>0) then Result := Result + format (Conv ('准确度: %d 姿势维持: %d'), [Accuracy, KeepRecovery]) + ',';
               if DamageBody <> 0 then Result := Result + format (Conv ('破坏力: %d/%d/%d/%d/%d'), [DamageBody, DamageHead, DamageArm, DamageLeg, DamageEnergy]) + ',';
               if ArmorBody <> 0 then Result := Result + format (Conv ('防御力: %d/%d/%d/%d/%d'), [ArmorBody, ArmorHead, ArmorArm, ArmorLeg, ArmorEnergy]) + ',';
            end;
         end;
   end;
end;

procedure THaveMagicClass.SetMagicIndex (boRise : Boolean; aRow, aColumn, aIndex : Integer);
begin
   if ( aRow < 0 ) or ( aRow > MAGICTYPE_PROTECTING) then exit;
   if ( aColumn < 0 ) or ( aColumn > MAGICRELATION_6) then exit;
   
   if boRise = true then begin
      RiseMagicIndexTable[aRow, aColumn] := aIndex;
   end else begin
      MagicIndexTable[aRow, aColumn] := aIndex;
   end;
end;

procedure THaveMagicClass.SetMysteryMagicIndex (aColumn, aIndex : Integer);
begin
   if (aColumn<0) or (aColumn>MAGICRELATION_6) then exit;
   MysteryMagicIndexTable[aColumn] := aIndex;
end;

procedure THaveMagicClass.ChangeMagicIndex (boRise : Boolean; aRow1, aColumn1, aRow2, aColumn2 : Integer);
var
   temp : Integer;
begin
   if boRise = true then begin
      temp := RiseMagicIndexTable[aRow1,aColumn1];
      RiseMagicIndexTable[aRow1,aColumn1] := RiseMagicIndexTable[aRow2,aColumn2];
      RiseMagicIndexTable[aRow2,aColumn2] := temp;
   end else begin
      temp := MagicIndexTable[aRow1,aColumn1];
      MagicIndexTable[aRow1,aColumn1] := MagicIndexTable[aRow2,aColumn2];
      MagicIndexTable[aRow2,aColumn2] := temp;
   end;
end;

function  THaveMagicClass.GetMagicTypeName (boRise : Boolean; aMagicType : Integer): String;
var
   str : String;
begin
   str := '';
   if ( aMagicType < MAGICTYPE_WRESTLING ) or ( aMagicType > MAGICTYPE_PROTECTING) then exit;
   if boRise = true then str := Conv('二级武功') + ' '
   else str := Conv('基本武功') + ' ';

   case aMagicType of
      MAGICTYPE_WRESTLING  : str := str + Conv('拳法');
      MAGICTYPE_FENCING    : str := str + Conv('剑法');
      MAGICTYPE_SWORDSHIP  : str := str + Conv('刀法');
      MAGICTYPE_HAMMERING  : str := str + Conv('槌法');
      MAGICTYPE_SPEARING   : str := str + Conv('枪术');
      MAGICTYPE_BOWING     :;
      MAGICTYPE_THROWING   :;
      MAGICTYPE_RUNNING    :;
      MAGICTYPE_BREATHNG   :;
      MAGICTYPE_PROTECTING : str := str + Conv('护体');
   end;

   Result := str;
end;

function THaveMagicClass.GetMagicRelationName (boRise : Boolean; aMagicRelation : Integer) : String;
var
   str : String;
begin
   str := '';
   if ( aMagicRelation < MAGICRELATION_0 ) or ( aMagicRelation > MAGICRELATION_6) then exit;
   if boRise = false then begin
      case aMagicRelation of
         MAGICRELATION_0: str := Conv('无影脚');
         MAGICRELATION_1: str := Conv('旋风脚');
         MAGICRELATION_2: str := Conv('太极拳');
         MAGICRELATION_3: str := Conv('无名拳法');
         MAGICRELATION_4: str := Conv('骨架击');
         MAGICRELATION_5: str := Conv('少林长拳');
         MAGICRELATION_6: str := Conv('如来金刚拳');
      end;
   end else begin
      case aMagicRelation of
         MAGICRELATION_0: str := Conv('无影疾风脚');
         MAGICRELATION_1: str := Conv('暴风连环拳');
         MAGICRELATION_2: str := Conv('太极八卦拳');
         MAGICRELATION_3: str := Conv('不羁浪人拳法');
         MAGICRELATION_4: str := Conv('狂破拳');
         MAGICRELATION_5: str := Conv('百步神拳');
         MAGICRELATION_6: str := Conv('如来天王拳');
      end;
   end;
   Result := str;
end;

function  THaveMagicClass.boBingGoRow (boRise : Boolean; aRow, aColumn : Integer): Boolean;
var
   aMagicType, aMagicRelation, i, aIndex : Integer;
begin
   Result := false;
   aMagicType := aRow;
   aMagicRelation := aColumn;

   if ( aMagicType > MAGICTYPE_SPEARING ) or ( aMagicType < 0) then exit;
   if ( aMagicRelation < 0 ) or ( aMagicRelation > MAGICRELATION_6 ) then exit;

   if aMagicRelation = MAGICRELATION_3 then begin
      for i := MAGICTYPE_WRESTLING to MAGICTYPE_SPEARING do begin
         if boRise = true then aIndex := RiseMagicIndexTable[i,aMagicRelation]
         else aIndex := MagicIndexTable[i,aMagicRelation];

         if aIndex = -1 then exit;
         if DefaultMagic[aIndex].rname[0] = 0 then exit;
         if DefaultMagic[aIndex].rcSkillLevel <> 9999 then exit;
      end;
      Result := true;
      exit;
   end;

   if boRise = true then begin
      for i := MAGICTYPE_WRESTLING to MAGICTYPE_SPEARING do begin
         aIndex := RiseMagicIndexTable [i, aMagicRelation];
         if aIndex = -1 then exit;
         if HaveRiseMagicArr[aIndex].rname[0] = 0 then exit;
         if HaveRiseMagicArr[aIndex].rcSkillLevel <> 9999 then exit;
      end;
      Result := true;
   end else begin
      for i := MAGICTYPE_WRESTLING to MAGICTYPE_SPEARING do begin
         aIndex := MagicIndexTable [i, aMagicRelation];
         if aIndex = -1 then exit;
         if HaveMagicArr[aIndex].rname[0] = 0 then exit;
         if HaveMagicArr[aIndex].rcSkillLevel <> 9999 then exit;
      end;
      Result := true;
   end;
end;

function  THaveMagicClass.boBingGoColumn (boRise : Boolean; aRow, aColumn : Integer): Boolean;
var
   i, aMagicType, aMagicRelation, aIndex : integer;
begin
   Result := false;
   aMagicType := aRow;
   aMagicRelation := aColumn;

   if ( aMagicRelation < 0 ) or ( aMagicRelation > MAGICRELATION_6 ) then exit;
   if aMagicType < 0 then exit;
   if aMagicType > MAGICTYPE_PROTECTING then exit;
   if (aMagicType > MAGICTYPE_SPEARING) and (aMagicType < MAGICTYPE_PROTECTING) then exit;

   if boRise = true then begin
      for i := MAGICRELATION_0 to MAGICRELATION_6 do begin
         aIndex := RiseMagicIndexTable[aMagicType, i];
         if aIndex = -1 then exit;
         if i = MAGICRELATION_3 then begin
            if DefaultMagic[aIndex].rcSkillLevel <> 9999 then exit;
         end else begin
            if HaveRiseMagicArr[aIndex].rname[0] = 0 then exit;
            if HaveRiseMagicArr[aIndex].rcSkillLevel <> 9999 then exit;
         end;
      end;
      
      Result := true;
   end else begin
      for i := MAGICRELATION_0 to MAGICRELATION_6 do begin
         aIndex := MagicIndexTable[aMagicType, i];
         if aIndex = -1 then exit;
         if i = MAGICRELATION_3 then begin
            if DefaultMagic[aIndex].rcSkillLevel <> 9999 then exit;
         end else begin
            if HaveMagicArr[aIndex].rname[0] = 0 then exit;
            if HaveMagicArr[aIndex].rcSkillLevel <> 9999 then exit;
         end;
      end;
      Result := true;
   end;
end;

function  THaveMagicClass.boBingGoMystery: Boolean;
var
   i, aIndex : integer;
begin
   Result := false;
   for i := MAGICRELATION_0 to MAGICRELATION_5 do begin
      aIndex := MysteryMagicIndexTable[i];
      if aIndex = -1 then exit;
      if HaveMysteryMagicArr[aIndex].rcSkillLevel <> 9999 then exit;
   end;
   Result := true;
end;

//2003-10
function  THaveMagicClass.boHaveOneRiseProtectingMagic: Boolean;
var
   i : integer;
begin
   Result := false;
   //惑铰公傍吝 惑铰碍脚捞 乐栏哥 必牢啊?

   //老馆惑铰碍脚
   for i := 0 to HAVERISEMAGICSIZE-1 do begin
      if HaveRiseMagicArr[i].rname[0] <> 0 then begin
         if (HaveRiseMagicArr[i].rMagicType = MAGICTYPE_PROTECTING) and
            (HaveRiseMagicArr[i].rcSkillLevel = 9999) then begin
            Result := true;
            exit;
         end;
      end;
   end;

   //扯牢碍脚
   for i := 0 to HAVEBASICMAGICSIZE-1 do begin
      if (DefaultMagic[i].rname[0] <>0) and (DefaultMagic[i].rMagicClass = MAGICCLASS_RISEMAGIC) then begin
         if (DefaultMagic[i].rMagicType = MAGICTYPE_PROTECTING) and
            (DefaultMagic[i].rcSkillLevel = 9999) then begin
            Result := true;
            exit;
         end;
      end;
   end;
end;

function  THaveMagicClass.boHaveThreeRiseAttackMagic(aMagicType: integer): Boolean; //2003-10
var
   i,n : integer;
begin
   Result := false;

   n := 0;

   //老馆惑铰公傍俊辑
   for i := 0 to HAVERISEMAGICSIZE-1 do begin
      if (HaveRiseMagicArr[i].rname[0]<>0) and (HaveRiseMagicArr[i].rMagicClass = MAGICCLASS_RISEMAGIC) then begin
         if (HaveRiseMagicArr[i].rMagicType = aMagicType) and
            (HaveRiseMagicArr[i].rcSkillLevel = 9999) then inc(n);
      end;
   end;

   //扯牢惑铰公傍俊辑
   for i := 0 to HAVEBASICMAGICSIZE-1 do begin
      if (DefaultMagic[i].rname[0]<>0) and (DefaultMagic[i].rMagicClass = MAGICCLASS_RISEMAGIC) then begin
         if (DefaultMagic[i].rMagicType = aMagicType) and
            (DefaultMagic[i].rcSkillLevel = 9999) then inc(n);
      end;
   end;
   if n>=3 then Result := true;
end;

function  THaveMagicClass.boHaveOneBestAttackMagic(aMagicType: integer): Boolean;
var
   i,n : integer;
begin
   Result := true;
   n := 0;

   for i := 0 to HAVEBESTATTACKMAGICSIZE-1 do begin
      if HaveBestAttackMagicArr[i].rname[0] <> 0 then begin
         if HaveBestAttackMagicArr[i].rMagicType = aMagictype then begin
            Result := false;
            exit;
         end;
      end;
   end;
end;

//2003-10
function  THaveMagicClass.GetMaxStatePointByGrade: Integer;
var
   i,m : integer;
begin
   Result := 0;
   m := 0;
   for i := 0 to 5-1 do begin
      if HaveBestAttackMagicArr[i].rname[0] = 0 then continue;
      if m <= HaveBestAttackMagicArr[i].rGrade then m := HaveBestAttackMagicArr[i].rGrade;
   end;

   case m of
      0: Result := 800;
      1: Result := 1800; //2窜(=2鞭, idx=1) 老 版快 width = 1000;
      2: Result := 3000; //3窜(=3鞭, idx=2) 老 版快 width = 1200;
   end;
end;

function THaveMagicClass.CheckMagic (aMagicClass, aMagicType : Integer; aMagicName : String) : Boolean;
var
   i : Integer;
begin
   Result := false;

   case aMagicClass of
      MAGICCLASS_MAGIC : begin
         for i := 0 to 10 - 1 do begin
            if (DefaultMagic [i].rMagicType = aMagicType) and
               (StrPas (@DefaultMagic [i].rname) = aMagicName) then begin
               result := true;
               exit;
            end;
         end;
         for i := 0 to HAVEMAGICSIZE - 1 do begin
            if (HaveMagicArr [i].rMagicType = aMagicType) and
               (StrPas (@HaveMagicArr [i].rname) = aMagicName) then begin
               result := true;
               exit;
            end;
         end;
      end;
      MAGICCLASS_RISEMAGIC : begin
         for i := 10 to 20 - 1 do begin
            if (DefaultMagic [i].rMagicType = aMagicType) and
               (StrPas (@DefaultMagic [i].rname) = aMagicName) then begin
               result := true;
               exit;
            end;
         end;
         for i := 0 to HAVERISEMAGICSIZE - 1 do begin
            if (HaveRiseMagicArr [i].rMagicType = aMagicType) and
               (StrPas (@HaveRiseMagicArr [i].rname) = aMagicName) then begin
               result := true;
               exit;
            end;
         end;
      end;
      MAGICCLASS_MYSTERY : begin
         for i := 0 to HAVEMYSTERYMAGICSIZE - 1 do begin
            if (HaveMysteryMagicArr [i].rMagicType = aMagicType) and
               (StrPas (@HaveMysteryMagicArr [i].rname) = aMagicName) then begin
               result := true;
               exit;
            end;
         end;
      end;
      MAGICCLASS_BESTMAGIC : begin
         for i := 0 to HAVEBESTSPECIALMAGICSIZE - 1 do begin
            if (HaveBestSpecialMagicArr [i].rMagicType = aMagicType) and
               (StrPas (@HaveBestSpecialMagicArr [i].rname) = aMagicName) then begin
               result := true;
               exit;
            end;
         end;
         for i := 0 to HAVEBESTPROTECTMAGICSIZE - 1 do begin
            if (HaveBestProtectMagicArr [i].rMagicType = aMagicType) and
               (StrPas (@HaveBestProtectMagicArr [i].rname) = aMagicName) then begin
               result := true;
               exit;
            end;
         end;
         for i := 0 to HAVEBESTATTACKMAGICSIZE - 1 do begin
            if (HaveBestAttackMagicArr [i].rMagicType = aMagicType) and
               (StrPas (@HaveBestAttackMagicArr [i].rname) = aMagicName) then begin
               result := true;
               exit;
            end;
         end;
      end;
      Else begin

      end;
   end;
end;

function  THaveMagicClass.ConditionBestAttackMagic (aMagicName : String) : Boolean;
var
   i : Integer;
   MagicData : TMagicData;
begin
   Result := false;

   //龋楷瘤扁 65.00阑 逞扁绰啊
   if FAttribClass.Virtue < 6501 then begin
      FSendClass.SendChatMessage(Conv ('浩然之气要在65.01以上'), SAY_COLOR_SYSTEM);
      exit;
   end;

   //唱捞 40.01
   if FAttribClass.Age < 4001 then begin
      FSendClass.SendChatMessage (Conv ('年龄要在40岁以上'), SAY_COLOR_SYSTEM);
      exit;
   end;

   MagicClass.GetMagicData (aMagicName, MagicData, 0);
   if StrPas (@MagicData.rRelationProtect) <> StrPas (@pCurProtectingMagic^.rname) then begin
      FSendClass.SendChatMessage(Conv ('要开相关的神功'), SAY_COLOR_SYSTEM);
      exit;
   end;

   //秦寸拌凯狼 惑铰公傍吝 3俺捞惑捞 必捞绢具凳
   if boHaveThreeRiseAttackMagic (MagicData.rMagicType) = false then begin
      FSendClass.SendChatMessage(Conv ('要想修炼此系列武功,必需要有同一系列的3个上层武功满级'), SAY_COLOR_SYSTEM);
      exit;
   end;

   for i := 0 to HAVEBESTATTACKMAGICSIZE -1 do begin
      if StrComp (@HaveBestAttackMagicArr[i].rName, @MagicData.rName) = 0 then begin
         FSendClass.SendChatMessage(Conv ('已经修炼过了'), SAY_COLOR_SYSTEM);
         exit;
      end;
   end;

   Result := true;
end;

function THaveMagicClass.ChangeRelationMagic (aMagicType : Integer) : Boolean;     // 犬厘己阑 困秦 atype阑 滴菌促.
var
   i : Integer;
begin
   Result := false;

   // 惑铰公傍俊辑 刚历 茫绰促...
   for i := 0 to HAVERISEMAGICSIZE - 1 do begin
      if HaveRiseMagicArr [i].rname [0] = 0 then continue;

      if HaveRiseMagicArr [i].rMagicType = aMagicType then begin
         case aMagicType of
            MAGICTYPE_PROTECTING : begin  // 老窜篮 protect率父... 
               FpCurProtectingMagic := @HaveRiseMagicArr [i];
               Result := true;
               exit;
            end;
         end;
      end;
   end;
   // 扯牢第柳促
   for i := 10 to 20 - 1 do begin
      if DefaultMagic [i].rname [0] = 0 then continue;

      if DefaultMagic [i].rMagicType = aMagicType then begin
         case aMagicType of
            MAGICTYPE_PROTECTING : begin
               FpCurProtectingMagic := @DefaultMagic [i];
               Result := true;
               exit;
            end;
         end;
      end;
   end;
   // 老馆公傍俊辑 茫绰促.
   for i := 0 to HAVEMAGICSIZE - 1 do begin
      if HaveMagicArr [i].rname [0] = 0 then continue;

      if HaveMagicArr [i].rMagicType = aMagicType then begin
         case aMagicType of
            MAGICTYPE_PROTECTING : begin  // 老窜篮 protect率父... 
               FpCurProtectingMagic := @HaveMagicArr [i];
               Result := true;
               exit;
            end;
         end;
      end;
   end;
   // 公疙第柳促
   for i := 0 to 10 - 1 do begin
      if DefaultMagic [i].rname [0] = 0 then continue;

      if DefaultMagic [i].rMagicType = aMagicType then begin
         case aMagicType of
            MAGICTYPE_PROTECTING : begin
               FpCurProtectingMagic := @DefaultMagic [i];
               Result := true;
               exit;
            end;
         end;
      end;
   end;
end;

procedure THaveMagicClass.AddAttributeRelationBestMagic;
begin
   if pCurProtectingMagic = nil then exit;
   if pCurAttackMagic = nil then exit;
   if pCurProtectingMagic^.rMagicClass <> MAGICCLASS_BESTMAGIC then exit;
   if pCurAttackMagic^.rMagicClass <> MAGICCLASS_BESTMAGIC then exit;

   if Strpas (@pCurAttackMagic^.rRelationProtect) = StrPas (@pCurProtectingMagic^.rName) then begin
      case pCurAttackMagic^.rKind of
         MAGIC_KIND_SAPA1 : begin           // 荤颇 (趋玫付傍)
            HaveMagicLifeData.AttackSpeed := HaveMagicLifeData.AttackSpeed - 4;      // 加档 4眠啊
         end;
         MAGIC_KIND_SAPA2 : begin           // 荤颇 (老岿脚傍)
            HaveMagicLifeData.avoid := HaveMagicLifeData.avoid + 10;                 // 雀乔 10眠啊
         end;
         MAGIC_KIND_JUNGPA1 : begin         // 沥颇 (磊窍脚傍)
            HaveMagicLifeData.avoid := HaveMagicLifeData.avoid + 10;                 // 雀乔 10眠啊
         end;
         MAGIC_KIND_JUNGPA2 : begin         // 沥颇 (合疙脚傍)
            HaveMagicLifeData.Accuracy := HaveMagicLifeData.Accuracy + 8;            // 沥犬 8眠啊
         end;
      end;
   end else if StrPas (@pCurAttackMagic^.rSameSection) = StrPas (@pCurProtectingMagic^.rName) then begin
   // 酒公加己 绝促.
   end else begin
      case pCurAttackMagic^.rKind of
         MAGIC_KIND_SAPA1 : begin           // 荤颇 (趋玫付傍)
            HaveMagicLifeData.AttackSpeed := HaveMagicLifeData.AttackSpeed + 4;      // 加档 4皑家
         end;
         MAGIC_KIND_SAPA2 : begin           // 荤颇 (老岿脚傍)
            HaveMagicLifeData.avoid := HaveMagicLifeData.avoid - 10;                 // 雀乔 10皑家
         end;
         MAGIC_KIND_JUNGPA1 : begin         // 沥颇 (磊窍脚傍)
            HaveMagicLifeData.avoid := HaveMagicLifeData.avoid - 10;                 // 雀乔 10皑家
         end;
         MAGIC_KIND_JUNGPA2 : begin         // 沥颇 (合疙脚傍)
            HaveMagicLifeData.Accuracy := HaveMagicLifeData.Accuracy - 8;            // 沥犬 8皑家
         end;
      end;
   end;


   {
   case pCurProtectingMagic^.rcSkillLevel of
      5000..5999 : begin
         if Strpas (@pCurAttackMagic^.rRelationProtect) = StrPas (@pCurProtectingMagic^.rName) then begin
            case pCurAttackMagic^.rGrade of
               0 : begin   // 1鞭
                  HaveMagicLifeData.damageBody := HaveMagicLifeData.damageBody * 10 div 100
               end;
               1 : begin   // 2鞭
                  HaveMagicLifeData.damageBody := (HaveMagicLifeData.damageBody * 10 div 100) * 120 div 100
               end;
               2 : begin   // 3鞭
                  HaveMagicLifeData.damageBody := (HaveMagicLifeData.damageBody * 10 div 100) * 150 div 100
               end;
            end;
         end else if StrPas (@pCurAttackMagic^.rSameSection) = StrPas (@pCurProtectingMagic^.rName) then begin
         end else begin
            case pCurAttackMagic^.rGrade of
               0 : begin   // 1鞭
                  HaveMagicLifeData.damageBody := -(HaveMagicLifeData.damageBody * 10 div 100)   
               end;
               1 : begin   // 2鞭
                  HaveMagicLifeData.damageBody := -((HaveMagicLifeData.damageBody * 10 div 100) * 120 div 100)
               end;
               2 : begin   // 3鞭
                  HaveMagicLifeData.damageBody := -((HaveMagicLifeData.damageBody * 10 div 100) * 150 div 100)
               end;
            end;
         end;
      end;
      6000..6999 : begin
         if Strpas (@pCurAttackMagic^.rRelationProtect) = StrPas (@pCurProtectingMagic^.rName) then begin
            case pCurAttackMagic^.rGrade of
               0 : begin   // 1鞭
                  HaveMagicLifeData.damageBody := HaveMagicLifeData.damageBody * 20 div 100
               end;
               1 : begin   // 2鞭
                  HaveMagicLifeData.damageBody := (HaveMagicLifeData.damageBody * 20 div 100) * 120 div 100
               end;
               2 : begin   // 3鞭
                  HaveMagicLifeData.damageBody := (HaveMagicLifeData.damageBody * 20 div 100) * 150 div 100
               end;
            end;
         end else if StrPas (@pCurAttackMagic^.rSameSection) = StrPas (@pCurProtectingMagic^.rName) then begin
         end else begin
            case pCurAttackMagic^.rGrade of
               0 : begin   // 1鞭
                  HaveMagicLifeData.damageBody := -(HaveMagicLifeData.damageBody * 20 div 100)
               end;
               1 : begin   // 2鞭
                  HaveMagicLifeData.damageBody := -((HaveMagicLifeData.damageBody * 20 div 100) * 120 div 100)
               end;
               2 : begin   // 3鞭
                  HaveMagicLifeData.damageBody := -((HaveMagicLifeData.damageBody * 20 div 100) * 150 div 100)
               end;
            end;
         end;
      end;
      7000..7999 : begin
         if Strpas (@pCurAttackMagic^.rRelationProtect) = StrPas (@pCurProtectingMagic^.rName) then begin
            case pCurAttackMagic^.rGrade of
               0 : begin   // 1鞭
                  HaveMagicLifeData.damageBody := HaveMagicLifeData.damageBody * 30 div 100
               end;
               1 : begin   // 2鞭
                  HaveMagicLifeData.damageBody := (HaveMagicLifeData.damageBody * 30 div 100) * 120 div 100
               end;
               2 : begin   // 3鞭
                  HaveMagicLifeData.damageBody := (HaveMagicLifeData.damageBody * 30 div 100) * 150 div 100
               end;
            end;
         end else if StrPas (@pCurAttackMagic^.rSameSection) = StrPas (@pCurProtectingMagic^.rName) then begin
         end else begin
            case pCurAttackMagic^.rGrade of
               0 : begin   // 1鞭
                  HaveMagicLifeData.damageBody := -(HaveMagicLifeData.damageBody * 30 div 100)
               end;
               1 : begin   // 2鞭
                  HaveMagicLifeData.damageBody := -((HaveMagicLifeData.damageBody * 30 div 100) * 120 div 100)
               end;
               2 : begin   // 3鞭
                  HaveMagicLifeData.damageBody := -((HaveMagicLifeData.damageBody * 30 div 100) * 150 div 100)
               end;
            end;
         end;
      end;
      8000..8999 : begin
         if Strpas (@pCurAttackMagic^.rRelationProtect) = StrPas (@pCurProtectingMagic^.rName) then begin
            case pCurAttackMagic^.rGrade of
               0 : begin   // 1鞭
                  HaveMagicLifeData.damageBody := HaveMagicLifeData.damageBody * 40 div 100
               end;
               1 : begin   // 2鞭
                  HaveMagicLifeData.damageBody := (HaveMagicLifeData.damageBody * 40 div 100) * 120 div 100
               end;
               2 : begin   // 3鞭
                  HaveMagicLifeData.damageBody := (HaveMagicLifeData.damageBody * 40 div 100) * 150 div 100
               end;
            end;
         end else if StrPas (@pCurAttackMagic^.rSameSection) = StrPas (@pCurProtectingMagic^.rName) then begin
         end else begin
            case pCurAttackMagic^.rGrade of
               0 : begin   // 1鞭
                  HaveMagicLifeData.damageBody := -(HaveMagicLifeData.damageBody * 40 div 100)
               end;
               1 : begin   // 2鞭
                  HaveMagicLifeData.damageBody := -((HaveMagicLifeData.damageBody * 40 div 100) * 120 div 100)
               end;
               2 : begin   // 3鞭
                  HaveMagicLifeData.damageBody := -((HaveMagicLifeData.damageBody * 40 div 100) * 150 div 100)
               end;
            end;
         end;
      end;
      9000..9998 : begin
         if Strpas (@pCurAttackMagic^.rRelationProtect) = StrPas (@pCurProtectingMagic^.rName) then begin
            case pCurAttackMagic^.rGrade of
               0 : begin   // 1鞭
                  HaveMagicLifeData.damageBody := HaveMagicLifeData.damageBody * 50 div 100
               end;
               1 : begin   // 2鞭
                  HaveMagicLifeData.damageBody := (HaveMagicLifeData.damageBody * 50 div 100) * 120 div 100
               end;
               2 : begin   // 3鞭
                  HaveMagicLifeData.damageBody := (HaveMagicLifeData.damageBody * 50 div 100) * 150 div 100
               end;
            end;
         end else if StrPas (@pCurAttackMagic^.rSameSection) = StrPas (@pCurProtectingMagic^.rName) then begin
         end else begin
            case pCurAttackMagic^.rGrade of
               0 : begin   // 1鞭
                  HaveMagicLifeData.damageBody := -(HaveMagicLifeData.damageBody * 50 div 100)
               end;
               1 : begin   // 2鞭
                  HaveMagicLifeData.damageBody := -((HaveMagicLifeData.damageBody * 50 div 100) * 120 div 100)
               end;
               2 : begin   // 3鞭
                  HaveMagicLifeData.damageBody := -((HaveMagicLifeData.damageBody * 50 div 100) * 150 div 100)
               end;
            end;
         end;
      end;
      9999 : begin
         if Strpas (@pCurAttackMagic^.rRelationProtect) = StrPas (@pCurProtectingMagic^.rName) then begin
            case pCurAttackMagic^.rGrade of
               0 : begin   // 1鞭
                  HaveMagicLifeData.damageBody := HaveMagicLifeData.damageBody * 100 div 100
               end;
               1 : begin   // 2鞭
                  HaveMagicLifeData.damageBody := (HaveMagicLifeData.damageBody * 100 div 100) * 120 div 100
               end;
               2 : begin   // 3鞭
                  HaveMagicLifeData.damageBody := (HaveMagicLifeData.damageBody * 100 div 100) * 150 div 100
               end;
            end;
         end else if StrPas (@pCurAttackMagic^.rSameSection) = StrPas (@pCurProtectingMagic^.rName) then begin
         end else begin
            case pCurAttackMagic^.rGrade of
               0 : begin   // 1鞭
                  HaveMagicLifeData.damageBody := -(HaveMagicLifeData.damageBody * 100 div 100)
               end;
               1 : begin   // 2鞭
                  HaveMagicLifeData.damageBody := -((HaveMagicLifeData.damageBody * 100 div 100) * 120 div 100)
               end;
               2 : begin   // 3鞭
                  HaveMagicLifeData.damageBody := -((HaveMagicLifeData.damageBody * 100 div 100) * 150 div 100)
               end;
            end;
         end;
      end;
   end;
   }
end;

function THaveMagicClass.Update (CurTick : integer): integer;
var
   oldslevel, nCount, nTotal : integer;
   closeflag : Boolean;
begin
   Result := 0;

   if FBasicObject.BasicData.Feature.rfeaturestate <> wfs_die then RegenerateShield (CurTick);
   
   if FpCurAttackMagic <> nil then begin
      if CurTick > FpCurAttackMagic.rMagicProcessTick + 500 then begin
         FpCurAttackMagic.rMagicProcessTick := CurTick;
         Dec5SecAttrib (FpCurAttackMagic);
         if not boKeepingMagic (FpCurAttackMagic) then begin Result := RET_CLOSE_ATTACK; exit; end;
      end;
   end;

   if FpCurRunningMagic <> nil then begin
     if CurTick > FpCurRunningMagic.rMagicProcessTick + 500 then begin
        FpCurRunningMagic.rMagicProcessTick := CurTick;
        Dec5SecAttrib (FpCurRunningMagic);
        if not boKeepingMagic (FpCurRunningMagic) then begin Result := RET_CLOSE_RUNNING; exit; end;
     end;
   end;

   if FpCurProtectingMagic <> nil then begin
      if CurTick > FpCurProtectingMagic.rMagicProcessTick + 500 then begin
         FpCurProtectingMagic.rMagicProcessTick := CurTick;
         Dec5SecAttrib (FpCurProtectingMagic);

         if FpCurProtectingMagic^.rMagicClass = MAGICCLASS_BESTMAGIC then begin
            if not boKeepingMagic (FpCurProtectingMagic) then begin Result := RET_CLOSE_PROTECTING; exit; end;
            if not boKeepingBestMagic (FpCurProtectingMagic) then begin Result := RET_CLOSE_BESTPROTECT; exit; end;
         end else begin
            if not boKeepingMagic (FpCurProtectingMagic) then begin Result := RET_CLOSE_PROTECTING; exit; end;
         end;
      end;
   end;

   if FpCurBreathngMagic <> nil then begin
      if CurTick > FpCurBreathngMagic.rMagicProcessTick + 500 then begin
         case FpCurBreathngMagic.rcSkillLevel of
            0..4999: ReQuestPlaySoundNumber := FpCurBreathngMagic.rSoundEvent.rWavNumber;
            5000..8999: ReQuestPlaySoundNumber := FpCurBreathngMagic.rSoundEvent.rWavNumber+2;
            else begin
               ReQuestPlaySoundNumber := FpCurBreathngMagic.rSoundEvent.rWavNumber+4;
            end;
         end;

         //2002-11-06
         if ( FpCurBreathngMagic^.rcSkillLevel >= 8501 ) and
            ( FpCurBreathngMagic^.rcSkillLevel <= 9999 )then begin
            if FpCurBreathngMagic^.rSEffectNumber <> 0 then begin
               TUserObject (FBasicObject).ShowEffect2 ( FpCurBreathngMagic^.rSEffectNumber + 1, lek_follow, 0);
            end;
         end;
         
         if not FAttribClass.boMan then ReQuestPlaySoundNumber := ReQuestPlaySoundNumber +1;

         FpCurBreathngMagic.rMagicProcessTick := CurTick;

//         Dec5SecAttrib (FpCurBreathngMagic);
         if not boKeepingMagic (FpCurBreathngMagic) then begin Result := RET_CLOSE_BREATHNG; exit; end;

         closeflag := TRUE;

         if (FpCurBreathngMagic^.rEventDecDamageHead < 0) and (FAttribClass.CurHeadLife < FAttribClass.HeadLife) then closeflag := FALSE;
         if (FpCurBreathngMagic^.rEventDecDamageArm < 0) and (FAttribClass.CurArmLife < FAttribClass.ArmLife) then closeflag := FALSE;
         if (FpCurBreathngMagic^.rEventDecDamageLeg < 0) and (FAttribClass.CurLegLife < FAttribClass.LegLife) then closeflag := FALSE;

         if (FpCurBreathngMagic^.rEventDecInPower < 0) and (FAttribClass.CurInPower < FAttribClass.InPower) then closeflag := FALSE;
         if (FpCurBreathngMagic^.rEventDecOutPower < 0) and (FAttribClass.CurOutPower < FAttribClass.OutPower) then closeflag := FALSE;
         if (FpCurBreathngMagic^.rEventDecMagic < 0) and (FAttribClass.CurMagic < FAttribClass.Magic) then closeflag := FALSE;
         if (FpCurBreathngMagic^.rEventDecLife < 0) and (FAttribClass.CurLife < FAttribClass.Life) then closeflag := FALSE;
         if closeflag then begin Result := RET_CLOSE_BREATHNG; exit; end;

         nCount := 0; nTotal := 0;
         if FpCurBreathngMagic^.rEventDecDamageHead < 0 then Inc (nTotal);
         if FpCurBreathngMagic^.rEventDecDamageArm < 0 then Inc (nTotal);
         if FpCurBreathngMagic^.rEventDecDamageLeg < 0 then Inc (nTotal);
         // if FpCurBreathngMagic^.rEventDecEnergy < 0 then Inc (nTotal);
         if FpCurBreathngMagic^.rEventDecInPower < 0 then Inc (nTotal);
         if FpCurBreathngMagic^.rEventDecOutPower < 0 then Inc (nTotal);
         if FpCurBreathngMagic^.rEventDecMagic < 0 then Inc (nTotal);
         if FpCurBreathngMagic^.rEventDecLife < 0 then Inc (nTotal);

         if (FpCurBreathngMagic^.rEventDecDamageHead < 0) and (FAttribClass.CurHeadLife < FAttribClass.HeadLife) then inc (nCount);
         if (FpCurBreathngMagic^.rEventDecDamageArm < 0) and (FAttribClass.CurArmLife < FAttribClass.ArmLife) then inc (nCount);
         if (FpCurBreathngMagic^.rEventDecDamageLeg < 0) and (FAttribClass.CurLegLife < FAttribClass.LegLife) then inc (nCount);
         // if (FpCurBreathngMagic^.rEventDecEnergy < 0) and (FAttribClass.CurAttribData.CurEnergy < FAttribClass.AttribData.cEnergy) then inc (nCount);
         if (FpCurBreathngMagic^.rEventDecInPower < 0) and (FAttribClass.CurInPower < FAttribClass.InPower) then inc (nCount);
         if (FpCurBreathngMagic^.rEventDecOutPower < 0) and (FAttribClass.CurOutPower < FAttribClass.OutPower) then inc (nCount);
         if (FpCurBreathngMagic^.rEventDecMagic < 0) and (FAttribClass.CurMagic < FAttribClass.Magic) then inc (nCount);
         if (FpCurBreathngMagic^.rEventDecLife < 0) and (FAttribClass.CurLife < FAttribClass.Life) then inc (nCount);

         DecBreathngAttrib (FpCurBreathngMagic);
//         DecEventAttrib (FpCurBreathngMagic);
         FSendClass.SendAttribBase (FAttribClass);

         if (nCount > 0) and (nTotal > 0) and (boAddExp = true) then begin
            oldslevel := FpCurBreathngMagic.rcSkillLevel;
            AddPermitExpbyRate (FpCurBreathngMagic^.rcSkillLevel, FpCurBreathngMagic^.rSkillExp, DEFAULTEXP, 100 * nCount div nTotal);
            if oldslevel <> FpCurBreathngMagic^.rcSkillLevel then begin
               FindAndSendMagic (FpCurBreathngMagic);
               FSendClass.SendEventString (StrPas (@FpCurBreathngMagic^.rName));
            end;
         end;

         if (nCount = nTotal) and (boAddExp = true) then begin
            oldslevel := FAttribClass.AttribData.cGoodChar;
            AddPermitExp (FAttribClass.AttribData.cGoodChar, FAttribClass.AttribData.GoodChar, FpCurBreathngMagic^.rGoodChar, false);
            if oldslevel <> FAttribClass.AttribData.cGoodChar then begin
               FSendClass.SendAttribValues (FAttribClass);

            end;
            oldslevel := FAttribClass.AttribData.cBadChar;
            AddPermitExp (FAttribClass.AttribData.cBadChar, FAttribClass.AttribData.BadChar, FpCurBreathngMagic^.rBadChar, false);
            if oldslevel <> FAttribClass.AttribData.cBadChar then begin
               FSendClass.SendAttribValues (FAttribClass);
            end;
         end;
      end;
   end;
   //2003-10
   if FpCurEctMagic <> nil then begin
      if CurTick > FpCurEctMagic.rMagicProcessTick + 100 then begin
         FpCurEctMagic.rMagicProcessTick := CurTick;
         if FpCurEctMagic^.rMagicClass = MAGICCLASS_BESTMAGIC then begin
            Dec1SecAttribForBestSpecial(FpCurEctMagic);
            if not boKeepingBestMagic (FpCurEctMagic) then begin Result := RET_CLOSE_BESTSPECIAL; exit; end;
         end else begin
            Dec5SecAttrib (FpCurEctMagic);
            if not boKeepingMagic (FpCurEctMagic) then begin Result := RET_CLOSE_ECTMAGIC; exit; end;
         end;
      end;
   end;
end;
// add by Orber at 2004-09-29 at 14:22
procedure THaveMagicClass.DblClickItemMagic(pcClick : PTCClick; aWearItemClass : TWearItemClass; aHaveItemClass : THaveItemClass);

begin
    if aHaveItemClass.HaveItemArr[pcClick^.rKey].rName[0] = 0 then exit;
    if StrPas(@aHaveItemClass.HaveItemArr[pcClick^.rKey].rName) = Conv('疾速靴') then begin
    if TUser(FBasicObject).State <> wfs_running then begin
        if aWearItemClass.GetWearItemName(ARR_SHOES) = '' then begin
            TUser(FBasicObject).CommandChangeCharState (wfs_running);
        end;
        {FpCurRunningMagic := @DefaultMagic[7];
        pCurRunningMagic^.rcSkillLevel := 100;}
        //FSendClass.SendChatMessage ('疾速靴开始使用', SAY_COLOR_SYSTEM);
    end else begin
        if aWearItemClass.GetWearItemName(ARR_SHOES) = Conv('疾速靴') then begin
            TUser(FBasicObject).CommandChangeCharState (wfs_normal);
        end;
        //FpCurRunningMagic := nil;
        //FSendClass.SendChatMessage ('疾速靴停止使用', SAY_COLOR_SYSTEM);
    end;
    end;
end;

procedure THaveMagicClass.AddItemMagic(aWearItemClass : TWearItemClass);
begin
    if aWearItemClass.WearItemArr[ARR_SHOES].rName[0] = 0 then exit;
    if StrPas(@aWearItemClass.WearItemArr[ARR_SHOES].rName) = Conv('疾速靴') then begin
    if TUser(FBasicObject).State <> wfs_running then begin
        TUser(FBasicObject).CommandChangeCharState (wfs_running);
{        FpCurRunningMagic := @DefaultMagic[7];
        pCurRunningMagic^.rcSkillLevel := 100;}
        //FSendClass.SendChatMessage ('疾速靴开始使用', SAY_COLOR_SYSTEM);
    end;
    end;
end;

procedure THaveMagicClass.DelItemMagic(ItemData :TItemData);
begin
    if ItemData.rName[0] = 0 then exit;
    if (StrPas(@ItemData.rName) = Conv('疾速靴')) and
    (TUser(FBasicObject).State = wfs_running) then begin
        TUser(FBasicObject).CommandChangeCharState (wfs_normal);
        //FpCurRunningMagic := nil;
        //FSendClass.SendChatMessage ('疾速靴停止使用', SAY_COLOR_SYSTEM);
    end;
end;


procedure THaveMagicClass.DblClickBasicMagicProcess (pcClick : PTCClick; aShowWindowClass : TShowWindowClass; aWearItemClass : TWearItemClass; aHaveItemClass : THaveItemClass);
var
   MagicData : TMagicData;
   WeaponKey, ret : Integer;
   boFlag : Boolean;
   ItemData, tmpItemData : TItemData;
   SubData : TSubData;
begin
   ViewBasicMagic (pcclick^.rkey, @MagicData);
   if MagicData.rName[0] = 0 then exit;

   if TUser (FBasicObject).Manager.boUseBowMagic = false then begin
      if (MagicData.rMagicType = MAGICTYPE_BOWING) or (MagicData.rMagicType = MAGICTYPE_THROWING) then begin
         FSendClass.SendChatMessage (Conv('无法使用的地带'), SAY_COLOR_SYSTEM);
         exit;
      end;
   end;

   if TUser (FBasicObject).Manager.boUseRiseMagic = false then begin
      if MagicData.rMagicClass = MAGICCLASS_RISEMAGIC then begin
         FSendClass.SendChatMessage (Conv('禁止使用二级武功的地带'), SAY_COLOR_SYSTEM);
         exit;
      end;
   end;

   boFlag := false;
   WeaponKey := -1;
   Case MagicData.rMagicType of
      MAGICTYPE_WRESTLING, MAGICTYPE_FENCING, MAGICTYPE_SWORDSHIP, MAGICTYPE_HAMMERING,
      MAGICTYPE_SPEARING, MAGICTYPE_BOWING, MAGICTYPE_THROWING : begin
         if aWearItemClass.GetWeaponType <> MagicData.rMagicType then begin
            boFlag := true;
            if FBasicObject.Manager.boCanChangeMagic = false then begin
               TUser (FBasicObject).SendClass.SendChatMessage (Conv ('在此地区无法切换武功'), SAY_COLOR_SYSTEM);
               exit;
            end;
            if TUser (FBasicObject).Manager.boUsePowerItem = false then begin
               WeaponKey := aHaveItemClass.FindNoPowerItemByMagicKind (MagicData.rMagicType);
               if (WeaponKey < 0) and (MagicData.rMagicType <> MAGICTYPE_WRESTLING) then begin
                  TUser (FBasicObject).SendClass.SendChatMessage (Conv('没有相应武功对应的武器'), SAY_COLOR_SYSTEM);
                  exit;
               end;
            end else begin
               WeaponKey := aHaveItemClass.FindItemByMagicKind (MagicData.rMagicType);
               if (WeaponKey < 0) and (MagicData.rMagicType <> MAGICTYPE_WRESTLING) then begin
                  TUser (FBasicObject).SendClass.SendChatMessage (Conv('没有相应武功对应的武器'), SAY_COLOR_SYSTEM);
                  exit;
               end;
            end;
            
            aWearItemClass.ViewItem (ARR_WEAPON, @tmpItemData);
            if tmpItemData.rName [0] <> 0 then begin
               if aHaveItemClass.CheckBlankAfterDelete (WeaponKey, 1) = false then begin
                  if aHaveItemClass.CheckAddable (tmpItemData) < 0 then begin
                     exit;
                  end;
               end;
            end;
         end;
      end;
   end;

   ret := SelectBasicMagic (pcClick^.rKey, false);
   if ret = SELECTMAGIC_RESULT_FALSE then exit;
   case ret of
      SELECTMAGIC_RESULT_NONE:;
      SELECTMAGIC_RESULT_NORMAL: TUser (FBasicObject).CommandChangeCharState (wfs_normal);
      SELECTMAGIC_RESULT_SITDOWN: TUser (FBasicObject).CommandChangeCharState (wfs_sitdown);
      SELECTMAGIC_RESULT_RUNNING: TUser (FBasicObject).CommandChangeCharState (wfs_running);
   end;

   SetWordString (SubData.SayString, StrPas (@MagicData.rName));
   FBasicObject.SendLocalMessage (NOTARGETPHONE, FM_SAYUSEMAGIC, FBasicObject.BasicData, SubData);
   //if MagicData.rSEffectNumber <> 0 then begin
   //   TUserObject (FBasicObject).ShowEffect( MagicData.rSEffectNumber, lek_follow);
   //end;

   if boFlag = false then exit;
   
   if WeaponKey >= 0 then begin
      aHaveItemClass.ViewItem (WeaponKey, @ItemData);
      if ItemData.rName [0] = 0 then begin
         aWearItemClass.ViewItem (ARR_WEAPON, @tmpItemData);
         aWearItemClass.DeleteKeyItem (ARR_WEAPON, false);
      end else begin
         if TUser (FBasicObject).Manager.boUsePowerItem = false then begin
            if ItemData.rboPower = true then begin
               FSendClass.SendChatMessage (Conv('不能使用技能物品'), SAY_COLOR_SYSTEM);
               exit;
            end;
         end;
         
         aWearItemClass.ChangeItem (ItemData, tmpItemData, false);
         ItemData.rOwnerName [0] := 0;
         aHaveItemClass.DeleteKeyItem (WeaponKey, 1, @ItemData);
      end;
      if tmpItemData.rName [0] <> 0 then begin
         tmpItemData.rCount := 1;
         aHaveItemClass.ViewItem (WeaponKey, @ItemData);
         if ItemData.rName [0] = 0 then begin
            aHaveItemClass.AddKeyItem (WeaponKey, tmpItemData);
         end else begin
            aHaveItemClass.AddItem (tmpItemData);
         end;
      end;
   end else begin
      aWearItemClass.ViewItem (ARR_WEAPON, @tmpItemData);
      aWearItemClass.DeleteKeyItem (ARR_WEAPON, false);
      if tmpItemData.rName [0] <> 0 then begin
         tmpItemData.rCount := 1;
         aHaveItemClass.AddItem (tmpItemData);
      end;
   end;
end;

procedure THaveMagicClass.DblClickMagicProcess (pcClick : PTCClick; aShowWindowClass : TShowWindowClass; aWearItemClass : TWearItemClass; aHaveItemClass : THaveItemClass);
var
   MagicData : TMagicData;
   WeaponKey, ret : Integer;
   boFlag : Boolean;
   ItemData, tmpItemData : TItemData;
   SubData : TSubData;
begin
   ViewMagic (pcclick^.rkey, @MagicData);
   if MagicData.rName[0] = 0 then exit;

   if TUser (FBasicObject).Manager.boUseMagic = false then begin
      if MagicData.rMagicClass = MAGICCLASS_MAGIC then begin
         FSendClass.SendChatMessage (Conv ('在此地区无法使用一级武功'), SAY_COLOR_SYSTEM);
         exit;
      end;
   end;
   
   if TUser (FBasicObject).Manager.boUseBowMagic = false then begin
      if (MagicData.rMagicType = MAGICTYPE_BOWING) or (MagicData.rMagicType = MAGICTYPE_THROWING) then begin
         FSendClass.SendChatMessage (Conv('无法使用的地带'), SAY_COLOR_SYSTEM);
         exit;
      end;
   end;

   if TUser (FBasicObject).Manager.boUseGuildMagic = false then begin
      if MagicData.rGuildMagictype = 1 then begin
         FSendClass.SendChatMessage (Conv('禁止使用门派武功地带'), SAY_COLOR_SYSTEM);
         exit;
      end;
   end;

   if TUser (FBasicObject).Manager.boUseEtcMagic = false then begin
      if MagicData.rMagicType = MAGICTYPE_ECT then begin
         FSendClass.SendChatMessage (Conv('开辅助武功无法进入'), SAY_COLOR_SYSTEM);
         exit;
      end;
   end;

   boFlag := false;
   WeaponKey := -1;
   Case MagicData.rMagicType of
      MAGICTYPE_WRESTLING, MAGICTYPE_FENCING, MAGICTYPE_SWORDSHIP, MAGICTYPE_HAMMERING,
      MAGICTYPE_SPEARING, MAGICTYPE_BOWING, MAGICTYPE_THROWING : begin
         if aWearItemClass.GetWeaponType <> MagicData.rMagicType then begin
            boFlag := true;

            if FBasicObject.Manager.boCanChangeMagic = false then begin
               TUser (FBasicObject).SendClass.SendChatMessage (Conv ('在此地区无法切换武功'), SAY_COLOR_SYSTEM);
               exit;
            end;
            
            if TUser (FBasicObject).Manager.boUsePowerItem = false then begin
               WeaponKey := aHaveItemClass.FindNoPowerItemByMagicKind (MagicData.rMagicType);
               if (WeaponKey < 0) and (MagicData.rMagicType <> MAGICTYPE_WRESTLING) then begin
                  TUser (FBasicObject).SendClass.SendChatMessage (Conv('没有相应武功对应的武器'), SAY_COLOR_SYSTEM);
                  exit;
               end;
            end else begin
               WeaponKey := aHaveItemClass.FindItemByMagicKind (MagicData.rMagicType);
               if (WeaponKey < 0) and (MagicData.rMagicType <> MAGICTYPE_WRESTLING) then begin
                  TUser (FBasicObject).SendClass.SendChatMessage (Conv('没有相应武功对应的武器'), SAY_COLOR_SYSTEM);
                  exit;
               end;
            end;
            
            aWearItemClass.ViewItem (ARR_WEAPON, @tmpItemData);
            if tmpItemData.rName [0] <> 0 then begin
               if aHaveItemClass.CheckBlankAfterDelete (WeaponKey, 1) = false then begin
                  if aHaveItemClass.CheckAddable (tmpItemData) < 0 then begin
                     exit;
                  end;
               end;
            end;
         end;
      end;
   end;

   ret := SelectHaveMagic (pcClick^.rKey, false);
   if ret = SELECTMAGIC_RESULT_FALSE then exit;
   case ret of
      SELECTMAGIC_RESULT_NONE:;
      SELECTMAGIC_RESULT_NORMAL: TUser (FBasicObject).CommandChangeCharState (wfs_normal);
      SELECTMAGIC_RESULT_SITDOWN: TUser (FBasicObject).CommandChangeCharState (wfs_sitdown);
      SELECTMAGIC_RESULT_RUNNING: TUser (FBasicObject).CommandChangeCharState (wfs_running);
   end;

   SetWordString (SubData.SayString, StrPas (@MagicData.rName));
   FBasicObject.SendLocalMessage (NOTARGETPHONE, FM_SAYUSEMAGIC, FBasicObject.BasicData, SubData);
   //if MagicData.rSEffectNumber <> 0 then begin
   //   TUserObject (FBasicObject).ShowEffect( MagicData.rSEffectNumber, lek_follow);
   //end;
   
   if boFlag = false then exit;
   
   if WeaponKey >= 0 then begin
      aHaveItemClass.ViewItem (WeaponKey, @ItemData);
      if ItemData.rName [0] = 0 then begin
         aWearItemClass.ViewItem (ARR_WEAPON, @tmpItemData);
         aWearItemClass.DeleteKeyItem (ARR_WEAPON, false);
      end else begin
         if TUser (FBasicObject).Manager.boUsePowerItem = false then begin
            if ItemData.rboPower = true then begin
               FSendClass.SendChatMessage (Conv('不能使用技能物品'), SAY_COLOR_SYSTEM);
               exit;
            end;
         end;
         
         aWearItemClass.ChangeItem (ItemData, tmpItemData, false);
         ItemData.rOwnerName [0] := 0;
         aHaveItemClass.DeleteKeyItem (WeaponKey, 1, @ItemData);
      end;
      if tmpItemData.rName [0] <> 0 then begin
         tmpItemData.rCount := 1;
         aHaveItemClass.ViewItem (WeaponKey, @ItemData);
         if ItemData.rName [0] = 0 then begin
            aHaveItemClass.AddKeyItem (WeaponKey, tmpItemData);
         end else begin
            aHaveItemClass.AddItem (tmpItemData);
         end;
      end;
   end else begin
      aWearItemClass.ViewItem (ARR_WEAPON, @tmpItemData);
      aWearItemClass.DeleteKeyItem (ARR_WEAPON, false);
      if tmpItemData.rName [0] <> 0 then begin
         tmpItemData.rCount := 1;
         aHaveItemClass.AddItem (tmpItemData);
      end;
   end;
end;

procedure THaveMagicClass.DblClickRiseMagicProcess (pcClick : PTCClick; aShowWindowClass : TShowWindowClass; aWearItemClass : TWearItemClass; aHaveItemClass : THaveItemClass);
var
   MagicData : TMagicData;
   WeaponKey, ret : Integer;
   boFlag : Boolean;
   ItemData, tmpItemData : TItemData;
   SubData : TSubData;
begin
   ViewRiseMagic (pcclick^.rkey, @MagicData);
   if MagicData.rName[0] = 0 then exit;

   if TUser (FBasicObject).Manager.boUseBowMagic = false then begin
      if (MagicData.rMagicType = MAGICTYPE_BOWING) or (MagicData.rMagicType = MAGICTYPE_THROWING) then begin
         FSendClass.SendChatMessage (Conv('无法使用的地带'), SAY_COLOR_SYSTEM);
         exit;
      end;
   end;

   if TUser (FBasicObject).Manager.boUseRiseMagic = false then begin
      if MagicData.rMagicClass = MAGICCLASS_RISEMAGIC then begin
         FSendClass.SendChatMessage (Conv('禁止使用二级武功的地带'), SAY_COLOR_SYSTEM);
         exit;
      end;
   end;

   boFlag := false;
   WeaponKey := -1;
   Case MagicData.rMagicType of
      MAGICTYPE_WRESTLING, MAGICTYPE_FENCING, MAGICTYPE_SWORDSHIP, MAGICTYPE_HAMMERING,
      MAGICTYPE_SPEARING, MAGICTYPE_BOWING, MAGICTYPE_THROWING : begin
         if aWearItemClass.GetWeaponType <> MagicData.rMagicType then begin
            boFlag := true;
            if FBasicObject.Manager.boCanChangeMagic = false then begin
               TUser (FBasicObject).SendClass.SendChatMessage (Conv ('在此地区无法切换武功'), SAY_COLOR_SYSTEM);
               exit;
            end;
            if TUser (FBasicObject).Manager.boUsePowerItem = false then begin
               WeaponKey := aHaveItemClass.FindNoPowerItemByMagicKind (MagicData.rMagicType);
               if (WeaponKey < 0) and (MagicData.rMagicType <> MAGICTYPE_WRESTLING) then begin
                  TUser (FBasicObject).SendClass.SendChatMessage (Conv('没有相应武功对应的武器'), SAY_COLOR_SYSTEM);
                  exit;
               end;
            end else begin
               WeaponKey := aHaveItemClass.FindItemByMagicKind (MagicData.rMagicType);
               if (WeaponKey < 0) and (MagicData.rMagicType <> MAGICTYPE_WRESTLING) then begin
                  TUser (FBasicObject).SendClass.SendChatMessage (Conv('没有相应武功对应的武器'), SAY_COLOR_SYSTEM);
                  exit;
               end;
            end;
            
            aWearItemClass.ViewItem (ARR_WEAPON, @tmpItemData);
            if tmpItemData.rName [0] <> 0 then begin
               if aHaveItemClass.CheckBlankAfterDelete (WeaponKey, 1) = false then begin
                  if aHaveItemClass.CheckAddable (tmpItemData) < 0 then begin
                     exit;
                  end;
               end;
            end;
         end;
      end;
   end;

   ret := SelectHaveRiseMagic (pcClick^.rKey, false);
   if ret = SELECTMAGIC_RESULT_FALSE then exit;
   case ret of
      SELECTMAGIC_RESULT_NONE:;
      SELECTMAGIC_RESULT_NORMAL: TUser (FBasicObject).CommandChangeCharState (wfs_normal);
      SELECTMAGIC_RESULT_SITDOWN: TUser (FBasicObject).CommandChangeCharState (wfs_sitdown);
      SELECTMAGIC_RESULT_RUNNING: TUser (FBasicObject).CommandChangeCharState (wfs_running);
   end;

   SetWordString (SubData.SayString, StrPas (@MagicData.rName));
   FBasicObject.SendLocalMessage (NOTARGETPHONE, FM_SAYUSEMAGIC, FBasicObject.BasicData, SubData);
   //if MagicData.rSEffectNumber <> 0 then begin
   //   TUserObject (FBasicObject).ShowEffect( MagicData.rSEffectNumber, lek_follow);
   //end;
   
   if boFlag = false then exit;
   
   if WeaponKey >= 0 then begin
      aHaveItemClass.ViewItem (WeaponKey, @ItemData);
      if ItemData.rName [0] = 0 then begin
         aWearItemClass.ViewItem (ARR_WEAPON, @tmpItemData);
         aWearItemClass.DeleteKeyItem (ARR_WEAPON, false);
      end else begin
         if TUser (FBasicObject).Manager.boUsePowerItem = false then begin
            if ItemData.rboPower = true then begin
               FSendClass.SendChatMessage (Conv('不能使用技能物品'), SAY_COLOR_SYSTEM);
               exit;
            end;
         end;
         
         aWearItemClass.ChangeItem (ItemData, tmpItemData, false);
         ItemData.rOwnerName [0] := 0;
         aHaveItemClass.DeleteKeyItem (WeaponKey, 1, @ItemData);
      end;
      if tmpItemData.rName [0] <> 0 then begin
         tmpItemData.rCount := 1;
         aHaveItemClass.ViewItem (WeaponKey, @ItemData);
         if ItemData.rName [0] = 0 then begin
            aHaveItemClass.AddKeyItem (WeaponKey, tmpItemData);
         end else begin
            aHaveItemClass.AddItem (tmpItemData);
         end;
      end;
   end else begin
      aWearItemClass.ViewItem (ARR_WEAPON, @tmpItemData);
      aWearItemClass.DeleteKeyItem (ARR_WEAPON, false);
      if tmpItemData.rName [0] <> 0 then begin
         tmpItemData.rCount := 1;
         aHaveItemClass.AddItem (tmpItemData);
      end;
   end;
end;

procedure THaveMagicClass.DblClickBestMagicProcess (pcClick : PTCClick; aShowWindowClass : TShowWindowClass; aWearItemClass : TWearItemClass; aHaveItemClass : THaveItemClass);
var
   MagicData : TMagicData;
   WeaponKey, ret : Integer;
   boFlag : Boolean;
   ItemData, tmpItemData : TItemData;
   SubData : TSubData;
begin
   ViewBestMagic (pcclick^.rkey, @MagicData);
   if MagicData.rName[0] = 0 then exit;

   if TUser (FBasicObject).Manager.boUseBestMagic = false then begin
      if MagicData.rMagicClass = MAGICCLASS_BESTMAGIC then begin
         FSendClass.SendChatMessage (Conv ('在此地区无法使用绝世武功'), SAY_COLOR_SYSTEM);
         exit;
      end;
   end;

   if TUser (FBasicObject).Manager.boUseBestSpecialMagic = false then begin
      if MagicData.rMagicType = MAGICTYPE_BESTSPECIAL then begin
         FSendClass.SendChatMessage (Conv ('在此地区无法使用招式武功'), SAY_COLOR_SYSTEM);
         exit;
      end;
   end;

   boFlag := false;
   WeaponKey := -1;
   Case MagicData.rMagicType of
      MAGICTYPE_WRESTLING, MAGICTYPE_FENCING, MAGICTYPE_SWORDSHIP, MAGICTYPE_HAMMERING,
      MAGICTYPE_SPEARING, MAGICTYPE_BOWING, MAGICTYPE_THROWING : begin
         if aWearItemClass.GetWeaponType <> MagicData.rMagicType then begin
            boFlag := true;
            if FBasicObject.Manager.boCanChangeMagic = false then begin
               TUser (FBasicObject).SendClass.SendChatMessage (Conv ('在此地区无法切换武功'), SAY_COLOR_SYSTEM);
               exit;
            end;
            
            if TUser (FBasicObject).Manager.boUsePowerItem = false then begin
               WeaponKey := aHaveItemClass.FindNoPowerItemByMagicKind (MagicData.rMagicType);
               if (WeaponKey < 0) and (MagicData.rMagicType <> MAGICTYPE_WRESTLING) then begin
                  TUser (FBasicObject).SendClass.SendChatMessage (Conv ('没有相应武功对应的武器'), SAY_COLOR_SYSTEM);
                  exit;
               end;
            end else begin
               WeaponKey := aHaveItemClass.FindItemByMagicKind (MagicData.rMagicType);
               if (WeaponKey < 0) and (MagicData.rMagicType <> MAGICTYPE_WRESTLING) then begin
                  TUser (FBasicObject).SendClass.SendChatMessage (Conv ('没有相应武功对应的武器'), SAY_COLOR_SYSTEM);
                  exit;
               end;
            end;
            
            aWearItemClass.ViewItem (ARR_WEAPON, @tmpItemData);
            if tmpItemData.rName [0] <> 0 then begin
               if aHaveItemClass.CheckBlankAfterDelete (WeaponKey, 1) = false then begin
                  if aHaveItemClass.CheckAddable (tmpItemData) < 0 then begin
                     exit;
                  end;
               end;
            end;
         end;
      end;
   end;

   ret := SelectHaveBestMagic (pcClick^.rKey, false);
   if ret = SELECTMAGIC_RESULT_FALSE then exit;
   case ret of
      SELECTMAGIC_RESULT_NONE:;
      SELECTMAGIC_RESULT_NORMAL: TUser (FBasicObject).CommandChangeCharState (wfs_normal);
      SELECTMAGIC_RESULT_SITDOWN: TUser (FBasicObject).CommandChangeCharState (wfs_sitdown);
      SELECTMAGIC_RESULT_RUNNING: TUser (FBasicObject).CommandChangeCharState (wfs_running);
   end;

   SetWordString (SubData.SayString, StrPas (@MagicData.rName));
   FBasicObject.SendLocalMessage (NOTARGETPHONE, FM_SAYUSEMAGIC, FBasicObject.BasicData, SubData);

   if boFlag = false then exit;
   
   if WeaponKey >= 0 then begin
      aHaveItemClass.ViewItem (WeaponKey, @ItemData);
      if ItemData.rName [0] = 0 then begin
         aWearItemClass.ViewItem (ARR_WEAPON, @tmpItemData);
         aWearItemClass.DeleteKeyItem (ARR_WEAPON, false);
      end else begin
         aWearItemClass.ChangeItem (ItemData, tmpItemData, false);
         ItemData.rOwnerName [0] := 0;
         aHaveItemClass.DeleteKeyItem (WeaponKey, 1, @ItemData);
      end;
      if tmpItemData.rName [0] <> 0 then begin
         tmpItemData.rCount := 1;
         aHaveItemClass.ViewItem (WeaponKey, @ItemData);
         if ItemData.rName [0] = 0 then begin
            aHaveItemClass.AddKeyItem (WeaponKey, tmpItemData);
         end else begin
            aHaveItemClass.AddItem (tmpItemData);
         end;
      end;
   end else begin
      aWearItemClass.ViewItem (ARR_WEAPON, @tmpItemData);
      aWearItemClass.DeleteKeyItem (ARR_WEAPON, false);
      if tmpItemData.rName [0] <> 0 then begin
         tmpItemData.rCount := 1;
         aHaveItemClass.AddItem (tmpItemData);
      end;
   end;
end;

procedure THaveMagicClass.DblClickMysteryMagicProcess (pcClick : PTCClick; aShowWindowClass : TShowWindowClass; aWearItemClass : TWearItemClass; aHaveItemClass : THaveItemClass);
var
   MagicData : TMagicData;
   WeaponKey, ret : Integer;
   boFlag : Boolean;
   ItemData, tmpItemData : TItemData;
   SubData : TSubData;
begin
   ViewMysteryMagic (pcclick^.rkey, @MagicData);
   if MagicData.rName[0] = 0 then exit;

   if TUser (FBasicObject).Manager.boUseWindMagic = false then begin
      if MagicData.rMagicClass = MAGICCLASS_MYSTERY then begin
         FSendClass.SendChatMessage (Conv('禁止使用掌法地带'), SAY_COLOR_SYSTEM);
         exit;
      end;
   end;

   boFlag := false;
   WeaponKey := -1;
   Case MagicData.rMagicType of
      MAGICTYPE_WINDOFHAND : begin
         if aWearItemClass.GetWeaponType <> MagicData.rMagicType then begin
            boFlag := true;
            if FBasicObject.Manager.boCanChangeMagic = false then begin
               TUser (FBasicObject).SendClass.SendChatMessage (Conv ('在此地区无法切换武功'), SAY_COLOR_SYSTEM);
               exit;
            end;
            
            WeaponKey := aHaveItemClass.FindItemByMagicKind (MagicData.rMagicType);
            if (WeaponKey < 0) and (MagicData.rMagicType <> MAGICTYPE_WRESTLING)
               and (MagicData.rMagicType <> MAGICTYPE_WINDOFHAND) then exit;
            aWearItemClass.ViewItem (ARR_WEAPON, @tmpItemData);
            if tmpItemData.rName [0] <> 0 then begin
               if aHaveItemClass.CheckBlankAfterDelete (WeaponKey, 1) = false then begin
                  if aHaveItemClass.CheckAddable (tmpItemData) < 0 then begin
                     exit;
                  end;
               end;
            end;
         end;
      end;
   end;

   ret := SelectHaveMysteryMagic (pcClick^.rKey, false);
   if ret = SELECTMAGIC_RESULT_FALSE then exit;
   case ret of
      SELECTMAGIC_RESULT_NONE:;
      SELECTMAGIC_RESULT_NORMAL: TUser (FBasicObject).CommandChangeCharState (wfs_normal);
      SELECTMAGIC_RESULT_SITDOWN: TUser (FBasicObject).CommandChangeCharState (wfs_sitdown);
      SELECTMAGIC_RESULT_RUNNING: TUser (FBasicObject).CommandChangeCharState (wfs_running);
   end;

   SetWordString (SubData.SayString, StrPas (@MagicData.rName));
   FBasicObject.SendLocalMessage (NOTARGETPHONE, FM_SAYUSEMAGIC, FBasicObject.BasicData, SubData);
   if boFlag = false then exit;
   
   if WeaponKey >= 0 then begin
      aHaveItemClass.ViewItem (WeaponKey, @ItemData);
      if ItemData.rName [0] = 0 then begin
         aWearItemClass.ViewItem (ARR_WEAPON, @tmpItemData);
         aWearItemClass.DeleteKeyItem (ARR_WEAPON, false);
      end else begin
         aWearItemClass.ChangeItem (ItemData, tmpItemData, false);
         ItemData.rOwnerName [0] := 0;
         aHaveItemClass.DeleteKeyItem (WeaponKey, 1, @ItemData);
      end;
      if tmpItemData.rName [0] <> 0 then begin
         tmpItemData.rCount := 1;
         aHaveItemClass.ViewItem (WeaponKey, @ItemData);
         if ItemData.rName [0] = 0 then begin
            aHaveItemClass.AddKeyItem (WeaponKey, tmpItemData);
         end else begin
            aHaveItemClass.AddItem (tmpItemData);
         end;
      end;
   end else begin
      aWearItemClass.ViewItem (ARR_WEAPON, @tmpItemData);
      aWearItemClass.DeleteKeyItem (ARR_WEAPON, false);
      if tmpItemData.rName [0] <> 0 then begin
         tmpItemData.rCount := 1;
         aHaveItemClass.AddItem (tmpItemData);
      end;
   end;
end;

/////////////////////////////////
// THaveJobClass
/////////////////////////////////
constructor THaveJobClass.Create (aBasicObject : TBasicObject; aSendClass : TSendClass; aAttribClass : TAttribClass; aHaveItemClass : THaveItemClass);
begin
   FBasicObject := aBasicObject;
   FSendClass := aSendClass;
   FAttribClass := aAttribClass;
   FHaveItemClass := aHaveItemClass;

   FJobKind := JOB_KIND_NONE;
   FJobGrade := JOB_GRADE_NONE;

   FMinePickAmount := 0;
   FMinePickObjectID := 0;
   
   FPickCount := 0;
   FWorkSound := 0;

   FToolConst := 5;

   FSmeltItem := '';
   FSmeltItem2 := '';   
end;

destructor THaveJobClass.Destroy;
begin
   inherited Destroy;
end;

function THaveJobClass.GetJobKindStr : String;
begin
   Result := '';
   Case FJobKind of
      JOB_KIND_NONE : Result := '';
      JOB_KIND_ALCHEMIST : Result := INI_DEF_ALCHEMIST;
      JOB_KIND_CHEMIST : Result := INI_DEF_CHEMIST;
      JOB_KIND_DESIGNER : Result := INI_DEF_DESIGNER;
      JOB_KIND_CRAFTSMAN : Result := INI_DEF_CRAFTSMAN;
   end;
end;

function THaveJobClass.GetJobGradeStr : String;
begin
   Result := '';
   Case FJobGrade of
      JOB_GRADE_NONE : Result := '';
      JOB_GRADE_NAMELESSWORKER : Result := INI_DEF_NAMELESSWORKER;
      JOB_GRADE_TECHNICIAN : Result := INI_DEF_TECHNICIAN;
      JOB_GRADE_SKILLEDWORKER : Result := INI_DEF_SKILLEDWORKER;
      JOB_GRADE_EXPERT : Result := INI_DEF_EXPERT;
      JOB_GRADE_MASTER : Result := INI_DEF_MASTER;
      JOB_GRADE_VIRTUEMAN : Result := INI_DEF_VIRTUEMAN;
   end;
end;

function THaveJobClass.GetJobToolStr : String;
begin
   Result := JobClass.GetJobTool (FJobKind, FJobGrade);
end;

function THaveJobClass.GetProductItem : TItemData;
begin
   Result := HaveMaterialArr [PRODUCT_KEY];
end;

function THaveJobClass.GetMaterialStr : String;
var
   i : Integer;
   Str : String;
begin
   Result := '';

   Str := '';
   for i := 0 to HAVEMATERIALITEMSIZE - 1 do begin
      if HaveMaterialArr [i].rName [0] <> 0 then begin
         if Str <> '' then Str := Str + ',';

         Str := Str + format ('%s:%d', [StrPas (@HaveMaterialArr [i].rName), HaveMaterialArr [i].rCount]);
      end;
   end;

   Result := Str;
end;

function THaveJobClass.GetJobImageShape : Byte;
begin
   Result := 0;
   if FJobKind = JOB_KIND_NONE then exit;
   
   Result := ((FJobKind - 1) * JOB_GRADE_MAX) + (FJobGrade - 1);
end;

procedure THaveJobClass.LoadFromSdb (aCharData : PTDBRecord);
var
   i : Integer;
   Str : String;
   ItemData : TItemData;
begin
   FillChar (HaveMaterialArr, SizeOf (HaveMaterialArr), 0);
   // FillChar (FJobTool, SizeOf (TItemData), 0);
   FJobKind := JOB_KIND_NONE;
   FJobGrade := JOB_GRADE_NONE;

   for i := 0 to HAVEMATERIALITEMSIZE - 1 do begin
      Str := StrPas (@aCharData^.HaveMaterialItemArr [i].Name) + ':' +
         IntToStr (aCharData^.HaveMaterialItemArr [i].Color) + ':' +
         IntToStr (aCharData^.HaveMaterialItemArr [i].Count) + ':' +
         IntToStr (aCharData^.HaveMaterialItemArr [i].Durability) + ':' +
         IntToStr (aCharData^.HaveMaterialItemArr [i].CurDurability) + ':' +
         IntToStr (aCharData^.HaveMaterialItemArr [i].UpGrade) + ':' +
         IntToStr (aCharData^.HaveMaterialItemArr [i].AddType)+ ':' +
         // add by Orber at 2004-09-27 10:08
         IntToStr (aCharData^.HaveMaterialItemArr [i].rLockState)+ ':' +
         IntToStr (aCharData^.HaveMaterialItemArr [i].runLockTime);

      ItemClass.GetWearItemData (Str, HaveMaterialArr [i]);
      JobClass.GetUpgradeItemLifeData (HaveMaterialArr [i]);
      ItemClass.GetAddItemAttribData (HaveMaterialArr[i]);
   end;

   FJobKind := aCharData^.JobKind;
   if FJobKind <> JOB_KIND_NONE then begin
      FJobGrade := JobClass.GetJobGrade (FAttribClass.Talent);
      for i := 0 to HAVEMATERIALITEMSIZE - 1 do begin
         FSendClass.SendMaterialItem (i, HaveMaterialArr [i]);
      end;
   end;

   Str := GetJobToolStr;
   if Str <> '' then begin
      ItemClass.GetItemData (Str, ItemData);
      if ItemData.rName [0] <> 0 then begin
         FWorkSound := ItemData.rSoundEvent.rWavNumber;
      end; 
   end; 
end;

procedure THaveJobClass.SaveToSdb (aCharData : PTDBRecord);
var
   i : Integer;
   Str, rdStr : String;
begin
   for i := 0 to HAVEMATERIALITEMSIZE - 1 do begin
      Str := ItemClass.GetWearItemString (HaveMaterialArr [i]);
      Str := GetValidStr3 (Str, rdStr, ':');
      StrPCopy (@aCharData^.HaveMaterialItemArr [i].Name, rdStr);
      str := GetValidStr3 (Str, rdStr, ':');
      aCharData^.HaveMaterialItemArr[i].Color := _StrToInt (rdStr);
      str := GetValidStr3 (Str, rdStr, ':');
      aCharData^.HaveMaterialItemArr[i].Count := _StrToInt (rdStr);
      str := GetValidStr3 (str, rdStr, ':');
      aCharData^.HaveMaterialItemArr[i].Durability := _StrToInt (rdStr);
      str := GetValidStr3 (str, rdStr, ':');
      aCharData^.HaveMaterialItemArr[i].CurDurability := _StrToInt (rdStr);
      str := GetValidStr3 (str, rdStr, ':');
      aCharData^.HaveMaterialItemArr[i].Upgrade := _StrToInt (rdStr);
      str := GetValidStr3 (str, rdStr, ':');
      aCharData^.HaveMaterialItemArr[i].AddType := _StrToInt (rdStr);
      str := GetValidStr3 (str, rdStr, ':');
      aCharData^.HaveMaterialItemArr[i].rLockState := _StrToInt (rdStr);
      str := GetValidStr3 (str, rdStr, ':');
      aCharData^.HaveMaterialItemArr[i].runLockTime := _StrToInt (rdStr);
   end;

   aCharData^.JobKind := FJobKind;
end;

procedure THaveJobClass.Update (CurTick : integer);
begin
end;

procedure THaveJobClass.PutOnAutoMaterialProcess (pcSetMaterial : PTCSetMaterial);
var
   i, Key, Count : Integer;
   Items : array [0..PRODUCT_KEY - 1] of TItemData;
   Requested : array [0..HAVEITEMSIZE - 1] of Integer;
begin
   if pcSetMaterial = nil then exit;
   if not TUser (FBasicObject).AllowMaterialMove (swk_none) then exit;
   if CheckBlankData = false then begin
      FSendClass.SendChatMessage (Conv ('请留出技术窗栏位'), SAY_COLOR_SYSTEM);
      exit;
   end;
   FillChar (Requested, SizeOf (Requested), 0);
   // Validate every entry before moving anything. The original client
   // zero-fills unused pairs; (0, 0) is empty, not inventory slot 0.
   for i := 0 to PRODUCT_KEY - 1 do begin
      Key := pcSetMaterial^.rIdx [i];
      Count := pcSetMaterial^.rCount [i];
      if Count = 0 then begin
         if Key <> 0 then exit;
         continue;
      end;
      if (Count < 1) or (Count > 10000) then exit;
      if not FHaveItemClass.ViewItem (Key, @Items [i]) then exit;
      if Items [i].rboNotSkill then begin
         FSendClass.SendChatMessage (Conv('此物品无法放入'), SAY_COLOR_SYSTEM);
         exit;
      end;
      if Items [i].rLockState <> 0 then begin
         FSendClass.SendChatMessage (Conv('物品锁定中,无法升级.'), SAY_COLOR_SYSTEM);
         exit;
      end;
      Inc (Requested [Key], Count);
      if Requested [Key] > Items [i].rCount then exit;
      Items [i].rCount := Count;
      StrPCopy (@Items [i].rOwnerName, Conv ('@技术窗'));
   end;
   // All five slots are empty, so at most four entries fit the four
   // material slots. No other request is processed inside this loop.
   for i := 0 to PRODUCT_KEY - 1 do begin
      if pcSetMaterial^.rCount [i] = 0 then continue;
      if not FHaveItemClass.DeletekeyItem (pcSetMaterial^.rIdx [i],
         pcSetMaterial^.rCount [i], @Items [i]) then exit;
      if not AddMaterialItem (Items [i]) then exit;
   end;
end;

function THaveJobClass.AddMaterialItem  (var aItemData: TItemData): Boolean;
var
   i : Integer;
begin
   Result := FALSE;
   i := CheckMaterialBlankData (aItemData);
   if i < 0 then exit;
   if HaveMaterialArr [i].rName [0] = 0 then
      HaveMaterialArr [i] := aItemData
   else
      Inc (HaveMaterialArr [i].rCount, aItemData.rCount);
   FSendClass.SendMaterialItem (i, HaveMaterialArr [i]);
   Result := TRUE;
end;

function THaveJobClass.AddKeyMaterialItem  (akey : Integer; var aItemData: TItemData): Boolean;
var
   i, nPos : Integer;
begin
   Result := false;

   if (aKey < 0) or (aKey > HAVEMATERIALITEMSIZE - 1) then exit;
   if aItemData.rName[0] = 0 then exit;
   if (akey = PRODUCT_KEY) and (aItemData.rMaxUpgrade = 0) then exit;
   if aKey <> PRODUCT_KEY then if CheckMaterialBlankData (aItemData) = -1 then exit;

   nPos := aKey;
   for i := 0 to HAVEMATERIALITEMSIZE - 1 do begin
      if StrPas (@HaveMaterialArr[i].rName) = StrPas (@aItemData.rName) then begin
         if HaveMaterialArr[i].rColor = aItemData.rColor then begin
            if HaveMaterialArr[i].rUpgrade = aItemData.rUpgrade then begin
               if HaveMaterialArr[i].rAddType = aItemData.rAddType then begin
                  if HaveMaterialArr[i].rboDouble = true then begin
                     nPos := i;
                     break;
                  end;
               end;
            end;
         end;
      end;
   end;

   if HaveMaterialArr[nPos].rName[0] <> 0 then begin
      if StrPas (@HaveMaterialArr[nPos].rName) <> StrPas (@aItemData.rName) then exit;
      if HaveMaterialArr[nPos].rColor <> aItemData.rColor then exit;
      if HaveMaterialArr[nPos].rUpgrade <> aItemData.rUpgrade then exit;
      if HaveMaterialArr[nPos].rAddType <> aItemData.rAddType then exit;

      if aItemData.rboDouble = false then exit;
      HaveMaterialArr[nPos].rCount := HaveMaterialArr[nPos].rCount + aItemData.rCount;
   end else begin
      HaveMaterialArr[nPos] := aItemData;
   end;

   FSendClass.SendMaterialItem (nPos, HaveMaterialArr[nPos]);

   Result := true;
end;

function THaveJobClass.PutProductItem  (var aItemData: TItemData) : Boolean;
begin
   Result := false;

   if HaveMaterialArr[PRODUCT_KEY].rName [0] <> 0 then exit;
   if aItemData.rName[0] = 0 then exit;

   HaveMaterialArr [PRODUCT_KEY] := aItemData;

   FSendClass.SendItemMoveInfo (StrPas (@FBasicObject.BasicData.Name) + ',' + Conv('@技术成功') + ','
      + StrPas(@HaveMaterialArr [PRODUCT_KEY].rName) + ':' + IntToStr (HaveMaterialArr [PRODUCT_KEY].rUpgrade) + ':'
      + IntToStr (HaveMaterialArr[PRODUCT_KEY].rAddType) + ',' + IntToStr(HaveMaterialArr [PRODUCT_KEY].rCount) + ','
      + IntToStr(0) + ',' + IntToStr(0) + ',' + IntToStr(0) + ',,', '');

   FSendClass.SendMaterialItem (PRODUCT_KEY, HaveMaterialArr [PRODUCT_KEY]);

   Result := true;
end;

function THaveJobClass.PutProductItem_2  (var aItemData: TItemData) : Boolean;
begin
   Result := false;

   if HaveMaterialArr[PRODUCT_KEY].rName [0] <> 0 then exit;
   if aItemData.rName[0] = 0 then exit;

   HaveMaterialArr [PRODUCT_KEY] := aItemData;

   FSendClass.SendItemMoveInfo (StrPas (@FBasicObject.BasicData.Name) + ',' + Conv('@名所加工') + ','
   + StrPas(@HaveMaterialArr [PRODUCT_KEY].rName) + ':' + IntToStr (HaveMaterialArr [PRODUCT_KEY].rUpgrade) + ':'
   + IntToStr(HaveMaterialArr [PRODUCT_KEY].rAddType) + ','
   + IntToStr(HaveMaterialArr [PRODUCT_KEY].rCount) + ',' + IntToStr(0) + ',' + IntToStr(0) + ',' + IntToStr(0) + ',,', '');

   FSendClass.SendMaterialItem (PRODUCT_KEY, HaveMaterialArr [PRODUCT_KEY]);

   Result := true;
end;

function THaveJobClass.DeletekeyMaterialItem (akey, aCount: integer; aItemData : PTItemData) : Boolean;
begin
   Result := FALSE;

   if (akey < 0) or (akey > HAVEMATERIALITEMSIZE - 1) then exit;

   HaveMaterialArr [akey].rCount := HaveMaterialArr[akey].rCount - aCount;
   if HaveMaterialArr [aKey].rCount <= 0 then begin
      FillChar (HaveMaterialArr [aKey], SizeOf (TItemData), 0);
   end;

   FSendClass.SendMaterialItem (aKey, HaveMaterialArr[akey]);

   Result := TRUE;
end;

function THaveJobClass.DeletekeyMaterialItem (akey : integer): Boolean;
begin
   Result := FALSE;

   if (akey < 0) or (akey > HAVEMATERIALITEMSIZE - 1) then exit;

   FillChar (HaveMaterialArr [aKey], SizeOf (TItemData), 0);
   FSendClass.SendMaterialItem (aKey, HaveMaterialArr[akey]);

   Result := TRUE;
end;

function THaveJobClass.DeleteMaterialItem (aItemData: PTItemData) : Boolean;
var
   i, LimitCount : integer;
begin
   Result := FALSE;

   for i := 0 to HAVEMATERIALITEMSIZE - 1 do begin
      if StrPas (@HaveMaterialArr[i].rName) = StrPas (@aItemData^.rName) then begin
         if HaveMaterialArr[i].rCount < aItemData^.rCount then exit;

         if (NATION_VERSION = NATION_CHINA_1) or (NATION_VERSION = NATION_CHINA_1_TEST) then begin
            LimitCount := 250;
         end else begin
            LimitCount := 100;
         end;

         if (aItemData^.rPrice * aItemData^.rCount >= LimitCount) or (aItemData^.rcolor <> 1) then begin
            if (aItemData.rName [0] <> 0) and (aItemData^.rOwnerName[0] <> 0) then begin
               FSendClass.SendItemMoveInfo (StrPas (@FBasicObject.BasicData.Name) + ',' +
                  StrPas(@aItemData^.rOwnerName) + ',' + StrPas(@aItemData^.rName) + ':' + IntToStr (aItemData^.rUpgrade) + ':' +
                  IntToStr (aItemData^.rAddType) + ',' + IntToStr(aItemData^.rCount) + ',' +
                  IntToStr(aItemData^.rOwnerServerID) + ',' + IntToStr(aItemData^.rOwnerX) + ',' +
                  IntToStr(aItemData^.rOwnerY) + ',' + StrPas (@aItemData^.rOwnerIP) + ',', '');
            end;
         end;

         HaveMaterialArr[i].rCount := HaveMaterialArr[i].rCount - aItemData.rCount;
         if HaveMaterialArr[i].rCount = 0 then FillChar (HaveMaterialArr[i], sizeof(TItemData), 0);
         FSendClass.SendMaterialItem (i, HaveMaterialArr[i]);
         Result := TRUE;
         exit;
      end;
   end;
end;

function THaveJobClass.FindItemKeybyName (aName : String) : Integer;
var
   i : Integer;
begin
   Result := -1;

   for i := 0 to HAVEMATERIALITEMSIZE - 1 do begin
      if HaveMaterialArr [i].rName [0] = 0 then continue;
      if StrPas (@HaveMaterialArr [i].rName) = aName then begin
         Result := i;
         exit;
      end;
   end;
end;

function THaveJobClass.FindItemCountbyName (aItemName : String) : Integer;
var
   i : Integer;
begin
   Result := 0;

   for i := 0 to HAVEMATERIALITEMSIZE - 1 do begin
      if StrPas (@HaveMaterialArr [i].rName) = aItemName then begin
         Result := Result + HaveMaterialArr [i].rCount;
      end;
   end;
end;

function THaveJobClass.ViewMaterialItem (akey: integer; aItemData: PTItemData): Boolean;
begin
   Result := FALSE;
   FillChar (aItemData^, sizeof(TItemData), 0);

   if (akey < 0) or (akey > HAVEMATERIALITEMSIZE - 1) then exit;
   if HaveMaterialArr[akey].rName[0] = 0 then exit;
   Move (HaveMaterialArr[akey], aItemData^, SizeOf (TItemData));
   Result := TRUE;
end;

procedure THaveJobClass.FromSkillToItemWindow (pcDragDrop : PTCDragDrop; aShowWindowClass : TShowWindowClass);
var
   ItemData : TItemData;
   srcKey, destKey : Integer;
begin
   srcKey := pcDragDrop^.rsourkey;
   destKey := pcDragDrop^.rdestkey;

   if (srcKey < 0) or (srcKey >= HAVEMATERIALITEMSIZE) then exit;
   if (destKey < 0) or (destKey >= HAVEITEMSIZE) then exit;

   if not ViewMaterialItem (srcKey, @ItemData) then exit;

   if FHaveItemClass.CheckAddable (ItemData) < 0 then begin
      FSendClass.SendChatMessage (Conv('持有的物品太多'), SAY_COLOR_SYSTEM);
      exit;
   end;

   if DeletekeyMaterialItem (srcKey, ItemData.rCount, @ItemData) = false then exit;

   if FHaveItemClass.AddKeyItem (destkey, ItemData) = false then begin
      if FHaveItemClass.AddItem (ItemData) = false then exit;
   end;
end;

function THaveJobClass.CheckProductBlankData : Boolean;
begin
   Result := false;

   if HaveMaterialArr [PRODUCT_KEY].rName [0] = 0 then Result := true;
end;

function THaveJobClass.CheckMaterialBlankData (aItemData : TItemData) : Integer;
var
   i : Integer;
begin
   Result := -1;

   if aItemData.rName [0] = 0 then exit;
   if (aItemData.rCount <= 0) or (aItemData.rCount > 100000000) then exit; 

   for i := 0 to PRODUCT_KEY - 1 do begin
      if aItemData.rboDouble = false then begin
         if HaveMaterialArr [i].rName [0] = 0 then begin
            Result := i;
            exit;
         end;
      end else begin
         if StrPas (@HaveMaterialArr [i].rName) = StrPas (@aItemData.rName) then begin
            if HaveMaterialArr [i].rColor = aItemData.rColor then begin
               if HaveMaterialArr [i].rUpgrade = aItemData.rUpgrade then begin
                  if (HaveMaterialArr [i].rboDouble = true) and
                     (HaveMaterialArr [i].rAddType = aItemData.rAddType) and
                     (HaveMaterialArr [i].rCount <= 100000000 - aItemData.rCount) then begin
                     Result := i;
                     exit;
                  end;
               end;
            end;
         end;
      end;
   end;

   if aItemData.rboDouble = true then begin
      for i := 0 to PRODUCT_KEY - 1 do begin
         if HaveMaterialArr [i].rName [0] = 0 then begin
            Result := i;
            exit;
         end;
      end;
   end;
end;

function THaveJobClass.CheckBlankData : Boolean;
var
   i : Integer;
begin
   Result := false;

   for i := 0 to PRODUCT_KEY do begin
      if HaveMaterialarr [i].rName [0] <> 0 then exit;
   end;

   Result := true;
end;

procedure THaveJobClass.ClearMaterialData;
var
   i : Integer;
begin
   for i := 0 to HAVEMATERIALITEMSIZE - 1 do begin
      FillChar (HaveMaterialArr [i], SizeOf (TItemData), 0);
      FSendClass.SendMaterialItem (i, HaveMaterialArr [i]);
   end;
end;

procedure THaveJobClass.ClearJobData;
begin
   FJobKind := JOB_KIND_NONE;
   FJobGrade := JOB_GRADE_NONE;
   // FillChar (FJobTool, SizeOf (TItemData), 0);
end;

procedure THaveJobClass.SetJobTalent (aExp : Integer);
var
   Str : String;
   ItemData : TItemData;
begin
   if FJobKind <> JOB_KIND_NONE then begin
      FAttribClass.AttribData.Talent := aExp;
      FAttribClass.Calculate;
      FJobGrade := JobClass.GetJobGrade (FAttribClass.Talent);
      Str := GetJobToolStr;
      if Str <> '' then begin
         ItemClass.GetItemData (Str, ItemData);
         if ItemData.rName [0] <> 0 then begin
            FWorkSound := ItemData.rSoundEvent.rWavNumber;
         end;
      end;
   end;
end;

procedure THaveJobClass.ConfirmMakeItem;
var
   Str, MadeItem : String;
   cnt : Integer;
   ItemData : TItemData;
   SubData : TSubData;
   usd : TStringData;   
begin
   if HaveMaterialArr [PRODUCT_KEY].rName [0] <> 0 then begin
      FSendClass.SendJobResult (false, IntToStr (FWorkSound), JOB_SOUND_FALSE, Conv('此物品已存在'));
      exit;
   end;

   
   if (HaveMaterialArr [0].rName [0] = 0) and
      (HaveMaterialArr [1].rName [0] = 0) and
      (HaveMaterialArr [2].rName [0] = 0) and
      (HaveMaterialArr [3].rName [0] = 0) then begin
      FSendClass.SendJobResult (false, IntToStr (FWorkSound), JOB_SOUND_FALSE, Conv('无原料'));
      exit;
   end;

   if CheckEventItemMaterial then begin
      ProcessEventItemGive;
      exit;
   end;

   MadeItem := '';

   MadeItem := ItemMaterialClass.GetAllMakeMaterialData (GetMaterialStr);
   if MadeItem = '' then begin
      Case FJobKind of
         JOB_KIND_ALCHEMIST, JOB_KIND_CHEMIST, JOB_KIND_DESIGNER, JOB_KIND_CRAFTSMAN : begin
            MadeItem := ItemMaterialClass.GetMakeMaterialData (FJobKind, GetMaterialStr);
         end;
         Else begin
            FSendClass.SendJobResult (false, IntToStr (FWorkSound), JOB_SOUND_FALSE, Conv('没有选择职业'));
            exit;
         end;
      end;
   end;

   if MadeItem = '' then begin // 棵妨初篮 犁丰俊 嘎绰 搬苞啊 绝绰 版快
      // ClearMaterialData;
      FSendClass.SendJobResult (false, IntToStr (FWorkSound), JOB_SOUND_FALSE,Conv('物品制造失败'));
      Str := Conv('材料组合不正确');
      SetWordString (SubData.SayString, Str);
      FBasicObject.SendLocalMessage (NOTARGETPHONE, FM_SAYSYSTEM, FBasicObject.BasicData, SubData);

      exit;
   end else begin // 力炼 瓷仿捞 登绰瘤, 力炼 己傍沁绰瘤
      ItemClass.GetItemData (MadeItem, ItemData);
      if ItemData.rJobKind <> 0 then begin
         if MakeItemByRate (MadeItem) = true then begin
            FSendClass.SendJobResult (true, IntToStr (FWorkSound), JOB_SOUND_TRUE, Conv ('制造物品成功'));
            Str := format (Conv ('%s 制造 %s 成功'), [StrPas (@FBasicObject.BasicData.Name), MadeItem]);
            SetWordString (SubData.SayString, Str);
            Str := format (Conv ('%s 制造 %s 成功'), [StrPas (@FBasicObject.BasicData.Name), MadeItem]);

            usd.rmsg := 1;                                        // 酒捞袍 肮荐 朝府绊
            SetWordString (usd.rWordString, 'Make:' + MadeItem + ',' + IntToStr (1) + ',');
            cnt := sizeof(usd) - sizeof(TWordString) + sizeofwordstring (usd.rwordstring);

            FrmSockets.UdpObjectAddData (cnt, @usd);
         end else begin
            FSendClass.SendJobResult (false, IntToStr (FWorkSound), JOB_SOUND_FALSE, Conv ('物品制造失败'));
            Str := format (Conv ('%s 制造 %s 失败'), [StrPas (@FBasicObject.BasicData.Name), MadeItem]);
            SetWordString (SubData.SayString, Str);
            Str := format (Conv ('%s 制造 %s 失败'), [StrPas (@FBasicObject.BasicData.Name), MadeItem]);
         end;
      end else begin  // 葛电荤恩甸捞 促 父甸 荐 乐绰;;;
         if MakeItem (MadeItem) = true then begin
            FSendClass.SendJobResult (true, IntToStr (FWorkSound), JOB_SOUND_TRUE, Conv ('制造物品成功'));
            Str := format (Conv ('%s 制造 %s 成功'), [StrPas (@FBasicObject.BasicData.Name), MadeItem]);
            SetWordString (SubData.SayString, Str);
            Str := format (Conv ('%s 制造 %s 成功'), [StrPas (@FBasicObject.BasicData.Name), MadeItem]);

            usd.rmsg := 1;                                        // 酒捞袍 肮荐 朝府绊
            SetWordString (usd.rWordString, 'Make:' + MadeItem + ',' + IntToStr (1) + ',');
            cnt := sizeof(usd) - sizeof(TWordString) + sizeofwordstring (usd.rwordstring);

            FrmSockets.UdpObjectAddData (cnt, @usd);
         end else begin
            FSendClass.SendJobResult (false, IntToStr (FWorkSound), JOB_SOUND_FALSE, Conv ('物品制造失败'));
            Str := format (Conv ('%s 制造 %s 失败'), [StrPas (@FBasicObject.BasicData.Name), MadeItem]);
            SetWordString (SubData.SayString, Str);
            Str := format (Conv ('%s 制造 %s 失败'), [StrPas (@FBasicObject.BasicData.Name), MadeItem]);
         end;
      end;
   end;

   FBasicObject.SendLocalMessage (NOTARGETPHONE, FM_SAYSYSTEM, FBasicObject.BasicData, SubData);

   ItemClass.GetItemData (MadeItem, ItemData);   
   if ItemData.rGrade = 1 then begin
      UserList.SendTopMessage (Str);
   end;
end;

function THaveJobClass.MakeItembyRate (aItemName : String) : Boolean;
var
   Str : String;
   ItemData : TItemData;
   JobGradeData : TJobGradeData;
   RandomRate, SuccessRate, TalentExp, MaxTalent : Integer;
   NewGrade : Byte;
begin
   Result := false;

   if ItemClass.GetItemData (aItemName, ItemData) = false then exit;
   if ItemData.rName [0] = 0 then exit;
   if HaveMaterialArr [PRODUCT_KEY].rName [0] <> 0 then exit;
   if (ItemData.rGrade < 1) or (ItemData.rGrade > 10) then exit;

   JobClass.GetJobGradeData (FJobGrade, JobGradeData);
   if JobGradeData.MaxItemGrade > ItemData.rGrade then begin
      ClearMaterialData;
      exit;
   end;

   if ItemData.rSuccessRate < 100 then begin
      SuccessRate := JobGradeData.Grade [ItemData.rGrade - 1];

      if ItemData.rMaxUpgrade = 4 then begin   // 扁贱酒捞袍 酒囱巴
         SuccessRate := SuccessRate div 2;
      end;
      
      RandomRate := Random (100 + 1);
      if RandomRate > SuccessRate then begin
         ClearMaterialData;
         
         FSendClass.SendItemMoveInfo (StrPas (@FBasicObject.BasicData.Name) + ',' + Conv('@制造失败') + ','
            + StrPas(@ItemData.rName) + ':' + IntToStr (ItemData.rUpgrade) + ':'
            + IntToStr(ItemData.rAddType) + ',' + IntToStr(ItemData.rCount) + ',' +
            IntToStr(0) + ',' + IntToStr(0) + ',' + IntToStr(0) + ',,', '');
         exit;
      end;
   end;

   if ItemData.rboTalentExp = true then begin
      // 力炼 己傍俊 狼茄 犁瓷 版氰摹 刘啊
      MaxTalent := JobClass.GetItemGradeMaxTalent (ItemData.rGrade);
   //   TalentExp := (MaxTalent * (100 - JobGradeData.Grade [ItemData.rGrade - 1]) * 25) div 10;
      TalentExp := (MaxTalent * (90 - JobGradeData.Grade [ItemData.rGrade - 1]) * 25) div 10;
      FAttribClass.AddTalent (TalentExp);
   end;

   ClearMaterialData;
   PutProductItem (ItemData);

   NewGrade := JobClass.GetJobGrade (FAttribClass.Talent);
   if NewGrade <> FJobGrade then begin
      {
      ToolName := JobClass.GetJobTool (FJobKind, NewGrade);
      if ToolName = '' then exit;
      if ItemClass.GetItemData (ToolName, ToolItemData) = false then exit;
      if ToolItemData.rName [0] = 0 then exit;
      }

      FJobGrade := NewGrade;
      // FJobTool := ToolItemData;
      Str := GetJobToolStr;
      if Str <> '' then begin
         ItemClass.GetItemData (Str, ItemData);
         if ItemData.rName [0] <> 0 then begin
            FWorkSound := ItemData.rSoundEvent.rWavNumber;
         end;
      end;
   end;

   Result := true;
end;

function THaveJobClass.MakeItem (aItemName : String) : Boolean;
var
   Str : String;
   ItemData : TItemData;
   JobGradeData : TJobGradeData;
   RandomRate, SuccessRate, TalentExp, MaxTalent : Integer;
   NewGrade : Byte;
begin
   Result := false;

   if ItemClass.GetItemData (aItemName, ItemData) = false then exit;
   if ItemData.rName [0] = 0 then exit;
   if HaveMaterialArr [PRODUCT_KEY].rName [0] <> 0 then exit;

   if FHaveItemClass.FindItem (@ItemData) = true then begin
      if ItemData.rKind = ITEM_KIND_CHARM then begin
//         FSendClass.SendChatMessage ('歹捞惑 父甸 荐 绝嚼聪促', SAY_COLOR_SYSTEM);
         exit;
      end;
   end;

   ClearMaterialData;
   PutProductItem (ItemData);

   Result := true;
end;

function THaveJobClass.CheckDelAttribItem : Boolean;
var
   i, iCount : integer;
begin
   Result := false;

   iCount :=0;

   for i :=0 to 4-1 do begin
      if HaveMaterialArr[i].rName[0] = 0 then continue;
      if HaveMaterialArr[i].rKind = ITEM_KIND_DELATTRIBITEM then begin
         inc (iCount);
      end;
   end;

   if iCount = 0 then exit;
   if (HaveMaterialArr[PRODUCT_KEY].rName[0] <> 0 ) and
      (HaveMaterialArr[PRODUCT_KEY].rAddType <> 0) then Result := true;
end;

function THaveJobClass.CheckEventItemMaterial : Boolean;
var
   i, iCount : integer;
begin
   Result := false;
   iCount := 0;

   for i := 0 to 4-1 do begin
      if HaveMaterialArr[i].rName[0] = 0 then continue;
      if HaveMaterialArr[i].rKind = ITEM_KIND_EVENT1 then inc(iCount)
      else exit;
   end;

   if iCount = 0 then exit;
   if HaveMaterialArr[PRODUCT_KEY].rName[0] <> 0 then exit;

   for i := 0 to 4-1 do begin
      if HaveMaterialArr[i].rName[0] = 0 then continue;
      if HaveMaterialArr[i].rCount > 3 then begin
         FSendClass.SendJobResult (false, IntToStr (FWorkSound), JOB_SOUND_FALSE, 'Event材料最多只能放置5个');
         exit;
      end;
   end;
   
   Result := true;
end;

function THaveJobClass.GetEventItemSuccessRate : integer;
var
   i : integer;
   total : integer;
begin
   Result := 0;

   total := 0;

   for i := 0 to 4-1 do begin
      if HaveMaterialArr[i].rName[0] <> 0 then
         total := total + HaveMaterialArr[i].rSuccessRate * HaveMaterialArr[i].rCount;
   end;

   result := total;
end;

function THaveJobClass.GetRandomValue(aValue : integer) : integer;
var
   aTotal : integer;
begin
   Result := 0;
   //aTotal := EventItemClass.MAX_RANGE - aValue;
   Result := aValue + Random(aTotal);
end;

function THaveJobClass.CheckAddAttribItem : Boolean;
var
   i, iCount : integer;
begin
   Result := false;

   iCount := 0;
   for i := 0 to 4 - 1 do begin
      if HaveMaterialArr[i].rName[0] = 0 then continue;
      if HaveMaterialArr[i].rKind = ITEM_KIND_ADDATTRIBITEM then begin
         inc (iCount);
      end;
   end;

   if (iCount = 1) and
      (HaveMaterialArr[PRODUCT_KEY].rName[0] <> 0) and
      (HaveMaterialArr[PRODUCT_KEY].rRoleType > 0) and
      (HaveMaterialArr[PRODUCT_KEY].rRoleType <= ROLE_HANDMAN) then Result := true;
end;

function THaveJobClass.CheckAddAttribKind (var iWorth : Integer) : Boolean;
var
   i, iPos, aSpecialKind, iCount, nCount : integer;
begin
   Result := false;

   nCount := 0;
   iPos := -1;
   for i := 0 to 4 - 1 do begin
      if HaveMaterialArr[i].rName[0] = 0 then continue;
      if HaveMaterialArr[i].rKind = ITEM_KIND_ADDATTRIBITEM then begin
         iPos := i;
      end else begin
         inc (nCount);
      end;
   end;

   if nCount > 0 then exit;
   if iPos = -1 then exit;

   case HaveMaterialArr[PRODUCT_KEY].rWearArr of
      ADDATTRIB_CAP, ADDATTRIB_ARMARMOR, ADDATTRIB_SHOES : aSpecialKind := ITEM_SPKIND_MUNJANG;
      ADDATTRIB_ARMOR : aSpecialKind := ITEM_SPKIND_ZANGSIK;
      ADDATTRIB_WEAPON : aSpecialKind := ITEM_SPKIND_JUMOON;
      else begin
         aSpecialKind := ITEM_SPKIND_NONE;
      end;
   end;

   if aSpecialKind <> HaveMaterialArr[iPos].rSpecialKind then exit;
   iCount := AddAttribClass.GetNeedItemCount(HaveMaterialArr[PRODUCT_KEY].rGrade);
   if iCount <> HaveMaterialArr[iPos].rCount then exit;
   iWorth := HaveMaterialArr[iPos].rAttribute;
   Result := true;
end;

procedure THaveJobClass.ProcessDelAddAttribItem;
var
   i : integer;
   ItemData : TItemData;
   ItemName : String;
begin
   ItemName := StrPas (@HaveMaterialArr[PRODUCT_KEY].rName);
   ItemClass.GetItemData(ItemName, ItemData);
   ItemData.rcolor := HaveMaterialArr[PRODUCT_KEY].rcolor;
   ItemData.rAddType := 0;
   ItemData.rUpgrade := HaveMaterialArr[PRODUCT_KEY].rUpgrade;
   JobClass.GetUpgradeItemLifeData (ItemData);

   ClearMaterialData;

   FSendClass.SendJobResult (true, IntToStr (FWorkSound), JOB_SOUND_TRUE, Conv('属性消失'));
   HaveMaterialArr[PRODUCT_KEY] := ItemData;
   FSendClass.SendMaterialItem(PRODUCT_KEY, HaveMaterialArr[PRODUCT_KEY]);
end;

procedure THaveJobClass.ProcessEventItemGive;
var
   i : integer;
   ItemData : TItemData;
   totalvalue, nRandom : integer;
   aItemName : string;
   aItemCount : integer;
   SubData : TSubData;
   str : string;
begin
   totalvalue := GetEventItemSuccessRate;
   EventItemClass.GetEventItem(totalvalue, aItemName, aItemCount);

   ClearMaterialData;

   if aItemName = '' then begin
      FSendClass.SendJobResult (false, IntToStr (FWorkSound), JOB_SOUND_FALSE, '没有中奖..');
   end else begin
      ItemClass.GetItemData (aItemName, ItemData);
      if ItemData.rName[0] = 0 then begin
         FSendClass.SendJobResult (false, IntToStr (FWorkSound), JOB_SOUND_FALSE, '没有中奖..');
         exit;
      end;
      
      ItemData.rCount := aItemCount;

      FSendClass.SendJobResult (true, IntToStr (FWorkSound), JOB_SOUND_TRUE, '您中奖了Event物品');
      HaveMaterialArr[PRODUCT_KEY] := ItemData;
      FSendClass.SendMaterialItem(PRODUCT_KEY, HaveMaterialArr[PRODUCT_KEY]);

      Str := format ('%s您中奖了 %s:%d Event ITEM', [StrPas (@FBasicObject.BasicData.Name),aItemName,aItemCount]);
      SetWordString (SubData.SayString, Str);
      FBasicObject.SendLocalMessage (NOTARGETPHONE, FM_SAYSYSTEM, FBasicObject.BasicData, SubData);

      FSendClass.SendItemMoveInfo (StrPas (@FBasicObject.BasicData.Name) + ',' + '@Event830' + ','
         + StrPas(@HaveMaterialArr [PRODUCT_KEY].rName) + ':'
         + IntToStr (HaveMaterialArr [PRODUCT_KEY].rUpgrade) + ':'
         + IntToStr (HaveMaterialArr [PRODUCT_KEY].rAddType) + ','
         + IntToStr(HaveMaterialArr [PRODUCT_KEY].rCount) + ',' + IntToStr(0) + ',' + IntToStr(0) + ',' + IntToStr(0) + ',,', '');
   end;
end;

procedure THaveJobClass.ProcessAddAttribItem (iWorth : Integer) ;
var
   aMaxRange : Integer;
   aAddType : Integer;
   ItemData : TItemData;
begin
   aMaxRange := AddAttribClass.GetRange (HaveMaterialArr[PRODUCT_KEY].rGrade);
   aAddType := AddAttribClass.GetAddTypeNum (aMaxRange, iWorth);
   if aAddType < 1 then exit;

   ItemData := HaveMaterialArr[PRODUCT_KEY];
   ItemData.rAddType := aAddType;
   ItemClass.GetAddItemAttribData (ItemData);
   ClearMaterialData;

   FSendClass.SendJobResult (true, IntToStr (FWorkSound), JOB_SOUND_TRUE, Conv('新增属性'));
   HaveMaterialArr[PRODUCT_KEY] := ItemData;

   FSendClass.SendMaterialItem(PRODUCT_KEY, HaveMaterialArr[PRODUCT_KEY]);
end;

function THaveJobClass.Check3rdQuestItem : Boolean;
var
   kindcheck : array [0..4-1] of Boolean;
   i : integer;
begin
   Result := false;
   FillChar (kindcheck , sizeof(kindcheck), 0);

   for i := 0 to 4 - 1 do begin
      if HaveMaterialArr[i].rKind <> ITEM_KIND_NAMEDPOSQUEST then exit;   
      if HaveMaterialArr[i].rCount <> 1 then exit;
      if HaveMaterialArr[i].rSpecialKind = 0 then exit;
      
      case HaveMaterialArr[i].rSpecialKind of
         ITEM_SPKIND_1 : kindcheck[0] := true;
         ITEM_SPKIND_2 : kindcheck[1] := true;
         ITEM_SPKIND_3 : kindcheck[2] := true;
         ITEM_SPKIND_4 : kindcheck[3] := true;
      end;
   end;

   for i := 0 to 4 -1 do begin
      if kindcheck[i] = false then exit;
   end;

   Result := true;
end;

procedure THaveJobClass.ConfirmProcessItem;
var
   Str : String;
   ProcessDrug : Word;
   SubDrugRate, cnt : Integer;
   ItemData : TItemData;
   SubData : TSubData;
   usd : TStringData;
   iWorth : Integer;   
begin
   if HaveMaterialArr [PRODUCT_KEY].rName [0] = 0 then begin
      FSendClass.SendJobResult (false, IntToStr (FWorkSound), JOB_SOUND_FALSE, Conv('没有加工用的物品'));
      exit;
   end;

   //2003-08-29 EventCode : 酒捞袍 加己 檬扁拳
   if CheckDelAttribItem then begin
      ProcessDelAddAttribItem;

      FSendClass.SendItemMoveInfo (StrPas (@FBasicObject.BasicData.Name) + ',' + Conv ('@属性值初始化') + ','
         + StrPas(@HaveMaterialArr [PRODUCT_KEY].rName) + ':'
         + IntToStr (HaveMaterialArr [PRODUCT_KEY].rUpgrade) + ':'
         + IntToStr (HaveMaterialArr [PRODUCT_KEY].rAddType) + ','
         + IntToStr(HaveMaterialArr [PRODUCT_KEY].rCount) + ',' + IntToStr(0) + ',' + IntToStr(0) + ',' + IntToStr(0) + ',,', '');
      exit;
   end;

   if CheckAddAttribItem then begin
      if HaveMaterialArr [PRODUCT_KEY].rAddType <> 0 then begin
         FSendClass.SendJobResult (false, IntToStr (FWorkSound), JOB_SOUND_FALSE, Conv('已经加了属性的物品'));
         exit;
      end;
      if CheckAddAttribKind (iWorth) then begin
         ProcessAddAttribItem (iWorth);
      end else begin
         FSendClass.SendJobResult (false, IntToStr (FWorkSound), JOB_SOUND_FALSE, Conv('是其他种类的新增属性的物品或是属性物品的数量不符'));
      end;
      exit;
   end;

   if Check3rdQuestItem then begin
      ItemData := HaveMaterialArr [PRODUCT_KEY];


      if ItemData.rMaxUpgrade <= ItemData.rUpgrade then begin
         FSendClass.SendJobResult (false, IntToStr (FWorkSound), JOB_SOUND_FALSE, Conv('不能继续加工'));
         exit;
      end else begin
         ItemData.rUpgrade := ItemData.rUpgrade + 1;
      end;
      
      ClearMaterialData;
      JobClass.GetUpgradeItemLifeData (ItemData);
      ItemClass.GetAddItemAttribData (ItemData);

      if ItemData.rName[0] = 0 then exit;
      HaveMaterialArr [PRODUCT_KEY] := ItemData;

      if HaveMaterialArr [PRODUCT_KEY].rName[0] <> 0 then begin
         FSendClass.SendItemMoveInfo (StrPas (@FBasicObject.BasicData.Name) + ',' + Conv('@名所加工') + ','
            + StrPas(@HaveMaterialArr [PRODUCT_KEY].rName) + ':'
            + IntToStr (HaveMaterialArr [PRODUCT_KEY].rUpgrade) + ':'
            + IntToStr (HaveMaterialArr [PRODUCT_KEY].rAddType) + ','
            + IntToStr(HaveMaterialArr [PRODUCT_KEY].rCount) + ',' + IntToStr(0) + ',' + IntToStr(0) + ',' + IntToStr(0) + ',,', '');
      end;

      FSendClass.SendMaterialItem (PRODUCT_KEY, HaveMaterialArr [PRODUCT_KEY]);
      FSendClass.SendJobResult (true, IntToStr (FWorkSound), JOB_SOUND_TRUE, Conv('用于任务的物品加工成功了'));

      exit;
   end;
   
   if FJobKind = JOB_KIND_NONE then begin
      FSendClass.SendJobResult (false, IntToStr (FWorkSound), JOB_SOUND_FALSE, Conv('没有选择职业'));
      exit;
   end;

   if FindProcessDrug (ProcessDrug, SubDrugRate) = false then begin // 啊傍矫距阑 啊瘤绊 乐绰瘤 八荤 (割窜 啊傍矫距牢瘤)
      FSendClass.SendJobResult (false, IntToStr (FWorkSound), JOB_SOUND_FALSE, '');      
      exit;
   end;
   if (HaveMaterialArr [PRODUCT_KEY].rWearArr = 1) or (HaveMaterialArr [PRODUCT_KEY].rWearArr = 3) or
      (HaveMaterialArr [PRODUCT_KEY].rWearArr = 6) or (HaveMaterialArr [PRODUCT_KEY].rWearArr = 8) or
      (HaveMaterialArr [PRODUCT_KEY].rWearArr = 9) then begin
      if HaveMaterialArr [PRODUCT_KEY].rboUpgrade = false then begin // 啊傍秦档 登绰瘤 八荤
         FSendClass.SendJobResult (false, IntToStr (FWorkSound), JOB_SOUND_FALSE, Conv('物品加工失败'));
         exit;
      end;
      if HaveMaterialArr [PRODUCT_KEY].rMaxUpgrade < ProcessDrug then begin // 弥措啊傍摹
         FSendClass.SendJobResult (false, IntToStr (FWorkSound), JOB_SOUND_FALSE, Conv('物品加工失败'));
         exit;
      end;
      if HaveMaterialArr [PRODUCT_KEY].rUpgrade <> ProcessDrug - 1 then begin // 酒捞袍俊 嘎霸 啊傍矫距阑 借绰瘤
         SetWordString (SubData.SayString, Conv('请放入相应物品的加工试剂'));
         FBasicObject.SendLocalMessage (NOTARGETPHONE, FM_SAYSYSTEM, FBasicObject.BasicData, SubData);
         FSendClass.SendJobResult (false, IntToStr (FWorkSound), JOB_SOUND_FALSE, Conv('请放入相应物品的加工试剂'));
         exit;
      end;

      ItemData := HaveMaterialArr [PRODUCT_KEY];
      if ProcessItembyRate (ItemData, ProcessDrug, SubDrugRate) = true then begin
         FSendClass.SendJobResult (true, IntToStr (FWorkSound), JOB_SOUND_TRUE, Conv('物品加工成功'));
         Str := format (Conv('%s 加工 %s 第%d段 成功'), [StrPas (@FBasicObject.BasicData.Name), StrPas (@ItemData.rName), ItemData.rUpgrade + 1]);
         SetWordString (SubData.SayString, Str);
         Str := format (Conv('%s 加工 %s 第%d段 成功'), [StrPas (@FBasicObject.BasicData.Name), StrPas (@ItemData.rName), ItemData.rUpgrade + 1]);

         usd.rmsg := 1;                                        // 酒捞袍 肮荐 朝府绊
         SetWordString (usd.rWordString, 'Process:' + StrPas (@ItemData.rName) + ':' + IntToStr (ItemData.rUpgrade + 1) + ',' + IntToStr (ItemData.rCount) + ',');
         cnt := sizeof(usd) - sizeof(TWordString) + sizeofwordstring (usd.rwordstring);

         FrmSockets.UdpObjectAddData (cnt, @usd);
      end else begin
         FSendClass.SendJobResult (false, IntToStr (FWorkSound), JOB_SOUND_FALSE, Conv('物品加工失败'));
         Str := format (Conv('%s 加工 %s 第%d段 失败'), [StrPas (@FBasicObject.BasicData.Name), StrPas (@ItemData.rName), ItemData.rUpgrade + 1]);
         SetWordString (SubData.SayString, Str);
         Str := format (Conv('%s 加工 %s 第%d段 失败'), [StrPas (@FBasicObject.BasicData.Name), StrPas (@ItemData.rName), ItemData.rUpgrade + 1]);
      end;

      FBasicObject.SendLocalMessage (NOTARGETPHONE, FM_SAYSYSTEM, FBasicObject.BasicData, SubData);
      if ItemData.rUpgrade >= 2 then begin
         UserList.SendTopMessage (Str);
      end;
   end;
end;

function THaveJobClass.FindProcessDrug (var aProcessDrug : Word; var aSubDrugRate : Integer) : Boolean;
var
   i : Integer;
   ItemData : TItemData;
   nCount : Integer;
begin
   Result := false;

   aProcessDrug := 0;
   aSubDrugRate := 0;

   nCount := 0;
   for i := 0 to 4 - 1 do begin
      if HaveMaterialArr [i].rName [0] = 0 then continue;
      inc (nCount);      
   end;

   if nCount < 0 then exit;

   for i := 0 to 4 - 1 do begin
      if HaveMaterialArr [i].rName [0] = 0 then continue;

      if StrPas (@HaveMaterialArr [i].rName) = INI_DEF_ITEMPROCESS1 then begin      // 割窜啊傍牢瘤 府畔秦霖促
         aProcessDrug := 1;
         break;
      end else if StrPas (@HaveMaterialArr [i].rName) = INI_DEF_ITEMPROCESS2 then begin
         aProcessDrug := 2;
         break;
      end else if StrPas (@HaveMaterialArr [i].rName) = INI_DEF_ITEMPROCESS3 then begin
         aProcessDrug := 3;
         break;
      end else if StrPas (@HaveMaterialArr [i].rName) = INI_DEF_ITEMPROCESS4 then begin
         aProcessDrug := 4;
         break;
      end;
   end;

   case nCount of
      1 : begin
         if aProcessDrug > 0 then begin
            Result := true;
            exit;
         end;
      end;
      2 : begin
         if aProcessDrug > 0 then begin
            for i := 0 to 4 - 1 do begin
               if HaveMaterialArr [i].rName [0] = 0 then continue;

               if HaveMaterialArr [i].rKind = ITEM_KIND_HELPDRUG then begin
                  ItemClass.GetItemData (StrPas (@HaveMaterialArr [i].rName), ItemData);
                  if ItemData.rName [0] = 0 then continue;
                  aSubDrugRate := ItemData.rSuccessRate;
                  Result := true;
                  exit;
               end;
            end;
         end;
      end;
   end;
end;

function THaveJobClass.ProcessItembyRate (aItemData : TItemData; aUpgrade : Word; aSubDrugRate : Integer) : Boolean;
var
   Rate, SuccessCount, RandomCount : Integer;
begin
   Result := false;

   if aItemData.rName [0] = 0 then exit;

   case aItemData.rMaxUpgrade of
      3 : Rate := JobClass.GetItemUpgradeSuccessRate (aUpgrade);
      4 : Rate := JobClass.GetItemUpgradeDungeonRate (aUpgrade);
      else exit;
   end;

   SuccessCount := Rate + (Rate * aSubDrugRate div 100);   // 啊傍己傍伏 + 焊炼矫距啊傍伏
   RandomCount := Random (100);
   if RandomCount < SuccessCount then begin
      ClearMaterialData;
      aItemData.rUpgrade := aItemData.rUpgrade + 1;
      JobClass.GetUpgradeItemLifeData (aItemData);
      PutProductItem (aItemData);
      Result := true;
   end else begin
      ClearMaterialData;

      FSendClass.SendItemMoveInfo (StrPas (@FBasicObject.BasicData.Name) + ',' + Conv('@加工失败') + ','
         + StrPas(@aItemData.rName) + ':' + IntToStr (aItemData.rUpgrade) + ':'
         + IntToStr(aItemData.rAddType) + ',' + IntToStr(aItemData.rCount) + ','
         + IntToStr(0) + ',' + IntToStr(0) + ',' + IntToStr(0) + ',,', '');
   end;
end;

function THaveJobClass.DecEventPick : Boolean;
begin
   Result := FALSE;
   
   if FAttribClass.CurLife < 70 then exit;

   FAttribClass.CurLife := FAttribClass.CurLife - 70;

   Result := TRUE;
end;

procedure THaveJobClass.SmeltItem (aMakeName : String; aShowWindowClass : TShowWindowClass);
var
   SmeltItemData : TSmeltItemData;
   ItemData, MakeItemData : TItemData;
   nPos : Integer;
begin
   FSmeltItem := '';

   if aMakeName = '' then exit;

   if TUser (FBasicObject).Password <> '' then begin
      TUser (FBasicObject).SendClass.SendChatMessage (Conv('有密码设定'), SAY_COLOR_SYSTEM);
      exit;
   end;

   if ItemClass.GetSmeltItemData (aMakeName, SmeltItemData) = false then begin
      FSendClass.SendChatMessage (Conv('无法提炼'), SAY_COLOR_SYSTEM);
      exit;
   end;

   nPos := FHaveItemClass.FindItemKeyByName (StrPas (@SmeltItemData.rNeedItem));  // 力访且 犁丰乐绰瘤 犬牢
   if nPos < 0 then begin
      FSendClass.SendChatMessage (format (Conv('%s 的提炼需要 %s %d个'), [StrPas (@SmeltItemData.rName), StrPas (@SmeltItemData.rNeedItem), SmeltItemData.rNeedCount]), SAY_COLOR_SYSTEM);
      exit;
   end;

   if ItemClass.GetItemData (aMakeName, MakeItemData) = false then begin
      FSendClass.SendChatMessage (Conv('无法提炼'), SAY_COLOR_SYSTEM);
      exit;
   end;

   if FHaveItemClass.ViewItem (nPos, @ItemData) = false then begin
      FSendClass.SendChatMessage (format (Conv('%s 的提炼需要 %s %d个'), [StrPas (@SmeltItemData.rName), StrPas (@SmeltItemData.rNeedItem), SmeltItemData.rNeedCount]), SAY_COLOR_SYSTEM);
      exit;
   end;

   if StrPas (@ItemData.rName) <> StrPas (@SmeltItemData.rNeedItem) then begin
      FSendClass.SendChatMessage (format (Conv('%s 的提炼需要 %s %d个'), [StrPas (@SmeltItemData.rName), StrPas (@SmeltItemData.rNeedItem), SmeltItemData.rNeedCount]), SAY_COLOR_SYSTEM);
      exit;
   end;
   if ItemData.rCount < SmeltItemData.rNeedCount then begin
      FSendClass.SendChatMessage (format (Conv('%s 的提炼需要 %s %d个'), [StrPas (@SmeltItemData.rName), StrPas (@SmeltItemData.rNeedItem), SmeltItemData.rNeedCount]), SAY_COLOR_SYSTEM);
      exit;
   end;

   FSmeltItem := aMakeName;

   aShowWindowClass.FCurrentWindow := swk_count;
   FSendClass.SendShowCount (DRAGACTION_SMELTITEM, nPos, nPos, 10000, FSmeltItem);
end;

procedure THaveJobClass.SmeltItem2 (aMakeName : String; aShowWindowClass : TShowWindowClass);
var
   SmeltItemData : TSmeltItemData;
   ItemData, MakeItemData : TItemData;
   nPos : Integer;
begin
   FSmeltItem2 := '';

   if aMakeName = '' then exit;

   if TUser (FBasicObject).Password <> '' then begin
      TUser (FBasicObject).SendClass.SendChatMessage (Conv('有密码设定'), SAY_COLOR_SYSTEM);
      exit;
   end;

   if ItemClass.GetSmeltItemData2 (aMakeName, SmeltItemData) = false then begin
      FSendClass.SendChatMessage (Conv('无法交换'), SAY_COLOR_SYSTEM);
      exit;
   end;

   nPos := FHaveItemClass.FindItemKeyByName (StrPas (@SmeltItemData.rNeedItem));  // 力访且 犁丰乐绰瘤 犬牢
   if nPos < 0 then begin
      FSendClass.SendChatMessage (format (Conv('交换 %s 需要 %s %d个'), [StrPas (@SmeltItemData.rName), StrPas (@SmeltItemData.rNeedItem), SmeltItemData.rNeedCount]), SAY_COLOR_SYSTEM);
      exit;
   end;

   if ItemClass.GetItemData (aMakeName, MakeItemData) = false then begin
      FSendClass.SendChatMessage (Conv('无法交换'), SAY_COLOR_SYSTEM);
      exit;
   end;

   if FHaveItemClass.ViewItem (nPos, @ItemData) = false then begin
      FSendClass.SendChatMessage (format (Conv('交换 %s 需要 %s %d个'), [StrPas (@SmeltItemData.rName), StrPas (@SmeltItemData.rNeedItem), SmeltItemData.rNeedCount]), SAY_COLOR_SYSTEM);
      exit;
   end;

   if StrPas (@ItemData.rName) <> StrPas (@SmeltItemData.rNeedItem) then begin
      FSendClass.SendChatMessage (format (Conv('交换 %s 需要 %s %d个'), [StrPas (@SmeltItemData.rName), StrPas (@SmeltItemData.rNeedItem), SmeltItemData.rNeedCount]), SAY_COLOR_SYSTEM);
      exit;
   end;
   if ItemData.rCount < SmeltItemData.rNeedCount then begin
      FSendClass.SendChatMessage (format (Conv('交换 %s 需要 %s %d个'), [StrPas (@SmeltItemData.rName), StrPas (@SmeltItemData.rNeedItem), SmeltItemData.rNeedCount]), SAY_COLOR_SYSTEM);
      exit;
   end;

   FSmeltItem2 := aMakeName;

   aShowWindowClass.FCurrentWindow := swk_count;
   FSendClass.SendShowCount (DRAGACTION_SMELTITEM2, nPos, nPos, 10000, FSmeltItem2);
end;

function THaveJobClass.AddPickMineAmount (aID : Integer; var aSubData : TSubData) : Boolean;
var
   SubData : TSubData;
begin
   Result := false;

  // add by Orber at 2005-04-03 19:31:39
   FillChar(SubData,SizeOf(SubData),0);

   if FMinePickObjectID = 0 then FMinePickObjectID := aID;

   if FMinePickObjectID <> aID then begin
      FMinePickObjectID := aID;
      FMinePickAmount := 0;
   end;

   FMinePickAmount := FMinePickAmount + (aSubData.HitData.PickConst * FToolConst);
   if FMinePickAmount > 100 then begin
      FMinePickAmount := FMinePickAmount - 100;

      SubData.ItemData.rName [0] := 0;
      SetWordString (SubData.SayString, FToolName);
      //Author:Steven Date: 2005-02-03 13:54:13
      //Note:采集技能
      //这里所传递的是角色的采集技能和技能经验值
      SubData.ExpData.ExpType := aSubData.ExpData.ExpType;
      SubData.ExpData.Exp := aSubData.ExpData.Exp;
      //========================================
      FBasicObject.SendLocalMessage (FMinePickObjectID, FM_DECDEPOSIT, FBasicObject.BasicData, SubData);

      if SubData.ItemData.rName [0] = 0 then exit;
      if FHaveItemClass.AddItem (SubData.ItemData) = false then begin
         FSendClass.SendChatMessage(Conv('持有的物品太多'), SAY_COLOR_SYSTEM);
         exit;
      end;
      FSendClass.SendSideMessage(format (Conv('采到%s %d个'), [StrPas (@SubData.ItemData.rName), SubData.ItemData.rCount]));

      Result := true;
   end;
end;

procedure THaveJobClass.ChangeJobTool (var ItemData : TItemData);
begin
   if (ItemData.rName [0] = 0) or (ItemData.rHitType <> HITTYPE_PICK) then begin
      FToolName := '';
      FillChar (FToolMagic, SizeOf (TMagicData), 0);
      exit;
   end;

   FToolName := StrPas (@ItemData.rName);
   MagicClass.GetMagicData (FToolName, FToolMagic, 0);
end;

procedure THaveJobClass.SetVirtueman;
var
   Str : String;
begin
   FAttribClass.AttribData.Talent := GetExpOverLevel (9999);
   FAttribClass.AttribData.cTalent := GetLevel (FAttribClass.AttribData.Talent);
   FJobGrade := JobClass.GetJobGrade (FAttribClass.Talent);

   Str := format (Conv('%s 恭喜你'), [StrPas (@FBasicObject.BasicData.Name)]) + ',';
   Str := Str + Conv('升为神工');
   UserList.SendTopMessage (Str);
end;

procedure THaveJobClass.SetJobKind (aKind : Byte);
var
   Str : String;
   ItemData : TItemData;
begin
   if (aKind <= JOB_KIND_NONE) or (aKind > JOB_KIND_CRAFTSMAN) then exit;

   {
   ToolName := JobClass.GetJobTool (aKind, tmpGrade);
   if ToolName = '' then exit;
   if ItemClass.GetItemData (ToolName, FJobTool) = false then exit;
   }

   FJobKind := aKind;
   FAttribClass.AttribData.Talent := 0;
   FAttribClass.AttribData.cTalent := GetLevel (0);
   FJobGrade := JobClass.GetJobGrade (FAttribClass.Talent);

   Str := GetJobToolStr;
   if Str <> '' then begin
      ItemClass.GetItemData (Str, ItemData);
      if ItemData.rName [0] <> 0 then begin
         FWorkSound := ItemData.rSoundEvent.rWavNumber;
      end;
   end;
end;

// ShowWindowClass;
constructor TShowWindowClass.Create (aUser : Pointer; aSendClass : TSendClass; aHaveItemClass : THaveItemClass;
   aHaveJobClass : THaveJobClass; aHaveMarketClass : THaveMarketClass);
begin
   FCurrentWindow := swk_none;
   FCurrentSubType := sst_none;

   FUser := aUser;
   FCommander := nil;

   FSendClass := aSendClass;
   FHaveItemClass := aHaveItemClass;
   FHaveJobClass := aHaveJobClass;
   FHaveMarketClass := aHaveMarketClass;
   
   FillChar (ExchangeData, SizeOf (TExchangeData), 0);
   FillChar (ItemLogData, SizeOf (TItemLogRecord) * 4, 0);

   UpdateItemLogTick := 0;

   CopyHaveItem := nil;

   CountWindowState := DRAGACTION_NONE;

   SaleNpc := nil;
   MarketUser := nil;

   CopyMarketDataList := TList.Create;
   SaleItemList := TList.Create;

   boActiveExchange := false;          
end;

destructor TShowWindowClass.Destroy;
var
   i : Integer;
   pCheckItem : PTCheckItem;
begin
   ClearCopyMarketDataList;
   CopyMarketDataList.Free;
   
   SaleNpc := nil;
   MarketUser := nil;

   if SaleItemList <> nil then begin
      for i := 0 to SaleItemList.Count - 1 do begin
         pCheckItem := SaleItemList.Items [i];
         if pCheckItem <> nil then Dispose (pCheckItem);
      end;
      SaleItemList.Clear;
      SaleItemList.Free;
   end;

   if CopyHaveItem <> nil then begin
      CopyHaveItem.Free;
      CopyHaveItem := nil;
   end;

   inherited Destroy;
end;

function TShowWindowClass.AddableExChangeData (pex : PTExChangedata): Boolean;
var
   i, cnt, excnt : integer;
begin
   Result := TRUE;

   cnt := 0;
   for i := 0 to HAVEITEMSIZE -1 do if FHaveItemClass.HaveItemArr[i].rName[0] = 0 then cnt := cnt + 1;

   excnt := 0;
   for i := 0 to 4-1 do if pex^.ritems[i].ritemcount <> 0 then excnt := excnt + 1;

   if cnt < excnt then Result := FALSE;
end;

procedure TShowWindowClass.AddExChangeData (var aSenderInfo : TBasicData; pex : PTExChangedata; aSenderIP : String);
var
   i : integer;
   ItemData : TItemData;
begin
   for i := 0 to 4 - 1 do begin
      if pEx^.rItems[i].rItemName <> '' then begin
         ItemClass.GetItemData (pex^.rItems[i].rItemName, ItemData);
         ItemData.rCount := pex^.rItems[i].rItemCount;
         ItemData.rColor := pex^.rItems[i].rColor;
//         StrPCopy (@ItemData.rCode, pex^.rItems [i].rCode);
         ItemData.rUpgrade := pex^.rItems [i].rUpgrade;
         ItemData.rCurDurability := pex^.rItems [i].rCurDurability;
         ItemData.rDurability := pex^.rItems [i].rDurability;
         ItemData.rAddType := pex^.rItems [i].rAddtype;
         SignToItem (ItemData, TUser (FUser).ServerID, aSenderInfo, aSenderIP);

         if ItemData.rUpgrade > 0 then JobClass.GetUpgradeItemLifeData (ItemData);
         if ItemData.rAddType <> 0 then ItemClass.GetAddItemAttribData (ItemData);
         FHaveItemClass.AddItem (ItemData);
      end;
   end;
end;

procedure TShowWindowClass.DelExChangeData (pex : PTExChangedata);
var
   key, j : integer;
   ItemData : TItemData;
begin
   for j := 0 to 4 - 1 do begin
      if pEx^.rItems[j].rItemName <> '' then begin
         key := pEx^.rItems[j].rKey;
         if StrPas (@FHaveItemClass.HaveItemArr[key].rName) = pex^.rItems[j].rItemName then begin
            if FHaveItemClass.HaveItemArr[key].rColor = pex^.rItems[j].rColor then begin
               if FHaveItemClass.HaveItemArr[key].rUpgrade = pex^.rItems[j].rUpgrade then begin
                  if FHaveItemClass.HaveItemArr[key].rAddType = pex^.rItems[j].rAddtype then begin
                     if FHaveItemClass.HaveItemArr[key].rCount >= pEx^.rItems[j].rItemCount then begin
                        ItemData.rOwnerName[0] := 0;
                        FHaveItemClass.DeleteKeyItem (key, pEx^.rItems[j].rItemCount, @ItemData);
                     end;
                  end;
               end;
            end;
         end;
      end;
   end;
end;

function TShowWindowClass.FindExChangeData (pex : PTExChangedata) : Boolean;
var
   key, j, nCount, tCount : integer;
begin
   Result := false;
                                                                 
   nCount := 0;
   for j := 0 to 4 - 1 do begin
      if pEx^.rItems[j].rItemName <> '' then begin
         inc (nCount);
      end;
   end;

   //林狼措惑
   if nCount = 0 then begin
      Result := true;
      exit;
   end;
   //////////

   tCount := 0;
   for j := 0 to 4 - 1 do begin
      if pEx^.rItems[j].rItemName <> '' then begin
         key := pEx^.rItems[j].rKey;
         if StrPas (@FHaveItemClass.HaveItemArr[key].rName) = pex^.rItems[j].rItemName then begin
            if FHaveItemClass.HaveItemArr[key].rColor = pex^.rItems[j].rColor then begin
               if FHaveItemClass.HaveItemArr[key].rUpgrade = pex^.rItems[j].rUpgrade then begin
                  if FHaveItemClass.HaveItemArr[key].rAddType = pex^.rItems[j].rAddType then begin
                     if FHaveItemClass.HaveItemArr[key].rCount >= pEx^.rItems[j].rItemCount then begin
                            if FHaveItemClass.FindKeyExchangeItem (key, @pex^.rItems [j]) = false then exit;
                            inc (tCount);
                     end;
                  end;
               end;
            end;
         end;
      end;
   end;
   if nCount = tCount then Result := true;
end;

procedure TShowWindowClass.ExChangeStart (aId : Integer);
var
   BObject : TBasicObject;
   TempBasicData : TBasicData;
   SubData : TSubData;
   ExchangeUser, User : TUser;
   tmpExchangeData : TExchangeData;
begin
   User := TUser (FUser);

   if ExChangeData.rExChangeId <> 0 then begin
      User.SendLocalMessage ( ExChangeData.rExChangeId, FM_CANCELEXCHANGE, User.BasicData, SubData);
      User.SendLocalMessage ( User.BasicData.id, FM_CANCELEXCHANGE, User.BasicData, SubData);
   end;

   BObject := TBasicObject (User.SendLocalMessage ( aid, FM_GIVEMEADDR, User.BasicData, SubData));
   if (Integer (BObject) = 0) or (integer(BObject) = -1) then exit;

   ExChangeUser := TUser (BObject);
   ExchangeUser.GetExchangeData (tmpExchangeData);

   if tmpExChangeData.rExChangeId <> 0 then begin
      FSendClass.SendChatMessage (StrPas (@ExChangeUser.BasicData.Name) + Conv('对方正与其它玩家进行交易'), SAY_COLOR_SYSTEM);
      exit;
   end;

   FillChar (ExChangeData, sizeof(ExChangeData), 0);
   FillChar (tmpExChangeData, sizeof(ExChangeData), 0);

   ExChangeData.rExChangeId := aid;
   ExChangeData.rExChangeName := StrPas (@ExchangeUser.BasicData.Name);

   tmpExChangeData.rExChangeId := User.BasicData.id;
   tmpExChangeData.rExChangeName := StrPas (@User.BasicData.Name);
   ExchangeUser.SetExchangeData (tmpExchangeData);

   User.SendLocalMessage ( ExChangeData.rExChangeId, FM_SHOWEXCHANGE, User.BasicData, SubData);
   TempBasicData.id := ExChangeData.rExChangeId;                                           // 巩力乐澜.
   User.SendLocalMessage ( User.BasicData.Id, FM_SHOWEXCHANGE, TempBasicData, SubData);
end;

function TShowWindowClass.isCheckExChangeData : Boolean;
var
   i, j : integer;
   bo : Boolean;
begin
   Result := TRUE;

   for j := 0 to 4 - 1 do begin
      bo := FALSE;
      for i := 0 to HAVEITEMSIZE-1 do begin
         if StrPas (@FHaveItemClass.HaveItemArr[i].rName) = ExChangeData.rItems[j].rItemName then begin
            if FHaveItemClass.HaveItemArr[i].rColor = ExChangeData.rItems[j].rColor then begin
               if FHaveItemClass.HaveItemArr [i].rUpgrade = ExchangeData.rItems [j].rUpgrade then begin
                  if FHaveItemClass.HaveItemArr [i].rDurability = ExchangeData.rItems [j].rDurability then begin
                     if FHaveItemClass.HaveItemArr [i].rCurDurability = ExchangeData.rItems [j].rCurDurability then begin
                        if FHaveItemClass.HaveItemArr[i].rCount >= ExChangeData.rItems[j].rItemCount then begin
  // add by Orber at 2004-10-10 18:50:51
                            if FHaveItemClass.HaveItemArr[i].rLockState = 0 then begin
                               ExChangeData.rItems[j].rkey := i;
                               bo := TRUE;
                               break;
                            end;
                        end;
                     end;
                  end;
               end;
            end;
         end;
      end;
      if bo = FALSE then Result := FALSE;
   end;
end;

// add by Orber at 2004-09-08 16:24
procedure TShowWindowClass.Update (CurTick : integer);
var i,j :integer;
    ItemData :TItemData;
begin
   if UpdateItemLogTick = 0 then UpdateItemLogTick := CurTick;
   if frmMain.chkSaveUserData.Checked then begin
        if UpdateItemLogTick + 60 * 100 < CurTick then begin
            for i := 0 to 4 - 1  do begin
                if ItemLogData[i].Header.boUsed = false then continue;
                for j := 0 to 10 - 1 do begin
                    if ItemLogData[i].ItemData[j].Name[0] = 0 then continue;
                    if ItemLogData[i].ItemData[j].rLockState = 2 then begin
                        Inc(ItemLogData[i].ItemData[j].runLockTime);
                        if ItemLogData[i].ItemData[j].runLockTime >= INI_ITEMUNLOCKTIME then begin
                            ItemLogData[i].ItemData[j].rLockState := 0;
                            ItemLogData[i].ItemData[j].runLockTime := 0;
                            ItemClass.GetItemData (StrPas (@ItemLogData[i].ItemData[j].Name), ItemData);
                            ItemData.rColor := ItemLogData[i].ItemData[j].Color;
                            ItemData.rCount := ItemLogData[i].ItemData[j].Count;
                            ItemData.rUpgrade := ItemLogData[i].ItemData[j].UpGrade;
                            ItemData.rAddType := ItemLogData[i].ItemData[j].AddType;
                            ItemData.rDurability := ItemLogData[i].ItemData[j].Durability;
                            ItemData.rCurDurability := ItemLogData[i].ItemData[j].CurDurability;
                            ItemData.rLockState := ItemLogData[i].ItemData[j].rLockState;
                            ItemData.runLockTime := ItemLogData[i].ItemData[j].runLockTime;

                            FSendClass.SendSsamzieItem (i * 10 + j,ItemData);
                        end;
                    end;
                end;
            end;
        UpdateItemLogTick := CurTick;
        end;
   end;


end;

procedure TShowWindowClass.SelectMarketCount (pcMarketCount : PTCSelectMarketCount);
var
   srcKey, destKey : Integer;
   ItemData : TItemData;
   User : TUser;
   usd : TStringData;
   cnt : Integer;
begin
   if (NATION_VERSION = NATION_CHINA_1) or (NATION_VERSION = NATION_CHINA_1_TEST) then exit;
   
   if pcMarketCount^.rboOk = false then begin
      exit;
   end;
   if pcMarketCount^.rCount <= 0 then begin
      TUser (FUser).SendClass.SendChatMessage (Conv('请正确输入数量'), SAY_COLOR_SYSTEM);
      exit;
   end;
   if pcMarketCount^.rCount > 10000 then begin
      TUser (FUser).SendClass.SendChatMessage (Conv('超出数量'), SAY_COLOR_SYSTEM);
      exit;
   end;
   if pcMarketCount^.rCost <= 0 then begin
      TUser (FUser).SendClass.SendChatMessage (Conv('请正确输入价格'), SAY_COLOR_SYSTEM);
      exit;
   end;
   if pcMarketCount^.rCost > 30000000 then begin
      TUser (FUser).SendClass.SendChatMessage (Conv('超出价格'), SAY_COLOR_SYSTEM);
      exit;
   end;
   
   User := TUser (FUser);

   srcKey := pcMarketCount^.rsourkey;
   destKey := pcMarketCount^.rdestkey;

   if not FHaveItemClass.ViewItem (srcKey, @ItemData) then exit;
   if (ItemData.rboNotTrade = true) or (ItemData.rboNotExchange = true) or
      (ItemData.rboNotDrop = true) or (ItemData.rboNotSsamzie = true) or
      (ItemData.rboNotSkill = true) then begin
      FSendClass.SendChatMessage(Conv('禁止交易的物品'),SAY_COLOR_SYSTEM);
      exit;
   end;

   if pcMarketCount^.rCount > ItemData.rCount then exit;

   if FHaveMarketClass.CheckAddableMarketData (ItemData) < 0 then begin
      FSendClass.SendChatMessage (Conv('无法继续添加'), SAY_COLOR_SYSTEM);
      exit;
   end;
   ItemData.rCount := pcMarketCount^.rCount;
   ItemData.rPrice := pcMarketCount^.rCost;
   StrPCopy (@ItemData.rOwnerName, Conv('@我的贩卖窗'));
   ItemData.rOwnerServerID := User.ServerID;
   ItemData.rOwnerX := User.BasicData.x;
   ItemData.rOwnerY := User.BasicData.y;
   if FHaveItemClass.DeletekeyItem (srcKey, pcMarketCount^.rCount, @ItemData) = false then exit;
   if FHaveMarketClass.AddMarketItem (ItemData) = false then exit;

   usd.rmsg := 3;
   SetWordString (usd.rWordString, format ('MyMarket:%s:%d,%d,%d,%s', [StrPas (@ItemData.rName), ItemData.rUpgrade, ItemData.rCount, ItemData.rPrice, TUser (User).Name]));
   cnt := sizeof(usd) - sizeof(TWordString) + sizeofwordstring (usd.rwordstring);
   FrmSockets.UdpObjectAddData (cnt, @usd);
end;

procedure TShowWindowClass.PutOnMaterialCount (pcCount : PTCSelectCount);
var
   srcKey, destKey : Integer;
   ItemData : TItemData;
begin
   if CountWindowState <> DRAGACTION_FROMITEMTOSKILL then exit;
   if FCurrentWindow <> swk_count then exit;
   // The client closes its quantity dialog immediately after submitting.
   // A rejected or cancelled confirmation must release this action too.
   try
      if not pcCount^.rboOk then exit;
      if (pcCount^.rCount <= 0) or (pcCount^.rCount > 10000) then exit;
      if not TUser (FUser).AllowMaterialMove (swk_count) then exit;
      srcKey := pcCount^.rsourkey;
      destKey := pcCount^.rdestkey;
      if (destKey < 0) or (destKey > PRODUCT_KEY) then exit;
      // Inventory may have changed while the quantity dialog was open.
      if not FHaveItemClass.ViewItem (srcKey, @ItemData) then exit;
      if ItemData.rLockState <> 0 then begin
         FSendClass.SendChatMessage (Conv('物品锁定中,无法升级.'), SAY_COLOR_SYSTEM);
         exit;
      end;
      if ItemData.rboNotSkill then begin
         FSendClass.SendChatMessage (Conv('不能放入的物品'), SAY_COLOR_SYSTEM);
         exit;
      end;
      if pcCount^.rCount > ItemData.rCount then exit;
      ItemData.rCount := pcCount^.rCount;
      if destKey = PRODUCT_KEY then begin
         if (ItemData.rMaxUpgrade = 0) or (ItemData.rCount <> 1) then exit;
         if not FHaveJobClass.CheckProductBlankData then exit;
      end else begin
         if FHaveJobClass.CheckMaterialBlankData (ItemData) < 0 then exit;
      end;
      StrPCopy (@ItemData.rOwnerName, Conv('@技术窗'));
      if not FHaveItemClass.DeletekeyItem (srcKey, pcCount^.rCount, @ItemData) then exit;
      if destKey = PRODUCT_KEY then begin
         if not FHaveJobClass.AddKeyMaterialItem (destKey, ItemData) then exit;
      end else begin
         if not FHaveJobClass.AddMaterialItem (ItemData) then exit;
      end;
   finally
      CountWindowState := DRAGACTION_NONE;
      FCurrentWindow := swk_none;
      FCurrentSubType := sst_none;
   end;
end;

procedure TShowWindowClass.SelectCount (pcCount : PTCSelectCount);
var
   i, ret, srcKey, destKey, Price, nCount, RealPrice : integer;
   ItemData, tmpItemData : TItemData;
   SmeltItemData : TSmeltItemData;
   User, tempUser : TUser;
   TempBasicData : TBasicData;
   SubData : TSubData;
   boFlag : boolean;
   pMarketItem : PTIndividualMarketItem;
   GuildObject : TGuildObject;
begin
   if pcCount^.rCountid = DRAGACTION_FROMITEMTOSKILL then begin
      PutOnMaterialCount (pcCount);
      exit;
   end;
   if pccount^.rboOk = FALSE then begin
      CountWindowState := DRAGACTION_NONE;
      if (FCurrentWindow <> swk_exchange) and (FCurrentWindow <> swk_itemlog)
         and (FCurrentWindow <> swk_help) and (FCurrentWindow <> swk_trade)
         and (FCurrentWindow <> swk_sale) and (FCurrentWindow <> swk_individualmarket) then begin
         FCurrentWindow := swk_none;
         FCurrentSubType := sst_none;
      end;
      exit;
   end;

   if pccount^.rCount <= 0 then begin
      TUser (FUser).SendClass.SendChatMessage (Conv('请正确输入数量'), SAY_COLOR_SYSTEM);
      exit;
   end;

   if pccount^.rCount > 10000 then begin
      TUser (FUser).SendClass.SendChatMessage (Conv('超出数量'), SAY_COLOR_SYSTEM);
      if (FCurrentWindow <> swk_exchange) and (FCurrentWindow <> swk_itemlog)
         and (FCurrentWindow <> swk_help) and (FCurrentWindow <> swk_trade)
         and (FCurrentWindow <> swk_sale) and (FCurrentWindow <> swk_individualmarket) then begin
         FCurrentWindow := swk_none;
         FCurrentSubType := sst_none;
      end;
      exit;
   end;

   User := TUser (FUser);

   // case CountWindowState of
   case pcCount^.rCountid of
      DRAGACTION_DROPITEM :
         begin
            if FCurrentWindow <> swk_count then exit;
            if not FHaveItemClass.ViewItem (pccount^.rsourkey, @ItemData) then exit;
            if pccount^.rCount <= 0 then begin
               FCurrentWindow := swk_none;
               FCurrentSubType := sst_none;
               exit;
            end;
            if ItemData.rboNotDrop = true then begin
               FSendClass.SendChatMessage(Conv('不能丢在地下的物品'),SAY_COLOR_SYSTEM);
               exit; //2002-10-15
            end;
            //add by Orber at 2004-09-07 15:34
            if ItemData.rLockState <> 0 then begin
               FSendClass.SendChatMessage(Conv('装备锁定或正在解锁中，不能丢弃'),SAY_COLOR_SYSTEM);
               exit;
            end;
            if Itemdata.rCount >= pccount^.rCount then begin
               SignToItem (ItemData, User.ServerID, User.BasicData, User.IP);
               ItemData.rCount := pccount^.rCount;
               SubData.ItemData := ItemData;
               SubData.ServerId := User.ServerID;
               SubData.PowerLevel := User.PowerLevel;
               ret := User.Phone.SendMessage (MANAGERPHONE, FM_ADDITEM, User.BasicData, SubData);
               if ret = PROC_TRUE then begin
                  TempBasicData.Feature.rrace := RACE_NPC;
                  StrPCopy(@TempBasicData.Name, Conv('地面'));
                  TempBasicData.x := User.BasicData.x;
                  TempBasicData.y := User.BasicData.y;
                  SignToItem (ItemData, User.ServerID, TempBasicData, '');
                  FHaveItemClass.DeleteKeyItem (pccount^.rsourkey, ItemData.rCount, @ItemData);
               end else if ret = PROC_DONTDROP then begin
                  FSendClass.SendChatMessage (Conv ('无此权限'), SAY_COLOR_SYSTEM);
               end else begin
                  FSendClass.SendChatMessage (Conv('无法放在这个地方。'), SAY_COLOR_SYSTEM);
               end;
            end;
            FCurrentWindow := swk_none;
            FCurrentSubType := sst_none;
         end;
      DRAGACTION_ADDEXCHANGEITEM :
         begin
            if FCurrentWindow <> swk_exchange then exit;
            if not FHaveItemClass.ViewItem (pccount^.rsourkey, @ItemData) then exit;
            if ItemData.rLockState <> 0 then begin
               FSendClass.SendChatMessage (Conv('物品锁定中,无法交易.'), SAY_COLOR_SYSTEM);
               exit;
            end;
            if ItemData.rboNotExchange = true then begin
               FSendClass.SendChatMessage (Conv('无法交换的物品'), SAY_COLOR_SYSTEM);
               exit;
            end;
            for i := 0 to 4 - 1 do begin
               if StrPas (@ItemData.rName) = ExChangeData.rItems[i].rItemName then begin
                  if ItemData.rColor = ExChangeData.rItems[i].rColor then begin
                     if ItemData.rUpgrade = ExchangeData.rItems [i].rUpgrade then begin
                        if ItemData.rAddType = ExchangeData.rItems[i].rAddtype then begin
                           FSendClass.SendChatMessage (Conv('已经有同样名称的物品。'), 3);
                           exit;
                        end;
                     end;
                  end;
               end;
            end;
            ItemData.rcount := pccount^.rCount;

            TempUser := TUser (User.SendLocalMessage (ExChangeData.rExChangeId, FM_GIVEMEADDR, User.BasicData, SubData));
            if (Integer (TempUser) = 0) or (integer(TempUser) = -1) then begin
               FSendClass.SendChatMessage (Conv('交换对象不存在'), 3);
               exit;
            end;

            boFlag := false;
            for i := 0 to 4 - 1 do begin
               if ExChangeData.rItems[i].rItemCount = 0 then begin
                  ExChangeData.rItems[i].rIcon := ItemData.rShape;
                  ExChangeData.rItems[i].rItemName := StrPas (@ItemData.rName);
                  ExChangeData.rItems[i].rItemViewName := StrPas (@ItemData.rViewName);
                  ExChangeData.rItems[i].rItemcount := pccount^.rcount;
                  ExChangeData.rItems[i].rColor := ItemData.rcolor;
                  ExChangeData.rItems[i].rUpgrade := ItemData.rUpgrade;
                  ExChangeData.rItems[i].rCurDurability := ItemData.rCurDurability;
                  ExChangeData.rItems[i].rDurability := ItemData.rDurability;
                  ExChangeData.rItems[i].rAddtype := ItemData.rAddType;
                  boFlag := true;
                  break;
               end;
            end;

            if boFlag = false then begin
               FSendClass.SendChatMessage (Conv('无法再增加。'), 3);
               exit;
            end;

            if isCheckExChangeData then begin
               User.SendLocalMessage ( ExChangeData.rExChangeId, FM_SHOWEXCHANGE, User.BasicData, SubData);
               TempBasicData.id := ExChangeData.rExChangeId;
               User.SendLocalMessage ( User.BasicData.Id, FM_SHOWEXCHANGE, TempBasicData, SubData);
            end else begin
               User.SendLocalMessage ( ExChangeData.rExChangeId, FM_CANCELEXCHANGE, User.BasicData, SubData);
               TempBasicData.id := ExChangeData.rExChangeId;
               User.SendLocalMessage ( User.BasicData.Id, FM_CANCELEXCHANGE, TempBasicData, SubData);
            end;
         end;
      DRAGACTION_FROMITEMTOLOG :
         begin
            if FCurrentWindow <> swk_itemlog then exit;
            if CopyHaveItem = nil then exit;
            if not CopyHaveItem.ViewItem (pcCount^.rsourkey, @ItemData) then exit;
            if ItemData.rboNotSsamzie = true then begin
               FSendClass.SendChatMessage(Conv('不能放入福袋的物品'),SAY_COLOR_SYSTEM);
               exit;
            end;
            if ItemData.rCount < pcCount^.rCount then exit;

            if pcCount^.rdestkey < 10 then ret := 0
            else if pcCount^.rdestkey < 20 then ret := 1
            else if pcCount^.rdestkey < 30 then ret := 2
            else ret := 3;
            if ItemLogData[ret].Header.boUsed = false then exit;
            if ItemLogData[ret].ItemData[pcCount^.rdestkey mod 10].Name[0] <> 0 then begin
               if ItemData.rboDouble = false then exit;
               if StrPas (@ItemLogData[ret].ItemData[pcCount^.rdestkey mod 10].Name) <> StrPas (@ItemData.rName) then exit;
               if ItemLogData[ret].ItemData[pcCount^.rdestkey mod 10].Color <> ItemData.rColor then exit;
               if ItemLogData[ret].ItemData[pcCount^.rdestkey mod 10].UpGrade <> ItemData.rUpgrade then exit;
               if ItemLogData[ret].ItemData[pcCount^.rdestkey mod 10].AddType <> ItemData.rAddType then exit;
            end;

            if ItemLogData[ret].ItemData[pcCount^.rdestkey mod 10].Count + pcCount^.rCount > 10000 then begin
               TUser (FUser).SendClass.SendChatMessage (Conv('超出数量'), SAY_COLOR_SYSTEM);
               exit;
            end;

            if CopyHaveItem.DeleteKeyItem (pcCount^.rSourKey, pcCount^.rCount, @ItemData) = false then exit;

            StrCopy (@ItemLogData[ret].ItemData[pcCount^.rdestkey mod 10].Name, @ItemData.rName);
            ItemLogData[ret].ItemData[pcCount^.rdestkey mod 10].Color := ItemData.rColor;
            ItemLogData[ret].ItemData[pcCount^.rdestkey mod 10].Count := ItemLogData[ret].ItemData[pcCount^.rdestkey mod 10].Count + pcCount^.rCount;
            ItemLogData[ret].ItemData[pcCount^.rdestkey mod 10].UpGrade := ItemData.rUpGrade;
            ItemLogData[ret].ItemData[pcCount^.rdestkey mod 10].AddType := ItemData.rAddType;
            ItemLogData[ret].ItemData[pcCount^.rdestkey mod 10].Durability := ItemData.rDurability;
            ItemLogData[ret].ItemData[pcCount^.rdestkey mod 10].CurDurability := ItemData.rCurDurability;
            // StrCopy (@ItemLogData[ret].ItemData[pcCount^.rdestkey mod 10].Code, @ItemData.rCode);
            //add by Orber at 2004-09-08 14:11
            with ItemLogData[ret].ItemData[pcCount^.rdestkey mod 10] do
            begin
                if (rLockState = 1) or (ItemData.rLockState = 1) then begin
                  rLockState := 1;
                  ItemData.rLockState := 1;
                end else if (rLockState = 2) or (ItemData.rLockState = 2) then begin
                  rLockState := 2;
                  ItemData.rLockState := 2;
                end;

            end;
            ItemLogData[ret].ItemData[pcCount^.rdestkey mod 10].runLockTime := ItemData.runLockTime;


            ItemClass.GetItemData (StrPas (@ItemLogData[ret].ItemData[pcCount^.rdestkey mod 10].Name), ItemData);
            ItemData.rColor := ItemLogData[ret].ItemData[pcCount^.rdestkey mod 10].Color;
            ItemData.rCount := ItemLogData[ret].ItemData[pcCount^.rdestkey mod 10].Count;
            ItemData.rUpgrade := ItemLogData[ret].ItemData[pcCount^.rdestkey mod 10].Upgrade;
            ITemData.rAddType := ItemLogData[ret].ItemData[pcCount^.rdestkey mod 10].AddType;
            ItemData.rDurability := ItemLogData[ret].ItemData[pcCount^.rdestkey mod 10].Durability;
            ItemData.rCurDurability := ItemLogData[ret].ItemData[pcCount^.rdestkey mod 10].CurDurability;
            //add by Orber at 2004-09-08 14:11
            ItemData.rLockState := ItemLogData[ret].ItemData[pcCount^.rdestkey mod 10].rLockState;
            ItemData.runLockTime := ItemLogData[ret].ItemData[pcCount^.rdestkey mod 10].runLockTime;

            FSendClass.SendSsamzieItem (pcCount^.rdestkey, ItemData);
         end;
      DRAGACTION_FROMITEMTOGUILD :
         begin
            if FCurrentWindow <> swk_itemlog then exit;
//            if CopyHaveItem = nil then exit;
//            if not CopyHaveItem.ViewItem (pcCount^.rsourkey, @ItemData) then exit;
            FHaveItemClass.boLocked := False;
            if not FHaveItemClass.ViewItem(pcCount^.rsourkey, @ItemData) then exit;

            if ItemData.rboNotSsamzie = true then begin
               FSendClass.SendChatMessage(Conv('不能放入福袋的物品'),SAY_COLOR_SYSTEM);
               exit;
            end;
            if ItemData.rCount < pcCount^.rCount then exit;

           GuildObject := GuildList.GetGuildObject(TUser(FUser).GuildName);
           if GuildObject = nil then Exit;
           if Not GuildObject.IsGuildSysop(TUser(FUser).Name) then Exit;

            if GuildObject.FGuildItemLog.ItemData[pcCount^.rdestkey].Name[0] <> 0 then begin
               if ItemData.rboDouble = false then exit;
               if StrPas (@GuildObject.FGuildItemLog.ItemData[pcCount^.rdestkey].Name) <> StrPas (@ItemData.rName) then exit;
               if GuildObject.FGuildItemLog.ItemData[pcCount^.rdestkey].Color <> ItemData.rColor then exit;
               if GuildObject.FGuildItemLog.ItemData[pcCount^.rdestkey].UpGrade <> ItemData.rUpgrade then exit;
               if GuildObject.FGuildItemLog.ItemData[pcCount^.rdestkey].AddType <> ItemData.rAddType then exit;
            end;

            if GuildObject.FGuildItemLog.ItemData[pcCount^.rdestkey].Count + pcCount^.rCount > 10000 then begin
               TUser (FUser).SendClass.SendChatMessage (Conv('超出数量'), SAY_COLOR_SYSTEM);
               exit;
            end;

//             CopyHaveItem.DeleteKeyItem (pcCount^.rSourKey, pcCount^.rCount, @ItemData) = false then exit;
            if FHaveItemClass.DeletekeyItem(pcCount^.rSourKey, pcCount^.rCount, @ItemData) = false then exit;
            StrCopy (@GuildObject.FGuildItemLog.ItemData[pcCount^.rdestkey].Name, @ItemData.rName);
            GuildObject.FGuildItemLog.ItemData[pcCount^.rdestkey].Color := ItemData.rColor;
            GuildObject.FGuildItemLog.ItemData[pcCount^.rdestkey].Count := GuildObject.FGuildItemLog.ItemData[pcCount^.rdestkey].Count + pcCount^.rCount;
            GuildObject.FGuildItemLog.ItemData[pcCount^.rdestkey].UpGrade := ItemData.rUpGrade;
            GuildObject.FGuildItemLog.ItemData[pcCount^.rdestkey].AddType := ItemData.rAddType;
            GuildObject.FGuildItemLog.ItemData[pcCount^.rdestkey].Durability := ItemData.rDurability;
            GuildObject.FGuildItemLog.ItemData[pcCount^.rdestkey].CurDurability := ItemData.rCurDurability;
            // StrCopy (@ItemLogData[ret].ItemData[pcCount^.rdestkey mod 10].Code, @ItemData.rCode);
            //add by Orber at 2004-09-08 14:11
            with GuildObject.FGuildItemLog.ItemData[pcCount^.rdestkey] do
            begin
                if (rLockState = 1) or (ItemData.rLockState = 1) then begin
                  rLockState := 1;
                  ItemData.rLockState := 1;
                end else if (rLockState = 2) or (ItemData.rLockState = 2) then begin
                  rLockState := 2;
                  ItemData.rLockState := 2;
                end;

            end;
            GuildObject.FGuildItemLog.ItemData[pcCount^.rdestkey].runLockTime := ItemData.runLockTime;
            ItemClass.GetItemData (StrPas (@GuildObject.FGuildItemLog.ItemData[pcCount^.rdestkey].Name), ItemData);
            ItemData.rColor := GuildObject.FGuildItemLog.ItemData[pcCount^.rdestkey].Color;
            ItemData.rCount := GuildObject.FGuildItemLog.ItemData[pcCount^.rdestkey].Count;
            ItemData.rUpgrade := GuildObject.FGuildItemLog.ItemData[pcCount^.rdestkey].Upgrade;
            ITemData.rAddType := GuildObject.FGuildItemLog.ItemData[pcCount^.rdestkey].AddType;
            ItemData.rDurability := GuildObject.FGuildItemLog.ItemData[pcCount^.rdestkey].Durability;
            ItemData.rCurDurability := GuildObject.FGuildItemLog.ItemData[pcCount^.rdestkey].CurDurability;
            //add by Orber at 2004-09-08 14:11
            ItemData.rLockState := GuildObject.FGuildItemLog.ItemData[pcCount^.rdestkey].rLockState;
            ItemData.runLockTime := GuildObject.FGuildItemLog.ItemData[pcCount^.rdestkey].runLockTime;

            FSendClass.SendGuildItem (pcCount^.rdestkey, ItemData);
            FillChar(ItemData,SizeOf(ItemData),0);
         end;
      DRAGACTION_FROMLOGTOITEM :
         begin
            if FCurrentWindow <> swk_itemlog then exit;
            if CopyHaveItem = nil then exit;

            if pcCount^.rsourkey < 10 then ret := 0
            else if pcCount^.rsourkey < 20 then ret := 1
            else if pcCount^.rsourkey < 30 then ret := 2
            else ret := 3;
            if ItemLogData[ret].Header.boUsed = false then exit;
            if ItemLogData[ret].ItemData[pcCount^.rsourkey mod 10].Name[0] = 0 then exit;
            if ItemLogData[ret].ItemData[pcCount^.rsourkey mod 10].Count < pcCount^.rCount then exit;

            CopyHaveItem.ViewItem (pcCount^.rdestkey, @ItemData);
            if ItemData.rName [0] <> 0 then begin
               if ItemData.rboDouble = false then exit;
               if StrPas (@ItemLogData[ret].ItemData[pcCount^.rsourkey mod 10].Name) <> StrPas (@ItemData.rName) then exit;
               if ItemData.rColor <> ItemLogData[ret].ItemData[pcCount^.rsourkey mod 10].Color then exit;
               if ItemData.rUpgrade <> ItemLogData[ret].ItemData[pcCount^.rsourkey mod 10].Upgrade then exit;
               if ItemData.rAddtype <> ItemLogData[ret].ItemData[pcCount^.rsourkey mod 10].AddType then exit;
               //if ItemData.rLockState <> ItemLogData[ret].ItemData[pcCount^.rsourkey mod 10].rLockState then exit;
            end;

            ItemLogData[ret].ItemData[pcCount^.rsourkey mod 10].Count := ItemLogData[ret].ItemData[pcCount^.rsourkey mod 10].Count - pcCount^.rCount;

            ItemClass.GetItemData (StrPas (@ItemLogData[ret].ItemData[pcCount^.rsourkey mod 10].Name), ItemData);
            ItemData.rColor := ItemLogData[ret].ItemData[pcCount^.rsourkey mod 10].Color;
            ItemData.rCount := pcCount^.rCount;
            ItemData.rUpgrade := ItemLogData[ret].ItemData[pcCount^.rsourkey mod 10].UpGrade;
            ItemData.rAddType := ItemLogData[ret].ItemData[pcCount^.rsourkey mod 10].AddType;            
            ItemData.rCurDurability := ItemLogData[ret].ItemData[pcCount^.rsourkey mod 10].CurDurability;
            ItemData.rDurability := ItemLogData[ret].ItemData[pcCount^.rsourkey mod 10].Durability;                        
            // StrCopy (@ItemData.rCode, @ItemLogData [ret].ItemData[pcCount^.rsourkey mod 10].Code);

            if ItemData.rUpgrade > 0 then JobClass.GetUpgradeItemLifeData (ItemData);
            if ItemData.rAddType > 0 then ItemClass.GetAddItemAttribData (ItemData);
            //add by Orber at 2004-09-08 14:11
//            if ItemData.rLockState <= ItemLogData[ret].ItemData[pcCount^.rsourkey mod 10].rLockState then
            ItemData.rLockState := ItemLogData[ret].ItemData[pcCount^.rsourkey mod 10].rLockState;
            ItemData.runLockTime := ItemLogData[ret].ItemData[pcCount^.rsourkey mod 10].runLockTime;

            if CopyHaveItem.AddKeyItem (pcCount^.rdestkey, ItemData) = false then exit;

            if ItemLogData[ret].ItemData[pcCount^.rsourkey mod 10].Count <= 0 then begin
               FillChar (ItemLogData[ret].ItemData[pcCount^.rsourkey mod 10], SizeOf (TItemLogData), 0);
            end;
            ItemClass.GetItemData (StrPas (@ItemLogData[ret].ItemData[pcCount^.rsourkey mod 10].Name), ItemData);
            ItemData.rColor := ItemLogData[ret].ItemData[pcCount^.rsourkey mod 10].Color;
            ItemData.rCount := ItemLogData[ret].ItemData[pcCount^.rsourkey mod 10].Count;
            ItemData.rUpgrade := ItemLogData[ret].ItemData[pcCount^.rsourkey mod 10].UpGrade;
            ItemData.rAddType := ItemLogData[ret].ItemData[pcCount^.rsourkey mod 10].AddType;
            ItemData.rDurability := ItemLogData[ret].ItemData[pcCount^.rsourkey mod 10].Durability;
            ItemData.rCurDurability := ItemLogData[ret].ItemData[pcCount^.rsourkey mod 10].CurDurability;
            //add by Orber at 2004-09-08 14:11
            ItemData.rLockState := ItemLogData[ret].ItemData[pcCount^.rsourkey mod 10].rLockState;
            ItemData.runLockTime := ItemLogData[ret].ItemData[pcCount^.rsourkey mod 10].runLockTime;

            FSendClass.SendSsamzieItem (pcCount^.rsourkey, ItemData);
         end;
  // add by Orber at 2005-01-06 14:01:48
        DRAGACTION_FROMGUILDTOITEM :
         begin
            if FCurrentWindow <> swk_itemlog then exit;

            FHaveItemClass.ViewItem (pcCount^.rdestkey, @ItemData);
            FHaveItemClass.boLocked := False;
           GuildObject := GuildList.GetGuildObject(TUser(FUser).GuildName);
           if GuildObject = nil then Exit;
           if Not GuildObject.IsGuildSysop(TUser(FUser).Name) then Exit;

            if ItemData.rName [0] <> 0 then begin
               if ItemData.rboDouble = false then exit;
               if StrPas (@GuildObject.FGuildItemLog.ItemData[pcCount^.rsourkey].Name) <> StrPas (@ItemData.rName) then exit;
               if ItemData.rColor <> GuildObject.FGuildItemLog.ItemData[pcCount^.rsourkey].Color then exit;
               if ItemData.rUpgrade <> GuildObject.FGuildItemLog.ItemData[pcCount^.rsourkey].Upgrade then exit;
               if ItemData.rAddtype <> GuildObject.FGuildItemLog.ItemData[pcCount^.rsourkey].AddType then exit;
               //if ItemData.rLockState <> ItemLogData[ret].ItemData[pcCount^.rsourkey mod 10].rLockState then exit;
            end;

            GuildObject.FGuildItemLog.ItemData[pcCount^.rsourkey].Count := GuildObject.FGuildItemLog.ItemData[pcCount^.rsourkey].Count - pcCount^.rCount;

            ItemClass.GetItemData (StrPas (@GuildObject.FGuildItemLog.ItemData[pcCount^.rsourkey].Name), ItemData);
            ItemData.rColor := GuildObject.FGuildItemLog.ItemData[pcCount^.rsourkey].Color;
            ItemData.rCount := pcCount^.rCount;
            ItemData.rUpgrade := GuildObject.FGuildItemLog.ItemData[pcCount^.rsourkey].UpGrade;
            ItemData.rAddType := GuildObject.FGuildItemLog.ItemData[pcCount^.rsourkey].AddType;
            ItemData.rCurDurability := GuildObject.FGuildItemLog.ItemData[pcCount^.rsourkey].CurDurability;
            ItemData.rDurability := GuildObject.FGuildItemLog.ItemData[pcCount^.rsourkey].Durability;
            if ItemData.rUpgrade > 0 then JobClass.GetUpgradeItemLifeData (ItemData);
            if ItemData.rAddType > 0 then ItemClass.GetAddItemAttribData (ItemData);
            //add by Orber at 2004-09-08 14:11
            ItemData.rLockState := GuildObject.FGuildItemLog.ItemData[pcCount^.rsourkey].rLockState;
            ItemData.runLockTime := GuildObject.FGuildItemLog.ItemData[pcCount^.rsourkey].runLockTime;

            if FHaveItemClass.AddKeyItem (pcCount^.rdestkey, ItemData) = false then exit;

            if GuildObject.FGuildItemLog.ItemData[pcCount^.rsourkey].Count <= 0 then begin
               FillChar (GuildObject.FGuildItemLog.ItemData[pcCount^.rsourkey], SizeOf (TItemLogData), 0);
               FillChar (ItemData,SizeOf(ItemData),0);
            end;
            ItemData.rCount := GuildObject.FGuildItemLog.ItemData[pcCount^.rsourkey].Count ;
            FSendClass.SendGuildItem (pcCount^.rsourkey,ItemData);
         end;
      DRAGACTION_FROMITEMTOTRADE :
         begin
            if FCurrentWindow <> swk_trade then exit;
            if FCurrentSubType <> sst_buy then exit;
            if CopyHaveItem = nil then exit;

            srcKey := pcCount^.rsourkey;
            destKey := pcCount^.rdestkey;

            CopyHaveItem.ViewItem (srcKey, @ItemData);
            if ItemData.rName [0] = 0 then exit;
            if ItemData.rboNotTrade = true then exit;
            if pcCount^.rCount > ItemData.rCount then exit;
            if destKey >= TRADELISTMAX then exit;
            if StrPas (@TradeDataArr [destKey].rName) <> StrPas (@ItemData.rName) then exit;

            if TradeDataArr [destKey].rCount + pcCount^.rCount > 10000 then begin
               TUser (FUser).SendClass.SendChatMessage (Conv('超出数量'), SAY_COLOR_SYSTEM);
               exit;
            end;

            Price := ItemData.rBuyPrice * pcCount^.rCount;
            if (Price > 40000000) or (Price <= 0) then begin
               FSendClass.SendChatMessage (Conv ('不能再买了'), SAY_COLOR_SYSTEM);
               exit;
            end;

            ItemClass.GetItemData (INI_GOLD, tmpItemData);
            if tmpItemData.rName [0] = 0 then exit;
            tmpItemData.rCount := Price;

            if (tmpItemData.rLockState <> 0) then begin
               FSendClass.SendChatMessage (Conv('物品锁定中,无法交易.'), SAY_COLOR_SYSTEM);
               exit;
            end;

            if CopyHaveItem.CheckAddable (tmpItemData) < 0 then exit;

            ItemData.rCount := pcCount^.rCount;
            if CopyHaveItem.DeleteKeyItem (srcKey, pcCount^.rCount, @ItemData) = false then exit;

            CopyHaveItem.AddItem (tmpItemData);

            TradeDataArr [destKey].rCount := TradeDataArr [destKey].rCount + pcCount^.rCount;
            SetTradeItem;
         end;
      DRAGACTION_FROMTRADETOITEM :
         begin
            if FCurrentWindow <> swk_trade then exit;
            if FCurrentSubType <> sst_sell then exit;
            if CopyHaveItem = nil then exit;

            srcKey := pcCount^.rsourkey;
            destKey := pcCount^.rdestkey;

            if TradeDataArr [srcKey].rName [0] = 0 then exit;
            ItemClass.GetItemData (StrPas (@TradeDataArr [srcKey].rName), ItemData);
            if ItemData.rName [0] = 0 then exit;
            if CopyHaveItem.CheckAddable (ItemData) < 0 then exit;

            if (ItemData.rboDouble = false) and (pcCount^.rCount <> 1) then exit;

            Price := ItemData.rPrice * pcCount^.rCount;
            if (Price > 40000000) or (Price <= 0) then begin
               FSendClass.SendChatMessage (Conv ('不能再买了'), SAY_COLOR_SYSTEM); 
               exit;
            end;
                        
            if CopyHaveItem.HaveMoney < Price then begin
               FSendClass.SendChatMessage (Conv('持有的钱太少'), SAY_COLOR_SYSTEM);
               exit;
            end;

            if TradeDataArr [srcKey].rCount + pcCount^.rCount > 10000 then begin
               TUser (FUser).SendClass.SendChatMessage (Conv('超出数量'), SAY_COLOR_SYSTEM);
               exit;
            end;

            ItemData.rCount := pcCount^.rCount;
            if CopyHaveItem.AddKeyItem (destKey, ItemData) = false then begin
               if CopyHaveItem.AddItem (ItemData) = false then exit;
            end;

            if CopyHaveItem.PayMoney (Price) = false then exit;

            TradeDataArr [srcKey].rCount := TradeDataArr [srcKey].rCount + pcCount^.rCount;
            SetTradeItem;
         end;
      DRAGACTION_FROMITEMTOSKILL : PutOnMaterialCount (pcCount);
      DRAGACTION_FROMSKILLTOITEM :
         begin
            if FCurrentWindow <> swk_count then exit;
                     
            srcKey := pcCount^.rsourkey;
            destKey := pcCount^.rdestkey;

            if not FHaveJobClass.ViewMaterialItem (srcKey, @ItemData) then exit;
            if pcCount^.rCount > ItemData.rCount then begin
               FCurrentWindow := swk_none;
               FCurrentSubType := sst_none;
               exit;
            end;

            if FHaveItemClass.CheckAddable (ItemData) < 0 then exit;

            ItemData.rCount := pcCount^.rCount;

            if FHaveJobClass.DeletekeyMaterialItem (srcKey, pcCount^.rCount, @ItemData) = false then exit;

            if FHaveItemClass.AddKeyItem (destkey, ItemData) = false then begin
               if FHaveItemClass.AddItem (ItemData) = false then exit;
            end;
            FCurrentWindow := swk_none;
            FCurrentSubType := sst_none;
         end;
      DRAGACTION_FROMITEMTOSALE :
         begin
            if FCurrentWindow <> swk_sale then exit;
            if FCurrentSubType <> sst_salebuy then exit;

            if CopyHaveItem = nil then exit;

            srcKey := pcCount^.rsourkey;
            destKey := pcCount^.rdestkey;

            CopyHaveItem.ViewItem (srcKey, @ItemData);
            if ItemData.rName [0] = 0 then exit;
            if pcCount^.rCount > ItemData.rCount then exit;
            if destKey >= SALELISTMAX then exit;
            if StrPas (@SaleDataArr [destKey].rName) <> StrPas (@ItemData.rName) then exit;

            Price := ItemData.rBuyPrice * pcCount^.rCount;

            ItemClass.GetItemData (INI_GOLD, tmpItemData);
//            ItemClass.CreateItem (INI_GOLD, tmpItemData);
            if tmpItemData.rName [0] = 0 then exit;
            tmpItemData.rCount := Price;

            if (tmpItemData.rLockState <> 0) then begin
               FSendClass.SendChatMessage (Conv('物品锁定中,无法交易.'), SAY_COLOR_SYSTEM);
               exit;
            end;

            if SaleDataArr [destKey].rCount + pcCount^.rCount > 10000 then begin
               TUser (FUser).SendClass.SendChatMessage (Conv('超出数量'), SAY_COLOR_SYSTEM);
               exit;
            end;

            if CopyHaveItem.CheckAddable (tmpItemData) < 0 then exit;

            ItemData.rCount := pcCount^.rCount;
            if CopyHaveItem.DeleteKeyItem (srcKey, pcCount^.rCount, @ItemData) = false then exit;

            CopyHaveItem.AddItem (tmpItemData);

            SaleDataArr [destKey].rCount := SaleDataArr [destKey].rCount + pcCount^.rCount;

//            TNpc (SaleNpc).SaleSkill.AddItembyName (StrPas (@SaleDataArr [destKey].rName), pcCount^.rCount);
            AddSaleItem (StrPas (@SaleDataArr [destKey].rName), pcCount^.rCount); 
            SetSaleItem;
         end;
      DRAGACTION_FROMSALETOITEM :
         begin
            if FCurrentWindow <> swk_sale then exit;
            if FCurrentSubType <> sst_salesell then exit;

            if CopyHaveItem = nil then exit;

            srcKey := pcCount^.rsourkey;
            destKey := pcCount^.rdestkey;

            if SaleDataArr [srcKey].rName [0] = 0 then exit;
            ItemClass.GetItemData (StrPas (@SaleDataArr [srcKey].rName), ItemData);
            if ItemData.rName [0] = 0 then exit;
            if CopyHaveItem.CheckAddable (ItemData) < 0 then exit;

            if (ItemData.rboDouble = false) and (pcCount^.rCount <> 1) then exit;
            if SaleDataArr [srcKey].rTotalCount < pcCount^.rCount then exit;

            Price := ItemData.rPrice * pcCount^.rCount;

            if CopyHaveItem.HaveMoney < Price then begin
               FSendClass.SendChatMessage (Conv('持有的钱太少'), SAY_COLOR_SYSTEM);
               exit;
            end;

            if SaleDataArr [srcKey].rCount + pcCount^.rCount > 10000 then begin
               TUser (FUser).SendClass.SendChatMessage (Conv('超出数量'), SAY_COLOR_SYSTEM);
               exit;
            end;            

            {
            if TNpc (SaleNpc).SaleSkill.DelItembyName (StrPas (@ItemData.rName), pcCount^.rCount) = false then begin
               FSendClass.SendChatMessage (Conv ('数量不足'), SAY_COLOR_SYSTEM);
               exit;
            end;
            }
            ItemData.rCount := pcCount^.rCount;
            if CopyHaveItem.AddKeyItem (destKey, ItemData) = false then begin
               if CopyHaveItem.AddItem (ItemData) = false then exit;
            end;

            if CopyHaveItem.PayMoney (Price) = false then exit;

            SaleDataArr [srcKey].rTotalCount := SaleDataArr [srcKey].rTotalCount - pcCount^.rCount;
            SaleDataArr [srcKey].rCount := SaleDataArr [srcKey].rCount + pcCount^.rCount;

            AddSaleItem (StrPas (@SaleDataArr [srcKey].rName), pcCount^.rCount);
            SetSaleItem;
         end;
      DRAGACTION_SMELTITEM :
         begin
            if FCurrentWindow <> swk_count then exit;         
            if FHaveJobClass.FSmeltItem = '' then exit;

            if ItemClass.GetSmeltItemData (FHaveJobClass.FSmeltItem, SmeltItemData) = false then exit;
            if FHaveItemClass.ViewItem (pcCount^.rSourKey, @ItemData) = false then exit;
            if StrPas (@ItemData.rName) <> StrPas (@SmeltItemData.rNeedItem) then exit;
            if ItemClass.GetItemData (StrPas (@SmeltItemData.rName), tmpItemData) = false then exit;

            if ItemData.rCount < pcCount^.rCount * SmeltItemData.rNeedCount then begin
               FSendClass.SendChatMessage (format (Conv('%s 数量不足'), [StrPas (@ItemData.rName)]), SAY_COLOR_SYSTEM);
               FCurrentWindow := swk_none;
               FCurrentSubType := sst_none;
               exit;
            end;

            tmpItemData.rCount := pcCount^.rCount;
            ItemData.rCount := pcCount^.rCount * SmeltItemData.rNeedCount;
            Price := SmeltItemData.rPrice * pcCount^.rCount;
            if FHaveItemClass.HaveMoney < Price then begin
               FSendClass.SendChatMessage (format (Conv('提炼所需金额不足'), [Price]), SAY_COLOR_SYSTEM);
               FCurrentWindow := swk_none;
               FCurrentSubType := sst_none;
               exit;
            end;

            if FHaveItemClass.CheckAddable (tmpItemData) < 0 then begin
               FSendClass.SendChatMessage (Conv('物品窗空间已满'), SAY_COLOR_SYSTEM);
               FCurrentWindow := swk_none;
               FCurrentSubType := sst_none;
               exit;
            end;

            if FHaveItemClass.DeleteItem (@ItemData) = false then exit;
            if FHaveItemClass.PayMoney (Price) = false then exit;

            FHaveItemClass.AddItem (tmpItemData);

            FSendClass.SendSideMessage (format (Conv('%s 获得 %d个'), [StrPas (@tmpItemData.rName), tmpItemData.rCount]));
            FCurrentWindow := swk_none;
            FCurrentSubType := sst_none;
         end;
      DRAGACTION_SMELTITEM2 :
         begin
            if FCurrentWindow <> swk_count then exit;         
            if FHaveJobClass.FSmeltItem2 = '' then exit;

            if ItemClass.GetSmeltItemData2 (FHaveJobClass.FSmeltItem2, SmeltItemData) = false then exit;
            if FHaveItemClass.ViewItem (pcCount^.rSourKey, @ItemData) = false then exit;
            if StrPas (@ItemData.rName) <> StrPas (@SmeltItemData.rNeedItem) then exit;
            if ItemClass.GetItemData (StrPas (@SmeltItemData.rName), tmpItemData) = false then exit;

            if ItemData.rCount < pcCount^.rCount * SmeltItemData.rNeedCount then begin
               FSendClass.SendChatMessage (format (Conv('%s 数量不足'), [StrPas (@ItemData.rName)]), SAY_COLOR_SYSTEM);
               FCurrentWindow := swk_none;
               FCurrentSubType := sst_none;
               exit;
            end;

            tmpItemData.rCount := pcCount^.rCount;
            ItemData.rCount := pcCount^.rCount * SmeltItemData.rNeedCount;
            Price := SmeltItemData.rPrice * pcCount^.rCount;
            if FHaveItemClass.HaveMoney < Price then begin
               FSendClass.SendChatMessage (format (Conv('交易金额不足'), [Price]), SAY_COLOR_SYSTEM);
               FCurrentWindow := swk_none;
               FCurrentSubType := sst_none;
               exit;
            end;

            if FHaveItemClass.CheckAddable (tmpItemData) < 0 then begin
               FSendClass.SendChatMessage (Conv('物品窗空间已满'), SAY_COLOR_SYSTEM);
               FCurrentWindow := swk_none;
               FCurrentSubType := sst_none;
               exit;
            end;

            if FHaveItemClass.DeleteItem (@ItemData) = false then exit;
            if FHaveItemClass.PayMoney (Price) = false then exit;

            FHaveItemClass.AddItem (tmpItemData);

            FSendClass.SendSideMessage (format (Conv('%s 获得 %d个'), [StrPas (@tmpItemData.rName), tmpItemData.rCount]));
            FCurrentWindow := swk_none;
            FCurrentSubType := sst_none;
         end;
      DRAGACTION_FROMINDIVIDUALMARKETTOITEM :
         begin
            if (NATION_VERSION = NATION_CHINA_1) or (NATION_VERSION = NATION_CHINA_1_TEST) then exit;

            if FCurrentWindow <> swk_individualmarket then exit;
            if CopyHaveItem = nil then exit;

            if (MarketUser = nil) or (TUser (MarketUser).GetboMarketing = false) then begin
               FSendClass.SendChatMessage (Conv ('不在买卖状态'), SAY_COLOR_SYSTEM);
               MarketUser := nil;
               exit;
            end;
            
            srcKey := pcCount^.rsourkey;
            destKey := pcCount^.rdestkey;

            if (srcKey < 0) or (srcKey >= CopyMarketDataList.Count) then exit;
            pMarketItem := CopyMarketDataList.Items [srcKey];
            if pMarketItem = nil then exit;
                        
            if pMarketItem^.rName [0] = 0 then exit;
            ItemClass.GetItemData (StrPas (@pMarketItem^.rName), ItemData);
            if ItemData.rName [0] = 0 then exit;
            RealPrice := ItemData.rPrice;            

            ItemData.rcolor := pMarketItem^.rColor;
            ItemData.rPrice := pMarketItem^.rCost;
            ItemData.rCurDurability := pMarketItem^.rCurDurability;
            ItemData.rDurability := pMarketItem^.rDurability;
            ItemData.rUpgrade := pMarketItem^.rUpgrade;
            ItemData.rAddType := pMarketItem^.rAddType;

            JobClass.GetUpgradeItemLifeData (ItemData);
            ItemClass.GetAddItemAttribData (ItemData);            

            if CopyHaveItem.CheckAddable (ItemData) < 0 then exit;

            if (ItemData.rboDouble = false) and (pcCount^.rCount <> 1) then exit;
            if pMarketItem^.rTotalCount < pcCount^.rCount then exit;

            nCount := 100000000 div ItemData.rPrice;       // overflow锭巩俊 持篮内靛
            if nCount < pcCount^.rCount then begin
               FSendClass.SendChatMessage (Conv ('不能再买了'), SAY_COLOR_SYSTEM); 
               exit;
            end;

            Price := ItemData.rPrice * pcCount^.rCount;

            if CopyHaveItem.HaveMoney < Price then begin
               FSendClass.SendChatMessage (Conv('持有的钱太少'), SAY_COLOR_SYSTEM);
               exit;
            end;

            if pMarketItem^.rCount + pcCount^.rCount > 10000 then begin
               TUser (FUser).SendClass.SendChatMessage (Conv('超出数量'), SAY_COLOR_SYSTEM);
               exit;
            end;

            ItemData.rCount := pcCount^.rCount;
            ItemData.rPrice := RealPrice;             // 绊狼肺 1傈栏肺 颇绰巴 秦欧贸府锭巩俊 盔贰啊拜栏肺 倒覆  030828 saset             

            if TUser (MarketUser).SellItembyUser (ItemData, StrPas (@TUser (FUser).BasicData.Name)) = false then begin
               FSendClass.SendChatMessage (Conv ('购置的物品不存在或是数量不足'), SAY_COLOR_SYSTEM);
               MarketUser := nil;
               exit;
            end;

            ItemData.rPrice := RealPrice;             // 绊狼肺 1傈栏肺 颇绰巴 秦欧贸府锭巩俊 盔贰啊拜栏肺 倒覆  030828 saset

            StrPCopy (@ItemData.rOwnerIp, TUser (FUser).IP);
            if CopyHaveItem.AddKeyItem (destKey, ItemData) = false then begin
               if CopyHaveItem.AddItem (ItemData) = false then exit;
            end;

            if CopyHaveItem.PayMoney (Price) = false then exit;

            pMarketItem^.rTotalCount := pMarketItem^.rTotalCount - pcCount^.rCount;
            pMarketItem^.rCount := pMarketItem^.rCount + pcCount^.rCount;

            SetIndividualMarketItem;
         end;
      else exit;
   end;

//   if pcCount^.rCountid <> DRAGACTION_ADDEXCHANGEITEM then begin
//   end;
end;


procedure TShowWindowClass.ClickExChange (awin:byte; aclickedid:longInt; akey:word);
var
   boExChange : Boolean;
   BObject : TBasicObject;
   User, ExUser : TUser;
   TempBasicData : TBasicData;
   SubData : TSubData;
   tmpExchangeData : TExchangeData;
   Str : String;
begin
   User := TUser (FUser);
   if boActiveExchange = true then begin
      if FCurrentWindow <> swk_exchange then begin
         Str := format ('%s, CurWin: %d, WinSubType: %d, x, y: %d, %d', [User.Name,
            Integer(FCurrentWindow), Integer(FCurrentSubType), User.BasicData.x, User.BasicData.y]);
         str := str + ',' + 'ClickExchange (01)';
         frmMain.WriteBadUserLog(str);
         User.SendLocalMessage ( ExChangeData.rExChangeId, FM_CANCELEXCHANGE, User.BasicData, SubData);
         TempBasicData.id := ExChangeData.rExChangeId;
         User.SendLocalMessage ( User.BasicData.id, FM_CANCELEXCHANGE, TempBasicData, SubData);

         ConnectorList.CloseConnectByCharName (User.Name);
         exit;
      end;
   end;

   boExChange := TRUE;

   ExChangeData.rboCheck := not ExChangeData.rboCheck;

   if ExChangeData.rboCheck then begin
      BObject := TBasicObject (User.SendLocalMessage (ExChangeData.rExChangeId, FM_GIVEMEADDR, User.BasicData, SubData));
      if (Integer (BObject) = 0) or (integer(BObject) = -1) then begin
         boExChange := FALSE;
      end else begin
         if not (BObject is TUser) then boExChange := FALSE;
      end;

      if boExChange = FALSE then begin
         User.SendLocalMessage ( ExChangeData.rExChangeId, FM_CANCELEXCHANGE, User.BasicData, SubData);
         TempBasicData.id := ExChangeData.rExChangeId;
         User.SendLocalMessage ( User.BasicData.id, FM_CANCELEXCHANGE, TempBasicData, SubData);
         exit;
      end;

      ExUser := TUser (BObject);
      {
      if ExUser.GetCurrentWindow <> swk_exchange then begin
         Str := format ('%s, CurWin: %d, WinSubType: %d, x, y: %d, %d', [StrPas (@Exuser.BasicData.Name),
            Integer(ExUser.GetCurrentWindow), 0, ExUser.BasicData.x, ExUser.BasicData.y]);
         str := str + ',' + 'ClickExchange';
         frmMain.WriteBadUserLog(str);

         User.SendLocalMessage ( ExChangeData.rExChangeId, FM_CANCELEXCHANGE, User.BasicData, SubData);
         TempBasicData.id := ExChangeData.rExChangeId;
         User.SendLocalMessage ( User.BasicData.id, FM_CANCELEXCHANGE, TempBasicData, SubData);
         exit;
      end;
      }
      ExUser.GetExchangeData (tmpExchangeData);

      if tmpExChangeData.rboCheck then begin
         if isCheckExChangeData = FALSE then boExChange := FALSE;
         if ExUser.isCheckExChangeData = FALSE then boExChange := FALSE;
         if boExChange = FALSE then begin
            User.SendLocalMessage ( ExChangeData.rExChangeId, FM_CANCELEXCHANGE, User.BasicData, SubData);
            TempBasicData.id := ExChangeData.rExChangeId;
            User.SendLocalMessage ( User.BasicData.id, FM_CANCELEXCHANGE, TempBasicData, SubData);
            exit;
         end;

         if AddableExChangeData(@tmpExChangedata) = FALSE then boExChange := FALSE;
         if ExUser.AddableExChangeData(@ExChangeData) = FALSE then boExChange := FALSE;
         if boExChange = FALSE then begin
            User.SendLocalMessage ( ExChangeData.rExChangeId, FM_CANCELEXCHANGE, User.BasicData, SubData);
            TempBasicData.id := ExChangeData.rExChangeId;
            User.SendLocalMessage ( User.BasicData.id, FM_CANCELEXCHANGE, TempBasicData, SubData);
            exit;
         end;

         {
         if (ExUser.DelExChangeData(@tmpExChangeData) = false) or (DelExChangeData(@ExChangedata) = false) then boExchange := FALSE;
         if boExChange = FALSE then begin
            User.SendLocalMessage ( ExChangeData.rExChangeId, FM_CANCELEXCHANGE, User.BasicData, SubData);
            TempBasicData.id := ExChangeData.rExChangeId;
            User.SendLocalMessage ( User.BasicData.id, FM_CANCELEXCHANGE, TempBasicData, SubData);
            exit;
         end;
         }
         if FindExchangeData (@ExchangeData) = true then begin
            if ExUser.FindExChangeData (@tmpExchangeData) = true then begin
               if (ExUser.GetCurrentWindow = swk_exchange) and (User.GetCurrentWindow = swk_exchange) then begin
                  DelExChangeData(@ExChangedata);
                  ExUser.DelExChangeData(@tmpExChangeData);

                  AddExChangeData(ExUser.BasicData, @tmpExChangedata, ExUser.IP);
                  ExUser.AddExChangeData(User.BasicData, @ExChangeData, User.IP);
               end;
            end else begin
               Str := format ('%s, CurWin: %d, WinSubType: %d, x, y: %d, %d', [ExUser.Name,
                  Integer(FCurrentWindow), Integer(FCurrentSubType), ExUser.BasicData.x, ExUser.BasicData.y]);
               str := str + ',' + 'ClickExchange (02 exuserw)';
               frmMain.WriteBadUserLog(str);

               User.SendLocalMessage ( ExChangeData.rExChangeId, FM_CANCELEXCHANGE, User.BasicData, SubData);
               TempBasicData.id := ExChangeData.rExChangeId;
               User.SendLocalMessage ( User.BasicData.id, FM_CANCELEXCHANGE, TempBasicData, SubData);

               ConnectorList.CloseConnectByCharName (ExUser.Name);
            end;
         end else begin
            Str := format ('%s, CurWin: %d, WinSubType: %d, x, y: %d, %d', [User.Name,
               Integer(FCurrentWindow), Integer(FCurrentSubType), User.BasicData.x, User.BasicData.y]);
            str := str + ',' + 'ClickExchange (03 user)';
            frmMain.WriteBadUserLog(str);

            User.SendLocalMessage ( ExChangeData.rExChangeId, FM_CANCELEXCHANGE, User.BasicData, SubData);
            TempBasicData.id := ExChangeData.rExChangeId;
            User.SendLocalMessage ( User.BasicData.id, FM_CANCELEXCHANGE, TempBasicData, SubData);

            ConnectorList.CloseConnectByCharName (User.Name);
         end;

         User.SendLocalMessage (ExChangeData.rExChangeId, FM_CANCELEXCHANGE, User.BasicData, SubData);
         TempBasicData.id := ExChangeData.rExChangeId;
         User.SendLocalMessage (User.BasicData.id, FM_CANCELEXCHANGE, TempBasicData, SubData);
         exit;
      end;
   end;

   User.SendLocalMessage ( ExChangeData.rExChangeId, FM_SHOWEXCHANGE, User.BasicData, SubData);
   TempBasicData.id := ExChangeData.rExChangeId;
   User.SendLocalMessage ( User.BasicData.Id, FM_SHOWEXCHANGE, TempBasicData, SubData);
end;

function TShowWindowClass.GetCurrentWindowStr : String;
begin
   Result := '';
   Case FCurrentWindow of
      swk_none : Result := '';
      swk_exchange : Result := Conv('交换窗');
      swk_search : Result := Conv('探查窗');
      swk_count : Result := Conv('数量窗');
      swk_guildmagic : Result := Conv('门派武功申请窗');
      swk_bloodguild : Result := Conv('确认门派同盟窗');
      swk_itemlog : Result := Conv('保管窗');
      else Result := Conv('窗口');
   end;
end;

function TShowWindowClass.GetUserWindowStateStr : String;
var
   str : String;
   user : TUser;
begin
   Result := '';
   if FUser = nil then begin
      frmMain.WriteLogInfo('ShowWindowClass have Nil User Pointer');
      exit;
   end;

   user := TUser (FUser);
   Str := format ('%s, CurWin: %d, WinSubType: %d, x, y: %d, %d', [StrPas (@user.BasicData.Name),
      Integer(FCurrentWindow), Integer(FCurrentSubType), user.BasicData.x, user.BasicData.y]);
   Result := str;
end;

function TShowWindowClass.AllowWindowAction (aAllowWindowKind : TSpecialWindowKind) : Boolean;
begin
   Result := true;

   if FCurrentWindow <> aAllowWindowKind then begin
      FSendClass.SendChatMessage(CurrentWindowStr + Conv('已打开无法变更'), SAY_COLOR_SYSTEM);
      Result := false;
      exit;
   end;
end;

function TShowWindowClass.CheckExchangeBlankData (aItemData : TItemData) : Boolean;
var
   i : Integer;
begin
   Result := false;

   for i := 0 to 4 - 1 do begin
      if StrPas (@aItemData.rName) = ExChangeData.rItems[i].rItemName then begin
         if aItemData.rColor = ExChangeData.rItems[i].rColor then begin
            if aItemData.rAddType = ExchangeData.rItems[i].rAddType then begin
               if aItemData.rUpgrade = ExchangeData.rItems [i].rUpgrade then begin
                  FSendClass.SendChatMessage (Conv('此物品名已存在'), 3);
                  exit;
               end;
            end;
         end;
      end;
   end;

   for i := 0 to 4 - 1 do begin
      if ExChangeData.rItems[i].rItemCount = 0 then begin
         Result := true;
         exit;
      end;
   end;
   FSendClass.SendChatMessage (Conv('无法继续添加'), 3);
end;

procedure TShowWindowClass.PickUpScreenProcess (pcDragDrop : PTCDragDrop);
var
   BObject : TBasicObject;
   SubData : TSubData;
begin
   if TUser (FUser).BasicData.id = pcDragDrop^.rdestid then begin
      if pcDragDrop^.rsourid <> 0 then begin
         Bobject := TBasicObject (TUser (FUser).SendLocalMessage (pcDragDrop^.rsourid, FM_GIVEMEADDR, TUser (FUser).BasicData, SubData));
         if (Integer (BObject) = -1) or (Integer(BObject) = 0) then exit;
         if GetCellLength (TUser (FUser).BasicData.x, TUser (FUser).BasicData.y, BObject.Posx, BObject.Posy) > 3 then begin
            FSendClass.SendChatMessage (Conv('距离太远'), SAY_COLOR_SYSTEM);
            exit;
         end;
         TUser (FUser).Phone.SendMessage (pcDragDrop^.rsourid, FM_PICKUP, TUser (FUser).BasicData, SubData);
      end;
   end;
end;

procedure TShowWindowClass.PickUpItemWindowProcess (pcDragDrop : PTCDragDrop);
var
   SubData : TSubData;
   BObject : TBasicObject;
begin
   if pcDragDrop^.rsourid <> 0 then begin
      Bobject := TBasicObject (TUser (FUser).SendLocalMessage (pcDragDrop^.rsourid, FM_GIVEMEADDR, TUser (FUser).BasicData, SubData));
      if (Integer (BObject) = -1) or (Integer(BObject) = 0) then exit;
      if GetCellLength (TUser (FUser).BasicData.x, TUser (FUser).BasicData.y, BObject.Posx, BObject.Posy) > 3 then begin
         FSendClass.SendChatMessage (Conv('距离太远'), SAY_COLOR_SYSTEM);
         exit;
      end;
      TUser (FUser).Phone.SendMessage (pcDragDrop^.rsourid, FM_PICKUP, TUser (FUser).BasicData, SubData);
   end;
end;

procedure TShowWindowClass.FromItemLogToItemWindow (pcDragDrop : PTCDragDrop);
var
   ItemData : TItemData;
   ret : Integer;
   cSelectCount : TCSelectCount;
   str : String;
begin
   if FCurrentWindow <> swk_itemlog then begin
      str := GetUserWindowStateStr;
      str := str + ',' + 'FromItemLogToItemWindow';
      CopyHaveItem.Free;
      CopyHaveItem := nil;
      frmMain.WriteBadUserLog(str);
      ConnectorList.CloseConnectByCharName (TUser (FUser).Name);
      exit;
   end;

   if CopyHaveItem = nil then begin
      frmMain.WriteLogInfo (format ('CopyHaveItem = nil, FromItemLogToItemWindow, Name=%s', [TUser (FUser).Name]));
      exit;
   end;

   if pcDragDrop^.rsourkey < 10 then ret := 0
   else if pcDragDrop^.rsourkey < 20 then ret := 1
   else if pcDragDrop^.rsourkey < 30 then ret := 2
   else ret := 3;
   if ItemLogData[ret].Header.boUsed = false then exit;
   if ItemLogData[ret].ItemData[pcDragDrop^.rsourkey mod 10].Name[0] = 0 then exit;

   FillChar (ItemData, SizeOf (TItemData), 0);
   CopyHaveItem.ViewItem (pcDragDrop^.rdestkey, @ItemData);
   if ItemData.rName[0] <> 0 then begin
      if ItemData.rboDouble = false then exit;
      if StrPas (@ItemLogData[ret].ItemData[pcDragDrop^.rsourkey mod 10].Name) <> StrPas (@ItemData.rName) then exit;
      if ItemLogData[ret].ItemData[pcDragDrop^.rsourkey mod 10].Color <> ItemData.rColor then exit;
   end;

   if ItemLogData[ret].ItemData[pcDragDrop^.rsourkey mod 10].Count > 1 then begin
      ItemClass.GetItemData (StrPas (@ItemLogData[ret].ItemData[pcDragDrop^.rsourkey mod 10].Name), ItemData);
      FSendClass.SendShowCount (DRAGACTION_FROMLOGTOITEM, pcDragDrop^.rSourKey, pcDragDrop^.rDestKey, ItemLogData[ret].ItemData[pcDragDrop^.rsourkey mod 10].Count, StrPas (@ItemData.rViewName));
   end else begin
      cSelectCount.rboOk := true;
      cSelectCount.rsourkey := pcDragDrop^.rsourkey;
      cSelectCount.rdestkey := pcDragDrop^.rdestkey;
      cSelectCount.rCount := 1;
      cSelectCount.rCountid := DRAGACTION_FROMLOGTOITEM;
//      FCurrentWindow := swk_itemlog;
      SelectCount (@cSelectCount);
   end;
end;

procedure TShowWindowClass.FromGuildItemLogToItemWindow (pcDragDrop : PTCDragDrop);
var
   ItemData : TItemData;
   ret : Integer;
   cSelectCount : TCSelectCount;
   str : String;
   GuildObject : TGuildObject;
begin
   if FCurrentWindow <> swk_itemlog then begin
      str := GetUserWindowStateStr;
      str := str + ',' + 'FromGuildItemLogToItemWindow';
      frmMain.WriteBadUserLog(str);
      ConnectorList.CloseConnectByCharName (TUser (FUser).Name);
      exit;
   end;


   GuildObject := GuildList.GetGuildObject(TUser(FUser).GuildName);
   if GuildObject = nil then Exit;
   if Not GuildObject.IsGuildSysop(TUser(FUser).Name) then Exit;

   if pcDragDrop^.rsourkey >= 80 then Exit;

//   if GuildObject.FGuildItemLog.ItemData[pcDragDrop^.rsourkey].Name[0] <> 0 then Exit;

   FillChar (ItemData, SizeOf (TItemData), 0);
   FHaveItemClass.boLocked := False;
   FHaveItemClass.ViewItem (pcDragDrop^.rdestkey, @ItemData);
   if ItemData.rName[0] <> 0 then begin
      if ItemData.rboDouble = false then exit;
      if StrPas (@GuildObject.FGuildItemLog.ItemData[pcDragDrop^.rsourkey].Name) <> StrPas (@ItemData.rName) then exit;
      if GuildObject.FGuildItemLog.ItemData[pcDragDrop^.rsourkey].Color <> ItemData.rColor then exit;
   end;

   if GuildObject.FGuildItemLog.ItemData[pcDragDrop^.rsourkey].Count > 1 then begin
      ItemClass.GetItemData (StrPas (@GuildObject.FGuildItemLog.ItemData[pcDragDrop^.rsourkey].Name), ItemData);
      FSendClass.SendShowCount (DRAGACTION_FROMGUILDTOITEM, pcDragDrop^.rSourKey, pcDragDrop^.rDestKey, GuildObject.FGuildItemLog.ItemData[pcDragDrop^.rsourkey].Count, StrPas (@ItemData.rViewName));

   end else begin
      cSelectCount.rboOk := true;
      cSelectCount.rsourkey := pcDragDrop^.rsourkey;
      cSelectCount.rdestkey := pcDragDrop^.rdestkey;
      cSelectCount.rCount := 1;
      cSelectCount.rCountid := DRAGACTION_FROMGUILDTOITEM;
//      FCurrentWindow := swk_itemlog;
      SelectCount (@cSelectCount);
   end;
end;


procedure TShowWindowClass.FromTradeToItemWindow (pcDragDrop : PTCDragDrop);
var
   ItemData : TItemData;
   srcKey, destKey : Integer;
   cSelectCount : TCSelectCount;
   str : String;
begin
   if FCurrentWindow <> swk_trade then begin
      str := GetUserWindowStateStr;
      str := str + ',' + 'FromTradeToItemWindow';
      CopyHaveItem.Free;
      CopyHaveItem := nil;
      frmMain.WriteBadUserLog(str);
      ConnectorList.CloseConnectByCharName (TUser (FUser).Name);
      exit;
   end;
   
   if CopyHaveItem = nil then begin
      frmMain.WriteLogInfo (format ('CopyHaveItem = nil, FromTradeToItemWindow, Name=%s', [TUser (FUser).Name]));
      exit;
   end;
   if FCurrentWindow <> swk_trade then exit;
   if FCurrentSubType <> sst_sell then exit;

   srcKey := pcDragDrop^.rSourKey;
   destKey := pcDragDrop^.rDestKey;
   if TradeDataArr [srcKey].rName [0] = 0 then exit;
   ItemClass.GetItemData (StrPas (@TradeDataArr [srcKey].rName), ItemData);
   if ItemData.rName [0] = 0 then exit;

   if CopyHaveItem.CheckAddable (ItemData) < 0 then begin
      FSendClass.SendChatMessage (Conv('持有的物品太多'), SAY_COLOR_SYSTEM);
      exit;
   end;

   if ItemData.rboDouble = false then begin
      cSelectCount.rboOk := true;
      cSelectCount.rsourkey := pcDragDrop^.rsourkey;
      cSelectCount.rdestkey := pcDragDrop^.rdestkey;
      cSelectCount.rCount := 1;
      cSelectCount.rCountid := DRAGACTION_FROMTRADETOITEM;
      SelectCount (@cSelectCount);
      exit;
   end;

   FSendClass.SendShowCount (DRAGACTION_FROMTRADETOITEM, srcKey, destKey, 10000, StrPas (@ItemData.rViewName));
end;

procedure TShowWindowClass.FromItemToTradeWindow (pcDragDrop : PTCDragDrop);
var
   i, srcKey, destKey : Integer;
   ItemData : TItemData;
   cSelectCount : TCSelectCount;
   str : String;
begin
   if FCurrentWindow <> swk_trade then begin
      str := GetUserWindowStateStr;
      str := str + ',' + 'FromTradeToItemWindow';
      CopyHaveItem.Free;
      CopyHaveItem := nil;
      frmMain.WriteBadUserLog(str);
      ConnectorList.CloseConnectByCharName (TUser (FUser).Name);      
      exit;
   end;
   
   if CopyHaveItem = nil then begin
      frmMain.WriteLogInfo (format ('CopyHaveItem = nil, FromItemToTradeWindow, Name=%s', [TUser (FUser).Name]));
      exit;
   end;
   if FCurrentWindow <> swk_trade then exit;
   if FCurrentSubType <> sst_buy then exit;

   srcKey := pcDragDrop^.rSourKey;
   destKey := pcDragDrop^.rDestKey;

   CopyHaveItem.ViewItem (srcKey, @ItemData);
   if ItemData.rName [0] = 0 then exit;
   //2002-08-11 giltae 绊媚具瞪 家瘤啊 促盒茄 内靛.
   if ItemData.rboNotTrade = true then begin
      FSendClass.SendChatMessage (Conv('不能买到的物品'), SAY_COLOR_SYSTEM);
      exit;
   end;
   //------------------------

   destKey := -1;
   for i := 0 to TRADELISTMAX - 1 do begin
      if TradeDataArr [i].rName [0] = 0 then break;
      if StrPas (@TradeDataArr [i].rName) = StrPas (@ItemData.rName) then begin
         if ItemData.rUpgrade = 0 then begin
            destKey := i;
         end;
         break;
      end;
   end;
   if destKey = -1 then begin
      FSendClass.SendChatMessage (Conv('不买此种物品'), SAY_COLOR_SYSTEM);
      exit;
   end;

   if ItemData.rCount = 1 then begin
      cSelectCount.rboOk := true;
      cSelectCount.rsourkey := pcDragDrop^.rsourkey;
      cSelectCount.rdestkey := i;
      cSelectCount.rCount := 1;
      cSelectCount.rCountid := DRAGACTION_FROMITEMTOTRADE;
      SelectCount (@cSelectCount);
      exit;
   end;

   if ItemData.rCount > 10000 then begin
      FSendClass.SendShowCount (DRAGACTION_FROMITEMTOTRADE, srcKey, destKey, 10000, StrPas (@ItemData.rViewName));
   end else begin
      FSendClass.SendShowCount (DRAGACTION_FROMITEMTOTRADE, srcKey, destKey, ItemData.rCount, StrPas (@ItemData.rViewName));
   end;
end;

procedure TShowWindowClass.FromSaleToItemWindow (pcDragDrop : PTCDragDrop);
var
   ItemData : TItemData;
   srcKey, destKey : Integer;
   cSelectCount : TCSelectCount;
   str : String;
begin
   if FCurrentWindow <> swk_sale then begin
      str := GetUserWindowStateStr;
      str := str + ',' + 'FromSaleToItemWindow';
      CopyHaveItem.Free;
      CopyHaveItem := nil;
      frmMain.WriteBadUserLog(str);
      ConnectorList.CloseConnectByCharName (TUser (FUser).Name);
      exit;
   end;

   if CopyHaveItem = nil then begin
      frmMain.WriteLogInfo (format ('CopyHaveItem = nil, FromSaleToItemWindow, Name=%s', [TUser (FUser).Name]));
      exit;
   end;
   if FCurrentWindow <> swk_sale then exit;
   if FCurrentSubType <> sst_salesell then exit;

   srcKey := pcDragDrop^.rSourKey;
   destKey := pcDragDrop^.rDestKey;
   if SaleDataArr [srcKey].rName [0] = 0 then exit;
   ItemClass.GetItemData (StrPas (@SaleDataArr [srcKey].rName), ItemData);
   if ItemData.rName [0] = 0 then exit;

   if CopyHaveItem.CheckAddable (ItemData) < 0 then begin
      FSendClass.SendChatMessage (Conv('持有的物品太多'), SAY_COLOR_SYSTEM);
      exit;
   end;

   if ItemData.rboDouble = false then begin
      cSelectCount.rboOk := true;
      cSelectCount.rsourkey := pcDragDrop^.rsourkey;
      cSelectCount.rdestkey := pcDragDrop^.rdestkey;
      cSelectCount.rCount := 1;
      cSelectCount.rCountid := DRAGACTION_FROMSALETOITEM;
      SelectCount (@cSelectCount);
      exit;
   end;

   FSendClass.SendShowCount (DRAGACTION_FROMSALETOITEM, srcKey, destKey, 10000, StrPas (@ItemData.rViewName));
end;

procedure TShowWindowClass.FromItemToSaleWindow (pcDragDrop : PTCDragDrop);
var
   i, srcKey, destKey : Integer;
   ItemData : TItemData;
   cSelectCount : TCSelectCount;
   Str : String;
begin
   if FCurrentWindow <> swk_sale then begin
      str := GetUserWindowStateStr;
      str := str + ',' + 'FromItemToSaleWindow';
      CopyHaveItem.Free;
      CopyHaveItem := nil;
      frmMain.WriteBadUserLog(str);
      ConnectorList.CloseConnectByCharName (TUser (FUser).Name);
      exit;
   end;

   if CopyHaveItem = nil then begin
      frmMain.WriteLogInfo (format ('CopyHaveItem = nil, FromItemToSaleWindow, Name=%s', [TUser (FUser).Name]));
      exit;
   end;
   if FCurrentWindow <> swk_sale then exit;
   if FCurrentSubType <> sst_salebuy then exit;

   srcKey := pcDragDrop^.rSourKey;
   destKey := pcDragDrop^.rDestKey;

   CopyHaveItem.ViewItem (srcKey, @ItemData);
   if ItemData.rName [0] = 0 then exit;
   if ItemData.rboNotTrade = true then begin
      FSendClass.SendChatMessage (Conv('禁止交易的物品'), SAY_COLOR_SYSTEM);
      exit;
   end;

   destKey := -1;
   for i := 0 to SALELISTMAX - 1 do begin
      if SaleDataArr [i].rName [0] = 0 then break;
      if StrPas (@SaleDataArr [i].rName) = StrPas (@ItemData.rName) then begin
         if ItemData.rUpgrade = 0 then begin
            destKey := i;
         end;
         break;
      end;
   end;
   if destKey = -1 then begin
      FSendClass.SendChatMessage (Conv('不买此种物品'), SAY_COLOR_SYSTEM);
      exit;
   end;

   if ItemData.rCount = 1 then begin
      cSelectCount.rboOk := true;
      cSelectCount.rsourkey := pcDragDrop^.rsourkey;
      cSelectCount.rdestkey := i;
      cSelectCount.rCount := 1;
      cSelectCount.rCountid := DRAGACTION_FROMITEMTOSALE;
      SelectCount (@cSelectCount);
      exit;
   end;

   if ItemData.rCount > 10000 then begin
      FSendClass.SendShowCount (DRAGACTION_FROMITEMTOSALE, srcKey, destKey, 10000, StrPas (@ItemData.rViewName));
   end else begin
      FSendClass.SendShowCount (DRAGACTION_FROMITEMTOSALE, srcKey, destKey, ItemData.rCount, StrPas (@ItemData.rViewName));
   end;
end;

procedure TShowWindowClass.FromIndividualMarketToItemWindow (pcDragDrop : PTCDragDrop);
var
   ItemData : TItemData;
   srcKey, destKey : Integer;
   cSelectCount : TCSelectCount;
   pMarketItem : PTIndividualMarketItem;
   str : String;
begin
   if (NATION_VERSION = NATION_CHINA_1) or (NATION_VERSION = NATION_CHINA_1_TEST) then exit;

   if FCurrentWindow <> swk_individualmarket then begin
      str := GetUserWindowStateStr;
      str := str + ',' + 'FromIndividualMarketToItemWindow';
      CopyHaveItem.Free;
      CopyHaveItem := nil;
      frmMain.WriteBadUserLog(str);
      ConnectorList.CloseConnectByCharName (TUser (FUser).Name);      
      exit;
   end;

   if CopyHaveItem = nil then begin
      frmMain.WriteLogInfo (format ('CopyHaveItem = nil, FromIndividualMarketToItemWindow, Name=%s', [TUser (FUser).Name]));
      exit;
   end;
   if FCurrentWindow <> swk_individualmarket then exit;

   srcKey := pcDragDrop^.rSourKey;
   destKey := pcDragDrop^.rDestKey;

   if (srcKey < 0) or (srcKey >= CopyMarketDataList.Count) then exit;   
   pMarketItem := CopyMarketDataList.Items [srcKey];
   if pMarketItem^.rName [0] = 0 then exit;
   ItemClass.GetItemData (StrPas (@pMarketItem^.rName), ItemData);
   if ItemData.rName [0] = 0 then begin
      FSendClass.SendChatMessage (Conv('此中物品不存在'), SAY_COLOR_SYSTEM);
      exit;
   end;
   ItemData.rcolor := pMarketItem^.rColor;
   ItemData.rPrice := pMarketItem^.rCost;
   ItemData.rCurDurability := pMarketItem^.rCurDurability;
   ItemData.rDurability := pMarketItem^.rDurability;
   ItemData.rUpgrade := pMarketItem^.rUpgrade;

   if CopyHaveItem.CheckAddable (ItemData) < 0 then begin
      FSendClass.SendChatMessage (Conv('持有的物品太多'), SAY_COLOR_SYSTEM);
      exit;
   end;

   if ItemData.rboDouble = false then begin
      cSelectCount.rboOk := true;
      cSelectCount.rsourkey := pcDragDrop^.rsourkey;
      cSelectCount.rdestkey := pcDragDrop^.rdestkey;
      cSelectCount.rCount := 1;
      cSelectCount.rCountid := DRAGACTION_FROMINDIVIDUALMARKETTOITEM;
      SelectCount (@cSelectCount);
      exit;
   end;

   FSendClass.SendShowCount (DRAGACTION_FROMINDIVIDUALMARKETTOITEM, srcKey, destKey, 10000, StrPas (@ItemData.rViewName));
end;

procedure TShowWindowClass.MakeGuildMagic (aGuildName : String; aCode : TWordComData);
var
   GuildObject : TGuildObject;
   pcGuildMagicData : PTCGuildMagicData;
   ItemData : TItemData;
   MagicData : TMagicData;
   Str : String;
begin
   if FCurrentWindow <> swk_guildmagic then begin
      str := GetUserWindowStateStr;
      str := str + ',' + 'MakeGuildMagic';
      frmMain.WriteBadUserLog(str);
      ConnectorList.CloseConnectByCharName (TUser (FUser).Name);      
      exit;
   end;

   FCurrentWindow := swk_none;
   FCurrentSubType := sst_none;

   if aGuildName = '' then exit;
   GuildObject := GuildList.GetGuildObject (aGuildName);
   if GuildObject = nil then exit;
   if GuildObject.IsGuildSysop (TUser (FUser).Name) = false then begin
      FSendClass.SendChatMessage (Conv('只有门主才可以申请门派武功'), SAY_COLOR_SYSTEM);
      exit;
   end;
   if GuildObject.GetGuildMagicString <> '' then begin
      FSendClass.SendChatMessage (Conv('已经有门派武功'), SAY_COLOR_SYSTEM);
      exit;
   end;

   ItemClass.GetItemData (Conv('金元'), ItemData);
   if ItemData.rName [0] = 0 then exit;
   ItemData.rCount := 40;
   if FHaveItemClass.FindItem (@ItemData) = false then begin
      FSendClass.SendChatMessage (Conv('申请门派武功时需要40个金元'), SAY_COLOR_SYSTEM);
      exit;
   end;

   pcGuildMagicData := PTCGuildMagicData (@aCode.Data);

   FillChar (MagicData, SizeOf (TMagicData), 0);
   StrPCopy (@MagicData.rName, pcGuildMagicData^.rMagicName);
   MagicData.rGuildMagicType := 1;
   MagicData.rMagicType := pcGuildMagicData^.rMagicType;
   MagicData.rEffectColor := 1;
   MagicData.rShape := MagicData.rMagicType + 1;

   case MagicData.rMagicType of
      MAGICTYPE_WRESTLING : MagicData.rShape := 4;
      MAGICTYPE_FENCING : MagicData.rShape := 19;
      MAGICTYPE_SWORDSHIP : MagicData.rShape := 35;
      MAGICTYPE_HAMMERING : MagicData.rShape := 51;
      MAGICTYPE_SPEARING : MagicData.rShape := 67;
      Else MagicData.rShape := 1;
   end;
   
   MagicData.rSkillExp := 100;
   MagicData.rLifeData.damageBody := pcGuildMagicData^.rDamageBody;
   MagicData.rLifeData.damageHead := pcGuildMagicData^.rDamageHead;
   MagicData.rLifeData.damageArm := pcGuildMagicData^.rDamageArm;
   MagicData.rLifeData.damageLeg := pcGuildMagicData^.rDamageLeg;
   MagicData.rLifeData.ArmorBody := pcGuildMagicData^.rArmorBody;
   MagicData.rLifeData.ArmorHead := pcGuildMagicData^.rArmorHead;
   MagicData.rLifeData.ArmorArm := pcGuildMagicData^.rArmorArm;
   MagicData.rLifeData.ArmorLeg := pcGuildMagicData^.rArmorLeg;
   MagicData.rLifeData.AttackSpeed := pcGuildMagicData^.rSpeed;
   MagicData.rLifeData.Recovery := pcGuildMagicData^.rRecovery;
   MagicData.rLifeData.Avoid := pcGuildMagicData^.rAvoid;
   MagicData.rLifeData.Accuracy := pcGuildMagicData^.rAccuracy;
   MagicData.rLifeData.KeepRecovery := pcGuildMagicData^.rKeepRecovery;
   MagicData.rEventDecInPower := pcGuildMagicData^.rInPower;
   MagicData.rEventDecOutPower := pcGuildMagicData^.rOutPower;
   MagicData.rEventDecMagic := pcGuildMagicData^.rMagicPower;
   MagicData.rEventDecLife := pcGuildMagicData^.rLife;

   if MagicClass.CheckMagicData (MagicData, Str) = false then begin
      FSendClass.SendChatMessage (Str, SAY_COLOR_SYSTEM);
      exit;
   end;

   if MagicClass.AddGuildMagic (MagicData, aGuildName) = false then begin
      FSendClass.SendChatMessage (Conv('不能添加门派武功'), SAY_COLOR_SYSTEM);
      exit;
   end;

   GuildObject := GuildList.GetGuildObject (aGuildName);
   if GuildObject = nil then begin
      FSendClass.SendChatMessage (Conv('无法搜索到加入的门派'), SAY_COLOR_SYSTEM);
      exit;
   end;

   if FHaveItemClass.DeleteItem (@ItemData) = false then exit;
   GuildObject.AddGuildMagic (pcGuildMagicData^.rMagicName);

   FSendClass.SendChatMessage (format (Conv('%s门的门派武功是%s'), [aGuildName, pcGuildMagicData^.rMagicName]), SAY_COLOR_SYSTEM);
end;

procedure TShowWindowClass.ConfirmWindowProcess (pcWindowConfirm : PTCWindowConfirm);
var
   i : Integer;
   pCheckItem : PTCheckItem;
   SubData : TSubData;
   tmpUser : TUser;
   Str : String;
   GuildObject : TGuildObject;
begin
   Case pcWindowConfirm^.rWindow of
      WINDOW_SSAMZIEITEM :
         begin
            if FCurrentWindow <> swk_itemlog then begin
               FHaveItemClass.boLocked := false;
               FhaveItemClass.Refresh;
               if CopyHaveItem <> nil then begin
                  CopyHaveItem.Free;
                  CopyHaveItem := nil;
               end;
               FCurrentWindow := swk_none;
               FCurrentSubType := sst_none;

               str := GetUserWindowStateStr;
               str := str + ',' + 'confirmwindow_ssamzie';
               frmMain.WriteBadUserLog(str);
               ConnectorList.CloseConnectByCharName (TUser (FUser).Name);
               exit;
            end;

            if pcWindowConfirm^.rboCheck = true then begin
               for i := 0 to 4 - 1 do begin
                  if ItemLogData[i].Header.boUsed = true then begin
                     ItemLog.SetLogRecord (TUser (FUser).Name, i, ItemLogData[i]);
                  end;
                  ItemLogData[i].Header.boUsed := false;
               end;
               if CopyHaveItem <> nil then begin
                  FHaveItemClass.CopyFromHaveItemClass (CopyHaveItem, Conv('@福袋'), '');
               end;
            end else begin
               for i := 0 to 4 - 1 do begin
                  ItemLogData[i].Header.boUsed := false;
               end;
            end;

            FHaveItemClass.boLocked := false;
            FHaveItemClass.Refresh;

            if CopyHaveItem <> nil then begin
               CopyHaveItem.Free;
               CopyHaveItem := nil;
            end;
         end;
      WINDOW_GUILDITEMLOG :
         begin
            if FCurrentWindow <> swk_itemlog then begin
               FHaveItemClass.boLocked := false;
               FhaveItemClass.Refresh;
               if CopyHaveItem <> nil then begin
                  CopyHaveItem.Free;
                  CopyHaveItem := nil;
               end;
               FCurrentWindow := swk_none;
               FCurrentSubType := sst_none;

               str := GetUserWindowStateStr;
               str := str + ',' + 'confirmwindow_guilditem';
               frmMain.WriteBadUserLog(str);
               ConnectorList.CloseConnectByCharName (TUser (FUser).Name);
               exit;
            end;

           {GuildObject := GuildList.GetGuildObject(TUser (FUser).GuildName);
           if GuildObject = nil then Exit;
           if GuildObject.IsGuildSysop(TUser (FUser).Name) then begin

                if pcWindowConfirm^.rboCheck = true then begin
                   if CopyHaveItem <> nil then begin
                      FHaveItemClass.CopyFromHaveItemClass (CopyHaveItem, Conv('@福袋'), '');
                   end;
                end else begin


                end;
            end; }
            if pcWindowConfirm^.rboCheck = true then begin
               FCurrentWindow := swk_none;
               FCurrentSubType := sst_none;
            end;

            FHaveItemClass.boLocked := false;
            FHaveItemClass.Refresh;
            Exit;

         end;
      WINDOW_ALERT :
         begin
            if FCurrentWindow <> swk_alert then begin
               str := GetUserWindowStateStr;
               str := str + ',' + 'confirmwindow_alert';
               frmMain.WriteBadUserLog(str);
               ConnectorList.CloseConnectByCharName (TUser (FUser).Name);
               exit;
            end;
            if pcWindowConfirm^.rType = ALERT_GAMEAGREE then begin
               if pcWindowConfirm^.rboCheck = false then begin
                  ConnectorList.CloseConnectByCharName (TUser (FUser).Name);
               end;
            end;
         end;
      WINDOW_AGREE :
         begin
            if FCurrentWindow <> swk_bloodguild then begin
               str := GetUserWindowStateStr;
               str := str + ',' + 'confirmwindow_agree';
               frmMain.WriteBadUserLog(str);
               ConnectorList.CloseConnectByCharName (TUser (FUser).Name);
               exit;
            end;
            if pcWindowConfirm^.rType = AGREE_ALLYGUILD then begin
               if pcWindowConfirm^.rboCheck = true then begin
                  StrPCopy (@SubData.GuildName, TUser (FUser).ParamStr [1]);
                  GuildList.FieldProc (TUser (FUser).ParamStr [0], FM_ADDALLYGUILD, TUser (FUser).BasicData, SubData);
                  StrPCopy (@SubData.GuildName, TUser (FUser).ParamStr [0]);
                  GuildList.FieldProc (TUser (FUser).ParamStr [1], FM_ADDALLYGUILD, TUser (FUser).BasicData, SubData);
               end else begin
                  SetWordString (SubData.SayString, Conv('结盟的提议被拒绝了'));
                  GuildList.FieldProc (TUser (FUser).ParamStr [0], FM_SElFSAY, TUser (FUser).BasicData, SubData);
                  GuildList.FieldProc (TUser (FUser).ParamStr [1], FM_SElFSAY, TUser (FUser).BasicData, SubData);
               end;
            end;
         end;
      WINDOW_TRADE :
         begin
             if FCurrentWindow <> swk_trade then begin
               FHaveItemClass.boLocked := false;
               FhaveItemClass.Refresh;
               if CopyHaveItem <> nil then begin
                  CopyHaveItem.Free;
                  CopyHaveItem := nil;
               end;
               FCurrentWindow := swk_none;
               FCurrentSubType := sst_none;

               str := GetUserWindowStateStr;
               str := str + ',' + 'confirmwindow_trade';
               frmMain.WriteBadUserLog(str);
               ConnectorList.CloseConnectByCharName (TUser (FUser).Name);
               exit;
            end;

            if CopyHaveItem = nil then exit;

            if pcWindowConfirm^.rboCheck = true then begin
               if FCurrentSubType = sst_sell then begin
               end;
               if FCurrentSubType = sst_buy then begin
               end;
               FHaveItemClass.CopyFromHaveItemClass (CopyHaveItem, Conv('@买卖窗'), '');
            end;
            FhaveItemClass.Refresh;

            CopyHaveItem.Free;
            CopyHaveItem := nil;
         end;
      WINDOW_SALE :
         begin
            // 概概辆丰
             if FCurrentWindow <> swk_sale then begin
               FHaveItemClass.boLocked := false;
               FhaveItemClass.Refresh;
               if CopyHaveItem <> nil then begin
                  CopyHaveItem.Free;
                  CopyHaveItem := nil;
               end;
               FCurrentWindow := swk_none;
               FCurrentSubType := sst_none;

               str := GetUserWindowStateStr;
               str := str + ',' + 'confirmwindow_sale';
               frmMain.WriteBadUserLog(str);
               ConnectorList.CloseConnectByCharName (TUser (FUser).Name);
               exit;
            end;

            if CopyHaveItem = nil then exit;

            if pcWindowConfirm^.rboCheck = true then begin
               if FCurrentSubType = sst_salesell then begin
                  if SaleItemList <> nil then begin
                     for i := 0 to SaleItemList.Count - 1 do begin
                        pCheckItem := SaleItemList.Items [i];
                        if TNpc (SaleNpc).SaleSkill.DelItembyName (StrPas (@pCheckItem^.rName), pCheckItem^.rCount) = false then begin
                           FSendClass.SendChatMessage (Conv('数量不足'), SAY_COLOR_SYSTEM); 
                           FhaveItemClass.Refresh;
                           CopyHaveItem.Free;
                           CopyHaveItem := nil;

                           FCurrentWindow := swk_none;
                           FCurrentSubType := sst_none;
                           FCommander := nil;
                           SaleNpc := nil;
                           exit;
                        end;
                     end;
                  end;
               end;
               if FCurrentSubType = sst_salebuy then begin
                  if SaleItemList <> nil then begin
                     for i := 0 to SaleItemList.Count - 1 do begin
                        pCheckItem := SaleItemList.Items [i];
                        TNpc (SaleNpc).SaleSkill.AddItembyName (StrPas (@pCheckItem^.rName), pCheckItem^.rCount);
                     end;
                  end;
               end;
               FHaveItemClass.CopyFromHaveItemClass (CopyHaveItem, Conv('@商店窗'), '');
            end;
            FhaveItemClass.Refresh;

            CopyHaveItem.Free;
            CopyHaveItem := nil;
         end;
      WINDOW_INDIVIDUALMARKET :
         begin
            if (NATION_VERSION = NATION_CHINA_1) or (NATION_VERSION = NATION_CHINA_1_TEST) then exit;

            if FCurrentWindow <> swk_individualmarket then begin
               FHaveItemClass.boLocked := false;
               FhaveItemClass.Refresh;
               if CopyHaveItem <> nil then begin
                  CopyHaveItem.Free;
                  CopyHaveItem := nil;
               end;
               FCurrentWindow := swk_none;
               FCurrentSubType := sst_none;

               str := GetUserWindowStateStr;
               str := str + ',' + 'confirmwindow_individualmarket';
               frmMain.WriteBadUserLog(str);
               ConnectorList.CloseConnectByCharName (TUser (FUser).Name);
               exit;
            end;
            
            if CopyHaveItem = nil then exit;
            if pcWindowConfirm^.rboCheck = true then begin
               tmpUser := UserList.GetUserPointerById (TUser (FUser).MarketUserID);

               if (tmpUser = nil) or (tmpUser.GetboMarketing = false) then begin
                  FSendClass.SendChatMessage (Conv('不在买卖状态'), SAY_COLOR_SYSTEM);
                  FhaveItemClass.Refresh;
                  CopyHaveItem.Free;
                  CopyHaveItem := nil;

                  FCurrentWindow := swk_none;
                  FCurrentSubType := sst_none;
                  TUser (FUser).MarketUserID := 0;
                  exit;
               end else if tmpUser.SellItembyUser (CopyMarketDataList, StrPas (@TUser (FUser).BasicData.Name)) = false then begin
                  FSendClass.SendChatMessage (Conv('购置的物品不存在或是数量不足'), SAY_COLOR_SYSTEM);
                  FhaveItemClass.Refresh;
                  CopyHaveItem.Free;
                  CopyHaveItem := nil;

                  FCurrentWindow := swk_none;
                  FCurrentSubType := sst_none;
                  TUser (FUser).MarketUserID := 0;
                  exit;
               end;

               FHaveItemClass.CopyFromHaveItemClass (CopyHaveItem, format ('#%s', [StrPas (@tmpUser.BasicData.Name)]), tmpUser.IP);
            end;
            FhaveItemClass.Refresh;

            CopyHaveItem.Free;
            CopyHaveItem := nil;
         end;
      Else begin
         exit;
      end;
   end;

   FCurrentWindow := swk_none;
   FCurrentSubType := sst_none;
   FCommander := nil;
   SaleNpc := nil;
end;

procedure TShowWindowClass.CancelExchange;
begin
   FillChar (ExChangeData, sizeof (TExChangeData), 0);
   FSendClass.SendCancelExChange;

   FCurrentWindow := swk_none;
   FCurrentSubType := sst_none;
   boActiveExchange := false;   
end;

//林狼措惑
procedure TShowWindowClass.ShowCountWindow (aCountWindowState : Integer; pcDragDrop : PTCDragDrop; aItemData : TItemData);
begin
   CountWindowState := aCountWindowState;

   if (FCurrentWindow <> swk_exchange) and (FCurrentWindow <> swk_itemlog) then begin
      FCurrentWindow := swk_count;
   end;

   if aItemData.rCount > 10000 then begin
      FSendClass.SendShowCount (aCountWindowState, pcDragDrop^.rsourkey, pcDragDrop^.rdestkey, 10000, StrPas (@aItemData.rViewName));
   end else begin
      FSendClass.SendShowCount (aCountWindowState, pcDragDrop^.rsourkey, pcDragDrop^.rdestkey, aItemData.rCount, StrPas (@aItemData.rViewName));
   end;
   FSendClass.SendChatMessage (Conv('请选择个数'), SAY_COLOR_SYSTEM);
end;

procedure TShowWindowClass.ShowMarketCountWindow (pcDragDrop : PTCDragDrop; aItemData : TItemData);
begin
   FSendClass.SendShowMarketCount (pcDragDrop^.rsourkey, pcDragDrop^.rdestkey, aItemData.rCount);
   FSendClass.SendChatMessage (Conv('请输入数量/单价'), SAY_COLOR_SYSTEM);
end;

function TShowWindowClass.ShowItemLogWindow : String;
var
   i, j, n : Integer;
   ItemData : TItemData;
begin
   Result := '';

   try
      if ItemLog.Enabled = false then begin
         Result := Conv('无法使用储存物品的功能');
         exit;
      end;
      if FCurrentWindow <> swk_none then begin
         Result := Conv('请关闭开启的窗口');
         exit;
      end;

      n := ItemLog.GetRoomCount (TUser (FUser).Name);
      if n <= 0 then begin
         Result := format (Conv('%s 没有储存的空间'), [TUser (FUser).Name]);
         exit;
      end;
      if n > 4 then n := 4;

      if ItemLog.isLocked (TUser (FUser).Name) = true then begin
         Result := format (Conv('%s 的保管窗有密码设定'), [TUser (FUser).Name]);
         exit;
      end;

      for i := 0 to n - 1 do begin
         if ItemLog.GetLogRecord (TUser (FUser).Name, i, ItemLogData[i]) = false then begin
            Result := Conv('因有错误被取消');
            exit;
         end;
         // add by Orber at 2005-02-26 19:35:01
         if ItemLogData[i].CRCKey <> oz_CRC32(@ItemLogData[i],SizeOf(ItemLogData[i])-4) then begin
            Result := Conv('因有错误被取消');
            exit;
         end;
         
         for j := 0 to 10 - 1 do begin
            ItemClass.GetItemData (StrPas (@ItemLogData[i].ItemData [j].Name), ItemData);
            if ItemData.rName [0] = 0 then begin
               FillChar (ItemLogData[i].ItemData [j], SizeOf (TItemLogData), 0);
            end;
         end;

      end;
   finally
      if (Result <> '') and (FCommander <> nil) then begin
         FCommander.SSay (Result);
      end;
   end;

   if CopyHaveItem <> nil then CopyHaveItem.Free;
   CopyHaveItem := THaveItemClass.Create (TUser (FUser), FSendClass, nil, nil);
   CopyHaveItem.CopyFromHaveItemClass (FHaveItemClass, Conv('@福袋'), '');

   FHaveItemClass.boLocked := true;

   FSendClass.SendShowSpecialWindow (FUser, WINDOW_SSAMZIEITEM, 0, Conv('物品保管窗'), Conv('把物品移动到DRAG&DROP后，请按【确认】键'));

   for i := 0 to n - 1 do begin
      for j := 0 to 10 - 1 do begin
         ItemClass.GetItemData (StrPas (@ItemLogData[i].ItemData[j].Name), ItemData);
         ItemData.rColor := ItemLogData[i].ItemData[j].Color;
         ItemData.rCount := ItemLogData[i].ItemData[j].Count;
//add by Orber 2004-09-08 20:44
            ItemData.rLockState := ItemLogData[i].ItemData[j].rLockState;
            ItemData.runLockTime := ItemLogData[i].ItemData[j].runLockTime;
         FSendClass.SendSsamzieItem (i * 10 + j, ItemData);
      end;
   end;

   FCurrentWindow := swk_itemlog;
   FCurrentSubType := sst_none;
end;

// add by Orber at 2005-01-05 15:09:52
function TShowWindowClass.ShowGuildItemLogWindow(sPage:Word) : String;
var
   i, j, n : Integer;
   ItemData : TItemData;
   aGuildObject : TGuildObject;
begin
   Result := '';

   try
      if FCurrentWindow <> swk_none then begin
         Result := Conv('请关闭开启的窗口');
         exit;
      end;
   finally
      if (Result <> '') and (FCommander <> nil) then begin
         FCommander.SSay (Result);
      end;
   end;
   aGuildObject := GuildList.GetGuildObject(TUser(FUser).GuildName);
   if aGuildObject = nil then begin
        FCommander.SSay (Conv('你还没有加入门派'));
        Exit;
   end;
   //if not aGuildObject.IsGuildSysop(TUser(FUser).Name) then exit;


   //if CopyHaveItem <> nil then CopyHaveItem.Free;
   {if CopyHaveItem = nil then begin
     CopyHaveItem := THaveItemClass.Create (TUser (FUser), FSendClass, nil, nil);
     CopyHaveItem.CopyFromHaveItemClass (FHaveItemClass, Conv('@福袋'), '');

     FHaveItemClass.boLocked := true;
   end;}

   FSendClass.SendShowSpecialWindow (FUser, WINDOW_GUILDITEMLOG, 0, TUser(FUser).GuildName + Conv('门派仓库'), Conv('把物品移动到DRAG&DROP后，请按【确认】键'));

   for i := 40 * (sPage - 1) to 40 + (40 * (sPage - 1)) - 1 do begin
         ItemClass.GetItemData (StrPas (@aGuildObject.FGuildItemLog.ItemData[i].Name), ItemData);
         ItemData.rColor := aGuildObject.FGuildItemLog.ItemData[i].Color;
         ItemData.rCount := aGuildObject.FGuildItemLog.ItemData[i].Count;
         //ItemData.rCount := 1;
         ItemData.rLockState := aGuildObject.FGuildItemLog.ItemData[i].rLockState;
         ItemData.runLockTime := aGuildObject.FGuildItemLog.ItemData[i].runLockTime;
         {if i < 40 then begin
            n := i;
         end else begin
            n := i - 40;
         end;}
         FSendClass.SendGuildItem (i, ItemData);
   end;

   FCurrentWindow := swk_itemlog;
   FCurrentSubType := sst_none;
end;

procedure TShowWindowClass.ShowGuildMagicWindow (pMagicWindowData : PTSShowGuildMagicWindow);
begin
   if FCurrentWindow <> swk_none then begin
      TUser (FUser).SendClass.SendChatMessage (Conv('请关闭开启的窗口'), SAY_COLOR_SYSTEM);
      exit;
   end;

   FCurrentWindow := swk_guildmagic;
   FCurrentSubType := sst_none;
   FSendClass.SendShowGuildMagicWindow (pMagicWindowData);
end;

procedure TShowWindowClass.ShowExchangeWindow (pexleft, pexright: PTExChangedata);
begin
   if (FCurrentWindow <> swk_exchange) and (FCurrentWindow <> swk_none) then begin
      TUser (FUser).SendClass.SendChatMessage (Conv('请关闭开启的窗口'), SAY_COLOR_SYSTEM);
      exit;
   end;

   FCurrentWindow := swk_exchange;
   FCurrentSubType := sst_none;

   boActiveExchange := true;   
   FSendClass.SendShowExChange (pexleft, pexright);
end;

procedure TShowWindowClass.ShowSearchWindow (aInputStringId: integer; aCaptionString: string; aListString: string);
begin
//   FCurrentWindow := swk_search;
   FSendClass.SendShowInputString (aInputStringId, aCaptionString, aListString);
end;

procedure TShowWindowClass.ShowHelpWindow (aFileName, aHelpText : String);
begin
   if FCurrentWindow <> swk_none then begin
      TUser (FUser).SendClass.SendChatMessage (Conv('请关闭开启的窗口'), SAY_COLOR_SYSTEM);
      exit;
   end;

   FCurrentWindow := swk_help;
   FCurrentSubType := sst_none;

   FSendClass.SendShowHelpWindow (aFileName, aHelpText);
end;

procedure TShowWindowClass.ShowHelpWindow2 (aStr : String);
begin
   if FCurrentWindow <> swk_none then begin
      TUser (FUser).SendClass.SendChatMessage (Conv('请关闭开启的窗口'), SAY_COLOR_SYSTEM);
      exit;
   end;

   FCurrentWindow := swk_help;
   FCurrentSubType := sst_none;

   FSendClass.SendShowHelpWindow ('', aStr);
end;


procedure TShowWindowClass.ShowTradeWindow (aFileName, aHelpText : String);
begin
   if FCurrentWindow <> swk_none then begin
      TUser (FUser).SendClass.SendChatMessage (Conv('请关闭开启的窗口'), SAY_COLOR_SYSTEM);
      exit;
   end;
   FCurrentWindow := swk_help;
   FCurrentSubType := sst_none;

   FSendClass.SendShowTradeWindow (aFileName, aHelpText);
end;

  // add by Orber at 2004-12-23 10:47:21
procedure TShowWindowClass.ShowMarry (aHelpText : String);
begin
   if FCurrentWindow <> swk_none then begin
      TUser (FUser).SendClass.SendChatMessage (Conv('请关闭开启的窗口'), SAY_COLOR_SYSTEM);
      exit;
   end;
   FCurrentWindow := swk_marry;
   FCurrentSubType := sst_none;

   FSendClass.SendShowMarryWindow (aHelpText);
end;

  // add by Orber at 2005-01-04 10:36:14
procedure TShowWindowClass.ShowUnMarry (aHelpText : String);
begin
   if FCurrentWindow <> swk_none then begin
      TUser (FUser).SendClass.SendChatMessage (Conv('请关闭开启的窗口'), SAY_COLOR_SYSTEM);
      exit;
   end;
   FCurrentWindow := swk_marry;
   FCurrentSubType := sst_none;
   FSendClass.SendShowUnMarryWindow (aHelpText);
end;

procedure TShowWindowClass.ShowGuildApplyMoney(aHelpText,aUser :String);
begin
   if FCurrentWindow <> swk_none then begin
      TUser (FUser).SendClass.SendChatMessage (Conv('请关闭开启的窗口'), SAY_COLOR_SYSTEM);
      exit;
   end;
   FCurrentWindow := swk_guildinfo;
   FCurrentSubType := sst_none;
   TUser (FUser).PreGuildMoneyApplyer := aUser;
   FSendClass.SendShowGuildApplyMoneyWindow (aHelpText);
end;

procedure TShowWindowClass.ShowGuildSubSysop (aHelpText :String);
begin
   if FCurrentWindow <> swk_none then begin
      TUser (FUser).SendClass.SendChatMessage (Conv('请关闭开启的窗口'), SAY_COLOR_SYSTEM);
      exit;
   end;
   FCurrentWindow := swk_guildsubsysop;
   FCurrentSubType := sst_none;
   FSendClass.SendShowGuildSubSysopWindow (aHelpText);
end;

procedure TShowWindowClass.ShowMarryAnswer (aHelpText : String);
begin
   if FCurrentWindow <> swk_none then begin
      TUser (FUser).SendClass.SendChatMessage (Conv('请关闭开启的窗口'), SAY_COLOR_SYSTEM);
      exit;
   end;
   FCurrentWindow := swk_marryanswer;
   FCurrentSubType := sst_none;

   FSendClass.SendShowMarryAnswerWindow (aHelpText);
end;

procedure TShowWindowClass.ShowGuildAnswer(aHelpText:String);
begin
   if FCurrentWindow <> swk_none then begin
      TUser (FUser).SendClass.SendChatMessage (Conv('请关闭开启的窗口'), SAY_COLOR_SYSTEM);
      exit;
   end;
   FCurrentWindow := swk_guildanswer;
   FCurrentSubType := sst_none;

   FSendClass.SendShowGuildAnswerWindow (aHelpText);
end;

procedure TShowWindowClass.ShowArenaWindow (aHelpText : String);
begin
   if FCurrentWindow <> swk_none then begin
      TUser (FUser).SendClass.SendChatMessage (Conv('请关闭开启的窗口'), SAY_COLOR_SYSTEM);
      exit;
   end;
   FCurrentWindow := swk_arena;
   FCurrentSubType := sst_none;

   FSendClass.SendShowArenaWindow (aHelpText);
end;

procedure TShowWindowClass.ShowInputMoneyChip (aHelpText : String);
begin
   if FCurrentWindow <> swk_none then begin
      TUser (FUser).SendClass.SendChatMessage (Conv('请关闭开启的窗口'), SAY_COLOR_SYSTEM);
      exit;
   end;
   FCurrentWindow := swk_guildinfo;
   FCurrentSubType := sst_none;

   FSendClass.SendShowInputMoneyChipWindow (aHelpText);
end;

procedure TShowWindowClass.TradeWindow (aTitle, aCaption : String; aImageNum, aImageValue : Word; aItemStr : String; aKind : Byte);
var
   iCount : Integer;
   ComData : TWordComData;
   pd : PTSShowTradeWindow;
   Str, rdStr : String;
   ItemData : TItemData;
begin
   if FCurrentWindow <> swk_none then begin
      TUser (FUser).SendClass.SendChatMessage (Conv('请关闭开启的窗口'), SAY_COLOR_SYSTEM);
      exit;
   end;

   FCurrentWindow := swk_trade;
   if aKind = KIND_SELL then FCurrentSubType := sst_sell
   else if aKind = KIND_BUY then FCurrentSubType := sst_buy
   else exit;

   pd := PTSShowTradeWindow (@ComData.Data);
   pd^.rMsg := SM_SHOWTRADEWINDOW;
   pd^.rTradeType := aKind;
   StrPCopy (@pd^.rTitle, aTitle);
   StrPCopy (@pd^.rImageName, 'z' + IntToStr (aImageNum));
   pd^.rImageValue := aImageValue;
   SetWordString (pd^.rWordString, aCaption);
   ComData.Size := SizeOf (TSShowTradeWindow) - WORDSTRINGSIZE + SizeOfWordString (pd^.rWordString);

   FSendClass.SendData (ComData);

   FillChar (TradeDataArr, SizeOf (TradeDataArr), 0);

   Str := aItemStr;
   iCount := 0;
   while Str <> '' do begin
      Str := GetValidStr3 (Str, rdStr, ',');
      if rdStr = '' then break;
      ItemClass.GetItemData (rdStr, ItemData);
      if ItemData.rName [0] = 0 then continue;

      StrCopy (@TradeDataArr [iCount].rName, @ItemData.rName);
      TradeDataArr [iCount].rCount := 0;
      TradeDataArr [iCount].rColor := ItemData.rColor;
      TradeDataArr [iCount].rShape := ItemData.rShape;
      if aKind = KIND_BUY then TradeDataArr [iCount].rPrice := ItemData.rBuyPrice
      else TradeDataArr [iCount].rPrice := ItemData.rPrice;
      Inc (iCount);
      if iCount >= TRADELISTMAX then break;
   end;

   SetTradeItem;

   if CopyHaveItem = nil then CopyHaveItem := THaveItemClass.Create (TUser (FUser), FSendClass, nil, nil);
   CopyHaveItem.CopyFromHaveItemClass (FHaveItemClass, Conv('@买卖窗'), '');
end;

procedure TShowWindowClass.SaleWindow (aBasicObject : TBasicObject; aTitle, aCaption : String;
   aImageNum, aImageValue : Word; aItemStr : String; aKind : Byte);
var
   i : integer;
   iCount : Integer;
   ComData : TWordComData;
   pd : PTSShowTradeWindow;
   Str, rdStr, dest : String;
   ItemData : TItemData;
   pCheckItem : PTCheckItem;
begin
   if FCurrentWindow <> swk_none then begin
      TUser (FUser).SendClass.SendChatMessage (Conv('请关闭开启的窗口'), SAY_COLOR_SYSTEM);
      exit;
   end;
   FCurrentWindow := swk_sale;
   if aKind = KIND_SALESELL then FCurrentSubType := sst_salesell
   else if aKind = KIND_SALEBUY then FCurrentSubType := sst_salebuy
   else exit;

   SaleNpc := aBasicObject;

   pd := PTSShowTradeWindow (@ComData.Data);
   pd^.rMsg := SM_SHOWTRADEWINDOW;
   pd^.rTradeType := aKind;
   StrPCopy (@pd^.rTitle, aTitle);
   StrPCopy (@pd^.rImageName, 'z' + IntToStr (aImageNum));
   pd^.rImageValue := aImageValue;
   SetWordString (pd^.rWordString, aCaption);
   ComData.Size := SizeOf (TSShowTradeWindow) - WORDSTRINGSIZE + SizeOfWordString (pd^.rWordString);

   FSendClass.SendData (ComData);

   FillChar (SaleDataArr, SizeOf (SaleDataArr), 0);
   if SaleItemList <> nil then begin
      for i := 0 to SaleItemList.Count - 1 do begin
         pCheckItem := SaleItemList.Items [i];
         if pCheckItem <> nil then Dispose (pCheckItem);
      end;
      SaleItemList.Clear;
   end;

   Str := aItemStr;
   iCount := 0;
   while Str <> '' do begin
      Str := GetValidStr3 (Str, rdStr, ',');
      if rdStr = '' then break;

      if akind = KIND_SALESELL then begin
         rdStr := GetValidStr3 (rdStr, dest, ':');
         ItemClass.GetItemData (dest, ItemData);
      end else begin
         ItemClass.GetItemData (rdStr, ItemData);
      end;

      if ItemData.rName [0] = 0 then continue;

      StrCopy (@SaleDataArr [iCount].rName, @ItemData.rName);

      if aKind = KIND_SALESELL then begin
         SaleDataArr [iCount].rTotalCount := _StrToInt (rdStr);
      end else begin
         SaleDataArr [iCount].rTotalCount := 0;
      end;
      SaleDataArr [iCount].rCount := 0;
      SaleDataArr [iCount].rColor := ItemData.rColor;
      SaleDataArr [iCount].rShape := ItemData.rShape;

      if aKind = KIND_SALESELL then SaleDataArr [iCount].rPrice := ItemData.rPrice
      else if aKind = KIND_SALEBUY then SaleDataArr [iCount].rPrice := ItemData.rBuyPrice;
      Inc (iCount);
      if iCount >= SALELISTMAX then break;
   end;

   SetSaleItem;

   if CopyHaveItem = nil then CopyHaveItem := THaveItemClass.Create (TUser (FUser), FSendClass, nil, nil);
   CopyHaveItem.CopyFromHaveItemClass (FHaveItemClass, Conv('@商店窗'), '');
end;
{
procedure TShowWindowClass.ShowMarketWindow;
begin
   if FCurrentWindow <> swk_none then begin
      TUser (FUser).SendClass.SendChatMessage (Conv('请关闭开启的窗口'), SAY_COLOR_SYSTEM);
      exit;
   end;
   FCurrentWindow := swk_market;
   FCurrentSubType := sst_none;

   FSendClass.SendShowMarketWindow (FHaveMarketClass.MarketCount);
end;
}
procedure TShowWindowClass.IndividualMarketWindow;
var
   ComData : TWordComData;
   pd : PTSShowIndividualMarketWindow;
   tmpUser : TUser;
begin
   if (NATION_VERSION = NATION_CHINA_1) or (NATION_VERSION = NATION_CHINA_1_TEST) then exit;

   if FCurrentWindow <> swk_none then begin
      TUser (FUser).SendClass.SendChatMessage (Conv('请关闭开启的窗口'), SAY_COLOR_SYSTEM);
      exit;
   end;

   FCurrentWindow := swk_individualmarket;

   tmpUser := UserLIst.GetUserPointerById (TUser (FUser).MarketUserID); 
   if tmpUser = nil then exit;
   
   pd := PTSShowIndividualMarketWindow (@ComData.Data);
   pd^.rMsg := SM_SHOWINDIVIDUALMARKETWINDOW;
   pd^.rMarketTargetId := TUser (FUser).MarketUserID;
   SetWordString (pd^.rCaption, StrPas (@tmpUser.BasicData.MarketName));

   ComData.Size := SizeOf (TSShowIndividualMarketWindow) - WORDSTRINGSIZE + SizeOfWordString (pd^.rCaption);
   FSendClass.SendData (ComData);

   ClearCopyMarketDataList;
   tmpUser.CopyMarketItem (CopymarketDataList);

   SetIndividualMarketItem;

   if CopyHaveItem = nil then CopyHaveItem := THaveItemClass.Create (TUser (FUser), FSendClass, nil, nil);
   CopyHaveItem.CopyFromHaveItemClass (FHaveItemClass, format ('#%s', [StrPas (@tmpUser.BasicData.Name)]), tmpUser.IP);
end;

//Author:Steven Date: 2005-01-10 18:08:42
//Note:显示门派名称输入框
procedure TShowWindowClass.ShowInputGuildName (aHelpText : String; SenderID : LongInt);
begin
   if FCurrentWindow <> swk_none then begin
      TUser (FUser).SendClass.SendChatMessage (Conv('请关闭开启的窗口'), SAY_COLOR_SYSTEM);
      Exit;
   end;
   FCurrentWindow := swk_inputguildname;
   FCurrentSubType := sst_none;
   FSendClass.SendShowInputGuildNameWindow(aHelpText, SenderID);
end;
//========================================

//Author:Steven Date: 2005-01-10 18:08:42
//Note:显示门派信息
procedure TShowWindowClass.ShowGuildInfo (aHelpText : String);
begin
   if FCurrentWindow <> swk_none then begin
      TUser (FUser).SendClass.SendChatMessage (Conv('请关闭开启的窗口'), SAY_COLOR_SYSTEM);
      Exit;
   end;
   FCurrentWindow := swk_guildinfo;
   FCurrentSubType := sst_none;
   FSendClass.SendShowMarryWindow (aHelpText);
end;
//=================================================

procedure TShowWindowClass.SetTradeItem;
var
   i, TotalPrice : Integer;
   Str, rdStr : String;
   pdi : PTSSetTradeItem;
   ComData : TWordComData;
begin
   TotalPrice := 0;
   Str := '';
   for i := 0 to TRADELISTMAX - 1 do begin
      if TradeDataArr [i].rName [0] = 0 then break;
      if Str <> '' then Str := Str + ',';
      with TradeDataArr [i] do begin
         rdStr := format ('%s:%d:%d:%d:%d', [StrPas (@rName), rShape, rColor, rPrice, rCount]);
         TotalPrice := TotalPrice + (rPrice * rCount);
      end;
      Str := Str + rdStr;
   end;

   pdi := PTSSetTradeItem (@ComData.Data);
   pdi^.rMsg := SM_SETTRADEITEM;
   pdi^.rTotalPrice := TotalPrice;
   SetWordString (pdi^.rWordString, Str);

   ComData.Size := SizeOf (TSSetTradeItem) - WORDSTRINGSIZE + SizeOfWordString (pdi^.rWordString);

   FSendClass.SendData (ComData);
end;

procedure TShowWindowClass.SetSaleItem;
var
   i, TotalPrice : Integer;
   Str, rdStr : String;
   pdi : PTSSetTradeItem;
   ComData : TWordComData;
begin
   TotalPrice := 0;
   Str := '';
   for i := 0 to SALELISTMAX - 1 do begin
      if SaleDataArr [i].rName [0] = 0 then break;
      if Str <> '' then Str := Str + ',';
      with SaleDataArr [i] do begin
         rdStr := format ('%s:%d:%d:%d:%d:%d', [StrPas (@rName), rShape, rColor, rPrice, rCount, rTotalCount]);
         TotalPrice := TotalPrice + (rPrice * rCount);
      end;
      Str := Str + rdStr;
   end;

   pdi := PTSSetTradeItem (@ComData.Data);
   pdi^.rMsg := SM_SETTRADEITEM;
   pdi^.rTotalPrice := TotalPrice;
   SetWordString (pdi^.rWordString, Str);

   ComData.Size := SizeOf (TSSetTradeItem) - WORDSTRINGSIZE + SizeOfWordString (pdi^.rWordString);

   FSendClass.SendData (ComData);
end;

procedure TShowWindowClass.SetIndividualMarketItem;
var
   i, TotalPrice : Integer;
   Str, rdStr : String;
   pdi : PTSSetTradeItem;
   pMarketItem : PTIndividualMarketItem;
   ComData : TWordComData;
begin
   if (NATION_VERSION = NATION_CHINA_1) or (NATION_VERSION = NATION_CHINA_1_TEST) then exit;

   TotalPrice := 0;
   Str := '';

   for i := 0 to CopyMarketDataList.Count - 1 do begin
      pMarketItem := CopyMarketDataList.Items [i];
      if pMarketItem^.rName [0] = 0 then break;
      if Str <> '' then Str := Str + ',';
      with pMarketItem^ do begin
         rdStr := format ('%s:%d:%d:%d:%d:%d', [StrPas (@rName), rShape, rColor, rCost, rCount, rTotalCount]);
         TotalPrice := TotalPrice + (rCost * rCount);
      end;
      Str := Str + rdStr;
   end;

   pdi := PTSSetTradeItem (@ComData.Data);
   pdi^.rMsg := SM_SETTRADEITEM;
   pdi^.rTotalPrice := TotalPrice;
   SetWordString (pdi^.rWordString, Str);

   ComData.Size := SizeOf (TSSetTradeItem) - WORDSTRINGSIZE + SizeOfWordString (pdi^.rWordString);

   FSendClass.SendData (ComData);
end;

procedure TShowWindowClass.GetExchangeData (var aExchangeData : TExchangeData);
begin
   aExchangeData := ExchangeData;
end;

procedure TShowWindowClass.SetExchangeData (aExchangeData : TExchangeData);
begin
   ExchangeData := aExchangeData;
end;

procedure TShowWindowClass.SelectHelpWindow (aData : PChar);
var
   pCSelectHelpWindow : PTCSelectHelpWindow;
   SelectKey : String;
begin
   pCSelectHelpWindow := PTCSelectHelpWindow (aData);

   SelectKey := GetWordString (pCSelectHelpWindow^.rSelectKey);

   if ( FCurrentWindow <> swk_none ) and ( FCurrentWindow <> swk_help ) then exit;
   if SelectKey = '' then exit;
   //if ( CurrentWindow = swk_exchange ) or
   //   ( CurrentWindow = swk_itemlog ) then exit;
   if SelectKey = 'open' then begin
      ShowHelpWindow ('0.ahp', '');
      exit;
   end;

   FCurrentWindow := swk_none;
   FCurrentSubType := sst_none;

   if SelectKey = 'close' then exit;
   if FCommander = nil then exit;
   if FCommander.ServerID <> TUser (FUser).ServerID then exit;
   if GetCellLength (TUser (FUser).BasicData.x, TUser (FUser).BasicData.y, FCommander.BasicData.x, FCommander.BasicData.y) > 15 then exit;

   try
      FCommander.PutResult (FUser, SelectKey);
   except
      frmMain.WriteLogInfo (format ('Showwindowclass.SelectHelpWindow - %s', [SelectKey]));         
   end;

//   FCommander := nil;
end;

// add by Orber at 2004-12-23 11:06:02
procedure TShowWindowClass.SelectMarryWindow (aData : PChar);
var
   pcSelectHelpWindow : PTCSelectHelpWindow;
   Selectkey : String;
   aUser :TUser;
begin
   pcSelectHelpWindow := PTCSelectHelpWindow (aData);

   SelectKey := GetWordString (pCSelectHelpWindow^.rSelectKey);

   if ( FCurrentWindow <> swk_none ) and ( FCurrentWindow <> swk_marry ) then exit;
   
   FCurrentWindow := swk_none;
   FCurrentSubType := sst_none;

   if SelectKey = '' then exit;
   if FCommander = nil then exit;
   if FCommander.ServerID <> TUser (FUser).ServerID then exit;
   if GetCellLength (TUser (FUser).BasicData.x, TUser (FUser).BasicData.y, FCommander.BasicData.x, FCommander.BasicData.y) > 15 then exit;

    aUser := UserList.GetUserPointer(SelectKey);
    if aUser = nil then begin
        FCommander.SSay(Conv('该玩家并不在线,无法完成求婚.'));
        FCommander := nil;
        Exit;
    end;

    if Not aUser.MarryEnable then begin
        FCommander.SSay(Conv('该玩家不接受任何求婚.'));
        FCommander := nil;
        Exit;
    end;

    if aUser.Lover <> '' then begin
        FCommander.SSay(Conv('该玩家已经结婚.'));
        FCommander := nil;
        Exit;
    end;

    if aUser.Name = TUser (FUser).Name then begin
        FCommander.SSay(Conv('疯了？'));
        FCommander := nil;
        Exit;
    end;
    if aUser.SGetSex = TUser (FUser).SGetSex then begin
        FCommander.SSay(Conv('同性别无法结婚.'));
        FCommander := nil;
        Exit;
    end;
    FCommander.SSay(Conv('正在向该玩家发出求婚...'));
    aUser.MarryAnswerWindow(TUser (FUser).Name ,TUser (FUser).Name + Conv('向你求婚?你愿意嫁给他么?'));
//   FCommander := nil;
end;

procedure TShowWindowClass.Marry(aUser:String;aAnswer:Byte);
var
   rUser :TUser;
begin
    if FCommander = nil then exit;
    if FCommander.ServerID <> TUser (FUser).ServerID then exit;
    rUser := UserList.GetUserPointer(aUser);
    if rUser = nil then begin
        FCommander.SSay(Conv('该玩家并不在线,无法完成求婚.'));
//        TUser (FUser).SendClass.SendChatMessage ('该玩家并不在线,无法完成求婚.', SAY_COLOR_SYSTEM);
        Exit;
    end;
    case aAnswer of
        0:
        begin
            FCommander.SSay(rUser.Name + Conv('拒绝了你的求婚.'));
        end;
        1:
        begin
            FCommander.SSay(rUser.Name + Conv('已经接受了你的求婚,恭喜你们喜结良缘'));
            TUser(FUser).SSendTopMessage( TUser(FUser).Name +Conv('和')+ rUser.Name + Conv('喜结良缘'));
        end;
        2:
        begin
            FCommander.SSay(rUser.Name + Conv('虽然答应了你的求婚,但是你们没有足够的空间接受喜帖。'));
        end;
        3:
        begin
            FCommander.SSay(rUser.Name + Conv('虽然答应了你的求婚,但是你们没有足够的钱币。'));
        end;
        4:
        begin
            FCommander.SSay(rUser.Name + Conv('双方有一方已经结婚，所以无法完成求婚。'));
        end;
    end;
    FCommander := nil;
end;

procedure TShowWindowClass.SelectMarryAnswerWindow (aData : PChar);
var
   pcSelectHelpWindow : PTCSelectHelpWindow;
   Selectkey : String;
   ItemData : TItemData;
   aUser :TUser;
begin
   pcSelectHelpWindow := PTCSelectHelpWindow (aData);

   SelectKey := GetWordString (pCSelectHelpWindow^.rSelectKey);

   if ( FCurrentWindow <> swk_none ) and ( FCurrentWindow <> swk_marryanswer ) then exit;

   aUser := UserList.GetUserPointer(TUser(FUser).PreLover);
   if aUser = nil then begin
        TUser (FUser).SSendChatMessage (Conv('求婚玩家已经掉线,无法完成求婚.'), SAY_COLOR_SYSTEM);
        Exit;
   end;

   FCurrentWindow := swk_none;
   FCurrentSubType := sst_none;

   if SelectKey = '' then exit;
   if SelectKey = 'no' then begin  //拒绝求婚
      TUser (FUser).PreLover := '';
      aUser.Marry(TUser(FUser).Name,0);
   end else begin
        ItemClass.GetItemData (Conv('钱币'), ItemData);
        ItemData.rCount := 100000;
        if (not TUser(FUser).SGetItemCount(ItemData,100000)) or (not aUser.SGetItemCount(ItemData,100000)) then begin
            aUser.Marry(TUser(FUser).Name,3);
            TUser (FUser).SSendChatMessage (Conv('没有足够的钱币完成求婚.'), SAY_COLOR_SYSTEM);
            exit;
        end;
        if (TUser(FUser).Lover <> '') or (aUser.Lover <> '') then begin
            aUser.Marry(TUser(FUser).Name,4);
            Exit;
        end;
        if (TUser(FUser).SCheckEnoughSpace(1) = 'true') and (aUser.SCheckEnoughSpace(1) = 'true') then begin
            TUser(FUser).DeleteItem(@ItemData);
            aUser.DeleteItem(@ItemData);
            ItemClass.GetItemData (Conv('喜帖'), ItemData);
            ItemData.rCount := 10;
            TUser(FUser).AddItem(ItemData);
            aUser.AddItem(ItemData);
            TUser(FUser).Lover        := aUser.Name;
            aUser.Lover               := TUser(FUser).Name;
            TUser (FUser).PreLover    := '';
            MarryList.AddMarry(aUser.Name,TUser(FUser).Name);
            aUser.Marry(TUser(FUser).Name,1);
        end else begin
            aUser.Marry(TUser(FUser).Name,2);
        end;
   end;
end;

procedure TShowWindowClass.SelectGuildAnswerWindow (aData : PChar);
var
   pcSelectHelpWindow : PTCSelectHelpWindow;
   Selectkey : String;
   ItemData : TItemData;
   aGuildObject : TGuildObject;
   aUser :TUser;
begin
   pcSelectHelpWindow := PTCSelectHelpWindow (aData);

   SelectKey := GetWordString (pCSelectHelpWindow^.rSelectKey);

   if ( FCurrentWindow <> swk_none ) and ( FCurrentWindow <> swk_guildanswer ) then exit;

   FCurrentWindow := swk_none;
   FCurrentSubType := sst_none;

   aUser := UserList.GetUserPointer(TUser(FUser).InviteGuildMaster);
   TUser(FUser).InviteGuildMaster := '';
   if aUser = nil then begin
        TUser (FUser).SSendChatMessage (Conv('邀请者已经下线,无法加入该门派.'), SAY_COLOR_SYSTEM);
        Exit;
   end;
   if aUser.GuildName = '' then Exit;
   if SelectKey = '' then exit;
    aGuildObject := GuildList.GetGuildObject(aUser.GuildName);
    if aGuildObject = nil then exit;
   if SelectKey = 'yes' then begin  //拒绝求婚
        if (aUser.Name <> aGuildObject.GetSelfData.Sysop)
        and (aUser.Name <> aGuildObject.GetSelfData.SubSysop[0])
        and (aUser.Name <> aGuildObject.GetSelfData.SubSysop[1])
        and (aUser.Name <> aGuildObject.GetSelfData.SubSysop[2])
        then exit;
        TUser(FUser).GuildName := aUser.GuildName;
        StrPCopy (@TUser(FUser).BasicData.Guild, aUser.GuildName);
        aGuildObject.AddUser (TUser(FUser).Name);
        TUser(FUser).BocChangeProperty;
        aGuildObject.BocSay(format (Conv('加入了%s'),[TUser(FUser).Name]));
   end else begin
        aGuildObject.BocSay(format (Conv('%s拒绝了你的加入门派邀请'),[TUser(FUser).Name]));
   end;
end;

procedure TShowWindowClass.SelectGuildItemWindow (aData : PChar);
var
   pcSelectHelpWindow : PTCSelectHelpWindow;
   Selectkey : String;
   sPage:Word;
begin
   pcSelectHelpWindow := PTCSelectHelpWindow (aData);

   SelectKey := GetWordString (pCSelectHelpWindow^.rSelectKey);

   if ( FCurrentWindow <> swk_none ) and ( FCurrentWindow <> swk_itemlog ) then exit;

   FCurrentWindow := swk_none;

   sPage := StrToIntDef(SelectKey,1);
   ShowGuildItemLogWindow(sPage);

end;

// add by Orber at 2005-01-11 11:32:10
procedure TShowWindowClass.SelectInputGuildNameWindow (aData : PChar);
var
   pcInputGuildWindow : PTCInputGuildWindow;
   Selectkey : String;
   sPage:Word;
   GuildObject:TGuildObject;
   ItemData : TItemData;
   ItemName :String;
begin
   pcInputGuildWindow := PTCInputGuildWindow (aData);

   SelectKey := GetWordString (pcInputGuildWindow^.rSelectKey);

   if ( FCurrentWindow <> swk_none ) and ( FCurrentWindow <> swk_inputguildname ) then exit;
   FCurrentWindow := swk_none;
   FCurrentSubType := sst_none;
   if SelectKey = '' then begin
       Exit;
   end;
   if GetStringLength(SelectKey) > 6 then begin
        TUser (FUser).SSendChatMessage(Conv('门派名称太长，请取回门石重新操作'), SAY_COLOR_SYSTEM);
        exit;
   end;
   if GuildList.AllowGuildCondition (SelectKey, TUser(FUser).Name) then begin
// add by minds 050902
      GuildList.AllowGuildName(pcInputGuildWindow^.rSenderID,
        not GateList.IsOwnGateGuild(SelectKey), SelectKey, TUser(FUser).Name);
//        GuildList.AllowGuildName(pcInputGuildWindow^.rSenderID,TRUE,SelectKey,TUser(FUser).Name);
   end else begin
        TUser (FUser).SSendChatMessage(Conv('您已经执掌了门派，无法再次申请，请收回门石。'), SAY_COLOR_SYSTEM);
   end;
   //建立门派
end;

// add by Orber at 2005-01-12 02:23:53
//门派银行取钱确认

procedure TShowWindowClass.SelectInputGuildMoneyChipWindow (aData : PChar);
var
   pcSelectHelpWindow : PTCSelectHelpWindow;
   Selectkey : String;
   MoneyChips :integer;
  GuildObject : TGuildObject;
  GuildUser : PTGuildUserData;
  ItemData : TItemData;
begin
   pcSelectHelpWindow := PTCSelectHelpWindow (aData);

   SelectKey := GetWordString (pCSelectHelpWindow^.rSelectKey);

   if ( FCurrentWindow <> swk_none ) and ( FCurrentWindow <> swk_guildinfo ) then exit;
   FCurrentWindow := swk_none;
   FCurrentSubType := sst_none;
   MoneyChips := StrToIntDef(SelectKey,0);
   if (MoneyChips < 400) or (MoneyChips > 100000) then begin
        TUser (FUser).SSendChatMessage (Conv('不在规定额度，请重新输入'), SAY_COLOR_SYSTEM);
        exit;
   end;
    GuildObject := GuildList.GetGuildObject(TUser(FUser).GuildName);
    if GuildObject = nil then begin
        TUser(FUser).SSendChatMessage (Conv('您还没有加入门派，不能享受此种优惠'), SAY_COLOR_SYSTEM);
        Exit;
    end;
    GuildUser := GuildObject.GetUser(TUser(FUser).Name);
    if  GuildUser^.rName = '' then begin
        TUser(FUser).SSendChatMessage (Conv('你可能还没有加入该门派'), SAY_COLOR_SYSTEM);
        Exit;
    end;
    if GuildUser^.rLastDate = DateToStr(Date) then begin
        TUser(FUser).SSendChatMessage (Conv('今日你已申请过了'), SAY_COLOR_SYSTEM);
        Exit;
    end;
    if GuildUser^.rLoadMoney >= 300000 then begin
        TUser(FUser).SSendChatMessage (Conv('你向银行申请的钱币已超额了'), SAY_COLOR_SYSTEM);
        Exit;
    end;
    if GuildObject.Bank <= 2000000 then begin
        TUser(FUser).SSendChatMessage (Conv('门派银行资金不足'), SAY_COLOR_SYSTEM);
        Exit;
    end;
    ItemClass.GetItemData(Conv('门派钱令'),ItemData);
    ItemData.rCount := 1;
    if TUser(FUser).SGetItemCount(ItemData,1) then begin
        TUser(FUser).SSendChatMessage (Conv('你还有门派钱令尚未使用'), SAY_COLOR_SYSTEM);
        Exit;
    end;
    if TUser(FUser).AddItem(ItemData) then begin
        GuildUser^.rMoneyChip := MoneyChips;
        GuildObject.UserChange;
        TUser(FUser).SSendChatMessage (Conv('门派钱令申请成功，请到门主处兑换'), SAY_COLOR_SYSTEM);
    end;
end;

procedure TShowWindowClass.SelectInputGuildSubSysopWindow (aData : PChar);
var
  pcSelectHelpWindow : PTCSelectHelpWindow;
  Selectkey : String;
  GuildSysop : String;
  GuildObject : TGuildObject;
  aUser : TUser;
begin
   pcSelectHelpWindow := PTCSelectHelpWindow (aData);

   SelectKey := GetWordString (pCSelectHelpWindow^.rSelectKey);

   if ( FCurrentWindow <> swk_none ) and ( FCurrentWindow <> swk_guildsubsysop ) then exit;
   FCurrentWindow := swk_none;
   FCurrentSubType := sst_none;
   if SelectKey = 'no' then begin
        GuildObject := GuildList.GetGuildObject(TUser(FUser).GuildName);
        GuildSysop := GuildObject.GetGuildSysop;
        aUser := UserList.GetUserPointer(GuildSysop);
        if aUser =  nil then exit;
        aUser.SSendChatMessage (Conv('副门主拒绝了你的让位要求'), SAY_COLOR_SYSTEM);
        exit;
   end;
   if SelectKey = 'yes' then begin
        GuildObject := GuildList.GetGuildObject(TUser(FUser).GuildName);
        GuildSysop := GuildObject.GetGuildSysop;
        GuildObject.SetGuildSysop(TUser(FUser).Name);
        aUser := UserList.GetUserPointer(GuildSysop);
        if aUser <>  nil then aUser.SSendChatMessage (Conv('副门主接受了你的让位要求'), SAY_COLOR_SYSTEM);
        UserList.GuildSay(TUser(FUser).GuildName,format(Conv('%s门主改为%s'),[TUser(FUser).GuildName,TUser(FUser).Name]));
        exit;
   end;
end;

procedure TShowWindowClass.SelectInputArenaWindow (aData : PChar);
var
  pcSelectHelpWindow : PTCSelectHelpWindow;
  Selectkey : String;
  GuildSysop : String;
  GuildObject : TGuildObject;
  aUser : TUser;
begin
   pcSelectHelpWindow := PTCSelectHelpWindow (aData);

   SelectKey := GetWordString (pCSelectHelpWindow^.rSelectKey);

   if ( FCurrentWindow <> swk_none ) and ( FCurrentWindow <> swk_arena ) then exit;
   FCurrentWindow := swk_none;
   FCurrentSubType := sst_none;
   if SelectKey = 'yes' then begin
        if not ArenaObjList.SelectMaster(TUser(FUser).aArenaBody,TUser(FUser)) then
            TUser(FUser).SSendChatMessage(Conv('抱歉，当前擂台已被占用，请稍候再尝试'),SAY_COLOR_SYSTEM);
        exit;
    end else begin
        TUser(FUser).aArenaBody := '';
    end;
end;

procedure TShowWindowClass.SelectInputArenaJoinWindow (aData : PChar);
var
  pcSelectHelpWindow : PTCSelectHelpWindow;
  Selectkey : String;
  GuildSysop : String;
  GuildObject : TGuildObject;
  aUser : TUser;
  nByte :Integer;
begin
   pcSelectHelpWindow := PTCSelectHelpWindow (aData);

   SelectKey := GetWordString (pCSelectHelpWindow^.rSelectKey);

   if ( FCurrentWindow <> swk_none ) and ( FCurrentWindow <> swk_arena ) then exit;
   FCurrentWindow := swk_none;
   FCurrentSubType := sst_none;
   if SelectKey = 'yes' then begin
        nByte := ArenaObjList.AddMember(TUser(FUser).aArenaIndex, TUser(FUser));
        case nByte of
            -1 :
                TUser(FUser).SendClass.SendChatMessage(Conv('该擂台激战正酣！'),SAY_COLOR_SYSTEM);
            -2 :
                TUser(FUser).SendClass.SendChatMessage(Conv('该擂台没有招亲活动！'),SAY_COLOR_SYSTEM);
            -3 :
                TUser(FUser).SendClass.SendChatMessage(Conv('你正在参加其他擂台活动！'),SAY_COLOR_SYSTEM);
        end;
    end else begin
        TUser(FUser).aArenaIndex := 0;
    end;
end;

procedure TShowWindowClass.SelectInputGuildMoneyApplyWindow (aData : PChar);
var
   pcSelectHelpWindow : PTCSelectHelpWindow;
   Selectkey : String;
    GuildObject : TGuildObject;
    GuildUser : PTGuildUserData;
    ItemData : TItemData;
    aUser : TUser;
begin
   pcSelectHelpWindow := PTCSelectHelpWindow (aData);

   SelectKey := GetWordString (pCSelectHelpWindow^.rSelectKey);

   if ( FCurrentWindow <> swk_none ) and ( FCurrentWindow <> swk_guildinfo ) then exit;
   FCurrentWindow := swk_none;
   FCurrentSubType := sst_none;
   if SelectKey = 'no' then begin
        aUser := UserList.GetUserPointer(TUser(FUser).PreGuildMoneyApplyer);
        aUser.SSendChatMessage (Conv('门主拒绝了你的提款要求'), SAY_COLOR_SYSTEM);
        TUser(FUser).PreGuildMoneyApplyer := '';
        exit;
   end;
   if SelectKey = 'yes' then begin
        aUser := UserList.GetUserPointer(TUser(FUser).PreGuildMoneyApplyer);
        if aUser = nil then begin
            TUser(FUser).SSendChatMessage(Conv('对方已经下线，无法完成提款'), SAY_COLOR_SYSTEM);
            TUser(FUser).PreGuildMoneyApplyer := '';
            Exit;
        end;
        TUser(FUser).PreGuildMoneyApplyer := '';
        GuildObject := GuildList.GetGuildObject(TUser(FUser).GuildName);
        GuildUser := GuildObject.GetUser(aUser.Name);
        if  GuildUser^.rName = '' then begin
            aUser.SSendChatMessage (Conv('你可能还没有加入该门派'), SAY_COLOR_SYSTEM);
            Exit;
        end;
        if GuildUser^.rLastDate = DateToStr(Date) then begin
            aUser.SSendChatMessage (Conv('今日你已申请过了'), SAY_COLOR_SYSTEM);
            Exit;
        end;
        if GuildUser^.rLoadMoney >= 300000 then begin
            aUser.SSendChatMessage (Conv('你向银行申请的钱币已超额了'), SAY_COLOR_SYSTEM);
            Exit;
        end;
        if GuildObject.Bank <= 2000000 then begin
            aUser.SSendChatMessage (Conv('门派银行资金不足'), SAY_COLOR_SYSTEM);
            Exit;
        end;
        ItemClass.GetItemData(Conv('门派钱令'),ItemData);
        ItemData.rCount := 1;
        if aUser.DeleteItem(@ItemData) then begin
            ItemClass.GetItemData(Conv('钱币'),ItemData);
            ItemData.rCount := GuildUser^.rMoneyChip;
            aUser.AddItem(ItemData);
            Inc(GuildUser^.rLoadMoney,GuildUser^.rMoneyChip);
            Dec(GuildObject.Bank,GuildUser^.rMoneyChip);
            aUser.SSendChatMessage(Conv('你已经被获准提取门派银行的') +
                                   IntToStr(GuildUser^.rMoneyChip) +
                                   Conv('钱币'), SAY_COLOR_SYSTEM);
            GuildUser^.rMoneyChip := 0;
            GuildUser^.rLastDate := DateToStr(Date);
            GuildObject.UserChange;
        end else begin
            aUser.SSendChatMessage (Conv('你没有门派钱令了'), SAY_COLOR_SYSTEM);
            Exit;
        end;
    end;
end;

procedure TShowWindowClass.SelectUnMarryWindow (aData : PChar);
var
   pcSelectHelpWindow : PTCSelectHelpWindow;
   Selectkey : String;
   ItemData : TItemData;
   aUser : TUser;
begin
   pcSelectHelpWindow := PTCSelectHelpWindow (aData);

   SelectKey := GetWordString (pCSelectHelpWindow^.rSelectKey);

   if ( FCurrentWindow <> swk_none ) and ( FCurrentWindow <> swk_marry ) then exit;
   
   FCurrentWindow := swk_none;
   FCurrentSubType := sst_none;

   if SelectKey = '' then exit;
   if SelectKey = 'yes' then begin  //同意离婚
        aUser := UserList.GetUserPointer(TUser(FUser).Lover);
        ItemClass.GetItemData (Conv('钱币'), ItemData);
        ItemData.rCount := 200000;
        if Not aUser.DeleteItem(@ItemData) then begin
            aUser.SSendChatMessage(Conv('没有足够的离婚资金.'), SAY_COLOR_SYSTEM);
            Exit;
        end;
        aUser.Lover := '';
        TUser (FUser).Lover := '';
        MarryList.UnMarryNow(aUser.Name);
        aUser.SSendChatMessage(Conv('离婚成功.'), SAY_COLOR_SYSTEM);
        TUser (FUser).SSendChatMessage(Conv('离婚成功.'), SAY_COLOR_SYSTEM);
   end else begin
        aUser := UserList.GetUserPointer(TUser(FUser).Lover);
        ItemClass.GetItemData (Conv('钱币'), ItemData);
        ItemData.rCount := 200000;
        if Not aUser.DeleteItem(@ItemData) then begin
            aUser.SSendChatMessage(Conv('没有足够的离婚资金.'), SAY_COLOR_SYSTEM);
            Exit;
        end;
        MarryList.UnMarry(aUser.Name);
        aUser.SSendChatMessage(Conv('对方拒绝了你的离婚要求，7天以后将会自动解除婚约.'), SAY_COLOR_SYSTEM);
   end;

end;

procedure TShowWindowClass.SelectTradeWindow (aData : PChar);
var
   pcSelectHelpWindow : PTCSelectHelpWindow;
   Selectkey : String;
begin
   pcSelectHelpWindow := PTCSelectHelpWindow (aData);

   SelectKey := GetWordString (pCSelectHelpWindow^.rSelectKey);

   if SelectKey = '' then exit;
   if ( FCurrentWindow <> swk_none ) and ( FCurrentWindow <> swk_help ) then exit;
   
   FCurrentWindow := swk_none;
   FCurrentSubType := sst_none;

   if SelectKey = 'close' then exit;
   if FCommander = nil then exit;
   if FCommander.ServerID <> TUser (FUser).ServerID then exit;
   if GetCellLength (TUser (FUser).BasicData.x, TUser (FUser).BasicData.y, FCommander.BasicData.x, FCommander.BasicData.y) > 15 then exit;

   FCommander.PutResult (FUser, SelectKey);
//   FCommander := nil;
end;

procedure TShowWindowClass.SelectItemWindow (pcClick : PTCClick);
var
   nPos : Integer;
   ItemData : TItemData;
   Str, ViewName : String;
   tmpExchangeData : TExchangeData;
   User : TUser;
   pMarketItem : PTIndividualMarketItem;
begin
   case pcClick^.rwindow of
      WINDOW_EXCHANGE : begin
         nPos := pcClick^.rKey;
         if (nPos >= 0) and (nPos < 4) then begin
            Move (ExchangeData, tmpExchangeData, SizeOf (TExchangeData));
         end else if (nPos >= 4) and (nPos < 8) then begin
            User := TUser (TBasicObject (FUser).GetViewObjectByID (ExchangeData.rExChangeId));
            if User = nil then exit;

            User.GetExchangeData (tmpExchangeData);
         end else begin
            exit;
         end;
         if nPos >= 4 then Dec (nPos, 4);
         if tmpExchangeData.rItems [nPos].rItemName = '' then exit;

         Str := tmpExchangeData.rItems [nPos].rItemName;
         ItemClass.GetItemData (Str, ItemData);
         if ItemData.rName [0] = 0 then exit;
         ItemData.rUpgrade := tmpExchangeData.rItems [nPos].rUpgrade;
         ItemData.rAddType := tmpExchangeData.rItems [nPos].rAddtype;         
         ItemData.rDurability := tmpExchangeData.rItems [nPos].rDurability;
         ItemData.rCurDurability := tmpExchangeData.rItems [nPos].rCurDurability;
         JobClass.GetUpgradeItemLifeData (ItemData);
         if ItemData.rAddType <> 0 then ItemClass.GetAddItemAttribData (ItemData);         
      end;
      WINDOW_TRADE : begin
         nPos := pcClick^.rkey;
         if TradeDataArr [nPos].rName [0] = 0 then exit;
         ItemClass.GetItemData (StrPas (@TradeDataArr [nPos].rName), ItemData);
         if ItemData.rName [0] = 0 then exit;
      end;
      WINDOW_SALE : begin
         nPos := pcClick^.rkey;

         if SaleDataArr [nPos].rName [0] = 0 then exit;
         ItemClass.GetItemData (StrPas (@SaleDataArr [nPos].rName), ItemData);
         if ItemData.rName [0] = 0 then exit;
      end;
      WINDOW_INDIVIDUALMARKET : begin
         if (NATION_VERSION = NATION_CHINA_1) or (NATION_VERSION = NATION_CHINA_1_TEST) then exit;
               
         nPos := pcClick^.rkey;
         if (nPos < 0) or (nPos >= CopyMarketDataList.Count) then exit;

         pMarketitem := CopyMarketDataList.Items [nPos];
         if pMarketItem^.rName [0] = 0 then exit;
         ItemClass.GetItemData (StrPas (@pMarketItem^.rName), ItemData);
         if ItemData.rName [0] = 0 then exit;
         ItemData.rUpgrade := pMarketItem^.rUpgrade;
         ItemData.rAddType := pMarketItem^.rAddType;         
         ItemData.rDurability := pMarketItem^.rDurability;
         ItemData.rCurDurability := pMarketItem^.rCurDurability;
         ItemData.rPrice := pMarketItem^.rCost;
         JobClass.GetUpgradeItemLifeData (ItemData);
         ItemClass.GetAddItemAttribData (ItemData);         
      end;
   end;

   case ItemData.rKind of
      ITEM_KIND_WEARITEM, ITEM_KIND_WEARITEM2, ITEM_KIND_CAP, ITEM_KIND_PICKAX, ITEM_KIND_HIGHPICKAX, ITEM_KIND_DURAWEAPON :
         begin
            if ItemData.rUpgrade <> 0 then begin
               ViewName := format (Conv('%s %d级'), [StrPas (@ItemData.rViewName), ItemData.rUpgrade]);
            end else begin
               ViewName := StrPas (@ItemData.rViewName);
            end;
         end;
      Else
         begin
            ViewName := StrPas (@ItemData.rViewName);
         end;
   end;
   Str := GetMiniItemContents2 (ItemData, TUserObject (FUser).PowerLevel);
   FSendClass.SendShowItemWindow2 (ViewName, Str, ItemData.rShape, ItemData.rcolor, ItemData.rPrice, ItemData.rGrade , ItemData.rLockState , ItemData.runLockTime);
end;

procedure TShowWindowClass.SetCurrentWindow (aSWK : TSpecialWindowKind; aSST : TSpecialSubType);
begin
   FCurrentWindow := aSWK;
   FCurrentSubType := aSST;
end;

procedure TShowWindowClass.AddSaleItem (aName : String; aCount : Integer);
var
   pCheckItem : PTCheckItem;
   i : Integer;
begin
//   if SaleItemList = nil then SaleItemList := TList.Create;
   if SaleItemList = nil then exit;

   for i := 0 to SaleItemList.Count - 1 do begin
      pCheckItem := SaleItemList.Items [i];
      if StrPas (@pCheckItem^.rName) = aName then begin
         inc (pCheckItem^.rCount, aCount);
         exit;
      end; 
   end;

   New (pCheckItem);
   StrPCopy (@pCheckItem^.rName, aName);
   pCheckItem^.rCount := aCount;

   SaleItemList.Add(pCheckItem); 
end;

procedure TShowWindowClass.ClearCopyMarketDataList;
var
   i : Integer;
   pMarketItem : PTIndividualMarketItem;
begin
   if CopyMarketDataList <> nil then begin
      for i := 0 to CopyMarketDataList.Count - 1 do begin
         pMarketItem := CopyMarketDataList.Items [i];
         if pMarketItem <> nil then Dispose (pMarketItem);
      end;
      CopyMarketDataList.Clear;
   end;
end;


// THaveMarketClass;
constructor THaveMarketClass.Create (aBasicObject : TBasicObject; aSendClass : TSendClass;
   aAttribClass : TAttribClass; aHaveItemClass : THaveItemClass);
begin
   FBasicObject := aBasicObject;
   FSendClass := aSendClass;
   FAttribClass := aAttribClass;
   FHaveItemClass := aHaveItemClass;

   SetMarketCount;
   MarketCaption := '';
   FboMarketing := false;
end;

destructor THaveMarketClass.Destroy;
begin
   inherited Destroy;
end;

procedure THaveMarketClass.LoadFromSdb (aCharData : PTDBRecord);
var
   i : Integer;
   Str : String;
begin
   FillChar (HaveMarketArr, SizeOf (HaveMarketArr), 0);

   for i := 0 to HAVEMARKETITEMSIZE - 1 do begin
      Str := StrPas (@aCharData^.HaveMarketItemArr [i].Name) + ':' +
         IntToStr (aCharData^.HaveMarketItemArr [i].Color) + ':' +
         IntToStr (aCharData^.HaveMarketItemArr [i].Count) + ':' +
         IntToStr (aCharData^.HaveMarketItemArr [i].Durability) + ':' +
         IntToStr (aCharData^.HaveMarketItemArr [i].CurDurability) + ':' +
         IntToStr (aCharData^.HaveMarketItemArr [i].UpGrade) + ':' +
         IntToStr (aCharData^.HaveMarketItemArr [i].AddType) + ':' +         
         IntToStr (aCharData^.HaveMarketItemArr [i].Cost);

      ItemClass.GetMarketItemData (Str, HaveMarketArr [i]);
      JobClass.GetUpgradeItemLifeData (HaveMarketArr [i]);
      ItemClass.GetAddItemAttribData (HaveMarketArr [i]);      
   end;

   for i := 0 to HAVEMARKETITEMSIZE - 1 do begin
      FSendClass.SendMarketItem (i, HaveMarketArr [i]);
   end;
end;

procedure THaveMarketClass.SaveToSdb (aCharData : PTDBRecord);
var
   i : Integer;
   Str, rdStr : String;
begin
   for i := 0 to HAVEMARKETITEMSIZE - 1 do begin
      Str := ItemClass.GetMarketItemString (HaveMarketArr [i]);
      Str := GetValidStr3 (Str, rdStr, ':');
      StrPCopy (@aCharData^.HaveMarketItemArr [i].Name, rdStr);
      str := GetValidStr3 (Str, rdStr, ':');
      aCharData^.HaveMarketItemArr[i].Color := _StrToInt (rdStr);
      str := GetValidStr3 (Str, rdStr, ':');
      aCharData^.HaveMarketItemArr[i].Count := _StrToInt (rdStr);
      str := GetValidStr3 (str, rdStr, ':');
      aCharData^.HaveMarketItemArr[i].Durability := _StrToInt (rdStr);
      str := GetValidStr3 (str, rdStr, ':');
      aCharData^.HaveMarketItemArr[i].CurDurability := _StrToInt (rdStr);
      str := GetValidStr3 (str, rdStr, ':');
      aCharData^.HaveMarketItemArr[i].Upgrade := _StrToInt (rdStr);
      str := GetValidStr3 (str, rdStr, ':');
      aCharData^.HaveMarketItemArr[i].AddType := _StrToInt (rdStr);
      str := GetValidStr3 (str, rdStr, ':');
      aCharData^.HaveMarketItemArr[i].Cost := _StrToInt (rdStr);
   end;
end;

function THaveMarketClass.AddMarketItem  (var aItemData: TItemData): Boolean;
var
   i : Integer;
begin                    
   Result := FALSE;
   if (NATION_VERSION = NATION_CHINA_1) or (NATION_VERSION = NATION_CHINA_1_TEST) then exit;

   if CheckAddableMarketData (aItemData) = -1 then exit;

   if aItemData.rboDouble then begin
      for i := 1 to HAVEMARKETITEMSIZE - 1 do begin
         if StrPas (@HaveMarketArr[i].rName) <> StrPas (@aItemData.rName) then continue;
         if HaveMarketArr[i].rColor <> aItemData.rColor then continue;
         if HaveMarketArr[i].rUpgrade <> aItemData.rUpgrade then continue;
         if HaveMarketArr[i].rAddType <> aItemData.rAddType then continue;         

         HaveMarketArr[i].rCount := HaveMarketArr[i].rCount + aItemData.rCount;
         FSendClass.SendMarketItem (i, HaveMarketArr[i]);

         Result := TRUE;
         exit;
      end;
   end;

   for i := 1 to HAVEMARKETITEMSIZE - 1 do begin
      if HaveMarketArr[i].rName[0] = 0 then begin
         Move (aItemData, HaveMarketArr[i], SizeOf (TItemData));
         FSendClass.SendMarketItem (i, HaveMarketArr[i]);
         Result := TRUE;
         exit;
      end;
   end;
end;

function THaveMarketClass.AddKeyMarketItem  (akey : Integer; var aItemData: TItemData): Boolean;
var
   i, nPos : Integer;
begin
   Result := false;
   if (NATION_VERSION = NATION_CHINA_1) or (NATION_VERSION = NATION_CHINA_1_TEST) then exit;   

//   if (aKey < 1) or (aKey > HAVEMARKETITEMSIZE - 1) then exit;
   if (aKey < 1) or (aKey > FMarketCount) then exit;
   if aItemData.rName[0] = 0 then exit;
   if CheckAddableMarketData (aItemData) = -1 then exit;

   nPos := aKey;
   for i := 1 to HAVEMARKETITEMSIZE - 1 do begin
      if StrPas (@HaveMarketArr[i].rName) = StrPas (@aItemData.rName) then begin
         if HaveMarketArr[i].rColor = aItemData.rColor then begin
            if HaveMarketArr[i].rUpgrade = aItemData.rUpgrade then begin
               if HaveMarketArr[i].rAddType = aItemData.rAddType then begin
                  if HaveMarketArr[i].rboDouble = true then begin
                     nPos := i;
                     break;
                  end;
               end;
            end;
         end;
      end;
   end;

   if HaveMarketArr[nPos].rName[0] <> 0 then begin
      if StrPas (@HaveMarketArr[nPos].rName) <> StrPas (@aItemData.rName) then exit;
      if HaveMarketArr[nPos].rColor <> aItemData.rColor then exit;
      if HaveMarketArr[nPos].rUpgrade <> aItemData.rUpgrade then exit;
      if HaveMarketArr[nPos].rAddType <> aItemData.rAddType then exit;      
      if aItemData.rboDouble = false then exit;
      HaveMarketArr[nPos].rCount := HaveMarketArr[nPos].rCount + aItemData.rCount;
   end else begin
      HaveMarketArr[nPos] := aItemData;
   end;

   FSendClass.SendMarketItem (nPos, HaveMarketArr[nPos]);

   Result := true;
end;

function THaveMarketClass.AddGoldItem (var aItemData : TItemData) : Boolean;
var
   nCount : Integer;
begin
   Result := false;
   if (NATION_VERSION = NATION_CHINA_1) or (NATION_VERSION = NATION_CHINA_1_TEST) then exit;   

   if aItemData.rName [0] = 0 then exit;
   if StrPas (@aItemData.rName) <> INI_GOLD then exit;

   nCount := HaveMarketArr[MARKET_GOLD_KEY].rCount + aItemData.rCount;
   if nCount > 30000000 then begin
      TUser (FBasicObject).SendClass.SendChatMessage (Conv('钱额不足'), SAY_COLOR_SYSTEM);
   end;

   if HaveMarketArr[MARKET_GOLD_KEY].rName[0] <> 0 then begin
      if StrPas (@HaveMarketArr[MARKET_GOLD_KEY].rName) <> StrPas (@aItemData.rName) then exit;
      HaveMarketArr[MARKET_GOLD_KEY].rCount := nCount;
   end else begin
      HaveMarketArr[MARKET_GOLD_KEY] := aItemData;
   end;

   FSendClass.SendMarketItem (MARKET_GOLD_KEY, HaveMarketArr[MARKET_GOLD_KEY]);

   Result := true;   
end;

function THaveMarketClass.DeleteKeyMarketItem (aKey : Integer) : Boolean;
begin
   Result := FALSE;
   if (NATION_VERSION = NATION_CHINA_1) or (NATION_VERSION = NATION_CHINA_1_TEST) then exit;   

   if (akey < 0) or (akey > HAVEMARKETITEMSIZE - 1) then exit;

   FillChar (HaveMarketArr [aKey], SizeOf (TItemData), 0);
   FSendClass.SendMarketItem (aKey, HaveMarketArr[akey]);

   Result := TRUE;
end;

function THaveMarketClass.DeletekeyMarketItem (akey, aCount: integer; aItemData : PTItemData): Boolean;
var
   LimitCount : Integer;
begin
   Result := FALSE;
   if (NATION_VERSION = NATION_CHINA_1) or (NATION_VERSION = NATION_CHINA_1_TEST) then exit;   

   if (akey < 0) or (akey > HAVEMARKETITEMSIZE - 1) then exit;

   if (NATION_VERSION = NATION_CHINA_1) or (NATION_VERSION = NATION_CHINA_1_TEST) then begin
      LimitCount := 250;
   end else begin
      LimitCount := 100;
   end;

   if (aItemData^.rPrice * aItemData^.rCount >= LimitCount) or (aItemData^.rcolor <> 1) then begin
      if (aItemData.rName [0] <> 0) and (aItemData^.rOwnerName[0] <> 0) then begin
         FSendClass.SendItemMoveInfo (StrPas(@aItemData.rOwnerName) + ',' + StrPas (@FBasicObject.BasicData.Name) + ',' +
            StrPas(@aItemData^.rName) + ':' + IntToStr (aItemData^.rUpgrade) + ':' + IntToStr (aItemData^.rAddType) + ',' +
            IntToStr(aItemData^.rCount) + ',' + IntToStr(aItemData^.rOwnerServerID) + ',' + IntToStr(aItemData.rOwnerX) + ',' +
            IntToStr(aItemData^.rOwnerY) + ',' + StrPas (@aItemData^.rOwnerIP) + ',', '');
      end;
   end;

   HaveMarketArr [akey].rCount := HaveMarketArr[akey].rCount - aCount;
   if HaveMarketArr [aKey].rCount <= 0 then begin
      FillChar (HaveMarketArr [aKey], SizeOf (TItemData), 0);
   end;

   FSendClass.SendMarketItem (aKey, HaveMarketArr[akey]);

   Result := TRUE;
end;

function THaveMarketClass.DeleteMarketItem (aItemData: PTItemData): Boolean;
var
   i, LimitCount : integer;
begin
   Result := FALSE;
   if (NATION_VERSION = NATION_CHINA_1) or (NATION_VERSION = NATION_CHINA_1_TEST) then exit;   

   LimitCount := 100;

   for i := 0 to HAVEMARKETITEMSIZE - 1 do begin
      if StrPas (@HaveMarketArr[i].rName) = StrPas (@aItemData^.rName) then begin
         if HaveMarketArr[i].rUpgrade = aItemData.rUpgrade then begin
            if HaveMarketArr [i].rCurDurability = aItemData.rCurDurability then begin
               if HaveMarketArr [i].rDurability = aItemData.rDurability then begin
                  if HaveMarketArr [i].rcolor = aItemData.rcolor then begin
                     if HaveMarketArr [i].rCount < aItemData^.rCount then continue;
                     if HaveMarketArr [i].rPrice <> aItemData^.rPrice then continue;

                     if (aItemData^.rPrice * aItemData^.rCount >= LimitCount) or (aItemData^.rcolor <> 1) then begin
                        if (aItemData.rName [0] <> 0) and (aItemData^.rOwnerName[0] <> 0) then begin
                           FSendClass.SendItemMoveInfo (StrPas (@FBasicObject.BasicData.Name) + ',' +
                              StrPas(@aItemData.rOwnerName) + ',' + StrPas(@aItemData^.rName) + ':' + IntToStr (aItemData^.rUpgrade) + ':' +
                              IntToStr (aItemData^.rAddType) + ',' + IntToStr(aItemData^.rCount) + ',' +
                              IntToStr(aItemData^.rOwnerServerID) + ',' + IntToStr(aItemData.rOwnerX) + ',' +
                              IntToStr(aItemData^.rOwnerY) + ',' + StrPas (@aItemData^.rOwnerIP) + ',', '');
                        end;
                     end;

                     HaveMarketArr[i].rCount := HaveMarketArr[i].rCount - aItemData.rCount;
                     if HaveMarketArr[i].rCount = 0 then FillChar (HaveMarketArr[i], sizeof(TItemData), 0);
                     FSendClass.SendMarketItem (i, HaveMarketArr[i]);
                     Result := TRUE;
                     exit;
                  end;
               end;
            end;
         end;
      end;
   end;
end;

function THaveMarketClass.FindItemKeybyName (aName : String) : Integer;
var
   i : Integer;
begin
   Result := -1;
   if (NATION_VERSION = NATION_CHINA_1) or (NATION_VERSION = NATION_CHINA_1_TEST) then exit;   

   for i := 0 to HAVEMARKETITEMSIZE - 1 do begin
      if HaveMarketArr [i].rName [0] = 0 then continue;   
      if StrPas (@HaveMarketArr [i].rName) = aName then begin
         Result := i;
         exit;
      end;
   end;
end;

function THaveMarketClass.CheckAddableMarketData (aItemData : TItemData) : Integer;
var
   i, iCount : Integer;
begin
   Result := -1;
   if (NATION_VERSION = NATION_CHINA_1) or (NATION_VERSION = NATION_CHINA_1_TEST) then exit;   

   if (aItemData.rCount <= 0) or (aItemData.rCount > 100000000) then exit; 

   for i := 1 to HAVEMARKETITEMSIZE - 1 do begin
      if aItemData.rboDouble = false then begin
         if HaveMarketArr [i].rName [0] = 0 then begin
            Result := i;
            exit;
         end;
      end else begin
         if StrPas (@HaveMarketArr [i].rName) = StrPas (@aItemData.rName) then begin
            if HaveMarketArr [i].rColor = aItemData.rColor then begin
               if HaveMarketArr [i].rUpgrade = aItemData.rUpgrade then begin
                  if HaveMarketArr [i].rboDouble = true then begin
                     iCount := HaveMarketArr [i].rCount + aItemData.rCount;
                     if (iCount <= 0) or (iCount > 100000000) then exit;
                     Result := i;
                     exit;
                  end;
               end;
            end;
         end;
      end;
   end;

   if aItemData.rboDouble = true then begin
      for i := 1 to HAVEMARKETITEMSIZE - 1 do begin
         if HaveMarketArr [i].rName [0] = 0 then begin
            Result := i;
            exit;
         end;
      end;
   end;
end;

function THaveMarketClass.ViewMarketItem (akey: integer; aItemData: PTItemData): Boolean;
begin
   Result := FALSE;
   if (NATION_VERSION = NATION_CHINA_1) or (NATION_VERSION = NATION_CHINA_1_TEST) then exit;
      
   FillChar (aItemData^, sizeof(TItemData), 0);

   if (akey < 0) or (akey > HAVEMARKETITEMSIZE - 1) then exit;
   if HaveMarketArr[akey].rName[0] = 0 then exit;
   Move (HaveMarketArr[akey], aItemData^, SizeOf (TItemData));
   Result := TRUE;
end;

procedure THaveMarketClass.ClearMarketData;
var
   i : Integer;
begin
   for i := 0 to HAVEMARKETITEMSIZE - 1 do begin
      FillChar (HaveMarketArr [i], SizeOf (TItemData), 0);
      FSendClass.SendMarketItem (i, HaveMarketArr [i]);
   end;
end;

function THaveMarketClass.SellItembyUser (aMarketList : TList; aName : String) : Boolean;
   function FindItemCount (aItemData : TItemData; aMarketList : TList) : PTIndividualMarketItem;
   var
      i : Integer;
      pMarketItem : PTIndividualMarketItem;
   begin
      Result := nil;
      for i := 0 to aMarketList.Count - 1 do begin
         pMarketItem := aMarketList.items [i];
         if StrPas (@pMarketItem^.rName) = Strpas (@aItemData.rName) then begin
            if (pMarketItem^.rColor = aItemData.rcolor) and (pMarketItem^.rCost = aItemData.rPrice) and
               (pMarketItem^.rCurDurability = aItemData.rCurDurability) and
               (pMarketItem^.rDurability = aItemData.rDurability) and
               (pMarketItem^.rUpgrade = aItemData.rUpgrade) then begin
               Result := pMarketItem;
               exit;
            end;
         end;
      end;
   end;
   
   function FindItem2 (var aItemData : TItemData) : Boolean;
   var
      i : Integer;
   begin
      Result := false;
      for i := 1 to HAVEMARKETITEMSIZE - 1 do begin
         if StrPas (@HaveMarketArr[i].rName) = StrPas (@aItemData.rName) then begin
            if (HaveMarKetArr[i].rcolor = aItemData.rcolor) and
               (HaveMarketArr[i].rCurDurability = aItemData.rCurDurability) and
               (HaveMarketArr[i].rUpgrade = aItemData.rUpgrade) and
               (HaveMarketArr[i].rPrice = aItemData.rPrice) and
               (HaveMarketArr[i].rCount >= aItemData.rCount) then begin
               Result := true;
               exit;
            end;
         end;
      end;
   end;
var
   i, tmpPrice : Integer;
   GoldItemData : TItemData;
   usd : TStringData;
   cnt, buycnt : Integer;
   pMItem : PTIndividualMarketItem;
   ItemArr : array [1..HAVEMARKETITEMSIZE-1] of TItemData;
begin
   Result := false;
   if (NATION_VERSION = NATION_CHINA_1) or (NATION_VERSION = NATION_CHINA_1_TEST) then exit;   

   if aMarketList.Count < 1 then exit;
   if HaveMarketArr [MARKET_GOLD_KEY].rCount > 30000000 then begin
      TUser (FBasicObject).SendClass.SendChatMessage (Conv('钱额不足'), SAY_COLOR_SYSTEM);
      exit;
   end;

   tmpPrice := 0;
   buycnt := aMarketList.Count;
   cnt := 0;

   for i := 0 to aMarketList.Count - 1 do begin
      pMItem := aMarketList.Items[i];
      if pMItem = nil then exit;
      ItemClass.GetItemData (StrPas (@pMItem^.rName), ItemArr[i+1]);
      if ItemArr[i+1].rName[0] = 0 then exit;
      ItemArr[i+1].rCount := pMItem^.rCount;
      ItemArr[i+1].rcolor := pMItem^.rColor;
      ItemArr[i+1].rUpgrade := pMItem^.rUpgrade;
      ItemArr[i+1].rCurDurability := pMItem^.rCurDurability;
      ItemArr[i+1].rDurability := pMItem^.rDurability;
      ItemArr[i+1].rPrice := pMItem^.rCost;
      if FindItem2(ItemArr[i+1]) = false then exit;
      inc(cnt);
      tmpPrice := tmpPrice + ItemArr[i+1].rPrice * ItemArr[i+1].rCount;
   end;

   if cnt <> buycnt then exit;
   if tmpPrice + HaveMarketArr[MARKET_GOLD_KEY].rCount > 30000000 then begin
      TUser (FBasicObject).SendClass.SendChatMessage (Conv('钱额不足，无法售出'), SAY_COLOR_SYSTEM);
      exit;
   end;
   if tmpPrice <= 0 then exit;
   
   for i := 0 to buycnt - 1 do begin
      StrPCopy (@ItemArr[i+1].rOwnerName, '');
      if DeleteMarketitem (@ItemArr[i+1]) = true then begin
         if ItemArr[i+1].rCount > 0 then begin
            TUser (FBasicObject).SendClass.SendChatMessage (format (Conv('%s买了 %s %d个'), [aName, StrPas (@ItemArr[i+1].rName), ItemArr[i+1].rCount]), SAY_COLOR_SYSTEM);
            usd.rmsg := 2;
            SetWordString (usd.rWordString, format ('Market:%s:%d,%d,%d', [StrPas (@ItemArr[i+1].rName), ItemArr[i+1].rUpgrade, ItemArr[i+1].rCount, ItemArr[i+1].rPrice]));
            cnt := sizeof(usd) - sizeof(TWordString) + sizeofwordstring (usd.rwordstring);
            FrmSockets.UdpObjectAddData (cnt, @usd);
         end;
      end;
   end;

   ItemClass.GetItemData (INI_GOLD, GoldItemData);
   if GoldItemData.rName [0] = 0 then exit;
   GoldItemData.rCount := tmpPrice;
//   StrPCopy (@GoldItemData.rOwnerName, Conv('@我的贩卖窗'));
   AddGoldItem (GoldItemData);

   Result := true;
end;

function THaveMarketClass.SellItembyUser (aItemData : TItemData; aName : String) : Boolean;
var
   ItemData, GoldItemData : TItemData;
   tmpPrice, cnt : Integer;
   usd : TStringData;
begin
   Result := false;

   ItemData := aItemData;
   if ItemData.rName [0] = 0 then exit;
   if HaveMarketArr [MARKET_GOLD_KEY].rCount > 30000000 then begin
      TUser (FBasicObject).SendClass.SendChatMessage (Conv ('钱额不足'), SAY_COLOR_SYSTEM);
      exit;
   end;

   tmpPrice := ItemData.rPrice * ItemData.rCount;

   if tmpPrice + HaveMarketArr[MARKET_GOLD_KEY].rCount > 30000000 then begin
      TUser (FBasicObject).SendClass.SendChatMessage (Conv ('钱额不足，无法售出'), SAY_COLOR_SYSTEM);
      exit;
   end;
   if tmpPrice <= 0 then exit;

   if DeleteMarketItem (@ItemData) = false then exit;

   StrPCopy (@ItemData.rOwnerName, '');
   if ItemData.rCount > 0 then begin
      TUser (FBasicObject).SendClass.SendChatMessage (format (Conv ('%s买了 %s %d个'), [aName, StrPas (@ItemData.rName), ItemData.rCount]), SAY_COLOR_SYSTEM);
      usd.rmsg := 2;
      SetWordString (usd.rWordString, format ('Market:%s:%d,%d,%d', [StrPas (@ItemData.rName), ItemData.rUpgrade, ItemData.rCount, ItemData.rPrice]));
      cnt := sizeof(usd) - sizeof(TWordString) + sizeofwordstring (usd.rwordstring);
      FrmSockets.UdpObjectAddData (cnt, @usd);
   end;

   ItemClass.GetItemData (INI_GOLD, GoldItemData);
   if GoldItemData.rName [0] = 0 then exit;
   GoldItemData.rCount := tmpPrice;
//   StrPCopy (@GoldItemData.rOwnerName, '@我的贩卖窗');
   AddGoldItem (GoldItemData);

   Result := true;   
end;

procedure THaveMarketClass.FromMarketToItemWindow (pcDragDrop : PTCDragDrop; aShowWindowClass : TShowWindowClass);
var
   ItemData : TItemData;
   srcKey, destKey : Integer;
begin
   if (NATION_VERSION = NATION_CHINA_1) or (NATION_VERSION = NATION_CHINA_1_TEST) then exit;

   srcKey := pcDragDrop^.rsourkey;
   destKey := pcDragDrop^.rdestkey;

   if (FboMarketing = true) and (srcKey <> 0) then begin
      FSendClass.SendChatMessage (Conv('无法移动'), SAY_COLOR_SYSTEM);
      exit;
   end;

   if (srcKey < 0) or (srcKey > FMarketCount) then exit;  
   if (destKey < 0) or (destKey >= HAVEITEMSIZE) then exit;

   if not ViewMarketItem (srcKey, @ItemData) then exit;

   if FHaveItemClass.CheckAddable (ItemData) < 0 then begin
      FSendClass.SendChatMessage (Conv('持有的物品太多'), SAY_COLOR_SYSTEM);
      exit;
   end;

   StrPCopy (@ItemData.rOwnerName, '');
   if DeletekeyMarketItem (srcKey, ItemData.rCount, @ItemData) = false then exit;

   if srcKey = 0 then begin
      StrPCopy (@ItemData.rOwnerName, Conv('@钱袋'));
   end else begin
      StrPCopy (@ItemData.rOwnerName, Conv('@我的贩卖窗'));
   end;
   if FHaveItemClass.AddKeyItem (destkey, ItemData) = false then begin
      if FHaveItemClass.AddItem (ItemData) = false then exit;
   end;
end;

procedure THaveMarketClass.ConfirmMarketProcess (pcMarketConfirm : PTCMarketConfirm; aShowWindowClass : TShowWindowClass);
begin
   if (NATION_VERSION = NATION_CHINA_1) or (NATION_VERSION = NATION_CHINA_1_TEST) then exit;

   case pcMarketConfirm^.rConfirmType of
      0 : begin   // 辆丰
         MarketCaption := '';
         FboMarketing := false;
         TUser (FBasicObject).CommandChangeCharState (wfs_normal);
         TUser (FBasicObject).SendClass.SendMarketResult (0);
      end;
      1 : begin   // 魄概俺矫
         if aShowWindowClass.AllowWindowAction (swk_none) = false then exit;
         if TUser (FBasicObject).Password <> '' then begin
            TUser (FBasicObject).SendClass.SendMarketResult (0);
            FSendClass.SendChatMessage (Conv('有设置密码'), SAY_COLOR_SYSTEM);
            exit;
         end;
         if TUser (FBasicObject).ServerID <> 1 then begin  // 厘己捞巢 寇浚 魄概陛瘤
            FSendClass.SendChatMessage (Conv('不能摆摊的地段儿'), SAY_COLOR_SYSTEM);
            exit;
         end;
         if FAttribClass.CurLife < FAttribClass.Life then begin
            FSendClass.SendChatMessage (Conv('要补足活力'), SAY_COLOR_SYSTEM);
            exit;
         end;
         if TUser (FBasicObject).Check8Around (TUser (FBasicObject).BasicData.dir, TUser (FBasicObject).BasicData.x, TUser (FBasicObject).BasicData.y) = true then begin   // 8规氢俊 拱眉啊 窍唱扼档 乐栏搁 救凳
            TUser (FBasicObject).SendClass.SendMarketResult (0);
            TUser (FBasicObject).SendClass.SendChatMessage (Conv('周围必须无障碍物'), SAY_COLOR_SYSTEM);
            exit;
         end;
         MarketCaption := GetWordString (pcMarketConfirm^.rTitle);
         if Length (MarketCaption) > 18 then begin
            MarketCaption := Copy (MarketCaption, 1, 18);
         end;

         if MarketCaption = '' then begin
            TUser (FBasicObject).SendClass.SendMarketResult (0);
            TUser (FBasicObject).SendClass.SendChatMessage (Conv('输入标题'), SAY_COLOR_SYSTEM);
            exit;
         end;
         FboMarketing := true;
         TUser (FBasicObject).CommandChangeCharState (wfs_shop);
         TUser (FBasicObject).CommandTurn (DR_4, TRUE);
         TUser (FBasicObject).SendClass.SendMarketResult (1);
      end;
      2 : begin   // 魄概秒家
         MarketCaption := '';
         FboMarketing := false;
         TUser (FBasicObject).CommandChangeCharState (wfs_normal);
         TUser (FBasicObject).SendClass.SendMarketResult (0);
      end;
   end;
end;

procedure THaveMarketClass.CopyMarketItem (var aMarketDataList : TList);
var
   i : Integer;
   pMarketItem : PTIndividualMarketItem;
   ItemData : TItemData;
begin
   if (NATION_VERSION = NATION_CHINA_1) or (NATION_VERSION = NATION_CHINA_1_TEST) then exit;

   for i := 1 to HAVEMARKETITEMSIZE - 1 do begin
      ItemClass.GetItemData (StrPas (@HaveMarketArr [i].rName), ItemData);
      if ItemData.rName [0] = 0 then continue;

      New (pMarketItem);
      StrPCopy (@pMarketItem^.rName, StrPas (@HaveMarketArr [i].rName));
      pMarketItem^.rCount := 0;
      pMarketItem^.rcolor := HaveMarketArr [i].rcolor;
      pMarketItem^.rShape := HaveMarketArr [i].rShape;
      pMarketItem^.rCost := HaveMarketArr [i].rPrice;
      pMarketItem^.rCurDurability := HaveMarketArr [i].rCurDurability;
      pMarketItem^.rDurability := HaveMarketArr [i].rDurability;
      pMarketItem^.rUpgrade := HaveMarketArr [i].rUpgrade;
      pMarketItem^.rAddType := HaveMarketArr [i].rAddType;
      pMarketItem^.rTotalCount := HaveMarketArr [i].rCount;

      aMarketDataList.Add (pMarketItem); 
   end;
end;

procedure THaveMarketClass.SetMarketCount;
begin
   if (NATION_VERSION = NATION_CHINA_1) or (NATION_VERSION = NATION_CHINA_1_TEST) then exit;

   FMarketCount := TUser (FBasicObject).GetAttribCurVirtue div 1000;
end;

procedure THaveMarketClass.SelectItemWindow (pcClick : PTCClick);
var
   ItemData : TItemData;
   Str, ViewName : String;
begin
   if (NATION_VERSION = NATION_CHINA_1) or (NATION_VERSION = NATION_CHINA_1_TEST) then exit;

   if ViewMarketItem (pcClick^.rkey, @ItemData) = false then exit;
   if ItemData.rName [0] = 0 then exit;

   case ItemData.rKind of
      ITEM_KIND_WEARITEM, ITEM_KIND_WEARITEM2, ITEM_KIND_CAP, ITEM_KIND_PICKAX, ITEM_KIND_HIGHPICKAX, ITEM_KIND_DURAWEAPON :
         begin
            if ItemData.rUpgrade <> 0 then begin
               ViewName := format (Conv('%s %d级'), [StrPas (@ItemData.rViewName), ItemData.rUpgrade]);
            end else begin
               ViewName := StrPas (@ItemData.rViewName);
            end;
         end;
      Else
         begin
            ViewName := StrPas (@ItemData.rViewName);
         end;
   end;
   JobClass.GetUpgradeItemLifeData (ItemData);
   Str := GetMiniItemContents2 (ItemData, TUserObject (FBasicObject).PowerLevel);

   if ItemData.rKind = ITEM_KIND_MINERAL then ItemData.rPrice := 0;

   FSendClass.SendShowItemWindow2 (ViewName, Str, ItemData.rShape, ItemData.rcolor, ItemData.rPrice, ItemData.rGrade , ItemData.rLockState , ItemData.runLockTime);
end;

// TUserQuestClass;
constructor TUserQuestClass.Create;
begin
   FCompleteQuestNo := 0;
   FCurrentQuestNo := 0;
   FQuestStr := '';
   FFirstQuestNo := 0;
end;

destructor TUserQuestClass.Destroy;
begin
   inherited Destroy;
end;

// TUserSystemInfoClass;
constructor TUserSystemInfoClass.Create;
begin
   KeyClass := TStringKeyClass.Create;
end;

destructor TUserSystemInfoClass.Destroy;
begin
   KeyClass.Free;

   inherited Destroy;
end;

procedure TUserSystemInfoClass.AddUserInfo (aMasterName : String; aSystemInfo : PTCSystemInfoData);
var
   Stream : TFileStream;
   FileName, Str : String;
   Buffer : array [0..1024 - 1] of Byte;
begin
   if KeyClass.Select (aMasterName) <> nil then exit;

   KeyClass.Insert (aMasterName, aSystemInfo);

   FileName := '.\Log\SystemInfo' + GetDateByStr (Date) + '.SDB';

   if FileExists (FileName) then begin
      Stream := TFileStream.Create (FileName, fmOpenReadWrite)
   end else begin
      Stream := TFileStream.Create (FileName, fmCreate);
      Str := 'MasterName,CPUSpeed,RAM,VGA' + #13#10;
      StrPCopy (@Buffer, Str);
      Stream.WriteBuffer (Buffer, StrLen (@Buffer)); 
   end;
   Str := aMasterName + ',' + IntToStr (aSystemInfo^.rCPUSpeed) + ',' + IntToStr (aSystemInfo^.rRAMSize) + ','
      + GetWordString (aSystemInfo^.rVGA) + #13#10;
   StrPCopy (@Buffer, Str);
   Stream.Seek(0, soFromEnd);
   Stream.WriteBuffer (Buffer, StrLen(@Buffer));

   Stream.Free;
end;

procedure TUserSystemInfoClass.Clear;
begin
   KeyClass.Clear;   
end;

//Author:Steven Date: 2005-02-03 10:51:33
//Note:采集技能
function TAttribClass.GetExtJobExp: Integer;
begin
   Result := CurAttribData.CurExtJobExp;
end;

function TAttribClass.GetExtJobLevel: Integer;
begin
   Result := JobClass.GetExtJobLevel(ExtJobExp);
end;

procedure TAttribClass.SetExtJobExp(AValue: Integer);
begin
   CurAttribData.CurExtJobExp := AValue;
end;

function TAttribClass.GetExtJobKind: Byte;
begin
  Result := AttribData.ExtJobKind;
end;

procedure TAttribClass.SetExtJobKind(AValue: Byte);
begin
   AttribData.ExtJobKind := AValue;
end;
//==================================================

initialization
begin
   UserSystemInfoClass := TUserSystemInfoClass.Create;
end;

finalization
begin
   UserSystemInfoClass.Free;
end;

end.
