# AVPlayerArkTSPlayWithCache

## 介绍

本示例为媒体->Media Kit(媒体服务)->[使用AVPlayer设置边播边缓存(ArkTS)](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/media/media/playback-url-setting-method.md)的配套示例工程。 

本示例展示了如何使用AVPlayer开发播放功能，在流媒体的场景下如何设置边播边缓存。

## 效果预览

| 播放效果                                      | 
| -------------------------------------------- | 
<img src="./screenshots/AVPlayerArkTSPlayWithCache.png" width="300" />


## 工程目录

```
AVPlayerArkTSPlayWithCache
entry/src/main/ets/
└── pages
    └── Index.ets (播放界面)
entry/src/main/resources/
├── base
│   ├── element
│   │   ├── color.json
│   │   ├── float.json
│   │   └── string.json
│   └── media
│       ├── ic_video_play.svg  (播放键图片资源)
│       └── ic_video_pause.svg (暂停键图片资源)
└── rawfile
    ├── test.m3u8    (m3u8资源)
    └── test_01.mp3 （音频资源）
entry/src/ohosTest/ets/
└── test
    ├── Ability.test.ets (UI测试代码)
    └── List.test.ets (测试套件列表)
```
## 具体实现

1. 通过 `media.createMediaSourceWithUrl(url, headers)` 创建 MediaSource 对象
2. 调用 `mediaSource.enableOfflineCache(true)` 开启离线缓存功能
3. 使用 `avPlayer.setMediaSource(mediaSource, strategy)` 设置媒体源，播放器将自动边播边缓存
## 相关权限

ohos.permission.INTERNET：允许使用Internet网络。

ohos.permission.GET_WIFI_INFO：允许应用获取Wi-Fi信息和使用P2P能力。

## 依赖

不涉及

## 约束和限制

1. 本示例支持标准系统上运行，支持设备：RK3568;

2. 本示例支持API23版本SDK，版本号：6.1.0.830;
   
3. 本示例已支持使DevEco Studio 6.1.0 Release (构建版本：6.1.0.830，构建 2026年4月20日)编译运行

## 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/Media/AVPlayer/AVPlayerArkTSPlayWithCache/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```