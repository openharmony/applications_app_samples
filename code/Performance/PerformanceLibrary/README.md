# 性能示例

### 介绍

本示例集成了条件渲染、动态加载以及HiDumper等场景来介绍如何提升应用性能。

### 效果预览
| 性能示例主页                                    | 场景主页                                             | 正例场景页                                     | 反例场景页                                |
| ------------------------------------- |--------------------------------------------------| -------------------------------------- | ----------------------------------- |
| ![](screenshots/device/PerformanceHomePage.jpeg) | ![](screenshots/device/RenderGroupHomePage.jpeg) | ![](screenshots/device/ProfitScenePage.jpeg) | ![](screenshots/device/NonProfitScenePage.jpeg) |

HiDumper使用说明：  



### 工程目录

```
features/hiDumper/src/main/ets          // 列表类功能HAR共享包
|---/view    
|   |---ConditionView.ets                  // 显隐切换模块      
|   |---GridView.ets                       // 查看组件树模块
|   |---HidumperHomeView.ets               // 场景主页面模块           
|   |---VisibilityView.ets                 // 查看Visibility属性模块
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
|   |---/Index                             // 性能示例首页                              
|---/utils
|   |---Logger.ets                         // 封装整个日志

```

### 具体实现

* HiDumper正例场景与反例场景两个模块:  
  
  * 正例场景  
    
    * 在ProfitScene的IconItem上添加动画，在IconView上使用到renderGroup接口(renderGroup(value: boolean): T)得到收益。  
    * 源码链接：[ProfitScene.ets](feature/renderGroup/src/main/ets/pages/ProfitScene.ets)，[IconView.ts](renderGroup/src/main/ets/view/IconView.ets)
  
  * 反例场景  
    
    * 在IconView的Image上添加动画，在NonIconView上使用到renderGroup接口(renderGroup(value: boolean): T)得到负收益。  
    * 源码链接：[NonProfitScene.ets](renderGroup/src/main/ets/pages/NonProfitScene.ets)，[NonIconView.ts](renderGroup/src/main/ets/view/NonIconView.ets)  

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

```