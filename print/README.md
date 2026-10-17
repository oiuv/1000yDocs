# Print 命令参考

> 权威依据：`tgs1000/uScriptManager.pas` 中当前有效的 `TScriptManager.CommandScript`（另含 `checkitemregen` 的入口专用处理） 分支。

## 调用格式

```pascal
print('命令名 参数1 参数2 ...');
```

- 命令名和参数按空格拆分；命令本身没有返回值。命令名是字符串内容，分派前不会转换大小写，应使用索引中的精确形式（包括 `boMapEnter`、`decreasePrisonTime` 的历史大小写）。
- 下划线转空格不是全局规则，只有 `say`、聊天/公告等明确调用 `ChangeScriptString` 的分支会转换。
- `sender` 表示触发事件的玩家；其他命令可能作用于脚本自身对象。
- 参数缺失时多数分支不会报告脚本错误，部署前应严格按对应页面核对。

## 当前覆盖

当前源码共有 **76** 个有效 Print 命令（含入口专用的 `checkitemregen`），以下均有独立说明页。

### 对话消息命令

- [`say`](对话消息命令/say.md)
- [`saybyname`](对话消息命令/saybyname.md)
- [`sendcentermsg`](对话消息命令/sendcentermsg.md)
- [`sendnoticemsgformapuser`](对话消息命令/sendnoticemsgformapuser.md)
- [`sendsenderchatmessage`](对话消息命令/sendsenderchatmessage.md)
- [`sendsendertopmsg`](对话消息命令/sendsendertopmsg.md)
- [`sendsound`](对话消息命令/sendsound.md)
- [`sendzoneeffectmsg`](对话消息命令/sendzoneeffectmsg.md)

### 任务系统命令

- [`changecompletequest`](任务系统命令/changecompletequest.md)
- [`changecurrentquest`](任务系统命令/changecurrentquest.md)
- [`changefirstquest`](任务系统命令/changefirstquest.md)
- [`changesendercompletequest`](任务系统命令/changesendercompletequest.md)
- [`changesendercurrentquest`](任务系统命令/changesendercurrentquest.md)
- [`changesenderfirstquest`](任务系统命令/changesenderfirstquest.md)
- [`changesenderqueststr`](任务系统命令/changesenderqueststr.md)
- [`questcomplete`](任务系统命令/questcomplete.md)

### 玩家操作命令

- [`addaddablestatepoint`](玩家操作命令/addaddablestatepoint.md)
- [`addtotalstatepoint`](玩家操作命令/addtotalstatepoint.md)
- [`attack`](玩家操作命令/attack.md)
- [`decreasePrisonTime`](玩家操作命令/decreasePrisonTime.md)
- [`gotoxy`](玩家操作命令/gotoxy.md)
- [`marry`](玩家操作命令/marry.md)
- [`reposition`](玩家操作命令/reposition.md)
- [`returndamage`](玩家操作命令/returndamage.md)
- [`selfkill`](玩家操作命令/selfkill.md)
- [`senderrefill`](玩家操作命令/senderrefill.md)
- [`setmarryclothes`](玩家操作命令/setmarryclothes.md)
- [`setoutzhuang`](玩家操作命令/setoutzhuang.md)
- [`setsenderjobkind`](玩家操作命令/setsenderjobkind.md)
- [`setsendervirtueman`](玩家操作命令/setsendervirtueman.md)
- [`unmarry`](玩家操作命令/unmarry.md)
- [`usemagicgradeup`](玩家操作命令/usemagicgradeup.md)

### 物品交易命令

- [`changesendercurdurabyname`](物品交易命令/changesendercurdurabyname.md)
- [`checkitemregen`](物品交易命令/checkitemregen.md)
- [`deletequestitem`](物品交易命令/deletequestitem.md)
- [`getsenderallitem`](物品交易命令/getsenderallitem.md)
- [`getsenderitem`](物品交易命令/getsenderitem.md)
- [`getsenderitem2`](物品交易命令/getsenderitem2.md)
- [`guilditemwindow`](物品交易命令/guilditemwindow.md)
- [`logitemwindow`](物品交易命令/logitemwindow.md)
- [`putsendermagicitem`](物品交易命令/putsendermagicitem.md)
- [`sendersmeltitem`](物品交易命令/sendersmeltitem.md)
- [`sendersmeltitem2`](物品交易命令/sendersmeltitem2.md)
- [`senditemmoveinfo`](物品交易命令/senditemmoveinfo.md)
- [`tradewindow`](物品交易命令/tradewindow.md)

### 系统控制命令

- [`activebank`](系统控制命令/activebank.md)
- [`athleticprocess`](系统控制命令/athleticprocess.md)
- [`bohitallbyname`](系统控制命令/bohitallbyname.md)
- [`boiceallbyname`](系统控制命令/boiceallbyname.md)
- [`boMapEnter`](系统控制命令/boMapEnter.md)
- [`bopickbymapname`](系统控制命令/bopickbymapname.md)
- [`buymoneychip`](系统控制命令/buymoneychip.md)
- [`changedynobjstate`](系统控制命令/changedynobjstate.md)
- [`changesenderdynobjstate`](系统控制命令/changesenderdynobjstate.md)
- [`changestate`](系统控制命令/changestate.md)
- [`clearworkbox`](系统控制命令/clearworkbox.md)
- [`commandice`](系统控制命令/commandice.md)
- [`commandicebyname`](系统控制命令/commandicebyname.md)
- [`directmovespace`](系统控制命令/directmovespace.md)
- [`mapaddobjbyname`](系统控制命令/mapaddobjbyname.md)
- [`mapaddobjbytick`](系统控制命令/mapaddobjbytick.md)
- [`mapdelobjbyname`](系统控制命令/mapdelobjbyname.md)
- [`mapregen`](系统控制命令/mapregen.md)
- [`mapregenbyname`](系统控制命令/mapregenbyname.md)
- [`movespace`](系统控制命令/movespace.md)
- [`movespacebyname`](系统控制命令/movespacebyname.md)
- [`regen`](系统控制命令/regen.md)
- [`selfchangedynobjstate`](系统控制命令/selfchangedynobjstate.md)
- [`setallowdelete`](系统控制命令/setallowdelete.md)
- [`setallowhit`](系统控制命令/setallowhit.md)
- [`setallowhitbyname`](系统控制命令/setallowhitbyname.md)
- [`setallowhitbytick`](系统控制命令/setallowhitbytick.md)
- [`setautomode`](系统控制命令/setautomode.md)
- [`showeffect`](系统控制命令/showeffect.md)
- [`startwindow`](系统控制命令/startwindow.md)

### 系统命令

- [`showwindow`](系统命令/showwindow.md)

## 未实现的历史名称

- [`changequeststr`](任务系统命令/changequeststr.md)：当前源码没有有效处理分支，仅保留迁移说明，不计入有效 API。
