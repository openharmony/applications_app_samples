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

// [Start xcomponent_av_player]
// xxx.ets
import { window } from '@kit.ArkUI';
import { AVPlayerController } from '../avplayertool/AVPlayerController';
import { emitter } from '@kit.BasicServicesKit';
import { CommonConstants, VideoDataType } from  '../common/constants/CommonConstants';
import { VideoData } from '../model/VideoData';
import { common } from '@kit.AbilityKit';

// [Start av_player_xcomponent_controller]
class VideoXComponentController extends XComponentController {
  private avPlayerController: AVPlayerController;

  constructor(avPlayerController: AVPlayerController) {
    super();
    this.avPlayerController = avPlayerController;
  }

  onSurfaceCreated(surfaceId: string): void {
    let source: VideoData = {
      type: VideoDataType.RAW_FILE,
      videoSrc: 'videoTest.mp4'
    };
    // 将surfaceId和视频源信息传递给AVPlayer
    this.avPlayerController.initAVPlayer(source, surfaceId);
  }
}
// [End av_player_xcomponent_controller]

const MINUTE_UNIT = 60000;
const SECOND_UNIT = 1000;
const SECOND_TEN = 10;
function timeCover(time: number): string {
  let min: number = Math.floor(time / MINUTE_UNIT);
  let second: string = ((time % MINUTE_UNIT) / SECOND_UNIT).toFixed(0);
  return `${min}:${(Number(second) < SECOND_TEN ? '0' : '') + second}`;
}

@Entry
@Component
struct XComponentAVPlayer {
  // 设置视频控制器，可以控制视频的播放状态。
  @State avPlayerController: AVPlayerController = new AVPlayerController(this.getUIContext().getHostContext()!);
  // 视频的总时长。
  @State durationTime: number = 0;
  // 视频当前进度。
  @State currentTime: number = 0;
  // 判断视频是否暂停播放。
  @State isPause: boolean = true;
  // 判断视频是否全屏播放。
  @State isLayoutFullScreen: boolean = false;
  // 设置XComponent组件控制器。
  private videoXComponentController: XComponentController = new VideoXComponentController(this.avPlayerController);
  // 判断窗口是否横屏。
  @State isLandScape: boolean = false;
  // 系统导航栏的标识。
  private WINDOW_SYSTEM_BAR: Array<'status' | 'navigation'> = ['navigation', 'status'];
  // 窗口宽度。
  @State windowWidth:number = 0;
  // 窗口高度。
  @State windowHeight: number = 0;
  // 窗口实例。
  private windowClass: window.Window | null = null;

  // 获取窗口实例。
  getWindow(): window.Window {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    return context.windowStage!.getMainWindowSync();
  }

  aboutToAppear(): void {
    this.windowClass = this.getWindow();
    let properties = this.windowClass.getWindowProperties();
    let context = this.getUIContext();
    this.windowWidth = context.px2vp(properties.windowRect.width);
    this.windowHeight = context.px2vp(properties.windowRect.height);
    // 获取窗口横竖屏状态及其尺寸。
    this.windowClass.on('windowSizeChange', (size: window.Size) => {
      this.isLandScape = size.width > size.height;
      this.windowWidth = context.px2vp(size.width);
      this.windowHeight = context.px2vp(size.height);
    })
    emitter.on(CommonConstants.AVPLAYER_PREPARED, (res) => {
      if (res.data) {
        this.durationTime = this.avPlayerController.durationTime;
        // 更新视频进度时间。
        setInterval(() => {
          this.currentTime = this.avPlayerController.currentTime;
        }, 1000);
      }
    });
  }

  // 设置沉浸式窗口。
  setFullScreen(isLayoutFullScreen: boolean) {
    window.getLastWindow(this.getUIContext().getHostContext()).then((win) => {
      if (isLayoutFullScreen) {
        // 设置窗口全屏模式时导航栏、状态栏的可见模式。
        win.setWindowSystemBarEnable([]);
      } else {
        // 设置窗口非全屏模式时导航栏、状态栏的可见模式。
        win.setWindowSystemBarEnable(this.WINDOW_SYSTEM_BAR);
      }
    }).catch((err: string) => {
      console.error(`setFullScreen failed, message is ${err}`);
    });
  }

  build() {
    Column() {
      Stack() {
        // [Start av_player_create_xcomponent]
        XComponent({ type: XComponentType.SURFACE, controller: this.videoXComponentController })
        // [End av_player_create_xcomponent]
        Column() {
          Blank()
          Column() {
            Column() {
              Row() {
                Row() {
                  // 设置视频播放或暂停的按钮。
                  SymbolGlyph(this.isPause ? $r('sys.symbol.pause') : $r('sys.symbol.play_fill'))
                    .fontSize(30)
                    .fontWeight(FontWeight.Bolder)
                    .fontColor([Color.White])
                    .onClick(() => {
                      if (this.isPause) {
                        this.avPlayerController.videoPause();
                      } else {
                        this.avPlayerController.videoPlay();
                      }
                      this.isPause = !this.isPause;
                    })
                  // 视频当前进度。
                  Text(timeCover(this.currentTime))
                    .fontColor(Color.White)
                    .textAlign(TextAlign.End)
                    .fontWeight(FontWeight.Regular)
                    .margin({ left: 5 })
                }
                Row() {
                  // 视频进度条。
                  Slider({
                    value: this.currentTime,
                    min: 0,
                    max: this.durationTime,
                    style: SliderStyle.OutSet
                  })
                    .id('Slider')
                    .blockColor(Color.White)
                    .trackColor(Color.Gray)
                    .selectedColor('#317af7')
                    .showTips(false)
                    .onChange((value: number, mode: SliderChangeMode) => {
                      if (mode === SliderChangeMode.Begin) {
                        this.avPlayerController.videoPause();
                      }
                      this.avPlayerController.videoSeek(value);
                      this.currentTime = value;
                      if (mode === SliderChangeMode.End) {
                        this.isPause = true;
                        this.avPlayerController.videoPlay();
                      }
                    })
                }
                .layoutWeight(1)
                Row() {
                  // 视频的总时长。
                  Text(timeCover(this.durationTime))
                    .fontColor(Color.White)
                    .fontWeight(FontWeight.Regular)
                    .margin({ right: 5 })
                }
                Row() {
                  // 设置是否全屏播放的按钮。
                  SymbolGlyph(this.isLayoutFullScreen ? $r('sys.symbol.arrow_down_right_and_arrow_up_left') : $r('sys.symbol.arrow_up_left_and_arrow_down_right'))
                    .fontSize(30)
                    .fontWeight(FontWeight.Bolder)
                    .fontColor([Color.White])
                    .onClick(()=> {
                      this.isLayoutFullScreen = !this.isLayoutFullScreen;
                      this.setFullScreen(this.isLayoutFullScreen);
                    })
                }
              }
              .justifyContent(FlexAlign.Center)
              .padding({ left: 12, right: 20, bottom: 28 })
              .width('100%')
            }
            .backgroundColor(Color.Black)
          }
          .justifyContent(FlexAlign.Center)
        }
        .width('100%')
        .height('100%')
      }
      .height(this.isLayoutFullScreen ? this.windowHeight : 300)
      .width(this.isLayoutFullScreen ? this.windowWidth : 300)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}
// [End xcomponent_av_player]