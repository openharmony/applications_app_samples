# AVPlayerArkTSURL

## 介绍

本示例为媒体->Media Kit(媒体服务)->[使用AVPlayer设置播放URL(ArkTS)](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/media/media/playback-url-setting-method.md)的配套示例工程。 

本示例展示了如何使用AVPlayer开发播放功能，在不同的场景下（流媒体/本地文件）如何设置URL。

## 效果预览

| 播放效果                                      | 
| -------------------------------------------- | 
<img src="./screenshots/AVPlayerArkTSURL.jpeg" width="300" />


## 工程目录

```
AVPlayerArkTSURL
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

## 相关权限

ohos.permission.INTERNET
ohos.permission.GET_WIFI_INFO

## 依赖

不涉及

## 约束和限制

1. 本示例支持标准系统上运行，支持设备：RK3568;

2. 本示例支持API15版本SDK，版本号：5.0.3.135;
   
3. 本示例已支持使DevEco Studio 5.0.3 Release (构建版本：5.0.8.300，构建 2025年3月19日)编译运行

## 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/Media/AVPlayer/AVPlayerArkTSURL/ > .git/info/sparse-checkout
git remote add origin OpenHarmony/applications_app_samples
git pull origin master
```