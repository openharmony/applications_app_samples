# 性能示例

### 介绍

本示例集成了条件渲染、动态加载以及HiDumper等场景来介绍如何提升应用性能。

### 效果预览
| 性能示例主页                                    | 场景主页                                             | 正例场景页                                     | 反例场景页                                |
| ------------------------------------- |--------------------------------------------------| -------------------------------------- | ----------------------------------- |
| ![](screenshots/device/PerformanceHomePage.jpeg) | ![](screenshots/device/RenderGroupHomePage.jpeg) | ![](screenshots/device/ProfitScenePage.jpeg) | ![](screenshots/device/NonProfitScenePage.jpeg) |

HiDumper使用说明：  
1.点击性能示例主页的**HiDumper**按钮，进入**HiDumper查看组件信息**场景页。

2.点击HiDumper查看组件信息场景页的**查看应用组件树**进入场景页。

3.点击HiDumper查看组件信息场景页的**查看if/else组件**按钮，在场景中点击**显隐切换**按钮，查看图片显示隐藏。

4.点击HiDumper查看组件信息场景页的**查看visibility属性**按钮，在场景中依次点击**Visible**、**Hidden**、**Visible**、**None**，查看图片显示和隐藏。

常规加载页面使用说明：
1.点击性能示例主页的**StaticImport**按钮，进入**常规加载入口**场景页。

2.点击常规加载入口的**点击跳转常规加载案例**按钮，进入**常规加载主页**。

3.点击常规加载主页的**pageOne**按钮，进入**常规加载子页面**。

动态加载页面使用说明：
1.点击性能示例主页的**DynamicImport**按钮，进入**动态加载入口**场景页。

2.点击动态加载入口页的**点击跳转动态加载案例**按钮，进入**动态加载主页**。

3.点击动态加载主页的**pageOne**按钮，进入**动态加载子页面**。

### 工程目录

```
features/hiDumper/src/main/ets          // 列表类功能HAR共享包
|---/view    
|   |---ConditionView.ets                  // 显隐切换模块      
|   |---GridView.ets                       // 查看组件树模块
|   |---HidumperHomeView.ets               // 场景主页面模块           
|   |---VisibilityView.ets                 // 查看Visibility属性模块
features/staticImport/src/main/ets      // 常规加载HAR共享包
|---/pages    
|   |---StaticContentPageOne.ets           // 常规加载子页面     
|   |---StaticContentPageTwo.ets           // 常规加载子页面
|   |---StaticEntryView.ets                // 常规加载入口页面           
|   |---StaticHome.ets                     // 常规加载主页
features/dynamicImport/src/main/ets     // 动态加载HAR共享包
|---/pages    
|   |---DynamicContentPageOne.ets          // 动态加载子页面     
|   |---DynamicEntryView.ets               // 动态加载入口页面           
|   |---DynaHome.ets                       // 动态加载主页
products/phone/entry/src/main/ets
|---/entryability
|   |---EntryAbility.ts                    // 封装整个模块启用，监听Ability对应的窗口等逻辑
|---/model                                                               
|   |---/DataType                          // 数据类型
|   |---/MockData                          // 本地数据
|---pages 
|   |---/hiDumper
|   |   |---ConditionPage.ets              // 显隐切换页面                
|   |   |---GridPage.ets                   // 查看组件树页面
|   |   |---HidumperHomePage.ets           // 场景主页面                   
|   |   |---VisibilityPage.ets             // 查看Visibility属性页面
|   |---/staticImport
|   |   |---StaticEntryView.ets            // 常规加载入口页面              
|   |   |---StaticHome.ets                 // 常规加载主页
|   |---/Index                             // 性能示例首页                              
|---/utils
|   |---Logger.ets                         // 封装整个日志

```

### 具体实现

* HiDumper场景模块

  * 查看组件树
    * 在页面上添加Grid，每个GridItem嵌套多个Stack，然后通过HiDumper抓取组件树信息。
    * 源码链接：[GridView.ets](feature/hiDumper/src/main/ets/view/GridView.ets)
    
  * 查看if/else组件
    * 在页面上添加**显隐切换**按钮，添加一张图片，点击按钮后通过HiDumper抓取组件树信息。
    * 源码链接：[ConditionView.ets](feature/hiDumper/src/main/ets/view/ConditionView.ets)
    
  * 查看visibility属性
    * 在页面上添加**Visible**、**Hidden**、**None**按钮，添加一张图片，点击按钮后通过HiDumper抓取组件树信息。
    * 源码链接：[VisibilityView.ets](feature/hiDumper/src/main/ets/view/VisibilityView.ets)

* Navigation常规加载页面模块

  * 在Navigation组件加载内容页时，使用`import`常规加载子页面。
  * 源码链接：[StaticHome.ets](feature/staticImport/src/main/ets/pages/StaticHome.ets)

* Navigation动态加载页面模块

  * 在Navigation组件加载内容页时，使用`await import`实现动态按需加载。
  * 源码链接：[DynamicHome.ets](feature/dynamicImport/src/main/ets/pages/DynamicHome.ets)


### 相关权限

不涉及。  

### 依赖

不涉及。  

### 约束与限制

1.本示例已适配API version 10版本SDK，SDK版本号(API Version 10 Release),镜像版本号(4.0Release)。

2.本示例需要使用DevEco Studio 版本号(4.0Release)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：  

```

 git init
 git config core.sparsecheckout true
 echo code/Performance/PerformanceLibrary/ > .git/info/sparse-checkout
 git remote add origin https://gitee.com/openharmony/applications_app_samples.git
 git pull origin master

```