# getjobgrade（未实现）

当前 `TScriptManager.CallFunction` 没有 `getjobgrade` 分支。调用这个名称不会读取 `SGetJobGrade`，因此不应依赖其结果。

获取当前触发玩家的职业等级应使用：

```pascal
JobGrade := callfunc('getsenderjobgrade');
```

已实现分支为：

```pascal
Result := IntToStr(TBasicObject(FSender).SGetJobGrade);
```

`TUser.SGetJobGrade` 返回 `HaveJobClass.JobGrade`。云端神武归档的 `龙师父.txt` 保留 `getjobgrade` 旧名称；当前工作区炎黄 `bin/Script/龙师父.txt` 已修正两处调用为 `getsenderjobgrade`。归档用法不代表当前分派器存在该接口。参见 [getsenderjobgrade](getsenderjobgrade.md)。
