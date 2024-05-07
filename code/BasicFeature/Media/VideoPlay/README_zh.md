# 视频播放

### 介绍
视频播放的主要工作是将视频数据转码并输出到设备进行播放，同时管理播放任务。本文将对视频播放全流程、视频切换、视频循环播放等场景开发进行介绍说明。
本示例主要展示了播放本地视频和网络视频相关功能,使用 [@ohos.multimedia.media](https://gitee.com/openharmony/docs/blob/OpenHarmony-3.2-Release/zh-cn/application-dev/reference/apis/js-apis-media.md#bufferinginfotype8),[@ohos.resourceManager](https://gitee.com/openharmony/docs/blob/OpenHarmony-3.2-Release/zh-cn/application-dev/reference/apis/js-apis-resource-manager.md),[@ohos.wifiManager](https://gitee.com/openharmony/docs/blob/OpenHarmony-3.2-Release/zh-cn/application-dev/reference/apis/js-apis-wifiManager.md)等接口,实现了视频播放、暂停、调节倍速、切换视频的功能;实现效果如下;

### 效果预览
| 播放                                       | 暂停                                    | 倍速弹窗                                       | 视频列表                                      |
|------------------------------------------|---------------------------------------|--------------------------------------------|-------------------------------------------|
| ![播放.png](screenshots/devices/播放.png)    | ![暂停.png](screenshots/devices/暂停.png) | ![img_2.png](screenshots/devices/倍速弹窗.png) | ![视频列表.png](screenshots/devices/视频列表.png) |
| 拖动滑动条                                    |
| ![拖动滑动条.png](screenshots/devices/拖动滑动条.png) |

使用说明

1.点击视频界面，唤起视频操作面板，再次点击操作面板消失，如果不做任何操作操作界面会5s自动消失;

2.点击暂停/播放按钮，控制视频暂停播放;

3.滑动视频进度条，视频跳转到指定位置,在视频中间会出现时间进度方便用户查看视频进度;

4.点击倍速，可以选择1.0、1.25、1.75、2.0进行倍速调节;

5.点击下方视频名称，可以选择视频进行切换。注意：network是网络视频，检测到没有连接网络会退出应用，有网络能在本地视频和网络视频进行切换;

6.点击AudioTrack音轨列表选择框，可以选择音轨进行切换;

7.点击左上角退出箭头，退出应用。

### 目录结构
```
VideoPlay/src/main/ets/
|---components
|   |---ExitVideo.ets                            // 退出应用组件
|   |---SpeedDialog.ets                          // 播放倍速弹窗
|   |---VideoOperate.ets                         // 视频操作组件
|   |---VideoPanel.ets                           // 视频列表
|---pages
|   |---Index.ets                                // 首页视频界面
|---utils
|   |---Logger.ts                                // 日志帮助类
|   |---TimeUtils.ts                             // 视频时间帮助类
|---videomanager                                 
|   |---AvPlayManager.ts                         // 视频管理接口，统一封装了对外提供的功能接口
```

### 具体实现
+ 视频倍速切换、暂停、播放、切换视频、视频跳转的功能接口都封装在AvPlayManager.ts,源码参考：[AvPlayManager.ts](entry%2Fsrc%2Fmain%2Fets%2Fvideomanager%2FAvPlayManager.ts);
+ 使用media.createAVPlayer()来获取AVPlayer对象;
+ 倍速切换：选择不同的倍速时调用avPlayer.setSpeed(speed: PlaybackSpeed);
+ 暂停、播放：点击暂停、播放时调用avPlayer.pause()、avPlayer.play();
+ 切换视频：在切换视频前要先调用avPlayer.reset()重置资源，再通过avPlayer.fdSrc为fdSrc赋值触发initialized状态机上报;
+ 视频跳转：在拖动滑动条时调用avPlayer.seek()
+ 视频预下载：在prepared状态之前调用avPlayer.setMediaSource()
+ 多音轨选择：调用avPlayer.getTrackDescription()获取音轨列表，调用avPlayer.selectTrack()选择音轨，调用avPlayer.deselectTrack()取消选择音轨。

### 相关权限

#### [ohos.permission.INTERNET](https://docs.openharmony.cn/pages/v3.2/zh-cn/application-dev/security/permission-list.md/)
#### [ohos.permission.GET_WIFI_INFO](https://docs.openharmony.cn/pages/v3.2/zh-cn/application-dev/security/permission-list.md/)

### 依赖
不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行,需要联网才能够播放网络视频;

2.本示例已适配API12版本SDK,版本号：5.0.0.17,镜像版本号：OpenHarmony5.0.0.18;

3.本示例需要使用DevEco Studio NEXT Developer Preview1 (Build Version: 4.1.3.500, built on January 20, 2024)才可编译运行。

### 下载
如需单独下载本工程，执行如下命令：
```
git init
git config core.sparsecheckout true
echo code/BasicFeature/Media/VideoPlay/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```