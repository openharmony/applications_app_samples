# ArkUI视频播放指南文档示例

### 介绍

本示例通过使用[ArkUI指南文档](https://gitcode.com/openharmony/docs/tree/master/zh-cn/application-dev/ui)中各场景的开发示例，展示在工程中，帮助开发者更好地理解ArkUI提供的组件及组件属性并合理使用。该工程中展示的代码详细描述可查如下链接：

1. [视频播放](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/arkts-common-components-video-player.md)。


### 效果预览
| 视频播放效果图                                 |
| ------------------------------------ | 
| ![](screenshots/device/image1.png) |

### 使用说明

1. 在主界面，可以点击对应页面，选择需要参考的组件示例。

2. 在组件目录选择详细的示例参考。

3. 进入示例界面，查看参考示例。

4. 通过自动测试框架可进行测试及维护。

### 工程目录
```
entry/src/main/ets/
├── avplayertool
│   └── AVPlayerController.ets   // 实现AVPlayer控制器
├── common
│   └── constants
│       └── CommonConstants.ets  // 公共常量
├── entryability
│   └── EntryAbility.ets
├── entrybackupability
│   └── EntryBackupAbility.ets
├── model
│   └── VideoData.ets            // 视频播放数据
└── pages
    ├── AttributeVideo.ets       // 添加属性
    ├── CustomizedControl.ets    // 自定义控制器
    ├── DataAbility.ets          // 加载本地视频
    ├── EventCall.ets            // 事件调用
    ├── Index.ets
    ├── LocalVideo.ets           // 加载本地视频
    ├── OnlineVideo.ets          // 加载网络视频
    ├── Sandbox.ets              // 加载沙箱路径视频
    ├── VideoControl.ets         // Video控制器使用
    └── XComponentAVPlayer.ets   // AVPlayer替代Video
entry/src/ohosTest/
├── ets
│   └── test
│       ├── Ability.test.ets
│       ├── Index.test.ets        // 测试用例代码
│       └── List.test.ets
└── module.json5
```

### 具体实现

1. Video组件支持加载本地视频和网络视频。使用资源访问符$rawfile()引用视频资源。支持file://路径前缀的字符串，用于读取应用沙箱路径内的资源，需要确保应用沙箱目录路径下的文件存在并且有可读权限。

2. Video组件回调事件主要包括播放开始、播放暂停、播放结束、播放失败、播放停止、视频准备和操作进度条等事件，除此之外，Video组件也支持通用事件的调用，如点击、触摸等事件的调用。

3. Video控制器主要用于控制视频的状态，包括播放、暂停、停止以及设置进度等

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：RK3568。

2.本示例为Stage模型，支持API20版本SDK，版本号：6.0.0.33，镜像版本号：OpenHarmony_6.0.0.33。

3.本示例需要使用DevEco Studio 6.0.0 Release (Build Version: 6.0.0.858， built on September 24, 2025)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/VideoPlayer > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
````