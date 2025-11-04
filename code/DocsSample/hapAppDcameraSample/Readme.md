# 分布式相机示例代码工程化

### 介绍

本示例为开发指南中 **分布式相机开发** 章节示例代码的完整工程。该工程展示了如何发现并连接一个远端的分布式摄像头设备，并将远端的预览图像显示在本地屏幕上，最后通过本地操作来控制远端摄像头进行拍照。

本工程配套的开发指南文档，详细描述了相关的开发流程与核心代码，可查阅如下链接：
[分布式相机开发指南](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/distributedservice/camera-distributed.md)

### 效果预览

| 主界面 |权限申请|
|---|---|
| <img src=".\screenshot\image.png" width="360;">  |<img src=".\screenshot\image3.png" width="360;">|
| 预览 |照片文件|
| <img src=".\screenshot\image4.png" width="360;">  |<img src=".\screenshot\image5.png" width="360;">
### 使用说明

1.  启动应用，应用会弹出权限申请对话框，请点击同意。
2.  确保两台设备已在同一个局域网下成功组网。
3.  点击界面上的 **"Connect Remote"** 按钮，应用将开始初始化并连接远端的分布式摄像头。
4.  连接成功后，远端摄像头的预览画面将实时显示在应用屏幕上。
5.  点击屏幕下方的圆形白色拍照按钮，即可控制远端设备进行拍照。
6.  拍摄的照片会自动保存到应用的沙箱目录中。
   > 参考路径: /data/app/el2/100/com.ohos.HapAppDcameraSample/haps/entry/files
7.  退出应用或应用进入后台时，会自动释放相机资源。

### 工程目录
```
entry/src/main/ets/
|---common
|   |---DeviceDialog.ets             // 远端设备列表对话框 (可选，当前未直接使用)
|   └---TitleBarComponent.ets        // 顶部标题栏组件
|---entryability
|   └---EntryAbility.ts              // 应用主入口与权限申请
|---entrybackupability
|   └---EntryBackupAbility.ets       // 应用备份恢复能力 (可按需保留)
|---recorder
|   |---RemoteDeviceModel.ets        // 远端设备模型
|   └---VideoRecorder.ets            // 核心业务页面 (UI与相机逻辑)
└---utils
    |---DateTimeUtils.ets            // 日期时间工具类
    |---Logger.ts                    // 日志工具类
    └---SaveCameraAsset.ets          // 媒体文件保存工具类
```

### 具体实现

  * 本示例应用核心展示了分布式相机的连接、预览与拍照功能：
      * **应用权限申请**:
        在 `EntryAbility.ts` 中，通过 `abilityAccessCtrl` 模块为应用申请相机、麦克风、媒体读写和分布式数据同步等必要的权限。
      * **远端相机初始化**:
        在 `VideoRecorder.ets` 的 `initCamera` 方法中，通过 `camera.getCameraManager()` 获取相机管理器，调用 `getSupportedCameras()` 遍历查找 `connectionType` 为 `CAMERA_CONNECTION_REMOTE` 的远端相机设备。
      * **创建输入与输出**:
        在 `VideoRecorder.ets` 中，分别为远端相机创建 `CameraInput` 对象；基于界面上的 XComponent 组件创建 `PreviewOutput` 以显示预览流；并创建 `ImageReceiver` 和 `PhotoOutput` 以接收拍照数据流。
      * **创建并运行会话**:
        在 `VideoRecorder.ets` 的 `createCaptureSession` 方法中，创建 `CaptureSession`，将上述输入和输出添加到会话中，配置完成后调用 `start()` 方法开启预览。
      * **拍照与资源释放**:
        在 `VideoRecorder.ets` 中，调用 `photoOutput.capture()` 执行拍照；在 `imageArrival` 回调中处理图像数据并保存到本地文件；在组件销毁时，调用 `releaseCamera()` 方法，依次停止和释放会话、输入、输出等所有占用的资源。
      * **错误码**:
        开发过程中遇到的错误码请参见 [相机服务子系统错误码]

### 相关权限

  - [ohos.permission.CAMERA]
  - [ohos.permission.MICROPHONE]
  - [ohos.permission.DISTRIBUTED_DATASYNC]
  - [ohos.permission.MEDIA_LOCATION]
  - [ohos.permission.READ_MEDIA]
  - [ohos.permission.WRITE_MEDIA]

### 依赖

不涉及

### 约束与限制

1.  本示例仅支持标准系统上运行。
2.  本示例为Stage模型，支持API版本 **API Version 20 Beta5**，SDK版本号：**OpenHarmony SDK Ohos_sdk_public 6.0.0.47**。
3.  本示例需要使用DevEco Studio **6.0.0 Beta5** 及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/hapAppDcameraSample/ > .git/info/sparse-checkout  // 请根据实际路径修改
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```