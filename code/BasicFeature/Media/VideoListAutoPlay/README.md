# 滑动视频自动播放

### 介绍

本示例主要介绍视频列表滑动到屏幕中间自动播放场景，利用onScrollIndex获取List显示区域内中间子组件索引值的能力来判断播放，利用懒加载场景会预加载List显示区域外cachedCount的内容的能力来实现视频连续播放。

### 效果图预览

<img src="./casesfeature/videolistautoplay/video_list_autoplay.gif" width="300" >

**使用说明**

1. 等待视频加载完成，首页中间视频会自动播放。
2. 滑动列表，视频达到中间位置会自动播放。
3. 滑动列表返回上一个视频会继续播放。

### 实现思路

本例涉及的关键特性和实现方案如下：

1. 使用List渲染视频列表，LazyForEach实现视频列表懒加载。将每个视频模块存放在ListItem中，LazyForEach懒加载可以通过设置cachedCount来指定缓存数量，使用onScrollIndex获取List显示区域内中间位置子组件的索引值，源码参考[VideoListAutoplay.ets](./casesfeature/videolistautoplay/src/main/ets/view/VideoListAutoplay.ets)。

```typescript
List() {
  LazyForEach(this.newsList, (news: NewsItem, index: number) => {
    ListItem() {
      XComponentVideo({
        centerIndex: this.centerIndex,
        news: news,
        index: index
      })
    }
    .backgroundColor('#fff6f6f6')
      .borderRadius(30)
      .margin({ bottom: 20 })
  }, (item: string) => item)
}
.cachedCount(CACHE_COUNT) // TODO：知识点：LazyForEach懒加载可以通过设置cachedCount来指定缓存数量，在设置cachedCount后，除屏幕内显示的ListItem组件外，还会预先将屏幕可视区外指定数量的列表项数据缓存。
.onScrollIndex((firstIndex: number, lastIndex: number, centerIndex: number) => {
  this.centerIndex = centerIndex; // 获取List显示区域内中间子组件索引值
})
```

2. 视频渲染部分可使用XComponent+AVPlayer实现，也可用Video实现，因XComponent+AVPlayer可对视频进行更多操作，因此本案例使用XComponent+AVPlayer进行开发。

3. 通过监听centerIndex值，实时调整视频播放状态。实时监听centerIndex，使得centerIndex改变可及时调整视频播放状态，源码参考[XComponentVideo.ets](./casesfeature/videolistautoplay/src/main/ets/view/XComponentVideo.ets)。

```typescript
// centerIndex状态变化时调用
onIndexChange() {
  if (this.isLoadingVideo) {
    // centerIndex是List显示区域内中间子组件索引值，index值是List当前索引值。当二者相等时，代表视频滑动到屏幕中间。
    if (this.centerIndex === this.index) {
      this.isPlaying = true;
      this.getPlay();
    } else {
      this.isPlaying = false;
      this.getPause();
    }
  }
}
```

4. XComponent和AVPlayer渲染视频。在资源初始化时，将XComponent和AVPlayer通过surfaceId绑定，并进入准备状态，在准备状态中将对当前视频是否是List显示区域内中间子组件做判断，如果是则进入播放阶段，源码参考[XComponentVideo.ets](./casesfeature/videolistautoplay/src/main/ets/view/XComponentVideo.ets)。

```typescript
...
// 资源初始化，avplayer设置播放源后触发该状态上报
case 'initialized':
  logger.info('state initialized called');
  this.setSurfaceID(); // 设置显示画面，当播放的资源为纯音频时无需设置
  this.avPlayer.prepare(); // 进入准备状态
  break;
// 已准备状态
case 'prepared':
  logger.info('state prepared called');
  this.avPlayer.audioInterruptMode = audio.InterruptMode.INDEPENDENT_MODE; // 避免同时出现两个视频的声音
  this.avPlayer.loop = true; // 设置循环播放
  this.isLoadingVideo = true; // 视频加载完成
  // 在屏幕中间的视频开始播放
  if (this.centerIndex === this.index) {
    this.isPlaying = true;
    this.avPlayer.play();
  }
  break;
// 正在播放状态
case 'playing':
  this.flag = true; // 视频准备完毕
  this.isLoading = false; // 取消加载
  logger.info('state playing called');
  break;
...
```

5. Image进入页面加载。进入应用首先加载图片，使用Stack将Image覆盖在XComponent上，并使用visibility来控制图片的显示，源码参考[XComponentVideo.ets](./casesfeature/videolistautoplay/src/main/ets/view/XComponentVideo.ets)。

```typescript
Stack(){
  XComponent({
    type: XComponentType.SURFACE,
    controller: this.xComponentController
  })
    .borderRadius(30)
    .onLoad(() => {
      this.surfaceID = this.xComponentController.getXComponentSurfaceId();
      this.videoSrc = news.newsVideoSrc;
      this.init();
    })
  Image(news.newsImage)
    .borderRadius(30)
    .visibility(this.startOrEnd || !this.flag || this.imageChange ?
    Visibility.Visible :
    Visibility.None)
    .zIndex(1)
}
```

### 高性能知识点

本示例使用了[LazyForEach](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/reference/apis-arkui/arkui-ts/ts-rendering-control-lazyforeach.md) 进行数据懒加载优化，以降低内存占用和渲染开销。

### 工程结构&模块类型

   ```
videolistautoplay                            
|---model 
|   |---NewsItemModel.ets                    // 视频信息
|   |---NewsListDataSource.ets               // IDataSource处理数据监听的基本实现 
|   |---TabBarModel.ets                      // Tab组件信息   
|---view
|   |---CustomComponent.ets                  // 视图层-应用Tab页面
|   |---VideoListAutoplay.ets                // 视图层-应用主页面
|   |---XComponentVideo.ets                  // 视图层-应用视频渲染页面
   ```

### 参考资料

- [XComponent](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/reference/apis-arkui/arkui-ts/ts-basic-components-xcomponent.md)
- [媒体服务](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/reference/apis-media-kit/js-apis-media.md)
- [显隐控制](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/reference/apis-arkui/arkui-ts/ts-universal-attributes-visibility.md)
- [在线短视频流畅切换](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/performance/performance-quick-switch-short-video.md)

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行。

2.本示例为Stage模型，支持API12版本SDK，SDK版本号（API Version 12 Release）。

3.本示例需要使用DevEco Studio版本号（DevEco Studio 5.0.0 Release）及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```shell
git init
git config core.sparsecheckout true
echo code/UI/VideoListAutoPlay/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```