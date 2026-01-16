# 相机数据采集保存

### 介绍

本示例主要展示了相机的预配置能力。
提供了相机拍照录像的功能。

### 效果预览

| 效果展示                                                            |
|-----------------------------------------------------------------|
| <img src="screenshot/device/preConfig.gif" style="zoom:40%;" /> |

使用说明
1. 弹出是否允许“‘CameraKitSample’使用相机？”，点击“允许”。
2. 弹出是否允许“‘CameraKitSample’使用麦克风？”，点击“允许”。
3. 进入预览界面，预览正常，点击拍照按钮，跳转到图片预览页面，跳转正常，图片预览页面显示当前所拍照的图片，显示正常。
4. 进入预览界面，预览正常，点击拍照按钮，跳转到图片预览页面，跳转正常，图片预览页面显示当前所拍照的图片，显示正常，点击右上角保存，退出应用并进入图库应用，第一张图片显示为刚刚拍照的图片，拍照正常。
5. 点击图片预览页面的左上角返回按钮，重新进入预览页面，预览正常。
6. 点击录制按钮，录制结束后跳转到预览界面，录制视频能正常播放，显示正常。

### 工程目录

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
│  ├──model
│  │  └──CameraService.ets              // 相机初始化、选择分辨率、打开摄像头、调整焦距等功能
│  └──views
│     ├──ModeComponent.ets              // 拍照录制组件
│     └──SlideComponent.ets             // 变焦滑动条组件，可以对预览画面焦距进行改变
└──entry/src/main/resources             // 应用资源目录

```

### 具体实现

1. 使用Camera Kit相关能力。


### 相关权限

* ohos.permission.CAMERA：用于相机操作。
* ohos.permission.MICROPHONE：麦克风权限，用于录像。
* ohos.permission.WRITE_IMAGEVIDEO：用于写入媒体文件。
* ohos.permission.ACCELEROMETER：加速度传感器数据权限。

### 依赖

不涉及

### 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：华为手机。 

2. 本示例支持API20版本SDK，版本号：6.0.0.47。

3. 本示例已支持使DevEco Studio 6.0.0 Release(构建版本：6.0.0.858，构建 2025年9月25日)编译运行。