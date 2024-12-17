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

import media from '@ohos.multimedia.media';
import audio from '@ohos.multimedia.audio';
import window from '@ohos.window';
import { logger } from '../util/Logger';
import { getTimeString } from '../util/TimeTools';
import resourceManager from '@ohos.resourceManager';
import { BusinessError } from '@kit.BasicServicesKit';

// 倍速对象
interface speedObj {
  text: string,
  value: number
};

const WINDOW_SYSTEM_BAR: Array<'status' | 'navigation'> = ['navigation', 'status'];
const LAYOUT_WEIGHT: number = 1; // 自动分配剩余空间
const SPEED_POPUP_LIST_SPACE: number = 20;
const FONT_WEIGHT: number = 500;
const OPACITY: number = 0.6;
const AVPLAYER_PLAYING_STATE: string = 'playing';
const AVPLAYER_PAUSED_STATE: string = 'paused';

class AVPlayerConstants {
  // 倍速
  public static readonly SPEED_ARRAY: speedObj[] = [
    {
      text: '0.75x', value: 0
    },
    {
      text: '1.0x', value: 1
    },
    {
      text: '1.25x', value: 2
    },
    {
      text: '1.75x', value: 3
    },
    {
      text: '2.0x', value: 4
    }];
}

@Component
export struct VideoComponent {
  @State verticalVideo: boolean = true; // 是否是竖屏视频
  @State aspectRatio_: number = 1.77777778; // 元素宽高比
  @State currentTime: number = 0; // 视频当前时间
  @State flagValue: number = 0; // 拖拽时时间
  @State totalDuration: number = 0; // 视频总时长
  @State @Watch('onChangePlay') isPlaying: boolean = false; // 是否播放状态
  @Link @Watch('changeOrientation') isLandscapeStart: boolean; // 是否横屏状态
  @Link isLandscape: boolean; // 是否横屏状态
  @State isSpeedShow: boolean = false; // 是否倍速状态
  @State speed: string = '1.0x'; // 倍速大小
  @Link @Watch('onChangeVideo') selectedVideo: string; // 视频名称
  @State systemHeight: number = 0; // 系统状态栏高度
  private fileName: string = '';
  private fileUrl: string = '';
  private avPlayer: media.AVPlayer = {} as media.AVPlayer; // 视频播放器对象
  private surfaceID: string | undefined = undefined; // 视频播放器ID
  private isCreate: boolean = false; // 视频播放器是否被创建
  private xComponentController: XComponentController = new XComponentController();
  private callbackComplete: () => void = () => { // 播放至结尾状态回调
  };
  private callbackTimeUpdate: (nol: number) => void = (nol: number) => { // 时间上报函数回调
  };
  private callbackBitrateUpdate: (bitrateList: number[]) => void = (bitrateList: number[]) => { // 比特率更新回调
  };
  private callbackErrorUpdate: (error: string) => void = (error: string) => { // 错误状态回调
  };

  aboutToAppear() {
    // 获取系统状态栏高度
    window.getLastWindow(getContext()).then((lastWindow) => {
      const areas = lastWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      this.systemHeight = px2vp(areas.topRect.height);
    });
    // 设置播放状态
    this.setCompleteCallback(() => {
      logger.info('completed state called');
      this.isPlaying = false;
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
    const context = getContext(this);
    // 获取fdSrc用于注册AVPlayer
    // TODO: 大概是由于avplayer还没有进入prepared状态就划到了当前视频并被执行播放
    context.resourceManager.getRawFd(this.fileUrl).then(async (value: resourceManager.RawFileDescriptor) => {
      this.avPlayer = await media.createAVPlayer();
      this.isCreate = true;
      await this.setSourceInfo(); // 视频信息上报函数
      await this.setStateChangeCallback(); // 状态机上报回调函数
      this.avPlayer.fdSrc = {
        fd: value.fd,
        offset: value.offset,
        length: value.length
      };
    });
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
    let state = this.avPlayer.state;
    if (this.isCreate && (state === 'prepared' || state === 'completed' || state === 'paused')) {
      this.avPlayer.play();
    }
  }

  getPause() {
    // TODO: 知识点: 只有视频创建并且处于播放状态才会暂停
    if (this.isCreate && this.avPlayer.state === 'playing') {
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
    // 时间上报函数
    this.avPlayer.on('timeUpdate', (time: number) => {
      logger.info('timeUpdate called: time is :' + time);
      logger.info('timeUpdate called: currentTime is :' + this.avPlayer.currentTime);
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
      logger.info(`audioInterrupt success,and InterruptEvent info is: ${info}`);
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
      this.avPlayer.release();
      this.init();
    });
  }

  // 状态机上报回调函数
  async setStateChangeCallback(): Promise<void> {
    this.avPlayer.on('stateChange', async (state: string, reason: media.StateChangeReason) => {
      logger.info('stateChange callback function is triggered,state is:' + state + ',reason is :' + reason);
      switch (state) {
        case 'idle':
          logger.info('state idle called');
          break;
        case 'initialized':
          logger.info('state initialized called');
          this.setSurfaceID();
          this.avPlayer.prepare();
          break;
        case 'prepared':
          logger.info(`state prepared called, ${this.fileUrl}`);
          this.getPlay();
          this.isPlaying = true; // 准备完成阶段 开始播放
          this.totalDuration = this.avPlayer.duration; // 获取视频时长
          this.aspectRatio_ = this.avPlayer.width / this.avPlayer.height; // 获取视频宽高比
          if (this.avPlayer.width >= this.avPlayer.height) { // 判断是横屏视频还是竖屏视频
            this.verticalVideo = false;
          } else {
            this.verticalVideo = true;
          }
          break;
        case 'playing':
          logger.info('state playing called');
          if (this.fileUrl !== this.selectedVideo) {
            this.isPlaying = false;
          }
          break;
        case 'paused':
          logger.info('state paused called');
          break;
        case 'completed':
          logger.info('state completed called');
          this.callbackComplete();
          break;
        case 'stopped':
          logger.info('state stopped called');
          break;
        case 'released':
          logger.info('state released called');
          break;
        case 'error':
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

  onChangeVideo() {
    this.isPlaying = this.selectedVideo === this.fileUrl;
  }

  changeOrientation() {
    // 获取UIAbility实例的上下文信息
    let context = getContext(this);
    // 调用该接口手动改变设备横竖屏状态（设置全屏模式，先强制横屏，再加上传感器模式）
    window.getLastWindow(context).then((lastWindow) => {
      if (this.isLandscapeStart) {
        // 设置窗口的布局是否为沉浸式布局
        lastWindow.setWindowLayoutFullScreen(true).then(() => {
          // 设置窗口全屏模式时导航栏、状态栏的可见模式
          lastWindow.setWindowSystemBarEnable([]);
          // 设置窗口的显示方向属性，AUTO_ROTATION_LANDSCAPE表示传感器自动横向旋转模式
          lastWindow.setPreferredOrientation(window.Orientation.AUTO_ROTATION_LANDSCAPE, () => {
            this.isLandscape = !this.isLandscape;
          });
        });
      } else {
        // 设置窗口的显示方向属性，UNSPECIFIED表示未定义方向模式，由系统判定
        lastWindow.setPreferredOrientation(window.Orientation.UNSPECIFIED, () => {
          // 设置窗口全屏模式时导航栏、状态栏的可见模式
          lastWindow.setWindowSystemBarEnable(WINDOW_SYSTEM_BAR).then(() => {
            // 设置窗口的布局是否为沉浸式布局
            lastWindow.setWindowLayoutFullScreen(false).then(() => {
              this.isLandscape = !this.isLandscape;
            });
          });
        });
      }
    });
  }

  // 倍速弹框
  @Builder
  speedPopup() {
    List({ space: SPEED_POPUP_LIST_SPACE }) {
      ForEach(AVPlayerConstants.SPEED_ARRAY, (item: speedObj) => {
        ListItem() {
          Row() {
            Text(item.text)
              .fontColor(Color.White)
              .fontSize($r('app.integer.video_screen_direction_switching_speed_popup_text_font'))
              .onClick(() => {
                if (this.isCreate) {
                  this.avPlayer.setSpeed(item.value);
                }
                this.speed = item.text;
                this.isSpeedShow = false;
              })
          }
          .padding({ left: $r('app.integer.video_screen_direction_switching_speed_popup_row_padding') })
          .width($r('app.string.video_screen_direction_switching_layout_100'))
          .height($r('app.integer.video_screen_direction_switching_speed_popup_row_height'))
        }
      }, (item: speedObj) => {
        return JSON.stringify(item);
      })
    }
    .width($r('app.integer.video_screen_direction_switching_speed_popup_list_width'))
    .padding($r('app.integer.video_screen_direction_switching_speed_popup_list_padding'))
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      Column() {
        XComponent({
          type: XComponentType.SURFACE,
          controller: this.xComponentController
        })
          .aspectRatio(this.aspectRatio_)
          .height(this.isLandscape ? $r('app.string.video_screen_direction_switching_layout_100') : 'auto')
          .width(this.isLandscape ? 'auto' : $r('app.string.video_screen_direction_switching_layout_100'))
          .onLoad(() => {
            this.surfaceID = this.xComponentController.getXComponentSurfaceId();
            this.init();
          })
      }
      .justifyContent(FlexAlign.Center)
      .width($r('app.string.video_screen_direction_switching_layout_100'))
      .height($r('app.string.video_screen_direction_switching_layout_100'))
      .layoutWeight(LAYOUT_WEIGHT)
      .backgroundColor(Color.Black)
      .zIndex(0)

      Flex({
        direction: FlexDirection.Column,
        justifyContent: (this.verticalVideo && !this.isLandscape) ? FlexAlign.End : FlexAlign.SpaceBetween
      }) {
        if (this.isLandscape) {
          Row() {
            Image($r('app.media.video_screen_direction_switching_ic_back1'))
              .width($r('app.integer.video_screen_direction_switching_video_icon_play_width'))
              .height($r('app.integer.video_screen_direction_switching_video_icon_play_height'))
              .margin({ right: $r('app.integer.video_screen_direction_switching_video_icon_play_margin') })
              .onClick(() => {
                this.isLandscapeStart = !this.isLandscapeStart;
              })
            Text(this.fileName)
              .textAlign(TextAlign.Start)
              .fontFamily($r('app.string.video_screen_direction_switching_harmony_hei_ti_medium'))
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .fontSize($r('app.integer.video_screen_direction_switching_video_name_font_size'))
              .fontColor(Color.White)
          }
          .padding($r('app.integer.video_screen_direction_switching_video_name_padding'))
          .width($r('app.string.video_screen_direction_switching_layout_100'))
        }

        if (!this.isPlaying && this.isLandscape && this.isCreate) {
          Row() {
            Image($r('app.media.video_screen_direction_switching_icon_pause'))
              .width($r('app.integer.video_screen_direction_switching_pause_width'))
              .height($r('app.integer.video_screen_direction_switching_pause_height'))
              .onClick(() => {
                this.isPlaying = !this.isPlaying;
              })
          }
          .width($r('app.string.video_screen_direction_switching_layout_100'))
          .justifyContent(FlexAlign.Center)
        }

        if (!this.verticalVideo && !this.isLandscape) {
          Row() {
            Button($r('app.string.video_screen_direction_switching_full_screen'))
              .fontSize($r('app.integer.video_screen_direction_switching_full_screen_font_size'))
              .backgroundColor($r('app.string.video_screen_direction_switching_full_screen_color'))
              .width($r('app.integer.video_screen_direction_switching_full_screen_width'))
              .height($r('app.integer.video_screen_direction_switching_full_screen_height'))
              .border({
                width: $r('app.integer.video_screen_direction_switching_full_screen_border'),
                radius: $r('app.string.video_screen_direction_switching_full_screen_border_radius'),
                color: Color.White
              })
              .onClick(() => {
                this.isLandscapeStart = !this.isLandscapeStart;
              })
          }
          .margin({ top: $r('app.integer.video_screen_direction_switching_full_screen_margin') })
          .width($r('app.string.video_screen_direction_switching_layout_100'))
          .justifyContent(FlexAlign.Center)
        }

        Column() {
          if (!this.isLandscape) {
            Text(this.fileName)
              .textAlign(TextAlign.Start)
              .fontFamily($r('app.string.video_screen_direction_switching_harmony_hei_ti_medium'))
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .fontSize($r('app.integer.video_screen_direction_switching_video_name_font_size'))
              .fontColor(Color.White)
              .padding({ left: $r('app.integer.video_screen_direction_switching_file_name_padding') })
              .width($r('app.string.video_screen_direction_switching_layout_100'))
          }
          Row() {
            if (this.isLandscape) {
              // 播放icon
              Image(this.isPlaying ? $r('app.media.video_screen_direction_switching_icon_play') :
              $r('app.media.video_screen_direction_switching_icon_pause'))
                .width($r('app.integer.video_screen_direction_switching_video_icon_play_width'))
                .height($r('app.integer.video_screen_direction_switching_video_icon_play_height'))
                .margin({
                  top: 0,
                  bottom: 0,
                  left: $r('app.integer.video_screen_direction_switching_video_icon_play_margin'),
                  right: $r('app.integer.video_screen_direction_switching_video_icon_play_margin')
                })
                .onClick(() => {
                  this.isPlaying = !this.isPlaying;
                })
            }
            // 时间轴
            Row() {
              if (this.isLandscape) {
                Text(getTimeString(this.currentTime))
                  .fontSize($r('app.integer.video_screen_direction_switching_current_time_font_size'))
                  .fontColor($r('app.color.video_screen_direction_switching_white_color'))
                  .fontWeight(FONT_WEIGHT)
                  .opacity(OPACITY)
              }
              Slider({
                value: Math.round(this.currentTime / this.totalDuration * 100)
              })
                .selectedColor(Color.White)
                .layoutWeight(LAYOUT_WEIGHT)
                .trackColor(Color.Gray)
                .onChange((value: number, mode: SliderChangeMode) => {
                  if (this.isCreate) {
                    this.currentTime = this.totalDuration * value / 100;
                    this.avPlayer.seek(this.currentTime);
                    if (mode === SliderChangeMode.Moving) {
                      if (this.avPlayer.state === AVPLAYER_PLAYING_STATE) {
                        this.getPause();
                      }
                    } else if (mode === SliderChangeMode.End) {
                      if (this.avPlayer.state === AVPLAYER_PAUSED_STATE && this.isPlaying) {
                        this.getPlay();
                      }
                    }
                  }
                })
              if (this.isLandscape) {
                Text(getTimeString(this.totalDuration))
                  .fontSize($r('app.integer.video_screen_direction_switching_duration_font_size'))
                  .fontColor($r('app.color.video_screen_direction_switching_white_color'))
                  .fontWeight(FONT_WEIGHT)
                  .opacity(OPACITY)
              }
            }
            .layoutWeight(LAYOUT_WEIGHT)
            .height($r('app.integer.video_screen_direction_switching_duration_row_height'))
            .hitTestBehavior(HitTestMode.Transparent) // 将组件的触摸测试类型设置为自身和子节点都响应触摸测试，不会阻塞兄弟节点的触摸测试，不会影响祖先节点的触摸测试。
            .responseRegion( // 设置多个触摸热区
              [
                {
                  x: 0,
                  y: 0,
                  width: $r('app.string.video_screen_direction_switching_layout_100'),
                  height: $r('app.string.video_screen_direction_switching_layout_100')
                },
                {
                  x: 0,
                  y: $r('app.string.video_screen_direction_switching_layout_negative_200'),
                  width: $r('app.string.video_screen_direction_switching_layout_100'),
                  height: $r('app.string.video_screen_direction_switching_layout_200')
                }
              ]
            )
            .gesture( // 设置拖动手势，将距离变量与进度条变量进行绑定计算
              PanGesture(new PanGestureOptions({
                direction: PanDirection.Left | PanDirection.Right
              }))
                .onActionStart(() => {
                  this.flagValue = this.currentTime;
                })
                .onActionUpdate((event?: GestureEvent) => {
                  if (event) {
                    if (this.isCreate) {
                      if (this.avPlayer.state === AVPLAYER_PLAYING_STATE) {
                        this.getPause();
                      }
                      this.currentTime =
                        (this.flagValue + this.totalDuration * (event.offsetX / 3) / 100) > this.totalDuration ?
                        this.totalDuration : (this.flagValue + this.totalDuration * (event.offsetX / 3) / 100);
                    }
                  }
                })
                .onActionEnd(() => {
                  if (this.isCreate) {
                    this.avPlayer.seek(this.currentTime);
                    if (this.avPlayer.state === AVPLAYER_PAUSED_STATE && this.isPlaying) {
                      this.getPlay();
                    }
                  }
                })
            )

            // 倍速icon
            Text(this.speed)
              .fontColor($r('app.string.video_screen_direction_switching_font_color'))
              .fontSize($r('app.integer.video_screen_direction_switching_speed_icon_font_size'))
              .fontFamily($r('app.string.video_screen_direction_switching_harmony_hei_ti_medium'))
              .margin($r('app.integer.video_screen_direction_switching_speed_icon_margin'))
              .onClick(() => {
                this.isSpeedShow = !this.isSpeedShow;
              })
              .bindPopup(this.isSpeedShow, {
                builder: this.speedPopup,
                placement: Placement.Top,
                popupColor: $r('app.string.video_screen_direction_switching_popup_color'),
                backgroundBlurStyle: BlurStyle.NONE
              })
          }
        }
        .width($r('app.string.video_screen_direction_switching_layout_100'))
      }
      .onClick(() => {
        if (!this.isLandscape) {
          this.isPlaying = !this.isPlaying;
        }
      })
      .width($r('app.string.video_screen_direction_switching_layout_100'))
      .height($r('app.string.video_screen_direction_switching_layout_100'))
      .zIndex(1)

      if (!this.isPlaying && !this.isLandscape && this.isCreate) {
        Row() {
          Image($r('app.media.video_screen_direction_switching_icon_pause'))
            .width($r('app.integer.video_screen_direction_switching_pause_width'))
            .height($r('app.integer.video_screen_direction_switching_pause_height'))
        }
        .width($r('app.string.video_screen_direction_switching_layout_100'))
        .height($r('app.string.video_screen_direction_switching_layout_100'))
        .justifyContent(FlexAlign.Center)
      }
    }
    .width($r('app.string.video_screen_direction_switching_video_width'))
    .height($r('app.string.video_screen_direction_switching_video_height'))
    .backgroundColor(Color.Black)
  }
}