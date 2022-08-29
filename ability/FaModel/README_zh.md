# FA模型

### 介绍

Ability框架在API 8及更早版本使用[FA模型](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/ability/fa-brief.md)。FA模型中Ability分为PageAbility、ServiceAbility、DataAbility、FormAbility几种类型。其中：

- PageAbility是具备ArkUI实现的Ability，是用户具体可见并可以交互的Ability实例。
- ServiceAbility也是Ability一种，但是没有UI，提供其他Ability调用自定义的服务，在后台运行。
- DataAbility也是没有UI的Ability，提供其他Ability进行数据的增删查服务，在后台运行。
- FormAbility是卡片Ability，是一种界面展示形式。

本示例主要展示FA模型与Stage模型的区别，分别从DataAbility、PageAbility（工程中对应MainAbility）、ServiceAbility、FA卡片、featureAbility、particleAbility、context模块进行介绍。

DataAbility：接口createRdbPredicates；通过createRdbPredicates创建DataAbilityHelper对象；通过rdb创建数据库，用来存放数据；通过DataAbilityHelper来访问数据库；通过dataAbility对数据库进行增删改查操作。

ServiceAbility：生命周期函数onStart、onCommand、onConnect、onDisconnect、onStop；通过featureAbility中的startAbility启动Service；通过connectAbility连接service；通过disconnectAbility断开service连接；通过rpc进行客户端与服务端通信。

FA卡片：生命周期函数onCreate、onCastToNormal、onUpdate、onVisibilityChange、onEvent、onDestroy、onAcquireFormState；通过formBindingData中的createFormBindingData创建卡片。

featureAbility： 提供UI设计与用户交互的能力 ， 包括启动新的ability、获取dataAbilityHelper、设置此Page Ability、获取当前Ability对应的窗口，连接服务等 。

particleAbility： 提供Service类型Ability的能力，包括启动、停止指定的particleAbility，获取dataAbilityHelper，连接、断开当前Ability与指定ServiceAbility等 。

context： 提供ability或application的上下文的能力，包括允许访问特定于应用程序的资源、请求和验证权限等。 

PageAbility：应用的界面绘制。

#### FA和Stage模型的区别

1.在FA模型中主要配置文件config.json，需要时将对应的ability配置在config.json中module/abilites；对应Stage模型主要有module.json5和app.json5，需要时对应的ability须配置在module.json5中的extensionAbilities中，PageAbility单独在abilites。

2.Stage模型中卡片的创建需要的配置文件在resources/base/profile/form_config.json。

3.FA模型中ability生命周期与Stage模型生命周期区别：

FA模型生命周期[具体参考文档]( [zh-cn/application-dev/ability/fa-brief.md · OpenHarmony/docs - Gitee.com](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/ability/fa-brief.md#生命周期) )；Stage模型生命周期[具体参考文档]( [zh-cn/application-dev/ability/stage-brief.md · OpenHarmony/docs - Gitee.com](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/ability/stage-brief.md#生命周期) )。

4.FA模型中DataAbility对应Stage模型中DataShareExtensionAbility，具体实现差异详见方法注释。

5.FA模型中ServiceAbility对应Stage模型中ServiceExtAbility，具体实现差异详见方法注释。

6.FA模型中DataAbilityHelper对应stage模型DataShareExtensionAbility 。

7.FA模型通过导入@ohos.resourceManager， 获取应用资源信息 ；Stage模型从API Version9开始，通过context获取resourceManager对象的方式，再调用其内部获取资源的接口， 无需再导入 @ohos.resourceManager。

#### FA对应Stage接口（FA-->Stage）

 **FeatureAbility——>AbilityContext接口：**

FeatureAbilityTest：getWant——>MainAbility：want

FeatureAbilityTest：startAbilityForResult——>AbilityContextController：startAbilityForResult

FeatureAbilityTest：acquireDataAbilityHelper——>DataShareHelper：createDataShareHelper

FeatureAbilityTest：terminateSelfWithResult——>AbilityContextController：terminateSelfWithResult

FeatureAbilityTest：hasWindowFocus——>Stage模型不支持

FeatureAbilityTest：terminateSelf——>AbilityContextController：terminateSelf

FeatureAbilityTest：getWindow——>WindowController：getTopWindow

FeatureAbilityTest：startServiceAbility——>AbilityContextController：startAbility

FeatureAbilityTest：connectService——>AbilityContextController：connectAbility

FeatureAbilityTest：disconnectService——>AbilityContextController：disconnectAbility



**context-->AbilityContext、Bundle、Window、abilityAccessCtrl接口：**

AppContext：getOrCreateLocalDir——>BundleController：entryDir

AppContext：verifyPermission——>AbilityAccessCtrlController：verifyAccessToken

AppContext：requestPermissionsFromUser——>AbilityContextController：requestPermissionsFromUser

AppContext：getApplicationInfo——>BundleController：getApplicationInfo

AppContext：getBundleName——>AbilityContextPage：abilityInfo.bundleName（属性）

AppContext：getDisplayOrientation——>AbilityContextPage：config.direction（属性）

AppContext：setDisplayOrientation——>WindowController：setPreferredOrientation

AppContext：setShowOnLockScreen——>MainAbility：setShowOnLockScreen

AppContext：setWakeUpScreen——>WindowController：setWakeUpScreen

AppContext：getProcessInfo——>AbilityContextPage：abilityInfo.descriptionId；abilityInfo.name（属性）

AppContext：getElementName——>BundleController：getAbilityInfo

AppContext：getProcessName——>BundleController：process

AppContext：getCallingBundle——>want.parameters（属性）

AppContext：getCacheDir——>AbilityContextPage：cacheDir（属性）

AppContext：getFilesDir——>AbilityContextPage：filesDir（属性）

AppContext：getOrCreateDistributedDir——>AbilityContextPage：distributedFilesDir（属性）

AppContext：getAppType——>BundleController：entityType

AppContext：getHapModuleInfo——>AbilityContextPage：currentHapModuleInfo（属性）

AppContext：getAppVersionInfo——>BundleController.getDispatcherVersion

AppContext：getAbilityInfo——>AbilityContextPage：abilityInfo（属性）

AppContext：getApplicationContext——>AbilityContextPage：getApplicationContext()

AppContext：isUpdatingConfigurations——>Stage模型不支持

AppContext：printDrawnCompleted——>Stage模型不支持



 **particleAbility ——>ServiceExtensionContext、dataShare接口：**

 ParticleAbilityTest ：startAbility——>ServiceExtContextController：startAbility

 ParticleAbilityTest ：connectAbility——>ServiceExtContextController：connectAbility

 ParticleAbilityTest ：disconnectAbility——>ServiceExtContextController：disconnectAbility

 ParticleAbilityTest ：terminateSelf——>ServiceExtContextController：terminateSelf

 ParticleAbilityTest ：acquireDataAbilityHelper——>DataShareHelper：createDataShareHelper 

#### 使用说明

1.按照各按钮名称测试相应的接口功能。

#### 效果预览

![](screenshots/devices/main.png)

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持在标准系统上运行，支持设备：RK3568。

2.本示例仅支持API9版本SDK，版本号：3.2.5.5。

3.本示例需要使用DevEco Studio 3.0 Beta4 (Build Version: 3.0.0.992, built on July 14, 2022)才可编译运行。

