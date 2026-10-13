# getintoarena

请求将触发玩家加入指定竞技场。参数是竞技场列表的 Key，不是地图 ID。

## 语法

```pascal
Str := callfunc('getintoarena 0');
```

参数经 `_StrToInt` 转换后传入 `Word` 类型的 `aArenaKey`。应只传有效的非负列表索引。

## 返回值

| 字符串 | 实际含义 |
| --- | --- |
| `'-1'` | Key 不在竞技场列表中 |
| `'-3'` | 玩家 `CheckArena > 0`，已参加其它擂台活动 |
| `'-2'` | 该竞技场 `MasterUser = nil` |
| `'0'` | 内层默认结果；可能已加入，也可能满员而未加入 |

`TArenaObject.AddMember` 先将结果设为 `ADDMEMBER_OK = 0`，只有 `DataList.Count < MemberAmount` 才调用 `JoinArena`、加入列表并移动角色。满员分支没有把结果改成失败，因此不能依据 `'0'` 宣告加入成功，也不能把 `'-1'` 当作满员错误码。

## 示例

```pascal
Str := callfunc('getintoarena 0');
if Str = '-1' then begin
    print('say 竞技场编号无效');
    exit;
end;
if Str = '-2' then begin
    print('say 当前没有擂主');
    exit;
end;
if Str = '-3' then begin
    print('say 你已参加其它擂台活动');
    exit;
end;
// 返回 0 仍不能证明已入场；不要据此直接扣款或发放入场奖励
```

源码依据：[uArena.pas](../../help/TGS核心源码/uArena.pas) 的 `TArenaObjList.AddMember`、`TArenaObject.AddMember`；[UUser.pas](../../help/TGS核心源码/UUser.pas) 的 `SGetIntoArenaGame`。

相关接口：[getstartarena](getstartarena.md)、[getaddmember](../玩家属性函数/getaddmember.md)。
