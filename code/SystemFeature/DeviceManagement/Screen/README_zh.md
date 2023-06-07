# 屏幕属性

### 介绍

本示例监听屏幕数量变化，创建、销毁虚拟屏幕模拟屏幕增减，读取屏幕属性并显示。

### 效果预览

|主页| 屏幕详情页面                                  |
|--------------------------------|-----------------------------------------|
|![](screenshots/device/index.png)| ![](screenshots/device/defaultInfo.png) |

### 使用说明

1.点击主页面中大矩形，弹窗显示默认屏幕宽、高、刷新率、ID信息，点击任意区域关闭弹窗，点击小矩形，弹窗显示所有屏幕信息。

2.点击**增加屏幕**按钮，监听到屏幕增加，增加小矩形代表新增屏幕（因界面空间有效，增加超过三个屏幕，只显示三个小矩形）。

3.点击**移除屏幕**按钮，监听到屏幕销毁，减少小矩形代表移除屏幕。

### 工程目录
```
entry/src/main/ets/
|---Application
|   |---AbilityStage.ts
|---common
|   |---DisplayDevice.ets                    // 显示屏幕
|   |---ShowInfo.ets                         // 显示屏幕信息
|---MainAbility
|   |---MainAbility.ts
|---model
|   |---DisplayModel.ts                      // 显示数据
|   |---Logger.ts                            // 日志工具
|---pages
|   |---Index.ets                            // 首页
```
### 具体实现

* 该示例屏幕属性接口提供获取默认display对象、获取所有display对象，开启监听、关闭监听功能，screen接口提供创建虚拟屏幕、销毁虚拟屏幕、扩展屏幕、镜像屏幕等功能。
* 源码链接：[DisplayDevice.ets](code/SystemFeature/DeviceManagement/Screen/entry/src/main/ets/common/DisplayDevice.ets)，[DisplayModel.ts](code/SystemFeature/DeviceManagement/Screen/entry/src/main/ets/model/DisplayModel.ts)，[ShowInfo.ets](code/SystemFeature/DeviceManagement/Screen/entry/src/main/ets/common/ShowInfo.ets)
* 接口参考：[@ohos.display](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-display.md)，[@ohos.screen](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-screen.md)

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持在标准系统上运行。

2.本示例为Stage模型，已适配API version 9版本SDK，版本号：3.2.11.9。

3.编译前下载最新每日构建中ohos-sdk，解压并替换@ohos.screen.d.ts文件。

4.本示例需要使用DevEco Studio 3.1 Beta2 (Build Version: 3.1.0.400, built on April 7, 2023)及以上版本才可编译运行。

5.本示例需要使用@ohos.screen系统权限的系统接口。使用Full SDK时需要手动从镜像站点获取，并在DevEco Studio中替换，具体操作可参考[替换指南](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/quick-start/full-sdk-switch-guide.md)。

### 下载

如需单独下载本工程，执行如下命令：
```
git init
git config core.sparsecheckout true
echo code/SystemFeature/DEviceManagement/Screen/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master

```