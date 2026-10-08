# Windows 全量编译

构建入口为仓库根目录 `build_all.bat`，公共逻辑在 `build.ps1`。需要 Windows PowerShell 5.1 和 PATH 中的 Delphi 7 `DCC32.EXE`。仅在所有者明确授权编译时运行；不以编译成功替代协议或实服验收。

## 常用命令

从仓库根目录运行：

```powershell
.\build_all.bat -Help
.\build_all.bat
.\build_all.bat -NoPause
.\build_all.bat -NoPause -LogDir "D:\Build Logs"
.\build_all.bat -NoPause -Project game
.\gate_biscuit\build.bat -NoPause
```

无参数编译全部七个目标，交互输入时只在结束后暂停一次；重定向输入自动跳过暂停。`-NoPause` 显式关闭暂停，适合终端和自动化。`-Help` 不编译、不创建日志，也不要求编译器已配置。

## 目标与输出

| `-Project` | 目录 | 项目文件 |
| --- | --- | --- |
| `balance` | `balance/` | `Balance.dpr` |
| `db` | `db/` | `db.dpr` |
| `game` | `gameserver-tgs1000/` | `tgs1000.dpr` |
| `gate` | `gate_biscuit/` | `gate.dpr` |
| `login-sdb` | `loginsdb_biscuit/` | `login.dpr` |
| `login-sql` | `loginsql/` | `login.dpr` |
| `client` | `client/` | `Client.dpr` |

默认值为 `all`。各组件的 `build.bat` 固定选择自身目标，其余参数相同。仍使用原来的 `dcc32 -B` 全量编译及组件 CFG，不改优化、对齐、编码或条件编译开关；创建 `bin/`、`dcu/` 后在组件目录编译。已有同名编译产物可能被覆盖，应避开实际运行程序的部署目录。

`authentication` 是历史机器授权码写入工具，不纳入七个目标，也不改变其 OBJ 构建配置。

## 日志及结果

每次运行在 `temp/build_logs/` 下创建独立目录，包含七个目标各自的 `.log`（单目标运行仅一个）、`summary.txt` 和 `summary.json`。日志为 UTF-8，保留编译器标准输出与错误输出；错误输出单列在 `[stderr]` 后，不保证两路输出的原始交错顺序。

汇总记录每个目标的编译器退出码、Warning/Hint 条数和耗时，以及整次成功数、总耗时和结果。条数是本次输出记录数，不是独立缺陷数量。某个目标失败后仍检查其余目标；汇总不得将失败目标计为成功。

全部成功返回 `0`；编译、预检或日志写入失败返回非零。BAT 入口保留公共脚本的退出码；PowerShell 中用 `$LASTEXITCODE` 判断。默认日志目录已被根 `.gitignore` 的 `temp/` 忽略；自定义目录应在仓库外或自行明确忽略，不提交编译日志和产物。

## 回归验证

```powershell
python -B -m unittest py1000y.tests.test_build_scripts -v
```

测试在临时项目副本中使用假的 `DCC32.EXE`，不编译真实游戏源码。覆盖成功/失败、后续目标继续、独立入口退出码、缺少编译器/项目、无效参数、带空格及特殊字符的路径、重定向输入、日志统计和多次运行隔离；非 Windows 环境跳过。真实全量编译仍需单独运行。
