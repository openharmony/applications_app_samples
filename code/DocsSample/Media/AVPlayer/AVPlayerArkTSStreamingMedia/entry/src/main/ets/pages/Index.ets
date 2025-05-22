/*
 * Copyright (c) 2023-2025 Huawei Device Co., Ltd.
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

import display from '@ohos.display';
import emitter from '@ohos.events.emitter';
import { common } from '@kit.AbilityKit';
import media from '@ohos.multimedia.media';
import { BusinessError } from '@kit.BasicServicesKit';

const PROPORTION = 0.99; // 占屏幕比例
const SURFACE_W = 0.9; // 表面宽比例
const SURFACE_H = 1.78; // 表面高比例
const SET_INTERVAL = 100; // interval间隔时间
const TIME_ONE = 60000;
const TIME_TWO = 1000;
const SPEED_ZERO = 0;
const SPEED_ONE = 1;
const SPEED_TWO = 2;
const SPEED_THREE = 3;
const SPEED_COUNT = 4;
let innerEventFalse: emitter.InnerEvent = {
  eventId: 1,
  priority: emitter.EventPriority.HIGH
};
let innerEventTrue: emitter.InnerEvent = {
  eventId: 2,
  priority: emitter.EventPriority.HIGH
};
let innerEventWH: emitter.InnerEvent = {
  eventId: 3,
  priority: emitter.EventPriority.HIGH
};

@Entry
@Component
struct Index {
  tag: string = 'AVPlayManager';
  private xComponentController: XComponentController = new XComponentController();
  private avPlayer: media.AVPlayer | null = null;
  private surfaceId: string = '';
  private intervalID: number = -1;
  private seekTime: number = -1;
  private context: common.UIAbilityContext | undefined = undefined;
  public videoTrackIndex: number = 0;
  public bitrate: number = 0;

  @State title: Resource = $r('app.string.EntryAbility_label');
  @State fileName: string = 'test1.mp4';
  @State isSwiping: boolean = false; // 用户滑动过程中
  @State isPaused: boolean = true; // 暂停播放
  @State XComponentFlag: boolean = false;
  @State speedSelect: number = 0; // 倍速选择
  @State speedList: Resource[] = [$r('app.string.video_speed_1_0X'), $r('app.string.video_speed_1_25X'), $r('app.string.video_speed_1_75X'), $r('app.string.video_speed_2_0X')];
  @StorageLink('durationTime') durationTime: number = 0; // 视频总时长
  @StorageLink('currentTime') currentTime: number = 0; // 视频当前时间
  @StorageLink('speedName') speedName: Resource = $r('app.string.video_speed_1_0X');
  @StorageLink('speedIndex') speedIndex: number = 0; // 倍速索引
  @State surfaceW: number | null = null;
  @State surfaceH: number | null = null;
  @State percent: number = 0;
  @State windowWidth: number = 300;
  @State windowHeight: number = 200;

  getDurationTime(): number {
    return this.durationTime;
  }

  getCurrentTime(): number {
    return this.currentTime;
  }

  timeConvert(time: number): string {
    let min: number = Math.floor(time / TIME_ONE);
    let second: string = ((time % TIME_ONE) / TIME_TWO).toFixed(0);
    // return `${min}:${(+second < TIME_THREE ? '0' : '') + second}`;
    second = second.padStart(2, '0');
    return `${min}:${second}`;
  }

  async msleepAsync(ms: number): Promise<boolean> {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        resolve(true)
      }, ms)
    })
  }

  async avSetupStreaminMediaVideo() {
    if (this.context == undefined) return;
    // 创建avPlayer实例对象
    this.avPlayer = await media.createAVPlayer();

    // 创建状态机变化回调函数
    await this.setAVPlayerCallback((avPlayer: media.AVPlayer) => {
      this.percent = avPlayer.width / avPlayer.height;
      this.setVideoWH();
      this.durationTime = this.getDurationTime();
      setInterval(() => { // 更新当前时间
        if (!this.isSwiping) {
          this.currentTime = this.getCurrentTime();
        }
      }, SET_INTERVAL);
    });

    // 情况一：HTTP视频播放
    this.avPlayer.url = "http://media.iyuns.top:1000/http/720p_1m.mp4";

    // 情况二：HLS视频播放
    // this.avPlayer.url = "http://media.iyuns.top:1000/720-270-480.m3u8";

    // 情况三：DASH视频播放
    // this.avPlayer.url = "http://media.iyuns.top:1000/dash/720p/720-1/720-1.mpd";

    // 情况四：通过setMediaSource设置自定义头域及播放优选参数实现初始播放参数设置，以流媒体HTTP点播为例
    /*
    let mediaSource : media.MediaSource = media.createMediaSourceWithUrl("http://media.iyuns.top:1000/http/720p_1m.mp4", {"":""});
    // 设置播放策略，设置为缓冲区数据为20s
    let playbackStrategy : media.PlaybackStrategy = {preferredBufferDuration: 20};
    // 为avPlayer设置媒体来源和播放策略
    this.avPlayer.setMediaSource(mediaSource, playbackStrategy);
    * */

    // 情况五：HLS切码率
    /*
    this.avPlayer.url = "https://upftimae.dailyworkout.cn/videos/course/c800f81a209b5ee7891f1128ed301db/4/master.m3u8";
    let bitrate: number = 0;
    // 监听当前HLS协议流可用的码率
    this.avPlayer.on('availableBitrates', (bitrates: Array<number>) => {
      console.info('availableBitrates called, and availableBitrates length is: ' + bitrates.length);
      this.bitrate = bitrates[0]; // 保存需要切换的码率
    })
    // 监听码率设置是否生效
    this.avPlayer.on('bitrateDone', (bitrate: number) => {
      console.info('bitrateDone called, and bitrate value is: ' + bitrate);
    })
    * */

    // 情况六：DASH切换音视频轨道
    /*
    this.avPlayer.url = "http://poster-inland.hwcloudtest.cn/AiMaxEngine/ProductionEnvVideo/DASH_SDR_MultiAudio_MultiSubtitle_yinHeHuWeiDui3/DASH_SDR_MultiAudio_MultiSubtitle_yinHeHuWeiDui3.mpd";
    // 
    this.avPlayer.getTrackDescription((error: BusinessError, arrList: Array<media.MediaDescription>) => {
      if (arrList != null) {
        for (let i = 0; i < arrList.length; i++) {
          let propertyIndex: Object = arrList[i][media.MediaDescriptionKey.MD_KEY_TRACK_INDEX];
          let propertyType: Object = arrList[i][media.MediaDescriptionKey.MD_KEY_TRACK_TYPE];
          let propertyWidth: Object = arrList[i][media.MediaDescriptionKey.MD_KEY_WIDTH];
          let propertyHeight: Object = arrList[i][media.MediaDescriptionKey.MD_KEY_HEIGHT];
          if (propertyType == media.MediaType.MEDIA_TYPE_VID && propertyWidth == 1920 && propertyHeight == 1080) {
            this.videoTrackIndex = parseInt(propertyIndex.toString()); // 获取1080p视频轨道索引。
          }
        }
      } else {
        console.error(`getTrackDescription fail, error:${error}`);
      }
    });
    * */
  }

  // HLS切换码率
  changeBitrate(bitrate: number) {
    if (this.avPlayer == null) {
      return;
    }
    // 设置播放码率
    try {
      this.avPlayer.setBitrate(bitrate);
    } catch (error) {
      console.error(`${this.tag}: setBitrate failed, error message is = ${JSON.stringify(error.message)}`);
    }
  }

  // DASH切换音视频轨道
  changeTrack(track: number) {
    if (this.avPlayer == null) {
      return;
    }
    // 切换至目标视频轨道
    try {
      this.avPlayer.selectTrack(track);
    } catch (error) {
      console.error(`${this.tag}: selectTrack failed, error message is = ${JSON.stringify(error.message)}`);
    }
    // 取消选择目标视频轨道
    /*
    try {
      this.avPlayer.deselectTrack(track);
    } catch (error) {
      console.error(`${this.tag}: deselectTrack failed, error message is = ${JSON.stringify(error.message)}`);
    }
    * */
  }

  avPlay(): void {
    if (this.avPlayer) {
      try {
        this.avPlayer.play();
      } catch (e) {
        console.error(`${this.tag}: avPlay = ${JSON.stringify(e)}`);
      }
    }
  }

  avPause(): void {
    if (this.avPlayer) {
      try {
        this.avPlayer.pause();
        console.info(`${this.tag}: avPause==`);
      } catch (e) {
        console.error(`${this.tag}: avPause== ${JSON.stringify(e)}`);
      }
    }
  }

  async avSeek(seekTime: number, mode: SliderChangeMode): Promise<void> {
    if (this.avPlayer) {
      try {
        console.info(`${this.tag}: videoSeek  seekTime== ${seekTime}`);
        this.avPlayer.seek(seekTime, 2);
        this.currentTime = seekTime;
      } catch (e) {
        console.error(`${this.tag}: videoSeek== ${JSON.stringify(e)}`);
      }
    }
  }

  avSetSpeed(speed: number): void {
    if (this.avPlayer) {
      try {
        this.avPlayer.setSpeed(speed);
        console.info(`${this.tag}: avSetSpeed enum ${speed}`);
      } catch (e) {
        console.error(`${this.tag}: avSetSpeed == ${JSON.stringify(e)}`);
      }
    }
  }

  // 注册avplayer回调函数
  async setAVPlayerCallback(callback: (avPlayer: media.AVPlayer) => void, vType?: number): Promise<void> {
    // seek操作结果回调函数
    if (this.avPlayer == null) {
      console.error(`${this.tag}: avPlayer has not init!`);
      return;
    }
    this.avPlayer.on('seekDone', (seekDoneTime) => {
      console.info(`${this.tag}: setAVPlayerCallback AVPlayer seek succeeded, seek time is ${seekDoneTime}`);
    });
    this.avPlayer.on('speedDone', (speed) => {
      console.info(`${this.tag}: setAVPlayerCallback AVPlayer speedDone, speed is ${speed}`);
    });
    // error回调监听函数,当avPlayer在操作过程中出现错误时调用reset接口触发重置流程
    this.avPlayer.on('error', (err) => {
      console.error(`${this.tag}: setAVPlayerCallback Invoke avPlayer failed ${JSON.stringify(err)}`);
      if (this.avPlayer == null) {
        console.error(`${this.tag}: avPlayer has not init on error`);
        return;
      }
      this.avPlayer.reset();
    });
    // 状态机变化回调函数
    this.avPlayer.on('stateChange', async (state, reason) => {
      if (this.avPlayer == null) {
        console.info(`${this.tag}: avPlayer has not init on state change`);
        return;
      }
      switch (state) {
        case 'idle': // 成功调用reset接口后触发该状态机上报
          console.info(`${this.tag}: setAVPlayerCallback AVPlayer state idle called.`);
          break;
        case 'initialized': // avplayer 设置播放源后触发该状态上报
          console.info(`${this.tag}: setAVPlayerCallback AVPlayer state initialized called.`);
          if (this.surfaceId) {
            this.avPlayer.surfaceId = this.surfaceId; // 设置显示画面，当播放的资源为纯音频时无需设置
            console.info(`${this.tag}: setAVPlayerCallback this.avPlayer.surfaceId = ${this.avPlayer.surfaceId}`);
            this.avPlayer.prepare();
          }
          break;
        case 'prepared': // prepare调用成功后上报该状态机
          console.info(`${this.tag}: setAVPlayerCallback AVPlayer state prepared called.`);
          this.avPlayer.on('bufferingUpdate', (infoType: media.BufferingInfoType, value: number) => {
            console.info(`${this.tag}: bufferingUpdate called, infoType value: ${infoType}, value:${value}}`);
          })
          this.durationTime = this.avPlayer.duration;
          this.currentTime = this.avPlayer.currentTime;
          this.avPlayer.play(); // 调用播放接口开始播放
          console.info(`${this.tag}:
            setAVPlayerCallback speedSelect: ${this.speedSelect}, duration: ${this.durationTime}`);
          if (this.speedSelect != -1) {
            switch (this.speedSelect) {
              case SPEED_ZERO:
                this.avSetSpeed(media.PlaybackSpeed.SPEED_FORWARD_1_00_X);
                break;
              case SPEED_ONE:
                this.avSetSpeed(media.PlaybackSpeed.SPEED_FORWARD_1_25_X);
                break;
              case SPEED_TWO:
                this.avSetSpeed(media.PlaybackSpeed.SPEED_FORWARD_1_75_X);
                break;
              case SPEED_THREE:
                this.avSetSpeed(media.PlaybackSpeed.SPEED_FORWARD_2_00_X);
                break;
            }
          }
          callback(this.avPlayer);
          break;
        case 'playing': // play成功调用后触发该状态机上报
          console.info(`${this.tag}: setAVPlayerCallback AVPlayer state playing called.`);
          if (this.intervalID != -1) {
            clearInterval(this.intervalID)
          }
          this.intervalID = setInterval(() => { // 更新当前时间
            AppStorage.setOrCreate('durationTime', this.durationTime);
            AppStorage.setOrCreate('currentTime', this.currentTime);
          }, 100);
          let eventDataTrue: emitter.EventData = {
            data: {
              'flag': true
            }
          };
          let innerEventTrue: emitter.InnerEvent = {
            eventId: 2,
            priority: emitter.EventPriority.HIGH
          };
          emitter.emit(innerEventTrue, eventDataTrue);
          break;
        case 'completed': // 播放结束后触发该状态机上报
          console.info(`${this.tag}: setAVPlayerCallback AVPlayer state completed called.`);
          let eventDataFalse: emitter.EventData = {
            data: {
              'flag': false
            }
          };
          let innerEvent: emitter.InnerEvent = {
            eventId: 1,
            priority: emitter.EventPriority.HIGH
          };
          emitter.emit(innerEvent, eventDataFalse);
          if (this.intervalID != -1) {
            clearInterval(this.intervalID)
          }
          this.avPlayer.off('bufferingUpdate')
          AppStorage.setOrCreate('currentTime', this.durationTime);
          break;
        case 'released':
          console.info(`${this.tag}: setAVPlayerCallback released called.`);
          break
        case 'stopped':
          console.info(`${this.tag}: setAVPlayerCallback AVPlayer state stopped called.`);
          break
        case 'error':
          console.error(`${this.tag}: setAVPlayerCallback AVPlayer state error called.`);
          break
        case 'paused':
          console.info(`${this.tag}: setAVPlayerCallback AVPlayer state paused called.`);
          break
        default:
          console.info(`${this.tag}: setAVPlayerCallback AVPlayer state unknown called.`);
          break;
      }
    });
    // 时间上报监听函数
    this.avPlayer.on('timeUpdate', (time: number) => {
      this.currentTime = time;
    });
  }

  aboutToAppear() {
    this.windowWidth = display.getDefaultDisplaySync().width;
    this.windowHeight = display.getDefaultDisplaySync().height;
    this.surfaceW = this.windowWidth * SURFACE_W;
    this.surfaceH = this.surfaceW / SURFACE_H;
    this.isPaused = true;
    this.context = getContext(this) as common.UIAbilityContext;
  }

  aboutToDisappear() {
    if (this.avPlayer == null) {
      console.info(`${this.tag}: avPlayer has not init aboutToDisappear`);
      return;
    }
    this.avPlayer.release((err) => {
      if (err == null) {
        console.info(`${this.tag}: videoRelease release success`);
      } else {
        console.error(`${this.tag}: videoRelease release failed, error message is = ${JSON.stringify(err.message)}`);
      }
    });
    emitter.off(innerEventFalse.eventId);
  }

  onPageHide() {
    this.avPause();
    this.isPaused = false;
  }

  onPageShow() {
    emitter.on(innerEventTrue, (res: emitter.EventData) => {
      if (res.data) {
        this.isPaused = res.data.flag;
        this.XComponentFlag = res.data.flag;
      }
    });
    emitter.on(innerEventFalse, (res: emitter.EventData) => {
      if (res.data) {
        this.isPaused = res.data.flag;
      }
    });
    emitter.on(innerEventWH, (res: emitter.EventData) => {
      if (res.data) {
        this.windowWidth = res.data.width;
        this.windowHeight = res.data.height;
        this.setVideoWH();
      }
    });
  }

  setVideoWH(): void {
    if (this.percent >= 1) { // 横向视频
      this.surfaceW = Math.round(this.windowWidth * PROPORTION);
      this.surfaceH = Math.round(this.surfaceW / this.percent);
    } else { // 纵向视频
      this.surfaceH = Math.round(this.windowHeight * PROPORTION);
      this.surfaceW = Math.round(this.surfaceH * this.percent);
    }
  }

  @Builder
  CoverXComponent() {
    XComponent({
      // 装载视频容器
      id: 'xComponent',
      type: XComponentType.SURFACE,
      controller: this.xComponentController
    })
      .id('VideoView')
      .visibility(this.XComponentFlag ? Visibility.Visible : Visibility.Hidden)
      .onLoad(() => {
        this.surfaceId = this.xComponentController.getXComponentSurfaceId();
        this.avSetupStreaminMediaVideo();
      })
      .height(`${this.surfaceH}px`)
      .width(`${this.surfaceW}px`)
  }

  build() {
    Column() {
      Stack() {
        Column() {
          this.CoverXComponent()
        }
        .align(Alignment.TopStart)
        .margin({ top: 80 })
        .id('VideoView')
        .justifyContent(FlexAlign.Center)

        Text()
          .height(`${this.surfaceH}px`)
          .width(`${this.surfaceW}px`)
          .margin({ top: 80 })
          .backgroundColor(Color.Black)
          .opacity($r('app.float.size_zero_five'))
          .visibility(this.isSwiping ? Visibility.Visible : Visibility.Hidden)

        Row() {
          Text(this.timeConvert(this.currentTime))
            .id("currentTime")
            .fontSize($r('app.float.size_24'))
            .opacity($r('app.float.size_1'))
            .fontColor($r("app.color.slider_selected"))
          Text("/" + this.timeConvert(this.durationTime))
            .id("durationTime")
            .fontSize($r('app.float.size_24'))
            .opacity($r('app.float.size_1'))
            .fontColor(Color.White)
        }
        .margin({ top: 80 })
        .visibility(this.isSwiping ? Visibility.Visible : Visibility.Hidden)

        Column() {

          Blank()

          Column() {
            // 进度条
            Row() {
              Row() {
                // 播放、暂停键
                Image(this.isPaused ? $r("app.media.ic_video_play") : $r("app.media.ic_video_pause")) // 暂停/播放
                  .id(this.isPaused ? 'pause' : 'play')
                  .width($r('app.float.size_40'))
                  .height($r('app.float.size_40'))
                  .onClick(() => {
                    if (this.isPaused) {
                      this.avPause();
                      this.isPaused = false;
                    } else {
                      this.avPlay();
                      this.isPaused = true;
                    }
                  })
                // 左侧时间
                Text(this.timeConvert(this.currentTime))
                  .id("currentTimeText")
                  .fontColor(Color.White)
                  .textAlign(TextAlign.End)
                  .fontWeight(FontWeight.Regular)
                  .margin({ left: $r('app.float.size_10') })
              }

              // 进度条
              Row() {
                Slider({
                  value: this.currentTime,
                  min: 0,
                  max: this.durationTime,
                  style: SliderStyle.OutSet
                })
                  .id('Slider')
                  .blockColor(Color.White)
                  .trackColor(Color.Gray)
                  .selectedColor($r("app.color.slider_selected"))
                  .showTips(false)
                  .onChange((value: number, mode: SliderChangeMode) => {
                    if (this.seekTime !== value) {
                      this.seekTime = value;
                      this.avSeek(Number.parseInt(value.toFixed(0)), mode);
                    }
                  })
              }
              .layoutWeight(1)

              Row() {
                // 右侧时间
                Text(this.timeConvert(this.durationTime))
                  .id("durationTimeText")
                  .fontColor(Color.White)
                  .fontWeight(FontWeight.Regular)

                // 倍速按钮
                Button(this.speedName, { type: ButtonType.Normal })
                  .border({ width: $r('app.float.size_1'), color: Color.White })
                  .width(75)
                  .height($r('app.float.size_40'))
                  .fontSize($r('app.float.size_15'))
                  .borderRadius($r('app.float.size_24'))
                  .fontColor(Color.White)
                  .backgroundColor(Color.Black)
                  .opacity($r('app.float.size_1'))
                  .margin({ left: $r('app.float.size_10') })
                  .id('Speed')
                  .onClick(() => {
                    this.speedIndex = (this.speedIndex + 1) % SPEED_COUNT;
                    this.speedSelect = this.speedIndex;
                    this.speedName = this.speedList[this.speedIndex];
                    if(!this.avPlayer) return;
                    switch (this.speedSelect) {
                      case 0:
                        this.avSetSpeed(media.PlaybackSpeed.SPEED_FORWARD_1_00_X);
                        break;
                      case 1:
                        this.avSetSpeed(media.PlaybackSpeed.SPEED_FORWARD_1_25_X);
                        break;
                      case 2:
                        this.avSetSpeed(media.PlaybackSpeed.SPEED_FORWARD_1_75_X);
                        break;
                      case 3:
                        this.avSetSpeed(media.PlaybackSpeed.SPEED_FORWARD_2_00_X);
                        break;
                    }
                  })
              }
            }
            .justifyContent(FlexAlign.Center)
            .padding({ left: $r('app.float.size_25'), right: $r('app.float.size_30') })
            .width('100%')
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)
        }
        .width('100%')
        .height('100%')
      }
      .backgroundColor(Color.Black)
      .height('90%')
      .width('100%')

      Row() {
        Text(this.title)
          .fontSize($r('app.float.size_20'))
          .fontColor(Color.White)
          .opacity($r('app.float.size_zero_six'))
          .fontWeight(FontWeight.Regular)
          .textAlign(TextAlign.Center)
      }
    }.backgroundColor(Color.Black)
    .height('100%')
    .width('100%')
  }
}
