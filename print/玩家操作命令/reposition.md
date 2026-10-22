# reposition

## 功能描述
重新定位玩家到NPC的对向位置。将玩家（aSender）移动到相对于NPC（aSelf）的对称位置，如果目标位置可移动则执行传送。

## 语法格式
```pascal
print('reposition');
```

## 参数说明
无参数。

## 源码实现
基于 `uScriptManager.pas` 中的处理逻辑：

```pascal
end else if cmd = 'reposition' then begin
   TBasicObject (aSelf).SRePosition(aSender);
```

`SRePosition` 实现在 `BasicObj.pas` 中：

```pascal
procedure TBasicObject.SRePosition(aBo: TBasicObject);
var
   SubData: TSubData;
   xx, yy: Word;
begin
   if aBo.BasicData.Feature.rrace <> RACE_HUMAN then
      exit;

   GetOppositePosition(aBO.BasicData.X, aBO.BasicData.Y, BasicData.X,
      BasicData.Y, xx, yy);
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
```

## 使用示例

### 石大王脚本（真实示例）
来自 `bin/Script/石大王.txt`：

```pascal
procedure OnHit (aStr : String);
var
   Str : String;
   Damage, n : Integer;
begin
   Str := callfunc ('getsenderrace');
   if Str <> '1' then exit;

   print ('reposition');

   Str := 'returndamage ' + aStr;
   Str := Str + ' 20';
   print (Str);
end;
```

玩家攻击石大王时，先将玩家弹开到对向位置，再反弹伤害。

## 注意事项

1. **仅对玩家有效**：如果 aSender 不是人类种族（RACE_HUMAN），命令不执行
2. **对称位置**：玩家被移动到相对于NPC的对称位置（以NPC坐标为中心取反）
3. **可移动检查**：目标位置必须是可移动的（isMoveable），否则不执行传送
4. **常与反弹伤害配合**：典型用法是先 reposition 弹开玩家，再用 returndamage 反弹伤害

## 相关命令
- `returndamage` - 反弹伤害
- [gotoxy](gotoxy.md) - 让脚本对象在当前地图移动，不是跨图传送
