# NPC.SDB

## HaveItem 掉落配置

`HaveItem` 使用重复的 `物品名:每次数量:判定周期长度`，最多 5 组。名称使用 `Item.SDB` 的 `Name`；非正周期按 1 处理，数量非正、名称为空或参数缺失会停止读取后续条目。

`TNpcClass.LoadNpcData` 将“NPC 配置名＋物品名”登记到 `RandomClass`。`TNpc.FieldProc` 的死亡相关分支通过 `GetCheckItemData` 执行判定；各物品每个完整周期命中一次，计数在同一 TGS 进程内共享，不是玩家个人保底。完整算法、重启重置及多物品关系见 [Monster.SDB：HaveItem](Init_monster.sdb.md#haveitem独立周期判定)。

不要将第三项理解为散落份数或物品间的相对权重。源码依据：[svClass.pas](TGS核心源码/svClass.pas) 的 `TNpcClass.LoadNpcData`、`TRandomClass`，以及 [uNpc.pas](TGS核心源码/uNpc.pas) 的 `TNpc.FieldProc`。


## 相关代码 

```pascal

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
```

```pascal
// rboSeller
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

```

```pascal
// boSale
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

```

```pascal
// showwindow的类型说明
procedure TUser.SShowWindow (aCommander : TBasicObject; aFileName : String; aKind : Byte);
var
   Str : String;
begin
//   if ShowWindowClass.CurrentWindow <> swk_none then exit;
   if ShowWindowClass.AllowWindowAction (swk_none) = false then exit;

   ShowWindowClass.Commander := aCommander;
   if not FileExists (aFileName) then exit;

   Str := HelpFiles.FindFile (aFileName);
   if aKind = 0 then begin
      ShowWindowClass.ShowHelpWindow ('', Str);
   end else begin
      ShowWindowClass.ShowTradeWindow ('', Str);
   end;
end;
```

> 类型为TradeWindow的窗口，command最多5个，超过运行时会报错。类型为HelpWindow的窗口，command最多4个，超过运行时会报错，但可以用a标签处理。另外从客户端代码分析`close` `link` `send`三个命令是特殊的。

Help窗口相关代码：

```pascal
function TfrmHelp.Parse: integer;
var
   Res, iCommand: integer;
   ParseStack: TStringList;
   Line, DataText, tmpStr: string;
   isBody: Boolean;
begin
   Result := 0;

   Clear;

   ParseStack := TStringList.Create;
   Line := FRawData;
   DataText := '';
   isBody := False;
   iCommand := 0;

   repeat
      Res := GetStatement(line, tmpStr);

      case Res of
      0: // 일반 텍스트
         begin
            if isBody then // Body는 공백삭제를 하지 않음(enter처리땜시롱)
               DataText := DataText + tmpStr
            else           // Text의 불필요한 양 공백삭제
               DataText := Trim(tmpStr);
         end;
      1: // 시작태그
         begin
            if not isBody then begin
               if StrLIComp(PChar(tmpStr), 'image', 5) = 0 then
                  SetImage(tmpStr)
               else begin
                  if StrLIComp(PChar(tmpStr), 'body', 4) = 0 then isBody := True;
                  ParseStack.Add(tmpStr);
               end;

               DataText := '';
            end else begin // body내의 tag들은 parsing하지 않음
               DataText := DataText + '<' + tmpStr + '>';
            end;
         end;
      2: // 종료태그
         begin
            if StrLIComp(PChar(tmpStr), 'title', 5) = 0 then begin
               SetTitle(DataText);
            end else if StrLIComp(PChar(tmpStr), 'text', 4) = 0 then
               SetA2Text(StringReplace(DataText, #13#10, ' ', [rfReplaceAll]))
            else if StrLIComp(PChar(tmpStr), 'command', 7) = 0 then begin
               tmpStr := ParseStack[ParseStack.Count-1];
               AddCommand(iCommand, tmpStr, DataText);
               inc(iCommand);
            end else if StrLIComp(PChar(tmpStr), 'body', 4) = 0 then begin
               SetBody(DataText);
               isBody := False;
            end;
            DataText := '';
            ParseStack.Delete(ParseStack.Count-1);
         end;
      end;

   until ParseStack.Count = 0;

   ParseStack.Free;
end;
```

## 文件结构

字段名|类型|说明|示例
-|-|-|-
Name|string|npc索引名称，不可重复|老板娘
ViewName|string|npc显示名称，可重复|老板娘
Virtue,
VirtueLevel,
NpcText|string|npc交易文件，在'.\NpcSetting\'目录下，需要boSale或boSeller为TRUE，由tradewindow调用|老板娘.txt
boMinimapShow|boolean|是否在地图上显示|TRUE
boSale|boolean|是否可以买卖，表现为出售从玩家那买回来的物品，tradewindow 3和4|TRUE
boSeller|boolean|是否可以交易，买卖指定的物品，tradewindow 0为sell 1为buy|TRUE
boProtecter|boolean|是否为守卫，表现为会主动攻击boGoodHeart为fasle的MONSTER|TRUE
boObserver|boolean|是否为观察者，表现为攻击PK其它玩家的玩家|TRUE
boAutoAttack|boolean|是否自动攻击玩家，如果为TRUE会自动攻击玩家，常用于NPC比武挑战场景|TRUE
boHit|boolean|是否可以被玩家攻击，如果为TRUE玩家可以攻击此NPC|TRUE
animate,
shape,
Image||当前 `TNpcClass.LoadNpcData` 不读取此表头字段|
Damage,
Armor,
ArmorHead,
ArmorArm,
ArmorLeg,
Life,
AttackSpeed,
Avoid,
Recovery,
SpendLife,
HitArmor,
ActionWidth|integer|NPC移动范围，0为不动，算法为：X-ActionWidth div 2 + random(AcitonWidth)|4
SoundStart,
SoundAttack,
SoundDie,
SoundNormal,
SoundStructed,
EffectStart,
EffectStructed,
EffectEnd,
HaveItem,
AttackMagic,
AttackSkill,
HaveMagic,
RegenInterval,
boBattle|boolean|启用战斗 NPC 分支：加载 `AttackMagic`，使用战斗属性计算，并让头、手、脚生命与最大生命一起初始化|TRUE
boRightRemove,
EffectNumber||当前 `TNpcClass.LoadNpcData` 不读取此表头字段|
