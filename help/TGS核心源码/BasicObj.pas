unit BasicObj;

interface

uses
   Windows, Classes, SysUtils, mmSystem, SubUtil, uAnsTick, AnsUnit,
   FieldMsg, MapUnit, DefType, Autil32, uManager, AnsStringCls,
   uObjectEvent, uScriptManager, uWorkBox, svClass;

const
   ATTACKEDMAGICSIZE = 5;
   ALARMINTERVAL = 6000; //舅覆 埃拜
   ALARMSTART_TIME = 5; //5盒傈 舅覆 矫累
type
   TAttackedMagicClass = class;

   TBasicObject = class
   private
      FCreateTick: integer;
      FCreateX, FCreateY: integer;
      FTimerTick: Integer;

      function GetPosx: integer;
      function GetPosy: integer;
      function GetFeatureState: TFeatureState;
   protected
      FboRegisted: Boolean;
      FboAllowDelete: Boolean;
      FboHaveGuardPos: Boolean;

      FAlarmTick: Integer;

      FShowEffectNumber, FHideEffectNumber: Word;
      FShowEffectKind, FHideEffectKind: TLightEffectKind;

      function isApproach(xx, yy: word): Boolean;
      function isRange(xx, yy: word): Boolean;
      function isRangeMessage(hfu: Longint; Msg: word; var SenderInfo:
         TBasicData): Boolean;
      function FieldProc(hfu: Longint; Msg: word; var SenderInfo: TBasicData; var
         aSubData: TSubData): Integer; dynamic;
      function GetViewObjectCountByName(aName: string): Integer;

      function isHitedArea(adir, ax, ay: integer; afunc: byte; var apercent:
         integer): Boolean;
      function isBowArea(adir, ax, ay: integer; afunc: byte; var apercent:
         integer): Boolean;
      function isSpellArea(aSX, aSY: Word; aSpellWidth: Integer): Boolean;
      function isWindOfHandArea(aSX, aSY: Word; aMinRange, aMaxRange: Integer;
         var aDis: Integer): Boolean;
      function isCriticalAttackArea(tid: Longint; aRangeType: byte; sx, sy,
         sdir, tx, ty, tdir, aMin, aMax: word; afunc, aper: byte): Boolean;
      procedure Initial(aName, aViewName: string);
      procedure StartProcess; dynamic;
      procedure EndProcess; dynamic;

      procedure BocChangeFeature;

      procedure BoSysopMessage(astr: string; aSysopScope: integer);
      //   protected
   public
      // event
      SOnCreate: Integer;
      SOnDestroy: Integer;
      SOnDanger: Integer;
      SOnHit: Integer;
      SOnBow: Integer;
      SOnStructed: Integer;
      SOnShow: Integer;
      SOnHide: Integer;
      SOnDie: Integer;
      SOnDieBefore: Integer;
      SOnHear: Integer;
      SOnLeftClick: Integer;
      SOnRightClick: Integer;
      SOnDblClick: Integer;
      SOnDropItem: Integer;
      SOnChangeState: Integer;
      SOnMove: Integer;
      SOnTimer: Integer;
      SOnApproach: Integer;
      SOnAway: Integer;
      SOnUserStart: Integer;
      SOnUserEnd: Integer;
      SOnArrival: Integer;
      SOnTurnOn: Integer;
      SOnTurnOff: Integer;
      SOnRegen: Integer;
      SOnGetChangeStep: Integer;

      SOnGetResult: Integer;

      FWorkBox: TWorkBox;

      // property
      function SGetName : String; virtual;
      function SGetAge : Integer; virtual;
      function SGetSex : Integer; virtual;
      function SGetId : Integer; virtual;
      function SGetServerId : Integer; 
      procedure SGetPosition (var aMapID : Integer; var aX, aY : Word); virtual;
      function SGetMapName : String; virtual;
      function SGetMoveableXY (aX, aY : Word) : String; virtual;
      function SGetNearXY (aX, aY : Word) : String; virtual;
      function SGetRace : Byte; virtual;
      function SGetState : Byte; virtual;
      function SGetMaxLife : Integer; virtual;
      function SGetMaxInPower : Integer; virtual;
      function SGetMaxOutPower : Integer; virtual;
      function SGetMaxMagic : Integer; virtual;
      function SGetLife : Integer; virtual;
      function SGetHeadLife : Integer; virtual;
      function SGetArmLife : Integer; virtual;
      function SGetLegLife : Integer; virtual;
      function SGetPower : Integer; virtual;
      function SGetInPower : Integer; virtual;
      function SGetOutPower : Integer; virtual;
      function SGetMagic : Integer; virtual;
      function SGetVirtue : Integer; virtual;
      function SGetTalent : Integer; virtual;
      function SGetMoveSpeed : Integer; virtual;
      function SGetUseAttackMagic : String; virtual;
      function SGetUseAttackSkillLevel : Integer; virtual;
      function SGetUseMagicSkillLevel (aKind : Word) : Integer; virtual;
      function SGetMagicSkillLevel (aName : String) : Integer; virtual;
      function SGetUseProtectMagic : String; virtual;
      function SFindObjectByName (aName : String) : Integer; virtual;
      function SGetCompleteQuest : Integer; virtual;
      function SGetCurrentQuest : Integer; virtual;
      function SGetQuestStr : String; virtual;
      function SGetFirstQuest : Integer; virtual;
      function SGetItemExistence (aItem : String; aOption : Integer) : String; virtual;
      function SGetItemExistenceByKind (aKind, aOption : Integer) : String; virtual;      
      function SCheckEnoughSpace (aCount : Integer) : String; virtual;
      function SGetHaveGradeQuestItem: String; virtual; //2003-10      
      function SCheckAliveMonsterCount (aServerID : Integer; aRace, aName : String) : Integer; virtual;
      function SGetUserCount (aID : Integer) : Integer; virtual;
      function SGetJobKind : Byte; virtual;
      function SGetJobGrade : Byte; virtual;

      function SGetJobTalent : Integer; virtual;
      function SGetWearItemCurDurability (aKey : Integer) : Integer; virtual;
      function SGetWearItemMaxDurability (aKey : Integer) : Integer; virtual;
      function SGetWearItemName (aKey : Integer) : String; virtual;
      function SGetMagicCountBySkill (aType, aSKill : Integer) : String; virtual;
      function SRepairItem (aKey, aKind : Integer) : Integer; virtual;
      function SDestroyItembyKind (aKey, aKind : Integer) : Integer; virtual;      
      function SFindItemCount (aItemName : String) : String; virtual;
      function SGetPossibleGrade (atype,agrade:byte) : String;virtual;      
      function SCheckPowerWearItem : Integer; virtual;
      function SCheckCurUseMagic (aType : Byte) : String; virtual;
      function SCheckCurUseMagicByGrade (aType, aGrade, amagictype : Byte) : String; virtual;
      function SGetCurPowerLevelName : String; virtual;
      function SGetCurPowerLevel : Integer; virtual;      
      function SGetCurDuraWaterCase : Integer; virtual;
      function SGetRemainMapTime (aRemainMin, aRemainSec : Integer) : String; virtual;
      function SCheckEnterMap (aServerID : Integer) : String; virtual;
      function SCheckMagic (aMagicClass, aMagicType : Integer; aMagicName : String) : String; virtual;
      function SCheckAttribItem (aAttrib : Integer) : String; virtual;
      function SConditionBestAttackMagic (aMagicName : String) : String; virtual;
      function SGetMarryClothes : String; virtual;
      function SGetZhuangTicketPrice : String; virtual;
      function SGetZhuangInto :String; virtual;
      function SGetMarryInfo :String; virtual;
      //Author:Steven Date: 2005-01-31 17:16:49
      //Note:采集技能
      function SGetExtJobLevel: Integer; virtual;
      function SSetExtJobExp(aExp: Integer): Integer; virtual;
      function SGetExtJobExp: Integer; virtual;
      function SGetExtJobKind: Byte; virtual;
      procedure SSetExtJobKind(AValue: Byte); virtual;
      //=======================================

      function SGetAskConquer :String; virtual;

      // system property
      function SGetSystemInfo(aCmd: string): string;
      // add by Orber at 2004-09-16 14:13
      function  SStartMissionTime: single; virtual;
      function  SGetPassMissionTime: single; virtual;
      function  SGetIntoArenaGame(aArenaKey : Word):Integer; virtual;
      function  SStartArenaGame:Integer; virtual;
      // add by Orber at 2005-02-03 11:33:12
      function  SAddArenaMember(aMasterName : String):String; virtual;
      function  SGetEvent(EventCode:integer):String; virtual;
      function  SGetSetEvent(EventCode:integer):String; virtual;
      function  SCheckPickup:String; virtual;
      function  SGetParty:String; virtual;
      function  SSetParty:String; virtual;


      // method
      procedure SSay(aStr: string); virtual;
      procedure SGotoXY(aX, aY: Word); virtual;
      procedure SAttack(aID: Integer); virtual;
      procedure SChangeState(aState: Byte); virtual;
      procedure SSelfKill; virtual;
      procedure SShowWindow(aCommander: TBasicObject; aFileName: string; aKind:
         Byte); virtual;
      procedure SShowWindow2(aCommander: TBasicObject; aStr: string; aKind:
         Byte); virtual;
      procedure STradeWindow(aName: string; aKind: Byte); virtual;
      procedure SLogItemWindow(aCommander: TBasicObject); virtual;
      procedure SGuildItemWindow(aCommander: TBasicObject); virtual;
      procedure SSetAutoMode; virtual;
      procedure SPutMagicItem(aWeapon, aMopName: string; aRace: Byte); virtual;
      procedure SGetItem(aItem: string); virtual;
      procedure SGetItem2(aItem: string); virtual;
      procedure SGetAllItem(aItem: string); virtual;
         // 捞抚俊 秦寸窍绰芭 葛滴 绝局绰芭 (酒捞袍芒, 扁贱芒, 俺牢魄概芒)
      procedure SDeleteQuestItem; virtual;
      procedure SChangeCompleteQuest(aQuest: Integer); virtual;
      procedure SChangeCurrentQuest(aQuest: Integer); virtual;
      procedure SChangeQuestStr(aStr: string); virtual;
      procedure SChangeFirstQuest(aQuest: Integer); virtual;
      procedure SAddAddableStatePoint(aPoint: Integer); virtual;
      procedure STotalAddableStatePoint(aPoint: Integer); virtual;
      procedure SSelfChangeDynobjState(aboInc: Boolean); virtual;
      procedure SChangeDynobjState(aObjName: string; aboInc: Boolean); virtual;
      procedure SSendZoneEffectMessage(aName: string); virtual;
      procedure SSendChatMessage(aStr: string; aColor: Integer); virtual;
      procedure SMoveSpace(aName, aRace: string; aServerID, aX, aY: Integer);
         virtual;
      procedure SSetAllowHit(aHit: string); virtual;
      procedure SSetAllowDelete(aRace, aName: string); virtual;
      procedure SShowEffect(aEffectNumber: Integer; aEffectKind: Integer);
         virtual;
      procedure SCommandIce(aInterval: Integer); virtual;
      procedure SCommandIceByName(aName, aRace: string; aInterval: Integer);
         virtual;
      procedure SSetAllowHitByName(aName, aRace, aHit: string); virtual;
      procedure SSayByName(aName, aRace, aSay: string; aInterval: Integer);
         virtual;
      procedure SMoveSpaceByName(aParams: array of string; aName, aRace: string;
         aInterval: Integer); virtual;

      procedure SClearWorkBox;
      procedure SRegen(aName, aRace: string);
      procedure SMapRegen(aMapID: Integer);
      procedure SMapRegenByName(aParams: array of string; aName, aRace: string);
      procedure SMapDelObjByName(aRace: string; aName: string);
      procedure SMapAddObjByName(aRace: string; aParams: array of string);
      procedure SSendSound(aWavName: string; aMapID: Integer);
      procedure SboIceAllbyName(aName, aRace, aboIce: string);
      procedure SboHitAllbyName(aName, aRace, aboHit: string);
      procedure SboPickbyMapName(aMapName, aboPick: string);
      procedure SRePosition(aBo: TBasicObject);
      procedure SReturnDamage(aBo: TBasicObject; aMaxDamage, aDecRate: Integer);
      procedure SSetJobKind(aKind: Byte); virtual;
      procedure SSetVirtueman; virtual;
      procedure SSmeltItem(aMakeName: string); virtual; // 酒捞袍 力访.. ;;;
      procedure SSmeltItem2(aMakeName: string); virtual;
         // 酒捞袍 力访茄芭 背券.. ;;;
      procedure SQuestComplete(aStr, aQuestName: string); virtual;
      procedure SSendItemMoveInfo(aStr: string); virtual;
      procedure SSendTopMessage(aStr: string);
      procedure SSendNoticeMessageForMapUser(aServerID: Integer; aStr: string;
         aColor: Integer);
      procedure SRefill;
      procedure SChangeCurDuraByName(aName: string; aCurDura: Integer); virtual;
      procedure SboMapEnter(aServerID: Integer; aboEnter: string); virtual;
      procedure SDecreasePrisonTime(aTime: Integer); virtual;
      procedure SUseMagicGradeup(atype, tg: byte); virtual;

      //procedure SSetEventCount (aCount : Integer);     // event

      // Regist Script
      procedure SetScript(aIndex: Integer);
      procedure PushCommand(aCmd: Byte; aParams: array of string; aInterval:
         Integer);
      procedure PutResult(aSender: TBasicObject; aStr: string);
   public
      procedure SetManagerClass(aManager: TManager);
      function SendLocalMessage(hfu: Longint; Msg: word; var SenderInfo:
         TBasicData; var aSubData: TSubData): Integer;
      procedure BocSay(astr: string);
      procedure WorkOver;
      procedure SetManualMode;
      function isAutoMode: Boolean;
      function isWorkOver: Boolean;
      function isWalking: Boolean;
   public
      Manager: TManager;
      Maper: TMaper;
      Phone: TFieldPhone;
      ServerID: Integer;

      BasicData: TBasicData; // 傍侩函荐
      ViewObjectList: TList;
      // ViewObjectNameList : TStringList;

      constructor Create;
      destructor Destroy; override;
      procedure Update(CurTick: integer); dynamic;
      procedure BocChangeProperty;

      function GetViewObjectByName(aName: string; aRace: integer): TBasicObject;
      function GetViewObjectById(aid: integer): TBasicObject;

      function FindViewObject(aBasicObject: TBasicObject): Boolean;
      procedure SetShowEffect(aEffectNumber: Word; aEffectKind:
         TLightEffectKind);
      procedure SetHideEffect(aEffectNumber: Word; aEffectKind:
         TLightEffectKind);
      procedure PushMove(dir: word; length: integer);

      property PosX: integer read GetPosX;
      property PosY: integer read GetPosY;
      property CreateX: integer read FCreateX;
      property CreateY: integer read FCreateY;
      property CreateTick: integer read FCreateTick;
      property boAllowDelete: Boolean read FboAllowDelete write FboAllowDelete;
      property boRegisted: Boolean read FboRegisted;
      property State: TFeatureState read GetFeatureState;
   end;

   TBasicObjectList = class
   private
      FName: string;
      FProcessCount: Integer;
      FProcessPos: Integer;
      FDelayTickMax: LongWord;

      function GetCount: Integer;
   protected
      Manager: TManager;
      DataList: TList;
   public
      constructor Create(aName: string; aManager: TManager);
      destructor Destroy; override;

      procedure Clear; virtual;
      procedure Update(CurTick: LongWord); virtual;

      property Count: Integer read GetCount;
   end;

   TItemObject = class(TBasicObject)
   private
      SelfItemData: TItemData;
      OwnerId: Integer;
      FAllowPickupID: Integer;
      boAllowPickup: Boolean;
   protected
      //     procedure   Initial (aItemData: TItemData; aOwnerId, ax, ay: integer);
      procedure Initial(aItemData: TItemData; aOwnerID, aPickupID, ax, ay:
         integer);
      procedure StartProcess; override;
      procedure EndProcess; override;
      function FieldProc(hfu: Longint; Msg: word; var SenderInfo: TBasicData; var
         aSubData: TSubData): Integer; override;
   public
      constructor Create;
      destructor Destroy; override;
      procedure Update(CurTick: integer); override;

      property AllowPickUp: Boolean read boAllowPickup;
   end;

   TItemList = class(TBasicObjectList)
   private
   public
      constructor Create(aManager: TManager);
      destructor Destroy; override;

      procedure AddItemObject(var aSubData: TSubData; aOwnerId, aPickupID, ax,
         ay: integer);
      procedure AddItemSpecial(aName: string; aX, aY, aW, aCount: Integer);
   end;

   TZoneEffectObject = class(TBasicObject)
   private
      SelfData: TCreateZoneEffectData;
   protected
      procedure Initial;
      procedure StartProcess; override;
      procedure EndProcess; override;
      function FieldProc(hfu: Longint; Msg: word; var SenderInfo: TBasicData; var
         aSubData: TSubData): Integer; override;
   public
      constructor Create;
      destructor Destroy; override;

      procedure SendFMMessage;

      procedure Update(CurTick: Integer); override;

      function GetSelfData: PTCreateZoneEffectData;
   end;

   TZoneEffectList = class(TBasicObjectList)
   private
   public
      constructor Create;
      destructor Destroy; override;

      procedure LoadFromFile(aFileName: string);
      function SendMsgZoneEffectObject(aName: string): Boolean;
   end;

   TGateObject = class(TBasicObject)
   private
      SelfData: TCreateGateData;

      boActive: Boolean;
      RegenedTick: Integer;
      RemainHour, RemainMin, RemainSec: Word;
      AlarmedTick: Integer;
      CheckTick: Integer;
      BattleTick: Integer;
   protected
      procedure Initial;
      procedure StartProcess; override;
      procedure EndProcess; override;
      function FieldProc(hfu: Longint; Msg: word; var SenderInfo: TBasicData; var
         aSubData: TSubData): Integer; override;
   public
      CurHour, CurMin, CurSec: Word;
      ArrivalCount: Integer;
      LimitCount: Integer;
      MaxUser: Integer;

      constructor Create;
      destructor Destroy; override;

      procedure Update(CurTick: Integer); override;

      function GetOpenTime: string;
      function GetSelfData: PTCreateGateData;
   end;

   TGateList = class(TBasicObjectList)
   private
      // add by minds 050902
      OwnGateGuildList: TStringList;
   public
      constructor Create;
      destructor Destroy; override;

      procedure LoadFromFile(aFileName: string);
      procedure SetBSGateActive(boFlag: Boolean);
      procedure SetGateActivebyKind(aKind: Byte; aboFlag: Boolean);
      function GetGatePosByStr(aManager: TManager): string;
      // add by minds 050902
      function IsOwnGateGuild(const aGuildName: string): Boolean;
   end;

   TGateObjectEx = class(TBasicObject)
   private
      SelfData: TCreateGateDataEx;

      boActive: Boolean;
      RegenedTick: Integer;
      RemainHour, RemainMin, RemainSec: Word;
   protected
      procedure Initial;
      procedure StartProcess; override;
      procedure EndProcess; override;
      function FieldProc(hfu: Longint; Msg: word; var SenderInfo: TBasicData; var
         aSubData: TSubData): Integer; override;
   public
      constructor Create;
      destructor Destroy; override;

      procedure Update(CurTick: Integer); override;

      function GetSelfData: PTCreateGateDataEx;
   end;

   TGateListEx = class(TBasicObjectList)
   private
   public
      constructor Create;
      destructor Destroy; override;

      procedure LoadFromFile(aFileName: string);
      procedure SetBSGateActive(boFlag: Boolean);
      function GetGatePosByStr(aManager: TManager): string;
   end;

   TMirrorObject = class(TBasicObject)
   private
      SelfData: TCreateMirrorData;

      ViewerList: TList;

      boActive: Boolean;
   protected
      procedure Initial;
      procedure StartProcess; override;
      procedure EndProcess; override;
      function FieldProc(hfu: Longint; Msg: word; var SenderInfo: TBasicData; var
         aSubData: TSubData): Integer; override;
   public
      constructor Create;
      destructor Destroy; override;

      procedure AddViewer(aUser: Pointer);
      function DelViewer(aUser: Pointer): Boolean;

      procedure Update(CurTick: Integer); override;

      function GetSelfData: PTCreateMirrorData;
   end;

   TMirrorList = class(TBasicObjectList)
   private
   public
      constructor Create;
      destructor Destroy; override;

      function AddViewer(aStr: string; aUser: Pointer): Boolean;
      function DelViewer(aUser: Pointer): Boolean;
      procedure LoadFromFile(aFileName: string);
   end;

   TStaticItem = class(TBasicObject)
   private
      CurDurability: integer;
      SelfItemData: TItemData;
      OwnerId: Integer;
   protected
      procedure Initial(aItemData: TItemData; aOwnerId, ax, ay: integer);
      procedure StartProcess; override;
      procedure EndProcess; override;
      function FieldProc(hfu: Longint; Msg: word; var SenderInfo: TBasicData; var
         aSubData: TSubData): Integer; override;
   public
      constructor Create;
      destructor Destroy; override;
      procedure Update(CurTick: integer); override;
   end;

   TStaticItemList = class(TBasicObjectList)
   private
   public
      constructor Create(aManager: TManager);
      destructor Destroy; override;

      function AddStaticItemObject(aItemData: TItemData; aOwnerId, ax, ay:
         integer): integer;
   end;

   TStepData = record
      StartStep: array[0..3 - 1] of Word;
      EndStep: array[0..3 - 1] of Word;
   end;
   PTStepData = ^TStepData;

   TExpLinkData = record
      ID: Integer;
      DecLife: Integer;
   end;
   PTExpLinkData = ^TExpLinkData;

   TDynamicObject = class(TBasicObject)
   private
      SelfData: TCreateDynamicObjectData;

      CurLife: Integer;
      EventItemCount: Integer;
      DragDropEvent: TDragDropEvent;
      MemberList: TList;

      FCurrentStep: Word;
      FStepList: TList;

      ExpLink: array[0..10 - 1] of TExpLinkData;

      procedure AddExpLink(aID, aValue: Integer);
      procedure ClearExpLink;
      function FindBestExpLink: Integer;
   protected
      procedure CommandHit;
      procedure CommandAttackedMagic(var aWindOfHandData: TWindOfHandData);
      procedure ShowEffect(aEffectNumber: Word; aEffectKind: TLightEffectKind);
      procedure ShowEffect2(aEffectNumber: Word; aEffectKind: TLightEffectKind;
         aDelay: Integer);
      function FieldProc(hfu: Longint; Msg: word; var SenderInfo: TBasicData; var
         aSubData: TSubData): Integer; override;
      function GetArmor: integer;
   public
      OpenedTick: Integer;
      OpenedPosX, OpenedPosY: Word;
      ObjectStatus: TDynamicObjectState;

      AttackedMagicClass: TAttackedMagicClass;
   public
      constructor Create;
      destructor Destroy; override;

      procedure Initial(pObjectData: PTCreateDynamicObjectData);
      procedure StartProcess; override;
      procedure EndProcess; override;

      procedure Update(CurTick: integer); override;
      procedure MemberDie(aBasicObject: TBasicObject);

      procedure IncStep;
      procedure DecStep;

      procedure Regen;
      procedure CallMe(x, y: Integer);

      procedure WorkBoxCommand(aCmd: Byte);

      procedure SSay(aStr: string); override;
      procedure SChangeState(aState: Byte); override;
      function SGetLife: Integer; override;
      procedure SetArmor(aArmor: Integer);
      procedure SetLife(aLife: Integer);

      procedure SSendZoneEffectMessage(aName: string); override;
      procedure SShowEffect(aEffectNumber: Integer; aEffectKind: Integer);
         override;

      property Status: TDynamicObjectState read ObjectStatus;
      property Armor: Integer read GetArmor;
   end;

   TDynamicObjectList = class(TBasicObjectList)
   private
   public
      constructor Create(aManager: TManager);
      destructor Destroy; override;

      procedure ReLoadFromFile;

      function AddDynamicObject(pObjectData: PTCreateDynamicObjectData):
         integer;
      function DeleteDynamicObject(aName: string): Boolean;
      function FindDynamicObject(aName: string): Integer;
      procedure SearchDynamicObject(aName: string; var aDynamicObject:
         TDynamicObject);
      procedure ChangeStep(aName: string; aboInc: Boolean);

      function GetDynamicObjects(aName: string; aList: TList): Integer;
      function GetDynamicObjectbyName(aName: string): TDynamicObject;
      function GetDynPosStr: string;

      procedure RegenByName(aName: string);
   end;

   TVirtualObject = class(TBasicObject)
   private
      SelfData: TCreateVirtualObjectData;
   protected
      function FieldProc(hfu: Longint; Msg: word; var SenderInfo: TBasicData; var
         aSubData: TSubData): Integer; override;
   public
      constructor Create(pObjectData: PTCreateVirtualObjectData);
      destructor Destroy; override;

      function IsNearPos(var SenderInfo: TBasicData; var SubData: TSubData):
         Boolean;

      procedure Initial;
      procedure StartProcess; override;
      procedure EndProcess; override;

      procedure Update(CurTick: Integer); override;
   end;

   TVirtualObjectList = class(TBasicObjectList)
   private
   public
      constructor Create(aManager: TManager);
      destructor Destroy; override;

      procedure ReLoadFromFile;
      procedure SendFMMessage(var SenderInfo: TBasicData; var SubData:
         TSubData);
   end;

   TMineObject = class(TBasicObject)
   private
      FPositionName: string;
      FGroupName: string;

      FMineObjectName: string;
      FShape: Word;
      FActive: Boolean;
      FPickConst: Integer;
      FDeposit: Integer;
      FAvailItems: array[0..10 - 1] of string;
      FRegenIntervals: array[0..3 - 1] of Integer;
      FDropMop: array[0..5 - 1] of TCheckItem;

      FRegenInterval: Integer;
      FRegenedTick: Integer;
      FCheckedTick: Integer;

      function ReInitial: Boolean;
   protected
      function FieldProc(hfu: Longint; Msg: word; var SenderInfo: TBasicData; var
         aSubData: TSubData): Integer; override;
   public
      constructor Create;
      destructor Destroy; override;

      procedure Initial(aPositionName, aGroupName: string; aX, aY, aShape:
         Word);
      procedure StartProcess; override;
      procedure EndProcess; override;

      procedure Update(CurTick: Integer); override;
   end;

   TMineObjectList = class(TBasicObjectList)
   private
   public
      constructor Create(aManager: TManager);
      destructor Destroy; override;

      procedure ReLoadFromFile;
      function GetReportStr: string;
   end;

   TGroupMoveObject = class(TBasicObject)
   private
      SelfData: TCreateGroupMoveData;

      AddItemCount: Integer;
      // AddItemUserIDArr : array [0..8 - 1] of Integer;
      PosStrList: TStringList;
   protected
      procedure Initial;
      procedure StartProcess; override;
      procedure EndProcess; override;
      function FieldProc(hfu: Longint; Msg: word; var SenderInfo: TBasicData; var
         aSubData: TSubData): Integer; override;
   public
      ObjectStatus: TDynamicObjectState;

      constructor Create;
      destructor Destroy; override;

      procedure Update(CurTick: Integer); override;

      function GetSelfData: PTCreateGroupMoveData;
   end;

   TGroupMoveList = class(TBasicObjectList)
   private
   public
      constructor Create;
      destructor Destroy; override;

      procedure LoadFromFile(aFileName: string);
   end;

   //厘过俊 措茄 瓤苞惯瓤 矫埃阑 贸府窍扁 困茄 努贰胶
   TAttackedMagicClass = class
   private
      FBasicObject: TBasicObject;
      FAttackedMagicArr: array[0..ATTACKEDMAGICSIZE - 1] of TAttackedMagic;
   public
      constructor Create(aBasicObject: TBasicObject);
      destructor Destroy; override;

      procedure Clear;

      procedure Update(CurTick: Integer);

      function AddWindOfHand(var aSubData: TSubData): Boolean;
   end;

procedure SignToItem(var aItemData: TItemData; aServerID: Integer; var
   aBasicData: TBasicData; aIP: string);

var
   boShowHitedValue: Boolean = FALSE;
   boShowGuildDuraValue: Boolean = FALSE;

   GateList: TGateList = nil;
   GateListEx: TGateListEx = nil;
   GroupMoveList: TGroupMoveList = nil;
   MirrorList: TMirrorList = nil;
   ZoneEffectList: TZoneEffectList = nil;

   MaxConnectionCount: Integer = 0;
   MaxPacketCount: Integer = 0;
   MaxViewCount: Integer = 0;
   MaxDelayUserTick: LongWord = 0;
   MaxDelayMonsterTick: LongWord = 0;
   MaxDelayNpcTick: LongWord = 0;
   MaxDelayGuildTick: LongWord = 0;
   MaxDelayGateTick: LongWord = 0;
   MaxDelayGateConnectorTick: LongWord = 0;
   MaxDelayDynamicTick: LongWord = 0;
   MaxDelayMineTick: LongWord = 0;

   iGStartTick, iGEndTick: LongWord;

implementation

uses
   SvMain, uUser, uNpc, uMonster, uSkills, uLevelExp, UserSDB, uEvent, uGuild,
      uZhuang;

///////////////////////////////
//        TBasicObject
///////////////////////////////

constructor TBasicObject.Create;
begin
   FillChar(BasicData, sizeof(BasicData), 0);
   BasicData.P := Self;
   ViewObjectList := TList.Create;
   // ViewObjectNameList := TStringList.Create;

   FShowEffectNumber := 0;
   FHideEffectNumber := 0;
   FShowEffectKind := lek_none;
   FHideEffectKind := lek_none;

   SOnCreate := 0;
   SOnDestroy := 0;
   SOnDanger := 0;
   SOnHit := 0;
   SOnBow := 0;
   SOnStructed := 0;
   SOnShow := 0;
   SOnHide := 0;
   SOnDie := 0;
   SOnDieBefore := 0;
   SOnHear := 0;
   SOnLeftClick := 0;
   SOnRightClick := 0;
   SOnDblClick := 0;
   SOnDropItem := 0;
   SOnChangeState := 0;
   SOnMove := 0;
   SOnTimer := 0;
   SOnApproach := 0;
   SOnAway := 0;
   SOnUserStart := 0;
   SOnUserEnd := 0;
   SOnArrival := 0;
   SOnGetResult := 0;
   SOnTurnOn := 0;
   SOnTurnOff := 0;
   SOnRegen := 0;
   SOnGetChangeStep := 0;

   FWorkBox := TWorkBox.Create;
end;

destructor TBasicObject.Destroy;
begin
   FWorkBox.Free;

   // ViewObjectNameList.Free;
   ViewObjectList.Free;
   inherited Destroy;
end;

procedure TBasicObject.SetShowEffect(aEffectNumber: Word; aEffectKind:
   TLightEffectKind);
begin
   FShowEffectNumber := aEffectNumber;
   FShowEffectKind := aEffectKind;
end;

procedure TBasicObject.SetHideEffect(aEffectNumber: Word; aEffectKind:
   TLightEffectKind);
begin
   FHideEffectNumber := aEffectNumber;
   FHideEffectKind := aEffectKind;
end;

procedure TBasicObject.PushMove(dir: word; length: integer);
var
   SubData: TSubData;
   xx, yy: word;
   i: integer;
begin
   if length > 2 then
      exit;

   xx := BasicData.x;
   yy := BasicData.y;

   for i := 0 to length - 1 do
   begin
      GetNextPosition(dir, xx, yy);
      if Maper.isMoveable(xx, yy) = false then
      begin
         BasicData.nx := BasicData.x;
         BasicData.ny := BasicData.y;
         break;
      end
      else
      begin
         BasicData.nx := xx;
         BasicData.ny := yy;
      end;
   end;

   if (BasicData.x = BasicData.nx) and (BasicData.y = BasicData.ny) then
   begin
      //力磊府扼搁 傲 公矫茄促
   end
   else
   begin
      Phone.SendMessage(NOTARGETPHONE, FM_BACKMOVE, BasicData, SubData);
      Maper.MapProc(BasicData.id, MM_MOVE, BasicData.x, basicData.y, xx, yy,
         BasicData);
      BasicData.x := xx;
      BasicData.y := yy;
   end;
end;

function TBasicObject.FindViewObject(aBasicObject: TBasicObject): Boolean;
var
   i: Integer;
   BasicObject: TBasicObject;
begin
   Result := false;
   for i := 0 to ViewObjectList.Count - 1 do
   begin
      BasicObject := ViewObjectList.Items[i];
      if BasicObject = aBasicObject then
      begin
         Result := true;
         exit;
      end;
   end;
end;

function TBasicObject.isHitedArea(adir, ax, ay: integer; afunc: byte; var
   apercent: integer): Boolean;
var
   xx, yy: word;
begin
   apercent := 0;
   Result := FALSE;
   case afunc of
      MAGICFUNC_NONE:
         begin
            xx := ax;
            yy := ay;
            GetNextPosition(adir, xx, yy);
            if (BasicData.x = xx) and (BasicData.y = yy) then
            begin
               apercent := 100;
               Result := TRUE;
            end;
         end;
      MAGICFUNC_8HIT:
         begin
            if GetLargeLength(ax, ay, BasicData.x, BasicData.y) > 1 then
               exit;
            apercent := Check8Hit(adir, ax, ay, BasicData.x, BasicData.y);
            if apercent = 0 then
               exit;
            Result := TRUE;
         end;
      MAGICFUNC_5HIT:
         begin
            if GetLargeLength(ax, ay, BasicData.x, BasicData.y) > 1 then
               exit;
            apercent := Check5Hit(adir, ax, ay, BasicData.x, BasicData.y);
            if apercent = 0 then
               exit;
            Result := TRUE;
         end;
   end;
end;

function TBasicObject.isBowArea(adir, ax, ay: integer; afunc: byte; var
   apercent: integer): Boolean;
begin
   apercent := 0;
   Result := FALSE;
   case afunc of
      MAGICFUNC_8HIT:
         begin
            if GetLargeLength(ax, ay, BasicData.x, BasicData.y) > 1 then
               exit;
            apercent := Check8Hit(adir, ax, ay, BasicData.x, BasicData.y);
            if apercent = 0 then
               exit;
            Result := TRUE;
         end;
      MAGICFUNC_5HIT:
         begin
            if GetLargeLength(ax, ay, BasicData.x, BasicData.y) > 1 then
               exit;
            apercent := Check5Hit(adir, ax, ay, BasicData.x, BasicData.y);
            if apercent = 0 then
               exit;
            Result := TRUE;
         end;
   end;
end;

function TBasicObject.isSpellArea(aSX, aSY: Word; aSpellWidth: Integer):
   Boolean;
begin
   Result := false;

   if GetLargeLength(aSx, aSy, BasicData.x, BasicData.y) > aSpellWidth then
      exit;
   Result := true;
end;

function TBasicObject.isWindOfHandArea(aSX, aSY: Word; aMinRange, aMaxRange:
   Integer; var aDis: Integer): Boolean;
var
   dis: integer;
   dx, dy: integer;
   a: integer;
begin
   Result := false;
   dis := GetCellLength(aSX, aSY, BasicData.x, BasicData.y);
   if dis < aMinRange then
      exit;
   if dis > aMaxRange then
      exit;

   if aSX > BasicData.x then
      dx := aSX - BasicData.x
   else
      dx := BasicData.x - aSX;
   if aSY > BasicData.y then
      dy := aSY - BasicData.y
   else
      dy := BasicData.y - aSY;

   if dx > dy then
      a := 1
   else
      a := 2;
   if a = 1 then
      dis := (48 * dx + 12 * dy) div 10 + 49
   else
      dis := (16 * dx + 36 * dy) div 10 + 49;

   {
   dis := GetCellLength (32*dx, 24*dy,0,0);
   dis := dis * 3 div 20 + 49;
   }
   aDis := dis;
   Result := true;
end;

function TBasicObject.isCriticalAttackArea(tid: Longint; aRangeType: byte; sx,
   sy, sdir, tx, ty, tdir, aMin, aMax: word; afunc, aper: byte): Boolean;
var
   n, ix, iy: word;
   i: integer;
begin
   Result := false;

   case aRangeType of
      RANGETYPE_NONE:
         begin
            if tid <> BasicData.id then
               exit;

            n := GetLargeLength(sx, sy, tx, ty);
            if (n >= aMin) and (n <= aMax) then
            begin
               Result := true;
               exit;
            end;
         end;
      RANGETYPE_CENTER_8:
         begin
            n := GetLargeLength(sx, sy, BasicData.x, BasicData.y);
            if (n >= aMin) and (n <= aMax) then
            begin
               Result := true;
               exit;
            end;
         end;
      RANGETYPE_CENTER_4:
         begin
            n := sdir mod 2;

            case n of
               0:
                  begin //绞磊
                     ix := sx;
                     //合
                     for iy := sy + aMin to sy + aMax do
                     begin
                        if (ix = BasicData.x) and (iy = BasicData.y) then
                        begin
                           Result := true;
                           exit;
                        end;
                        if (afunc = CRITICMAGIC_FUNC_YOU8) and (Check8Hit(sdir,
                           ix, iy, BasicData.x, BasicData.y) <> 0) then
                        begin
                           Result := true;
                           exit;
                        end;
                     end;

                     //巢
                     for iy := sy - aMax to sy - aMin do
                     begin
                        if (ix = BasicData.x) and (iy = BasicData.y) then
                        begin
                           Result := true;
                           exit;
                        end;
                        if (afunc = CRITICMAGIC_FUNC_YOU8) and (Check8Hit(sdir,
                           ix, iy, BasicData.x, BasicData.y) <> 0) then
                        begin
                           Result := true;
                           exit;
                        end;
                     end;

                     iy := sy;
                     //悼
                     for ix := sx + aMin to sx + aMax do
                     begin
                        if (ix = BasicData.x) and (iy = BasicData.y) then
                        begin
                           Result := true;
                           exit;
                        end;
                        if (afunc = CRITICMAGIC_FUNC_YOU8) and (Check8Hit(sdir,
                           ix, iy, BasicData.x, BasicData.y) <> 0) then
                        begin
                           Result := true;
                           exit;
                        end;
                     end;
                     //辑
                     for ix := sx - aMax to sx - aMin do
                     begin
                        if (ix = BasicData.x) and (iy = BasicData.y) then
                        begin
                           Result := true;
                           exit;
                        end;
                        if (afunc = CRITICMAGIC_FUNC_YOU8) and (Check8Hit(sdir,
                           ix, iy, BasicData.x, BasicData.y) <> 0) then
                        begin
                           Result := true;
                           exit;
                        end;
                     end;
                  end;
               1:
                  begin //农肺胶
                     aMin := aMin - 1;
                     aMax := aMax - 1;
                     //悼巢
                     for i := aMin to aMax do
                     begin
                        ix := sx + i;
                        iy := sy + i;
                        if (ix = BasicData.x) and (iy = BasicData.y) then
                        begin
                           Result := true;
                           exit;
                        end;
                        if (afunc = CRITICMAGIC_FUNC_YOU8) and (Check8Hit(sdir,
                           ix, iy, BasicData.x, BasicData.y) <> 0) then
                        begin
                           Result := true;
                           exit;
                        end;
                     end;

                     //合悼
                     for i := aMin to aMax do
                     begin
                        ix := sx + i;
                        iy := sy - i;
                        if (ix = BasicData.x) and (iy = BasicData.y) then
                        begin
                           Result := true;
                           exit;
                        end;
                        if (afunc = CRITICMAGIC_FUNC_YOU8) and (Check8Hit(sdir,
                           ix, iy, BasicData.x, BasicData.y) <> 0) then
                        begin
                           Result := true;
                           exit;
                        end;
                     end;

                     //合辑
                     for i := -aMax to -aMin do
                     begin
                        ix := sx + i;
                        iy := sy + i;
                        if (ix = BasicData.x) and (iy = BasicData.y) then
                        begin
                           Result := true;
                           exit;
                        end;
                        if (afunc = CRITICMAGIC_FUNC_YOU8) and (Check8Hit(sdir,
                           ix, iy, BasicData.x, BasicData.y) <> 0) then
                        begin
                           Result := true;
                           exit;
                        end;
                     end;

                     //巢辑
                     for i := -aMax to -aMin do
                     begin
                        ix := sx + i;
                        iy := sy - i;
                        if (ix = BasicData.x) and (iy = BasicData.y) then
                        begin
                           Result := true;
                           exit;
                        end;
                        if (afunc = CRITICMAGIC_FUNC_YOU8) and (Check8Hit(sdir,
                           ix, iy, BasicData.x, BasicData.y) <> 0) then
                        begin
                           Result := true;
                           exit;
                        end;
                     end;
                  end;
            end;
         end;
   end;
end;

procedure TBasicObject.SetManagerClass(aManager: TManager);
begin
   Manager := aManager;
   ServerID := Manager.ServerID;
   Maper := TMaper(Manager.Maper);
   Phone := TFieldPhone(Manager.Phone);
end;

function TBasicObject.GetPosX: integer;
begin
   Result := BasicData.x;
end;

function TBasicObject.GetPosY: integer;
begin
   Result := BasicData.y;
end;

function TBasicObject.GetFeatureState: TFeatureState;
begin
   Result := BasicData.Feature.rfeaturestate;
end;

procedure TBasicObject.Initial(aName, aViewName: string);
begin
   FillChar(BasicData, sizeof(BasicData), 0);
   BasicData.P := Self;
   StrPCopy(@BasicData.Name, aName);
   StrPCopy(@BasicData.ViewName, aViewName);

   BasicData.LifePercent := 100;

   FboAllowDelete := FALSE;
   FboRegisted := FALSE;
   FboHaveGuardPos := FALSE;

   FCreateX := 0;
   FCreateY := 0;
end;

procedure TBasicObject.StartProcess;
begin
   FboRegisted := TRUE;
   FboAllowDelete := FALSE;

   BasicData.dir := DR_4;
   BasicData.Feature.rfeaturestate := wfs_normal;

   FCreateX := BasicData.x;
   FCreateY := BasicData.y;
   FCreateTick := mmAnsTick;
   FTimerTick := mmAnsTick;
   FAlarmTick := 0;

   ViewObjectList.Clear;
   // ViewObjectNameList.Clear;
end;

procedure TBasicObject.EndProcess;
begin
   // ViewObjectNameList.Clear;
   ViewObjectList.Clear;
   FWorkBox.Clear;

   FboRegisted := FALSE;
end;

function TBasicObject.GetViewObjectById(aid: integer): TBasicObject;
var
   i: integer;
begin
   Result := nil;
   for i := 0 to ViewObjectList.Count - 1 do
   begin
      if TBasicObject(ViewobjectList[i]).BasicData.id = aid then
      begin
         Result := ViewObjectList[i];
         exit;
      end;
   end;
end;

function TBasicObject.GetViewObjectCountByName(aName: string): Integer;
var
   i: integer;
begin
   Result := 0;
   for i := 0 to ViewObjectList.Count - 1 do
   begin
      if StrPas(@TBasicObject(ViewobjectList[i]).BasicData.Name) = aName then
      begin
         Result := Result + 1;
      end;
   end;
end;

// function    TBasicObject.GetViewObjectByName (aName: string; aRace: integer): TBasicObject;
// 2000.09.18 鞍篮 捞抚狼 按眉啊 乐阑锭 惯积登绰 滚弊荐沥阑 困秦 牢磊眠啊
// 茫栏妨绰 按眉狼 捞抚苞 辆幅肺 八祸茄促 by Lee.S.G

function TBasicObject.GetViewObjectByName(aName: string; aRace: integer):
   TBasicObject;
var
   i: integer;
   BObject: TBasicObject;
begin
   Result := nil;
   for i := 0 to ViewObjectList.Count - 1 do
   begin
      BObject := ViewObjectList[i];
      if (BObject.BasicData.Feature.rRace = aRace) and
         (StrPas(@BObject.BasicData.Name) = aName) then
      begin
         Result := BObject;
         exit;
      end;
   end;
end;

procedure TBasicObject.BocSay(astr: string);
var
   SubData: TSubData;
begin
   SetWordString(SubData.SayString, StrPas(@BasicData.ViewName) + ': ' + astr);
   SendLocalMessage(NOTARGETPHONE, FM_SAY, BasicData, SubData);
end;

procedure TBasicObject.BocChangeFeature;
var
   SubData: TSubData;
begin
   SendLocalMessage(NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);
end;

procedure TBasicObject.BocChangeProperty;
var
   SubData: TSubData;
begin
   SendLocalMessage(NOTARGETPHONE, FM_CHANGEPROPERTY, BasicData, SubData);
end;

procedure TBasicObject.BoSysopMessage(astr: string; aSysopScope: integer);
var
   SubData: TSubData;
begin
   if not boShowHitedValue then
      exit;

   SetWordString(SubData.SayString, StrPas(@BasicData.ViewName) + ': ' + astr);
   SubData.SysopScope := aSysopScope;
   SendLocalMessage(NOTARGETPHONE, FM_SYSOPMESSAGE, BasicData, SubData);
end;

function TBasicObject.SendLocalMessage(hfu: Longint; Msg: word; var SenderInfo:
   TBasicData; var aSubData: TSubData): Integer;
var
   i: integer;
   Bo: TBasicObject;
begin
   Result := PROC_FALSE;

   if FboRegisted = false then
      exit;

   if MaxViewCount < ViewObjectList.Count then
   begin
      MaxViewCount := ViewObjectList.Count;
      AddLog(format('MVC:%s(%s.%d.%d) %d', [StrPas(@BasicData.Name),
         Manager.Title, BasicData.X, BasicData.Y, MaxViewCount]));
   end;

   if hfu = 0 then
   begin
      Result := FieldProc(hfu, Msg, SenderInfo, aSubData);

      i := 0;
      while i < ViewObjectList.Count do
      begin
         Bo := ViewObjectList[i];
         try
            if Bo <> Self then
            begin
               Bo.FieldProc(hfu, Msg, SenderInfo, aSubData)
            end;
            Inc(i);
         except
            // Str := ViewObjectNameList.Strings [i];
            // ViewObjectNameList.Delete (i);
            ViewObjectList.Delete(i);
            // frmMain.WriteLogInfo (format ('TBasicObject.SendLocalMessage (%s,%d,%d) failed %s - %x', [StrPas (@BasicData.Name), BasicData.X, BasicData.Y, Str, Integer (BO)]));
            frmMain.WriteLogInfo(format('TBasicObject.SendLocalMessage (%s,%d,%d,%d) failed, msg: %d', [StrPas(@BasicData.Name), BasicData.X, BasicData.Y, ServerID, Msg]));
         end;
      end;

   end
   else
   begin
      for i := 0 to ViewObjectList.Count - 1 do
      begin
         Bo := ViewObjectList[i];
         try
            if Bo.BasicData.id = hfu then
            begin
               result := Bo.FieldProc(hfu, Msg, SenderInfo, aSubData);
               exit;
            end;
         except
            ViewObjectList.Delete(i);
            // ViewObjectNameList.Delete (i);
            frmMain.WriteLogInfo(format('TBasicObject.SendLocalMessage (%s) failed, msg: %d', [StrPas(@BasicData.Name), Msg]));
            exit;
         end;
      end;
   end;
end;

function TBasicObject.isRange(xx, yy: word): Boolean;
var
   x1, x2, y1, y2: integer;
begin
   Result := TRUE;
   x1 := BasicData.x;
   y1 := BasicData.y;
   x2 := xx;
   y2 := yy;
   if (x2 < x1 - VIEWRANGEWIDTH) then
   begin
      Result := FALSE;
      exit;
   end;
   if (x2 > x1 + VIEWRANGEWIDTH) then
   begin
      Result := FALSE;
      exit;
   end;
   if (y2 < y1 - VIEWRANGEHEIGHT) then
   begin
      Result := FALSE;
      exit;
   end;
   if (y2 > y1 + VIEWRANGEHEIGHT) then
   begin
      Result := FALSE;
      exit;
   end;
end;

function TBasicObject.isApproach(xx, yy: word): Boolean;
var
   x1, x2, y1, y2: integer;
begin
   Result := TRUE;
   x1 := BasicData.x;
   y1 := BasicData.y;
   x2 := xx;
   y2 := yy;
   if (x2 < x1 - 2) then
   begin
      Result := FALSE;
      exit;
   end;
   if (x2 > x1 + 2) then
   begin
      Result := FALSE;
      exit;
   end;
   if (y2 < y1 - 2) then
   begin
      Result := FALSE;
      exit;
   end;
   if (y2 > y1 + 2) then
   begin
      Result := FALSE;
      exit;
   end;
end;

function TBasicObject.isRangeMessage(hfu: Longint; Msg: word; var SenderInfo:
   TBasicData): Boolean;
begin
   Result := FALSE;
   if (hfu = BasicData.id) then
   begin
      Result := TRUE;
      exit;
   end;
   if hfu = NOTARGETPHONE then
   begin
      if isRange(SenderInfo.x, SenderInfo.y) then
      begin
         Result := TRUE;
         exit;
      end;
      if ((msg = FM_MOVE) or (msg = FM_BACKMOVE)) and isRange(SenderInfo.nx,
         SenderInfo.ny) then
      begin
         Result := TRUE;
         exit;
      end;
   end;
   if Msg = FM_SHOUT then
      Result := TRUE;
end;

function TBasicObject.FieldProc(hfu: Longint; Msg: word; var SenderInfo:
   TBasicData; var aSubData: TSubData): Integer;
var
   i: integer;
   SubData: TSubData;
   bo1, bo2: boolean;
begin
   Result := PROC_FALSE;

   if not FboRegisted then
   begin
      frmMain.WriteLogInfo(format('UnRegisted BasicObject.FieldProc was called,SenderName: %s ,Msg: %d, Receiver:%s',
         [StrPas(@SenderInfo.Name), Msg, StrPas(@BasicData.Name)]));
      exit;
   end;

   case Msg of
      FM_GIVEMEADDR: if hfu = BasicData.id then
            Result := Integer(Self);

      FM_CLICK: if hfu = BasicData.id then
            SetWordString(aSubData.SayString, StrPas(@BasicData.viewName));
      FM_SHOW:
         begin
            if SenderInfo.id = Basicdata.id then
            begin
               ViewObjectList.Clear;
               // ViewObjectNameList.Clear;
            end;

            if FindViewObject(SenderInfo.P) = true then
            begin
               frmMain.WriteLogInfo('ViewObjectList Duplicate');
               exit;
            end;

            {
            BO := TBasicObject (SenderInfo.P);
            Case BO.BasicData.Feature.rrace of
               RACE_HUMAN : Str := format ('human %s %d,%d %x', [StrPas (@SenderInfo.Name), SenderInfo.X, SEnderInfo.Y, Integer (BO)]);
               RACE_MONSTER : Str := format ('monster %s %d,%d %x', [StrPas (@SenderInfo.Name), SenderInfo.X, SEnderInfo.Y, Integer (BO)]);
               RACE_NPC : Str := format ('npc %s %d,%d %x', [StrPas (@SenderInfo.Name), SenderInfo.X, SEnderInfo.Y, Integer (BO)]);
               Else Str := format ('etc %s %d,%d %x', [StrPas (@SenderInfo.Name), SenderInfo.X, SEnderInfo.Y, Integer (BO)]);
            end;
            }

            if SenderInfo.Feature.rrace = RACE_HUMAN then
            begin
               ViewObjectList.Insert(0, SenderInfo.p);
               // ViewObjectNameList.Insert (0, Str);
            end
            else
            begin
               ViewObjectList.Add(SenderInfo.p);
               // ViewObjectNameList.Add (Str);
            end;
         end;
      FM_HIDE:
         begin
            for i := 0 to ViewObjectList.Count - 1 do
            begin
               if ViewObjectList[i] = SenderInfo.P then
               begin
                  ViewObjectList.Delete(i);
                  // ViewObjectNameList.Delete (i);
                  break;
               end;
            end;
         end;
      FM_CREATE:
         begin
            Phone.SendMessage(BasicData.Id, FM_SHOW, SenderInfo, aSubData);
            if SenderInfo.Id = BasicData.id then
            begin
               BasicData := SenderInfo;
               if (BasicData.Feature.rRace = RACE_HUMAN) and
                  (BasicData.Feature.rfeaturestate = wfs_die) then
                  exit;
               Maper.MapProc(BasicData.Id, MM_SHOW, BasicData.x, BasicData.y,
                  BasicData.x, BasicData.y, BasicData);
            end
            else
            begin
               Result := PROC_TRUE;
               Phone.SendMessage(SenderInfo.Id, FM_SHOW, BasicData, SubData);
            end;
         end;
      FM_DESTROY:
         begin
            if SenderInfo.Id = BasicData.id then
               Maper.MapProc(BasicData.Id, MM_HIDE, BasicData.x, BasicData.y,
                  BasicData.x, BasicData.y, BasicData);
            Phone.SendMessage(BasicData.Id, FM_HIDE, SenderInfo, aSubData);
         end;
      FM_AFTERCREATE:
         begin
            if SOnCreate <> 0 then
            begin
               ScriptManager.CallEvent(Self, Senderinfo.p, SOnCreate, 'OnCreate',
                  ['']);
            end;
         end;
      FM_BEFOREDESTROY:
         begin
            if SOnDestroy <> 0 then
            begin
               ScriptManager.CallEvent(Self, Senderinfo.p, SOnDestroy,
                  'OnDestroy', ['']);
            end;
         end;
      FM_BACKMOVE:
         begin
            bo1 := isRange(SenderInfo.x, SenderInfo.y);
            bo2 := isRange(SenderInfo.nx, SenderInfo.ny);
            if (bo1 = TRUE) and (bo2 = FALSE) then
            begin
               Phone.SendMessage(SenderInfo.Id, FM_HIDE, BasicData, SubData);
               Phone.SendMessage(BasicData.id, FM_HIDE, SenderInfo, aSubData);
               exit;
            end;
            if (bo1 = FALSE) and (bo2 = TRUE) then
            begin
               SubData.EffectNumber := 0;
               SubData.EffectKind := lek_none;
               Phone.SendMessage(SenderInfo.Id, FM_SHOW, BasicData, SubData);
               Phone.SendMessage(BasicData.ID, FM_SHOW, SenderInfo, aSubData);
               exit;
            end;
         end;
      FM_MOVE:
         begin
            if SOnMove <> 0 then
            begin
               ScriptManager.CallEvent(Self, Senderinfo.p, SOnMove, 'OnMove',
                  ['']);
            end;

            bo1 := isApproach(SenderInfo.x, SenderInfo.y);
            bo2 := isApproach(SenderInfo.nx, SenderInfo.ny);
            if (bo1 = TRUE) and (bo2 = FALSE) then
            begin
               Phone.SendMessage(SenderInfo.Id, FM_AWAY, BasicData, SubData);
               Phone.SendMessage(BasicData.id, FM_AWAY, SenderInfo, aSubData);
               exit;
            end;
            if (bo1 = FALSE) and (bo2 = TRUE) then
            begin
               Phone.SendMessage(SenderInfo.Id, FM_APPROACH, BasicData,
                  SubData);
               Phone.SendMessage(BasicData.ID, FM_APPROACH, SenderInfo,
                  aSubData);
               exit;
            end;

            bo1 := isRange(SenderInfo.x, SenderInfo.y);
            bo2 := isRange(SenderInfo.nx, SenderInfo.ny);
            if (bo1 = TRUE) and (bo2 = FALSE) then
            begin
               Phone.SendMessage(SenderInfo.Id, FM_HIDE, BasicData, SubData);
               Phone.SendMessage(BasicData.id, FM_HIDE, SenderInfo, aSubData);
               exit;
            end;
            if (bo1 = FALSE) and (bo2 = TRUE) then
            begin
               SubData.EffectNumber := 0;
               SubData.EffectKind := lek_none;
               Phone.SendMessage(SenderInfo.Id, FM_SHOW, BasicData, SubData);
               Phone.SendMessage(BasicData.ID, FM_SHOW, SenderInfo, aSubData);
               exit;
            end;
         end;
      FM_SELFSAY:
         begin
            if hfu = BasicData.ID then
               BocSay(GetWordString(aSubData.SayString));
         end;
      FM_APPROACH:
         begin
            if SOnApproach <> 0 then
            begin
               ScriptManager.CallEvent(Self, Senderinfo.p, SOnApproach,
                  'OnApproach', ['']);
            end;
         end;
      FM_AWAY:
         begin
            if SOnAway <> 0 then
            begin
               ScriptManager.CallEvent(Self, Senderinfo.p, SOnAway, 'OnAway',
                  ['']);
            end;
         end;
   end;
end;

procedure TBasicObject.Update(CurTick: integer);
var
   Str: string;
   nHour, nMin, nSec, nMSec: Word;
begin
   if FboRegisted = false then
      exit;

   if SOnTimer <> 0 then
   begin
      if CurTick >= FTimerTick + 100 then
      begin
         DecodeTime(Time, nHour, nMin, nSec, nMSec);
         Str := format('%d %d %d', [nHour, nMin, nSec]);
         ScriptManager.CallEvent(Self, nil, SOnTimer, 'OnTimer', [Str]);
         FTimerTick := CurTick;
      end;
   end;
end;

function TBasicObject.SGetName: string;
begin
   Result := StrPas(@BasicData.Name);
end;

function TBasicObject.SGetSex: Integer;
begin
   Result := 1;
   if BasicData.Feature.rboMan = false then
      Result := 2;
end;

function TBasicObject.SGetAge: Integer;
begin
   Result := 0;
end;

function TBasicObject.SGetId: Integer;
begin
   Result := BasicData.id;
end;

function TBasicObject.SGetServerId: Integer;
begin
   Result := ServerID;
end;

procedure TBasicObject.SGetPosition(var aMapID: Integer; var aX, aY: Word);
begin
   aMapID := Manager.ServerID;
   aX := BasicData.X;
   aY := BasicData.Y;
end;

function TBasicObject.SGetMapName: string;
begin
   Result := Manager.Title;
end;

function TBasicObject.SGetMoveableXY(aX, aY: Word): string;
begin
   Result := 'false';
   if TMaper(Maper).isMoveable(aX, aY) = true then
   begin
      Result := 'true';
   end;
end;

function TBasicObject.SGetNearXY(aX, aY: Word): string;
var
   xx, yy: Integer;
begin
   xx := aX;
   yy := aY;
   TMaper(Maper).GetNearXY(xx, yy);

   Result := format('%d_%d', [xx, yy]);
end;

function TBasicObject.SGetRace: Byte;
begin
   Result := BasicData.Feature.rRace;
end;

function TBasicObject.SGetState: Byte;
begin
   Result := Byte(BasicData.Feature.rFeatureState);
end;

function TBasicObject.SGetMaxLife: Integer;
begin
   Result := 0;
end;

function TBasicObject.SGetMaxInPower: Integer;
begin
   Result := 0;
end;

function TBasicObject.SGetMaxOutPower: Integer;
begin
   Result := 0;
end;

function TBasicObject.SGetMaxMagic: Integer;
begin
   Result := 0;
end;

function TBasicObject.SGetLife: Integer;
begin
   Result := 0;
end;

function TBasicObject.SGetHeadLife: Integer;
begin
   Result := 0;
end;

function TBasicObject.SGetArmLife: Integer;
begin
   Result := 0;
end;

function TBasicObject.SGetLegLife: Integer;
begin
   Result := 0;
end;

function TBasicObject.SGetPower: Integer;
begin
   Result := 0;
end;

function TBasicObject.SGetInPower: Integer;
begin
   Result := 0;
end;

function TBasicObject.SGetOutPower: Integer;
begin
   Result := 0;
end;

function TBasicObject.SGetMagic: Integer;
begin
   Result := 0;
end;

function TBasicObject.SGetVirtue: Integer;
begin
   Result := 0;
end;

function TBasicObject.SGetTalent: Integer;
begin
   Result := 0;
end;

function TBasicObject.SGetMoveSpeed: Integer;
begin
   Result := 0;
end;

function TBasicObject.SGetUseAttackMagic: string;
begin
   Result := '';
end;

function TBasicObject.SGetUseAttackSkillLevel: Integer;
begin
   Result := 0;
end;

function TBasicObject.SGetUseMagicSkillLevel(aKind: Word): Integer;
begin
   Result := 0;
end;

function TBasicObject.SGetMagicSkillLevel(aName: string): Integer;
begin
   Result := 0;
end;

function TBasicObject.SGetUseProtectMagic: string;
begin
   Result := '';
end;

function TBasicObject.SFindObjectByName(aName: string): Integer;
var
   i: Integer;
   BO: TBasicObject;
begin
   Result := 0;

   for i := 0 to ViewObjectList.Count - 1 do
   begin
      BO := ViewObjectList.Items[i];
      if StrPas(@BO.BasicData.Name) = aName then
      begin
         Result := BO.BasicData.ID;
         exit;
      end;
   end;
end;

function TBasicObject.SGetCompleteQuest: Integer;
begin
   Result := 0;
end;

function TBasicObject.SGetCurrentQuest: Integer;
begin
   Result := 0;
end;

function TBasicObject.SGetQuestStr: string;
begin
   Result := '';
end;

function TBasicObject.SGetFirstQuest: Integer;
begin
   Result := 0;
end;

function TBasicObject.SGetItemExistence(aItem: string; aOption: Integer):
   string;
begin
   Result := 'false';
end;

function TBasicObject.SGetItemExistenceByKind(aKind, aOption: Integer): string;
begin
   Result := 'false';
end;

function TBasicObject.SCheckEnoughSpace(aCount: Integer): string;
begin
   Result := 'false';
end;

function TBasicObject.SGetHaveGradeQuestItem: string;
begin
   Result := 'false';
end;

function TBasicObject.SCheckAliveMonsterCount(aServerID: Integer; aRace, aName:
   string): Integer;
var
   tmpManager: TManager;
   iMonster, iNpc, iDyn: Integer;
begin
   Result := 0;

   tmpManager := ManagerList.GetManagerByServerID(aServerID);
   if tmpManager <> nil then
   begin
      if UpperCase(aRace) = 'MONSTER' then
      begin
         iMonster :=
            TMonsterList(tmpManager.MonsterList).GetAliveCountbyMonsterName(aName);
         Result := iMonster;
         exit;
      end;
      if UpperCase(aRace) = 'NPC' then
      begin
         iNpc := TNpcList(tmpManager.NpcList).AliveCount;
         Result := iNpc;
         exit;
      end;
      if UpperCase(aRace) = 'DYN' then
      begin
         iDyn :=
            TDynamicObjectList(tmpManager.DynamicObjectList).FindDynamicObject(aName);
         Result := iDyn;
         exit;
      end;
   end;
end;

function TBasicObject.SGetUserCount(aID: Integer): Integer;
begin
   Result := 0;
   if UserList <> nil then
   begin
      Result := UserList.GetUserCountByManager(aID);
   end;
end;

function TBasicObject.SGetJobKind: Byte;
begin
   Result := JOB_KIND_NONE;
end;

function TBasicObject.SGetJobGrade: Byte;
begin
   Result := JOB_GRADE_NONE;
end;

function TBasicObject.SGetJobTalent: Integer;
begin
   Result := 0;
end;

{
function TBasicObject.SGetToolName : String;
begin
   Result := '';
end;
}

function TBasicObject.SGetWearItemCurDurability(aKey: Integer): Integer;
begin
   Result := 0;
end;

function TBasicObject.SGetWearItemMaxDurability(aKey: Integer): Integer;
begin
   Result := 0;
end;

function TBasicObject.SGetWearItemName(aKey: Integer): string;
begin
   Result := '';
end;

function TBasicObject.SGetMagicCountBySkill(aType, aSKill: Integer): string;
begin
   Result := 'false';
end;

function TBasicObject.SGetSystemInfo(aCmd: string): string;
begin
   Result := '';
   if LowerCase(aCmd) = 'getbestguild' then
   begin
      Result := GuildList.GetBestGuild;
      exit;
   end;
end;

function TBasicObject.SRepairItem(aKey, aKind: Integer): Integer;
begin
   Result := 0;
end;

function TBasicObject.SDestroyItembyKind(aKey, aKind: Integer): Integer;
begin
   Result := 0;
end;

function TBasicObject.SFindItemCount(aItemName: string): string;
begin
   Result := '';
end;

function TBasicObject.SGetPossibleGrade(atype, agrade: byte): string;
begin
   Result := 'false';
end;

function TBasicObject.SCheckPowerWearItem: Integer;
begin
   Result := 0;
end;

function TBasicObject.SCheckCurUseMagic(aType: Byte): string;
begin
   Result := 'false';
end;

function TBasicObject.SCheckCurUseMagicByGrade(aType, aGrade, amagictype: Byte):
   string;
begin
   Result := 'false';
end;

function TBasicObject.SGetCurPowerLevelName: string;
begin
   Result := '';
end;

function TBasicObject.SGetCurPowerLevel: Integer;
begin
   Result := 0;
end;

function TBasicObject.SGetCurDuraWaterCase: Integer;
begin
   Result := 0;
end;

function TBasicObject.SGetRemainMapTime(aRemainMin, aRemainSec: Integer):
   string;
begin
   Result := 'false';

   if Manager.RegenInterval > 0 then
   begin
      if (Manager.RemainHour = 0) and (Manager.RemainMin = 0) then
      begin
         if aRemainSec > 0 then
         begin
            if aRemainSec < Manager.RemainSec then
            begin
               exit;
            end;
         end;
      end
      else
      begin
         if aRemainMin > 0 then
         begin
            if aRemainMin < Manager.RemainMin then
            begin
               exit;
            end
         end;
      end;
   end;

   Result := 'true';
end;

function TBasicObject.SCheckEnterMap(aServerID: Integer): string;
var
   tmpManager: TManager;
begin
   Result := 'false';

   tmpManager := ManagerList.GetManagerByServerID(aServerID);
   if tmpManager = nil then
      exit;
   if tmpManager.boEnter = false then
      exit;

   Result := 'true';
end;

function TBasicObject.SCheckMagic(aMagicClass, aMagicType: Integer; aMagicName:
   string): string;
begin
   Result := 'false';
end;

function TBasicObject.SCheckAttribItem(aAttrib: Integer): string;
begin
   Result := 'false';
end;

function TBasicObject.SConditionBestAttackMagic(aMagicName: string): string;
begin
   Result := 'false';
end;

function TBasicObject.SGetMarryClothes: string;
begin
   Result := 'false';
end;

function TBasicObject.SGetZhuangTicketPrice: string;
begin
   Result := '50000';
end;

function TBasicObject.SGetZhuangInto: string;
begin
   Result := 'NoTicket';
end;

function TBasicObject.SGetMarryInfo: string;
begin
   Result := 'false';
end;

function TBasicObject.SGetAskConquer:String;
begin
   Result := '0';
end;

function TBasicObject.SAddArenaMember(aMasterName : String):String;
begin
   Result := 'false';
end;

function TBasicObject.SGetEvent(EventCode:integer):String;
begin
   Result := '0';
end;

function TBasicObject.SGetSetEvent(EventCode:integer):String;
begin
   Result := '0';
end;

function  TBasicObject.SCheckPickup:String;
begin
   Result := 'false';
end;

function  TBasicObject.SGetParty:String;
begin
   Result := 'false';
end;

function  TBasicObject.SSetParty:String;
begin
   Result := 'false';
end;
// method

procedure TBasicObject.SSay(aStr: string);
begin
end;

procedure TBasicObject.SGotoXY(aX, aY: Word);
begin
end;

procedure TBasicObject.SAttack(aID: Integer);
begin
end;

procedure TBasicObject.SChangeState(aState: Byte);
begin
   BasicData.Feature.rfeaturestate := TFeatureState(aState);
end;

procedure TBasicObject.SSelfKill;
begin
end;

procedure TBasicObject.SShowWindow(aCommander: TBasicObject; aFileName: string;
   aKind: Byte);
begin
end;

procedure TBasicObject.SShowWindow2(aCommander: TBasicObject; aStr: string;
   aKind: Byte);
begin

end;

procedure TBasicObject.STradeWindow(aName: string; aKind: Byte);
begin
end;

procedure TBasicObject.SLogItemWindow(aCommander: TBasicObject);
begin
end;

procedure TBasicObject.SGuildItemWindow(aCommander: TBasicObject);
begin

end;

procedure TBasicObject.SSetAutoMode;
begin
   // FWorkBox.AutoMode := wcm_auto;
end;

procedure TBasicObject.SPutMagicItem(aWeapon, aMopName: string; aRace: Byte);
begin
end;

procedure TBasicObject.SGetItem(aItem: string);
begin
end;

procedure TBasicObject.SGetItem2(aItem: string);
begin
end;

procedure TBasicObject.SGetAllItem(aItem: string);
begin
end;

procedure TBasicObject.SDeleteQuestItem;
begin
end;

procedure TBasicObject.SChangeCompleteQuest(aQuest: Integer);
begin
end;

procedure TBasicObject.SChangeCurrentQuest(aQuest: Integer);
begin
end;

procedure TBasicObject.SChangeQuestStr(aStr: string);
begin
end;

procedure TBasicObject.SChangeFirstQuest(aQuest: Integer);
begin
end;

procedure TBasicObject.SAddAddableStatePoint(aPoint: Integer);
begin
end;

procedure TBasicObject.STotalAddableStatePoint(aPoint: Integer);
begin
end;

procedure TBasicObject.SSelfChangeDynobjState(aboInc: Boolean);
begin
   if aboInc = true then
   begin
      TDynamicObject(self).IncStep;
   end
   else
   begin
      TDynamicObject(self).DecStep;
   end;
end;

procedure TBasicObject.SChangeDynobjState(aObjName: string; aboInc: Boolean);
begin
   if Manager.DynamicObjectList <> nil then
   begin
      TDynamicObjectList(Manager.DynamicObjectList).ChangeStep(aObjName,
         aboInc);
   end;
end;

procedure TBasicObject.SSendZoneEffectMessage(aName: string);
begin
end;

procedure TBasicObject.SSendChatMessage(aStr: string; aColor: Integer);
begin
end;

procedure TBasicObject.SMoveSpace(aName, aRace: string; aServerID, aX, aY:
   Integer);
var
   User: TUser;
   Monster: TMonster;
   Npc: TNpc;
   SubData: TSubData;
begin
   if UpperCase(aRace) = 'USER' then
   begin
      User := UserList.GetUserPointer(aName);
      if User <> nil then
      begin
         User.BasicData.nx := aX;
         User.BasicData.ny := aY;

         SubData.ServerId := aServerID;
         Phone.SendMessage(User.BasicData.id, FM_GATE, User.BasicData, SubData);
      end;
      exit;
   end;
   if UpperCase(aRace) = 'MONSTER' then
   begin
      Monster := TMonsterList(Manager.MonsterList).GetMonsterByName(aName,
         true);
      if Monster <> nil then
      begin
         Monster.CallMe(aX, aY);
      end;
   end;
   if UpperCase(aRace) = 'NPC' then
   begin
      Npc := TNpcList(Manager.NpcList).GetNpcByName(aName, true);
      if Npc <> nil then
      begin
         Npc.CallMe(aX, aY);
      end;
   end;
end;

procedure TBasicObject.SSetAllowHit(aHit: string);
begin
end;

procedure TBasicObject.SSetAllowDelete(aRace, aName: string);
var
   BO: TBasicObject;
begin
   BO := nil;
   if UpperCase(aRace) = 'MONSTER' then
   begin
      BO := TMonsterList(Manager.MonsterList).GetMonsterByName(aName, false);
   end
   else if UpperCase(aRace) = 'NPC' then
   begin
      BO := TNpcList(Manager.NpcList).GetNpcByName(aName, false);
   end
   else if UpperCase(aRace) = 'DYNAMICOBJECT' then
   begin
      BO :=
         TDynamicObjectList(Manager.DynamicObjectList).GetDynamicObjectbyName(aName);
   end;

   if BO <> nil then
   begin
      BO.FboAllowDelete := true;
   end;
end;

procedure TBasicObject.SShowEffect(aEffectNumber: Integer; aEffectKind:
   Integer);
begin
end;

procedure TBasicObject.SCommandIce(aInterval: Integer);
begin
end;

procedure TBasicObject.SCommandIceByName(aName, aRace: string; aInterval:
   Integer);
var
   BO: TBasicObject;
begin
   BO := nil;
   if UpperCase(aRace) = 'MONSTER' then
   begin
      BO := TMonsterList(Manager.MonsterList).GetMonsterByName(aName, true);
      if BO = nil then
         exit;
   end;
   if UpperCase(aRace) = 'NPC' then
   begin
      BO := TNpcList(Manager.NpcList).GetNpcByName(aName, true);
      if BO = nil then
         exit;
   end;
   if UpperCase(aRace) = 'USER' then
   begin
      BO := UserList.GetUserPointer(aName);
      if BO = nil then
         exit;
   end;
   if BO <> nil then
      BO.SCommandIce(aInterval);
end;

procedure TBasicObject.SSetAllowHitByName(aName, aRace, aHit: string);
var
   BO: TBasicObject;
begin
   BO := nil;
   if UpperCase(aRace) = 'MONSTER' then
   begin
      BO := TMonsterList(Manager.MonsterList).GetMonsterByName(aName, true);
      if BO = nil then
         exit;
   end;
   if UpperCase(aRace) = 'NPC' then
   begin
      BO := TNpcList(Manager.NpcList).GetNpcByName(aName, true);
      if BO = nil then
         exit;
   end;
   if UpperCase(aRace) = 'USER' then
   begin
      BO := UserList.GetUserPointer(aName);
      if BO = nil then
         exit;
   end;
   if Bo <> nil then
      BO.SSetAllowHit(aHit);
end;

procedure TBasicObject.SSayByName(aName, aRace, aSay: string; aInterval:
   Integer);
var
   BO: TBasicObject;
begin
   BO := nil;
   if UpperCase(aRace) = 'MONSTER' then
   begin
      BO := TMonsterList(Manager.MonsterList).GetMonsterByName(aName, true);
      if BO = nil then
         exit;
   end;
   if UpperCase(aRace) = 'NPC' then
   begin
      BO := TNpcList(Manager.NpcList).GetNpcByName(aName, true);
      if BO = nil then
         exit;
   end;
   if UpperCase(aRace) = 'USER' then
   begin
      BO := UserList.GetUserPointer(aName);
      if BO = nil then
         exit;
   end;
   if Bo <> nil then
      BO.PushCommand(CMD_SAY, aSay, aInterval);
end;

// add by Orber at 2004-09-16 15:10

function TBasicObject.SStartMissionTime: single;
begin

end;

function TBasicObject.SGetPassMissionTime: single;
begin

end;

function TBasicObject.SStartArenaGame: Integer;
begin

end;

// add by Orber at 2004-12-06 16:15:01

function TBasicObject.SGetIntoArenaGame(aArenaKey: Word): Integer;
begin

end;

procedure TBasicObject.SMoveSpaceByName(aParams: array of string; aName, aRace:
   string; aInterval: Integer);
var
   BO: TBasicObject;
begin
   BO := nil;
   if UpperCase(aRace) = 'MONSTER' then
   begin
      BO := TMonsterList(Manager.MonsterList).GetMonsterByName(aName, true);
      if BO = nil then
         exit;
   end;
   if UpperCase(aRace) = 'NPC' then
   begin
      BO := TNpcList(Manager.NpcList).GetNpcByName(aName, true);
      if BO = nil then
         exit;
   end;
   if UpperCase(aRace) = 'USER' then
   begin
      BO := UserList.GetUserPointer(aName);
      if BO = nil then
         exit;
   end;
   if Bo <> nil then
      BO.PushCommand(CMD_MOVESPACE, aParams, aInterval);
end;

procedure TBasicObject.SClearWorkBox;
begin
   FWorkBox.Clear;
end;

procedure TBasicObject.SRegen(aName, aRace: string);
begin
   if UpperCase(aRace) = 'MONSTER' then
   begin
      if Manager.MonsterList = nil then
         exit;
      TMonsterList(Manager.MonsterList).RegenByName(aName);
   end;
   if UpperCase(aRace) = 'NPC' then
   begin
      if Manager.NpcList = nil then
         exit;
      TNpcList(Manager.NpcList).RegenByName(aName);
   end;
   if UpperCase(aRace) = 'DYNAMICOBJECT' then
   begin
      if Manager.DynamicObjectList = nil then
         exit;
      TDynamicObjectList(Manager.DynamicObjectList).RegenByName(aName);
   end;
end;

procedure TBasicObject.SMapRegen(aMapID: Integer);
begin
   ManagerList.RegenById(aMapID);
end;

procedure TBasicObject.SMapRegenByName(aParams: array of string; aName, aRace:
   string);
var
   BO: TBasicObject;
begin
   BO := nil;
   if UpperCase(aRace) = 'MONSTER' then
   begin
      BO := TMonsterList(Manager.MonsterList).GetMonsterByName(aName, true);
      if BO = nil then
         exit;
   end;
   if UpperCase(aRace) = 'NPC' then
   begin
      BO := TNpcList(Manager.NpcList).GetNpcByName(aName, true);
      if BO = nil then
         exit;
   end;
   if UpperCase(aRace) = 'USER' then
   begin
      BO := UserList.GetUserPointer(aName);
      if BO = nil then
         exit;
   end;
   if Bo <> nil then
      BO.PushCommand(CMD_MAPREGEN, aParams, 0);
end;

procedure TBasicObject.SMapDelObjByName(aRace: string; aName: string);
begin
   if UpperCase(aRace) = 'MONSTER' then
   begin
      TMonsterList(Manager.MonsterList).DeleteMonster(aName);
      exit;
   end;
   if UpperCase(aRace) = 'DYNAMICOBJECT' then
   begin
      TDynamicObjectList(Manager.DynamicObjectList).DeleteDynamicObject(aName);
      exit;
   end;
end;

procedure TBasicObject.SMapAddObjByName(aRace: string; aParams: array of
   string);
var
   dod: TCreateDynamicObjectData;
   tmpScript: Integer;
begin
   if UpperCase(aRace) = 'MONSTER' then
   begin
      if aParams[6] = 'true' then
      begin
         TMonsterList(Manager.MonsterList).MakeMonster(aParams[1],
            _StrToInt(aParams[2]),
            _StrToInt(aParams[3]), _StrToInt(aParams[4]), _StrToInt(aParams[5]),
               true);
      end
      else if aParams[6] = 'false' then
      begin
         TMonsterList(Manager.MonsterList).MakeMonster(aParams[1],
            _StrToInt(aParams[2]),
            _StrToInt(aParams[3]), _StrToInt(aParams[4]), _StrToInt(aParams[5]),
               false);
      end;
      exit;
   end;
   if UpperCase(aRace) = 'NPC' then
   begin
      TNpcList(Manager.NpcList).AddNpc(aParams[1], _StrToInt(aParams[2]),
         _StrToInt(aParams[3]),
         _StrToInt(aParams[4]), _StrToInt(aParams[5]), aParams[6]);
      exit;
   end;
   if UpperCase(aRace) = 'DYNAMICOBJECT' then
   begin
      FillChar(dod, SizeOf(TCreateDynamicObjectData), 0);
      DynamicObjectClass.GetDynamicObjectData(aParams[1], dod.rBasicData);
      dod.rServerId := Manager.ServerID;
      dod.rX[0] := _StrToInt(aParams[2]);
      dod.rY[0] := _StrToInt(aParams[3]);
      tmpScript := _StrToInt(aParams[4]);
      if tmpScript > 0 then
         dod.rScript := tmpScript;
      TDynamicObjectList(Manager.DynamicObjectList).AddDynamicObject(@dod);
      exit;
   end;
end;

procedure TBasicObject.SSendSound(aWavName: string; aMapID: Integer);
begin
   UserList.SendSoundMessage(aWavName, aMapID);
end;

procedure TBasicObject.SboIceAllbyName(aName, aRace, aboIce: string);
begin
   if UpperCase(aRace) = 'MONSTER' then
   begin
      if aboIce = 'true' then
      begin
         TMonsterList(Manager.MonsterList).boIceAllMonsterByName(aName, true);
      end
      else if aboIce = 'false' then
      begin
         TMonsterList(Manager.MonsterList).boIceAllMonsterByName(aName, false);
      end;
   end;
end;

procedure TBasicObject.SboHitAllbyName(aName, aRace, aboHit: string);
begin
   if UpperCase(aRace) = 'MONSTER' then
   begin
      if aboHit = 'true' then
      begin
         TMonsterList(Manager.MonsterList).boHitAllMonsterByName(aName, true);
      end
      else if aboHit = 'false' then
      begin
         TMonsterList(Manager.MonsterList).boHitAllMonsterByName(aName, false);
      end;
   end;
end;

procedure TBasicObject.SboPickbyMapName(aMapName, aboPick: string);
var
   Manager: TManager;
begin
   Manager := ManagerList.GetManagerByTitle(aMapName);
   if Manager = nil then
      exit;

   if aboPick = 'true' then
      Manager.boPick := true
   else if aboPick = 'false' then
      Manager.boPick := false;
end;

procedure TBasicObject.SRePosition(aBo: TBasicObject);
var
   SubData: TSubData;
   xx, yy: Word;
begin
   if aBo.BasicData.Feature.rrace <> RACE_HUMAN then
      exit;

   GetOppositePosition(aBO.BasicData.X, aBO.BasicData.Y, BasicData.X,
      BasicData.Y, xx, yy);
   // SubData.Tx := xx;
   // SubData.Ty := yy;
   if Maper.isMoveable(xx, yy) = true then
   begin
      aBO.BasicData.nx := xx;
      aBO.BasicData.ny := yy;
      Phone.SendMessage(NOTARGETPHONE, FM_BACKMOVE, aBO.BasicData, SubData);
      Maper.MapProc(aBO.BasicData.id, MM_MOVE, aBO.BasicData.x, aBO.basicData.y,
         xx, yy, aBO.BasicData);
      aBO.BasicData.x := xx;
      aBO.BasicData.y := yy;
   end;
end;

procedure TBasicObject.SReturnDamage(aBo: TBasicObject; aMaxDamage, aDecRate:
   Integer);
var
   Damage, MaxLife, reDamage: Integer;
begin
   if aBo.BasicData.Feature.rrace <> RACE_HUMAN then
      exit;

   MaxLife := TUser(aBO).SGetMaxLife;

   reDamage := (aMaxDamage * aDecRate) div 100;
   Damage := (reDamage * 100) div MaxLife;
   TUser(aBO).CommandDecLifePercent(Damage);
end;

procedure TBasicObject.SSetJobKind(aKind: Byte);
begin
end;

procedure TBasicObject.SSetVirtueman;
begin
end;

procedure TBasicObject.SSmeltItem(aMakeName: string);
begin
end;

procedure TBasicObject.SSmeltItem2(aMakeName: string);
begin
end;

procedure TBasicObject.SQuestComplete(aStr, aQuestName: string);
var
   Str: string;
begin
   Str := aStr + Conv('祝贺您,') + aQuestName +
      Conv('任务结束');
   UserList.SendTopMessage(Str);
end;

procedure TBasicObject.SSendItemMoveInfo(aStr: string);
begin
end;

procedure TBasicObject.SSendTopMessage(aStr: string);
begin
   UserList.SendTopMessage(aStr);
end;

procedure TBasicObject.SSendNoticeMessageForMapUser(aServerID: Integer; aStr:
   string; aColor: Integer);
begin
   UserList.SayByServerID(aServerID, aStr, aColor);
end;

procedure TBasicObject.SRefill;
var
   SubData: TSubData;
begin
   SendLocalMessage(NOTARGETPHONE, FM_REFILL, BasicData, SubData);
end;

procedure TBasicObject.SChangeCurDuraByName(aName: string; aCurDura: Integer);
begin
end;

procedure TBasicObject.SboMapEnter(aServerID: Integer; aboEnter: string);
var
   tmpManager: TManager;
begin
   tmpManager := ManagerList.GetManagerByServerID(aServerID);
   if tmpManager <> nil then
   begin
      if aboEnter = 'true' then
      begin
         tmpManager.boEnter := true;
      end
      else
      begin
         tmpManager.boEnter := false;
      end;
   end;
end;

procedure TBasicObject.SDecreasePrisonTime(aTime: Integer);
begin

end;

procedure TBasicOBject.SUseMagicGradeup(atype, tg: byte);
begin
end;

procedure TBasicObject.SetScript(aIndex: Integer);
begin
   SOnHear := ScriptManager.CheckScriptEvent(aIndex, 'OnHear');
   SOnShow := ScriptManager.CheckScriptEvent(aIndex, 'OnShow');

   SOnCreate := ScriptManager.CheckScriptEvent(aIndex, 'OnCreate');
   SOnDestroy := ScriptManager.CheckScriptEvent(aIndex, 'OnDestroy');
   SOnDanger := ScriptManager.CheckScriptEvent(aIndex, 'OnDanger');
   SOnHit := ScriptManager.CheckScriptEvent(aIndex, 'OnHit');
   SOnBow := ScriptManager.CheckScriptEvent(aIndex, 'OnBow');
   SOnStructed := ScriptManager.CheckScriptEvent(aIndex, 'OnStructed');
   SOnHide := ScriptManager.CheckScriptEvent(aIndex, 'OnHide');
   SOnDie := ScriptManager.CheckScriptEvent(aIndex, 'OnDie');
   SOnDieBefore := ScriptManager.CheckScriptEvent(aIndex, 'OnDieBefore');
   SOnLeftClick := ScriptManager.CheckScriptEvent(aIndex, 'OnLeftClick');
   SOnRightClick := ScriptManager.CheckScriptEvent(aIndex, 'OnRightClick');
   SOnDblClick := ScriptManager.CheckScriptEvent(aIndex, 'OnDblClick');
   SOnDropItem := ScriptManager.CheckScriptEvent(aIndex, 'OnDropItem');
   SOnChangeState := ScriptManager.CheckScriptEvent(aIndex, 'OnChangeState');
   SOnMove := ScriptManager.CheckScriptEvent(aIndex, 'OnMove');
   SOnTimer := ScriptManager.CheckScriptEvent(aIndex, 'OnTimer');
   SOnApproach := ScriptManager.CheckScriptEvent(aIndex, 'OnApproach');
   SOnAway := ScriptManager.CheckScriptEvent(aIndex, 'OnAway');
   SOnUserStart := ScriptManager.CheckScriptEvent(aIndex, 'OnUserStart');
   SOnUserEnd := ScriptManager.CheckScriptEvent(aIndex, 'OnUserEnd');
   SOnArrival := ScriptManager.CheckScriptEvent(aIndex, 'OnArrival');
   SOnGetResult := ScriptManager.CheckScriptEvent(aIndex, 'OnGetResult');
   SOnTurnOn := ScriptManager.CheckScriptEvent(aIndex, 'OnTurnOn');
   SOnTurnOff := ScriptManager.CheckScriptEvent(aIndex, 'OnTurnOff');
   SOnRegen := ScriptManager.CheckScriptEvent(aIndex, 'OnRegen');
   SOnGetChangeStep := ScriptManager.CheckScriptEvent(aIndex,
      'OnGetChangeStep');
end;

procedure TBasicObject.PushCommand(aCmd: Byte; aParams: array of string;
   aInterval: Integer);
var
   WorkSet: TWorkSet;
begin
   WorkSet := TWorkSet.Create;
   WorkSet.Cmd := aCmd;
   WorkSet.Interval := aInterval;

   case aCmd of
      CMD_ATTACK:
         begin
            WorkSet.Priority := wsp_giga;
            WorkSet.AddiParam(wpt_integer, _StrToInt(aParams[0]));
         end;
      CMD_MOVEATTACK:
         begin
            WorkSet.Priority := wsp_byte;
            WorkSet.AddiParam(wpt_integer, _StrToInt(aParams[0]));
         end;
      CMD_GOTOXY:
         begin
            WorkSet.Priority := wsp_byte;
            WorkSet.AddiParam(wpt_integer, _StrToInt(aParams[0]));
            WorkSet.AddiParam(wpt_integer, _StrToInt(aParams[1]));
         end;
      CMD_SAY:
         begin
            WorkSet.Priority := wsp_tera;
            WorkSet.AddsParam(wpt_string, aParams[0]);
         end;
      CMD_SOUND:
         begin
            WorkSet.Priority := wsp_tera;
            WorkSet.AddsParam(wpt_string, aParams[0]);
         end;
      CMD_SELFKILL:
         begin
            WorkSet.Priority := wsp_byte;
            WorkSet.AddsParam(wpt_string, '');
         end;
      CMD_CHANGESTATE:
         begin
            WorkSet.Priority := wsp_byte;
            WorkSet.AddiParam(wpt_integer, _StrToInt(aParams[0]));
         end;
      CMD_SENDCENTERMSG:
         begin
            WorkSet.Priority := wsp_giga;
            WorkSet.AddsParam(wpt_string, aParams[0]);
            WorkSet.AddsParam(wpt_string, aParams[1]);
         end;
      CMD_CHANGESTEP:
         begin
            WorkSet.Priority := wsp_byte;
            WorkSet.AddsParam(wpt_string, aParams[0]);
            WorkSet.AddsParam(wpt_string, aParams[1]);
         end;
      CMD_MOVESPACE:
         begin
            WorkSet.Priority := wsp_tera;
            WorkSet.AddsParam(wpt_string, aParams[0]);
            WorkSet.AddsParam(wpt_string, aParams[1]);
            WorkSet.AddiParam(wpt_integer, _StrToInt(aParams[2]));
            WorkSet.AddiParam(wpt_integer, _StrToInt(aParams[3]));
            WorkSet.AddiParam(wpt_integer, _StrToInt(aParams[4]));
         end;
      CMD_MAPREGEN:
         begin
            WorkSet.Priority := wsp_tera;
            WorkSet.AddiParam(wpt_integer, _StrToInt(aParams[0]));
         end;
      CMD_ALLOWHIT:
         begin
            WorkSet.Priority := wsp_tera;
            WorkSet.AddsParam(wpt_string, aParams[0]);
         end;
      CMD_ADDMOP:
         begin
            WorkSet.Priority := wsp_tera;
            WorkSet.AddsParam(wpt_string, aParams[1]);
            WorkSet.AddiParam(wpt_integer, _StrToInt(aParams[2]));
            WorkSet.AddiParam(wpt_integer, _StrToInt(aParams[3]));
            WorkSet.AddiParam(wpt_integer, _StrToInt(aParams[4]));
            WorkSet.AddiParam(wpt_integer, _StrToInt(aParams[5]));
            WorkSet.AddsParam(wpt_string, aParams[6]);
         end;
   else
      begin
         WorkSet.Free;
         exit;
      end;
   end;

   FWorkBox.Push(WorkSet);
end;

procedure TBasicObject.PutResult(aSender: TBasicObject; aStr: string);
begin
   if SOnGetResult <> 0 then
   begin
      try
         ScriptManager.CallEvent(Self, aSender, SOnGetResult, 'OnGetResult',
            [aStr]);
      except
         frmMain.WriteLogInfo(format('basicobject putresult - %s (ongetresult:%d)', [aStr, SOnGetResult]));
         frmMain.WriteDumpInfo(@Self.BasicData, SizeOf(TBasicData));
         frmMain.WriteDumpInfo(@aSender.BasicData, SizeOf(TBasicData));
      end;
   end;
end;

procedure TBasicObject.WorkOver;
begin
   FWorkBox.WorkOver;
end;

procedure TBasicObject.SetManualMode;
begin
   FWorkBox.AutoMode := wcm_manual;
end;

function TBasicObject.isAutoMode: Boolean;
begin
   Result := false;
   if FWorkBox.AutoMode = wcm_auto then
      Result := true;
end;

function TBasicObject.isWorkOver: Boolean;
begin
   Result := true;
   if FWorkBox.WorkState = ws_ing then
      Result := false;
end;

function TBasicObject.isWalking: Boolean;
begin
   Result := false;
   if (FWorkBox.WorkState <> ws_ing) then
      exit;
   if (FWorkBox.WorkSet = nil) then
      exit;
   if (FWorkBox.WorkSet.Cmd = cmd_gotoxy) then
      Result := true;
end;

////////////////////////////////////////////////////
// TBasicObjectList
////////////////////////////////////////////////////

constructor TBasicObjectList.Create(aName: string; aManager: TManager);
begin
   FName := aName;
   Manager := aManager;

   DataList := TList.Create;

   FProcessCount := 40;
   FProcessPos := 0;
end;

destructor TBasicObjectList.Destroy;
begin
   Clear;
   DataList.Free;

   inherited Destroy;
end;

procedure TBasicObjectList.Clear;
var
   i: Integer;
   BasicObject: TBasicObject;
begin
   for i := DataList.Count - 1 downto 0 do
   begin
      BasicObject := DataList.Items[i];
      BasicObject.EndProcess;
      BasicObject.Free;
   end;
   DataList.Clear;
end;

function TBasicObjectList.GetCount: Integer;
begin
   Result := DataList.Count;
end;

procedure TBasicObjectList.Update(CurTick: LongWord);
var
   i, iStartPos: Integer;
   BasicObject: TBasicObject;
begin
   if DataList.Count = 0 then
      exit;

   iStartPos := FProcessPos;

   FProcessCount := ((DataList.Count + 25) * 4) div 100;

   for i := 0 to FProcessCount - 1 do
   begin
      if DataList.Count = 0 then
         break;
      if FProcessPos >= DataList.Count then
         FProcessPos := 0;

      BasicObject := DataList.Items[FProcessPos];
      if BasicObject.boAllowDelete then
      begin
         BasicObject.EndProcess;
         BasicObject.Free;
         DataList.Delete(FProcessPos);
      end
      else
      begin
         try
            iGStartTick := timeGetTime;
            BasicObject.Update(CurTick);
            iGEndTick := timeGetTime;

            {
            if FDelayTickMax < iGEndTick - iGStartTick then begin
               FDelayTickMax := iGEndTick - iGStartTick;

               if Manager <> nil then begin
                  frmLog.AddLog (format ('[%s %s] DT : %d (%s-%s-%s)', [DateToStr (Now), TimeToStr (Now), FDelayTickMax, Manager.Title, FName, StrPas (@BasicObject.BasicData.Name)]));
               end else begin
                  frmLog.AddLog (format ('[%s %s] DT : %d (%s-%s)', [DateToStr (Now), TimeToStr (Now), FDelayTickMax, FName, StrPas (@BasicObject.BasicData.Name)]));
               end;
            end;
            }
            FDelayTickMax := iGEndTick - iGStartTick;
            if FDelayTickMax >= 5 then
            begin
               if Manager <> nil then
               begin
                  AddLog(format('[%s %s] DT : %d (%s-%s-%s %d:%d)',
                     [DateToStr(Now), TimeToStr(Now), FDelayTickMax, Manager.Title,
                     FName, StrPas(@BasicObject.BasicData.Name),
                     BasicObject.BasicData.X, BasicObject.BasicData.Y]));
               end
               else
               begin
                  AddLog(format('[%s %s] DT : %d (%s-%s %d:%d)',
                     [DateToStr(Now), TimeToStr(Now), FDelayTickMax, FName,
                     StrPas(@BasicObject.BasicData.Name), BasicObject.BasicData.X,
                     BasicObject.BasicData.Y]));
               end;
            end;
         except
            BasicObject.FboAllowDelete := true;
            frmMain.WriteLogInfo(format('TBasicObjectList.Update Failed (%s)',
               [StrPas(@BasicObject.BasicData.Name)]));
         end;
      end;

      Inc(FProcessPos);
      if FProcessPos >= DataList.Count then
         FProcessPos := 0;
      if FProcessPos = iStartPos then
         break;
   end;
end;

////////////////////////////////////////////////////
//
//             ===  ItemObject  ===
//
////////////////////////////////////////////////////

constructor TItemObject.Create;
begin
   inherited Create;
   boAllowPickup := true;
end;

destructor TItemObject.Destroy;
begin
   inherited destroy;
end;

function TItemObject.FieldProc(hfu: Longint; Msg: word; var SenderInfo:
   TBasicData; var aSubData: TSubData): Integer;
var
   SubData: TSubData;
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
            if aSubData.ItemData.rCount <> 1 then
               exit;
            if SelfItemData.rKind = ITEM_KIND_COLORDRUG then
               exit;
            if SelfItemData.rKind = ITEM_KIND_CHANGER then
               exit;

            if aSubData.ItemData.rKind = ITEM_KIND_COLORDRUG then
            begin
               if SelfItemData.rboColoring = FALSE then
               begin
                  Result := PROC_FALSE;
                  exit;
               end;
               if INI_WHITEDRUG <> StrPas(@aSubData.ItemData.rName) then
               begin
                  SelfItemData.rColor := aSubData.ItemData.rColor;
                  BasicData.Feature.rImageColorIndex :=
                     aSubData.ItemData.rColor;
                  Phone.SendMessage(NOTARGETPHONE, FM_CHANGEFEATURE, BasicData,
                     SubData);
               end
               else
               begin
                  SelfItemdata.rColor := SelfItemdata.rColor +
                     aSubData.ItemData.rColor;
                  BasicData.Feature.rImageColorIndex := SelfItemdata.rColor;
                  Phone.SendMessage(NOTARGETPHONE, FM_CHANGEFEATURE, BasicData,
                     SubData);
               end;
               Result := PROC_TRUE;
               exit;
            end;
            {   // 厘固呕祸 顶俊辑 窍瘤臼澜
            if (NATION_VERSION = NATION_CHINA_1) or (NATION_VERSION = NATION_CHINA_1_TEST) then begin
            end else begin
               if aSubData.ItemData.rKind = ITEM_KIND_CHANGER then begin
                  if StrPas (@BasicData.Name) <> aSubData.ItemData.rNameParam [0] then exit;
                  FboAllowDelete := true;

                  ItemClass.GetItemData (aSubData.ItemData.rNameParam [1], SubData.ItemData);
                  if SubData.ItemData.rName [0] <> 0 then begin
                     BasicData.nX := BasicData.X;
                     BasicData.nY := BasicData.Y;
                     SubData.ServerId := Manager.ServerId;
                     Phone.SendMessage (MANAGERPHONE, FM_ADDITEM, BasicData, SubData);
                     Result := PROC_TRUE;
                  end;
                  exit;
               end;
            end;
            }
         end;
      FM_PICKUP:
         begin
            if FboAllowDelete then
               exit;

            if (NATION_VERSION = NATION_TAIWAN) or (NATION_VERSION =
               NATION_CHINA_1) or
               (NATION_VERSION = NATION_TAIWAN_TEST) or (NATION_VERSION =
                  NATION_CHINA_1_TEST) then
            begin
               if (FAllowPickupID = 0) or (FAllowPickupID = SenderInfo.ID) then
               begin
                  SubData.ItemData := SelfItemData;
                  SubData.ServerId := ServerId;
                  SubData.TargetID := 0;
                  if Phone.SendMessage(SenderInfo.ID, FM_ADDITEM, BasicData,
                     SubData) = PROC_TRUE then
                  begin
                     FboAllowDelete := TRUE;
                  end;
               end
               else
               begin
                  SetWordString(SubData.SayString,
                     Conv('无法拾取物品'));
                  SendLocalMessage(SenderInfo.ID, FM_SAYSYSTEM, BasicData,
                     SubData);
               end;
            end
            else
            begin
               SubData.ItemData := SelfItemData;
               SubData.ServerId := ServerId;
               if Phone.SendMessage(SenderInfo.id, FM_ADDITEM, BasicData,
                  SubData) = PROC_TRUE then
               begin
                  FboAllowDelete := TRUE;
               end;
            end;
         end;
      FM_SAY:
         begin
         end;
   end;
end;

//procedure TItemObject.Initial (aItemData: TItemData; aOwnerId, ax, ay: integer);

procedure TItemObject.Initial(aItemData: TItemData; aOwnerID, aPickupID, ax, ay:
   integer);
var
   iName, iViewName: string;
begin
   iName := StrPas(@aItemData.rName);

   if aItemData.rCount > 1 then
      iName := iName + ':' + IntToStr(aItemData.rCount);
   iViewName := StrPas(@aItemData.rViewName);
   if aItemData.rCount > 1 then
      iViewName := iViewName + ':' + IntToStr(aItemData.rCount);

   inherited Initial(iName, iViewName);

   OwnerId := aOwnerId;
   FAllowPickupID := aPickupID;

   SelfItemdata := aItemData;
   BasicData.id := GetNewItemId;
   BasicData.x := ax;
   BasicData.y := ay;
   BasicData.ClassKind := CLASS_ITEM;
   BasicData.Feature.rrace := RACE_ITEM;
   BasicData.Feature.rImageNumber := aItemData.rShape;
   BasicData.Feature.rImageColorIndex := aItemData.rcolor;

   {
   boAllowPickup := true;
   if not Maper.isMoveable (ax, ay) then begin
      boAllowPickup := false;
   end;
   }
end;

procedure TItemObject.StartProcess;
var
   SubData: TSubData;
begin
   inherited StartProcess;

   SubData.EffectNumber := FShowEffectNumber;
   SubData.EffectKind := FShowEffectKind;
   Phone.RegisterUser(BasicData.id, FieldProc, BasicData.X, BasicData.Y);
   Phone.SendMessage(0, FM_CREATE, BasicData, SubData);

   if SelfItemData.rSoundDrop.rWavNumber <> 0 then
   begin
      SetWordString(SubData.SayString,
         IntToStr(SelfItemData.rSoundDrop.rWavNumber) + '.wav');
      SendLocalMessage(NOTARGETPHONE, FM_SOUND, BasicData, SubData);
   end;
end;

procedure TItemObject.EndProcess;
var
   SubData: TSubData;
begin
   if FboRegisted = FALSE then
      exit;

   SubData.EffectNumber := FHideEffectNumber;
   SubData.EffectKind := FHideEffectKind;
   Phone.SendMessage(0, FM_DESTROY, BasicData, SubData);
   Phone.UnRegisterUser(BasicData.id, BasicData.x, BasicData.y);
   inherited EndProcess;
end;

procedure TItemObject.Update(CurTick: integer);
begin
   if CurTick >= CreateTick + 500 then
      FAllowPickupID := 0;
   if CreateTick + 3 * 60 * 100 < CurTick then
      FboAllowDelete := TRUE;
   {
   if CurTick >= FAlarmTick + 300 then begin
      SendLocalMessage (NOTARGETPHONE, FM_IAMHERE, BasicData, SubData);
   end;
   }

   {
   if boAllowPickup = false then begin
      if CreateTick + 5*100 < CurTick then begin
         boAllowPickup := true;
      end;
   end;
   }
end;

////////////////////////////////////////////////////
//
//             ===  ItemList  ===
//
////////////////////////////////////////////////////

constructor TItemList.Create(aManager: TManager);
begin
   inherited Create('ITEM', aManager);
end;

destructor TItemList.Destroy;
begin
   Clear;
   inherited Destroy;
end;

procedure TItemList.AddItemObject(var aSubData: TSubData; aOwnerId, aPickupID,
   ax, ay: integer);
var
   ItemObject: TItemObject;
begin
   if DataList.Count > 3000 then
      exit;

   ItemObject := TItemObject.Create;

   ItemObject.SetManagerClass(Manager);

   ItemObject.Initial(aSubData.ItemData, aOwnerId, aPickupID, ax, ay);
   ItemObject.SetShowEffect(aSubData.EffectNumber, aSubData.EffectKind);
   ItemObject.StartProcess;

   DataList.Add(ItemObject);
end;

procedure TItemList.AddItemSpecial(aName: string; aX, aY, aW, aCount: Integer);
var
   i, x, y, nCount: Integer;
   ItemObject: TItemObject;
   SubData: TSubData;
begin
   nCount := 0;
   for i := 0 to DataList.Count - 1 do
   begin
      ItemObject := DataList.Items[i];
      if StrPas(@ItemObject.BasicData.Name) = aName then
         Inc(nCount);
   end;

   ItemClass.GetItemData(aName, SubData.ItemData);
   for i := nCount to aCount do
   begin
      x := aX - aW + Random(aW * 2);
      y := aY - aW + Random(aW * 2);
      AddItemObject(SubData, 0, 0, x, y);
   end;
end;

////////////////////////////////////////////////////
//
//             ===  TZoneEffectObject  ===
//
////////////////////////////////////////////////////

constructor TZoneEffectObject.Create;
begin
   inherited Create;

   FillChar(SelfData, SizeOf(TCreateZoneEffectData), 0);
end;

destructor TZoneEffectObject.Destroy;
begin
   inherited Destroy;
end;

procedure TZoneEffectObject.Initial;
begin
   inherited Initial(SelfData.Name, SelfData.Name);

   BasicData.id := GetNewItemId;
   BasicData.x := SelfData.X;
   BasicData.y := SelfData.Y;
   BasicData.ClassKind := CLASS_SERVEROBJ;
   BasicData.Feature.rrace := RACE_ITEM;
   BasicData.Feature.rImageNumber := 0;
   BasicData.Feature.rImageColorIndex := 0;
end;

procedure TZoneEffectObject.StartProcess;
var
   SubData: TSubData;
begin
   inherited StartProcess;

   SubData.EffectNumber := 0;
   SubData.EffectKind := lek_none;
   Phone.RegisterUser(BasicData.id, FieldProc, BasicData.X, BasicData.Y);
   Phone.SendMessage(0, FM_CREATE, BasicData, SubData);
end;

procedure TZoneEffectObject.EndProcess;
var
   SubData: TSubData;
begin
   Phone.SendMessage(0, FM_DESTROY, BasicData, SubData);
   Phone.UnRegisterUser(BasicData.id, BasicData.x, BasicData.y);

   inherited EndProcess;
end;

function TZoneEffectObject.FieldProc(hfu: Longint; Msg: word; var SenderInfo:
   TBasicData; var aSubData: TSubData): Integer;
begin
   Result := PROC_FALSE;

   if isRangeMessage(hfu, Msg, SenderInfo) = FALSE then
      exit;
   Result := inherited FieldProc(hfu, Msg, Senderinfo, aSubData);
   if Result = PROC_TRUE then
      exit;
end;

procedure TZoneEffectObject.Update(CurTick: Integer);
begin
end;

procedure TZoneEffectObject.SendFMMessage;
var
   SubData: TSubData;
begin
   if SelfData.Kind = BTEFFECT_KIND_DECLIFE then
   begin
      SubData.SpellType := BTEFFECT_KIND_DECLIFE; // type
      SubData.ShoutColor := SelfData.Width; // 馆版伎
      SubData.SpellDamage := SelfData.Value; // 劝仿 别捞绰剧

      Phone.SendMessage(NOTARGETPHONE, FM_ZONEEFFECT, BasicData, SubData);
   end;
end;

function TZoneEffectObject.GetSelfData: PTCreateZoneEffectData;
begin
   Result := @SelfData;
end;

////////////////////////////////////////////////////
//
//             ===  TZoneEffectList  ===
//
////////////////////////////////////////////////////

constructor TZoneEffectList.Create;
begin
   inherited Create('ZONEEFFECT', nil);

   LoadFromFile('.\Setting\CreateZoneEffect.SDB');
end;

destructor TZoneEffectList.Destroy;
begin
   Clear;

   inherited Destroy;
end;

procedure TZoneEffectList.LoadFromFile(aFileName: string);
var
   i: Integer;
   DB: TUserStringDB;
   iName: string;
   pd: PTCreateZoneEffectData;
   ZEObject: TZoneEffectObject;
   Manager: TManager;
begin
   DB := TUserStringDB.Create;
   DB.LoadFromFile(aFileName);

   for i := 0 to DB.Count - 1 do
   begin
      iName := DB.GetIndexName(i);

      ZEObject := TZoneEffectObject.Create;
      pd := ZEObject.GetSelfData;

      pd^.Name := DB.GetFieldValueString(iName, 'Name');
      pd^.MapID := DB.GetFieldValueInteger(iName, 'MapID');
      pd^.X := DB.GetFieldValueInteger(iName, 'X');
      pd^.Y := DB.GetFieldValueInteger(iName, 'Y');
      pd^.Width := DB.GetFieldValueInteger(iName, 'Width');
      pd^.Kind := DB.GetFieldValueInteger(iName, 'Kind');
      pd^.Value := DB.GetFieldValueInteger(iName, 'Value');

      Manager := ManagerList.GetManagerByServerID(pd^.MapID);
      if Manager <> nil then
      begin
         ZEObject.SetManagerClass(Manager);
         ZEObject.Initial;
         ZEObject.StartProcess;
         DataList.Add(ZEObject);
      end
      else
      begin
         ZEObject.Free;
      end;
   end;

   DB.Free;
end;

function TZoneEffectList.SendMsgZoneEffectObject(aName: string): Boolean;
var
   i: integer;
   ZEObject: TZoneEffectObject;
begin
   Result := false;

   for i := 0 to DataList.Count - 1 do
   begin
      ZEObject := DataList.Items[i];
      if ZEObject.SelfData.Name = aName then
      begin
         ZEObject.SendFMMessage;
         Result := true;
      end;
   end;
end;

////////////////////////////////////////////////////
//
//             ===  GateObject  ===
//
////////////////////////////////////////////////////

// OpenTime 中 0 是有效的午夜场次，未使用的位置必须与它区分。
const
   UNUSED_GATE_HOUR = 255;
   GATE_TICKS_PER_DAY = 24 * 60 * 60 * 100;
   SPECIAL_GATE_OPEN_MSECS = 10 * 60 * 1000;

procedure LoadGateOpenHours(const Text: string; var Data: TCreateGateData);
var
   i, Hour: Integer;
   Rest, Token: string;
begin
   FillChar(Data.OpenTime, SizeOf(Data.OpenTime), UNUSED_GATE_HOUR);
   Rest := Text;
   for i := Low(Data.OpenTime) to High(Data.OpenTime) do
   begin
      if Rest = '' then
         break;
      Rest := GetValidStr3(Rest, Token, ':');
      if TryStrToInt(Trim(Token), Hour) and (Hour >= 0) and (Hour <= 23) then
         Data.OpenTime[i] := Hour;
   end;
end;

function IsHourlyGateOpen(const Data: TCreateGateData;
   Clock: TDateTime): Boolean;
var
   i, Elapsed, CurrentTick: Integer;
   Stamp: TTimeStamp;
begin
   Result := false;
   if Data.ActiveInterval <= 0 then
      exit;
   Stamp := DateTimeToTimeStamp(Clock);
   CurrentTick := Stamp.Time div 10;
   for i := Low(Data.OpenTime) to High(Data.OpenTime) do
      if Data.OpenTime[i] <= 23 then
      begin
         Elapsed := (CurrentTick - Data.OpenTime[i] * 60 * 60 * 100 +
            GATE_TICKS_PER_DAY) mod GATE_TICKS_PER_DAY;
         if Elapsed < Data.ActiveInterval then
         begin
            Result := true;
            exit;
         end;
      end;
end;

function GateClockMilliseconds(Clock: TDateTime): Int64;
var
   Stamp: TTimeStamp;
begin
   Stamp := DateTimeToTimeStamp(Clock);
   Result := Int64(Stamp.Date) * MSecsPerDay + Stamp.Time;
end;

function IsDatedGateOpen(const Data: TCreateGateData;
   Clock: TDateTime): Boolean;
var
   i: Integer;
   Elapsed, CurrentTime: Int64;
begin
   Result := false;
   CurrentTime := GateClockMilliseconds(Clock);
   for i := Low(Data.OpenClock) to High(Data.OpenClock) do
      if Data.OpenClock[i] <> 0 then
      begin
         Elapsed := CurrentTime - GateClockMilliseconds(Data.OpenClock[i]);
         if (Elapsed >= 0) and (Elapsed < SPECIAL_GATE_OPEN_MSECS) then
         begin
            Result := true;
            exit;
         end;
      end;
end;

constructor TGateObject.Create;
var
   mSec: Word;
begin
   inherited Create;

   boActive := false;
   RegenedTick := mmAnsTick;
   CheckTick := mmAnsTick;
   BattleTick := 0;

   ArrivalCount := 0;
   LimitCount := 0;
   MaxUser := 0;

   FillChar(SelfData, SizeOf(TCreateGateData), 0);
   FillChar(SelfData.OpenTime, SizeOf(SelfData.OpenTime), UNUSED_GATE_HOUR);

   DecodeTime(Time, CurHour, CurMin, CurSec, mSec);
end;

destructor TGateObject.Destroy;
begin
   inherited destroy;
end;

function TGateObject.GetSelfData: PTCreateGateData;
begin
   Result := @SelfData;
end;

function TGateObject.FieldProc(hfu: Longint; Msg: word; var SenderInfo:
   TBasicData; var aSubData: TSubData): Integer;
var
   i, nCount: Integer;
   SubData: TSubData;
   ItemData: TItemData;
   pUser: TUser;
   boFlag: Boolean;
   BO: TBasicObject;
   RetStr, PowerLevelName: string;
   tmpManager, tmpManager2: TManager;
   CurMagic: PTMagicData;
   str: string;
   gapTick: Integer;
   boRet: Boolean;
   tmpBattleMap: TBattleMap;
   TeamName: string;
begin
   Result := PROC_FALSE;
   if isRangeMessage(hfu, Msg, SenderInfo) = FALSE then
      exit;
   Result := inherited FieldProc(hfu, Msg, Senderinfo, aSubData);
   if Result = PROC_TRUE then
      exit;

   case Msg of
      FM_SHOW:
         begin
            if (SelfData.Kind = GATE_KIND_NORMAL) and (BasicData.nx = 0) and
               (BasicData.ny = 0) then
               exit;

            if CheckInArea(SenderInfo.x, SenderInfo.y, BasicData.x, BasicData.y,
               SelfData.Width) then
            begin
               BO := TBasicObject(SenderInfo.P);
               if BO = nil then
                  exit;
               if not (BO is TUser) then
                  exit;
               pUser := TUser(BO);

               if (SelfData.EjectX > 0) and (SelfData.EjectY > 0) then
               begin
                  pUser.SetPosition(SelfData.EjectX, SelfData.EjectY);
               end;
            end;
         end;
      FM_MOVE:
         begin
            if (SelfData.Kind = GATE_KIND_NORMAL) and (BasicData.nx = 0) and
               (BasicData.ny = 0) then
               exit;

            if CheckInArea(SenderInfo.nx, SenderInfo.ny, BasicData.x,
               BasicData.y, SelfData.Width) then
            begin
               BO := TBasicObject(SenderInfo.P);
               if BO = nil then
                  exit;
               if not (BO is TUser) then
                  exit;
               pUser := TUser(BO);

               if pUser.MovingStatus = true then
               begin
                  exit;
               end;

               if SOnMove <> 0 then
               begin
                  RetStr := ScriptManager.CallEvent(Self, pUser, SOnMove,
                     'OnMove', ['']);
                  if RetStr = 'false' then
                  begin
                     pUser.SetPosition(SelfData.EjectX, SelfData.EjectY);
                     pUser.SendClass.SendChatMessage(Conv('无法进入'),
                        SAY_COLOR_SYSTEM);
                     exit;
                  end;
               end;

               if SelfData.MaxUser <> 0 then
               begin
                  if MaxUser = SelfData.MaxUser then
                  begin
                     pUser.SetPosition(SelfData.EjectX, SelfData.EjectY);
                     pUser.SendClass.SendChatMessage(Conv('参赛人员已满'), SAY_COLOR_SYSTEM);
                     exit;
                  end;
               end;

               if SelfData.GuildName <> '' then
               begin
                  if pUser.GuildName <> SelfData.GuildName then
                  begin
                     pUser.SetPosition(SelfData.EjectX, SelfData.EjectY);
                     pUser.SendClass.SendChatMessage(Conv('无法进入'),
                        SAY_COLOR_SYSTEM);
                     exit;
                  end;
               end;

               tmpManager :=
                  ManagerList.GetManagerByServerID(SelfData.targetserverid);
               if LimitCount >= 10 then
               begin // 捞亥锭概 10疙栏肺 弊成 老窜 力茄 031224
                  pUser.SetPosition(SelfData.EjectX, SelfData.EjectY);
                  pUser.SendClass.SendChatMessage(Conv('歹捞惑 甸绢哎 荐 绝嚼聪促'), SAY_COLOR_SYSTEM);
                  exit;
               end;
  // add by Orber at 2005-04-01 18:03:36
               if tmpManager = nil then
               begin // 捞亥锭概 10疙栏肺 弊成 老窜 力茄 031224
                  pUser.SetPosition(SelfData.EjectX, SelfData.EjectY);
                  pUser.SendClass.SendChatMessage(Conv('尚未开放'), SAY_COLOR_SYSTEM);
                  exit;
               end;

               if tmpManager.boUsePowerItem = false then
               begin
                  nCount := pUser.SCheckPowerWearItem;
                  if nCount <> 0 then
                  begin
                     pUser.SetPosition(SelfData.EjectX, SelfData.EjectY);
                     pUser.SendClass.SendChatMessage(Conv('不能使用技能物品'), SAY_COLOR_SYSTEM);
                     exit;
                  end;
               end;
               if tmpManager.boUseMagic = false then
               begin
                  CurMagic := pUser.GetCurAttackMagic;
                  if CurMagic <> nil then
                  begin
                     if CurMagic^.rMagicClass = MAGICCLASS_MAGIC then
                     begin
                        pUser.SetPosition(SelfData.EjectX, SelfData.EjectY);
                        pUser.SendClass.SendChatMessage(Conv('使用一级武功无法进入'), SAY_COLOR_SYSTEM);
                        exit;
                     end;
                  end;
                  CurMagic := pUser.GetCurProtectingMagic;
                  if CurMagic <> nil then
                  begin
                     if CurMagic^.rMagicClass = MAGICCLASS_MAGIC then
                     begin
                        pUser.SetPosition(SelfData.EjectX, SelfData.EjectY);
                        pUser.SendClass.SendChatMessage(Conv('使用一级武功无法进入'), SAY_COLOR_SYSTEM);
                        exit;
                     end;
                  end;
               end;
               if tmpManager.boUseBestSpecialMagic = false then
               begin
                  CurMagic := pUser.GetCurSpecialMagic;
                  if CurMagic <> nil then
                  begin
                     pUser.SetPosition(SelfData.EjectX, SelfData.EjectY);
                     pUser.SendClass.SendChatMessage(Conv('使用招式无法进入'), SAY_COLOR_SYSTEM);
                     exit;
                  end;
               end;
               if tmpManager.boUseBestMagic = false then
               begin
                  CurMagic := pUser.GetCurAttackMagic;
                  if CurMagic <> nil then
                  begin
                     if CurMagic^.rMagicClass = MAGICCLASS_BESTMAGIC then
                     begin
                        pUser.SetPosition(SelfData.EjectX, SelfData.EjectY);
                        pUser.SendClass.SendChatMessage(Conv('使用绝世武功无法进入'), SAY_COLOR_SYSTEM);
                        exit;
                     end;
                  end;
                  CurMagic := pUser.GetCurProtectingMagic;
                  if CurMagic <> nil then
                  begin
                     if CurMagic^.rMagicClass = MAGICCLASS_BESTMAGIC then
                     begin
                        pUser.SetPosition(SelfData.EjectX, SelfData.EjectY);
                        pUser.SendClass.SendChatMessage(Conv('使用功力无法进入'), SAY_COLOR_SYSTEM);
                        exit;
                     end;
                  end;
               end;
               if tmpManager.boUseRiseMagic = false then
               begin
                  CurMagic := pUser.GetCurAttackMagic;
                  if CurMagic <> nil then
                  begin
                     if CurMagic^.rMagicClass = MAGICCLASS_RISEMAGIC then
                     begin
                        pUser.SetPosition(SelfData.EjectX, SelfData.EjectY);
                        pUser.SendClass.SendChatMessage(Conv('开着上层武功进入不了'), SAY_COLOR_SYSTEM);
                        exit;
                     end;
                  end;
                  CurMagic := pUser.GetCurProtectingMagic;
                  if CurMagic <> nil then
                  begin
                     if CurMagic^.rMagicClass = MAGICCLASS_RISEMAGIC then
                     begin
                        pUser.SetPosition(SelfData.EjectX, SelfData.EjectY);
                        pUser.SendClass.SendChatMessage(Conv('开着上层武功进入不了'), SAY_COLOR_SYSTEM);
                        exit;
                     end;
                  end;
               end;
               if tmpManager.boUseBowMagic = false then
               begin
                  CurMagic := pUser.GetCurAttackMagic;
                  if CurMagic <> nil then
                  begin
                     if (CurMagic^.rMagictype = MAGICTYPE_BOWING) or
                        (CurMagic^.rMagictype = MAGICTYPE_THROWING) then
                     begin
                        pUser.SetPosition(SelfData.EjectX, SelfData.EjectY);
                        pUser.SendClass.SendChatMessage(Conv('无法进入'), SAY_COLOR_SYSTEM);
                        exit;
                     end;
                  end;
               end;
               if tmpManager.boUseWindMagic = false then
               begin
                  CurMagic := pUser.GetCurAttackMagic;
                  if CurMagic <> nil then
                  begin
                     if CurMagic^.rMagicClass = MAGICCLASS_MYSTERY then
                     begin
                        pUser.SetPosition(SelfData.EjectX, SelfData.EjectY);
                        pUser.SendClass.SendChatMessage(Conv('开着掌法无法进入'), SAY_COLOR_SYSTEM);
                        exit;
                     end;
                  end;
               end;
               if tmpManager.boUseEtcMagic = false then
               begin
                  CurMagic := pUser.GetCurEctMagic;
                  if CurMagic <> nil then
                  begin
                     if CurMagic^.rMagicType = MAGICTYPE_ECT then
                     begin
                        pUser.SetPosition(SelfData.EjectX, SelfData.EjectY);
                        pUser.SendClass.SendChatMessage(Conv('开辅助武功无法进入'), SAY_COLOR_SYSTEM);
                        exit;
                     end;
                  end;
               end;

               boFlag := true;
               if boFlag = true then
               begin
                  if SelfData.BelowEnergy <> 0 then
                  begin
                     if SelfData.BelowEnergy <= pUser.SGetPower then
                     begin
                        pUser.SetPosition(SelfData.EjectX, SelfData.EjectY);
                        pUser.SendClass.SendChatMessage(Conv('元气过高无法进入'), SAY_COLOR_SYSTEM);
                        exit;
                     end;
                  end;
               end;

               if boFlag = true then
               begin
                  if SelfData.OverEnergy <> 0 then
                  begin
                     if SelfData.OverEnergy > pUser.SGetPower then
                     begin
                        pUser.SetPosition(SelfData.EjectX, SelfData.EjectY);
                        pUser.SendClass.SendChatMessage(Conv('元气太低无法进入'), SAY_COLOR_SYSTEM);
                        exit;
                     end;
                  end;
               end;

               if boActive = false then
               begin
                  pUser.SetPosition(SelfData.EjectX, SelfData.EjectY);
                  case SelfData.Kind of
                     GATE_KIND_NORMAL, GATE_KIND_LIMITUSER:
                        pUser.SendClass.SendChatMessage(format(Conv('现在无法进入， %d分%d秒后才会开启'), [RemainHour * 60 + RemainMin, RemainSec]), SAY_COLOR_SYSTEM);
                     GATE_KIND_SPECIALTIME:
                        begin
                           str := GetOpenTime;
                           pUser.SendClass.SendChatMessage(str,
                              SAY_COLOR_SYSTEM);
                        end;
                     GATe_KIND_BS:
                        pUser.SendClass.SendChatMessage(Conv('现在无法进入'), SAY_COLOR_SYSTEM);
                     GATE_KIND_FIXPOSITION, GATE_KIND_FIXTIME , GATE_KIND_SPORTSWAR:
                        pUser.SendClass.SendChatMessage(Conv('现在不能入场'), SAY_COLOR_SYSTEM);
                  end;
                  exit;
               end;
               if SelfData.Kind = GATE_KIND_FIXPOSITION then
               begin
                  if Manager.boEnter = false then
                  begin
                     pUser.SetPosition(SelfData.EjectX, SelfData.EjectY);
                     pUser.SendClass.SendChatMessage(Conv('现在不能入场'), SAY_COLOR_SYSTEM);
                     exit;
                  end;
               end;

               if SelfData.NeedAge > 0 then
               begin
                  if SelfData.NeedAge <= pUser.GetAge then
                  begin
                  end
                  else
                  begin
                     if SelfData.AgeNeedItem > 0 then
                     begin
                        if SelfData.AgeNeedItem <= pUser.GetAge then
                        begin
                           for i := 0 to 5 - 1 do
                           begin
                              if SelfData.NeedItem[i].rName[0] = 0 then
                                 break;
                              ItemClass.GetItemData(StrPas(@SelfData.NeedItem[i].rName), ItemData);
                              if ItemData.rName[0] <> 0 then
                              begin
                                 if SelfData.NeedItem[i].rCount > 0 then
                                 begin
                                    ItemData.rCount :=
                                       SelfData.NeedItem[i].rCount;
                                 end
                                 else
                                 begin
                                    ItemData.rCount := 1;
                                 end;
                                 boFlag := TUser(BO).FindItem(@ItemData);
                                 if boFlag = false then
                                    break;
                              end;
                           end;
                           if boFlag = true then
                           begin
                              if SelfData.boRemainItem = false then
                              begin
                                 for i := 0 to 5 - 1 do
                                 begin
                                    if SelfData.NeedItem[i].rName[0] = 0 then
                                       break;
                                    ItemClass.GetItemData(StrPas(@SelfData.NeedItem[i].rName), ItemData);
                                    if ItemData.rName[0] <> 0 then
                                    begin
                                       if SelfData.NeedItem[i].rCount > 0 then
                                       begin
                                          ItemData.rCount :=
                                             SelfData.NeedItem[i].rCount;
                                          TUser(BO).DeleteItem(@ItemData);
                                       end;
                                    end;
                                 end;
                              end;
                           end;
                        end
                        else
                        begin
                           boFlag := false;
                        end;
                     end
                     else
                     begin
                        boFlag := false;
                     end;
                  end;
               end;

               if boFlag = true then
               begin
                  if SelfData.LimitAge <> 0 then
                  begin
                     if SelfData.LimitAge < pUser.GetAge then
                     begin
                        pUser.SetPosition(SelfData.EjectX, SelfData.EjectY);
                        pUser.SendClass.SendChatMessage(Conv('无法进入'), SAY_COLOR_SYSTEM);
                        exit;
                     end;
                  end;
               end;
               if boFlag = true then
               begin
                  if SelfData.OverAge <> 0 then
                  begin
                     if SelfData.OverAge > pUser.GetAge then
                     begin
                        pUser.SetPosition(SelfData.EjectX, SelfData.EjectY);
                        pUser.SendClass.SendChatMessage(Conv('无法进入'), SAY_COLOR_SYSTEM);
                        exit;
                     end;
                  end;
               end;
               if boFlag = true then
               begin
                  if SelfData.LimitPowerLevel <> 0 then
                  begin
                     if pUser.CurPowerLevel > SelfData.LimitPowerLevel then
                     begin
                        pUser.ChangeCurPowerLevel(SelfData.LimitPowerLevel);
                     end;
                  end;
               end;

               if boFlag = true then
               begin
                  if SelfData.NeedAge = 0 then
                  begin
                     for i := 0 to 5 - 1 do
                     begin
                        if SelfData.NeedItem[i].rName[0] = 0 then
                           break;
                        ItemClass.GetItemData(StrPas(@SelfData.NeedItem[i].rName), ItemData);
                        if ItemData.rName[0] <> 0 then
                        begin
                           boRet :=
                              TUser(BO).FindItemByName(StrPas(@selfData.needItem[i].rName));
                           if boRet = false then
                           begin
                              pUser.SetPosition(SelfData.EjectX,
                                 SelfData.EjectY);
                              pUser.SendClass.SendChatMessage(format(Conv('需要%s'), [StrPas(@ItemData.rName)]), SAY_COLOR_SYSTEM);
                              exit;
                           end;
                        end
                        else
                        begin
                           break;
                        end;
                     end;
                  end;
               end;

               if boFlag = true then
               begin
                  for i := 0 to 5 - 1 do
                  begin
                     if SelfData.DelItem[i].rName[0] = 0 then
                        break;
                     ItemClass.GetItemData(StrPas(@SelfData.DelItem[i].rName),
                        ItemData);
                     if ItemData.rName[0] <> 0 then
                     begin
                        if SelfData.DelItem[i].rCount = 0 then
                        begin
                           TUser(BO).DeleteAllItembyName(StrPas(@SelfData.DelItem[i].rName));
                        end
                        else if SelfData.DelItem[i].rCount > 0 then
                        begin
                           ItemData.rCount := SelfData.DelItem[i].rCount;
                           TUser(BO).DeleteItem(@ItemData);
                        end;
                     end;
                  end;
               end;

               if boFlag = true then
               begin
                  if SelfData.Quest <> 0 then
                  begin
                     if QuestClass.CheckQuestComplete(SelfData.Quest, ServerID,
                        pUser, RetStr) = false then
                     begin
                        pUser.SetPosition(SelfData.EjectX, SelfData.EjectY);
                        pUser.SendClass.SendChatMessage(SelfData.QuestNotice,
                           SAY_COLOR_SYSTEM);
                        pUser.SendClass.SendChatMessage(RetStr,
                           SAY_COLOR_SYSTEM);
                        exit;
                     end;
                  end;
               end;

               if boFlag = true then
               begin
                  case SelfData.Kind of
                     GATE_KIND_NORMAL, GATE_KIND_ORDERADDITEM,
                        GATE_KIND_LIMITUSER:
                        begin
                           SubData.ServerId := SelfData.TargetServerId;
                           Phone.SendMessage(SenderInfo.id, FM_GATE, BasicData,
                              SubData);
                        end;
                     GATE_KIND_BS:
                        begin
                           pUser.SetPositionBS(SelfData.EjectX,
                              SelfData.EjectY);
                        end;
                     GATE_KIND_SPECIALTIME, GATE_KIND_FIXTIME :
                        begin
                           tmpManager2 := nil;
                           tmpManager2 :=
                              ManagerList.GetManagerByServerID(SelfData.targetserverid);
                           if tmpManager2 <> nil then
                           begin
                              if tmpManager2.UserCount = 0 then
                              begin
                                 tmpManager2.Regen;
                              end;
                           end;
                           SubData.ServerId := SelfData.targetserverid;
                           Phone.SendMessage(SenderInfo.id, FM_GATE, BasicData,
                              SubData);
                        end;
                     GATE_KIND_FIXPOSITION:
                        begin
                           if tmpManager.MapAttribute = MAP_TYPE_BATTLE then
                           begin
                              tmpBattleMap :=
                                 BattleMapList.DevideUser(SelfData.targetserverid);
                              if tmpBattleMap <> nil then
                              begin
                                 BasicData.nx := tmpBattleMap.PosX;
                                 BasicData.ny := tmpBattleMap.PosY;
                                 SubData.ServerId := SelfData.targetserverid;
                                 pUser.EventTeam := tmpBattleMap.DynName;
                                 pUser.SetActionState(as_ice);
                                 Phone.SendMessage(SenderInfo.id, FM_GATE,
                                    BasicData, SubData);
                                 pUser.SetGroupColor(tmpBattleMap.GroupKey);
                              end
                              else
                              begin
                                 if (SelfData.EjectX > 0) and (SelfData.EjectY >
                                    0) then
                                 begin
                                    pUser.SetPosition(SelfData.EjectX,
                                       SelfData.EjectY);
                                 end;
                                 pUser.SendClass.SendChatMessage(Conv('无法进入'), SAY_COLOR_SYSTEM);
                                 exit;
                              end;
                           end
                           else
                           begin
                              SubData.ServerId := SelfData.targetserverid;
                              Phone.SendMessage(SenderInfo.id, FM_GATE,
                                 BasicData, SubData);
                           end;
                        end;
                     GATE_KIND_INTOZHUANG:
                        begin
                           Str := Zhuang.GetZhuangInto(pUser);
                           if Str = 'fight' then
                           begin
                              if (SelfData.EjectX > 0) and (SelfData.EjectY > 0)
                                 then
                              begin
                                 pUser.SetPosition(SelfData.EjectX,
                                    SelfData.EjectY);
                              end;
                              pUser.SendClass.SendChatMessage(Conv('聚贤庄现为战争状态，请稍后进入'), SAY_COLOR_SYSTEM);
                              exit;
                           end;
                           if Str = 'noticket' then
                           begin
                              if (SelfData.EjectX > 0) and (SelfData.EjectY > 0)
                                 then
                              begin
                                 pUser.SetPosition(SelfData.EjectX,
                                    SelfData.EjectY);
                              end;
                              pUser.SendClass.SendChatMessage(Conv('请先向聚贤庄主购买门票才能进入'), SAY_COLOR_SYSTEM);
                              exit;
                           end;
                           if Str = 'ok' then
                           begin
                              SubData.ServerId := SelfData.targetserverid;
                              Phone.SendMessage(SenderInfo.id, FM_GATE,
                                 BasicData, SubData);
                           end;
                        end;
                     GATE_KIND_GUILDWAR:
                        begin
                           //                        if NameClass.SearchNameList (pUser.GuildName, pUser.Name) = true then begin
                           tmpBattleMap :=
                              BattleMapList.GetPositionbyGuildName(pUser.GuildName);
                           if tmpBattleMap <> nil then
                           begin
                              BasicData.nx := tmpBattleMap.PosX;
                              BasicData.ny := tmpBattleMap.PosY;
                              SubData.ServerId := SelfData.targetserverid;
                              pUser.SetActionState(as_ice);
                              Phone.SendMessage(SenderInfo.id, FM_GATE,
                                 BasicData, SubData);
                              pUser.SetGroupColor(tmpBattleMap.GroupKey);
                           end
                           else
                           begin
                              if (SelfData.EjectX > 0) and (SelfData.EjectY > 0)
                                 then
                              begin
                                 pUser.SetPosition(SelfData.EjectX,
                                    SelfData.EjectY);
                              end;
                              pUser.SendClass.SendChatMessage(Conv('无法进入'), SAY_COLOR_SYSTEM);
                              exit;
                           end;

                        end;
                     //Author:Steven Date: 2005-01-19 12:03:03
                     //Note:竞技场
                     GATE_KIND_SPORTSWAR:
                        begin
                           case
                              UserList.GetUserCountByManager(SelfData.targetserverid) mod 2
                              of
                              0: TeamName := Format('%s%d', [Conv('红方'),
                                 SelfData.targetserverid]);
                              1: TeamName := Format('%s%d', [Conv('蓝方'),
                                 SelfData.targetserverid]);
                           end;
                           pUser.BattleGuildName := TeamName;
                           tmpBattleMap :=
                              BattleMapList.GetPositionbyGuildName(TeamName);

                           if tmpBattleMap <> nil then
                           begin
                              BasicData.nx := tmpBattleMap.PosX; //出生点
                              BasicData.ny := tmpBattleMap.PosY;
                              SubData.ServerId := SelfData.targetserverid;
                                 //服务器地图ID
                              pUser.SetActionState(as_ice);
                              Phone.SendMessage(SenderInfo.id, FM_GATE,
                                 BasicData,
                                 SubData);
                              pUser.SetGroupColor(tmpBattleMap.GroupKey);
                              pUser.SetNameColor(tmpBattleMap.GroupKey);
                           end
                           else
                           begin
                              if (SelfData.EjectX > 0) and (SelfData.EjectY > 0)
                                 then
                              begin
                                 pUser.SetPosition(SelfData.EjectX,
                                    SelfData.EjectY);
                              end;
                              pUser.SendClass.SendChatMessage(Conv('无法进入'), SAY_COLOR_SYSTEM);
                              exit;
                           end;
                        end;
                     //=======================================================

 //                        end else begin
 //                           if (SelfData.EjectX > 0) and (SelfData.EjectY > 0) then begin
 //                              pUser.SetPosition (SelfData.EjectX, SelfData.EjectY);
 //                           end;
 //                           pUser.SendClass.SendChatMessage (Conv ('无法进入'), SAY_COLOR_SYSTEM);
 //                           exit;
 //                        end;

                  end;

                  if SelfData.Kind = GATE_KIND_LIMITUSER then
                  begin
                     inc(LimitCount);
                  end;

                  if SelfData.Kind = GATE_KIND_ORDERADDITEM then
                  begin
                     inc(ArrivalCount);
                     case ArrivalCount of
                        1:
                           begin
                              ItemClass.GetItemData(StrPas(@SelfData.AddItem[0].rName), ItemData);
                              ItemData.rCount := SelfData.AddItem[0].rCount;
                           end;
                        2:
                           begin
                              ItemClass.GetItemData(StrPas(@SelfData.AddItem[1].rName), ItemData);
                              ItemData.rCount := SelfData.AddItem[1].rCount;
                           end;
                     else
                        begin
                           ItemClass.GetItemData(StrPas(@SelfData.AddItem[2].rName), ItemData);
                           ItemData.rCount := SelfData.AddItem[2].rCount;
                        end;
                     end;
                     TUser(BO).AddItem(ItemData);
                  end
                  else
                  begin
                     for i := 0 to 5 - 1 do
                     begin
                        if SelfData.AddItem[i].rName[0] = 0 then
                           break;
                        ItemClass.GetItemData(StrPas(@SelfData.AddItem[i].rName), ItemData);
                        if ItemData.rName[0] <> 0 then
                        begin
                           if SelfData.AddItem[i].rCount = 0 then
                           begin
                              ItemData.rCount := 1;
                              TUser(BO).AddItem(ItemData);
                           end
                           else if SelfData.AddItem[i].rCount > 0 then
                           begin
                              ItemData.rCount := SelfData.AddItem[i].rCount;
                              TUser(BO).AddItem(ItemData);
                           end;
                        end;
                     end;
                  end;

                  if SelfData.MaxUser <> 0 then
                     inc(MaxUser); // 力茄牢盔阑 敌促.
                  // 人数满即开始
                  if (SelfData.MaxUser <> 0) and (SelfData.Kind = GATE_KIND_SPORTSWAR) and (SelfData.MaxUser = MaxUser) then begin
                      UserList.SetActionStateByServerID (SelfData.targetserverid, as_free);
                      TUser(BO).SetActionState(as_free);
                      TUser(BO).Manager.boEnter := false;
                      UserList.SendCenterMessage(Conv('竞技场开战, 大家变换步法,开始战斗吧!'));

                  end;
               end
               else
               begin
                  if (SelfData.EjectX > 0) and (SelfData.EjectY > 0) then
                  begin
                     pUser.SetPosition(SelfData.EjectX, SelfData.EjectY);
                  end;
                  if SelfData.EjectNotice = '' then
                  begin
                     pUser.SendClass.SendChatMessage(Conv('此处为限制出入的地方，无法进入。'), SAY_COLOR_SYSTEM);
                  end
                  else
                  begin
                     pUser.SendClass.SendChatMessage(SelfData.EjectNotice,
                        SAY_COLOR_SYSTEM);
                  end;
               end;
            end;
         end;
   end;
end;

procedure TGateObject.Initial;
var
   iNo: Integer;
begin
   inherited Initial(SelfData.Name, SelfData.ViewName);

   BasicData.id := GetNewItemId;

   if (SelfData.X <> 0) or (SelfData.Y <> 0) then
   begin
      BasicData.x := SelfData.x;
      BasicData.y := SelfData.y;
   end
   else
   begin
      iNo := Random(SelfData.RandomPosCount);
      BasicData.X := SelfData.RandomX[iNo];
      BasicData.Y := SelfData.RandomY[iNo];
   end;

   BasicData.nx := SelfData.targetx;
   BasicData.ny := SelfData.targety;
   BasicData.ClassKind := CLASS_GATE;
   BasicData.Feature.rrace := RACE_ITEM;
   BasicData.Feature.rImageNumber := SelfData.Shape;
   BasicData.Feature.rImageColorIndex := 0;

   case SelfData.Kind of
      GATE_KIND_SPECIALTIME:
         boActive := IsDatedGateOpen(SelfData, Now);
      GATE_KIND_FIXPOSITION, GATE_KIND_FIXTIME, GATE_KIND_SPORTSWAR:
         boActive := IsHourlyGateOpen(SelfData, Now);
   else
      begin
         boActive := true;
      end;
   end;

   RegenedTick := mmAnsTick;
end;

procedure TGateObject.StartProcess;
var
   SubData: TSubData;
begin
   inherited StartProcess;

   ArrivalCount := 0;
   LimitCount := 0;
   MaxUser := 0;

   SubData.EffectNumber := 0;
   SubData.EffectKind := lek_none;
   Phone.RegisterUser(BasicData.id, FieldProc, BasicData.X, BasicData.Y);
   Phone.SendMessage(0, FM_CREATE, BasicData, SubData);
end;

procedure TGateObject.EndProcess;
var
   SubData: TSubData;
begin
   Phone.SendMessage(0, FM_DESTROY, BasicData, SubData);
   Phone.UnRegisterUser(BasicData.id, BasicData.x, BasicData.y);

   inherited EndProcess;
end;

procedure TGateObject.Update(CurTick: Integer);
var
   i: integer;
   gaptime: integer;
   str: string;
   nHour, nMin, nSec, nMSec: Word;
   Clock: TDateTime;
   Remaining: Int64;
   tmpManager: TManager;
begin
   if (SelfData.RegenInterval > 0) and (RegenedTick + 100 <= CurTick) then
   begin
      Manager.CalcTime(RegenedTick + SelfData.RegenInterval - CurTick,
         RemainHour, RemainMin, RemainSec);
   end;

   case SelfData.Kind of
      GATE_KIND_FIXPOSITION, GATE_KIND_FIXTIME, GATE_KIND_SPORTSWAR:
         begin
            Clock := Now;
            DecodeTime(Clock, nHour, nMin, nSec, nMSec);
            if (CurHour <> nHour) or (CurMin <> nMin) then
               for i := Low(SelfData.OpenTime) to High(SelfData.OpenTime) do
               begin
                  if SelfData.OpenTime[i] > 23 then
                     continue;
                  // 距下一场的分钟数，午夜场次也从前一天开始预告。
                  gaptime := (SelfData.OpenTime[i] * 60 - nHour * 60 -
                     nMin + 24 * 60) mod (24 * 60);
                  if (SelfData.Kind = GATE_KIND_FIXPOSITION) and
                     (gaptime = 1) then
                  begin
                     tmpManager := ManagerList.GetManagerByServerID(
                        SelfData.targetserverid);
                     if (tmpManager <> nil) and (tmpManager.UserCount = 0) then
                     begin
                        tmpManager.Regen;
                        if BattleMapList.Position1 <> nil then
                           BattleMapList.Position1.JoinUserCount := 0;
                        if BattleMapList.Position2 <> nil then
                           BattleMapList.Position2.JoinUserCount := 0;
                     end;
                  end;
                  if gaptime = 0 then
                  begin
                     // 人数统计按场次重置，不依赖是否开启公告。
                     if SelfData.Kind in [GATE_KIND_FIXTIME, GATE_KIND_SPORTSWAR] then
                        MaxUser := 0;
                     if SelfData.boAlarmRemainTime then
                        UserList.SendNoticeMessage('<Event>: ' +
                           SelfData.ViewName + Conv('比赛开始'), SAY_COLOR_NOTICE);
                  end
                  else if (gaptime <= 10) and SelfData.boAlarmRemainTime then
                  begin
                     str := format(SelfData.AlarmNotice, [gaptime]);
                     UserList.SendNoticeMessage('<Event>: ' + str, SAY_COLOR_NOTICE);
                  end;
               end;

            boActive := IsHourlyGateOpen(SelfData, Clock);
            if boActive and (SelfData.Kind = GATE_KIND_FIXPOSITION) then
            begin
               tmpManager := ManagerList.GetManagerByServerID(SelfData.targetserverid);
               if tmpManager <> nil then
                  tmpManager.boBattleStart := true;
            end;
            CurHour := nHour;
            CurMin := nMin;
            CurSec := nSec;
         end;
      GATE_KIND_SPECIALTIME:
         begin
            Clock := Now;
            // 开关每轮更新；20 秒间隔只限制公告，不能延迟关门。
            boActive := IsDatedGateOpen(SelfData, Clock);
            if CheckTick + 2000 > CurTick then
               exit;
            CheckTick := CurTick;
            for i := Low(SelfData.OpenClock) to High(SelfData.OpenClock) do
            begin
               if SelfData.OpenClock[i] = 0 then
                  continue;
               Remaining := GateClockMilliseconds(SelfData.OpenClock[i]) -
                  GateClockMilliseconds(Clock);
               if (Remaining > 0) and (Remaining <= SPECIAL_GATE_OPEN_MSECS) and
                  SelfData.boAlarmRemainTime then
               begin
                  gaptime := (Remaining + 59999) div 60000;
                  str := format(SelfData.AlarmNotice, [gaptime]);
                  UserList.SendNoticeMessage('<Event>: ' + str, SAY_COLOR_NOTICE);
               end;
            end;
         end;
      GATE_KIND_NORMAL, GATE_KIND_BS, GATE_KIND_DOOR, GATE_KIND_LIMITUSER:
         begin
            if (SelfData.RegenInterval > 0) and (RegenedTick +
               SelfData.RegenInterval <= CurTick) then
            begin
               RegenedTick := CurTick;
               boActive := true;
            end
            else
            begin
               if (SelfData.X = 0) and (SelfData.Y = 0) then
               begin
                  if CurTick >= RegenedTick + SelfData.ActiveInterval then
                  begin
                     EndProcess;
                     Initial;
                     StartProcess;
                  end;
                  exit;
               end;
               if boActive = true then
               begin
                  if (SelfData.RegenInterval > 0) and (RegenedTick +
                     SelfData.ActiveInterval <= CurTick) then
                  begin
                     LimitCount := 0;
                     boActive := false;
                  end;
               end;
            end;
         end;
   end;

end;

function TGateObject.GetOpenTime: string;
var
   i: Integer;
   str, str2: string;
   CurrentTime, Remaining, Nearest: Int64;
   ahour, aminute, asecond: Int64;
begin
   CurrentTime := GateClockMilliseconds(Now);
   Nearest := 0;
   str := '';
   for i := Low(SelfData.OpenClock) to High(SelfData.OpenClock) do
      if SelfData.OpenClock[i] <> 0 then
      begin
         str := str + DateTimeToStr(SelfData.OpenClock[i]) + #13;
         Remaining := GateClockMilliseconds(SelfData.OpenClock[i]) - CurrentTime;
         if (Remaining > 0) and ((Nearest = 0) or (Remaining < Nearest)) then
            Nearest := Remaining;
      end;
   // 先取总秒数，再拆分时分秒，避免分别四舍五入造成负分钟。
   Nearest := (Nearest + 999) div 1000;
   ahour := Nearest div 3600;
   aminute := (Nearest div 60) mod 60;
   asecond := Nearest mod 60;

   if ahour > 0 then
   begin
      str2 := format(Conv('%d点%d分'), [ahour, aminute]) + Conv('还剩下')
         + #13;
   end
   else if ahour = 0 then
   begin
      if aminute >= 1 then
      begin
         str2 := format(Conv('%d分'), [aminute]) + Conv('还剩下') + #13;
      end
      else if aminute = 0 then
      begin
         str2 := format(Conv('%d秒'), [asecond]) + Conv('还剩下') + #13;
      end;
   end;

   str := str + str2;
   Result := Conv('open时间为') + #13 + str;
end;

////////////////////////////////////////////////////
//
//             ===  GateList  ===
//
////////////////////////////////////////////////////

constructor TGateList.Create;
begin
   inherited Create('GATE', nil);

   // add by minds 050902
   OwnGateGuildList := TStringList.Create;
   
   LoadFromFile('.\Setting\CreateGate.SDB');
end;

destructor TGateList.Destroy;
begin
   Clear;
   inherited Destroy;
end;

procedure TGateList.LoadFromFile(aFileName: string);
var
   i, j, xx, yy: integer;
   iName, srcstr, tokenstr, str, str2, str3: string;
   ItemData: TItemData;
   GateObject: TGateObject;
   pd: PTCreateGateData;
   DB: TUserStringDB;
   Manager: TManager;
begin
   if not FileExists(aFileName) then
      exit;

   DB := TUserStringDb.Create;
   DB.LoadFromFile(aFileName);

   for i := 0 to DB.Count - 1 do
   begin
      iName := DB.GetIndexName(i);

      GateObject := TGateObject.Create;
      pd := GateObject.GetSelfData;

      pd^.Name := DB.GetFieldValueString(iName, 'GateName');
      pd^.ViewName := DB.GetFieldValueString(iName, 'ViewName');
      pd^.boShow := Db.GetFieldValueBoolean(iName, 'boShow');
      pd^.Kind := DB.GetFieldValueInteger(iname, 'Kind');
      pd^.MapID := DB.GetFieldValueInteger(iname, 'MapID');
      pd^.x := DB.GetFieldValueInteger(iName, 'X');
      pd^.y := DB.GetFieldValueInteger(iName, 'Y');
      pd^.targetx := DB.GetFieldValueInteger(iName, 'TX');
      pd^.targety := DB.GetFieldValueInteger(iName, 'TY');
      pd^.ejectx := DB.GetFieldValueInteger(iName, 'EX');
      pd^.ejecty := DB.GetFieldValueInteger(iName, 'EY');
      pd^.targetserverid := DB.GetFieldValueInteger(iName, 'ServerId');

      if pd^.Kind = GATE_KIND_FIXPOSITION then
      begin
         if (pd^.TargetX = 0) and (pd^.TargetY = 0) then
         begin
            BattleMapList.SetBattleMapData(pd^.targetserverid);
         end
         else
         begin
         end;
      end;

      pd^.shape := DB.GetFieldValueInteger(iName, 'Shape');
      pd^.Width := DB.GetFieldValueInteger(iName, 'Width');
      pd^.LimitAge := DB.GetFieldValueInteger(iName, 'LimitAge');
      pd^.OverAge := DB.GetFieldValueInteger(iName, 'OverAge');
      pd^.LimitPowerLevel := DB.GetFieldValueInteger(iName, 'LimitPowerLevel');
      pd^.NeedAge := DB.GetFieldValueInteger(iName, 'NeedAge');
      pd^.BelowEnergy := DB.GetFieldValueInteger(iName, 'BelowEnergy');
      pd^.OverEnergy := DB.GetFieldValueInteger(iName, 'OverEnergy');
      pd^.AgeNeedItem := DB.GetFieldValueInteger(iName, 'AgeNeedItem');

      srcstr := DB.GetFieldValueString(iName, 'NeedItem');
      if srcstr <> '' then
      begin
         for j := 0 to 5 - 1 do
         begin
            srcstr := GetValidStr3(srcstr, tokenstr, ':');
            if tokenstr = '' then
               break;
            ItemClass.GetItemData(tokenstr, ItemData);
            if ItemData.rName[0] <> 0 then
            begin
               srcstr := GetValidStr3(srcstr, tokenstr, ':');
               ItemData.rCount := _StrToInt(tokenstr);
               StrCopy(@pd^.NeedItem[j].rName, @ItemData.rName);
               pd^.NeedItem[j].rCount := ItemData.rCount;
            end;
         end;
      end;
      srcstr := DB.GetFieldValueString(iName, 'DelItem');
      if srcstr <> '' then
      begin
         for j := 0 to 5 - 1 do
         begin
            srcstr := GetValidStr3(srcstr, tokenstr, ':');
            if tokenstr = '' then
               break;
            ItemClass.GetItemData(tokenstr, ItemData);
            if ItemData.rName[0] <> 0 then
            begin
               srcstr := GetValidStr3(srcstr, tokenstr, ':');
               ItemData.rCount := _StrToInt(tokenstr);
               StrCopy(@pd^.DelItem[j].rName, @ItemData.rName);
               pd^.DelItem[j].rCount := ItemData.rCount;
            end;
         end;
      end;

      srcstr := DB.GetFieldValueString(iName, 'AddItem');
      if srcstr <> '' then
      begin
         for j := 0 to 5 - 1 do
         begin
            srcstr := GetValidStr3(srcstr, tokenstr, ':');
            if tokenstr = '' then
               break;
            ItemClass.GetItemData(tokenstr, ItemData);
            if ItemData.rName[0] <> 0 then
            begin
               srcstr := GetValidStr3(srcstr, tokenstr, ':');
               ItemData.rCount := _StrToInt(tokenstr);
               StrCopy(@pd^.AddItem[j].rName, @ItemData.rName);
               pd^.AddItem[j].rCount := ItemData.rCount;
            end;
         end;
      end;

      pd^.boRemainItem := DB.GetFieldValueBoolean(iname, 'boRemainItem');
      pd^.Quest := DB.GetFieldValueInteger(iname, 'Quest');
      pd^.QuestNotice := DB.GetFieldValueString(iname, 'QuestNotice');
      pd^.RegenInterval := DB.GetFieldValueInteger(iName, 'RegenInterval');
      pd^.ActiveInterval := DB.GetFieldValueInteger(iName, 'ActiveInterval');
      pd^.EjectNotice := DB.GetFieldValueString(iname, 'EjectNotice');

      if (pd^.X = 0) and (pd^.Y = 0) then
      begin
         pd^.RandomPosCount := 0;
         srcstr := DB.GetFieldValueString(iName, 'RandomPos');
         for j := 0 to 10 - 1 do
         begin
            srcstr := GetValidStr3(srcstr, tokenstr, ':');
            xx := _StrToInt(tokenstr);
            srcstr := GetValidStr3(srcstr, tokenstr, ':');
            yy := _StrToInt(tokenstr);
            if (xx = 0) or (yy = 0) then
               break;
            pd^.RandomX[j] := xx;
            pd^.RandomY[j] := yy;
            Inc(pd^.RandomPosCount);
         end;
      end;

      str := DB.GetFieldValueString(iName, 'OpenClock');
      if str <> '' then
      begin
         case pd^.Kind of
            GATE_KIND_SPECIALTIME:
               begin
                  for j := Low(pd^.OpenClock) to High(pd^.OpenClock) do
                  begin
                     str := GetValidStr3(str, str2, '/');
                     if str2 = '' then
                        break;
                     pd^.OpenClock[j] := strtodatetime(str2);
                  end;
               end;
            GATE_KIND_FIXPOSITION, GATE_KIND_FIXTIME , GATE_KIND_SPORTSWAR:
               begin
                  LoadGateOpenHours(str, pd^);
               end;
         end;
      end;

      pd^.boAlarmRemainTime := DB.GetFieldValueBoolean(iName,
         'boAlarmRemainTime');
      pd^.AlarmNotice := DB.GetFieldValueString(iName, 'AlarmNotice');
      pd^.MaxUser := DB.GetFieldValueInteger(iName, 'MaxUser');
      pd^.Script := DB.GetFieldValueInteger(iName, 'Script');
      pd^.GuildName := DB.GetFieldValueString(iName, 'GuildName');

      // add by minds 051128
      if NATION_VERSION <> NATION_TAIWAN then
        // add by minds 050902
        if pd^.GuildName <> '' then OwnGateGuildList.Add(pd^.GuildName);
        ////

      Manager := ManagerList.GetManagerByServerID(pd^.MapID);
      if Manager <> nil then
      begin
         GateObject.SetManagerClass(Manager);
         if pd^.Script > 0 then
         begin
            GateObject.SetScript(pd^.Script);
         end;
         GateObject.Initial;
         GateObject.StartProcess;
         DataList.Add(GateObject);
      end
      else
      begin
         GateObject.Free;
      end;
   end;
   DB.Free;
end;

procedure TGateList.SetBSGateActive(boFlag: Boolean);
var
   i: integer;
   GateObject: TGateObject;
begin
   for i := 0 to DataList.Count - 1 do
   begin
      GateObject := DataList.Items[i];
      if GateObject.SelfData.Kind = GATE_KIND_BS then
      begin
         GateObject.boActive := boFlag;
      end;
   end;
end;

procedure TGateList.SetGateActivebyKind(aKind: Byte; aboFlag: Boolean);
var
   i: integer;
   GateObject: TGateObject;
begin
   for i := 0 to DataList.Count - 1 do
   begin
      GateObject := DataList.Items[i];
      if GateObject.SelfData.Kind = aKind then
      begin
         GateObject.boActive := aboFlag;
      end;
   end;
end;

function TGateList.GetGatePosByStr(aManager: TManager): string;
var
   i: integer;
   Str: string;
   GateObject: TGateObject;
begin
   Str := '';
   for i := 0 to DataList.Count - 1 do
   begin
      GateObject := DataList.Items[i];
      if GateObject.Manager = aManager then
      begin
         //         if StrPas (@GateObject.BasicData.ViewName) <> '' then begin
         if GateObject.SelfData.boShow = true then
         begin
            if Str <> '' then
               Str := Str + ',';
            Str := Str + format('%s:%d:%d:%d',
               [StrPas(@GateObject.BasicData.ViewName), GateObject.BasicData.X,
               GateObject.BasicData.Y, 64512]);
         end;
      end;
   end;

   Result := Str;
end;

// add by minds 050902
function TGateList.IsOwnGateGuild(const aGuildName: string): Boolean;
begin
  Result := (OwnGateGuildList.IndexOf(aGuildName) >= 0); 
end;

////////////////////////////////////////////////////
//
//             ===  GateObjectEx  ===
//
////////////////////////////////////////////////////

constructor TGateObjectEx.Create;
begin
   inherited Create;

   boActive := false;
   RegenedTick := mmAnsTick;

   FillChar(SelfData, SizeOf(TCreateGateDataEx), 0);
end;

destructor TGateObjectEx.Destroy;
begin
   inherited destroy;
end;

function TGateObjectEx.GetSelfData: PTCreateGateDataEx;
begin
   Result := @SelfData;
end;

function TGateObjectEx.FieldProc(hfu: Longint; Msg: word; var SenderInfo:
   TBasicData; var aSubData: TSubData): Integer;
var
   i, RandomCount: Integer;
   SubData: TSubData;
   ItemData: TItemData;
   pUser: TUser;
   boFlag: Boolean;
   BO: TBasicObject;
   RetStr, Str, Condition: string;
begin
   Result := PROC_FALSE;
   if isRangeMessage(hfu, Msg, SenderInfo) = FALSE then
      exit;
   Result := inherited FieldProc(hfu, Msg, Senderinfo, aSubData);
   if Result = PROC_TRUE then
      exit;

   case Msg of
      FM_MOVE:
         begin
            if (SelfData.Kind = GATE_KIND_NORMAL) and (BasicData.nx = 0) and
               (BasicData.ny = 0) then
               exit;

            if CheckInArea(SenderInfo.nx, SenderInfo.ny, BasicData.x,
               BasicData.y, SelfData.Width) then
            begin
               BO := TBasicObject(SenderInfo.P);
               if BO = nil then
                  exit;
               if not (BO is TUser) then
                  exit;
               pUser := TUser(BO);

               if pUser.MovingStatus = true then
               begin
                  exit;
               end;

               if boActive = false then
               begin
                  pUser.SetPosition(SelfData.EjectX, SelfData.EjectY);
                  case SelfData.Kind of
                     GATE_KIND_NORMAL:
                        pUser.SendClass.SendChatMessage(format(Conv('现在无法进入， %d分%d秒后才会开启'), [RemainHour * 60 + RemainMin, RemainSec]), SAY_COLOR_SYSTEM);
                     GATe_KIND_BS:
                        pUser.SendClass.SendChatMessage(format(Conv('现在无法进入'), [RemainHour * 60 + RemainMin, RemainSec]), SAY_COLOR_SYSTEM);
                  end;
                  exit;
               end;

               boFlag := true;
               if SelfData.NeedAge > 0 then
               begin
                  if SelfData.NeedAge <= pUser.GetAge then
                  begin
                  end
                  else
                  begin
                     if SelfData.AgeNeedItem > 0 then
                     begin
                        if SelfData.AgeNeedItem <= pUser.GetAge then
                        begin
                           for i := 0 to 5 - 1 do
                           begin
                              if SelfData.NeedItem[i].rName[0] = 0 then
                                 break;
                              ItemClass.GetItemData(StrPas(@SelfData.NeedItem[i].rName), ItemData);
                              if ItemData.rName[0] <> 0 then
                              begin
                                 ItemData.rCount := SelfData.NeedItem[i].rCount;
                                 boFlag := TUser(BO).FindItem(@ItemData);
                                 if boFlag = false then
                                    break;
                              end;
                           end;
                           if boFlag = true then
                           begin
                              for i := 0 to 5 - 1 do
                              begin
                                 if SelfData.NeedItem[i].rName[0] = 0 then
                                    break;
                                 ItemClass.GetItemData(StrPas(@SelfData.NeedItem[i].rName), ItemData);
                                 if ItemData.rName[0] <> 0 then
                                 begin
                                    ItemData.rCount :=
                                       SelfData.NeedItem[i].rCount;
                                    TUser(BO).DeleteItem(@ItemData);
                                 end;
                              end;
                           end;
                        end
                        else
                        begin
                           boFlag := false;
                        end;
                     end
                     else
                     begin
                        boFlag := false;
                     end;
                  end;
               end;

               if boFlag = true then
               begin
                  if SelfData.Quest <> 0 then
                  begin
                     if QuestClass.CheckQuestComplete(SelfData.Quest, ServerID,
                        pUser, RetStr) = false then
                     begin
                        pUser.SetPosition(SelfData.EjectX, SelfData.EjectY);
                        pUser.SendClass.SendChatMessage(SelfData.QuestNotice,
                           SAY_COLOR_SYSTEM);
                        pUser.SendClass.SendChatMessage(RetStr,
                           SAY_COLOR_SYSTEM);
                        exit;
                     end;
                  end;
               end;

               if boFlag = true then
               begin
                  case SelfData.Kind of
                     GATE_KIND_NORMAL:
                        begin
                           if SelfData.boRandom = true then
                           begin
                              RandomCount := Random(SelfData.RandomCount);
                              SubData.ServerId :=
                                 SelfData.TargetData[RandomCount].ServerID;
                              BasicData.nx :=
                                 SelfData.TargetData[RandomCount].X;
                              BasicData.ny :=
                                 SelfData.TargetData[RandomCount].Y;
                              Phone.SendMessage(SenderInfo.ID, FM_GATE,
                                 BasicData, SubData);
                           end;
                           if SelfData.boCondition = true then
                           begin
                              Condition := SelfData.Condition;
                              Str := GetValidStr3(Condition, RetStr, ':');
                              if StrtoInt(Str) > pUser.GetAge then
                              begin
                                 SubData.ServerID :=
                                    SelfData.TargetData[0].ServerID;
                                 BasicData.nx := SelfData.TargetData[0].X;
                                 BasicData.ny := SelfData.TargetData[0].Y;
                                 Phone.SendMessage(SenderInfo.ID, FM_GATE,
                                    BasicData, SubData);
                              end
                              else
                              begin
                                 SubData.ServerID :=
                                    SelfData.TargetData[1].ServerID;
                                 BasicData.nx := SelfData.TargetData[1].X;
                                 BasicData.ny := SelfData.TargetData[1].Y;
                                 Phone.SendMessage(SenderInfo.ID, FM_GATE,
                                    BasicData, SubData);
                              end;
                           end;
                        end;
                     GATE_KIND_BS:
                        begin
                           pUser.SetPositionBS(SelfData.EjectX,
                              SelfData.EjectY);
                        end;
                     GATE_KIND_DOOR:
                        begin
                        end;
                  end;
               end
               else
               begin
                  if (SelfData.EjectX > 0) and (SelfData.EjectY > 0) then
                  begin
                     pUser.SetPosition(SelfData.EjectX, SelfData.EjectY);
                  end;
                  if SelfData.EjectNotice = '' then
                  begin
                     pUser.SendClass.SendChatMessage(Conv('此处为限制出入的地方，无法进入。'), SAY_COLOR_SYSTEM);
                  end
                  else
                  begin
                     pUser.SendClass.SendChatMessage(SelfData.EjectNotice,
                        SAY_COLOR_SYSTEM);
                  end;
               end;
            end;
         end;
   end;
end;

procedure TGateObjectEx.Initial;
begin
   inherited Initial(SelfData.Name, SelfData.ViewName);

   BasicData.id := GetNewItemId;

   if (SelfData.X <> 0) or (SelfData.Y <> 0) then
   begin
      BasicData.x := SelfData.x;
      BasicData.y := SelfData.y;
   end;

   BasicData.nx := SelfData.TargetData[0].X;
   BasicData.ny := SelfData.TargetData[0].Y;
   BasicData.ClassKind := CLASS_GATE;
   BasicData.Feature.rrace := RACE_ITEM;
   BasicData.Feature.rImageNumber := SelfData.Shape;
   BasicData.Feature.rImageColorIndex := 0;

   boActive := true;
   RegenedTick := mmAnsTick;
end;

procedure TGateObjectEx.StartProcess;
var
   SubData: TSubData;
begin
   inherited StartProcess;

   SubData.EffectNumber := 0;
   SubData.EffectKind := lek_none;
   Phone.RegisterUser(BasicData.id, FieldProc, BasicData.X, BasicData.Y);
   Phone.SendMessage(0, FM_CREATE, BasicData, SubData);
end;

procedure TGateObjectEx.EndProcess;
var
   SubData: TSubData;
begin
   Phone.SendMessage(0, FM_DESTROY, BasicData, SubData);
   Phone.UnRegisterUser(BasicData.id, BasicData.x, BasicData.y);

   inherited EndProcess;
end;

procedure TGateObjectEx.Update(CurTick: Integer);
begin
   if (SelfData.RegenInterval > 0) and (RegenedTick + 100 <= CurTick) then
   begin
      Manager.CalcTime(RegenedTick + SelfData.RegenInterval - CurTick,
         RemainHour, RemainMin, RemainSec);
   end;
   if (SelfData.RegenInterval > 0) and (RegenedTick + SelfData.RegenInterval <=
      CurTick) then
   begin
      RegenedTick := CurTick;
      boActive := true;
   end
   else
   begin
      if (SelfData.X = 0) and (SelfData.Y = 0) then
      begin
         if CurTick >= RegenedTick + SelfData.ActiveInterval then
         begin
            EndProcess;
            Initial;
            StartProcess;
         end;
         exit;
      end;
      if boActive = true then
      begin
         if (SelfData.RegenInterval > 0) and (RegenedTick +
            SelfData.ActiveInterval <= CurTick) then
         begin
            boActive := false;
         end;
      end;
   end;
end;

////////////////////////////////////////////////////
//
//             ===  GateListEx  ===
//
////////////////////////////////////////////////////

constructor TGateListEx.Create;
begin
   inherited Create('GATEEX', nil);

   LoadFromFile('.\Setting\CreateGateEx.SDB');
end;

destructor TGateListEx.Destroy;
begin
   Clear;
   inherited Destroy;
end;

procedure TGateListEx.LoadFromFile(aFileName: string);
var
   i, j, tmpCount: integer;
   iName, srcstr, tokenstr: string;
   ItemData: TItemData;
   GateObjectEx: TGateObjectEx;
   pd: PTCreateGateDataEx;
   DB: TUserStringDB;
   Manager: TManager;
begin
   if not FileExists(aFileName) then
      exit;

   DB := TUserStringDb.Create;
   DB.LoadFromFile(aFileName);

   for i := 0 to DB.Count - 1 do
   begin
      iName := DB.GetIndexName(i);

      GateObjectEx := TGateObjectEx.Create;
      pd := GateObjectEx.GetSelfData;

      pd^.Name := DB.GetFieldValueString(iName, 'GateName');
      pd^.ViewName := DB.GetFieldValueString(iName, 'ViewName');
      pd^.Kind := DB.GetFieldValueInteger(iname, 'Kind');
      pd^.Shape := DB.GetFieldValueInteger(iName, 'Shape');
      pd^.x := DB.GetFieldValueInteger(iName, 'X');
      pd^.y := DB.GetFieldValueInteger(iName, 'Y');
      pd^.targetx := DB.GetFieldValueInteger(iName, 'TX');
      pd^.targety := DB.GetFieldValueInteger(iName, 'TY');
      pd^.ejectx := DB.GetFieldValueInteger(iName, 'EX');
      pd^.ejecty := DB.GetFieldValueInteger(iName, 'EY');
      pd^.MapID := DB.GetFieldValueInteger(iname, 'MapID');

      pd^.boRandom := DB.GetFieldValueBoolean(iName, 'boRandom');
      pd^.RandomCount := DB.GetFieldValueInteger(iName, 'RandomCount');
      pd^.RandomTotal := DB.GetFieldValueInteger(iName, 'RandomTotal');
      if pd^.boRandom and ((pd^.RandomCount < 1) or
         (pd^.RandomCount > Length(pd^.TargetData))) then
      begin
         FrmMain.WriteLogInfo(Format('%s: gate %s has invalid RandomCount %d (valid 1..12)',
            [aFileName, iName, pd^.RandomCount]));
         GateObjectEx.Free;
         continue;
      end;
      pd^.boCondition := DB.GetFieldValueBoolean(iName, 'boCondition');
      pd^.Condition := DB.GetFieldValueString(iName, 'Condition');
      pd^.Width := DB.GetFieldValueInteger(iName, 'Width');
      pd^.NeedAge := DB.GetFieldValueInteger(iName, 'NeedAge');
      pd^.AgeNeedItem := DB.GetFieldValueInteger(iName, 'AgeNeedItem');

      if pd^.boRandom = true then
      begin
         pd^.TargetData[0].ServerID := DB.GetFieldValueInteger(iName,
            'TargetServerID' + InttoStr(0));
            // 捞扒 1/randomcount 捞扁 锭巩俊 菊栏肺画
         pd^.TargetData[0].X := DB.GetFieldValueInteger(iName, 'TargetX' +
            InttoStr(0));
         pd^.TargetData[0].Y := DB.GetFieldValueInteger(iName, 'TargetY' +
            InttoStr(0));
         tmpCount := 0;
         for j := 1 to pd^.RandomCount - 1 do
         begin
            pd^.TargetData[j].ServerID := DB.GetFieldValueInteger(iName,
               'TargetServerID' + InttoStr(tmpCount + 1));
            pd^.TargetData[j].X := DB.GetFieldValueInteger(iName, 'TargetX' +
               InttoStr(tmpCount + 1));
            pd^.TargetData[j].Y := DB.GetFieldValueInteger(iName, 'TargetY' +
               InttoStr(tmpCount + 1));
            inc(tmpCount);
            if tmpCount = pd^.RandomTotal - 1 then
               tmpCount := 0;
         end;
      end
      else
      begin
         for j := 0 to 5 - 1 do
         begin
            pd^.TargetData[j].ServerID := DB.GetFieldValueInteger(iName,
               'TargetServerID' + InttoStr(j));
            pd^.TargetData[j].X := DB.GetFieldValueInteger(iName, 'TargetX' +
               InttoStr(j));
            pd^.TargetData[j].Y := DB.GetFieldValueInteger(iName, 'TargetY' +
               InttoStr(j));
         end;
      end;

      srcstr := DB.GetFieldValueString(iName, 'NeedItem');
      if srcstr <> '' then
      begin
         for j := 0 to 5 - 1 do
         begin
            srcstr := GetValidStr3(srcstr, tokenstr, ':');
            if tokenstr = '' then
               break;
            ItemClass.GetItemData(tokenstr, ItemData);
            if ItemData.rName[0] <> 0 then
            begin
               srcstr := GetValidStr3(srcstr, tokenstr, ':');
               ItemData.rCount := _StrToInt(tokenstr);
               StrCopy(@pd^.NeedItem[j].rName, @ItemData.rName);
               pd^.NeedItem[j].rCount := ItemData.rCount;
            end;
         end;
      end;
      pd^.Quest := DB.GetFieldValueInteger(iname, 'Quest');
      pd^.QuestNotice := DB.GetFieldValueString(iname, 'QuestNotice');
      pd^.RegenInterval := DB.GetFieldValueInteger(iName, 'RegenInterval');
      pd^.ActiveInterval := DB.GetFieldValueInteger(iName, 'ActiveInterval');
      pd^.EjectNotice := DB.GetFieldValueString(iname, 'EjectNotice');

      Manager := ManagerList.GetManagerByServerID(pd^.MapID);
      if Manager <> nil then
      begin
         GateObjectEx.SetManagerClass(Manager);
         GateObjectEx.Initial;
         GateObjectEx.StartProcess;
         DataList.Add(GateObjectEx);
      end
      else
      begin
         GateObjectEx.Free;
      end;
   end;
   DB.Free;
end;

procedure TGateListEx.SetBSGateActive(boFlag: Boolean);
var
   i: integer;
   GateObjectEx: TGateObjectEx;
begin
   for i := 0 to DataList.Count - 1 do
   begin
      GateObjectEx := DataList.Items[i];
      if GateObjectEx.SelfData.Kind = GATE_KIND_BS then
      begin
         GateObjectEx.boActive := boFlag;
      end;
   end;
end;

function TGateListEx.GetGatePosByStr(aManager: TManager): string;
var
   i: integer;
   Str: string;
   GateObjectEx: TGateObjectEx;
begin
   Str := '';
   for i := 0 to DataList.Count - 1 do
   begin
      GateObjectEx := DataList.Items[i];
      if GateObjectEx.Manager = aManager then
      begin
         if StrPas(@GateObjectEx.BasicData.ViewName) <> '' then
         begin
            if Str <> '' then
               Str := Str + ',';
            Str := Str + format('%s:%d:%d',
               [StrPas(@GateObjectEx.BasicData.ViewName), GateObjectEx.BasicData.X,
               GateObjectEx.BasicData.Y]);
         end;
      end;
   end;

   Result := Str;
end;

////////////////////////////////////////////////////
//
//             ===  MirrorObject  ===
//
////////////////////////////////////////////////////

constructor TMirrorObject.Create;
begin
   inherited Create;

   ViewerList := TList.Create;

   FillChar(SelfData, SizeOf(TCreateMirrorData), 0);
   boActive := false;
end;

destructor TMirrorObject.Destroy;
begin
   ViewerList.Free;

   inherited Destroy;
end;

procedure TMirrorObject.AddViewer(aUser: Pointer);
var
   i: Integer;
begin
   if ViewerList.IndexOf(aUser) >= 0 then
      exit;
   ViewerList.Add(aUser);

   TUser(aUser).SendClass.SendMap(BasicData, Manager);
   for i := 0 to ViewObjectList.Count - 1 do
   begin
      TUser(aUser).SendClass.SendShow(TBasicObject(ViewObjectList[i]).BasicData,
         0, lek_none);
   end;

end;

function TMirrorObject.DelViewer(aUser: Pointer): Boolean;
var
   i, iNo: Integer;
   tmpManager: TManager;
   tmpViewObjectList: TList;
begin
   Result := false;

   iNo := ViewerList.IndexOf(aUser);
   if iNo < 0 then
      exit;

   tmpManager := TUser(aUser).Manager;
   tmpViewObjectList := TUser(aUser).ViewObjectList;

   TUser(aUser).SendClass.SendMap(TUser(aUser).BasicData, tmpManager);
   for i := 0 to tmpViewObjectList.Count - 1 do
   begin
      TUser(aUser).SendClass.SendShow(TBasicObject(tmpViewObjectList[i]).BasicData, 0, lek_none);
   end;

   ViewerList.Delete(iNo);

   Result := true;
end;

procedure TMirrorObject.Initial;
begin
   inherited Initial(SelfData.Name, SelfData.Name);

   BasicData.id := GetNewItemId;
   BasicData.x := SelfData.X;
   BasicData.y := SelfData.Y;
   BasicData.ClassKind := CLASS_SERVEROBJ;
   BasicData.Feature.rrace := RACE_ITEM;
   BasicData.Feature.rImageNumber := 0;
   BasicData.Feature.rImageColorIndex := 0;

   boActive := SelfData.boActive;
end;

procedure TMirrorObject.StartProcess;
var
   SubData: TSubData;
begin
   inherited StartProcess;

   SubData.EffectNumber := 0;
   SubData.EffectKind := lek_none;
   Phone.RegisterUser(BasicData.id, FieldProc, BasicData.X, BasicData.Y);
   Phone.SendMessage(0, FM_CREATE, BasicData, SubData);
end;

procedure TMirrorObject.EndProcess;
var
   SubData: TSubData;
begin
   Phone.SendMessage(0, FM_DESTROY, BasicData, SubData);
   Phone.UnRegisterUser(BasicData.id, BasicData.x, BasicData.y);

   inherited EndProcess;
end;

function TMirrorObject.FieldProc(hfu: Longint; Msg: word; var SenderInfo:
   TBasicData; var aSubData: TSubData): Integer;
var
   i: Integer;
   User: TUser;
begin
   Result := PROC_FALSE;

   if isRangeMessage(hfu, Msg, SenderInfo) = FALSE then
      exit;
   Result := inherited FieldProc(hfu, Msg, Senderinfo, aSubData);

   for i := 0 to ViewerList.Count - 1 do
   begin
      User := ViewerList.Items[i];
      User.FieldProc2(hfu, Msg, SenderInfo, aSubData);
   end;
end;

procedure TMirrorObject.Update(CurTick: Integer);
begin

end;

function TMirrorObject.GetSelfData: PTCreateMirrorData;
begin
   Result := @SelfData;
end;

////////////////////////////////////////////////////
//
//             ===  MirrorList  ===
//
////////////////////////////////////////////////////

constructor TMirrorList.Create;
begin
   inherited Create('MIRROR', nil);

   LoadFromFile('.\Setting\CreateMirror.SDB');
end;

destructor TMirrorList.Destroy;
begin
   Clear;
   inherited Destroy;
end;

function TMirrorList.AddViewer(aStr: string; aUser: Pointer): Boolean;
var
   i: Integer;
   MirrorObj: TMirrorObject;
begin
   Result := false;

   for i := 0 to DataList.Count - 1 do
   begin
      MirrorObj := DataList.Items[i];
      if StrPas(@MirrorObj.BasicData.Name) = aStr then
      begin
         MirrorObj.AddViewer(aUser);
         Result := true;
         exit;
      end;
   end;
end;

function TMirrorList.DelViewer(aUser: Pointer): Boolean;
var
   i: Integer;
   MirrorObj: TMirrorObject;
begin
   Result := false;

   for i := 0 to DataList.Count - 1 do
   begin
      MirrorObj := DataList.Items[i];
      if MirrorObj.DelViewer(aUser) = true then
      begin
         Result := true;
         exit;
      end;
   end;
end;

procedure TMirrorList.LoadFromFile(aFileName: string);
var
   i: Integer;
   iName: string;
   DB: TUserStringDB;
   MirrorObj: TMirrorObject;
   pd: PTCreateMirrorData;
   Manager: TManager;
begin
   if not FileExists(aFileName) then
      exit;

   DB := TUserStringDB.Create;
   DB.LoadFromFile(aFileName);

   for i := 0 to DB.Count - 1 do
   begin
      iName := DB.GetIndexName(i);
      if iName = '' then
         continue;

      MirrorObj := TMirrorObject.Create;
      pd := MirrorObj.GetSelfData;

      pd^.Name := DB.GetFieldValueString(iName, 'Name');
      pd^.X := DB.GetFieldValueInteger(iName, 'X');
      pd^.Y := DB.GetFieldValueInteger(iName, 'Y');
      pd^.MapID := DB.GetFieldValueInteger(iName, 'MapID');
      pd^.boActive := DB.GetFieldValueBoolean(iName, 'boActive');

      Manager := ManagerList.GetManagerByServerID(pd^.MapID);
      if Manager <> nil then
      begin
         MirrorObj.SetManagerClass(Manager);
         MirrorObj.Initial;
         MirrorObj.StartProcess;
         DataList.Add(MirrorObj);
      end
      else
      begin
         MirrorObj.Free;
      end;
   end;

   DB.Free;
end;

////////////////////////////////////////////////////
//
//             ===  StaticItemObject  ===
//
////////////////////////////////////////////////////

constructor TStaticItem.Create;
begin
   inherited Create;
end;

destructor TStaticItem.Destroy;
begin
   inherited destroy;
end;

function TStaticItem.FieldProc(hfu: Longint; Msg: word; var SenderInfo:
   TBasicData; var aSubData: TSubData): Integer;
var
   percent: integer;
begin
   Result := PROC_FALSE;
   if isRangeMessage(hfu, Msg, SenderInfo) = FALSE then
      exit;
   Result := inherited FieldProc(hfu, Msg, Senderinfo, aSubData);
   if Result = PROC_TRUE then
      exit;

   case Msg of
      FM_HIT:
         begin
            if isHitedArea(SenderInfo.dir, SenderInfo.x, SenderInfo.y,
               aSubData.HitData.HitFunction, percent) then
            begin
               Dec(CurDurability, 5 * 100);
            end;
         end;
   end;
end;

procedure TStaticItem.Initial(aItemData: TItemData; aOwnerId, ax, ay: integer);
var
   str: string;
begin
   str := StrPas(@aItemData.rName);
   if aItemData.rCount > 1 then
      str := str + ':' + IntToStr(aItemData.rCount);

   inherited Initial(str, str);
   CurDurability := 10 * 60 * 100; // 10盒悼救 绝绢瘤瘤 救澜.

   OwnerId := aOwnerId;
   SelfItemdata := aItemData;
   BasicData.id := GetNewStaticItemId;
   BasicData.x := ax;
   BasicData.y := ay;
   BasicData.ClassKind := CLASS_STATICITEM;
   BasicData.Feature.rrace := RACE_STATICITEM;
   BasicData.Feature.rImageNumber := aItemData.rShape;
   BasicData.Feature.rImageColorIndex := aItemData.rcolor;
end;

procedure TStaticItem.StartProcess;
var
   SubData: TSubData;
begin
   inherited StartProcess;

   SubData.EffectNumber := 0;
   SubData.EffectKind := lek_none;
   Phone.RegisterUser(BasicData.id, FieldProc, BasicData.X, BasicData.Y);
   Phone.SendMessage(0, FM_CREATE, BasicData, SubData);

   if SelfItemData.rSoundDrop.rWavNumber <> 0 then
   begin
      SetWordString(SubData.SayString,
         IntToStr(SelfItemData.rSoundDrop.rWavNumber) + '.wav');
      SendLocalMessage(NOTARGETPHONE, FM_SOUND, BasicData, SubData);
   end;
end;

procedure TStaticItem.EndProcess;
var
   SubData: TSubData;
begin
   if FboRegisted = FALSE then
      exit;

   Phone.SendMessage(0, FM_DESTROY, BasicData, SubData);
   Phone.UnRegisterUser(BasicData.id, BasicData.x, BasicData.y);
   inherited EndProcess;
end;

procedure TStaticItem.Update(CurTick: integer);
begin
   if CreateTick + CurDurability < CurTick then
      FboAllowDelete := TRUE;
end;

////////////////////////////////////////////////////
//
//             ===  StaticItemList  ===
//
////////////////////////////////////////////////////

constructor TStaticItemList.Create(aManager: TManager);
begin
   inherited Create('STATICITEM', aManager);
end;

destructor TStaticItemList.Destroy;
begin
   Clear;
   inherited Destroy;
end;

function TStaticItemList.AddStaticItemObject(aItemData: TItemData; aOwnerId, ax,
   ay: integer): integer;
var
   ItemObject: TStaticItem;
begin
   Result := PROC_FALSE;
   if DataList.count > 3000 then
      exit;

   if aItemData.rCount <> 1 then
      exit;
   if not TMaper(Manager.Maper).isMoveable(ax, ay) then
      exit;

   ItemObject := TStaticItem.Create;
   ItemObject.SetManagerClass(Manager);
   ItemObject.Initial(aItemData, aOwnerId, ax, ay);
   ItemObject.StartProcess;

   DataList.Add(ItemObject);
   Result := PROC_TRUE;
end;

////////////////////////////////////////////////////
//
//             ===  DynamicItemObject  ===
//
////////////////////////////////////////////////////

constructor TDynamicObject.Create;
begin
   inherited Create;

   EventItemCount := 0;
   ObjectStatus := dos_Closed;
   MemberList := nil;
   DragDropEvent := nil;

   FCurrentStep := 0;
   FStepList := TList.Create;
   AttackedMagicClass := TAttackedMagicClass.Create(self);
end;

destructor TDynamicObject.Destroy;
var
   i: Integer;
   AttackSkill: TAttackSkill;
   BO: TBasicObject;
   psd: PTStepData;
begin
   if FStepList <> nil then
   begin
      for i := 0 to FStepList.Count - 1 do
      begin
         psd := FStepList.Items[i];
         Dispose(psd);
      end;
      FStepList.Clear;
      FStepList.Free;
      FStepList := nil;
   end;
   if DragDropEvent <> nil then
      DragDropEvent.Free;
   if MemberList <> nil then
   begin
      for i := MemberList.Count - 1 downto 0 do
      begin
         BO := MemberList[i];
         if BO <> nil then
         begin
            AttackSkill := nil;
            if BO.BasicData.Feature.rRace = RACE_MONSTER then
            begin
               AttackSkill := TMonster(BO).GetAttackSkill;
            end
            else if BO.BasicData.Feature.rRace = RACE_NPC then
            begin
               AttackSkill := TNpc(BO).GetAttackSkill;
            end;
            if AttackSkill <> nil then
            begin
               AttackSkill.SetObjectBoss(nil);
            end;
         end;
      end;
      MemberList.Clear;
      MemberList.Free;
   end;

   AttackedMagicClass.Free;
   ClearExpLink;

   inherited destroy;
end;

procedure TDynamicObject.AddExpLink(aID, aValue: Integer); // 龋楷瘤扁 林绰芭
var
   i: Integer;
begin
   for i := 0 to 10 - 1 do
   begin
      if ExpLink[i].ID = aID then
      begin
         ExpLink[i].DecLife := ExpLink[i].DecLife + aValue;
         exit;
      end;
   end;

   for i := 0 to 10 - 1 do
   begin
      if ExpLink[i].ID = 0 then
      begin
         ExpLink[i].ID := aID;
         ExpLink[i].DecLife := aValue;
         exit;
      end;
   end;
end;

function TDynamicObject.FindBestExpLink: Integer; // 龋楷瘤扁 临 局甸 茫绰芭
var
   i, MaxID, MaxValue: Integer;
begin

   MaxID := 0;
   MaxValue := 0;
   for i := 0 to 10 - 1 do
   begin
      if ExpLink[i].ID = 0 then
         continue;
      if ExpLink[i].DecLife > MaxValue then
      begin
         MaxID := ExpLink[i].ID;
         MaxValue := ExpLink[i].DecLife;
      end;
   end;

   Result := MaxID;
end;

procedure TDynamicObject.ClearExpLink;
var
   i: Integer;
begin
   for i := 0 to 10 - 1 do
   begin
      FillChar(ExpLink[i], SizeOf(TExpLinkData), 0);
   end;
end;

procedure TDynamicObject.Regen;
var
   pd: PTStepData;
begin
   if FboRegisted = true then
      exit;

   FCurrentStep := 0;
   CurLife := SelfData.rBasicData.rLife;
   ObjectStatus := dos_Closed;
   pd := FStepList.Items[FCurrentStep];
   BasicData.nx := pd^.StartStep[byte(dos_Closed)];
   BasicData.ny := pd^.EndStep[byte(dos_Closed)];
   BasicData.Feature.rHitMotion := Byte(dos_Closed);
   if BasicData.nx <> BasicData.ny then
      BasicData.Feature.rHitMotion := Byte(dos_Openning);

   StartProcess;
end;

procedure TDynamicObject.CallMe(x, y: Integer);
var
   pd: PTStepData;
begin
   EndProcess;

   FCurrentStep := 0;
   CurLife := SelfData.rBasicData.rLife;
   ObjectStatus := dos_Closed;
   pd := FStepList.Items[FCurrentStep];
   BasicData.nx := pd^.StartStep[byte(dos_Closed)];
   BasicData.ny := pd^.EndStep[byte(dos_Closed)];
   BasicData.Feature.rHitMotion := Byte(dos_Closed);
   if BasicData.nx <> BasicData.ny then
      BasicData.Feature.rHitMotion := Byte(dos_Openning);

   StartProcess;
end;

procedure TDynamicObject.MemberDie(aBasicObject: TBasicObject);
var
   i: Integer;
begin
   if MemberList = nil then
      exit;
   for i := 0 to MemberList.Count - 1 do
   begin
      if aBasicObject = MemberList[i] then
      begin
         if aBasicObject.BasicData.Feature.rfeaturestate <> wfs_die then
         begin
            CurLife := SelfData.rBasicData.rLife;
            {
            end else begin
               for j := 0 to 5 - 1 do begin
                  if StrPas (@aBasicObject.BasicData.Name) = SelfData.rDropMop [j].rName then begin
                     SelfData.rDropMop[j].rName := '';
                     break;
                  end;
                  if StrPas (@aBasicObject.BasicData.Name) = SelfData.rCallNpc [j].rName then begin
                     SelfData.rCallNpc[j].rName := '';
                     break;
                  end;
               end;
            }
         end;
         MemberList.Delete(i);
         break;
      end;
   end;
end;

procedure TDynamicObject.CommandHit;
var
   SubData: TSubData;
begin
   if SelfData.rBasicData.rDamage = 0 then
      exit;

   FillChar(SubData, SizeOf(TSubData), 0);

   SubData.HitData.damageBody := SelfData.rBasicData.rDamage;
   SubData.HitData.damageHead := 0;
   SubData.HitData.damageArm := 0;
   SubData.HitData.damageLeg := 0;

   SubData.HitData.ToHit := 75;
   SubData.HitData.HitType := 0;
   SubData.HitData.HitLevel := 7500;
   SubData.HitData.HitFunction := 0;
   SubData.HitData.HitFunctionSkill := 0;

   SubData.HitData.boHited := FALSE;
   SubData.HitData.HitFunction := 0;
   SubData.HitData.Virtue := 0;

   SubData.HitData.Accuracy := 0;

   SubData.HitData.damageExp := SelfData.rBasicData.rDamage;
   SubData.HitData.MagicType := 0;
   SubData.HitData.Race := RACE_MONSTER;
   SubData.HitData.GroupKey := 0;

   // if  then begin 8柳拜栏肺 且锭
   SubData.HitData.HitFunction := MAGICFUNC_8HIT;
   SubData.HitData.HitFunctionSkill := 9999;
   // end;

   ShowEffect2(SelfData.rBasicData.rEffectColor, lek_follow, 0);

   SubData.HitData.CurMagicDamage := 0;
   SendLocalMessage(NOTARGETPHONE, FM_HIT, BasicData, SubData);
end;

procedure TDynamicObject.CommandAttackedMagic(var aWindOfHandData:
   TWindOfHandData);
var
   BO, BO2: TBasicObject;
   i, j: integer;
   xx, yy: Integer;
   Monster: TMonster;
   AttackSkill: TAttackSkill;
   Npc: TNpc;
   decLife: Integer;
   SubData: TSubData;
   Code: Integer;
   SkillLevel: Integer;
   ItemData: TItemData;
   boFlag: Boolean;
begin
   if ObjectStatus <> dos_Closed then
      exit;
   if (SelfData.rBasicData.rKind and DYNOBJ_EVENT_HIT) = DYNOBJ_EVENT_HIT then
   begin
      BO := GetViewObjectByID(aWindOfHandData.rAttacker);
      if BO = nil then
         exit;
      if BO.BasicData.Feature.rRace <> RACE_HUMAN then
         exit;

      if SelfData.rBasicData.rLife = CurLife then
      begin
         for i := 0 to 5 - 1 do
         begin
            if SelfData.rDropMop[i].rName[0] = 0 then
               continue;
            for j := 0 to SelfData.rDropMop[i].rCount - 1 do
            begin
               xx := BasicData.x;
               yy := BasicData.y;
               if (SelfData.rDropX <> 0) and (SelfData.rDropY <> 0) then
               begin
                  xx := SelfData.rDropX;
                  yy := SelfData.rDropY;
               end
               else
               begin
                  Maper.GetMoveableXY(xx, yy, 10);
               end;
               if Maper.isMoveable(xx, yy) then
               begin
                  Monster :=
                     TMonsterList(Manager.MonsterList).CallMonster(Strpas(@SelfData.rDropMop[i].rName), xx, yy, 4, StrPas(@Bo.BasicData.Name));
                  if Monster <> nil then
                  begin
                     AttackSkill := Monster.GetAttackSkill;
                     if AttackSkill <> nil then
                     begin
                        AttackSkill.SetObjectBoss(Self);
                     end;
                     if MemberList = nil then
                     begin
                        MemberList := TList.Create;
                     end;
                     MemberList.Add(Monster);
                  end;
               end;
            end;
         end;
         for i := 0 to 5 - 1 do
         begin
            if SelfData.rCallNpc[i].rName[0] = 0 then
               continue;
            for j := 0 to SelfData.rCallNpc[i].rCount - 1 do
            begin
               xx := BasicData.x;
               yy := BasicData.y;
               if (SelfData.rDropX <> 0) and (SelfData.rDropY <> 0) then
               begin
                  xx := SelfData.rDropX;
                  yy := SelfData.rDropY;
               end
               else
               begin
                  Maper.GetMoveableXY(xx, yy, 10);
               end;
               if Maper.isMoveable(xx, yy) then
               begin
                  Npc :=
                     TNpcList(Manager.NpcList).CallNpc(StrPas(@SelfData.rCallNpc[i].rName), xx, yy, 4, StrPas(@Bo.BasicData.Name));
                  if Npc <> nil then
                  begin
                     AttackSkill := Npc.GetAttackSkill;
                     if AttackSkill <> nil then
                     begin
                        AttackSkill.SetObjectBoss(Self);
                     end;
                     if MemberList = nil then
                     begin
                        MemberList := TList.Create;
                     end;
                     MemberList.Add(Npc);
                  end;
               end;
            end;
         end;
      end
      else
      begin
         if MemberList <> nil then
         begin
            for i := 0 to MemberList.Count - 1 do
            begin
               BO2 := MemberList[i];
               if BO2 <> nil then
               begin
                  if BO2.BasicData.Feature.rRace = RACE_NPC then
                  begin
                     AttackSkill := TNpc(BO2).GetAttackSkill;
                  end
                  else
                  begin
                     AttackSkill := TMonster(BO2).GetAttackSkill;
                  end;
                  AttackSkill.SetDeadAttackName(StrPas(@Bo.BasicData.Name));
               end;
            end;
         end;
      end;

      decLife := aWindOfHandData.rDamageBody - Armor;
      if decLife < 0 then
      begin
         decLife := 1;
      end;

      AddExpLink(aWindOfHandData.rAttacker, declife);
         // 力老 腹捞 锭赴荤恩 茫绰芭...
      CurLife := CurLife - decLife;
      FillChar(SubData.SayString, sizeof(TWordString), 0);
      Move(aWindOfHandData.rSayString, SubData.SayString, sizeof(TNameString));
      SendLocalMessage(NOTARGETPHONE, FM_SOUND, BasicData, SubData);

      if CurLife < 0 then
      begin
         CurLife := 0;
         if SOnDieBefore <> 0 then
         begin
            ScriptManager.CallEvent(Self, nil, SOnDieBefore, 'OnDieBefore',
               ['']);
         end;
      end;

      if CurLife > 0 then
      begin
         SubData.Percent := CurLife * 100 div SelfData.rBasicData.rLife;
         SendLocalMessage(NOTARGETPHONE, FM_STRUCTED, BasicData, SubData);
      end;

      if SelfData.rBasicData.rSoundSpecial.rWavNumber > 0 then
      begin
         SetWordString(SubData.SayString,
            IntToStr(SelfData.rBasicData.rSoundSpecial.rWavNumber) + '.wav');
         SendLocalMessage(NOTARGETPHONE, FM_SOUND, BasicData, SubData);
      end;

      if CurLife > 0 then
         exit;

      Code := EventClass.isDynObjDieEvent(StrPas(@BasicData.Name));
      if Code > 0 then
      begin
         EventClass.RunDynObjDieEvent(Code);
      end;

      if SelfData.rNeedAge <> 0 then
      begin
         if TUser(BO).GetAge < SelfData.rNeedAge then
         begin
            TUser(BO).SendClass.SendChatMessage(format(Conv('%d岁以上方可开启'), [SelfData.rNeedAge]), SAY_COLOR_SYSTEM);
            exit;
         end;
      end;
      for i := 0 to 5 - 1 do
      begin
         if SelfData.rNeedSkill[i].rName[0] = 0 then
            break;
         SkillLevel :=
            TUser(BO).FindHaveMagicByName(StrPas(@SelfData.rNeedSkill[i].rName));
         if SelfData.rNeedSkill[i].rLevel > SkillLevel then
         begin
            TUser(BO).SendClass.SendChatMessage(format(Conv('%s修练值 %s 以上的人方可开启'), [StrPas(@SelfData.rNeedSkill[i].rName),
               Get10000To100(SelfData.rNeedSkill[i].rLevel)]), SAY_COLOR_SYSTEM);
            exit;
         end;
      end;

      for i := 0 to 5 - 1 do
      begin
         if SelfData.rNeedItem[i].rName[0] = 0 then
            break;
         ItemClass.GetItemData(StrPas(@SelfData.rNeedItem[i].rName), ItemData);
         if ItemData.rName[0] <> 0 then
         begin
            ItemData.rCount := SelfData.rNeedItem[i].rCount;
            boFlag := TUser(BO).FindItem(@ItemData);
            if boFlag = false then
            begin
               TUser(BO).SendClass.SendChatMessage(format(Conv('%s 物品需要 %d个'), [StrPas(@ItemData.rName), ItemData.rCount]), SAY_COLOR_SYSTEM);
               exit;
            end;
         end;
      end;

      for i := 0 to 5 - 1 do
      begin
         if SelfData.rNeedItem[i].rName[0] = 0 then
            break;
         ItemClass.GetItemData(StrPas(@SelfData.rNeedItem[i].rName), ItemData);
         if ItemData.rName[0] <> 0 then
         begin
            ItemData.rCount := SelfData.rNeedItem[i].rCount;
            TUser(BO).DeleteItem(@ItemData);
         end;
      end;

      IncStep;

      OpenedPosX := Bo.BasicData.X;
      OpenedPosY := Bo.BasicData.Y;

      xx := BasicData.nx;
      yy := BasicData.ny;
      BasicData.nx := Bo.BasicData.x;
      BasicData.ny := Bo.BasicData.y;
      for i := 0 to 5 - 1 do
      begin
         if SelfData.rGiveItem[i].rName[0] = 0 then
            break;
         ItemClass.GetChanceItemData(StrPas(@BasicData.Name),
            StrPas(@SelfData.rGiveItem[i].rName), ItemData);
         ItemData.rCount := SelfData.rGiveItem[i].rCount;
         ItemData.rOwnerName[0] := 0;

         SubData.ItemData := ItemData;
         SubData.ServerId := ServerId;
         if TFieldPhone(Manager.Phone).SendMessage(Bo.BasicData.id,
            FM_ENOUGHSPACE, BasicData, SubData) = PROC_FALSE then
         begin
            Phone.SendMessage(MANAGERPHONE, FM_ADDITEM, BasicData, SubData);
         end
         else
         begin
            TFieldPhone(Manager.Phone).SendMessage(Bo.BasicData.id, FM_ADDITEM,
               BasicData, SubData);
         end;
      end;
      BasicData.nx := xx;
      BasicData.ny := yy;
   end;
end;

procedure TDynamicObject.ShowEffect(aEffectNumber: Word; aEffectKind:
   TLightEffectKind);
var
   SubData: TSubData;
begin
   BasicData.Feature.rEffectNumber := aEffectNumber;
   BasicData.Feature.rEffectKind := aEffectKind;

   SendLocalMessage(NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);

   BasicData.Feature.rEffectNumber := 0;
   BasicData.Feature.rEffectKind := lek_none;
end;

procedure TDynamicObject.ShowEffect2(aEffectNumber: Word; aEffectKind:
   TLightEffectKind; aDelay: Integer);
var
   SubData: TSubData;
begin
   SubData.EffectNumber := aEffectNumber;
   SubData.EffectKind := aEffectKind;
   SubData.Delay := aDelay;
   SendLocalMessage(NOTARGETPHONE, FM_SETEFFECT, BasicData, SubData);
end;

function TDynamicObject.FieldProc(hfu: Longint; Msg: word; var SenderInfo:
   TBasicData; var aSubData: TSubData): Integer;
var
   i, j, xx, yy, declife: Integer;
   tx, ty: Word;
   Sayer, Str, dummy1, dummy2, Ret: string;
   Code: Byte;
   percent: Integer;
   SubData: TSubData;
   ItemData: TItemData;
   CurTick, SkillLevel: Integer;
   BO, BO2: TBasicObject;
   Monster: TMonster;
   Npc: TNpc;
   boFlag: boolean;
   AttackSkill: TAttackSkill;
   aDis: Integer;
begin
   Result := PROC_FALSE;
   if isRangeMessage(hfu, Msg, SenderInfo) = FALSE then
      exit;
   Result := inherited FieldProc(hfu, Msg, Senderinfo, aSubData);
   if Result = PROC_TRUE then
      exit;

   case Msg of
      FM_CLICK:
         begin
            //2002-07-30 gil-tae
            if SOnLeftClick <> 0 then
            begin
               ScriptManager.CallEvent(Self, SenderInfo.P, SOnLeftClick,
                  'OnLeftClick', ['']);
               exit;
            end;
            //--------------------------
         end;
      FM_HEAL:
         begin
            if ObjectStatus <> dos_Closed then
               exit;

            CurLife := CurLife + aSubData.HitData.ToHit;
            if CurLife > SelfData.rBasicData.rLife then
               CurLife := SelfData.rBasicData.rLife;
            if CurLife > 0 then
            begin
               SubData.Percent := CurLife * 100 div SelfData.rBasicData.rLife;
               SendLocalMessage(NOTARGETPHONE, FM_LIFEPERCENT, BasicData,
                  SubData);
            end;
         end;
      FM_SAY:
         begin
            if ObjectStatus <> dos_Closed then
               exit;
            if (SelfData.rBasicData.rKind and DYNOBJ_EVENT_SAY) =
               DYNOBJ_EVENT_SAY then
            begin
               if SelfData.rBasicData.rEventSay = '' then
                  exit;
               Str := GetWordString(aSubData.SayString);
               if ReverseFormat(Str, '%s: ' + SelfData.rBasicData.rEventSay,
                  Sayer, dummy1, dummy2, 1) then
               begin
                  if SelfData.rBasicData.rSoundSpecial.rWavNumber > 0 then
                  begin
                     SetWordString(SubData.SayString,
                        IntToStr(SelfData.rBasicData.rSoundSpecial.rWavNumber) +
                        '.wav');
                     SendLocalMessage(NOTARGETPHONE, FM_SOUND, BasicData,
                        SubData);
                  end;

                  SetWordString(SubData.SayString, StrPas(@BasicData.ViewName) +
                     ': ' + SelfData.rBasicData.rEventAnswer);
                  SendLocalMessage(NOTARGETPHONE, FM_SAY, BasicData, SubData);
               end;
               exit;
            end;

            // for test;
            Str := GetWordString(aSubData.SayString);
            if SOnHear <> 0 then
            begin
               Str := GetValidStr3(Str, Sayer, ':');
               Str := GetValidStr3(Str, Sayer, ' ');
               ScriptManager.CallEvent(Self, SenderInfo.P, SOnHear, 'OnHear',
                  [Str]);
            end;
         end;
      FM_ADDITEM:
         begin
            if ObjectStatus <> dos_Closed then
               exit;
            if (SelfData.rBasicData.rKind and DYNOBJ_EVENT_ADDITEM) =
               DYNOBJ_EVENT_ADDITEM then
            begin
               if DragDropEvent.EventAddItem(StrPas(@aSubData.ItemData.rName),
                  SenderInfo) = true then
                  exit;

               if StrPas(@aSubData.ItemData.rName) <>
                  StrPas(@SelfData.rBasicData.rEventItem.rName) then
                  exit;
               Inc(EventItemCount);

               if EventItemCount >= SelfData.rBasicData.rEventItem.rCount then
               begin
                  if SelfData.rBasicData.rEventDropItem.rName[0] = 0 then
                  begin
                     if SelfData.rBasicData.rSoundEvent.rWavNumber > 0 then
                     begin
                        SetWordString(SubData.SayString,
                           IntToStr(SelfData.rBasicData.rSoundSpecial.rWavNumber) +
                           '.wav');
                        SendLocalMessage(NOTARGETPHONE, FM_SOUND, BasicData,
                           SubData);
                     end;
                     IncStep;
                  end
                  else
                  begin
                     BasicData.nX := BasicData.X;
                     BasicData.nY := BasicData.Y;

                     if SelfData.rBasicData.rSoundSpecial.rWavNumber > 0 then
                     begin
                        SetWordString(SubData.SayString,
                           IntToStr(SelfData.rBasicData.rSoundSpecial.rWavNumber) +
                           '.wav');
                        SendLocalMessage(NOTARGETPHONE, FM_SOUND, BasicData,
                           SubData);
                     end;
                     if ItemClass.GetCheckItemData(StrPas(@BasicData.Name),
                        SelfData.rBasicData.rEventDropItem, ItemData) = true then
                     begin
                        CurLife := CurLife + 1000;
                        ItemData.rCount :=
                           SelfData.rBasicData.rEventDropItem.rCount;
                        ItemData.rOwnerName[0] := 0;
                        SubData.ItemData := ItemData;
                        SubData.ServerId := ServerId;
                        Phone.SendMessage(MANAGERPHONE, FM_ADDITEM, BasicData,
                           SubData);
                     end;
                  end;
                  EventItemCount := 0;
               end;
               Move(aSubData.ItemData, SubData.ItemData, SizeOf(TItemData));
               SendLocalMessage(SenderInfo.ID, FM_DELITEM, BasicData, SubData);

               //giltae by 2002-07-19
               if SOnDropItem <> 0 then
               begin
                  ScriptManager.CallEvent(Self, SenderInfo.P, SOnDropItem,
                     'OnDropItem', [selfdata.rBasicData.rName]);
               end;
               //------------------------------------
            end;
         end;
      FM_WINDOFHAND:
         begin
            if ObjectStatus <> dos_Closed then
               exit;
            if isWindOfHandArea(SenderInfo.x, SenderInfo.y, aSubData.MinRange,
               aSubData.MaxRange, aDis) then
            begin
               if SOnHit <> 0 then
               begin
                  ScriptManager.CallEvent(Self, SenderInfo.P, SOnHit, 'OnHit',
                     ['']);
               end;
               //惯瓤矫埃拌魂.
               aSubData.Delay := aDis;
               AttackedMagicClass.AddWindOfHand(aSubData);
            end
            else
            begin
               TUser(SenderInfo.P).SendClass.SendChatMessage(Conv('不在有效距离之内打偏了'), SAY_COLOR_SYSTEM);
            end;
         end;
      FM_HIT, FM_CRITICAL:
         begin
            if SelfData.rBasicData.rboOnlyUseLongMagic = true then
               exit;

            if ObjectStatus <> dos_Closed then
               exit;
            if (SelfData.rBasicData.rKind and DYNOBJ_EVENT_HIT) =
               DYNOBJ_EVENT_HIT then
            begin
               if CheckGuardNearPos2(BasicData, SenderInfo.X, SenderInfo.Y,
                  SenderInfo.dir, tx, ty, aSubData.HitData.HitFunction) = true then
               begin
                  // if isHitedArea (SenderInfo.dir, SenderInfo.x, SenderInfo.y, aSubData.HitData.HitFunction, percent) then begin
                  BO := GetViewObjectByID(SenderInfo.ID);
                  if BO = nil then
                     exit;
                  if BO.BasicData.Feature.rRace <> RACE_HUMAN then
                     exit;
                  if StrPas(@BasicData.Name) = TUser(BO).EventTeam then
                     exit;

                  if SOnHit <> 0 then
                  begin
                     ScriptManager.CallEvent(Self, SenderInfo.P, SOnHit, 'OnHit',
                        ['']);
                  end;

                  if SelfData.rBasicData.rLife = CurLife then
                  begin
                     for i := 0 to 5 - 1 do
                     begin
                        if SelfData.rDropMop[i].rName[0] = 0 then
                           continue;
                        for j := 0 to SelfData.rDropMop[i].rCount - 1 do
                        begin
                           xx := BasicData.x;
                           yy := BasicData.y;
                           if (SelfData.rDropX <> 0) and (SelfData.rDropY <> 0)
                              then
                           begin
                              xx := SelfData.rDropX;
                              yy := SelfData.rDropY;
                           end
                           else
                           begin
                              Maper.GetMoveableXY(xx, yy, 10);
                           end;
                           if Maper.isMoveable(xx, yy) then
                           begin
                              Monster :=
                                 TMonsterList(Manager.MonsterList).CallMonster(Strpas(@SelfData.rDropMop[i].rName), xx, yy, 4, StrPas(@SenderInfo.Name));
                              if Monster <> nil then
                              begin
                                 AttackSkill := Monster.GetAttackSkill;
                                 if AttackSkill <> nil then
                                 begin
                                    AttackSkill.SetObjectBoss(Self);
                                 end;
                                 if MemberList = nil then
                                 begin
                                    MemberList := TList.Create;
                                 end;
                                 MemberList.Add(Monster);
                              end;
                           end;
                        end;
                     end;
                     for i := 0 to 5 - 1 do
                     begin
                        if SelfData.rCallNpc[i].rName[0] = 0 then
                           continue;
                        for j := 0 to SelfData.rCallNpc[i].rCount - 1 do
                        begin
                           xx := BasicData.x;
                           yy := BasicData.y;
                           if (SelfData.rDropX <> 0) and (SelfData.rDropY <> 0)
                              then
                           begin
                              xx := SelfData.rDropX;
                              yy := SelfData.rDropY;
                           end
                           else
                           begin
                              Maper.GetMoveableXY(xx, yy, 10);
                           end;
                           if Maper.isMoveable(xx, yy) then
                           begin
                              Npc :=
                                 TNpcList(Manager.NpcList).CallNpc(StrPas(@SelfData.rCallNpc[i].rName), xx, yy, 4, StrPas(@SenderInfo.Name));
                              if Npc <> nil then
                              begin
                                 AttackSkill := Npc.GetAttackSkill;
                                 if AttackSkill <> nil then
                                 begin
                                    AttackSkill.SetObjectBoss(Self);
                                 end;
                                 if MemberList = nil then
                                 begin
                                    MemberList := TList.Create;
                                 end;
                                 MemberList.Add(Npc);
                              end;
                           end;
                        end;
                     end;
                  end
                  else
                  begin
                     if MemberList <> nil then
                     begin
                        for i := 0 to MemberList.Count - 1 do
                        begin
                           BO2 := MemberList[i];
                           if BO2 <> nil then
                           begin
                              if BO2.BasicData.Feature.rRace = RACE_NPC then
                              begin
                                 AttackSkill := TNpc(BO2).GetAttackSkill;
                              end
                              else
                              begin
                                 AttackSkill := TMonster(BO2).GetAttackSkill;
                              end;
                              AttackSkill.SetDeadAttackName(StrPas(@SenderInfo.Name));
                           end;
                        end;
                     end;
                  end;

                  //CurLife := CurLife - aSubData.HitData.damageBody;
                  //2002-07-25 gil-tae
                  decLife := aSubData.HitData.damageBody - Armor;
                  if decLife < 0 then
                  begin
                     decLife := 1;
                  end;
                  CurLife := CurLife - decLife;
                  //-------------------

                  if CurLife < 0 then
                  begin
                     CurLife := 0;
                     if SOnDieBefore <> 0 then
                     begin
                        ScriptManager.CallEvent(Self, nil, SOnDieBefore,
                           'OnDieBefore', ['']);
                     end;
                  end;

                  if CurLife > 0 then
                  begin
                     SubData.Percent := CurLife * 100 div
                        SelfData.rBasicData.rLife;
                     SendLocalMessage(NOTARGETPHONE, FM_STRUCTED, BasicData,
                        SubData);
                  end;

                  if SelfData.rBasicData.rSoundSpecial.rWavNumber > 0 then
                  begin
                     SetWordString(SubData.SayString,
                        IntToStr(SelfData.rBasicData.rSoundSpecial.rWavNumber) +
                        '.wav');
                     SendLocalMessage(NOTARGETPHONE, FM_SOUND, BasicData,
                        SubData);
                  end;

                  if CurLife > 0 then
                     exit;

                  Code := EventClass.isDynObjDieEvent(StrPas(@BasicData.Name));
                  if Code > 0 then
                  begin
                     EventClass.RunDynObjDieEvent(Code);
                  end;

                  if SelfData.rNeedAge <> 0 then
                  begin
                     if TUser(BO).GetAge < SelfData.rNeedAge then
                     begin
                        TUser(BO).SendClass.SendChatMessage(format(Conv('%d岁以上方可开启'), [SelfData.rNeedAge]), SAY_COLOR_SYSTEM);
                        exit;
                     end;
                  end;
                  for i := 0 to 5 - 1 do
                  begin
                     if SelfData.rNeedSkill[i].rName[0] = 0 then
                        break;
                     SkillLevel :=
                        TUser(BO).FindHaveMagicByName(StrPas(@SelfData.rNeedSkill[i].rName));
                     if SelfData.rNeedSkill[i].rLevel > SkillLevel then
                     begin
                        TUser(BO).SendClass.SendChatMessage(format(Conv('%s修练值 %s 以上的人方可开启'), [StrPas(@SelfData.rNeedSkill[i].rName),
                           Get10000To100(SelfData.rNeedSkill[i].rLevel)]),
                           SAY_COLOR_SYSTEM);
                        exit;
                     end;
                  end;

                  for i := 0 to 5 - 1 do
                  begin
                     if SelfData.rNeedItem[i].rName[0] = 0 then
                        break;
                     ItemClass.GetItemData(StrPas(@SelfData.rNeedItem[i].rName),
                        ItemData);
                     if ItemData.rName[0] <> 0 then
                     begin
                        ItemData.rCount := SelfData.rNeedItem[i].rCount;
                        boFlag := TUser(BO).FindItem(@ItemData);
                        if boFlag = false then
                        begin
                           TUser(BO).SendClass.SendChatMessage(format(Conv('%s 物品需要 %d个'), [StrPas(@ItemData.rName), ItemData.rCount]), SAY_COLOR_SYSTEM);
                           exit;
                        end;
                     end;
                  end;

                  for i := 0 to 5 - 1 do
                  begin
                     if SelfData.rNeedItem[i].rName[0] = 0 then
                        break;
                     ItemClass.GetItemData(StrPas(@SelfData.rNeedItem[i].rName),
                        ItemData);
                     if ItemData.rName[0] <> 0 then
                     begin
                        ItemData.rCount := SelfData.rNeedItem[i].rCount;
                        TUser(BO).DeleteItem(@ItemData);
                     end;
                  end;

                  IncStep;

                  OpenedPosX := SenderInfo.X;
                  OpenedPosY := SenderInfo.Y;

                  xx := BasicData.nx;
                  yy := BasicData.ny;
                  BasicData.nx := SenderInfo.x;
                  BasicData.ny := SenderInfo.y;
                  for i := 0 to 5 - 1 do
                  begin
                     if SelfData.rGiveItem[i].rName[0] = 0 then
                        break;
                     ItemClass.GetChanceItemData(StrPas(@BasicData.Name),
                        StrPas(@SelfData.rGiveItem[i].rName), ItemData);
                     ItemData.rCount := SelfData.rGiveItem[i].rCount;
                     ItemData.rOwnerName[0] := 0;

                     SubData.ItemData := ItemData;
                     SubData.ServerId := ServerId;
                     if TFieldPhone(Manager.Phone).SendMessage(SenderInfo.id,
                        FM_ENOUGHSPACE, BasicData, SubData) = PROC_FALSE then
                     begin
                        Phone.SendMessage(MANAGERPHONE, FM_ADDITEM, BasicData,
                           SubData);
                     end
                     else
                     begin
                        TFieldPhone(Manager.Phone).SendMessage(SenderInfo.id,
                           FM_ADDITEM, BasicData, SubData);
                     end;
                  end;
                  BasicData.nx := xx;
                  BasicData.ny := yy;
               end;
            end;
         end;
      FM_BOW:
         begin
            if ObjectStatus <> dos_Closed then
               exit;

            if (aSubData.TargetId = Basicdata.id) or
               (isBowArea(SenderInfo.dir, aSubData.tx, aSubData.ty,
                  aSubData.HitData.HitFunction, percent)) then
            begin
               if (SelfData.rBasicData.rKind and DYNOBJ_EVENT_BOW) =
                  DYNOBJ_EVENT_BOW then
               begin
                  if SOnDanger <> 0 then
                  begin
                     Str := GetWordString(aSubData.SayString);
                     Ret := ScriptManager.CallEvent(Self, SenderInfo.P,
                        SOnDanger, 'OnDanger', [Str]);
                     if Ret = 'false' then
                        exit;
                  end;

                  if SOnBow <> 0 then
                  begin
                     Str := GetWordString(aSubData.SayString);
                     ScriptManager.CallEvent(Self, SenderInfo.P, SOnBow, 'OnBow',
                        [Str]);
                  end;

                  BO := GetViewObjectByID(SenderInfo.ID);
                  if BO = nil then
                     exit;
                  if BO.BasicData.Feature.rRace <> RACE_HUMAN then
                     exit;
                  if StrPas(@BasicData.Name) = TUser(BO).EventTeam then
                     exit;

                  if CurLife > 0 then
                  begin
                     decLife := aSubData.HitData.damageBody - Armor;
                     if decLife < 0 then
                     begin
                        decLife := 1;
                     end;

                     AddExpLink(SenderInfo.id, declife);
                     CurLife := CurLife - decLife;

                     if CurLife < 0 then
                     begin
                        CurLife := 0;
                        if SOnDieBefore <> 0 then
                        begin
                           ScriptManager.CallEvent(Self, nil, SOnDieBefore,
                              'OnDieBefore', ['']);
                        end;
                     end;

                     if CurLife > 0 then
                     begin
                        SubData.Percent := CurLife * 100 div
                           SelfData.rBasicData.rLife;
                        SendLocalMessage(NOTARGETPHONE, FM_STRUCTED, BasicData,
                           SubData);
                     end;

                     if SelfData.rBasicData.rSoundSpecial.rWavNumber > 0 then
                     begin
                        SetWordString(SubData.SayString,
                           IntToStr(SelfData.rBasicData.rSoundSpecial.rWavNumber) +
                           '.wav');
                        SendLocalMessage(NOTARGETPHONE, FM_SOUND, BasicData,
                           SubData);
                     end;

                     if CurLife > 0 then
                        exit;
                  end;

                  IncStep;

                  OpenedPosX := SenderInfo.X;
                  OpenedPosY := SenderInfo.Y;
               end;
            end;
         end;
   end;
end;

function TDynamicObject.GetArmor: integer;
begin
   Result := SelfData.rBasicData.rArmor;
end;

procedure TDynamicObject.Initial(pObjectData: PTCreateDynamicObjectData);
var
   i: Integer;
   rdStr: string;
   SStr, EStr: array[0..3 - 1] of string[20];
   pd: PTStepData;
begin
   inherited Initial(pObjectData^.rBasicData.rName,
      pObjectData^.rBasicData.rViewName);

   Move(pObjectData^, SelfData, sizeof(TCreateDynamicObjectData));

   for i := 0 to 3 - 1 do
   begin
      SStr[i] := pObjectData^.rBasicData.rSStep[i];
      EStr[i] := pObjectData^.rBasicData.rEStep[i];
   end;
   while SStr[0] <> '' do
   begin
      New(pd);
      FillChar(pd^, SizeOf(TStepData), 0);
      for i := 0 to 3 - 1 do
      begin
         SStr[i] := GetValidStr3(SStr[i], rdStr, ':');
         pd^.StartStep[i] := _StrToInt(rdStr);
         EStr[i] := GetValidStr3(EStr[i], rdStr, ':');
         pd^.EndStep[i] := _StrToInt(rdStr);
      end;
      FStepList.Add(pd);
   end;

   BasicData.id := GetNewDynamicObjectId;

   if pObjectData^.rBasicData.rboRandom = true then
   begin
      BasicData.x := pObjectData^.rx[0] - pObjectData^.rWidth +
         Random(pObjectData^.rWidth * 2);
      BasicData.y := pObjectData^.ry[0] - pObjectData^.rWidth +
         Random(pObjectData^.rWidth * 2);
   end
   else
   begin
      BasicData.x := pObjectData^.rx[0];
      BasicData.y := pObjectData^.ry[0];
   end;

   BasicData.ClassKind := CLASS_DYNOBJECT;
   BasicData.Feature.rrace := RACE_DYNAMICOBJECT;
   BasicData.Feature.rImageNumber := pObjectData^.rBasicData.rShape;

   ObjectStatus := dos_Closed;
   if FStepList.Count > 0 then
   begin
      pd := FStepList.Items[0];
      BasicData.nx := pd^.StartStep[byte(dos_Closed)];
      BasicData.ny := pd^.EndStep[byte(dos_Closed)];

      BasicData.Feature.rHitMotion := Byte(dos_Closed);
      if BasicData.nx <> BasicData.ny then
         BasicData.Feature.rHitMotion := Byte(dos_Openning);
   end;

   FboHaveGuardPos := TRUE;
   for i := 0 to 20 - 1 do
   begin
      BasicData.GuardX[i] := pObjectData^.rBasicData.rGuardX[i];
      BasicData.GuardY[i] := pObjectData^.rBasicData.rGuardY[i];
   end;

   CurLife := pObjectData^.rBasicData.rLife;

   if DragDropEvent = nil then
   begin
      DragDropEvent := TDragDropEvent.Create(Self);
   end;
end;

procedure TDynamicObject.StartProcess;
var
   SubData: TSubData;
   i, x, y, c, cmax: Integer;
begin
   cmax := 0;
   for i := 0 to 5 - 1 do
   begin
      if (SelfData.rX[i] = 0) and (SelfData.rY[i] = 0) then
      begin
         break;
      end;
      inc(cmax);
   end;

   if SelfData.rBasicData.rboRandom = true then
   begin
      x := SelfData.rx[0] - SelfData.rWidth + Random(SelfData.rWidth * 2);
      y := SelfData.ry[0] - SelfData.rWidth + Random(SelfData.rWidth * 2);
   end
   else
   begin
      c := Random(cmax);
      x := SelfData.rX[c];
      y := SelfData.rY[c];
      // if not TMaper(Manager.Maper).isMoveable (x, y) then exit;
   end;

   if SelfData.rBasicData.rEventType = DYNOBJ_TYPE_CHECKMOVE then
   begin
      for i := 0 to 10 - 1 do
      begin
         if Maper.isMoveable(x, y) = false then
         begin
            x := SelfData.rx[0] - SelfData.rWidth + Random(SelfData.rWidth * 2);
            y := SelfData.ry[0] - SelfData.rWidth + Random(SelfData.rWidth * 2);
         end
         else
            break;
      end;
   end;

   BasicData.X := x;
   BasicData.Y := y;

   inherited StartProcess;

   SubData.EffectNumber := 0;
   SubData.EffectKind := lek_none;
   Phone.RegisterUser(BasicData.id, FieldProc, BasicData.X, BasicData.Y);
   Phone.SendMessage(0, FM_CREATE, BasicData, SubData);

   if SelfData.rBasicData.rSoundStart.rWavNumber <> 0 then
   begin
      SetWordString(SubData.SayString,
         IntToStr(SelfData.rBasicData.rSoundStart.rWavNumber) + '.wav');
      SendLocalMessage(NOTARGETPHONE, FM_SOUND, BasicData, SubData);
   end;

   ClearExpLink;

   if SOnRegen <> 0 then
   begin
      ScriptManager.CallEvent(Self, nil, SOnRegen, 'OnRegen', ['']);
   end;
end;

procedure TDynamicObject.EndProcess;
var
   SubData: TSubData;
begin
   if FboRegisted = FALSE then
      exit;

   Phone.SendMessage(0, FM_DESTROY, BasicData, SubData);
   Phone.UnRegisterUser(BasicData.id, BasicData.x, BasicData.y);

   inherited EndProcess;
end;

procedure TDynamicObject.WorkBoxCommand(aCmd: Byte);
var
   pWorkParam, ptmpWorkParam: PTWorkParam;
   tmpUser: TUser;
begin
   case FWorkBox.WorkSet.Cmd of
      CMD_SAY:
         begin
            pWorkParam := FWorkBox.WorkSet.GetParam(0);
            SSay(pWorkParam^.sValue);
            WorkOver;
         end;
      CMD_SOUND:
         begin
            pWorkParam := FWorkBox.WorkSet.GetParam(0);
            //
         end;
      CMD_SENDCENTERMSG:
         begin
            pWorkParam := FWorkBox.WorkSet.GetParam(0);
            ptmpWorkParam := FWorkBox.WorkSet.GetParam(1);
            tmpUser := UserList.GetUserPointer(pWorkParam^.sValue);
            if tmpUser <> nil then
            begin
               tmpUser.SendClass.SendCenterMessage(ptmpWorkParam^.sValue);
            end;
         end;
   end;
end;

procedure TDynamicObject.Update(CurTick: integer);
var
   i, xx, yy: Integer;
   ItemData: TItemData;
   SubData: TSubData;
   pd: PTStepData;
   //   cnt : Integer;
begin
   inherited Update(CurTick);
   if FboAllowDelete = true then
      exit;
   if (FWorkBox.WorkState <> ws_ing) and (FWorkBox.WorkSet <> nil) then
   begin
      if FWorkBox.WorkSet.isTimeOver(CurTick) = true then
      begin
         FWorkBox.WorkState := ws_ing;
         WorkBoxCommand(FWorkBox.WorkSet.Cmd);
      end;
   end;

   if FboRegisted = true then
   begin
      try
         AttackedMagicClass.Update(CurTick);
      except
         frmMain.WriteLogInfo(format('TDynamicObject.Update Failed in AttackedMagicClass.Update (%s)', [StrPas(@BasicData.Name)]));
         FboAllowDelete := true;
         exit;
      end;

      if ObjectStatus = dos_Openned then
      begin
         if SelfData.rBasicData.rboRemove = true then
         begin
            if OpenedTick + SelfData.rBasicData.rOpennedInterval <= CurTick then
            begin
               xx := BasicData.nx;
               yy := BasicData.ny;
               BasicData.nx := OpenedPosX;
               BasicData.ny := OpenedPosY;
               //               cnt := 0;
               for i := 0 to 5 - 1 do
               begin
                  if SelfData.rDropItem[i].rName[0] = 0 then
                     break;
                  if ItemClass.GetCheckItemData(StrPas(@BasicData.Name),
                     SelfData.rDropItem[i], ItemData) = true then
                  begin
                     ItemData.rOwnerName[0] := 0;
                     SubData.ItemData := ItemData;
                     SubData.ServerId := ServerId;
                     Phone.SendMessage(MANAGERPHONE, FM_ADDITEM, BasicData,
                        SubData);
                     //                     inc (cnt);
                  end;
               end;
               BasicData.nx := xx;
               BasicData.ny := yy;

               if SelfData.rBasicData.rSoundDie.rWavNumber <> 0 then
               begin
                  SetWordString(SubData.SayString,
                     IntToStr(SelfData.rBasicData.rSoundDie.rWavNumber) + '.wav');
                  SendLocalMessage(NOTARGETPHONE, FM_SOUND, BasicData, SubData);
               end;

               if SelfData.rBasicData.rRegenInterval = 0 then
               begin
                  FboAllowDelete := true;
               end
               else
               begin
                  EndProcess;
               end;

               try
                  if SOnDie <> 0 then
                  begin
                     ScriptManager.CallEvent(Self, nil, SOnDie, 'OnDie', ['']);
                  end;
               except
                  frmMain.WriteLogInfo(format('script callevent except error - ondie (%s)', [Strpas(@BasicData.Name)]));
               end;
            end;
         end
         else
         begin
            if FStepList.Count <= 1 then
            begin
               if OpenedTick + SelfData.rBasicData.rOpennedInterval <= CurTick
                  then
               begin
                  {
                  FCurrentStep := 0;
                  CurLife := SelfData.rBasicData.rLife;
                  ObjectStatus := dos_Closed;
                  BasicData.Feature.rHitMotion := 1;
                  pd := FStepList.Items [FCurrentStep];
                  BasicData.nx := pd^.StartStep [byte(dos_Closed)];
                  BasicData.ny := pd^.EndStep [byte(dos_Closed)];
                  // BasicData.Feature.rHitMotion := Byte (dos_Closed);
                  // if BasicData.nx <> BasicData.ny then BasicData.Feature.rHitMotion := Byte (dos_Openning);
                  SendLocalMessage (NOTARGETPHONE, FM_CHANGESTATE, BasicData, SubData);
                  }
                  DecStep;
               end;
            end;
         end;
      end
      else
      begin
         if DragDropEvent <> nil then
         begin
            DragDropEvent.EventSay(CurTick);
         end;
      end;

      if FCurrentStep > 0 then
      begin
         if SelfData.rBasicData.rKeepInterval > 0 then
         begin
            if CurTick >= OpenedTick + SelfData.rBasicData.rKeepInterval then
            begin
               DecStep;
            end;
         end;
      end;
      if SelfData.rBasicData.rKind = DYNOBJ_EVENT_MOVETICK then
      begin
         if SelfData.rBasicData.rShowInterval > 0 then
         begin
            if OpenedTick + SelfData.rBasicData.rShowInterval <= CurTick then
            begin
               EndProcess;
               OpenedTick := CurTick;
            end;
         end;
      end;
   end
   else
   begin
      if (ObjectStatus <> dos_Closed) and (SelfData.rBasicData.rRegenInterval >
         0) then
      begin
         if OpenedTick + SelfData.rBasicData.rRegenInterval <= CurTick then
         begin
            //漂荐 纳捞胶俊 措茄 秦搬氓
            //咯快奔 吝汗 泅惑
            if SelfData.rBasicData.rboBlock = true then
            begin
               if not TMaper(Manager.Maper).isMoveable(BasicData.x, BasicData.y)
                  then
               begin
                  OpenedTick := CurTick;
                  exit;
               end;
            end;

            FCurrentStep := 0;
            CurLife := SelfData.rBasicData.rLife;
            ObjectStatus := dos_Closed;
            // BasicData.Feature.rHitMotion := 1;
            pd := FStepList.Items[FCurrentStep];
            BasicData.nx := pd^.StartStep[byte(dos_Closed)];
            BasicData.ny := pd^.EndStep[byte(dos_Closed)];
            BasicData.Feature.rHitMotion := Byte(dos_Closed);
            if BasicData.nx <> BasicData.ny then
               BasicData.Feature.rHitMotion := Byte(dos_Openning);

            StartProcess;
         end;
      end;
      if SelfData.rBasicData.rKind = DYNOBJ_EVENT_MOVETICK then
      begin
         if SelfData.rBasicData.rhideInterval > 0 then
         begin
            if OpenedTick + SelfData.rBasicData.rhideInterval <= CurTick then
            begin
               StartProcess;
               OpenedTick := CurTick;
            end;
         end;
      end;
   end;
end;

procedure TDynamicObject.SSay(aStr: string);
begin
   BocSay(aStr);
end;

procedure TDynamicObject.SChangeState(aState: Byte);
begin
   ObjectStatus := TDynamicObjectState(aState);
end;

function TDynamicObject.SGetLife: Integer;
begin
   Result := CurLife;
end;

procedure TDynamicObject.SetArmor(aArmor: Integer);
begin
   SelfData.rBasicData.rArmor := aArmor;
end;

procedure TDynamicObject.SetLife(aLife: Integer);
begin
   SelfData.rBasicData.rLife := aLife;
end;

procedure TDynamicObject.IncStep;
var
   pd: PTStepData;
   SubData: TSubData;
begin
   if FboRegisted = false then
      exit;
   if FCurrentStep >= FStepList.Count then
      exit;

   ObjectStatus := dos_Openned;
   BasicData.Feature.rHitMotion := 0;

   pd := FStepList.Items[FCurrentStep];
   BasicData.nx := pd^.StartStep[byte(dos_Openning)];
   BasicData.ny := pd^.EndStep[byte(dos_Openning)];
   // BasicData.Feature.rHitMotion := Byte (dos_Closed);
   // if BasicData.nx <> BasicData.ny then BasicData.Feature.rHitMotion := Byte (dos_Openning);

   SendLocalMessage(NOTARGETPHONE, FM_CHANGESTATE, BasicData, SubData);

   if (pd^.StartStep[byte(dos_Openned)] <> 0) and
   (pd^.EndStep[byte(dos_Openned)] <> 0) then
   begin
      ObjectStatus := dos_Openned;
      BasicData.Feature.rHitMotion := 1;
      BasicData.nx := pd^.StartStep[byte(dos_Openned)];
      BasicData.ny := pd^.EndStep[byte(dos_Openned)];
      // BasicData.Feature.rHitMotion := Byte (dos_Closed);
      // if BasicData.nx <> BasicData.ny then BasicData.Feature.rHitMotion := Byte (dos_Openning);
      SendLocalMessage(NOTARGETPHONE, FM_CHANGESTATE, BasicData, SubData);
   end;

   Inc(FCurrentStep);
   if FStepList.Count > FCurrentStep then
   begin
      ObjectStatus := dos_Closed;
      BasicData.Feature.rHitMotion := 1;
      pd := FStepList.Items[FCurrentStep];
      BasicData.nx := pd^.StartStep[byte(dos_Closed)];
      BasicData.ny := pd^.EndStep[byte(dos_Closed)];
      // BasicData.Feature.rHitMotion := Byte (dos_Closed);
      // if BasicData.nx <> BasicData.ny then BasicData.Feature.rHitMotion := Byte (dos_Openning);
      SendLocalMessage(NOTARGETPHONE, FM_CHANGESTATE, BasicData, SubData);
   end
   else
   begin
      if SelfData.rBasicData.rOpennedInterval = -1 then
      begin
         ObjectStatus := dos_Openning;
         BasicData.Feature.rHitMotion := 1;
         BasicData.nx := pd^.StartStep[byte(dos_Openning)];
         BasicData.ny := pd^.EndStep[byte(dos_Openning)];
      end
      else
      begin
         ObjectStatus := dos_Openned;
         CommandHit;
      end;

      if SelfData.rBasicData.rEffectColor > 0 then
      begin
         ShowEffect2(SelfData.rBasicData.rEffectColor, lek_follow, 0);
      end;

      if SOnTurnOn <> 0 then
      begin
         ScriptManager.CallEvent(Self, nil, SOnTurnOn, 'OnTurnOn', ['']);
      end;
   end;

   SubData.motion := FCurrentStep;
   SendLocalMessage(NOTARGETPHONE, FM_CHANGESTEP, BasicData, SubData);

   OpenedTick := mmAnsTick;
end;

procedure TDynamicObject.DecStep;
var
   pd: PTStepData;
   SubData: TSubData;
begin
   if FboRegisted = false then
      exit;
   if FCurrentStep = 0 then
      exit;

   if FCurrentStep = FStepList.Count then
   begin
      if SOnTurnOff <> 0 then
      begin
         ScriptManager.CallEvent(Self, nil, SOnTurnOff, 'OnTurnOff', ['']);
      end;
   end;

   Dec(FCurrentStep);
   ObjectStatus := dos_Closed;
   BasicData.Feature.rHitMotion := 1;
   pd := FStepList.Items[FCurrentStep];
   BasicData.nx := pd^.StartStep[byte(dos_Closed)];
   BasicData.ny := pd^.EndStep[byte(dos_Closed)];
   // BasicData.Feature.rHitMotion := Byte (dos_Closed);
   // if BasicData.nx <> BasicData.ny then BasicData.Feature.rHitMotion := Byte (dos_Openning);

   SendLocalMessage(NOTARGETPHONE, FM_CHANGESTATE, BasicData, SubData);

   SubData.motion := FCurrentStep;
   SendLocalMessage(NOTARGETPHONE, FM_CHANGESTEP, BasicData, SubData);

   OpenedTick := mmAnsTick;
end;

procedure TDynamicObject.SSendZoneEffectMessage(aName: string);
begin
   ZoneEffectList.SendMsgZoneEffectObject(aName);
end;

procedure TDynamicObject.SShowEffect(aEffectNumber: Integer; aEffectKind:
   Integer);
begin
   ShowEffect2(aEffectNumber, TLightEffectKind(aEffectKind), 0);
end;

////////////////////////////////////////////////////
//
//             ===  DynamicObjectList  ===
//
////////////////////////////////////////////////////

constructor TDynamicObjectList.Create(aManager: TManager);
begin
   inherited Create('DYNAMICOBJECT', aManager);

   ReLoadFromFile;
end;

destructor TDynamicObjectList.Destroy;
begin
   inherited Destroy;
end;

procedure TDynamicObjectList.ReLoadFromFile;
var
   i: integer;
   FileName: string;
   DynamicObject: TDynamicObject;
   CreateDynamicObjectList: TList;
   pd: PTCreateDynamicObjectData;
begin
   Clear;

   FileName := format('.\Setting\CreateDynamicObject%d.SDB',
      [Manager.ServerID]);
   if not FileExists(FileName) then
      exit;

   CreateDynamicObjectList := TList.Create;
   LoadCreateDynamicObject(FileName, CreateDynamicObjectList);

   for i := 0 to CreateDynamicObjectList.Count - 1 do
   begin
      pd := CreateDynamicObjectList[i];

      DynamicObject := TDynamicObject.Create;
      DynamicObject.SetManagerClass(Manager);
      if pd^.rScript > 0 then
         DynamicObject.SetScript(pd^.rScript);
      DynamicObject.Initial(pd);
      if pd^.rboDelay = false then
         DynamicObject.StartProcess;
      DataList.Add(DynamicObject);
   end;

   for i := 0 to CreateDynamicObjectList.Count - 1 do
   begin
      pd := CreateDynamicObjectList.Items[i];
      Dispose(pd);
   end;
   CreateDynamicObjectList.Clear;
   CreateDynamicObjectList.free;
end;

function TDynamicObjectList.AddDynamicObject(pObjectData:
   PTCreateDynamicObjectData): integer;
var
   DynamicObject: TDynamicObject;
begin
   //   Result := PROC_FALSE;

   DynamicObject := TDynamicObject.Create;
   DynamicObject.SetManagerClass(Manager);
   if pObjectData^.rScript > 0 then
      DynamicObject.SetScript(pObjectData^.rScript);
   DynamicObject.Initial(pObjectData);
   DynamicObject.StartProcess;
   DataList.Add(DynamicObject);

   Result := PROC_TRUE;
end;

function TDynamicObjectList.DeleteDynamicObject(aName: string): Boolean;
var
   i: Integer;
   DynamicObject: TDynamicObject;
begin
   Result := false;
   for i := 0 to DataList.Count - 1 do
   begin
      DynamicObject := DataList.Items[i];
      if DynamicObject.SelfData.rBasicData.rName = aName then
      begin
         DynamicObject.FboAllowDelete := true;
         Result := true;
         exit;
      end;
   end;
end;

function TDynamicObjectList.FindDynamicObject(aName: string): Integer;
var
   i, iCount: Integer;
   DynamicObject: TDynamicObject;
begin
   iCount := 0;
   for i := 0 to DataList.Count - 1 do
   begin
      DynamicObject := DataList.Items[i];
      if DynamicObject.SelfData.rBasicData.rName = aName then
      begin
         Inc(iCount);
      end;
   end;

   Result := iCount;
end;

procedure TDynamicObjectList.SearchDynamicObject(aName: string; var
   aDynamicObject: TDynamicObject);
var
   DynObj: TdynamicObject;
   i: Integer;
begin
   aDynamicObject := nil;

   for i := 0 to DataList.Count - 1 do
   begin
      DynObj := DataList.Items[i];
      if DynObj.SelfData.rBasicData.rName = aName then
      begin
         aDynamicObject := DynObj;
         exit;
      end;
   end;
end;

procedure TDynamicObjectList.ChangeStep(aName: string; aboInc: Boolean);
var
   i: Integer;
   DynamicObject: TDynamicObject;
begin
   for i := 0 to DataList.Count - 1 do
   begin
      DynamicObject := DataList.Items[i];
      if DynamicObject.SelfData.rBasicData.rName = aName then
      begin
         if aboInc = true then
         begin
            DynamicObject.IncStep;
         end
         else
         begin
            DynamicObject.DecStep;
         end;
      end;
   end;
end;

function TDynamicObjectList.GetDynamicObjects(aName: string; aList: TList):
   Integer;
var
   i, iCount: Integer;
   DynamicObject: TDynamicObject;
begin
   iCount := 0;
   for i := 0 to DataList.Count - 1 do
   begin
      DynamicObject := DataList.Items[i];
      if DynamicObject.SelfData.rBasicData.rName = aName then
      begin
         aList.Add(DynamicObject);
         Inc(iCount);
      end;
   end;
   //if iCount = 0 then begin
   //   FrmMain.WriteLogInfo (aName + ' Not Found' );
   //   exit;
   //end;

   Result := iCount;
end;

function TDynamicObjectList.GetDynamicObjectbyName(aName: string):
   TDynamicObject;
var
   i: Integer;
   DynamicObject: TDynamicObject;
begin
   Result := nil;

   for i := 0 to DataList.Count - 1 do
   begin
      DynamicObject := DataList.Items[i];
      if DynamicObject.SelfData.rBasicData.rName = aName then
      begin
         if DynamicObject.boRegisted = true then
         begin
            Result := DynamicObject;
            exit;
         end;
      end;
   end;
end;

function TDynamicObjectList.GetDynPosStr: string;
var
   i: Integer;
   dyn: TDynamicObject;
   Str: string;
begin
   Str := '';
   for i := 0 to DataList.Count - 1 do
   begin
      dyn := DataList.Items[i];
      if dyn.SelfData.rBasicData.rboMinimapShow = true then
      begin
         if Str <> '' then
            Str := Str + ',';
         Str := Str + format('%s:%d:%d:%d', [StrPas(@dyn.BasicData.ViewName),
            dyn.BasicData.X, dyn.BasicData.Y, 64512]);
      end;
   end;

   Result := Str;
end;

procedure TDynamicObjectList.RegenByName(aName: string);
var
   i: Integer;
   DynamicObject: TDynamicObject;
begin
   for i := 0 to DataList.Count - 1 do
   begin
      DynamicObject := DataList.Items[i];
      if StrPas(@DynamicObject.BasicData.Name) = aName then
      begin
         if DynamicObject.FboRegisted = false then
         begin
            DynamicObject.Regen;
         end;
      end;
   end;
end;

////////////////////////////////////////////////////
// TVirtualObject
////////////////////////////////////////////////////

constructor TVirtualObject.Create(pObjectData: PTCreateVirtualObjectData);
begin
   inherited Create;
   Move(pObjectData^, SelfData, sizeof(TCreateVirtualObjectData));
end;

destructor TVirtualObject.Destroy;
begin
   inherited Destroy;
end;

procedure TVirtualObject.Initial;
var
   StrName: string;
begin
   StrName := StrPas(@SelfData.rName);
   inherited Initial(StrName, StrName);

   BasicData.id := GetNewItemId;
   BasicData.x := SelfData.rX;
   BasicData.y := SelfData.rY;
   BasicData.ClassKind := CLASS_SERVEROBJ;
   BasicData.Feature.rrace := RACE_ITEM;
   BasicData.Feature.rImageNumber := 0;
   BasicData.Feature.rImageColorIndex := 0;
end;

procedure TVirtualObject.StartProcess;
var
   SubData: TSubData;
begin
   inherited StartProcess;

   SubData.EffectNumber := 0;
   SubData.EffectKind := lek_none;
   Phone.RegisterUser(BasicData.id, FieldProc, BasicData.X, BasicData.Y);
   Phone.SendMessage(0, FM_CREATE, BasicData, SubData);
end;

procedure TVirtualObject.EndProcess;
var
   SubData: TSubData;
begin
   Phone.SendMessage(0, FM_DESTROY, BasicData, SubData);
   Phone.UnRegisterUser(BasicData.id, BasicData.x, BasicData.y);

   inherited EndProcess;
end;

procedure TVirtualObject.Update(CurTick: Integer);
begin
   inherited Update(CurTick);
end;

function TVirtualObject.IsNearPos(var SenderInfo: TBasicData; var SubData:
   TSubData): Boolean;
var
   x, y: integer;
   dx, dy: integer;
begin
   Result := false;
   x := SubData.tx;
   y := SubData.ty;

   if SelfData.rX > x then
      dx := SelfData.rX - x
   else
      dx := x - SelfData.rX;

   if SelfData.rY > y then
      dy := SelfData.rY - y
   else
      dy := y - SelfData.rY;

   if (dx < SelfData.rWidth) and (dy < SelfData.rHeight) then
   begin
      Result := true;
   end;
end;

function TVirtualObject.FieldProc(hfu: Longint; Msg: word; var SenderInfo:
   TBasicData; var aSubData: TSubData): Integer;
begin
   Result := PROC_FALSE;

   if isRangeMessage(hfu, Msg, SenderInfo) = FALSE then
      exit;
   Result := inherited FieldProc(hfu, Msg, Senderinfo, aSubData);
   if Result = PROC_TRUE then
      exit;

   case Msg of
      FM_CLICK:
         begin
            //            boFlag := IsNearPos (SenderInfo,aSubData);
            //            if boFlag = true then begin
            if SelfData.rKind = VIRTUALOBJ_KIND_OASIS then
            begin
               SendLocalMessage(SenderInfo.id, FM_CHANGEDURAWATERCASE,
                  BasicData, aSubData);
            end
            else if SelfData.rKind = VIRTUALOBJ_KIND_FILLLIFE then
            begin
               aSubData.ShoutColor := SelfData.rLife;
                  // 檬焊付阑 距荐磐 劝仿 盲况林绰 蔼
               aSubData.SpellType := VIRTUALOBJ_KIND_NONE; // 檬扁拳
               SendLocalMessage(SenderInfo.id, FM_FILLLIFE, BasicData,
                  aSubData);
            end
            else if SelfData.rKind = VIRTUALOBJ_KIND_FILLOASISLIFE then
            begin
               SendLocalMessage(SenderInfo.id, FM_CHANGEDURAWATERCASE,
                  BasicData, aSubData);
               aSubData.ShoutColor := SelfData.rLife;
               aSubData.SpellType := VIRTUALOBJ_KIND_FILLOASISLIFE;
                  // kind俊 蝶扼辑 劝仿盲况林绰 沥档啊 崔扼咙
               SendLocalMessage(SenderInfo.id, FM_FILLLIFE, BasicData,
                  aSubData);
            end;
            //            end;
         end;
   else
      begin
      end;
   end;
end;

////////////////////////////////////////////////////
// TVirtualObjectList
////////////////////////////////////////////////////

constructor TVirtualObjectList.Create(aManager: TManager);
begin
   inherited Create('VIRTUALOBJECT', aManager);

   ReLoadFromFile;
end;

destructor TVirtualObjectList.Destroy;
begin
   Clear;

   inherited Destroy;
end;

procedure TVirtualObjectList.ReLoadFromFile;
var
   i: Integer;
   FileName, iName: string;
   VirtualObject: TVirtualObject;
   ObjectData: TCreateVirtualObjectData;
   DB: TUserStringDB;
begin
   Clear;

   FileName := format('.\Setting\CreateVirtualObject%d.sdb',
      [Manager.ServerId]);
   if FileExists(FileName) then
   begin
      DB := TUserStringDB.Create;
      DB.LoadFromFile(FileName);

      for i := 0 to DB.Count - 1 do
      begin
         iName := DB.GetIndexName(i);
         if iName = '' then
            continue;

         FillChar(ObjectData, SizeOf(TCreateVirtualObjectData), 0);

         StrPCopy(@ObjectData.rName, iName);
         ObjectData.rX := DB.GetFieldValueInteger(iName, 'X');
         ObjectData.rY := DB.GetFieldValueInteger(iName, 'Y');
         ObjectData.rWidth := DB.GetFieldValueInteger(iName, 'Width');
         ObjectData.rHeight := DB.GetFieldValueInteger(iName, 'Height');
         ObjectData.rKind := DB.GetFieldValueInteger(iName, 'Kind');
         ObjectData.rLife := DB.GetFieldValueInteger(iName, 'Life');

         VirtualObject := TVirtualObject.Create(@ObjectData);
         VirtualObject.SetManagerClass(Manager);
         VirtualObject.Initial;
         VirtualObject.StartProcess;

         DataList.Add(VirtualObject);
      end;
      DB.Free;
   end;
end;

procedure TVirtualObjectList.SendFMMessage(var SenderInfo: TBasicData; var
   SubData: TSubData);
var
   i: integer;
   VirtualObject: TVirtualObject;
   boFlag: Boolean;
begin
   for i := 0 to DataList.Count - 1 do
   begin
      VirtualObject := DataList.Items[i];
      boFlag := VirtualObject.IsNearPos(SenderInfo, SubData);
      if boFlag = false then
         continue;

      VirtualObject.SendLocalMessage(VirtualObject.BasicData.id, FM_CLICK,
         SenderInfo, SubData);
   end;
end;

////////////////////////////////////////////////////
// TMineObject
////////////////////////////////////////////////////

constructor TMineObject.Create;
begin
   FCheckedTick := 0;

   inherited Create;
end;

destructor TMineObject.Destroy;
begin
   inherited Destroy;
end;

function TMineObject.FieldProc(hfu: Longint; Msg: word; var SenderInfo:
   TBasicData; var aSubData: TSubData): Integer;
var
   i, j, nPos, nRandom: Integer;
   xx, yy: Word;
   Str, ToolName: string;
   SubData: TSubData;
begin
   Result := PROC_FALSE;
   if isRangeMessage(hfu, Msg, SenderInfo) = FALSE then
      exit;
   Result := inherited FieldProc(hfu, Msg, Senderinfo, aSubData);
   if Result = PROC_TRUE then
      exit;

   case Msg of
      FM_CLICK:
         begin
            if hfu = BasicData.ID then
            begin
               //               SetWordString (aSubData.SayString, format ('%s <%d>', [StrPas (@BasicData.ViewName), FDeposit]));
            end;
         end;
      FM_PICK:
         begin
            if FActive = false then
               exit;
            if Manager.boPick = false then
               exit;

            if CheckGuardNearPos(BasicData, SenderInfo.X, SenderInfo.Y,
               SenderInfo.dir, xx, yy) = true then
            begin
               if FDeposit <= 0 then
               begin
                  SetWordString(SubData.SayString, Conv('无法开采'));
                  SendLocalMessage(SenderInfo.ID, FM_SAYSYSTEM, BasicData,
                     SubData);
                  exit;
               end;
               //Author:Steven Date: 2005-02-02 13:14:49
               //Note:采集技能
               //SubData.ExpData.ExpType := SGetExtJobKind;
               //SubData.ExpData.Exp := SGetExtJobExp;
               //========================================
               SubData.HitData.PickConst := FPickConst;
               SendLocalMessage(SenderInfo.ID, FM_ADDMINEAMOUNT, BasicData,
                  SubData);
            end;
         end;
      FM_DECDEPOSIT:
         begin
            if FActive = false then
               exit;
            if Manager.boPick = false then
               exit;
            if FDeposit <= 0 then
               exit;

            ToolName := GetWordString(aSubData.SayString);
            Str := FMineObjectName + ToolName;

            //Author:Steven Date: 2005-02-03 14:06:43
            //Note:采集技能
            if aSubData.ExpData.ExpType <> 1 then
               aSubData.ExpData.Exp := 0;
            //======================================
            //要将角色的经验值传递进去 aSubData.ExpData.Exp 为角色采集技能的经验值
            nPos := MineObjectClass.ChoiceMineItemPos(Str,
               aSubData.ExpData.Exp);
            if (nPos >= 0) and (nPos < 10) then
            begin
               Str := FAvailItems[nPos];
               ItemClass.GetItemData(Str, aSubData.ItemData);
            end else begin
               FillChar(aSubData,SizeOf(aSubData),0);
            end;

            //Author:Steven Date: 2005-01-31 15:57:47
            //Note:采集技能
            //现在aSubData.ExpData.Exp的经验值为采集到物品的经验值
            SubData.ExpData.ExpType := aSubData.ExpData.ExpType;
            SubData.ExpData.Exp := aSubData.ItemData.rExtJobExp;
            SendLocalMessage(SenderInfo.ID, FM_ADDMINEREXP, BasicData, SubData);
            //========================================

            Dec(FDeposit);
            if FDeposit <= 0 then
            begin
               FDeposit := 0;
               StrPCopy(@BasicData.Name, '');
               StrPCopy(@BasicData.ViewName, '');
               BocChangeProperty;

               FRegenInterval := FRegenIntervals[Random(3)];
               FRegenedTick := mmAnsTick;

               for i := 0 to 5 - 1 do
               begin
                  if FDropMop[i].rName[0] = 0 then
                     break;
                  for j := 0 to FDropMop[i].rCount - 1 do
                  begin
                     nRandom := Random(3);
                     TMonsterList(Manager.MonsterList).MakeMonster(StrPas(@FDropMop[i].rName), BasicData.x + nRandom, BasicData.y + nRandom, 4, 0, false);
                  end;
               end;

               // MineObjectClass.ReturnChance (FGroupName, FPositionName);
            end;
         end;
   end;
end;

function TMineObject.ReInitial: Boolean;
var
   i: Integer;
   pd: PTMineObjectData;
begin
   Result := false;

   FMineObjectName := '';
   FActive := false;
   FPickConst := 0;
   FDeposit := 0;
   for i := 0 to 10 - 1 do
   begin
      FAvailItems[i] := '';
   end;
   for i := 0 to 3 - 1 do
   begin
      FRegenIntervals[i] := 0;
   end;
   FRegenedTick := 0;
   FRegenInterval := 0;
   FCheckedTick := 0;

   if MineObjectClass.GetBuildChance(FGroupName, FPositionName) = true then
   begin
      FMineObjectName := MineObjectClass.ChoiceMineObjectName(FGroupName);
      if FMineObjectName <> '' then
      begin
         pd := MineObjectClass.GetMineObjectData(FMineObjectName);
         if pd <> nil then
         begin
            FActive := true;
            StrPCopy(@BasicData.Name, FMineObjectName);
            StrCopy(@BasicData.ViewName, @pd^.rViewName);
            BocChangeProperty;

            FPickConst := pd^.rPickConst;
            FDeposit := pd^.rDeposits[Random(5)];

            for i := 0 to 10 - 1 do
            begin
               FAvailItems[i] := StrPas(@pd^.rAvailItems[i]);
            end;
            for i := 0 to 3 - 1 do
            begin
               FRegenIntervals[i] := pd^.rRegenIntervals[i];
            end;
            for i := 0 to 5 - 1 do
            begin
               FDropMop[i] := pd^.rDropMop[i];
            end;

            Result := true;
         end;
      end;
   end;
end;

procedure TMineObject.Initial(aPositionName, aGroupName: string; aX, aY, aShape:
   Word);
var
   i: Integer;
   pd: PTMineObjectShapeData;
begin
   FPositionName := aPositionName;
   FGroupName := aGroupName;
   FMineObjectName := '';
   FShape := aShape;
   FRegenedTick := 0;
   FRegenInterval := 0;
   FCheckedTick := 0;

   inherited Initial('', '');

   BasicData.id := GetNewDynamicObjectId;
   BasicData.x := aX;
   BasicData.y := aY;
   BasicData.ClassKind := CLASS_MINEOBJECT;
   BasicData.Feature.rrace := RACE_DYNAMICOBJECT;
   BasicData.Feature.rImageNumber := FShape;
   BasicData.Feature.rHitMotion := 1;
   BasicData.nx := 0;
   BasicData.ny := 0;

   pd := MineObjectClass.GetMineObjectShapeData(FShape);
   if pd <> nil then
   begin
      BasicData.nx := pd^.rSStep;
      BasicData.ny := pd^.rEStep;
      BasicData.Feature.rHitMotion := Byte(dos_Closed);
      if BasicData.nx <> BasicData.ny then
         BasicData.Feature.rHitMotion := Byte(dos_Openning);

      for i := 0 to 10 - 1 do
      begin
         if (pd^.rGuardX[i] = 0) and (pd^.rGuardY[i] = 0) then
            break;
         BasicData.GuardX[i] := pd^.rGuardX[i];
         BasicData.GuardY[i] := pd^.rGuardY[i];
      end;
   end;
end;

procedure TMineObject.StartProcess;
var
   SubData: TSubData;
begin
   ReInitial;

   inherited StartProcess;

   SubData.EffectNumber := 0;
   SubData.EffectKind := lek_none;
   Phone.RegisterUser(BasicData.id, FieldProc, BasicData.X, BasicData.Y);
   Phone.SendMessage(0, FM_CREATE, BasicData, SubData);
end;

procedure TMineObject.EndProcess;
var
   SubData: TSubData;
begin
   if FboRegisted = FALSE then
      exit;

   Phone.SendMessage(0, FM_DESTROY, BasicData, SubData);
   Phone.UnRegisterUser(BasicData.id, BasicData.x, BasicData.y);

   inherited EndProcess;
end;

procedure TMineObject.Update(CurTick: integer);
begin
   if FboRegisted = true then
   begin
      if (FActive = true) and (FRegenInterval > 0) then
      begin
         if CurTick >= FRegenedTick + FRegenInterval then
         begin
            FActive := false;
            FCheckedTick := CurTick;
            MineObjectClass.ReturnChance(FGroupName, FPositionName);
         end;
         exit;
      end;
      if FActive = false then
      begin
         if CurTick >= FCheckedTick + 500 then
         begin
            ReInitial;
            FCheckedTick := CurTick;
            exit;
         end;
      end;
   end;
end;

////////////////////////////////////////////////////
// TMineObjectList
////////////////////////////////////////////////////

constructor TMineObjectList.Create(aManager: TManager);
begin
   inherited Create('MINEOBJECT', aManager);

   ReLoadFromFile;
end;

destructor TMineObjectList.Destroy;
begin
   Clear;

   inherited Destroy;
end;

procedure TMineObjectList.ReLoadFromFile;
var
   i: Integer;
   FileName, iName, gName: string;
   MineObject: TMineObject;
   pd: PTCreateMineObjectData;
   DB: TUserStringDB;
   CreateList: TList;
begin
   Clear;

   MineObjectClass.ClearSettingPos(Manager.ServerID);

   FileName := format('.\Setting\CreateMineObject%d.sdb', [Manager.ServerId]);
   if FileExists(FileName) then
   begin
      DB := TUserStringDB.Create;
      DB.LoadFromFile(FileName);

      gName := '';
      CreateList := TList.Create;
      for i := 0 to DB.Count - 1 do
      begin
         iName := DB.GetIndexName(i);
         if iName = '' then
            continue;

         New(pd);
         FillChar(pd^, SizeOf(TCreateMineObjectData), 0);

         StrPCopy(@pd^.rName, iName);
         StrPCopy(@pd^.rGroupName, DB.GetFieldValueString(iName, 'GroupName'));
         pd^.rShape := DB.GetFieldValueInteger(iName, 'Shape');
         pd^.rX := DB.GetFieldValueInteger(iName, 'X');
         pd^.rY := DB.GetFieldValueInteger(iName, 'Y');

         MineObjectClass.AddSettingPos(StrPas(@pd^.rGroupName),
            StrPas(@pd^.rName));
         if (gName <> '') and (StrPas(@pd^.rGroupName) <> gName) then
         begin
            MineObjectClass.InitPosition(gName);
         end;
         gName := StrPas(@pd^.rGroupName);

         CreateList.Add(pd);
      end;
      if gName <> '' then
         MineObjectClass.InitPosition(gName);

      for i := 0 to CreateList.Count - 1 do
      begin
         pd := CreateList.Items[i];
         MineObject := TMineObject.Create;
         MineObject.SetManagerClass(Manager);
         MineObject.Initial(StrPas(@pd^.rName), StrPas(@pd^.rGroupName), pd^.rX,
            pd^.rY, pd^.rShape);
         MineObject.StartProcess;
         DataList.Add(MineObject);
      end;

      for i := 0 to CreateList.Count - 1 do
      begin
         pd := CreateList.Items[i];
         Dispose(pd);
      end;
      CreateList.Free;
      DB.Free;
   end;
end;

function TMineObjectList.GetReportStr: string;
var
   i: integer;
   Str: string;
   MineObject: TMineObject;
begin
   Result := '';

   if DataList.Count = 0 then
      exit;

   Str := '[MineObjectList]' + #13;
   for i := DataList.Count - 1 downto 0 do
   begin
      MineObject := DataList.Items[i];
      if MineObject.FActive = true then
      begin
         Str := Str + format('%s (%d,%d) Deposit(%d)',
            [StrPas(@MineObject.BasicData.Name), MineObject.BasicData.X,
            MineObject.BasicData.Y, MineObject.FDeposit]);
         if (i mod 2) = 0 then
            Str := Str + ' '
         else
            Str := Str + #13;
      end;
   end;
   Result := Str;
end;

/////////////////////////////////////////
//  TGroupMoveObject
/////////////////////////////////////////

constructor TGroupMoveObject.Create;
begin
   inherited Create;

   FillChar(SelfData, SizeOf(TCreateGroupMoveData), 0);
   AddItemCount := 0;
   // FillChar (AddItemUserIDArr, SizeOf (AddItemUserIDArr), 0);
   ObjectStatus := dos_closed;
   PosStrList := TStringList.Create;
end;

destructor TGroupMoveObject.Destroy;
begin
   PosStrList.Clear;
   PosStrList.Free;

   inherited Destroy;
end;

procedure TGroupMoveObject.Initial;
begin
   inherited Initial(SelfData.Name, SelfData.ViewName);

   BasicData.id := GetNewDynamicObjectId;
   BasicData.x := SelfData.X;
   BasicData.y := SelfData.Y;
   BasicData.ClassKind := CLASS_DYNOBJECT;
   BasicData.Feature.rrace := RACE_DYNAMICOBJECT;
   BasicData.Feature.rImageNumber := SelfData.Shape;

   ObjectStatus := dos_closed;
   // BasicData.Feature.rhitmotion := 1;

   BasicData.nx := SelfData.SStep;
   BasicData.ny := SelfData.EStep;
   BasicData.Feature.rHitMotion := Byte(dos_Closed);
   if BasicData.nx <> BasicData.ny then
      BasicData.Feature.rHitMotion := Byte(dos_Openning);
end;

procedure TGroupMoveObject.StartProcess;
var
   SubData: TSubData;
begin
   BasicData.X := SelfData.X;
   BasicData.Y := SelfData.Y;

   inherited StartProcess;

   SubData.EffectNumber := 0;
   SubData.EffectKind := lek_none;
   Phone.RegisterUser(BasicData.id, FieldProc, BasicData.X, BasicData.Y);
   Phone.SendMessage(0, FM_CREATE, BasicData, SubData);
end;

procedure TGroupMoveObject.EndProcess;
var
   SubData: TSubData;
begin
   Phone.SendMessage(0, FM_DESTROY, BasicData, SubData);
   Phone.UnRegisterUser(BasicData.id, BasicData.x, BasicData.y);

   inherited EndProcess;
end;

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

procedure TGroupMoveObject.Update(CurTick: Integer);
begin
end;

function TGroupMoveObject.GetSelfData: PTCreateGroupMoveData;
begin
   Result := @SelfData;
end;

////////////////////////////////////////////////////
//
//             ===  GroupMoveObjectList  ===
//
////////////////////////////////////////////////////

constructor TGroupMoveList.Create;
begin
   inherited Create('GROUPMOVE', nil);

   LoadFromFile('.\Setting\CreateGroupMove.SDB');
end;

destructor TGroupMoveList.Destroy;
begin
   Clear;

   inherited Destroy;
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

/////////////////////////////////
// TAttackedMagicClass
/////////////////////////////////

constructor TAttackedMagicClass.Create(aBasicObject: TBasicObject);
begin
   FBasicObject := aBasicObject;

   FillChar(FAttackedMagicArr, sizeof(FAttackedMagicArr), 0);
end;

destructor TAttackedMagicClass.Destroy;
begin
   Clear;
   inherited;
end;

procedure TAttackedMagicClass.Clear;
begin
   FillChar(FAttackedMagicArr, sizeof(FAttackedMagicArr), 0);
end;

procedure TAttackedMagicClass.Update(CurTick: Integer);
var
   i: Integer;
begin
   for i := 0 to ATTACKEDMAGICSIZE - 1 do
   begin
      if FBasicObject.boRegisted = false then
         exit;
      if FBasicObject.boAllowDelete = true then
         exit;
      if FBasicObject.State = wfs_die then
         exit;

      if (FAttackedMagicArr[i].rProcessTick > 0) and (CurTick >=
         FAttackedMagicArr[i].rProcessTick + FAttackedMagicArr[i].rDelay) then
      begin
         case FBasicObject.BasicData.Feature.rRace of
            RACE_HUMAN:
               begin
                  TUser(FBasicObject).CommandAttackedMagic(FAttackedMagicArr[i].rData);
               end;
            RACE_DYNAMICOBJECT:
               begin
                  if TDynamicObject(FBasicObject).ObjectStatus <> dos_Closed
                     then
                     exit;

                  TDynamicObject(FBasicObject).CommandAttackedMagic(FAttackedMagicArr[i].rData);
               end;
            RACE_MONSTER, RACE_NPC:
               begin
                  try
                     TLifeObject(FBasicObject).CommandAttackedMagic(FAttackedMagicArr[i].rData);
                  except
                     FBasicObject.FboAllowDelete := true;
                     frmMain.WriteLogInfo(format('CommandAttackedMagic Except Error(%s)', [StrPas(@FBasicObject.BasicData.Name)]));
                  end;
               end;
         end;
         FillChar(FAttackedMagicArr[i], sizeof(TAttackedMagic), 0);
      end;
   end;
end;

function TAttackedMagicClass.AddWindOfHand(var aSubData: TSubData): Boolean;
var
   i, nPos: Integer;
begin
   Result := false;

   nPos := -1;
   for i := 0 to ATTACKEDMAGICSIZE - 1 do
   begin
      if FAttackedMagicArr[i].rProcessTick = 0 then
      begin
         nPos := i;
         break;
      end;
   end;

   if nPos = -1 then
      exit;

   with FAttackedMagicArr[nPos] do
   begin
      rProcessTick := mmAnsTick;
      rDelay := aSubData.Delay;
      rData.rMagicType := aSubData.HitData.MagicType;
      rData.rMagicRelation := aSubData.HitData.MagicRelation;
      rData.rConsumeEnergy := aSubData.HitData.CosumeEnergy;
      rData.rGroupKey := aSubData.HitData.GroupKey;
      rData.rAttacker := aSubData.attacker;
      rData.rRace := aSubData.HitData.Race;
      rData.rHitType := aSubData.HitData.HitType;

      StrPCopy(@rData.rSayString, GetWordString(aSubData.SayString));

      rData.rEffectNumber := aSubData.EffectNumber;
      rData.rDamageBody := aSubData.HitData.damageBody;
      rData.rDamageArm := aSubData.HitData.damageArm;
      rData.rDamageHead := aSubData.HitData.damageHead;
      rData.rDamageLeg := aSubData.HitData.damageLeg;
      rData.rDamageExp := aSubData.HitData.damageExp;
   end;
end;

procedure SignToItem(var aItemData: TItemData; aServerID: Integer; var
   aBasicData: TBasicData; aIP: string);
begin
   if aItemData.rName[0] > 0 then
   begin
      aItemData.rOwnerRace := aBasicData.Feature.rrace;
      aItemData.rOwnerServerID := aServerID;
      if aBasicData.Feature.rRace <> RACE_HUMAN then
      begin
         StrPCopy(@aItemData.rOwnerName, '@');
         StrCopy(@aItemData.rOwnerName[1], @aBasicData.Name);
         StrPCopy(@aItemData.rOwnerIP, '');
      end
      else
      begin
         StrCopy(@aItemData.rOwnerName, @aBasicData.Name);
         StrPCopy(@aItemData.rOwnerIP, aIP);
      end;
      aItemData.rOwnerX := aBasicData.x;
      aItemData.rOwnerY := aBasicData.y;
      StrPCopy(@aItemData.rOwnerIP, aIP);
   end;
end;

function TBasicObject.SGetExtJobLevel: Integer;
begin
   Result := 0;
end;

function TBasicObject.SSetExtJobExp(aExp: Integer): Integer;
begin
   Result := 0;
end;

function TBasicObject.SGetExtJobExp: Integer;
begin
   Result := 0;
end;

function TBasicObject.SGetExtJobKind: Byte;
begin
   Result := 0;
end;

procedure TBasicObject.SSetExtJobKind(AValue: Byte);
begin
   //..
end;

end.

