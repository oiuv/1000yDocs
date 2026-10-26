# getsenderguildname

## 功能

返回当前事件发送者玩家的门派名称。只读取当前玩家对象的 `GuildName`，不修改门派、背包、任务或领取记录。

## 语法与返回值

```pascal
GuildName := callfunc('getsenderguildname');
```

无参数，函数名使用小写。

| 当前发送者状态 | 返回值 |
|---|---|
| 已加入门派的玩家 | 门派真实名称，不含称号或物品显示名称 |
| 未加入门派的玩家 | 空字符串 `''` |
| 无发送者，或发送者不是玩家 | 空字符串 `''` |

每次调用读取当前值；玩家加入或退出门派后，后续调用反映更新后的状态。本函数不查询离线角色，也不能据此判断角色是否为新玩家、是否领取过奖励或是否仍在退派冷却期。

## 脚本示例

以下为玩家触发的 NPC 事件处理片段，局部变量 `GuildName` 声明为 `String`：

```pascal
GuildName := callfunc('getsenderguildname');
if GuildName <> '' then begin
   print('sendsenderchatmessage 你已经加入门派，无需领取入门凭证。 3');
   exit;
end;
```

通过门派检查后，发奖脚本仍需独立检查新手资格、领取记录、已有物品及背包空间。非玩家事件也返回空字符串，因此发奖入口应先确认发送者是玩家。

## 与入门凭证的关系

`Kind=26` 是通用入门凭证类型。物品内部名称 `Name` 必须与目标门派真实名称一致，交给对应门派香炉时据此校验；物品显示名称 `ViewName` 可按玩法命名为推荐书、门派手令等，不参与门派匹配。不同门派可以配置各自的凭证，不能把显示名称当作门派名称判断。

本函数仅查询已有门派，不代替香炉对凭证、门派成立状态、已有门派及退派冷却等条件的检查。

## 适用条件与依据

需要 TGS 已包含 `getsenderguildname` 分支；部署对应服务程序后，脚本才能使用。没有该分支的旧服务程序对未知函数同样返回空字符串，不能把旧程序的空结果当成玩家无门派。

- 分派与读取：[uScriptManager.pas](../../help/TGS核心源码/uScriptManager.pas) 的 `TScriptManager.CallFunction`。
- 玩家门派状态：[UUser.pas](../../help/TGS核心源码/UUser.pas) 的 `TUser.GuildName`。
- 入门凭证校验：[uUserSub.pas](../../help/TGS核心源码/uUserSub.pas) 的 `JoinGuildByLetter`。
