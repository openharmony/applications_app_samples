# ModuleIsolationProcess测试用例归档

## 用例表

| 测试功能                             | 预置条件                        | 输入                                                         | 预期输出                                     |是否自动|测试结果|
|--------------------------------|-----------------------------|------------------------------------------------------------|--------------------------------------------|--------------------------------|--------------------------------|
| 通过文本定位点击entry页面，跨模块拉起FeatureAbility | entry模块EntryAbility已启动并显示主页面 | 1、通过ON.text('Hello World Entry')定位文本组件<br/>2、点击该文本组件<br/>3、等待1000ms | 触发startAbility拉起feature模块的FeatureAbility |是|Pass|
| 通过id定位点击entry页面，跨模块拉起FeatureAbility并返回 | entry模块EntryAbility已启动并显示主页面 | 1、通过ON.id('HelloWorld')定位文本组件<br/>2、点击该文本组件<br/>3、等待1000ms<br/>4、按返回键 | 触发startAbility拉起feature模块的FeatureAbility，并成功返回entry页面 |是|Pass|
