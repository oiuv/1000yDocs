# checkmagic

## 功能描述
通过脚本自身对象 `FSelf` 检查指定分类、类型和名称的武功。`FSelf` 为玩家时调用玩家的拥有武功检查，不是完整修炼资格检查，也不自动改查 `FSender`。

## 语法格式
```pascal
Str := callfunc('checkmagic 武功分类 武功类型 武功名称');
```

## 参数说明
- **武功分类**：Integer - `aMagicClass`，例如 3 为 `MAGICCLASS_BESTMAGIC`（绝世武功）
- **武功类型**：Integer - `aMagicType`，例如 9 为 `MAGICTYPE_PROTECTING`（护体），不是等级
- **武功名称**：String - 要检查的武功名称

## 返回值
- **成功**：'true' - 玩家已修炼了该武功
- **失败**：'false' - 玩家未修炼该武功

## 源码实现
```pascal
// uScriptManager.pas 的 CallFunction
end else if cmd = 'checkmagic' then begin
   Result := TBasicObject (FSelf).SCheckMagic (_StrToInt (Params [0]), _StrToInt (Params [1]), Params [2]);
```

调用 `TBasicObject.SCheckMagic`，注意此处使用 `FSelf` 而非 `FSender`。因此 `checkmagic 3 9 名称` 表示按名称检查绝世护体武功，不表示“9 级护身武功”。依据：[UUser.pas](../../help/TGS核心源码/UUser.pas)、[deftype.pas](../../help/deftype.pas)。

## 使用示例

### 检查四大神功修炼状态
```pascal
// 检查是否已修炼血天魔功
Str := callfunc ('checkmagic 3 9 血天魔功');
if Str = 'true' then begin
    print ('sendsenderchatmessage 已修炼了此武功 2');
    exit;
end;

print ('showwindow .\help\四大神功1.txt 0');
```
> 来源：`四大神功全集.txt`

### 检查日月神功
```pascal
Str := callfunc ('checkmagic 3 9 日月神功');
if Str = 'true' then begin
    print ('sendsenderchatmessage 已修炼了此武功 2');
    exit;
end;
```
> 来源：`四大神功全集.txt`

### 检查北冥神功
```pascal
Str := callfunc ('checkmagic 3 9 北冥神功');
if Str = 'true' then begin
    print ('sendsenderchatmessage 已修炼了此武功 2');
    exit;
end;
```
> 来源：`四大神功全集.txt`

### 检查紫霞神功
```pascal
Str := callfunc ('checkmagic 3 9 紫霞神功');
if Str = 'true' then begin
    print ('sendsenderchatmessage 已修炼了此武功 2');
    exit;
end;
```
> 来源：`四大神功全集.txt`

## 注意事项

1. **返回值格式**：返回字符串 'true' 或 'false'
2. **FSelf 而非 FSender**：此函数使用 `FSelf` 对象，与其他 `getsender*` 函数不同
3. **三个参数**：需要同时指定武功分类、类型和名称，没有等级参数
4. **修炼检查**：主要用于检查玩家是否已经修炼了某个武功，避免重复修炼

## 相关函数
- `checksendercurusemagic` - 检查当前使用的武功
- `checkusemagicbygrade` - 按等级检查武功
- `getsendermagicskilllevel` - 获取武功技能等级
- `getsendermagiccountbyskill` - 获取武功数量
