# 视频播放

### 介绍

本示例主要展示了网络视频播放的相关功能。使用[@ohos.multimedia.avsession](https://docs.openharmony.cn/pages/v4.0/zh-cn/application-dev/reference/apis/js-apis-avsession.md)等接口实现视频播放的功能。

### 效果预览

| 主页 | 
|-------------------------------- |
| ![Index](screenshots/device/index.jpeg) |

#### 使用说明

1. 点击播放按钮，应用的播放状态发生变化。
2. 点击暂停按钮，应用的播放状态开始变化。
3. 点击上一个按钮，界面展示播放列表中的上一个视频的信息。
4. 点击下一下按钮，界面展示播放列表中的下一个视频的信息。

### 工程目录

给出项目中关键的目录结构并描述它们的作用，示例如下：

```
entry/src/main/ets/
|---common                             // 方法封装
|---|---AudioFrameworkTest.ets
|---|---AudioUtils.ets                 // 控制器封装
|---|---CommonUtils.ets                // 格式化时间封装
|---|---Constants.ets                  // 媒体资源信息
|---|---Log.ets                        // 日志封装
|---|---PermissionUtils.ets            // 权限封装
|---entryability              
|---|---EntryAbility.ets               
|---pages
|---|---Index.ets                      // 界面实现
|---|---components
|---|---|---SongItem.ets               // 视频列表组件
```

### 具体实现

* 界面相关的实现都封装在pages/Index.ets下，源码参考：[pages/Index.ets](./entry/src/main/ets/pages/Index.ets)
    * 使用`@State`来设置与逻辑代码同步更新的变量，当逻辑代码中对应的变量更新时，界面会同步的刷新。

    * 通过引入逻辑代码对应的类，创建出对象，实现对onClick事件的响应，关键代码段：
      ```js
      
      import media from '@ohos.multimedia.media';     // 引入
      
      this.avPlayer = await media.createAVPlayer();  // 创建对象
      
      this.controller = await this.session.getController();  // 通过类的对象来调用逻辑代码

      ```

* 逻辑相关的实现都封装在common/MediaController.ets下，源码参考：[common/AudioUtils.ets](./entry/src/main/ets/common/AudioUtils.ets)

  应用的初始化相关操作

    * 链接变量

      使用`@State`来设置与逻辑代码同步更新，关键代码段：

      ```ets
      @State session: avSession.AVSession = null;
      @State controller: avSession.AVSessionController = null;
      private avPlayer: media.AVPlayer;
      @State @Watch('playInfoUpdated') currentPlayInfo: avSession.AVMediaDescription = undefined;
      this.currentPlayInfo = temp;
      this.avPlayer = await this.audioUtils.init();
      ```

    * 获取当前设备中会话并创建Controller

      通过接口`audioUtils.init()`获取当前设备中的媒体会话；

      通过接口`session.getController()`创建媒体会话对应的控制器；

      通过接口`on(play | pause | stop | playNext | playPrevious | seek)`开启对远程以及播控中心提供方发送事件的监听，对事件进行处理；

  应用在运行中相关的操作

    * 从远程以及播控中心获取基础控制命令

      基础控制命令可以通过监听事件`setListenerForMesFromController()`。本示例中，从媒体控制方到媒体提供方的基础控制命令主要包括`play, pause, playPrevious, playNext`。发送命令的参考代码如下：
      ```ets
      let command : AVSessionManager.AVControlCommand = {
        command : 'play',
        parameter : undefined
      } // 构造AVControlCommand参数
      async setListenerForMesFromController(); // 媒体会话控制器与媒体会话一一对应
      ```

    * 获取自定义会话数据（以获取视频为例）

      > 说明：
      > 
      > 本示例中，用户点击“下一个视频”的命令，会在将视频信息更新。

      视频使用接口`switchToNextByLoopMode()`更新视频信息，示例代码如下：
      ```ets
      this.currentIndex = this.currentIndex  === this.songList.length - 1 ? 0 : this.currentIndex + 1;
      this.updateCurrentPlayInfo(this.songList[this.currentIndex], this.audioType);
      ```

### 相关权限

不涉及

### 约束与限制

1. 本示例仅支持标准系统上运行。

2. 本示例为Stage模型，支持API11版本SDK，SDK版本号(API Version 11 beta1),镜像版本号(4.1 beta1)

3. 本示例需要使用DevEco Studio 版本号(4.0 Release)及以上版本才可编译运行。

4. 本示例需全程联网。
