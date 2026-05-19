# DynamicIsolationProcess测试用例归档

## 用例表

| 测试功能                                              | 预置条件                        | 输入                                                        | 预期输出                                                |是否自动|测试结果|
|-------------------------------------------------|-----------------------------|-----------------------------------------------------------|-----------------------------------------------------|--------------------------------|--------------------------------|
| 通过文本定位点击主页面，触发动态指定进程拉起EntryAbility1            | entry模块EntryAbility已启动并显示主页面 | 1、通过ON.text('start EntryAbility1')定位文本组件<br/>2、点击该文本组件<br/>3、等待1000ms | 触发startAbility拉起配置了isolationProcess的EntryAbility1，系统回调onNewProcessRequest分配独立进程 |是|Pass|
| 通过id定位点击主页面，触发动态指定进程拉起EntryAbility1并返回        | entry模块EntryAbility已启动并显示主页面 | 1、通过ON.id('HelloWorld')定位文本组件<br/>2、点击该文本组件<br/>3、等待1000ms<br/>4、按返回键 | 触发startAbility拉起EntryAbility1，并成功返回主页面                    |是|Pass|
