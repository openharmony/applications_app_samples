# AVRecorder Sample

## 介绍
AVRecorder Sample 调用了媒体 AVRecorder 组件提供的接口能力，提供音视频录制的功能，包含：
- 音视频录制
- 音频录制/视频录制
- 保存录制文件到应用沙箱/图库

使用说明

1. 启动应用，首次启动需要用户授予访问相机、麦克风、保存文件的权限。
2. 进入Demo界面，点击 Start 按钮，开始录制。
3. 录制过程中，可随时点击Pause、Resume进行暂停、恢复。
4. 录制完成后，点击Stop结束录制。
5. 录制生成的文件保存在沙箱目录或图库。

## 工程目录

仓目录结构如下：

```
entry/src/main          # AVRecorder demo业务代码
│  module.json5             # 编译相关文件
├─cpp                       # ndk相关文件
│  │  CMakeLists.txt
│  │  main.cpp
│  │  main.h
│  │  camera_manager.cpp
│  │  camera_manager.h
│  │  log_common.h
│  │  sample_info.h
│  │  muxer.cpp
│  │  muxer.h
│  │  video_encoder_sample.cpp
│  │  video_encoder_sample.h
│  └─types                      # 映射文件
│
├─ets                       # 页面相关实现
│  ├─entryability
│  ├─entrybackupability
│  └─pages                      # ets 页面实现
│          Index.ets                # 首页 
│
└─resources                 # 资源文件
```

## 相关权限

ohos.permission.MICROPHONE
ohos.permission.INTERNET
ohos.permission.CAMERA
ohos.permission.MEDIA_LOCATION
ohos.permission.KEEP_BACKGROUND_RUNNING
ohos.permission.READ_MEDIA
ohos.permission.WRITE_MEDIA

## 依赖

不涉及

## 约束和限制

1. 本示例支持标准系统上运行，支持设备：RK3568;

2. 本示例支持API19版本SDK，版本号：5.1.1.62;

3. 本示例已支持使DevEco Studio 5.0.5 Beta1（构建版本：5.0.13.100，构建于：2025年4月25日）编译运行

## 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/Media/AVRecorder/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```