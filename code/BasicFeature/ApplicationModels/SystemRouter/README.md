# Navigation系统路由

### 介绍

本项目提供系统路由的验证，运用系统路由表的方式，跳转到模块(HSP/HAR)的页面，可以不用配置不同跳转模块间的依赖。当发生页面跳转时，未跳转页面不会加载,
已经加载过的页面不会再次加载。 解决了不同模块依赖耦合的问题，以及首页加载时间长的问题。
详细配置可参考[系统路由表](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/arkts-navigation-navigation.md)。

由于环境的差异，不建议下载后直接编译，应先当创建项目，参考示例代码进行编写。

### 效果预览

<img src="./images/NavIndex.jpeg" width="200" height="360" /> 

| EntryPageOne                                                     | EntryPageTwo                                                     | HarAPageOne                                                     | 
|------------------------------------------------------------------|------------------------------------------------------------------|-----------------------------------------------------------------|
| <img src="./images/EntryPageOne.jpeg" width="200" height="360"/> | <img src="./images/EntryPageTwo.jpeg" width="200" height="360"/> | <img src="./images/HarAPageOne.jpeg" width="200" height="360"/> |
| HarAPageTwo                                                      | HspAPageOne                                                      | HspAPageTwo                                                     |
| <img src="./images/HarAPageTwo.jpeg" width="200" height="360"/>  | <img src="./images/HspAPageOne.jpeg" width="200" height="360"/>  | <img src="./images/HspAPageTwo.jpeg" width="200" height="360"/> |

使用说明

1. 主页会提供一个NavIndex的导航页，点击按钮会跳转到不同的来自HAR和HSP包的页面

2. 每个HAR和HSP包的页面也存在跳转到别的页面的按钮

### 工程目录

```
├──entry/src/main/ets/
│  ├──common
│  │  └──utils
│  │     └──Logger.ets                          // 日志打印封装
│  ├──entryability
│  │  └──EntryAbility.ets                       // 程序入口  
│  └──pages
│     ├──EntryPageOne.ets                       // 页面1
│     ├──EntryPageTwo.ets                       // 页面2
│     └──Index.ets                              // 界面实现
├──entry/src/main/resources                     // 应用资源目录
├──harA
├──harB
├──hspA
└──hspB
```

### 具体实现

1.创建hapA harA hspA hspB

2.在跳转目标模块的配置文件[module.json5](entry/src/main/module.json5)添加路由表配置

3.添加完路由配置文件地址后，需要在工程resources/base/profile中创建[route_map.json](entry/src/main/resources/base/profile/router_map.json)
文件

4.在跳转目标页面中，需要配置入口Builder函数，函数名称需要和[route_map.json](entry/src/main/resources/base/profile/router_map.json)
配置文件中的buildFunction保持一致。

5.应用通过调用pushDestinationByName等方式，可以获取跳转目标页面的错误信息。

6.运行时需设置引用所有HSP模块。设置运行后，点击Run > entry来启动应用/服务的编译构建。

### 相关权限

不涉及

### 依赖

不涉及。

### 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：RK3568。

2. 本示例仅支持API12版本SDK，版本号：5.0.0.26，镜像版本号：OpenHarmony 5.0.0.26。

3. 本示例需要使用DevEco Studio NEXT Developer Beta5 (Build Version: 5.0.3.700)才可编译运行；

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/BasicFeature/ApplicationModels/SystemRouter > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
