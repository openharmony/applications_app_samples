# Debug

### 介绍

本示例通过使用[@ohos.hidebug](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-hidebug.md) 接口来获取当前应用内存使用情况。

### 效果预览

|主页|Debug数据|
|--------------------------------|--------------------------------|
|![](screenshots/device/index.jpeg)|![](screenshots/device/data.jpeg)|

使用说明

1.点击界面右上方Debug图标，弹出Debug信息界面，显示当前应用内存使用情况；

2.再次点击右上方Debug图标，Debug信息界面消失。

### 工程目录

```
entry/src/main/ets/
|---Application
|---component
|   |---DebugInfo.ets                  // Debug信息页面
|---data
|   |---Logger.ts                      // 日志工具
|---MainAbility
|---pages
|   |---Index.ets                      // 首页
```
### 具体实现

* 本实例获取Debug信息的功能结主要封装在Index，源码参考:[Index.ets](https://gitee.com/openharmony/applications_app_samples/blob/master/code/BasicFeature/DFX/Debug/entry/src/main/ets/pages/Index.ets) 。
    * 获取Debug信息：在Index页面中通过点击事件调用hidebug.getPss()、hidebug.getSharedDirty()、hidebug.getPrivateDirty()等方法能够获取应用进程实际使用的物理内存大小、进程的共享脏内存大小、进程的私有脏内存大小。
  
### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行。

2.本示例已适配API10版本SDK，版本号：4.0.5.1。

3.本示例需要使用DevEco Studio 3.1 Canary1 (Build Version: 3.1.0.100)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：
```
git init
git config core.sparsecheckout true
echo code/BasicFeature/DFX/Debug/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master

```
