# 实现音频焦点功能

## 介绍

本示例基于[SystemSoundPlayer](https://gitcode.com/openharmony/interface_sdk-js/blob/master/api/multimedia/SystemSoundPlayer.d.ts)提供的能力，实现了系统音效播放功能，适用于拍照或录像提示音，比如在开始拍照、开始录像或结束录像时播放提示音。

## 效果预览

| 预览                                      | 
| -------------------------------------------- | 
<img src="./screenshots/soundPlayer.jpg" width="300" />


## 使用说明
1. 安装编译生成的hap包，并打开应用；
2. 点击下拉选择框选择对应的音效；
3. 点击'播放音效'按钮，播放选择的音效。

## 工程结构&模块类型

```
├───entry/src/main/ets
│   ├───entryability                        
│   │   ├───EntryAbility.ets                // Ability的生命周期回调内容。
│   ├───entrybackupability                  
│   │   └───EntryBackupAbility.ets          // BackupAbility的生命周期回调内容。
│   ├───pages                               
│       └───SoundPlayer.ets                       // 播放界面。
└───entry/src/main/resources                // 资源目录。
```
## 具体实现

- 源码参考：[SoundPlayer.ets](entry/src/main/ets/pages/SoundPlayer.ets)
- 实现流程：
    - 在aboutToAppear函数中，调用createSystemSoundPlayer接口创建SystemSoundPlayer对象，并调用load接口加载拍照音资源。
    - 使用下拉选择框选择对应的音效资源后，会调用load接口加载选择的音效资源。
    - 点击播放音效按钮，会调用play接口播放选择的音效（如果未选择对应的音效，默认播放拍照音效）。
    - 在aboutToDisappear函数中，调用unload接口卸载之前已加载的系统音效资源，并调用release接口释放SystemSoundPlayer对象。

## 相关权限

不涉及。

## 模块依赖

不涉及。

## 约束与限制

1.  本示例支持在标准系统上运行，支持设备：RK3568。

2.  本示例仅支持API23版本SDK，版本号： 6.1.0.23。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/Media/Audio/SystemSoundPlayer > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```