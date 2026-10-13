# getpossiblegrade

## 功能描述
检查触发玩家指定绝世武功分组中，是否有熟练度 `rcSkillLevel = 9999` 且 `rGrade` 等于参数值的武功。只检查这一项条件，不保证所有升级条件均满足。

## 语法格式
```pascal
Str := callfunc('getpossiblegrade 分组 当前品级');
```

## 参数说明
- **参数1**：传给 Byte 类型的 `aType`，只应使用下列分组
  - 0：`HaveBestProtectMagicArr`，绝世护体武功
  - 1：`HaveBestAttackMagicArr`，绝世攻击武功
- **参数2**：传给 Byte 类型的 `aGrade`，匹配已有武功的当前 `rGrade`，不是升级后的目标品级
  - 0：检查是否有满1级的神功（2级任务）
  - 1：检查是否有满2级的神功（3级任务）

## 返回值
- **成功**：'true' - 玩家满足升级条件
- **失败**：'false' - 玩家不满足升级条件

## 源码实现
```pascal
// uScriptManager.pas 的 CallFunction
end else if cmd = 'getpossiblegrade' then begin
   Result := TBasicObject (FSender).SGetPossibleGrade(_StrToInt(Params[0]),_StrToInt(Params[1]));
```

调用 `TBasicObject.SGetPossibleGrade`，玩家实现委托给 `THaveMagicClass.GetPossibleGrade`。只检查对应分组内名称非空、熟练度为 9999 且品级相等的条目；其它分组返回 false。依据：[UUser.pas](../../help/TGS核心源码/UUser.pas)、[uUserSub.pas](../../help/TGS核心源码/uUserSub.pas)。

## 使用示例

### 2级任务条件检查（需要满1级神功）
```pascal
// 检查是否有满1级的神功
Str := callfunc ('getpossiblegrade 0 0');
if Str = 'false' then begin
    print ('say 要有一个满1级的神功 50');
    exit;
end;
```
> 来源：`老侠客.txt`

### 3级任务条件检查（需要满2级神功）
```pascal
// 检查是否有满2级的神功
Str := callfunc ('getpossiblegrade 0 1');
if Str = 'false' then begin
    print ('say 要有满2级神功 50');
    exit;
end;
```
> 来源：`老侠客.txt`

### 完整的升级任务接取流程
```pascal
// 1. 检查是否已在做升级任务
Str := callfunc ('gethavegradequestitem');
if Str = 'true' then begin
    print ('say 你已经在做升级任务 50');
    exit;
end;

// 2. 检查武功等级条件
Str := callfunc ('getpossiblegrade 0 0');
if Str = 'false' then begin
    print ('say 要有一个满1级的神功 50');
    exit;
end;

// 3. 检查背包空间
Str := callfunc ('checkenoughspace 1');
if Str = 'false' then begin
    print ('say 要空出一个物品栏栏位');
    exit;
end;

// 4. 检查金元
Str := callfunc ('getsenderitemexistence 金元:60');
if Str = 'false' then begin
    print ('say 要接2级任务,需支付60个金元 50');
    exit;
end;

// 5. 扣除金元，给予任务卷轴
print ('getsenderitem 金元:60');
print ('putsendermagicitem 侠客任务卷轴:1 @老侠客 4');
```
> 来源：`老侠客.txt`

## 注意事项

1. **返回值格式**：返回字符串 'true' 或 'false'
2. **参数含义**：第一个参数为绝世武功分组，第二个参数为已有武功的当前品级；示例中的 `0 0`、`0 1` 均检查护体分组
3. **任务前置条件**：用于检查玩家是否满足升级任务的前置武功等级要求
4. **配合使用**：通常与 `gethavegradequestitem`、`checkenoughspace`、`getsenderitemexistence` 配合使用

## 相关函数
- `gethavegradequestitem` - 获取等级任务物品状态
- `checksendercurusemagic` - 检查当前使用的武功
- `getsendermagicskilllevel` - 获取武功技能等级
