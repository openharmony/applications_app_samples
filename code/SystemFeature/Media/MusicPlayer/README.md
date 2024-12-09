# 折叠屏音乐播放器案例

### 介绍

本示例介绍使用ArkUI中的容器组件FolderStack在折叠屏设备中实现音乐播放器场景，展示当前播放歌曲信息，支持播控中心控制播放和后台播放能力。

### 效果图预览

<img src="musicplayer/music_player.gif" width="400">

**使用说明**

1. 播放器预加载了歌曲列表，即开即用；
2. 支持播放模式切换、播放、暂停、重新播放、上一首、下一首操作；
3. 支持歌词展示、随歌曲滚动；
4. 支持歌曲进度拖拽；
5. 在折叠屏上，支持横屏半展开态下的组件自适应动态布局；
6. 支持退到后台播放音乐，由播控中心控制操作和拉起应用；

### 实现思路

1. 采用MVVM模式进行架构设计，目录结构中区分展示层、模型层、控制层，展示层通过控制层与模型层沟通，展示层的状态数据与控制层进行双向绑定，模型层的变更通过回调形式通知给控制层，并最终作用于展示层。

2. 在可折叠设备上使用FolderStack组件作为容器组件，承载播放器的所有功能组件，在半折叠态上，使需要移动到上屏的子组件产生相应的动态效果。
```typescript
// TODO：知识点：FolderStack继承于Stack控件，通过upperItems字段识别指定id的组件，自动避让折叠屏折痕区后移到上半屏
FolderStack({ upperItems: [CommonConstants.FOLDER_STACK_UP_COMP_ID] }) {
    MusicPlayerInfoComp({ musicModel: this.musicModel, curFoldStatus: this.curFoldStatus })
        .id(CommonConstants.FOLDER_STACK_UP_COMP_ID)
    MusicPlayerCtrlComp({ musicModel: this.musicModel })
}
```

源码请参考[MusicPlayerPage.ets](./musicplayer/src/main/ets/pages/MusicPlayerPage.ets)

3. 在需要移动到上屏的子组件上添加属性动效，当组件属性发生变更时，达成动态展示效果。
```typescript
Image(this.musicModel.coverRes)
  .width(this.curImgSize)
  .height(this.curImgSize)
  .margin(20)
  .animation(this.attrAniCfg)
  .interpolation(ImageInterpolation.High)
  .draggable(false)
```

源码请参考[MusicPlayerInfoComp.ets](./musicplayer/src/main/ets/components/MusicPlayerInfoComp.ets)

4. 折叠屏设备上，依赖display的屏幕状态事件，监听屏幕折叠状态变更，通过对折叠状态的分析，更新UI属性。
```typescript
display.on('foldStatusChange', (curFoldStatus: display.FoldStatus) => {
    this.curFoldStatus = curFoldStatus;
    this.windowModel.updateMainWinPreferredOrientation(curFoldStatus);
})
```

源码请参考[MusicPlayerPage.ets](./musicplayer/src/main/ets/pages/MusicPlayerPage.ets)

5. 创建AVSession实例，注册AVSession实例事件，激活AVSession实例，接入系统播控中心
```typescript
// TODO：知识点：创建AVSession实例
this.session = await AVSessionManager.createAVSession(this.bindContext!, this.avSessionTag, this.avSessionType);
// TODO：知识点：注册AVSession事件
await this.registerSessionListener(eventListener);
// TODO：知识点：激活AVSession实例
await this.session.activate();
```

源码请参考[AVSessionModel.ets](./musicplayer/src/main/ets/model/AVSessionModel.ets)

6. 设置AVSession实例元信息和播放状态
```typescript
// 设置必要的媒体信息
let metadata: AVSessionManager.AVMetadata = {
  assetId: '0', // 由应用指定，用于标识应用媒体库里的媒体
  title: musicModel?.title,
  mediaImage: imagePixel,
  artist: musicModel?.singer,
  duration: musicModel?.totalTime,
  lyric: lrcStr
}
// TODO：知识点：设置AVSession元信息
this.session?.setAVMetadata(metadata).then(() => {
  logger.info(`SetAVMetadata successfully`);
}).catch((err: BusinessError) => {
  logger.error(`Failed to set AVMetadata. Code: ${err.code}, message: ${err.message}`);
});


// TODO：知识点：设置AVSession当前状态
this.session?.setAVPlaybackState(this.curState, (err) => {
  if (err) {
    console.error(`Failed to set AVPlaybackState. Code: ${err.code}, message: ${err.message}`);
  } else {
    console.info(`SetAVPlaybackState successfully`);
  }
});
```

源码请参考[AVSessionModel.ets](./musicplayer/src/main/ets/model/AVSessionModel.ets)

7. 创建WantAgent实例，确认后台任务类型，启动后台任务
```typescript
let wantAgentInfo: wantAgent.WantAgentInfo = {
  // 点击通知后，将要执行的动作列表
  // 添加需要被拉起应用的bundleName和abilityName
  wants: [
    {
      bundleName: "com.north.cases",
      abilityName: "com.north.cases.EntryAbility"
    }
  ],
  // 指定点击通知栏消息后的动作是拉起ability
  actionType: wantAgent.OperationType.START_ABILITY,
  // 使用者自定义的一个私有值
  requestCode: 0,
  // 点击通知后，动作执行属性
  actionFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
};
// 通过wantAgent模块下getWantAgent方法获取WantAgent对象
wantAgent.getWantAgent(wantAgentInfo).then((wantAgentObj: WantAgent) => {
  // TODO：知识点：设置后台任务类型，启动后台任务
  backgroundTaskManager.startBackgroundRunning(this.bindContext!,
    backgroundTaskManager.BackgroundMode.AUDIO_PLAYBACK, wantAgentObj).then(() => {
    // 此处执行具体的长时任务逻辑，如放音等。
    console.info(`Succeeded in operationing startBackgroundRunning.`);
    this.isBackgroundTaskRunning = true;
  }).catch((err: BusinessError) => {
    console.error(`Failed to operation startBackgroundRunning. Code is ${err.code}, message is ${err.message}`);
  });
});
```

源码请参考[AVSessionModel.ets](./musicplayer/src/main/ets/model/AVSessionModel.ets)

8. 播控中心状态回传给AVPlayer，采用监听AVSession实例的事件进行
```typescript
// 播放
this.session?.on('play', () => {
  logger.info('avsession on play');
  eventListener.onPlay();
});
// 暂停
this.session?.on('pause', () => {
  logger.info('avsession on pause');
  eventListener.onPause();
});
// 停止
this.session?.on('stop', () => {
  logger.info('avsession on stop');
  eventListener.onStop();
});
// 下一首
this.session?.on('playNext', async () => {
  logger.info('avsession on playNext');
  eventListener.onPlayNext();
});
// 上一首
this.session?.on('playPrevious', async () => {
  logger.info('avsession on playPrevious');
  eventListener.onPlayPrevious();
});
// 拖进度
this.session?.on('seek', (position) => {
  logger.info('avsession on seek', position.toString());
  eventListener.onSeek(position);
});
// 标记喜好
this.session?.on('toggleFavorite', (assetId) => {
  logger.info('avsession on toggleFavorite', assetId);
});
// 播放循环模式切换
this.session?.on('setLoopMode', (mode) => {
  logger.info('avsession on setLoopMode', mode.toString());
  eventListener.onSetLoopMode();
});
```

源码请参考[AVSessionModel.ets](./musicplayer/src/main/ets/model/AVSessionModel.ets)

9. 歌词滚动使用scrollToIndex接口实现，通过监听播放进度进行歌词滚动
```typescript
onViewModelChanged() {
  const curMusiclyricsLine = this.viewModel.curMusiclyricsLine;
  this.lyricsScrollerCtrl.scrollToIndex(curMusiclyricsLine, true, ScrollAlign.CENTER);
}
```

源码请参考[MusicPlayerInfoComp.ets](./musicplayer/src/main/ets/components/MusicPlayerInfoComp.ets)

10. 歌曲切换根据播放模式进行相应业务逻辑，单曲循环采用seek到歌曲开始处，列表循环索引加1，随机播放索引加随机数
```typescript
switch (this.curLoopMode) {
  case AVSessionManager.LoopMode.LOOP_MODE_SINGLE: {
    this.seek(0);
    break;
  }

  case AVSessionManager.LoopMode.LOOP_MODE_LIST: {
    this.curMusicModelIndex = (this.curMusicModelIndex + 1) % this.musicModelArr.length;
    this.curMusicModelRaw = this.musicModelArr[this.curMusicModelIndex];
    await this.reset();
    await this.prepare(() => {
      this.play();
    });
    this.avsessionModel?.setSessionInfo(this.curMusicModelRaw);
    break;
  }

  case AVSessionManager.LoopMode.LOOP_MODE_SHUFFLE: {
    const randomVal: number = Decimal.random(1).e;
    let dieta: number = 1;
    while (dieta < this.musicModelArr.length - 1) {
      if (randomVal >= dieta - 1 / this.musicModelArr.length - 1 && randomVal < dieta / this.musicModelArr.length - 1) {
        break;
      }
      dieta++;
    }
    this.curMusicModelIndex = (this.curMusicModelIndex + dieta) % this.musicModelArr.length;
    this.curMusicModelRaw = this.musicModelArr[this.curMusicModelIndex];
    await this.reset();
    await this.prepare(() => {
      this.play();
    });
    this.avsessionModel?.setSessionInfo(this.curMusicModelRaw);
    break;
  }
}
```

源码请参考[MusicPlayViewModel.ets](./musicplayer/src/main/ets/viewmodel/MusicPlayViewModel.ets)

### 高性能知识点

暂无

### 工程结构&模块类型

   ```
   foldablescreencases                  // har类型
   |---common
   |   |---constants
   |   |    |---CommonConstants.ets     // 通用常量
   |---components
   |   |---MusicPlayerCtrlComp.ets      // 自定义组件-音乐播放器控制栏
   |   |---MusicPlayerInfoComp.ets      // 自定义组件-音乐播放器歌曲详情展示
   |---model
   |   |---AVPlayerModel.ets            // 模型层-音频播放管理器 
   |   |---AVSessionModel.ets           // 模型层-音频会话管理器
   |   |---MusicModel.ets               // 模型层-音乐歌曲数据模型
   |   |---WindowModel.ets              // 模型层-窗口管理器 
   |---pages
   |   |---MusicPlayerPage.ets          // 展示层-音乐播放器 
   |---viewmodel
   |   |---MusicPlayerViewModel.ets     // 控制层-音乐播放器控制器
   ```

### 模块依赖

依赖本地的utils模块

### 参考资料

- [FolderStack](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/reference/apis-arkui/arkui-ts/ts-container-folderstack.md)
- [属性动画](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/reference/apis-arkui/arkui-ts/ts-animatorproperty.md)
- [AVPlayer](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/media/media/using-avplayer-for-playback.md)
- [状态管理概述](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/quick-start/arkts-state-management-overview.md)
- [AVSession](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/media/avsession/avsession-access-scene.md)

### 相关权限

[ohos.permission.KEEP_BACKGROUND_RUNNING](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/security/AccessToken/permissions-for-all.md#ohospermissionkeepbackgroundrunning)

### 约束与限制

1.本示例仅支持在标准系统上运行，支持设备：折叠屏。

2.本示例为Stage模型，支持API12版本SDK，SDK版本号（API Version 12 Release）。

3.本示例需要使用DevEco Studio 5.0.0 Release 才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：
```javascript
git init
git config core.sparsecheckout true
echo /code/SystemFeature/Media/MusicPlayer/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```