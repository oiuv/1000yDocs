# PowerLevel.sdb

元气等级数据配置文件，定义玩家的元气境界等级及各等级对应的属性加成。

## 文件路径

```
.\Init\PowerLevel.SDB
```

## 文件格式

CSV 格式，逗号分隔，首行为列名。

## 字段说明

| 列名 | 类型 | 说明 | 源码依据 |
|------|------|------|----------|
| Name | Integer | 等级编号；下表示例为 1～13，加载与查询的有效编号为 1～99 | 首列转为 sn 后访问 `PowerLevelArr[sn-1]`，不是按文件行位置编号 |
| ViewName | String | 境界名称 | `PowerLevelArr[sn-1].Name := TempDB.GetFieldValueString(iName, 'ViewName')` |
| PowerValue | Integer | 该境界所需的元气值 | `PowerLevelArr[sn-1].PowerValue := TempDB.GetFieldValueInteger(iName, 'PowerValue')` |
| LimitEnergy | Integer | 降低当前境界时，掌法伤害公式所用的元气折算上限；不是直接限制人物元气属性 | `PowerLevelArr[sn-1].LimitEnergy := TempDB.GetFieldValueInteger(iName, 'LimitEnergy')` |
| Damage | Integer | 攻击力加成值 | `PowerLevelArr[sn-1].Damage := TempDB.GetFieldValueInteger(iName, 'Damage')` |
| Armor | Integer | 防御力加成值 | `PowerLevelArr[sn-1].Armor := TempDB.GetFieldValueInteger(iName, 'Armor')` |
| AttackSpeed | Integer | 攻击速度加成；当前表内为空，加载为 0 | `GetPowerLevelAttackSpeed` 返回该值 |
| Avoid | Integer | 闪避加成；当前表内为空，加载为 0 | `GetPowerLevelAvoid` 返回该值 |
| Recovery | Integer | 恢复加成；当前表内为空，加载为 0 | `GetPowerLevelRecovery` 返回该值 |
| Accuracy | Integer | 命中加成；当前表内为空，加载为 0 | `GetPowerLevelAccuracy` 返回该值 |
| KeepRecovery | Integer | 维持恢复加成；当前表内为空，加载为 0 | `GetPowerLevelKeepRecovery` 返回该值 |

### 编号与连续性

已配置等级应从 1 连续填充：`CalcPowerLevel` 按数组顺序检查，遇到第一个空名称就停止，因此不能像地图 ID 一样任意跳号。加载器按 Name 的数值定位，文件行序本身不决定等级，但保持升序便于核对。

禁止配置 0。加载器只接受 1～99；0、负数、非数字或超出上限的编号会记录日志并跳过，不写入 `[sn-1]`。该范围不代表仅增加记录就已支持全部新境界；扩展仍须核对客户端和固定境界判断。跨表规则见 [配置编号、索引与固定容量](ConfigurationIdentifiers.md)。

### 境界等级列表

| 等级 | 名称 | 元气值 | LimitEnergy | 攻击加成 |
|------|------|--------|---------|---------|
| 1 | 出入境 | 4000 | 7999 | 75 |
| 2 | 造化境 | 8000 | 11999 | 150 |
| 3 | 玄妙境 | 12000 | 17999 | 300 |
| 4 | 生死境 | 18000 | 25999 | 450 |
| 5 | 解脱境 | 26000 | 35999 | 600 |
| 6 | 无为境 | 36000 | 47999 | 750 |
| 7 | 神话境 | 48000 | 61999 | 900 |
| 8 | 无上武念 | 62000 | 77999 | 1050 |
| 9 | 天人合一 | 78000 | 95999 | 1200 |
| 10 | 至尊无上 | 96000 | 115999 | 1350 |
| 11 | 一念通天 | 116000 | 137999 | 1500 |
| 12 | 空前绝后 | 138000 | 161999 | 1650 |
| 13 | 泰山北斗 | 162000 | 200000 | 1800 |

### 属性应用

元气等级影响武功的实际伤害和防御计算：

- 攻击力：`DamageBody += MagicClass.GetPowerLevelDamage(FCurPowerLevel)`
- 防御力：`ArmorBody += MagicClass.GetPowerLevelArmor(FCurPowerLevel)`
- 攻速、闪避、恢复、命中和维持恢复也分别通过 `GetPowerLevel*` 加入 `THaveMagicClass.AddPowerLevelLifeData`。当前配置列为空，所以本仓库数据下实际增量为 0。

### LimitEnergy 的实际用途

`TUserObject.CommandWindOfHand_new` 计算掌法伤害时，用 `n` 表示该次计算采用的元气：

```text
t = 当前元气 + 本次已消耗元气
若 CurPowerLevel = PowerLevel：n = t
否则：n = min(t, 当前境界的 LimitEnergy)
```

这里的 `n` 只参与掌法伤害计算，不会把人物 `Energy` 或 `CurEnergy` 改成 `LimitEnergy`。修改这一列不等于修改角色最大元气。人物元气和可用最高境界由武功相关累计值计算；当前使用境界可以通过 `PowerLevelUP/PowerLevelDOWN` 调整。

## 相关源码

- [svClass.pas](TGS核心源码/svClass.pas) — `TPowerLevelData`、`TMagicClass.ReLoadFromFile`、`CalcPowerLevel`、`GetPowerLevel*`。
- [uUserSub.pas](TGS核心源码/uUserSub.pas) — `THaveMagicClass.LoadFromSdb`、`AddPowerLevelLifeData`、`PowerLevelUP/PowerLevelDOWN`。
- [UUser.pas](TGS核心源码/UUser.pas) — `TUserObject.CommandWindOfHand_new` 的元气伤害计算。
