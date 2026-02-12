## 解决Web组件本地资源跨域问题

### 介绍

1. 本示例主要介绍解决Web组件本地资源跨域问题，利用Web组件的onInterceptRequest方法，对本地资源进行拦截和相应的替换。
2. 本工程主要实现了对以下指南文档中 https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/web/web-cross-origin.md 示例代码片段的工程化，主要目标是实现指南中示例代码需要与sample工程文件同源。

#### LocCrossOriginResAccSol_one

##### 介绍

1. 本示例主要介绍解决Web组件本地资源跨域问题，利用Web组件的onInterceptRequest方法，对本地资源进行拦截和相应的替换。

##### 效果预览

| 主页                                                         |
| ------------------------------------------------------------ |
| <img src="./screenshots/LocCrossOriginResAccSol_one.png" width="360;" /> |

使用说明

1. 针对本地index.html,使用http或者https协议代替file协议或者resource协议，构造一个属于自己的域名。

#### LocCrossOriginResAccSol_two

##### 介绍

1. 本示例主要介绍解决Web组件本地资源跨域问题，通过setPathAllowingUniversalAccess设置一个路径列表。当使用file协议访问该列表中的资源时，允许进行跨域访问本地文件。

##### 效果预览

| 主页                                                         | 跨域访问                                                     |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img src="screenshots\LocCrossOriginResAccSol_two_1.png" width="360;" /> | <img src="screenshots\LocCrossOriginResAccSol_two_2.png" width="360;" /> |

使用说明

1. 通过setPathAllowingUniversalAccess设置一个路径列表。当使用file协议访问该列表中的资源时，允许进行跨域访问本地文件。
1. index.html页面加载完成后，页面上显示一个按钮stealFile，点击stealFile按钮触发getFile函数跨域访问本地resfile/js/script.js文件。

## 使用智能防跟踪功能

### 介绍

1. 实现对以下指南文档中 https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/web/web-intelligent-tracking-prevention.md 示例代码片段的工程化，保证指南中示例代码与sample工程文件同源。

#### AddIntTrackPreventByPassList

##### 介绍

1. 本示例主要介绍使用智能防跟踪功能，调用addIntelligentTrackingPreventionBypassingList接口设置需要绕过智能防跟踪功能的域名列表。

##### 效果预览

| 主页                                                         |
| ------------------------------------------------------------ |
| <img src="./screenshots/AddIntTrackPreventByPassList.png" width="360;" /> |

使用说明

1. 点击addIntelligentTrackingPreventionBypassingList按钮设置需要绕过智能防跟踪功能的域名。

#### ClearIntTrackPreventByPassList

##### 介绍

1. 本示例主要介绍使用智能防跟踪功能，通过调用clearIntelligentTrackingPreventionBypassingList接口清除通过addIntelligentTrackingPreventionBypassingList接口设置的所有域名。

##### 效果预览

| 主页                                                         |
| ------------------------------------------------------------ |
| <img src="./screenshots/ClearIntTrackPreventByPassList.png" width="360;" /> |

使用说明

1. 点击clearIntelligentTrackingPreventionBypassingList按钮清除通过addIntelligentTrackingPreventionBypassingList接口设置的所有域名。

#### EnableIntTrackPrevent

##### 介绍

1. 本示例主要介绍使用智能防跟踪功能，调用enableIntelligentTrackingPrevention接口使能或者关闭相应Web组件的智能防跟踪功能。

##### 效果预览

| 主页                                                         |
| ------------------------------------------------------------ |
| <img src="./screenshots/EnableIntTrackPrevent.png" width="360;" /> |

使用说明

1. 点击enableIntelligentTrackingPrevention按钮使能相应Web组件的智能防跟踪功能。

#### IsIntTrackPreventEnabled

##### 介绍

1. 本示例主要介绍使用智能防跟踪功能，通过调用isIntelligentTrackingPreventionEnabled接口判断当前Web组件是否开启了智能防跟踪功能。

##### 效果预览

| 主页                                                         |
| ------------------------------------------------------------ |
| <img src="./screenshots/IsIntTrackPreventEnabled.png" width="360;" /> |

使用说明

1. 点击isIntelligentTrackingPreventionEnabled按钮判断当前Web组件是否开启了智能防跟踪功能。

#### OnIntTrackPreventResult

##### 介绍

1. 本示例主要介绍使用智能防跟踪功能，通过调用onIntelligentTrackingPreventionResult接口，以回调的方式异步获取拦截的跟踪型网站的域名和访问的网站域名信息。

##### 效果预览

| 主页                                                         |
| ------------------------------------------------------------ |
| <img src="./screenshots/OnIntTrackPreventResult.png" width="360;" /> |

使用说明

1. 点击onIntelligentTrackingPreventionResult按钮，获取拦截的跟踪型网站的域名和访问的网站域名信息。

#### RemoveIntTrackPreventByPassList

##### 介绍

1. 本示例主要介绍使用智能防跟踪功能，通过调用removeIntelligentTrackingPreventionBypassingList接口移除通过addIntelligentTrackingPreventionBypassingList接口设置的部分域名列表。

##### 效果预览

| 主页                                                         |
| ------------------------------------------------------------ |
| <img src="./screenshots/RemoveIntTrackPreventByPassList.png" width="360;" /> |

使用说明

1. 点击removeIntelligentTrackingPreventionBypassingList按钮，移除通过addIntelligentTrackingPreventionBypassingList接口设置的部分域名列表。

## 使用Web组件的广告过滤功能

### 介绍

1. 实现对以下指南文档中 https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/web/web-adsblock.md 示例代码片段的工程化，保证指南中示例代码与sample工程文件同源。

#### EnablingAdsBlocking

##### 介绍

1. 本示例主要介绍使用Web组件的广告过滤功能，应用可以通过AdsBlockManager提供的setAdsBlockRules()接口设置自定义的easylist过滤规则，并通过Web组件的enableAdsBlock()接口使能广告过滤特性。

##### 效果预览

| 主页                                                         | 文件选择器                                                   |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img src="./screenshots/EnablingAdsBlocking_1.png" width="360;" />/> | <img src="./screenshots/EnablingAdsBlocking_2.png" width="360;" /> |

使用说明

1. 点击setAdsBlockRules按钮，通过文件选择器设置自定义的easylist过滤规则。

#### DisAdsBlockSpecDomPages_one

##### 介绍

1. 本示例主要介绍使用Web组件的广告过滤功能，在Web组件的广告过滤开关开启后，应用有时候会期望关闭一些特定页面的广告过滤功能，AdsBlockManager提供了addAdsBlockDisallowedList()接口完成此功能。

##### 效果预览

| 主页                                                         |
| ------------------------------------------------------------ |
| <img src="./screenshots/DisAdsBlockSpecDomPages_one.png" width="360;" /> |

使用说明

1. 点击addAdsBlockDisallowedList按钮关闭特定域名页面的广告过滤。

#### DisAdsBlockSpecDomPages_two

##### 介绍

1. 本示例主要介绍使用Web组件的广告过滤功能，使用addAdsBlockDisallowedList()接口添加域名。

##### 效果预览

| 主页                                                         |
| ------------------------------------------------------------ |
| <img src="./screenshots/DisAdsBlockSpecDomPages_two.png" width="360;" /> |

使用说明

1. 点击addAdsBlockDisallowedList按钮添加域名。

#### CollectingAdsBlockingInformation

##### 介绍

1. 本示例主要介绍使用Web组件的广告过滤功能，在Web组件的广告过滤开关开启后，访问的网页如果发生了广告过滤，会通过Web组件的onAdsBlocked()回调接口通知到应用，应用可根据需要进行过滤信息的收集和统计。

##### 效果预览

| 主页                                                         |
| ------------------------------------------------------------ |
| <img src="./screenshots/CollectingAdsBlockingInformation.png" width="360;" /> |

使用说明

1. 使用onAdsBlocked接口收集广告过滤的信息。

### 工程目录

```
entry/src/main/
|---ets
|---|---entryability
|---|---|---EntryAbility.ets
|---|---pages
|---|---|---CollectingAdsBlockingInformation
|---|---|---DisAdsBlockSpecDomPages_one
|---|---|---DisAdsBlockSpecDomPages_two
|---|---|---LocCrossOriginResAccSol_one
|---|---|---LocCrossOriginResAccSol_two
|---|---|---AddIntTrackPreventByPassList
|---|---|---ClearIntTrackPreventByPassList
|---|---|---EnableIntTrackPrevent
|---|---|---IsIntTrackPreventEnabled
|---|---|---OnIntTrackPreventResult 
|---|---|---RemoveIntTrackPreventByPassList
|---|---|---EnablingAdsBlocking
|---|---|---Index.ets						// 首页
|---resources								// 静态资源
|---ohosTest
|---|---ets
|---|---|---tests
|---|---|---|---Ability.test.ets            // 自动化测试用例
```

### 具体实现

* 解决Web组件本地资源跨域问题
  * 构造自定义HTTPS域名与本地rawfile文件的映射关系及MIME类型对照表，调用onInterceptRequest接口拦截页面网络请求，在回调中判断请求URL是否命中预设的映射规则，若规则匹配，通过$rawfile接口读取本地资源流，手动构建WebResourceResponse对象并返回。
  * 通过UIContext获取应用沙箱内的资源目录与文件目录，构建本地路径列表，并调用setPathAllowingUniversalAccess接口将其设置为跨域访问白名单。允许本地HTML页面访问白名单内的本地资源文件，并通过loadUrl完成页面加载。
* 使用智能防跟踪功能
  * 调用enableIntelligentTrackingPrevention接口，传入布尔值true开启智能防跟踪功能。
  * 调用isIntelligentTrackingPreventionEnabled接口，获取当前WebView实例的智能防跟踪功能启用状态，返回布尔值结果并输出日志。
  * 定义包含受信任域名的字符串数组hostList，通过调用addIntelligentTrackingPreventionBypassingList方法，将域名列表注册到Web内核的全局配置中。
  * 调用clearIntelligentTrackingPreventionBypassingList方法，移除所有此前通过addIntelligentTrackingPreventionBypassingList接口配置的受信任域名白名单。
  * 开启WebView的智能防跟踪功能后，在Web组件初始化时注册onIntelligentTrackingPreventionResult回调，当追踪者cookie被拦截时，触发回调并传递details对象，解析其中的host（网站域名）与trackerHost（追踪者域名）。
  * 调用removeIntelligentTrackingPreventionBypassingList方法，将指定的域名从智能防跟踪的豁免白名单中剔除。
* 使用Web组件的广告过滤功能
  * 开启广告拦截功能后，使用DocumentViewPicker调用系统文件选择器，用户动态导入符合EasyList语法的外部广告拦截规则文件，并通过fileUri.FileUri将选中的虚拟URI解析为可访问的物理文件路径。通过setAdsBlockRules接口，将解析后的规则文件注入到Web内核的全局配置中，建立基于规则的网络请求过滤机制。
  * 开启广告拦截功能后，构造包含目标域名后缀的字符串数组定义不需要执行广告拦截的集合，调用addAdsBlockDisallowedList接口，将该域名数组注册为广告过滤的“例外名单”，在访问特定站点时跳过拦截规则匹配。
  * 开启广告拦截功能后，调用addAdsBlockDisallowedList接口，将父级域名配置为广告过滤的“豁免对象”。再调用addAdsBlockAllowedList接口，将该父域名下的特定子域名重新标记为“需拦截对象”。
  * 开启广告拦截功能后，在Web组件中注册onAdsBlocked事件回调，拦截到广告资源时，通过回调参数AdsBlockedDetails获取被拦截的URL列表。利用的Set数据结构对原始拦截数据进行去重后，将拦截数量累加至totalAdsBlockCounts中。

### 相关权限

[ohos.permission.INTERNET](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/security/AccessToken/permissions-for-all.md#ohospermissioninternet)

## 依赖

不涉及。

## 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：RK3568。
2. 本示例支持API20版本SDK，SDK版本号(API Version 20 Release)。
3. 本示例需要使用DevEco Studio 版本号(6.0.0Release)及以上版本才可编译运行。

## 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkWeb/ManageWebCompSecPriv > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
