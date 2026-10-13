# getstartarena

请求为触发玩家登记比武招亲等待项。当前实现不是调用后立即成为活动擂主。

## 语法

```pascal
Str := callfunc('getstartarena');
```

无参数。调用 `TUser.SStartArenaGame → ArenaObjList.AddMaster(Self)`，结果转为十进制字符串。

## 行为与返回值

- 外层 `TArenaObjList.AddMaster` 查找竞技场；内层返回 `ADDMASTER_OK = 0` 时，外层返回对应竞技场索引，因此正常返回值可以为 0 或正整数。
- 外层未找到可接受的竞技场时保留 `-1`。不能只把它解释为“已满”；玩家已参加活动导致内层拒绝时，也可能在外层得到 `-1`。
- 内层有效分支调用 `JoinArena(1, ID)`、加入 `WaitPlayerList`，按位置生成绿绣球或红绣球，并增加等待计数。
- 直接执行 `MasterUser := aUser` 的旧分支位于注释中。实际擂主赋值还依赖后续流程，不能用本次返回值证明玩家已成为当前擂主。
- 内层等待列表已满时没有明确设置返回值，外层返回也不能作为严格可靠的排队成功凭据。

## 示例

```pascal
Str := callfunc('getstartarena');
if Str = '-1' then begin
    print('say 暂时无法登记比武招亲');
    exit;
end;
// 不在这里宣告已经成为当前擂主；后续需按实际擂台流程处理
```

源码依据：[uArena.pas](../../help/TGS核心源码/uArena.pas) 的 `TArenaObject.AddMaster`、`TArenaObjList.AddMaster`，以及 [UUser.pas](../../help/TGS核心源码/UUser.pas) 的 `SStartArenaGame`。

相关接口：[getintoarena](getintoarena.md)、[getaddmember](../玩家属性函数/getaddmember.md)。
