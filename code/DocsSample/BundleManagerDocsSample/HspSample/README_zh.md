# HSP

### 介绍

HSP（Harmony Shared Package）是动态共享包，按照使用场景可以分为应用内HSP和应用间HSP。应用内HSP指的是专门为某一应用开发的HSP，只能被该应用内部其他HAP/HSP使用，用于应用内部代码、资源的共享。应用内HSP跟随其宿主应用的APP包一起发布，与宿主应用同进程，具有相同的包名和生命周期。

>**说明**
>
>由于当前不支持应用间HSP，这里提到的HSP特指应用内HSP。

### 效果预览

| 主页                               | **资源引用页面**    | **路由跳转页面**          |
|----------------------------------|-------------------------------------------|-------------------------------------------|
| ![](screenshots/home.png) | ![](screenshots/example.png) | ![](screenshots/router.png) |
| **路由返回页面** |  |  |
| ![](screenshots/back.png) |  |  |

使用说明：

1.启动HspSample(动态共享包)应用，首页正常显示所引用HSP的ArkUI组件、接口、资源。

2.点击主页"引用HSP的ts类和方法"按钮，正确引用HSP的ts类和方法，页面Hello World字段变更为result: 3。

3.点击主页"引用HSP中的资源"按钮，正确引用HSP中的资源，页面Hello World字段变更为getStringValue is shared。

4.点击主页"引用HSP导出的native方法"按钮，正确引用HSP导出的native方法，页面Hello World字段变更为result: 12。

5.点击主页"访问HSP中的资源"按钮，跳转至HSP中Index页面，Index页面正确访问HSP中的资源，显示内容为example.png的图片信息。

6.点击主页"页面路由跳转"按钮，正确引用HSP的路由跳转，跳转至menu页面，页面显示内容为：The page is menu。menu页面点击"router to HSP page"按钮，跳转至HSP的新页面，HSP的新页面上点击"back to HSP page"按钮，返回menu页面。

7.点击主页"页面路由返回"按钮，正确引用HSP的路由跳转，跳转至新页面，新页面上点击"back to HAP page"按钮，返回至主页。

### 工程目录
```
entry/src/main/ets/                 
|---entryability
|   └---EntryAbility.ts                   
|---logger
|   └---Logger.ts                      // 日志工具
└---pages
    └---Index.ets                      // 首页
library
|---src
|   └---main
|       |---cpp
|       |   |---types
|       |   |---CMakeLists.txt
|       |   └---hello.cpp
|       |---ets
|       |   |---components
|       |   |   └---MyTitleBar.ets		// ArkUI组件页面
|       |   |---page
|       |   |   |---back.ets			// 实现页面路由返回
|       |   |   |---Index.ets			// 访问HSP中的图片资源
|       |   |   └---menu.ts
|       |   └---utils
|       |       └---nativeTest.ts		// native方法页面
|       |       └---tset.ts				// ts类和方法页面
|       |---resources				// 资源文件
|       └---module.json5
└---oh-package.json5
```

### 具体实现

* 本示例为HspSample(动态共享包)应用，提供 导出HSP的ArkUI组件、接口、资源功能：
  * 导出HSP的ArkUI组件、接口、资源，HSP中的资源，源码链接：[index.ets](library/src/main/ets/Index.ets)
    * HSP中MyTitleBar.ets文件的ArkUI组件，源码链接：[MyTitleBar.ets](library/src/main/ets/components/MyTitleBar.ets)
    * HSP中test.ts文件的ts类和方法，源码链接：[test.ts](library/src/main/ets/utils/test.ts)
    * HSP中nativeTest.ts文件的native方法。在HSP中也可以包含C++编写的so，对于so中的native方法，HSP通过间接的方式导出，如导出libnative.so的乘法接口multi，源码链接：[nativeTest.ts](library/src/main/ets/utils/nativeTest.ts)
    * 通过$r访问HSP中的资源，源码链接：[Index.ets](library/src/main/ets/pages/Index.ets)
    * HSP中的资源管理类，跨包访问HSP内资源时，推荐实现一个资源管理类，以封装对外导出的资源，源码链接：[ResManager.ets](library/src/main/ets/ResManager.ets)
  * 引用HSP的ArkUI组件、接口、资源
    * 在使用方中，引用HSP的ArkUI组件、接口、资源及 页面路由跳转，源码链接：[index.ets](entry/src/main/ets/pages/Index.ets)

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行，支持设备：RK3568。

2.本示例为Stage模型，支持API11版本SDK，SDK版本号（API Version 11 Canary1）。

3.本示例需要使用DevEco Studio版本号（3.1 Release）及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/BundleManagerDocsSample/HspSample/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```

