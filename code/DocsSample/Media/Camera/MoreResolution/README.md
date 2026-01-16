# 相机切换不同分辨率

## 介绍

本示例主要展示了相机切换不同分辨率的功能，
接口实现相机的预览拍照录像功能。

## 效果预览

| 预览                                      | 
| -------------------------------------------- | 
<img src="./screenshot/camera.jpg" width="300" />

## 使用说明
1. 弹出“是否允许CameraKitSample使用相机？”，点击“允许”。
2. 弹出“是否允许CameraKitSample使用麦克风？”，点击“允许”。
3. 进入预览界面，选择一个分辨率，当前预览界面显示正常。
4. 进入预览界面，预览正常，选择一个分辨率，点击拍照按钮，跳转到图片预览页面，跳转正常，图片预览页面显示当前所拍照的图片，显示正常。
5. 进入预览界面，预览正常，选择一个分辨率，点击拍照按钮，跳转到图片预览页面，跳转正常，图片预览页面显示当前所拍照的图片，显示正常，退出应用并进入图库应用，第一张图片显示为刚刚拍照的图片，拍照正常。
6. 点击图片预览页面的左上角返回按钮，重新进入预览页面，预览正常。
7. 进入预览界面，预览正常，点击“拍照”旁边的“录像”切换到录像模式，选择一个分辨率，预览正常，点击录像按钮，开始录像，录像正常，点击停止录像按钮，跳转到录像预览界面，跳转正常，点击视频播放按钮，播放正常。

## 工程目录

```
├──entry/src/main/ets
│  ├──common
│  │  ├──utils
│  │  │  ├──Logger.ets                  // 日志工具
│  │  │  └──GlobalContext.ets           // 全局上下文工具
│  │  └──Constants.ets                  // 基本参数枚举：分辨率、icon大小、按钮边距...
│  ├──entryability
│  │  └──EntryAbility.ets               // Ability的生命周期回调内容
│  ├──pages
│  │  ├──Index.ets                      // Ability实现的应用的入口页面，相机APP首页
│  │  └──EditPage.ets                   // 提供拍照后图片预览和编辑页面
│  ├──model1
│  │  └──CameraService.ets              // 相机初始化、分辨率选择、打开摄像头、调整焦距等功能
│  └──views
│     ├──ModeComponent.ets              // 拍照录制组件
│     └──SlideComponent.ets             // 变焦滑动条组件，可以对预览画面焦距进行改变
└──entry/src/main/resources             // 应用资源目录
```


## 具体实现
* 这里重点介绍相机分辨率功能的实现：
    * 分辨率选择位于Index.ets下的select组件的onSelect接口中，其中随用户选择更新选中索引，表明用户希望选中的分辨率，并且调用了Index.ets中的分辨率变更处理方法onResolutionChanged， onResolutionChanged主要将用户选择的分辨率以及其他参数传入initCamera2方法。
    * 在CameraService的initCamera2函数里完成一个相机生命周期初始化的过程，包括调用getCameraManager获取CameraManager，调用getSupportedCameras获取支持的camera设备，调用getSupportedOutputCapability获取支持的camera设备能力集，调用createPreviewOutput创建预览输出，调用createCameraInput创建相机输入，调用CameraInput的open打开相机输入，调用onCameraStatusChange创建CameraManager注册回调，最后调用sessionFlowFn创建并开启Session。
    * 其中在CameraService的initCamera2函数中与分辨率相关的业务流程是在selectProfileForPreviewAndVideo()函数中，该函数会创建与用户预期分辨率严格匹配的视频与预览配置文件，还有getPhotoProfile()函数，该函数会创建与用户预期分辨率一致的拍照配置文件，initcamera2后续流程将使用这些配置文件创建输出流。
    * 手机硬件并不支持预览录像模式下一些特殊情况的分辨率，见下表中画斜线表格，针对这些特殊情况，统一配置默认分辨率为1920 * 1080，该配置在Index.ets文件中的selectedResolutionIndex变量初始化值为7，指向分辨率数组resolutionOptions下标为7元素，即1920 * 1080。

## 相关权限

* ohos.permission.CAMERA
* ohos.permission.MICROPHONE

## 依赖

不涉及

## 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：华为手机。 

2. 本示例支持API20版本SDK，版本号：6.0.0.47。

3. 本示例已支持使DevEco Studio 6.0.0 Release(构建版本：6.0.0.858，构建 2025年9月25日)编译运行。

## 下载

如需单独下载本工程，执行如下命令：
```
git init
git config core.sparsecheckout true
echo MediaLibraryKit/MediaResourceChangeNotificationsSample/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```