/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import { avSession } from '@kit.AVSessionKit';
import control from '../feature/MediaController';
import Log from '../common/Logger';

const TAG: string = 'PresentPage';

@Entry
@Component
struct PresentPage {
  controller = new control();
  @State isShowQueue: boolean = false;
  @StorageLink('currentController') currentController: avSession.AVSessionController | undefined = undefined;
  @StorageLink('metaData') metaData: avSession.AVMetadata | undefined = undefined;
  @StorageLink('playbackState') playbackState: avSession.PlaybackState = avSession.PlaybackState.PLAYBACK_STATE_PAUSE;
  @StorageLink('queueItems') queueItems: avSession.AVQueueItem[] | undefined = undefined;
  @StorageLink('isSupportedLyric') isSupportedLyric: boolean = false;
  @StorageLink('isLyricVisible') isLyricVisible: boolean = false;
  @StorageLink('validCommands') @Watch('changeCallback') validCommands: avSession.AVControlCommandType[] | undefined = undefined;
  @State canPlay: boolean = false; // 媒体会话是否支持播放。
  @State canPause: boolean = false; // 媒体会话是否支持暂停。
  @State canNext: boolean = false; // 媒体会话是否支持下一首。
  @State canPrevious: boolean = false; // 媒体会话是否支持上一首。

  async aboutToAppear() {
    await this.controller.startControl();
  }

  aboutToDisappear() {
    this.controller.stopControl();
  }

  // [Start commands]
  changeCallback() {
    this.canPlay = !!this.validCommands?.includes('play');
    this.canPause = !!this.validCommands?.includes('pause');
    this.canNext = !!this.validCommands?.includes('playNext');
    this.canPrevious = !!this.validCommands?.includes('playPrevious');
  }

  @Builder
  commandBuild() {
    Image($r('app.media.previous'))
      .width('24vp').height('24vp')
      .id('Previous')
      .onClick(async () => {
        if (this.canPrevious) {
          let command: avSession.AVControlCommand = {
            command: 'playPrevious', // 上一首指令。
          }
          await this.currentController?.sendControlCommand(command);
          Log.info(TAG, 'on previous click');
        }
      })
    Image(this.playbackState == avSession.PlaybackState.PLAYBACK_STATE_PLAY ? $r('app.media.stopmusic') : $r('app.media.playmusic'))
      .width('24vp')
      .height('24vp')
      .id('PlayOrPause:')
      .onClick(async () => {
        if (this.playbackState == avSession.PlaybackState.PLAYBACK_STATE_PLAY) {
          if (this.canPause) {
            let command: avSession.AVControlCommand = {
              command: 'pause', // 暂停指令。
            }
            await this.currentController?.sendControlCommand(command);
          }
        } else {
          if (this.canPlay) {
            let command: avSession.AVControlCommand = {
              command: 'play', // 播放指令。
            }
            await this.currentController?.sendControlCommand(command);
          }
        }
        Log.info(TAG, 'on play/pause click');
      })
    Image($r('app.media.next'))
      .width('24vp').height('24vp')
      .id('Next')
      .onClick(async () => {
        if (this.canNext) {
          let command: avSession.AVControlCommand = {
            command: 'playNext', // 下一首指令。
          }
          await this.currentController?.sendControlCommand(command);
          Log.info(TAG, 'on next click ');
        }
      })
  }
  // [End commands]

  build() {
    Stack() {
      Column() {
        Stack({ alignContent: Alignment.TopStart }) {
          Column() {}
          .width('100%')
          .height('100%')
          .backgroundColor('#99ffffff')
          .zIndex(1)
          .borderRadius('16vp')
          .id('FirstPanel')

          Column() {
            Row() {
              Image(this.metaData?.mediaImage || $r('app.media.no_music'))
                .width('48vp')
                .height('48vp')
                .id('CurrentImage')
              Column() {
                Text(this.metaData?.title || $r('app.string.not_in_play'))
                  .fontSize('16fp')
                  .fontColor('#182431')
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .width('228vp')
                  .id('Title')
                Text(this.metaData?.artist || $r('app.string.not_in_play'))
                  .fontSize('14fp')
                  .fontColor('#182431')
                  .opacity(0.6)
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .width('228vp')
                  .id('Artist')
              }
              .margin({ left: '12vp' })
              .alignItems(HorizontalAlign.Start)
            }
            .justifyContent(FlexAlign.Start)
            .width('100%')
            .margin({ top: '12vp' })

            Row() {
              Image(this.isShowQueue ? $r('app.media.list_activate') : $r('app.media.list_none'))
                .width('24vp')
                .height('24vp')
                .id('ShowQueue')
                .onClick(() => {
                  this.isShowQueue = !this.isShowQueue;
                  Log.info(TAG, 'isShowQueue set to : ' + this.isShowQueue);
                })

              this.commandBuild();

              Image(this.isLyricVisible ? $r('app.media.list_activate') : $r('app.media.lyric_none'))
                .width('24vp')
                .height('24vp')
                .id('Lyric')
                .onClick(async () => {
                  if (this.isSupportedLyric) {
                    await this.currentController?.setDesktopLyricVisible(!this.isLyricVisible); // 设置当前会话桌面歌词的显示状态。
                  }
                  Log.info(TAG, 'set DesktopLyric Visible' + this.isLyricVisible);
                })
            }
            .justifyContent(FlexAlign.SpaceBetween)
            .margin({ left: '12vp', right: '12vp', top: '20vp', bottom: '12vp' })
            .width('264vp')
            .height('24vp')

            Row() {
              Text($r('app.string.not_in_play'))
                .id('LyricText')
                .fontColor('#182431')
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            }
            .width('264vp')
            .height('20vp')
            .margin({ top: '12vp', bottom: '12vp', left: '12vp', right: '12vp' })

            .alignItems(VerticalAlign.Center)
            .justifyContent(FlexAlign.Center)
            .visibility(this.isLyricVisible ? Visibility.Visible : Visibility.None)
          }
          .width('288vp')
          .height('100%')
          .zIndex(2)
          .margin({ top: '4vp', bottom: '4vp', left: '12vp', right: '12vp' })
        }
        .width('312vp')
        .height(this.getMediaCardHeight())
        .margin({ top: '40vp' })

        Stack() {
          Column() {
          }
          .width('100%')
          .height('153vp')
          .backgroundColor('#99ffffff')
          .zIndex(1)
          .borderRadius('24vp')

          Column() {
            Column() {
              Text(this.queueItems?.[0]?.description?.title || 'queue null')
                .fontSize('16fp')
                .fontColor('#182431')
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            }
            .alignItems(HorizontalAlign.Start)
            .height('48vp')
            .justifyContent(FlexAlign.Center)
            .width('100%')
            .id('FirstMusicInQueue')

            Divider()
              .height('0.5vp')
              .opacity(0.05)
              .color('#182431')
              .width('100%')

            Column() {
              Text(this.queueItems?.[1]?.description?.title || 'queue null')
                .fontSize('16fp')
                .fontColor('#182431')
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            }
            .alignItems(HorizontalAlign.Start)
            .height('48vp')
            .justifyContent(FlexAlign.Center)
            .width('100%')
            .id('SecondMusicInQueue')

            Divider()
              .height('0.5vp')
              .opacity(0.05)
              .color('#182431')
              .width('100%')

            Column() {
              Text(this.queueItems?.[2]?.description?.title || 'queue null')
                .fontSize('16fp')
                .fontColor('#182431')
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            }
            .alignItems(HorizontalAlign.Start)
            .height('48vp')
            .justifyContent(FlexAlign.Center)
            .width('100%')
            .id('ThirdMusicInQueue')
          }
          .width('288vp')
          .height('144vp')
          .id('SecondPanel')
          .zIndex(2)
          .alignItems(HorizontalAlign.Start)
          .margin({ top: '4vp', bottom: '4vp', left: '12vp', right: '12vp' })
        }
        .width('312vp')
        .height('153vp')
        .margin({ top: '12vp' })
        .visibility(this.isShowQueue ? Visibility.Visible : Visibility.None)
      }
      .height(this.getTotalHeight())
      .width('312vp')
      .margin({ top: '40vp', left: '24vp', right: '24vp' })
      .backgroundColor('#00000000')
    }
    .backgroundImage($r('app.media.background'))
    .backgroundImageSize(ImageSize.Cover)
    .alignContent(Alignment.Top)
    .width('100%')
    .height('100%')
  }

  getMediaCardHeight(): string {
    let mediaNum: number = 1; // only has one session
    let mediaExtraHeight: number = ((mediaNum - 1) > 0 ? 12 : 0) + (mediaNum - 1) * 73; // 73 is the length given from UX designer
    let height: number = 124 + (this.isLyricVisible ? 44 : 0) + mediaExtraHeight; // 124 and 44 is the size given from UX designer
    Log.info(TAG, 'get height : ' + height);
    return String(height) + 'vp';
  }

  getTotalHeight(): string {
    let mediaNum: number = 1; // only has one session
    let mediaExtraHeight: number = ((mediaNum - 1) > 0 ? 12 : 0) + (mediaNum - 1) * 73; // 73 is the length given from UX designer
    let height: number = 124 + (this.isLyricVisible ? 44 : 0) + mediaExtraHeight; // 124 and 44 is the length given from UX designer
    Log.info(TAG, 'get media height : ' + height);
    height += (this.isShowQueue ? 165 : 0); // 165 is the length given from UX designer
    Log.info(TAG, 'get total height : ' + height);
    return (height + 40) + 'vp';
  }
}
