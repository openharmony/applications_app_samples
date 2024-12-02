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
import { getTimeString } from '../util/TimeTools';
import resourceManager from '@ohos.resourceManager';
import { logger } from '../util/Logger';

// 倍速对象
interface speedObj {
  text: string,
  value: number
};

const WINDOW_SYSTEM_BAR: ('status' | 'navigation')[] = ['navigation', 'status'];
const ASPECT_RATIO: number = 1.77777778; // 元素宽高比
const LAYOUT_WEIGHT: number = 1; // 自动分配剩余空间
const VIDEO_Z_INDEX: number = 100; // 组件zIndex
const ANIMATE_DURATION: number = 400; // 动画持续时间
const TIMEOUT_DURATION: number = 200; // 计时器时间
const SPEED_POPUP_LIST_SPACE: number = 20;


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
export struct XVideoComponent {
  @State currentTime: number = 0; // 视频当前时间
  @State totalDuration: number = 0; // 视频总时长
  @State @Watch('onChangePlay') isPlaying: boolean = false; // 是否播放状态
  @Link @Watch('changeOrientation') isLandscape: boolean; // 是否横屏状态
  @State isSpeedShow: boolean = false; // 是否倍速状态
  @State speed: string = '1.0x'; // 倍速大小
  @Link maskShow: boolean; // 遮罩层是否显示
  @Link @Watch('createOrFinish') fileName: string; // 视频名称
  @State isFullScreen: boolean = false; // 是否全屏状态
  @Prop videoLocation: Area; // 视频在屏幕中的位置信息
  @State systemHeight: number = 0; // 系统状态栏高度
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
      logger.info('completed state called')
      this.isPlaying = !this.isPlaying
    });
    // 时间上报函数
    this.setTimeUpdateCallback((time) => {
      this.currentTime = time
    });
  }

  aboutToDisappear() {
    this.release();
    this.isLandscape = false;
  }

  // 初始化AVPlayer
  async init(): Promise<void> {
    await this.release();
    const context = getContext(this);
    // 获取fdSrc用于注册AVPlayer
    context.resourceManager.getRawFd(this.fileName).then(async (value: resourceManager.RawFileDescriptor) => {
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

  // 创建或注销AVPlayer
  createOrFinish(): void {
    if (this.fileName !== '') {
      this.init();
    } else {
      this.getStop();
      this.release();
    }
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
      this.avPlayer.play();
    }
  }

  getPause() {
    if (this.isCreate) {
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
        case 'idle':
          this.release();
          logger.info('state idle called');
          break;
        case 'initialized':
          logger.info('state initialized called');
          this.setSurfaceID();
          this.avPlayer.prepare();
          break;
        case 'prepared':
          logger.info('state prepared called');
          this.isPlaying = true;
          this.totalDuration = this.avPlayer.duration;
          this.getPlay();
          // 设置全屏播放展开动画
          animateTo({
            duration: ANIMATE_DURATION,
            onFinish: () => {
              this.isLandscape = !this.isLandscape; // 设置横屏
            }
          }, () => {
            this.isFullScreen = !this.isFullScreen;
          });
          break;
        case 'playing':
          logger.info('state playing called');
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
          logger.info('state error called');
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

  changeOrientation() {
    // 获取UIAbility实例的上下文信息
    let context = getContext(this);
    // 调用该接口手动改变设备横竖屏状态（设置全屏模式，先强制横屏，再加上传感器模式）
    window.getLastWindow(context).then((lastWindow) => {
      if (this.isLandscape) {
        // 设置窗口的布局是否为沉浸式布局
        lastWindow.setWindowLayoutFullScreen(true).then(() => {
          // 设置窗口全屏模式时导航栏、状态栏的可见模式
          lastWindow.setWindowSystemBarEnable([]);
          // 设置窗口的显示方向属性，AUTO_ROTATION_LANDSCAPE表示传感器自动横向旋转模式
          lastWindow.setPreferredOrientation(window.Orientation.AUTO_ROTATION_LANDSCAPE);
        });
      } else {
        // 设置窗口的显示方向属性，UNSPECIFIED表示未定义方向模式，由系统判定
        lastWindow.setPreferredOrientation(window.Orientation.UNSPECIFIED, () => {
          // 设置窗口全屏模式时导航栏、状态栏的可见模式
          lastWindow.setWindowSystemBarEnable(WINDOW_SYSTEM_BAR).then(() => {
            setTimeout(() => {
              // 设置退出全屏动画
              animateTo({
                duration: ANIMATE_DURATION,
                onFinish: () => {
                  this.fileName = '';
                  this.maskShow = false;
                }
              }, () => {
                this.isFullScreen = !this.isFullScreen;
              });
            }, TIMEOUT_DURATION);
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
              .fontColor('rgba(255,255,255,0.90)')
              .fontSize($r('app.integer.media_full_screen_speed_popup_text_font'))
              .onClick(() => {
                if (this.isCreate) {
                  this.avPlayer.setSpeed(item.value);
                }
                this.speed = item.text;
                this.isSpeedShow = false;
              })
          }
          .padding({ left: $r('app.integer.media_full_screen_speed_popup_row_padding') })
          .width($r('app.string.media_full_screen_layout_100'))
          .height($r('app.integer.media_full_screen_speed_popup_row_height'))
        }
      }, (item: speedObj) => {
        return JSON.stringify(item);
      })
    }
    .width($r('app.integer.media_full_screen_speed_popup_list_width'))
    .padding($r('app.integer.media_full_screen_speed_popup_list_padding'))
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      Column() {
        XComponent({
          type: XComponentType.SURFACE,
          controller: this.xComponentController
        })
          .width($r('app.string.media_full_screen_layout_100'))
          .aspectRatio(ASPECT_RATIO)
          .onLoad(() => {
            this.surfaceID = this.xComponentController.getXComponentSurfaceId();
          })
      }
      .borderRadius(this.isFullScreen ? 0 : {
        topLeft: $r('app.integer.media_full_screen_video_border_radius'),
        topRight: $r('app.integer.media_full_screen_video_border_radius')
      })
      .justifyContent(FlexAlign.Center)
      .width($r('app.string.media_full_screen_layout_100'))
      .height($r('app.string.media_full_screen_layout_100'))
      .aspectRatio(this.isFullScreen ? -1 : ASPECT_RATIO)
      .layoutWeight(LAYOUT_WEIGHT)
      .backgroundColor(Color.Black)
      .zIndex(0)

      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween }) {
        Text(this.fileName)
          .textAlign(TextAlign.Start)
          .fontFamily($r('app.string.media_full_screen_harmony_hei_ti_medium'))
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .fontSize($r('app.integer.media_full_screen_video_name_font_size'))
          .fontColor(Color.White)
          .padding($r('app.integer.media_full_screen_video_name_padding'))
          .width($r('app.string.media_full_screen_layout_100'))

        Row() {
          // 播放icon
          Image(this.isPlaying ? $r('app.media.media_full_screen_icon_play') :
          $r('app.media.media_full_screen_icon_pause'))
            .width($r('app.integer.media_full_screen_video_icon_play_width'))
            .height($r('app.integer.media_full_screen_video_icon_play_height'))
            .margin({
              top: 0,
              bottom: 0,
              left: $r('app.integer.media_full_screen_video_icon_play_margin'),
              right: $r('app.integer.media_full_screen_video_icon_play_margin')
            })
            .onClick(() => {
              this.isPlaying = !this.isPlaying
            })
          // 时间轴
          Row() {
            Text(getTimeString(this.currentTime))
              .fontSize($r('app.integer.media_full_screen_current_time_font_size'))
              .fontColor($r('app.color.media_full_screen_white_color'))
              .fontWeight(500)
              .opacity(0.6)
            Slider({
              value: Math.round(this.currentTime / this.totalDuration * 100)
            })
              .selectedColor(Color.White)
              .layoutWeight(1)
              .trackColor(Color.Gray)
              .onChange((value: number) => {
                if (this.isCreate) {
                  this.currentTime = this.totalDuration * value / 100;
                  this.avPlayer.seek(this.currentTime);
                }
              })
            Text(getTimeString(this.totalDuration))
              .fontSize($r('app.integer.media_full_screen_duration_font_size'))
              .fontColor($r('app.color.media_full_screen_white_color'))
              .fontWeight(500)
              .opacity(0.6)
          }
          .layoutWeight(1)
          .height($r('app.integer.media_full_screen_duration_row_height'))

          // 全屏icon
          Image($r('app.media.media_full_screen_icon_large'))
            .width($r('app.integer.media_full_screen_icon_large_width'))
            .height($r('app.integer.media_full_screen_icon_large_height'))
            .margin({
              top: 0,
              bottom: 0,
              left: $r('app.integer.media_full_screen_icon_large_margin'),
              right: $r('app.integer.media_full_screen_icon_large_margin')
            })
            .opacity(0.6)
            .onClick(() => {
              this.isLandscape = !this.isLandscape;
            })
          // 倍速icon
          Text(this.speed)
            .fontColor('rgba(255,255,255,0.90)')
            .fontSize($r('app.integer.media_full_screen_speed_icon_font_size'))
            .fontFamily($r('app.string.media_full_screen_harmony_hei_ti_medium'))
            .margin($r('app.integer.media_full_screen_speed_icon_margin'))
            .onClick(() => {
              this.isSpeedShow = !this.isSpeedShow;
            })
            .bindPopup(this.isSpeedShow, {
              builder: this.speedPopup,
              placement: Placement.Top,
              popupColor: 'rgba(0,0,0,0.6)'
            })
        }
      }
      .visibility(this.isFullScreen ? Visibility.Visible : Visibility.None)
      .width($r('app.string.media_full_screen_layout_100'))
      .height($r('app.string.media_full_screen_layout_100'))
      .zIndex(1)
    }
    .visibility(this.fileName !== '' ? Visibility.Visible : Visibility.None)
    .width(this.isFullScreen ? $r('app.string.media_full_screen_video_width') : this.videoLocation.width)
    .height($r('app.string.media_full_screen_video_height'))
    .aspectRatio(this.isFullScreen ? -1 : ASPECT_RATIO)
    .position(this.isFullScreen ? { x: 0, y: 0 } : {
      x: this.videoLocation.globalPosition.x,
      y: (this.videoLocation.globalPosition.y as number) - this.systemHeight
    })
    .zIndex(VIDEO_Z_INDEX)
  }
}