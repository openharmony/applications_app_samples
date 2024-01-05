/*
 * Copyright (c) 2022-2024 Huawei Device Co., Ltd.
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

import audio from '@ohos.multimedia.audio'
import mediaLibrary from '@ohos.multimedia.mediaLibrary'
import { AVPlayer } from '../model/AVPlayer'
import { getTimeString } from '../model/TimeTools'
import { isInformationDialog } from '../common/IsInformationDialog'
import Logger from '../model/Logger'

let audioManager = audio.getAudioManager()
const TAG: string = 'AVPlayerSample'

@Component
export struct BroadcastControl {
  @Link isLoop: boolean
  @Link myMedia: AVPlayer
  @Link isOpacity: number
  @Link isSurface: boolean
  @Link isPlaying: boolean
  @Link currentTime: number
  @Link btnEnabled: boolean
  @Link isXComponent: boolean
  @Link itemData: mediaLibrary.FileAsset
  @Link @Watch('onChangeIsShowMenu') isShowMenu: boolean
  @State isVolume: boolean = false
  @State mediaVolumeValue: number = -1
  @State isInformation: boolean = false
  @State isInformationObj: mediaLibrary.FileAsset = {} as mediaLibrary.FileAsset
  @State selectText: string = ''
  private timerOut: number = 0
  private scroller: Scroller = new Scroller()
  private mXComponentController: XComponentController = {} as XComponentController
  private dialogController: CustomDialogController = {} as CustomDialogController
  private context: Context = getContext(this)

  clearVideoPlayer() {
    this.currentTime = 0
    this.myMedia.stop()
    this.myMedia.release()
  }

  onChangeIsShowMenu() {
    if (!this.isShowMenu) {
      this.isInformation = false
      this.isVolume = false
    }
  }

  async aboutToAppear() {
    this.mediaVolumeValue = await audioManager.getVolume(audio.AudioVolumeType.MEDIA)
    this.selectText = await this.convertResourceToString($r('app.string.phoneMain_setSpeed'))
    this.myMedia.setTimeUpdateCallback((time) => {
      Logger.info(TAG, 'timeUpdate, time is:' + time)
      this.currentTime = time
    })
  }

  async convertResourceToString(resource: Resource) {
    return await this.context.resourceManager.getString(resource.id)
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      if (this.isShowMenu) {
        Column() {
          Row() {
            Text(this.myMedia.fileName ? this.myMedia.fileName : $r('app.string.phoneMain_title'))
              .fontColor(Color.White)
              .fontSize(28)
              .margin({ left: 12, top: 8 })
              .fontFamily('HarmonyHeiTi-Medium')
          }
          .width('100%')
          .height('8%')
          .constraintSize({ minHeight: 70 })
          .padding({ left: 15 })

          Blank()
          Row() {
            Text(getTimeString(this.currentTime))
              .fontSize(16)
              .fontColor('#FFFFFF')
              .fontWeight(500)
              .opacity(0.6)
            Slider({
              value: this.myMedia ? Math.round(this.currentTime / this.myMedia.totalDuration * 100) : 0
            })
              .selectedColor(Color.White)
              .width('90%')
              .trackColor(Color.Gray)
              .onChange((value: number) => {
                this.currentTime = this.myMedia.totalDuration * value / 100
                this.myMedia.seek(this.currentTime)
              })
            Text(this.myMedia ? getTimeString(this.myMedia.totalDuration) : '00:00')
              .fontSize(16)
              .fontColor('#FFFFFF')
              .fontWeight(500)
              .opacity(0.6)
          }
          .width('98%')
          .height(25)

          Flex({
            justifyContent: FlexAlign.SpaceBetween,
            alignItems: ItemAlign.Center
          }) {
            Row() {
              Image($r('app.media.icon_Previous'))
                .width(24)
                .height(24)
                .enabled(this.btnEnabled)
                .opacity(this.isOpacity)
                .onClick(() => {
                  this.isPlaying = true
                  this.isLoop = false
                  let surfaceId = this.mXComponentController.getXComponentSurfaceId()
                  this.myMedia.prev(surfaceId)
                })
              Image(this.isPlaying ? $r('app.media.icon_play') : $r('app.media.icon_pause'))
                .width(24)
                .height(24)
                .opacity(this.isOpacity)
                .onClick(() => {
                  this.isPlaying = !this.isPlaying
                })
              Image($r('app.media.icon_next'))
                .width(24)
                .height(24)
                .enabled(this.btnEnabled)
                .opacity(this.isOpacity)
                .onClick(() => {
                  this.isPlaying = true
                  this.isLoop = false
                  let surfaceId = this.mXComponentController.getXComponentSurfaceId()
                  this.myMedia.next(surfaceId)
                })
              Image(this.isLoop ? $r('app.media.icon_single') : $r('app.media.icon_repeatplay'))
                .width(24)
                .height(24)
                .opacity(this.isOpacity)
                .onClick(() => {
                  this.isLoop = !this.isLoop
                  this.myMedia.getPlayMode(this.isLoop)
                })
              Select([
                { value: '0.75' },
                { value: '1.00' },
                { value: '1.25' },
                { value: '1.75' },
                { value: '2.00' },
              ])
                .value(this.selectText)
                .font({ size: 18 })
                .fontColor(Color.White)
                .selectedOptionFont({ size: 18 })
                .optionFontColor(Color.Black)
                .opacity(this.itemData ? (this.itemData.mediaType == mediaLibrary.MediaType.AUDIO ? 0 : 1) : 0.4)
                .enabled(this.itemData ? (this.itemData.mediaType == mediaLibrary.MediaType.AUDIO ? false : true) : false)
                .optionFont({ size: 18 })
                .onSelect((index: number) => {
                  this.myMedia.setSpeed(index)
                })

            }.width('40%').justifyContent(FlexAlign.SpaceBetween)

            Row() {
              Image($r('app.media.icon_info'))
                .width(24)
                .height(24)
                .opacity(this.isOpacity)
                .onClick(() => {
                  this.isInformation = !this.isInformation
                  if (this.isInformation) {
                    if (this.myMedia.getResourceAddress()) {
                      this.dialogController = new CustomDialogController({
                        builder: isInformationDialog({ myMedia: $myMedia, context: this.context }),
                        autoCancel: true,
                        cancel: () => {
                          this.myMedia.getPlay()
                          this.isPlaying = true
                        },
                        customStyle: true,
                        offset: {
                          dx: 195,
                          dy: -7
                        }
                      })
                      this.dialogController.open()
                    }
                  }
                })

              Image(this.isVolume ? $r('app.media.icon_isvolume') : $r('app.media.icon_volume'))
                .width(24)
                .height(24)
                .onClick(() => {
                  this.isVolume = !this.isVolume
                })

            }
            .width('10%')
            .justifyContent(FlexAlign.SpaceBetween)
            .margin({ right: 10 })
          }
          .margin({ top: 10, bottom: 10 })
          .height(40)
          .width('98%')
        }
        .height('100%')
        .width('98%')
        .zIndex(2)
      }
      if (this.isXComponent) {
        if (this.isSurface) {
          Row() {
            XComponent({
              id: '',
              type: 'surface',
              controller: this.mXComponentController
            })
              .width('100%')
          }
          .height('85%')
          .width('100%')
          .justifyContent(FlexAlign.Center)
          .margin({ top: -45 })
        } else {
          Row() {
            XComponent({
              id: '',
              type: 'surface',
              controller: this.mXComponentController
            })
              .width('100%')
          }
          .height('85%')
          .width('100%')
          .justifyContent(FlexAlign.Center)
          .margin({ top: -45 })
        }
      }
      if (this.isVolume) {
        Flex({
          justifyContent: FlexAlign.SpaceEvenly,
          alignItems: ItemAlign.Center,
          direction: FlexDirection.Column
        }) {
          Slider({
            value: this.mediaVolumeValue,
            min: 0,
            max: 15,
            step: 1,
            direction: Axis.Vertical,
            reverse: true
          })
            .selectedColor('#5291ff')
            .height('94%')
            .opacity(1)
            .trackColor(Color.Gray)
            .onChange((value: number) => {
              this.mediaVolumeValue = value
              audioManager.setVolume(audio.AudioVolumeType.MEDIA, value, (err) => {
              })
            })
        }
        .position({ x: '93%', y: '43%' })
        .width('5%')
        .height('50%')
        .backgroundColor('rgba(0,0,0,0.6)')
        .borderRadius(25)
        .zIndex(5)
        .onClick(() => {
          this.isVolume = !this.isVolume
        })
      }
    }
    .width('77%')
    .height('100%')
    .backgroundColor(Color.Black)
    .onClick(() => {
      this.isShowMenu = !this.isShowMenu
    })
  }
}