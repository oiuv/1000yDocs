# Item.sdb

这是游戏中所有物品的数据文件，包括物品的属性、物品的描述、物品的图标等。

在炎黄新章中名称有特殊含义和作用的物品，例如：疾速靴、补血石、九转金丹、噬月刀、门派钱令、巨象石、河马石、金鸡石、人龙石、花窟石、玉犬石、玉猿石、玉蟾石、血狮石、血陵石、砸门锤等，直接根据名称判断物品的特殊功能，而不是根据Kind确认效果。

## 相关代码

```pascal
   // svClass.pas
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

         //2002-07-22 giltae Item.sdb에 추가된 필드로드
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

```

## 文件结构

字段 | 类型 | 描述 | 示例
-|-|-|-
Name | string | 物品的索引名称，要求在表中唯一 | 金元
ViewName | string | 物品的显示名称，可和其它物品重名 | 金元
Kind | int | 物品的类型，非常重要，见下表Kind | 1
Desc | string | 物品的描述，可为空 | 给物品染上颜色的试剂
Grade | int | 物品的品级，1-10，1为最高 | 1
QuestNum| int | Kind值为ITEM_KIND_GRADEUPQUESTITEM的物品，双击显示指定编号的任务信息 | 9999
NeedItem| string | 拾取前必须持有列出的物品名；格式为物品名:数量重复（最多4组），加载数量必须为正，但当前拾取分支只检查名字存在，不检查数量 | 招式全集:1
NotHaveItem| string | 持有任一列出的物品名时禁止拾取；格式及上限同NeedItem，当前拾取分支不比较配置数量|戒指:1:不灭:1:牌王:1
DelItem| string | 拾取时按列出的名称取物品模板并调用DeleteItem，不使用配置子项数量；SpecialKind为ITEM_SPKIND_DELALLBYDURA时跳过此删除分支；格式及上限同NeedItem|葫芦2:1
AddItem| string | 拾取时按列出的名称添加物品，数量采用被拾取地面物品的rCount，不使用配置子项数量；格式及上限同NeedItem|收了魂的葫芦2:1
boDouble| boolean | 是否可堆叠，如钱币可以，装备不可以，可叠加物品数量最大值为100000000 | TRUE
boColoring| boolean | 是否可染色，针对装备类物品 | TRUE
Shape| int | 物品的形状，具体编号由客户端文件item.atz控制 | 1
WearPos| int | 装备的部位，0-9，9=武器 8=帽子 7=头发 6=衣服 4=裤裙 3=鞋子 2=上衣 1=护腕 | 9
WearShape| int | 装备的形状，具体由客户端sprite目录下文件控制 | 1
ActionImage| int | 物品的动作图片，主要是针对箭和飞刀类| 1
HitMotion| int | 物品的攻击动作，主要是针对装备类| 2
HitType| int | 物品的攻击类型，主要是针对装备类| 1
Color| int | 物品的颜色，主要是针对可染色类，参考染色染 | 1  
Sex| int | 装备类物品的性别限制，1-男，2-女，为空不限制 | 1
Weight| int | 当前 `TItemClass` 加载器不读取此表头字段| 1
NeedGrade| int | 加载到 `TItemData.rNeedGrade`；当前 Pascal 源码没有找到该成员的消费位置| 6
Price| int | 物品的售价| 100
BuyPrice| int | 物品的购买价格（NPC回收的价格）| 100
RepairPrice| int | 物品的修理价格| 100
ServerId| int | Kind类型为TICKET物品的传送目标服务器ID| 1
X | int | 传送的X坐标，仅限Kind为TICKET有效| 10
Y | int | 传送的Y坐标，仅限Kind为TICKET有效| 10
SoundEvent|int | 物品得到时声音，编号请查看客户端 effect.atw| 4419
SoundDrop|int | 物品掉落时声音，编号请查看客户端 effect.atw| 4824
boPower| boolean | 物品是否是技能物品（非普通装备）常用于特殊场景限制玩家装备| TRUE
AttackSpeed| int | 物品的攻击速度，仅限装备类物品| 10
Recovery| int | 物品的恢复速度，仅限装备类物品| 10
LongAvoid| int | 物品的远距离躲闪，仅限装备类物品| 10
Avoid| int | 物品的近距离躲闪，仅限装备类物品| 10
LongAccuracy| int | 物品的远距离命中，仅限装备类物品| 10
Accuracy| int | 物品的近距离命中，仅限装备和套装属性| 10
KeepRecovery| int | 物品的姿势维持，仅限装备和套装属性| 10
DamageBody| int | 物品的身体攻击力，仅限装备和套装属性| 100
DamageHead| int | 物品的头部攻击力，仅限装备和套装属性| 10
DamageArm| int | 物品的手部攻击力，仅限装备和套装属性| 10
DamageLeg| int | 物品的腿部攻击力，仅限装备和套装属性| 10
ArmorBody| int | 物品的身体防御力，仅限装备和套装属性| 100
ArmorHead| int | 物品的头部防御力，仅限装备和套装属性| 10
ArmorArm| int | 物品的手部防御力，仅限装备和套装属性| 10
ArmorLeg| int | 物品的腿部防御力，仅限装备和套装属性| 10
RandomCount||从源码看无效设定，找不到相关代码|
NameParam1,
NameParam2,
Material|string | 物品的合成配方，最多4种材料| 玄铁:1:黄金:3:狼皮:1:矿泉水石:2
JobKind|int | 合成物品所需的职业类型，1铸造师、2炼丹师、3裁缝、4工匠| 1
boUpgrade| boolean | 物品是否可升段 | TRUE
MaxUpgrade | int | 物品的最大升段等级，默认技能装备3，系统装备4（MaxUpgrade为4的装备制造成功率减半） | 4
boTalentExp| boolean | 物品制造是否可以增加天赋（职业技能）经验 | TRUE
boDurability| boolean | 物品是否可磨损，仅限Kind为 WATERCASE、CHARM、FILL、GOLDBAG、DAGGEROFOS、DURABILITY、EIGHTANGLES、WEARITEM（限炎黄版本）、PICKAX和DURAWEAPON 有效| TRUE
Durability | int | 物品的耐久度| 100
DecDelay| int | 物品耐久度每次减少的间隔，单位为 `mmAnsTick` tick；默认 1 tick 约 10 ms，因此 5000 约为 50 秒。背包和装备耐久检查本身每 500 tick（约 5 秒）轮询一次| 5000
DecSize|int | 物品耐久度减少的数值| 1
Abrasion| int | 物品的磨损值，目前只有十字镐类装备有设置，这里是维修磨损，而不是随时间磨损 | 960
ToolConst,
SuccessRate|int | 物品的成功率，对可制造的物品设置为100代表必定成功（否则根据职业等级计算成功率），对HELPDRUG类药品为增加的升段成功率 | 100
boNotTrade| boolean | 物品是否不能和NPC交易| TRUE
boNotExchange| boolean | 物品是否不能和玩家交易| TRUE
boNotDrop| boolean | 物品是否不能丢弃| TRUE
boNotSkill| boolean | 物品是否不能放到技能栏| TRUE
boNotSSamzie| boolean | 物品是否不能放到福袋中| TRUE
cLife| int | 增加玩家的活力值，仅限Kind为CHARM有效，对ITEM_SPKIND_ADDALLLIFE还会增加头手脚活力| 1000
Attribute|int | 物品的特殊属性，具体见下表Attribute | 1
SpecialKind| int | 特殊类型，具体见下表SpecialKind | 4
RoleType| int | 装备物品增加黄字属性的类型，值为1-4，对类种类ROLE | 1
Script| Int | Kind为ITEM_KIND_USESCRIPT的物品双击调用的脚本编号，由Script/Script.SDB指定，事件限制为OnDblClick | 103
MaxCount| int |可持有的物品最大数量，0为无限，超过限制后无法拾取物品|99999
BoNotSave | boolean | 物品是否不保存到SDB备份文件 | TRUE
ExtJobExp| int | 物品的扩展职业经验(采集技能经验) | 1000

### WearPos（装备部位）

```
   # 装备部位
   ARR_BODY           = 0;
   ARR_GLOVES         = 1;
   ARR_UPUNDERWEAR    = 2;
   ARR_SHOES          = 3;
   ARR_DOWNUNDERWEAR  = 4;

   ARR_UPOVERWEAR     = 6;
   ARR_HAIR           = 7;
   ARR_CAP            = 8;
   ARR_WEAPON         = 9;
```

位置2、4、7为内衣、内裤和头发，这几个都无属性，只设置外形样式。

### Kind（类型）

```
   ITEM_KIND_NONE          = 0;
   ITEM_KIND_COLORDRUG     = 1;
   ITEM_KIND_BOOK          = 2;
   ITEM_KIND_WEARITEM      = 6;
   ITEM_KIND_ARROW         = 7;
   ITEM_KIND_FLYSWORD      = 8;
   ITEM_KIND_GUILDSTONE    = 9;
   ITEM_KIND_DUMMY         = 10;
   ITEM_KIND_STATICITEM    = 11;
   ITEM_KIND_DRUG          = 13;
   ITEM_KIND_TICKET        = 18;
   ITEM_KIND_HIDESKILL     = 19;
   ITEM_KIND_CANTMOVE      = 20;
   ITEM_KIND_ITEMLOG       = 21;
   ITEM_KIND_CHANGER       = 22;
   ITEM_KIND_SHOWSKILL     = 23;
   ITEM_KIND_WEARITEM2     = 24;
   ITEM_KIND_FOXMIRROR     = 25;
   ITEM_KIND_GUILDLETTER   = 26;       // 문원추천서
   ITEM_KIND_PICKAX        = 27;       // 곡괭이
   ITEM_KIND_MINERAL       = 28;       // 광물들
   ITEM_KIND_CAP           = 29;       // 갑박 머리 안나오게
   ITEM_KIND_PROCESSDRUG   = 30;       // 기술가공시약
   ITEM_KIND_HELPDRUG      = 31;       // 보조시약
   ITEM_KIND_GROWTHHERB    = 32;       // 자라는 약초
   ITEM_KIND_SKILLROLLPAPER = 33;      // 두루마리
   ITEM_KIND_QUESTITEM     = 34;       // 제왕석굴에 사용되는 Quest용 ITEM들.
   ITEM_KIND_WATERCASE     = 35;       // 물통(죽통,대형죽통)
   ITEM_KIND_CHARM         = 36;       // 들고만 있어도 속성이 적용되는 아이템 (퀘스트용)
   ITEM_KIND_QUESTLOG      = 37;       // e.g. 서한
   ITEM_KIND_SUBITEM       = 38;       // 특별한 아이템을 장비하고 있을경우에만 반응해서 그효과가 더해진다
   ITEM_KIND_NAMEDPOSQUEST = 39;       // ?? 이건 머지요?
   ITEM_KIND_QUESTITEM2    = 40;       // Quest용 아이템이지만 중첩가능한 아이템들.
   ITEM_KIND_FILL          = 41;       // 오색약수 (초보존에서 활력/내/외/무공 채워주는거)
   ITEM_KIND_SPECIALEFFECT = 42;       // 아이템창에 있으면서 특별한 능력을 발휘하는것
   ITEM_KIND_ADDATTRIBITEM = 43;       // 속성추가 아이템
   ITEM_KIND_GOLDBAG       = 44;       // 우중객의금낭
   ITEM_KIND_DAGGEROFOS    = 45;       // 옥선의무정쌍도
   ITEM_KIND_DUBU          = 46;       // 유배지의 두부. 유배지를 벗어날경우 사라져야됨.
   ITEM_KIND_DELATTRIBITEM = 47;       // 속성이 추가된 아이템의 속성을 없애주는 아이템
   ITEM_KIND_TRANSMONSTER  = 48;       // 몬스터로 변신하게 함
   ITEM_KIND_RECOVERYHUMAN = 49;       // 인간으로 다시 회복되게 함
   ITEM_KIND_GRADEUPQUESTITEM = 50;
   ITEM_KIND_DURABILITY    = 51;       // 내구성있는 모든 아이템
   ITEM_KIND_TOPLETTER     = 52;       // 더블클릭해서 방송띄우는거
   ITEM_KIND_GUILDLOTTERY  = 53;       // 문파대전 복권
   ITEM_KIND_SET           = 54;       // 세트아이템
   ITEM_KIND_DBLRANDOM     = 55;       // 더블클릭했을때 아이템 랜덤하게 주는것
   ITEM_KIND_USESCRIPT     = 56;       // 스크립트 이용하는 아이템
   ITEM_KIND_HIGHPICKAX    = 57;       // 고급곡괭이
   ITEM_KIND_SEAL          = 58;       // 봉인부적
   ITEM_KIND_EIGHTANGLES   = 59;       // 팔각괴
   ITEM_KIND_DURAWEAPON    = 60;       // 내구성갖고있는 무기

   ITEM_KIND_EVENT1     = 200;         // 이벤트용 아이템1, 가공창에서 가공할 경우 랜덤한 아이템을 획득가능함
```

类型3、4、5、12、14、15、16、17未实现，其中特别功能物品由game.ini配置如钱币、追魂索等，另外金元等根据名称由TGS指定特别功能。

| Kind | Type      | 说明         | 示例   |
|------|-----------|--------------|------|
| 0    | NONE      | 无实物，技能用 | 无名火炉 |
| 1    | COLORDRUG | 染色剂 | 紫色染剂 |
| 2    | BOOK      | 书 | 太极拳 |
| 3    |           | 钱币，游戏货币，实际由game.ini配置 | 钱币 |
| 4    |           |              | 肉 |
| 5    |           |              | 金元 |
| 6    | WEARITEM  | 装备，包括可升级4段装备，炎黄端支持设定耐久度 | 长剑 |
| 7    | ARROW     | 箭 | 箭 |
| 8    | FLYSWORD  | 飞刀 | 仙鹤神针 |
| 9    | GUILDSTONE| 门派石 | 门派石 |
| 10   | DUMMY     | 门派娃娃 | 男子卒兵娃娃 |
| 11   | STATICITEM| 静态物品 | |
| 12   ||||
| 13   | DRUG      | 药品 | 生药 |
| 14   |||| 
| 15   ||||
| 16   ||||
| 17   |           | INI_ROPE，由game.ini指定 | 追魂索 |
| 18   | TICKET | 卷轴，可传送 | 回城卷轴 |
| 19   | HIDESKILL | 隐身符，可隐身 | 隐身符 |
| 20   | CANTMOVE | 无法交换的物品，同boNotExchange属性 | 青龙牌 |
| 21   | ITEMLOG | 福袋，储物空间 | 福袋 |
| 22   | CHANGER | | 玫瑰脱色药 |
| 23   | SHOWSKILL | 透视符，可看穿隐身 | 透视符 |
| 24   | WEARITEM2 | 除内衣内裤外的装备，可升级 | 女子梅花战袍 |
| 25   | FOXMIRROR | | 妖华镜 |
| 26   | GUILDLETTER | 可直接加入门派 | 门人推荐书 |
| 27   | PICKAX | 挖矿工具 | 象牙十字镐 |
| 28   | MINERAL | 矿石，职业技能材料，此类物品价格固定为0（右键不显示价格），单击信息显示`('%s 数量: %d')` | 黄金 |
| 29   | CAP | 类似6，装备，可升级，帽子类 | 男子流星帽 |
| 30   | PROCESSDRUG | 加工试剂 | 桂圆丹 |
| 31   | HELPDRUG | 提升加工成功率的药品 | 生死梦幻丹 |
| 32   | GROWTHHERB | 草药类材料 | 千年地黄 |
| 33   | SKILLROLLPAPER | 技术密笈，根据职业类型调用help目录对应文件 | 卷轴 |
| 34   | QUESTITEM | 任务物品，可被deletequestitem删除 | 小佛 |
| 35   | WATERCASE | 沙漠用的水桶 | 竹筒 |
| 36   | CHARM | 能增加活力的物品（自动生效），可被deletequestitem删除 | 不灭 |
| 37   | QUESTLOG | 双击查看任务，可被deletequestitem删除，可根据currentquest调用任务详情 | 书函 |
| 38   | SUBITEM | 子物品（装备特殊物品时才生效） | 太极牌 |
| 39   | NAMEDPOSQUEST | 四大宝石 | 翡翠 |
| 40   | QUESTITEM2 | 可叠加的任务物品，可被deletequestitem删除 | 石谷钥匙 |
| 41   | FILL | 定时恢复活力/内/外/武功等属性，要求地图Attribute值为MAP_TYPE_FILL | 五色药水 |
| 42   | SPECIALEFFECT | 类似太极牌和八卦牌的特殊效果物品 ||
| 43   | ADDATTRIBITEM | 增加黄字属性的物品 | 霸王灵符 |
| 44   | GOLDBAG | SpecialKind为5的任务物品，自动删除DelItem | 雨中客锦囊 |
| 45   | DAGGEROFOS | SpecialKind为5的任务物品，自动删除DelItem | 玉仙的无情双刀 |
| 46   | DUBU | 从流放地释放出来时会删除此类物品 ||
| 47   | DELATTRIBITEM | 清除物品黄字属性 | 北海冰玉 |
| 48   | TRANSMONSTER | 变身成怪物，未实现功能 ||
| 49   | RECOVERYHUMAN | 恢复成人类，未实现功能 ||
| 50   | GRADEUPQUESTITEM | 升级神功任务物品，可指定QuestNum，可由gethavegradequestitem判断 | 侠客任务卷轴 |
| 51   | DURABILITY | 有耐久度的普通物品 | 万毒钥匙 |
| 52   | TOPLETTER | 双击可以显示广播的物品 | |
| 53   | GUILDLOTTERY | 门派奖券 | |
| 54   | SET | 套装加成属性| 从代码看Name只能是SetValue，加成装备属性 |
| 55   | DBLRANDOM | 双击随机掉落RandomEventItem0.sdb中的物品 | |
| 56   | USESCRIPT | 可双击调用脚本OnDblClick过程的物品，脚本由Script字段指定 | 四大神功全集 |
| 57   | HIGHPICKAX || 高级象牙十字镐 |
| 58   | SEAL | 封印符咒，可封印Kind为4的Monster，并触发Event.sdb中同名Mop死亡事件 | 封印符 |
| 59   | EIGHTANGLES | 类似SUBITEM和SPECIALEFFECT类型，增加玩家属性 | 八卦牌 |
| 60   | DURAWEAPON（WEARITEM_GUILD） | 有耐久度的武器（使用时才消耗） | 不羁浪人剑 |
| 200  | EVENT1 | 活动道具，加工窗口中加工时有几率获得随机物品 | |
| --   | -- | -以下无效- | -- |
| 61   | ScripterSay | 脚本物品 ||
| 100  | WEARITEM_FD| 时装 ||
| 120  | GuildAddLife | 门派加血石头 ||
| 121  | 121 | 宝石 镶嵌，SpecialKind 表示等级 ||
| 130  | 130 | 精炼 石头 ||
| 131  | LifeData_item | 可以吃的附加属性 ||
| 132  | 132 | 精炼 辅助石 rSpecialKind 类型 ||
| 133  | QUEST | 任务物品 ||
| 134  | GOLD_D | 代币 | |

> kind非常重要，ITEM_KIND_WEARITEM, ITEM_KIND_WEARITEM2, ITEM_KIND_CAP, ITEM_KIND_PICKAX, ITEM_KIND_HIGHPICKAX, ITEM_KIND_DURAWEAPON 都是可装备物品

### Attribute（属性）

```
   ITEM_ATTRIBUTE_NONE              = 0;  # 物品属性：无
   ITEM_ATTRIBUTE_FIRE              = 1;  # 物品属性：火属性
   ITEM_ATTRIBUTE_WATER             = 2;  # 物品属性：水属性（无效）
   ITEM_ATTRIBUTE_ICE               = 3;  # 物品属性：冰属性
   ITEM_ATTRIBUTE_FILL              = 4;  # 物品属性：恢复（增加活力、内力、外力、武功）
   ITEM_ATTRIBUTE_SET               = 5;  # 物品属性：套装，装备4件套加成SetValue物品的装备属性
   ITEM_ATTRIBUTE_DIRECT            = 6;  # 物品属性：直接放入物品栏（不会掉落地上） 040422 saset
   ITEM_ATTRIBUTE_PAPERBESTPROTECT  = 7;  # 物品属性：防护卷轴
   ITEM_ATTRIBUTE_PAPERBESTSPECIAL  = 8;  # 物品属性：特殊卷轴
   ITEM_ATTRIBUTE_QUESTSIGN         = 9;  # 物品属性：任务标志（无效）
   ITEM_ATTRIBUTE_TAEGUK            = 199;  # 物品属性：太极
   ITEM_ATTRIBUTE_LOWEST            = 201;  # 物品属性：最低
   ITEM_ATTRIBUTE_LOWEER            = 202;  # 物品属性：更低
   ITEM_ATTRIBUTE_NORMAL            = 203;  # 物品属性：正常
   ITEM_ATTRIBUTE_HIGHER            = 204;  # 物品属性：更高
   ITEM_ATTRIBUTE_HIGHEST           = 205;  # 物品属性：最高
```

### SpecialKind（特殊类型）

```
   ITEM_SPKIND_NONE           = 0;   # 物品特殊种类：无
   ITEM_SPKIND_MUNJANG        = 1;   # 物品特殊种类：属性灵符（工匠）
   ITEM_SPKIND_ZANGSIK        = 2;   # 物品特殊种类：属性饰品（裁缝）
   ITEM_SPKIND_JUMOON         = 3;   # 物品特殊种类：属性卷轴（铸造）
   ITEM_SPKIND_GOLBANG        = 4;   # 物品特殊种类：可以制作其他物品的物品（玩家可以@item 指令制造）
   ITEM_SPKIND_DELALLBYDURA   = 5;   # 物品特殊种类：当耐久度全耗尽时，连同delitem中指定的物品一起消失
   ITEM_SPKIND_DONTDRUG       = 6;   # 物品特殊种类：由炼丹师制作的药，不能服用
   ITEM_SPKIND_ADDALLLIFE     = 7;   # 物品特殊种类：从Item.sdb文件中的cLife字段中的一个数值，增加头部、手部、脚部的HP
   ITEM_SPKIND_1              = 8;   # 物品特殊种类：珍珠
   ITEM_SPKIND_2              = 9;   # 物品特殊种类：翡翠
   ITEM_SPKIND_3              = 10;  # 物品特殊种类：水晶
   ITEM_SPKIND_4              = 11;  # 物品特殊种类：琥珀
```

## 制造物品成功率

> MaxUpgrade 为4的物品，成功率减半

```pascal
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

      if ItemData.rMaxUpgrade = 4 then begin   // 기술아이템 아닌것
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
      // 제조 성공에 의한 재능 경험치 증가
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
```

## 关于修理

修理耐久度相关代码`callfunc ('getsenderrepairitem 9 27')`和`callfunc ('getsenderrepairitem 0 59')`，返回值如下：

返回值|说明
-|-
-1|默认返回值
0|没带要修理的物品(物品栏没八卦牌和手里没装备)
1|物品没有设定耐久度
2|物品耐久度是满的
3|十字镐耐久度小于磨损值，没有修理的必要了
4|修理成功

减少耐久度相关代码`print ('changesendercurdurabyname 物品 耐久度')`

类型为27的十字镐，每次修理会减少`Abrasion`的耐久度上限，修理价格为固定的`RepairPrice`

类型为57的高级十字镐、类型为59的八卦牌和类型为60的装备修理不减耐久度，修理价格为`RepairPrice * 需恢复的耐久度`

## 关于@item指令

玩家可制造特殊类型为ITEM_SPKIND_GOLBANG的物品，GM可制造所有物品。

    @item Name Count
    // 以下神武端无效
    @item Name Count Upgrade AddType
    @item Name Count Upgrade CurDurability Durability

```pascal
   SAYCOMMAND_MAKEITEM: // Conv('@item')   //制造物品
   begin
      ItemClass.GetItemData (strs[1], ItemData);
      if ItemData.rName[0] = 0 then exit;

      if SysopScope > 99 then begin
         if Strs [2] <> '' then begin
         ItemData.rCount := _StrToInt (Strs [2]);

         if (NATION_VERSION = NATION_KOREA) or (NATION_VERSION = NATION_KOREA_TEST) then begin
            ItemData.rUpgrade := _StrToInt (Strs [3]);

            if Strs [5] = '' then begin
               ItemData.rAddType := _StrToInt (Strs [4]);
               JobClass.GetUpgradeItemLifeData (ItemData);
               if ItemData.rAddType <> 0 then begin
               nRet := ItemClass.GetAddItemAttribData (ItemData);
               if nRet <> true then begin
                  SendClass.SendChatMessage (Conv('옵션번호가 잘못되었습니다'),SAY_COLOR_SYSTEM);
                  exit;
               end;
               end;
            end else begin
               ItemData.rCurDurability := _StrToInt (Strs [4]);
               ItemData.rDurability := _StrToInt (Strs [5]);
            end;
         end;
         end;
      end else begin
         if ItemData.rSpecialKind <> ITEM_SPKIND_GOLBANG then begin
         SendClass.SendChatMessage (Conv('无法制造的物品'), SAY_COLOR_SYSTEM);
         exit;
         end;
      end;

      if ItemData.rboDouble = false then ItemData.rCount := 1;
      tmpBasicData.Feature.rRace := RACE_NPC;
      StrPCopy (@tmpBasicData.Name, Conv('item'));
      tmpBasicData.x := BasicData.x;
      tmpBasicData.y := BasicData.y;
      SignToItem (ItemData, ServerID, tmpBasicData, '');
      if HaveItemClass.AddItem (ItemData) = true then
         SendClass.SendChatMessage (format (Conv('做出%s'),[Strs[1]]), SAY_COLOR_SYSTEM);
      exit;
   end;
```
