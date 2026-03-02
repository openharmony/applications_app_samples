/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { avSession } from '@kit.AVSessionKit';
import { inputConsumer, KeyCode } from '@kit.InputKit';
import { VideoCastHeadView } from '../view/VideoCastHeadView';
import { IconButton, EpisodeChoose } from '../view/CommonView';
import { VideoCastController } from '../controller/VideoCastController';
import { VideoData } from '../model/VideoData';
import { VideoSessionController } from '../controller/VideoSessionController';
import { AVCastingControllerView } from '../view/AVCastingControllerView';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG = 'RemoteControlPage';

@Component
export struct RemoteControlPage {
  @StorageLink('avCastController') @Watch('avCastPlayerControllerChange') avCastPlayerController?:
    VideoCastController = undefined;
  @StorageLink('castingList') castingList: string[] = [];
  @StorageLink('avSessionController') avSessionController ?: VideoSessionController = undefined;
  @StorageLink('avplayerContinueTime') avplayerContinueTime: number = 0;
  @StorageLink('avplayerContinueIndex') avplayerContinueIndex: number = 0;
  @Link videoList: VideoData[];
  @Link @Watch('videoIndexChange') videoIndex: number;
  @Consume videoType: string;
  @State isEpisodeSheetShow: boolean = false;
  @State remoteControlPathStack: NavPathStack = new NavPathStack();
  @State videoEpisode: number[] = [];
  @State currentTime: number = 0;
  @State durationTime: number = this.videoList[this.videoIndex].duration;
  @State currentVolume: number = 0;
  @State @Watch('episodeChoose') episodeChooseIndex: number = 0;
  public avplayerTime: number = 0;

  videoIndexChange() {
    this.durationTime = this.videoList[this.videoIndex].duration;
  }

  episodeChoose() {
    this.avCastPlayerController?.setCastResource(this.episodeChooseIndex, 0);
  }

  avCastPlayerControllerChange() {
    if (this.avCastPlayerController) {
      this.currentTime = this.avCastPlayerController.elapsedTime;
      this.currentVolume = this.avCastPlayerController.volume;
      this.avplayerContinueTime = this.avCastPlayerController.elapsedTime;
      this.avplayerContinueIndex = this.avCastPlayerController.videoIndex;
      if (this.avCastPlayerController.videoIndex >= 0) {
        this.videoIndex = this.avCastPlayerController.videoIndex;
      }
    }
  }

  async aboutToAppear() {
    if (this.avSessionController && !this.avCastPlayerController) {
      let session = await this.avSessionController.videoSession.getAVCastController().catch((err: BusinessError)=>{
        if (err.code) {
          hilog.error(0x0000, TAG, 'testTag', 'get AVCast controller failed, cause: %{public}s', JSON.stringify(err));
        }
      });
      if (session) {
        this.avCastPlayerController = new VideoCastController(session);
        await this.avCastPlayerController.initAVCast(this.videoList,
                                                     this.videoIndex, this.videoType, this.avplayerTime);
      }
    }
    this.videoList.forEach((item, index: number) => {
      this.videoEpisode.push(index + 1);
    })
    // [Start inputConsumer]
    let upOptions: inputConsumer.KeyPressedConfig = {
      key: KeyCode.KEYCODE_VOLUME_UP,
      action: 1,
      isRepeat: true,
    }
    try {
      inputConsumer.on('keyPressed', upOptions, async () => {
        if (this.avCastPlayerController) {
          console.log('currentVolume' + JSON.stringify(this.currentVolume));
          let volume = this.currentVolume + 10;
          await this.avCastPlayerController.setAVCastVolume(volume);
        }
      })
    } catch (error) {
      let err = error as BusinessError
      if (err.code) {
        hilog.error(0x0000, TAG, 'testTag', 'set AVCast volume failed, cause: %{public}s', JSON.stringify(err));
      }
    }
    let downOptions: inputConsumer.KeyPressedConfig = {
      key: KeyCode.KEYCODE_VOLUME_DOWN,
      action: 1,
      isRepeat: true,
    }
    try {
      inputConsumer.on('keyPressed', downOptions, async () => {
        if (this.avCastPlayerController) {
          let volume = this.currentVolume - 10;
          if (volume < 0) {
            await this.avCastPlayerController.setAVCastVolume(0);
          }
          await this.avCastPlayerController.setAVCastVolume(volume);
        }
      })
    } catch (error) {
      let err = error as BusinessError
      if (err.code) {
        hilog.error(0x0000, TAG, 'testTag', 'set AVCast volume failed, cause: %{public}s', JSON.stringify(err));
      }
    }
    // [End inputConsumer]
  }

  aboutToDisappear(): void {
    try {
      inputConsumer.off('keyPressed');
    } catch (error) {
      let err = error as BusinessError
      if (err.code) {
        hilog.error(0x0000, TAG, 'testTag', 'input consume failed, cause: %{public}s', JSON.stringify(err));
      }
    }
  }

  @Builder
  myBuilder() {
    Column() {
      EpisodeChoose({
        numberTest: this.videoEpisode,
        videoIndex: this.videoIndex,
        episodeChooseIndex: this.episodeChooseIndex
      })
    }
    .padding({
      top: 16,
      left: 16,
      right: 16,
      bottom: 112
    })
  }

  build() {
    NavDestination() {
      Column() {
        VideoCastHeadView({ path: this.remoteControlPathStack })
        Column() {
          Column() {
            Text(this.videoList[this.videoIndex].name)
              .fontColor(Color.White)
              .fontSize(20)
              .fontWeight(500)
              .margin({
                bottom: 4
              })
            Text($r('app.string.episode', JSON.stringify(this.videoIndex + 1)))
              .fontColor(Color.White)
              .fontSize(20)
              .fontWeight(500)
          }
          .margin({
            bottom: 78
          })

          RelativeContainer() {
            Column()
              .width(232)
              .height(232)
              .borderRadius(116)
              .backgroundColor('rgba(255,255,255,0.1)')
            Column()
              .width(92)
              .height(92)
              .borderRadius(46)
              .backgroundColor('rgba(255,255,255,0.1)')
              .alignRules({
                top: { anchor: '__container__', align: VerticalAlign.Center },
                left: { anchor: '__container__', align: HorizontalAlign.Center },
              })
              .offset({
                x: -46,
                y: -46
              })
            SymbolGlyph(this.avCastPlayerController?.state === avSession.PlaybackState.PLAYBACK_STATE_PLAY ?
            $r('sys.symbol.pause_fill') : $r('sys.symbol.play_fill'))
              .fontSize(40)
              .width(40)
              .height(40)
              .fontColor([Color.White])
              .alignRules({
                bottom: { anchor: '__container__', align: VerticalAlign.Center },
                right: { anchor: '__container__', align: HorizontalAlign.Center },
              })
              .offset({
                x: 20,
                y: 20
              })
              .onClick(() => {
                if (!this.avCastPlayerController) {
                  return;
                }
                if (this.avCastPlayerController.state === avSession.PlaybackState.PLAYBACK_STATE_PLAY) {
                  this.avCastPlayerController.setAVCastPause();
                } else {
                  this.avCastPlayerController.setAVCastPlay();
                }
              })
            SymbolGlyph($r('sys.symbol.speaker_wave_1_fill'))
              .fontSize(40)
              .width(40)
              .height(40)
              .fontColor([Color.White])
              .alignRules({
                bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
                left: { anchor: '__container__', align: HorizontalAlign.Center },
              })
              .offset({
                x: -20,
                y: -19
              })
              .onClick(() => {
                this.avCastPlayerController!.setAVCastVolume(this.currentVolume - 10);
              })
            SymbolGlyph($r('sys.symbol.speaker_wave_3_fill'))
              .fontSize(32)
              .fontColor([Color.White])
              .width(40)
              .height(40)
              .alignRules({
                top: { anchor: '__container__', align: VerticalAlign.Top },
                left: { anchor: '__container__', align: HorizontalAlign.Center },
              })
              .offset({
                x: -20,
                y: 19
              })
              .onClick(() => {
                this.avCastPlayerController!.setAVCastVolume(this.currentVolume + 10);
              })
            SymbolGlyph($r('sys.symbol.backward_fill'))
              .fontSize(32)
              .fontColor([Color.White])
              .width(40)
              .height(40)
              .alignRules({
                top: { anchor: '__container__', align: VerticalAlign.Center },
                left: { anchor: '__container__', align: HorizontalAlign.Start },
              })
              .offset({
                x: 19,
                y: -20
              })
              .onClick(() => {
                this.avCastPlayerController!.setAVCastRewind();
              })
            SymbolGlyph($r('sys.symbol.fast_forward'))
              .fontSize(32)
              .fontColor([Color.White])
              .width(32)
              .height(32)
              .alignRules({
                top: { anchor: '__container__', align: VerticalAlign.Center },
                right: { anchor: '__container__', align: HorizontalAlign.End },
              })
              .offset({
                x: -19,
                y: -16
              })
              .onClick(() => {
                this.avCastPlayerController!.setAVCastFastForward();
              })
          }
          .margin({
            bottom: 50
          })
          .width(232)
          .height(232)
        }
        .justifyContent(FlexAlign.Center)
        .layoutWeight(1)
        .width('100%')

        Row() {
          Column() {
            IconButton({ iconResource: $r('sys.symbol.satellite_map_fill') })
              .margin({
                bottom: 4
              })
            Text($r('app.string.episode_choose'))
              .fontSize(12)
              .fontColor(Color.White)
          }
          .width(40)
          .onClick(() => {
            this.isEpisodeSheetShow = true;
          })
          .bindSheet($$this.isEpisodeSheetShow, this.myBuilder(), {
            height: SheetSize.FIT_CONTENT,
            title: { title: $r('app.string.episode_choose') },
            backgroundColor: $r('sys.color.comp_background_primary'),
          })

          Blank()
          Column() {
            IconButton({ iconResource: $r('sys.symbol.forward_end_fill') })
              .margin({
                bottom: 4
              })
            Text($r('app.string.next'))
              .fontSize(12)
              .fontColor(Color.White)
          }
          .width(40)
          .onClick(() => {
            if (this.videoIndex < this.videoList.length - 1) {
              this.avCastPlayerController?.setCastResource(this.videoIndex + 1, 0)
            } else {
              this.avCastPlayerController?.setCastResource(0, 0)
            }
          })
        }
        .width('100%')
        .margin({
          bottom: 24
        })

        AVCastingControllerView({ isShowPlaying: false, durationTime: this.durationTime })
      }
      .padding({
        left: 16,
        right: 16
      })
      .width('100%')
      .height('100%')
    }
    .focusable(true)
    .backgroundImage(this.videoList[this.videoIndex].head)
    .backgroundImageSize(ImageSize.Cover)
    .backgroundBlurStyle(BlurStyle.Thin)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .hideTitleBar(true)
    .onReady((context: NavDestinationContext) => {
      this.remoteControlPathStack = context.pathStack;
    })
  }
}