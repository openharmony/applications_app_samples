/*
* Copyright (C) 2023 Huawei Device Co., Ltd.
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

import AVSessionManager from '@ohos.multimedia.avsession';
import common from '@ohos.app.ability.common';
import control from '../feature/MediaController';
import Log from '../common/Logger';

const TAG: string = 'PresentPage';

@Entry
@Component
struct PresentPage {
  @State
  isShowQueue: boolean = false;
  @StorageLink('isLyric')
  isLyric: boolean = false;
  @StorageLink('item')
  itemShow: Array<AVSessionManager.AVQueueItem> = new Array;
  @StorageLink('history')
  history: Array<AVSessionManager.AVSessionDescriptor> = new Array();
  @StorageLink('isPlaying')
  isPlaying: boolean = false;
  controller = new control();
  @StorageLink('metaDataMap')
  @Watch('onMetaDataChangeCallback')
  private metaDataMap: Map<string, AVSessionManager.AVMetadata> = new Map();
  @StorageLink('playStateMap')
  private playStateMap: Map<string, AVSessionManager.AVMetadata> = new Map();
  @StorageLink('queueTitleMap')
  private queueTitleMap: Map<string, string> = new Map();
  @StorageLink('queueItemsMap')
  private queueItemsMap: Map<string, Array<AVSessionManager.AVQueueItem>> = new Map();
  @StorageLink('lyricMap')
  private lyricMap: Map<string, string> = new Map();
  @StorageLink('bundleNameMap')
  private bundleNameMap: Map<string, string> = new Map();
  @StorageLink('sessionArray')
  private sessionArray: Array<string> = new Array();

  async aboutToAppear() {
    await this.controller.initLink();
    await this.controller.startControl();
  }

  onMetaDataChangeCallback() {
    Log.info(TAG, 'metadatachange check metadatamap: ' + JSON.stringify(this.metaDataMap));
    Log.info(TAG, 'metadatachange check sessionarray: ' + JSON.stringify(this.sessionArray![0]));
  }

  build() {
    Stack() {
      Image('#00000000')
        .width('100%')
        .height('100%')
        .onTouch((event?: TouchEvent) => {
          if (event !== undefined && event.type == TouchType.Down) {
            Log.info(TAG, 'touch down img, terminate self sss');
            let context: common.UIAbilityContext | undefined = AppStorage.get<common.UIAbilityContext>('context')
            context!.terminateSelf()
          }
        })
      Column() {
        Stack({ alignContent: Alignment.TopStart }) {
          Column() {
          }
          .width('100%')
          .height('100%')
          .backgroundColor('#99ffffff')
          .zIndex(1)
          .borderRadius('16vp')
          .id('FirstPanel')

          Column() {
            Row() {
              Image(this.sessionArray[0] && this.metaDataMap.get(this.sessionArray[0])
                ? (this.metaDataMap?.get(this.sessionArray[0]))?.mediaImage : $r('app.media.no_music'))
                .width('48vp')
                .height('48vp')
                .id('CurrentImage')
              Column() {
                Text(this.sessionArray[0] && this.metaDataMap.get(this.sessionArray[0])
                  ? (this.metaDataMap?.get(this.sessionArray[0]))?.title : $r('app.string.not_in_play'))
                  .fontSize('16fp')
                  .fontColor('#182431')
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .width('228vp')
                  .id('Title')
                Text(this.sessionArray[0] && this.metaDataMap.get(this.sessionArray[0])
                  ? (this.metaDataMap?.get(this.sessionArray[0]))?.artist : $r('app.string.not_in_play'))
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
              Image($r('app.media.previous')).width('24vp').height('24vp')
                .id('Previous')
                .onClick(() => {
                  if (this.sessionArray[0]) {
                    this.controller.previous(this.sessionArray[0]);
                    Log.info(TAG, 'on previous click ');
                  }
                })
              Image(this.isPlaying ? $r('app.media.stopmusic') : $r('app.media.playmusic'))
                .width('24vp')
                .height('24vp')
                .id('PlayOrPause:' + this.isPlaying)
                .onClick(() => {
                  if (this.sessionArray[0]) {
                    if (this.isPlaying) {
                      this.controller.pause(this.sessionArray[0]);
                    } else {
                      this.controller.play(this.sessionArray[0]);
                    }
                    Log.info(TAG, 'on play/pause click ');
                  }
                })
              Image($r('app.media.next')).width('24vp').height('24vp')
                .id('Next')
                .onClick(() => {
                  if (this.sessionArray[0]) {
                    this.controller.next(this.sessionArray[0]);
                    Log.info(TAG, 'on next click ');
                  }
                })
              Image(this.isLyric ? $r('app.media.lyric_activate') : $r('app.media.lyric_none'))
                .width('24vp')
                .height('24vp')
                .id('Lyric')
                .onClick(() => {
                  this.controller.getLyric(this.sessionArray[0]);
                  Log.info(TAG, ' isLyric set to :' + this.isLyric);
                })
            }
            .justifyContent(FlexAlign.SpaceBetween)
            .margin({ left: '12vp', right: '12vp', top: '20vp', bottom: '12vp' })
            .width('264vp')
            .height('24vp')

            Row() {
              Text(this.sessionArray[0] && this.lyricMap[this.sessionArray[0]]
                ? this.lyricMap[this.sessionArray[0]] : $r('app.string.not_in_play'))
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
            .visibility(this.isLyric ? Visibility.Visible : Visibility.None)

            Divider()
              .height('0.5vp')
              .opacity(0.05)
              .color('#182431')
              .width('100%')
              .margin({ top: '12.5vp' })
              .visibility(this.sessionArray.length > 1 ? Visibility.Visible : Visibility.None)
            Row() {
              Image(this.sessionArray[1] && this.metaDataMap[this.sessionArray[1]]
                && this.metaDataMap[this.sessionArray[1]].mediaImage
                ? (this.metaDataMap[this.sessionArray[1]]).mediaImage : $r('app.media.no_music'))
                .width('48vp')
                .height('48vp')
                .id('HistoryImage')
              Column() {
                Text(this.sessionArray[1] && this.metaDataMap[this.sessionArray[1]]
                  ? (this.metaDataMap[this.sessionArray[1]]).title : $r('app.string.not_in_play'))
                  .fontSize('16fp')
                  .maxLines(1)
                  .fontColor('#182431')
                  .id('HistoryTitle')
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .width('228vp')
                Text(this.sessionArray[1] && this.bundleNameMap[this.sessionArray[1]]
                  ? (this.bundleNameMap[this.sessionArray[1]]) : '')
                  .fontSize('14fp')
                  .fontColor('#182431')
                  .opacity(0.6)
                  .maxLines(1)
                  .id('HistoryArtist')
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .width('228vp')
              }
              .margin({ left: '12vp' })
              .alignItems(HorizontalAlign.Start)
              .justifyContent(FlexAlign.Center)
            }
            .justifyContent(FlexAlign.Start).width('100%').margin({ top: '12vp', bottom: '12.5vp' })
            .visibility(this.sessionArray.length > 1 ? Visibility.Visible : Visibility.None)

            Divider()
              .height('0.5vp')
              .opacity(0.05)
              .color('#182431')
              .width('100%')
              .visibility(this.sessionArray.length > 2 ? Visibility.Visible : Visibility.None)

            Row() {
              Image(this.sessionArray[2] && this.metaDataMap?.get(this.sessionArray[2])
                && this.metaDataMap?.get(this.sessionArray[2])?.mediaImage
                ? (this.metaDataMap?.get(this.sessionArray[2]))?.mediaImage : $r('app.media.no_music'))
                .width('48vp')
                .height('48vp')
              Column() {
                Text(this.sessionArray[2] && this.metaDataMap?.get(this.sessionArray[2])
                  ? (this.metaDataMap?.get(this.sessionArray[2]))?.title : $r('app.string.not_in_play'))
                  .fontSize('16fp')
                  .fontColor('#182431')
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .width('228vp')
                Text(this.sessionArray[2] && this.bundleNameMap[this.sessionArray[2]]
                  ? (this.bundleNameMap[this.sessionArray[2]]) : '')
                  .fontSize('14fp')
                  .fontColor('#182431')
                  .opacity(0.6)
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .width('228vp')
              }
              .margin({ left: '12vp' })
              .alignItems(HorizontalAlign.Start)
              .justifyContent(FlexAlign.Center)
            }
            .justifyContent(FlexAlign.Start)
            .width('100%')
            .margin({ top: 10 })
            .visibility(this.sessionArray.length > 2 ? Visibility.Visible : Visibility.None)
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
              Text(this.sessionArray[0]
                && this.queueItemsMap[this.sessionArray[0]]
                && this.queueItemsMap[this.sessionArray[0]][0]
                ? this.queueItemsMap[this.sessionArray[0]][0].description.title : 'queue null')
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
            .onClick(() => {
              if (this.sessionArray[0] &&
              this.queueItemsMap[this.sessionArray[0]] &&
                this.queueItemsMap[this.sessionArray[0]][0] !== undefined) {
                Log.info(TAG, 'pre skip :' + this.queueItemsMap[this.sessionArray[0]][0].itemId);
                this.controller.skip(this.sessionArray[0], this.queueItemsMap[this.sessionArray[0]][0].itemId);
              }
            })

            Divider()
              .height('0.5vp')
              .opacity(0.05)
              .color('#182431')
              .width('100%')

            Column() {
              Text(this.sessionArray[0]
                && this.queueItemsMap[this.sessionArray[0]]
                && this.queueItemsMap[this.sessionArray[0]][1]
                ? this.queueItemsMap[this.sessionArray[0]][1].description.title : 'queue null')
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
            .onClick(() => {
              if (this.sessionArray[0] &&
              this.queueItemsMap[this.sessionArray[0]] &&
                this.queueItemsMap[this.sessionArray[0]][1] !== undefined) {
                Log.info(TAG, 'pre skip :' + this.queueItemsMap[this.sessionArray[0]][1].itemId);
                this.controller.skip(this.sessionArray[0], this.queueItemsMap[this.sessionArray[0]][1].itemId);
              }
            })

            Divider()
              .height('0.5vp')
              .opacity(0.05)
              .color('#182431')
              .width('100%')

            Column() {
              Text(this.sessionArray[0]
                && this.queueItemsMap[this.sessionArray[0]]
                && this.queueItemsMap[this.sessionArray[0]][2]
                ? this.queueItemsMap[this.sessionArray[0]][2].description.title : 'queue null')
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
            .onClick(() => {
              if (this.sessionArray[0] &&
              this.queueItemsMap[this.sessionArray[0]] &&
                this.queueItemsMap[this.sessionArray[0]][2] !== undefined) {
                this.controller.skip(this.sessionArray[0], this.queueItemsMap[this.sessionArray[0]][2].itemId);
              }
            })
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
    let mediaNum: number = this.sessionArray.length > 0 ?
      (this.sessionArray.length > 3 ? 3 : this.sessionArray.length) : 1; // If has 3 or more history, get 3 of them.
    let mediaExtraHeight: number = ((mediaNum - 1) > 0 ? 12 : 0) + (mediaNum - 1) * 73; // 73 is the length given from UX designer
    let height: number = 124 + (this.isLyric ? 44 : 0) + mediaExtraHeight; // 124 and 44 is the size given from UX designer
    Log.info(TAG, 'get height : ' + height);
    return String(height) + 'vp';
  }

  getTotalHeight(): string {
    let mediaNum: number = this.sessionArray.length > 0 ?
      (this.sessionArray.length > 3 ? 3 : this.sessionArray.length) : 1; // If has 3 or more history, get 3 of them.
    let mediaExtraHeight: number = ((mediaNum - 1) > 0 ? 12 : 0) + (mediaNum - 1) * 73; // 73 is the length given from UX designer
    let height: number = 124 + (this.isLyric ? 44 : 0) + mediaExtraHeight; // 124 and 44 is the length given from UX designer
    Log.info(TAG, 'get media height : ' + height);
    height += (this.isShowQueue ? 165 : 0); // 165 is the length given from UX designer
    Log.info(TAG, 'get total height : ' + height);
    return String(height + 40) + 'vp';
  }
}
