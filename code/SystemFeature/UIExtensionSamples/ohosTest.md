|测试功能|预置条件|输入|预期输出|是否手动|测试结果|
|--------------------------------|--------------------------------|--------------------------------|--------------------------------|--------------------------------|--------------------------------|
|拉起应用|	设备正常运行|		|成功拉起应用|否|Pass|
|测试AbilityStartCallback中接口| AbilityStartCallback开发示例页面 | 1.点击startAbilityByType(onResult)按钮，拉起新界面，点击返回按钮<br/>2.点击startAbilityByType(onError)按钮 | 1.拉起新界面<br/>2.弹出Toast信息 | 否 |Pass|
|测试UIAbilityContext中接口| 位于UIAbilityContext开发示例页面 | 1.点击openLink按钮<br/>2.点击返回按钮，返回UIExtensionContext开发示例界面，点击启动UIExtensionAbility按钮<br/>3.点击reportDrawnCompleted按钮<br/>4.点击terminateSelf（callback）按钮<br/>5.点击启动UIExtensionAbility按钮 | 1.拉起新的Ability<br/>2.进入UIExtensionAbility界面<br/>3.弹出Toast信息<br/>4.UIExtensionAbility界面消失<br/>5.进入UIExtensionAbility界面 | 否 |Pass|
|测试UIAbilityContext中接口| 位于UIAbilityContext开发示例页面 | 1.点击terminateSelf（promise）按钮<br/>2.点击启动UIExtensionAbility按钮，进入UIExtensionAbility界面，点击terminateSelfWithResult（promise）按钮<br/>3.点击启动UIExtensionAbility按钮，进入UIExtensionAbility界面，点击terminateSelfWithResult（callback）按钮 | 1.UIExtensionAbility界面消失<br/>2.UIExtensionAbility界面消失<br/>3.UIExtensionAbility界面消失 | 否 |Pass|
|测试UIExtensionContentSession中接口| 位于UIExtensionContentSession开发示例页面 | 1.点击启动UIExtensionAbility按钮<br/>2.点击terminateSelfWithResult（promise）按钮<br/>3.点击启动UIExtensionAbility按钮，进入UIExtensionAbility界面，点击terminateSelfWithResult（callback）按钮<br/>4.点击启动UIExtensionAbility按钮 | 1.进入UIExtensionAbility界面<br/>2.UIExtensionAbility界面消失<br/>3.UIExtensionAbility界面消失<br/>4.进入UIExtensionAbility界面 | 否 |Pass|
|测试UIExtensionContentSession中接口| 位于UIExtensionContentSession开发示例页面 | 1.点击setWindowPrivacyMode（callback）按钮<br/>2.点击setWindowPrivacyMode（promise）按钮<br/>3.点击getUIExtensionWindowProxy按钮 | 1.弹出Toast信息<br/>2.弹出Toast信息<br/>3.弹出Toast信息 | 否 |Pass|

