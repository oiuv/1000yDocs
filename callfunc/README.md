# CallFunc 函数参考

> 权威依据：`tgs1000/uScriptManager.pas` 中当前有效的 `TScriptManager.CallFunction` 分支。

## 调用格式

```pascal
Str := callfunc('函数名 参数1 参数2 ...');
```

- 函数名和参数按空格拆分，返回值统一为字符串。函数名是字符串内容，分派前不会转换大小写；当前登记名称均为小写，应按索引精确书写。
- 数值结果通常由源码中的 `IntToStr` 转换；需要计算时再用脚本 `StrToInt`。
- `sender` 表示触发事件的玩家，非 `sender` 版本通常作用于脚本自身对象 `FSelf`。
- 参数中的下划线不会被 `callfunc` 入口统一转换；是否处理取决于具体函数实现。

## 当前覆盖

当前源码支持 **111** 个有效 CallFunc 名称（含别名），以下均有独立说明页。

### 地图场景函数

- [`checkalivemopcount`](地图场景函数/checkalivemopcount.md)
- [`checkentermap`](地图场景函数/checkentermap.md)
- [`checkobjectalive`](地图场景函数/checkobjectalive.md)
- [`findobjectbyname`](地图场景函数/findobjectbyname.md)
- [`getdistance`](地图场景函数/getdistance.md)
- [`getevent`](地图场景函数/getevent.md)
- [`getintoarena`](地图场景函数/getintoarena.md)
- [`getintozhuang`](地图场景函数/getintozhuang.md)
- [`getmapname`](地图场景函数/getmapname.md)
- [`getmoveablexy`](地图场景函数/getmoveablexy.md)
- [`getnearxy`](地图场景函数/getnearxy.md)
- [`getposition`](地图场景函数/getposition.md)
- [`getremainmaptime`](地图场景函数/getremainmaptime.md)
- [`getsendermapname`](地图场景函数/getsendermapname.md)
- [`getsetevent`](地图场景函数/getsetevent.md)
- [`getstartarena`](地图场景函数/getstartarena.md)
- [`getsysteminfo`](地图场景函数/getsysteminfo.md)
- [`getusercount`](地图场景函数/getusercount.md)
- [`getzhuangfight`](地图场景函数/getzhuangfight.md)
- [`getzhuangticketprice`](地图场景函数/getzhuangticketprice.md)
- [`setevent`](地图场景函数/setevent.md)（与 `getsetevent` 同义）

### 任务系统函数

- [`getcompletequest`](任务系统函数/getcompletequest.md)
- [`getcurrentquest`](任务系统函数/getcurrentquest.md)
- [`getfirstquest`](任务系统函数/getfirstquest.md)
- [`getpassmissiontime`](任务系统函数/getpassmissiontime.md)
- [`getsendercompletequest`](任务系统函数/getsendercompletequest.md)
- [`getsendercurrentquest`](任务系统函数/getsendercurrentquest.md)
- [`getsenderfirstquest`](任务系统函数/getsenderfirstquest.md)
- [`getsenderqueststr`](任务系统函数/getsenderqueststr.md)
- [`startmissiontime`](任务系统函数/startmissiontime.md)

### 玩家属性函数

- [`checkenoughspace`](玩家属性函数/checkenoughspace.md)
- [`getaddmember`](玩家属性函数/getaddmember.md)
- [`getage`](玩家属性函数/getage.md)
- [`getarmlife`](玩家属性函数/getarmlife.md)
- [`getheadlife`](玩家属性函数/getheadlife.md)
- [`getid`](玩家属性函数/getid.md)
- [`getinpower`](玩家属性函数/getinpower.md)
- [`getleglife`](玩家属性函数/getleglife.md)
- [`getlife`](玩家属性函数/getlife.md)
- [`getmagic`](玩家属性函数/getmagic.md)
- [`getmarryclothes`](玩家属性函数/getmarryclothes.md)
- [`getmarryinfo`](玩家属性函数/getmarryinfo.md)
- [`getmaxinpower`](玩家属性函数/getmaxinpower.md)
- [`getmaxlife`](玩家属性函数/getmaxlife.md)
- [`getmaxmagic`](玩家属性函数/getmaxmagic.md)
- [`getmaxoutpower`](玩家属性函数/getmaxoutpower.md)
- [`getmovespeed`](玩家属性函数/getmovespeed.md)
- [`getname`](玩家属性函数/getname.md)
- [`getoutpower`](玩家属性函数/getoutpower.md)
- [`getparty`](玩家属性函数/getparty.md)
- [`getpower`](玩家属性函数/getpower.md)
- [`getrace`](玩家属性函数/getrace.md)
- [`getsenderage`](玩家属性函数/getsenderage.md)
- [`getsenderarmlife`](玩家属性函数/getsenderarmlife.md)
- [`getsendercurdurawatercase`](玩家属性函数/getsendercurdurawatercase.md)
- [`getsendercurpowerlevel`](玩家属性函数/getsendercurpowerlevel.md)
- [`getsendercurpowerlevelname`](玩家属性函数/getsendercurpowerlevelname.md)
- [`getsenderguildname`](玩家属性函数/getsenderguildname.md)
- [`getsenderheadlife`](玩家属性函数/getsenderheadlife.md)
- [`getsenderid`](玩家属性函数/getsenderid.md)
- [`getsenderinpower`](玩家属性函数/getsenderinpower.md)
- [`getsenderjobgrade`](玩家属性函数/getsenderjobgrade.md)
- [`getsenderjobkind`](玩家属性函数/getsenderjobkind.md)
- [`getsenderleglife`](玩家属性函数/getsenderleglife.md)
- [`getsenderlife`](玩家属性函数/getsenderlife.md)
- [`getsendermagic`](玩家属性函数/getsendermagic.md)
- [`getsendermaxinpower`](玩家属性函数/getsendermaxinpower.md)
- [`getsendermaxlife`](玩家属性函数/getsendermaxlife.md)
- [`getsendermaxmagic`](玩家属性函数/getsendermaxmagic.md)
- [`getsendermaxoutpower`](玩家属性函数/getsendermaxoutpower.md)
- [`getsendermovespeed`](玩家属性函数/getsendermovespeed.md)
- [`getsendername`](玩家属性函数/getsendername.md)
- [`getsenderoutpower`](玩家属性函数/getsenderoutpower.md)
- [`getsenderposition`](玩家属性函数/getsenderposition.md)
- [`getsenderpower`](玩家属性函数/getsenderpower.md)
- [`getsenderrace`](玩家属性函数/getsenderrace.md)
- [`getsenderserverid`](玩家属性函数/getsenderserverid.md)
- [`getsendersex`](玩家属性函数/getsendersex.md)
- [`getsendertalent`](玩家属性函数/getsendertalent.md)
- [`getsendervirtue`](玩家属性函数/getsendervirtue.md)
- [`getserverid`](玩家属性函数/getserverid.md)
- [`getsex`](玩家属性函数/getsex.md)
- [`getvirtue`](玩家属性函数/getvirtue.md)
- [`setparty`](玩家属性函数/setparty.md)

### 武功技能函数

- [`checkmagic`](武功技能函数/checkmagic.md)
- [`checksendercurusemagic`](武功技能函数/checksendercurusemagic.md)
- [`checkusemagicbygrade`](武功技能函数/checkusemagicbygrade.md)
- [`conditionbestattackmagic`](武功技能函数/conditionbestattackmagic.md)
- [`getsendermagiccountbyskill`](武功技能函数/getsendermagiccountbyskill.md)
- [`getsendermagicskilllevel`](武功技能函数/getsendermagicskilllevel.md)
- [`getsenderuseattackmagic`](武功技能函数/getsenderuseattackmagic.md)
- [`getsenderuseattackskilllevel`](武功技能函数/getsenderuseattackskilllevel.md)
- [`getsenderuseprotectmagic`](武功技能函数/getsenderuseprotectmagic.md)
- [`getuseattackmagic`](武功技能函数/getuseattackmagic.md)
- [`getuseattackskilllevel`](武功技能函数/getuseattackskilllevel.md)
- [`getuseprotectmagic`](武功技能函数/getuseprotectmagic.md)

### 物品背包函数

- [`checksenderattribitem`](物品背包函数/checksenderattribitem.md)
- [`checksenderpowerwearitem`](物品背包函数/checksenderpowerwearitem.md)
- [`getcheckpickup`](物品背包函数/getcheckpickup.md)
- [`gethavegradequestitem`](物品背包函数/gethavegradequestitem.md)
- [`getpossiblegrade`](物品背包函数/getpossiblegrade.md)
- [`getquestitem`](物品背包函数/getquestitem.md)
- [`getrandomitem`](物品背包函数/getrandomitem.md)
- [`getsenderdestroyitem`](物品背包函数/getsenderdestroyitem.md)
- [`getsenderitemcountbyname`](物品背包函数/getsenderitemcountbyname.md)
- [`getsenderitemcurdurability`](物品背包函数/getsenderitemcurdurability.md)
- [`getsenderitemexistence`](物品背包函数/getsenderitemexistence.md)
- [`getsenderitemexistencebykind`](物品背包函数/getsenderitemexistencebykind.md)
- [`getsenderitemmaxdurability`](物品背包函数/getsenderitemmaxdurability.md)
- [`getsenderrepairitem`](物品背包函数/getsenderrepairitem.md)
- [`getsenderwearitemname`](物品背包函数/getsenderwearitemname.md)

## 未实现的历史名称

- [`getjobgrade`](玩家属性函数/getjobgrade.md)：当前源码没有有效处理分支，仅保留迁移说明，不计入有效 API。
