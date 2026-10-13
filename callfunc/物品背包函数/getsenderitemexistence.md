# getsenderitemexistence

## 功能描述
检查触发玩家是否满足指定物品条件。背包匹配失败时，玩家实现还会尝试按名称寻找已拥有武功，因此返回 `'true'` 不一定证明背包里有该数量的物品。

## 语法格式
```pascal
Str := callfunc('getsenderitemexistence 物品名称:数量 匹配选项');
```

## 参数说明
- **物品名称:数量**：String - 物品名称和所需数量，用冒号 `:` 分隔。格式为 `物品名称:数量`
- **匹配选项**：独立的第二个参数 `aOption`，省略时按 0 处理。0 要求名称、`rUpgrade`、`rAddType` 匹配且数量足够；1 只按名称及数量匹配。

## 返回值
- **'true'**：背包中有一堆满足匹配条件和数量，或背包匹配失败后按名称找到了已拥有武功
- **'false'**：物品定义无效，或背包和武功回退检查均未通过

## 源码实现
```pascal
// uScriptManager.pas 第568行
end else if cmd = 'getsenderitemexistence' then begin
   Result := TBasicObject (FSender).SGetItemExistence (Params [0], _StrToInt (Params [1]));
```

调用 `TBasicObject.SGetItemExistence`。玩家实现先从第一个参数拆出物品名称与数量，将独立第二参数作为 `aOption` 传给 `FindItembyCount`。该方法逐槽检查单堆数量，不合计多堆。参见 [UUser.pas](../../help/TGS核心源码/UUser.pas) 的 `SGetItemExistence` 和 [uUserSub.pas](../../help/TGS核心源码/uUserSub.pas) 的 `FindItembyCount`。

## 使用示例

### 基础物品检查
```pascal
// 检查是否有1个神秘箱子
Str := callfunc ('getsenderitemexistence 神秘箱子:1');
if Str = 'false' then begin
    print ('say 没看见我正忙着吗?!');
    exit;
end;
```
> 来源：`quest铁匠.txt`

### 钱币检查
```pascal
// 检查钱币是否足够（门票1000钱币）
Str := callfunc ('getsenderitemexistence 钱币:1000');
if Str = 'false' then begin
    print ('say 钱币不足，入场门票需1000钱币');
    exit;
end;
```
> 来源：`一级比武老人.txt`

### 金元检查
```pascal
// 检查60个金元
Str := callfunc ('getsenderitemexistence 金元:60');
if Str = 'false' then begin
    print ('say 需金元60');
    exit;
end;
```
> 来源：`梅花夫人.txt`

### 血石检查
```pascal
// 检查30个血石
Name := callfunc('getsenderitemexistence 血石:30');
if Name = 'false' then begin
    Str := 'say 这真的是萧郎让你交给我的玛瑙石么？怎么颜色这么暗淡？';
    print (Str);
    exit;
end;
```
> 来源：`素莲.txt`

## 注意事项

1. **返回值格式**：返回字符串 'true' 或 'false'，需要进行字符串比较
2. **参数格式**：物品名称和数量之间用冒号 `:` 分隔
3. **数量检查**：背包分支检查单堆数量；武功名称回退分支不按该数量比较，不能把本接口当作无条件的背包库存证明
4. **与 getsenderitemcountbyname 的区别**：本函数返回布尔值，`getsenderitemcountbyname` 返回具体数量

## 相关函数
- `getsenderitemcountbyname` - 获取指定名称物品的数量
- `getsenderitemexistencebykind` - 按种类检查物品是否存在
- `checkenoughspace` - 检查背包空间是否足够
