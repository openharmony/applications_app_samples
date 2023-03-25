# 简单时钟

### 介绍

本示例通过使用[@ohos.display](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-display.md) 接口以及Canvas组件来实现一个简单的时钟应用。

### 效果预览

|主页|
|--------------------------------|
|![main](screenshots/device/main.jpeg)|

使用说明

1.界面通过setInterval实现周期性实时刷新时间，使用Canvas绘制时钟，指针旋转角度通过计算得出。

例如："2 * Math.PI / 60 * second"是秒针旋转的角度。

### 工程目录
```
entry/src/main/ets/
|---Application
|---MainAbility
|---model
|   |---Logger.ts                        // 日志工具
|---pages
|   |---Index.ets                        // 首页

```
### 具体实现

* 本示例展示简单时钟的方法主要封装在Index中，源码参考:[Index.ets](https://gitee.com/openharmony/applications_app_samples/blob/master/code/Solutions/Tools/ArkTSClock/entry/src/main/ets/pages/Index.ets) 。
    * 设置表盘大小：通过Index中的display.getDefaultDisplay()方法来获取设备宽高计算表盘大小；
    * 获取当前时间：调用updateTime函数，执行new Date().getHours()、new Date().getMinutes()、new Date().getSeconds()获取当前时间。
    * 绘制表盘内容：通过[CanvasRenderingContext2D](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/arkui-ts/ts-canvasrenderingcontext2d.md) 来画表盘背景、时针、分针、秒针、圆心以及表盘下方文本；
    * 启动时钟：添加setInterval定时器，每隔1s执行一次upDateTime函数。
  
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
echo code/Solutions/Tools/ArkTSClock/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master

```