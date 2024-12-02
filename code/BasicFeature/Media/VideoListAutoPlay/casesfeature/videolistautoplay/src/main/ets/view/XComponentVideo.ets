/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { audio } from '@kit.AudioKit';
import { media } from '@kit.MediaKit';
import { promptAction } from '@kit.ArkUI';
import { NewsItem, NEWS_LIST_DATA } from '../model/NewsItemModel';
import { NewsListDataSource } from '../model/NewsListDataSource';
import hilog from '@ohos.hilog';

const FIRST_INDEX: number = 0; // 第一个index标志位
const MAX_LINES: number = 1; // 文本最大行数
const PERFORMER_OPACITY: number = 0.8; // 演员文字透明度
const DETAILS_OPACITY: number = 0.6; // 视频介绍文字透明度

@Component
export struct XComponentVideo {
  private newsList: NewsListDataSource = new NewsListDataSource();
  private avPlayer: media.AVPlayer = {} as media.AVPlayer; // 视频播放器对象
  private xComponentController: XComponentController = new XComponentController();
  private surfaceID: string = ''; // surfaceID用于播放画面显示，具体的值需要通过XComponent接口获取，相关文档链接见上面XComponent创建方法
  private isCreate: boolean = false; // 视频播放器是否被创建
  private isLoadingVideo: boolean = false; // 视频是否加载完成
  private arrayLength: number = -1; // 视频共有多少数据
  private callbackComplete: () => void = () => { // 播放至结尾状态回调
  };
  private callbackTimeUpdate: (nol: number) => void = (nol: number) => { // 时间上报函数回调
  };
  private callbackBitrateUpdate: (bitrateList: number[]) => void = (bitrateList: number[]) => { // 比特率更新回调
  };
  private callbackErrorUpdate: (error: string) => void = (error: string) => { // 错误状态回调
  };
  controller: VideoController = new VideoController();
  @State flag: boolean = false; // 视频是否进入准备状态
  @State currentTime: number = 0; // 视频当前时间
  @State imageChange: boolean = false; // 从图片切换成视频
  @State startOrEnd: boolean = false; // 是否是列表第一个和最后一个
  @State videoSrc: string = ''; // 当前播放视频路径
  @State @Watch('onChangePlay') isPlaying: boolean = false; // 是否播放状态
  @Link @Watch('onIndexChange') centerIndex: number; // List显示区域内中间子组件索引值
  @Consume isLoading: boolean; // 是否显示加载动画
  @Prop news: NewsItem; // 列表当前视频信息
  @Prop index: number; // 列表当前索引值

  async aboutToAppear() {
    // 视频列表数据初始化
    NEWS_LIST_DATA.forEach((news: NewsItem) => {
      this.newsList.pushData(news);
    })
    // 获取列表的长度
    this.arrayLength = this.newsList.totalCount()
    if (this.index === 0 || this.index === this.arrayLength) {
      this.startOrEnd = true;
    }
    // 设置播放状态
    this.setCompleteCallback(() => {
      logger.info('completed state called');
      this.isPlaying = !this.isPlaying;
    });
    // 时间上报函数
    this.setTimeUpdateCallback((time) => {
      this.currentTime = time;
    });
  }

  aboutToDisappear() {
    this.release();
  }

  // 初始化AVPlayer
  async init(): Promise<void> {
    await this.release();
    // 创建avPlayer实例对象
    this.avPlayer = await media.createAVPlayer();
    this.isCreate = true;
    // 创建状态机变化回调函数
    await this.setSourceInfo(); // 视频信息上报函数
    await this.setStateChangeCallback(); // 状态机上报回调函数
    this.avPlayer.url = this.videoSrc; // 播放hls网络直播码流
  }

  // 释放AVPlayer资源
  async release() {
    if (this.isCreate) {
      await this.avPlayer.release();
      this.isCreate = false;
      this.isPlaying = false;
    }
  }

  getPlay() {
    if (this.isCreate) {
      this.isLoading = false;
      this.flag = true; // 视频准备完毕
      this.avPlayer.play();
    }
  }

  getPause() {
    if (this.isCreate) {
      this.isLoading = false;
      this.avPlayer.pause();
    }
  }

  getStop() {
    if (this.isCreate) {
      this.avPlayer.stop();
    }
  }

  // TODO 知识点：XComponent和AVPlayer通过surfaceId绑定
  setSurfaceID(): void {
    logger.info('play video: surfaceID is:' + this.surfaceID);
    this.avPlayer.surfaceId = this.surfaceID;
  }

  setCompleteCallback(func: () => void) {
    this.callbackComplete = func;
  }

  setTimeUpdateCallback(func: (nol: number) => void) {
    this.callbackTimeUpdate = func;
  }

  setBitrateUpdateCallback(func: (bitrateList: number[]) => void) {
    this.callbackBitrateUpdate = func;
  }

  setErrorCallback(func: (error: string) => void) {
    this.callbackErrorUpdate = func;
  }

  // 视频信息上报函数
  async setSourceInfo(): Promise<void> {
    this.isLoadingVideo = false; // 视频未加载完成
    this.isLoading = true; // 加载动画继续加载
    // 时间上报函数
    this.avPlayer.on('timeUpdate', (time: number) => {
      this.callbackTimeUpdate(time);
    });
    // 音量变化回调函数
    this.avPlayer.on('volumeChange', (vol: number) => {
      logger.info('volumeChange success,and new volume is :' + vol);
    });
    // 视频播放结束触发回调
    this.avPlayer.on('endOfStream', () => {
      logger.info('endOfStream success');
    });
    // seek操作回调函数
    this.avPlayer.on('seekDone', (seekDoneTime: number) => {
      logger.info('seekDone success,and seek time is:' + seekDoneTime);
    });
    // 视频总时长上报函数
    this.avPlayer.on('durationUpdate', (duration: number) => {
      logger.info('durationUpdate success,and durationUpdate is:' + duration);
    });
    // 设置倍速播放回调函数
    this.avPlayer.on('speedDone', (speed: number) => {
      logger.info('speedDone success,and speed value is:' + speed);
    });
    // bitrate设置成功回调函数
    this.avPlayer.on('bitrateDone', (bitrate: number) => {
      logger.info('bitrateDone success,and bitrate value is:' + bitrate);
    });
    // 缓冲上报回调函数
    this.avPlayer.on('bufferingUpdate', (infoType: media.BufferingInfoType, value: number) => {
      logger.info('bufferingUpdate success,and infoType value is:' + infoType + ', value is :' + value);
    });
    // 首帧上报回调函数
    this.avPlayer.on('startRenderFrame', () => {
      logger.info('startRenderFrame success 1');
    });
    // 视频宽高上报回调函数
    this.avPlayer.on('videoSizeChange', (width: number, height: number) => {
      logger.info('videoSizeChange success,and width is:' + width + ', height is :' + height);
    });
    // 焦点上报回调函数
    this.avPlayer.on('audioInterrupt', (info: audio.InterruptEvent) => {
      // 触发焦点上报后调用暂停接口暂停播放
      logger.info('audioInterrupt success,and InterruptEvent info is:' + JSON.stringify(info));
    });
    // HLS上报所有支持的比特率
    this.avPlayer.on('availableBitrates', (bitrates: number[]) => {
      logger.info('availableBitrates success,and availableBitrates length is:' + bitrates.length);
      this.callbackBitrateUpdate(bitrates);
    });
    // 设置错误监听
    this.avPlayer.on('error', (error) => {
      logger.error('error happened,message is :' + error.message);
      this.callbackErrorUpdate('Error ' + error.code + ' - ' + error.message);
    });
  }

  // 状态机上报回调函数
  async setStateChangeCallback(): Promise<void> {
    this.avPlayer.on('stateChange', async (state: string, reason: media.StateChangeReason) => {
      logger.info('stateChange callback function is triggered,state is:' + state + ',reason is :' + reason);
      switch (state) {
        // 闲置状态
        case 'idle':
          // 调用release接口销毁实例对象
          this.release();
          logger.info('state idle called');
          break;
        // 资源初始化，avplayer设置播放源后触发该状态上报
        case 'initialized':
          logger.info('state initialized called');
          this.isLoadingVideo = false; // 视频未加载完成
          this.isLoading = true; // 加载动画继续加载
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
            this.avPlayer.play();
          }
          break;
        // 正在播放状态
        case 'playing':
          this.flag = true; // 视频准备完毕
          this.isLoading = false; // 取消加载
          this.isPlaying = true; // 视频开始播放
          logger.info('state playing called');
          break;
        // 暂停状态
        case 'paused':
          this.isPlaying = false; // 视频暂停播放
          logger.info('state paused called');
          break;
        // 播放至结尾状态
        case 'completed':
          logger.info('state completed called');
          this.callbackComplete();
          break;
        // 停止状态
        case 'stopped':
          this.isPlaying = false; // 视频暂停播放
          logger.info('state stopped called');
          break;
        // 销毁状态，销毁与当前AVPlayer关联的播放引擎，无法再进行状态转换
        case 'released':
          this.isLoadingVideo = false;
          this.isLoading = true;
          logger.info('state released called');
          break;
        // 错误状态，当播放引擎发生不可逆的错误，则会转换至当前状态
        case 'error':
          this.isPlaying = false;
          logger.error('state error called');
          break;
        default:
          logger.info('unknown state :' + state);
          break;
      }
    })
  }

  // isPlaying状态变化时调用
  onChangePlay() {
    this.isPlaying ? this.getPlay() : this.getPause();
  }

  // centerIndex状态变化时调用
  onIndexChange() {
    if (this.isLoadingVideo) {
      // centerIndex是List显示区域内中间子组件索引值，index值是列表当前索引值。当二者相等时，代表视频滑动到屏幕中间。
      if (this.centerIndex === this.index) {
        this.isPlaying = true;
        this.getPlay();
      } else {
        this.isPlaying = false;
        this.getPause();
      }
    }
  }

  build() {
    Column() {
      Column() {
        this.xComponentVideo(this.news)
      }
      .height($r('app.integer.video_list_autoplay_component_video_height'))
      .width($r('app.string.video_list_autoplay_component_video_width'))

      this.videoItem(this.news, this.index)
    }
    .height($r('app.integer.video_list_autoplay_component_height'))
    .margin({ bottom: $r('app.integer.video_list_autoplay_component_margin_bottom') })
  }

  /**
   * 视频渲染页面
   */
  @Builder
  xComponentVideo(news: NewsItem) {
    Stack() {
      XComponent({
        type: XComponentType.SURFACE,
        controller: this.xComponentController
      })
        .borderRadius($r('app.integer.video_list_autoplay_component_video_component_border_radius'))
        .onLoad(() => {
          this.surfaceID = this.xComponentController.getXComponentSurfaceId();
          this.videoSrc = news.newsVideoSrc;
          this.init();
        })
        .onClick(() => {
          if (this.centerIndex === this.index) {
            this.isPlaying = !this.isPlaying
          }
        })
      Image(news.newsImage)
        .borderRadius($r('app.integer.video_list_autoplay_component_video_component_border_radius'))
        .visibility(this.startOrEnd || !this.flag || this.imageChange ?
        Visibility.Visible :
        Visibility.None)
        .zIndex(1)
      // 播放icon
      if (this.isLoading && !this.isLoadingVideo) {
        Column() {
          // TODO: 知识点：创建加载进展组件，除支持通用属性外，还支持设置加载进度条前景色和设置动画显示或者不显示。
          LoadingProgress()
            .color(Color.White)
            .width($r('app.integer.video_list_autoplay_component_video_loading_progress_width'))
            .height($r('app.integer.video_list_autoplay_component_video_loading_progress_width'))
          Text($r('app.string.video_list_autoplay_component_video_loading_progress'))
            .fontSize($r('app.integer.video_list_autoplay_component_video_loading_text_font_size'))
            .fontColor(Color.White)
        }
        .justifyContent(FlexAlign.Center)
        .zIndex(2)
      } else {
        // 播放icon
        Image(this.isPlaying ? $r('app.media.video_list_autoplay_icon_play') :
        $r('app.media.video_list_autoplay_icon_pause'))
          .width($r('app.integer.video_list_autoplay_component_video_playing_image_width'))
          .height($r('app.integer.video_list_autoplay_component_video_playing_image_width'))
          .margin({
            left: $r('app.integer.video_list_autoplay_component_video_playing_image_margin_left'),
            right: $r('app.integer.video_list_autoplay_component_video_playing_image_margin_left')
          })
          .visibility(this.centerIndex === this.index && this.isPlaying ? Visibility.Hidden : Visibility.Visible)
          .onClick(() => {
            if (this.centerIndex === this.index) {
              this.isPlaying = !this.isPlaying;
            }
            if (this.index === FIRST_INDEX || this.index === this.arrayLength) {
              this.imageChange = false;
              this.startOrEnd = false;
            }
          })
          .zIndex(2)
      }
    }
  }

  /**
   * 视频渲染详情页面
   */
  @Builder
  videoItem(news: NewsItem, index: number) {
    Row() {
      Column() {
        Row() {
          // 视频图片
          Image(news.newsImage)
            .height($r('app.integer.video_list_autoplay_video_item_news_image_height'))
            .width($r('app.integer.video_list_autoplay_video_item_news_image_width'))
            .margin({
              right: $r('app.integer.video_list_autoplay_video_item_news_image_margin_right'),
              bottom: $r('app.integer.video_list_autoplay_video_item_news_image_margin_bottom')
            })
          // 视频标题、演出人员
          Column() {
            Text(news.newsName)
              .width($r('app.string.video_list_autoplay_video_item_news_name_width'))
              .fontSize($r('app.integer.video_list_autoplay_video_item_news_name_font_size'))
              .maxLines(MAX_LINES)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .margin({ bottom: $r('app.integer.video_list_autoplay_video_item_news_name_margin_bottom') })
            Text($r('app.string.video_list_autoplay_video_item_news_performer'))
              .width($r('app.string.video_list_autoplay_video_item_news_name_width'))
              .fontSize($r('app.integer.video_list_autoplay_video_item_news_performer_font_size'))
              .opacity(PERFORMER_OPACITY)
              .maxLines(MAX_LINES)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .textAlign(TextAlign.Start)
          }
          .width($r('app.string.video_list_autoplay_video_item_news_name_column_width'))
          .justifyContent(FlexAlign.SpaceEvenly)
        }
        .width($r('app.string.video_list_autoplay_video_item_news_name_row_width'))
        .margin({
          top: $r('app.integer.video_list_autoplay_video_item_news_name_row_margin_top'),
          bottom: $r('app.integer.video_list_autoplay_video_item_news_name_row_margin_top')
        })

        // 视频介绍
        Text(news.newsDetails)
          .width($r('app.string.video_list_autoplay_video_item_news_name_row_width'))
          .fontSize($r('app.integer.video_list_autoplay_video_item_news_details_font_size'))
          .opacity(DETAILS_OPACITY)
          .padding({ bottom: $r('app.integer.video_list_autoplay_video_item_news_details_padding_bottom') })
      }
      .width($r('app.string.video_list_autoplay_video_item_row_column_width'))

      // 视频图标
      Row() {
        Image($r('app.media.video_list_autoplay_drawer_filled'))
          .width($r('app.integer.video_list_autoplay_video_item_icon_image_width'))
          .height($r('app.integer.video_list_autoplay_video_item_icon_image_width'))
        Image($r('app.media.video_list_autoplay_cancel_filled'))
          .width($r('app.integer.video_list_autoplay_video_item_icon_image_width'))
          .height($r('app.integer.video_list_autoplay_video_item_icon_image_width'))
      }
      .onClick(() => {
        // 调用Toast显示提示:此样式仅为案例展示
        promptAction.showToast({ message: $r('app.string.video_list_autoplay_toast_tips') });
      })
      .padding($r('app.integer.video_list_autoplay_video_item_row_icon_image_padding'))
      .height($r('app.integer.video_list_autoplay_video_item_row_icon_image_height'))
      .alignItems(VerticalAlign.Top)
    }
    .width($r('app.string.video_list_autoplay_video_item_news_name_width'))
    .justifyContent(FlexAlign.SpaceBetween)
  }
}

/**
 * 日志打印类
 */
class Logger {
  private domain: number;
  private prefix: string;
  private format: string = '%{public}s, %{public}s';

  constructor(prefix: string) {
    this.prefix = prefix;
    this.domain = 0xFF00;
    this.format.toUpperCase();
  }

  debug(...args: string[]) {
    hilog.debug(this.domain, this.prefix, this.format, args);
  }

  info(...args: string[]) {
    hilog.info(this.domain, this.prefix, this.format, args);
  }

  warn(...args: string[]) {
    hilog.warn(this.domain, this.prefix, this.format, args);
  }

  error(...args: string[]) {
    hilog.error(this.domain, this.prefix, this.format, args);
  }
}

export let logger = new Logger('[CommonAppDevelopment]')