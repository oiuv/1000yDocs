# Item.sdb

这是游戏中所有物品的数据文件，包括物品的属性、物品的描述、物品的图标等。

部分物品还有按内部名称 `Name` 实现的专用逻辑，例如疾速靴、九转金丹、噬月刀和门石。名称判断可能与 `Kind`、穿戴位置、地图、任务条件共同生效，不能只靠类别或物品描述推断。完整名单、配置名称及未启用分支见[特殊物品内部名称与专用机制](SpecialItems.md)。

## 配置一致性检查

- `Name` 是内部键，改类别、排序或说明时保持名称不变，并核对任务脚本、配方与按名称判断的专用逻辑。
- 没有命名常量的 3、4、5、17 按[数据分类约定](constants/ITEM_KIND.md#预留类型与数据分类约定)维护；不能通过改类别替代药效、穿戴、计时或任务实现。
- `Kind=13` 的每件药品必须在 [ItemDrug.sdb](Init_ItemDrug.sdb.md) 有同名有效记录。说明按实际恢复/加成字段编写，不凭名称宣称反弹、免疫、打断武功等功能。
- 普通加工的成功率表按 `MaxUpgrade=3/4` 分支，属性重算支持的加工上限为 4。不要把普通装备配置成 `MaxUpgrade=5`；这不会新增第五段属性或普通加工成功率表。四大宝石直升同样须遵守可计算的加工等级范围。
- 性别限定装备须同时核对 `Sex`、`WearPos` 和外观资源；任务凭证不要误填成可穿戴装备。婚戒用于脚本兑换礼服，和礼服自身的穿戴记录是两类物品。
- 保留 `boNotSkill`、交易、丢弃等安全标志；`boDouble` 是堆叠，不是允许双击。布尔列使用 `TRUE/FALSE` 或既有空值，避免拼写错误静默落到默认值。
- 上线更新前核对存档兼容：载入会按名称取得当前模板，但已佩戴物品所在槽位和保存的加工等级不会仅因改表自动迁移。若存在已穿戴婚戒或旧的五段日月装备，需先核对并处理对应存档；不要直接删除玩家物品。

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
boColoring| boolean | 是否允许通过染剂改变物品颜色；穿戴和地面物品染色入口检查此项，不控制初始配色显示，见[物品图标与颜色](#物品图标与颜色) | TRUE
Shape| int | 客户端根目录 `item.atz` 中的图像索引，编号从0开始；物品栏中0表示不显示图标，见[物品图标与颜色](#物品图标与颜色) | 1
WearPos| int | 装备的部位，0-9，9=武器 8=帽子 7=头发 6=衣服 4=裤裙 3=鞋子 2=上衣 1=护腕 | 9
WearShape| int | 装备的形状，具体由客户端sprite目录下文件控制 | 1
ActionImage| int | 物品的动作图片，主要是针对箭和飞刀类| 1
HitMotion| int | 物品的攻击动作，主要是针对装备类| 2
HitType| int | 物品的攻击类型，主要是针对装备类| 1
Color| int | 物品初始配色色表编号，范围0～255；不是RGB值，实际效果取决于图像中的可染色区域，见[物品图标与颜色](#物品图标与颜色) | 1
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
boDurability| boolean | 耐久计时开关；还要求当前耐久和DecDelay大于0。背包只处理指定Kind，穿戴栏计时无Kind筛选；攻击、采矿的按次损耗不检查此开关。见[耐久度处理](constants/ITEM_KIND.md#耐久度处理)| TRUE
Durability | int | 新建物品模板的耐久上限及初始当前耐久；初始为0不会因计时自动删除，不能据此判断所有类型的使用损耗| 100
DecDelay| int | 物品耐久度每次减少的间隔，单位为 `mmAnsTick` tick；默认 1 tick 约 10 ms，因此 5000 约为 50 秒。背包和装备耐久检查本身每 500 tick（约 5 秒）轮询一次| 5000
DecSize|int | 每次计时扣减量，正常消耗应为正数；不是攻击、采矿按次扣减的数值| 1
Abrasion| int | 普通十字镐（Kind=27）修理时扣除的耐久上限；不是随时间磨损，也不是所有类型修理都使用| 960
ToolConst,
SuccessRate|int | 物品的成功率，对可制造的物品设置为100代表必定成功（否则根据职业等级计算成功率），对HELPDRUG类药品为增加的升段成功率 | 100
boNotTrade| boolean | 物品是否不能和NPC交易| TRUE
boNotExchange| boolean | 物品是否不能和玩家交易| TRUE
boNotDrop| boolean | 物品是否不能丢弃| TRUE
boNotSkill| boolean | 禁止从背包放入技术窗的物品标志；拖拽、数量确认和批量材料入口均需检查，见下方限制说明 | TRUE
boNotSSamzie| boolean | 物品是否不能放到福袋中| TRUE
cLife| int | 护符类（Kind=36）在背包中的活力上限加成值；为空或为0时不加成。SpecialKind=7时还增加头、手臂、腿部活力上限，不是回复当前活力 | 1000
Attribute|int | 物品的特殊属性，具体见下表Attribute | 1
SpecialKind| int | 特殊类型，具体见下表SpecialKind | 4
RoleType| int | 装备物品增加黄字属性的类型，值为1-4，对类种类ROLE | 1
Script| Int | Kind为ITEM_KIND_USESCRIPT的物品双击调用的脚本编号，由Script/Script.SDB指定，事件限制为OnDblClick | 103
MaxCount| int | 拾取前已有背包及技术窗同名物品的数量门槛；0 不启用此检查，不是所有容器的最终持有量硬上限 |99999
BoNotSave | boolean | 背包序列化到角色记录时不保存此物品；影响普通存档，不限于备份 | TRUE
ExtJobExp| int | 物品的扩展职业经验(采集技能经验) | 1000

### 物品图标与颜色

`Shape` 选择图片，`Color` 选择配色，`boColoring` 决定是否允许使用染剂。三者不能混为一谈。

#### 图标来源与染色条件

服务端从 `Item.sdb` 读取物品模板，将物品的 `Shape`、`Color` 发送给客户端。客户端不直接读取服务端物品表，而是按收到的编号绘制图标。

客户端启动时将工作目录切换到 `Client.exe` 所在目录，随后以相对路径 `item.atz` 加载物品图库。因此图库位于客户端根目录，不在 `etc/` 或 `ect/` 下。物品栏按 `Shape` 直接取图库索引；不同版本的图库内容和数量可能不同，不能直接套用其它客户端的编号。`WearShape` 则用于人物穿戴外观，不是物品栏图标编号。

`Color` 是客户端 `ColorDataTable` 的索引，支持 **0～255**。每个编号对应一组色调和亮度补充值，不是RGB值，也不表示第几张图片。

物品图标染色只处理**非透明且红、蓝通道均为0的像素**，即图片中预留的纯绿色区域。绘制时按这些像素的绿色强度换算目标颜色，保留明暗层次；其它像素维持原来的颜色。

- 图片没有这类像素时，修改 `Color` 不会改变图标外观；不能通过继续更换编号实现整张图片变色。
- `boColoring=FALSE` 不会关闭图标配色。它是服务端染剂操作的许可条件，具体槽位和目标限制见[染色使用规则](constants/ITEM_KIND.md#双击染色弹药和穿戴)。
- 在物品图标绘制中，`Color=1` 将可染色区域处理成灰色，不是“保持原图颜色”；`Color=0` 对应黑色／近黑色，也不是“不染色”开关。

#### 常用配色编号

以下色名用于说明色调，实际深浅取决于原图的绿色强度。编号以当前炎黄客户端的 `ColorDataTable` 为准。

| Color | 色调或用途 |
|---:|---|
| 0 | 黑色／近黑色 |
| 1 | 灰色，物品表中常用的配色 |
| 2 | 绿色 |
| 3 | 褐色 |
| 4 | 蓝灰色 |
| 5 | 红色偏橙 |
| 6 | 青绿色 |
| 7 | 淡紫色 |
| 8 | 土黄色 |
| 9 | 深紫红色 |
| 10 | 天蓝色 |
| 11 | 深灰色 |
| 12 | 纯红色 |
| 13 | 纯绿色 |
| 14 | 纯蓝色 |
| 15 | 白色 |
| 16～31 | 分别对应0～15的提亮版本，亮度补充值为3 |
| 32～255 | 扩展配色，部分编号效果重复，按目标客户端色表及实际图标预览选择 |

#### 炎黄图库示例

以下示例对应 **ATZ1格式、734幅图像、857932字节**的炎黄 `item.atz`，不作为其它版本图库的通用编号约定。

| Shape | 使用示例 | 非透明像素 | 可染色像素 | 修改Color的效果 |
|---:|---|---:|---:|---|
| 88 | 仙豆、糖果、比比路 | 120 | 118 | 大部分图标随配色变化 |
| 517 | 天书 | 407 | 0 | 图标外观不变 |

例如糖果使用 `Color=86`、比比路使用 `Color=69`，可以通过同一张88号图片显示不同配色。517号图片没有可染色区域，无法仅靠 `Color` 变色。若需要另一种外观，可选择合适的其它图标或新增图像；直接修改已有图像会影响所有使用该 `Shape` 的物品。

客户端源码定位：`FMain.pas` 的 `TFrmM.FormCreate`、`AtzCls.pas` 的 `TAtzClass.Create/GetItemImage`、`FAttrib.pas` 的 `TFrmAttrib.MessageProcess/SetItemLabel`、`CharCls.pas` 的 `GetGreenColorAndAdd`、`CTable.pas` 的 `ColorDataTable`，以及 `Lib/ALib/A2Img.pas` 的 `TA2Image.DrawImageGreenConvert`。物品模板及染剂规则依据：[svClass.pas](TGS核心源码/svClass.pas) 的 `TItemClass.ReLoadFromFile/GetItemData`、[uUserSub.pas](TGS核心源码/uUserSub.pas) 的 `TWearItemClass.AddColorDrug` 和 [BasicObj.pas](TGS核心源码/BasicObj.pas) 的 `TItemObject.FieldProc`。

### 物品限制的实际边界

- `boNotSkill` 在背包放入技术窗的处理入口检查。材料移动还受物品锁、角色物品移动权限、地图 `boNotDeal`、摆摊、窗口状态及背包密码限制。数量确认必须重新读取当前槽位，再核对物品锁和禁止标志；不能只依赖打开数量窗口时的状态。批量材料请求须先完成全部校验，拒绝时不得先移动其中一部分。依据：[UUser.pas](TGS核心源码/UUser.pas) 的 `CM_DRAGDROP`、`CM_SELECTCOUNT`、`CM_SETMATERIAL` 分支及 [uUserSub.pas](TGS核心源码/uUserSub.pas) 的材料处理方法。
- `MaxCount` 的这项检查位于 `TUser.FieldProc` 的 `FM_ADDITEM` 分支，计算 `HaveItemClass` 与 `HaveJobClass` 中已有的同名数量，达到门槛即拒绝。它不把本次待加入的堆叠数量相加，也不统计穿戴、福袋等全部容器。例如已有 4 个、门槛为 5 时，一次新增多个仍可通过这项检查；最终是否添加还受后续条件影响。不能用这个字段单独保证全局唯一性。
- `BoNotSave` 的实际消费点是 `THaveItemClass.SaveToSdb(PTDBRecord)`：把对应背包槽的名称、数量及其它保存字段清空。普通下线和周期状态收集也使用它，不是“只跳过文本备份”。这个结论限于背包保存方法，不应推及所有容器。角色记录及落盘路径见[玩家数据库](database.md#6-数据持久化流程)。

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

`Kind` 决定物品进入哪些使用、穿戴或加工分支；完整取值、示例及生效条件集中见[物品类型常量](constants/ITEM_KIND.md)。普通穿戴入口接受 6、24、27、29、57、60 类，具体位置和外观仍由穿戴字段决定。

3、4、5、17 等无命名常量的表值，应按[预留类型与数据分类约定](constants/ITEM_KIND.md#预留类型与数据分类约定)核对用途；钱币、追魂索等还依赖配置或内部名称。其它版本资料中的 61、100、120、121、130～134 等编号不在本版 `ITEM_KIND_*` 定义表内，不应照抄为可用功能。

`CHARM` 译为“护符类”，不等于“必定增加活力的物品”。例如九转金丹的 `cLife` 为空，不提供活力加成；具体条件见[护符类说明](constants/ITEM_KIND.md#护符类kind36)。血红色的玛瑙石采用普通耐久物品 `Kind=51`，保留任务脚本按名称发放、交付和耐久到期清除的用途。

`deletequestitem` 会清空背包中 **34、36、37、40** 类的全部槽位，不按当前任务或剩余耐久过滤，也不受禁止丢弃标记保护。完整边界见[任务清理范围](constants/ITEM_KIND.md#任务清理范围)。

耐久字段不是某一种 Kind 的专属功能。背包计时支持 **6、35、36、41、44、45、51、59**；其中35保留空容器，59耗尽不删除。穿戴计时、攻击/采矿损耗和修理使用不同入口，详见[耐久度处理](constants/ITEM_KIND.md#耐久度处理)，其中也说明了计时起点、轮询间隔及初始耐久为0的行为。

### Attribute（属性）

全部枚举值及材料档次见[物品属性常量](constants/ITEM_ATTRIBUTE.md)。

`Attribute` 不仅表示元素属性，也用于套装、直接获取和“废弃”按钮等功能。随包“招式全集”的 `Name`、`ViewName` 均为“招式全集”，配置 `Kind=4、Attribute=7`；“四大神功全集”配置 `Kind=56、Attribute=8、Script=103`。这两个中文名称以实际物品表为准，不从英文常量名推译；`Attribute=7/8` 在物品说明窗口中分别对应“废弃”按钮键 `0/1`。完整说明见[物品属性常量](constants/ITEM_ATTRIBUTE.md)。

### SpecialKind（特殊类型）

附加属性材料、地图药品限制、耐久关联清理及四大宝石标记，集中见[物品特殊类型常量](constants/ITEM_SPKIND.md)。

`Kind`、`Attribute`、`SpecialKind` 是三个独立字段。名称与条件不能仅按英文常量推测，详见[物品类型](constants/ITEM_KIND.md)、[物品属性](constants/ITEM_ATTRIBUTE.md)和[特殊类型](constants/ITEM_SPKIND.md)。

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

直接设置背包当前耐久：`print ('changesendercurdurabyname 物品 当前耐久')`。这是赋值，不是扣减；设为0不会在此命令内删除，后续计时分支也要求当前耐久大于0。详见[命令说明](../print/物品交易命令/changesendercurdurabyname.md)。

类型为27的十字镐，每次修理会减少`Abrasion`的耐久度上限，修理价格为固定的`RepairPrice`

穿戴栏中类型为57的高级十字镐、60的耐久武器，以及背包中类型为59的八卦牌，修理时不降低耐久上限，将当前耐久补满，修理价格为`RepairPrice * 需恢复的耐久度`。

## 关于@item指令

普通玩家只允许创建 `SpecialKind=ITEM_SPKIND_GOLBANG` 的物品；权限达到 100 的 GM 可指定物品表中的物品及数量。物品加入操作者自己的背包，非叠加物品强制数量为 1，仍需背包能容纳。普通玩家不走 GM 数量设置分支。

中国版本使用：

```text
@item Name Count
```

以下额外参数仅在 `NATION_KOREA`、`NATION_KOREA_TEST` 条件下处理；中国、台湾版本不会应用这些升级、附加属性或耐久参数，不能仅凭游戏章节名称判断支持情况：

```text
@item Name Count Upgrade AddType
@item Name Count Upgrade CurDurability Durability
```

其它管理命令及危险操作见 [GM 管理命令](GMCommands.md)。

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
