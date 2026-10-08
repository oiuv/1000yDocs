# DynamicObject.Sdb

## 相关代码

```pascal
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
```

## 数据结构

字段 | 类型 | 描述 | 示例
-|-|-|-
Name|String|动态对象名称|火炉
ViewName,
Kind|Integer|对象类型，具体见下文|0
Shape,
Life,
Armor,
Damage,
StepCount||当前加载器没有读取此列；运行时步阶数据来自下面三组 `SStep`/`EStep` 字段|
SStep0|Integer或String|关闭状态开始帧|0或0:1:7
EStep0|Integer或String|关闭状态结束帧|0或0:6:10
SStep1|Integer或String|开启过程开始帧|
EStep1|Integer或String|开启过程结束帧|
SStep2|Integer或String|开启完成开始帧|
EStep2|Integer或String|开启完成结束帧|
EffectColor,
SoundEvent,
SoundSpecial,
SoundStart,
SoundDie,
GuardPos|String|禁止进入区域坐标，最多20对X/Y（20个坐标、40个整数）；遇到X/Y均为0时停止解析|1:0:1:1:0:1
EventItem,
EventDropItem,
EventSay|String|玩家说话|芝麻开门
EventAnswer|String|对象回答，要求Kind包括4|芝麻开门
boRemove,
OpennedInterval,
RegenInterval,
KeepInterval,
boRandom|Boolean|是否随机坐标，算法见上文代码|TRUE
EventType,
ShowInterval,
HideInterval,
boBlock,
bominimapshow,

- SStep = StartStep
- EStep = EndStep
- TDynamicObjectState = (dos_Closed, dos_Openning, dos_Openned, dos_Scroll);

> 注意石棺洞入口的激活方式和相关Step设置（激活状态5次,Step0|1|2循环5次），功能实现注意火炉对象参数和相关脚本。

> 可在NpcSetting文件夹设置"动态对象"，来控制随机物品奖励，具体请参考“妖华”与"NpcSetting\妖华.txt"和以下代码。

```pascal
begin
   if not FileExists (aFileName) then exit;

   StrList := TStringList.Create;
   StrList.LoadFromFile (aFileName);

   pd := nil; pt := nil;
   ParseSt := 0;

   for i := 0 to StrList.Count - 1 do begin
      Str := StrList.Strings [i];
      if Str = '' then continue;

      if Copy (Str, 1, 1) = '@' then ParseSt := 0;
      Case ParseSt of
         0 :
            begin
               if Str = '@DRAGDROPEVENT' then begin
                  ParseSt := 1;
               end else if Str = '@SELFSPEECH' then begin
                  ParseSt := 2;
               end else if Str = '@END' then begin
                  break;
               end;
            end;
         1 :
            begin
               GetKeyAndValue (Str, KeyStr, ValueStr);
               if KeyStr = 'ITEM' then begin
                  New (pd);
                  FillChar (pd^, SizeOf (TDragDropEventData), 0);
                  pd^.GiveItems := TList.Create;
                  ValueStr := GetValidStr3 (ValueStr, rdStr, ':');
                  pd^.ItemName := rdStr;
                  ValueStr := GetValidStr3 (ValueStr, rdStr, ':');
                  pd^.ItemCount := _StrToInt (rdStr);
                  DragDropList.Add (pd);
                  continue;
               end;
               if pd = nil then continue;
               if KeyStr = 'RANDOM' then begin
                  if UpperCase (Trim(ValueStr)) = 'TRUE' then begin
                     pd^.boRandom := true;
                  end;
               end else if KeyStr = 'GIVEITEM' then begin
                  New (pt);
                  FillChar (pt^, SizeOf (TItemTextData), 0);
                  pt^.SayText := TStringList.Create;
                  ValueStr := GetValidStr3 (ValueStr, rdStr, ':');
                  pt^.ItemName := rdStr;
                  ValueStr := GetValidStr3 (ValueStr, rdStr, ':');
                  pt^.ItemCount := _StrToInt (rdStr);
                  pd^.GiveItems.Add (pt);
               end;
               if pt <> nil then continue;
               if KeyStr = 'SAY' then begin
                  pt^.SayText.Add (ValueStr);
               end;
            end;
         2 :
            begin
               nPos := Pos ('=', Str);
               if nPos <= 0 then continue;
               KeyStr := UpperCase (Copy (Str, 1, nPos - 1));
               ValueStr := Copy (Str, nPos + 1, Length (Str));
               if KeyStr = 'SAY' then begin
                  SpeechList.Add (ValueStr);
               end else if KeyStr = 'INTERVAL' then begin
                  SpeechInterval := _StrToInt (ValueStr);
               end else if KeyStr = 'LOOPINTERVAL' then begin
                  SpeechLoopInterval := _StrToInt (ValueStr);
               end;
            end;
      end;
   end;

   StrList.Clear;
   STrList.Free;
end;

```

### Kind（类型）

```
# 0 无任何事件触发
# 1 被打时触发事件
# 2 添加物品时触发事件
# 4 说话时触发事件
# 3 被打和添加物品时同时触发事件
# 5 被打和说话时同时触发事件
# 6 添加物品和说话时同时触发事件
# 7 被打、添加物品和说话时同时触发事件
# 8 由火焰箭触发的事件
# 9 由事件触发的移动计时 03.03.31 saset

Kind 类别 作用
0 普通 装饰物
1 攻击 可攻击
2 拖放 可放物品
3 攻击+拖放 可放物品、攻击
4 说话 对话
5 说话+攻击 可对话、攻击
6 说话+拖放 可放入物品、对话
7 事件 可放入物品、对话、攻击
8 弓术 远程攻击
9 时间 时间段

说明 激活段（Dynamicobject.sdb）
攻击 boRandom、Damage、Life
拖放 EventItem、EventDropItem
说话 EventSay、EventAnswer
时间 ShowInterval、HideInterval

- Kind=0 纯用来装饰，玩家无法攻击“动态对象”，可被脚本调用。
- Kind=1 玩家可攻击“动态对象”。
- Kind=2 将指定物品拖放在“动态对象”，例如：门需要钥匙，或需要某物品才能掉落指定物品。
- Kind=4 说话：玩家只要输入指定“内容”，“动态对象”将与你对话。
- Kind=8

Kind=3 综合Kind=1与2功能，即可攻击又可拖放物品到“动态对象”。
Kind=5 综合Kind=1与4功能，即可攻击又可与“动态对象”对话。
Kind=6 综合Kind=2与4功能，即可拖放物品又可与“动态对象”对话。
Kind=7 综合Kind=3与4功能。

eventsay=是玩家输入，例如：设置=你好。
eventanswer=是“动态对象”回答，例如：设置=您终于来了！已经等您很久了。

聊天窗口显示：
玩家：你好
动态对象：您终于来了！已经等您很久了。

Kind=8 只能使用弓术攻击“动态对象”。

Kind=9 可攻击，受ShowInterval、HideInterval影响。
```

拖放物品仅限制EventItem指定的物品，会触发以下过程：

```pascal
procedure OnDropItem (aStr : String);
var
   Str, Name : String;
begin
   

end;
```

### EventType

```
   DYNOBJ_EVENT_NONE    = 0;   # 动态物品事件：无
   DYNOBJ_EVENT_HIT     = 1;   # 动态物品事件：被攻击
   DYNOBJ_EVENT_ADDITEM = 2;   # 动态物品事件：添加物品
   DYNOBJ_EVENT_SAY     = 4;   # 动态物品事件：说话
   DYNOBJ_EVENT_BOW     = 8;   # 动态物品事件：Bow攻击
   DYNOBJ_EVENT_MOVETICK = 9;  # 动态物品事件：移动计时
```
