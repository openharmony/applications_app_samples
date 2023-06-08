# 窗口

### 介绍

本示例展示了在应用主窗口中创建和拉起子窗口，并对子窗口设置窗口相关属性，以及设置窗口规避区域、窗口沉浸式和小窗口等功能。

本实例使用[窗口管理](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-window.md)

### 效果预览

|主页| 窗口视频                                        | 拉起悬浮应用                                  |
|--------------------------------|---------------------------------------------|---------------------------------------------|
|![home](screenshots/devices/mainWindow.png) | ![play1](screenshots/devices/subWindow.png) | ![play1](screenshots/devices/startAbility.png) |

使用说明：

1.启动应用,首页展示窗口沉浸式以及设置状态栏和任务栏属性,点击窗口视频跳转到播放页。

2.点击视频屏幕可以拉起小窗口播放视频，小窗口可以拖拽，再次点击视频可以关闭小窗口。

3.点击全屏播放并切换窗口方向按钮可以全屏播放视频并且改变窗口方向。

4.点击视频屏幕拉起小窗口播放视频, 界面显示小窗口状态为“获焦状态”; 再次点击视频关闭小窗口, 界面显示小窗口状态为“失焦状态”

5.点击视频屏幕拉起小窗口视频，再点击小窗口中的“拉起悬浮应用”按钮，成功拉起WindowRatio悬浮应用

### 工程目录
```
entry/src/main/ets/
|---Application
|   |---MyAbilityStage.ts                   
|---MainAbility
|   |---MainAbility.ts                    
|---pages
|   |---Index.ets                      // 首页
|   |---SubWindowPage.ets              // 全屏播放
|   |---Video.ets                      // 视频播放
```

### 具体实现

* 本示例主要分为三个模块
  * 首页入口模块
    * 使用WindowStage实例化一个窗口，引入WindowManger方法设置一个主窗口与子窗口
    * 源码链接：[WindowManger.ts](WindowComponent/src/main/ets/components/feature/WindowManger.ts)，[WindowConst.ts](WindowComponent/src/main/ets/components/util/WindowConst.ts),
    * 接口参考：[@ohos.window](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-window.md)，[@ohos.events.emitter](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-emitter.md)，[@ohos.app.ability.common](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-app-ability-common.md)，[@ohos.router](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-router.md)

  * 窗口视频模块
    * 这里用到依赖window-components中WindowComponent方法来进行视频的播放

  * 全屏播放窗口并切换窗口方向模块
    * 通过EventPriority方法表示事件被发送的优先级，emitter.emit方法发送指定的事件进行全屏播放和切换窗口方向
    * 参考接口：[@ohos.events.emitter](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-emitter.md)


### 相关权限

本示例需要在module.json5中配置如下权限:

允许应用使用悬浮窗的能力：[ohos.permission.SYSTEM_FLOAT_WINDOW](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md#ohospermissionsystem_float_window)


### 依赖

本示例需要依赖[窗口比例](code/BasicFeature/WindowManagement/WindowRatio)sample，本示例点击“拉起悬浮应用”按钮之后会以悬浮窗模式拉起[窗口比例](code/BasicFeature/WindowManagement/WindowRatio)sample。


### 约束与限制

1.本示例仅支持标准系统上运行,支持设备:RK3568；

2.本示例不支持release版本,仅支持master版本,当前software version为OpenHarmony 4.0.8.2

3.本示例SDK仅支持api10及以上版本,当前支持的SDK版本链接如下：

[SDK全量包下载链接](http://download.ci.openharmony.cn/version/Daily_Version/ohos-sdk-public/20230610_140110/version-Daily_Version-ohos-sdk-public-20230610_140110-ohos-sdk-public.tar.gz)

4.本示例需要使用DevEco Studio 3.1 Beta2 (3.1.0.500, built on April 28, 2023)及以上版本才可编译运行；

5.本示例所配置的权限ohos.permission.SYSTEM_FLOAT_WINDOW为system_basic级别(相关权限级别可通过[权限定义列表](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md)查看)，需要手动配置对应级别的权限签名(具体操作可查看[自动化签名方案](https://docs.openharmony.cn/pages/v3.2/zh-cn/application-dev/security/hapsigntool-overview.md/)。

### 下载

如需单独下载本工程，执行如下命令：
```
git init
git config core.sparsecheckout true
echo code/BasicFeature/WindowManagement/WindowManage/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master

```