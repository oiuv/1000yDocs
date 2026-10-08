# OnDie

Monster/NPC/DynamicObject 死亡后触发的事件回调。

## 声明
```pascal
procedure OnDie (aStr : String);
```

## 参数
| 参数 | 类型 | 说明 |
|------|------|------|
| aStr | String | 空字符串，无附加信息 |

## 触发条件
调用时机和 Sender 取决于对象路径：

- 生命对象（NPC、Monster 等）：`TLifeObject.CommandChangeCharState` 转入 `wfs_die` 时调用，不等待死亡动画结束。`Self` 是死亡对象，`Sender` 是攻击者；当两者 ID 相同时跳过事件。
- DynamicObject：由动态对象死亡更新路径调用，`Self` 是死亡对象、`Sender=nil`。

`OnDieBefore` 只在动态对象部分扣血路径中调用，不能假设所有 `OnDie` 都有前置 `OnDieBefore`。本事件可用于：
- 死亡后生成新的怪物或对象
- 触发地图事件（如播放通知、改变地图状态）
- 掉落物品或触发宝箱逻辑
- 重置计数器或机关状态

**源码位置**: `uSkills.pas` 第 1583-1617 行；`BasicObj.pas` 第 7199-7201 行

## 适用对象
- Monster
- NPC
- DynamicObject

## 示例

### 示例 1：死亡后重生 Boss 并触发掉落
> 来源：`bin/Script/石大王.txt`

```pascal
procedure OnDie (aStr : String);
begin
   print ('regen 霸王石 dynamicobject');
   print ('bopickbymapname 地下采石场2层 false');
   print ('regen 地下石巨人 monster');
end;
```

此示例在石大王被击杀后，重生霸王石对象并触发地图掉落和怪物再生。

### 示例 2：死亡后根据计数触发多阶段机关
> 来源：`bin/Script/王陵装置.txt`

```pascal
procedure OnDie (aStr : String);
begin
   if n < 8 then begin
      inc (n);
   end;
   if n = 1 then begin
      print ('sendnoticemsgformapuser 70 <雨中客>_有人侵入王陵 15');
      print ('mapaddobjbyname dynamicobject 滚动桥A 248 138');
      print ('mapaddobjbyname dynamicobject 滚动狮子A 255 141 101');
      exit;
   end;
   if n = 3 then begin
      print ('sendnoticemsgformapuser 70 <雨中客>_封锁秘密通道 15');
      print ('mapaddobjbyname dynamicobject 迷宫门 281 83');
      exit;
   end;
   if n = 5 then begin
      print ('sendnoticemsgformapuser 70 <雨中客>_封锁所有的出入口 15');
      print ('mapaddobjbyname dynamicobject 石门右1 118 192');
      exit;
   end;
end;
```

此示例通过计数器 `n` 实现多阶段机关：每次被击杀递增计数，达到不同阈值时触发不同的地图事件。

### 示例 3：死亡后生成 Boss 怪物
> 来源：`bin/Script/霸王石.txt`

```pascal
procedure OnDie (aStr : String);
begin
   print ('mapaddobjbyname monster 石大王 80 40 10 38 false');
   print ('bopickbymapname 地下采石场2层 true');
end;
```

## 相关事件
- [OnDieBefore](OnDieBefore.md) — 动态对象部分扣血路径中的死亡前回调
- [OnHit](OnHit.md) — 被攻击命中时触发
- [OnRegen](OnRegen.md) — 对象重生时触发
