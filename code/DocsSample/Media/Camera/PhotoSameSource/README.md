## 实现相机基础拍照、录像功能

### 介绍

本示例基于Camera Kit相机服务，适配预览、预览画面调整（前后置镜头切换、闪光灯等）、动态照片、拍照、录像等核心功能，为开发者提供自定义相机开发的完整参考与实践指导。

### 效果预览

![](./screenshot/device/cameraSameSource.PNG)

使用说明：
1. 打开应用，授权后展示预览界面。
2. 上方按钮功能为：闪光灯设置，动态照片设置。
3. 屏幕按钮功能未：切换拍照/录像模式。
4. 下方按钮可显示缩略图，拍照/录像，切换前后置摄像头。

### 工程目录

```
├──entry/src/main/ets/                
│  ├──common          
│  │  └──utils        
│  │  │  ├──BlurAnimetaUtil.ts   
│  │  │  ├──DataTimeUtil.ets   
│  │  │  ├──GlobalContext.ets   
│  │  │  └──Logger.ts     
│  │  └──Constants.ts
│  ├──entryability
│  │  └──EntryAbility.ets                           // 程序入口类
│  ├──mode
│  │  └──CameraService.ets                          // 相机启动类
│  ├──pages    
│  │  ├──EditPage.ets                               // 录像预览页面        
│  │  └──Index.ets                                  // 入口预览页面
│  └──views             
│     ├──FlashingLightComponent.ets                 // 闪光灯，动图模式按钮视图
│     ├──FocusAreaComponent.ets                     // 对焦绘制视图
│     ├──FocusComponent.ets                         // 对焦模式视图
│     ├──ModeComponent.ets                          // 拍照录像模式切换按钮视图
│     └──SlideComponent.ets                         // 变焦滑动视图
└──entry/src/main/resources                         // 应用静态资源目录
```

### 具体实现

1. 使用Camera Kit相关能力。
2. 使用animateToImmediately接口实现闪黑或者模糊等动效的实现。

### 相关权限

- ohos.permission.CAMERA：用于相机操作。
- ohos.permission.MICROPHONE：麦克风权限，用于录像。
- ohos.permission.WRITE_IMAGEVIDEO：媒体库权限，用于保存图片到图库。
- ohos.permission.READ_IMAGEVIDEO：媒体库权限，用于读取图库图片。

### 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：华为手机。 

2. 本示例支持API20版本SDK，版本号：6.0.0.47。

3. 本示例已支持使DevEco Studio 6.0.0 Release(构建版本：6.0.0.858，构建 2026年4月7日)编译运行。

