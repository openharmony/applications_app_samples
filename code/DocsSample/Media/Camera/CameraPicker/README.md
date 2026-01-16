# 相机数据采集保存

### 介绍

本示例主要展示了Picker相机的相关功能。
接口实现相机的预览拍照功能。

### 效果预览

| 效果展示                                                               |
|--------------------------------------------------------------------|
| <img src="screenshot/device/cameraPicker.png" style="zoom:40%;" /> |

使用说明
1. 弹出是否允许“‘CameraKitSample’使用相机？”，点击“允许”。
2. 弹出是否允许“‘CameraKitSample’使用麦克风？”，点击“允许”。
3. 点击picker按钮，进入picker相机界面。
4. 选择拍照，点击拍照按钮，生成的图片会显示在图片预览界面。
5. 选择录像，点击录制按钮，生成的视频会显示在视频预览界面。

### 工程目录

```
├──entry/src/main/ets
│  ├──common
│  │  ├──utils
│  │  │  ├──Logger.ets                  // 日志工具
│  │  │  └──DateTimeUtil.ets            // 日期工具
│  │  │  └──GlobalContext.ets           // 全局上下文工具
│  │  └──Constants.ets                  // 基本参数枚举：分辨率、icon大小、按钮边距...
│  ├──entryability
│  │  └──EntryAbility.ets               // Ability的生命周期回调内容
│  └──pages
│     └──Index.ets                      // Ability实现的应用的入口页面，相机APP首页
└──entry/src/main/resources             // 应用资源目录

```

### 具体实现

1. 使用Camera Kit相关能力。

### 相关权限

* ohos.permission.CAMERA：用于相机操作。
* ohos.permission.MICROPHONE：麦克风权限，用于录像。
* ohos.permission.WRITE_IMAGEVIDEO：用于写入媒体文件。
* hos.permission.READ_IMAGEVIDEO：用于读取媒体文件。

### 依赖

不涉及

### 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：华为手机。 

2. 本示例支持API20版本SDK，版本号：6.0.0.47。

3. 本示例已支持使DevEco Studio 6.0.0 Release(构建版本：6.0.0.858，构建 2025年9月25日)编译运行。