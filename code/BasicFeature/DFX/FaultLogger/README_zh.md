# 故障日志获取

### 介绍

本示例使用了[@ohos.hiviewdfx.hiAppEvent](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-performance-analysis-kit/js-apis-hiviewdfx-hiappevent.md)接口，展示了在eTS中如何获取应用故障相关信息。

### 效果预览
|首页|
|--------|
![home](screenshots/devices/home.png)

使用说明：
1. 启动应用后，点击**构造异常**按钮，在弹窗中选择故障类型，点击确定可以构造异常场景;
2. 构造异常场景后，重新启动应用，点击下面不同的获取异常按钮可以获取到对应类型的异常日志并显示在页面文本框中。

### 工程目录
```
entry/src/main/ets/
|---common
|   |---FaultDialog.ets                    // 异常构造弹窗
|   |---PreferencesManager.ets             // 首选项工具类
|   |---TitleBar.ets                       // title
|---model
|   |---Logger                             // 日志工具
|---pages
|   |---Index.ets                          // 首页
```

### 具体实现
+ 创造应用故障场景，故障类型枚举值参考[FaultType](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-performance-analysis-kit/js-apis-hiviewdfx-hiappevent.md#hiappeventevent)，源码参考[FaultDialog.ets](entry/src/main/ets/common/FaultDialog.ets)：
    + js_crash故障：通过数组访问越界构造;
    + cpp_crash故障：通过调用空指针NAPI接口构造;
    + freeze_crash故障：通过代码产生死循环构造;
+ 获取上述异常故障日志,源码参考[Index.ets](entry/src/main/ets/pages/Index.ets)：
    + 获取异常故障日志：使用hiAppEvent.addWatcher接口获取异常日志信息。

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：RK3568；

2. 本示例已适配API version 12版本SDK，版本号：5.0.0.71；

3. 本示例需要使用DevEco Studio 4.1.3.700 (Build Version: 4.1.3.700 构建 2024年3月19日)及以上版本才可编译运行。

### 下载
如需单独下载本工程，执行如下命令：
```
git init
git config core.sparsecheckout true
echo code/BasicFeature/DFX/FaultLogger/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```