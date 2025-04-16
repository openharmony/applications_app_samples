/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
import { fileIo as fs } from '@kit.CoreFileKit';
import { media } from '@kit.MediaKit';
import { logger } from '../utils/Logger';
import { VideoPlayController } from './VideoPlayController';
import { VideoPlayListener } from './VideoPlayListener';
import { WorkItem, WORK_LIST_DATA } from '../model/WorkItemModel';
import { WorkListDataSource } from '../model/WorkListDataSource';


const FIRST_INDEX: number = 0; // 第一个index标志位
const TAG: string = 'videoTrimmer_XComponentVideo';

@Component
export struct XComponentVideo {
  private workList: WorkListDataSource = new WorkListDataSource();
  private avPlayer: media.AVPlayer = {} as media.AVPlayer; // 视频播放器对象
  private xComponentController: XComponentController = new XComponentController();
  private surfaceID: string = ''; // surfaceID用于播放画面显示，具体的值需要通过XComponent接口获取，相关文档链接见上面XComponent创建方法
  private isCreate: boolean = false; // 视频播放器是否被创建
  private isLoadingVideo: boolean = false; // 视频是否加载完成
  private arrayLength: number = -1; // 视频共有多少数据
  @State videoRatio: number = 1.0; // 视频宽高比
  private callbackComplete: () => void = () => { // 播放至结尾状态回调
  };
  private callbackTimeUpdate: (nol: number) => void = (nol: number) => { // 时间上报函数回调
  };
  private callbackBitrateUpdate: (bitrateList: number[]) => void = (bitrateList: number[]) => { // 比特率更新回调
  };
  private callbackErrorUpdate: (error: string) => void = (error: string) => { // 错误状态回调
  };
  videoPlayController?: VideoPlayController; // 视频播放控制接口
  videoPlayListener?: VideoPlayListener; // 视频播放回调接口
  @State isPrepared: boolean = false; // 视频是否进入准备状态
  @State currentTime: number = 0; // 视频当前时间
  @State imageChange: boolean = false; // 从图片切换成视频
  @State startOrEnd: boolean = false; // 是否是列表第一个和最后一个
  @State videoSrc: string = ''; // 当前播放视频路径
  @State @Watch('onChangePlay') isPlaying: boolean = false; // 是否播放状态
  @Link @Watch('onIndexChange') centerIndex: number; // List显示区域内中间子组件索引值
  @State isLoading: boolean = true; // 是否显示加载动画
  @Prop work: WorkItem; // 列表当前视频信息
  @Prop index: number; // 列表当前索引值
  onXComponentClick: (videoSrc: string) => void = () => { //  组件点击后回调
  };

  async aboutToAppear() {
    // 视频列表数据初始化
    WORK_LIST_DATA.forEach((work: WorkItem) => {
      this.workList.pushData(work);
    })
    // 获取列表的长度
    this.arrayLength = this.workList.totalCount()
    if (this.index === 0 || this.index === this.arrayLength) {
      this.startOrEnd = true;
    }
    // 初始化代理服务器
    this.videoSrc = this.work.videoSrc;

    if (this.videoPlayController) {
      this.videoPlayController.seek = this.seek;
      this.videoPlayController.pause = this.Pause;
      this.videoPlayController.play = this.Play;
    }
    logger.info(TAG, 'aboutToAppear centerIndex:' + this.centerIndex)
  }

  aboutToDisappear() {
    this.release();
  }

  async initAVPlayer(videoSrc: string): Promise<void> {
    await this.release();
    // 创建avPlayer实例对象
    this.avPlayer = await media.createAVPlayer();
    this.isCreate = true;
    // 创建状态机变化回调函数
    await this.setSourceInfo(); // 视频信息上报函数
    await this.setStateChangeCallback(); // 状态机上报回调函数

    logger.info(TAG, 'aboutToAppear centerIndex:' + videoSrc)
    if (videoSrc.startsWith(getContext().filesDir) || videoSrc.startsWith(getContext().cacheDir)) {
      const file = fs.openSync(videoSrc, fs.OpenMode.READ_ONLY);
      this.avPlayer.url = `fd://${file.fd}`;
    } else {
      this.avPlayer.url = videoSrc;
    }
  }

  // 注销回调函数接口
  setOffCallback(): void {
    if (this && this.avPlayer) {
      this.avPlayer?.off('volumeChange');
      this.avPlayer?.off('endOfStream');
      this.avPlayer?.off('seekDone');
      this.avPlayer?.off('durationUpdate');
      this.avPlayer?.off('speedDone');
      this.avPlayer?.off('bitrateDone');
      this.avPlayer?.off('bufferingUpdate');
      this.avPlayer?.off('startRenderFrame');
      this.avPlayer?.off('videoSizeChange');
      this.avPlayer?.off('audioInterrupt');
      this.avPlayer?.off('availableBitrates');
      this.avPlayer?.off('error');
      this.avPlayer?.off('stateChange');
    }
  }

  // 释放AVPlayer资源
  async release() {
    if (this.isCreate) {
      this.setOffCallback();
      await this.avPlayer.release();
      this.isCreate = false;
      this.isPlaying = false;
    }
  }

  Play = () => {
    logger.info(TAG, 'Play isCreate:' + this.isCreate);
    if (this.isCreate) {
      this.isLoading = false;
      this.isPrepared = true; // 视频准备完毕
      this.avPlayer.play();
      this.isPlaying = true;
    }
  }
  Pause = () => {
    logger.info(TAG, 'Pause isCreate:' + this.isCreate);
    if (this.isCreate) {
      this.isLoading = false;
      this.avPlayer.pause();
      this.isPlaying = false;
    }
  }
  private seek = (currentTime: number) => {
    logger.info(TAG, 'videoPlayController seek');
    this.avPlayer.seek(currentTime);
  }

  Stop() {
    if (this.isCreate) {
      this.avPlayer.stop();
    }
  }

  // TODO 知识点：XComponent和AVPlayer通过surfaceId绑定
  setSurfaceID(): void {
    logger.info(TAG, 'play video: surfaceID is:' + this.surfaceID);
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
    // 时间上报函数
    this.avPlayer.on('timeUpdate', (time: number) => {
      this.callbackTimeUpdate(time);
      this.videoPlayListener?.onTimeUpdate(time);
    });
    // 音量变化回调函数
    this.avPlayer.on('volumeChange', (vol: number) => {
      logger.info(TAG, 'volumeChange success,and new volume is :' + vol);
    });
    // 视频播放结束触发回调
    this.avPlayer.on('endOfStream', () => {
      logger.info(TAG, 'endOfStream success');
    });
    // seek操作回调函数
    this.avPlayer.on('seekDone', (seekDoneTime: number) => {
      logger.info(TAG, 'seekDone success,and seek time is:' + seekDoneTime);
    });
    // 视频总时长上报函数
    this.avPlayer.on('durationUpdate', (duration: number) => {
      logger.info(TAG, 'durationUpdate success,and durationUpdate is:' + duration);
    });
    // 设置倍速播放回调函数
    this.avPlayer.on('speedDone', (speed: number) => {
      logger.info(TAG, 'speedDone success,and speed value is:' + speed);
    });
    // bitrate设置成功回调函数
    this.avPlayer.on('bitrateDone', (bitrate: number) => {
      logger.info(TAG, 'bitrateDone success,and bitrate value is:' + bitrate);
    });
    // 缓冲上报回调函数
    this.avPlayer.on('bufferingUpdate', (infoType: media.BufferingInfoType, value: number) => {
      logger.info(TAG, 'bufferingUpdate success,and infoType value is:' + infoType + ', value is :' + value);
    });
    // 首帧上报回调函数
    this.avPlayer.on('startRenderFrame', () => {
      logger.info(TAG, 'startRenderFrame success');
    });
    // 视频宽高上报回调函数
    this.avPlayer.on('videoSizeChange', (width: number, height: number) => {
      this.videoRatio = width * (1.0) / height;
      logger.info(TAG, 'videoSizeChange success,and width is:' + width + ', height is :' + height);
    });
    // 焦点上报回调函数
    this.avPlayer.on('audioInterrupt', (info: audio.InterruptEvent) => {
      // 触发焦点上报后调用暂停接口暂停播放
      logger.info(TAG, 'audioInterrupt success,and InterruptEvent info is:' + JSON.stringify(info));
    });
    // HLS上报所有支持的比特率
    this.avPlayer.on('availableBitrates', (bitrates: number[]) => {
      logger.info(TAG, 'availableBitrates success,and availableBitrates length is:' + bitrates.length);
      this.callbackBitrateUpdate(bitrates);
      this.videoPlayListener?.onBitrateUpdate(bitrates);
    });
    // 设置错误监听
    this.avPlayer.on('error', (error) => {
      logger.error(TAG, 'error happened,message is :' + error.message);
      this.callbackErrorUpdate('Error ' + error.code + ' - ' + error.message);
      logger.error(TAG, 'error happened,fd is :' + this.avPlayer.url);
      this.videoPlayListener?.onErrorUpdate('Error ' + error.code + ' - ' + error.message);
    });
  }

  // 状态机上报回调函数
  async setStateChangeCallback(): Promise<void> {
    this.avPlayer.on('stateChange', async (state: string, reason: media.StateChangeReason) => {
      logger.info(TAG, 'stateChange callback function is triggered,state is:' + state + ',reason is :' + reason);
      switch (state) {
        // 闲置状态
        case 'idle':
          // 调用release接口销毁实例对象
          this.release();
          logger.info(TAG, 'state idle called');
          break;
        // 资源初始化，avplayer设置播放源后触发该状态上报
        case 'initialized':
          logger.info(TAG, 'state initialized called');
          this.setSurfaceID(); // 设置显示画面，当播放的资源为纯音频时无需设置
          this.avPlayer.prepare(); // 进入准备状态
          break;
        // 已准备状态
        case 'prepared':
          logger.info(TAG, 'state prepared called');
          this.avPlayer.audioInterruptMode = audio.InterruptMode.INDEPENDENT_MODE; // 避免同时出现两个视频的声音
          this.avPlayer.loop = true; // 设置循环播放
          this.isLoadingVideo = true; // 视频加载完成
          // 在屏幕中间的视频开始播放
          if (this.centerIndex === this.index) {
            this.isPlaying = true;
            this.avPlayer.play();
          }
          this.videoPlayListener?.onPrepared(this.avPlayer.duration);
          break;
        // 正在播放状态
        case 'playing':
          this.isPrepared = true; // 视频准备完毕
          this.isLoading = false; // 取消加载
          logger.info(TAG, 'state playing called');
          break;
        // 暂停状态
        case 'paused':
          logger.info(TAG, 'state paused called');
          break;
        // 播放至结尾状态
        case 'completed':
          logger.info(TAG, 'state completed called');
          this.videoPlayListener?.onComplete();
          break;
        // 停止状态
        case 'stopped':
          logger.info(TAG, 'state stopped called');
          break;
        // 销毁状态，销毁与当前AVPlayer关联的播放引擎，无法再进行状态转换
        case 'released':
          this.isLoadingVideo = false;
          this.isLoading = true;
          logger.info(TAG, 'state released called');
          break;
        // 错误状态，当播放引擎发生不可逆的错误，则会转换至当前状态
        case 'error':
          this.isPlaying = false;
          logger.error(TAG, 'state error called');
          break;
        default:
          logger.info(TAG, 'unknown state :' + state);
          break;
      }
    })
  }

  // isPlaying状态变化时调用
  onChangePlay() {
    logger.info(TAG, 'onChangePlay:' + this.isPlaying);
    this.isPlaying ? this.Play() : this.Pause();
    this.videoPlayListener?.onPlayStatus(this.isPlaying);
  }

  // centerIndex状态变化时调用
  onIndexChange() {
    logger.info(TAG, 'onIndexChange, centerIndex:' + this.centerIndex + ', currentIndex:' + this.index.toString() +
      ', isload:' + this.isLoadingVideo + this.isPlaying);
    if (this.isLoadingVideo) {
      // centerIndex是List显示区域内中间子组件索引值，index值是列表当前索引值。当二者相等时，代表视频滑动到屏幕中间。
      if (this.centerIndex === this.index) {
        this.isPlaying = true;
        this.Play();
      } else {
        this.isPlaying = false;
        this.Pause();
      }
    }
  }

  build() {
    Column() {
      this.XComponentVideo(this.work)
    }
    .width($r('app.string.video_trimmer_full_size'))
  }

  /**
   * 视频渲染页面
   */
  @Builder
  XComponentVideo(work: WorkItem) {
    Stack() {
      XComponent({
        type: XComponentType.SURFACE,
        controller: this.xComponentController
      })
        .aspectRatio(this.videoRatio)
        .onLoad(async () => {
          this.surfaceID = this.xComponentController.getXComponentSurfaceId();
          // 初始化AVPlayer
          this.initAVPlayer(this.videoSrc);
        })
        .onClick(() => {
          logger.info(TAG,
            `XComponentVideo onClick, centerIndex = ${this.centerIndex}, index = ${this.index}, src = ${work.videoSrc}`);
          if (this.centerIndex === this.index) {
            this.isPlaying = !this.isPlaying;
          }
          this.onXComponentClick(this.videoSrc);
        })
      Image(work.firstImage)
        .id('image_first')
        .visibility(this.startOrEnd || !this.isPrepared || this.imageChange ?
        Visibility.Visible :
        Visibility.None)
        .zIndex(1)
      // 播放icon
      if (this.isLoading && !this.isLoadingVideo) {
        Column() {
          // TODO: 知识点：创建加载进展组件，除支持通用属性外，还支持设置加载进度条前景色和设置动画显示或者不显示。
          LoadingProgress()
            .color(Color.White)
            .width($r('app.integer.video_trimmer_component_video_loading_progress_width'))
            .height($r('app.integer.video_trimmer_component_video_loading_progress_width'))
          Text($r('app.string.video_trimmer_component_video_loading_progress'))
            .fontSize($r('app.integer.video_trimmer_component_video_loading_text_font_size'))
            .fontColor(Color.White)
        }
        .justifyContent(FlexAlign.Center)
        .zIndex(2)
      } else {
        // 播放icon
        Image(this.isPlaying ? $r('app.media.video_trimmer_icon_play') :
        $r('app.media.video_trimmer_icon_pause'))
          .width($r('app.integer.video_trimmer_component_video_playing_image_width'))
          .height($r('app.integer.video_trimmer_component_video_playing_image_width'))
          .margin({
            left: $r('app.integer.video_trimmer_component_video_playing_image_margin_left'),
            right: $r('app.integer.video_trimmer_component_video_playing_image_margin_left')
          })
          .visibility(this.centerIndex === this.index && this.isPlaying ? Visibility.Hidden : Visibility.Visible)
          .onClick(() => {
            logger.info(TAG,
              `icon onClick, centerIndex = ${this.centerIndex}, index = ${this.index}, src = ${work.videoSrc}`);
            this.isPlaying = !this.isPlaying;
            if (this.index === FIRST_INDEX || this.index === this.arrayLength) {
              this.imageChange = false;
              this.startOrEnd = false;
            }
          })
          .zIndex(2)
      }
    }
    .id('video_stack')
    .onClick(() => {
      logger.info(TAG,
        `Stack onClick, centerIndex = ${this.centerIndex}, index = ${this.index}, src = ${work.videoSrc}`);
      this.onXComponentClick(this.videoSrc);
    })
  }
}
