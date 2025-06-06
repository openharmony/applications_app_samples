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
import { fileIo as fs } from '@kit.CoreFileKit';

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

  @State title: Resource = $r('app.string.EntryAbility_label');
  @State fileName: string = 'test_01.mp3';
  @State m3u8FileName: string = 'test.m3u8';
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
  @State subtitle: string = '';

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

  async avSetupURL(){
    // 通过UIAbilityContext的resourceManager成员的getRawFd接口获取媒体资源播放地址。
    // 返回类型为{fd,offset,length},fd为HAP包fd地址，offset为媒体资源偏移量，length为播放长度。
    if (this.context == undefined) return;

    if (this.avPlayer) {
      console.info(`${this.tag}: init avPlayer release2createNew`);
      this.avPlayer.release();
      await this.msleepAsync(1500);
    }
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

    // 情况一：播放HTTP/HTTPS媒体资源
    // 设置对应的播放url
    let url = "https://vd3.bdstatic.com/mda-pdc2kmwtd2vxhiy4/cae_h264/1681502407203843413/mda-pdc2kmwtd2vxhiy4.mp4";
    this.avPlayer.url = url;

    // 情况二：HLS媒体资源播放(点播/直播)
    // 设置对应的播放url
    // let url = 'http://media.iyuns.top:1000/720-270-480.m3u8';
    // this.avPlayer.url = url;

    // 情况三：设置HTTP请求头信息播放
    /*
    // 设置对应的播放url
    let url = 'https://vd3.bdstatic.com/mda-nmh2004d24kf4bjh/hd/h264/1671326683061787710/mda-nmh2004d24kf4bjh.mp4';
    // 创建mediaSource实例对象，设置媒体来源，定制HTTP请求，如需要，可以键值对的形式设置User-Agent、Cookie、Referer等字段
    let mediaSource : media.MediaSource = media.createMediaSourceWithUrl(url,  {'aa' : 'bb', 'cc' : 'dd'});
    // 设置播放策略，设置缓冲区数据量为20s
    let playbackStrategy : media.PlaybackStrategy =
      {preferredWidth: 1, preferredHeight: 2, preferredBufferDuration: 3, preferredHdr: false};
    // 为avPlayer设置媒体来源和播放策略
    this.avPlayer.setMediaSource(mediaSource, playbackStrategy);
    * */

    // 情况四：通过本地Raw文件中的m3u8文件播放在线流媒体资源
    /*
    // 通过本地m3u8文件名，获取文件描述符
    let fileDescriptor = await this.context.resourceManager.getRawFd(this.m3u8FileName);
    // 用文件描述符构造本地m3u8的URL
    let fdUrl : string = "fd://" + fileDescriptor.fd +
      "?offset=" + fileDescriptor.offset + "&size=" + fileDescriptor.length;
    // 按需设置HTTP请求头
    let headers : Record<string,string> = {"User-Agent" : "User-Agent-Value", "Cookie" : "Cookie-Value"};
    // 通过本地m3u8的URL和HTTP请求头构造mediaSource媒体来源
    let mediaSource : media.MediaSource = media.createMediaSourceWithUrl(fdUrl, headers);

    // 设置媒体MIME类型为APPLICATION_M3U8
    let mimeType : media.AVMimeTypes = media.AVMimeTypes.APPLICATION_M3U8;
    mediaSource.setMimeType(mimeType);

    // 设置播放策略，设置缓冲区数据量为20s
    let playbackStrategy : media.PlaybackStrategy = {preferredBufferDuration: 20};
    // 为avPlayer设置媒体来源和播放策略
    this.avPlayer.setMediaSource(mediaSource, playbackStrategy);
    * */

    // 情况五：通过应用沙箱中的m3u8文件播放在线流媒体资源
    /*
    let filePath = `${this.context.filesDir}/${this.m3u8FileName}`;
    // 通过fs.openSync获取文件句柄
    let file = fs.openSync(filePath, fs.OpenMode.READ_ONLY);
    let fd : string = file.fd.toString();
    // 用文件句柄构造本地m3u8的URL
    let fdUrl : string = "fd://" + fd + "?offset=" + "0" + "&size=" + "0";

    // 按需设置HTTP请求头
    let headers : Record<string,string> = {"User-Agent" : "User-Agent-Value", "Cookie" : "Cookie-Value"};
    // 通过本地m3u8的URL和HTTP请求头构造mediaSource媒体来源
    let mediaSource : media.MediaSource = media.createMediaSourceWithUrl(fdUrl, headers);

    // 设置媒体MIME类型为APPLICATION_M3U8
    let mimeType : media.AVMimeTypes = media.AVMimeTypes.APPLICATION_M3U8;
    mediaSource.setMimeType(mimeType);

    // 设置播放策略，设置缓冲区数据量为20s
    let playbackStrategy : media.PlaybackStrategy = {preferredBufferDuration: 20};
    // 为avPlayer设置媒体来源和播放策略
    this.avPlayer.setMediaSource(mediaSource, playbackStrategy);
    * */

    // 本地raw文件播放场景下设置URL
    /*
    // 情况一：应用沙箱文件播放
    let fdPath = 'fd://';
    // 通过UIAbilityContext获取沙箱地址filesDir，以Stage模型为例
    let path = `${this.context.filesDir}/${this.fileName}`;
    // 打开相应的资源文件地址获取fd，并为url赋值触发initialized状态机上报
    let file = await fs.open(path);
    fdPath = fdPath + '' + file.fd;
    this.avPlayer.url = fdPath;
    * */

    // 情况二：本地文件播放
    /*
    // 通过UIAbilityContext的resourceManager成员的getRawFd接口获取媒体资源播放地址
    // 返回类型为{fd,offset,length},fd为HAP包fd地址，offset为媒体资源偏移量，length为播放长度
    let fileDescriptor = await this.context.resourceManager.getRawFd(this.fileName);
    let avFileDescriptor: media.AVFileDescriptor =
      { fd: fileDescriptor.fd, offset: fileDescriptor.offset, length: fileDescriptor.length };
    // 为fdSrc赋值触发initialized状态机上报
    this.avPlayer.fdSrc = avFileDescriptor;
    * */
  }

  async avTurnOffSubtitle() {
    this.avPlayer?.off('subtitleUpdate');
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
        console.info(`${this.tag}: avPause== ${JSON.stringify(e)}`);
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
        console.info(`${this.tag}: videoSeek== ${JSON.stringify(e)}`);
      }
    }
  }

  avSetSpeed(speed: number): void {
    if (this.avPlayer) {
      try {
        this.avPlayer.setSpeed(speed);
        console.info(`${this.tag}: avSetSpeed enum ${speed}`);
      } catch (e) {
        console.info(`${this.tag}: avSetSpeed == ${JSON.stringify(e)}`);
      }
    }
  }

  // 注册avplayer回调函数
  async setAVPlayerCallback(callback: (avPlayer: media.AVPlayer) => void, vType?: number): Promise<void> {
    // seek操作结果回调函数
    if (this.avPlayer == null) {
      console.info(`${this.tag}: avPlayer has not init!`);
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
        console.info(`${this.tag}: avPlayer has not init on error`);
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
          console.info(`${this.tag}: setAVPlayerCallback AVPlayer state error called.`);
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

    this.avPlayer.on('subtitleUpdate', (info: media.SubtitleInfo) => {
      if (!!info) {
        let text = (!info.text) ? '' : info.text;
        let startTime = (!info.startTime) ? 0 : info.startTime;
        let duration = (!info.duration) ? 0 : info.duration;
        console.info('subtitleUpdate info: text=' + text + ' startTime=' + startTime +' duration=' + duration);
        this.subtitle = text;
      } else {
        console.info('subtitleUpdate info is null');
      }
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
        console.error(`${this.tag}: videoRelease release filed,error message is = ${JSON.stringify(err.message)}`);
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
        this.avSetupURL();
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
                Image(this.isPaused ? $r("app.media.ic_video_play") : $r("app.media.ic_video_pause"))// 暂停/播放
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
      Row() {
        Text(this.subtitle)
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
