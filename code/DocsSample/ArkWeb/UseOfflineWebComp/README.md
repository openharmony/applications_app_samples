# 使用离线Web组件

### 介绍

1. 本工程主要实现了对以下指南文档中 https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/web/web-offline-mode.md 示例代码片段的工程化，主要目标是实现指南中示例代码需要与sample工程文件同源。

### Entry:

####  CreatingOfflineWebComponents

##### 介绍

1. 本示例主要介绍使用离线Web组件加载显示页面。在需要离屏创建Web组件时，定义一个自定义组件以封装Web组件，此Web组件在离线状态下被创建，封装于无状态的NodeContainer节点中，并与相应的NodeController组件绑定。Web组件在后台预渲染完毕后，当需要展示时，通过NodeController将其挂载到ViewTree的NodeContainer中，即与对应的NodeContainer组件绑定，即可挂载上树并显示。

##### 效果预览

| 主页                                                         |
| ------------------------------------------------------------ |
| <img src="./screenshots/CreatingOfflineWebComponents.png" width="360;" /> |

使用说明

1. Index.ets通过getNWeb从NodeMap获取myNodeController，将其传入NodeContainer，实现动态组件在页面的显示。

### Entry1: 

#### PreLaunchingRenderingProcess_one

##### 介绍

1. 本示例主要介绍预启动ArkWeb渲染进程。在后台预先创建一个Web组件，以启动用于渲染的Web渲染进程，这样可以节省后续Web组件加载时启动Web渲染进程所需的时间。

##### 效果预览

| 主页                                                         | 跳转页                                                       |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img src="./screenshots/PreLaunchingRenderingProcess_one_1.png" width="360;" /> | <img src="./screenshots/PreLaunchingRenderingProcess_one_2.png" width="360;" /> |

使用说明

1. 在onWindowStageCreate时期预创建了一个Web组件加载blank页面，从而提前启动了Render进程，从index跳转到index2时，优化了Web的Render进程启动和初始化的耗时。
1. 点击跳转到web页面按钮跳转到Web页面。

### Entry2: 

#### PreLaunchingRenderingProcess_two

##### 介绍

1. 本示例主要介绍使用预渲染Web页面。预渲染Web页面优化方案适用于Web页面启动和跳转场景，例如，进入首页后，跳转到子页。建议在高命中率的页面使用该方案。渲染Web页面的实现方案是提前创建离线Web组件，并设置Web为Active状态来开启渲染引擎，进行后台渲染。

##### 效果预览

| 主页                                                         | 跳转页面                                                     |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img src="./screenshots/PreLaunchingRenderingProcess_two_1.png" width="360;" /> | <img src="./screenshots/PreLaunchingRenderingProcess_two_2.png" width="360;" /> |

使用说明

1. 点击跳转到web页面按钮跳转到Web页面。

### Entry3: 

#### ReuseAndRecycleOfflineWebComponents

##### 介绍

1. 本示例主要介绍使用复用和释放离线Web组件。
2. 复用离线Web组件适用于应用有多个UI页面都需要显示Web内容的场景。可以减少组件创建和销毁的性能消耗；减少创建多个Web组件导致的内存消耗；降低应用因内存占用过高被系统查杀的概率。
3. 当应用退至后台，明确在特定时间段内不再需要使用离线Web组件时，建议释放该组件以减少应用的内存占用。可以优化内存占用，降低应用被系统查杀的概率。

##### 效果预览【TODO】

| 主页                                                         | Home页面                                                     |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img src="./screenshots/ReuseAndRecycleOfflineWebComponents_index_page.png" width="360;" /> | <img src="./screenshots/ReuseAndRecycleOfflineWebComponents_home_page.png" width="360;" /> |

| 测试页Page1                                                         | 测试页Page2                                                     |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img src="./screenshots/ReuseAndRecycleOfflineWebComponents_page1.png" width="360;" /> | <img src="./screenshots/ReuseAndRecycleOfflineWebComponents_page2.png" width="360;" /> |

使用说明

1. Index页面作为入口页面，演示页面跳转、离线Web组件的释放，恢复及统计信息展示。
   * 点击跳转至Home页面的按钮，跳转打开Home页面；
   * 点击释放离线Web组件按钮，仅释放没有被绑定的离线Web组件。
   * 点击强制释放离线Web组件按钮，演示强制释放所有离线Web组件，包括已绑定和未绑定的组件，会导致对应的NodeContainer白屏。
   * 点击恢复离线Web组件按钮，可以恢复被释放的离线web组件。
   * 页面下面会显示离线Web组件的数量、状态及URL等详细信息。
2. Home页面为UI主页，演示离线Web组件的创建，预渲染的执行方法和时机。
   * 页面在创建时会创建3个离线组件，其中一个加载指定网页并进行预渲染，另外两个为空白离线Web组件。
   * 页面提供导航按钮用于跳转至Page1或Page2页面，点击可进入不同的测试页面。
3. Page1页面同时显示了两个Web页面，每个页面使用了一个离线Web组件，加载并显示相同URL的内容。该页面用于演示预渲染与不预渲染的效果对比，以及如何复用离线组件。
   * 第一个离线Web组件执行了预渲染，可以直接显示页面。 
   * 第二个离线Web组件复用空闲的离线Web组件，并在aboutToAppear的生命周期中动态加载这个url。
4. Page2页面显示单个Web页面，使用复用空闲离线Web组件的方式加载指定url。
   * Page2页面可以通过传入参数加载指定url，也提供按钮供用户在加载后跳转到其他url。
   * Page2会在NavDestination的onWillHide回调中，让当前Web组件加载空白页并取消与当前UI的关联，为下次复用做准备。
   * Page2页面支持嵌套，即使有多层UI页面嵌套，点击打开新页面按钮，可以嵌套打开一个新的Page2页面。由于采用复用离线Web组件的方式，Web组件数量不会增加。

### 工程目录

```
entry/src/main/
|---ets
|---|---entryability
|---|---|---EntryAbility.ets
|---|---pages
|---|---|---Common.ets
|---|---|---Index.ets						// 首页
|---resources								// 静态资源
|---ohosTest
|---|---ets
|---|---|---tests
|---|---|---|---Ability.test.ets            // 自动化测试用例

entry1/src/main/
|---ets
|---|---entry1ability
|---|---|---Entry1Ability.ets
|---|---pages
|---|---|---Common.ets
|---|---|---Index.ets						// 首页
|---|---|---index2.ets
|---resources								// 静态资源
|---ohosTest
|---|---ets
|---|---|---tests
|---|---|---|---Ability.test.ets            // 自动化测试用例

entry2/src/main/
|---ets
|---|---entry2ability
|---|---|---Entry2Ability.ets
|---|---pages
|---|---|---Common.ets
|---|---|---Index.ets						// 首页
|---|---|---index2.ets
|---resources								// 静态资源
|---ohosTest
|---|---ets
|---|---|---tests
|---|---|---|---Ability.test.ets            // 自动化测试用例

entry3/src/main/
|---ets
|---|---entry3ability
|---|---|---Entry3Ability.ets
|---|---pages
|---|---|---Common.ets
|---|---|---Index.ets						// 入口页
|---|---|---Home.ets                        // 首页
|---|---|---Page1.ets
|---|---|---Page2.ets
|---resources								// 静态资源
|---ohosTest
|---|---ets
|---|---|---tests
|---|---|---|---Ability.test.ets            // 自动化测试用例
```


### 相关权限

[ohos.permission.INTERNET](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/security/AccessToken/permissions-for-all.md#ohospermissioninternet)

### 依赖

不涉及。

### 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：RK3568。
2. 本示例支持API14版本SDK，SDK版本号(API Version 14 Release)。
3. 本示例需要使用DevEco Studio 版本号(5.0.1Release)才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkWeb/UseOfflineWebComp > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```