# 音频管理（仅对系统应用开放）

### 介绍

此Sample展示如何在eTS中调用空间音频相关API。实现效果如下：

### 效果预览
| 主页                                     | 空间音频界面                                  |
|----------------------------------------|-----------------------------------------|
| ![index](screenshot/devices/index.png) | ![main](screenshot/devices/spatial.png) |

使用说明

1. 启动应用，在主页卡片中选择空间音频卡片，进入空间音频演示

2. 在上部的两个音乐播放器分别可以播放2.0和5.1的音源，体现了音频框架对多声道播放的支持

3. 下方的空间音频UX，具体的界面会随音频播放的设备而变化：外放及普通耳机只会启用关闭模式；支持空间音频和头动追踪的耳机会使三个按钮全部可选。

4. 点击三个按钮，分别会启用”关闭空间音频“，”启用空间音频固定模式“，”启用空间音频头动追踪模式“

### 工程目录

```
entry/src/main/ets/
|---pages
|---|---Index.ets                           //首页
|---|---SpatialAudio.ets                    //空间音频页面
```

### 相关权限

蓝牙使用权限：ohos.permission.USE_BLUETOOTH

### 具体实现

1.使用@ohos.multimedia.audio接口实现空间音频的主要功能：查询空间音频状态/系统支持能力，设置空间音频状态等。

### 约束与限制

1.当前版本对是否支持空间音频的判断仍简单，即当前发声设备具备不为空的mac地址就会显示三态按钮UX。

2.本示例仅支持标准系统上运行。

3.本示例为Stage模型，仅支持API11版本SDK。

4.本示例需要使用DevEco Studio 版本号(4.0Release)及以上版本才可编译运行。

5.本示例需要使用系统权限的系统接口。使用Full SDK时需要手动从镜像站点获取，并在DevEco Studio中替换，具体操作可参考[替换指南](https://docs.openharmony.cn/pages/v3.2/zh-cn/application-dev/quick-start/full-sdk-switch-guide.md/)。

6.本示例想要调用空间音频API需要被赋权，因为非系统APP调用接口无法生效。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/SystemFeature/Media/Audio/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```