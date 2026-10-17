# game.ini

`game.ini` 由 `LoadGameIni` 读取，保存本地化名称和战斗公式参数。仓库实际文件为 ANSI/CP936；直接改成 UTF-8 可能使旧版 Delphi 程序读出乱码，编辑时应保持原编码。

## 配置节

| 节 | 键与用途 |
| --- | --- |
| `STRINGS` | `WHO`、`SERCHSKILL`、`SERCHENABLE`、`SERCHUNABLE`、`WHITEDRUG`、`ROPE`、`SEX_FIELD_MAN`、`SEX_FIELD_WOMAN`、`GUILD_STONE`、`GUILD_NPCMAN_NAME`、`GUILD_NPCWOMAN_NAME`、`GUILD_NPCWHITE_NAME`、`GUILD_NPCBLACK_NAME`、`GOLD`：命令字及本地化对象名称。实际文件未写 `SERCHENABLE`、`SERCHUNABLE`，所以使用源码默认字符串 |
| `GUILD_NPC_WEAR` | 男、女门派 NPC 的 `SEX`、`CAP`、`HAIR`、`UPUNDERWEAR`、`UPOVERWEAR`、`DOWNUNDERWEAR`、`GLOVES`、`SHOES`、`WEAPON` 共 18 项 |
| `DEFAULT_MAGIC` | `DEF_WRESTLING`、`FENCING`、`SWORDSHIP`、`HAMMERING`、`SPEARING`、`BOWING`、`THROWING`、`RUNNING`、`BREATHNG`、`PROTECTING`，以及对应的 `...2` 上层武功名称，共 20 项 |
| `DIRECTION_NAMES` | `NORTH`、`NORTHEAST`、`EAST`、`EASTSOUTH`、`SOUTH`、`SOUTHWEST`、`WEST`、`WESTNORTH` |
| `ITEM_VALUES` | `HIDEPAPER_DELAY`、`SHOWPAPER_DELAY`、`ITEM_UNLOCKTIME`，均直接作为整数 tick/间隔参数读取 |
| `MAGIC_VALUES` | 普通武功类别（包括默认基本武功模板）的 `MAGIC_DIV_VALUE`、`ADD_DAMAGE`、各 `MUL_*` 与 `SKILL_DIV_*` 公式参数 |
| `RISEMAGIC_VALUES` | 上层武功对应的 `MAGIC_DIV_VALUE`、`ADD_DAMAGE`、`MUL_*`、`SKILL_DIV_*`，另有 `SKILL_ADD_BASESKILL` |
| `JOB_SYSTEM` | 四种职业名 `DEF_ALCHEMIST`、`CHEMIST`、`DESIGNER`、`CRAFTSMAN`，六个职业等级名，以及 `DEF_ITEMPROCESS1..4` 加工名称 |

## 修改规则

- 键名中的历史拼写是协议的一部分，例如 `SERCHSKILL`、`BREATHNG`，不要自行纠正。
- `MAGIC_VALUES` 与 `RISEMAGIC_VALUES` 会直接参与 `Magic.SDB` 加载和技能计算；修改前应对照 [Magic.SDB](Init_magic.sdb.md) 及 `svClass.pas` 公式分支。
- 配置缺项时使用 `ReadString`/`ReadInteger` 的源码默认值；空白数值会按 INI 读取行为落到默认值或 0，不应把表面空列解释为未加载。

## 校验依据

- 实际配置：`tgs1000/bin/game.ini`
- 加载器：`tgs1000/svClass.pas` 的 `LoadGameIni`
