# HAR

### 介绍

HAR（Harmony Archive）是静态共享包，可以包含代码、C++库、资源和配置文件。通过HAR可以实现多个模块或多个工程共享ArkUI组件、资源等相关代码。HAR不同于HAP，不能独立安装运行在设备上，只能作为应用模块的依赖项被引用。

### 效果预览

| 主页                               | 导出ArkUI组件页面                        | 导出ts类和方法页面                           |
|----------------------------------|-------------------------------------------|-------------------------------------------|
| ![](screenshots/home.png) | ![](screenshots/arkui.png) | ![](screenshots/ts.png) |
| **导出native方法页面** |                                   |                                |
| ![](screenshots/native.png) |  |  |

使用说明：

1.启动HarSample(静态共享包)应用，首页正常显示所引用HAR的ArkUI组件、ts类和方法、native方法、资源。

2.点击主页"引用HAR的ArkUI组件"按钮，正确引用HAR的ArkUI组件，跳转至HAR的MainPage页面，页面显示内容为：Hello World。

3.点击主页"引用HAR的ts类和方法"按钮，正确引用HAR导出的ts类和方法，页面Hello World字段变更为func return: har func。

4.点击主页"引用HAR导出的native方法"按钮，正确引用HAR导出的native方法，页面Hello World字段变更为result: 3。

### 工程目录
```
entry/src/main/ets/                 
|---entryability
|   └---EntryAbility.ts                   
|---logger
|   └---Logger.ts                      // 日志工具
└---pages
    |---Index.ets                      // 首页
    └---IndexSec.ets				   // 引用HAR的ArkUI组件的页面
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
|       |   └---utils
|       |       └---nativeTest.ts		// native方法页面
|       |---resources				// 资源文件
|       |---ts
|       |   └---tset.ts				// ts类和方法页面
|       └---module.json5
|---index.ets
└---oh-package.json5
```

### 具体实现

* 本示例为HarSample(静态共享包)应用，提供导出及引用HAR的ArkUI组件、接口、资源功能：
  * 导出HAR的ArkUI组件、接口、资源
    * Index.ets文件是HAR导出声明文件的入口，HAR需要导出的接口，统一在Index.ets文件中导出。Index.ets文件是DevEco Studio默认自动生成的，用户也可以自定义，在模块的oh-package.json5文件中的main字段配置入口声明文件。源码链接：[Index.ets](library/index.ets)，[oh-package.json5](library/oh-package.json5)
    * HAR中MainPage.ets文件的ArkUI组件，源码链接：[MainPage.ets](library/src/main/ets/components/mainpage/MainPage.ets)
    * HAR中test.ets文件的ts类和方法，源码链接：[test.ets](library/src/main/ts/test.ets)
    * HAR中可以包含C++编写的so，so中的native方法，HAR通过import方式导出，nativeTest.ts文件导出liblibrary.so的加法接口add，链接： [nativeTest.ts](library/src/main/ets/utils/nativeTest.ts)
  * 引用HAR的ArkUI组件、接口、资源
    * 在使用方中，引用HAR的ArkUI组件、接口、资源及 页面路由跳转，源码链接：[Index.ets](entry/src/main/ets/pages/Index.ets)，[IndexSec.ets](entry/src/main/ets/pages/IndexSec.ets)


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
echo code/DocsSample/BundleManagerDocsSample/HarSample/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
