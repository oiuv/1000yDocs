# 物品类型常量 (ITEM_KIND_*)

> 源码: [deftype.pas](../deftype.pas) 第 114-168 行（`ITEM_KIND_*`）

定义物品的功能和行为类型，对应 `Init/Item.sdb` 中的 `Kind` 字段。中文物品名以随包表的 `ViewName` 为准，内部键使用 `Name`；功能描述须结合使用分支，不能仅从英文常量名推断。

---

## 常量列表

| 常量名 | 值 | 中文说明 | 详细说明 |
|--------|---:|----------|----------|
| `ITEM_KIND_NONE` | 0 | 未指定功能类型 | 随包制造工具如无名槌、无名火炉也使用 0，不能据此认定为空物品 |
| `ITEM_KIND_COLORDRUG` | 1 | 染色剂 | 如紫色染剂；拖到允许染色的穿戴物品上使用 |
| `ITEM_KIND_BOOK` | 2 | 书籍 | 武功秘籍，双击学习武功 |
| `ITEM_KIND_WEARITEM` | 6 | 穿戴物品 | 普通装备（衣服/帽子/鞋等） |
| `ITEM_KIND_ARROW` | 7 | 箭矢 | 弓术用弹药 |
| `ITEM_KIND_FLYSWORD` | 8 | 飞刀、暗器类 | 如飞刀、半月镖、仙鹤神针；不是御剑飞行道具 |
| `ITEM_KIND_GUILDSTONE` | 9 | 门派基石 | 创建门派的基石物品 |
| `ITEM_KIND_DUMMY` | 10 | 门派娃娃 | 如男子卒兵娃娃；表中说明为守门派石的卒兵 |
| `ITEM_KIND_STATICITEM` | 11 | 静态物品 | 不可移动的场景装饰物 |
| `ITEM_KIND_DRUG` | 13 | 药品 | 可服用的药品（配合 ITEM_DRUG_TYPE） |
| `ITEM_KIND_TICKET` | 18 | 传送卷轴 | 如回城卷轴；双击按 `ServerId/X/Y` 传送，受地图限制 |
| `ITEM_KIND_HIDESKILL` | 19 | 隐身符 | 使用后进入隐身状态，受地图限制 |
| `ITEM_KIND_CANTMOVE` | 20 | 禁止交换的物品 | 如青龙牌；交换、交给其他角色的路径拒绝此类型，不表示不能放入背包 |
| `ITEM_KIND_ITEMLOG` | 21 | 福袋 | 双击扩充个人储物空间，成功后消耗一个；不是日志物品 |
| `ITEM_KIND_CHANGER` | 22 | 玫瑰脱色药类 | 随包物品为玫瑰脱色药；当前背包双击分派没有此类型分支，不据名称推断变身功能 |
| `ITEM_KIND_SHOWSKILL` | 23 | 透视符 | 使用后可看见隐身对象 |
| `ITEM_KIND_WEARITEM2` | 24 | 装备类型二 | 如女子梅花战袍；并非仅武器，穿在外衣位时还影响内衣外观显示 |
| `ITEM_KIND_FOXMIRROR` | 25 | 妖华镜 | 随包正式物品名；当前背包双击分支无有效执行语句 |
| `ITEM_KIND_GUILDLETTER` | 26 | 门派推荐书标记 | 当前背包双击处理已注释；正式显示名称需以实际物品配置为准 |
| `ITEM_KIND_PICKAX` | 27 | 十字镐 | 如青铜十字镐、钢铁十字镐、象牙十字镐，供采矿使用 |
| `ITEM_KIND_MINERAL` | 28 | 矿物 | 采矿获得的矿石 |
| `ITEM_KIND_CAP` | 29 | 帽子类装备 | 如男子流星帽；穿戴后外观隐藏头发层 |
| `ITEM_KIND_PROCESSDRUG` | 30 | 加工试剂 | 溶华素、逐龙丹、太极液、桂圆丹 |
| `ITEM_KIND_HELPDRUG` | 31 | 辅助试剂 | 精华素、草芥丹、生死梦幻丹，用于提高加工成功率 |
| `ITEM_KIND_GROWTHHERB` | 32 | 药草材料 | 如葛根、甘草、何首乌；不由英文名称推断成长机制 |
| `ITEM_KIND_SKILLROLLPAPER` | 33 | 卷轴（技术密笈） | 随包 `Name=技术密笈`、`ViewName=卷轴`；双击按职业编号打开对应帮助文件 |
| `ITEM_KIND_QUESTITEM` | 34 | 任务物品 | 帝王石窟等任务专用物品（不可堆叠） |
| `ITEM_KIND_WATERCASE` | 35 | 水桶 | 竹筒/大型竹筒，装水容器 |
| `ITEM_KIND_CHARM` | 36 | 背包活力加成物品 | 如不灭；在背包中按 `cLife` 增加活力上限，配合 `SpecialKind=7` 还增加头、手臂、腿部活力上限 |
| `ITEM_KIND_QUESTLOG` | 37 | 任务日志 | 如书信等任务记录物品 |
| `ITEM_KIND_SUBITEM` | 38 | 装备联动加成物品 | 如太极牌；要求物品 `Attribute` 与当前武器一致，且此类物品在背包中只占一个槽位 |
| `ITEM_KIND_NAMEDPOSQUEST` | 39 | 四大宝石类 | 随包为珍珠、翡翠、水晶、琥珀；不按英文名推断坐标任务 |
| `ITEM_KIND_QUESTITEM2` | 40 | 任务物品2 | 可堆叠的任务物品 |
| `ITEM_KIND_FILL` | 41 | 五色药水类 | 定时恢复活力、内功、外功、武功等属性，要求地图属性为 `MAP_TYPE_FILL` |
| `ITEM_KIND_SPECIALEFFECT` | 42 | 背包属性加成物品 | 将背包中首个此类型物品的 `rLifeData` 纳入属性加成，不是画面特效分类 |
| `ITEM_KIND_ADDATTRIBITEM` | 43 | 属性追加物品 | 为装备附加属性的物品 |
| `ITEM_KIND_GOLDBAG` | 44 | 雨中客锦囊 | 随包 `Name`、`ViewName` 均为雨中客锦囊，属于任务物品 |
| `ITEM_KIND_DAGGEROFOS` | 45 | 玉仙的无情双刀 | 随包正式物品名，属于任务物品 |
| `ITEM_KIND_DUBU` | 46 | 豆腐 | 流放地豆腐（离开流放地时消失） |
| `ITEM_KIND_DELATTRIBITEM` | 47 | 属性删除物品 | 清除装备附加属性的物品 |
| `ITEM_KIND_TRANSMONSTER` | 48 | 变身怪物预留类型 | 未见当前 TGS 的类型处理分支，不列为已实现功能 |
| `ITEM_KIND_RECOVERYHUMAN` | 49 | 恢复人形预留类型 | 未见当前 TGS 的类型处理分支，不列为已实现功能 |
| `ITEM_KIND_GRADEUPQUESTITEM` | 50 | 神功升级任务物品 | 如侠客任务卷轴、仙人卷轴；双击按 `QuestNum` 显示任务说明 |
| `ITEM_KIND_DURABILITY` | 51 | 普通耐久物品 | 如万毒钥匙；不是所有有耐久度物品的共同 Kind |
| `ITEM_KIND_TOPLETTER` | 52 | 广播输入物品类型 | 双击打开广播输入窗口并消耗一个物品，不等于已经发送全服广播 |
| `ITEM_KIND_GUILDLOTTERY` | 53 | 门派奖券类型 | 内部类型标记；正式物品名以实际配置为准 |
| `ITEM_KIND_SET` | 54 | 套装加成配置类型 | 穿戴物品中恰有四件 `Attribute=5` 时，读取名为 `SetValue` 且 `Kind=54` 的记录叠加属性；不是每件套装装备的 Kind |
| `ITEM_KIND_DBLRANDOM` | 55 | 双击随机 | 双击后随机获得物品的物品 |
| `ITEM_KIND_USESCRIPT` | 56 | 脚本物品 | 使用脚本逻辑的物品（双击触发脚本） |
| `ITEM_KIND_HIGHPICKAX` | 57 | 高级十字镐 | 随包为高级象牙十字镐 |
| `ITEM_KIND_SEAL` | 58 | 封印符 | 封印类符咒 |
| `ITEM_KIND_EIGHTANGLES` | 59 | 八卦牌 | 随包为八卦牌1～15；背包中首个此类物品耐久不为零时应用属性加成 |
| `ITEM_KIND_DURAWEAPON` | 60 | 耐久武器 | 有耐久度的武器 |
| `ITEM_KIND_EVENT1` | 200 | 事件物品1 | 活动专用物品，加工窗口可随机获得物品 |

---

## 药品子类型 (ITEM_DRUG_TYPE_*)

配合 `ITEM_KIND_DRUG` 使用，定义药品的生效方式：

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `ITEM_DRUG_TYPE_A` | 0 | 服用后按秒恢复固定量的属性值 |
| `ITEM_DRUG_TYPE_B` | 1 | 服用后按百分比恢复属性值 |
| `ITEM_DRUG_TYPE_C` | 2 | 增加最大属性值/属性，维持一定时间 |

---

## 脚本中使用

```pascal
// 检查背包中是否存在类型34（ITEM_KIND_QUESTITEM）的物品
Str := callfunc('getsenderitemexistencebykind 34 0');
if Str = 'true' then begin
   print('say 你身上有任务物品');
end;
```

## 相关文档

- 源码依据：[uUserSub.pas](../TGS核心源码/uUserSub.pas) 的 `THaveItemClass.DblClickProcess`、`SetAttribData`、`SetEffectItemLifeData`、`PutOnExchangeProcess`，以及 `TWearItemClass.AddColorDrug`、`GetFeature`。
- 名称依据：随包 `Init/Item.sdb`；加工试剂说明见[职业技能简介](<../炎黄新章游戏资料/职业技能/【职业技能】简介.txt>)。
- [Init_item.sdb.md](../Init_item.sdb.md) — 物品数据库结构
- [ITEM_ATTRIBUTE.md](ITEM_ATTRIBUTE.md) — 物品属性常量
- [ITEM_SPKIND.md](ITEM_SPKIND.md) — 物品特殊类型
