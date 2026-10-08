# OnBow

## 声明

```pascal
procedure OnBow (aStr : String);
```

## 参数

| 参数 | 类型 | 说明 |
|------|------|------|
| aStr | String | 攻击者的 SayString（通常是武功名称字符串） |

## 触发条件

当前有两条 `FM_BOW` 调用路径：

- `TDynamicObject`：要求 `DYNOBJ_EVENT_BOW` 标记及目标/范围判断通过；`OnDanger` 精确返回 `false` 时直接退出，否则可调用 `OnBow`。
- `TLifeObject`：要求对象未死亡、允许受击且未禁弓术，并通过目标/范围判断；`OnDanger` 未拒绝后，先进行弓术伤害结算，再调用 `OnBow`。这条路径不要求动态对象事件标记。

两条路径中 `Self` 都是受击对象，`Sender` 是攻击者。此事件针对弓术消息，不能据“远程”一词推广到掌风等其它消息。

源码位置：`BasicObj.pas` 第 6852-6868 行、`uSkills.pas` 第 1890-1915 行

## 适用对象

- DynamicObject（动态对象）— 需设置 `DYNOBJ_EVENT_BOW` 标记
- 使用 `TLifeObject.FieldProc` 的生命对象（包括 NPC、Monster、User）— 按生命对象路径的受击条件判断

## 示例

### 示例 1：火炉被火箭点燃（火炉.txt）

配合 `OnDanger` 判断远程攻击类型，火箭命中时触发点燃逻辑：

```pascal
function OnDanger (aStr : String) : String;
begin
   if aStr = '火箭' then begin
      Result := 'true';
      exit;
   end;
   Result := 'false';
end;

procedure OnBow (aStr : String);
begin
   // 被远程攻击命中时，配合 OnDanger 判断是否为火箭
   // OnDanger 返回 true 后触发 IncStep 点燃炉火
end;
```

### 示例 2：火坛计数器（火坛.txt）

与 OnTurnOn/OnTurnOff 配合，远程攻击命中火坛时递增计数器，达到阈值后开启机关：

```pascal
procedure OnBow (aStr : String);
begin
   // 被远程攻击命中，触发 IncStep 使炉火开启
   // 随后 OnTurnOn 中递增计数，达到 4 时允许攻击 Boss
end;
```

## 相关事件

- [OnDanger](../function/OnDanger.md) — 远程攻击判定回调（决定是否接受伤害）
- [OnTurnOn](OnTurnOn.md) / [OnTurnOff](OnTurnOff.md) — 开关状态事件（OnBow 触发 IncStep 后联动）
- [OnHit](OnHit.md) — 近战命中事件
