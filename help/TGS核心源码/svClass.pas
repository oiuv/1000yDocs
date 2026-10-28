unit svClass;
 
interface

uses
  Windows, SysUtils, Classes, Usersdb, adeftype, Deftype, AnsImg2, AUtil32,
  uSendcls, uAnstick, uLevelexp, IniFiles, SubUtil, AnsStringCls, uKeyClass,
  uUtil, Dialogs, uDBRecordDef;

const
   AREA_NONE            = 0;
   AREA_CANMAKEGUILD    = 1;
   MAX_ADDATTRIB_SIZE   = 100;
   ADDATTRIBTABLE_SIZE  = 20;
   CURRENT_CYCLE_MAXNUM = 3;

   // 犬厘公傍 quest蔼甸
   QUEST_NONE           = 0;
   QUEST_BEGINNERPRIZE  = 1;   // 檬焊磊焊惑
   QUEST_PRIZE1         = 2;   // 老馆焊惑 1瞒
   QUEST_PRIZE2         = 3;   // 老馆焊惑 2瞒
   QUEST_GOLDCOIN       = 4;   // 陛拳焊惑
   QUEST_PICKAX         = 5;   // 邦豹捞焊惑
   QUEST_ATTRIBUTEPIECE = 6;   // 加己菩焊惑
   QUEST_WEAPON         = 7;   // 公扁焊惑

type
   TSkillAddDamageData = record
      rdamagebody: integer;
      rdamagehead: integer;
      rdamagearm: integer;
      rdamageleg: integer;
   end;

   TSkillAddPalmDamageData = record
      rdamagebody: integer;
      rdamagehead: integer;
      rdamagearm: integer;
      rdamageleg: integer;
      rlongavoid: integer;
   end;

   TRandomData = record
      rItemName : String;
      rObjName : String;
      rIndex : Integer;
      rCurIndex : Integer;
      rCount : Integer;
   end;
   PTRandomData = ^TRandomData;

   TRandomClass = class
   private
      DataList : TList;
   public
      constructor Create;
      destructor Destroy; override;

      procedure Clear;
      procedure AddData (aItemName, aObjName : String; aCount : Integer);
      function  GetChance (aItemName, aObjName : String) : Boolean;
//      procedure SaveToFile (str : String); //颇老疙 : ItemIndexLog.txt
   end;

   // 2000.10.05 眠啊规绢仿 备炼眉 by Lee.S.G
   TSkillAddArmorData = record
      rarmorbody: integer;
      rarmorhead: integer;
      rarmorarm: integer;
      rarmorleg: integer;
   end;

   TPowerLevelData = record
      Name : String [20];
      PowerValue : Integer;
      Damage : Integer;
      Armor : Integer;
      AttackSpeed : Integer;
      Recovery : Integer;
      Avoid : Integer;
      Accuracy : Integer;
      KeepRecovery : Integer;
      LimitEnergy : Integer;
   end;

   TJobGradeData = record
      Name : String [20];
      StartLevel : Integer;
      EndLevel : Integer;
      MaxItemGrade : Integer;
      Grade : array [0..10 - 1] of Integer;
      //Author:Steven Date: 2005-01-31 01:32:57
      //Note:
      Miner_SExp: Integer;
      Miner_EExp: Integer;
      Miner_SLevel: Integer;
      Miner_ELevel: Integer;
      //================================
   end;
   PTJobGradeData = ^TJobGradeData;

   TJobUpgradeData = record
      UpgradeStep : Word;
      SuccessRate : Integer;
      DungeonRate : Integer;
      DamageBody : Integer;
      DamageHead : Integer;
      DamageArm : Integer;
      DamageLeg : Integer;
      ArmorBody : Integer;
      ArmorHead : Integer;
      ArmorArm : Integer;
      ArmorLeg : Integer;
      AttackSpeed : Integer;
      Avoid : Integer;
      Recovery : Integer;
      Accuracy : Integer;
      KeepRecovery : Integer;
   end;
   PTJobUpgradeData = ^TJobUpgradeData;

   TMaterialData = record
      ItemName : String;
      Material : String;
   end;
   PTMaterialData = ^TMaterialData;

   TConsumeData = record
      rStartSkill : Integer;
      rEndSkill : Integer;
      rCosumeValue : Integer;
   end;
   PTConsumeData = ^TConsumeData;

   TMagicCycleClass = class
   private
      DataLists : array [0..CURRENT_CYCLE_MAXNUM - 1] of TList;
      Cycles : array [0..CURRENT_CYCLE_MAXNUM - 1] of TStringKeyClass;
      FNeedStatePoint : array [0..3 - 1] of integer;      

//      EnergyDataList : TList;
//      EnergyKeyClass : TStringKeyClass;

      StateDataList : Tlist;
      StateKeyClass : TStringKeyClass;

      procedure Clear;
      function GetNeedStatePoint (idx: integer): integer;
   public
      constructor Create;
      destructor Destroy;override;
      procedure ReLoadFromFile;
      procedure GetData(aMagicName : string; aGrade: Byte; var aMagicData : TMagicData);
      procedure GetStateDataofBestMagic (pMagicData : PTMagicData);
      procedure GetEnergyPointData (pMagicData : PTMagicData);
      property NeedStatePoint[idx:integer] : integer read GetNeedStatePoint;
   end;

   TMagicClass = class
   private
     MagicDb               : TUserStringDb;
     MagicForGuildDb       : TUserStringDb;
     DataList              : TList;
     KeyClass              : TStringKeyClass;
     SkillAddDamageArr     : array [0..10000] of TSkillAddDamageData;
     SkillAddArmorArr      : array [0..10000] of TSkillAddArmorData; // 眠啊规绢仿
     SkillAddPalmDamageArr : array [0..10000] of TSkillAddPalmDamageData; //厘过傍拜仿
     SkillConsumeEnergyArr : array [0..10] of TConsumeData; //俊呈瘤 家葛樊 皑家.
//     EnergyLimitArr        : array [0..20 - 1] of Integer; //盔扁炼例俊 蝶弗 汲沥摹

     AM_WHRelationTable : array [0..7 - 1, 0..6 - 1] of Integer;
     PowerLevelArr : array [0..100] of TPowerLevelData;
     procedure Clear;
     function  LoadMagicData (aMagicName: string; var MagicData: TMagicData; aDb: TUserStringDb): Boolean;
     function  LoadMagicDataForGuild (aMagicName: string; var MagicData: TMagicData; aDb: TUserStringDb): Boolean;

     function GetCount : Integer;     
   public
     constructor Create;
     destructor Destroy; override;
     procedure ReLoadFromFile;

     function  GetValueFromRelationTable (aWH, aAM : Integer): Integer;
     function  GetSkillConsumeEnergy (aEnergy: integer): integer;
     function  GetSkillDamageBody (askill: integer): integer;
     function  GetSkillDamageBodyForPalm (askill: integer): integer;
     function  GetSkillLongAvoidForPalm (askill: integer): integer;
     function  GetSkillDamageHead (askill: integer): integer;
     function  GetSkillDamageArm  (askill: integer): integer;
     function  GetSkillDamageLeg  (askill: integer): integer;

     function  GetSkillArmorBody (askill: integer): integer;
     function  GetSkillArmorHead (askill: integer): integer;
     function  GetSkillArmorArm  (askill: integer): integer;
     function  GetSkillArmorLeg  (askill: integer): integer;

     function  GetPowerLevelName (aLevel : Integer) : String;
     function  GetPowerLevelValue (aLevel : Integer) : Integer;
     function  CalcPowerLevel (aValue : Integer) : Integer;
     function  GetPowerLevelDamage (aLevel : Integer) : Integer;
     function  GetPowerLevelArmor (aLevel : Integer) : Integer;
     function  GetPowerLevelAttackSpeed (aLevel : Integer) : Integer;
     function  GetPowerLevelRecovery (aLevel : Integer) : Integer;
     function  GetPowerLevelAvoid (aLevel : Integer) : Integer;
     function  GetPowerLevelAccuracy (aLevel : Integer) : Integer;
     function  GetPowerLevelKeepRecovery (aLevel : Integer) : Integer;
     function  GetPowerLevelLimitEnergy (aLevel : Integer): Integer;

     procedure Calculate_cLifeData (pMagicData: PTMagicData);

     function GetMagicData (aMagicName: string; var MagicData: TMagicData; aexp: integer): Boolean;
     function GetHaveMagicData (astr: string; var MagicData: TMagicData): Boolean;
     function GetHaveBestMagicData (astr: string; var MagicData: TMagicData): Boolean;//new 2003-09-22
     function GetHaveMagicString (var MagicData: TMagicData): string;
     function GetHaveBestMagicString (var MagicData: TMagicData): string;

     function CheckMagicData (var MagicData: TMagicData; var aRetStr : String) : Boolean;

     procedure CompactGuildMagic;
     function AddGuildMagic (var aMagicData : TMagicData; aGuildName : String) : Boolean;
   end;

   TMagicParamClass = class
   private
     DataList : TList;
     KeyClass : TStringKeyClass;

     procedure Clear;
   public
     constructor Create;
     destructor Destroy; override;

     function LoadFromFile (aFileName : String) : Boolean;
     function GetMagicParamData (aObjectName, aMagicName : String; var aMagicParamData: TMagicParamData): Boolean;
   end;

   TItemClass = class
   private
     FDataList : TList;
     FKeyClass : TStringKeyClass;

     FSmeltList : TList;
     FSmeltList2 : TList;  // 犁丰背券

     FAddValue : Integer;
     AddAttribList : array [0..ADDATTRIBTABLE_SIZE-1] of TList;
     
     procedure Clear;
     // function  LoadItemData (aItemName: string; var ItemData: TItemData): Boolean;
   public
     constructor Create;
     destructor Destroy; override;

     procedure ReLoadFromFile;

     function GetItemData (aItemName: string; var ItemData: TItemData): Boolean;
     function GetSmeltItemData (aItemName : String; var SmeltItemData : TSmeltItemData) : Boolean;
     function GetSmeltItemData2 (aItemName : String; var SmeltItemData : TSmeltItemData) : Boolean;
     function GetCheckItemData (aObjName : String; aCheckItem : TCheckItem; var ItemData: TItemData): Boolean;
     function GetWearItemData (astr: string; var ItemData: TItemData): Boolean;
     function GetMarketItemData (astr: string; var ItemData: TItemData): Boolean;
     function GetChanceItemData (aStr, aObjName : string; var ItemData: TItemData): Boolean;
     function GetWearItemString (var ItemData: TItemData): string;
     function GetMarketItemString (var ItemData: TItemData): string;
     function GetAddItemAttribData (var ItemData : TItemData): Boolean;     
//     function CreateItem (aItemName : String; var ItemData : TItemData) : Boolean;
   end;

   // 惑怕 函拳甫 爱绰 酒捞袍甸俊 措茄 努贰胶 空釜狼 巩, 惑磊 etc
   TDynamicObjectClass = class
   private
      // DynamicItemDb : TUserStringDb;
      DataList : TList;
      KeyClass : TStringKeyClass;

      procedure   Clear;
   public
      constructor Create;
      destructor  Destroy; override;
      procedure   LoadFromFile (aName : String);

      function    GetDynamicObjectData (aObjectName: String; var aObjectData: TDynamicObjectData): Boolean;
   end;

   TMineObjectClass = class
   private
      FDataList : TList;
      FShapeList : TList;
      FAvailList : TList;
      FToolRateList : TList;
   public
      constructor Create;
      destructor Destroy; override;

      procedure Clear;
      procedure LoadFromFile;

      procedure InitPosition (aGroupName : String);
      procedure ClearSettingPos (aMapID : Word);
      procedure AddSettingPos (aGroupName : String; aName : String);

      function GetMineObjectData (aObjectName : String) : PTMineObjectData;
      function GetMineObjectShapeData (aShape : Word) : PTMineObjectShapeData;
      function GetPositionCount (aGroupName : String) : Word;

      function GetBuildChance (aGroupName : String; aPositionName : String) : Boolean;
      procedure ReturnChance (aGroupName : String; aPositionName : String);
      function ChoiceMineObjectName (aGroupName : String) : String;
      function ChoiceMineItemPos (aName : String; aExp: Integer) : Integer;
   end;

   {
   THerbObjectClass = class
   private
      FDataList : TList;
      FGroupList : TList;

      PickConst : array [0..HERB_YEAR_MAX - 1] of Integer;
      HerbValue : array [0..HERB_YEAR_MAX - 1] of Integer;
   public
      constructor Create;
      destructor Destroy; override;
      
      procedure Clear;
      procedure LoadFromFile;

      function GetRandomHerbName : String;
      function GetHerbObjectData (aObjectName : String) : PTHerbObjectData;
      function GetPickConst (aYear : Integer) : Integer;
      function GetHerbValue (aYear : Integer) : Integer;

      procedure AddGroup (aName : String; aCount : Integer);
      function GetChanceInGroup (aGroupIndex, aPrivateIndex : Word) : Boolean;
   end;
   }

   TItemDrugClass = class
   private
     FDataList : TList;
     FKeyClass : TStringKeyClass;

     procedure Clear;
   public
     constructor Create;
     destructor Destroy; override;

     procedure ReLoadFromFile;
     
     function  GetItemDrugData (aItemDrugName: string; var ItemDrugData: TItemDrugData): Boolean;
   end;

   TItemMaterialClass = class
   private
      DataList : TList;
      MaterialSlot : TStringList;
      
      AlchemistKeyClass : TStringKeyClass;
      ChemistKeyClass : TStringKeyClass;
      DesignerKeyClass : TStringKeyClass;
      CraftsmanKeyClass : TStringKeyClass;
      AllKeyClass : TStringKeyClass;

      procedure Clear;
   public
      constructor Create;
      destructor Destroy; override;

      procedure AllMakeItem (aItemName, aMaterialName : String); 
      procedure PushStr (aKind : byte; aItemName, aMaterialName : String);
      function GetAllMakeMaterialData (aMaterialStr : String) : String;
      function GetMakeMaterialData (aJobKind : byte; aMaterialStr : String) : String;
   end;

   TJobClass = class
   private
      JobGradeData : array [0..JOB_GRADE_MAX - 1] of TJobGradeData;
      JobTalentData : array [0..ITEM_GRADE_MAX - 1] of Integer;
      JobUpgradeData : array [0..ITEM_UPGRADE_MAX - 1] of TJobUpgradeData;
      
      AlchemistTool : array [0..JOB_GRADE_MAX - 1] of String;
      ChemistTool : array [0..JOB_GRADE_MAX - 1] of String;
      DesignerTool : array [0..JOB_GRADE_MAX - 1] of String;
      CraftsmanTool : array [0..JOB_GRADE_MAX - 1] of String;

      procedure Clear;
   public
      constructor Create;
      destructor Destroy; override;

      function LoadFromFile : Boolean;
      function GetJobGrade (aLevel : Integer) : Byte;
      function GetJobGradeData (aJobGrade : Byte; var aJobGradeData : TJobGradeData) : Boolean;
      function GetItemGradeMaxTalent (aItemGrade : Word) : Integer;
      function GetItemUpgradeSuccessRate (aStep : Word) : Integer;
      function GetItemUpgradeDungeonRate (aStep : Word) : Integer;      
      function GetUpgradeData (aStep : Word; var aJobUpgradeData : TJobUpgradeData) : Boolean;
      function GetUpgradeItemLifeData (var aItemData : TItemData) : Boolean;
      function GetJobTool (aJobKind, aJobGrade : Byte) : String;

      //Author:Steven Date: 2005-01-31 17:33:38
      //Note:采集技能
      function GetExtJobLevel(aExp: Integer): Integer;
      function GetExtJobGradeName(aExp: Integer): String;
   end;

   TMonsterClass = class
   private
     MonsterDb : TUserStringDb;
     DataList : TList;
     KeyClass : TStringKeyClass;
     
     procedure Clear;
     function  LoadMonsterData (aMonsterName: string; var MonsterData: TMonsterData): Boolean;
   public
     constructor Create;
     destructor Destroy; override;
     procedure ReLoadFromFile;
     function GetMonsterData (aMonsterName: string; var pMonsterData: PTMonsterData): Boolean;
   end;

   TNpcClass = class
   private
     NpcDb : TUserStringDb;
     DataList : TList;
     KeyClass : TStringKeyClass;
     
     procedure Clear;
     function  LoadNpcData (aNpcName: string; var NpcData: TNpcData): Boolean;
   public
     constructor Create;
     destructor Destroy; override;
     procedure ReLoadFromFile;
     function GetNpcData (aNpcName: string; var pNpcData: PTNpcData): Boolean;
   end;

   TSysopClass = class
   private
     SysopDb : TUserStringDb;
   public
     constructor Create;
     destructor Destroy; override;
     procedure  ReLoadFromFile;
     function   GetSysopScope (aName: string): integer;
   end;

   TPosByDieClass = class
   private
      DataList : TList;
      procedure Clear;
   public
      constructor Create;
      destructor Destroy; override;

      procedure ReLoadFromFile;
      function GetPosByDieData (aServerID : Integer; var aDestServerID : Integer; var aDestX, aDestY : Word) : Boolean;
   end;

   TQuestClass = class
   private
      function CheckQuest1 (aServerID : Integer; var aRetStr : String) : Boolean;
      function CheckQuest2 (aUser : Pointer; var aRetStr : String) : Boolean;
      function CheckQuest3 (aUser : Pointer; var aRetStr : String) : Boolean;      
   public
      constructor Create;
      destructor Destroy; override;

      function GetQuestString (aQuest : Integer) : String;

      function CheckQuestComplete (aQuest, aServerID : Integer; aUser : Pointer; var aRetStr : String) : Boolean;
   end;

   //2002-08-06 giltae
   TQuestSummaryClass = class
   private
      FDataList : TList;

      procedure LoadFromFile (aFileName : String);
      procedure MakeQuestLogWindow (var aData : TQuestSummaryData);
      function GetMainQuestTitle (aQuestNum: integer) : String;
      function GetSubQuestTitle (aQuestNum: integer) : String;
      function GetRequest (aQuestNum: integer) : String;
      function GetDesc (aQuestNum: integer) : String;
   public
      constructor Create;
      destructor Destroy; override;
      procedure Clear;
      procedure ReLoadFromFile;

      property Items[ idx : integer] : String read GetDesc;
   end;
   //--------------------------------------


   TAreaClass = class
   private
      DataList : TList;
      function  GetCount: integer;
   public
      constructor Create;
      destructor  Destroy; override;

      procedure   Clear;
      procedure   LoadFromFile (aFileName : String);

      function    CanMakeGuild (aIndex : Byte) : Boolean;
      function    GetAreaName (aIndex : Byte) : String;
      function    GetAreaDesc (aIndex : Byte) : String;

      property    Count : integer read GetCount;
   end;

   TPrisonData = record
      rUserName : String;
      rPrisonTime : Integer;
      rElaspedTime : Integer;
      rPrisonType : String;
      rReason : String;
   end;
   PTPrisonData = ^TPrisonData;

   TPrisonClass = class
   private
      DataList : TList;
      SaveTick : Integer;

      function GetPrisonTime (aType : String) : Integer;
      function GetPrisonData (aName : String) : PTPrisonData;
   public
      constructor Create;
      destructor Destroy; override;

      procedure Clear;

      function LoadFromFile (aFileName : String) : Boolean;
      function SaveToFile (aFileName : String) : Boolean;

      function AddUser (aName, aType, aReason : String) : String;
      function DelUser (aName : String) : String;
      function UpdateUser (aName, aType, aReason : String) : String;
      function PlusUser (aName, aType, aReason : String) : String;
      function EditUser (aName, aTime, aReason : String) : String;

      function GetUserStatus (aName : String) : String;
      function IncreaseElaspedTime (aName : String; aTime : Integer) : Integer;
      procedure Update (CurTick : Integer);
   end;

   TNpcFunction = class
   private
      DataList : TList;
   public
      constructor Create;
      destructor Destroy; override;

      procedure Clear;

      procedure LoadFromFile (aFileName : String);
      
      function GetFunction (aIndex : Integer) : PTNpcFunctionData;
   end;

   TSystemAlert = class
   private
      boGameAgree : Boolean;
      Information : TStringList;
   public
      constructor Create;
      destructor Destroy; override;

      procedure Clear;
      procedure LoadFromFile;

      procedure Alert (aUser : Pointer);
   end;

   THelpFiles = class
   private
      FDataList : TList;


      procedure Clear;
   public
      constructor Create;
      destructor Destroy; override;
      function FindFile (aFileName : string) : String;
      procedure LoadHelpFiles;
   end;

   TReportInfo = record
      rMacroUser : array [0..20-1] of Byte;
      rReportuser : array [0..20-1] of Byte;
      rTime : array [0..50-1] of Byte;
   end;

   PTReportInfo = ^TReportInfo;

   TMacroReport = class
   private
      FList : TList;
      FMaxListCount : Integer;
      

      function GetCount : Integer;
      function GetReport : String;
      function GetMacroUser : String;
   public
      constructor Create;
      destructor Destroy;override;
      function AddUser (aUserName,aReporterName : string) : Boolean;
      function DelUser (aUserName : string) : Boolean;
      function DelFirst : Boolean;
      procedure Clear;
      property Count : Integer read GetCount;
      property MacroUser : String read GetMacroUser;
      property Report : String read GetReport;
   end;

   TQuizSystem = class
   private
      FActive     : Boolean;
      FQuestion   : String;
      FAnswer     : String;
      FPresentName: String;
      FPresentCnt : Integer;
      function GetPresentation : String;
   public
      constructor Create;
      destructor Destroy; override;

      procedure SetPresent (aItemName : String; aCount : Integer);
      procedure SetAnswer (aAnswer : String);
      procedure SetQuestion (aQuestion : String);
      
      property Active : Boolean read FActive write FActive;
      property Question : String read FQuestion;
      property Answer : String read FAnswer;
      property Presentation : String read GetPresentation;
      property PresentName : String read FPresentName;
      property Count : Integer read FPresentCnt;
   end;

   TProbabilityData = record
      rLowestValue : Integer;
      rLowerValue : Integer;
      rNormalValue : Integer;
      rHigherValue : Integer;
      rHighestValue : Integer;
   end;
   PTProbabilityData = ^TProbabilityData;
   
   TAttribGradeData = record
      rMaxRange : Integer;
      rAttribItemCount : Integer;
   end;
   PTAttribGradeData = ^TAttribGradeData;
   
   TAddAttribClass = class
   private
      FDataList : TList;
      GradeData : array [1..10] of TAttribGradeData;

      procedure Clear;
   public
      constructor Create;
      destructor Destroy;override;
      procedure LoadFromFile;

      function GetRange (iGrade : Integer) : Integer;
      function GetNeedItemCount (iGrade : Integer) : Integer;
      function GetAddTypeNum (aMaxRange, aWorth : Integer) : Integer;
      //function
   end;

   //2003-08-29 Event Code : 捞亥飘惑前府胶飘俊辑 漂沥 箭磊俊 秦寸窍绰 惑前 搬沥
   TEventItemData = record
      rItemName : TNameString;
      rItemCount : integer;
      rMin : integer;
      rMax : integer;
   end;
   PTEventItemData = ^TEventItemData;
   
   TEventItemClass = class
   private
      FDataLists : array [0..4-1] of TList;
      FMaxRangeValues : array [0..4-1] of integer;

      procedure Clear;
      function GetMaxRangeValue(idx : integer): integer;
   public
      constructor Create;
      destructor Destroy;override;
      procedure LoadFromFile;

      procedure GetEventItem(iNum : integer; var aItemName :String; var aItemCount: integer);
      property MAX_RANGE[idx :integer] : integer read GetMaxRangeValue;
   end;

   TTransMonsterListClass = class
   private
      FDataList : TList;

      procedure Clear;
   public
      constructor Create;
      destructor Destroy;override;
      procedure LoadFromFile;

      procedure GetRandomMonsterName(var aMonsterName :string);
   end;

   TBattleMap = class
   private
      FMapid : Integer;
      FPosX, FPosY : Word;
      FGroupKey : Integer;
      FMaxUser : Integer;
      FDynName : String;
      FTargetID : Integer;
      FTargetX, FTargetY : Word;
      FDieX, FDieY : Word;
      FGuildName : String;
      FMopName : String;

      FJoinUserCount : Integer;

//      JoinUserList : TList;

//      function GetJoinUserCount : Integer;
   public
      constructor Create;
      destructor Destroy; override;

//      procedure JoinUserChatMessage (aStr : String; aColor : Integer);
//      procedure JoinUserSetActionState (aActionState : TActionState);
//      procedure PutItembyDynName (aItemName : String);

      property MapID : Integer read FMapid;
      property PosX : Word read FPosX;
      property PosY : Word read FPosY;
      property GroupKey : Integer read FGroupKey;
      property MaxUser : Integer read FMaxUser;
      property DynName : String read FDynName;
      property MopName : String read FMopName;
      property JoinUserCount : Integer read FJoinUserCount write FJoinUsercount;
   end;

   TBattleMapList = class
   private
      DataList : TList;
   public
      Position1, Position2 : TBattleMap;

      constructor Create;
      destructor Destroy; override;

      procedure Clear;
      procedure LoadFromFile (aFileName : String);

      procedure SetBattleMapData (aMapID : Integer);
      function DevideUser (aMapID : Integer) : TBattleMap;
      function CheckSameJoinCount : Boolean;
      function GetPositionbyGuildName (aGuildName : String) : TBattleMap;
//      procedure JoinUserChatMessage (aStr : String; aColor : Integer);
//      procedure JoinUserSetActionState (aActionState : TActionState);
//      procedure PutItemAndGetOut (aDynName, aItemName : String; aServerID, aTargetID, aTargetX, aTargetY : Integer);
      procedure GetDiePositionbyDynName (aDynName : String; var aX, aY : Word);
      procedure GetDiePositionbyGuildName (aGuildName : String; var aX, aY : Word);      
   end;

   TRandomEventItem = class
   private
      ItemName : String;
      ItemCount : Integer;
      TotalRandomCount : Integer;
      MaxValue : Integer;
      Kind : Byte;
   public
      constructor Create;
      destructor Destroy; override;
   end;

   TRandomEventItemList = class
   private
      DataList : array [0..3 - 1] of TList;
      BeginnerQuestList : TList;
      QuestList1, QuestList2 : TList;
      GoldCoinList : TList;
      PickAxList : TList;
      AttributePieceList : TList;
      WeaponList : TList;

      procedure Clear;
   public
      constructor Create;
      destructor Destroy; override;

      procedure LoadFromFile;

      function GetItemNamebyRandom (aListNo : Integer) : String;
      function GetQuestItembyRandom (aKind : Byte) : String;
   end;

   TNameData = record
      rGuildName : string[25];
      rCharName : string[25];
      rUserType : Integer;
   end;
   PTNameData = ^TNameData;

   TNameClass = class
   private
      NameDataList : TList;

      function GetCount : Integer;
      procedure Clear;
   public
      constructor Create;
      destructor Destroy; override;

      procedure ReLoadFromFile;
      function  SearchNameList (aGuildName, aCharName : String) : Boolean;
//      function SearchNameList (aGuildName, aCharName : String; var aUserType : integer) : Boolean;
      function DelNameList (aGuildName, aCharName : String) : Boolean;
      property Count : Integer read GetCount;
   end;

  // add by Orber at 2005-01-27 17:27:03
   TMarryClass = class
   private
      FMarryList : TList;
      procedure Clear;
   public
      constructor Create;
      destructor Destroy;override;
      function Search(aName :String):PTMarry;
      procedure LoadFromFile;
      procedure AddMarry(Boy,Girl : String);
      procedure UnMarry(aName :String);
      function isParty(aName :String) : Boolean;
      function isClothes(aName :String) : Boolean;
      function DelMarryInfo(aName :String) : Boolean;
      procedure UnMarryNow(aName :String);
      procedure SetParty(aName :String);
      procedure SetClothes(aName :String);
      procedure SaveToFile;
   end;

   procedure LoadGameIni (aName: string);

   function  GetServerIdPointer (aServerId, atype: integer): Pointer;

   procedure LoadCreateMonster (aFileName: string; List : TList);
   procedure LoadCreateNpc (aFileName: string; List : TList);
   procedure LoadCreateDynamicObject (aFileName : String; List : TList);
   // procedure LoadCreateMineObject (aFileName : String; List : TList);

var
   NameClass : TNameClass;
   RandomEventItemList : TRandomEventItemList;
   BattleMapList : TBattleMapList;
   NameStringListForDeleteMagic : TStringList;
   RejectNameList : TStringList;
   RandomClass : TRandomClass;
   MagicClass : TMagicClass;
   MagicParamClass : TMagicParamClass;
   ItemMaterialClass : TItemMaterialClass;
   ItemClass : TItemClass;
   DynamicObjectClass : TDynamicObjectClass;
   MineObjectClass : TMineObjectClass;
   ItemDrugClass : TItemDrugClass;
   JobClass : TJobClass;
   MonsterClass : TMonsterClass;
   NpcClass : TNpcClass;
   SysopClass : TSysopclass;
   PosByDieClass : TPosByDieClass;
   QuestClass : TQuestClass;
   QuestSummaryClass : TQuestSummaryClass; //2002-08-06 giltae
   AreaClass : TAreaClass;
   PrisonClass : TPrisonClass;
   NpcFunction : TNpcFunction;
   SystemAlert : TSystemAlert;
   HelpFiles : THelpFiles;
   MacroReport : TMacroReport;
   QuizSystem : TQuizSystem;
   AddAttribClass : TAddAttribClass;
   EventItemClass : TEventItemClass;
   TransMonList : TTransMonsterListClass;
   MarryList : TMarryClass;

   TipStrList : TStringList;
   MagicCycleClass : TMagicCycleClass;   

   GrobalLightDark : TLightDark = gld_light;

   NameOfLend : string = '';

   GameStartDateStr : String;
   GameStartYear : Word = 2000;
   GameStartMonth : Word = 1;
   GameStartDay : Word = 1;
   
   GameCurrentDate : integer = 0;

   Udp_MouseEvent_IpAddress : string = '';
   Udp_MouseEvent_Port : integer = 6000;

   Udp_Item_IpAddress : string = '';
   Udp_Item_Port : integer = 6000;

   Udp_Moniter_IpAddress : string = '';
   Udp_Moniter_Port : integer = 6000;

   Udp_Connect_IpAddress : string = '';
   Udp_Connect_Port : integer = 6022;

   Udp_Object_IpAddress : String = '';
   Udp_Object_Port : Integer = 3003;

   Udp_Pay_IpAddress : string = '';
   Udp_Pay_Port : integer = 6000;
   
   Udp_Relation_IpAddress : String = '';
   Udp_Relation_Port : Integer = 3005;

{
   Udp_UserData_Ipaddress : string = '';
   Udp_UserData_Port : integer = 0;
   Udp_UserData_LocalPort : integer = 0;
}

   NoticeServerIpAddress : String = '';
   NoticeServerPort : Integer = 0;

   ProcessListCount : integer = 40;

   ////////////////////////
   //     INI Variable
   ////////////////////////

   INI_WHO : string = '/WHO';
   INI_SERCHSKILL : string = '@SERCHSKILL';
   INI_SERCHENABLE : string = '@SEARCHENABLE';
   INI_SERCHUNABLE : string = '@SERCHUNABLE';
   INI_WHITEDRUG : string = 'WHITEDRUG';
   INI_ROPE : string = 'ROPE';
   INI_SEX_FIELD_MAN : string = 'MAN';
   INI_SEX_FIELD_WOMAN : string = 'WOMAN';
   INI_GUILD_STONE : string = 'GUILDSTONE';
   INI_GUILD_NPCMAN_NAME : string = 'NPCMAN';
   INI_GUILD_NPCWOMAN_NAME : string = 'NPCWOMAN';
   INI_GUILD_NPCWHITE_NAME : string = 'NPCWHITE';
   INI_GUILD_NPCBLACK_NAME : string = 'NPCBLACK';
   INI_GOLD : string = 'GOLD';
   // add by Orber at 2004-09-10 11:26
   INI_ITEMUNLOCKTIME : integer = 60;


   INI_Guild_MAN_SEX : string = 'MAN';
   INI_Guild_MAN_CAP : string = '';
   INI_Guild_MAN_HAIR : string = '';
   INI_GUILD_MAN_UPUNDERWEAR : string = '';
   INI_Guild_MAN_UPOVERWEAR : string = '';
   INI_Guild_MAN_DOWNUNDERWEAR : string = '';
   INI_Guild_MAN_GLOVES : string = '';
   INI_Guild_MAN_SHOES : string = '';
   INI_Guild_MAN_WEAPON : string = '';
   INI_GUILD_MAN_SHAPE : integer = 27;
   INI_GUILD_MAN_ANIMATE : integer = 11;

   INI_Guild_WOMAN_SEX : string = 'WOMAN';
   INI_Guild_WOMAN_CAP : string = '';
   INI_Guild_WOMAN_HAIR : string = '';
   INI_GUILD_WOMAN_UPUNDERWEAR : string = '';
   INI_Guild_WOMAN_UPOVERWEAR : string = '';
   INI_Guild_WOMAN_DOWNUNDERWEAR : string = '';
   INI_Guild_WOMAN_GLOVES : string = '';
   INI_Guild_WOMAN_SHOES : string = '';
   INI_Guild_WOMAN_WEAPON : string = '';
   INI_GUILD_WOMAN_SHAPE : integer = 30;
   INI_GUILD_WOMAN_ANIMATE : integer = 12;

   INI_DEF_WRESTLING   : string;
   INI_DEF_FENCING     : string;
   INI_DEF_SWORDSHIP   : string;
   INI_DEF_HAMMERING   : string;
   INI_DEF_SPEARING    : string;
   INI_DEF_BOWING      : string;
   INI_DEF_THROWING    : string;
   INI_DEF_RUNNING     : string;
   INI_DEF_BREATHNG    : string;
   INI_DEF_PROTECTING  : string;

   INI_DEF_WRESTLING2   : string;
   INI_DEF_FENCING2     : string;
   INI_DEF_SWORDSHIP2   : string;
   INI_DEF_HAMMERING2   : string;
   INI_DEF_SPEARING2    : string;
   INI_DEF_BOWING2      : string;
   INI_DEF_THROWING2    : string;
   INI_DEF_RUNNING2     : string;
   INI_DEF_BREATHNG2    : string;
   INI_DEF_PROTECTING2  : string;

   INI_NORTH     : string;
   INI_NORTHEAST : string;
   INI_EAST      : string;
   INI_EASTSOUTH : string;
   INI_SOUTH     : string;
   INI_SOUTHWEST : string;
   INI_WEST      : string;
   INI_WESTNORTH : string;

   INI_HIDEPAPER_DELAY : Integer = 15;
   INI_SHOWPAPER_DELAY : Integer = 60;

   // 扁夯公傍
   INI_MAGIC_DIV_VALUE  : integer = 10;
   INI_ADD_DAMAGE       : integer = 40;
   INI_MUL_ATTACKSPEED  : integer = 10;
   INI_MUL_ACCURACY        : Integer = 6;
   INI_MUL_KEEPRECOVERY    : Integer = 10;
   INI_MUL_AVOID           : integer = 6;
   INI_MUL_RECOVERY        : integer = 10;
   INI_MUL_DAMAGEBODY      : integer = 23;
   INI_MUL_DAMAGEHEAD      : integer = 17;
   INI_MUL_DAMAGEARM       : integer = 17;
   INI_MUL_DAMAGELEG       : integer = 17;
   INI_MUL_ARMORBODY       : integer = 7;
   INI_MUL_ARMORHEAD       : integer = 7;
   INI_MUL_ARMORARM        : integer = 7;
   INI_MUL_ARMORLEG        : integer = 7;

   INI_MUL_EVENTENERGY     : integer = 20;
   INI_MUL_EVENTINPOWER    : integer = 22;
   INI_MUL_EVENTOUTPOWER   : integer = 22;
   INI_MUL_EVENTMAGIC      : integer = 10;
   INI_MUL_EVENTLIFE       : integer = 8;
   INI_MUL_EVENTDAMAGEHEAD : integer = 17;
   INI_MUL_EVENTDAMAGEARM  : integer = 17;
   INI_MUL_EVENTDAMAGELEG  : integer = 17;

   INI_MUL_5SECENERGY      : integer = 20;
   INI_MUL_5SECINPOWER     : integer = 14;
   INI_MUL_5SECOUTPOWER    : integer = 14;
   INI_MUL_5SECMAGIC       : integer = 9;
   INI_MUL_5SECLIFE        : integer = 8;
   INI_MUL_5SECDAMAGEHEAD  : integer = 17;
   INI_MUL_5SECDAMAGEARM   : integer = 17;
   INI_MUL_5SECDAMAGELEG   : integer = 17;


   INI_SKILL_DIV_DAMAGE    : integer = 5000;
   INI_SKILL_DIV_ARMOR     : integer = 5000;
   INI_SKILL_DIV_ATTACKSPEED : integer = 25000;
   INI_SKILL_DIV_EVENT     : integer = 5000;

   // 惑铰公傍
   INI_MAGIC_DIV_VALUE2  : integer = 10;
   INI_ADD_DAMAGE2       : integer = 40;
   INI_MUL_ATTACKSPEED2  : integer = 10;
   INI_MUL_AVOID2           : integer = 6;
   INI_MUL_RECOVERY2        : integer = 10;
   INI_MUL_ACCURACY2        : integer = 6;
   INI_MUL_KEEPRECOVERY2    : integer = 10;
   INI_MUL_DAMAGEBODY2      : integer = 23;
   INI_MUL_DAMAGEHEAD2      : integer = 17;
   INI_MUL_DAMAGEARM2       : integer = 17;
   INI_MUL_DAMAGELEG2       : integer = 17;
   INI_MUL_ARMORBODY2       : integer = 7;
   INI_MUL_ARMORHEAD2       : integer = 7;
   INI_MUL_ARMORARM2        : integer = 7;
   INI_MUL_ARMORLEG2        : integer = 7;

   INI_MUL_EVENTENERGY2     : integer = 20;
   INI_MUL_EVENTINPOWER2    : integer = 22;
   INI_MUL_EVENTOUTPOWER2   : integer = 22;
   INI_MUL_EVENTMAGIC2      : integer = 10;
   INI_MUL_EVENTLIFE2       : integer = 8;
   INI_MUL_EVENTDAMAGEHEAD2 : integer = 17;
   INI_MUL_EVENTDAMAGEARM2  : integer = 17;
   INI_MUL_EVENTDAMAGELEG2  : integer = 17;

   INI_MUL_5SECENERGY2      : integer = 20;
   INI_MUL_5SECINPOWER2     : integer = 14;
   INI_MUL_5SECOUTPOWER2    : integer = 14;
   INI_MUL_5SECMAGIC2       : integer = 9;
   INI_MUL_5SECLIFE2        : integer = 8;
   INI_MUL_5SECDAMAGEHEAD2  : integer = 17;
   INI_MUL_5SECDAMAGEARM2   : integer = 17;
   INI_MUL_5SECDAMAGELEG2   : integer = 17;

   INI_SKILL_DIV_DAMAGE2    : integer = 5000;
   INI_SKILL_DIV_ARMOR2     : integer = 5000;
   INI_SKILL_DIV_ATTACKSPEED2 : integer = 25000;
   INI_SKILL_DIV_RECOVERY2    : integer = 25000;
   INI_SKILL_DIV_AVOID2       : integer = 25000;
   INI_SKILL_DIV_ACCURACY2    : integer = 25000;
   INI_SKILL_DIV_KEEPRECOVERY2 : integer = 25000;
   INI_SKILL_DIV_EVENT2     : integer = 5000;

   INI_SKILL_ADD_BASESKILL : Integer = 3000;

   //厘过
   INI_MAGIC_DIV_VALUE3  : integer = 10;
   INI_ADD_DAMAGE3       : integer = 847;
   INI_MUL_ATTACKSPEED3  : integer = 19;
   INI_MUL_AVOID3           : integer = 6;
   INI_MUL_RECOVERY3        : integer = 10;
   INI_MUL_ACCURACY3        : integer = 6;
   INI_MUL_KEEPRECOVERY3    : integer = 10;
   INI_MUL_DAMAGEBODY3      : integer = 22;
   INI_MUL_DAMAGEHEAD3      : integer = 17;
   INI_MUL_DAMAGEARM3       : integer = 17;
   INI_MUL_DAMAGELEG3       : integer = 17;
   INI_MUL_ARMORBODY3       : integer = 7;
   INI_MUL_ARMORHEAD3       : integer = 7;
   INI_MUL_ARMORARM3        : integer = 7;
   INI_MUL_ARMORLEG3        : integer = 7;

   INI_MUL_EVENTENERGY3     : integer = 20;
   INI_MUL_EVENTINPOWER3    : integer = 22;
   INI_MUL_EVENTOUTPOWER3   : integer = 22;
   INI_MUL_EVENTMAGIC3      : integer = 10;
   INI_MUL_EVENTLIFE3       : integer = 8;
   INI_MUL_EVENTDAMAGEHEAD3 : integer = 17;
   INI_MUL_EVENTDAMAGEARM3  : integer = 17;
   INI_MUL_EVENTDAMAGELEG3  : integer = 17;

   INI_MUL_5SECENERGY3      : integer = 20;
   INI_MUL_5SECINPOWER3     : integer = 14;
   INI_MUL_5SECOUTPOWER3    : integer = 14;
   INI_MUL_5SECMAGIC3       : integer = 9;
   INI_MUL_5SECLIFE3        : integer = 8;
   INI_MUL_5SECDAMAGEHEAD3  : integer = 17;
   INI_MUL_5SECDAMAGEARM3   : integer = 17;
   INI_MUL_5SECDAMAGELEG3   : integer = 17;

   INI_SKILL_DIV_DAMAGE3    : integer = 5000;
   INI_SKILL_DIV_ARMOR3     : integer = 5000;
   INI_SKILL_DIV_ATTACKSPEED3 : integer = 50000;
   INI_SKILL_DIV_RECOVERY3    : integer = 25000;
   INI_SKILL_DIV_AVOID3       : integer = 25000;
   INI_SKILL_DIV_ACCURACY3    : integer = 25000;
   INI_SKILL_DIV_KEEPRECOVERY3 : integer = 9999;
   INI_SKILL_DIV_EVENT3     : integer = 5000;

   // 扁贱流辆
   INI_DEF_ALCHEMIST       : String;
   INI_DEF_CHEMIST         : String;
   INI_DEF_DESIGNER        : String;
   INI_DEF_CRAFTSMAN       : String;

   // 扁贱流鞭
   INI_DEF_NAMELESSWORKER  : String;
   INI_DEF_TECHNICIAN      : String;
   INI_DEF_SKILLEDWORKER   : String;
   INI_DEF_EXPERT          : String;
   INI_DEF_MASTER          : String;
   INI_DEF_VIRTUEMAN       : String;

   // 啊傍矫距
   INI_DEF_ITEMPROCESS1    : String;
   INI_DEF_ITEMPROCESS2    : String;
   INI_DEF_ITEMPROCESS3    : String;
   INI_DEF_ITEMPROCESS4    : String;

function  GetLifeDataInfo (var aLifeData: TLifeData): string;
function  GetItemDataInfo (var aItemData: TItemData): string;
function  GetItemDataInfo2 (var aItemData: TItemData): string;
function  GetMiniItemContents (var aItemData: TItemData): string;
function GetMiniItemContents2 (var aItemData: TItemData; aPowerLevel : Integer): string;
function  GetMagicDataInfo (var aMagicData: TMagicData): string;
procedure GatherAddAttribLifeData (var BaseAddAttribLifeData : TRealAddAttribData ; aAddAttribLifeData : TAddAttribData; aPowerLevel : Integer);
procedure GatherLifeData (var BaseLifeData, aLifeData: TLifeData);
procedure GatherAttribLifeData (var BaseAttribLifeData, aAttribLifeData : TRealAddAttribData);
procedure CheckLifeData (var BaseLifeData: TLifeData);
procedure CheckAttribData (var BaseAttribData : TAttribData);

function GetNeedXByTotalPoint (total : integer) : integer;
function GetStatePointByTotalPoint (total : integer) : integer;
procedure GetResultSettingValueofBestMagic(statePoint, sValue: integer; var total: integer);
function GetStatePointByUserState(n : integer) : integer;
function GetAddStateByN(n,sValue : integer) : integer;
function GetNeedStateValueofBestProtect (total: integer): integer;

function GetMagicString (var aMagic: TDBBestMagicData) : string;
function GetBestMagicString (var aMagic : TDBBestMagicData) : string;

implementation

uses
   uUser, uUserSub, uconnect, uManager, uMonster, uNpc, uGuild, uItemLog, SVMain,
   uCharCheck,uZhuang;

function  GetMagicDataInfo (var aMagicData: TMagicData): string;
begin
   Result := '';
   if aMagicData.rName[0] = 0 then exit;

   case aMagicData.rMagicClass of
      MAGICCLASS_MAGIC: begin
         with aMagicData.rcLifeData do begin
            Result := format (Conv ('%s  修练等级: %s'), [StrPas (@aMagicData.rName), Get10000To100 (aMagicData.rcSkillLevel)]) + #13;

            if (AttackSpeed <> 0) or (Recovery <> 0) or (Avoid <> 0) then begin
               Result := Result + format (Conv ('攻击速度: %d  恢复: %d  躲闪: %d'), [AttackSpeed, Recovery, Avoid, KeepRecovery, Accuracy]) + #13;
            end;
            if DamageBody <> 0 then
               Result := Result + format (Conv ('破坏力: %d / %d / %d / %d'), [DamageBody, DamageHead, DamageArm, DamageLeg]) + #13;
            if ArmorBody <> 0 then
               Result := Result + format (Conv ('防御力:  %d / %d / %d / %d'), [ArmorBody, ArmorHead, ArmorArm, ArmorLeg]) + #13;
         end;
      end;
      MAGICCLASS_RISEMAGIC,MAGICCLASS_MYSTERY: begin
         with aMagicData.rcLifeData do begin
            Result := format (Conv ('%s  修练等级: %s'), [StrPas (@aMagicData.rName), Get10000To100 (aMagicData.rcSkillLevel)]) + #13;

            if (AttackSpeed <> 0) or (Recovery <> 0) or (Avoid <> 0) or (KeepRecovery <> 0) or (Accuracy <> 0) then begin
// change by minds 050602
//               Result := Result + format (Conv ('攻击速度: %d  恢复: %d  躲闪: %d'), [AttackSpeed, Recovery, Avoid, KeepRecovery, Accuracy]) + #13;
               Result := Result + format (Conv('攻击速度: %d  恢复: %d  躲闪: %d'), [AttackSpeed, Recovery, Avoid]) + #13;
               Result := Result + format (Conv('准确度: %d 姿势维持: %d'), [Accuracy, KeepRecovery]) + #13;
            end;
            if DamageBody <> 0 then
               Result := Result + format (Conv ('破坏力: %d / %d / %d / %d'), [DamageBody, DamageHead, DamageArm, DamageLeg]) + #13;
            if ArmorBody <> 0 then
               Result := Result + format (Conv ('防御力:  %d / %d / %d / %d'), [ArmorBody, ArmorHead, ArmorArm, ArmorLeg]) + #13;
         end;
      end;
      MAGICCLASS_BESTMAGIC: begin
         if aMagicData.rMagicType <> MAGICTYPE_BESTSPECIAL then begin
            with aMagicData.rcLifeData do begin
               Result := format (Conv ('%s(%d级) 修炼等级: %s'), [StrPas (@aMagicData.rName), aMagicData.rGrade+1, Get10000To100 (aMagicData.rcSkillLevel)]) + #13;

               if (AttackSpeed <> 0) or (Recovery <> 0) or (Avoid <> 0) or (KeepRecovery <> 0) or (Accuracy <> 0) then begin
// change by minds 050602
//                  Result := Result + format (Conv ('攻击速度: %d  恢复: %d  躲闪: %d'), [AttackSpeed, Recovery, Avoid, KeepRecovery, Accuracy]) + #13;
                  Result := Result + format (Conv('攻击速度: %d  恢复: %d  躲闪: %d'), [AttackSpeed, Recovery, Avoid]) + #13;
                  Result := Result + format (Conv('准确度: %d 姿势维持: %d'), [Accuracy, KeepRecovery]) + #13;
               end;
               if DamageBody <> 0 then
                  Result := Result + format (Conv ('破坏力: %d / %d / %d / %d'), [DamageBody, DamageHead, DamageArm, DamageLeg]) + #13;
               if ArmorBody <> 0 then
                  Result := Result + format (Conv ('防御力:  %d / %d / %d / %d'), [ArmorBody, ArmorHead, ArmorArm, ArmorLeg]) + #13;
               if DamageEnergy <> 0 then
                  Result := Result + format (Conv ('元气攻击: %d'), [DamageEnergy]) + #13;
               if ArmorEnergy <> 0 then
                  Result := Result + format (Conv ('元气防御: %d%%, %d'), [ArmorEnergy,ArmorEValue]) +#13;
            end;
         end;
      end;
   end;

   if aMagicData.rMagicClass = MAGICCLASS_MYSTERY then begin
      Result := Result + format (Conv ('有效距离范围: 最小(%d)，最大(%d)'), [aMagicData.rMinRange,aMagicData.rMaxRange]) + #13;
      Result := Result + format (Conv ('远距离躲闪: %d'), [aMagicData.rcLifeData.longavoid]) + #13;
   end;
end;

function  GetItemDataInfo (var aItemData: TItemData): String;
begin
   Result := '';

   if aItemData.rName[0] = 0 then exit;

   with aItemData do begin
      if rUpgrade <> 0 then begin
         if rGrade <= 5 then begin
            Result := format (Conv('%s %d级'), [StrPas (@rViewName), rUpgrade]) + #13;
         end else begin
            Result := format (Conv('%s %d级 价格: %d'), [StrPas (@rViewName), rUpgrade, rPrice]) + #13;
         end;
      end else begin
         if rKind = ITEM_KIND_MINERAL then begin
            Result := format (Conv('%s 数量: %d'), [StrPas (@rViewName), rCount]) + #13;
         end else begin
            if StrPas (@rName) = INI_GOLD then begin
               Result := format (Conv('%s %d 钱'), [StrPas (@rViewName), rCount]) + #13;
            end else begin
               if rGrade <= 5 then begin
                  Result := format ('%s', [StrPas (@rViewName)]) + #13;
               end else begin
                  Result := format (Conv('%s  价格: %d'), [StrPas (@rViewName), rPrice]) + #13;
               end;
            end;
         end;
      end;

      if rKind = ITEM_KIND_WATERCASE then begin
         Result := Result + format (Conv('剩余: %d%d'),[rCurDurability, rDurability]) + #13;
      end else if rDurability <> 0 then
         Result := Result + format (Conv('耐力: %d/%d'),[rCurDurability, rDurability]) + #13;
   end;
   with aItemData.rLifeData do begin
      if (AttackSpeed <> 0) or (Recovery <> 0) or (Avoid <> 0) or (Accuracy <> 0) or (KeepRecovery <> 0) then begin
         Result := Result + format (Conv('攻击速度: %d 恢复: %d 躲闪: %d 命中率: %d 姿势维持: %d'), [-AttackSpeed, -Recovery, Avoid, Accuracy, KeepRecovery]) + #13;
      end;
      if (DamageBody <> 0) or (DamageHead <> 0) or (DamageArm <> 0) or (DamageLeg <> 0) then
         Result := Result + format (Conv('破坏力: %d / %d / %d / %d'),[DamageBody, DamageHead, DamageArm, DamageLeg]) + #13;
      if (ArmorBody <> 0) or (ArmorHead <> 0) or (ArmorArm <> 0) or (ArmorLeg <> 0) then
         Result := Result + format (Conv('防御力:  %d / %d / %d / %d'),[ArmorBody, ArmorHead, ArmorArm, ArmorLeg]) + #13;
   end;
   if aItemData.rAddType = 0 then exit;

   with aItemData.rAddAttribData do begin
      if rBowAttSpd.rValue <> 0 then begin
         if rBowAttSpd.rLimit <> 0 then begin
            Result := Result + format(Conv('远距离攻击速度 : %d(%s)'),[-rBowAttSpd.rValue, MagicClass.GetPowerLevelName(rBowAttSpd.rLimit)]) + #13;
         end else begin
            Result := Result + format(Conv('远距离攻击速度 : %d'),[-rBowAttSpd.rValue]) + #13;
         end;
      end;
      if rBowAccuracy.rValue <> 0 then begin
         if rBowAccuracy.rLimit <> 0 then begin
            Result := Result + format (Conv('远距离命中率: %d(%s)'),[rBowAccuracy.rValue, MagicClass.GetPowerLevelName (rBowAccuracy.rLimit)]) + #13;
         end else begin
            Result := Result + format (Conv('远距离命中率: %d'),[rBowAccuracy.rValue]) + #13;
         end;
      end;

      if rBowKeepRecovery.rValue <> 0 then begin
         if rBowKeepRecovery.rLimit <> 0 then begin
            Result := Result + format (Conv('远距离维持: %d (%s)'),[rBowKeepRecovery.rValue, MagicClass.GetPowerLevelName (rBowKeepRecovery.rLimit)]) + #13;
         end else begin
            Result := Result + format (Conv('远距离维持: %d'),[rBowKeepRecovery.rValue]) + #13;
         end;
      end;
      
      if rBowAvoid.rValue <> 0 then begin
         if rBowAvoid.rLimit <> 0 then begin
            Result := Result + format (Conv('远距离躲闪 : %d (%s)'),[rBowAvoid.rValue, MagicClass.GetPowerLevelName (rBowAvoid.rLimit)]) + #13;
         end else begin
            Result := Result + format (Conv('远距离躲闪: %d'),[rBowAvoid.rValue]) + #13;
         end;
      end;

      if rBowBodyArmor.rValue <> 0 then begin
         if rBowBodyArmor.rLimit <> 0 then begin
            Result := Result + format (Conv('远距离身体防御: %d (%s)'),[rBowBodyArmor.rValue, MagicClass.GetPowerLevelName (rBowBodyArmor.rLimit)]) + #13;
         end else begin
            Result := Result + format (Conv('远距离身体防御 : %d'),[rBowBodyArmor.rValue]) + #13;
         end;
      end;

      if rBowHeadArmor.rValue <> 0 then begin
         if rBowHeadArmor.rLimit <> 0 then begin
            Result := Result + format (Conv('远距离头防御 : %d (%s)'),[rBowHeadArmor.rValue, MagicClass.GetPowerLevelName (rBowHeadArmor.rLimit)]) + #13;
         end else begin
            Result := Result + format (Conv('远距离头防御 : %d'),[rBowHeadArmor.rValue]) + #13;            
         end;
      end;
      
      if rBowArmArmor.rValue <> 0 then begin
         if rBowArmArmor.rLimit <> 0 then begin
            Result := Result + format (Conv('远距离臂防御 : %d (%s)'),[rBowArmArmor.rValue, MagicClass.GetPowerLevelName (rBowArmArmor.rLimit)]) + #13;
         end else begin
            Result := Result + format (Conv('远距离臂防御 : %d'),[rBowArmArmor.rValue]) + #13;
         end;
      end;
      
      if rBowLegArmor.rValue <> 0 then begin
         if rBowLegArmor.rLimit <> 0 then begin
            Result := Result + format (Conv('远距离腿防御 : %d (%s)'),[rBowLegArmor.rValue, MagicClass.GetPowerLevelName (rBowLegArmor.rLimit)]) + #13;
         end else begin
            Result := Result + format (Conv('远距离腿防御 : %d'),[rBowLegArmor.rValue]) + #13;
         end;
      end;

      if rHandSpd.rValue <> 0 then begin
         if rHandSpd.rLimit <> 0 then begin
            Result := Result + format(Conv('掌法攻击速度 : %d (%s)'),[-rHandSpd.rValue, MagicClass.GetPowerLevelName (rHandSpd.rLimit)]) + #13;
         end else begin
            Result := Result + format(Conv('掌法攻击速度 : %d'),[-rHandSpd.rValue]) + #13;
         end;
      end;

      if rHandAccuracy.rValue <> 0 then begin
         if rHandAccuracy.rLimit <> 0 then begin
            Result := Result + format(Conv('掌法命中率 : %d (%s)'),[rHandAccuracy.rValue, MagicClass.GetPowerLevelName (rHandAccuracy.rLimit)]) + #13;
         end else begin
            Result := Result + format(Conv('掌法命中率 : %d'),[rHandAccuracy.rValue]) + #13;
         end;
      end;

      if rHandKeepRecovery.rValue <> 0 then begin
         if rHandKeepRecovery.rLimit <> 0 then begin
            Result := Result + format(Conv('掌法 维持 : %d (%s)'),[rHandKeepRecovery.rValue, MagicClass.GetPowerLevelName (rHandKeepRecovery.rLimit)]) + #13;
         end else begin
            Result := Result + format(Conv('掌法 维持 : %d '),[rHandKeepRecovery.rValue]) + #13;
         end;
      end;
      
      if rHandMinValue.rValue <> 0 then begin
         if rHandMinValue.rLimit <> 0 then begin
            Result := Result + format(Conv('掌法最小距离 : %d (%s)'),[rHandMinValue.rValue, MagicClass.GetPowerLevelName (rHandMinValue.rLimit)]) + #13;
         end else begin
            Result := Result + format(Conv('掌法最小距离 : %d'),[rHandMinValue.rValue]) + #13;
         end;
      end;

      if rHandMaxValue.rValue <> 0 then begin
         if rHandMaxValue.rLimit <> 0 then begin
            Result := Result + format(Conv('掌法最大距离 : %d (%s)'),[rHandMaxValue.rValue, MagicClass.GetPowerLevelName (rHandMaxValue.rLimit)]) + #13;
         end else begin
            Result := Result + format(Conv('掌法最大距离 : %d'),[rHandMaxValue.rValue]) + #13;
         end;
      end;
      
      if rHandBodyArmor.rValue <> 0 then begin
         if rHandBodyArmor.rLimit <> 0 then begin
            Result := Result + format(Conv('掌法身体防御 : %d (%s)'),[rHandBodyArmor.rValue, MagicClass.GetPowerLevelName (rHandBodyArmor.rLimit)]) + #13;
         end else begin
            Result := Result + format(Conv('掌法身体防御: %d'),[rHandBodyArmor.rValue]) + #13;
         end;
      end;
      
      if rApproachSpd.rValue <> 0 then begin
         if rApproachSpd.rLimit <> 0 then begin
            Result := Result + format(Conv('近距离攻击速度: %d(%s)'),[-rApproachSpd.rValue, MagicClass.GetPowerLevelName (rApproachSpd.rLimit)]) + #13;
         end else begin
            Result := Result + format(Conv('近距离攻击速度 : %d'),[-rApproachSpd.rValue]) + #13;
         end;
      end;
      
      if rApproachAccuracy.rValue  <> 0 then begin
         if  rApproachAccuracy.rLimit <> 0 then begin
            Result := Result + format(Conv('近距离 命中率: %d (%s)'),[rApproachAccuracy.rValue, MagicClass.GetPowerLevelName (rApproachAccuracy.rLimit)]) + #13;
         end else begin
            Result := Result + format(Conv('近距离命中率 : %d'),[rApproachAccuracy.rValue]) + #13;
         end;
      end;
      
      if rApproachKeepRecovery.rValue <> 0 then begin
         if rApproachKeepRecovery.rLimit <> 0 then begin
            Result := Result + format(Conv('近距离姿势维持: %d (%s)'),[rApproachKeepRecovery.rValue, MagicClass.GetPowerLevelName (rApproachKeepRecovery.rLimit)]) + #13;
         end else begin
            Result := Result + format(Conv('近距离姿势维持 : %d'),[rApproachKeepRecovery.rValue]) + #13;
         end;
      end;

      if rApproachAvoid.rValue  <> 0 then begin
         if rApproachAvoid.rLimit <> 0 then begin
            Result := Result + format(Conv('近距离躲闪 : %d (%s)'),[rApproachAvoid.rValue, MagicClass.GetPowerLevelName (rApproachAvoid.rLimit)]) + #13;
         end else begin
            Result := Result + format(Conv('近距离躲闪 : %d'),[rApproachAvoid.rValue]) + #13;
         end;
      end;
      
      if rApproachBodyArmor.rValue <> 0 then begin
         if rApproachBodyArmor.rLimit <> 0 then begin
            Result := Result + format(Conv('近距离身体防御 : %d (%s)'),[rApproachBodyArmor.rValue, MagicClass.GetPowerLevelName (rApproachBodyArmor.rLimit)]) + #13;
         end else begin
            Result := Result + format(Conv('近距离身体防御 : %d'),[rApproachBodyArmor.rValue]) + #13;
         end;
      end;
      
      if rApproachHeadArmor.rValue <> 0 then begin
         if rApproachHeadArmor.rLimit <> 0 then begin
            Result := Result + format(Conv('近距离头部防御 : %d (%s)'),[rApproachHeadArmor.rValue, MagicClass.GetPowerLevelName (rApproachHeadArmor.rLimit)]) + #13;
         end else begin
            Result := Result + format(Conv('近距离头部防御 : %d'),[rApproachHeadArmor.rValue]) + #13;
         end;
      end;
      
      if rApproachArmArmor.rValue <> 0 then begin
         if rApproachArmArmor.rLimit <> 0 then begin
            Result := Result + format(Conv('近距离臂防御 : %d (%s)'),[rApproachArmArmor.rValue, MagicClass.GetPowerLevelName (rApproachArmArmor.rLimit)]) + #13;
         end else begin
            Result := Result + format(Conv('近距离臂防御 : %d'),[rApproachArmArmor.rValue]) + #13;
         end;
      end;

      if rApproachLegArmor.rValue <> 0 then begin
         if rApproachLegArmor.rLimit <> 0 then begin
            Result := Result + format(Conv('近距离腿防御 : %d (%s)'),[rApproachLegArmor.rValue, MagicClass.GetPowerLevelName (rApproachLegArmor.rLimit)]) + #13;
         end else begin
            Result := Result + format(Conv('近距离腿防御 : %d'),[rApproachLegArmor.rValue]) + #13;
         end;
      end;
      
      if rAddBodyDamage.rValue <> 0 then begin
         if rAddBodyDamage.rLimit <> 0 then begin
            Result := Result + format(Conv('身体攻击力增加 : %d (%s)'),[rAddBodyDamage.rValue, MagicClass.GetPowerLevelName (rAddBodyDamage.rLimit)]) + #13;
         end else begin
            Result := Result + format(Conv('身体攻击力增加 : %d'),[rAddBodyDamage.rValue]) + #13;
         end;
      end;

      if rAddHeadDamage.rValue <> 0 then begin
         if  rAddHeadDamage.rLimit <> 0 then begin
            Result := Result + format(Conv('头部攻击力增加 : %d (%s)'),[rAddHeadDamage.rValue, MagicClass.GetPowerLevelName (rAddHeadDamage.rLimit)]) + #13;
         end else begin
            Result := Result + format(Conv('头部攻击力增加 : %d'),[rAddHeadDamage.rValue]) + #13;
         end;
      end;

      if rAddArmDamage.rValue <> 0 then begin
         if rAddArmDamage.rLimit <> 0 then begin
            Result := Result + format(Conv('臂攻击力增加 : %d (%s)'),[rAddArmDamage.rValue, MagicClass.GetPowerLevelName (rAddArmDamage.rLimit)]) + #13;
         end else begin
            Result := Result + format(Conv('臂 攻击力增加: %d'),[rAddArmDamage.rValue]) + #13;
         end;
      end;
      
      if rAddLegDamage.rValue <> 0 then begin
         if rAddLegDamage.rLimit <> 0 then begin
            Result := Result + format(Conv('腿 攻击力增加 : %d (%s)'),[rAddLegDamage.rValue, MagicClass.GetPowerLevelName (rAddLegDamage.rLimit)]) + #13;
         end else begin
            Result := Result + format(Conv('腿部攻击力增加 : %d'),[rAddLegDamage.rValue]) + #13;
         end;
      end;
      
      if rEnergyRegenDec.rValue <> 0 then begin
         if rEnergyRegenDec.rLimit <> 0 then begin
            Result := Result + format(Conv('元气减少 %d (%s)'),[rEnergyRegenDec.rValue, MagicClass.GetPowerLevelName (rEnergyRegenDec.rLimit)]) + #13;
         end else begin
            Result := Result + format(Conv('元气减少%d'),[rEnergyRegenDec.rValue]) + #13;
         end;
      end;
      if rBasicValueDec.rValue <> 0 then begin
         if rBasicValueDec.rLimit <> 0 then begin
            Result := Result + format(Conv('内外功消耗减少 : %d %%(%s)'),[rBasicValueDec.rValue, MagicClass.GetPowerLevelName (rBasicValueDec.rLimit)]) + #13;
         end else begin
            Result := Result + format(Conv('内外功消耗减少: %d %%'),[rBasicValueDec.rValue]) + #13;
         end;
      end;
   end;
end;

function  GetItemDataInfo2 (var aItemData: TItemData): string;
begin
   Result := '';
   if aItemData.rName [0] = 0 then exit;
   with aItemData do begin
      if rDurability > 0 then begin
         Result := format (Conv('耐力: %d/%d'), [rCurDurability, rDurability]);
      end;
   end;
   with aItemData.rLifeData do begin
      if (AttackSpeed <> 0) or (Recovery <> 0) or (Avoid <> 0) or (Accuracy <> 0) or (KeepRecovery <> 0) then begin
         Result := Result + format (Conv('攻击速度: %d 恢复: %d 躲闪: %d 命中率: %d 姿势维持: %d'), [-AttackSpeed, -Recovery, Avoid, Accuracy, KeepRecovery]) + #13;
      end;
      if (DamageBody <> 0) or (DamageHead <> 0) or (DamageArm <> 0) or (DamageLeg <> 0)
         or (ArmorBody <> 0) or (ArmorHead <> 0) or (ArmorArm <> 0) or (ArmorLeg <> 0) then
         Result := Result + format (Conv('破坏力: %d/%d/%d/%d 防御力: %d/%d/%d/%d'),[DamageBody, DamageHead, DamageArm, DamageLeg, ArmorBody, ArmorHead, ArmorArm, ArmorLeg]) + #13;
   end;
   if aItemData.rAddType = 0 then exit;

   with aItemData.rAddAttribData do begin
      if rBowAttSpd.rValue <> 0 then begin
         if rBowAttSpd.rLimit <> 0 then begin
            Result := Result + format(Conv('远距离攻击速度 : %d (%s)'),[-rBowAttSpd.rValue, MagicClass.GetPowerLevelName(rBowAttSpd.rLimit)]) + #13;
         end else begin
            Result := Result + format(Conv('远距离攻击速度 : %d'),[-rBowAttSpd.rValue]) + #13;
         end;
      end;
      if rBowAccuracy.rValue <> 0 then begin
         if rBowAccuracy.rLimit <> 0 then begin
            Result := Result + format (Conv('远距离命中率: %d(%s)'),[rBowAccuracy.rValue, MagicClass.GetPowerLevelName (rBowAccuracy.rLimit)]) + #13;
         end else begin
            Result := Result + format (Conv('远距离命中率: %d'),[rBowAccuracy.rValue]) + #13;
         end;
      end;

      if rBowKeepRecovery.rValue <> 0 then begin
         if rBowKeepRecovery.rLimit <> 0 then begin
            Result := Result + format (Conv('远距离维持: %d (%s)'),[rBowKeepRecovery.rValue, MagicClass.GetPowerLevelName (rBowKeepRecovery.rLimit)]) + #13;
         end else begin
            Result := Result + format (Conv('远距离维持: %d'),[rBowKeepRecovery.rValue]) + #13;
         end;
      end;
      
      if rBowAvoid.rValue <> 0 then begin
         if rBowAvoid.rLimit <> 0 then begin
            Result := Result + format (Conv('远距离躲闪 : %d (%s)'),[rBowAvoid.rValue, MagicClass.GetPowerLevelName (rBowAvoid.rLimit)]) + #13;
         end else begin
            Result := Result + format (Conv('远距离躲闪: %d'),[rBowAvoid.rValue]) + #13;
         end;
      end;

      if rBowBodyArmor.rValue <> 0 then begin
         if rBowBodyArmor.rLimit <> 0 then begin
            Result := Result + format (Conv('远距离身体防御: %d (%s)'),[rBowBodyArmor.rValue, MagicClass.GetPowerLevelName (rBowBodyArmor.rLimit)]) + #13;
         end else begin
            Result := Result + format (Conv('远距离身体防御 : %d'),[rBowBodyArmor.rValue]) + #13;
         end;
      end;

      if rBowHeadArmor.rValue <> 0 then begin
         if rBowHeadArmor.rLimit <> 0 then begin
            Result := Result + format (Conv('远距离头防御 : %d (%s)'),[rBowHeadArmor.rValue, MagicClass.GetPowerLevelName (rBowHeadArmor.rLimit)]) + #13;
         end else begin
            Result := Result + format (Conv('远距离头防御 : %d'),[rBowHeadArmor.rValue]) + #13;            
         end;
      end;
      
      if rBowArmArmor.rValue <> 0 then begin
         if rBowArmArmor.rLimit <> 0 then begin
            Result := Result + format (Conv('远距离臂防御 : %d (%s)'),[rBowArmArmor.rValue, MagicClass.GetPowerLevelName (rBowArmArmor.rLimit)]) + #13;
         end else begin
            Result := Result + format (Conv('远距离臂防御 : %d'),[rBowArmArmor.rValue]) + #13;
         end;
      end;
      
      if rBowLegArmor.rValue <> 0 then begin
         if rBowLegArmor.rLimit <> 0 then begin
            Result := Result + format (Conv('远距离腿防御 : %d (%s)'),[rBowLegArmor.rValue, MagicClass.GetPowerLevelName (rBowLegArmor.rLimit)]) + #13;
         end else begin
            Result := Result + format (Conv('远距离腿防御 : %d'),[rBowLegArmor.rValue]) + #13;
         end;
      end;

      if rHandSpd.rValue <> 0 then begin
         if rHandSpd.rLimit <> 0 then begin
            Result := Result + format(Conv('掌法攻击速度 : %d (%s)'),[-rHandSpd.rValue, MagicClass.GetPowerLevelName (rHandSpd.rLimit)]) + #13;
         end else begin
            Result := Result + format(Conv('掌法攻击速度 : %d'),[-rHandSpd.rValue]) + #13;
         end;
      end;

      if rHandAccuracy.rValue <> 0 then begin
         if rHandAccuracy.rLimit <> 0 then begin
            Result := Result + format(Conv('掌法命中率 : %d (%s)'),[rHandAccuracy.rValue, MagicClass.GetPowerLevelName (rHandAccuracy.rLimit)]) + #13;
         end else begin
            Result := Result + format(Conv('掌法命中率 : %d'),[rHandAccuracy.rValue]) + #13;
         end;
      end;

      if rHandKeepRecovery.rValue <> 0 then begin
         if rHandKeepRecovery.rLimit <> 0 then begin
            Result := Result + format(Conv('掌法 维持 : %d (%s)'),[rHandKeepRecovery.rValue, MagicClass.GetPowerLevelName (rHandKeepRecovery.rLimit)]) + #13;
         end else begin
            Result := Result + format(Conv('掌法 维持 : %d '),[rHandKeepRecovery.rValue]) + #13;
         end;
      end;
      
      if rHandMinValue.rValue <> 0 then begin
         if rHandMinValue.rLimit <> 0 then begin
            Result := Result + format(Conv('掌法最小距离 : %d (%s)'),[rHandMinValue.rValue, MagicClass.GetPowerLevelName (rHandMinValue.rLimit)]) + #13;
         end else begin
            Result := Result + format(Conv('掌法最小距离 : %d'),[rHandMinValue.rValue]) + #13;
         end;
      end;

      if rHandMaxValue.rValue <> 0 then begin
         if rHandMaxValue.rLimit <> 0 then begin
            Result := Result + format(Conv('掌法最大距离 : %d (%s)'),[rHandMaxValue.rValue, MagicClass.GetPowerLevelName (rHandMaxValue.rLimit)]) + #13;
         end else begin
            Result := Result + format(Conv('掌法最大距离 : %d'),[rHandMaxValue.rValue]) + #13;
         end;
      end;
      
      if rHandBodyArmor.rValue <> 0 then begin
         if rHandBodyArmor.rLimit <> 0 then begin
            Result := Result + format(Conv('掌法身体防御 : %d (%s)'),[rHandBodyArmor.rValue, MagicClass.GetPowerLevelName (rHandBodyArmor.rLimit)]) + #13;
         end else begin
            Result := Result + format(Conv('掌法身体防御: %d'),[rHandBodyArmor.rValue]) + #13;
         end;
      end;
      
      if rApproachSpd.rValue <> 0 then begin
         if rApproachSpd.rLimit <> 0 then begin
            Result := Result + format(Conv('近距离攻击速度: %d(%s)'),[-rApproachSpd.rValue, MagicClass.GetPowerLevelName (rApproachSpd.rLimit)]) + #13;
         end else begin
            Result := Result + format(Conv('近距离攻击速度 : %d'),[-rApproachSpd.rValue]) + #13;
         end;
      end;
      
      if rApproachAccuracy.rValue  <> 0 then begin
         if  rApproachAccuracy.rLimit <> 0 then begin
            Result := Result + format(Conv('近距离 命中率: %d (%s)'),[rApproachAccuracy.rValue, MagicClass.GetPowerLevelName (rApproachAccuracy.rLimit)]) + #13;
         end else begin
            Result := Result + format(Conv('近距离命中率 : %d'),[rApproachAccuracy.rValue]) + #13;
         end;
      end;
      
      if rApproachKeepRecovery.rValue <> 0 then begin
         if rApproachKeepRecovery.rLimit <> 0 then begin
            Result := Result + format(Conv('近距离姿势维持: %d (%s)'),[rApproachKeepRecovery.rValue, MagicClass.GetPowerLevelName (rApproachKeepRecovery.rLimit)]) + #13;
         end else begin
            Result := Result + format(Conv('近距离姿势维持 : %d'),[rApproachKeepRecovery.rValue]) + #13;
         end;
      end;

      if rApproachAvoid.rValue  <> 0 then begin
         if rApproachAvoid.rLimit <> 0 then begin
            Result := Result + format(Conv('近距离躲闪 : %d (%s)'),[rApproachAvoid.rValue, MagicClass.GetPowerLevelName (rApproachAvoid.rLimit)]) + #13;
         end else begin
            Result := Result + format(Conv('近距离躲闪 : %d'),[rApproachAvoid.rValue]) + #13;
         end;
      end;
      
      if rApproachBodyArmor.rValue <> 0 then begin
         if rApproachBodyArmor.rLimit <> 0 then begin
            Result := Result + format(Conv('近距离身体防御 : %d (%s)'),[rApproachBodyArmor.rValue, MagicClass.GetPowerLevelName (rApproachBodyArmor.rLimit)]) + #13;
         end else begin
            Result := Result + format(Conv('近距离身体防御 : %d'),[rApproachBodyArmor.rValue]) + #13;
         end;
      end;
      
      if rApproachHeadArmor.rValue <> 0 then begin
         if rApproachHeadArmor.rLimit <> 0 then begin
            Result := Result + format(Conv('近距离头部防御 : %d (%s)'),[rApproachHeadArmor.rValue, MagicClass.GetPowerLevelName (rApproachHeadArmor.rLimit)]) + #13;
         end else begin
            Result := Result + format(Conv('近距离头部防御 : %d'),[rApproachHeadArmor.rValue]) + #13;
         end;
      end;
      
      if rApproachArmArmor.rValue <> 0 then begin
         if rApproachArmArmor.rLimit <> 0 then begin
            Result := Result + format(Conv('近距离臂防御 : %d (%s)'),[rApproachArmArmor.rValue, MagicClass.GetPowerLevelName (rApproachArmArmor.rLimit)]) + #13;
         end else begin
            Result := Result + format(Conv('近距离臂防御 : %d'),[rApproachArmArmor.rValue]) + #13;
         end;
      end;

      if rApproachLegArmor.rValue <> 0 then begin
         if rApproachLegArmor.rLimit <> 0 then begin
            Result := Result + format(Conv('近距离腿防御 : %d (%s)'),[rApproachLegArmor.rValue, MagicClass.GetPowerLevelName (rApproachLegArmor.rLimit)]) + #13;
         end else begin
            Result := Result + format(Conv('近距离腿防御 : %d'),[rApproachLegArmor.rValue]) + #13;
         end;
      end;
      
      if rAddBodyDamage.rValue <> 0 then begin
         if rAddBodyDamage.rLimit <> 0 then begin
            Result := Result + format(Conv('身体攻击力增加 : %d (%s)'),[rAddBodyDamage.rValue, MagicClass.GetPowerLevelName (rAddBodyDamage.rLimit)]) + #13;
         end else begin
            Result := Result + format(Conv('身体攻击力增加 : %d'),[rAddBodyDamage.rValue]) + #13;
         end;
      end;

      if rAddHeadDamage.rValue <> 0 then begin
         if  rAddHeadDamage.rLimit <> 0 then begin
            Result := Result + format(Conv('头部攻击力增加 : %d (%s)'),[rAddHeadDamage.rValue, MagicClass.GetPowerLevelName (rAddHeadDamage.rLimit)]) + #13;
         end else begin
            Result := Result + format(Conv('头部攻击力增加 : %d'),[rAddHeadDamage.rValue]) + #13;
         end;
      end;

      if rAddArmDamage.rValue <> 0 then begin
         if rAddArmDamage.rLimit <> 0 then begin
            Result := Result + format(Conv('臂攻击力增加 : %d (%s)'),[rAddArmDamage.rValue, MagicClass.GetPowerLevelName (rAddArmDamage.rLimit)]) + #13;
         end else begin
            Result := Result + format(Conv('臂 攻击力增加: %d'),[rAddArmDamage.rValue]) + #13;
         end;
      end;

      if rAddLegDamage.rValue <> 0 then begin
         if rAddLegDamage.rLimit <> 0 then begin
            Result := Result + format(Conv('腿 攻击力增加 : %d (%s)'),[rAddLegDamage.rValue, MagicClass.GetPowerLevelName (rAddLegDamage.rLimit)]) + #13;
         end else begin
            Result := Result + format(Conv('腿部攻击力增加 : %d'),[rAddLegDamage.rValue]) + #13;
         end;
      end;
      
      if rEnergyRegenDec.rValue <> 0 then begin
         if rEnergyRegenDec.rLimit <> 0 then begin
            Result := Result + format(Conv('元气减少 %d (%s)'),[rEnergyRegenDec.rValue, MagicClass.GetPowerLevelName (rEnergyRegenDec.rLimit)]) + #13;
         end else begin
            Result := Result + format(Conv('元气减少%d'),[rEnergyRegenDec.rValue]) + #13;
         end;
      end;
      if rBasicValueDec.rValue <> 0 then begin
         if rBasicValueDec.rLimit <> 0 then begin
            Result := Result + format(Conv('内外功消耗减少 : %d %%(%s)'),[rBasicValueDec.rValue, MagicClass.GetPowerLevelName (rBasicValueDec.rLimit)]) + #13;
         end else begin
            Result := Result + format(Conv('内外功消耗减少: %d %%'),[rBasicValueDec.rValue]) + #13;
         end;
      end;
   end;
end;

function  GetLifeDataInfo (var aLifeData: TLifeData): string;
var
   str , str1 : String;
begin
   str := '';
   str1 := format ('damagebody : %d',[aLifeData.damageBody]);
   str := str + str1 + #13;
   str1 := format ('damageHead : %d',[aLifeData.damageHead]);
   str := str + str1 + #13;
   str1 := format ('damageArm : %d',[aLifeData.damageArm]);
   str := str + str1 + #13;
   str1 := format ('damageLeg : %d',[aLifeData.damageLeg]);
   str := str + str1 + #13;
   str1 := format ('armorBody : %d',[aLifeData.armorBody]);
   str := str + str1 + #13;
   str1 := format ('armorHead : %d',[aLifeData.armorHead]);
   str := str + str1 + #13;
   str1 := format ('armorArm : %d',[aLifeData.armorArm]);
   str := str + str1 + #13;
   str1 := format ('armorLeg : %d',[aLifeData.armorLeg]);
   str := str + str1 + #13;
   str1 := format ('AttackSpeed : %d',[aLifeData.AttackSpeed]);
   str := str + str1 + #13;
   str1 := format ('Accuracy : %d',[aLifeData.Accuracy]);
   str := str + str1 + #13;
   str1 := format ('avoid : %d',[aLifeData.avoid]);
   str := str + str1 + #13;
   str1 := format ('KeepRecovery : %d',[aLifeData.KeepRecovery]);
   str := str + str1 + #13;
   str1 := format ('recovery : %d',[aLifeData.recovery]);
   str := str + str1 + #13;
   str1 := format ('HitArmor : %d',[aLifeData.HitArmor]);
   str := str + str1 + #13;
   str1 := format ('damageExp : %d',[aLifeData.damageExp]);
   str := str + str1 + #13;
   str1 := format ('armorExp : %d',[aLifeData.armorExp]);
   str := str + str1 + #13;
   Result := str;
end;

function GetMiniItemContents (var aItemData: TItemData): string;
begin
   Result := '';

   if aItemData.rName[0] = 0 then exit;

   if aItemData.rDesc [0] <> 0 then begin
      Result := Result + StrPas (@aItemData.rDesc) + '<br>';
   end;

   if aItemData.rDurability <> 0 then begin
      Result := Result + format (Conv('耐力: %d/%d'),[aItemData.rCurDurability, aItemData.rDurability]) + '<br>';
   end;

   with aItemData.rLifeData do begin
      if (AttackSpeed <> 0) or (Recovery <> 0) or (Avoid <> 0) or (Accuracy <> 0) or (KeepRecovery <> 0) or
         (DamageBody <> 0) or (DamageHead <> 0) or (DamageArm <> 0) or (DamageLeg <> 0) or
         (ArmorBody <> 0) or (ArmorHead <> 0) or (ArmorArm <> 0) or (ArmorLeg <> 0) then begin
         Result := Result + format (Conv('攻击速度: %d'), [-AttackSpeed]) + '<br>';
         Result := Result + format (Conv('恢复: %d 躲闪: %d'), [-Recovery, Avoid]) + '<br>';
         Result := Result + format (Conv('准确度: %d 姿势维持: %d'), [Accuracy, KeepRecovery]) + '<br>';
         Result := Result + format (Conv('破坏力: %d / %d / %d / %d'),[DamageBody, DamageHead, DamageArm, DamageLeg]) + '<br>';
         Result := Result + format (Conv('防御力:  %d / %d / %d / %d'),[ArmorBody, ArmorHead, ArmorArm, ArmorLeg]) + '<br>';
      end;
   end;
   if aItemData.rAddType = 0 then exit;

   with aItemData.rAddAttribData do begin
      if rBowAttSpd.rValue <> 0 then begin
         if rBowAttSpd.rLimit <> 0 then begin
            Result := Result + format(Conv('远距离攻击速度 : %d (%s)'),[-rBowAttSpd.rValue, MagicClass.GetPowerLevelName(rBowAttSpd.rLimit)]) + '<br>';
         end else begin
            Result := Result + format(Conv('远距离攻击速度 : %d'),[-rBowAttSpd.rValue]) + '<br>';
         end;
      end;
      if rBowAccuracy.rValue <> 0 then begin
         if rBowAccuracy.rLimit <> 0 then begin
            Result := Result + format (Conv('远距离命中率: %d(%s)'),[rBowAccuracy.rValue, MagicClass.GetPowerLevelName (rBowAccuracy.rLimit)]) + '<br>';
         end else begin
            Result := Result + format (Conv('远距离命中率: %d'),[rBowAccuracy.rValue]) + '<br>';
         end;
      end;

      if rBowKeepRecovery.rValue <> 0 then begin
         if rBowKeepRecovery.rLimit <> 0 then begin
            Result := Result + format (Conv('远距离维持: %d (%s)'),[rBowKeepRecovery.rValue, MagicClass.GetPowerLevelName (rBowKeepRecovery.rLimit)]) + '<br>';
         end else begin
            Result := Result + format (Conv('远距离维持: %d'),[rBowKeepRecovery.rValue]) + '<br>';
         end;
      end;
      
      if rBowAvoid.rValue <> 0 then begin
         if rBowAvoid.rLimit <> 0 then begin
            Result := Result + format (Conv('远距离躲闪 : %d (%s)'),[rBowAvoid.rValue, MagicClass.GetPowerLevelName (rBowAvoid.rLimit)]) + '<br>';
         end else begin
            Result := Result + format (Conv('远距离躲闪: %d'),[rBowAvoid.rValue]) + '<br>';
         end;
      end;

      if rBowBodyArmor.rValue <> 0 then begin
         if rBowBodyArmor.rLimit <> 0 then begin
            Result := Result + format (Conv('远距离身体防御: %d (%s)'),[rBowBodyArmor.rValue, MagicClass.GetPowerLevelName (rBowBodyArmor.rLimit)]) + '<br>';
         end else begin
            Result := Result + format (Conv('远距离身体防御 : %d'),[rBowBodyArmor.rValue]) + '<br>';
         end;
      end;

      if rBowHeadArmor.rValue <> 0 then begin
         if rBowHeadArmor.rLimit <> 0 then begin
            Result := Result + format (Conv('远距离头防御 : %d (%s)'),[rBowHeadArmor.rValue, MagicClass.GetPowerLevelName (rBowHeadArmor.rLimit)]) + '<br>';
         end else begin
            Result := Result + format (Conv('远距离头防御 : %d'),[rBowHeadArmor.rValue]) + '<br>';
         end;
      end;

      if rBowArmArmor.rValue <> 0 then begin
         if rBowArmArmor.rLimit <> 0 then begin
            Result := Result + format (Conv('远距离臂防御 : %d (%s)'),[rBowArmArmor.rValue, MagicClass.GetPowerLevelName (rBowArmArmor.rLimit)]) + '<br>';
         end else begin
            Result := Result + format (Conv('远距离臂防御 : %d'),[rBowArmArmor.rValue]) + '<br>';
         end;
      end;

      if rBowLegArmor.rValue <> 0 then begin
         if rBowLegArmor.rLimit <> 0 then begin
            Result := Result + format (Conv('远距离腿防御 : %d (%s)'),[rBowLegArmor.rValue, MagicClass.GetPowerLevelName (rBowLegArmor.rLimit)]) + '<br>';
         end else begin
            Result := Result + format (Conv('远距离腿防御 : %d'),[rBowLegArmor.rValue]) + '<br>';
         end;
      end;

      if rHandSpd.rValue <> 0 then begin
         if rHandSpd.rLimit <> 0 then begin
            Result := Result + format(Conv('掌法攻击速度 : %d (%s)'),[-rHandSpd.rValue, MagicClass.GetPowerLevelName (rHandSpd.rLimit)]) + '<br>';
         end else begin
            Result := Result + format(Conv('掌法攻击速度 : %d'),[-rHandSpd.rValue]) + '<br>';
         end;
      end;

      if rHandAccuracy.rValue <> 0 then begin
         if rHandAccuracy.rLimit <> 0 then begin
            Result := Result + format(Conv('掌法命中率 : %d (%s)'),[rHandAccuracy.rValue, MagicClass.GetPowerLevelName (rHandAccuracy.rLimit)]) + '<br>';
         end else begin
            Result := Result + format(Conv('掌法命中率 : %d'),[rHandAccuracy.rValue]) + '<br>';
         end;
      end;

      if rHandKeepRecovery.rValue <> 0 then begin
         if rHandKeepRecovery.rLimit <> 0 then begin
            Result := Result + format(Conv('掌法 维持 : %d (%s)'),[rHandKeepRecovery.rValue, MagicClass.GetPowerLevelName (rHandKeepRecovery.rLimit)]) + '<br>';
         end else begin
            Result := Result + format(Conv('掌法 维持 : %d '),[rHandKeepRecovery.rValue]) + '<br>';
         end;
      end;
      
      if rHandMinValue.rValue <> 0 then begin
         if rHandMinValue.rLimit <> 0 then begin
            Result := Result + format(Conv('掌法最小距离 : %d (%s)'),[rHandMinValue.rValue, MagicClass.GetPowerLevelName (rHandMinValue.rLimit)]) + '<br>';
         end else begin
            Result := Result + format(Conv('掌法最小距离 : %d'),[rHandMinValue.rValue]) + '<br>';
         end;
      end;

      if rHandMaxValue.rValue <> 0 then begin
         if rHandMaxValue.rLimit <> 0 then begin
            Result := Result + format(Conv('掌法最大距离 : %d (%s)'),[rHandMaxValue.rValue, MagicClass.GetPowerLevelName (rHandMaxValue.rLimit)]) + '<br>';
         end else begin
            Result := Result + format(Conv('掌法最大距离 : %d'),[rHandMaxValue.rValue]) + '<br>';
         end;
      end;

      if rHandBodyArmor.rValue <> 0 then begin
         if rHandBodyArmor.rLimit <> 0 then begin
            Result := Result + format(Conv('掌法身体防御 : %d (%s)'),[rHandBodyArmor.rValue, MagicClass.GetPowerLevelName (rHandBodyArmor.rLimit)]) + '<br>';
         end else begin
            Result := Result + format(Conv('掌法身体防御: %d'),[rHandBodyArmor.rValue]) + '<br>';
         end;
      end;

      if rApproachSpd.rValue <> 0 then begin
         if rApproachSpd.rLimit <> 0 then begin
            Result := Result + format(Conv('近距离攻击速度: %d(%s)'),[-rApproachSpd.rValue, MagicClass.GetPowerLevelName (rApproachSpd.rLimit)]) + '<br>';
         end else begin
            Result := Result + format(Conv('近距离攻击速度 : %d'),[-rApproachSpd.rValue]) + '<br>';
         end;
      end;

      if rApproachAccuracy.rValue  <> 0 then begin
         if  rApproachAccuracy.rLimit <> 0 then begin
            Result := Result + format(Conv('近距离 命中率: %d (%s)'),[rApproachAccuracy.rValue, MagicClass.GetPowerLevelName (rApproachAccuracy.rLimit)]) + '<br>';
         end else begin
            Result := Result + format(Conv('近距离命中率 : %d'),[rApproachAccuracy.rValue]) + '<br>';
         end;
      end;

      if rApproachKeepRecovery.rValue <> 0 then begin
         if rApproachKeepRecovery.rLimit <> 0 then begin
            Result := Result + format(Conv('近距离姿势维持: %d (%s)'),[rApproachKeepRecovery.rValue, MagicClass.GetPowerLevelName (rApproachKeepRecovery.rLimit)]) + '<br>';
         end else begin
            Result := Result + format(Conv('近距离姿势维持 : %d'),[rApproachKeepRecovery.rValue]) + '<br>';
         end;
      end;

      if rApproachAvoid.rValue  <> 0 then begin
         if rApproachAvoid.rLimit <> 0 then begin
            Result := Result + format(Conv('近距离躲闪 : %d (%s)'),[rApproachAvoid.rValue, MagicClass.GetPowerLevelName (rApproachAvoid.rLimit)]) + '<br>';
         end else begin
            Result := Result + format(Conv('近距离躲闪 : %d'),[rApproachAvoid.rValue]) + '<br>';
         end;
      end;

      if rApproachBodyArmor.rValue <> 0 then begin
         if rApproachBodyArmor.rLimit <> 0 then begin
            Result := Result + format(Conv('近距离身体防御 : %d (%s)'),[rApproachBodyArmor.rValue, MagicClass.GetPowerLevelName (rApproachBodyArmor.rLimit)]) + '<br>';
         end else begin
            Result := Result + format(Conv('近距离身体防御 : %d'),[rApproachBodyArmor.rValue]) + '<br>';
         end;
      end;

      if rApproachHeadArmor.rValue <> 0 then begin
         if rApproachHeadArmor.rLimit <> 0 then begin
            Result := Result + format(Conv('近距离头部防御 : %d (%s)'),[rApproachHeadArmor.rValue, MagicClass.GetPowerLevelName (rApproachHeadArmor.rLimit)]) + '<br>';
         end else begin
            Result := Result + format(Conv('近距离头部防御 : %d'),[rApproachHeadArmor.rValue]) + '<br>';
         end;
      end;

      if rApproachArmArmor.rValue <> 0 then begin
         if rApproachArmArmor.rLimit <> 0 then begin
            Result := Result + format(Conv('近距离臂防御 : %d (%s)'),[rApproachArmArmor.rValue, MagicClass.GetPowerLevelName (rApproachArmArmor.rLimit)]) + '<br>';
         end else begin
            Result := Result + format(Conv('近距离臂防御 : %d'),[rApproachArmArmor.rValue]) + '<br>';
         end;
      end;

      if rApproachLegArmor.rValue <> 0 then begin
         if rApproachLegArmor.rLimit <> 0 then begin
            Result := Result + format(Conv('近距离腿防御 : %d (%s)'),[rApproachLegArmor.rValue, MagicClass.GetPowerLevelName (rApproachLegArmor.rLimit)]) + '<br>';
         end else begin
            Result := Result + format(Conv('近距离腿防御 : %d'),[rApproachLegArmor.rValue]) + '<br>';
         end;
      end;

      if rAddBodyDamage.rValue <> 0 then begin
         if rAddBodyDamage.rLimit <> 0 then begin
            Result := Result + format(Conv('身体攻击力增加 : %d (%s)'),[rAddBodyDamage.rValue, MagicClass.GetPowerLevelName (rAddBodyDamage.rLimit)]) + '<br>';
         end else begin
            Result := Result + format(Conv('身体攻击力增加 : %d'),[rAddBodyDamage.rValue]) + '<br>';
         end;
      end;

      if rAddHeadDamage.rValue <> 0 then begin
         if  rAddHeadDamage.rLimit <> 0 then begin
            Result := Result + format(Conv('头部攻击力增加 : %d (%s)'),[rAddHeadDamage.rValue, MagicClass.GetPowerLevelName (rAddHeadDamage.rLimit)]) + '<br>';
         end else begin
            Result := Result + format(Conv('头部攻击力增加 : %d'),[rAddHeadDamage.rValue]) + '<br>';
         end;
      end;

      if rAddArmDamage.rValue <> 0 then begin
         if rAddArmDamage.rLimit <> 0 then begin
            Result := Result + format(Conv('臂攻击力增加 : %d (%s)'),[rAddArmDamage.rValue, MagicClass.GetPowerLevelName (rAddArmDamage.rLimit)]) + '<br>';
         end else begin
            Result := Result + format(Conv('臂 攻击力增加: %d'),[rAddArmDamage.rValue]) + '<br>';
         end;
      end;

      if rAddLegDamage.rValue <> 0 then begin
         if rAddLegDamage.rLimit <> 0 then begin
            Result := Result + format(Conv('腿 攻击力增加 : %d (%s)'),[rAddLegDamage.rValue, MagicClass.GetPowerLevelName (rAddLegDamage.rLimit)]) + '<br>';
         end else begin
            Result := Result + format(Conv('腿部攻击力增加 : %d'),[rAddLegDamage.rValue]) + '<br>';
         end;
      end;
      
      if rEnergyRegenDec.rValue <> 0 then begin
         if rEnergyRegenDec.rLimit <> 0 then begin
            Result := Result + format(Conv('元气减少 %d (%s)'),[rEnergyRegenDec.rValue, MagicClass.GetPowerLevelName (rEnergyRegenDec.rLimit)]) + '<br>';
         end else begin
            Result := Result + format(Conv('元气减少%d'),[rEnergyRegenDec.rValue]) + '<br>';
         end;
      end;
      if rBasicValueDec.rValue <> 0 then begin
         if rBasicValueDec.rLimit <> 0 then begin
            Result := Result + format(Conv('内外功消耗减少 : %d %%(%s)'),[rBasicValueDec.rValue, MagicClass.GetPowerLevelName (rBasicValueDec.rLimit)]) + '<br>';
         end else begin
            Result := Result + format(Conv('内外功消耗减少: %d %%'),[rBasicValueDec.rValue]) + '<br>';
         end;
      end;
   end;
end;

function GetMiniItemContents2 (var aItemData: TItemData; aPowerLevel : Integer): string;
begin
   Result := '';

   if aItemData.rName[0] = 0 then exit;
   if aPowerLevel < 0 then exit;
   
   if aItemData.rDesc [0] <> 0 then begin
      Result := Result + StrPas (@aItemData.rDesc) + '<br>';
   end;

   if aItemData.rDurability <> 0 then begin
      Result := Result + format (Conv('耐力: %d/%d'),[aItemData.rCurDurability, aItemData.rDurability]) + '<br>';
   end;

   with aItemData.rLifeData do begin
      if AttackSpeed <> 0 then begin
         Result := Result + format (Conv('攻击速度: %d'), [-AttackSpeed]) + '<br>';
      end;
      if ( Recovery <> 0) or ( Avoid <> 0) then begin
         Result := Result + format (Conv('恢复: %d 躲闪: %d'), [-Recovery, Avoid]) + '<br>';
      end;
      if (Accuracy <> 0) or (KeepRecovery <> 0) then begin
         Result := Result + format (Conv('准确度: %d 姿势维持: %d'), [Accuracy, KeepRecovery]) + '<br>';
      end;
      if (DamageBody <> 0) or (DamageHead <> 0) or (DamageArm <> 0) or (DamageLeg <> 0) then begin
         Result := Result + format (Conv('破坏力: %d / %d / %d / %d'),[DamageBody, DamageHead, DamageArm, DamageLeg]) + '<br>';
      end;
      if (ArmorBody <> 0) or (ArmorHead <> 0) or (ArmorArm <> 0) or (ArmorLeg <> 0) then begin
         Result := Result + format (Conv('防御力:  %d / %d / %d / %d'),[ArmorBody, ArmorHead, ArmorArm, ArmorLeg]) + '<br>';
      end;
   end;
//   if aItemData.rAddType = 0 then exit;

   with aItemData.rAddAttribData do begin
      Result := Result + '<br>';
      if rBowAttSpd.rValue <> 0 then begin
         if rBowAttSpd.rLimit <> 0 then begin
            if rBowAttSpd.rLimit > aPowerLevel then begin
               Result := Result + '<c1>';
            end;
            
            Result := Result + format(Conv('远距离攻击速度 : %d (%s)'),[-rBowAttSpd.rValue, MagicClass.GetPowerLevelName(rBowAttSpd.rLimit)]) + '<br>';

         end else begin
            Result := Result + format(Conv('远距离攻击速度 : %d'),[-rBowAttSpd.rValue]) + '<br>';
         end;
      end;
      if rBowAccuracy.rValue <> 0 then begin
         if rBowAccuracy.rLimit <> 0 then begin
            if rBowAccuracy.rLimit > aPowerLevel then begin
               Result := Result + '<c1>';
            end;
            Result := Result + format (Conv('远距离命中率: %d(%s)'),[rBowAccuracy.rValue, MagicClass.GetPowerLevelName (rBowAccuracy.rLimit)]) + '<br>';
         end else begin
            Result := Result + format (Conv('远距离命中率: %d'),[rBowAccuracy.rValue]) + '<br>';
         end;
      end;

      if rBowKeepRecovery.rValue <> 0 then begin
         if rBowKeepRecovery.rLimit <> 0 then begin
            if rBowKeepRecovery.rLimit > aPowerLevel then begin
               Result := Result + '<c1>';
            end;
            Result := Result + format (Conv('远距离维持: %d (%s)'),[rBowKeepRecovery.rValue, MagicClass.GetPowerLevelName (rBowKeepRecovery.rLimit)]) + '<br>';
         end else begin
            Result := Result + format (Conv('远距离维持: %d'),[rBowKeepRecovery.rValue]) + '<br>';
         end;
      end;

      if rBowAvoid.rValue <> 0 then begin
         if rBowAvoid.rLimit <> 0 then begin
            if rBowAvoid.rLimit > aPowerLevel then begin
               Result := Result + '<c1>';
            end;
            Result := Result + format (Conv('远距离躲闪 : %d (%s)'),[rBowAvoid.rValue, MagicClass.GetPowerLevelName (rBowAvoid.rLimit)]) + '<br>';
         end else begin
            Result := Result + format (Conv('远距离躲闪: %d'),[rBowAvoid.rValue]) + '<br>';
         end;
      end;

      if rBowBodyArmor.rValue <> 0 then begin
         if rBowBodyArmor.rLimit <> 0 then begin
            if rBowBodyArmor.rLimit > aPowerLevel then begin
               Result := Result + '<c1>';
            end;
            Result := Result + format (Conv('远距离身体防御: %d (%s)'),[rBowBodyArmor.rValue, MagicClass.GetPowerLevelName (rBowBodyArmor.rLimit)]) + '<br>';
         end else begin
            Result := Result + format (Conv('远距离身体防御 : %d'),[rBowBodyArmor.rValue]) + '<br>';
         end;
      end;

      if rBowHeadArmor.rValue <> 0 then begin
         if rBowHeadArmor.rLimit <> 0 then begin
            if rBowHeadArmor.rLimit > aPowerLevel then begin
               Result := Result + '<c1>';
            end;
            Result := Result + format (Conv('远距离头防御 : %d (%s)'),[rBowHeadArmor.rValue, MagicClass.GetPowerLevelName (rBowHeadArmor.rLimit)]) + '<br>';
         end else begin
            Result := Result + format (Conv('远距离头防御 : %d'),[rBowHeadArmor.rValue]) + '<br>';
         end;
      end;

      if rBowArmArmor.rValue <> 0 then begin
         if rBowArmArmor.rLimit <> 0 then begin
            if rBowArmArmor.rLimit > aPowerLevel then begin
               Result := Result + '<c1>';
            end;
            Result := Result + format (Conv('远距离臂防御 : %d (%s)'),[rBowArmArmor.rValue, MagicClass.GetPowerLevelName (rBowArmArmor.rLimit)]) + '<br>';
         end else begin
            Result := Result + format (Conv('远距离臂防御 : %d'),[rBowArmArmor.rValue]) + '<br>';
         end;
      end;

      if rBowLegArmor.rValue <> 0 then begin
         if rBowLegArmor.rLimit <> 0 then begin
            if rBowLegArmor.rLimit > aPowerLevel then begin
               Result := Result + '<c1>';
            end;
            Result := Result + format (Conv('远距离腿防御 : %d (%s)'),[rBowLegArmor.rValue, MagicClass.GetPowerLevelName (rBowLegArmor.rLimit)]) + '<br>';
         end else begin
            Result := Result + format (Conv('远距离腿防御 : %d'),[rBowLegArmor.rValue]) + '<br>';
         end;
      end;

      if rHandSpd.rValue <> 0 then begin
         if rHandSpd.rLimit <> 0 then begin
            if rHandSpd.rLimit > aPowerLevel then begin
               Result := Result + '<c1>';
            end;
            Result := Result + format(Conv('掌法攻击速度 : %d (%s)'),[-rHandSpd.rValue, MagicClass.GetPowerLevelName (rHandSpd.rLimit)]) + '<br>';
         end else begin
            Result := Result + format(Conv('掌法攻击速度 : %d'),[-rHandSpd.rValue]) + '<br>';
         end;
      end;

      if rHandAccuracy.rValue <> 0 then begin
         if rHandAccuracy.rLimit <> 0 then begin
            if rHandAccuracy.rLimit > aPowerLevel then begin
               Result := Result + '<c1>';
            end;
            Result := Result + format(Conv('掌法命中率 : %d (%s)'),[rHandAccuracy.rValue, MagicClass.GetPowerLevelName (rHandAccuracy.rLimit)]) + '<br>';
         end else begin
            Result := Result + format(Conv('掌法命中率 : %d'),[rHandAccuracy.rValue]) + '<br>';
         end;
      end;

      if rHandKeepRecovery.rValue <> 0 then begin
         if rHandKeepRecovery.rLimit <> 0 then begin
            if rHandKeepRecovery.rLimit > aPowerLevel then begin
               Result := Result + '<c1>';
            end;
            Result := Result + format(Conv('掌法 维持 : %d (%s)'),[rHandKeepRecovery.rValue, MagicClass.GetPowerLevelName (rHandKeepRecovery.rLimit)]) + '<br>';
         end else begin
            Result := Result + format(Conv('掌法 维持 : %d '),[rHandKeepRecovery.rValue]) + '<br>';
         end;
      end;

      if rHandMinValue.rValue <> 0 then begin
         if rHandMinValue.rLimit <> 0 then begin
            if rHandMinValue.rLimit > aPowerLevel then begin
               Result := Result + '<c1>';
            end;
            Result := Result + format(Conv('掌法最小距离 : %d (%s)'),[rHandMinValue.rValue, MagicClass.GetPowerLevelName (rHandMinValue.rLimit)]) + '<br>';
         end else begin
            Result := Result + format(Conv('掌法最小距离 : %d'),[rHandMinValue.rValue]) + '<br>';
         end;
      end;

      if rHandMaxValue.rValue <> 0 then begin
         if rHandMaxValue.rLimit <> 0 then begin
            if rHandMaxValue.rLimit > aPowerLevel then begin
               Result := Result + '<c1>';
            end;
            Result := Result + format(Conv('掌法最大距离 : %d (%s)'),[rHandMaxValue.rValue, MagicClass.GetPowerLevelName (rHandMaxValue.rLimit)]) + '<br>';
         end else begin
            Result := Result + format(Conv('掌法最大距离 : %d'),[rHandMaxValue.rValue]) + '<br>';
         end;
      end;

      if rHandBodyArmor.rValue <> 0 then begin
         if rHandBodyArmor.rLimit <> 0 then begin
            if rHandBodyArmor.rLimit > aPowerLevel then begin
               Result := Result + '<c1>';
            end;
            Result := Result + format(Conv('掌法身体防御 : %d (%s)'),[rHandBodyArmor.rValue, MagicClass.GetPowerLevelName (rHandBodyArmor.rLimit)]) + '<br>';
         end else begin
            Result := Result + format(Conv('掌法身体防御: %d'),[rHandBodyArmor.rValue]) + '<br>';
         end;
      end;

      if rApproachSpd.rValue <> 0 then begin
         if rApproachSpd.rLimit <> 0 then begin
            if rApproachSpd.rLimit > aPowerLevel then begin
               Result := Result + '<c1>';
            end;
            Result := Result + format(Conv('近距离攻击速度: %d(%s)'),[-rApproachSpd.rValue, MagicClass.GetPowerLevelName (rApproachSpd.rLimit)]) + '<br>';
         end else begin
            Result := Result + format(Conv('近距离攻击速度 : %d'),[-rApproachSpd.rValue]) + '<br>';
         end;
      end;

      if rApproachAccuracy.rValue  <> 0 then begin
         if  rApproachAccuracy.rLimit <> 0 then begin
            if rApproachAccuracy.rLimit > aPowerLevel then begin
               Result := Result + '<c1>';
            end;
            Result := Result + format(Conv('近距离 命中率: %d (%s)'),[rApproachAccuracy.rValue, MagicClass.GetPowerLevelName (rApproachAccuracy.rLimit)]) + '<br>';
         end else begin
            Result := Result + format(Conv('近距离命中率 : %d'),[rApproachAccuracy.rValue]) + '<br>';
         end;
      end;

      if rApproachKeepRecovery.rValue <> 0 then begin
         if rApproachKeepRecovery.rLimit <> 0 then begin
            if rApproachKeepRecovery.rLimit > aPowerLevel then begin
               Result := Result + '<c1>';
            end;
            Result := Result + format(Conv('近距离姿势维持: %d (%s)'),[rApproachKeepRecovery.rValue, MagicClass.GetPowerLevelName (rApproachKeepRecovery.rLimit)]) + '<br>';
         end else begin
            Result := Result + format(Conv('近距离姿势维持 : %d'),[rApproachKeepRecovery.rValue]) + '<br>';
         end;
      end;

      if rApproachAvoid.rValue  <> 0 then begin
         if rApproachAvoid.rLimit <> 0 then begin
            if rApproachAvoid.rLimit > aPowerLevel then begin
               Result := Result + '<c1>';
            end;
            Result := Result + format(Conv('近距离躲闪 : %d (%s)'),[rApproachAvoid.rValue, MagicClass.GetPowerLevelName (rApproachAvoid.rLimit)]) + '<br>';
         end else begin
            Result := Result + format(Conv('近距离躲闪 : %d'),[rApproachAvoid.rValue]) + '<br>';
         end;
      end;

      if rApproachBodyArmor.rValue <> 0 then begin
         if rApproachBodyArmor.rLimit <> 0 then begin
            if rApproachBodyArmor.rLimit > aPowerLevel then begin
               Result := Result + '<c1>';
            end;
            Result := Result + format(Conv('近距离身体防御 : %d (%s)'),[rApproachBodyArmor.rValue, MagicClass.GetPowerLevelName (rApproachBodyArmor.rLimit)]) + '<br>';
         end else begin
            Result := Result + format(Conv('近距离身体防御 : %d'),[rApproachBodyArmor.rValue]) + '<br>';
         end;
      end;

      if rApproachHeadArmor.rValue <> 0 then begin
         if rApproachHeadArmor.rLimit <> 0 then begin
            if rApproachHeadArmor.rLimit > aPowerLevel then begin
               Result := Result + '<c1>';
            end;
            Result := Result + format(Conv('近距离头部防御 : %d (%s)'),[rApproachHeadArmor.rValue, MagicClass.GetPowerLevelName (rApproachHeadArmor.rLimit)]) + '<br>';
         end else begin
            Result := Result + format(Conv('近距离头部防御 : %d'),[rApproachHeadArmor.rValue]) + '<br>';
         end;
      end;

      if rApproachArmArmor.rValue <> 0 then begin
         if rApproachArmArmor.rLimit <> 0 then begin
            if rApproachArmArmor.rLimit > aPowerLevel then begin
               Result := Result + '<c1>';
            end;
            Result := Result + format(Conv('近距离臂防御 : %d (%s)'),[rApproachArmArmor.rValue, MagicClass.GetPowerLevelName (rApproachArmArmor.rLimit)]) + '<br>';
         end else begin
            Result := Result + format(Conv('近距离臂防御 : %d'),[rApproachArmArmor.rValue]) + '<br>';
         end;
      end;

      if rApproachLegArmor.rValue <> 0 then begin
         if rApproachLegArmor.rLimit <> 0 then begin
            if rApproachLegArmor.rLimit > aPowerLevel then begin
               Result := Result + '<c1>';
            end;
            Result := Result + format(Conv('近距离腿防御 : %d (%s)'),[rApproachLegArmor.rValue, MagicClass.GetPowerLevelName (rApproachLegArmor.rLimit)]) + '<br>';
         end else begin
            Result := Result + format(Conv('近距离腿防御 : %d'),[rApproachLegArmor.rValue]) + '<br>';
         end;
      end;

      if rAddBodyDamage.rValue <> 0 then begin
         if rAddBodyDamage.rLimit <> 0 then begin
            if rAddBodyDamage.rLimit > aPowerLevel then begin
               Result := Result + '<c1>';
            end;
            Result := Result + format(Conv('身体攻击力增加 : %d (%s)'),[rAddBodyDamage.rValue, MagicClass.GetPowerLevelName (rAddBodyDamage.rLimit)]) + '<br>';
         end else begin
            Result := Result + format(Conv('身体攻击力增加 : %d'),[rAddBodyDamage.rValue]) + '<br>';
         end;
      end;

      if rAddHeadDamage.rValue <> 0 then begin
         if  rAddHeadDamage.rLimit <> 0 then begin
            if rAddHeadDamage.rLimit > aPowerLevel then begin
               Result := Result + '<c1>';
            end;
            Result := Result + format(Conv('头部攻击力增加 : %d (%s)'),[rAddHeadDamage.rValue, MagicClass.GetPowerLevelName (rAddHeadDamage.rLimit)]) + '<br>';
         end else begin
            Result := Result + format(Conv('头部攻击力增加 : %d'),[rAddHeadDamage.rValue]) + '<br>';
         end;
      end;

      if rAddArmDamage.rValue <> 0 then begin
         if rAddArmDamage.rLimit <> 0 then begin
            if rAddArmDamage.rLimit > aPowerLevel then begin
               Result := Result + '<c1>';
            end;
            Result := Result + format(Conv('臂攻击力增加 : %d (%s)'),[rAddArmDamage.rValue, MagicClass.GetPowerLevelName (rAddArmDamage.rLimit)]) + '<br>';
         end else begin
            Result := Result + format(Conv('臂 攻击力增加: %d'),[rAddArmDamage.rValue]) + '<br>';
         end;
      end;

      if rAddLegDamage.rValue <> 0 then begin
         if rAddLegDamage.rLimit <> 0 then begin
            if rAddLegDamage.rLimit > aPowerLevel then begin
               Result := Result + '<c1>';
            end;
            Result := Result + format(Conv('腿 攻击力增加 : %d (%s)'),[rAddLegDamage.rValue, MagicClass.GetPowerLevelName (rAddLegDamage.rLimit)]) + '<br>';
         end else begin
            Result := Result + format(Conv('腿部攻击力增加 : %d'),[rAddLegDamage.rValue]) + '<br>';
         end;
      end;

      if rEnergyRegenDec.rValue <> 0 then begin
         if rEnergyRegenDec.rLimit <> 0 then begin
            if rEnergyRegenDec.rLimit > aPowerLevel then begin
               Result := Result + '<c1>';
            end;
            Result := Result + format(Conv('元气减少 %d (%s)'),[rEnergyRegenDec.rValue, MagicClass.GetPowerLevelName (rEnergyRegenDec.rLimit)]) + '<br>';
         end else begin
            Result := Result + format(Conv('元气减少%d'),[rEnergyRegenDec.rValue]) + '<br>';
         end;
      end;
      if rBasicValueDec.rValue <> 0 then begin
         if rBasicValueDec.rLimit <> 0 then begin
            if rBasicValueDec.rLimit > aPowerLevel then begin
               Result := Result + '<c1>';
            end;
            Result := Result + format(Conv('内外功消耗减少 : %d %%(%s)'),[rBasicValueDec.rValue, MagicClass.GetPowerLevelName (rBasicValueDec.rLimit)]) + '<br>';
         end else begin
            Result := Result + format(Conv('内外功消耗减少: %d %%'),[rBasicValueDec.rValue]) + '<br>';
         end;
      end;
   end;
end;

procedure GatherAddAttribLifeData (var BaseAddAttribLifeData : TRealAddAttribData; aAddAttribLifeData : TAddAttribData; aPowerLevel : Integer);
begin
   with BaseAddAttribLifeData do begin
      if aAddAttribLifeData.rBowAttSpd.rLimit <= aPowerLevel then rBowAttSpd := rBowAttSpd + aAddAttribLifeData.rBowAttSpd.rValue;
      if aAddAttribLifeData.rBowKeepRecovery.rLimit <= aPowerLevel then rBowKeepRecovery := rBowKeepRecovery + aAddAttribLifeData.rBowKeepRecovery.rValue;
      if aAddAttribLifeData.rBowAccuracy.rLimit <= aPowerLevel then rBowAccuracy := rBowAccuracy + aAddAttribLifeData.rBowAccuracy.rValue;
      if aAddAttribLifeData.rBowAvoid.rLimit <= aPowerLevel then rBowAvoid := rBowAvoid + aAddAttribLifeData.rBowAvoid.rValue;
      if aAddAttribLifeData.rBowBodyArmor.rLimit <= aPowerLevel then rBowBodyArmor := rBowBodyArmor + aAddAttribLifeData.rBowBodyArmor.rValue;
      if aAddAttribLifeData.rBowHeadArmor.rLimit <= aPowerLevel then rBowHeadArmor := rBowHeadArmor + aAddAttribLifeData.rBowHeadArmor.rValue;
      if aAddAttribLifeData.rBowArmArmor.rLimit <= aPowerLevel then rBowArmArmor := rBowArmArmor + aAddAttribLifeData.rBowArmArmor.rValue;
      if aAddAttribLifeData.rBowLegArmor.rLimit <= aPowerLevel then rBowLegArmor := rBowLegArmor + aAddAttribLifeData.rBowLegArmor.rValue;
      if aAddAttribLifeData.rHandSpd.rLimit <= aPowerLevel then rHandSpd := rHandSpd + aAddAttribLifeData.rHandSpd.rValue;
      if aAddAttribLifeData.rHandAccuracy.rLimit <= aPowerLevel then rHandAccuracy := rHandAccuracy + aAddAttribLifeData.rHandAccuracy.rValue;
      if aAddAttribLifeData.rHandKeepRecovery.rLimit <= aPowerLevel then rHandKeepRecovery := rHandKeepRecovery + aAddAttribLifeData.rHandKeepRecovery.rValue;
      if aAddAttribLifeData.rHandMinValue.rLimit <= aPowerLevel then rHandMinValue := rHandMinValue + aAddAttribLifeData.rHandMinValue.rValue;
      if aAddAttribLifeData.rHandMaxValue.rLimit <= aPowerLevel then rHandMaxValue := rHandMaxValue + aAddAttribLifeData.rHandMaxValue.rValue;
      if aAddAttribLifeData.rHandBodyArmor.rLimit <= aPowerLevel then rHandBodyArmor := rHandBodyArmor + aAddAttribLifeData.rHandBodyArmor.rValue;
      if aAddAttribLifeData.rApproachSpd.rLimit <= aPowerLevel then rApproachSpd := rApproachSpd + aAddAttribLifeData.rApproachSpd.rValue;
      if aAddAttribLifeData.rApproachAccuracy.rLimit <= aPowerLevel then rApproachAccuracy := rApproachAccuracy + aAddAttribLifeData.rApproachAccuracy.rValue;
      if aAddAttribLifeData.rApproachKeepRecovery.rLimit <= aPowerLevel then rApproachKeepRecovery := rApproachKeepRecovery + aAddAttribLifeData.rApproachKeepRecovery.rValue;
      if aAddAttribLifeData.rApproachBodyArmor.rLimit <= aPowerLevel then rApproachBodyArmor := rApproachBodyArmor + aAddAttribLifeData.rApproachBodyArmor.rValue;
      if aAddAttribLifeData.rApproachHeadArmor.rLimit <= aPowerLevel then rApproachHeadArmor := rApproachHeadArmor + aAddAttribLifeData.rApproachHeadArmor.rValue;
      if aAddAttribLifeData.rApproachLegArmor.rLimit <= aPowerLevel then rApproachLegArmor := rApproachLegArmor + aAddAttribLifeData.rApproachLegArmor.rValue;
      if aAddAttribLifeData.rApproachArmArmor.rLimit <= aPowerLevel then rApproachArmArmor := rApproachArmArmor + aAddAttribLifeData.rApproachArmArmor.rValue;
      if aAddAttribLifeData.rAddBodyDamage.rLimit <= aPowerLevel then rAddBodyDamage := rAddBodyDamage + aAddAttribLifeData.rAddBodyDamage.rValue;
      if aAddAttribLifeData.rAddHeadDamage.rLimit <= aPowerLevel then rAddHeadDamage := rAddHeadDamage + aAddAttribLifeData.rAddHeadDamage.rValue;
      if aAddAttribLifeData.rAddArmDamage.rLimit <= aPowerLevel then rAddArmDamage := rAddArmDamage + aAddAttribLifeData.rAddArmDamage.rValue;
      if aAddAttribLifeData.rAddLegDamage.rLimit <= aPowerLevel then rAddLegDamage := rAddLegDamage + aAddAttribLifeData.rAddLegDamage.rValue;
      if aAddAttribLifeData.rEnergyRegenDec.rLimit <= aPowerLevel then rEnergyRegenDec := rEnergyRegenDec + aAddAttribLifeData.rEnergyRegenDec.rValue;
      if aAddAttribLifeData.rBasicValueDec.rLimit <= aPowerLevel then rBasicValueDec := rBasicValueDec + aAddAttribLifeData.rBasicValueDec.rValue;
   end;
end;

procedure GatherLifeData (var BaseLifeData, aLifeData: TLifeData);
var
   i : Integer;
begin
   BaseLifeData.DamageBody     := BaseLifeData.DamageBody     + aLifeData.damageBody;
   BaseLifeData.DamageHead     := BaseLifeData.DamageHead     + aLifeData.damageHead;
   BaseLifeData.DamageArm      := BaseLifeData.DamageArm      + aLifeData.damageArm;
   BaseLifeData.DamageLeg      := BaseLifeData.DamageLeg      + aLifeData.damageLeg;
   BaseLifeData.damageenergy   := BaseLifeData.damageenergy   + aLifeData.damageenergy;   
   BaseLifeData.AttackSpeed    := BaseLifeData.AttackSpeed    + aLifeData.AttackSpeed;
   BaseLifeData.Accuracy       := BaseLifeData.Accuracy       + aLifeData.Accuracy;
   BaseLifeData.KeepRecovery   := BaseLifeData.KeepRecovery   + aLifeData.KeepRecovery;
   BaseLifeData.avoid          := BaseLifeData.avoid          + aLifeData.avoid;
   BaseLifeData.recovery       := BaseLifeData.recovery       + aLifeData.recovery;
   BaseLifeData.armorBody      := BaseLifeData.armorBody      + aLifeData.armorBody;
   BaseLifeData.armorhead      := BaseLifeData.armorHead      + aLifeData.armorHead;
   BaseLifeData.armorArm       := BaseLifeData.armorArm       + aLifeData.armorArm;
   BaseLifeData.armorLeg       := BaseLifeData.armorLeg       + aLifeData.armorLeg;
   BaseLifeData.armorenergy    := BaseLifeData.armorenergy    + aLifeData.armorenergy;
   BaseLifeData.armorevalue    := BaseLifeData.armorevalue    + aLifeData.armorevalue;

   BaseLifeData.damageExp      := BaseLifeData.damageExp      + aLifeData.damageExp;
   BaseLifeData.armorExp       := BaseLifeData.armorExp       + aLifeData.armorExp;
   BaseLifeData.longavoid      := BaseLifeData.longavoid      + aLifeData.longavoid;
   for i := 0 to SPELLTYPE_MAX - 1 do begin
      if aLifeData.SpellResistRate [i] > 0 then begin
         BaseLifeData.SpellResistRate [i] := BaseLifeData.SpellResistRate [i] + aLifeData.SpellResistRate [i];
         if BaseLifeData.SpellResistRate [i] > 100 then BaseLifeData.SpellResistRate [i] := 100;
      end;
   end;
end;

procedure GatherAttribLifeData (var BaseAttribLifeData, aAttribLifeData : TRealAddAttribData);
begin
   BaseAttribLifeData.rBowAttSpd := BaseAttribLifeData.rBowAttSpd + aAttribLifeData.rBowAttSpd;
   BaseAttribLifeData.rBowAccuracy := BaseAttribLifeData.rBowAccuracy + aAttribLifeData.rBowAccuracy;
   BaseAttribLifeData.rBowKeepRecovery := BaseAttribLifeData.rBowKeepRecovery + aAttribLifeData.rBowKeepRecovery;
   BaseAttribLifeData.rBowAvoid := BaseAttribLifeData.rBowAvoid + aAttribLifeData.rBowAvoid;
   BaseAttribLifeData.rBowBodyArmor := BaseAttribLifeData.rBowBodyArmor + aAttribLifeData.rBowBodyArmor;
   BaseAttribLifeData.rBowHeadArmor := BaseAttribLifeData.rBowHeadArmor + aAttribLifeData.rBowHeadArmor;
   BaseAttribLifeData.rBowArmArmor := BaseAttribLifeData.rBowArmArmor + aAttribLifeData.rBowArmArmor;
   BaseAttribLifeData.rBowLegArmor := BaseAttribLifeData.rBowLegArmor + aAttribLifeData.rBowLegArmor;
   BaseAttribLifeData.rHandSpd := BaseAttribLifeData.rHandSpd + aAttribLifeData.rHandSpd;
   BaseAttribLifeData.rHandAccuracy := BaseAttribLifeData.rHandAccuracy + aAttribLifeData.rHandAccuracy;
   BaseAttribLifeData.rHandKeepRecovery := BaseAttribLifeData.rHandKeepRecovery + aAttribLifeData.rHandKeepRecovery;
   BaseAttribLifeData.rHandMinValue := BaseAttribLifeData.rHandMinValue + aAttribLifeData.rHandMinValue;
   BaseAttribLifeData.rHandMaxValue := BaseAttribLifeData.rHandMaxValue + aAttribLifeData.rHandMaxValue;
   BaseAttribLifeData.rHandBodyArmor := BaseAttribLifeData.rHandBodyArmor + aAttribLifeData.rHandBodyArmor;
   BaseAttribLifeData.rApproachSpd := BaseAttribLifeData.rApproachSpd + aAttribLifeData.rApproachSpd;
   BaseAttribLifeData.rApproachAccuracy := BaseAttribLifeData.rApproachAccuracy + aAttribLifeData.rApproachAccuracy;
   BaseAttribLifeData.rApproachAvoid := BaseAttribLifeData.rApproachAvoid + aAttribLifeData.rApproachAvoid;
   BaseAttribLifeData.rApproachKeepRecovery := BaseAttribLifeData.rApproachKeepRecovery + aAttribLifeData.rApproachKeepRecovery;
   BaseAttribLifeData.rApproachBodyArmor := BaseAttribLifeData.rApproachBodyArmor + aAttribLifeData.rApproachBodyArmor;
   BaseAttribLifeData.rApproachHeadArmor := BaseAttribLifeData.rApproachHeadArmor + aAttribLifeData.rApproachHeadArmor;
   BaseAttribLifeData.rApproachLegArmor := BaseAttribLifeData.rApproachLegArmor + aAttribLifeData.rApproachLegArmor;
   BaseAttribLifeData.rApproachArmArmor := BaseAttribLifeData.rApproachArmArmor + aAttribLifeData.rApproachArmArmor;
   BaseAttribLifeData.rAddBodyDamage := BaseAttribLifeData.rAddBodyDamage + aAttribLifeData.rAddBodyDamage;
   BaseAttribLifeData.rAddHeadDamage := BaseAttribLifeData.rAddHeadDamage + aAttribLifeData.rAddHeadDamage;
   BaseAttribLifeData.rAddArmDamage := BaseAttribLifeData.rAddArmDamage + aAttribLifeData.rAddArmDamage;
   BaseAttribLifeData.rAddLegDamage := BaseAttribLifeData.rAddLegDamage + aAttribLifeData.rAddLegDamage;
   BaseAttribLifeData.rEnergyRegenDec := BaseAttribLifeData.rEnergyRegenDec + aAttribLifeData.rEnergyRegenDec;
   BaseAttribLifeData.rBasicValueDec := BaseAttribLifeData.rBasicValueDec + aAttribLifeData.rBasicValueDec;
end;

procedure CheckAttribData (var BaseAttribData : TAttribData);
begin
   if BaseAttribData.cLife < 0 then BaseAttribData.cLife := 1000;
   if BaseAttribData.Life < 0 then BaseAttribData.Life := 1000;
end;

procedure CheckLifeData (var BaseLifeData: TLifeData);
begin
   if BaseLifeData.damageBody < 0 then BaseLifeData.DamageBody := 0;
   if BaseLifeData.DamageHead < 0 then BaseLifeData.DamageHead := 0;
   if BaseLifeData.DamageArm  < 0 then BaseLifeData.DamageArm := 0;
   if BaseLifeData.DamageLeg  < 0 then BaseLifeData.DamageLeg := 0;

   if BaseLifeData.AttackSpeed < 0 then BaseLifeData.AttackSpeed := 0;
   if BaseLifeData.Accuracy    < 0 then BaseLifeData.Accuracy    := 0;
   if BaseLifeData.KeepRecovery < 0 then BaseLifeData.KeepRecovery := 0;
   if BaseLifeData.avoid       < 0 then BaseLifeData.avoid       := 0;
   if BaseLifeData.recovery    < 0 then BaseLifeData.recovery    := 0;

   if BaseLifeData.ArmorBody < 0 then BaseLifeData.ArmorBody := 0;
   if BaseLifeData.ArmorHead < 0 then BaseLifeData.ArmorHead := 0;
   if BaseLifeData.ArmorArm  < 0 then BaseLifeData.ArmorArm := 0;
   if BaseLifeData.ArmorLeg  < 0 then BaseLifeData.ArmorLeg := 0;
end;

function GetNeedXByTotalPoint (total : integer) : integer;
var
   x, t, n : integer;
begin
   Result := 0 ;
   if (total<0) or (total>=540) then exit;

   t := total;

   for x := 1 to 10 do begin
      if t - x*10 < 0 then begin
         Result := x;
         exit;
      end;
      t := t-x*10;
   end;
end;

function GetStatePointByTotalPoint (total : integer) : integer;
var
   x, t, n : integer;
begin
   Result := 0 ;
   if (total<0) or (total>540) then exit;

   t := total;
   
   for x := 1 to 10 do begin
      if t - x*10 < 0 then begin
         n := (x-1)*10 + t div x;
         Result := n;
         exit;
      end;
      t := t-x*10;
   end;
end;

function GetStatePointByUserState(n : integer) : integer;
var
   x, stp : integer;
begin
   Result := 0;

   if (n<0) or (n>99) then exit;
   stp := 0;

   for x := 1 to 10 do begin
      if n - x*10 < 0 then begin
         inc (stp, (n-(x-1)*10)*x);
         Result := stp;
         exit;
      end else begin
         inc (stp,x*10);
      end;
   end;
   
end;

function GetAddStateByN (n,sValue : integer) : integer;
var
   x : integer;
begin
   Result := 0;
   if (n <0) or (n > 99) then exit;
   x := n div + 1;
   Result := (x*x+n)*sValue div 100;
end;

procedure GetResultSettingValueofBestMagic (StatePoint, sValue: integer; var Total: integer);
var
   x, n, t, v: integer;
begin
   if (statePoint < 0) or (statePoint > 540) then exit;

   t := statePoint;

   for x := 1 to 10 do begin
      if t - x * 10 < 0 then begin
         n := (x-1) * 10 + t div x;
         inc (total, (x * x + n) * sValue div 100);
         exit;
      end;
      t := t - x * 10;
   end;
end;

function GetNeedStateValueofBestProtect (total: integer): integer;
var
   x, n, i, oldt, t : integer;
begin
   Result := 0;
   if (total < 0) or (total > 540) then exit;

   t := 0;
   oldt := 0;

   for i := 1 to 10 do begin
      inc (t,i*10);
      if (total >= oldt+1) and (total < t) then begin
         Result := i;
         exit;
      end;
   end;
end;

function GetMagicString (var aMagic: TDBBestMagicData) : string;
begin
   Result := '';
   if aMagic.Name[0] = 0 then exit;

   Result := StrPas(@aMagic.Name) + ':'
      + IntToStr(aMagic.Skill);
end;

function GetBestMagicString (var aMagic : TDBBestMagicData) : string;
begin
   Result := '';

   if aMagic.Name[0] = 0 then exit;
   Result := StrPas (@aMagic.Name) + ':'
      + IntToStr(aMagic.Skill) + ':'
      + IntToStr(aMagic.Grade) + ':'
      + IntToStr(aMagic.rDamageBody) + ':'
      + IntToStr(aMagic.rDamageHead) + ':'
      + IntToStr(aMagic.rDamageArm) + ':'
      + IntToStr(aMagic.rDamageLeg) + ':'
      + IntToStr(aMagic.rDamageEnergy) + ':'
      + IntToStr(aMagic.rArmorBody) + ':'
      + IntToStr(aMagic.rArmorHead) + ':'
      + IntToStr(aMagic.rArmorArm) + ':'
      + IntToStr(aMagic.rArmorLeg) + ':'
      + IntToStr(aMagic.rArmorEnergy);
end;

procedure LoadCreateMonster (aFileName: string; List : TList);
var
   i : integer;
   iname : string;
   pd : PTCreateMonsterData;
   CreateMonster : TUserStringDb;
begin
   if not FileExists (aFileName) then exit;

   for i := 0 to List.Count -1 do dispose (List[i]);   // 辆丰甫 肋给窃...
   List.Clear;

   CreateMonster := TUserStringDb.Create;
   CreateMonster.LoadFromFile (aFileName);

   for i := 0 to CreateMonster.Count -1 do begin
      iname := CreateMonster.GetIndexName (i);
      new (pd);
      FillChar (pd^, sizeof(TCreateMonsterData), 0);

      pd^.index := i;
      pd^.mName := CreateMonster.GetFieldValueString (iname, 'MonsterName');
      pd^.CurCount := 0;
      pd^.Count := CreateMonster.GetFieldValueInteger (iname, 'Count');
      pd^.x := CreateMonster.GetFieldValueInteger (iname, 'X');
      pd^.y := CreateMonster.GetFieldValueInteger (iname, 'Y');
      pd^.width := CreateMonster.GetFieldValueInteger (iname, 'Width');
      pd^.Member := CreateMonster.GetFieldValueString (iName, 'Member');
      pd^.Script := CreateMonster.GetFieldValueInteger (iName, 'Script');
      List.Add (pd);
   end;
   CreateMonster.Free;
end;

procedure LoadCreateNpc (aFileName: string; List : TList);
var
   i : integer;
   iname : string;
   pd : PTCreateNpcData;
   CreateNpc : TUserStringDb;
begin
   if not FileExists (aFileName) then exit;
   
   for i := 0 to List.Count -1 do dispose (List[i]); // 辆丰甫 肋给窃...
   List.Clear;

   CreateNpc := TUserStringDb.Create;
   CreateNpc.LoadFromFile (aFileName);

   for i := 0 to CreateNpc.Count -1 do begin
      iname := CreateNpc.GetIndexName (i);
      new (pd);
      FillChar (pd^, sizeof(TCreateNpcData), 0);

      pd^.index := i;
      pd^.mName := CreateNpc.GetFieldValueString (iname, 'NpcName');
      pd^.CurCount := 0;
      pd^.Count := CreateNpc.GetFieldValueInteger (iname, 'Count');
      pd^.x := CreateNpc.GetFieldValueInteger (iname, 'X');
      pd^.y := CreateNpc.GetFieldValueInteger (iname, 'Y');
      pd^.width := CreateNpc.GetFieldValueInteger (iname, 'Width');
      pd^.Notice := CreateNpc.GetFieldValueInteger (iName, 'Notice');
      pd^.BookName := CreateNpc.GetFieldValueString (iname, 'BookName');      
      List.Add (pd);
   end;
   CreateNpc.Free;
end;

procedure LoadCreateDynamicObject (aFileName : String; List : TList);
var
   i, j, iRandomCount : integer;
   iName, ObjectName, mStr, sStr : string;
   DynamicObjectData : TDynamicObjectData;
   pd : PTCreateDynamicObjectData;
   CreateDynamicObject : TUserStringDb;
   MagicData : TMagicData;
   ItemData : TItemData;
   MonsterData : TMonsterData;
   NpcData : TNpcData;
begin
   if not FileExists (aFileName) then exit;

   for i := 0 to List.Count - 1 do begin
      Dispose (List[i]);
   end;
   List.Clear;

   CreateDynamicObject := TUserStringDb.Create;
   CreateDynamicObject.LoadFromFile (aFileName);

   for i := 0 to CreateDynamicObject.Count -1 do begin
      iName := CreateDynamicObject.GetIndexName (i);
      ObjectName := CreateDynamicObject.GetFieldValueString (iName, 'Name');
      FillChar (DynamicObjectData, SizeOf (DynamicObjectData), 0);
      DynamicObjectClass.GetDynamicObjectData (ObjectName, DynamicObjectData);
      if DynamicObjectData.rName <> '' then begin
         New (pd);
         FillChar (pd^, sizeof(TCreateDynamicObjectData), 0);
         pd^.rBasicData := DynamicObjectData;
         {
         pd^.rState := CreateDynamicObject.GetFieldValueInteger (iname, 'State');
         pd^.rRegenInterval := CreateDynamicObject.GetFieldValueInteger (iname, 'RegenInterval');
         pd^.rLife := CreateDynamicObject.GetFieldValueInteger (iname, 'Life');
         }
         pd^.rNeedAge := CreateDynamicObject.GetFieldValueInteger (iname, 'NeedAge');

         // pd^.rNeedSkill
         mStr := CreateDynamicObject.GetFieldValueString (iname, 'NeedSkill');
         for j := 0 to 5 - 1 do begin
            if mStr = '' then break;
            mStr := GetValidStr3 (mStr, sStr, ':');
            if sStr <> '' then begin
               MagicClass.GetMagicData (sStr, MagicData, 0);
               if MagicData.rname[0] <> 0 then begin
                  StrCopy (@pd^.rNeedSkill[j].rName, @MagicData.rName);
                  mStr := GetValidStr3 (mStr, sStr, ':');
                  pd^.rNeedSkill[j].rLevel := _StrToInt (sStr);
               end;
            end;
         end;
         // pd^.rNeedItem
         mStr := CreateDynamicObject.GetFieldValueString (iname, 'NeedItem');
         for j := 0 to 5 - 1 do begin
            if mStr = '' then break;
            mStr := GetValidStr3 (mStr, sStr, ':');
            if sStr <> '' then begin
               ItemClass.GetItemData (sStr, ItemData);
               if ItemData.rname[0] <> 0 then begin
                  StrCopy (@pd^.rNeedItem[j].rName, @ItemData.rName);
                  mStr := GetValidStr3 (mStr, sStr, ':');
                  pd^.rNeedItem[j].rCount := _StrToInt (sStr);
               end;
            end;
         end;
         // pd^.rGiveItem
         mStr := CreateDynamicObject.GetFieldValueString (iname, 'GiveItem');
         for j := 0 to 5 - 1 do begin
            if mStr = '' then break;
            mStr := GetValidStr3 (mStr, sStr, ':');
            if sStr <> '' then begin
               ItemClass.GetItemData (sStr, ItemData);
               if ItemData.rName[0] <> 0 then begin
                  StrCopy (@pd^.rGiveItem[j].rName, @ItemData.rName);
                  mStr := GetValidStr3 (mStr, sStr, ':');
                  pd^.rGiveItem[j].rCount := _StrToInt (sStr);
                  mStr := GetValidStr3 (mStr, sStr, ':');
                  iRandomCount := _StrToInt (sStr);
                  if iRandomCount <= 0 then iRandomCount := 1;

                  RandomClass.AddData (StrPas (@pd^.rGiveItem[j].rName), ObjectName, iRandomCount);                  
               end;
            end;
         end;
         // pd^.rDropItem
         mStr := CreateDynamicObject.GetFieldValueString (iname, 'DropItem');
         for j := 0 to 5 - 1 do begin
            if mStr = '' then break;
            mStr := GetValidStr3 (mStr, sStr, ':');
            if sStr <> '' then begin
               ItemClass.GetItemData (sStr, ItemData);
               if ItemData.rname[0] <> 0 then begin
                  StrCopy (@pd^.rDropItem[j].rName, @ItemData.rName);
                  mStr := GetValidStr3 (mStr, sStr, ':');
                  pd^.rDropItem[j].rCount := _StrToInt (sStr);
                  mStr := GetValidStr3 (mStr, sStr, ':');
                  iRandomCount := _StrToInt (sStr);
                  if iRandomCount <= 0 then iRandomCount := 1;

                  RandomClass.AddData (StrPas (@pd^.rDropItem[j].rName), ObjectName, iRandomCount);
               end;
            end;
         end;

         // pd^.rDropMop
         mStr := CreateDynamicObject.GetFieldValueString (iname, 'DropMop');
         for j := 0 to 5 - 1 do begin
            if mStr = '' then break;
            mStr := GetValidStr3 (mStr, sStr, ':');
            if sStr <> '' then begin
               MonsterClass.LoadMonsterData (sStr, MonsterData);
               if MonsterData.rName[0] <> 0 then begin
                  StrCopy (@pd^.rDropMop[j].rName, @MonsterData.rName);
                  mStr := GetValidStr3 (mStr, sStr, ':');
                  pd^.rDropMop[j].rCount := _StrToInt (sStr);
               end;
            end;
         end;

         // pd^.rCallNpc
         mStr := CreateDynamicObject.GetFieldValueString (iname, 'CallNpc');
         for j := 0 to 5 - 1 do begin
            if mStr = '' then break;
            mStr := GetValidStr3 (mStr, sStr, ':');
            if sStr <> '' then begin
               NpcClass.LoadNpcData (sStr, NpcData);
               if NpcData.rName[0] <> 0 then begin
                  StrCopy (@pd^.rCallNpc[j].rName, @NpcData.rName);
                  mStr := GetValidStr3 (mStr, sStr, ':');
                  pd^.rCallNpc[j].rCount := _StrToInt (sStr);
               end;
            end;
         end;

         mStr := CreateDynamicObject.GetFieldValueString (iname, 'X');
         for j := 0 to 5 - 1 do begin
            mStr := GetValidStr3 (mStr, sStr, ':');
            if sStr = '' then break;
            pd^.rX[j] := _StrToInt (sStr);
         end;
         mStr := CreateDynamicObject.GetFieldValueString (iname, 'Y');
         for j := 0 to 5 - 1 do begin
            mStr := GetValidStr3 (mStr, sStr, ':');
            if sStr = '' then break;
            pd^.rY[j] := _StrToInt (sStr);
         end;

         pd^.rDropX := CreateDynamicObject.GetFieldValueInteger (iName, 'DropX');
         pd^.rDropY := CreateDynamicObject.GetFieldValueInteger (iName, 'DropY');

         pd^.rScript := CreateDynamicObject.GetFieldValueInteger (iName, 'Script');
         pd^.rWidth := CreateDynamicObject.GetFieldValueInteger (iName, 'Width');
         pd^.rboDelay := CreateDynamicObject.GetFieldValueBoolean (iName, 'boDelay');         
         pd^.rEventType := DynamicObjectData.rEventType;
         List.Add (pd);
      end;
   end;
   CreateDynamicObject.Free;
end;

{
procedure LoadCreateMineObject (aFileName : String; List : TList);
var
   i, j, iRandomCount : integer;
   iName, ObjectName, mStr, sStr : string;
   MineObjectData : TMineObjectData;
   pd : PTCreateMineObjectData;
   CreateMineObject : TUserStringDb;
   ItemData : TItemData;
begin
   if not FileExists (aFileName) then exit;

   for i := 0 to List.Count - 1 do begin
      Dispose (List[i]);
   end;
   List.Clear;

   CreateMineObject := TUserStringDb.Create;
   CreateMineObject.LoadFromFile (aFileName);

   for i := 0 to CreateMineObject.Count -1 do begin
      iName := CreateMineObject.GetIndexName (i);
      ObjectName := CreateMineObject.GetFieldValueString (iName, 'Name');
      FillChar (MineObjectData, SizeOf (MineObjectData), 0);
      MineObjectClass.GetMineObjectData (ObjectName, MineObjectData);
      if MineObjectData.rName [0] <> 0 then begin
         New (pd);
         FillChar (pd^, sizeof(TCreateMineObjectData), 0);
         pd^.rBasicData := MineObjectData;

         mStr := CreateMineObject.GetFieldValueString (iname, 'DropItem');
         for j := 0 to 5 - 1 do begin
            if mStr = '' then break;
            mStr := GetValidStr3 (mStr, sStr, ':');
            if sStr <> '' then begin
               ItemClass.GetItemData (sStr, ItemData);
               if ItemData.rname[0] <> 0 then begin
                  StrCopy (@pd^.rDropItem[j].rName, @ItemData.rName);
                  mStr := GetValidStr3 (mStr, sStr, ':');
                  pd^.rDropItem[j].rCount := _StrToInt (sStr);
                  mStr := GetValidStr3 (mStr, sStr, ':');
                  iRandomCount := _StrToInt (sStr);
                  if iRandomCount <= 0 then iRandomCount := 1;

                  RandomClass.AddData (StrPas (@pd^.rDropItem[j].rName), ObjectName, iRandomCount);
               end;
            end;
         end;

         List.Add (pd);
      end;
   end;
   CreateMineObject.Free;
end;
}

function  GetServerIdPointer (aServerId, atype: integer): Pointer;
begin
   Result := nil;
end;

procedure StrToEffectData (var effectdata: TEffectData; astr: string);
var
   str, rdstr : string;
begin
   str := astr;
   str := GetValidStr3 (str, rdstr, ':');
   effectdata.rWavNumber := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   effectdata.rPercent := _StrToInt (rdstr);
end;


///////////////////////////////////
//         TRandomClass
///////////////////////////////////

constructor TRandomClass.Create;
begin
   DataList := nil;
   DataList := TList.Create;
end;

destructor TRandomClass.Destroy;
begin
   Clear;
   if DataList <> nil then DataList.Free;
end;

procedure TRandomClass.Clear;
var
   i : Integer;
   pd : PTRandomData;
begin
   for i := 0 to DataList.Count - 1 do begin
      pd := DataList.Items[i];
      if pd <> nil then Dispose (pd);
   end;
   DataList.Clear;
end;

procedure TRandomClass.AddData (aItemName, aObjName : String; aCount : Integer);
var
   pd : PTRandomData;
   str : String;
begin
   if (aItemName = '') or (aObjName = '') then exit;
   New (pd);
   pd^.rItemName := aItemName;
   pd^.rObjName := aObjName;
   if aCount < 1 then pd^.rCount := 1
   else pd^.rCount := aCount;
   pd^.rIndex := Random (pd^.rCount);

   pd^.rCurIndex := 0;
   DataList.Add (pd);

   {
   if pd^.rCount >= 60 then begin
      Str := aItemName + ':' + aObjName + ':' + IntToStr (pd^.rIndex);
      SaveToFile (str);
   end;
   }
end;

function  TRandomClass.GetChance (aItemName, aObjName : String) : Boolean;
var
   i : Integer;
   pd : PTRandomData;
begin
   Result := true;
   for i := 0 to DataList.Count - 1 do begin
      pd := DataList.Items [i];
      if pd <> nil then begin
         if pd^.rItemName = aItemName then begin
            if pd^.rObjName = aObjName then begin
               Result := false;
               if pd^.rCurIndex = pd^.rIndex then Result := true;
               
               Inc (pd^.rCurIndex);
               if pd^.rCurIndex >= pd^.rCount then begin
                  pd^.rCurIndex := 0;
                  pd^.rIndex := Random (pd^.rCount);

                  {
                  if pd^.rCount >= 60 then begin
                     Str := aItemName + ':' + aObjName + ':' + IntToStr (pd^.rIndex);
                     SaveToFile (str);
                  end;
                  }
               end;
               exit;
            end;
         end;
      end;
   end;

   FrmMain.WriteLogInfo (format('Random Chance Not Found  %s %s', [aItemName,aObjName]));
end;
{
procedure TRandomClass.SaveToFile (str : String);
var
   Stream : TFileStream;
   tmpFileName : String;
   szBuf : array[0..1024] of Byte;
begin
   //颇老疙 : ItemIndexLog.log
   try
      StrPCopy(@szBuf, '[' + DateToStr(Date) + ' ' + TimeToStr(Time) + '] ' + Str + #13#10);
      tmpFileName := 'ITEMINDEXLOG.LOG';
      if FileExists (tmpFileName) then
         Stream := TFileStream.Create (tmpFileName, fmOpenReadWrite)
      else
         Stream := TFileStream.Create (tmpFileName, fmCreate);

      Stream.Seek(0, soFromEnd);
      Stream.WriteBuffer (szBuf, StrLen(@szBuf));
      Stream.Destroy;
   except
   end;
end;
}
///////////////////////////////////
//         TSysopClass
///////////////////////////////////

constructor TSysopClass.Create;
begin
   SysopDb := TUserStringDb.Create;
   ReLoadFromFile;
end;

destructor TSysopClass.Destroy;
begin
   SysopDb.Free;
   inherited destroy;
end;

procedure  TSysopClass.ReLoadFromFile;
begin
   if not FileExists ('.\Sysop.SDB') then exit;
   SysopDb.LoadFromFile ('.\Sysop.SDB');
end;

function   TSysopClass.GetSysopScope (aName: string): integer;
begin
   if SysopDb.Count > 0 then Result := SysopDb.GetFieldValueInteger (aName, 'SysopScope')
   else Result := 0;
end;

///////////////////////////////////
//         TMagicCycleClass
///////////////////////////////////
constructor TMagicCycleClass.Create;
var
   i : integer;
begin
   for i := 0 to CURRENT_CYCLE_MAXNUM - 1 do begin
      DataLists[i] := TList.Create;
      Cycles[i] := TStringKeyClass.Create;
   end;

   StateDataList := TList.Create;
   StateKeyClass := TStringKeyClass.Create;

//   EnergyDataList := TList.Create;
//   EnergyKeyClass := TStringKeyClass.Create;

   ReLoadFromFile;
end;

destructor TMagicCycleClass.Destroy;
var
   i : integer;
begin
   Clear;

   for i := 0 to CURRENT_CYCLE_MAXNUM -1 do begin
      DataLists[i].Free;
      Cycles[i].Free;
   end;
//   EnergyDataList.Free;
//   EnergyKeyClass.Free;

   StateDataList.Free;
   StateKeyClass.Free;
end;

function TMagicCycleClass.GetNeedStatePoint (idx: integer): integer;
begin
   Result := 0 ;
   if (idx < 0) or (idx > CURRENT_CYCLE_MAXNUM - 2) then exit;
   Result := FNeedStatePoint[idx];
end;

procedure TMagicCycleClass.Clear;
var
   i,j : integer;
   pmd : PTBestMagicData;
   psd : PTStateData;
//   pep : PTEnergyPointData;   
begin
   for i := 0 to CURRENT_CYCLE_MAXNUM - 1 do begin
      for j := 0 to DataLists[i].Count - 1 do begin
         pmd := DataLists[i].Items[j];
         if pmd <> nil then dispose(pmd);
      end;
   end;

   for i := 0 to CURRENT_CYCLE_MAXNUM -1 do begin
      DataLists[i].Clear;
      Cycles[i].Clear;
   end;

   for i := 0 to StateDataList.Count - 1 do begin
      psd := StateDataList.Items[i];
      if psd <> nil then dispose(psd);
   end;

   StateDataList.Clear;
   StateKeyClass.Clear;

   {
   for i := 0 to EnergyDataList.Count - 1 do begin
      pep := EnergyDataList.Items[i];
      if pep <> nil then dispose(pep);
   end;

   EnergyDataList.Clear;
   EnergyKeyClass.Clear;
   }
end;

procedure TMagicCycleClass.ReLoadFromFile;
var
   i,j : integer;
   pmd : PTBestMagicData;
   psd : PTStateData;
//   pep : PTEnergyPointData;   
   aFile, mname : string;
   MagicCycleDB, MagicStateDB, NeedStateDB, EnergyDB : TUserStringDB;
begin
   for i := 0 to CURRENT_CYCLE_MAXNUM - 1 do begin
      aFile := format ('.\Init\BestMagic%dCycle.sdb',[i + 1]);
      if FileExists (aFile) then begin
         MagicCycleDB := TUserStringDB.Create;
         MagicCycleDB.LoadFromFile(aFile);

         for j := 0 to MagicCycleDB.Count - 1 do begin
            mname := MagicCycleDB.GetIndexName(j);
            New (pmd);
            FillChar (pmd^, sizeof(TBestMagicData), 0);

            pmd^.rLifeData.AttackSpeed := MagicCycleDB.GetFieldValueInteger (mname,'AttackSpeed');
            pmd^.rLifeData.recovery := MagicCycleDB.GetFieldValueInteger (mname,'Recovery');
            pmd^.rLifeData.KeepRecovery := MagicCycleDB.GetFieldValueInteger (mname,'KeepRecovery');
            pmd^.rLifeData.avoid := MagicCycleDB.GetFieldValueInteger (mname,'Avoid');
            pmd^.rLifeData.Accuracy := MagicCycleDB.GetFieldValueInteger (mname,'Accuracy');
            pmd^.rLifeData.ArmorBody := MagicCycleDB.GetFieldValueInteger (mname,'ArmorBody');
            pmd^.rLifeData.armorHead := MagicCycleDB.GetFieldValueInteger (mname,'ArmorHead');
            pmd^.rLifeData.armorArm := MagicCycleDB.GetFieldValueInteger (mname,'ArmorArm');
            pmd^.rLifeData.armorLeg := MagicCycleDB.GetFieldValueInteger (mname,'ArmorLeg');
            pmd^.rLifeData.armorenergy := MagicCycleDB.GetFieldValueInteger (mname,'ArmorEnergy');
            pmd^.rLifeData.damageBody := MagicCycleDB.GetFieldValueInteger (mname,'DamageBody');
            pmd^.rLifeData.DamageHead := MagicCycleDB.GetFieldValueInteger (mname,'DamageHead');
            pmd^.rLifeData.DamageArm := MagicCycleDB.GetFieldValueInteger (mname,'DamageArm');
            pmd^.rLifeData.DamageLeg := MagicCycleDB.GetFieldValueInteger (mname,'DamageLeg');
            pmd^.rLifeData.damageenergy := MagicCycleDB.GetFieldValueInteger (mname,'DamageEnergy');

            pmd^.rEnergyPoint := MagicCycleDB.GetFieldValueInteger (mname, 'EnergyPoint');
            pmd^.rSuccessRate := MagicCycleDB.GetFieldValueInteger (mname,'SuccessRate');
            pmd^.rPassDamagePer := MagicCycleDB.GetFieldValueInteger (mname,'PassDamagePer');
            pmd^.rGetDamagePer := MagicCycleDB.GetFieldValueInteger (mname,'GetDamagePer');
            pmd^.rKeepEnergy := MagicCycleDB.GetFieldValueInteger (mname,'NeedMinEnergy');
            pmd^.rShotDelay := MagicCycleDB.GetFieldValueInteger (mname,'ShotDelay');
            pmd^.rUseableDelay := MagicCycleDB.GetFieldValueInteger (mname,'UseableDelay');
            pmd^.rLockDown := MagicCycleDB.GetFieldValueInteger (mname, 'LockDown');
            pmd^.r3Attib := MagicCycleDB.GetFieldValueInteger (mname, '3Attrib');
            pmd^.rLifeSteal := MagicCycleDB.GetFieldValueInteger (mname, 'LifeSteal');
            pmd^.rEnergySteal := MagicCycleDB.GetFieldValueInteger (mname, 'EnergySteal');
            pmd^.rAddDamageEnergy := MagicCycleDB.GetFieldValueInteger (mname, 'AddDamageEnergy');            
            pmd^.rMoveSpeed := MagicCycleDB.GetFieldValueInteger (mname, 'MoveSpeed');

            pmd^.r1SecDecLife := MagicCycleDB.GetFieldValueInteger (mname, '1Life');

            StrToEffectData (pmd^.rSoundStart, MagicCycleDB.GetFieldValueString (mname, 'SoundStart'));
            StrToEffectData (pmd^.rSoundEnd, MagicCycleDB.GetFieldValueString (mname, 'SoundEnd'));
            StrToEffectData (pmd^.rSoundStrike, MagicCycleDB.GetFieldValueString (mname, 'SoundStrike'));
            StrToEffectData (pmd^.rSoundSwing, MagicCycleDB.GetFieldValueString (mname, 'SoundSwing'));
            StrToEffectData (pmd^.rSoundEvent, MagicCycleDB.GetFieldValueString (mname, 'SoundEvent'));

            pmd^.rSEffectNumber := MagicCycleDB.GetFieldValueInteger (mName, 'SEffectNumber');
            pmd^.rSEffectNumber2 := MagicCycleDB.GetFieldValueInteger (mName, 'SEffectNumber2');
            pmd^.rCEffectNumber := MagicCycleDB.GetFieldValueInteger (mName, 'CEffectNumber');
            pmd^.rEEffectNumber := MagicCycleDB.GetFieldValueInteger (mName, 'EEffectNumber');

            DataLists [i].Add (pmd);
            Cycles[i].Insert (mname, pmd);
         end;

         MagicCycleDB.Free;
      end;
   end;

   if FileExists ('.\Init\BestMagicStateData.sdb') then begin
      MagicStateDB := TUserStringDB.Create;
      MagicStateDB.LoadFromFile('.\Init\BestMagicStateData.sdb');

      for i := 0 to MagicStateDB.Count - 1 do begin
         mname := MagicStateDB.GetIndexName(i);
         new (psd);
         FillChar (psd^, sizeof(TStateData),0);

         psd^.ArmorBody := MagicStateDB.GetFieldValueInteger (mname,'ArmorBody');
         psd^.armorHead := MagicStateDB.GetFieldValueInteger (mname,'ArmorHead');
         psd^.armorArm := MagicStateDB.GetFieldValueInteger (mname,'ArmorArm');
         psd^.armorLeg := MagicStateDB.GetFieldValueInteger (mname,'ArmorLeg');
         psd^.armorenergy := MagicStateDB.GetFieldValueInteger (mname,'ArmorEnergy');
         psd^.damageBody := MagicStateDB.GetFieldValueInteger (mname,'DamageBody');
         psd^.DamageHead := MagicStateDB.GetFieldValueInteger (mname,'DamageHead');
         psd^.DamageArm := MagicStateDB.GetFieldValueInteger (mname,'DamageArm');
         psd^.DamageLeg := MagicStateDB.GetFieldValueInteger (mname,'DamageLeg');
         psd^.damageenergy := MagicStateDB.GetFieldValueInteger (mname,'DamageEnergy');
         StateDataList.Add(psd);
         StateKeyClass.Insert(mname, psd);
      end;

      MagicStateDB.Free;
   end;

   if FileExists ('.\Init\NeedStatePoint.sdb') then begin
      NeedStateDB := TUserStringDB.Create;
      NeedStateDB.LoadFromFile('.\Init\NeedStatePoint.sdb');

      for i := 0 to NeedStateDB.Count - 1 do begin
         if i > CURRENT_CYCLE_MAXNUM-2 then break;
         mname := NeedStateDB.GetIndexName(i);
         FNeedStatePoint[i] := NeedStateDB.GetFieldValueInteger (mname,'NeedPoint');
      end;

      NeedStateDB.Free;
   end;
   {
   if FileExists ('.\Init\BestMagicEnergyPoint.sdb') then begin
      EnergyDB := TUserStringDB.Create;
      EnergyDB.LoadFromFile('.\Init\BestMagicEnergyPoint.sdb');

      for i := 0 to EnergyDB.Count - 1 do begin
         mname := EnergyDB.GetIndexName(i);
         new (pep);
         FillChar (pep^, sizeof(TEnergyPointData), 0);
         pep^.rEnergyPoint[0] := EnergyDB.GetFieldValueInteger (mname,'1');
         pep^.rEnergyPoint[1] := EnergyDB.GetFieldValueInteger (mname,'2');
         pep^.rEnergyPoint[2] := EnergyDB.GetFieldValueInteger (mname,'3');

         EnergyDataList.Add(pep);
         EnergyKeyClass.Insert(mname, pep);
      end;

      EnergyDB.Free;
   end;
   }
end;

procedure TMagicCycleClass.GetData (aMagicName : string; aGrade: Byte; var aMagicData : TMagicData);
var
   pmd : PTBestMagicData;
   n : integer;
begin
   if aGrade > CURRENT_CYCLE_MAXNUM - 1 then exit;
   if aMagicName = '' then exit;

   pmd := Cycles[aGrade].Select (aMagicName);
   if pmd = nil then exit;

   with aMagicData do begin
      rLifeData.AttackSpeed      := pmd^.rLifeData.AttackSpeed;
      rLifeData.recovery         := pmd^.rLifeData.recovery;
      rLifeData.KeepRecovery     := pmd^.rLifeData.KeepRecovery;
      rLifeData.avoid            := pmd^.rLifeData.avoid;
      rLifeData.Accuracy         := pmd^.rLifeData.Accuracy;
      rLifeData.damageBody       := pmd^.rLifeData.damageBody;
      rLifeData.damageHead       := pmd^.rLifeData.damageHead;
      rLifeData.damageArm        := pmd^.rLifeData.damageArm;
      rLifeData.damageLeg        := pmd^.rLifeData.damageLeg;
      rLifeData.damageenergy     := pmd^.rLifeData.damageenergy;
      rLifeData.armorBody        := pmd^.rLifeData.armorBody;
      rLifeData.armorHead        := pmd^.rLifeData.armorHead;
      rLifeData.armorArm         := pmd^.rLifeData.armorArm;
      rLifeData.armorLeg         := pmd^.rLifeData.armorLeg;
      rLifeData.armorenergy      := pmd^.rLifeData.armorenergy;

      rEnergyPoint := pmd^.rEnergyPoint;
      
      rSoundStart := pmd^.rSoundStart;
      rSoundEnd := pmd^.rSoundEnd;
      rSoundStrike := pmd^.rSoundStrike;
      rSoundSwing := pmd^.rSoundSwing;
      rSoundEvent := pmd^.rSoundEvent;

      rSEffectNumber := pmd^.rSEffectNumber;
      rSEffectNumber2 := pmd^.rSEffectNumber2;
      rCEffectNumber := pmd^.rCEffectNumber;
      rEEffectNumber := pmd^.rEEffectNumber;

      case rMagicType of
         MAGICTYPE_PROTECTING: begin
            rKeepEnergy := pmd^.rKeepEnergy;  // 傍仿 弥家盔扁蔼
            rLifeData.armorBody := rLifeData.armorBody * 7 div 10;
            rLifeData.armorHead := rLifeData.armorHead * 7 div 10;
            rLifeData.armorArm := rLifeData.armorArm * 7 div 10;
            rLifeData.armorLeg := rLifeData.armorLeg * 7 div 10;
            rLifeData.armorenergy := rLifeData.armorenergy;
         end;
         MAGICTYPE_BESTSPECIAL: begin
            rKeepEnergy := pmd^.rKeepEnergy;
            rSuccessRate := pmd^.rSuccessRate;
            rPassDamagePer := pmd^.rPassDamagePer;
            rGetDamagePer := pmd^.rGetDamagePer;
            rShotDelay := pmd^.rShotDelay;
            rUseableDelay := pmd^.rUseableDelay;
            rLockDown := pmd^.rLockDown;
            r3Attrib := pmd^.r3Attib;
            rLifeSteal := pmd^.rLifeSteal;
            rEnergySteal := pmd^.rEnergySteal;
            rAddDamageEnergy := pmd^.rAddDamageEnergy;
            rMoveSpeed := pmd^.rMoveSpeed;
            r5SecDecLife := pmd^.r1SecDecLife;   // 檬侥俊辑 1檬付促 劝仿别绰芭... 040422

            //努扼捞攫飘 拳搁俊辑 1.00狼 钎泅阑 绝局扁 困秦
            rcSkillLevel := 0;
         end;
         Else begin
            if rLifeData.AttackSpeed <> 0 then rLifeData.AttackSpeed := (130 - rLifeData.AttackSpeed) * INI_MUL_ATTACKSPEED2 div INI_MAGIC_DIV_VALUE2;
            if rLifeData.recovery <> 0 then rLifeData.recovery := (130 - rLifeData.recovery) * INI_MUL_RECOVERY2 div INI_MAGIC_DIV_VALUE2;
            if rLifeData.avoid <> 0 then rLifeData.avoid := rLifeData.avoid * INI_MUL_AVOID2 div INI_MAGIC_DIV_VALUE2;
            if rLifeData.KeepRecovery <> 0 then rLifeData.KeepRecovery := rLifeData.KeepRecovery * rLifeData.KeepRecovery div 22 + 70;
            if rLifeData.Accuracy <> 0 then rLifeData.Accuracy := rLifeData.Accuracy * 6 div 10;
            if rLifeData.damageBody <> 0 then rLifeData.damageBody := (rLifeData.damageBody+INI_ADD_DAMAGE2) * INI_MUL_DAMAGEBODY2 div INI_MAGIC_DIV_VALUE2;
            if rLifeData.damageHead <> 0 then rLifeData.damageHead := (rLifeData.damageHead+INI_ADD_DAMAGE2) * INI_MUL_DAMAGEHEAD2 div INI_MAGIC_DIV_VALUE2;
            if rLifeData.damageArm <> 0 then rLifeData.damageArm := (rLifeData.damageArm+INI_ADD_DAMAGE2) * INI_MUL_DAMAGEARM2 div INI_MAGIC_DIV_VALUE2;
            if rLifeData.damageLeg <> 0 then rLifeData.damageLeg := (rLifeData.damageLeg+INI_ADD_DAMAGE2) * INI_MUL_DAMAGELEG2 div INI_MAGIC_DIV_VALUE2;
            if rLifeData.damageenergy <> 0 then rLifeData.damageenergy := (rLifeData.damageenergy+INI_ADD_DAMAGE2) *INI_MUL_DAMAGEBODY2 div INI_MAGIC_DIV_VALUE2;
            if rLifeData.armorBody <> 0 then rLifeData.armorBody := rLifeData.armorBody * INI_MUL_ARMORBODY2 div INI_MAGIC_DIV_VALUE2;
            if rLifeData.armorHead <> 0 then rLifeData.armorHead := rLifeData.armorHead * INI_MUL_ARMORHEAD2 div INI_MAGIC_DIV_VALUE2;
            if rLifeData.armorArm <> 0 then rLifeData.armorArm := rLifeData.armorArm * INI_MUL_ARMORARM2 div INI_MAGIC_DIV_VALUE2;
            if rLifeData.armorLeg <> 0 then rLifeData.armorLeg := rLifeData.armorLeg * INI_MUL_ARMORLEG2 div INI_MAGIC_DIV_VALUE2;
         end;
      end;
   end;
end;

procedure TMagicCycleClass.GetStateDataofBestMagic (pMagicData : PTMagicData);
var
   MagicName : string;
   psd : PTStateData;
begin
   with pMagicData^.rStatus do begin
      if rDamageBody > 540 then exit;
      if rDamageHead > 540 then exit;
      if rDamageArm > 540 then exit;
      if rDamageLeg > 540 then exit;
      if rDamageEnergy > 540 then exit;
      if rArmorBody > 540 then exit;
      if rArmorHead > 540 then exit;
      if rArmorArm > 540 then exit;
      if rArmorLeg > 540 then exit;
      if rArmorEnergy > 540 then exit;
   end;

   MagicName := StrPas (@pMagicData^.rname);
   psd := StateKeyClass.Select(MagicName);
   if psd = nil then exit;

   with pMagicData^ do begin
      GetResultSettingValueofBestMagic (rStatus.rDamageBody, psd^.damageBody, rcLifeData.damageBody);
      GetResultSettingValueofBestMagic (rStatus.rDamageHead, psd^.damageHead, rcLifeData.damageHead);
      GetResultSettingValueofBestMagic (rStatus.rDamageArm, psd^.damageArm, rcLifeData.damageArm);
      GetResultSettingValueofBestMagic (rStatus.rDamageLeg, psd^.damageLeg, rcLifeData.damageLeg);
      GetResultSettingValueofBestMagic (rStatus.rDamageEnergy, psd^.damageEnergy, rcLifeData.damageEnergy);
      GetResultSettingValueofBestMagic (rStatus.rArmorBody, psd^.ArmorBody, rcLifeData.ArmorBody);
      GetResultSettingValueofBestMagic (rStatus.rArmorHead, psd^.ArmorHead, rcLifeData.ArmorHead);
      GetResultSettingValueofBestMagic (rStatus.rArmorArm, psd^.ArmorArm, rcLifeData.ArmorArm);
      GetResultSettingValueofBestMagic (rStatus.rArmorLeg, psd^.ArmorLeg, rcLifeData.ArmorLeg);
      GetResultSettingValueofBestMagic (rStatus.rArmorEnergy, psd^.ArmorEnergy, rcLifeData.ArmorEvalue);
   end;
end;

procedure TMagicCycleClass.GetEnergyPointData (pMagicData : PTMagicData);
var
   MagicName : string;
   pmd : PTBestMagicData;
   BeforeEPoint, EPoint : Integer;   
//   pep : PTEnergyPointData;
begin
   if pMagicData = nil then exit;
   if pMagicData^.rname[0] = 0 then exit;
   
   MagicName := StrPas (@pMagicData^.rname);

//   pep := EnergyKeyClass.Select (amagicname);
//   if pep = nil then exit;

   pmd := Cycles [pMagicData^.rGrade].Select (MagicName);
   if pmd = nil then exit;

   EPoint := pmd^.rEnergyPoint;
   pMagicData^.rEnergyPoint := 0;

   case pMagicData^.rcSkillLevel of
      0..4999 : begin
         if pMagicData^.rGrade > 0 then begin
            pmd := Cycles [pMagicData^.rGrade - 1].Select (MagicName);
            pMagicData^.rEnergyPoint := pmd^.rEnergyPoint;
         end;
      end;
      5000..5999 : begin
         if pMagicData^.rGrade > 0 then begin
            pmd := Cycles [pMagicData^.rGrade - 1].Select (MagicName);
            BeforeEPoint := pmd^.rEnergyPoint;

            pMagicData^.rEnergyPoint := BeforeEPoint + ((EPoint - BeforeEPoint) div 10);
         end else begin
            pMagicData^.rEnergyPoint := EPoint div 10;
         end;
      end;
      6000..6999 : begin
         if pMagicData^.rGrade > 0 then begin
            pmd := Cycles [pMagicData^.rGrade - 1].Select (MagicName);
            BeforeEPoint := pmd^.rEnergyPoint;

            pMagicData^.rEnergyPoint := BeforeEPoint + ((EPoint - BeforeEPoint) * 2 div 10);
         end else begin
            pMagicData^.rEnergyPoint := EPoint * 2 div 10;;
         end;
      end;
      7000..7999 : begin
         if pMagicData^.rGrade > 0 then begin
            pmd := Cycles [pMagicData^.rGrade - 1].Select (MagicName);
            BeforeEPoint := pmd^.rEnergyPoint;

            pMagicData^.rEnergyPoint := BeforeEPoint + ((EPoint - BeforeEPoint) * 3 div 10);
         end else begin
            pMagicData^.rEnergyPoint := EPoint * 3 div 10;;
         end;
      end;
      8000..8999 : begin
         if pMagicData^.rGrade > 0 then begin
            pmd := Cycles [pMagicData^.rGrade - 1].Select (MagicName);
            BeforeEPoint := pmd^.rEnergyPoint;

            pMagicData^.rEnergyPoint := BeforeEPoint + ((EPoint - BeforeEPoint) * 4 div 10);
         end else begin
            pMagicData^.rEnergyPoint := EPoint * 4 div 10;;
         end;
      end;
      9000..9998 : begin
         if pMagicData^.rGrade > 0 then begin
            pmd := Cycles [pMagicData^.rGrade - 1].Select (MagicName);
            BeforeEPoint := pmd^.rEnergyPoint;
         
            pMagicData^.rEnergyPoint := BeforeEPoint + ((EPoint - BeforeEPoint) * 5 div 10);
         end else begin
            pMagicData^.rEnergyPoint := EPoint * 5 div 10;;
         end;
      end;
      9999 : begin
         pMagicData^.rEnergyPoint := EPoint;
      end;
   end;
end;

///////////////////////////////////
//         TMagicClass
///////////////////////////////////


constructor TMagicClass.Create;
begin
   DataList := TList.Create;
   KeyClass := TStringKeyClass.Create;
   
   MagicDb := TUserStringDb.Create;
   MagicForGuildDb := TUserStringDb.Create;
   ReLoadFromFile;
end;

destructor TMagicClass.Destroy;
begin
   Clear;
   MagicForGuildDb.Free;
   MagicDb.Free;
   DataList.Free;
   KeyClass.Free;
   inherited destroy;
end;

function TMagicClass.GetCount : Integer;
begin
   Result := DataList.Count;
end;

procedure TMagicClass.Clear;
var
   i : integer;
begin
   FillChar (SkillAddDamageArr, sizeof(SkillAddDamageArr) , 0);
   FillChar (SkillAddArmorArr, sizeof(SkillAddArmorArr), 0);
   FillChar (PowerLevelArr, SizeOf (PowerLevelArr), 0);
   for i := 0 to DataList.Count -1 do dispose (DataList[i]);
   DataList.Clear;
   KeyClass.Clear;
end;

procedure TMagicClass.Calculate_cLifeData (pMagicData: PTMagicData);
begin
   if pMagicData = nil then exit;
   if pMagicData^.rName[0] = 0 then exit;

   with pMagicData^ do begin
      if pMagicData^.rMagicClass = MAGICCLASS_RISEMAGIC then begin
         rcLifeData.DamageBody   := rLifeData.damageBody  + rLifeData.damageBody * rcSkillLevel div 3000;
         rcLifeData.DamageHead   := rLifeData.DamageHead  + rLifeData.damageHead * rcSkillLevel div INI_SKILL_DIV_DAMAGE2;
         rcLifeData.DamageArm    := rLifeData.DamageArm   + rLifeData.damageArm  * rcSkillLevel div INI_SKILL_DIV_DAMAGE2;
         rcLifeData.DamageLeg    := rLifeData.DamageLeg   + rLifeData.damageLeg  * rcSkillLevel div INI_SKILL_DIV_DAMAGE2;
         rcLifeData.AttackSpeed  := rLifeData.AttackSpeed - rLifeData.AttackSpeed * rcSkillLevel div 15000;
         rcLifeData.avoid        := rLifeData.avoid;
         rcLifeData.recovery     := rLifeData.recovery;

         rcLifeData.Accuracy     := rLifeData.Accuracy - rLifeData.Accuracy * (10000 - rcSkillLevel) div 10000;
         rcLifeData.keeprecovery := rLifeData.keeprecovery - rLifeData.keeprecovery * (10000 - rcSkillLevel) div 10000;

         rcLifeData.armorBody    := rLifeData.armorBody   + rLifeData.armorBody * rcSkillLevel div INI_SKILL_DIV_ARMOR2;
         rcLifeData.armorHead    := rLifeData.armorHead   + rLifeData.armorHead * rcSkillLevel div INI_SKILL_DIV_ARMOR2;
         rcLifeData.armorArm     := rLifeData.armorArm    + rLifeData.armorArm  * rcSkillLevel div INI_SKILL_DIV_ARMOR2;
         rcLifeData.armorLeg     := rLifeData.armorLeg    + rLifeData.armorLeg  * rcSkillLevel div INI_SKILL_DIV_ARMOR2;
      end else if pMagicData^.rMagicClass = MAGICCLASS_MAGIC then begin
         rcLifeData.DamageBody   := rLifeData.damageBody  + rLifeData.damageBody * rcSkillLevel div INI_SKILL_DIV_DAMAGE;
         rcLifeData.DamageHead   := rLifeData.DamageHead  + rLifeData.damageHead * rcSkillLevel div INI_SKILL_DIV_DAMAGE;
         rcLifeData.DamageArm    := rLifeData.DamageArm   + rLifeData.damageArm  * rcSkillLevel div INI_SKILL_DIV_DAMAGE;
         rcLifeData.DamageLeg    := rLifeData.DamageLeg   + rLifeData.damageLeg  * rcSkillLevel div INI_SKILL_DIV_DAMAGE;
         rcLifeData.AttackSpeed  := rLifeData.AttackSpeed - rLifeData.AttackSpeed * rcSkillLevel div INI_SKILL_DIV_ATTACKSPEED;
         rcLifeData.avoid        := rLifeData.avoid;
         rcLifeData.recovery     := rLifeData.recovery;
         rcLifeData.Accuracy     := rLifeData.Accuracy;
         rcLifeData.keeprecovery := rLifeData.keeprecovery;
         rcLifeData.armorBody    := rLifeData.armorBody   + rLifeData.armorBody * rcSkillLevel div INI_SKILL_DIV_ARMOR;
         rcLifeData.armorHead    := rLifeData.armorHead   + rLifeData.armorHead * rcSkillLevel div INI_SKILL_DIV_ARMOR;
         rcLifeData.armorArm     := rLifeData.armorArm    + rLifeData.armorArm  * rcSkillLevel div INI_SKILL_DIV_ARMOR;
         rcLifeData.armorLeg     := rLifeData.armorLeg    + rLifeData.armorLeg  * rcSkillLevel div INI_SKILL_DIV_ARMOR;
      end else if pMagicData^.rMagicClass = MAGICCLASS_MYSTERY then begin
         rcLifeData.DamageBody   := rLifeData.damageBody  + rLifeData.damageBody * rcSkillLevel div 2500;
         rcLifeData.DamageHead   := rLifeData.DamageHead  + rLifeData.damageHead * rcSkillLevel div INI_SKILL_DIV_DAMAGE3;
         rcLifeData.DamageArm    := rLifeData.DamageArm   + rLifeData.damageArm  * rcSkillLevel div INI_SKILL_DIV_DAMAGE3;
         rcLifeData.DamageLeg    := rLifeData.DamageLeg   + rLifeData.damageLeg  * rcSkillLevel div INI_SKILL_DIV_DAMAGE3;
         rcLifeData.AttackSpeed  := rLifeData.AttackSpeed - rLifeData.AttackSpeed * rcSkillLevel div INI_SKILL_DIV_ATTACKSPEED3;
         rcLifeData.avoid        := rLifeData.avoid + rLifeData.avoid * rcSkillLevel div 9999;
         rcLifeData.Accuracy     := rLifeData.Accuracy + rLifeData.Accuracy * rcSkillLevel div 9999;
         rcLifeData.recovery     := rLifeData.recovery;
         rcLifeData.keeprecovery := rLifeData.keeprecovery + rLifeData.keeprecovery * rcSkillLevel div INI_SKILL_DIV_KEEPRECOVERY3;

         rcLifeData.armorBody    := rLifeData.armorBody   + rLifeData.armorBody * rcSkillLevel div INI_SKILL_DIV_ARMOR2;
         rcLifeData.armorHead    := rLifeData.armorHead   + rLifeData.armorHead * rcSkillLevel div INI_SKILL_DIV_ARMOR2;
         rcLifeData.armorArm     := rLifeData.armorArm    + rLifeData.armorArm  * rcSkillLevel div INI_SKILL_DIV_ARMOR2;
         rcLifeData.armorLeg     := rLifeData.armorLeg    + rLifeData.armorLeg  * rcSkillLevel div INI_SKILL_DIV_ARMOR2;
      end else if pMagicData^.rMagicClass = MAGICCLASS_BESTMAGIC then begin
         case pMagicData^.rMagicType of
            MAGICTYPE_BESTSPECIAL :
               begin
                  rcLifeData.damageBody   := rLifeData.damageBody;
                  rcLifeData.damageHead   := rLifeData.damageHead;
                  rcLifeData.damageArm    := rLifeData.damageArm;
                  rcLifeData.damageLeg    := rLifeData.damageLeg;
                  rcLifeData.damageEnergy := rLifeData.damageEnergy;

                  rcLifeData.armorBody    := rLifeData.armorBody;
                  rcLifeData.armorHead    := rLifeData.armorHead;
                  rcLifeData.armorArm     := rLifeData.armorArm;
                  rcLifeData.armorLeg     := rLifeData.armorLeg;
                  rcLifeData.armorenergy  := rLifeData.armorenergy;

                  rcLifeData.AttackSpeed  := -(rLifeData.AttackSpeed);
                  rcLifeData.avoid        := rLifeData.avoid;
                  rcLifeData.recovery     := -(rLifeData.recovery);
                  rcLifeData.Accuracy     := rLifeData.Accuracy;
                  rcLifeData.KeepRecovery := rLifeData.KeepRecovery;
                  exit;
               end;
            else
               begin
                  rcLifeData.DamageBody   := rLifeData.damageBody  + rLifeData.damageBody * rcSkillLevel div 3000;
                  rcLifeData.DamageHead   := rLifeData.DamageHead  + rLifeData.damageHead * rcSkillLevel div INI_SKILL_DIV_DAMAGE2;
                  rcLifeData.DamageArm    := rLifeData.DamageArm   + rLifeData.damageArm  * rcSkillLevel div INI_SKILL_DIV_DAMAGE2;
                  rcLifeData.DamageLeg    := rLifeData.DamageLeg   + rLifeData.damageLeg  * rcSkillLevel div INI_SKILL_DIV_DAMAGE2;
                  rcLifeData.damageenergy := rLifeData.damageenergy + rLifeData.damageenergy * rcSkillLevel div 3000;
                  rcLifeData.AttackSpeed  := rLifeData.AttackSpeed - rLifeData.AttackSpeed * rcSkillLevel div 15000;
                  rcLifeData.avoid        := rLifeData.avoid;
                  rcLifeData.recovery     := rLifeData.recovery;

                  rcLifeData.Accuracy     := rLifeData.Accuracy - rLifeData.Accuracy * (10000 - rcSkillLevel) div 10000;
                  rcLifeData.keeprecovery := rLifeData.keeprecovery - rLifeData.keeprecovery * (10000 - rcSkillLevel) div 10000;

                  rcLifeData.armorBody    := rLifeData.armorBody   + rLifeData.armorBody * rcSkillLevel div INI_SKILL_DIV_ARMOR2;
                  rcLifeData.armorHead    := rLifeData.armorHead   + rLifeData.armorHead * rcSkillLevel div INI_SKILL_DIV_ARMOR2;
                  rcLifeData.armorArm     := rLifeData.armorArm    + rLifeData.armorArm  * rcSkillLevel div INI_SKILL_DIV_ARMOR2;
                  rcLifeData.armorLeg     := rLifeData.armorLeg    + rLifeData.armorLeg  * rcSkillLevel div INI_SKILL_DIV_ARMOR2;
                  rcLifeData.armorenergy  := rLifeData.armorenergy + rLifeData.armorenergy * rcSkillLevel div INI_SKILL_DIV_ARMOR;
                  rcLifeData.armorevalue  := 0;                   
               end;
         end;
      end;

      if (pMagicData^.rMagicType >= 0) and (pMagicData^.rMagicType <= 6) then begin
         if pMagicData^.rMagicClass = MAGICCLASS_RISEMAGIC then begin
            rcLifeData.damageBody := rcLifeData.damageBody + RISEMAGIC_ADDDAMAGE + RISEMAGIC_ADDDAMAGE div 2;
            rcLifeData.damageHead := rcLifeData.damageHead + RISEMAGIC_ADDDAMAGE;
            rcLifeData.damageArm  := rcLifeData.damageArm + RISEMAGIC_ADDDAMAGE;
            rcLifeData.damageLeg  := rcLifeData.damageLeg + RISEMAGIC_ADDDAMAGE;
            rcLifeData.armorBody  := rcLifeData.armorBody + RISEMAGIC_ADDDAMAGE div 2;
         end else if pMagicData^.rMagicClass = MAGICCLASS_BESTMAGIC then begin
            rcLifeData.damageBody := rcLifeData.damageBody + RISEMAGIC_ADDDAMAGE + RISEMAGIC_ADDDAMAGE div 2;
            rcLifeData.damageHead := rcLifeData.damageHead + RISEMAGIC_ADDDAMAGE;
            rcLifeData.damageArm  := rcLifeData.damageArm + RISEMAGIC_ADDDAMAGE;
            rcLifeData.damageLeg  := rcLifeData.damageLeg + RISEMAGIC_ADDDAMAGE;
            rcLifeData.damageenergy := rcLifeData.damageenergy + RISEMAGIC_ADDDAMAGE + RISEMAGIC_ADDDAMAGE div 2;
            rcLifeData.armorBody  := rcLifeData.armorBody + RISEMAGIC_ADDDAMAGE div 2;
         end;
      end;
   end;

   with pMagicData^ do begin
      case rMagicClass of
         MAGICCLASS_MYSTERY : begin
            rcLifeData.Damagebody := rcLifeData.Damagebody + rcLifeData.DamageBody * MagicClass.GetSkillDamageBodyForPalm (rcSkillLevel) div 100;
            rcLifeData.longavoid := MagicClass.GetSkillLongAvoidForPalm(rcSkillLevel);
         end;
         Else begin
            rcLifeData.Damagebody := rcLifeData.damageBody + rcLifeData.DamageBody * MagicClass.GetSkillDamageBody (rcSkillLevel) div 100;
            rcLifeData.damageenergy := rcLifeData.damageenergy + rcLifeData.damageenergy * MagicClass.GetSkillDamageBody (rcSkillLevel) div 100;

            if rMagicType = MAGICTYPE_PROTECTING then
               rcLifeData.Armorbody := rcLifeData.Armorbody + rcLifeData.ArmorBody * MagicClass.GetSkillArmorBody (rcSkillLevel) div 100;
         end;
      end;
   end;
   if pMagicData^.rMagicClass = MAGICCLASS_BESTMAGIC then begin
      MagicCycleClass.GetStateDataofBestMagic (pMagicData);
   end;
end;

procedure TMagicClass.ReLoadFromFile;
var
   i, idx, sn, en : integer;
   iname, mname : string;
   pmd : PTMagicData;
   TempDb : TUserStringDb;
begin
   if FileExists ('.\Init\AddDamage.SDB') then begin
      Clear;
      TempDb := TUserStringDb.Create;
      TempDb.LoadFromFile ('.\Init\AddDamage.SDB');
      for idx := 0 to TempDb.Count - 1 do begin
         iname := TempDb.GetIndexName (idx);
         sn := TempDb.GetFieldValueInteger (iname,'StartSkill');
         en := TempDb.GetFieldValueInteger (iname,'EndSkill');
         if sn <= 0 then sn := 0;
         if en >= 10000 then en := 10000;
         for i := sn to en do begin
            SkillAddDamageArr[i].rdamagebody := TempDb.GetFieldValueInteger (iname,'DamageBody');
            SkillAddDamageArr[i].rdamagehead := TempDb.GetFieldValueInteger (iname,'DamageHead');
            SkillAddDamageArr[i].rdamagearm := TempDb.GetFieldValueInteger (iname,'DamageArm');
            SkillAddDamageArr[i].rdamageleg := TempDb.GetFieldValueInteger (iname,'DamageLeg');
         end;
      end;
      TempDb.Free;
   end;

   if FileExists ('.\Init\AddArmor.SDB') then begin
      // 2000.10.05 眠啊规绢仿 AddArmor.sdb 颇老狼 肺靛
      TempDb := TUserStringDb.Create;
      TempDb.LoadFromFile ('.\Init\AddArmor.SDB');
      for idx := 0 to TempDb.Count -1 do begin
         iname := TempDb.GetIndexName (idx);
         sn := TempDb.GetFieldValueInteger (iname,'StartSkill');
         en := TempDb.GetFieldValueInteger (iname,'EndSkill');
         if sn <= 0 then sn := 0;
         if en >= 10000 then en := 10000;
         for i := sn to en do begin
            SkillAddArmorArr[i].rarmorbody := TempDb.GetFieldValueInteger (iname,'ArmorBody');
            SkillAddArmorArr[i].rarmorhead := TempDb.GetFieldValueInteger (iname,'ArmorHead');
            SkillAddArmorArr[i].rarmorarm := TempDb.GetFieldValueInteger (iname,'ArmorArm');
            SkillAddArmorArr[i].rarmorleg := TempDb.GetFieldValueInteger (iname,'ArmorLeg');
         end;
      end;
      TempDb.Free;
   end;

   if FileExists ('.\Init\AddPalmDamage.SDB') then begin
      TempDB := TUserStringDB.Create;
      TempDB.LoadFromFile ('.\Init\AddPalmDamage.SDB');
      for idx := 0 to TempDb.Count -1 do begin
         iname := TempDb.GetIndexName (idx);
         sn := TempDb.GetFieldValueInteger (iname,'StartSkill');
         en := TempDb.GetFieldValueInteger (iname,'EndSkill');
         if sn <= 0 then sn := 0;
         if en >= 10000 then en := 10000;
         for i := sn to en do begin
            SkillAddPalmDamageArr[i].rdamagebody   := TempDb.GetFieldValueInteger (iname, 'DamageBody');
            SkillAddPalmDamageArr[i].rdamagehead   := TempDb.GetFieldValueInteger (iname, 'DamageHead');
            SkillAddPalmDamageArr[i].rdamagearm    := TempDb.GetFieldValueInteger (iname, 'DamageArm');
            SkillAddPalmDamageArr[i].rdamageleg    := TempDb.GetFieldValueInteger (iname, 'DamageLeg');
            SkillAddPalmDamageArr[i].rlongavoid    := TempDb.GetFieldValueInteger (iname, 'LongAvoid');
         end;
      end;
      TempDb.Free;
   end;

   if FileExists ('.\Init\ConsumeEnergy.SDB') then begin
      TempDB := TUserStringDB.Create;
      TempDB.LoadFromFile ('.\Init\ConsumeEnergy.SDB');
      for idx := 0 to TempDb.Count -1 do begin
         if idx > High (SkillConsumeEnergyArr) then begin
            FrmMain.WriteLogInfo ('Init\ConsumeEnergy.SDB: excess rows ignored (maximum 11)');
            break;
         end;
         iname := TempDb.GetIndexName (idx);
         sn := TempDb.GetFieldValueInteger (iname,'StartSkill');
         en := TempDb.GetFieldValueInteger (iname,'EndSkill');
         if sn <= 0 then sn := 0;
         if en >= 999999 then en := 999999;
         SkillConsumeEnergyArr[idx].rStartSkill    := sn;
         SkillConsumeEnergyArr[idx].rEndSkill      := en;
         SkillConsumeEnergyArr[idx].rCosumeValue   := TempDb.GetFieldValueInteger (iname, 'ConsumePercent');
      end;
      TempDb.Free;
   end;
   
   if FileExists ('.\Init\AM&WHRelation.SDB') then begin
      TempDB := TUserStringDB.Create;
      TempDB.LoadFromFile ('.\Init\AM&WHRelation.SDB');
      for idx := 0 to TempDb.Count -1 do begin
         if idx > High (AM_WHRelationTable) then begin
            FrmMain.WriteLogInfo ('Init\AM&WHRelation.SDB: excess rows ignored (maximum 7)');
            break;
         end;
         iname := TempDb.GetIndexName (idx);
         AM_WHRelationTable[idx][0] := TempDb.GetFieldValueInteger (iname,'WindOfHand1');
         AM_WHRelationTable[idx][1] := TempDb.GetFieldValueInteger (iname,'WindOfHand2');
         AM_WHRelationTable[idx][2] := TempDb.GetFieldValueInteger (iname,'WindOfHand3');
         AM_WHRelationTable[idx][3] := TempDb.GetFieldValueInteger (iname,'WindOfHand4');
         AM_WHRelationTable[idx][4] := TempDb.GetFieldValueInteger (iname,'WindOfHand5');
         AM_WHRelationTable[idx][5] := TempDb.GetFieldValueInteger (iname,'WindOfHand6');
      end;
      TempDb.Free;
   end;

   if FileExists ('.\Init\PowerLevel.SDB') then begin
      TempDB := TUserStringDB.Create;
      TempDB.LoadFromFile ('.\Init\PowerLevel.SDB');

      FillChar (PowerLevelArr, SizeOf (PowerLevelArr), 0);

      for idx := 0 to TempDB.Count - 1 do begin
         iName := TempDB.GetIndexName (idx);
         sn := _StrToInt (iName);

         if (sn <= 0) or (sn >= 100) then begin
            FrmMain.WriteLogInfo (Format ('Init\PowerLevel.SDB: invalid Name %s ignored (valid 1..99)', [iName]));
            continue;
         end;

         PowerLevelArr [sn - 1].Name         := TempDB.GetFieldValueString  (iName, 'ViewName');
         PowerLevelArr [sn - 1].PowerValue   := TempDB.GetFieldValueInteger (iName, 'PowerValue');
         PowerLevelArr [sn - 1].Damage       := TempDB.GetFieldValueInteger (iName, 'Damage');
         PowerLevelArr [sn - 1].Armor        := TempDB.GetFieldValueInteger (iName, 'Armor');
         PowerLevelArr [sn - 1].AttackSpeed  := TempDB.GetFieldValueInteger (iName, 'AttackSpeed');
         PowerLevelArr [sn - 1].Recovery     := TempDB.GetFieldValueInteger (iName, 'Recovery');
         PowerLevelArr [sn - 1].Avoid        := TempDB.GetFieldValueInteger (iName, 'Avoid');
         PowerLevelArr [sn - 1].Accuracy     := TempDB.GetFieldValueInteger (iName, 'Accuracy');
         PowerLevelArr [sn - 1].KeepRecovery := TempDB.GetFieldValueInteger (iName, 'KeepRecovery');
         PowerLevelArr [sn - 1].LimitEnergy  := TempDB.GetFieldValueInteger (iName, 'LimitEnergy');
      end;
      TempDB.Free;
   end;

   {
   if FileExists ('.\Init\EnergyLimitTable.SDB') then begin
      TempDB := TUserStringDB.Create;
      TempDB.LoadFromFile ('.\Init\EnergyLimitTable.SDB');

      FillChar (EnergyLimitArr, SizeOf (EnergyLimitArr), 0);
      for idx := 0 to TempDB.Count - 1 do begin
         iName := TempDB.GetIndexName (idx);
         sn := _StrToInt (iName);

         if (sn < 0) or (sn >= 20) then continue;

         EnergyLimitArr[sn] := TempDB.GetFieldValueInteger (iName, 'PowerLevel');
         EnergyLimitArr[sn] := TempDB.GetFieldValueInteger (iName, 'LimitEnergy');
      end;
      TempDB.Free;
   end;
   }
   if FileExists ('.\Init\Magic.SDB') then begin
      MagicDb.LoadFromFile ('.\Init\Magic.SDB');
      for i := 0 to MagicDb.Count - 1 do begin
         mname := MagicDb.GetIndexName (i);
         new (pmd);
         LoadMagicData (mname, pmd^, MagicDb);
         DataList.Add (pmd);
         KeyClass.Insert (mName, pmd);
      end;
   end;

   if FileExists ('.\MagicForGuild.SDB') then begin
      MagicForGuildDb.LoadFromFile ('.\MagicForGuild.SDB');
      for i := 0 to MagicForGuildDb.Count -1 do begin
         mname := MagicForGuildDb.GetIndexName (i);
         new (pmd);
         LoadMagicDataForGuild (mname, pmd^, MagicForGuildDb);
         pmd^.rGuildMagictype := 1;
         DataList.Add (pmd);
         KeyClass.Insert (mName, pmd);
      end;
   end;
end;

function  TMagicClass.GetValueFromRelationTable (aWH, aAM : Integer): Integer;
begin
   Result := 0;
   // First index is protecting magic (0..6), second is palm magic (0..5).
   if (aWH < Low (AM_WHRelationTable)) or
      (aWH > High (AM_WHRelationTable)) then exit;
   if (aAM < Low (AM_WHRelationTable[aWH])) or
      (aAM > High (AM_WHRelationTable[aWH])) then exit;
   Result := AM_WHRelationTable[aWH,aAM];
end;

function  TMagicClass.GetSkillConsumeEnergy (aEnergy: integer): integer;
var
   i : integer;
begin
   Result := 0;
   if (aEnergy <= 0 ) or (aEnergy > 999999) then exit;
   for i := 0 to 10 do begin
      if (SkillConsumeEnergyArr[i].rStartSkill <= aEnergy) and
         (SkillConsumeEnergyArr[i].rEndSkill >= aEnergy) then begin
         Result := SkillConsumeEnergyArr[i].rCosumeValue;
         exit;
      end;
   end;
end;

function  TMagicClass.GetSkillDamageBody (askill: integer): integer;
begin
   Result := 0;
   if (askill <= 0) or (askill >= 10000) then exit;
   Result := SkillAddDamageArr[askill].rdamagebody;
end;

function  TMagicClass.GetSkillDamageBodyForPalm (askill: integer): integer;
begin
   Result := 0;
   if (askill <= 0) or (askill >= 10000) then exit;
   Result := SkillAddPalmDamageArr[askill].rdamagebody;
end;

function  TMagicClass.GetSkillLongAvoidForPalm (askill: integer): integer;
begin
   Result := 0;
   if (askill<=0) or (askill>=10000) then exit;
   Result := SkillAddPalmDamageArr[askill].rlongavoid;
end;

function  TMagicClass.GetSkillDamageHead (askill: integer): integer;
begin
   Result := 0;
   if (askill <= 0) or (askill >= 10000) then exit;
   Result := SkillAddDamageArr[askill].rdamagehead;
end;

function  TMagicClass.GetSkillDamageArm  (askill: integer): integer;
begin
   Result := 0;
   if (askill <= 0) or (askill >= 10000) then exit;
   Result := SkillAddDamageArr[askill].rdamagearm;
end;

function  TMagicClass.GetSkillDamageLeg  (askill: integer): integer;
begin
   Result := 0;
   if (askill <= 0) or (askill >= 10000) then exit;
   Result := SkillAddDamageArr[askill].rdamageleg;
end;

// 2000.10.05 个 眠啊规绢仿 备窍绰 Method
function  TMagicClass.GetSkillArmorBody (askill: integer): integer;
begin
   Result := 0;
   if (askill <= 0) or (askill >= 10000) then exit;
   Result := SkillAddArmorArr[askill].rarmorbody;
end;

// 2000.10.05 赣府 眠啊规绢仿 备窍绰 Method
function  TMagicClass.GetSkillArmorHead (askill: integer): integer;
begin
   Result := 0;
   if (askill <= 0) or (askill >= 10000) then exit;
   Result := SkillAddArmorArr[askill].rarmorhead;
end;

// 2000.10.05 迫 眠啊规绢仿 备窍绰 Method
function  TMagicClass.GetSkillArmorArm  (askill: integer): integer;
begin
   Result := 0;
   if (askill <= 0) or (askill >= 10000) then exit;
   Result := SkillAddArmorArr[askill].rarmorarm;
end;

// 2000.10.05 促府 眠啊规绢仿 备窍绰 Method
function  TMagicClass.GetSkillArmorLeg  (askill: integer): integer;
begin
   Result := 0;
   if (askill <= 0) or (askill >= 10000) then exit;
   Result := SkillAddArmorArr[askill].rarmorleg;
end;

function  TMagicClass.GetPowerLevelName (aLevel : Integer) : String;
begin
   Result := '';
   if (aLevel <= 0) or (aLevel >= 100) then exit;
   Result := PowerLevelArr [aLevel - 1].Name;
end;

function  TMagicClass.GetPowerLevelValue (aLevel : Integer) : Integer;
begin
   Result := 0;
   if (aLevel <= 0) or (aLevel >= 100) then exit;
   Result := PowerLevelArr [aLevel - 1].PowerValue;
end;

function  TMagicClass.CalcPowerLevel (aValue : Integer) : Integer;
var
   i : Integer;
begin
   Result := 0;

   for i := 0 to 100 - 1 do begin
      if PowerLevelArr [i].Name = '' then begin
         Result := i;
         break;
      end;
      if aValue < PowerLevelArr [i].PowerValue then begin
         Result := i;
         exit;
      end;
      if PowerLevelArr [i].PowerValue > 0 then begin
         Result := i;
      end;
   end;
end;

function TMagicClass.GetPowerLevelDamage (aLevel : Integer) : Integer;
begin
   Result := 0;
   if (aLevel <= 0) or (aLevel >= 100) then exit;
   Result := PowerLevelArr [aLevel - 1].Damage;
end;

function TMagicClass.GetPowerLevelArmor (aLevel : Integer) : Integer;
begin
   Result := 0;
   if (aLevel <= 0) or (aLevel >= 100) then exit;
   Result := PowerLevelArr [aLevel - 1].Armor;
end;

function TMagicClass.GetPowerLevelAttackSpeed (aLevel : Integer) : Integer;
begin
   Result := 0;
   if (aLevel <= 0) or (aLevel >= 100) then exit;
   Result := PowerLevelArr [aLevel - 1].AttackSpeed;
end;

function TMagicClass.GetPowerLevelRecovery (aLevel : Integer) : Integer;
begin
   Result := 0;
   if (aLevel <= 0) or (aLevel >= 100) then exit;
   Result := PowerLevelArr [aLevel - 1].Recovery;
end;

function TMagicClass.GetPowerLevelAvoid (aLevel : Integer) : Integer;
begin
   Result := 0;
   if (aLevel <= 0) or (aLevel >= 100) then exit;
   Result := PowerLevelArr [aLevel - 1].Avoid;
end;

function TMagicClass.GetPowerLevelAccuracy (aLevel : Integer) : Integer;
begin
   Result := 0;
   if (aLevel <= 0) or (aLevel >= 100) then exit;
   Result := PowerLevelArr [aLevel - 1].Accuracy;
end;

function TMagicClass.GetPowerLevelKeepRecovery (aLevel : Integer) : Integer;
begin
   Result := 0;
   if (aLevel <= 0) or (aLevel >= 100) then exit;
   Result := PowerLevelArr [aLevel - 1].KeepRecovery;
end;

function TMagicClass.GetPowerLevelLimitEnergy (aLevel : Integer): Integer;
begin
   Result := -1;
   if (aLevel < 0) or (aLevel > 20) then exit;

   Result := PowerLevelArr [aLevel - 1].LimitEnergy;
end;

function TMagicClass.GetMagicData (aMagicName: string; var MagicData: TMagicData; aexp: integer): Boolean;
var
   pd : PTMagicData;
begin
   Result := FALSE;

   pd := KeyClass.Select (aMagicName);
   if pd = nil then begin
      FillChar (MagicData, sizeof(MagicData), 0);
      if aMagicName <> '' then begin
         FrmMain.WriteLogInfo (format ('Magic Not Found  %s',[aMagicName]));
      end;
      exit;
   end;
   MagicData := pd^;
   MagicData.rSkillExp := aexp;
   MagicData.rcSkillLevel := GetLevel (aexp);
   
   Result := TRUE;
end;

function TMagicClass.CheckMagicData (var MagicData: TMagicData; var aRetStr : String) : Boolean;
var
   i : Integer;
   iName : String;
   tmpMagicData : TMagicData;
begin
   Result := false;

   aRetStr := '';

   iName := StrPas (@MagicData.rName);
   if iName = '' then begin
      aRetStr := Conv('没有输入门派武功名称');
      exit;
   end;
   if (Length (iName) < 4) or (Length (iName) > 10) then begin
      aRetStr := Conv('门派武功名称是两个汉字以上五个汉字以下');
      exit;
   end;
   {
   if not isFullHangul (iName) or not isGrammarID (iName) then begin
      aRetStr := Conv('无法使用的门派武功名');
      exit;
   end;
   }
   if CheckPascalString (iName) = 0 then begin
      aRetStr := Conv('无法使用的门派武功名');
      exit;
   end;

   for i := 0 to RejectNameList.Count - 1 do begin
      if Pos (RejectNameList.Strings [i], iName) > 0 then begin
         aRetStr := Conv('无法使用的门派武功名');
         exit;
      end;
   end;

   MagicClass.GetMagicData (iName, tmpMagicData, 1000);
   if tmpMagicData.rName [0] <> 0 then begin
      aRetStr := Conv('已经存在的武功名称');
      exit;
   end;

   Case MagicData.rMagicType of
      MAGICTYPE_WRESTLING,
      MAGICTYPE_FENCING,
      MAGICTYPE_SWORDSHIP,
      MAGICTYPE_HAMMERING,
      MAGICTYPE_SPEARING :
         begin
         end;
      Else begin
         aRetStr := Conv('武功的种类错误');
         exit;
      end;
   end;
   if (MagicData.rLifeData.AttackSpeed < 1) or (MagicData.rLifeData.AttackSpeed > 99) then begin
      aRetStr := Conv('攻击速度只允许1-99的值');
      exit;
   end;
   if (MagicData.rLifeData.DamageBody < 1) or (MagicData.rLifeData.DamageBody > 99) then begin
      aRetStr := Conv('上身破坏力只允许1-99的值');
      exit;
   end;
   if (MagicData.rLifeData.Recovery < 1) or (MagicData.rLifeData.Recovery > 99) then begin
      aRetStr := Conv('恢复只允许1-99的值');
      exit;
   end;
   if (MagicData.rLifeData.Avoid < 1) or (MagicData.rLifeData.Avoid > 99) then begin
      aRetStr := Conv('躲闪只允许1-99的值');
      exit;
   end;
   if (MagicData.rLifeData.Accuracy < 1) or (MagicData.rLifeData.Accuracy > 99) then begin
      if MagicData.rMagicClass = MAGICCLASS_RISEMAGIC then begin
         aRetStr := Conv('正确度的数值范围为1-99');
         exit;
      end else begin
         MagicData.rLifeData.Accuracy := 0;
      end;
   end;
   if (MagicData.rLifeData.KeepRecovery < 1) or (MagicData.rLifeData.KeepRecovery > 99) then begin
      if MagicData.rMagicClass = MAGICCLASS_RISEMAGIC then begin
         aRetStr := Conv('恢复的数值范围为1-99');
         exit;
      end else begin
         MagicData.rLifeData.KeepRecovery := 0;
      end;
   end;
   if (MagicData.rLifeData.DamageHead < 10) or (MagicData.rLifeData.DamageHead > 70) then begin
      aRetStr := Conv('头部攻击只允许10-70的值');
      exit;
   end;
   if (MagicData.rLifeData.DamageArm < 10) or (MagicData.rLifeData.DamageArm > 70) then begin
      aRetStr := Conv('手臂攻击只允许10-70的值');
      exit;
   end;
   if (MagicData.rLifeData.DamageLeg < 10) or (MagicData.rLifeData.DamageLeg > 70) then begin
      aRetStr := Conv('腿部攻击只允许10-70的值');
      exit;
   end;
   if (MagicData.rLifeData.ArmorBody < 10) or (MagicData.rLifeData.ArmorBody > 70) then begin
      aRetStr := Conv('上身防御只允许10-70的值');
      exit;
   end;
   if (MagicData.rLifeData.ArmorHead < 10) or (MagicData.rLifeData.ArmorHead > 70) then begin
      aRetStr := Conv('头部防御只允许10-70的值');
      exit;
   end;
   if (MagicData.rLifeData.ArmorArm < 10) or (MagicData.rLifeData.ArmorArm > 70) then begin
      aRetStr := Conv('手臂防御只允许10-70的值');
      exit;
   end;
   if (MagicData.rLifeData.ArmorLeg < 10) or (MagicData.rLifeData.ArmorLeg > 70) then begin
      aRetStr := Conv('腿部防御只允许10-70的值');
      exit;
   end;
   if (MagicData.rEventDecOutPower < 5) or (MagicData.rEventDecOutPower > 35) then begin
      aRetStr := Conv('外功消耗只允许5-35的值');
      exit;
   end;
   if (MagicData.rEventDecInPower < 5) or (MagicData.rEventDecInPower > 35) then begin
      aRetStr := Conv('内功消耗只允许5-35的值');
      exit;
   end;
   if (MagicData.rEventDecMagic < 5) or (MagicData.rEventDecMagic > 35) then begin
      aRetStr := Conv('武功消耗只允许5-35的值');
      exit;
   end;
   if (MagicData.rEventDecLife < 5) or (MagicData.rEventDecLife > 35) then begin
      aRetStr := Conv('活力消耗只允许5-35的值');
      exit;
   end;

   if MagicData.rLifeData.AttackSpeed + MagicData.rLifeData.DamageBody <> 100 then begin
      aRetStr := Conv('攻击速度和上身攻击之和是100');
      exit;
   end;
   if MagicData.rLifeData.Recovery + MagicData.rLifeData.Avoid <> 100 then begin
      aRetStr := Conv('恢复和躲闪之和是100');
      exit;
   end;
   if MagicData.rLifeData.DamageHead + MagicData.rLifeData.DamageArm +
      MagicData.rLifeData.DamageLeg + MagicData.rLifeData.ArmorBody +
      MagicData.rLifeData.ArmorHead + MagicData.rLifeData.ArmorArm +
      MagicData.rLifeData.ArmorLeg <> 228 then begin
      aRetStr := Conv('（头部，臂，腿）攻击+（上身，头部，臂，腿）防御力之和是228');
      exit;
   end;
   if MagicData.rEventDecInPower + MagicData.rEventDecOutPower +
      MagicData.rEventDecMagic + MagicData.rEventDecLife <> 80 then begin
      aRetStr := Conv('内功+外功+武功+活力（消耗量）之和为80');
      exit;
   end;

   Result := true;
end;

procedure TMagicClass.CompactGuildMagic;
var
   i : Integer;
   MagicName, GuildName : String;
   GuildObject : TGuildObject;
begin
   if MagicForGuildDB.Count = 0 then exit;

   for i := MagicForGuildDB.Count - 1 downto 0 do begin
      MagicName := MagicForGuildDb.GetIndexName (i);
      if MagicName = '' then continue;

      GuildName := MagicForGuildDB.GetFieldValueString (MagicName, 'GuildName');
      GuildObject := GuildList.GetGuildObjectByMagicName (MagicName);
      if GuildObject = nil then begin
         MagicForGuildDB.DeleteName (MagicName);
      end else begin
         MagicForGuildDB.SetFieldValueString (MagicName, 'GuildName', GuildObject.GuildName);
      end;
   end;

   MagicForGuildDB.SaveToFile ('.\MagicForGuild.SDB');

   ReloadFromFile;
end;

function TMagicClass.AddGuildMagic (var aMagicData : TMagicData; aGuildName : String) : Boolean;
var
   iName : String;
   iType, iSoundStrike, iSoundSwing : Integer;
   MagicData : TMagicData;
begin
   Result := false;

   iName := StrPas (@aMagicData.rName);
   MagicForGuildDB.AddName (iName);

   FillChar (MagicData, SizeOf (TMagicData), 0);
   iType := aMagicData.rMagicType;
   Case iType of
      MAGICTYPE_WRESTLING :
         begin
            GetMagicData (Conv('无名拳法'), MagicData, 100);
         end;
      MAGICTYPE_FENCING :
         begin
            GetMagicData (Conv('无名剑法'), MagicData, 100);
         end;
      MAGICTYPE_SWORDSHIP :
         begin
            GetMagicData (Conv('无名刀法'), MagicData, 100);
         end;
      MAGICTYPE_HAMMERING :
         begin
            GetMagicData (Conv('无名槌法'), MagicData, 100);
         end;
      MAGICTYPE_SPEARING :
         begin
            GetMagicData (Conv('无名枪术'), MagicData, 100);
         end;
   end;
   if MagicData.rname [0] = 0 then exit;

   iSoundSwing := MagicData.rSoundSwing.rWavNumber;
   iSoundStrike := MagicData.rSoundStrike.rWavNumber;

   MagicForGuildDB.SetFieldValueString (iName, 'SoundEvent', '');
   MagicForGuildDB.SetFieldValueString (iName, 'SoundStrike', IntToStr (iSoundStrike));
   MagicForGuildDB.SetFieldValueString (iName, 'SoundSwing', IntToStr (iSoundSwing));
   MagicForGuildDB.SetFieldValueString (iName, 'SoundStart', '');
   MagicForGuildDB.SetFieldValueString (iName, 'SoundEnd', '');
   MagicForGuildDB.SetFieldValueInteger (iName, 'Shape', aMagicData.rShape);
   MagicForGuildDB.SetFieldValueInteger (iName, 'MagicType', aMagicData.rMagicType);
   MagicForGuildDB.SetFieldValueInteger (iName, 'EffectColor', aMagicData.rEffectColor);
   MagicForGuildDB.SetFieldValueInteger (iName, 'Function', 0);
   MagicForGuildDB.SetFieldValueInteger (iName, 'AttackSpeed', aMagicData.rLifeData.AttackSpeed);
   MagicForGuildDB.SetFieldValueInteger (iName, 'Recovery', aMagicData.rLifeData.Recovery);
   MagicForGuildDB.SetFieldValueInteger (iName, 'Avoid', aMagicData.rLifeData.Avoid);
   MagicForGuildDB.SetFieldValueInteger (iName, 'Accuracy', aMagicData.rLifeData.Accuracy);
   MagicForGuildDB.SetFieldValueInteger (iName, 'KeepRecovery', aMagicData.rLifeData.KeepRecovery);
   MagicForGuildDB.SetFieldValueInteger (iName, 'DamageBody', aMagicData.rLifeData.DamageBody);
   MagicForGuildDB.SetFieldValueInteger (iName, 'DamageHead', aMagicData.rLifeData.DamageHead);
   MagicForGuildDB.SetFieldValueInteger (iName, 'DamageArm', aMagicData.rLifeData.DamageArm);
   MagicForGuildDB.SetFieldValueInteger (iName, 'DamageLeg', aMagicData.rLifeData.DamageLeg);
   MagicForGuildDB.SetFieldValueInteger (iName, 'ArmorBody', aMagicData.rLifeData.ArmorBody);
   MagicForGuildDB.SetFieldValueInteger (iName, 'ArmorHead', aMagicData.rLifeData.ArmorHead);
   MagicForGuildDB.SetFieldValueInteger (iName, 'ArmorArm', aMagicData.rLifeData.ArmorArm);
   MagicForGuildDB.SetFieldValueInteger (iName, 'ArmorLeg', aMagicData.rLifeData.ArmorLeg);
   MagicForGuildDB.SetFieldValueInteger (iName, 'EnergyPoint', 0);

   MagicForGuildDB.SetFieldValueInteger (iName, 'eEnergy', aMagicData.rEventDecEnergy);
   MagicForGuildDB.SetFieldValueInteger (iName, 'eInPower', aMagicData.rEventDecInPower);
   MagicForGuildDB.SetFieldValueInteger (iName, 'eOutPower', aMagicData.rEventDecOutPower);
   MagicForGuildDB.SetFieldValueInteger (iName, 'eMagic', aMagicData.rEventDecMagic);
   MagicForGuildDB.SetFieldValueInteger (iName, 'eLife', aMagicData.rEventDecLife);

   MagicForGuildDB.SetFieldValueString (iName, 'GuildName', aGuildName);

   MagicForGuildDB.SetFieldValueInteger (iName, 'kEnergy', 10);
   MagicForGuildDB.SetFieldValueInteger (iName, 'kInPower', 10);
   MagicForGuildDB.SetFieldValueInteger (iName, 'kOutPower', 10);
   MagicForGuildDB.SetFieldValueInteger (iName, 'kMagic', 10);
   MagicForGuildDB.SetFieldValueInteger (iName, 'kLife', 10);

   MagicForGuildDB.SaveToFile ('.\MagicForGuild.SDB');

   ReloadFromFile;

   Result := true;
end;

// TMagicParamClass
constructor TMagicParamClass.Create;
begin
   DataList := TList.Create;
   KeyClass := TStringKeyClass.Create;

   LoadFromFile ('.\Init\MagicParam.SDB');
end;

destructor TMagicParamClass.Destroy;
begin
   Clear;
   KeyClass.Free;
   DataList.Free;

   inherited Destroy;
end;

procedure TMagicParamClass.Clear;
var
   i : Integer;
   pd : PTMagicParamData;
begin
   for i := 0 to DataList.Count - 1 do begin
      pd := DataList.Items [i];
      Dispose (pd);
   end;
   DataList.Clear;
   KeyClass.Clear;
end;

function TMagicParamClass.LoadFromFile (aFileName : String) : Boolean;
var
   i, j : Integer;
   iName : String;
   pd : PTMagicParamData;
   DB : TUserStringDB;
begin
   Result := false;

   if not FileExists (aFileName) then exit;

   DB := TUserStringDB.Create;
   DB.LoadFromFile (aFileName);

   for i := 0 to DB.Count - 1 do begin
      iName := DB.GetIndexName (i);
      if iName = '' then continue;

      New (pd);
      FillChar (pd^, SizeOf (TMagicParamData), 0);

      pd^.ObjectName := DB.GetFieldValueString (iName, 'ObjectName');
      pd^.MagicName := DB.GetFieldValueString (iName, 'MagicName');
      for j := 0 to 5 - 1 do begin
         pd^.NameParam [j] := DB.GetFieldValueString (iName, 'NameParam' + IntToStr (j + 1));
      end;
      for j := 0 to 5 - 1 do begin
         pd^.NumberParam [j] := DB.GetFieldValueInteger (iName, 'NumberParam' + IntToStr (j + 1));
      end;

      KeyClass.Insert (pd^.ObjectName + pd^.MagicName, pd);
      DataList.Add (pd);
   end;

   DB.Free;

   Result := true;
end;

function TMagicParamClass.GetMagicParamData (aObjectName, aMagicName : String;var aMagicParamData : TMagicParamData): Boolean;
var
   pd : PTMagicParamData;
   str : string;
begin
   Result := false;

   str := aObjectName + aMagicName;
   pd := KeyClass.Select (str);
   if pd = nil then begin
      FillChar (aMagicParamData, SizeOf (TMagicParamData), 0);
      if str <> '' then begin
         FrmMain.WriteLogInfo (format ('Magic Param Not Found  %s', [str] ));
      end;
      exit;
   end;

   Move (pd^, aMagicParamData, SizeOf (TMagicParamData));

   Result := true;
end;

{
const
   MAGIC_DIV_VALUE      = 10;

   ADD_DAMAGE           = 40;

   MUL_ATTACKSPEED      = 10;
   MUL_AVOID            = 6;
   MUL_RECOVERY         = 10;
   MUL_DAMAGEBODY       = 23;
   MUL_DAMAGEHEAD       = 17;
   MUL_DAMAGEARM        = 17;
   MUL_DAMAGELEG        = 17;
   MUL_ARMORBODY        = 7;
   MUL_ARMORHEAD        = 7;
   MUL_ARMORARM         = 7;
   MUL_ARMORLEG         = 7;

   MUL_EVENTENERGY      = 20;
   MUL_EVENTINPOWER     = 22;
   MUL_EVENTOUTPOWER    = 22;
   MUL_EVENTMAGIC       = 10;
   MUL_EVENTLIFE        = 8;

   MUL_5SECENERGY       = 20;
   MUL_5SECINPOWER      = 14;
   MUL_5SECOUTPOWER     = 14;
   MUL_5SECMAGIC        = 9;
   MUL_5SECLIFE         = 8;
}
function TMagicClass.LoadMagicData (aMagicName: string; var MagicData: TMagicData; aDb: TUserStringDb): Boolean;
var
   n : Integer;
begin
   Result := FALSE;
   FillChar (MagicData, sizeof(MagicData), 0);
   if aDb.GetDbString (aMagicName) = '' then exit;
   with MagicData do begin
      StrPCopy (@rname, aMagicName);
      // rPercent := 10;
      StrPCopy (@rViewName, aDb.GetFieldValueString (aMagicName, 'ViewName'));
      rEnergyPoint := aDb.GetFieldValueinteger (aMagicName, 'EnergyPoint');
      rKind := aDB.GetFieldValueInteger (aMagicName, 'Kind'); 

      StrToEffectData (rSoundEvent, aDb.GetFieldValueString (aMagicName, 'SoundEvent'));
      StrToEffectData (rSoundStrike, aDb.GetFieldValueString (aMagicName, 'SoundStrike'));
      StrToEffectData (rSoundSwing, aDb.GetFieldValueString (aMagicName, 'SoundSwing'));
      StrToEffectData (rSoundStart, aDb.GetFieldValueString (aMagicName, 'SoundStart'));
      StrToEffectData (rSoundEnd, aDb.GetFieldValueString (aMagicName, 'SoundEnd'));

      rBowImage := aDb.GetFieldValueinteger (aMagicName, 'BowImage');
      rBowSpeed := aDb.GetFieldValueinteger (aMagicName, 'BowSpeed');
      rBowType := aDb.GetFieldValueinteger (aMagicName, 'BowType');
      rShape := aDb.GetFieldValueinteger (aMagicName, 'Shape');

      rMagicType := aDb.GetFieldValueinteger (aMagicName, 'MagicType') mod 100;
      rMagicClass := aDb.GetFieldValueinteger (aMagicName, 'MagicType') div 100;
      rMagicRelation := aDB.GetFieldValueInteger (aMagicName, 'MagicRelation');
      rRelationMagic := aDB.GetFieldValueInteger (aMagicName, 'RelationMagic');
      rPatternType := aDB.GetFieldValueInteger (aMagicName, 'PatternType');
      rRangeType := aDB.GetFieldValueInteger (aMagicName, 'RangeType');
      rAttackCount := aDB.GetFieldValueInteger (aMagicName, 'AttackCount');
      StrPCopy (@rNeedMagic, aDb.GetFieldValueString (aMagicName, 'NeedMagic'));
      rPushLength := aDB.GetFieldValueInteger (aMagicName, 'PushLength');
      rboNotRecovery := aDB.GetFieldValueBoolean (aMagicName, 'boNotRecovery');
      rStun := aDB.GetFieldValueInteger (aMagicName, 'Stun');
      rScreenEffectNum := aDB.GetFieldValueInteger (aMagicName, 'ScreenEffectNum');
      rScreenEffectDelay := aDB.GetFieldValueInteger (aMagicName, 'ScreenEffectDelay');
      rMotionType := aDB.GetFieldValueInteger (aMagicName, 'MotionType');

      rFunction := aDb.GetFieldValueinteger (aMagicName, 'Function');

      rEffectColor := aDB.GetFieldValueInteger (aMagicName, 'EffectColor');
      if rEffectColor = 0 then rEffectColor := 1;

      rSEffectNumber := aDB.GetFieldValueInteger (aMagicName, 'SEffectNumber');
      rSEffectNumber2 := aDB.GetFieldValueInteger (aMagicName, 'SEffectNumber2');      
      rCEffectNumber := aDB.GetFieldValueInteger (aMagicName, 'CEffectNumber');
      rEEffectNumber := aDB.GetFieldValueInteger (aMagicName, 'EEffectNumber');
      rMinRange := aDB.GetFieldValueInteger (aMagicName, 'MinRange');
      rMaxRange := aDB.GetFieldValueInteger (aMagicName, 'MaxRange');
//      rShootDelay := aDB.GetFieldValueInteger (aMagicName, 'ShootDelay');
      rEffectDelay := aDB.GetFieldValueInteger (aMagicName, 'EffectDelay');

      StrPCopy (@rRelationProtect, aDB.GetFieldValueString (aMagicName, 'RelationProtect'));
      StrPCopy (@rSameSection, aDB.GetFieldValueString (aMagicName, 'SameSection'));

      // 扁夯公傍
      if rMagicClass = MAGICCLASS_MAGIC then begin
         if aDb.GetFieldValueinteger (aMagicName, 'AttackSpeed') <> 0 then
            rLifeData.AttackSpeed := (120 - aDb.GetFieldValueinteger (aMagicName, 'AttackSpeed') ) * INI_MUL_ATTACKSPEED div INI_MAGIC_DIV_VALUE;
         if aDb.GetFieldValueinteger (aMagicName, 'Recovery') <> 0 then
            rLifeData.recovery := (120 - aDb.GetFieldValueinteger (aMagicName, 'Recovery') ) * INI_MUL_RECOVERY div INI_MAGIC_DIV_VALUE;
         if aDb.GetFieldValueinteger (aMagicName, 'Avoid') <> 0 then
            rLifeData.avoid := aDb.GetFieldValueinteger (aMagicName, 'Avoid') * INI_MUL_AVOID div INI_MAGIC_DIV_VALUE;
         if aDB.GetFieldValueInteger (aMagicName, 'Accuracy') <> 0 then
            rLifeData.Accuracy := aDB.GetFieldValueInteger (aMagicName, 'Accuracy') * INI_MUL_ACCURACY div INI_MAGIC_DIV_VALUE;
         if aDB.GetFieldValueInteger (aMagicName, 'KeepRecovery') <> 0 then
            rLifeData.KeepRecovery := aDB.GetFieldValueInteger (aMagicName, 'KeepRecovery') * INI_MUL_KEEPRECOVERY div INI_MAGIC_DIV_VALUE;

         if aDb.GetFieldValueinteger (aMagicName, 'DamageBody') <> 0 then
            rLifeData.damageBody := (aDb.GetFieldValueinteger (aMagicName, 'DamageBody')+INI_ADD_DAMAGE) * INI_MUL_DAMAGEBODY div INI_MAGIC_DIV_VALUE;

         if aDb.GetFieldValueinteger (aMagicName, 'DamageHead') <> 0 then
            rLifeData.damageHead := (aDb.GetFieldValueinteger (aMagicName, 'DamageHead')+INI_ADD_DAMAGE) * INI_MUL_DAMAGEHEAD div INI_MAGIC_DIV_VALUE;

         if aDb.GetFieldValueinteger (aMagicName, 'DamageArm') <> 0 then
            rLifeData.damageArm := (aDb.GetFieldValueinteger (aMagicName, 'DamageArm')+INI_ADD_DAMAGE) * INI_MUL_DAMAGEARM div INI_MAGIC_DIV_VALUE;

         if aDb.GetFieldValueinteger (aMagicName, 'DamageLeg') <> 0 then
            rLifeData.damageLeg := (aDb.GetFieldValueinteger (aMagicName, 'DamageLeg')+INI_ADD_DAMAGE) * INI_MUL_DAMAGELEG div INI_MAGIC_DIV_VALUE;
         rLifeData.damageenergy := aDB.GetFieldValueInteger (aMagicName, 'DamageEnergy');

         rLifeData.armorBody := aDb.GetFieldValueinteger (aMagicName, 'ArmorBody') * INI_MUL_ARMORBODY div INI_MAGIC_DIV_VALUE;
         rLifeData.armorHead := aDb.GetFieldValueinteger (aMagicName, 'ArmorHead') * INI_MUL_ARMORHEAD div INI_MAGIC_DIV_VALUE;
         rLifeData.armorArm := aDb.GetFieldValueinteger (aMagicName, 'ArmorArm') * INI_MUL_ARMORARM div INI_MAGIC_DIV_VALUE;
         rLifeData.armorLeg := aDb.GetFieldValueinteger (aMagicName, 'ArmorLeg') * INI_MUL_ARMORLEG div INI_MAGIC_DIV_VALUE;
         rLifeData.armorenergy := aDB.GetFieldValueInteger (aMagicName, 'ArmorEnergy');

         rEventDecEnergy := aDb.GetFieldValueinteger (aMagicName, 'eEnergy') * INI_MUL_EVENTENERGY div INI_MAGIC_DIV_VALUE;
         rEventDecInPower:= aDb.GetFieldValueinteger (aMagicName, 'eInPower') * INI_MUL_EVENTINPOWER div INI_MAGIC_DIV_VALUE;
         rEventDecOutPower:= aDb.GetFieldValueinteger (aMagicName, 'eOutPower') * INI_MUL_EVENTOUTPOWER div INI_MAGIC_DIV_VALUE;
         rEventDecMagic := aDb.GetFieldValueinteger (aMagicName, 'eMagic') * INI_MUL_EVENTMAGIC div INI_MAGIC_DIV_VALUE;
         rEventDecLife := aDb.GetFieldValueinteger (aMagicName, 'eLife') * INI_MUL_EVENTLIFE div INI_MAGIC_DIV_VALUE;
         rEventDecDamageHead := aDb.GetFieldValueinteger (aMagicName, 'eDamageHead') * INI_MUL_EVENTDAMAGEHEAD div INI_MAGIC_DIV_VALUE;
         rEventDecDamageArm := aDb.GetFieldValueinteger (aMagicName, 'eDamageArm') * INI_MUL_EVENTDAMAGEARM div INI_MAGIC_DIV_VALUE;
         rEventDecDamageLeg := aDb.GetFieldValueinteger (aMagicName, 'eDamageLeg') * INI_MUL_EVENTDAMAGELEG div INI_MAGIC_DIV_VALUE;

         rEventBreathngEnergy := aDb.GetFieldValueinteger (aMagicName, 'eEnergy');
         rEventBreathngInPower:= aDb.GetFieldValueinteger (aMagicName, 'eInPower');
         rEventBreathngOutPower:= aDb.GetFieldValueinteger (aMagicName, 'eOutPower');
         rEventBreathngMagic := aDb.GetFieldValueinteger (aMagicName, 'eMagic');
         rEventBreathngLife := aDb.GetFieldValueinteger (aMagicName, 'eLife');
         rEventBreathngDamageHead := aDB.GetFieldValueInteger (aMagicName, 'eDamageHead');
         rEventBreathngDamageArm := aDB.GetFieldValueInteger (aMagicName, 'eDamageArm');
         rEventBreathngDamageLeg := aDB.GetFieldValueInteger (aMagicName, 'eDamageLeg');

         r5SecDecEnergy := aDb.GetFieldValueinteger (aMagicName, '5Energy') * INI_MUL_5SECENERGY div INI_MAGIC_DIV_VALUE;
         r5SecDecInPower:= aDb.GetFieldValueinteger (aMagicName, '5InPower') * INI_MUL_5SECINPOWER div INI_MAGIC_DIV_VALUE;
         r5SecDecOutPower:= aDb.GetFieldValueinteger (aMagicName, '5OutPower') * INI_MUL_5SECOUTPOWER div INI_MAGIC_DIV_VALUE;
         r5SecDecMagic := aDb.GetFieldValueinteger (aMagicName, '5Magic') * INI_MUL_5SECMAGIC div INI_MAGIC_DIV_VALUE;
         r5SecDecLife := aDb.GetFieldValueinteger (aMagicName, '5Life') * INI_MUL_5SECLIFE div INI_MAGIC_DIV_VALUE;
         r5SecDecDamageHead := aDb.GetFieldValueinteger (aMagicName, '5DamageHead') * INI_MUL_5SECDAMAGEHEAD div INI_MAGIC_DIV_VALUE;
         r5SecDecDamageArm := aDb.GetFieldValueinteger (aMagicName, '5DamageArm') * INI_MUL_5SECDAMAGEARM div INI_MAGIC_DIV_VALUE;
         r5SecDecDamageLeg := aDb.GetFieldValueinteger (aMagicName, '5DamageLeg') * INI_MUL_5SECDAMAGELEG div INI_MAGIC_DIV_VALUE;

         rKeepEnergy := aDb.GetFieldValueinteger (aMagicName, 'kEnergy') * 10;
         rKeepInPower:= aDb.GetFieldValueinteger (aMagicName, 'kInPower') * 10;
         rKeepOutPower:= aDb.GetFieldValueinteger (aMagicName, 'kOutPower') * 10;
         rKeepMagic := aDb.GetFieldValueinteger (aMagicName, 'kMagic') * 10;
         rKeepLife := aDb.GetFieldValueinteger (aMagicName, 'kLife') * 10;
         rKeepDamageHead := aDb.GetFieldValueinteger (aMagicName, 'kDamageHead') * 10;         
         rKeepDamageArm := aDb.GetFieldValueinteger (aMagicName, 'kDamageArm') * 10;
         rKeepDamageLeg := aDb.GetFieldValueinteger (aMagicName, 'kDamageLeg') * 10;
      end else if rMagicClass = MAGICCLASS_RISEMAGIC then begin
         // 惑铰公傍
         if aDb.GetFieldValueinteger (aMagicName, 'AttackSpeed') <> 0 then
            rLifeData.AttackSpeed := (130 - aDb.GetFieldValueinteger (aMagicName, 'AttackSpeed') ) * INI_MUL_ATTACKSPEED2 div INI_MAGIC_DIV_VALUE2;
         if aDb.GetFieldValueinteger (aMagicName, 'Recovery') <> 0 then
            rLifeData.recovery := (130 - aDb.GetFieldValueinteger (aMagicName, 'Recovery') ) * INI_MUL_RECOVERY2 div INI_MAGIC_DIV_VALUE2;
         if aDb.GetFieldValueinteger (aMagicName, 'Avoid') <> 0 then
            rLifeData.avoid := aDb.GetFieldValueinteger (aMagicName, 'Avoid') * INI_MUL_AVOID2 div INI_MAGIC_DIV_VALUE2;

         // 公傍.SDB 俊 汲沥等 沥犬档客 磊技蜡瘤狼 蔼阑 角力 荤侩登绰 蔼栏肺 函券窍绰 镑
         if aDb.GetFieldValueinteger (aMagicName, 'KeepRecovery') <> 0 then begin
            n := aDb.GetFieldValueinteger (aMagicName, 'KeepRecovery');
            rLifeData.keeprecovery := (n * n div 22 + 70);  // 瘤陛
         end;
         if aDb.GetFieldValueinteger (aMagicName, 'Accuracy') <> 0 then begin
            n := aDb.GetFieldValueinteger (aMagicName, 'accuracy');
            // 沥犬档函版矫
            rLifeData.accuracy := n * 6 div 10;
         end;

         // 汲沥蔼俊 蝶扼辑 公傍汲沥摹甫 牢沥窍绰镑
         if aDb.GetFieldValueinteger (aMagicName, 'DamageBody') <> 0 then
            rLifeData.damageBody := (aDb.GetFieldValueinteger (aMagicName, 'DamageBody')+INI_ADD_DAMAGE2) * INI_MUL_DAMAGEBODY2 div INI_MAGIC_DIV_VALUE2;

         if aDb.GetFieldValueinteger (aMagicName, 'DamageHead') <> 0 then
            rLifeData.damageHead := (aDb.GetFieldValueinteger (aMagicName, 'DamageHead')+INI_ADD_DAMAGE2) * INI_MUL_DAMAGEHEAD2 div INI_MAGIC_DIV_VALUE2;

         if aDb.GetFieldValueinteger (aMagicName, 'DamageArm') <> 0 then
            rLifeData.damageArm := (aDb.GetFieldValueinteger (aMagicName, 'DamageArm')+INI_ADD_DAMAGE2) * INI_MUL_DAMAGEARM2 div INI_MAGIC_DIV_VALUE2;

         if aDb.GetFieldValueinteger (aMagicName, 'DamageLeg') <> 0 then
            rLifeData.damageLeg := (aDb.GetFieldValueinteger (aMagicName, 'DamageLeg')+INI_ADD_DAMAGE2) * INI_MUL_DAMAGELEG2 div INI_MAGIC_DIV_VALUE2;

         rLifeData.damageenergy := aDB.GetFieldValueInteger (aMagicName, 'DamageEnergy');

         rLifeData.armorBody := aDb.GetFieldValueinteger (aMagicName, 'ArmorBody') * INI_MUL_ARMORBODY2 div INI_MAGIC_DIV_VALUE2;
         rLifeData.armorHead := aDb.GetFieldValueinteger (aMagicName, 'ArmorHead') * INI_MUL_ARMORHEAD2 div INI_MAGIC_DIV_VALUE2;
         rLifeData.armorArm := aDb.GetFieldValueinteger (aMagicName, 'ArmorArm') * INI_MUL_ARMORARM2 div INI_MAGIC_DIV_VALUE2;
         rLifeData.armorLeg := aDb.GetFieldValueinteger (aMagicName, 'ArmorLeg') * INI_MUL_ARMORLEG2 div INI_MAGIC_DIV_VALUE2;
         rLifeData.armorenergy := aDB.GetFieldValueInteger (aMagicName, 'ArmorEnergy');

         rEventDecEnergy := aDb.GetFieldValueinteger (aMagicName, 'eEnergy') * INI_MUL_EVENTENERGY2 div INI_MAGIC_DIV_VALUE2;
         rEventDecInPower:= aDb.GetFieldValueinteger (aMagicName, 'eInPower') * INI_MUL_EVENTINPOWER2 div INI_MAGIC_DIV_VALUE2;
         rEventDecOutPower:= aDb.GetFieldValueinteger (aMagicName, 'eOutPower') * INI_MUL_EVENTOUTPOWER2 div INI_MAGIC_DIV_VALUE2;
         rEventDecMagic := aDb.GetFieldValueinteger (aMagicName, 'eMagic') * INI_MUL_EVENTMAGIC2 div INI_MAGIC_DIV_VALUE2;
         rEventDecLife := aDb.GetFieldValueinteger (aMagicName, 'eLife') * INI_MUL_EVENTLIFE2 div INI_MAGIC_DIV_VALUE2;
         rEventDecDamageHead := aDb.GetFieldValueinteger (aMagicName, 'eDamageHead') * INI_MUL_EVENTDAMAGEHEAD2 div INI_MAGIC_DIV_VALUE2;
         rEventDecDamageArm := aDb.GetFieldValueinteger (aMagicName, 'eDamageArm') * INI_MUL_EVENTDAMAGEARM2 div INI_MAGIC_DIV_VALUE2;
         rEventDecDamageLeg := aDb.GetFieldValueinteger (aMagicName, 'eDamageLeg') * INI_MUL_EVENTDAMAGELEG2 div INI_MAGIC_DIV_VALUE2;

         rEventBreathngEnergy := aDb.GetFieldValueinteger (aMagicName, 'eEnergy');
         rEventBreathngInPower:= aDb.GetFieldValueinteger (aMagicName, 'eInPower');
         rEventBreathngOutPower:= aDb.GetFieldValueinteger (aMagicName, 'eOutPower');
         rEventBreathngMagic := aDb.GetFieldValueinteger (aMagicName, 'eMagic');
         rEventBreathngLife := aDb.GetFieldValueinteger (aMagicName, 'eLife');
         rEventBreathngDamageHead := aDB.GetFieldValueInteger (aMagicName, 'eDamageHead');
         rEventBreathngDamageArm := aDB.GetFieldValueInteger (aMagicName, 'eDamageArm');
         rEventBreathngDamageLeg := aDB.GetFieldValueInteger (aMagicName, 'eDamageLeg');

         r5SecDecEnergy := aDb.GetFieldValueinteger (aMagicName, '5Energy') * INI_MUL_5SECENERGY2 div INI_MAGIC_DIV_VALUE2;
         r5SecDecInPower:= aDb.GetFieldValueinteger (aMagicName, '5InPower') * INI_MUL_5SECINPOWER2 div INI_MAGIC_DIV_VALUE2;
         r5SecDecOutPower:= aDb.GetFieldValueinteger (aMagicName, '5OutPower') * INI_MUL_5SECOUTPOWER2 div INI_MAGIC_DIV_VALUE2;
         r5SecDecMagic := aDb.GetFieldValueinteger (aMagicName, '5Magic') * INI_MUL_5SECMAGIC2 div INI_MAGIC_DIV_VALUE2;
         r5SecDecLife := aDb.GetFieldValueinteger (aMagicName, '5Life') * INI_MUL_5SECLIFE2 div INI_MAGIC_DIV_VALUE2;
         r5SecDecDamageHead := aDb.GetFieldValueinteger (aMagicName, '5DamageHead') * INI_MUL_5SECDAMAGEHEAD2 div INI_MAGIC_DIV_VALUE2;
         r5SecDecDamageArm := aDb.GetFieldValueinteger (aMagicName, '5DamageArm') * INI_MUL_5SECDAMAGEARM2 div INI_MAGIC_DIV_VALUE2;
         r5SecDecDamageLeg := aDb.GetFieldValueinteger (aMagicName, '5DamageLeg') * INI_MUL_5SECDAMAGELEG2 div INI_MAGIC_DIV_VALUE2;

         rKeepEnergy := aDb.GetFieldValueinteger (aMagicName, 'kEnergy') * 10;
         rKeepInPower:= aDb.GetFieldValueinteger (aMagicName, 'kInPower') * 10;
         rKeepOutPower:= aDb.GetFieldValueinteger (aMagicName, 'kOutPower') * 10;
         rKeepMagic := aDb.GetFieldValueinteger (aMagicName, 'kMagic') * 10;
         rKeepLife := aDb.GetFieldValueinteger (aMagicName, 'kLife') * 10;
         rKeepDamageHead := aDb.GetFieldValueinteger (aMagicName, 'kDamageHead') * 10;         
         rKeepDamageArm := aDb.GetFieldValueinteger (aMagicName, 'kDamageArm') * 10;
         rKeepDamageLeg := aDb.GetFieldValueinteger (aMagicName, 'kDamageLeg') * 10;
      end else if rMagicClass = MAGICCLASS_MYSTERY then begin
         //厘过. 傍烹登绰 夸家绰 固府 惶酒辑 拌魂秦初绰.
         if aDb.GetFieldValueinteger (aMagicName, 'AttackSpeed') <> 0 then begin
            n := aDb.GetFieldValueinteger (aMagicName, 'AttackSpeed');
            rLifeData.AttackSpeed := 201 - 128 * n div 100;
         end;
         if aDb.GetFieldValueinteger (aMagicName, 'Recovery') <> 0 then begin
            n := aDb.GetFieldValueinteger (aMagicName, 'Recovery');
            rLifeData.recovery := 50 - 36 * n div 100;
         end;
         if aDb.GetFieldValueinteger (aMagicName, 'Avoid') <> 0 then begin
            n := aDb.GetFieldValueinteger (aMagicName, 'Avoid');
            rLifeData.avoid := 2 * n div 10 + 10;
         end;
         // 公傍.SDB 俊 汲沥等 沥犬档客 磊技蜡瘤狼 蔼阑 角力 荤侩登绰 蔼栏肺 函券窍绰 镑
         if aDb.GetFieldValueinteger (aMagicName, 'KeepRecovery') <> 0 then begin
            n := aDb.GetFieldValueinteger (aMagicName, 'KeepRecovery');
            rLifeData.keeprecovery := 223 + (23 * n div 10);
         end;
         if aDb.GetFieldValueinteger (aMagicName, 'Accuracy') <> 0 then begin
            n := aDb.GetFieldValueinteger (aMagicName, 'accuracy');
            rLifeData.accuracy := 3 * n div 10 + 30;
         end;

         // 汲沥蔼俊 蝶扼辑 公傍汲沥摹甫 牢沥窍绰镑
         if aDb.GetFieldValueinteger (aMagicName, 'DamageBody') <> 0 then begin
            n := aDb.GetFieldValueinteger (aMagicName, 'DamageBody');
            rLifeData.damageBody := 168 * n div 100 + 328;
         end;

         rLifeData.damageenergy := aDB.GetFieldValueInteger (aMagicName, 'DamageEnergy');
         
         rLifeData.armorBody := aDb.GetFieldValueinteger (aMagicName, 'ArmorBody') * INI_MUL_ARMORBODY2 div INI_MAGIC_DIV_VALUE2;
         rLifeData.armorHead := aDb.GetFieldValueinteger (aMagicName, 'ArmorHead') * INI_MUL_ARMORHEAD2 div INI_MAGIC_DIV_VALUE2;
         rLifeData.armorArm := aDb.GetFieldValueinteger (aMagicName, 'ArmorArm') * INI_MUL_ARMORARM2 div INI_MAGIC_DIV_VALUE2;
         rLifeData.armorLeg := aDb.GetFieldValueinteger (aMagicName, 'ArmorLeg') * INI_MUL_ARMORLEG2 div INI_MAGIC_DIV_VALUE2;
         rLifeData.armorenergy := aDB.GetFieldValueInteger (aMagicName, 'ArmorEnergy');

         rEventDecEnergy := aDb.GetFieldValueinteger (aMagicName, 'eEnergy') * INI_MUL_EVENTENERGY2 div INI_MAGIC_DIV_VALUE2;
         rEventDecInPower:= aDb.GetFieldValueinteger (aMagicName, 'eInPower') * INI_MUL_EVENTINPOWER2 div INI_MAGIC_DIV_VALUE2;
         rEventDecOutPower:= aDb.GetFieldValueinteger (aMagicName, 'eOutPower') * INI_MUL_EVENTOUTPOWER2 div INI_MAGIC_DIV_VALUE2;
         rEventDecMagic := aDb.GetFieldValueinteger (aMagicName, 'eMagic') * INI_MUL_EVENTMAGIC2 div INI_MAGIC_DIV_VALUE2;
         rEventDecLife := aDb.GetFieldValueinteger (aMagicName, 'eLife') * INI_MUL_EVENTLIFE2 div INI_MAGIC_DIV_VALUE2;
         rEventDecDamageHead := aDb.GetFieldValueinteger (aMagicName, 'eDamageHead') * INI_MUL_EVENTDAMAGEHEAD2 div INI_MAGIC_DIV_VALUE2;
         rEventDecDamageArm := aDb.GetFieldValueinteger (aMagicName, 'eDamageArm') * INI_MUL_EVENTDAMAGEARM2 div INI_MAGIC_DIV_VALUE2;
         rEventDecDamageLeg := aDb.GetFieldValueinteger (aMagicName, 'eDamageLeg') * INI_MUL_EVENTDAMAGELEG2 div INI_MAGIC_DIV_VALUE2;

         rEventBreathngEnergy := aDb.GetFieldValueinteger (aMagicName, 'eEnergy');
         rEventBreathngInPower:= aDb.GetFieldValueinteger (aMagicName, 'eInPower');
         rEventBreathngOutPower:= aDb.GetFieldValueinteger (aMagicName, 'eOutPower');
         rEventBreathngMagic := aDb.GetFieldValueinteger (aMagicName, 'eMagic');
         rEventBreathngLife := aDb.GetFieldValueinteger (aMagicName, 'eLife');
         rEventBreathngDamageHead := aDB.GetFieldValueInteger (aMagicName, 'eDamageHead');
         rEventBreathngDamageArm := aDB.GetFieldValueInteger (aMagicName, 'eDamageArm');
         rEventBreathngDamageLeg := aDB.GetFieldValueInteger (aMagicName, 'eDamageLeg');

         r5SecDecEnergy := aDb.GetFieldValueinteger (aMagicName, '5Energy') * INI_MUL_5SECENERGY2 div INI_MAGIC_DIV_VALUE2;
         r5SecDecInPower:= aDb.GetFieldValueinteger (aMagicName, '5InPower') * INI_MUL_5SECINPOWER2 div INI_MAGIC_DIV_VALUE2;
         r5SecDecOutPower:= aDb.GetFieldValueinteger (aMagicName, '5OutPower') * INI_MUL_5SECOUTPOWER2 div INI_MAGIC_DIV_VALUE2;
         r5SecDecMagic := aDb.GetFieldValueinteger (aMagicName, '5Magic') * INI_MUL_5SECMAGIC2 div INI_MAGIC_DIV_VALUE2;
         r5SecDecLife := aDb.GetFieldValueinteger (aMagicName, '5Life') * INI_MUL_5SECLIFE2 div INI_MAGIC_DIV_VALUE2;
         r5SecDecDamageHead := aDb.GetFieldValueinteger (aMagicName, '5DamageHead') * INI_MUL_5SECDAMAGEHEAD2 div INI_MAGIC_DIV_VALUE2;
         r5SecDecDamageArm := aDb.GetFieldValueinteger (aMagicName, '5DamageArm') * INI_MUL_5SECDAMAGEARM2 div INI_MAGIC_DIV_VALUE2;
         r5SecDecDamageLeg := aDb.GetFieldValueinteger (aMagicName, '5DamageLeg') * INI_MUL_5SECDAMAGELEG2 div INI_MAGIC_DIV_VALUE2;

         rKeepEnergy := aDb.GetFieldValueinteger (aMagicName, 'kEnergy') * 10;
         rKeepInPower:= aDb.GetFieldValueinteger (aMagicName, 'kInPower') * 10;
         rKeepOutPower:= aDb.GetFieldValueinteger (aMagicName, 'kOutPower') * 10;
         rKeepMagic := aDb.GetFieldValueinteger (aMagicName, 'kMagic') * 10;
         rKeepLife := aDb.GetFieldValueinteger (aMagicName, 'kLife') * 10;
         rKeepDamageHead := aDb.GetFieldValueinteger (aMagicName, 'kDamageHead') * 10;         
         rKeepDamageArm := aDb.GetFieldValueinteger (aMagicName, 'kDamageArm') * 10;
         rKeepDamageLeg := aDb.GetFieldValueinteger (aMagicName, 'kDamageLeg') * 10;
      end else if rMagicClass = MAGICCLASS_BESTMAGIC then begin
         // 犬厘公傍
         if rMagicType = MAGICTYPE_BESTSPECIAL then begin
            rEventDecEnergy := aDb.GetFieldValueinteger (aMagicName, 'eEnergy');
            r5SecDecEnergy := aDb.GetFieldValueinteger (aMagicName, '5Energy');
         end else begin
            rEventDecEnergy := aDb.GetFieldValueinteger (aMagicName, 'eEnergy') * INI_MUL_EVENTENERGY2 div INI_MAGIC_DIV_VALUE2;
            r5SecDecEnergy := aDb.GetFieldValueinteger (aMagicName, '5Energy') * INI_MUL_5SECINPOWER div INI_MAGIC_DIV_VALUE;
         end;

         rEventDecInPower:= aDb.GetFieldValueinteger (aMagicName, 'eInPower') * INI_MUL_EVENTINPOWER2 div INI_MAGIC_DIV_VALUE2;
         rEventDecOutPower:= aDb.GetFieldValueinteger (aMagicName, 'eOutPower') * INI_MUL_EVENTOUTPOWER2 div INI_MAGIC_DIV_VALUE2;
         rEventDecMagic := aDb.GetFieldValueinteger (aMagicName, 'eMagic') * INI_MUL_EVENTMAGIC2 div INI_MAGIC_DIV_VALUE2;
         rEventDecLife := aDb.GetFieldValueinteger (aMagicName, 'eLife') * INI_MUL_EVENTLIFE2 div INI_MAGIC_DIV_VALUE2;
         rEventDecDamageHead := aDb.GetFieldValueinteger (aMagicName, 'eDamageHead') * INI_MUL_EVENTDAMAGEHEAD2 div INI_MAGIC_DIV_VALUE2;
         rEventDecDamageArm := aDb.GetFieldValueinteger (aMagicName, 'eDamageArm') * INI_MUL_EVENTDAMAGEARM2 div INI_MAGIC_DIV_VALUE2;
         rEventDecDamageLeg := aDb.GetFieldValueinteger (aMagicName, 'eDamageLeg') * INI_MUL_EVENTDAMAGELEG2 div INI_MAGIC_DIV_VALUE2;
         r5SecDecInPower:= aDb.GetFieldValueinteger (aMagicName, '5InPower') * INI_MUL_5SECINPOWER div INI_MAGIC_DIV_VALUE;
         r5SecDecOutPower:= aDb.GetFieldValueinteger (aMagicName, '5OutPower') * INI_MUL_5SECOUTPOWER div INI_MAGIC_DIV_VALUE;
         r5SecDecMagic := aDb.GetFieldValueinteger (aMagicName, '5Magic') * INI_MUL_5SECMAGIC div INI_MAGIC_DIV_VALUE;
         r5SecDecLife := aDb.GetFieldValueinteger (aMagicName, '5Life') * INI_MUL_5SECLIFE div INI_MAGIC_DIV_VALUE;
         r5SecDecDamageHead := aDb.GetFieldValueinteger (aMagicName, '5DamageHead') * INI_MUL_5SECDAMAGEHEAD div INI_MAGIC_DIV_VALUE;
         r5SecDecDamageArm := aDb.GetFieldValueinteger (aMagicName, '5DamageArm') * INI_MUL_5SECDAMAGEARM div INI_MAGIC_DIV_VALUE;
         r5SecDecDamageLeg := aDb.GetFieldValueinteger (aMagicName, '5DamageLeg') * INI_MUL_5SECDAMAGELEG div INI_MAGIC_DIV_VALUE;

         rKeepEnergy := aDb.GetFieldValueinteger (aMagicName, 'kEnergy') * 10;
         rKeepInPower:= aDb.GetFieldValueinteger (aMagicName, 'kInPower') * 10;
         rKeepOutPower:= aDb.GetFieldValueinteger (aMagicName, 'kOutPower') * 10;
         rKeepMagic := aDb.GetFieldValueinteger (aMagicName, 'kMagic') * 10;
         rKeepLife := aDb.GetFieldValueinteger (aMagicName, 'kLife') * 10;
         rKeepDamageHead := aDb.GetFieldValueinteger (aMagicName, 'kDamageHead') * 10;
         rKeepDamageArm := aDb.GetFieldValueinteger (aMagicName, 'kDamageArm') * 10;
         rKeepDamageLeg := aDb.GetFieldValueinteger (aMagicName, 'kDamageLeg') * 10;

         rLifeData.damageBody := aDB.GetFieldValueInteger (aMagicName, 'DamageBody');
         rLifeData.damageHead := aDB.GetFieldValueInteger (aMagicName, 'DamageHead');
         rLifeData.damageArm := aDB.GetFieldValueInteger (aMagicName, 'DamageArm');
         rLifeData.damageLeg := aDB.GetFieldValueInteger (aMagicName, 'DamageLeg');
         rLifeData.damageenergy := aDB.GetFieldValueInteger (aMagicName, 'DamageEnergy');

         rLifeData.armorBody := aDB.GetFieldValueInteger (aMagicName, 'ArmorBody');
         rLifeData.armorHead := aDB.GetFieldValueInteger (aMagicName, 'ArmorHead');
         rLifeData.armorArm := aDB.GetFieldValueInteger (aMagicName, 'ArmorArm');
         rLifeData.armorLeg := aDB.GetFieldValueInteger (aMagicName, 'ArmorLeg');
         rLifeData.armorenergy := aDB.GetFieldValueInteger (aMagicName, 'ArmorEnergy');
      end;
   end;
   Result := TRUE;
end;

function  TMagicClass.LoadMagicDataForGuild (aMagicName: string; var MagicData: TMagicData; aDb: TUserStringDb): Boolean;
var
   n : Integer;
begin
   Result := FALSE;
   FillChar (MagicData, sizeof(MagicData), 0);
   if aDb.GetDbString (aMagicName) = '' then exit;
   with MagicData do begin
      StrPCopy (@rname, aMagicName);
      // rPercent := 10;

      rEnergyPoint := aDb.GetFieldValueinteger (aMagicName, 'EnergyPoint');

      StrToEffectData (rSoundEvent, aDb.GetFieldValueString (aMagicName, 'SoundEvent'));
      StrToEffectData (rSoundStrike, aDb.GetFieldValueString (aMagicName, 'SoundStrike'));
      StrToEffectData (rSoundSwing, aDb.GetFieldValueString (aMagicName, 'SoundSwing'));
      StrToEffectData (rSoundStart, aDb.GetFieldValueString (aMagicName, 'SoundStart'));
      StrToEffectData (rSoundEnd, aDb.GetFieldValueString (aMagicName, 'SoundEnd'));

      rBowImage := aDb.GetFieldValueinteger (aMagicName, 'BowImage');
      rBowSpeed := aDb.GetFieldValueinteger (aMagicName, 'BowSpeed');
      rBowType := aDb.GetFieldValueinteger (aMagicName, 'BowType');
      rShape := aDb.GetFieldValueinteger (aMagicName, 'Shape');

      rMagicType := aDb.GetFieldValueinteger (aMagicName, 'MagicType') mod 100;
      rMagicClass := aDb.GetFieldValueinteger (aMagicName, 'MagicType') div 100;
      rMagicRelation := aDB.GetFieldValueInteger (aMagicName, 'MagicRelation');

      case rMagicType of
         MAGICTYPE_WRESTLING : rShape := 4;
         MAGICTYPE_FENCING : rShape := 19;
         MAGICTYPE_SWORDSHIP : rShape := 35;
         MAGICTYPE_HAMMERING : rShape := 67;
         MAGICTYPE_SPEARING : rShape := 51;
         Else rShape := 1;
      end;
      
      rFunction := aDb.GetFieldValueinteger (aMagicName, 'Function');

      rEffectColor := aDB.GetFieldValueInteger (aMagicName, 'EffectColor');
      if rEffectColor = 0 then rEffectColor := 1;

      rSEffectNumber := aDB.GetFieldValueInteger (aMagicName, 'SEffectNumber');
      rEEffectNumber := aDB.GetFieldValueInteger (aMagicName, 'EEffectNumber');
      rMinRange := 0;
      rMaxRange := 0;
      rEffectDelay := 0;
      // 扁夯公傍
      if rMagicClass <> 1 then begin
         if aDb.GetFieldValueinteger (aMagicName, 'AttackSpeed') <> 0 then
            rLifeData.AttackSpeed := (120 - aDb.GetFieldValueinteger (aMagicName, 'AttackSpeed') ) * INI_MUL_ATTACKSPEED div INI_MAGIC_DIV_VALUE;
         if aDb.GetFieldValueinteger (aMagicName, 'Recovery') <> 0 then
            rLifeData.recovery := (120 - aDb.GetFieldValueinteger (aMagicName, 'Recovery') ) * INI_MUL_RECOVERY div INI_MAGIC_DIV_VALUE;
         if aDb.GetFieldValueinteger (aMagicName, 'Avoid') <> 0 then
            rLifeData.avoid := aDb.GetFieldValueinteger (aMagicName, 'Avoid') * INI_MUL_AVOID div INI_MAGIC_DIV_VALUE;
         if aDB.GetFieldValueInteger (aMagicName, 'Accuracy') <> 0 then
            rLifeData.Accuracy := aDB.GetFieldValueInteger (aMagicName, 'Accuracy') * INI_MUL_ACCURACY div INI_MAGIC_DIV_VALUE;
         if aDB.GetFieldValueInteger (aMagicName, 'KeepRecovery') <> 0 then
            rLifeData.KeepRecovery := aDB.GetFieldValueInteger (aMagicName, 'KeepRecovery') * INI_MUL_KEEPRECOVERY div INI_MAGIC_DIV_VALUE;

         if aDb.GetFieldValueinteger (aMagicName, 'DamageBody') <> 0 then
            rLifeData.damageBody := (aDb.GetFieldValueinteger (aMagicName, 'DamageBody')+INI_ADD_DAMAGE) * INI_MUL_DAMAGEBODY div INI_MAGIC_DIV_VALUE;

         if aDb.GetFieldValueinteger (aMagicName, 'DamageHead') <> 0 then
            rLifeData.damageHead := (aDb.GetFieldValueinteger (aMagicName, 'DamageHead')+INI_ADD_DAMAGE) * INI_MUL_DAMAGEHEAD div INI_MAGIC_DIV_VALUE;

         if aDb.GetFieldValueinteger (aMagicName, 'DamageArm') <> 0 then
            rLifeData.damageArm := (aDb.GetFieldValueinteger (aMagicName, 'DamageArm')+INI_ADD_DAMAGE) * INI_MUL_DAMAGEARM div INI_MAGIC_DIV_VALUE;

         if aDb.GetFieldValueinteger (aMagicName, 'DamageLeg') <> 0 then
            rLifeData.damageLeg := (aDb.GetFieldValueinteger (aMagicName, 'DamageLeg')+INI_ADD_DAMAGE) * INI_MUL_DAMAGELEG div INI_MAGIC_DIV_VALUE;

         rLifeData.armorBody := aDb.GetFieldValueinteger (aMagicName, 'ArmorBody') * INI_MUL_ARMORBODY div INI_MAGIC_DIV_VALUE;
         rLifeData.armorHead := aDb.GetFieldValueinteger (aMagicName, 'ArmorHead') * INI_MUL_ARMORHEAD div INI_MAGIC_DIV_VALUE;
         rLifeData.armorArm := aDb.GetFieldValueinteger (aMagicName, 'ArmorArm') * INI_MUL_ARMORARM div INI_MAGIC_DIV_VALUE;
         rLifeData.armorLeg := aDb.GetFieldValueinteger (aMagicName, 'ArmorLeg') * INI_MUL_ARMORLEG div INI_MAGIC_DIV_VALUE;

         rEventDecEnergy := aDb.GetFieldValueinteger (aMagicName, 'eEnergy') * INI_MUL_EVENTENERGY div INI_MAGIC_DIV_VALUE;
         rEventDecInPower:= aDb.GetFieldValueinteger (aMagicName, 'eInPower') * INI_MUL_EVENTINPOWER div INI_MAGIC_DIV_VALUE;
         rEventDecOutPower:= aDb.GetFieldValueinteger (aMagicName, 'eOutPower') * INI_MUL_EVENTOUTPOWER div INI_MAGIC_DIV_VALUE;
         rEventDecMagic := aDb.GetFieldValueinteger (aMagicName, 'eMagic') * INI_MUL_EVENTMAGIC div INI_MAGIC_DIV_VALUE;
         rEventDecLife := aDb.GetFieldValueinteger (aMagicName, 'eLife') * INI_MUL_EVENTLIFE div INI_MAGIC_DIV_VALUE;
         rEventDecDamageHead := aDb.GetFieldValueinteger (aMagicName, 'eDamageHead') * INI_MUL_EVENTDAMAGEHEAD div INI_MAGIC_DIV_VALUE;
         rEventDecDamageArm := aDb.GetFieldValueinteger (aMagicName, 'eDamageArm') * INI_MUL_EVENTDAMAGEARM div INI_MAGIC_DIV_VALUE;
         rEventDecDamageLeg := aDb.GetFieldValueinteger (aMagicName, 'eDamageLeg') * INI_MUL_EVENTDAMAGELEG div INI_MAGIC_DIV_VALUE;

         rEventBreathngEnergy := aDb.GetFieldValueinteger (aMagicName, 'eEnergy');
         rEventBreathngInPower:= aDb.GetFieldValueinteger (aMagicName, 'eInPower');
         rEventBreathngOutPower:= aDb.GetFieldValueinteger (aMagicName, 'eOutPower');
         rEventBreathngMagic := aDb.GetFieldValueinteger (aMagicName, 'eMagic');
         rEventBreathngLife := aDb.GetFieldValueinteger (aMagicName, 'eLife');
         rEventBreathngDamageHead := aDB.GetFieldValueInteger (aMagicName, 'eDamageHead');
         rEventBreathngDamageArm := aDB.GetFieldValueInteger (aMagicName, 'eDamageArm');
         rEventBreathngDamageLeg := aDB.GetFieldValueInteger (aMagicName, 'eDamageLeg');

         r5SecDecEnergy := aDb.GetFieldValueinteger (aMagicName, '5Energy') * INI_MUL_5SECENERGY div INI_MAGIC_DIV_VALUE;
         r5SecDecInPower:= aDb.GetFieldValueinteger (aMagicName, '5InPower') * INI_MUL_5SECINPOWER div INI_MAGIC_DIV_VALUE;
         r5SecDecOutPower:= aDb.GetFieldValueinteger (aMagicName, '5OutPower') * INI_MUL_5SECOUTPOWER div INI_MAGIC_DIV_VALUE;
         r5SecDecMagic := aDb.GetFieldValueinteger (aMagicName, '5Magic') * INI_MUL_5SECMAGIC div INI_MAGIC_DIV_VALUE;
         r5SecDecLife := aDb.GetFieldValueinteger (aMagicName, '5Life') * INI_MUL_5SECLIFE div INI_MAGIC_DIV_VALUE;
         r5SecDecDamageHead := aDb.GetFieldValueinteger (aMagicName, '5DamageHead') * INI_MUL_5SECDAMAGEHEAD div INI_MAGIC_DIV_VALUE;
         r5SecDecDamageArm := aDb.GetFieldValueinteger (aMagicName, '5DamageArm') * INI_MUL_5SECDAMAGEARM div INI_MAGIC_DIV_VALUE;
         r5SecDecDamageLeg := aDb.GetFieldValueinteger (aMagicName, '5DamageLeg') * INI_MUL_5SECDAMAGELEG div INI_MAGIC_DIV_VALUE;

         rKeepEnergy := aDb.GetFieldValueinteger (aMagicName, 'kEnergy') * 10;
         rKeepInPower:= aDb.GetFieldValueinteger (aMagicName, 'kInPower') * 10;
         rKeepOutPower:= aDb.GetFieldValueinteger (aMagicName, 'kOutPower') * 10;
         rKeepMagic := aDb.GetFieldValueinteger (aMagicName, 'kMagic') * 10;
         rKeepLife := aDb.GetFieldValueinteger (aMagicName, 'kLife') * 10;
         rKeepDamageHead := aDb.GetFieldValueinteger (aMagicName, 'kDamageHead') * 10;         
         rKeepDamageArm := aDb.GetFieldValueinteger (aMagicName, 'kDamageArm') * 10;
         rKeepDamageLeg := aDb.GetFieldValueinteger (aMagicName, 'kDamageLeg') * 10;
      end else begin  // 惑铰公傍
         if aDb.GetFieldValueinteger (aMagicName, 'AttackSpeed') <> 0 then
            rLifeData.AttackSpeed := (130 - aDb.GetFieldValueinteger (aMagicName, 'AttackSpeed') ) * INI_MUL_ATTACKSPEED2 div INI_MAGIC_DIV_VALUE2;
         if aDb.GetFieldValueinteger (aMagicName, 'Recovery') <> 0 then
            rLifeData.recovery := (130 - aDb.GetFieldValueinteger (aMagicName, 'Recovery') ) * INI_MUL_RECOVERY2 div INI_MAGIC_DIV_VALUE2;
         if aDb.GetFieldValueinteger (aMagicName, 'Avoid') <> 0 then
            rLifeData.avoid := aDb.GetFieldValueinteger (aMagicName, 'Avoid') * INI_MUL_AVOID2 div INI_MAGIC_DIV_VALUE2;

         // 公傍.SDB 俊 汲沥等 沥犬档客 磊技蜡瘤狼 蔼阑 角力 荤侩登绰 蔼栏肺 函券窍绰 镑
         if aDb.GetFieldValueinteger (aMagicName, 'KeepRecovery') <> 0 then begin
            n := aDb.GetFieldValueinteger (aMagicName, 'KeepRecovery');
            rLifeData.keeprecovery := (n * n div 22 + 70);  // 瘤陛
         end;
         if aDb.GetFieldValueinteger (aMagicName, 'Accuracy') <> 0 then begin
            n := aDb.GetFieldValueinteger (aMagicName, 'accuracy');
            // 沥犬档函版矫
            rLifeData.accuracy := n * 6 div 10;
         end;

         // 汲沥蔼俊 蝶扼辑 公傍汲沥摹甫 牢沥窍绰镑
         if aDb.GetFieldValueinteger (aMagicName, 'DamageBody') <> 0 then
            rLifeData.damageBody := (aDb.GetFieldValueinteger (aMagicName, 'DamageBody')+INI_ADD_DAMAGE2) * INI_MUL_DAMAGEBODY2 div INI_MAGIC_DIV_VALUE2;

         if aDb.GetFieldValueinteger (aMagicName, 'DamageHead') <> 0 then
            rLifeData.damageHead := (aDb.GetFieldValueinteger (aMagicName, 'DamageHead')+INI_ADD_DAMAGE2) * INI_MUL_DAMAGEHEAD2 div INI_MAGIC_DIV_VALUE2;

         if aDb.GetFieldValueinteger (aMagicName, 'DamageArm') <> 0 then
            rLifeData.damageArm := (aDb.GetFieldValueinteger (aMagicName, 'DamageArm')+INI_ADD_DAMAGE2) * INI_MUL_DAMAGEARM2 div INI_MAGIC_DIV_VALUE2;

         if aDb.GetFieldValueinteger (aMagicName, 'DamageLeg') <> 0 then
            rLifeData.damageLeg := (aDb.GetFieldValueinteger (aMagicName, 'DamageLeg')+INI_ADD_DAMAGE2) * INI_MUL_DAMAGELEG2 div INI_MAGIC_DIV_VALUE2;

         rLifeData.armorBody := aDb.GetFieldValueinteger (aMagicName, 'ArmorBody') * INI_MUL_ARMORBODY2 div INI_MAGIC_DIV_VALUE2;
         rLifeData.armorHead := aDb.GetFieldValueinteger (aMagicName, 'ArmorHead') * INI_MUL_ARMORHEAD2 div INI_MAGIC_DIV_VALUE2;
         rLifeData.armorArm := aDb.GetFieldValueinteger (aMagicName, 'ArmorArm') * INI_MUL_ARMORARM2 div INI_MAGIC_DIV_VALUE2;
         rLifeData.armorLeg := aDb.GetFieldValueinteger (aMagicName, 'ArmorLeg') * INI_MUL_ARMORLEG2 div INI_MAGIC_DIV_VALUE2;

         rEventDecEnergy := aDb.GetFieldValueinteger (aMagicName, 'eEnergy') * INI_MUL_EVENTENERGY2 div INI_MAGIC_DIV_VALUE2;
         rEventDecInPower:= aDb.GetFieldValueinteger (aMagicName, 'eInPower') * INI_MUL_EVENTINPOWER2 div INI_MAGIC_DIV_VALUE2;
         rEventDecOutPower:= aDb.GetFieldValueinteger (aMagicName, 'eOutPower') * INI_MUL_EVENTOUTPOWER2 div INI_MAGIC_DIV_VALUE2;
         rEventDecMagic := aDb.GetFieldValueinteger (aMagicName, 'eMagic') * INI_MUL_EVENTMAGIC2 div INI_MAGIC_DIV_VALUE2;
         rEventDecLife := aDb.GetFieldValueinteger (aMagicName, 'eLife') * INI_MUL_EVENTLIFE2 div INI_MAGIC_DIV_VALUE2;
         rEventDecDamageHead := aDb.GetFieldValueinteger (aMagicName, 'eDamageHead') * INI_MUL_EVENTDAMAGEHEAD2 div INI_MAGIC_DIV_VALUE2;
         rEventDecDamageArm := aDb.GetFieldValueinteger (aMagicName, 'eDamageArm') * INI_MUL_EVENTDAMAGEARM2 div INI_MAGIC_DIV_VALUE2;
         rEventDecDamageLeg := aDb.GetFieldValueinteger (aMagicName, 'eDamageLeg') * INI_MUL_EVENTDAMAGELEG2 div INI_MAGIC_DIV_VALUE2;

         rEventBreathngEnergy := aDb.GetFieldValueinteger (aMagicName, 'eEnergy');
         rEventBreathngInPower:= aDb.GetFieldValueinteger (aMagicName, 'eInPower');
         rEventBreathngOutPower:= aDb.GetFieldValueinteger (aMagicName, 'eOutPower');
         rEventBreathngMagic := aDb.GetFieldValueinteger (aMagicName, 'eMagic');
         rEventBreathngLife := aDb.GetFieldValueinteger (aMagicName, 'eLife');
         rEventBreathngDamageHead := aDB.GetFieldValueInteger (aMagicName, 'eDamageHead');
         rEventBreathngDamageArm := aDB.GetFieldValueInteger (aMagicName, 'eDamageArm');
         rEventBreathngDamageLeg := aDB.GetFieldValueInteger (aMagicName, 'eDamageLeg');

         r5SecDecEnergy := aDb.GetFieldValueinteger (aMagicName, '5Energy') * INI_MUL_5SECENERGY2 div INI_MAGIC_DIV_VALUE2;
         r5SecDecInPower:= aDb.GetFieldValueinteger (aMagicName, '5InPower') * INI_MUL_5SECINPOWER2 div INI_MAGIC_DIV_VALUE2;
         r5SecDecOutPower:= aDb.GetFieldValueinteger (aMagicName, '5OutPower') * INI_MUL_5SECOUTPOWER2 div INI_MAGIC_DIV_VALUE2;
         r5SecDecMagic := aDb.GetFieldValueinteger (aMagicName, '5Magic') * INI_MUL_5SECMAGIC2 div INI_MAGIC_DIV_VALUE2;
         r5SecDecLife := aDb.GetFieldValueinteger (aMagicName, '5Life') * INI_MUL_5SECLIFE2 div INI_MAGIC_DIV_VALUE2;
         r5SecDecDamageHead := aDb.GetFieldValueinteger (aMagicName, '5DamageHead') * INI_MUL_5SECDAMAGEHEAD2 div INI_MAGIC_DIV_VALUE2;
         r5SecDecDamageArm := aDb.GetFieldValueinteger (aMagicName, '5DamageArm') * INI_MUL_5SECDAMAGEARM2 div INI_MAGIC_DIV_VALUE2;
         r5SecDecDamageLeg := aDb.GetFieldValueinteger (aMagicName, '5DamageLeg') * INI_MUL_5SECDAMAGELEG2 div INI_MAGIC_DIV_VALUE2;

         rKeepEnergy := aDb.GetFieldValueinteger (aMagicName, 'kEnergy') * 10;
         rKeepInPower:= aDb.GetFieldValueinteger (aMagicName, 'kInPower') * 10;
         rKeepOutPower:= aDb.GetFieldValueinteger (aMagicName, 'kOutPower') * 10;
         rKeepMagic := aDb.GetFieldValueinteger (aMagicName, 'kMagic') * 10;
         rKeepLife := aDb.GetFieldValueinteger (aMagicName, 'kLife') * 10;
         rKeepDamageHead := aDb.GetFieldValueinteger (aMagicName, 'kDamageHead') * 10;         
         rKeepDamageArm := aDb.GetFieldValueinteger (aMagicName, 'kDamageArm') * 10;
         rKeepDamageLeg := aDb.GetFieldValueinteger (aMagicName, 'kDamageLeg') * 10;
      end;
   end;
   Result := TRUE;
end;

function TMagicClass.GetHaveMagicData (astr: string; var MagicData: TMagicData): Boolean;
var
   str, rdstr, amagicname: string;
   sexp :integer;
begin
   Result := FALSE;
   str := astr;
   str := GetValidStr3 (str, amagicname, ':');
   str := GetValidStr3 (str, rdstr, ':');
   sexp := _StrToInt (rdstr);
   if GetMagicData (amagicname, MagicData, sexp) = FALSE then exit;
   Result := TRUE;
end;

function TMagicClass.GetHaveBestMagicData (astr: string; var MagicData: TMagicData): Boolean;
var
   str, rdstr, amagicname: string;
   sexp : integer;
   agrade : byte;
   i,n : integer;
begin
   Result := false;
   str := astr;
   str := GetValidStr3 (str, amagicname, ':');
   str := GetValidStr3 (str, rdstr, ':');
   sexp := _StrToInt (rdstr);

   if GetMagicData (amagicname, MagicData, sexp) = FALSE then exit;

   str := GetValidStr3 (str, rdstr, ':');
   MagicData.rGrade := _StrToInt (rdstr);

   with MagicData.rStatus do begin
      str := GetValidStr3 (str, rdstr, ':');
      rDamageBody := _StrToInt (rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      rDamageHead := _StrToInt (rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      rDamageArm := _StrToInt (rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      rDamageLeg := _StrToInt (rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      rDamageEnergy := _StrToInt (rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      rArmorBody := _StrToInt (rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      rArmorHead := _StrToInt (rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      rArmorArm := _StrToInt (rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      rArmorLeg := _StrToInt (rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      rArmorEnergy := _StrToInt (rdstr);
   end;

   MagicCycleClass.GetData(amagicname, MagicData.rGrade, MagicData);
   Result := TRUE;
end;

function TMagicClass.GetHaveMagicString (var MagicData: TMagicData): string;
begin
   Result := StrPas (@MagicData.rName) + ':' + IntToStr(MagicData.rSkillExp)+':';
end;

function TMagicClass.GetHaveBestMagicString (var MagicData: TMagicData): string;
begin
   Result := StrPas (@MagicData.rName) + ':'
      + IntToStr(MagicData.rSkillExp)+':'
      + IntToStr(MagicData.rGrade) + ':'
      + IntToStr(MagicData.rStatus.rDamageBody) + ':'
      + IntToStr(MagicData.rStatus.rDamageHead) + ':'
      + IntToStr(MagicData.rStatus.rDamageArm) + ':'
      + IntToStr(MagicData.rStatus.rDamageLeg) + ':'
      + IntToStr(MagicData.rStatus.rDamageEnergy) + ':'
      + IntToStr(MagicData.rStatus.rArmorBody) + ':'
      + IntToStr(MagicData.rStatus.rArmorHead) + ':'
      + IntToStr(MagicData.rStatus.rArmorArm) + ':'
      + IntToStr(MagicData.rStatus.rArmorLeg) + ':'
      + IntToStr(MagicData.rStatus.rArmorEnergy) + ':';
end;


///////////////////////////////////
//         TItemClass
///////////////////////////////////
constructor TItemClass.Create;
var
   i : Integer;
begin
   FAddValue := 0;
   
   FDataList := TList.Create;
   FKeyClass := TStringKeyClass.Create;
   FSmeltList := TList.Create;
   FSmeltList2 := TList.Create;

   for i := 0 to ADDATTRIBTABLE_SIZE - 1 do begin
      AddAttribList[i] := TList.Create;
   end;

   ReLoadFromFile;
end;

destructor  TItemClass.Destroy;
var
   i : Integer;
begin
   Clear;

   for i := 0 to ADDATTRIBTABLE_SIZE - 1 do begin
      AddAttribList[i].Free;
   end;

   FKeyClass.Free;
   FDataList.Free;
   FSmeltList.Free;
   FSmeltList2.Free;

   inherited Destroy;
end;

procedure TItemClass.Clear;
var
   i   : integer;
   pid : PTItemData;
   psd : PTSmeltItemData;
   pa  : PTAddAttribData;
begin
   for i := 0 to ADDATTRIBTABLE_SIZE - 1 do begin
      while AddAttribList[i].Count > 0 do begin
         pa := AddAttribList[i].Items[0];
         dispose (pa);
         AddAttribList[i].Delete(0);
      end;
   end;

   for i := 0 to FDataList.Count - 1 do begin
      pid := FDataList.Items [i];
      Dispose (pid);
   end;
   FDataList.Clear;
   FKeyClass.Clear;
   for i := 0 to FSmeltList.Count - 1 do begin
      psd := FSmeltList.Items [i];
      Dispose (psd);
   end;
   FSmeltList.Clear;
   for i := 0 to FSmeltList2.Count - 1 do begin
      psd := FSmeltList2.Items [i];
      Dispose (psd);
   end;
   FSmeltList2.Clear;
end;

procedure TItemClass.ReLoadFromFile;
var
   i, j, iCount : Integer;
   aFileName, iName, str, rdstr, ItemName, ItemCount, Desc : String;
   pid : PTItemData;
   psd : PTSmeltItemData;
   pa : PTAddAttribData;
   DB : TUserStringDB;
   aChar, bChar : Char;
begin
   Clear;

   if FileExists ('.\Init\Item.SDB') then begin
      DB := TUserStringDB.Create;
      DB.LoadFromFile ('.\Init\Item.SDB');

      for i := 0 to Db.Count - 1 do begin
         iName := DB.GetIndexName (i);
         if iName = '' then continue;

         New (pid);
         FillChar (pid^, sizeof (TItemData), 0);

         StrPCopy (@pid^.rName, iName);

         Str := DB.GetFieldValueString (iName, 'ViewName');
         StrPCopy (@pid^.rViewName, Str);

         pid^.rScript := DB.GetFieldValueInteger (iName, 'Script');
         pid^.rMaxCount := DB.GetFieldValueInteger (iName, 'MaxCount'); 

         StrToEffectData (pid^.rSoundEvent, DB.GetFieldValueString (iName, 'SoundEvent'));
         StrToEffectData (pid^.rSoundDrop, DB.GetFieldValueString (iName, 'SoundDrop'));

         pid^.rLifeData.DamageBody := DB.GetFieldValueinteger (iName, 'DamageBody');
         pid^.rLifeData.DamageHead := DB.GetFieldValueinteger (iName, 'DamageHead');
         pid^.rLifeData.DamageArm := DB.GetFieldValueinteger (iName, 'DamageArm');
         pid^.rLifeData.DamageLeg := DB.GetFieldValueinteger (iName, 'DamageLeg');

         pid^.rLifeData.ArmorBody := DB.GetFieldValueinteger (iName, 'ArmorBody');
         pid^.rLifeData.ArmorHead := DB.GetFieldValueinteger (iName, 'ArmorHead');
         pid^.rLifeData.ArmorArm := DB.GetFieldValueinteger (iName, 'ArmorArm');
         pid^.rLifeData.ArmorLeg := DB.GetFieldValueinteger (iName, 'ArmorLeg');

         pid^.rLifeData.AttackSpeed := 0 - DB.GetFieldValueinteger (iName, 'AttackSpeed');
         pid^.rLifeData.Recovery := 0 - DB.GetFieldValueinteger (iName, 'Recovery');
         pid^.rLifeData.Avoid := DB.GetFieldValueinteger (iName, 'Avoid');
         pid^.rLifeData.Accuracy := DB.GetFieldValueInteger (iName, 'Accuracy');
         pid^.rLifeData.KeepRecovery := DB.GetFieldValueInteger (iName, 'KeepRecovery');

         pid^.rAddAttribData.rBowAvoid.rValue := DB.GetFieldValueInteger (iName, 'LongAvoid');
         pid^.rAddAttribData.rBowAvoid.rLimit := 0;
         pid^.rAddAttribData.rBowAccuracy.rValue := DB.GetFieldValueInteger (iName, 'LongAccuracy');
         pid^.rAddAttribData.rBowAccuracy.rLimit := 0;

         pid^.rDurability := DB.GetFieldValueinteger (iName, 'Durability');
         pid^.rCurDurability := pid^.rDurability;
         //2002-08-01 giltae
         pid^.rDecDelay := DB.GetFieldValueinteger (iName, 'DecDelay');
         pid^.rDecSize := DB.GetFieldValueinteger (iName, 'DecSize');
         pid^.rDecTick := 0;
         //------------
         //2002-08-03 giltae
         pid^.rboNotTrade := DB.GetFieldValueBoolean (iName, 'boNotTrade');
         pid^.rboNotExchange := DB.GetFieldValueBoolean (iName, 'boNotExchange');
         pid^.rboNotDrop := DB.GetFieldValueBoolean (iName, 'boNotDrop');
         pid^.rboNotSsamzie := DB.GetFieldValueBoolean (iName, 'boNotSSamzie');
         pid^.rboNotSkill := DB.GetFieldValueBoolean (iName, 'boNotSkill');

         // add by Orber at 2004-09-16 11:58
         pid^.rboNotSave := DB.GetFieldValueBoolean (iName, 'boNotSave');

         pid^.cLife := DB.GetFieldValueInteger (iName, 'cLife');

         pid^.rSpecialKind := DB.GetFieldValueInteger (iName, 'SpecialKind');
         pid^.rRoleType := DB.GetFieldValueInteger (iName, 'RoleType');
         pid^.rAbrasion := DB.GetFieldValueInteger (iName, 'Abrasion');

         pid^.rWearArr := DB.GetFieldValueinteger (iName, 'WearPos');
         pid^.rWearShape := DB.GetFieldValueinteger (iName, 'WearShape');
         pid^.rShape := DB.GetFieldValueinteger (iName, 'Shape');
         pid^.rActionImage := DB.GetFieldValueInteger (iName, 'ActionImage');
         pid^.rHitMotion := DB.GetFieldValueinteger (iName, 'HitMotion');
         pid^.rHitType := DB.GetFieldValueinteger (iName, 'HitType');
         pid^.rKind := DB.GetFieldValueinteger (iName, 'Kind');
         pid^.rColor := DB.GetFieldValueinteger (iName, 'Color');
         pid^.rBoDouble := DB.GetFieldValueBoolean (iName, 'boDouble');
         pid^.rBoColoring := DB.GetFieldValueBoolean (iName, 'boColoring');
         pid^.rPrice := DB.GetFieldValueInteger (iName, 'Price');
         pid^.rBuyPrice := DB.GetFieldValueInteger (iName, 'BuyPrice');
         if pid^.rBuyPrice = 0 then pid^.rBuyPrice := pid^.rPrice;

         pid^.rRepairPrice := DB.GetFieldValueInteger (iName, 'RepairPrice');

         pid^.rNeedGrade := DB.GetFieldValueInteger (iName, 'NeedGrade');
         pid^.rSex := DB.GetFieldValueInteger (iName, 'Sex');
         pid^.rNameParam[0] := DB.GetFieldValueString (iName, 'NameParam1');
         pid^.rNameParam[1] := DB.GetFieldValueString (iName, 'NameParam2');

         pid^.rServerId := DB.GetFieldValueInteger (iName, 'ServerId');
         pid^.rx := DB.GetFieldValueInteger (iName, 'X');
         pid^.ry := DB.GetFieldValueInteger (iName, 'Y');
         pid^.rAttribute := DB.GetFieldValueInteger (iName, 'Attribute');
         pid^.rGrade := DB.GetFieldValueInteger (iName, 'Grade');
         pid^.rQuestNum := DB.GetFieldValueInteger (iName, 'QuestNum'); //2003-10         

         pid^.rMaxUpgrade := DB.GetFieldValueInteger (iName, 'MaxUpgrade');
         pid^.rUpgrade := 0;
         pid^.rJobKind := DB.GetFieldValueInteger (iName, 'JobKind');
         pid^.rboTalentExp := DB.GetFieldValueBoolean (iName, 'boTalentExp');
         
         Str := DB.GetFieldValueString (iName, 'Material');
         if Str <> '' then begin
            case pid^.rJobKind of
               JOB_KIND_NONE : begin
                  ItemmaterialClass.AllMakeItem (iName, Str);
               end;
               JOB_KIND_ALCHEMIST..JOB_KIND_CRAFTSMAN : begin
                  ItemMaterialClass.PushStr (pid^.rJobKind, iName, Str);
               end;
            end;
         end;

         for j := 0 to 4 - 1 do begin
            if Str = '' then break;
            Str := GetValidStr3 (Str, ItemName, ':');
            if ItemName = '' then break;
            Str := GetValidStr3 (Str, ItemCount, ':');
            if ItemCount = '' then break;
            iCount := _StrToInt (ItemCount);
            if iCount <= 0 then break;

            StrPCopy (@pid^.rMaterial [j].rName, ItemName);
            pid^.rMaterial [j].rCount := iCount;
         end;

         pid^.rToolConst := Db.GetFieldValueInteger (iName, 'ToolConst');
         pid^.rboDurability := Db.GetFieldValueBoolean (iName, 'boDurability');
         pid^.rboUpgrade := Db.GetFieldValueBoolean (iName, 'boUpgrade');
         pid^.rSuccessRate := Db.GetFieldValueInteger (iName, 'SuccessRate');
         StrPCopy (@pid^.rDesc, Db.GetFieldValueString (iName, 'Desc'));
         pid^.rboPower := Db.GetFieldValueBoolean (iName, 'boPower');

         //2002-07-22 giltae Item.sdb俊 眠啊等 鞘靛肺靛
         Str := Db.GetFieldValueString( iName,'NeedItem');
         for j := 0 to 4 - 1 do begin
            if Str = '' then break;
            Str := GetValidStr3 (Str, ItemName, ':');
            if ItemName = '' then break;
            Str := GetValidStr3 (Str, ItemCount, ':');
            if ItemCount = '' then break;
            iCount := _StrToInt (ItemCount);
            if iCount <= 0 then break;

            StrPCopy (@pid^.rNeedItem [j].rName, ItemName);
            pid^.rNeedItem [j].rCount := iCount;
         end;

         Str := Db.GetFieldValueString( iName,'NotHaveItem');
         for j := 0 to 4 - 1 do begin
            if Str = '' then break;
            Str := GetValidStr3 (Str, ItemName, ':');
            if ItemName = '' then break;
            Str := GetValidStr3 (Str, ItemCount, ':');
            if ItemCount = '' then break;
            iCount := _StrToInt (ItemCount);
            if iCount <= 0 then break;

            StrPCopy (@pid^.rNotHaveItem [j].rName, ItemName);
            pid^.rNotHaveItem [j].rCount := iCount;
         end;

         Str := Db.GetFieldValueString( iName,'DelItem');
         for j := 0 to 4 - 1 do begin
            if Str = '' then break;
            Str := GetValidStr3 (Str, ItemName, ':');
            if ItemName = '' then break;
            Str := GetValidStr3 (Str, ItemCount, ':');
            if ItemCount = '' then break;
            iCount := _StrToInt (ItemCount);
            if iCount <= 0 then break;

            StrPCopy (@pid^.rDelItem [j].rName, ItemName);
            pid^.rDelItem [j].rCount := iCount;
         end;

         Str := Db.GetFieldValueString( iName,'AddItem');
         for j := 0 to 4 - 1 do begin
            if Str = '' then break;
            Str := GetValidStr3 (Str, ItemName, ':');
            if ItemName = '' then break;
            Str := GetValidStr3 (Str, ItemCount, ':');
            if ItemCount = '' then break;
            iCount := _StrToInt (ItemCount);
            if iCount <= 0 then break;

            StrPCopy (@pid^.rAddItem [j].rName, ItemName);
            pid^.rAddItem [j].rCount := iCount;
         end;

         //------------------2002-07-22 gil-tae

         pid^.rCount := 1;

         pid^.rExtJobExp := Db.GetFieldValueInteger(iName, 'ExtJobExp');

         FDataList.Add (pid);
         FKeyClass.Insert (iName, pid);
      end;
      DB.Free;
   end;

   if FileExists ('.\Init\SmeltItem.SDB') then begin
      DB := TUserStringDB.Create;
      DB.LoadFromFile ('.\Init\SmeltItem.SDB');

      for i := 0 to Db.Count - 1 do begin
         iName := DB.GetIndexName (i);
         if iName = '' then continue;

         New (psd);
         FillChar (psd^, SizeOf (TSmeltItemData), 0);
         StrPCopy (@psd^.rName, iName);
         Str := DB.GetFieldValueString (iName, 'NeedItem');
         Str := GetValidStr3 (Str, ItemName, ':');
         Str := GetValidStr3 (Str, ItemCount, ':');
         iCount := _StrToInt (ItemCount);

         if (ItemName <> '') and (iCount > 0) then begin
            StrPCopy (@psd^.rNeedItem, ItemName);
            psd^.rNeedCount := iCount;
         end;

         psd^.rPrice := DB.GetFieldValueInteger (iName, 'Price');
         
         FSmeltList.Add (psd);
      end;
      DB.Free;
   end;

   if FileExists ('.\Init\SmeltItem2.SDB') then begin
      DB := TUserStringDB.Create;
      DB.LoadFromFile ('.\Init\SmeltItem2.SDB');

      for i := 0 to Db.Count - 1 do begin
         iName := DB.GetIndexName (i);
         if iName = '' then continue;

         New (psd);
         FillChar (psd^, SizeOf (TSmeltItemData), 0);
         StrPCopy (@psd^.rName, iName);
         Str := DB.GetFieldValueString (iName, 'NeedItem');
         Str := GetValidStr3 (Str, ItemName, ':');
         Str := GetValidStr3 (Str, ItemCount, ':');
         iCount := _StrToInt (ItemCount);

         if (ItemName <> '') and (iCount > 0) then begin
            StrPCopy (@psd^.rNeedItem, ItemName);
            psd^.rNeedCount := iCount;
         end;

         psd^.rPrice := DB.GetFieldValueInteger (iName, 'Price');

         FSmeltList2.Add (psd);
      end;
      DB.Free;
   end;

   iCount := 0;
   for aChar := 'A' to 'E' do begin
      for bChar := '1' to '4' do begin
         aFileName := '.\AdditionalAttrib\' + aChar + bChar + '.SDB';
         if FileExists(aFileName) then begin
            DB := TUserStringDB.Create;
            DB.LoadFromFile (aFileName);

            for i := 0 to DB.Count - 1 do begin
               iName := DB.GetIndexName (i);
               if iName = '' then continue;
               New (pa);
               FillChar (pa^, sizeof(TAddAttribData), 0);

               str := Db.GetFieldValueString (iName, 'BowAttackSpeed');
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rBowAttSpd.rValue := 0 - _StrToInt (rdstr);
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rBowAttSpd.rLimit := _StrToInt (rdstr);

               str := Db.GetFieldValueString (iName, 'BowAccuracy');
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rBowAccuracy.rValue := _StrToInt (rdstr);
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rBowAccuracy.rLimit := _StrToInt (rdstr);

               str := Db.GetFieldValueString (iName, 'BowKeepRecovery');
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rBowKeepRecovery.rValue := _StrToInt (rdstr);
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rBowKeepRecovery.rLimit := _StrToInt (rdstr);

               str := Db.GetFieldValueString (iName, 'BowAvoid');
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rBowAvoid.rValue := _StrToInt (rdstr);
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rBowAvoid.rLimit := _StrToInt (rdstr);

               str := Db.GetFieldValueString (iName, 'BowBodyArmor');
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rBowBodyArmor.rValue := _StrToInt (rdstr);
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rBowBodyArmor.rLimit := _StrToInt (rdstr);

               str := Db.GetFieldValueString (iName, 'BowHeadArmor');
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rBowHeadArmor.rValue := _StrToInt (rdstr);
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rBowHeadArmor.rLimit := _StrToInt (rdstr);

               str := Db.GetFieldValueString (iName, 'BowArmArmor');
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rBowArmArmor.rValue := _StrToInt (rdstr);
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rBowArmArmor.rLimit := _StrToInt (rdstr);

               str := Db.GetFieldValueString (iName, 'BowLegArmor');
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rBowLegArmor.rValue := _StrToInt (rdstr);
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rBowLegArmor.rLimit := _StrToInt (rdstr);

               str := Db.GetFieldValueString (iName, 'HandSpeed');
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rHandSpd.rValue := 0 - _StrToInt (rdstr);
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rHandSpd.rLimit := _StrToInt (rdstr);

               str := Db.GetFieldValueString (iName, 'HandAccuracy');
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rHandAccuracy.rValue := _StrToInt (rdstr);
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rHandAccuracy.rLimit := _StrToInt (rdstr);
               
               str := Db.GetFieldValueString (iName, 'HandKeepRecovery');
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rHandKeepRecovery.rValue := _StrToInt (rdstr);
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rHandKeepRecovery.rLimit := _StrToInt (rdstr);

               str := Db.GetFieldValueString (iName, 'HandMinValue');
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rHandMinValue.rValue := _StrToInt (rdstr);
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rHandMinValue.rLimit := _StrToInt (rdstr);

               str := Db.GetFieldValueString (iName, 'HandMaxValue');
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rHandMaxValue.rValue := _StrToInt (rdstr);
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rHandMaxValue.rLimit := _StrToInt (rdstr);

               str := Db.GetFieldValueString (iName, 'HandBodyArmor');
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rHandBodyArmor.rValue := _StrToInt (rdstr);
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rHandBodyArmor.rLimit := _StrToInt (rdstr);

               str := Db.GetFieldValueString (iName, 'ApproachSpeed');
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rApproachSpd.rValue := 0 - _StrToInt (rdstr);
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rApproachSpd.rLimit := _StrToInt (rdstr);

               str := Db.GetFieldValueString (iName, 'ApproachAccuracy');
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rApproachAccuracy.rValue := _StrToInt (rdstr);
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rApproachAccuracy.rLimit := _StrToInt (rdstr);

               str := Db.GetFieldValueString (iName, 'ApproachAvoid');
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rApproachAvoid.rValue := _StrToInt (rdstr);
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rApproachAvoid.rLimit := _StrToInt (rdstr);

               str := Db.GetFieldValueString (iName, 'ApproachKeepRecovery');
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rApproachKeepRecovery.rValue := _StrToInt (rdstr);
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rApproachKeepRecovery.rLimit := _StrToInt (rdstr);

               str := Db.GetFieldValueString (iName, 'ApproachBodyArmor');
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rApproachBodyArmor.rValue := _StrToInt (rdstr);
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rApproachBodyArmor.rLimit := _StrToInt (rdstr);

               str := Db.GetFieldValueString (iName, 'ApproachHeadArmor');
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rApproachHeadArmor.rValue := _StrToInt (rdstr);
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rApproachHeadArmor.rLimit := _StrToInt (rdstr);

               str := Db.GetFieldValueString (iName, 'ApproachLegArmor');
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rApproachLegArmor.rValue := _StrToInt (rdstr);
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rApproachLegArmor.rLimit := _StrToInt (rdstr);

               str := Db.GetFieldValueString (iName, 'ApproachArmArmor');
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rApproachArmArmor.rValue := _StrToInt (rdstr);
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rApproachArmArmor.rLimit := _StrToInt (rdstr);

               str := Db.GetFieldValueString (iName, 'AddBodyDamage');
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rAddBodyDamage.rValue := _StrToInt (rdstr);
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rAddBodyDamage.rLimit := _StrToInt (rdstr);

               str := Db.GetFieldValueString (iName, 'AddHeadDamage');
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rAddHeadDamage.rValue := _StrToInt (rdstr);
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rAddHeadDamage.rLimit := _StrToInt (rdstr);

               str := Db.GetFieldValueString (iName, 'AddArmDamage');
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rAddArmDamage.rValue := _StrToInt (rdstr);
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rAddArmDamage.rLimit := _StrToInt (rdstr);

               str := Db.GetFieldValueString (iName, 'AddLegDamage');
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rAddLegDamage.rValue := _StrToInt (rdstr);
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rAddLegDamage.rLimit := _StrToInt (rdstr);

               str := Db.GetFieldValueString (iName, 'EnergyRegenDec');
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rEnergyRegenDec.rValue := _StrToInt (rdstr);
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rEnergyRegenDec.rLimit := _StrToInt (rdstr);

               str := Db.GetFieldValueString (iName, 'BasicValueDec');
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rBasicValueDec.rValue := _StrToInt (rdstr);
               str := GetValidStr3 (str, rdstr, ':');
               pa^.rBasicValueDec.rLimit := _StrToInt (rdstr);

               AddAttribList[iCount].Add(pa);

            end;
            DB.Free;
         end;
         inc (iCount);
      end;
   end;
end;

{
function  TItemClass.LoadItemData (aItemName: string; var ItemData: TItemData): Boolean;
var
   i, iCount : Integer;
   Str, iName, dest : String;
begin
   Result := FALSE;
   FillChar (ItemData, sizeof(ItemData), 0);
   if ItemDb.GetDbString (aItemName) = '' then exit;

   StrPCopy (@ItemData.rname, aItemName);

   Str := ItemDB.GetFieldValueString (aItemName, 'ViewName');
   StrPCopy (@ItemData.rViewName, Str);

   StrToEffectData (ItemData.rSoundEvent, ItemDb.GetFieldValueString (aItemName, 'SoundEvent'));
   StrToEffectData (ItemData.rSoundDrop, ItemDb.GetFieldValueString (aItemName, 'SoundDrop'));

   Itemdata.rLifeData.DamageBody := ItemDb.GetFieldValueinteger (aItemName, 'DamageBody');
   Itemdata.rLifeData.DamageHead := ItemDb.GetFieldValueinteger (aItemName, 'DamageHead');
   Itemdata.rLifeData.DamageArm := ItemDb.GetFieldValueinteger (aItemName, 'DamageArm');
   Itemdata.rLifeData.DamageLeg := ItemDb.GetFieldValueinteger (aItemName, 'DamageLeg');

   Itemdata.rLifeData.ArmorBody := ItemDb.GetFieldValueinteger (aItemName, 'ArmorBody');
   Itemdata.rLifeData.ArmorHead := ItemDb.GetFieldValueinteger (aItemName, 'ArmorHead');
   Itemdata.rLifeData.ArmorArm := ItemDb.GetFieldValueinteger (aItemName, 'ArmorArm');
   Itemdata.rLifeData.ArmorLeg := ItemDb.GetFieldValueinteger (aItemName, 'ArmorLeg');

   Itemdata.rLifeData.AttackSpeed := 0 - ItemDb.GetFieldValueinteger (aItemName, 'AttackSpeed');
   Itemdata.rLifeData.Recovery := 0 - ItemDb.GetFieldValueinteger (aItemName, 'Recovery');
   Itemdata.rLifeData.Avoid := ItemDb.GetFieldValueinteger (aItemName, 'Avoid');
   ItemData.rLifeData.Accuracy := ItemDb.GetFieldValueInteger (aItemName, 'Accuracy');
   ItemData.rLifeData.KeepRecovery := ItemDb.GetFieldValueInteger (aItemName, 'KeepRecovery');
   
   Itemdata.rDurability := ItemDb.GetFieldValueinteger (aItemName, 'Durability');
   Itemdata.rCurDurability := Itemdata.rDurability;
   ItemData.rAbrasion := ItemDb.GetFieldValueInteger (aItemName, 'Abrasion');
   
   ItemData.rWearArr := ItemDb.GetFieldValueinteger (aItemName, 'WearPos');
   ItemData.rWearShape := ItemDb.GetFieldValueinteger (aItemName, 'WearShape');
   ItemData.rShape := ItemDb.GetFieldValueinteger (aItemName, 'Shape');
   ItemData.rActionImage := ItemDb.GetFieldValueInteger (aItemName, 'ActionImage');
   ItemData.rHitMotion := ItemDb.GetFieldValueinteger (aItemName, 'HitMotion');
   ItemData.rHitType := ItemDb.GetFieldValueinteger (aItemName, 'HitType');
   ItemData.rKind := ItemDb.GetFieldValueinteger (aItemName, 'Kind');
   ItemData.rColor := ItemDb.GetFieldValueinteger (aItemName, 'Color');
   ItemData.rBoDouble := ItemDb.GetFieldValueBoolean (aItemName, 'boDouble');
   ItemData.rBoColoring := ItemDb.GetFieldValueBoolean (aItemName, 'boColoring');
   ItemData.rPrice := ItemDb.GetFieldValueInteger (aItemName, 'Price');
   ItemData.rBuyPrice := ItemDb.GetFieldValueInteger (aItemName, 'BuyPrice');
   if ItemData.rBuyPrice = 0 then ItemData.rBuyPrice := ItemData.rPrice;
   ItemData.rRepairPrice := ItemDb.GetFieldValueInteger (aItemName, 'RepairPrice');

   ItemData.rNeedGrade := ItemDb.GetFieldValueInteger (aItemName, 'NeedGrade');
   ItemData.rSex := ItemDb.GetFieldValueInteger (aItemName, 'Sex');
   ItemData.rNameParam[0] := ItemDb.GetFieldValueString (aItemName, 'NameParam1');
   ItemData.rNameParam[1] := ItemDb.GetFieldValueString (aItemName, 'NameParam2');

   ItemData.rServerId := ItemDb.GetFieldValueInteger (aItemName, 'ServerId');
   ItemData.rx := ItemDb.GetFieldValueInteger (aItemName, 'X');
   ItemData.ry := ItemDb.GetFieldValueInteger (aItemName, 'Y');
   ItemData.rAttribute := ItemDb.GetFieldValueInteger (aItemName, 'Attribute');
   ItemData.rGrade := ItemDB.GetFieldValueInteger (aItemName, 'Grade');

   ItemData.rMaxUpgrade := ItemDb.GetFieldValueInteger (aItemName, 'MaxUpgrade');
   ItemData.rUpgrade := 0;
   ItemData.rJobKind := ItemDb.GetFieldValueInteger (aItemName, 'JobKind');
   
   Str := ItemDB.GetFieldValueString (aItemName, 'Material');
   if Str <> '' then begin
      // if (ItemData.rMaxUpgrade = 3) or (ItemData.rJobKind = 2) then begin
      if (ItemData.rJobKind > JOB_KIND_NONE) and (ItemData.rJobKind <= JOB_KIND_CRAFTSMAN) then begin
         ItemMaterialClass.PushStr (ItemData.rJobKind, aItemName, Str);
      end;
   end;

   for i := 0 to 4 - 1 do begin
      if Str = '' then break;
      Str := GetValidStr3 (Str, iName, ':');
      if iName = '' then break;
      Str := GetValidStr3 (Str, dest, ':');
      if dest = '' then break;
      iCount := _StrToInt (dest);
      if iCount <= 0 then break;

      StrPCopy (@ItemData.rMaterial [i].rName, iName);
      ItemData.rMaterial [i].rCount := iCount;
   end;

   ItemData.rToolConst := ItemDb.GetFieldValueInteger (aItemName, 'ToolConst');
   ItemData.rboDurability := ItemDb.GetFieldValueBoolean (aItemName, 'boDurability');
   ItemData.rboUpgrade := ItemDb.GetFieldValueBoolean (aItemName, 'boUpgrade');
   ItemData.rSuccessRate := ItemDb.GetFieldValueInteger (aItemName, 'SuccessRate');
   StrPCopy (@ItemData.rDesc, ItemDb.GetFieldValueString (aItemName, 'Desc')); 

   ItemData.rCount := 1;

   Result := TRUE;
end;
}

{
function TItemClass.CreateItem (aItemName : String; var ItemData : TItemData) : Boolean;
var
   n : integer;
   Str : String;
begin
   Result := FALSE;

   n := AnsIndexClass.Select (aItemName);
   if (n = 0) or (n = -1) then begin
      FillChar (ItemData, sizeof(ItemData), 0);
      exit;
   end;
   ItemData := PTItemData (n)^;

   if StrPas (@ItemData.rCode) <> '' then begin
      Str := StrPas (@ItemData.rCode);
      Str := Str + GetDateByCode (Date) + GetTimeByCode (Time) + GetFixedCode (FAddValue);
      StrPCopy (@ItemData.rCode, Str);
      Inc (FAddValue);
      if FAddValue >= 1000 then FAddValue := 0;
   end;

   Result := TRUE;
end;
}

function TItemClass.GetItemData (aItemName: String; var ItemData: TItemData): Boolean;
var
   pd : PTItemData;
begin
   Result := false;

   pd := FKeyClass.Select (aItemName);
   if pd = nil then begin
      if aItemName <> '' then frmMain.WriteLogInfo (format ('Item Not Found %s', [aItemName])); 
      FillChar (ItemData, sizeof(ItemData), 0);
      exit;
   end;
   ItemData := pd^;
   
   Result := true;
end;

function TItemClass.GetSmeltItemData (aItemName : String; var SmeltItemData : TSmeltItemData) : Boolean;
var
   i : Integer;
   psd : PTSmeltItemData;
begin
   Result := false;

   for i := 0 to FSmeltList.Count - 1 do begin
      psd := FSmeltList.Items [i];
      if StrPas (@psd^.rName) = aItemName then begin
         SmeltItemData := psd^;
         Result := true;
         exit;
      end;
   end;

   FillChar (SmeltItemData, SizeOf (TSmeltItemData), 0);
   FrmMain.WriteLogInfo (format ('SmeltItemData Not Found  %s', [aItemName ] ) );
end;

function TItemClass.GetSmeltItemData2 (aItemName : String; var SmeltItemData : TSmeltItemData) : Boolean;
var
   i : Integer;
   psd : PTSmeltItemData;
begin
   Result := false;

   for i := 0 to FSmeltList2.Count - 1 do begin
      psd := FSmeltList2.Items [i];
      if StrPas (@psd^.rName) = aItemName then begin
         SmeltItemData := psd^;
         Result := true;
         exit;
      end;
   end;

   FillChar (SmeltItemData, SizeOf (TSmeltItemData), 0);
   FrmMain.WriteLogInfo (format ('SmeltItemData Not Found 2  %s', [aItemName ] ) );
end;

function TItemClass.GetCheckItemData (aObjName : String; aCheckItem : TCheckItem; var ItemData: TItemData): Boolean;
var
   pd : PTItemData;
   iName : String;
begin
   Result := FALSE;

   iName := StrPas (@aCheckItem.rName);
   pd := FKeyClass.Select (iName);
   if pd = nil then begin
      FillChar (ItemData, sizeof(ItemData), 0);
      FrmMain.WriteLogInfo (format ('CheckItemData Not Found  %s', [iName ] ) );
      exit;
   end;

   if RandomClass.GetChance (iName, aObjName) = false then begin
      FillChar (ItemData, sizeof(ItemData), 0);
      exit;
   end;

   ItemData := pd^;
   ItemData.rCount := aCheckItem.rCount;

   Result := TRUE;
end;

function TItemClass.GetChanceItemData (aStr, aObjName: string; var ItemData: TItemData): Boolean;
var
   str, rdstr, iname : string;
   icolor, icnt : integer;
   boChance : Boolean;
begin
   Result := FALSE;

   str := astr;

   str := GetValidStr3 (str, iname, ':');
   str := GetValidStr3 (str, rdstr, ':');
   icolor := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   icnt := _StrToInt (rdstr);

   if GetItemData (iName, ItemData) = FALSE then exit;

   boChance := RandomClass.GetChance (iName, aObjName);
   if boChance = false then begin
      FillChar(ItemData, sizeof(TItemData),0);
      exit;
   end else begin
//      CreateItem (iName, ItemData);
      ItemData.rColor := iColor;
      ItemData.rCount := iCnt;
   end;

   Result := TRUE;
end;

function TItemClass.GetWearItemData (astr: string; var ItemData: TItemData): Boolean;
var
   str, rdstr, iname : string;
   icolor, icnt, idura, icurdura, iupgrade, iuaddtype ,irLockState, irunLockTime :integer;
begin
   Result := FALSE;

   str := astr;

   str := GetValidStr3 (str, iName, ':');       // name
   str := GetValidStr3 (str, rdStr, ':');
   icolor := _StrToInt (rdstr);                 // color
   str := GetValidStr3 (str, rdStr, ':');
   icnt := _StrToInt (rdstr);                   // count
   str := GetValidStr3 (str, rdStr, ':');
   idura := _StrToInt (rdstr);                   // durability
   str := GetValidStr3 (str, rdStr, ':');
   icurdura := _StrToInt (rdstr);                   // curdurability
   str := GetValidStr3 (str, rdStr, ':');
   iupgrade := _StrToInt (rdstr);                   // upgrade
   str := GetValidStr3 (str ,rdStr, ':');
   iuaddtype := _StrToInt (rdstr);               // additional option type Number
   str := GetValidStr3 (str ,rdStr, ':');

   {//add by Orber at 2004-09-08 15:44}
try
   irLockState := _StrToInt (rdstr);
except
   irLockState := 0;
end;
   str := GetValidStr3 (str ,rdStr, ':');
try
   irunLockTime := _StrToInt (rdstr);
except
   irunLockTime := 0;
end;

   // str := GetValidStr3 (str, iCode, ':');

   if GetItemData (iName, ItemData) = FALSE then exit;
   ItemData.rColor := iColor;
   ItemData.rCount := iCnt;
   ItemData.rDurability := idura;
   ItemData.rCurDurability := icurdura;
   ItemData.rUpgrade := iupgrade;
   ItemData.rAddType := iuaddtype;
   ItemData.rLockState := irLockState;
   ItemData.runLockTime := irunLockTime;

   // StrPCopy (@ItemData.rCode, iCode);
   
   Result := TRUE;
end;

function TItemClass.GetMarketItemData (astr: string; var ItemData: TItemData): Boolean;
var
   str, rdstr, iname : string;
   icolor, icnt, idura, icurdura, iupgrade, iuaddtype, iprice :integer;
begin
   Result := FALSE;

   str := astr;

   str := GetValidStr3 (str, iName, ':');       // name
   str := GetValidStr3 (str, rdStr, ':');
   icolor := _StrToInt (rdstr);                 // color
   str := GetValidStr3 (str, rdStr, ':');
   icnt := _StrToInt (rdstr);                   // count
   str := GetValidStr3 (str, rdStr, ':');
   idura := _StrToInt (rdstr);                   // durability
   str := GetValidStr3 (str, rdStr, ':');
   icurdura := _StrToInt (rdstr);                   // curdurability
   str := GetValidStr3 (str, rdStr, ':');
   iupgrade := _StrToInt (rdstr);                   // upgrade
   str := GetValidStr3 (str, rdStr, ':');
   iuaddtype := _StrToInt (rdStr);                 // AddType
   str := GetValidStr3 (str, rdStr, ':');
   iprice := _StrToInt (rdStr);                 // price

   // str := GetValidStr3 (str, iCode, ':');

   if GetItemData (iName, ItemData) = FALSE then exit;
   ItemData.rColor := iColor;
   ItemData.rCount := iCnt;
   ItemData.rDurability := idura;
   ItemData.rCurDurability := icurdura;
   ItemData.rUpgrade := iupgrade;
   ItemData.rAddType := iuaddtype;   
   ItemData.rPrice := iprice;
   // StrPCopy (@ItemData.rCode, iCode);
   
   Result := TRUE;
end;

function TItemClass.GetWearItemString (var ItemData: TItemData): string;
begin
{   Result := StrPas (@ItemData.rName) + ':' + IntToStr(ItemData.rColor)
      + ':' + IntToStr(ItemData.rCount) + ':' + IntToStr (ItemData.rDurability)
      + ':' + IntToStr(ItemData.rCurDurability) + ':' + IntToStr (ItemData.rUpgrade)
      + ':' + IntToStr(ItemData.rAddType) ;
}
   //add by Orber at 2004-09-07 11:04
   Result := StrPas (@ItemData.rName) + ':' + IntToStr(ItemData.rColor)
      + ':' + IntToStr(ItemData.rCount) + ':' + IntToStr (ItemData.rDurability)
      + ':' + IntToStr(ItemData.rCurDurability) + ':' + IntToStr (ItemData.rUpgrade)
      + ':' + IntToStr(ItemData.rAddType) + ':' +  IntToStr(ItemData.rLockState)
      + ':' + IntToStr(ItemData.runLockTime);

//      + ':' + IntToStr(ItemData.rCount) + ':' + StrPas (@ItemData.rCode);
end;

function TItemClass.GetMarketItemString (var ItemData: TItemData): string;
begin
   Result := StrPas (@ItemData.rName) + ':' + IntToStr(ItemData.rColor)
      + ':' + IntToStr(ItemData.rCount) + ':' + IntToStr (ItemData.rDurability)
      + ':' + IntToStr(ItemData.rCurDurability) + ':' + IntToStr (ItemData.rUpgrade)
      + ':' + IntToStr(ItemData.rAddType) + ':' + IntToStr (ItemData.rPrice);
//      + ':' + IntToStr(ItemData.rCount) + ':' + StrPas (@ItemData.rCode);
end;

function TItemClass.GetAddItemAttribData (var ItemData : TItemData): Boolean;
var
   aIndex : Integer;
   aAddType : Integer;
   pa : PTAddAttribData;
begin
   Result := false;

   with ItemData do begin
      if ( rName[0] = 0 ) or (rAddtype = 0) or (rRoleType = 0) then exit;
      if ( rRoleType <> ROLE_HEAVY_FIGHTER ) and
         ( rRoleType <> ROLE_LIGHT_FIGHTER ) and
         ( rRoleType <> ROLE_BOWMAN ) and
         ( rRoleType <> ROLE_HANDMAN ) then exit;
      if ( rWearArr <> ADDATTRIB_ARMOR ) and
         ( rWearArr <> ADDATTRIB_CAP ) and
         ( rWearArr <> ADDATTRIB_ARMARMOR ) and
         ( rWearArr <> ADDATTRIB_SHOES ) and
         ( rWearArr <> ADDATTRIB_WEAPON ) then exit;
   end;

   aIndex := -1;
   case ItemData.rWearArr of
      ADDATTRIB_ARMOR:
         begin
            case ItemData.rRoleType of
               ROLE_HEAVY_FIGHTER : aIndex := 0;
               ROLE_LIGHT_FIGHTER : aIndex := 1;
               ROLE_BOWMAN : aIndex := 2;
               ROLE_HANDMAN : aIndex := 3;
            end;
         end;
      ADDATTRIB_CAP:
         begin
            case ItemData.rRoleType of
               ROLE_HEAVY_FIGHTER : aIndex := 4;
               ROLE_LIGHT_FIGHTER : aIndex := 5;
               ROLE_BOWMAN : aIndex := 6;
               ROLE_HANDMAN :aIndex := 7;
            end;
         end;
      ADDATTRIB_ARMARMOR:
         begin
            case ItemData.rRoleType of
               ROLE_HEAVY_FIGHTER : aIndex := 8;
               ROLE_LIGHT_FIGHTER : aIndex := 9;
               ROLE_BOWMAN : aIndex := 10;
               ROLE_HANDMAN : aIndex := 11;
            end;
         end;
      ADDATTRIB_SHOES:
         begin
            case ItemData.rRoleType of
               ROLE_HEAVY_FIGHTER : aIndex := 12;
               ROLE_LIGHT_FIGHTER : aIndex := 13;
               ROLE_BOWMAN : aIndex := 14;
               ROLE_HANDMAN : aIndex := 15;
            end;
         end;
      ADDATTRIB_WEAPON:
         begin
            case ItemData.rRoleType of
               ROLE_HEAVY_FIGHTER : aIndex := 16;
               ROLE_LIGHT_FIGHTER : aIndex := 17;
               ROLE_BOWMAN : aIndex := 18;
               ROLE_HANDMAN : aIndex := 19;
            end;
         end;
   end;

   aAddType := ItemData.rAddType;

   if aIndex <> -1 then begin
      dec(aAddType);
      if ( aAddType < 0 ) or ( aAddType > AddAttribList[aIndex].Count - 1 ) then exit;
      pa := AddAttribList[aIndex].Items[aAddType];
      if pa <> nil then begin
         ItemData.rAddAttribData := pa^;
         Result := true;
         exit;
      end;
   end;
end;


///////////////////////////////
// TDynamicObjectClass
///////////////////////////////
constructor TDynamicObjectClass.Create;
begin
   DataList := TList.Create;
   KeyClass := TStringKeyClass.Create;
   LoadFromFile ('.\Init\DynamicObject.Sdb');
end;

destructor TDynamicObjectClass.Destroy;
begin
   Clear;
   KeyClass.Free;
   DataList.Free;
   
   inherited Destroy;
end;

procedure TDynamicObjectClass.Clear;
var
   i : integer;
begin
   for i := 0 to DataList.Count - 1 do begin
      Dispose (DataList[i]);
   end;
   DataList.Clear;
   KeyClass.Clear;
end;

function TDynamicObjectClass.GetDynamicObjectData (aObjectName: String; var aObjectData: TDynamicObjectData): Boolean;
var
   pd : PTDynamicObjectData;
begin
   Result := FALSE;

   pd := KeyClass.Select (aObjectName);
   if pd = nil then begin
      FillChar (aObjectData, sizeof(TDynamicObjectData), 0);
      FrmMain.WriteLogInfo (format ('DynamicObjectData Not Found  %s', [aObjectName]));
      exit;
   end;
   aObjectData := pd^;
   
   Result := TRUE;
end;

procedure TDynamicObjectClass.LoadFromFile (aName : String);
var
   i, j : integer;
   iName, Str, rdStr : String;
   xx, yy : Word;
   StrDB : TUserStringDb;
   pd : PTDynamicObjectData;
begin
   Clear;

   if not FileExists (aName) then exit;

   StrDB := TUserStringDb.Create;
   StrDB.LoadFromFile (aName);
   for i := 0 to StrDb.Count - 1 do begin
      iName := StrDb.GetIndexName (i);
      if iName = '' then continue;

      New (pd);
      FillChar (pd^, SizeOf (TDynamicObjectData), 0);

      pd^.rName := StrDB.GetFieldValueString (iName, 'Name');
      pd^.rViewName := StrDB.GetFieldValueString (iName, 'ViewName');
      pd^.rKind := StrDB.GetFieldValueInteger (iName, 'Kind');
      pd^.rShape := StrDB.GetFieldValueInteger (iName, 'Shape');
      pd^.rLife := StrDB.GetFieldValueInteger (iName, 'Life');

      //2002-07-25 giltae
      pd^.rArmor := StrDB.GetFieldValueInteger (iName, 'Armor');
      //----------------------
      
      for j := 0 to 3 - 1 do begin
         pd^.rSStep [j] := StrDB.GetFieldValueString (iName, 'SStep' + IntToStr (j));
         pd^.rEStep [j] := StrDB.GetFieldValueString (iName, 'EStep' + IntToStr (j));
      end;
      
      StrToEffectData (pd^.rSoundEvent, StrDB.GetFieldValueString (iName, 'SOUNDEVENT'));
      StrToEffectData (pd^.rSoundSpecial, StrDB.GetFieldValueString (iName, 'SOUNDSPECIAL'));
      StrToEffectData (pd^.rSoundStart, StrDB.GetFieldValueString (iName, 'SoundStart'));
      StrToEffectData (pd^.rSoundDie, StrDB.GetFieldValueString (iName, 'SoundDie')); 

      Str := StrDB.GetFieldValueString (iName, 'GuardPos');
      for j := 0 to 20 - 1 do begin
         Str := GetValidStr3 (Str, rdStr, ':');
         xx :=  _StrToInt (rdStr);
         Str := GetValidStr3 (Str, rdStr, ':');
         yy :=  _StrToInt (rdStr);
         if (xx = 0) and (yy = 0) then break;

         pd^.rGuardX [j] := xx;
         pd^.rGuardY [j] := yy;
      end;
      pd^.rEventSay := StrDB.GetFieldValueString (iName, 'EventSay');
      pd^.rEventAnswer := StrDB.GetFieldValueString (iName, 'EventAnswer');
      Str := StrDB.GetFieldValueString (iName, 'EventItem');
      if Str <> '' then begin
         Str := GetValidStr3 (Str, rdStr, ':');
         StrPCopy (@pd^.rEventItem.rName, rdStr);
         Str := GetValidStr3 (Str, rdStr, ':');
         pd^.rEventItem.rCount := _StrToInt (rdStr);
      end;
      Str := StrDB.GetFieldValueString (iName, 'EventDropItem');
      if Str <> '' then begin
         Str := GetValidStr3 (Str, rdStr, ':');
         StrPCopy (@pd^.rEventDropItem.rName, rdStr);
         Str := GetValidStr3 (Str, rdStr, ':');
         pd^.rEventDropItem.rCount := _StrToInt (rdStr);
      end;

      pd^.rboRemove := StrDB.GetFieldValueBoolean (iName, 'boRemove');
      pd^.rOpennedInterval := StrDB.GetFieldValueInteger (iName, 'OpennedInterval');
      pd^.rRegenInterval := StrDB.GetFieldValueInteger (iName, 'RegenInterval');
      pd^.rKeepInterval := StrDB.GetFieldValueInteger (iName, 'KeepInterval');
      pd^.rboRandom := StrDB.GetFieldValueBoolean (iName, 'boRandom');
      pd^.rDamage := StrDB.GetFieldValueInteger (iName, 'Damage');
      pd^.rEffectColor := StrDB.GetFieldValueInteger (iName, 'EffectColor');
      pd^.rEventType := StrDB.GetFieldValueInteger (iName, 'EventType');
      pd^.rShowInterval := StrDB.GetFieldValueInteger (iName, 'ShowInterval');
      pd^.rhideInterval := StrDB.GetFieldValueInteger (iName, 'HideInterval');
      pd^.rboBlock := StrDB.GetFieldValueBoolean (iName, 'boBlock');
      pd^.rboMinimapShow := StrDB.GetFieldValueBoolean (iName, 'boMinimapShow');
      DataList.Add (pd);
      KeyClass.Insert (iName, pd);
   end;

   StrDb.Free;
end;

///////////////////////////////////
//         TMineObjectClass
///////////////////////////////////

constructor TMineObjectClass.Create;
begin
   FDataList := TList.Create;
   FShapeList := TList.Create;
   FAvailList := TList.Create;
   FToolRateList := TList.Create;

   LoadFromFile;
end;

destructor TMineObjectClass.Destroy;
begin
   Clear;
   FToolRateList.Free;
   FAvailList.Free;
   FShapeList.Free;
   FDataList.Free;

   inherited Destroy;
end;

procedure TMineObjectClass.Clear;
var
   i : integer;
   pmd : PTMineObjectData;
   psd : PTMineObjectShapeData;
   pad : PTMineObjectAvailData;
   ptd : PTToolRateData;   
begin
   for i := 0 to FDataList.Count - 1 do begin
      pmd := FDataList.Items [i];
      Dispose (pmd);
   end;
   FDataList.Clear;

   for i := 0 to FShapeList.Count - 1 do begin
      psd := FShapeList.Items [i];
      Dispose (psd);
   end;
   FShapeList.Clear;

   for i := 0 to FAvailList.Count - 1 do begin
      pad := FAvailList.Items [i];
      if pad^.rUsedList <> nil then pad^.rUsedList.Free;
      if pad^.rUnUsedList <> nil then pad^.rUnUsedList.Free;
      Dispose (pad);
   end;
   FAvailList.Clear;

   for i := 0 to FToolRateList.Count - 1 do begin
      ptd := FToolRateList.Items [i];
      Dispose (ptd);
   end;
   FToolRateList.Clear;
end;

procedure TMineObjectClass.InitPosition (aGroupName : String);
var
   i, j, iPos : Integer;
   Str : String;
   pad : PTMineObjectAvailData;
begin
   for i := 0 to FAvailList.Count - 1 do begin
      pad := FAvailList.Items [i];
      if StrPas (@pad^.rGroupName) = aGroupName then begin
         for j := 0 to pad^.rPositionCount - 1 do begin
            iPos := Random (pad^.rUnUsedList.Count);
            Str := pad^.rUnUsedList.Strings [iPos];
            pad^.rUsedList.Add (Str);
            pad^.rUnUsedList.Delete (iPos);
         end;
         exit;
      end;
   end;
end;

procedure TMineObjectClass.ClearSettingPos (aMapID : Word);
var
   i : Integer;
   pd : PTMineObjectAvailData;
begin
   for i := 0 to FAvailList.Count - 1 do begin
      pd := FAvailList.Items [i];
      if pd^.rMapID = aMapID then begin
         pd^.rUsedList.Clear;
         pd^.rUnUsedList.Clear;
      end;
   end;
end;

procedure TMineObjectClass.AddSettingPos (aGroupName : String; aName : String);
var
   i : Integer;
   pd : PTMineObjectAvailData;
begin
   for i := 0 to FAvailList.Count - 1 do begin
      pd := FAvailList.Items [i];
      if StrPas (@pd^.rGroupName) = aGroupName then begin
         pd^.rUnUsedList.Add (aName);
         exit;
      end;
   end;
end;

procedure TMineObjectClass.LoadFromFile;
var
   iName, Str, rdStr : String;
   i, j : Integer;
   ItemData : TItemData;

   pmd : PTMineObjectData;
   psd : PTMineObjectShapeData;
   pad : PTMineObjectAvailData;
   ptd : PTToolRateData;
   Db : TUserStringDb;
begin
   if FileExists ('.\Init\MineObject.SDB') then begin
      Db := TUserStringDb.Create;
      Db.LoadFromFile ('.\Init\MineObject.SDB');
      for i := 0 to Db.Count - 1 do begin
         iName := Db.GetIndexName (i);
         if iName = '' then continue;

         New (pmd);
         FillChar (pmd^, SizeOf (TMineObjectData), 0);

         StrPCopy (@pmd^.rName, Db.GetFieldValueString (iName, 'Name'));
         StrPCopy (@pmd^.rViewName, Db.GetFieldValueString (iName, 'ViewName'));
         pmd^.rPickConst := Db.GetFieldValueInteger (iName, 'PickConst');
         Str := Db.GetFieldValueString (iName, 'Deposits');
         for j := 0 to 5 - 1 do begin
            Str := GetValidStr3 (Str, rdStr, ':');
            if rdStr = '' then break;
            pmd^.rDeposits [j] := _StrToInt (rdStr);
         end;

         for j := 0 to 10 - 1 do begin
            Str := Db.GetFieldValueString (iName, 'Item' + IntToStr (j + 1));
            if Str = '' then break;
            ItemClass.GetItemData (Str, ItemData);
            if ItemData.rName [0] <> 0 then begin
               StrCopy (@pmd^.rAvailItems [j].rName, @ItemData.rName);
               pmd^.rAvailItems [j].rCount := 1;
            end;
         end;

         StrToEffectData (pmd^.rSoundData, Db.GetFieldValueString (iName, 'Sound'));

         Str := Db.GetFieldValueString (iName, 'RegenIntervals');
         for j := 0 to 3 - 1 do begin
            Str := GetValidStr3 (Str, rdStr, ':');
            pmd^.rRegenIntervals [j] := _StrToInt (rdStr);
         end;

         Str := Db.GetFieldValueString (iName, 'DropMop');
         for j := 0 to 5 - 1 do begin
            Str := GetValidStr3 (Str, rdStr, ':');
            if rdStr = '' then break;
            StrPCopy (@pmd^.rDropMop [j].rName, rdStr);
            Str := GetValidStr3 (Str, rdStr, ':');
            pmd^.rDropMop [j].rCount := _StrToInt (rdStr); 
         end;

         FDataList.Add (pmd);
      end;

      Db.Free;
   end;

   if FileExists ('.\Init\MineObjectShape.SDB') then begin
      Db := TUserStringDb.Create;
      Db.LoadFromFile ('.\Init\MineObjectShape.SDB');
      for i := 0 to Db.Count - 1 do begin
         iName := Db.GetIndexName (i);
         if iName = '' then continue;

         New (psd);
         FillChar (psd^, SizeOf (TMineObjectShapeData), 0);

         psd^.rShape := DB.GetFieldValueInteger (iName, 'Shape');
         psd^.rSStep := DB.GetFieldValueInteger (iName, 'SStep');
         psd^.rEStep := DB.GetFieldValueInteger (iName, 'EStep');

         Str := DB.GetFieldValueString (iName, 'GuardPos');
         for j := 0 to 10 - 1 do begin
            Str := GetValidStr3 (Str, rdStr, ':');
            psd^.rGuardX [j] := _StrToInt (rdStr);
            Str := GetValidStr3 (Str, rdStr, ':');
            psd^.rGuardY [j] := _StrToInt (rdStr);
            if (psd^.rGuardX [j] = 0) and (psd^.rGuardY [j] = 0) then break;
         end;

         FShapeList.Add (psd);
      end;

      Db.Free;
   end;

   if FileExists ('.\Init\MineObjectAvail.SDB') then begin
      Db := TUserStringDb.Create;
      Db.LoadFromFile ('.\Init\MineObjectAvail.SDB');
      for i := 0 to Db.Count - 1 do begin
         iName := Db.GetIndexName (i);
         if iName = '' then continue;

         New (pad);
         FillChar (pad^, SizeOf (TMineObjectShapeData), 0);

         StrPCopy (@pad^.rName, DB.GetFieldValueString (iName, 'Name'));
         StrPCopy (@pad^.rGroupName, DB.GetFieldValueString (iName, 'GroupName'));
         pad^.rMapID := DB.GetFieldValueInteger (iName, 'MapID');
         pad^.rPositionCount := DB.GetFieldValueInteger (iName, 'PositionCount');
         pad^.rSettingCount := DB.GetFieldValueInteger (iName, 'SettingCount');
         for j := 0 to 5 - 1 do begin
            Str := DB.GetFieldValueString (iName, format ('Mine%d', [j + 1]));
            if Str = '' then break;
            Str := GetValidStr3 (Str, rdStr, ':');
            StrPCopy (@pad^.rAvailMines [j], rdStr);
            Str := GetValidStr3 (Str, rdStr, ':');
            pad^.rMineSFreq [j] := _StrToInt (rdStr);
            Str := GetValidStr3 (Str, rdStr, ':');
            pad^.rMineEFreq [j] := _StrToInt (rdStr);
         end;
         pad^.rUsedList := TStringList.Create;
         pad^.rUnUsedList := TStringList.Create;

         FAvailList.Add (pad);
      end;

      Db.Free;
   end;

   if FileExists ('.\Init\ToolRate.SDB') then begin
      Db := TUserStringDb.Create;
      Db.LoadFromFile ('.\Init\ToolRate.SDB');
      for i := 0 to Db.Count - 1 do begin
         iName := Db.GetIndexName (i);
         if iName = '' then continue;

         New (ptd);
         FillChar (ptd^, SizeOf (TToolRateData), 0);

         Str := DB.GetFieldValueString (iName, 'Mine');
         rdStr := DB.GetFieldValueString (iName, 'Tool');

         ptd^.Name := Str + rdStr;
         for j := 0 to 10 - 1 do begin
            ptd^.rSFreq [j] := DB.GetFieldValueInteger (iName, 'SFreq' + IntToStr (j + 1));
            ptd^.rEFreq [j] := DB.GetFieldValueInteger (iName, 'EFreq' + IntToStr (j + 1));
         end;

         FToolRateList.Add (ptd);
      end;
      DB.Free;
   end;
end;

function TMineObjectClass.GetMineObjectData (aObjectName : String) : PTMineObjectData;
var
   i : Integer;
   pd : PTMineObjectData;
begin
   Result := nil;

   for i := 0 to FDataList.Count - 1 do begin
      pd := FDataList.Items [i];
      if StrPas (@pd^.rName) = aObjectName then begin
         Result := pd;
         exit;
      end;
   end;

   FrmMain.WriteLogInfo (format ('MineObject Data Not Found  %s', [aObjectName]));
end;

function TMineObjectClass.GetMineObjectShapeData (aShape : Word) : PTMineObjectShapeData;
var
   i : Integer;
   psd : PTMineObjectShapeData;
begin
   Result := nil;

   for i := 0 to FShapeList.Count - 1 do begin
      psd := FShapeList.Items [i];
      if psd^.rShape = aShape then begin
         Result := psd;
         exit;
      end;
   end;
end;

function TMineObjectClass.GetPositionCount (aGroupName : String) : Word;
var
   i : Integer;
   pad : PTMineObjectAvailData;
begin
   Result := 0;

   for i := 0 to FAvailList.Count - 1 do begin
      pad := FAvailList.Items [i];
      if StrPas (@pad^.rGroupName) = aGroupName then begin
         Result := pad^.rPositionCount;
         exit;
      end;
   end;
end;

procedure TMineObjectClass.ReturnChance (aGroupName : String; aPositionName : String);
var
   i, j, iPos : Integer;
   Str : String;
   pd : PTMineObjectAvailData;
begin
   for i := 0 to FAvailList.Count - 1 do begin
      pd := FAvailList.Items [i];
      if StrPas (@pd^.rGroupName) = aGroupName then begin
         for j := 0 to pd^.rUsedList.Count - 1 do begin
            Str := pd^.rUsedList.Strings [j];
            if Str = aPositionName then begin
               pd^.rUsedList.Delete (j);
               pd^.rUnUsedList.Add (Str);

               iPos := Random (pd^.rUnUsedList.Count);
               Str := pd^.rUnUsedList.Strings [iPos];
               pd^.rUsedList.Add (Str);
               pd^.rUnUsedList.Delete (iPos);

               break;
            end;
         end;
         exit;
      end;
   end;
end;

function TMineObjectClass.GetBuildChance (aGroupName : String; aPositionName : String) : Boolean;
var
   i, j : Integer;
   Str : String;
   pd : PTMineObjectAvailData;
begin
   Result := false;

   for i := 0 to FAvailList.Count - 1 do begin
      pd := FAvailList.Items [i];
      if StrPas (@pd^.rGroupName) = aGroupName then begin
         for j := 0 to pd^.rUsedList.Count - 1 do begin
            Str := pd^.rUsedList.Strings [j];
            if Str = aPositionName then begin
               Result := true;
               break;
            end;
         end;
         exit;
      end;
   end;
end;

function TMineObjectClass.ChoiceMineObjectName (aGroupName : String) : String;
var
   i : Integer;
   iRandomValue : Word;
   pad : PTMineObjectAvailData;
begin
   Result := '';

   pad := nil;
   for i := 0 to FAvailList.Count - 1 do begin
      pad := FAvailList.Items [i];
      if StrPas (@pad^.rGroupName) = aGroupName then break;
      pad := nil;
   end;
   if pad = nil then exit;

   iRandomValue := Random (100);
   for i := 0 to 5 - 1 do begin
      if (iRandomValue >= pad^.rMineSFreq [i]) and (iRandomValue < pad^.rMineEFreq [i]) then begin
         Result := StrPas (@pad^.rAvailMines [i]);
         exit;
      end;
   end;
end;

//Author:Steven Date: 2005-01-31 15:53:35
//Note:采集技能
//要对这个函数做个扩展,因为要根据采集技能的级别,改变掉落概率.
//我是依据级别越高,产生随机码次数越多,取最小值
function TMineObjectClass.ChoiceMineItemPos (aName : String; aExp: Integer) : Integer;
var
   i : Integer;
   iRandomValue, tmpRandomValue: Word;
   ptd : PTToolRateData;
   Level: Integer;

begin
   //9999最高级别

   //Randomize;

   Level := JobClass.GetExtJobLevel(aExp) div 1000;
   //============
   Result := -1;

   if aExp < 0 then exit;
   ptd := nil;
   for i := 0 to FToolRateList.Count - 1 do begin
      ptd := FToolRateList.Items [i];
      if ptd^.Name = aName then break;
      ptd := nil;
   end;
   if ptd = nil then exit;

   {for i := 0 to Level do
   begin
      tmpRandomValue := Random (10000);
      if i = 0 then
         iRandomValue := tmpRandomValue;
      if iRandomValue > tmpRandomValue then
         iRandomValue := tmpRandomValue;
   end;}

   iRandomValue := Random(10000);

   for i := 0 to 10 - 1 do begin
      if (iRandomValue >= ptd^.rSFreq [i]) and (iRandomValue < ptd^.rEFreq [i]) then begin
         Result := i;
         exit;
      end;
   end;
end;

const
   ITEMDRUG_DIV_VALUE            = 10;

   ITEMDRUG_MUL_EVENTENERGY      = 10;
   ITEMDRUG_MUL_EVENTINPOWER     = 10;
   ITEMDRUG_MUL_EVENTOUTPOWER    = 10;
   ITEMDRUG_MUL_EVENTMAGIC       = 10;
   ITEMDRUG_MUL_EVENTLIFE        = 15;
   ITEMDRUG_MUL_EVENTHEADLIFE    = 15;
   ITEMDRUG_MUL_EVENTARMLIFE     = 15;
   ITEMDRUG_MUL_EVENTLEGLIFE     = 15;

///////////////////////////////////
//         TItemDrugClass
///////////////////////////////////
constructor TItemDrugClass.Create;
begin
   FDataList := TList.Create;
   FKeyClass := TStringKeyClass.Create;
   
   ReLoadFromFile;
end;

destructor  TItemDrugClass.Destroy;
begin
   Clear;
   FDataList.Free;
   FKeyClass.Free;
   
   inherited Destroy;
end;

procedure TItemDrugClass.Clear;
var
   i : integer;
   pd : PTItemDrugData;
begin
   for i := 0 to FDataList.Count - 1 do begin
      pd := FDataList.Items [i];
      Dispose (pd);
   end;
   FDataList.Clear;
   FKeyClass.Clear;
end;

procedure TItemDrugClass.ReLoadFromFile;
var
   i : Integer;
   iName : string;
   pd : PTItemDrugData;
   DB : TUserStringDB;
begin
   Clear;

   if FileExists ('.\Init\ItemDrug.SDB') then begin
      DB := TUserStringDB.Create;
      DB.LoadFromFile ('.\Init\ItemDrug.SDB');
      for i := 0 to DB.Count - 1 do begin
         iName := Db.GetIndexName (i);
         if iName = '' then continue;

         New (pd);
         FillChar (pd^, SizeOf(TItemDrugData), 0);

         StrPCopy (@pd^.rName, DB.GetFieldValueString (iName, 'Name'));
         pd^.rType := DB.GetFieldValueInteger (iName, 'Type');
         pd^.rUseInterval := DB.GetFieldValueInteger (iName, 'UseInterval');
         pd^.rUseCount := DB.GetFieldValueInteger (iName, 'UseCount');
         pd^.rStillInterval := DB.GetFieldValueInteger (iName, 'StillInterval');

         if pd^.rType <> ITEM_DRUG_TYPE_A then begin
            pd^.rEventEnergy   := Db.GetFieldValueinteger (iName, 'eEnergy');
            pd^.rEventInPower  := Db.GetFieldValueinteger (iName, 'eInPower');
            pd^.rEventOutPower := Db.GetFieldValueinteger (iName, 'eOutPower');
            pd^.rEventMagic    := Db.GetFieldValueinteger (iName, 'eMagic');
            pd^.rEventLife     := Db.GetFieldValueinteger (iName, 'eLife');
            pd^.rEventHeadLife := Db.GetFieldValueinteger (iName, 'eHeadLife');
            pd^.rEventArmLife  := Db.GetFieldValueinteger (iName, 'eArmLife');
            pd^.rEventLegLife  := Db.GetFieldValueinteger (iName, 'eLegLife');
         end else begin
            pd^.rEventEnergy   := Db.GetFieldValueinteger (iName, 'eEnergy')   * ITEMDRUG_MUL_EVENTENERGY   div ITEMDRUG_DIV_VALUE;
            pd^.rEventInPower  := Db.GetFieldValueinteger (iName, 'eInPower')  * ITEMDRUG_MUL_EVENTINPOWER  div ITEMDRUG_DIV_VALUE;
            pd^.rEventOutPower := Db.GetFieldValueinteger (iName, 'eOutPower') * ITEMDRUG_MUL_EVENTOUTPOWER div ITEMDRUG_DIV_VALUE;
            pd^.rEventMagic    := Db.GetFieldValueinteger (iName, 'eMagic')    * ITEMDRUG_MUL_EVENTMAGIC    div ITEMDRUG_DIV_VALUE;
            pd^.rEventLife     := Db.GetFieldValueinteger (iName, 'eLife')     * ITEMDRUG_MUL_EVENTLIFE     div ITEMDRUG_DIV_VALUE;
            pd^.rEventHeadLife := Db.GetFieldValueinteger (iName, 'eHeadLife') * ITEMDRUG_MUL_EVENTHEADLIFE div ITEMDRUG_DIV_VALUE;
            pd^.rEventArmLife  := Db.GetFieldValueinteger (iName, 'eArmLife')  * ITEMDRUG_MUL_EVENTARMLIFE  div ITEMDRUG_DIV_VALUE;
            pd^.rEventLegLife  := Db.GetFieldValueinteger (iName, 'eLegLife')  * ITEMDRUG_MUL_EVENTLEGLIFE  div ITEMDRUG_DIV_VALUE;
         end;

         pd^.rDamageBody := Db.GetFieldValueinteger (iName, 'DamageBody');
         pd^.rDamageHead := Db.GetFieldValueinteger (iName, 'DamageHead');
         pd^.rDamageArm := Db.GetFieldValueinteger (iName, 'DamageArm');
         pd^.rDamageLeg := Db.GetFieldValueinteger (iName, 'DamageLeg');
         pd^.rArmorBody := Db.GetFieldValueinteger (iName, 'ArmorBody');
         pd^.rArmorHead := Db.GetFieldValueinteger (iName, 'ArmorHead');
         pd^.rArmorArm := Db.GetFieldValueinteger (iName, 'ArmorArm');
         pd^.rArmorLeg := Db.GetFieldValueinteger (iName, 'ArmorLeg');
         pd^.rAttackSpeed := Db.GetFieldValueinteger (iName, 'AttackSpeed');
         pd^.rAvoid := Db.GetFieldValueinteger (iName, 'Avoid');
         pd^.rRecovery := Db.GetFieldValueinteger (iName, 'Recovery');
         pd^.rAccuracy := Db.GetFieldValueinteger (iName, 'Accuracy');
         pd^.rKeepRecovery := Db.GetFieldValueinteger (iName, 'KeepRecovery');
         pd^.rLightDark := Db.GetFieldValueinteger (iName, 'LightDark');

         pd^.rUsedCount := 0;
         pd^.rUsedTick := 0;

         FDataList.Add (pd);
         FKeyClass.Insert (iName, pd);
      end;
      DB.Free;
   end;
end;

function TItemDrugClass.GetItemDrugData (aItemDrugName: string; var ItemDrugData: TItemDrugData): Boolean;
var
   pd : PTItemDrugData;
begin
   Result := false;

   pd := FKeyClass.Select (aItemDrugName);
   if pd = nil then begin
      FillChar (ItemDrugData, SizeOf (TItemDrugData), 0);
      FrmMain.WriteLogInfo (format ('ItemDrugData Not Found  %s', [aItemDrugName]));
      exit;
   end;
   ItemDrugData := pd^;

   Result := true;
end;

///////////////////////////////////
//         TItemMaterialClass
///////////////////////////////////
constructor TItemMaterialClass.Create;
begin
   DataList := TList.Create;
   MaterialSlot := TStringList.Create;
   
   AlchemistKeyClass := TStringKeyClass.Create;
   ChemistKeyClass := TStringKeyClass.Create;
   DesignerKeyClass := TStringKeyClass.Create;
   CraftsmanKeyClass := TStringKeyClass.Create;
   AllKeyClass := TStringKeyClass.Create;
end;

destructor TItemMaterialClass.Destroy;
begin
   Clear;

   AllKeyClass.Free;
   CraftsmanKeyClass.Free;
   DesignerKeyClass.Free;
   ChemistKeyClass.Free;
   AlchemistKeyClass.Free;
   MaterialSlot.Free;
   DataList.Free;

   inherited Destroy;
end;

procedure TItemMaterialClass.Clear;
var
   i : Integer;
   pd : PTMaterialData;
begin
   for i := 0 to DataList.Count - 1 do begin
      pd := DataList.Items [i];
      Dispose (pd);
   end;
   DataList.Clear;
   MaterialSlot.Clear;
   
   AlchemistKeyClass.Clear;
   ChemistKeyClass.Clear;
   DesignerKeyClass.Clear;
   CraftsmanKeyClass.Clear;
   AllKeyClass.Clear;
end;

procedure TItemMaterialClass.AllMakeItem (aItemName, aMaterialName : String);
var
   tmpStrList : TStringList;
   Str, iName, sCount : String;
   i : Integer;
   pd : PTMaterialData;   
begin
   if aItemName = '' then exit;
   if aMaterialName = '' then exit;

   tmpStrList := TStringList.Create;
   tmpStrList.Clear;

   Str := aMaterialName;
   for i := 0 to 4 - 1 do begin
      if Str = '' then break;
      
      Str := GetValidStr3 (Str, iName, ':');
      if iName = '' then break;
      Str := GetValidStr3 (Str, SCount, ':');
      if SCount = '' then break;

      tmpStrList.Add (iName + ':' + SCount);
   end;
   tmpStrList.Sort;

   Str := '';
   for i := 0 to tmpStrList.Count - 1 do begin
      Str := Str + tmpStrList.Strings [i] + ',';
   end;

   New (pd);
   FillChar (pd^, SizeOf (TMaterialData), 0);
   pd^.ItemName := aItemName;
   pd^.Material := Str;

   AllKeyClass.Insert(pd^.Material, pd); 

   tmpStrList.Free;   
end;

procedure TItemMaterialClass.PushStr (aKind : Byte; aItemName, aMaterialName : String);
var
   i : Integer;
   iName, SCount, Str : String;
   pd : PTMaterialData;
begin
   if aKind = JOB_KIND_NONE then exit;
   if aItemName = '' then exit;
   if aMaterialName = '' then exit;

   MaterialSlot.Clear;
   Str := aMaterialName;
   for i := 0 to 4 - 1 do begin
      if Str = '' then break;
      Str := GetValidStr3 (Str, iName, ':');
      if iName = '' then break;
      Str := GetValidStr3 (Str, SCount, ':');
      if SCount = '' then break;

      MaterialSlot.Add (iName + ':' + SCount);
   end;
   MaterialSlot.Sort;

   Str := '';
   for i := 0 to MaterialSlot.Count - 1 do begin
      Str := Str + MaterialSlot.Strings [i] + ',';
   end;

   New (pd);
   FillChar (pd^, SizeOf (TMaterialData), 0);
   pd^.ItemName := aItemName;
   pd^.Material := Str;
   case aKind of
      JOB_KIND_ALCHEMIST : AlchemistKeyClass.Insert (pd^.Material, pd);
      JOB_KIND_CHEMIST   : ChemistKeyClass.Insert (pd^.Material, pd);
      JOB_KIND_DESIGNER  : DesignerKeyClass.Insert (pd^.Material, pd);
      JOB_KIND_CRAFTSMAN : CraftsmanKeyClass.Insert (pd^.Material, pd);
   end;
end;

function TItemMaterialClass.GetAllMakeMaterialData (aMaterialStr : String) : String;
var
   i : Integer;
   pd : PTMaterialData;
   Str, Dest : String;
   tmpStrList : TStringList;
begin
   Result := '';
   
   if aMaterialStr = '' then exit;

   tmpStrList := TStringList.Create;
   tmpStrList.Clear;

   Str := aMaterialStr;
   for i := 0 to 4 - 1 do begin
      if Str = '' then break;
      Str := GetValidStr3 (Str, Dest, ',');
      if Dest = '' then break;
      tmpStrList.Add (Dest);
   end;
   tmpStrList.Sort;

   Str := '';
   for i := 0 to tmpStrList.Count - 1 do begin
      Str := Str + tmpStrList.Strings [i] + ',';
   end;

   pd := nil;
   pd := AllKeyClass.Select(Str); 

   if pd <> nil then begin
      Result := pd^.ItemName;
      exit;
   end;

   tmpStrList.Free;
end;

function TItemMaterialClass.GetMakeMaterialData (aJobKind : byte; aMaterialStr : String) : String; // 焊尘锭 犁丰,犁丰,.... (桨钎 嘿咯辑)
var
   i : Integer;
   pd : PTMaterialData;
   Str, Dest : String;
begin
   Result := '';
   
   if aJobKind = JOB_KIND_NONE then exit;
   if aMaterialStr = '' then exit;

   MaterialSlot.Clear;

   Str := aMaterialStr;
   for i := 0 to 4 - 1 do begin
      if Str = '' then break;
      Str := GetValidStr3 (Str, Dest, ',');
      if Dest = '' then break;
      MaterialSlot.Add (Dest);
   end;
   MaterialSlot.Sort;

   Str := '';
   for i := 0 to MaterialSlot.Count - 1 do begin
      Str := Str + MaterialSlot.Strings [i] + ',';
   end;

   pd := nil;
   case aJobKind of
      JOB_KIND_ALCHEMIST : pd := AlchemistKeyClass.Select (Str);
      JOB_KIND_CHEMIST   : pd := ChemistKeyClass.Select (Str);
      JOB_KIND_DESIGNER  : pd := DesignerKeyClass.Select (Str);
      JOB_KIND_CRAFTSMAN : pd := CraftsmanKeyClass.Select (Str);
   end;

   if pd <> nil then begin
      Result := pd^.ItemName;
      exit;
   end;

   //FrmMain.WriteLogInfo (format ('GetMake Material Data Not Found  %s', [aItemDrugName]));

end;


///////////////////////////////////
//         TJobClass
///////////////////////////////////
constructor TJobClass.Create;
begin
   LoadFromFile;
end;

destructor TJobClass.Destroy;
begin
   Clear;

   inherited Destroy;
end;

procedure TJobClass.Clear;
begin
   FillChar (JobGradeData, SizeOf (JobGradeData), 0);
   FillChar (JobTalentData, SizeOf (JobTalentData), 0);
   FillChar (JobUpgradeData, SizeOf (JobUpgradeData), 0);

   FillChar (AlchemistTool, SizeOf (AlchemistTool), 0);
   FillChar (ChemistTool, SizeOf (ChemistTool), 0);
   FillChar (DesignerTool, SizeOf (DesignerTool), 0);
   FillChar (CraftsmanTool, SizeOf (CraftsmanTool), 0);
end;

function TJobClass.LoadFromFile : Boolean;
var
   i, j, iNum, n : Integer;
   iName : String;
   Db : TUserStringDb;
   Str, DestStr: String;
begin
   if FileExists ('.\Init\JobGrade.SDB') then begin
      Db := TUserStringDb.Create;
      Db.LoadFromFile  ('.\Init\JobGrade.SDB');

      for i := 0 to Db.Count - 1 do begin
         iName := Db.GetIndexName (i);
         if iName = '' then continue;

         iNum := DB.GetFieldValueInteger (iName, 'Grade');
         if (iNum <= JOB_GRADE_NONE) or (iNum > JOB_GRADE_MAX) then continue;

         Case iNum of
            JOB_GRADE_NAMELESSWORKER : JobGradeData [iNum - 1].Name := INI_DEF_NAMELESSWORKER;
            JOB_GRADE_TECHNICIAN : JobGradeData [iNum - 1].Name := INI_DEF_TECHNICIAN;
            JOB_GRADE_SKILLEDWORKER : JobGradeData [iNum - 1].Name := INI_DEF_SKILLEDWORKER;
            JOB_GRADE_EXPERT : JobGradeData [iNum - 1].Name := INI_DEF_EXPERT;
            JOB_GRADE_MASTER : JobGradeData [iNum - 1].Name := INI_DEF_MASTER;
            JOB_GRADE_VIRTUEMAN : JobGradeData [iNum - 1].Name := INI_DEF_VIRTUEMAN;
         end;

         JobGradeData [iNum - 1].StartLevel := Db.GetFieldValueInteger (iName, 'Startlevel');
         JobGradeData [iNum - 1].EndLevel := Db.GetFieldValueInteger (iName, 'EndLevel');
         JobGradeData [iNum - 1].MaxItemGrade := Db.GetFieldValueInteger (iName, 'MaxItemGrade');


         Str := Db.GetFieldValueString(iName, 'MinerExp');
         Str := GetValidStr3(Str, DestStr, ':');
         JobGradeData [iNum - 1].Miner_SExp := _StrToInt(DestStr);

         Str := GetValidStr3(Str, DestStr, ':');
         JobGradeData [iNum - 1].Miner_EExp := _StrToInt(DestStr);

         Str := GetValidStr3(Str, DestStr, ':');
         JobGradeData [iNum - 1].Miner_SLevel := _StrToInt(DestStr);

         Str := GetValidStr3(Str, DestStr, ':');
         JobGradeData [iNum - 1].Miner_ELevel := _StrToInt(DestStr);



         for j := 0 to ITEM_GRADE_MAX - 1 do begin
            JobGradeData [iNum - 1].Grade [j] := Db.GetFieldValueInteger (iName, IntToStr(j + 1) + 'Grade');
         end;

         AlchemistTool [iNum - 1] := Db.GetFieldValueString (iName, 'Alchemist');
         ChemistTool [iNum - 1] := Db.GetFieldValueString (iName, 'Chemist');
         DesignerTool [iNum - 1] := Db.GetFieldValueString (iName, 'Designer');
         CraftsmanTool [iNum - 1] := Db.GetFieldValueString (iName, 'Craftsman');
      end;
      Db.Free;
   end;

   if FileExists ('.\Init\JobTalent.SDB') then begin
      Db := TUserStringDb.Create;
      Db.LoadFromFile  ('.\Init\JobTalent.SDB');

      for i := 0 to Db.Count - 1 do begin
         iName := Db.GetIndexName (i);
         if iName = '' then continue;

         iNum := DB.GetFieldValueInteger (iName, 'ItemGrade');
         if (iNum <= 0) or (iNum > ITEM_GRADE_MAX) then continue;

         JobTalentData [iNum - 1] := Db.GetFieldValueInteger (iName, 'MaxTalent');
      end;
      Db.Free;
   end;

   if FileExists ('.\Init\JobUpgrade.SDB') then begin
      Db := TUserStringDb.Create;
      Db.LoadFromFile  ('.\Init\JobUpgrade.SDB');

      for i := 0 to Db.Count - 1 do begin
         iName := Db.GetIndexName (i);
         if iName = '' then continue;

         iNum := DB.GetFieldValueInteger (iName, 'Upgrade');
         if (iNum <= 0) or (iNum > ITEM_UPGRADE_MAX) then continue;

         JobUpgradeData [iNum - 1].UpgradeStep := iNum;
         JobUpgradeData [iNum - 1].SuccessRate := Db.GetFieldValueInteger (iName, 'SuccessRate');
         JobUpgradeData [iNum - 1].DungeonRate := Db.GetFieldValueInteger (iName, 'DungeonRate'); 
         JobUpgradeData [iNum - 1].DamageBody := Db.GetFieldValueInteger (iName, 'DamageBody');
         JobUpgradeData [iNum - 1].DamageHead := Db.GetFieldValueInteger (iName, 'DamageHead');
         JobUpgradeData [iNum - 1].DamageArm := Db.GetFieldValueInteger (iName, 'DamageArm');
         JobUpgradeData [iNum - 1].DamageLeg := Db.GetFieldValueInteger (iName, 'DamageLeg');
         JobUpgradeData [iNum - 1].ArmorBody := Db.GetFieldValueInteger (iName, 'ArmorBody');
         JobUpgradeData [iNum - 1].ArmorHead := Db.GetFieldValueInteger (iName, 'ArmorHead');
         JobUpgradeData [iNum - 1].ArmorArm := Db.GetFieldValueInteger (iName, 'ArmorArm');
         JobUpgradeData [iNum - 1].ArmorLeg := Db.GetFieldValueInteger (iName, 'ArmorLeg');

         JobUpgradeData [iNum - 1].AttackSpeed := Db.GetFieldValueInteger (iName, 'AttackSpeed');
         JobUpgradeData [iNum - 1].Avoid := Db.GetFieldValueInteger (iName, 'Avoid');
         JobUpgradeData [iNum - 1].Recovery := Db.GetFieldValueInteger (iName, 'Recovery');
         JobUpgradeData [iNum - 1].Accuracy := Db.GetFieldValueInteger (iName, 'Accuracy');
         JobUpgradeData [iNum - 1].KeepRecovery := Db.GetFieldValueInteger (iName, 'KeepRecovery');
      end;
      Db.Free;
   end;

   Result := true;
end;

function TJobClass.GetJobGrade (aLevel : Integer) : Byte;
begin
   Result := JOB_GRADE_NONE;

   Case aLevel of
       100..1999 : Result := JOB_GRADE_NAMELESSWORKER;
      2000..3999 : Result := JOB_GRADE_TECHNICIAN;
      4000..5999 : Result := JOB_GRADE_SKILLEDWORKER;
      6000..7999 : Result := JOB_GRADE_EXPERT;
      8000..9998 : Result := JOB_GRADE_MASTER;
      Else Result := JOB_GRADE_VIRTUEMAN;
   end;
end;

function TJobClass.GetJobGradeData (aJobGrade : Byte; var aJobGradeData : TJobGradeData) : Boolean;
begin
   Result := false;

   if (aJobGrade < 1) or (aJobGrade > JOB_GRADE_MAX) then begin
      FillChar (aJobGradeData, SizeOf (TJobGradeData), 0);
      exit;
   end;
   
   aJobGradeData := JobGradeData [aJobGrade - 1];
   Result := true;
end;

function TJobClass.GetItemGradeMaxTalent (aItemGrade : Word) : Integer;
begin
   Result := 0;

   if (aItemGrade < 1) or (aItemGrade > ITEM_GRADE_MAX) then exit;
   
   Result := JobTalentData [aItemGrade - 1];
end;

function TJobClass.GetItemUpgradeSuccessRate (aStep : Word) : Integer;
begin
   Result := 0;

   if (aStep < 1) or (aStep > ITEM_UPGRADE_MAX) then exit;

   Result := JobUpgradeData [aStep - 1].SuccessRate;
end;

function TJobClass.GetItemUpgradeDungeonRate (aStep : Word) : Integer;
begin
   Result := 0;

   if (aStep < 1) or (aStep > ITEM_UPGRADE_MAX) then exit;

   Result := JobUpgradeData [aStep - 1].DungeonRate;
end;

function TJobClass.GetUpgradeData (aStep : Word; var aJobUpgradeData : TJobUpgradeData) : Boolean;
begin
   Result := false;

   if (aStep < 1) or (aStep > ITEM_UPGRADE_MAX) then exit;
   aJobUpgradeData := JobUpgradeData [aStep - 1];
   Result := true;
end;

function TJobClass.GetUpgradeItemLifeData (var aItemData : TItemData) : Boolean;
var
   ItemUpgrade : Integer;
   ItemName : String;
   ItemData : TItemData;
begin
   Result := false;

   if (aItemData.rUpgrade < 1) or (aItemData.rUpgrade > ITEM_UPGRADE_MAX) then exit;

   ItemName := StrPas (@aItemData.rName);
   ItemUpgrade := aItemData.rUpgrade;
   ItemClass.GetItemData (ItemName, ItemData);
   if ItemData.rName [0] = 0 then exit;

   aItemData.rLifeData.damageBody := ItemData.rLifeData.damageBody + ((ItemData.rLifeData.damageBody * JobUpgradeData [ItemUpgrade - 1].DamageBody) div 100);
   aItemData.rLifeData.damageHead := ItemData.rLifeData.damageHead + ((ItemData.rLifeData.damageHead * JobUpgradeData [ItemUpgrade - 1].DamageHead) div 100);
   aItemData.rLifeData.damageArm := ItemData.rLifeData.damageArm + ((ItemData.rLifeData.damageArm * JobUpgradeData [ItemUpgrade - 1].DamageArm) div 100);
   aItemData.rLifeData.damageLeg := ItemData.rLifeData.damageLeg + ((ItemData.rLifeData.damageLeg * JobUpgradeData [ItemUpgrade - 1].DamageLeg) div 100);
   aItemData.rLifeData.armorBody := ItemData.rLifeData.armorBody + ((ItemData.rLifeData.armorBody * JobUpgradeData [ItemUpgrade - 1].ArmorBody) div 100);
   aItemData.rLifeData.armorHead := ItemData.rLifeData.armorHead + ((ItemData.rLifeData.armorHead * JobUpgradeData [ItemUpgrade - 1].ArmorHead) div 100);
   aItemData.rLifeData.armorArm := ItemData.rLifeData.armorArm + ((ItemData.rLifeData.armorArm * JobUpgradeData [ItemUpgrade - 1].ArmorArm) div 100);
   aItemData.rLifeData.armorLeg := ItemData.rLifeData.armorLeg + ((ItemData.rLifeData.armorLeg * JobUpgradeData [ItemUpgrade - 1].ArmorLeg) div 100);

   // aItemData.rLifeData.AttackSpeed := ItemData.rLifeData.AttackSpeed + ((ItemData.rLifeData.AttackSpeed * JobUpgradeData [ItemUpgrade - 1].AttackSpeed) div 100);
   // aItemData.rLifeData.Recovery := ItemData.rLifeData.Recovery + ((ItemData.rLifeData.Recovery * JobUpgradeData [ItemUpgrade - 1].Recovery) div 100);
   aItemData.rLifeData.Avoid := ItemData.rLifeData.Avoid + ((ItemData.rLifeData.Avoid * JobUpgradeData [ItemUpgrade - 1].Avoid) div 100);
   aItemData.rLifeData.Accuracy := ItemData.rLifeData.Accuracy + ((ItemData.rLifeData.Accuracy * JobUpgradeData [ItemUpgrade - 1].Accuracy) div 100);
   aItemData.rLifeData.KeepRecovery := ItemData.rLifeData.KeepRecovery + ((ItemData.rLifeData.KeepRecovery * JobUpgradeData [ItemUpgrade - 1].KeepRecovery) div 100);

   Result := true;
end;

function TJobClass.GetJobTool (aJobKind, aJobGrade : Byte) : String;
begin
   Result := '';

   if (aJobKind <= JOB_KIND_NONE) or (aJobKind > JOB_KIND_CRAFTSMAN) then exit;
   if (aJobGrade <= JOB_GRADE_NONE) or (aJobGrade > JOB_GRADE_VIRTUEMAN) then exit;

   Case aJobKind of
      JOB_KIND_ALCHEMIST : Result := AlchemistTool [aJobGrade - 1];
      JOB_KIND_CHEMIST : Result := ChemistTool [aJobGrade - 1];
      JOB_KIND_DESIGNER : Result := DesignerTool [aJobGrade - 1];
      JOB_KIND_CRAFTSMAN : Result := CraftsmanTool [aJobGrade - 1];
   end;
end;

///////////////////////////////////
//         TMonsterClass
///////////////////////////////////
constructor TMonsterClass.Create;
begin
   MonsterDb := TUserStringDb.Create;
   DataList := TList.Create;
   KeyClass := TStringKeyClass.Create;
   ReLoadFromFile;
end;

destructor TMonsterClass.Destroy;
begin
   Clear;
   KeyClass.Free;
   DataList.Free;
   MonsterDb.Free;
   inherited Destroy;
end;

procedure TMonsterClass.Clear;
var i : integer;
begin
   for i := 0 to DataList.Count -1 do dispose (DataList[i]);
   DataList.Clear;
   KeyClass.Clear;
end;

function  TMonsterClass.LoadMonsterData (aMonsterName: string; var MonsterData: TMonsterData): Boolean;
var
   i, iCount, iRandomCount : Integer;
   str, rdstr, mName, mCount, mColor, mSkill: String;
   aItemData : TItemData;
   aShape, acolor, aHitType : Byte;
begin
   Result := FALSE;
   FillChar (MonsterData, sizeof(MonsterData), 0);
   if MonsterDb.GetDbString (aMonsterName) = '' then exit;

   StrPCopy (@MonsterData.rname, aMonsterName);

   mName := MonsterDB.GetFieldValueString (aMonsterName, 'ViewName');
   StrPCopy (@MonsterData.rViewName, mName);

   StrToEffectData (MonsterData.rSoundStart, MonsterDb.GetFieldValueString (aMonsterName, 'SoundStart'));   
   StrToEffectData (MonsterData.rSoundNormal, MonsterDb.GetFieldValueString (aMonsterName, 'SoundNormal'));
   StrToEffectData (MonsterData.rSoundAttack, MonsterDb.GetFieldValueString (aMonsterName, 'SoundAttack'));
   StrToEffectData (MonsterData.rSoundDie, MonsterDb.GetFieldValueString (aMonsterName, 'SoundDie'));
   StrToEffectData (MonsterData.rSoundStructed, MonsterDb.GetFieldValueString (aMonsterName, 'SoundStructed'));

   MonsterData.rKind := MonsterDB.GetFieldValueInteger (aMonsterName, 'Kind');   
   MonsterData.rAnimate := MonsterDb.GetFieldValueinteger (aMonsterName, 'Animate');
   MonsterData.rWalkSpeed := MonsterDb.GetFieldValueinteger (aMonsterName, 'WalkSpeed');
   MonsterData.rShape := MonsterDb.GetFieldValueinteger (aMonsterName, 'Shape');
   MonsterData.rdamage := MonsterDb.GetFieldValueinteger (aMonsterName, 'Damage');
   MonsterData.rDamageHead := MonsterDb.GetFieldValueInteger (aMonsterName, 'DamageHead');
   MonsterData.rDamageArm := MonsterDb.GetFieldValueInteger (aMonsterName, 'DamageArm');
   MonsterData.rDamageLeg := MonsterDb.GetFieldValueInteger (aMonsterName, 'DamageLeg');

   MonsterData.rAttackSpeed := MonsterDb.GetFieldValueinteger (aMonsterName, 'AttackSpeed');
   MonsterData.ravoid := MonsterDb.GetFieldValueinteger (aMonsterName, 'Avoid');
   MonsterData.raccuracy := MonsterDb.GetFieldValueInteger (aMonsterName, 'Accuracy');   
   MonsterData.rrecovery := MonsterDb.GetFieldValueinteger (aMonsterName, 'Recovery');
   MonsterData.rspendlife := MonsterDb.GetFieldValueinteger (aMonsterName, 'SpendLife');
   MonsterData.rarmor := MonsterDb.GetFieldValueinteger (aMonsterName, 'Armor');
   MonsterData.rHitArmor := MonsterDB.GetFieldValueInteger (aMonsterName, 'HitArmor');
   MonsterData.rlife := MonsterDb.GetFieldValueinteger (aMonsterName, 'Life');
   MonsterData.rActionWidth := MonsterDb.GetFieldValueInteger (aMonsterName, 'ActionWidth');
   MonsterData.rSpellResistRate := MonsterDB.GetFieldValueInteger (aMonsterName, 'SpellResistRate');
   MonsterData.rVirtue := MonsterDB.GetFieldValueInteger (aMonsterName, 'Virtue');
   MonsterData.rVirtueLevel := MonsterDB.GetFieldValueInteger (aMonsterName, 'VirtueLevel');
   MonsterData.rRegenInterval := MonsterDB.GetFieldValueInteger (aMonsterName, 'RegenInterval');

   str := MonsterDb.GetFieldValueString (aMonsterName, 'FallItem');
   for i := 0 to 5 - 1 do begin
      if str = '' then break;
      str := GetValidStr3 (str, mName, ':');
      if mName = '' then break;
      str := GetValidStr3 (str, mCount, ':');
      if mCount = '' then break;
      iCount := _StrToInt (mCount);
      if iCount <= 0 then break;
      str := GetValidStr3 (str, mCount, ':');
      if mCount = '' then break;
      iRandomCount := _StrToInt (mCount);
      if iRandomCount <= 0 then iRandomCount := 1;
      StrPCopy (@MonsterData.rFallItem[i].rName, mName);               // 酒捞袍捞抚
      MonsterData.rFallItem[i].rCount := iCount;             // 割俺究
      MonsterData.rFallItem[i].rColor := iRandomCount;           // 割焙单俊
   end;

   str := MonsterDb.GetFieldValueString (aMonsterName, 'HaveItem');
   for i := 0 to 10 - 1 do begin
      if str = '' then break;
      str := GetValidStr3 (str, mName, ':');
      if mName = '' then break;
      str := GetValidStr3 (str, mCount, ':');
      if mCount = '' then break;
      iCount := _StrToInt (mCount);
      if iCount <= 0 then break;
      str := GetValidStr3 (str, mCount, ':');
      if mCount = '' then break;
      iRandomCount := _StrToInt (mCount);
      if iRandomCount <= 0 then iRandomCount := 1;
      StrPCopy (@MonsterData.rHaveItem[i].rName, mName);
      MonsterData.rHaveItem[i].rCount := iCount;

      RandomClass.AddData (mName, aMonsterName,iRandomCount);
   end;

   //2003-10
   MonsterData.rQuestNum := MonsterDb.GetFieldValueinteger (aMonsterName, 'QuestNum');
   str := MonsterDb.GetFieldValueString (aMonsterName, 'QuestHaveItem');
   for i := 0 to 3 - 1 do begin
      if str = '' then break;
      str := GetValidStr3 (str, mName, ':');
      if mName = '' then break;
      str := GetValidStr3 (str, mCount, ':');
      if mCount = '' then break;
      iCount := _StrToInt (mCount);
      if iCount <= 0 then break;
      str := GetValidStr3 (str, mColor, ':');
      StrPCopy (@MonsterData.rQuestHaveItem[i].rName, mName);               // 酒捞袍捞抚
      MonsterData.rQuestHaveItem[i].rCount := iCount;             // 割俺究
      MonsterData.rQuestHaveItem[i].rColor := _StrToInt(mColor);           // 割焙单俊
   end;

   MonsterData.rboRightRemove := MonsterDb.GetFieldValueBoolean (aMonsterName, 'boRightRemove');   
   MonsterData.rboControl := MonsterDb.GetFieldValueBoolean (aMonsterName, 'boControl');
   MonsterData.rXControl := MonsterDb.GetFieldValueinteger (aMonsterName, 'XControl');
   MonsterData.rYControl := MonsterDb.GetFieldValueinteger (aMonsterName, 'YControl');
   MonsterData.rboHit := MonsterDb.GetFieldValueBoolean (aMonsterName, 'boHit');
   MonsterData.rboNotBowHit := MonsterDb.GetFieldValueBoolean (aMonsterName, 'boNotBowHit');
   MonsterData.rboIce := MonsterDb.GetFieldValueBoolean (aMonsterName, 'boIce');   
   MonsterData.rboSeller := MonsterDb.GetFieldValueBoolean (aMonsterName, 'boSeller');
   MonsterData.rboViewHuman := MonsterDb.GetFieldValueBoolean (aMonsterName, 'boViewHuman');
   MonsterData.rboAutoAttack := MonsterDb.GetFieldValueBoolean (aMonsterName, 'boAutoAttack');
   MonsterData.rboGoodHeart := MonsterDb.GetFieldValueBoolean (aMonsterName, 'boGoodHeart');
   MonsterData.rboAttack := MonsterDB.GetFieldValueBoolean (aMonsterName, 'boAttack');
   MonsterData.rEscapeLife := MonsterDb.GetFieldValueinteger (aMonsterName, 'EscapeLife');
   MonsterData.rViewWidth := MonsterDb.GetFieldValueinteger (aMonsterName, 'ViewWidth');
   MonsterData.rboBoss := MonsterDb.GetFieldValueBoolean (aMonsterName, 'boBoss');
   MonsterData.rboChangeTarget := MonsterDb.GetFieldValueBoolean (aMonsterName, 'boChangeTarget');
   MonsterData.rboVassal := MonsterDb.GetFieldValueBoolean (aMonsterName, 'boVassal');
   MonsterData.rVassalCount := MonsterDb.GetFieldValueinteger (aMonsterName, 'VassalCount');

   MonsterData.rAttackType := MonsterDb.GetFieldValueinteger (aMonsterName, 'AttackType');
   str := MonsterDb.GetFieldValueString (aMonsterName, 'AttackMagic');
   str := GetValidStr3 (str, mname, ':');
   str := GetValidStr3 (str, mskill, ':');
   MagicClass.GetMagicData (mname, MonsterData.rAttackMagic, _StrToInt(mskill));

   MonsterData.rHaveMagic := MonsterDb.GetFieldValueString (aMonsterName, 'HaveMagic');

   MonsterData.rEffectStart := MonsterDb.GetFieldValueInteger (aMonsterName, 'EffectStart');
   MonsterData.rEffectStructed := MonsterDb.GetFieldValueInteger (aMonsterName, 'EffectStructed');
   MonsterData.rEffectEnd := MonsterDb.GetFieldValueInteger (aMonsterName, 'EffectEnd');
   MonsterData.rboRandom := MonsterDb.GetFieldValueBoolean (aMonsterName, 'boRandom');
   MonsterData.rboPK := MonsterDb.GetFieldValueBoolean (aMonsterName, 'boPK');
   MonsterData.rMonType := MonsterDB.GetFieldValueInteger (aMonsterName, 'MonType');
//   MonsterData.rboSpecialExp := MonsterDB.GetFieldValueBoolean (aMonsterName, 'boSpecialExp');
   MonsterData.rHandExp := MonsterDB.GetFieldValueInteger (aMonsterName, 'HandExp');
   MonsterData.rShortExp := MonsterDB.GetFieldValueInteger (aMonsterName, 'ShortExp');
   MonsterData.rRiseShortExp := MonsterDB.GetFieldValueInteger (aMonsterName, 'RiseShortExp');
   MonsterData.rBestShortExp := MonsterDB.GetFieldValueInteger (aMonsterName, 'BestShortExp'); //2003-09-29 giltae
   MonsterData.rBestShortExp2 := MonsterDB.GetFieldValueInteger (aMonsterName, 'BestShortExp2'); //2003-09-29 giltae
   MonsterData.rBestShortExp3 := MonsterDB.GetFieldValueInteger (aMonsterName, 'BestShortExp3'); //2003-09-29 giltae

   MonsterData.rLongExp := MonsterDB.GetFieldValueInteger (aMonsterName, 'LongExp');
   MonsterData.rRiseLongExp := MonsterDB.GetFieldValueInteger (aMonsterName, 'RiseLongExp');
   MonsterData.rExtraExp := MonsterDB.GetFieldValueInteger (aMonsterName, 'ExtraExp');
   MonsterData.r3HitExp := MonsterDB.GetFieldValueInteger (aMonsterName, '3HitExp');
   MonsterData.rLimitSkill := MonsterDB.GetFieldValueInteger (aMonsterName, 'LimitSkill');

   MonsterData.rArmorWHPercent := MonsterDB.GetFieldValueInteger (aMonsterName, 'ArmorWHPercent');
   MonsterData.rFallItemRandCount := MonsterDB.GetFieldValueInteger (aMonsterName, 'FallItemRandomCount');
   MonsterData.rFirstDir := MonsterDB.GetFieldValueInteger (aMonsterName, 'FirstDir');
   MonsterData.rGroupKey := MonsterDB.GetFieldValueInteger(aMonsterName, 'GroupKey');
   
   Result := TRUE;
   ///////////////////////////////////////////
   MonsterData.rMonType := MonsterDB.GetFieldValueInteger (aMonsterName, 'MonType');
   if MonsterData.rMonType = 0 then exit;

   MonsterData.rFeature.rrace := RACE_MONSTER;
   MonsterData.rFeature.raninumber := 0;
   MonsterData.rFeature.rfeaturestate := wfs_normal;
   MonsterData.rFeature.rboman := MonsterDB.GetFieldValueBoolean (aMonsterName, 'sex');
   MonsterData.rFeature.rhitmotion := AM_HIT;
   MonsterData.rFeature.rImageNumber := 0;
   MonsterData.rFeature.rImageColorIndex := 0;
   {
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
   }
   str := MonsterDB.GetFieldValueString (aMonsterName, 'arr_body');
   if str <> '' then begin
      str := GetValidStr3(str, rdstr, ':');
      ItemClass.GetItemData(rdstr, aItemData);
      if aItemData.rName[0] <> 0 then begin
         aShape := aItemData.rWearShape;
         str := GetValidStr3(str, rdstr, ':');
         aColor := _StrToInt (rdstr);
         MonsterData.rFeature.rArr[ARR_BODY*2] := aShape;
         MonsterData.rFeature.rArr[ARR_BODY*2+1] := aColor;
      end;
   end;

   str := MonsterDB.GetFieldValueString (aMonsterName, 'arr_gloves');
   if str <> '' then begin
      str := GetValidStr3(str, rdstr, ':');
      ItemClass.GetItemData(rdstr, aItemData);
      if aItemData.rName[0] <> 0 then begin
         aShape := aItemData.rWearShape;
         str := GetValidStr3(str, rdstr, ':');
         aColor := _StrToInt (rdstr);
         MonsterData.rFeature.rArr[ARR_GLOVES*2] := aShape;
         MonsterData.rFeature.rArr[ARR_GLOVES*2+1] := aColor;
      end;
   end;

   str := MonsterDB.GetFieldValueString (aMonsterName, 'arr_upunderwear');
   if str <> '' then begin
      str := GetValidStr3(str, rdstr, ':');
      ItemClass.GetItemData(rdstr, aItemData);
      if aItemData.rName[0] <>0 then begin
         aShape := aItemData.rWearShape;
         aColor := aItemData.rcolor;
         MonsterData.rFeature.rArr[ARR_UPUNDERWEAR*2] := aShape;
         MonsterData.rFeature.rArr[ARR_UPUNDERWEAR*2+1] := aColor;
      end;
   end;

   str := MonsterDB.GetFieldValueString (aMonsterName, 'arr_shoes');
   if str <> '' then begin
      str := GetValidStr3(str, rdstr, ':');
      ItemClass.GetItemData(rdstr, aItemData);
      if aItemData.rName[0] <>0 then begin
         aShape := aItemData.rWearShape;
         str := GetValidStr3(str, rdstr, ':');
         aColor := _StrToInt (rdstr);
         MonsterData.rFeature.rArr[ARR_SHOES*2] := aShape;
         MonsterData.rFeature.rArr[ARR_SHOES*2+1] := aColor;
      end;
   end;

   str := MonsterDB.GetFieldValueString (aMonsterName, 'arr_downunderwear');
   if str <> '' then begin
      str := GetValidStr3(str, rdstr, ':');
      ItemClass.GetItemData(rdstr, aItemData);
      if aItemData.rName[0] <>0 then begin
         aShape := aItemData.rWearShape;
         str := GetValidStr3(str, rdstr, ':');
         aColor := _StrToInt (rdstr);
         MonsterData.rFeature.rArr[ARR_DOWNUNDERWEAR*2] := aShape;
         MonsterData.rFeature.rArr[ARR_DOWNUNDERWEAR*2+1] := aColor;
      end;
   end;


   str := MonsterDB.GetFieldValueString (aMonsterName, 'arr_upoverwear');
   if str <> '' then begin
      str := GetValidStr3(str, rdstr, ':');
      ItemClass.GetItemData(rdstr, aItemData);
      if aItemData.rName[0] <>0 then begin
         aShape := aItemData.rWearShape;
         str := GetValidStr3(str, rdstr, ':');
         aColor := _StrToInt (rdstr);
         MonsterData.rFeature.rArr[ARR_UPOVERWEAR*2] := aShape;
         MonsterData.rFeature.rArr[ARR_UPOVERWEAR*2+1] := aColor;
      end;
   end;

   str := MonsterDB.GetFieldValueString (aMonsterName, 'arr_hair');
   if str <> '' then begin
      str := GetValidStr3(str, rdstr, ':');
      ItemClass.GetItemData(rdstr, aItemData);
      if aItemData.rName[0] <>0 then begin
         aShape := aItemData.rWearShape;
         str := GetValidStr3(str, rdstr, ':');
         aColor := _StrToInt (rdstr);
         MonsterData.rFeature.rArr[ARR_HAIR*2] := aShape;
         MonsterData.rFeature.rArr[ARR_HAIR*2+1] := aColor;
      end;
   end;

   str := MonsterDB.GetFieldValueString (aMonsterName, 'arr_cap');
   if str <>'' then begin
      str := GetValidStr3(str, rdstr, ':');
      ItemClass.GetItemData(rdstr, aItemData);
      if aItemData.rName[0] <>0 then begin
         aShape := aItemData.rWearShape;
         str := GetValidStr3(str, rdstr, ':');
         aColor := _StrToInt (rdstr);
         MonsterData.rFeature.rArr[ARR_CAP*2] := aShape;
         MonsterData.rFeature.rArr[ARR_CAP*2+1] := aColor;
      end;
   end;

   str := MonsterDB.GetFieldValueString (aMonsterName, 'arr_weapon');
   if str <> '' then begin
      str := GetValidStr3(str, rdstr, ':');
      ItemClass.GetItemData(rdstr, aItemData);
      if aItemData.rName[0] <>0 then begin
         aHitType := aItemData.rHitType;
         case aHitType of
            HITTYPE_WRESTLING    : MonsterData.rFeature.rhitmotion := 31;
            HITTYPE_FENCING      : MonsterData.rFeature.rhitmotion := 38;
            HITTYPE_SWORDSHIP    : MonsterData.rFeature.rhitmotion := 37;
            HITTYPE_HAMMERING    : MonsterData.rFeature.rhitmotion := AM_HIT3;
            HITTYPE_SPEARING     : MonsterData.rFeature.rhitmotion := AM_HIT3;
            HITTYPE_BOWING       : MonsterData.rFeature.rhitmotion := AM_HIT4;
            HITTYPE_THROWING     : MonsterData.rFeature.rhitmotion := AM_HIT2;
            HITTYPE_WINDOFHAND   : MonsterData.rFeature.rhitmotion := AM_HIT10;
         end;
         aShape := aItemData.rWearShape;
         str := GetValidStr3(str, rdstr, ':');
         aColor := _StrToInt (rdstr);
         MonsterData.rFeature.rArr[ARR_WEAPON*2] := aShape;
         MonsterData.rFeature.rArr[ARR_WEAPON*2+1] := aColor;
      end;
   end;

   MonsterData.rFeature.rTeamColor := MonsterDB.GetFieldValueInteger (aMonsterName, 'GroupKey');
   MonsterData.rFeature.rNameColor := RGB(25,25,25);
   str := MonsterDB.GetFieldValueString (aMonsterName, 'Guild');
   strpcopy (@monsterData.rGuild ,str);

end;

procedure TMonsterClass.ReLoadFromFile;
var
   i : integer;
   iname : string;
   pmd : PTMonsterData;
begin
   Clear;

   if not FileExists ('.\Init\Monster.SDB') then exit;
   
   MonsterDb.LoadFromFile ('.\Init\Monster.SDB');
   for i := 0 to MonsterDb.Count -1 do begin
      iname := MonsterDb.GetIndexName (i);
      new (pmd);
      LoadMonsterData (iname, pmd^);
      DataList.Add (pmd);
      KeyClass.Insert (iName, pmd);
   end;
end;

function TMonsterClass.GetMonsterData (aMonsterName: string; var pMonsterData: PTMonsterData): Boolean;
begin
   Result := false;

   pMonsterData := KeyClass.Select (aMonsterName);
   if pMonsterData = nil then begin
      FrmMain.WriteLogInfo (format ('MonsterData Not Found  %s', [aMonsterName]));
      exit;
   end;

   Result := true;
end;

///////////////////////////////////
//         TNpcClass
///////////////////////////////////
constructor TNpcClass.Create;
begin
   NpcDb := TUserStringDb.Create;
   DataList := TList.Create;
   KeyClass := TStringKeyClass.Create;
   ReLoadFromFile;
end;

destructor TNpcClass.Destroy;
begin
   Clear;
   KeyClass.Free;
   DataList.Free;
   NpcDb.Free;
   inherited destroy;
end;

procedure TNpcClass.Clear;
var
   i : integer;
begin
   for i := 0 to DataList.Count -1 do dispose (DataList[i]);
   DataList.Clear;
   KeyClass.Clear;
end;

function  TNpcClass.LoadNpcData (aNpcName: string; var NpcData: TNpcData): Boolean;
var
   i, iCount, iRandomCount : Integer;
   str, mName, mCount: string;
begin
   Result := FALSE;
   FillChar (NpcData, sizeof(NpcData), 0);
   if NpcDb.GetNameIndex (aNpcName) = -1 then exit;

   StrPCopy (@NpcData.rName, aNpcName);
   mName := NpcDB.GetFieldValueString (aNpcName, 'ViewName');
   StrPCopy (@NpcData.rViewName, mName);
   NpcData.rShape := NpcDb.GetFieldValueinteger (aNpcName, 'Shape');
   NpcData.rAnimate := NpcDb.GetFieldValueinteger (aNpcName, 'Animate');
   NpcData.rdamage := NpcDb.GetFieldValueinteger (aNpcName, 'Damage');
   NpcData.rAttackSpeed := NpcDb.GetFieldValueinteger (aNpcName, 'AttackSpeed');
   NpcData.ravoid := NpcDb.GetFieldValueinteger (aNpcName, 'Avoid');
   NpcData.rrecovery := NpcDb.GetFieldValueinteger (aNpcName, 'Recovery');
   NpcData.rspendlife := NpcDb.GetFieldValueinteger (aNpcName, 'SpendLife');
   NpcData.rarmor := NpcDb.GetFieldValueinteger (aNpcName, 'Armor');
   NpcData.rArmorHead := NpcDb.GetFieldValueInteger (aNpcName, 'ArmorHead');
   NpcData.rArmorArm := NpcDb.GetFieldValueInteger (aNpcName, 'ArmorArm');
   NpcData.rArmorLeg := NpcDb.GetFieldValueInteger (aNpcName, 'ArmorLeg');
   
   NpcData.rHitArmor := NpcDB.GetFieldValueInteger (aNpcName, 'HitArmor');
   NpcData.rlife := NpcDb.GetFieldValueinteger (aNpcName, 'Life');
   NpcData.rboProtecter := NpcDb.GetFieldValueBoolean (aNpcName, 'boProtecter');
   NpcData.rboObserver := NpcDb.GetFieldValueBoolean (aNpcName, 'boObserver');
   NpcData.rboAutoAttack := NpcDb.GetFieldValueBoolean (aNpcName, 'boAutoAttack');
   NpcData.rboSeller := NpcDb.GetFieldValueBoolean (aNpcName, 'boSeller');
   NpcData.rboSale := NpcDb.GetFieldValueBoolean (aNpcName, 'boSale');
   NpcData.rboMinimapShow := NpcDb.GetFieldValueBoolean (aNpcName, 'boMinimapShow');   
   NpcData.rActionWidth := NpcDb.GetFieldValueInteger (aNpcName, 'ActionWidth');
   NpcData.rVirtue := NpcDb.GetFieldValueInteger (aNpcName, 'Virtue');
   NpcData.rVirtueLevel := NpcDb.GetFieldValueInteger (aNpcName, 'VirtueLevel');
   NpcData.rAttackMagic := NpcDb.GetFieldValueString (aNpcName, 'AttackMagic');
   NpcData.rAttackSkill := NpcDB.GetFieldValueInteger (aNpcName, 'AttackSkill'); 

   str := NpcDb.GetFieldValueString (aNpcName, 'HaveItem');
   for i := 0 to 5 - 1 do begin
      if str = '' then break;
      str := GetValidStr3 (str, mName, ':');
      if mName = '' then break;
      str := GetValidStr3 (str, mCount, ':');
      if mCount = '' then break;
      iCount := _StrToInt (mCount);
      if iCount <= 0 then break;
      str := GetValidStr3 (str, mCount, ':');
      if mCount = '' then break;
      iRandomCount := _StrToInt (mCount);
      if iRandomCount <= 0 then iRandomCount := 1;

      StrPCopy (@NpcData.rHaveItem[i].rName, mName);
      NpcData.rHaveItem[i].rCount := iCount;

      RandomClass.AddData (mName, aNpcName, iRandomCount);      
   end;

   NpcData.rHaveMagic := NpcDb.GetFieldValueString (aNpcName, 'HaveMagic');

   str := NpcDb.GetFieldValueString (aNpcName, 'NpcText');
   StrPCopy (@NpcData.rNpcText, str);

   NpcData.rAnimate := NpcDb.GetFieldValueInteger (aNpcName, 'Animate');
   NpcData.rShape := NpcDb.GetFieldValueInteger (aNpcName, 'Shape');

   NpcData.rRegenInterval := NpcDb.GetFieldValueInteger (aNpcName, 'RegenInterval');

   StrToEffectData (NpcData.rSoundStart, NpcDb.GetFieldValueString (aNpcName, 'SoundStart'));
   StrToEffectData (NpcData.rSoundNormal, NpcDb.GetFieldValueString (aNpcName, 'SoundNormal'));
   StrToEffectData (NpcData.rSoundAttack, NpcDb.GetFieldValueString (aNpcName, 'SoundAttack'));
   StrToEffectData (NpcData.rSoundDie, NpcDb.GetFieldValueString (aNpcName, 'SoundDie'));
   StrToEffectData (NpcData.rSoundStructed, NpcDb.GetFieldValueString (aNpcName, 'SoundStructed'));

   NpcData.rboHit := NpcDb.GetFieldValueBoolean (aNpcName, 'boHit');

   NpcData.rEffectStart := NpcDb.GetFieldValueInteger (aNpcName, 'EffectStart');
   NpcData.rEffectStructed := NpcDb.GetFieldValueInteger (aNpcName, 'EffectStructed');
   NpcData.rEffectEnd := NpcDb.GetFieldValueInteger (aNpcName, 'EffectEnd');
   NpcData.rboBattle := NpcDb.GetFieldValueBoolean (aNpcName, 'boBattle');
   NpcData.rboRightRemove := NpcDb.GetFieldValueBoolean (aNpcName, 'boRightRemove');

   Result := TRUE;
end;

procedure TNpcClass.ReLoadFromFile;
var
   i : integer;
   iname : string;
   pnd : PTNpcData;
begin
   Clear;

   if not FileExists ('.\Init\Npc.SDB') then exit;
   
   NpcDb.LoadFromFile ('.\Init\Npc.SDB');
   for i := 0 to NpcDb.Count -1 do begin
      iname := NpcDb.GetIndexName (i);
      new (pnd);
      LoadNpcData (iname, pnd^);
      DataList.Add (pnd);
      KeyClass.Insert (iName, pnd);
   end;
end;

function TNpcClass.GetNpcData (aNpcName: string; var pNpcData: PTNpcData): Boolean;
begin
   Result := false;

   pNpcData := KeyClass.Select (aNpcName);
   if pNpcData = nil then begin
      FrmMain.WriteLogInfo (format ('NpcData Not Found  %s', [aNpcName]));
      exit;
   end;
   Result := true;
end;

constructor TPosByDieClass.Create;
begin
   DataList := TList.Create;
   ReLoadFromFile;
end;

destructor TPosByDieClass.Destroy;
begin
   Clear;
   DataList.Free;
   
   inherited Destroy;
end;

procedure TPosByDieClass.Clear;
var
   i : Integer;
begin
   for i := 0 to DataList.Count - 1 do begin
      Dispose (DataList[i]);
   end;
   DataList.Clear;
end;

procedure TPosByDieClass.ReLoadFromFile;
var
   i : Integer;
   iName : String;
   StrDB : TUserStringDB;
   pd : PTPosByDieData;
begin
   if not FileExists ('.\Init\PosByDie.SDB') then exit;

   StrDB := TUserStringDB.Create;
   StrDB.LoadFromFile ('.\Init\PosByDie.SDB');

   for i := 0 to StrDB.Count - 1 do begin
      iName := StrDB.GetIndexName (i);
      if iName <> '' then begin
         New (pd);
         FillChar (pd^, sizeof (PTPosByDieData), 0);
         pd^.rServerID := StrDB.GetFieldValueInteger (iName, 'Server');
         pd^.rDestServerID := StrDB.GetFieldValueInteger (iName, 'DestServer');
         pd^.rDestX := StrDB.GetFieldValueInteger (iName, 'DestX');
         pd^.rDestY := StrDB.GetFieldValueInteger (iName, 'DestY');

         DataList.Add (pd);
      end;
   end;

   StrDB.Free;
end;

function TPosByDieClass.GetPosByDieData (aServerID : Integer; var aDestServerID : Integer; var aDestX, aDestY : Word) : Boolean;
var
   i : Integer;
   pd : PTPosByDieData;
begin
   Result := false;

   for i := 0 to DataList.Count - 1 do begin
      pd := DataList.Items [i];
      if pd <> nil then begin
         if pd^.rServerID = aServerID then begin
            aDestServerID := pd^.rDestServerID;
            aDestX := pd^.rDestX;
            aDestY := pd^.rDestY;
            Result := true;
            exit;
         end;
      end;
   end;
end;

// TQuestClass;
constructor TQuestClass.Create;
begin
end;

destructor TQuestClass.Destroy;
begin
   inherited Destroy;
end;

function TQuestClass.CheckQuest1 (aServerID : Integer; var aRetStr : String) : Boolean;
var
   tmpManager : TManager;
   iMonster, iNpc : Integer;
begin
   Result := false;
   tmpManager := ManagerList.GetManagerByServerID (aServerID);
   if tmpManager <> nil then begin
      iMonster := TMonsterList (tmpManager.MonsterList).AliveCount;
      iNpc := TNpcList (tmpManager.NpcList).AliveCount;
      if (iMonster <= 0) and (iNpc <= 0) then begin
         Result := true;
         exit;
      end;
      aRetStr := '';
      if iMonster > 0 then begin
         aRetStr := aRetStr + format ('MONSTER(%d)', [iMonster]);
      end;
      if (iMonster > 0) and (iNpc > 0) then begin
         aRetStr := aRetStr + ', ';
      end;
      if iNpc > 0 then begin
         aRetStr := aRetStr + format ('NPC(%d)', [iNpc]);
      end;
      aRetStr := aRetStr + Conv(' 生存');
   end;
end;

function TQuestClass.CheckQuest2 (aUser : Pointer; var aRetStr : String) : Boolean;
begin
   Result := false;

   if TUser (aUser).SGetUseMagicSkillLevel (7) >= 8501 then begin
      Result := true;
   end;
end;

function TQuestClass.CheckQuest3 (aUser : Pointer; var aRetStr : String) : Boolean;
begin
   Result := false;

   if TUser (aUser).GetAge < 2000 then begin
      Result := true;
   end;
end;

function TQuestClass.GetQuestString (aQuest : Integer) : String;
begin
   Result := '';
end;

function TQuestClass.CheckQuestComplete (aQuest, aServerID : Integer; aUser : Pointer; var aRetStr : String) : Boolean;
begin
   Result := false;
   Case aQuest of
      1 : Result := CheckQuest1 (aServerID, aRetStr);
      2 : Result := CheckQuest2 (aUser, aRetStr);
      3 : Result := CheckQuest3 (aUser, aRetStr);
   end;
end;



////////////////////////////////////////////////////
//
//             ===  QuestSummary Class  ===
//
////////////////////////////////////////////////////
constructor TQuestSummaryClass.Create;
begin
   FDataList := TList.Create;
   LoadFromFile ('.\Init\QuestSummary.SDB');
end;

destructor TQuestSummaryClass.Destroy;
begin
   Clear;
   FDataList.Free;
   inherited Destroy;
end;

procedure TQuestSummaryClass.Clear;
var
   i : integer;
   pq : PTQuestSummaryData;
begin
   for i := 0 to FDataList.Count - 1 do begin
      pq := FDataList.Items[i];
      dispose (pq);
   end;

   FDataList.Clear;
end;

procedure TQuestSummaryClass.ReLoadFromFile;
begin
   LoadFromFile ('.\Init\QuestSummary.SDB');
end;

procedure TQuestSummaryClass.LoadFromFile (aFileName : String);
var
   i : integer;
   iname : string;
   DB : TUserStringDB;
   pq : PTQuestSummaryData;
begin
   Clear;
   
   if FileExists (aFileName) then begin
      DB := TUserStringDb.Create;
      DB.LoadFromFile  (aFileName);

      for i := 0 to Db.Count - 1 do begin
         iName := Db.GetIndexName (i);
         if iName = '' then continue;
         new (pq);
         
         FillChar(pq^, sizeof(TQuestSummaryData), 0);
         pq^.rQuestNumber := DB.GetFieldValueInteger (iname, 'QuestNum');
         pq^.rQuestMainTitle := DB.GetFieldValueString (iname, 'QuestMainTitle');
         pq^.rQuestSubTitle := DB.GetFieldValueString (iname, 'QuestSubTitle');
         pq^.rRequest := DB.GetFieldValueString (iname, 'Request');
         MakeQuestLogWindow (pq^);
         FDataList.Add(pq);
      end;
      Db.Free;
   end;
end;

function TQuestSummaryClass.GetMainQuestTitle (aQuestNum: integer) : String;
var
   i : integer;
   pq : PTQuestSummaryData;
begin
   Result := '';
   for i := 0 to FDataList.Count - 1 do begin
      pq := FDataList.Items[i];
      if pq^.rQuestNumber = aQuestNum then begin
         Result := pq^.rQuestMainTitle;
         exit;
      end;
   end;

end;

function TQuestSummaryClass.GetSubQuestTitle (aQuestNum: integer) : String;
var
   i : integer;
   pq : PTQuestSummaryData;
begin
   Result := '';
   for i := 0 to FDataList.Count - 1 do begin
      pq := FDataList.Items[i];
      if pq^.rQuestNumber = aQuestNum then begin
         Result := pq^.rQuestSubTitle;
         exit;
      end;
   end;

end;
function TQuestSummaryClass.GetRequest (aQuestNum: integer) : String;
var
   i : integer;
   pq : PTQuestSummaryData;
begin
   Result := '';
   for i := 0 to FDataList.Count - 1 do begin
      pq := FDataList.Items[i];
      if pq^.rQuestNumber = aQuestNum then begin
         Result := pq^.rRequest;
         exit;
      end;
   end;
end;

function TQuestSummaryClass.GetDesc (aQuestNum: integer) : String;
var
   i : integer;
   pq : PTQuestSummaryData;
begin
   Result := '';
   if aQuestNum = 0 then exit;   

   for i := 0 to FDataList.Count - 1 do begin
      pq := FDataList.Items[i];
      if aQuestNum = pq^.rQuestNumber then begin
         Result := GetWordString (pq^.rDesc);
         exit;
      end;
   end;
end;

procedure TQuestSummaryClass.MakeQuestLogWindow (var aData : TQuestSummaryData);
var
   StrList : TStringList;
   StrList2 : TStringList;
   QuestNum : String;
   Str : String;
begin
   StrList := nil;
   StrList2 := nil;

   Str := format ('.\questnotice\%d.txt' , [aData.rQuestNumber] );
   if not FileExists (Str) then begin
      SetWordString (aData.rDesc, '');
      exit;
   end;
   
   try
      StrList2 := TStringList.Create;
      StrList2.LoadFromFile(Str);
      Str := StrList2.Text;
   finally
      if StrList <> nil then StrList2.Free;
   end;
   
   try
      QuestNum := IntToStr (aData.rQuestNumber);
      StrList := TStringList.Create;
      StrList.Add (format ('<%s>', [QuestNum] ));
      StrList.Add ('<head>');
      StrList.Add (format ('<title>%s</title>', [aData.rQuestMainTitle] ));
      StrList.Add ('<text>');
      StrList.Add (format ('%s',[aData.rQuestSubTitle] ));
      StrList.Add ('</text>');
      StrList.Add ('</head>');
      StrList.Add ('<command send=''close''>');
      StrList.Add (Conv('关闭'));
      StrList.Add ('</command>');
      StrList.Add ('<body>');
      StrList.Add (format (Conv('目的 : %s '), [aData.rRequest] ) + #13 );
      StrList.Add (Conv('详细内容:'));
      StrList.Add (Str);
      StrList.Add ('</body>');
      StrList.Add (format ('</%s>', [QuestNum] ));

      SetWordString (aData.rDesc, StrList.Text );
   finally
      if StrList <> nil then StrList.Free;
   end;
end;




////////////////////////////////////////////////////
//
//             ===  AreaClass  ===
//
////////////////////////////////////////////////////

constructor TAreaClass.Create;
begin
   DataList := TList.Create;
   LoadFromFile ('.\Init\AreaData.SDB');
end;

destructor TAreaClass.Destroy;
begin
   Clear;
   DataList.Free;
   inherited destroy;
end;

function TAreaClass.GetCount: integer;
begin
   Result := DataList.Count;
end;

procedure TAreaClass.Clear;
var
   i : Integer;
begin
   for i := 0 to DataList.Count - 1 do Dispose (DataList[i]);
   DataList.Clear;
end;

procedure TAreaClass.LoadFromFile (aFileName : String);
var
   i : Integer;
   iName : String;
   pd : PTAreaClassData;
   AreaDB : TUserStringDb;
begin
   Clear;

   if not FileExists (aFileName) then exit;

   AreaDB := TUserStringDb.Create;
   AreaDB.LoadFromFile (aFileName);

   for i := 0 to AreaDB.Count - 1 do begin
      iName := AreaDB.GetIndexName (i);
      if iName = '' then continue;
      
      New (pd);
      FillChar (pd^, sizeof(TAreaClassData), 0);

      pd^.Name := AreaDB.GetFieldValueString (iName, 'Name');
      pd^.Desc := AreaDB.GetFieldValueString (iName, 'Desc');
      pd^.Func := AreaDB.GetFieldValueString (iName, 'Func');
      pd^.Index := AreaDB.GetFieldValueInteger (iName, 'Index');

      DataList.Add (pd);
   end;
   AreaDB.Free;
end;

function TAreaClass.CanMakeGuild (aIndex : Byte) : Boolean;
var
   i : Integer;
   str, rdstr : String;
   pd : PTAreaClassData;
begin
   Result := false;

   for i := 0 to DataList.Count - 1 do begin
      pd := DataList.Items [i];
      if pd^.Index = aIndex then begin
         str := pd^.func;
         while str <> '' do begin
            str := GetValidStr3 (str, rdstr, ':');
            if _StrToInt (rdstr) = AREA_CANMAKEGUILD then begin
               Result := true;
               exit;
            end;
         end;
         exit;
      end;
   end;
end;

function TAreaClass.GetAreaName (aIndex : Byte) : String;
var
   i : Integer;
   pd : PTAreaClassData;
begin
   Result := '';
   for i := 0 to DataList.Count - 1 do begin
      pd := DataList.Items [i];
      if pd^.Index = aIndex then begin
         Result := pd^.Name;
         exit;
      end;
   end;
end;

function TAreaClass.GetAreaDesc (aIndex : Byte) : String;
var
   i : Integer;
   pd : PTAreaClassData;
begin
   Result := '';
   for i := 0 to DataList.Count - 1 do begin
      pd := DataList.Items [i];
      if pd^.Index = aIndex then begin
         Result := pd^.Desc;
         exit;
      end;
   end;
end;

constructor TPrisonClass.Create;
begin
   SaveTick := mmAnsTick;
   DataList := TList.Create;
   LoadFromFile ('Prison.SDB');
end;

destructor TPrisonClass.Destroy;
begin
   if DataList <> nil then begin
      SaveToFile ('Prison.SDB');
      Clear;
      DataList.Free;
   end;
   inherited Destroy;
end;

function TPrisonClass.GetPrisonTime (aType : String) : Integer;
var
   i : Integer;
   sKind, sCount : String;
   Count, SumTime : Integer;
begin
   SumTime := 0;

   sKind := Copy (aType, 1, 1);
   sCount := Copy (aType, 2, Length (aType) - 1);
   Count := _StrToInt (sCount);

   if UpperCase (sKind) = 'A' then begin
      SumTime := 3;
      for i := 1 to Count - 1 do begin
         SumTime := SumTime * 2;
      end;
   end else if UpperCase (sKind) = 'B' then begin
      SumTime := Count;
   end else if UpperCase (sKind) = 'M' then begin
      SumTime := Count;
   end;

   if UpperCase (sKind) = 'M' then begin
      if SumTime > 3 then begin
         SumTime := 3;
      end;
   end;
   SumTime := SumTime * 24 * 60;

   Result := SumTime;
end;

function TPrisonClass.GetPrisonData (aName : String) : PTPrisonData;
var
   i : Integer;
   pd : PTPrisonData;
begin
   Result := nil;

   for i := 0 to DataList.Count - 1 do begin
      pd := DataList.Items [i];
      if pd = nil then continue;
      if pd^.rUserName = aName then begin
         Result := pd;
         exit;
      end;
   end;
end;

procedure TPrisonClass.Update (CurTick : Integer);
begin
   if SaveTick + 5 * 60 * 100 <= CurTick then begin
      SaveTick := CurTick;
      SaveToFile ('Prison.SDB');
   end;
end;

procedure TPrisonClass.Clear;
var
   i : Integer;
   pd : PTPrisonData;
begin
   for i := 0 to DataList.Count - 1 do begin
      pd := DataList.Items [i];
      if pd <> nil then Dispose (pd);
   end;
   DataList.Clear;
end;

function TPrisonClass.LoadFromFile (aFileName : String) : Boolean;
var
   i : Integer;
   PrisonDB : TUserStringDB;
   iName : String;
   pd : PTPrisonData;
begin
   Result := false;

   if not FileExists (aFileName) then exit;

   PrisonDB := TUserStringDB.Create;
   PrisonDB.LoadFromFile (aFileName);

   for i := 0 to PrisonDB.Count - 1 do begin
      iName := PrisonDB.GetIndexName (i);
      if iName = '' then continue;

      New (pd);
      FillChar (pd^, sizeof (TPrisonData), 0);

      pd^.rUserName := PrisonDB.GetFieldValueString (iName, 'UserName');
      pd^.rPrisonType := PrisonDB.GetFieldValueString (iName, 'PrisonType');
      pd^.rElaspedTime := PrisonDB.GetFieldValueInteger (iName, 'ElaspedTime');
      pd^.rPrisonTime := GetPrisonTime (pd^.rPrisonType);
      pd^.rReason := PrisonDB.GetFieldValueString (iName, 'Reason');

      DataList.Add (pd);
   end;

   PrisonDB.Free;

   Result := true;
end;

function TPrisonClass.SaveToFile (aFileName : String) : Boolean;
var
   i : Integer;
   iName : String;
   PrisonDB : TUserStringDB;
   pd : PTPrisonData;
begin
   Result := false;

   PrisonDB := TUserStringDB.Create;
   PrisonDB.LoadFromFile (aFileName);
   for i := 0 to PrisonDB.Count - 1 do begin
      iName := PrisonDB.GetIndexName (i);
      PrisonDB.DeleteName (iName);
   end;

   for i := 0 to DataList.Count - 1 do begin
      pd := DataList.Items [i];
      if pd <> nil then begin
         PrisonDB.AddName (pd^.rUserName);
         PrisonDB.SetFieldValueString (pd^.rUserName, 'UserName', pd^.rUserName);
         PrisonDB.SetFieldValueInteger (pd^.rUserName, 'PrisonTime', pd^.rPrisonTime);
         PrisonDB.SetFieldValueInteger (pd^.rUserName, 'ElaspedTime', pd^.rElaspedTime);
         PrisonDB.SetFieldValueString (pd^.rUserName, 'PrisonType', pd^.rPrisonType);
         PrisonDB.SetFieldValueString (pd^.rUserName, 'Reason', pd^.rReason);
      end;
   end;

   PrisonDB.SaveToFile (aFileName);
   PrisonDB.Free;

   Result := true;
end;

function TPrisonClass.AddUser (aName, aType, aReason : String) : String;
var
   pd : PTPrisonData;
   rTime : Integer;
   pUser : TUser;
begin
   Result := '';

   if aName = '' then begin
      Result := Conv('请指定使用者名称');
      exit;
   end;
   if GetPrisonData (aName) <> nil then begin
      Result := Conv('已被囚禁的使用者');
      exit;
   end;
   rTime := GetPrisonTime (aType);
   if rTime = 0 then begin
      Result := Conv('时间设定错误');
      exit;
   end;

   New (pd);
   FillChar (pd^, sizeof (TPrisonData), 0);

   pd^.rUserName := aName;
   pd^.rElaspedTime := 0;
   pd^.rPrisonTime := rTime;
   pd^.rPrisonType := aType;
   pd^.rReason := aReason;

   DataList.Add (pd);

   pUser := UserList.GetUserPointer (aName);
   if pUser <> nil then begin
      pUser.SendClass.SendChatMessage (Conv('现在开始被囚禁于流配地，请重新连线'), SAY_COLOR_SYSTEM);
      ConnectorList.CloseConnectByCharName(aName);      
   end;
end;

function TPrisonClass.DelUser (aName : String) : String;
var
   pd : PTPrisonData;
   rIndex : Integer;
begin
   Result := '';

   if aName = '' then begin
      Result := Conv('请指定使用者名称');
      exit;
   end;

   pd := GetPrisonData (aName);
   if pd = nil then begin
      Result := Conv('不是被囚禁的使用者');
      exit;
   end;
   rIndex := DataList.IndexOf (pd);
   if rIndex >= 0 then DataList.Delete (rIndex);
end;

function TPrisonClass.UpdateUser (aName, aType, aReason : String) : String;
var
   pd : PTPrisonData;
   rTime : Integer;
begin
   Result := '';

   if aName = '' then begin
      Result := Conv('请指定使用者名称');
      exit;
   end;

   pd := GetPrisonData (aName);
   if pd = nil then begin
      Result := Conv('不是被囚禁的使用者');
      exit;
   end;

   rTime := GetPrisonTime (aType);
   if rTime = 0 then begin
      Result := Conv('时间设定错误');
      exit;
   end;
   pd^.rPrisonTime := rTime;
   pd^.rElaspedTime := 0;
   pd^.rPrisonType := aType;
   if aReason <> '' then begin
      pd^.rReason := aReason;
   end;
end;

function TPrisonClass.PlusUser (aName, aType, aReason : String) : String;
var
   pd : PTPrisonData;
   rTime : Integer;
begin
   Result := '';

   if aName = '' then begin
      Result := Conv('请指定使用者名称');
      exit;
   end;

   pd := GetPrisonData (aName);
   if pd = nil then begin
      Result := Conv('不是被囚禁的使用者');
      exit;
   end;

   rTime := GetPrisonTime (aType);
   if rTime = 0 then begin
      Result := Conv('时间设定错误');
      exit;
   end;
   pd^.rPrisonTime := pd^.rPrisonTime + rTime;
   pd^.rPrisonType := aType;
   if aReason <> '' then begin
      pd^.rReason := aReason;
   end;
end;

function TPrisonClass.EditUser (aName, aTime, aReason : String) : String;
var
   pd : PTPrisonData;
   rTime : Integer;
begin
   Result := '';

   if aName = '' then begin
      Result := Conv('请指定使用者名称');
      exit;
   end;

   pd := GetPrisonData (aName);
   if pd = nil then begin
      Result := Conv('不是被囚禁的使用者');
      exit;
   end;

   rTime := _StrToInt (aTime);
   pd^.rPrisonTime := rTime;
   pd^.rPrisonType := 'C';
   if aReason <> '' then begin
      pd^.rReason := aReason;
   end;
end;


function TPrisonClass.GetUserStatus (aName : String) : String;
var
   pd : PTPrisonData;
   TotalMin : Integer;
   nDay, nHour, nMin : Word;
   rStr : String;
begin
   Result := '';
   pd := GetPrisonData (aName);
   if pd = nil then exit;

   nDay := 0; nHour := 0; nMin := 0;
   TotalMin := pd^.rPrisonTime;
   nDay := (TotalMin div (60 * 24));
   TotalMin := TotalMin - (nDay * 60 * 24);
   nHour := (TotalMin div 60);
   TotalMin := TotalMin - (nHour * 60);
   nMin := TotalMin;
   if nMin < 0 then nMin := 1;
   
   rStr := format (Conv('囚禁时间(%d天%d时%d分)'), [nDay, nHour, nMin]);

   nDay := 0; nHour := 0; nMin := 0;
   TotalMin := pd^.rPrisonTime - pd^.rElaspedTime;
   if TotalMin > 0 then begin
      nDay := (TotalMin div (60 * 24));
      TotalMin := TotalMin - (nDay * 60 * 24);
      nHour := (TotalMin div 60);
      TotalMin := TotalMin - (nHour * 60);
      nMin := TotalMin;
   end else begin
      TotalMin := 0;
      nDay := 0;
      nHour := 0;
   end;
   rStr := rStr + format (Conv('剩余时间(%d天%d时%d分)'), [nDay, nHour, nMin]);

   Result := rStr;
end;

function TPrisonClass.IncreaseElaspedTime (aName : String; aTime : Integer) : Integer;
var
   pd : PTPrisonData;
   rTime : Integer;
begin
   Result := 0;
   pd := GetPrisonData (aName);
   if pd = nil then exit;

   pd^.rElaspedTime := pd^.rElaspedTime + aTime;

   rTime := pd^.rPrisonTime - pd^.rElaspedTime;

   if rTime <= 0 then begin
      DelUser (aName);
      rTime := 0;
   end;
   
   Result := rTime;
end;

constructor TNpcFunction.Create;
begin
   DataList := TList.Create;

   LoadFromFile ('.\NpcFunc\NpcFunc.SDB');
end;

destructor TNpcFunction.Destroy;
begin
   Clear;
   DataList.Free;
end;

procedure TNpcFunction.Clear;
var
   i : Integer;
   pd : PTNpcFunctionData;
begin
   for i := 0 to DataList.Count - 1 do begin
      pd := DataList.Items [i];
      Dispose (pd);
   end;
   DataList.Clear;
end;

procedure TNpcFunction.LoadFromFile (aFileName : String);
var
   i : Integer;
   iName : String;
   DB : TUserStringDB;
   pd : PTNpcFunctionData;
begin
   if not FileExists (aFileName) then exit;

   DB := TUserStringDB.Create;
   DB.LoadFromFile (aFileName);

   for i := 0 to DB.Count - 1 do begin
      iName := DB.GetIndexName (i);
      if iName = '' then continue;

      New (pd);
      FillChar (pd^, SizeOf (TNpcFunctionData), 0);
      pd^.Index := _StrToInt (iName);
      pd^.FuncType := DB.GetFieldValueInteger (iName, 'FuncType');
      pd^.Text := DB.GetFieldValueString (iName, 'Text');
      pd^.FileName := DB.GetFieldValueString (iName, 'FileName');
      pd^.StartQuest := DB.GetFieldValueInteger (iName, 'StartQuest');
      pd^.NextQuest := DB.GetFieldValueInteger (iName, 'NextQuest');

      DataList.Add (pd);
   end;

   DB.Free;
end;

function TNpcFunction.GetFunction (aIndex : Integer) : PTNpcFunctionData;
var
   i : Integer;
   pd : PTNpcFunctionData;
begin
   Result := nil;
   
   for i := 0 to DataList.Count - 1 do begin
      pd := DataList.Items [i];
      if aIndex = pd^.Index then begin
         Result := pd;
         exit;
      end;
   end;
end;


// TSystemAlert
constructor TSystemAlert.Create;
begin
   boGameAgree := false;
   Information := TStringList.Create;
   LoadFromFile;
end;

destructor TSystemAlert.Destroy;
begin
   Clear;
   Information.Free;
   inherited Destroy;
end;

procedure TSystemAlert.Clear;
begin
   Information.Clear;
end;

procedure TSystemAlert.LoadFromFile;
begin
   Clear;

   boGameAgree := false;
   if FileExists ('.\GameAgree.TXT') then begin
      boGameAgree := true;
      Information.LoadFromFile ('.\GameAgree.TXT');
      exit;
   end;
   if FileExists ('.\Information.TXT') then begin
      Information.LoadFromFile ('.\Information.TXT');
      exit;
   end;
end;

procedure TSystemAlert.Alert (aUser : Pointer);
var
   i : Integer;
   Str1, Str2 : String;
begin
   if Information.Count > 0 then begin
      Str1 := Information.Strings [0];
      Str2 := '';
      for i := 1 to Information.Count - 1 do begin
         Str2 := Str2 + Information.Strings [i] + #13;
      end;
      if TUser (aUser).GetCurrentWindow = swk_none then begin
         if boGameAgree = true then begin
            TUser (aUser).SendClass.SendShowSpecialWindow (TUser (aUser), WINDOW_ALERT, ALERT_GAMEAGREE, Str1, Str2);
            TUser (aUser).SetCurrentWindow (swk_alert, sst_gameagree);
         end else begin
            TUser (aUser).SendClass.SendShowSpecialWindow (TUser (aUser), WINDOW_ALERT, ALERT_INFORMATION, Str1, Str2);
            TUser (aUser).SetCurrentWindow (swk_alert, sst_info);
         end;
      end;
   end;
end;

////////////////////////////////////
// THelpFiles Class
//
///////////////////////////////////

constructor THelpFiles.Create;
begin
   inherited Create;
   FDataList := TList.Create;
   LoadHelpFiles;
end;

destructor THelpFiles.Destroy;
begin
   Clear;
   FDataList.Free;
   inherited Destroy;
end;

procedure THelpFiles.Clear;
var
   i : integer;
   ph : PTCreateHelpData;
begin
   for i := 0 to FDataList.Count - 1 do begin
      ph := FDataList.Items[i];
      dispose (ph);
   end;
   FDataList.Clear;
end;

function THelpFiles.FindFile (aFileName : string) : String;
var
   i : integer;
   ph : PTCreateHelpData;
begin
   Result := '';
   for i := 0 to FDataList.Count - 1 do begin
      ph := FDataList.Items[i];
      if LowerCase (aFileName) = LowerCase (ph^.rHelpFileName) then begin
         Result := GetWordString (ph^.rHelpDesc);
         exit;
      end;
   end;

   FrmMain.WriteLogInfo (format ('HelpFiles Not Found  %s', [aFileName]));
end;

procedure THelpFiles.LoadHelpFiles;
var
   sr: TSearchRec;
   i : integer;
   ext : string;
   ph : PTCreateHelpData;
   basePath : string;
   StrList : TStringList;
   Str : String;
begin
   Str := '';
   Clear;
   try
      basePath := '.\help\';
      if FindFirst(basepath + '*.*', faAnyFile, sr) = 0 then begin
         repeat
            ext := ExtractFileExt (sr.Name);
            if ext = '.txt' then begin
               new(ph);
               FillChar (ph^,sizeof(TCreateHelpData), 0);
               ph^.rHelpFileName := basePath + sr.Name;
               Str := '';
               StrList := TStringList.Create;
               StrList.LoadFromFile (ph^.rHelpFileName);
               for i := 0 to StrList.Count - 1 do begin
                  Str := Str + StrList.Strings[i] + #13#10;
               end;

               SetWordString(ph^.rHelpDesc, Str);
               FDataList.Add (ph);
               StrList.Free;
            end;
         until FindNext(sr) <> 0;
         FindClose(sr);
      end;
   except
      ShowMessage ('Can not Load Help Files');
      //FrmMain.boCloseFlag := true;
      //FrmMain.TimerClose.Interval := 1000;
      //FrmMain.TimerClose.Enabled := TRUE;
   end;
end;

//////////////////////////////////////////////////
constructor TMacroReport.Create;
begin
   inherited;
   FList := TList.Create;
   FMaxListCount := 100;

end;

destructor TMacroReport.Destroy;
begin
   Clear;
   FList.Free;
   inherited Destroy;
end;

procedure TMacroReport.Clear;
var
   i : integer;
   pr : PTReportInfo;
begin
   for i := 0 to FList.Count -1 do begin
      pr := FList.Items[i];
      dispose (pr);
   end;
   FList.Clear;
end;

function TMacroReport.GetCount: Integer;
begin
   Result := FList.Count;
end;

function TMacroReport.GetReport : String;
var
   pr : PTReportInfo;
   str : String;
   aMacroUser, aReportUser, aTime : String;
begin
   Result := '';
   if Count = 0 then exit;
   pr := FList.Items[0];
   aMacroUser := StrPas (PChar (@pr^.rMacroUser));
   aReportUser := StrPas (PChar (@pr^.rReportuser));
   aTime := StrPas (PChar (@pr^.rTime));

   Str := Conv('≮脚绊郴侩≮') + #13;
   Str := Str + Conv('乔绊惯磊: ') + aMacroUser + #13;
   Str := Str + Conv('绊惯磊: ') + aReportUser + #13;
   Str := Str + Conv('矫阿: ') + aTime + #13;
   Result := Str;
end;

function TMacroReport.GetMacroUser : String;
var
   pr : PTReportInfo;
   str : String;
begin
   Result := '';
   if Count = 0 then exit;
   pr := FList.Items[0];
   str := StrPas (PChar (@pr^.rMacroUser));
   Result := str;

end;

function TMacroReport.AddUser (aUserName,aReporterName : string) : Boolean;
var
   pr : PTReportInfo;
   nLen : Integer;
   aTime : TDateTime;
   str : String;
begin
   Result := false;
   if Count > FMaxListCount then exit;

   new (pr);
   FillChar (pr^,sizeof(TReportInfo),0);
   nLen := Length (aUserName);
   if nLen > 20 - 1 then exit;

   aTime := Time;
   str := TimeToStr(aTime); // convert the time into a string

   StrPCopy ( PChar (@pr^.rMacroUser), aUserName);
   StrPCopy ( PChar (@pr^.rReportuser), aReporterName);
   StrPCopy ( PChar (@pr^.rTime), str);


   FList.Add (pr);
   Result := true;

end;

function TMacroReport.DelUser (aUserName : string) : Boolean;
var
   i : integer;
   str : String;
   pr : PTReportInfo;
begin
   Result := false;

   for i := FList.Count - 1 to 0 do begin
      pr := FList.Items[i];
      str := StrPas (PChar (@pr^.rMacroUser));
      if str = aUserName then begin
         dispose (pr);
         FList.Delete (i);
      end;
   end;
   Result := true;
end;

function TMacroReport.DelFirst : Boolean;
var
   pr : PTReportInfo;
begin
   Result := false;
   if Count = 0 then exit;

   pr := FList.Items[0];
   dispose (pr);

   FList.Delete (0);
   Result := true;
end;

//////////////////////////////////////////////////
constructor TQuizSystem.Create;
begin
   inherited;
   FActive := false;
   FQuestion := '';
   FAnswer := '';
   FPresentName := '';
   FPresentCnt := 0;
end;

destructor TQuizSystem.Destroy;
begin
   inherited;
end;

procedure TQuizSystem.SetPresent (aItemName : String; aCount : Integer);
begin
   FPresentName := aItemName;
   FPresentCnt := aCount;
end;

procedure TQuizSystem.SetAnswer (aAnswer : String);
begin
   FAnswer := aAnswer;
end;

procedure TQuizSystem.SetQuestion (aQuestion : String);
begin
   FQuestion := aQuestion;
end;

function TQuizSystem.GetPresentation : String;
var
   str : String;
begin
   Result := '';
   str := Conv('【问答内容】') + #13;
   str := str + Conv('问题 : ') + Question + #13;
   str := str + Conv('答案 : ') + Answer + #13;
   str := str + Conv('奖品 : ') + FPresentName + #13 ;
   str := str + Conv('数量 : ') + IntToStr (FPresentCnt) + #13#0;
   Result := str;
end;


//////////////////////////////////////////////////
//             TAddAttribClass
//////////////////////////////////////////////////
constructor TAddAttribClass.Create;
begin
   FDataList := TList.Create;

   LoadFromFile;
end;

destructor TAddAttribClass.Destroy;
begin
   Clear;
   FDataList.Free;

   inherited destroy;
end;

procedure TAddAttribClass.Clear;
var
   pp : PTProbabilityData;
begin
   While FDataList.Count > 0 do begin
      pp := FDataLIst.Items[0];
      dispose (pp);
      FDataList.Delete(0);
   end;

   FillChar (GradeData,sizeof(TAttribGradeData)*10,0);
end;

procedure TAddAttribClass.LoadFromFile;
var
   i : Integer;
   DB : TUserStringDB;
   iName : String;
   pp,pBefore : PTProbabilityData;
begin
   Clear;

   if FileExists ('.\Init\AddAttribProbability.SDB') then begin
      DB := TUserStringDB.Create;
      DB.LoadFromFile ('.\Init\AddAttribProbability.SDB');

      for i := 0 to Db.Count - 1 do begin
         iName := DB.GetIndexName (i);
         if iName = '' then continue;

         New (pp);
         FillChar (pp^, sizeof (TProbabilityData), 0);

         pp^.rLowestValue := DB.GetFieldValueInteger (iName, 'Lowest');
         pp^.rLowerValue := DB.GetFieldValueInteger (iName, 'Lower');
         pp^.rNormalValue := DB.GetFieldValueInteger (iName, 'Normal');
         pp^.rHigherValue := DB.GetFieldValueInteger (iName, 'Higher');
         pp^.rHighestValue := DB.GetFieldValueInteger (iName, 'Highest');

         FDataList.Add (pp);
      end;
      
      DB.Free;
   end;

   //固府 拌魂等 Table阑 付访秦初绰促.
   for i := 1 to FDataList.Count - 1 do begin
      pp := FDataList.Items[i];
      pBefore := FDataList.Items[i-1];

      pp^.rLowestValue := pp^.rLowestValue + pBefore^.rLowestValue;
      pp^.rLowerValue := pp^.rLowerValue + pBefore^.rLowerValue;
      pp^.rNormalValue := pp^.rNormalValue + pBefore^.rNormalValue;
      pp^.rHigherValue := pp^.rHigherValue + pBefore^.rHigherValue;
      pp^.rHighestValue := pp^.rHighestValue + pBefore^.rHighestValue;
   end;

   if FileExists ('.\Init\AddAttribGrade.SDB') then begin
      DB := TUserStringDB.Create;
      DB.LoadFromFile ('.\Init\AddAttribGrade.SDB');

      for i := 1 to Db.Count do begin
         if i > High (GradeData) then begin
            FrmMain.WriteLogInfo ('Init\AddAttribGrade.SDB: excess rows ignored (maximum 10)');
            break;
         end;
         iName := DB.GetIndexName (i-1);
         if iName = '' then continue;
         GradeData[i].rMaxRange := DB.GetFieldValueInteger (iName, 'MaxRange');
         GradeData[i].rAttribItemCount := DB.GetFieldValueInteger (iName, 'AttribItemCount');
      end;
      DB.Free;
   end;
   
end;

function TAddAttribClass.GetRange (iGrade : Integer) : Integer;
begin
   Result := -1;
   if ( iGrade > 10 ) or ( iGrade <= 0) then exit;
   Result := GradeData[iGrade].rMaxRange;
end;

function TAddAttribClass.GetNeedItemCount (iGrade : Integer) : Integer;
begin
   Result := -1;
   if ( iGrade > 10) or (iGrade <= 0) then exit;
   Result := GradeData[iGrade].rAttribItemCount;
end;

function TAddAttribClass.GetAddTypeNum (aMaxRange, aWorth : Integer) : Integer;
var
   i : integer;
   iValue : Integer;
   ppd,pBefore : PTProbabilityData;
   nRandom : Integer;
   iBefore, iNext : Integer;
begin
   Result := -1;
   if aMaxRange > FDataList.Count then exit;
   ppd := FDataList.Items[aMaxRange-1];
   iValue := -1;
   case aWorth of
      ITEM_ATTRIBUTE_LOWEST   : iValue := ppd^.rLowestValue;
      ITEM_ATTRIBUTE_LOWEER   : iValue := ppd^.rLowerValue;
      ITEM_ATTRIBUTE_NORMAL   : iValue := ppd^.rNormalValue;
      ITEM_ATTRIBUTE_HIGHER   : iValue := ppd^.rHigherValue;
      ITEM_ATTRIBUTE_HIGHEST  : iValue := ppd^.rHighestValue;
   end;

   if iValue = -1 then exit;
   nRandom := random(iValue)+1;

   iBefore := 0;
   iNext := 0;
   for i := 1 to FDataList.Count - 1 do begin
      ppd := FDataList.Items[i];
      pBefore := FDataList.Items[i-1];

      case aWorth of
         ITEM_ATTRIBUTE_LOWEST   :
            begin
               iBefore := pBefore^.rLowestValue;
               iNext := ppd^.rLowestValue;
            end;
         ITEM_ATTRIBUTE_LOWEER   :
            begin
               iBefore := pBefore^.rLowerValue;
               iNext := ppd^.rLowerValue;
            end;
         ITEM_ATTRIBUTE_NORMAL   :
            begin
               iBefore := pBefore^.rNormalValue;
               iNext := ppd^.rNormalValue;
            end;
         ITEM_ATTRIBUTE_HIGHER   :
            begin
               iBefore := pBefore^.rHigherValue;
               iNext := ppd^.rHigherValue;
            end;
         ITEM_ATTRIBUTE_HIGHEST  :
            begin
               iBefore := pBefore^.rHighestValue;
               iNext := ppd^.rHighestValue;
            end;
      end;

      if iBefore >= nRandom then Result := 1;
      if ( iBefore < nRandom) and ( iNext >= nRandom) then begin
         Result := i+1;
         exit;
      end;
   end;
end;

//////////////////////////////////////////////////
constructor TEventItemClass.Create;
var
   i : integer;
begin
   for i := 0 to 4-1 do begin
      FDataLists[i] := TList.Create;
   end;

   FillChar (FMaxRangeValues, sizeof(integer)*4,0);
   LoadFromFile;
end;

destructor TEventItemClass.Destroy;
var
   i : integer;
begin
   Clear;
   for i :=0 to 4-1 do begin
      FDataLists[i].Free;
   end;
end;

function TEventItemClass.GetMaxRangeValue(idx: integer): integer;
begin
   Result := 0;
   if (idx <0) or (idx >4-1) then exit;
   Result := FMaxRangeValues[idx];
end;

procedure TEventItemClass.GetEventItem(iNum : integer; var aItemName :String; var aItemCount: integer);
var
   i : integer;
   p : PTEventItemData;
   idx : integer;
   nRand : integer;
begin
   aItemName := '';
   aItemCount := 0;

   case iNum of
      1..14 : idx := 0;
      15..29: idx := 1;
      30..40: idx := 2;
      41..45: idx := 3;
      else
         exit;
   end;

   if (FDataLists[idx].Count = 0) or (FMaxRangeValues[idx] <= 0) then exit;
   nRand := Random(FMaxRangeValues[idx]);

   for i := 0 to FDataLists[idx].Count - 1 do begin
      p := FDataLists[idx].Items[i];
      if (p^.rMin <= nRand) and (p^.rMax > nRand) then begin
         aItemName := StrPas (@p^.rItemName);
         aItemCount := p^.rItemCount;
         exit;
      end;
   end;
end;

procedure TEventItemClass.Clear;
var
   i,j : integer;
   p : PTEventItemData;
begin
   for i := 0 to 4-1 do begin
      for j := 0 to FDataLists[i].Count -1 do begin
         p := FDataLists[i].Items[j];
         dispose(p);
      end;
   end;

   for i := 0 to 4-1 do begin
      FDataLists[i].Clear;
   end;


   FillChar (FMaxRangeValues, sizeof(FMaxRangeValues),0);
end;

procedure TEventItemClass.LoadFromFile;
var
   i,j, aWidth, aCount, aCurPos: integer;
   DB : TUserStringDB;
   iName, Str : String;
   p : PTEventItemData;
   boRet : boolean;
   ItemData : TItemData;
   aFileName : string;
begin
   Clear;

   for i := 0 to 4-1 do begin
      aFileName := format ('.\Event\EventItem%d.sdb',[i+1]);
      if FileExists (aFileName) then begin
         DB := TUserStringDB.Create;
         DB.LoadFromFile (aFileName);

         aWidth := 0;
         aCurPos := 0;

         for j := 0 to Db.Count - 1 do begin
            iName := DB.GetIndexName (j);
            if iName = '' then continue;

            Str := DB.GetFieldValueString (iName, 'ItemName');
            boRet := ItemClass.GetItemData(str, ItemData);
            aCount := DB.GetFieldValueInteger (iName,'ItemCount');
            aWidth := DB.GetFieldValueInteger (iName, 'Width');
            // 任一无效记录使本档奖池停用，不能跳过后改变其它奖品的概率。
            if (not boRet) or (Str = '') or (Length(Str) >= SizeOf(TNameString)) or
               (aCount <= 0) or (aWidth <= 0) or
               (aWidth > MaxInt - aCurPos) or
               ((not ItemData.rboDouble) and (aCount <> 1)) or
               ((ItemData.rMaxCount > 0) and (aCount > ItemData.rMaxCount)) then begin
               aCurPos := 0;
               break;
            end;
            New (p);
            FillChar (p^, sizeof (TEventItemData), 0);
            StrPCopy(@p^.rItemName, Str);
            p^.rItemCount := aCount;
            p^.rMin := aCurPos;
            p^.rMax := aCurPos + aWidth;

            FDataLists[i].Add(p);
            inc (aCurPos, aWidth);
         end;

         FMaxRangeValues[i] := aCurPos;
         DB.Free;
      end;
   end;

end;

//////////////////////////////////////////////////
//   class TTransMonsterListClass
//////////////////////////////////////////////////
constructor TTransMonsterListClass.Create;
begin
   FDataList := TList.Create;
   LoadFromFile;
end;

destructor TTransMonsterListClass.Destroy;
var
   i : integer;
begin
   Clear;
   FDataList.Free;
end;

procedure TTransMonsterListClass.Clear;
var
   i : integer;
   p : pTNameString;
begin
   for i := 0 to FDataList.Count -1 do begin
      p := FDataList.Items[i];
      dispose(p);
   end;
   FDataList.Clear;
end;

procedure TTransMonsterListClass.LoadFromFile;
var
   i : integer;
   DB : TUserStringDB;
   iName, Str : String;
   p : PTNameString;
   pMon : PTMonsterData;
begin
   Clear;

   if FileExists ('.\Event\TransMonsterList.sdb') then begin
      DB := TUserStringDB.Create;
      DB.LoadFromFile ('.\Event\TransMonsterList.sdb');

      for i := 0 to Db.Count - 1 do begin
         iName := DB.GetIndexName (i);
         if iName = '' then continue;

         New (p);
         FillChar (p^, sizeof (TNameString), 0);

         Str := DB.GetFieldValueString (iName, 'Name');

         MonsterClass.GetMonsterData(str, pMon);
         if pMon = nil then begin
            FrmMain.WriteLogInfo(Str +'MosterName doesnt exist in TransMonsterList.sdb');
            exit;
         end;

         move(pMon^.rName,p^,sizeof(TNameString));

         FDataList.Add(p);
      end;

      DB.Free;
   end;
end;

procedure TTransMonsterListClass.GetRandomMonsterName(var aMonsterName :string);
var
   nRan : integer;
   p : PTNameString;
   str : string;
begin
   aMonsterName := '';
   nRan := Random(FDataList.Count);
   p := FDataList.Items[nRan];
   if p <> nil then begin
      str := StrPas(pchar(p));
      if str = '' then exit;
      aMonsterName := str;
   end;
end;

// TBattleMap;
constructor TBattleMap.Create;
begin
   FMapid := 0;
   FPosX := 0;
   FPosY := 0;
   FGroupKey := 0;
   FMaxUser := 0;
   FDynName := '';
   FMopName := '';
   FTargetID := 0;
   FTargetX := 0;
   FTargetY := 0;
   FDieX := 0;
   FDieY := 0;

//   JoinUserList := nil;
end;

destructor TBattleMap.Destroy;
begin
//   if JoinUserList <> nil then JoinUserList.Free;
//   JoinUserList := nil;

   inherited Destroy;
end;
{
function TBattleMap.GetJoinUserCount : Integer;
begin
   Result := JoinUserList.Count;
end;

procedure TBattleMap.JoinUserChatMessage (aStr : String; aColor : Integer);
var
   i : Integer;
   User : TUser;
begin
   for i := 0 to JoinUserList.Count - 1 do begin
      User := JoinUserList.Items [i];
      User.SendClass.SendChatMessage(aStr, aColor);
   end;
end;

procedure TBattleMap.JoinUserSetActionState (aActionState : TActionState);
var
   i : Integer;
   User : TUser;
begin
   for i := 0 to JoinUserList.Count - 1 do begin
      User := JoinUserList.Items [i];
      User.SetActionState(aActionState);
   end;
end;

procedure TBattleMap.PutItembyDynName (aItemName : String);
var
   i : Integer;
   User : TUser;
begin
   for i := 0 to JoinUserList.Count - 1 do begin
      User := JoinUserList.Items [i];
      User.SPutMagicItem (aItemName, FDynName, RACE_DYNAMICOBJECT);
   end;
end;
}


// TBattleMapList;
constructor TBattleMapList.Create;
begin
   DataList := TList.Create;
   LoadFromFile ('.\Event\BattleMap.sdb');

   Position1 := nil;
   Position2 := nil;
end;

destructor TBattleMapList.Destroy;
begin
   Clear;
   DataList.Free;

   inherited Destroy; 
end;

procedure TBattleMapList.Clear;
var
   i : Integer;
   BattleMap : TBattleMap;
begin
   Position1 := nil;
   Position2 := nil;
   for i := 0 to DataList.Count - 1 do begin
      BattleMap := DataList.Items [i];
      BattleMap.Free;
   end;
   DataList.Clear;
end;

procedure TBattleMapList.LoadFromFile (aFileName : String);
var
   i : Integer;
   DB : TUserStringDB;
   iName : String;
   BattleMap : TBattleMap;
begin
   if not FileExists (aFileName) then exit;

   DB := TUserStringDB.Create;
   DB.LoadFromFile(aFileName);
   for i := 0 to DB.Count - 1 do begin
      iName := DB.GetIndexName (i);
      if iName = '' then continue;

      BattleMap := TBattleMap.Create;
      BattleMap.FMapid := DB.GetFieldValueInteger (iName, 'MapID');
      BattleMap.FPosX := DB.GetFieldValueInteger (iName, 'PosX');
      BattleMap.FPosY := DB.GetFieldValueInteger (iName, 'PosY');
      BattleMap.FGroupKey := DB.GetFieldValueInteger (iName, 'GroupKey');
      BattleMap.FMaxUser := DB.GetFieldValueInteger (iName, 'MaxUser');
      BattleMap.FDynName := DB.GetFieldValueString(iName, 'DynName');
      BattleMap.FTargetID := DB.GetFieldValueInteger(iName, 'TargetID');
      BattleMap.FTargetX := DB.GetFieldValueInteger (iName, 'TargetX');
      BattleMap.FTargetY := DB.GetFieldValueInteger (iName, 'TargetY');
      BattleMap.FDieX := DB.GetFieldValueInteger(iName, 'DieX');
      BattleMap.FDieY := DB.GetFieldValueInteger(iName, 'DieY');
      BattleMap.FGuildName := DB.GetFieldValueString(iName, 'GuildName');
      BattleMap.FMopName := DB.GetFieldValueString(iName, 'MopName'); 

      DataList.Add (BattleMap);
   end;

   DB.Free;
end;

procedure TBattleMapList.SetBattleMapData (aMapID : Integer);
var
   i : Integer;
   BattleMap : TBattleMap;
   StrList : TStringList;
begin
   Position1 := nil;
   Position2 := nil;
   StrList := TStringList.Create;

   for i := 0 to DataList.Count - 1 do begin
      BattleMap := DataList.Items [i];
      if BattleMap.FMapid = aMapID then begin
         StrList.Add (IntToStr (i)); 
      end;
   end;

   if StrList.Count >= 2 then begin
      Position1 := DataList.Items [_StrToInt (StrList.Strings [0])];
//      Position1.JoinUserList := TList.Create;
      Position2 := DataList.Items [_StrToInt (StrList.Strings [1])];
//      Position2.JoinUserList := TList.Create;
   end else begin
      FrmMain.WriteLogInfo (Format ('Event\BattleMap.SDB: MapID %d requires two teams', [aMapID]));
   end;

   StrList.Free;
end;

function TBattleMapList.DevideUser (aMapID : Integer) : TBattleMap;
begin
   Result := nil;

   if Position1 = nil then exit;
   if Position2 = nil then exit;

   if CheckSameJoinCount = true then exit;

   if Position1.JoinUserCount = Position2.JoinUserCount then begin
      inc (position1.FJoinUserCount);
      Result := position1;
   end else if Position1.JoinUserCount > Position2.JoinUserCount then begin
      inc (position2.FJoinUserCount);
      Result := Position2;
   end else if Position1.JoinUserCount < Position2.JoinUserCount then begin
      inc (position1.FJoinUserCount);   
      Result := Position1;
   end;
end;

function TBattleMapList.CheckSameJoinCount : Boolean;
begin
   Result := false;

   if Position1 = nil then exit;
   if Position2 = nil then exit;

   if (Position1.JoinUserCount = Position1.FMaxUser) and (Position2.JoinUserCount = Position2.FMaxUser) then begin
      Result := true;
   end;
end;

function TBattleMapList.GetPositionbyGuildName (aGuildName : String) : TBattleMap;
var
   i : Integer;
   BattleMap : TBattleMap;
begin
   Result := nil;

   for i := 0 to DataList.Count - 1 do begin
      BattleMap := DataList.Items [i];
      if BattleMap.FGuildName = aGuildName then begin
         Result := BattleMap;
         exit;
      end;
   end;
end;


{
procedure TBattleMapList.JoinUserChatMessage (aStr : String; aColor : Integer);
begin
   Position1.JoinUserChatMessage(aStr, aColor);
   Position2.JoinUserChatMessage(aStr, aColor);
end;

procedure TBattleMapList.JoinUserSetActionState (aActionState : TActionState);
begin
   Position1.JoinUserSetActionState(aActionState);
   Position2.JoinUserSetActionState(aActionState);
end;

procedure TBattleMapList.PutItemAndGetOut (aDynName, aItemName : String; aServerID, aTargetID, aTargetX, aTargetY : Integer);
begin
   if Position1.FDynName = aDynName then begin
      Position2.PutItembyDynName(aItemName);
      Position2.JoinUserList.Clear;
   end else if Position2.FDynName = aDynName then begin
      Position1.PutItembyDynName(aItemName);
      Position1.JoinUserList.Clear;
   end;

   UserList.MoveByServerID (aServerID, aTargetID, aTargetX, aTargetY); 
end;
}
procedure TBattleMapList.GetDiePositionbyDynName (aDynName : String; var aX, aY : Word);
begin
   if (Position1 = nil) or (Position2 = nil) then exit;
   if Position1.FDynName = aDynName then begin
      aX := Position1.FDieX;
      aY := Position1.FDieY;
   end else if Position2.FDynName = aDynName then begin
      aX := Position2.FDieX;
      aY := Position2.FDieY;
   end;
end;

procedure TBattleMapList.GetDiePositionbyGuildName (aGuildName : String; var aX, aY : Word);
var
   i : Integer;
   BattleMap : TBattleMap;
begin
   for i := 0 to DataList.Count - 1 do begin
      BattleMap := DataList.Items [i];
      if BattleMap.FGuildName = aGuildName then begin
         aX := BattleMap.FDieX;
         aY := BattleMap.FDieY;
         exit;
      end;
   end;

{
   if Position1.FGuildName = aGuildName then begin
      aX := Position1.FDieX;
      aY := Position1.FDieY;
   end else if Position2.FGuildName = aGuildName then begin
      aX := Position2.FDieX;
      aY := Position2.FDieY;
   end;
}
end;

// TRandomEventItem
constructor TRandomEventItem.Create;
begin
   ItemName := '';
   ItemCount := 0;
   TotalRandomCount := 0;
   MaxValue := 0;
end;

destructor TRandomEventItem.Destroy;
begin
   inherited Destroy; 
end;

// TRandomEventItemList;
constructor TRandomEventItemList.Create;
var
   i : Integer;
begin
   for i := 0 to 3 - 1 do begin
      DataList [i] := TList.Create;
   end;
   BeginnerQuestList := TList.Create;
   QuestList1 := TList.Create;
   QuestList2 := TList.Create;
   GoldCoinList := TList.Create;
   PickAxList := TList.Create;
   AttributePieceList := TList.Create;
   WeaponList := TList.Create;

   LoadFromFile;
end;

destructor TRandomEventItemList.Destroy;
var
   i : Integer;
begin
   Clear;

   for i := 0 to 3 - 1 do begin
      DataList [i].Free;
   end;
   BeginnerQuestList.Free;
   QuestList1.Free;
   QuestList2.Free;
   GoldCoinList.Free;
   PickAxList.Free;
   AttributePieceList.Free;
   WeaponList.Free;

   inherited Destroy;
end;

procedure TRandomEventItemList.Clear;
var
   i, j : Integer;
   RandomEventItem : TRandomEventItem;
begin
   for j := 0 to 3 - 1 do begin
      for i := 0 to DataList [j].Count - 1 do begin
         RandomEventItem := DataList [j].Items [i];
         RandomEventItem.Free;
      end;
      DataList [j].Clear;
   end;

   for i := 0 to BeginnerQuestList.Count - 1 do begin
      RandomEventItem := BeginnerQuestList.Items [i];
      RandomEventItem.Free;
   end;
   BeginnerQuestList.Clear;

   for i := 0 to QuestList1.Count - 1 do begin
      RandomEventItem := QuestList1.Items [i];
      RandomEventItem.Free;
   end;
   QuestList1.Clear;

   for i := 0 to QuestList2.Count - 1 do begin
      RandomEventItem := QuestList2.Items [i];
      RandomEventItem.Free;
   end;
   QuestList2.Clear;

   for i := 0 to GoldCoinList.Count - 1 do begin
      RandomEventItem := GoldCoinList.Items [i];
      RandomEventItem.Free;
   end;
   GoldCoinList.Clear;

   for i := 0 to PickAxList.Count - 1 do begin
      RandomEventItem := PickAxList.Items [i];
      RandomEventItem.Free;
   end;
   PickAxList.Clear;

   for i := 0 to AttributePieceList.Count - 1 do begin
      RandomEventItem := AttributePieceList.Items [i];
      RandomEventItem.Free;
   end;
   AttributePieceList.Clear;

   for i := 0 to WeaponList.Count - 1 do begin
      RandomEventItem := WeaponList.Items [i];
      RandomEventItem.Free;
   end;
   WeaponList.Clear;
end;

procedure TRandomEventItemList.LoadFromFile;
var
   DB : TUserStringDB;
   iName, FileName : String;
   i, j : Integer;
   RandomEventItem : TRandomEventItem;
begin
   for j := 0 to 4 - 1 do begin
      FileName := format ('.\Event\RandomEventItem%d.sdb', [j]);
      if FileExists (FileName) then begin
         DB := TUserStringDb.Create;
         DB.LoadFromFile(FileName);

         for i := 0 to DB.Count - 1 do begin
            iName := DB.GetIndexName(i);
            if iName = '' then continue;

            RandomEventItem := TRandomEventItem.Create;
            RandomEventItem.ItemName := DB.GetFieldValueString(iName, 'ItemName');
            RandomEventItem.Kind := DB.GetFieldValueInteger(iName, 'Kind');
            RandomEventItem.ItemCount := DB.GetFieldValueInteger(iName, 'ItemCount');
            RandomEventITem.TotalRandomCount := DB.GetFieldValueInteger (iName, 'TotalRandom');
            RandomEventItem.MaxValue := DB.GetFieldValueInteger (iName, 'MaxValue');

            DataList [j].Add (RandomEventItem);
         end;
         DB.Free;
      end;
   end;

   FileName := '.\QuestNotice\QuestItem_1stBeginnerPrize.sdb';
   if FileExists (FileName) then begin
      DB := TUserStringDb.Create;
      DB.LoadFromFile(FileName);

      for i := 0 to DB.Count - 1 do begin
         iName := DB.GetIndexName(i);
         if iName = '' then continue;

         RandomEventItem := TRandomEventItem.Create;
         RandomEventItem.ItemName := DB.GetFieldValueString(iName, 'ItemName');
         RandomEventItem.Kind := DB.GetFieldValueInteger(iName, 'Kind');
         RandomEventItem.ItemCount := DB.GetFieldValueInteger(iName, 'ItemCount');
         RandomEventITem.TotalRandomCount := DB.GetFieldValueInteger (iName, 'TotalRandom');
         RandomEventItem.MaxValue := DB.GetFieldValueInteger (iName, 'MaxValue');

         BeginnerQuestList.Add (RandomEventItem);
      end;
      DB.Free;
   end;

   FileName := '.\QuestNotice\QuestItem_1stPrize.sdb';
   if FileExists (FileName) then begin
      DB := TUserStringDb.Create;
      DB.LoadFromFile(FileName);

      for i := 0 to DB.Count - 1 do begin
         iName := DB.GetIndexName(i);
         if iName = '' then continue;

         RandomEventItem := TRandomEventItem.Create;
         RandomEventItem.ItemName := DB.GetFieldValueString(iName, 'ItemName');
         RandomEventItem.Kind := DB.GetFieldValueInteger(iName, 'Kind');
         RandomEventItem.ItemCount := DB.GetFieldValueInteger(iName, 'ItemCount');
         RandomEventITem.TotalRandomCount := DB.GetFieldValueInteger (iName, 'TotalRandom');
         RandomEventItem.MaxValue := DB.GetFieldValueInteger (iName, 'MaxValue');

         QuestList1.Add (RandomEventItem);
      end;
      DB.Free;
   end;

   FileName := '.\QuestNotice\QuestItem_2ndPrize.sdb';
   if FileExists (FileName) then begin
      DB := TUserStringDb.Create;
      DB.LoadFromFile(FileName);

      for i := 0 to DB.Count - 1 do begin
         iName := DB.GetIndexName(i);
         if iName = '' then continue;

         RandomEventItem := TRandomEventItem.Create;
         RandomEventItem.ItemName := DB.GetFieldValueString(iName, 'ItemName');
         RandomEventItem.Kind := DB.GetFieldValueInteger(iName, 'Kind');
         RandomEventItem.ItemCount := DB.GetFieldValueInteger(iName, 'ItemCount');
         RandomEventITem.TotalRandomCount := DB.GetFieldValueInteger (iName, 'TotalRandom');
         RandomEventItem.MaxValue := DB.GetFieldValueInteger (iName, 'MaxValue');

         QuestList2.Add (RandomEventItem);
      end;
      DB.Free;
   end;

   FileName := '.\QuestNotice\QuestItem_GoldCoin.sdb';
   if FileExists (FileName) then begin
      DB := TUserStringDb.Create;
      DB.LoadFromFile(FileName);

      for i := 0 to DB.Count - 1 do begin
         iName := DB.GetIndexName(i);
         if iName = '' then continue;

         RandomEventItem := TRandomEventItem.Create;
         RandomEventItem.ItemName := DB.GetFieldValueString(iName, 'ItemName');
         RandomEventItem.Kind := DB.GetFieldValueInteger(iName, 'Kind');
         RandomEventItem.ItemCount := DB.GetFieldValueInteger(iName, 'ItemCount');
         RandomEventITem.TotalRandomCount := DB.GetFieldValueInteger (iName, 'TotalRandom');
         RandomEventItem.MaxValue := DB.GetFieldValueInteger (iName, 'MaxValue');

         GoldCoinList.Add (RandomEventItem);
      end;
      DB.Free;
   end;

   FileName := '.\QuestNotice\QuestItem_PickAx.sdb';
   if FileExists (FileName) then begin
      DB := TUserStringDb.Create;
      DB.LoadFromFile(FileName);

      for i := 0 to DB.Count - 1 do begin
         iName := DB.GetIndexName(i);
         if iName = '' then continue;

         RandomEventItem := TRandomEventItem.Create;
         RandomEventItem.ItemName := DB.GetFieldValueString(iName, 'ItemName');
         RandomEventItem.Kind := DB.GetFieldValueInteger(iName, 'Kind');
         RandomEventItem.ItemCount := DB.GetFieldValueInteger(iName, 'ItemCount');
         RandomEventITem.TotalRandomCount := DB.GetFieldValueInteger (iName, 'TotalRandom');
         RandomEventItem.MaxValue := DB.GetFieldValueInteger (iName, 'MaxValue');

         PickAxList.Add (RandomEventItem);
      end;
      DB.Free;
   end;

   FileName := '.\QuestNotice\QuestItem_AttributePiece.sdb';
   if FileExists (FileName) then begin
      DB := TUserStringDb.Create;
      DB.LoadFromFile(FileName);

      for i := 0 to DB.Count - 1 do begin
         iName := DB.GetIndexName(i);
         if iName = '' then continue;

         RandomEventItem := TRandomEventItem.Create;
         RandomEventItem.ItemName := DB.GetFieldValueString(iName, 'ItemName');
         RandomEventItem.Kind := DB.GetFieldValueInteger(iName, 'Kind');
         RandomEventItem.ItemCount := DB.GetFieldValueInteger(iName, 'ItemCount');
         RandomEventITem.TotalRandomCount := DB.GetFieldValueInteger (iName, 'TotalRandom');
         RandomEventItem.MaxValue := DB.GetFieldValueInteger (iName, 'MaxValue');

         AttributePieceList.Add (RandomEventItem);
      end;
      DB.Free;
   end;

   FileName := '.\QuestNotice\QuestItem_Weapon.sdb';
   if FileExists (FileName) then begin
      DB := TUserStringDb.Create;
      DB.LoadFromFile(FileName);

      for i := 0 to DB.Count - 1 do begin
         iName := DB.GetIndexName(i);
         if iName = '' then continue;

         RandomEventItem := TRandomEventItem.Create;
         RandomEventItem.ItemName := DB.GetFieldValueString(iName, 'ItemName');
         RandomEventItem.Kind := DB.GetFieldValueInteger(iName, 'Kind');
         RandomEventItem.ItemCount := DB.GetFieldValueInteger(iName, 'ItemCount');
         RandomEventITem.TotalRandomCount := DB.GetFieldValueInteger (iName, 'TotalRandom');
         RandomEventItem.MaxValue := DB.GetFieldValueInteger (iName, 'MaxValue');

         WeaponList.Add (RandomEventItem);
      end;
      DB.Free;
   end;
end;

function TRandomEventItemList.GetItemNamebyRandom (aListNo : Integer) : String;
var
   nRandom, nPos : Integer;
   i : Integer;
   RandomEventItem : TRandomEventItem;
begin
   Result := '';

   RandomEventItem := DataList [aListNo].Items [0];
   nRandom := Random (RandomEventItem.MaxValue);

   for i := 0 to DataList [aListNo].Count - 1 do begin
      RandomEventItem := DataList [aListNo].Items [i];
      if nRandom >= RandomEventItem.TotalRandomCount then begin
      end else begin
         nPos := i;
         break;
      end;
   end;

   RandomEventItem := DataList [aListNo].Items [nPos];
   if RandomEventItem <> nil then begin
      Result := RandomEventItem.ItemName + ':' + IntToStr (RandomEventItem.ItemCount);
   end;
end;

function TRandomEventItemList.GetQuestItembyRandom (aKind : Byte) : String;
var
   nRandom, nPos : Integer;
   i : Integer;
   RandomEventItem : TRandomEventItem;
begin
   Result := '';

   case aKind of
      QUEST_BEGINNERPRIZE : begin
         RandomEventItem := BeginnerQuestList.Items [0];
         nRandom := Random (RandomEventItem.MaxValue);

         for i := 0 to BeginnerQuestList.Count - 1 do begin
            RandomEventItem := BeginnerQuestList.Items [i];
            if nRandom >= RandomEventItem.TotalRandomCount then begin
            end else begin
               nPos := i;
               break;
            end;
         end;

         RandomEventItem := BeginnerQuestList.Items [nPos];
         if RandomEventItem <> nil then begin
            Result := RandomEventItem.ItemName + ':' + IntToStr (RandomEventItem.ItemCount);
         end;
      end;
      QUEST_PRIZE1 : begin
         RandomEventItem := QuestList1.Items [0];
         nRandom := Random (RandomEventItem.MaxValue);

         for i := 0 to QuestList1.Count - 1 do begin
            RandomEventItem := QuestList1.Items [i];
            if nRandom >= RandomEventItem.TotalRandomCount then begin
            end else begin
               nPos := i;
               break;
            end;
         end;

         RandomEventItem := QuestList1.Items [nPos];
         if RandomEventItem <> nil then begin
            Result := RandomEventItem.ItemName + ':' + IntToStr (RandomEventItem.ItemCount);
         end;
      end;
      QUEST_PRIZE2 : begin
         RandomEventItem := QuestList2.Items [0];
         nRandom := Random (RandomEventItem.MaxValue);

         for i := 0 to QuestList2.Count - 1 do begin
            RandomEventItem := QuestList2.Items [i];
            if nRandom >= RandomEventItem.TotalRandomCount then begin
            end else begin
               nPos := i;
               break;
            end;
         end;

         RandomEventItem := QuestList2.Items [nPos];
         if RandomEventItem <> nil then begin
            Result := RandomEventItem.ItemName + ':' + IntToStr (RandomEventItem.ItemCount);
         end;
      end;
      QUEST_GOLDCOIN : begin
         RandomEventItem := GoldCoinList.Items [0];
         nRandom := Random (RandomEventItem.MaxValue);

         for i := 0 to GoldCoinList.Count - 1 do begin
            RandomEventItem := GoldCoinList.Items [i];
            if nRandom >= RandomEventItem.TotalRandomCount then begin
            end else begin
               nPos := i;
               break;
            end;
         end;

         RandomEventItem := GoldCoinList.Items [nPos];
         if RandomEventItem <> nil then begin
            Result := RandomEventItem.ItemName + ':' + IntToStr (RandomEventItem.ItemCount);
         end;
      end;
      QUEST_PICKAX : begin
         RandomEventItem := PickAxList.Items [0];
         nRandom := Random (RandomEventItem.MaxValue);

         for i := 0 to PickAxList.Count - 1 do begin
            RandomEventItem := PickAxList.Items [i];
            if nRandom >= RandomEventItem.TotalRandomCount then begin
            end else begin
               nPos := i;
               break;
            end;
         end;

         RandomEventItem := PickAxList.Items [nPos];
         if RandomEventItem <> nil then begin
            Result := RandomEventItem.ItemName + ':' + IntToStr (RandomEventItem.ItemCount);
         end;
      end;
      QUEST_ATTRIBUTEPIECE : begin
         RandomEventItem := AttributePieceList.Items [0];
         nRandom := Random (RandomEventItem.MaxValue);

         for i := 0 to AttributePieceList.Count - 1 do begin
            RandomEventItem := AttributePieceList.Items [i];
            if nRandom >= RandomEventItem.TotalRandomCount then begin
            end else begin
               nPos := i;
               break;
            end;
         end;

         RandomEventItem := AttributePieceList.Items [nPos];
         if RandomEventItem <> nil then begin
            Result := RandomEventItem.ItemName + ':' + IntToStr (RandomEventItem.ItemCount);
         end;
      end;
      QUEST_WEAPON : begin
         RandomEventItem := WeaponList.Items [0];
         nRandom := Random (RandomEventItem.MaxValue);

         for i := 0 to WeaponList.Count - 1 do begin
            RandomEventItem := WeaponList.Items [i];
            if nRandom >= RandomEventItem.TotalRandomCount then begin
            end else begin
               nPos := i;
               break;
            end;
         end;

         RandomEventItem := WeaponList.Items [nPos];
         if RandomEventItem <> nil then begin
            Result := RandomEventItem.ItemName + ':' + IntToStr (RandomEventItem.ItemCount);
         end;
      end;
      Else begin

      end;
   end;
end;



//////////////////////////////////////////////////
// TNameClass;
//////////////////////////////////////////////////

constructor TNameClass.Create;
begin
   NameDataList := TList.Create;
   ReLoadFromFile;
end;

destructor TNameClass.Destroy;
begin
   Clear;
   NameDataList.Free;

   inherited Destroy;
end;

procedure TNameClass.Clear;
var
   i : Integer;
   pNameData : PTNameData;
begin
   for i := 0 to NameDataList.Count - 1 do begin
      pNameData := NameDataList.Items[i];
      dispose (pNameData);
   end;
   NameDataList.Clear;
end;

function TNameClass.GetCount : Integer;
begin
   Result := NameDataList.Count;
end;

procedure TNameClass.ReLoadFromFile;
var
   i : Integer;
   DB : TUserStringDB;
   iName : String;
   pNameData : PTNameData;
begin
   if FileExists ('.\Event\NameList.SDB') then begin
      Clear;
      DB := TUserStringDB.Create;
      DB.LoadFromFile ('.\EtcSetting\NameList.SDB');
      for i := 0 to Db.Count - 1 do begin
         iName := DB.GetIndexName (i);
         if iName = '' then continue;
         New (pNameData);
         FillChar (pNameData^, sizeof (TNameData), 0);

         pNameData^.rGuildName := DB.GetFieldValueString (iName, 'GuildName');
         pNameData^.rCharName := DB.GetFieldValueString (iName, 'CharName');
         pNameData^.rUserType := DB.GetFieldValueInteger (iName, 'UserType');

         NameDataList.Add (pNameData);
      end;
      DB.Free;
   end;
end;

function TNameClass.SearchNameList (aGuildName, aCharName : String) : Boolean;
var
   i : Integer;
   pNameData : PTNameData;
   Str, Dest, GuildName, CharName : String;
begin
   Result := false;
   if (aCharName = '') or (aGuildName = '') then exit;

   for i := 0 to NameDataList.Count - 1 do begin
      pNameData := NameDataList.Items[i];
      if pNameData = nil then continue;
      if (pNameData^.rGuildName = aGuildName) and (pNameData^.rCharName = aCharName) then begin
         Result := true;
         exit;
      end;
   end;
end;

function TNameClass.DelNameList (aGuildName, aCharName : String) : Boolean;
var
   i : Integer;
   pNameData : PTNameData;
   Str, Dest, GuildName, CharName : String;
begin
   Result := false;

   if (aCharName = '') or (aGuildName = '') then exit;
   for i := NameDataList.Count - 1 downto 0 do begin
      pNameData := NameDataList.Items[i];
      if pNameData = nil then continue;
      
      if (pNameData^.rGuildName = aGuildName) and (pNameData^.rCharName = aCharName) then begin
         dispose (pNameData);
         NameDataList.Delete(i);
         Result := true;
         exit;
      end;
   end;
end;



//////////////////////////////////////////////////

//////////////////////////////////////////////////
// TMarryClass;
//////////////////////////////////////////////////

constructor TMarryClass.Create;
begin
   FMarryList := TList.Create;
   LoadFromFile;
end;

destructor TMarryClass.Destroy;
begin
   SaveToFile;
   Clear;
   FMarryList.Free;

   inherited Destroy;
end;

procedure TMarryClass.Clear;
var
   i : Integer;
   pMarry : PTMarry;
begin
   for i := 0 to FMarryList.Count - 1 do begin
      pMarry := FMarryList.Items[i];
      dispose (pMarry);
   end;
   FMarryList.Clear;
end;

procedure TMarryClass.AddMarry(Boy,Girl : String);
var
    pMarry : PTMarry;
    i:integer;
begin
    new(pMarry);
    pMarry^.Girl := Girl;
    pMarry^.Boy := Boy;
    pMarry^.Party := False;
    pMarry^.BoyClothes := False;
    pMarry^.GirlClothes := False;
    pMarry^.MarryDate := Now;
    pMarry^.UnMarry  := False;
    pMarry^.UnMarryDate := Now;
    FMarryList.Add(pMarry);
end;

procedure TMarryClass.UnMarry(aName :String);
var
    pMarry : PTMarry;
    i:integer;
begin
    for i := 0 to FMarryList.Count - 1 do begin
        pMarry := FMarryList.Items[i];
        if (pMarry^.Girl = aName) or (pMarry^.Boy = aName) then begin
          if pMarry^.UnMarry then Begin
            Break;
          end;
          pMarry^.UnMarry := True;
          pMarry^.UnMarryDate := Now + 7;
          Break;
        end;
    end;
end;


procedure TMarryClass.UnMarryNow(aName :String);
var
    pMarry : PTMarry;
    i:integer;
begin
    for i := 0 to FMarryList.Count - 1 do begin
        pMarry := FMarryList.Items[i];
        if (pMarry^.Girl = aName) or (pMarry^.Boy = aName) then begin
            Dispose(pMarry);
            FMarryList.Delete(i);
            Break;
        end;
    end;
end;

function TMarryClass.DelMarryInfo(aName :String) : Boolean;
var
    pMarry : PTMarry;
    i:integer;
begin
    result := False;
    for i := 0 to FMarryList.Count - 1 do begin
        pMarry := FMarryList.Items[i];
        if (pMarry^.UnMarry) and (Now - pMarry^.UnMarryDate >= 7) then begin
            if pMarry^.Girl = aName then begin
                pMarry^.GirlUnMarry := True;
                if pMarry^.BoyUnMarry then begin
                    Dispose(pMarry);
                    FMarryList.Delete(i);
                end;
                Result := True;
                Exit;
            end;
            if pMarry^.Boy = aName then begin
                pMarry^.BoyUnMarry := True;
                if pMarry^.GirlUnMarry then begin
                    Dispose(pMarry);
                    FMarryList.Delete(i);
                end;
                Result := True;
                Exit;
            end;
        end;
    end;
end;

function TMarryClass.isParty(aName :String) : Boolean;
var
    pMarry : PTMarry;
    i:integer;
begin
    result := False;
    for i := 0 to FMarryList.Count - 1 do begin
        pMarry := FMarryList.Items[i];
        if (pMarry^.Girl = aName) or (pMarry^.Boy = aName) then begin
            Result := pMarry^.Party;
            Break;
        end;
    end;
end;

function TMarryClass.isClothes(aName :String) : Boolean;
var
    pMarry : PTMarry;
    i:integer;
begin
    result := False;
    for i := 0 to FMarryList.Count - 1 do begin
        pMarry := FMarryList.Items[i];
        if pMarry^.Girl = aName then begin
            Result := pMarry^.GirlClothes;
            Exit;
        end;
        if pMarry^.Boy = aName then begin
            Result := pMarry^.BoyClothes;
            Exit;
        end;
    end;
end;

procedure TMarryClass.SetParty(aName :String);
var
    pMarry : PTMarry;
    i:integer;
begin
    for i := 0 to FMarryList.Count - 1 do begin
        pMarry := FMarryList.Items[i];
        if (pMarry^.Girl = aName) or (pMarry^.Boy = aName) then begin
            pMarry^.Party := True;
            Break;
        end;
    end;
end;

procedure TMarryClass.SetClothes(aName :String);
var
    pMarry : PTMarry;
    i:integer;
begin
    for i := 0 to FMarryList.Count - 1 do begin
        pMarry := FMarryList.Items[i];
        if pMarry^.Girl = aName then begin
            pMarry^.GirlClothes := True;
            Exit;
        end;
        if pMarry^.Boy = aName then begin
            pMarry^.BoyClothes := True;
            Exit;
        end;
    end;
end;


{function TMarryClass.GetCount : Integer;
begin
   Result := FMarryList.Count;
end;}

procedure TMarryClass.LoadFromFile;
var
   i : Integer;
   DB : TUserStringDB;
   iName : String;
   pMarry : PTMarry;
begin
if Not FileExists ('.\Event\Marry.SDB') then Exit;
  DB := TUserStringDB.Create;
  DB.LoadFromFile ('.\Event\Marry.SDB');
  for i := 0 to Db.Count - 1 do begin
     iName := DB.GetIndexName (i);
     if iName = '' then continue;
     New (pMarry);
     FillChar (pMarry^, sizeof (pMarry), 0);

     pMarry^.Girl := DB.GetFieldValueString (iName, 'Girl');
     pMarry^.Boy := DB.GetFieldValueString (iName, 'Boy');
     pMarry^.GirlClothes := DB.GetFieldValueBoolean (iName, 'GirlClothes');
     pMarry^.BoyClothes := DB.GetFieldValueBoolean (iName, 'BoyClothes');
     pMarry^.Party := DB.GetFieldValueBoolean (iName, 'Party');
     pMarry^.MarryDate := StrToDateTime(DB.GetFieldValueString (iName, 'MarryDate'));
     pMarry^.UnMarry := DB.GetFieldValueBoolean (iName, 'UnMarry');
     pMarry^.UnMarryDate := StrToDateTime(DB.GetFieldValueString (iName, 'UnMarryDate'));
     pMarry^.BoyUnMarry := DB.GetFieldValueBoolean (iName, 'BoyUnMarry');
     pMarry^.GirlUnMarry := DB.GetFieldValueBoolean (iName, 'GirlUnMarry');

     FMarryList.Add (pMarry);
  end;
  DB.Free;

end;

procedure TMarryClass.SaveToFile;
var
   i : Integer;
   iName : String;
   StringList : TStringList;
   p : PTMarry;
   Str :String;
begin
      StringList := TStringList.Create;
      str := 'Girl,Boy,Party,GirlClothes,BoyClothes,MarryDate,UnMarry,UnMarryDate,BoyUnMarry,GirlUnMarry';
      StringList.add (str);
      for i := 0 to FMarryList.Count -1 do begin
         p := FMarryList[i];
         str := p^.Girl + ',' + p^.Boy + ',' +  UpperCase(BoolToStr (p^.Party,true))+ ',' + UpperCase(BoolToStr (p^.GirlClothes,true))+ ',' + UpperCase(BoolToStr (p^.BoyClothes,true))  + ',' + FormatDateTime('YYYY-MM-DD HH:MM:SS',p^.MarryDate)+ ',' + UpperCase(BoolToStr (p^.UnMarry,true)) + ','  + FormatDateTime('YYYY-MM-DD HH:MM:SS',p^.MarryDate) + ',' + UpperCase(BoolToStr (p^.BoyUnMarry,true)) + ',' + UpperCase(BoolToStr (p^.GirlUnMarry,true));
         StringList.Add (str);
      end;
      StringList.SaveToFile ('.\Event\Marry.SDB');
      StringList.Free;
end;

function TMarryClass.Search (aName: String) : PTMarry;
var
   i : Integer;
   pMarry : PTMarry;
   Str, Dest, GuildName, CharName : String;
begin
   Result := nil;
   if (aName = '') then exit;

   for i := 0 to FMarryList.Count - 1 do begin
      pMarry := FMarryList.Items[i];
      if (pMarry^.Boy = aName) and (pMarry^.Girl = aName) then begin
         Result := pMarry;
         exit;
      end;
   end;
end;

{
function TNameClass.DelNameList (aGuildName, aCharName : String) : Boolean;
var
   i : Integer;
   pNameData : PTNameData;
   Str, Dest, GuildName, CharName : String;
begin
   Result := false;

   if (aCharName = '') or (aGuildName = '') then exit;
   for i := NameDataList.Count - 1 downto 0 do begin
      pNameData := NameDataList.Items[i];
      if pNameData = nil then continue;

      if (pNameData^.rGuildName = aGuildName) and (pNameData^.rCharName = aCharName) then begin
         dispose (pNameData);
         NameDataList.Delete(i);
         Result := true;
         exit;
      end;
   end;
end;
}
//////////////////////////////////////////////////

procedure LoadGameIni (aName: string);
var
   ini: TIniFile;
begin
   ini := TIniFile.Create (aName);

   INI_WHO             := ini.ReadString ('STRINGS','WHO','/WHO');
   INI_SERCHSKILL      := ini.ReadString ('STRINGS','SERCHSKILL','@SERCHSKILL');
   INI_SERCHENABLE     := ini.ReadString ('STRINGS','SERCHENABLE','@SERCHENABLE');
   INI_SERCHUNABLE     := ini.ReadString ('STRINGS','SERCHUNABLE','@SERCHUNABLE');
   INI_WHITEDRUG       := ini.ReadString ('STRINGS','WHITEDRUG','WHITEDRUG');
   INI_ROPE            := ini.ReadString ('STRINGS','ROPE','ROPE');
   INI_SEX_FIELD_MAN   := ini.ReadString ('STRINGS','SEX_FIELD_MAN','MAN');
   INI_SEX_FIELD_WOMAN := ini.ReadString ('STRINGS','SEX_FIELD_WOMAN','WOMAN');
   INI_GUILD_STONE     := ini.ReadString ('STRINGS','GUILD_STONE','GUILDSTONE');
   INI_GUILD_NPCMAN_NAME := ini.ReadString ('STRINGS','GUILD_NPCMAN_NAME','NPCMAN');
   INI_GUILD_NPCWOMAN_NAME := ini.ReadString ('STRINGS','GUILD_NPCWOMAN_NAME','NPCWOMAN');
   INI_GUILD_NPCWHITE_NAME := ini.ReadString ('STRINGS','GUILD_NPCWHITE_NAME','NPCWHITE');
   INI_GUILD_NPCBLACK_NAME := ini.ReadString ('STRINGS','GUILD_NPCBLACK_NAME','NPCBLACK');
   INI_GOLD            := ini.ReadString ('STRINGS','GOLD','GOLD');
   // add by Orber at 2004-09-10 11:26
   INI_ITEMUNLOCKTIME  := ini.ReadInteger ('ITEM_VALUES','ITEM_UNLOCKTIME', 60);

   INI_Guild_MAN_SEX           := ini.ReadString ('GUILD_NPC_WEAR','GUILD_MAN_SEX','MAN');
   INI_Guild_MAN_CAP           := ini.ReadString ('GUILD_NPC_WEAR','GUILD_MAN_CAP','');
   INI_Guild_MAN_HAIR          := ini.ReadString ('GUILD_NPC_WEAR','GUILD_MAN_HAIR','');
   INI_GUILD_MAN_UPUNDERWEAR   := ini.ReadString ('GUILD_NPC_WEAR','GUILD_MAN_UPUNDERWEAR','');
   INI_Guild_MAN_UPOVERWEAR    := ini.ReadString ('GUILD_NPC_WEAR','GUILD_MAN_UPOVERWEAR','');
   INI_Guild_MAN_DOWNUNDERWEAR := ini.ReadString ('GUILD_NPC_WEAR','GUILD_MAN_DOWNUNDERWEAR','');
   INI_Guild_MAN_GLOVES        := ini.ReadString ('GUILD_NPC_WEAR','GUILD_MAN_GLOVES','');
   INI_Guild_MAN_SHOES         := ini.ReadString ('GUILD_NPC_WEAR','GUILD_MAN_SHOES','');
   INI_Guild_MAN_WEAPON        := ini.ReadString ('GUILD_NPC_WEAR','GUILD_MAN_WEAPON','');

   INI_Guild_WOMAN_SEX           := ini.ReadString ('GUILD_NPC_WEAR','GUILD_WOMAN_SEX','WOMAN');
   INI_Guild_WOMAN_CAP           := ini.ReadString ('GUILD_NPC_WEAR','GUILD_WOMAN_CAP','');
   INI_Guild_WOMAN_HAIR          := ini.ReadString ('GUILD_NPC_WEAR','GUILD_WOMAN_HAIR','');
   INI_GUILD_WOMAN_UPUNDERWEAR   := ini.ReadString ('GUILD_NPC_WEAR','GUILD_WOMAN_UPUNDERWEAR','');
   INI_Guild_WOMAN_UPOVERWEAR    := ini.ReadString ('GUILD_NPC_WEAR','GUILD_WOMAN_UPOVERWEAR','');
   INI_Guild_WOMAN_DOWNUNDERWEAR := ini.ReadString ('GUILD_NPC_WEAR','GUILD_WOMAN_DOWNUNDERWEAR','');
   INI_Guild_WOMAN_GLOVES        := ini.ReadString ('GUILD_NPC_WEAR','GUILD_WOMAN_GLOVES','');
   INI_Guild_WOMAN_SHOES         := ini.ReadString ('GUILD_NPC_WEAR','GUILD_WOMAN_SHOES','');
   INI_Guild_WOMAN_WEAPON        := ini.ReadString ('GUILD_NPC_WEAR','GUILD_WOMAN_WEAPON','');


   INI_DEF_WRESTLING   := ini.ReadString ('DEFAULT_MAGIC','DEF_WRESTLING','WRESTLING');
   INI_DEF_FENCING     := ini.ReadString ('DEFAULT_MAGIC','DEF_FENCING','FENCING');
   INI_DEF_SWORDSHIP   := ini.ReadString ('DEFAULT_MAGIC','DEF_SWORDSHIP','SWORDSHIP');
   INI_DEF_HAMMERING   := ini.ReadString ('DEFAULT_MAGIC','DEF_HAMMERING','HAMMERING');
   INI_DEF_SPEARING    := ini.ReadString ('DEFAULT_MAGIC','DEF_SPEARING','SPEARING');
   INI_DEF_BOWING      := ini.ReadString ('DEFAULT_MAGIC','DEF_BOWING','BOWING');
   INI_DEF_THROWING    := ini.ReadString ('DEFAULT_MAGIC','DEF_THROWING','THROWING');
   INI_DEF_RUNNING     := ini.ReadString ('DEFAULT_MAGIC','DEF_RUNNING','RUNNING');
   INI_DEF_BREATHNG    := ini.ReadString ('DEFAULT_MAGIC','DEF_BREATHNG','BREATHNG');
   INI_DEF_PROTECTING  := ini.ReadString ('DEFAULT_MAGIC','DEF_PROTECTING','PROTECTING');

   INI_DEF_WRESTLING2   := ini.ReadString ('DEFAULT_MAGIC','DEF_WRESTLING2','WRESTLING2');
   INI_DEF_FENCING2     := ini.ReadString ('DEFAULT_MAGIC','DEF_FENCING2','FENCING2');
   INI_DEF_SWORDSHIP2   := ini.ReadString ('DEFAULT_MAGIC','DEF_SWORDSHIP2','SWORDSHIP2');
   INI_DEF_HAMMERING2   := ini.ReadString ('DEFAULT_MAGIC','DEF_HAMMERING2','HAMMERING2');
   INI_DEF_SPEARING2    := ini.ReadString ('DEFAULT_MAGIC','DEF_SPEARING2','SPEARING2');
   INI_DEF_BOWING2      := ini.ReadString ('DEFAULT_MAGIC','DEF_BOWING2','BOWING2');
   INI_DEF_THROWING2    := ini.ReadString ('DEFAULT_MAGIC','DEF_THROWING2','THROWING2');
   INI_DEF_RUNNING2     := ini.ReadString ('DEFAULT_MAGIC','DEF_RUNNING2','RUNNING2');
   INI_DEF_BREATHNG2    := ini.ReadString ('DEFAULT_MAGIC','DEF_BREATHNG2','BREATHNG2');
   INI_DEF_PROTECTING2  := ini.ReadString ('DEFAULT_MAGIC','DEF_PROTECTING2','PROTECTING2');

   INI_NORTH     := ini.ReadString ('DIRECTION_NAMES','NORTH','NORTH');
   INI_NORTHEAST := ini.ReadString ('DIRECTION_NAMES','NORTHEAST','NORTHEAST');
   INI_EAST      := ini.ReadString ('DIRECTION_NAMES','EAST','EAST');
   INI_EASTSOUTH := ini.ReadString ('DIRECTION_NAMES','EASTSOUTH','EASTSOUTH');
   INI_SOUTH     := ini.ReadString ('DIRECTION_NAMES','SOUTH','SOUTH');
   INI_SOUTHWEST := ini.ReadString ('DIRECTION_NAMES','SOUTHWEST','SOUTHWEST');
   INI_WEST      := ini.ReadString ('DIRECTION_NAMES','WEST','WEST');
   INI_WESTNORTH := ini.ReadString ('DIRECTION_NAMES','WESTNORTH','WESTNORTH');

   INI_HIDEPAPER_DELAY := ini.Readinteger ('ITEM_VALUES','HIDEPAPER_DELAY', 15);
   INI_SHOWPAPER_DELAY := ini.Readinteger ('ITEM_VALUES','SHOWPAPER_DELAY', 60);

   // 扁夯公傍
   INI_MAGIC_DIV_VALUE     := ini.Readinteger ('MAGIC_VALUES','MAGIC_DIV_VALUE', 10);
   INI_ADD_DAMAGE          := ini.Readinteger ('MAGIC_VALUES','ADD_DAMAGE', 40);
   INI_MUL_ATTACKSPEED     := ini.Readinteger ('MAGIC_VALUES','MUL_ATTACKSPEED', 10);
   INI_MUL_AVOID           := ini.Readinteger ('MAGIC_VALUES','MUL_AVOID',6);
   INI_MUL_RECOVERY        := ini.Readinteger ('MAGIC_VALUES','MUL_RECOVERY',10);
   INI_MUL_ACCURACY        := ini.ReadInteger ('MAGIC_VALUES','MUL_ACCURACY',0);
   INI_MUL_KEEPRECOVERY    := ini.ReadInteger ('MAGIC_VALUES','MUL_KEEPRECOVERY',0);
   INI_MUL_DAMAGEBODY      := ini.Readinteger ('MAGIC_VALUES','MUL_DAMAGEBODY',23);
   INI_MUL_DAMAGEHEAD      := ini.Readinteger ('MAGIC_VALUES','MUL_DAMAGEHEAD',17);
   INI_MUL_DAMAGEARM       := ini.Readinteger ('MAGIC_VALUES','MUL_DAMAGEARM',17);
   INI_MUL_DAMAGELEG       := ini.Readinteger ('MAGIC_VALUES','MUL_DAMAGELEG',17);
   INI_MUL_ARMORBODY       := ini.Readinteger ('MAGIC_VALUES','MUL_ARMORBODY',7);
   INI_MUL_ARMORHEAD       := ini.Readinteger ('MAGIC_VALUES','MUL_ARMORHEAD',7);
   INI_MUL_ARMORARM        := ini.Readinteger ('MAGIC_VALUES','MUL_ARMORARM',7);
   INI_MUL_ARMORLEG        := ini.Readinteger ('MAGIC_VALUES','MUL_ARMORLEG',7);

   INI_MUL_EVENTENERGY     := ini.Readinteger ('MAGIC_VALUES','MUL_EVENTENERGY',20);
   INI_MUL_EVENTINPOWER    := ini.Readinteger ('MAGIC_VALUES','MUL_EVENTINPOWER',22);
   INI_MUL_EVENTOUTPOWER   := ini.Readinteger ('MAGIC_VALUES','MUL_EVENTOUTPOWER',22);
   INI_MUL_EVENTMAGIC      := ini.Readinteger ('MAGIC_VALUES','MUL_EVENTMAGIC',10);
   INI_MUL_EVENTLIFE       := ini.Readinteger ('MAGIC_VALUES','MUL_EVENTLIFE',8);

   INI_MUL_5SECENERGY      := ini.Readinteger ('MAGIC_VALUES','MUL_5SECENERGY',20);
   INI_MUL_5SECINPOWER     := ini.Readinteger ('MAGIC_VALUES','MUL_5SECINPOWER',14);
   INI_MUL_5SECOUTPOWER    := ini.Readinteger ('MAGIC_VALUES','MUL_5SECOUTPOWER',14);
   INI_MUL_5SECMAGIC       := ini.Readinteger ('MAGIC_VALUES','MUL_5SECMAGIC',9);
   INI_MUL_5SECLIFE        := ini.Readinteger ('MAGIC_VALUES','MUL_5SECLIFE',8);

   INI_SKILL_DIV_DAMAGE      := ini.Readinteger ('MAGIC_VALUES','SKILL_DIV_DAMAGE',5000);
   INI_SKILL_DIV_ARMOR       := ini.Readinteger ('MAGIC_VALUES','SKILL_DIV_ARMOR', 5000);
   INI_SKILL_DIV_ATTACKSPEED := ini.Readinteger ('MAGIC_VALUES','SKILL_DIV_ATTACKSPEED', 25000);
   INI_SKILL_DIV_EVENT       := ini.Readinteger ('MAGIC_VALUES','SKILL_DIV_EVENT', 5000);

   // 惑铰公傍
   INI_MAGIC_DIV_VALUE2     := ini.Readinteger ('RISEMAGIC_VALUES','MAGIC_DIV_VALUE', 10);
   INI_ADD_DAMAGE2          := ini.Readinteger ('RISEMAGIC_VALUES','ADD_DAMAGE', 40);
   INI_MUL_ATTACKSPEED2     := ini.Readinteger ('RISEMAGIC_VALUES','MUL_ATTACKSPEED', 10);
   INI_MUL_AVOID2           := ini.Readinteger ('RISEMAGIC_VALUES','MUL_AVOID',6);
   INI_MUL_RECOVERY2        := ini.Readinteger ('RISEMAGIC_VALUES','MUL_RECOVERY',10);
   INI_MUL_ACCURACY2        := ini.ReadInteger ('RISEMAGIC_VALUES','MUL_ACCURACY',6);
   INI_MUL_KEEPRECOVERY2    := ini.ReadInteger ('RISEMAGIC_VALUES','MUL_KEEPRECOVERY',5);
   INI_MUL_DAMAGEBODY2      := ini.Readinteger ('RISEMAGIC_VALUES','MUL_DAMAGEBODY',23);
   INI_MUL_DAMAGEHEAD2      := ini.Readinteger ('RISEMAGIC_VALUES','MUL_DAMAGEHEAD',17);
   INI_MUL_DAMAGEARM2       := ini.Readinteger ('RISEMAGIC_VALUES','MUL_DAMAGEARM',17);
   INI_MUL_DAMAGELEG2       := ini.Readinteger ('RISEMAGIC_VALUES','MUL_DAMAGELEG',17);
   INI_MUL_ARMORBODY2       := ini.Readinteger ('RISEMAGIC_VALUES','MUL_ARMORBODY',7);
   INI_MUL_ARMORHEAD2       := ini.Readinteger ('RISEMAGIC_VALUES','MUL_ARMORHEAD',8);
   INI_MUL_ARMORARM2        := ini.Readinteger ('RISEMAGIC_VALUES','MUL_ARMORARM',8);
   INI_MUL_ARMORLEG2        := ini.Readinteger ('RISEMAGIC_VALUES','MUL_ARMORLEG',8);

   INI_MUL_EVENTENERGY2     := ini.Readinteger ('RISEMAGIC_VALUES','MUL_EVENTENERGY',20);
   INI_MUL_EVENTINPOWER2    := ini.Readinteger ('RISEMAGIC_VALUES','MUL_EVENTINPOWER',22);
   INI_MUL_EVENTOUTPOWER2   := ini.Readinteger ('RISEMAGIC_VALUES','MUL_EVENTOUTPOWER',22);
   INI_MUL_EVENTMAGIC2      := ini.Readinteger ('RISEMAGIC_VALUES','MUL_EVENTMAGIC',10);
   INI_MUL_EVENTLIFE2       := ini.Readinteger ('RISEMAGIC_VALUES','MUL_EVENTLIFE',8);

   INI_MUL_5SECENERGY2      := ini.Readinteger ('RISEMAGIC_VALUES','MUL_5SECENERGY',20);
   INI_MUL_5SECINPOWER2     := ini.Readinteger ('RISEMAGIC_VALUES','MUL_5SECINPOWER',14);
   INI_MUL_5SECOUTPOWER2    := ini.Readinteger ('RISEMAGIC_VALUES','MUL_5SECOUTPOWER',14);
   INI_MUL_5SECMAGIC2       := ini.Readinteger ('RISEMAGIC_VALUES','MUL_5SECMAGIC',9);
   INI_MUL_5SECLIFE2        := ini.Readinteger ('RISEMAGIC_VALUES','MUL_5SECLIFE',8);

   INI_SKILL_DIV_DAMAGE2       := ini.Readinteger ('RISEMAGIC_VALUES','SKILL_DIV_DAMAGE',5000);
   INI_SKILL_DIV_ARMOR2        := ini.Readinteger ('RISEMAGIC_VALUES','SKILL_DIV_ARMOR', 5000);
   INI_SKILL_DIV_ATTACKSPEED2  := ini.Readinteger ('RISEMAGIC_VALUES','SKILL_DIV_ATTACKSPEED', 25000);
   INI_SKILL_DIV_RECOVERY2     := ini.ReadInteger ('RISEMAGIC_VALUES','SKILL_DIV_RECOVERY', 25000);
   INI_SKILL_DIV_AVOID2        := ini.ReadInteger ('RISEMAGIC_VALUES','SKILL_DIV_AVOID', 25000);
   INI_SKILL_DIV_ACCURACY2     := ini.ReadInteger ('RISEMAGIC_VALUES','SKILL_DIV_ACCURACY', 25000);
   INI_SKILL_DIV_KEEPRECOVERY2 := ini.ReadInteger ('RISEMAGIC_VALUES','SKILL_DIV_KEEPRECOVERY', 25000);
   INI_SKILL_DIV_EVENT2        := ini.Readinteger ('RISEMAGIC_VALUES','SKILL_DIV_EVENT', 5000);

   INI_SKILL_ADD_BASESKILL    := ini.Readinteger ('RISEMAGIC_VALUES','SKILL_ADD_BASESKILL',5000);

   // 扁贱
   INI_DEF_ALCHEMIST       := ini.ReadString ('JOB_SYSTEM', 'DEF_ALCHEMIST', 'ALCHEMIST');
   INI_DEF_CHEMIST         := ini.ReadString ('JOB_SYSTEM', 'DEF_CHEMIST', 'CHEMIST');
   INI_DEF_DESIGNER        := ini.ReadString ('JOB_SYSTEM', 'DEF_DESIGNER', 'DESIGNER');
   INI_DEF_CRAFTSMAN       := ini.ReadString ('JOB_SYSTEM', 'DEF_CRAFTSMAN', 'DRAFTSMAN');

   INI_DEF_NAMELESSWORKER  := ini.ReadString ('JOB_SYSTEM', 'DEF_NAMELESSWORKER', 'NAMELESSWORKER');
   INI_DEF_TECHNICIAN      := ini.ReadString ('JOB_SYSTEM', 'DEF_TECHNICIAN', 'TECHNICIAN');
   INI_DEF_SKILLEDWORKER   := ini.ReadString ('JOB_SYSTEM', 'DEF_SKILLEDWORKER', 'SKILLEDWORKER');
   INI_DEF_EXPERT          := ini.ReadString ('JOB_SYSTEM', 'DEF_EXPERT', 'EXPERT');
   INI_DEF_MASTER          := ini.ReadString ('JOB_SYSTEM', 'DEF_MASTER', 'MASTER');
   INI_DEF_VIRTUEMAN      := ini.ReadString ('JOB_SYSTEM', 'DEF_VIRTUEMAN', 'VIRTUEMAN');

   INI_DEF_ITEMPROCESS1    := ini.ReadString ('JOB_SYSTEM', 'DEF_ITEMPROCESS1', 'ITEMPROCESS1');
   INI_DEF_ITEMPROCESS2    := ini.ReadString ('JOB_SYSTEM', 'DEF_ITEMPROCESS2', 'ITEMPROCESS2');
   INI_DEF_ITEMPROCESS3    := ini.ReadString ('JOB_SYSTEM', 'DEF_ITEMPROCESS3', 'ITEMPROCESS3');
   INI_DEF_ITEMPROCESS4    := ini.ReadString ('JOB_SYSTEM', 'DEF_ITEMPROCESS4', 'ITEMPROCESS4');

   ini.free;
end;

//Author:Steven Date: 2005-01-31 17:34:46
//Note:采集技能
function TJobClass.GetExtJobLevel(aExp: Integer): Integer;
var
   i: Integer;
begin
   for i := 0 to JOB_GRADE_MAX - 1 do
   begin
      with JobGradeData[i] do
      begin
         if (aExp >= Miner_SExp) and ( Miner_EExp = -1) then
         begin
           Result := 9999;
           Exit;
         end;
         if (aExp >= Miner_SExp) and (aExp <= Miner_EExp) then
         begin
            Result := Miner_SLevel + Round((aExp - Miner_SExp) / (Miner_EExp - Miner_SExp) *
               (Miner_ELevel - Miner_SLevel));
         end;
      end;
   end;
end;
//======================================

function TJobClass.GetExtJobGradeName(aExp: Integer): String;
var
   Level: Integer;
   i: Integer;
begin
   if aExp < 1 then
   begin
     Result := '';
     Exit;
   end;
   Level := GetExtJobLevel(aExp);
   for i := 0 to JOB_GRADE_MAX - 1 do
   begin
      with JobGradeData[i] do
      begin
        if (Level <= Miner_ELevel) and (Level >= Miner_SLevel) then
        begin
           Result := JobGradeData[i].Name;
        end;
      end;
   end;
end;

Initialization
begin
   TipStrList := TStringList.Create;

   NameStringListForDeleteMagic := TStringList.Create;
   RejectNameList := TStringList.Create;
   RejectNameList.LoadFromFile ('.\DontChar.TXT');

   SystemAlert := TSystemAlert.Create;
   NpcFunction := TNpcFunction.Create;
   PrisonClass := TPrisonClass.Create;
   Randomize; //酒捞袍 犬伏捞 绊沥等捞蜡看澜.
   RandomClass := TRandomClass.Create;
   QuestClass := TQuestClass.Create;
   QuestSummaryClass := TQuestSummaryClass.Create;
   AreaClass := TAreaClass.Create;
   PosByDieClass := TPosByDieClass.Create;
   SysopClass := TSysopclass.Create;
   LoadGameIni ('.\game.ini');
   NpcClass := TNpcClass.Create;
   ItemMaterialClass := TItemMaterialClass.Create;
   ItemClass := TItemClass.Create;
   JobClass := TJobClass.Create;
   DynamicObjectClass := TDynamicObjectClass.Create;
   MineObjectClass := TMineObjectClass.Create;
   ItemDrugClass := TItemDrugClass.Create;
   MagicClass := TMagicClass.Create;
   MagicParamClass := TMagicParamClass.Create;
   MonsterClass := TMonsterClass.Create;
   ItemLog := TItemLog.Create;
   HelpFiles := THelpFiles.Create;
   MacroReport := TMacroReport.Create;
   QuizSystem := TQuizSystem.Create;
   AddAttribClass := TAddAttribClass.Create;
//   AddAttribClass := TAddAttribClass.Create;
   EventItemClass := TEventItemClass.Create;
   TransMonList := TTransMonsterListClass.Create;
   MagicCycleClass := TMagicCycleClass.Create;   
   BattleMapList := TBattleMapList.Create;
   RandomEventItemList := TRandomEventItemList.Create;
   NameClass := TNameClass.Create;
   MarryList := TMarryClass.Create;

end;

Finalization
begin
   TipStrList.Free;

   NameClass.Free;
   RandomEventItemList.Free;
   BattleMapList.Free;   
   ItemLog.Free;
   MonsterClass.Free;
   MagicClass.Free;
   MagicParamClass.Free;
   ItemMaterialClass.Free;
   ItemClass.Free;
   JobClass.Free;
   DynamicObjectClass.Free;
   MineObjectClass.Free;
   ItemDrugClass.Free;
   NpcClass.Free;
   SysopClass.free;
   PosByDieClass.Free;
   AreaClass.Free;
   QuestClass.Free;
   QuestSummaryClass.Free; //2002-08-06 giltae
   RandomClass.Free;
   PrisonClass.Free;
   NpcFunction.Free;
   SystemAlert.Free;

   RejectNameList.Free;
   NameStringListForDeleteMagic.Free;
   HelpFiles.Free;
   MacroReport.Free;
   QuizSystem.Free;
   AddAttribClass.Free;
//   AddAttribClass.Free;
   EventItemClass.Free;
   TransMonList.Free;
   MagicCycleClass.Free;
   MarryList.Free;
end;

end.
