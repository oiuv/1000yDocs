# 物品类型常量 (ITEM_KIND_*)

> 源码: `1000ydef/deftype.pas` 第 105-170 行

定义物品的功能和行为类型，对应 `Init_Item.sdb` 中的 `kind` 字段。

---

## 常量列表

| 常量名 | 值 | 中文说明 | 详细说明 |
|--------|---:|----------|----------|
| `ITEM_KIND_NONE` | 0 | 无 | 空物品 |
| `ITEM_KIND_COLORDRUG` | 1 | 彩色药 | 带颜色的药品 |
| `ITEM_KIND_BOOK` | 2 | 书籍 | 武功秘籍，双击学习武功 |
| `ITEM_KIND_WEARITEM` | 6 | 穿戴物品 | 普通装备（衣服/帽子/鞋等） |
| `ITEM_KIND_ARROW` | 7 | 箭矢 | 弓术用弹药 |
| `ITEM_KIND_FLYSWORD` | 8 | 飞剑 | 御剑飞行道具 |
| `ITEM_KIND_GUILDSTONE` | 9 | 门派基石 | 创建门派的基石物品 |
| `ITEM_KIND_DUMMY` | 10 | 虚拟物品 | 不存在的占位物品 |
| `ITEM_KIND_STATICITEM` | 11 | 静态物品 | 不可移动的场景装饰物 |
| `ITEM_KIND_DRUG` | 13 | 药品 | 可服用的药品（配合 ITEM_DRUG_TYPE） |
| `ITEM_KIND_TICKET` | 18 | 门票 | 传送门使用的移动符/门票 |
| `ITEM_KIND_HIDESKILL` | 19 | 隐身术 | 隐身技能物品 |
| `ITEM_KIND_CANTMOVE` | 20 | 不可移动 | 无法放入背包的物品 |
| `ITEM_KIND_ITEMLOG` | 21 | 福袋入口物品 | 历史常量名含 `ITEMLOG`；实际界面是个人储物空间，不是获取日志 |
| `ITEM_KIND_CHANGER` | 22 | 变换器 | 变身/转换类物品 |
| `ITEM_KIND_SHOWSKILL` | 23 | 显示技能 | 展示类技能物品 |
| `ITEM_KIND_WEARITEM2` | 24 | 穿戴物品2 | 第二种穿戴物品（武器类） |
| `ITEM_KIND_FOXMIRROR` | 25 | 狐镜 | 九尾狐相关镜子道具 |
| `ITEM_KIND_GUILDLETTER` | 26 | 门元推荐信 | 加入门派的推荐信 |
| `ITEM_KIND_PICKAX` | 27 | 曲柄 | 普通采矿工具 |
| `ITEM_KIND_MINERAL` | 28 | 矿物 | 采矿获得的矿石 |
| `ITEM_KIND_CAP` | 29 | 帽子 | 特殊的头部装备（甲박 머리 안나오게） |
| `ITEM_KIND_PROCESSDRUG` | 30 | 加工试药 | 技术加工用试药 |
| `ITEM_KIND_HELPDRUG` | 31 | 辅助试药 | 辅助类试药 |
| `ITEM_KIND_GROWTHHERB` | 32 | 生长药草 | 可成长的药草 |
| `ITEM_KIND_SKILLROLLPAPER` | 33 | 卷轴 | 技能卷轴/두루마리 |
| `ITEM_KIND_QUESTITEM` | 34 | 任务物品 | 帝王石窟等任务专用物品（不可堆叠） |
| `ITEM_KIND_WATERCASE` | 35 | 水桶 | 竹筒/大型竹筒，装水容器 |
| `ITEM_KIND_CHARM` | 36 | 护符 | 持有即生效的属性物品（任务用） |
| `ITEM_KIND_QUESTLOG` | 37 | 任务日志 | 如书信等任务记录物品 |
| `ITEM_KIND_SUBITEM` | 38 | 附加物品 | 需配合特定装备才生效的附加物品 |
| `ITEM_KIND_NAMEDPOSQUEST` | 39 | 命名位置任务 | 指定位置的任务物品 |
| `ITEM_KIND_QUESTITEM2` | 40 | 任务物品2 | 可堆叠的任务物品 |
| `ITEM_KIND_FILL` | 41 | 填充药 | 五色药水（新手村恢复活力/内/外/武功） |
| `ITEM_KIND_SPECIALEFFECT` | 42 | 特效物品 | 在物品栏中产生特殊效果的物品 |
| `ITEM_KIND_ADDATTRIBITEM` | 43 | 属性追加物品 | 为装备附加属性的物品 |
| `ITEM_KIND_GOLDBAG` | 44 | 金囊 | 雨中客的金囊 |
| `ITEM_KIND_DAGGEROFOS` | 45 | 玉仙双刀 | 玉线的无情双刀 |
| `ITEM_KIND_DUBU` | 46 | 豆腐 | 流放地豆腐（离开流放地时消失） |
| `ITEM_KIND_DELATTRIBITEM` | 47 | 属性删除物品 | 清除装备附加属性的物品 |
| `ITEM_KIND_TRANSMONSTER` | 48 | 变身怪物 | 使玩家变身为怪物的物品 |
| `ITEM_KIND_RECOVERYHUMAN` | 49 | 恢复人形 | 从怪物变回人类的物品 |
| `ITEM_KIND_GRADEUPQUESTITEM` | 50 | 升段任务物品 | 职业升段用任务物品 |
| `ITEM_KIND_DURABILITY` | 51 | 耐久物品 | 所有有耐久度的物品 |
| `ITEM_KIND_TOPLETTER` | 52 | 广播信 | 双击后全服广播的信件 |
| `ITEM_KIND_GUILDLOTTERY` | 53 | 门派彩票 | 门派大战复权彩票 |
| `ITEM_KIND_SET` | 54 | 套装 | 套装物品 |
| `ITEM_KIND_DBLRANDOM` | 55 | 双击随机 | 双击后随机获得物品的物品 |
| `ITEM_KIND_USESCRIPT` | 56 | 脚本物品 | 使用脚本逻辑的物品（双击触发脚本） |
| `ITEM_KIND_HIGHPICKAX` | 57 | 高级曲柄 | 高级采矿工具 |
| `ITEM_KIND_SEAL` | 58 | 封印符 | 封印类符咒 |
| `ITEM_KIND_EIGHTANGLES` | 59 | 八角怪 | 八角怪相关物品 |
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

- [Init_item.sdb.md](../Init_item.sdb.md) — 物品数据库结构
- [ITEM_ATTRIBUTE.md](ITEM_ATTRIBUTE.md) — 物品属性常量
- [ITEM_SPKIND.md](ITEM_SPKIND.md) — 物品特殊类型
