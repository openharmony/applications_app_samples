# 音视频录制

### 介绍

音视频录制应用是基于AVRecorder接口开发的实现音频录制和视频录制功能的应用，音视频录制的主要工作是捕获音频信号，接收视频信号，完成音视频编码并保存到文件中，帮助开发者轻松实现音视频录制功能，包括开始录制、暂停录制、恢复录制、停止录制、释放资源等功能控制。它允许调用者指定录制的编码格式、封装格式、文件路径等参数。

本示例主要使用@ohos.multimedia.media中的AVRecorder接口实现了录制功能；另外辅助使用@ohos.multimedia.medialibrary接口，实现了创建录制文件功能，接口使用以及权限获取详见[媒体库管理](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-medialibrary.md)。使用@ohos.multimedia.camera接口，实现了相机预览及出流功能，接口使用以及权限获取详见[相机管理](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-camera.md)。

### 效果预览

| 主页                                                         | 视频录制                                                     | 音频录制                                                     |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img src="screenshots/devices/homePage.jpg" alt="homePage" style="zoom:25%;" /> | <img src="screenshots/devices/videoRecorder.jpg" alt="videoRecorder" style="zoom:25%;" /> | <img src="screenshots/devices/audioRecorder.jpg" alt="audioRecorder" style="zoom:25%;" /> |

使用说明

1. 进入应用前请先安装[VideoRecorder](./lib/VideoRecorder-1.0.0.hap)。
2. 在主界面，可以点击视频录制、音频录制进入对应功能界面。
3. 点击视频录制页面，进入页面呈现摄像头预览画面，用户可以通过点击左上角的设置图标进行视频分辨率参数设置，点击”开始“”暂停“”恢复“”停止“等对应图标按钮进行视频录控相关操作。
4. 点击音频录制页面，用户可以通过点击左上角的设置图标进行音频采样率参数设置，点击”开始“”暂停“”恢复“”停止“等对应图标按钮进行音频录控相关操作。

### 工程目录

```
entry/src/main/ets/
|---entryability
|   |---data                               // 能力生命周期管理
|---pages
|   |---ListPage.ets                       // 首页，选择音频录制或者视频录制
|---recorder
|   |---AudioRecorder.ets                  // 音频录制页面
|   |---VideoRecorder.ets                  // 视频录制页面
|---utils
|   |---DateTimeUtils                      // 录制显示时间转换函数
|   |---SaveCameraAsset.ets                // 创建录制文件相关函数
|   |---Logger.ts                          // 封装的日志打印函数
```

### 具体实现

* 录控功能接口调用实现参考工程目录中的音频录制页面和视频录制页面
  * 调用create()、prepare()、getInputSurface()、start()、pause()、resume()、stop()、reset()、release()接口实现录制器的创建、准备、录控操作、重置、销毁实例等功能；
  * 视频录制[VRecorder.ets](entry/src/main/ets/recorder/VideoRecorder.ets)调用Camera接口实现相机出流功能配合视频录制功能，相机的实现方法参考自相机接口[@ohos.multimedia.camera](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-camera.md)
* 调用MediaLibrary实现创建录制文件代码在[SaveCameraAsset.ets](entry/src/main/ets/utils/SaveCameraAsset.ets)，实现方法参考[@ohos.multimedia.medialibrary](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-medialibrary.md)接口说明

### 相关权限

开发者在进行录制功能开发前，需要先对所开发的应用配置相应权限，应用权限列表参考：[ 应用权限列表]([zh-cn/application-dev/security/permission-list.md · OpenHarmony/docs - Gitee.com](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md))。权限配置相关内容可参考：[访问控制权限申请指导](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/accesstoken-guidelines.md)。

音视频录制涉及的权限包括：

1.允许应用使用麦克风：[ohos.permission.MICROPHONE](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md#ohospermissionmicrophone)

2.允许应用使用相机拍摄照片和录制视频：[ohos.permission.CAMERA](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md#ohospermissioncamera)

3.允许应用读取用户外部存储中的媒体文件信息：[ohos.permission.READ_MEDIA](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md#ohospermissionread_media)

4.允许应用读写用户外部存储中的媒体文件信息：[ohos.permission.WRITE_MEDIA](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md#ohospermissionwrite_media)

5.允许应用获取设备位置信息：[ohos.permission.LOCATION](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/permission-list.md#ohospermissionlocation)

### 依赖

不涉及

### 约束与限制

1.本示例仅支持在标准系统上运行，支持设备：Phone。

2.本示例仅支持API9版本SDK，版本号：3.2.10.8。

3.本示例使用的IDE版本信息：DevEco Studio 3.1 Beta2 (Build Version:3.1.0.400, built on April 7, 2023)。

4.相机、媒体库为系统接口，需要配置高权限签名，相关权限级别可查阅权限列表，需要配置系统应用签名，可以参考[特殊权限配置方法](https://docs.openharmony.cn/pages/v3.2/zh-cn/application-dev/security/hapsigntool-overview.md/)。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/BasicFeature/Media/AVRecorder/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
