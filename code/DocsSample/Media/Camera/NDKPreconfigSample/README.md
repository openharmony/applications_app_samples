# NDKPreconfigSample

### 介绍

本示例主要展示了相机的预配置相关功能，使用[libohcamera.so]
接口实现相机的使用预配置进行预览、拍照、录像、前后置摄像头切换进行拍照、录像等功能


### 效果预览

| 效果展示                                                  |
|-------------------------------------------------------|
| <img src="ScreenShot/camera.jpg" style="zoom:40%;" /> |


### 使用说明

1. 弹出是否允许“ndk_camera_normal_demo”使用相机？点击“允许”。
2. 弹出是否允许“ndk_camera_normal_demo”使用麦克风？点击“允许”。
3. 弹出是否允许“ndk_camera_normal_demo”访问文件？点击“允许”。
4. 弹出是否允许“ndk_camera_normal_demo”访问图片和视频？点击“允许”。
5. 进入预览界面，预览正常，滑动变焦按钮，同一画面远近变焦效果明显。
6. 进入预览界面，预览正常，点击画面模糊处，点击处画面会变得清晰，对焦效果明显。
7. 进入预览界面，预览正常，上下滑动屏幕，屏幕场景亮度发生变化，曝光效果明显。
8. 进入预览界面，预览正常，进入拍照模式，点击拍照按钮，拍照正常，点击左下角相册图标，能够跳转到图库，图片保存正常，打开图片显示正常。
9. 进入预览界面，预览正常，切换到录像模式，点击录像，开始录像，再点击停止录像按钮，录像成功，点击左下角相册图标，能够跳转到图库，录像文件保存正常，播放录像文件正常。
10. 进入预览界面，预览正常，切换到前置摄像头，点击拍照按钮，拍照正常，点击左下角相册图标，能够跳转到图库，图片保存正常，打开图片显示正常。
11. 进入预览界面，预览正常，切换到前置摄像头， ，点击录像，开始录像，再点击停止录像按钮，录像成功，点击左下角相册图标，能够跳转到图库，录像文件保存正常，播放录像文件正常。
12. 进入预览界面，预览正常，进入拍照模式，选择预配置类型和分辨率比例，点击拍照按钮，拍照正常，点击左下角相册图标，能够跳转到图库，图片保存正常，打开图片显示正常。
13. 进入预览界面，预览正常，切换到录像模式，选择预配置类型和分辨率比例，点击录像，开始录像，再点击停止录像按钮，录像成功，点击左下角相册图标，录像文件保存正常，播放录像文件正常。

### 工程目录

```
entry/src/main
|-- cpp
|   |-- CMakeLists.txt						// Cmake打包配置文件，编译工程动态库脚本，依赖头文件、cpp以及相关依赖
|   |-- camera_manager.cpp					// 相机基本功能接口定义cpp实现侧
|   |-- camera_manager.h					// 相机基本功能接口定义头文件
|   |-- main.cpp					        // NAPI实现JS与C++通信的接口
|   |-- common
|   |    -- log_common.h                    //日志工具文件
|   |-- types
|       `-- libentry
|           |-- index.d.ts      			// 导入NAPI接口供JS调用
|           `-- oh-package.json5			// 接口注册配置文件
|-- ets
|   |-- Dialog
|   |   |-- MainDialog.ets					// 打开相机APP弹出的网络权限设置
|   |-- common
|   |   |-- Constants.ts					// 基本参数枚举：纵横比、设备类型、视频帧数
|   |   |-- DisplayCalculator.ts			// 计算界面宽高显示数值
|   |-- entryability
|   |   `-- EntryAbility.ts					// Ability的生命周期回调内容
|   |-- model
|   |   |-- DateTimeUtil.ts					// 日期工具
|   |   |-- Logger.ts						// 日志工具
|   |-- pages
|   |   `-- Index.ets						// Ability实现的应用的入口页面，相机APP首页
|   `-- views
|       |-- PreviewPage.ets                 // 图片预览界面布局
|       |-- SlidePage.ets					// 滑动滑块UI界面布局
|       |-- dividerPage.ets					// 分割线UI布局
|       |-- focusAreaPage.ets				// 对焦区域设置（焦点、侧光点）、单指竖直方向拖动触发曝光补偿设置
|       |-- focusPage.ets					// 变焦、对焦、曝光、刻度的图标设置、值的设置
|       `-- modeSwitchPage.ets				// 相机功能模式切换，开启预览、拍照、录像

```

### 具体实现
* 相机功能接口实现在CameraManager.cpp中，源码参考：[CameraManager.cpp](entry/src/main/cpp/CameraManager.cpp)
    * 在NDKCamera构造函数里完成一个相机生命周期初始化的过程，包括调用OH_Camera_GetCameraMananger获取CameraMananger，调用OH_CameraManager_CreateCaptureSession创建CaptureSession，调用CaptureSessionRegisterCallback创建CaptureSession注册回调，调用GetSupportedCameras获取支持的camera设备，调用GetSupportedOutputCapability获取支持的camera设备能力集，调用CreatePreviewOutput创建预览输出，根据当前模式调用CreateVideoOutput或CreatePhotoOutput创建录像流输出或拍照流输出，调用CreateCameraInput创建相机输入，调用CameraInputOpen打开相机输入，调用CameraManagerRegisterCallback创建CameraManager注册回调，最后调用SessionFlowFn开启Session。
    * 其中SessionFlowFn是一个配流的动作，主要流程包括：调用OH_CaptureSession_BeginConfig开始配置会话，调用OH_CaptureSession_AddInput把CameraInput加入到会话，调用OH_CaptureSession_AddPreviewOutput把previewOutput加入到会话，根据当前模式分别调用OH_CaptureSession_AddVideoOutput或OH_CaptureSession_AddPhotoOutput把videoOutput或photoOutput加入到会话中，调用OH_CaptureSession_CommitConfig提交配置信息，调用OH_CaptureSession_Start开始会话工作，还有一步是在开启预览的同时调用IsFocusMode启动对焦功能，这边后面会涉及到。
    * 在NDKCamera析构函数里完成对相机生命周期释放的过程，调用OH_CameraManager_DeleteSupportedCameras删除支持的camera设备，调用OH_CameraManager_DeleteSupportedCameraOutputCapability删除支持的camera设备能力集，调用OH_Camera_DeleteCameraMananger删除camera manager。
    * 拍照功能相关接口封装在TakePicture接口中，主要包含以下流程：调用OH_PhotoOutput_IsMirrorSupported获取是否支持拍照镜像，然后调用OH_PhotoOutput_GetPhotoRotation获取当前拍照角度，最后调用OH_PhotoOutput_Capture_WithCaptureSetting接口开启拍照动作。
    * 录像功能相关接口封装在VideoOutputStart、VideoOutputStop接口中，主要包含以下流程：调用OH_VideoOutput_Start开始录像，调用OH_VideoOutput_Stop停止录像。
    * 变焦功能相关接口封装在setZoomRatioFn接口中，主要包含以下流程：调用OH_CaptureSession_GetZoomRatioRange获取支持的变焦范围，调用OH_CaptureSession_SetZoomRatio设置变焦，调用OH_CaptureSession_GetZoomRatio获取当前设备的变焦值。
    * 曝光功能相关接口封装在IsExposureModeSupportedFn接口中，主要包含以下流程：调用OH_CaptureSession_IsExposureModeSupported判断是否支持曝光模式，然后调用OH_CaptureSession_SetExposureMode设置曝光模式，调用OH_CaptureSession_GetExposureMode获取设置后的曝光模式。调用IsExposureBiasRange接口获取曝光补偿，其中包含调用OH_CaptureSession_GetExposureBiasRange获取曝光补偿的范围，调用OH_CaptureSession_SetExposureBias设置曝光点，调用OH_CaptureSession_GetExposureBias获取曝光点。
    * 对焦功能相关接口封装在IsFocusMode接口中，主要包含以下流程：调用OH_CaptureSession_IsFocusModeSupported判断是否支持对焦模式，调用OH_CaptureSession_SetFocusMode设置对焦模式，调用OH_CaptureSession_GetFocusMode获取设置后的对焦模式。调用IsFocusPoint接口获取对焦点，其中包括调用OH_CaptureSession_SetFocusPoint获取JS侧下发来的对焦点位，然后调用OH_CaptureSession_GetFocusPoint获取设置后的对焦点位。

    * 回调接口设置：
        * CameraManagerRegisterCallback：监听相机状态回调，在打开、退出相机，相机摄像头切换时会触发
        * CameraInputRegisterCallback：相机输入发生错误时触发回调
        * PreviewOutputRegisterCallback：开启预览流时触发回调
        * PhotoOutputRegisterCallback：开启拍照时触发回调
        * VideoOutputRegisterCallback：开启录像模式时触发回调
        * MetadataOutputRegisterCallback：有metadata流输出时触发回调
        * CaptureSessionRegisterCallback：session出现异常时以及开启对焦模式时触发回调


* 相机预览、拍照、录像功能、前后置切换功能实现调用侧位于Index.ets，modeSwitchPage.ets，main.cpp中，源码参考：[Index.ets](entry/src/main/cpp/ets/pages/Index.ets)，[modeSwitchPage.ets](entry/src/main/cpp/ets/views/modeSwitchPage.ets)，[main.cpp](entry/src/main/cpp/main.cpp)
    * 预览：开启预览位于Index.ets下的onPageShow接口，其中调用cameraDemo.initCamera接口，将预览的surfaceId，对焦模式的值，以及是前置还是后置摄像头设备作为入参传下去，实际调用的是main.cpp下的InitCamera接口，InitCamera接口将JS侧拿到的参数进行转换再传入cameraManager.cpp中的构造函数里去，完成开启相机的操作，开启预览并设置好对焦模式。
    * 拍照和录像：开启拍照位于ModeSwitchPage.ets下的isVideoPhotoFn接口，通过判断modelBagCol的值是photo还是video，将modelBagCol的值，videoId，拍照的surfaceID或者录像的surfaceId传入接口startPhotoOrVideo。如果是拍照模式，则跳转到main.cpp中的TakePicture接口，将传下来的参数进行格式转换，再调用CameraManager对象下的TakePicture接口开启拍照操作；如果是录像模式，跳转到main.cpp中的VideoOutputStart接口，再调用CameraManager对象下的VideoOutputStart接口开启录像操作。
    * 前后置切换：前后置摄像头切换接口位于modeSwitchPage.ets，切换cameraDeviceIndex，将先前的session配置释放，调用cameraDemo.releaseSession接口，实际上是main.cpp下的ReleaseSession接口，最终调用到CameraManager.cpp下的ReleaseSession接口。然后将预览的surfaceId，对焦模式的值以及cameraDeviceIndex传入cameraDemo.initCamera接口中，逻辑和预览一致。
    * 使用预配置：选择预配置模式位于Index.ets下的两个Select控件，用于选择预配置类型和画面比例，其中调用cameraDemo.initCamera接口将预配置类型和画面比例作为入参传下去，实际调用的是main.cpp下的InitCamera接口，InitCamera接口将JS侧拿到的参数进行转换再传入cameraManager.cpp中的构造函数里去，在CreatePhotoOut、CreatePreviewOutput以及Video Output时使用预配置的profile进行创建，其余流程同拍照和录像


* 相机变焦、对焦、曝光功能实现调用侧位于FlashingLightPage.ets，SlidePage.ets，中，源码参考：[SlidePage.ets](entry/src/main/cpp/ets/views/SlidePage.ets)，[focusAreaPage.ets](entry/src/main/cpp/ets/views/focusAreaPage.ets)，[main.cpp](entry/src/main/cpp/main.cpp)
    * 变焦：变焦功能位于SlidePage.ets，通过调用slideChange接口设置slide滑块的值，目前只支持1-10.然后调用cameraDemo.setZoomRatio接口调用到main.cpp中的SetZoomRatio接口，最终调到CameraManager.cpp中的setZoomRatioFn接口，完成变焦功能的实现。
    * 对焦：对焦功能位于focusAreaPage.ets，通过在build中将对焦焦点下发到cpp侧，在CameraManager.cpp文件中的SessionFlowFn函数中，会调用IsFocusMode接口来判断是否支持对焦模式，然后通过onTouch的方式将对焦点位通过cameraDemo.isFocusPoint接口下发到main.cpp侧的IsFocusPoint接口，最终调到CameraManager.cpp中的IsFocusPoint接口。以及调用OH_CaptureSession_SetFocusMode拿到对焦点位来设置对焦模式，最后调用OH_CaptureSession_GetFocusMode来获取对焦模式，完成对焦功能实现。
    * 曝光：曝光功能位于focusAreaPage.ets，通过在build中将侧光点位下发到cpp侧，然后通过onTouch的方式将对焦点位以及侧光点位通过cameraDemo.isFocusPoint接口下发到main.cpp侧的isMeteringPoint接口，最终调到CameraManager.cpp中的IsMeteringPoint接口。然后设置曝光补偿，单指竖直方向拖动触发该手势事件，调用gesture中的cameraDemo.isExposureBiasRange接口将曝光值下发到main.cpp中的IsExposureBiasRange，然后经过napi转换后将值传到CameraManager.cpp中的IsExposureBiasRange接口，之后从native侧发到曝光补偿的范围，再调用OH_CaptureSession_SetExposureBias设置曝光值，最后调用OH_CaptureSession_GetExposureBias接口获取曝光值，完成曝光功能。

### 相关权限

[ohos.permission.CAMERA](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-all-user.md#ohospermissioncamera)

[ohos.permission.MICROPHONE](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-all-user.md#ohospermissionmicrophone)

[ohos.permission.READ_MEDIA](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-all-user.md#ohospermissionread_media)

[ohos.permission.WRITE_MEDIA](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-all-user.md#ohospermissionwrite_media)

[ohos.permission.MEDIA_LOCATION](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-all-user.md#ohospermissionmedia_location)

### 依赖

不涉及

### 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：华为手机。

2. 本示例支持API20版本SDK，版本号：6.0.0.47。

3. 本示例已支持使DevEco Studio 6.0.0 Release(构建版本：6.0.0.858，构建 2025年9月25日)编译运行。
