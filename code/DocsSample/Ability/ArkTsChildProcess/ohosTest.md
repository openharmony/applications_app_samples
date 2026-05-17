# ArkTsChildProcess测试用例归档

## 用例表

| 测试功能 | 预置条件 | 输入 | 预期输出 |是否自动|测试结果|
|---|---|---|---|---|---|
| 启动EntryAbility | 设备正常运行 | 通过abilityDelegator启动com.sample.ArkTsChildProcess的EntryAbility | 成功启动Ability，当前顶层Ability名称为EntryAbility |是|Pass|
| 使用Promise方式创建无参数ArkTS子进程 | 位于应用主页面 | 1、点击"StartArkChildProcessNoArg_Promise"按钮<br/>2、等待1秒 | 调用childProcessManager.startChildProcess接口以SELF_FORK模式启动子进程，通过Promise回调返回子进程pid |是|Pass|
| 使用Callback方式创建无参数ArkTS子进程 | 位于应用主页面 | 1、点击"StartArkChildProcessNoArg_Callback"按钮<br/>2、等待1秒 | 调用childProcessManager.startChildProcess接口以SELF_FORK模式启动子进程，通过callback回调返回子进程pid |是|Pass|
| 创建带参数的ArkTS子进程 | 位于应用主页面 | 1、点击"StartArkChildProcessWithArg"按钮<br/>2、等待1秒 | 调用childProcessManager.startArkChildProcess接口启动子进程，传递entryParams字符串参数和fd文件句柄参数，通过Promise回调返回子进程pid |是|Pass|