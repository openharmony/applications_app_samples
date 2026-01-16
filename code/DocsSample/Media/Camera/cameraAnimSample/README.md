## 实现相机旋转功能

### 介绍

本示例基于Camera Kit相机服务，使用ArkTS API实现基础动效，包含闪黑动效和模糊动效。
在前述功能的基础上，并适配预览、预览画面调整（前后置镜头切换、闪光灯、对焦、调焦、设置曝光中心点等）、拍照、录像等核心功能，为开发者提供自定义相机开发的完整参考与实践指导。

### 效果预览

![](./screenshot/device/cameraSample.png)

使用说明：
1. 打开应用，授权后展示预览界面。
2. 上方按钮功能为：闪光灯设置。
3. 切换录像模式，上方按钮为：闪关灯设置。
5. 下方按钮可拍照，录像，切换前后置摄像头。

### 工程目录

```
├──entry/src/main/ets/                              
│  ├──entryability
│  │  └──EntryAbility.ets                           // 程序入口类
│  ├──constants
│  │  └──Constants.ets                              // 常量文件
│  ├──pages             
│  │  └──Index.ets                                  // 入口预览页面
│  └──views             
│     ├──ModeComponent.ets                          // 拍照录像模式切换按钮视图
│     ├──FlashingLightComponent.ets                 // 闪光灯模式按钮视图
│     └──FocusComponent.ets                         // 对焦模式视图
└──entry/src/main/resources                         // 应用静态资源目录
```

### 具体实现

1. 使用Camera Kit相关能力。
2. 使用animateToImmediately接口实现闪黑或者模糊等动效的实现。

### 相关权限

- ohos.permission.CAMERA：用于相机操作。
- ohos.permission.MICROPHONE：麦克风权限，用于录像。

### 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：华为手机。 

2. 本示例支持API20版本SDK，版本号：6.0.0.47。

3. 本示例已支持使DevEco Studio 6.0.0 Release(构建版本：6.0.0.858，构建 2025年9月25日)编译运行。

