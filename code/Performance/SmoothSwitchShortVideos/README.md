# 实现流畅切换短视频

### 简介

本示例基于在线短视频场景，通过LazyForEach进行数据懒加载，同时搭配组件复用能力以达到高性能效果，帮助开发者解决在应用中在线短视频快速切换时容易出现起播时间延长的问题，提供对应场景的解决方案。

### 效果预览：

<img src="screenshots/Main.png" width="300">

### 使用说明：

1. 本示例需要访问网络视频直链来获取视频资源，您可以修改entry/src/main/ets/common/CommonConstants.ets中的VIDEO_SOURCE为想要播放的视频直链，本示例也提供了本地视频和本地搭建服务器的方案，来模拟访问网络视频的情况，请参考《搭建服务器》章节。

2. 安装应用后打开，应用会播放资源链接的视频，可上下滑动切换短视频。

### 搭建服务器

1. 本示例提供了Python脚本快速搭建服务器，需要本地有Python环境，另外，您需要安装Flask框架，可以通过Python的包管理器pip来安装Flask，在终端输入以下命令：

    ```
    pip install flask
    ```

2. 修改video_server.py中的VIDEO_PATH，将其替换为想要播放的视频的实际路径。

3. 修改entry/src/main/ets/common/CommonConstants.ets中的VIDEO_SOURCE中的链接，按照提示替换为PC的IP地址。

4. 保证播放设备和搭建服务器的PC在同一局域网内(调试设备使用网线插入跟PC相同的路由器或者网络交换器的端口上即可)，在server文件夹内使用终端运行脚本：

    ```
    python video_server.py
    ```

5. 脚本将启动一个Flask服务器，默认监听5000端口。

### 工程目录

```
├──entry/src/main/ets
│  ├──common
│  │  ├──utils         
│  │  │  └──CommonUtils.ets             // 公共方法类
│  │  └──CommonConstants.ets            // 公共常量类
│  ├──entryability
│  │  └──EntryAbility.ets               // 程序入口类
│  ├──entrybackupability
│  │  └──EntryBackupAbility.ets        
│  ├──model
│  │  ├──AVDataSource.ets               // 视频数据类
│  │  └──AVPlayereState.ets             // 视频状态类
│  ├──pages                  
│  │  └──Index.ets                      // 首页
│  └──view
│     └──VideoPlayView.ets              // 视频播放组件
└──entry/src/main/resources             // 应用静态资源目录
```

### 具体实现

1.[初始化AVPlayer播放器](entry/src/main/ets/view/VideoPlayView.ets)
   ```typescript
   async initAVPlayer() {
     Logger.info(TAG, 'createAVPlayer begin');
     media.createAVPlayer().then((video: media.AVPlayer) => {
       if (video !== null) {
         this.avPlayer = video;
         this.setAVPlayerCallback(this.avPlayer);
         // 设置播放源，使其进入initialized状态
         if (typeof this.curSource === 'string') {
           this.avPlayer.url = this.curSource;
         } else {
           this.avPlayer.fdSrc = this.curSource;
         }
         Loggor.info(TAG, 'createAVPlayer success');
       } else {
         Loggor.error(TAG, 'createAVPlayer fail');
       }
     }).catch((error: BusinessError) => {
       Logger.error(TAG, `AVPlayer catchCallback,error message:${error.message}`);
     })
   }
   ```

2.[设置业务需要的监听事件](entry/src/main/ets/view/VideoPlayView.ets)
   ```typescript
   setAVPlayerCallback(avPlayer: media.avPlayer) {
     // 用于进度条，监听进度条当前位置，刷新当前时间
     avPlayer.on('timeUpdate', (time: number) => {
       if (!this.isSliderMoving) {
         this.currentTime = Math.floor(time * this.durationTime / this.duration);
         this.currentStringTime = secondToTime(Math.floor((time / CommConstants.SECOND_TO_MS)));
       }
     })
     // 适配一多，根据屏幕尺寸的变化同步更新视频的长宽
     avPlayer.on('videoSizeChange', (width: number, height: number) => {
       this.viewHeight = height;
       this.viewWidth = width;
       this.autoVideoSize();
     })
     // 必要事件，监听播放器的错误信息
     avPlayer.on('error', (error: BusinessError) => {
       Logger.error(TAG,
         `Invoke avPlayer failed, code is ${error.code},message is ${error.message}` + `---state:${avPlayer.state}`);
       avPlayer.reset();
     })
     this.setAVPlayerStateListen(avPlayer);
   }
   ```
3.[设置状态机变化回调函数](entry/src/main/ets/view/VideoPlayView.ets)
 ```typescript
   setAVPlayerStateListen(avPlayer: media.AVPlayer) {
     avPlayer.on('stateChange', async (state: string) => {
       switch (state) {
         case 'idle': // 成功调用reset接口后触发该状态机上报
           Logger.info(TAG, 'AVPlayer state idle called.' + `this.curIndex:${this.curIndex}` + `this.index:${this.index}`);
           break;
         case 'initialized': // avplayer 设置播放源后触发该状态上报
           Logger.info(TAG,
             'AVPlayer state initialized called.' + `this.curIndex:${this.curIndex}` + `this.index:${this.index}`);
           avPlayer.surfaceId = this.surfaceID;
           avPlayer.prepare();
           break;
         case 'prepared': // prepare调用成功后上报该状态机
           Logger.info(TAG,
             'AVPlayer state prepared called.' + `this.curIndex:${this.curIndex}` + `this.index:${this.index}`);
           avPlayer.audioInterruptMode = audio.InterruptMode.INDEPENDENT_MODE; // 避免同时出现两个视频的声音
           this.flag = true;
           avPlayer.loop = true;
           this.duration = avPlayer.duration;
           this.durationTime = Math.floor(this.duration / CommConstants.SECOND_TO_MS);
           this.currentStringTime = secondToTime(this.durationTime);
           if (this.firstFlag && this.index === 0 && this.isPageShow) {
             avPlayer.play(); // 应用启动后的第一个视频启动播放
             this.firstFlag = false;
           }
           break;
         case 'completed': // 播放结束后触发该状态机上报
           Logger.info(TAG,
             'AVPlayer state completed called.' + `this.curIndex:${this.curIndex}` + `this.index:${this.index}`);
           this.isPlaying = false;
           break;
         case 'playing': // play成功调用后触发该状态机上报
           Logger.info(TAG,
             'AVPlayer state playing called.' + `this.curIndex:${this.curIndex}` + `this.index:${this.index}` +
               `source:${this.curSource}`);
           this.isPlaying = true;
           break;
         case 'paused': // pause成功调用后触发该状态机上报
           Logger.info(TAG,
             'AVPlayer state paused called.' + `this.curIndex:${this.curIndex}` + `this.index:${this.index}`);
           break;
         case 'stopped': // stop接口成功调用后触发该状态机上报
           Logger.info(TAG,
             'AVPlayer state stopped called.' + `this.curIndex:${this.curIndex}` + `this.index:${this.index}`);
           break;
         case 'released':
           Logger.info(TAG,
             'AVPlayer state released called.' + `this.curIndex:${this.curIndex}` + `this.index:${this.index}`);
           break;
         case 'error':
           Logger.info(TAG,
             'AVPlayer state released called.' + `this.curIndex:${this.curIndex}` + `this.index:${this.index}`);
           avPlayer.reset();
           break;
         default:
           Logger.info(TAG, 'AVPlayer state unknown called.' + state);
           break;
       }
     })
   }
   ```

4.[视频轮播：使用Swiper组件进行视频轮播，设置cachedCount（3）缓存视频数量](entry/src/main/ets/pages/Index.ets)
   ```typescript
   build() {
     Swiper(this.swiperController) {
       LazyForEach(new MyDataSource(this.sources), (item: string, index: number) => {
         VideoPlayer({
           curSource: item,
           curIndex: this.curIndex,
           index: index,
           firstFlag: this.firstFlag,
           isPageShow: this.isPageShow,
           foldStatus: this.foldStatus
         })
       }, (item: string, index: number) => JSON.stringify(item) + index)
     }
     .cachedCount(3) // 缓存视频数量
     .width(CommComstants.WIDTH_FULL_PERCENT)
     .height(CommComstants.HEIGHT_FULL_PERCENT)
     .vertical(true)
     .loop(true)
     .curve(Curve.Ease)
     .duration(CommComstants.DURATION_TIME)
     .indicator(false)
     .backgroundColor(Color.Black)
     .onGestureSwipe((index: number, extraInfo: SwiperAnimationEvent) => {
       Logger.info(TAG, `onGestureSwipe index:${index}}`);
     })
     .onAnimationStart((index: number, targetIndex: number, extraInfo: SwiperAnimationEvent) => {
       this.curIndex = targetIndex; // 优化点：视频播放和动画启动同步进行，覆盖动画效果
     })
     .onAnimationEnd((index: number, extraInfo: SwiperAnimationEvent) => {
       Logger.info(TAG, `onAnimationEnd index:${index}}`);
     })
   }
   ```
5.[窗口设置：设置XComponent组件用于视频流渲染，获取并设置SurfaceID，用户设置显示画面，在onLoad时异步创建并初始化AVPlayer播放器](entry/src/main/ets/view/VideoPlayView.ets)
   ```typescript
   XComponent({
     id: 'XComponent',
     type: XComponentType.SURFACE,
     controller: this.xComponentController
     })
       .width(this.XComponentWidth)
       .height(this.XComponentHeight)
       .onLoad(async () => {
         this.surfaceID = this.xComponentController.getXComponentSurfaceId();
         this.initAVPlayer(); // 优化点：创建AVPlayer的播放器放入到缓存池中，不可共用播放器。
       })
   ```

6.[视频播放设置：监听Swiper轮播的this.curIndex值，在视频缓存流中跟this.index进行比较，从而判断视频流中哪个播放，其余的均暂停](entry/src/main/ets/view/VideoPlayView.ets)
   ```typescript
   onIndexChange() {
     if (this.curIndex !== this.index) {
       pauseVideo(this.avPlayer, this.curIndex, this.index);
       this.isPlaying = false;
       this.trackThicknessSize = CommConstants.TRACK_SIZE_MIN;
     } else {
       if (this.flag === true) {
         playVideo(this.avPlayer, this.curIndex, this.index);
         this.isPlaying = true;
         this.trackThicknessSize = CommConstants.TRACK_SIZE_MIN;
       } else {
         let countNum = 0;
         let interValFlag = setInterval(() => {
           countNum++;
           // 此处有必要再次判断索引，否则会出现索引错乱导致播放异常
           if (this.curIndex !== this.index) {
             clearInterval(interValFlag);
           }
           if (this.flag === true && this.isPageShow) {
             countNum = 0;
             playVideo(this.avPlayer, this.curIndex, this.index);
             this.isPlaying = true;
             this.trackThicknessSize = CommConstants.TRACK_SIZE_MIN;
             clearInterval(interValFlag);
           } else {
             if (countNum > 15) {
               countNum = 0;
               this.initAVPlayer();
             }
           }
         }, 100);
       }
     }
   }
   ```

7.[设置AVPlayer监听关闭并释放资源](entry/src/main/ets/common/utils/CommonUtils.ets)
   ```typescript
   export function releaseVideo(avPlayer: media.AVPlayer | undefined, curIndex: number, index: number) {
     if (avPlayer) {
       Logger.info(TAG, 'releaseVideo:' + `state:${avPlayer.state}` + `curIndex:${curIndex},index:${index}`);
       avPlayer.off('timeUpdate');
       avPlayer.off('seekDone');
       avPlayer.off('speedDone');
       avPlayer.off('error');
       avPlayer.off('stateChange');
       avPlayer.release();
     }
   }
   aboutToDisappear(): void {
     releaseVideo(this.avPlayer, this.curIndex, this.index);
   }
   ```

### 相关权限

- 网络权限：ohos.permission.INTERNET

### 依赖

- 不涉及

### 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：RK3568。

2. 本示例已适配API20版本SDK，SDK版本号(API Version 20 Release),镜像版本号(6.1.0.23)。

3. 本示例需要使用DevEco Studio 6.0.1 Beta1 (Build Version: 6.0.1.246, built on October 31, 2025)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/Performance/SmoothSwitchShortVideos/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master