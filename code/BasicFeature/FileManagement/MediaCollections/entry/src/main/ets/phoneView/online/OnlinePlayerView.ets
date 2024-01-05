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

import router from '@ohos.router'
import { AVPlayer } from '../../model/AVPlayer'
import { getTimeString } from '../../model/TimeTools'
import { samplesData } from '../../model/JsonListData'
import Logger from '../../model/Logger'
import AVPlayerConstants, { speedObj } from '../../common/constants/AVplayerConstants'
import KVManagerUtil from '../../model/KVManagerUtil'

const TAG = 'OnlinePlayerView'

@Component
export default struct OnlinePlayerView {
  @Link myMedia: AVPlayer
  @Link currentTime: number
  @Link isXComponent: boolean
  @Link surfaceId: number
  @Link isPlaying: boolean
  @Link isLoop: boolean
  @Link isLandscape: boolean
  @State isSpeedShow: boolean = false
  @State isBitrateShow: boolean = false
  @State isProgressMoving: boolean = false
  @State isDeleteShow: boolean = false
  @State bitRateList: number[] = []
  @State errorText: string = ''
  private onlineVideoData: samplesData = {} as samplesData
  private mXComponentController: XComponentController = {} as XComponentController

  async aboutToAppear() {
    this.myMedia.setTimeUpdateCallback((time) => {
      if (!this.isProgressMoving) {
        this.currentTime = time
      }
    })

    this.myMedia.setBitrateUpdateCallback((bitRateList) => {
      this.bitRateList = bitRateList
    })

    this.myMedia.setErrorCallback((error) => {
      this.errorText = error
    })

    setTimeout(async () => {
      let keyId: string = await KVManagerUtil.get(this.onlineVideoData.uri)
      this.isDeleteShow = keyId ? true : false
    }, 500)

  }

  @Builder
  speedPopup() {
    List({ space: 20 }) {
      ForEach(AVPlayerConstants.SPEED_ARRAY, (item: speedObj) => {
        ListItem() {
          Row() {
            Text(item.text)
              .fontColor('rgba(255,255,255,0.90)')
              .fontSize(15)
              .onClick(() => {
                this.myMedia.setSpeed(item.value)
                this.isSpeedShow = false
              })
          }
          .padding({ left: 10 })
          .width("100%")
          .height(20)
        }
      }, (item: speedObj) => JSON.stringify(item))
    }
    .width(80)
    .padding(10)
  }

  @Builder
  bitratePopup() {
    List({ space: 20 }) {
      ForEach(this.bitRateList, (item: number) => {
        ListItem() {
          Row() {
            Text(item.toString())
              .fontColor('rgba(255,255,255,0.90)')
              .fontSize(15)
              .onClick(() => {
                this.myMedia.setBitrate(item)
                this.isBitrateShow = false
              })
          }
          .padding({ left: 10 })
          .width("100%")
          .height(20)
        }
      }, (item: speedObj) => JSON.stringify(item))
    }
    .width(80)
    .padding(10)
  }

  build() {
    Column() {
      Stack({ alignContent: Alignment.Top }) {
        // 底层播放区域
        if (this.isXComponent) {
          Column() {
            Column().layoutWeight(1)

            XComponent({
              id: '',
              type: 'surface',
              controller: this.mXComponentController
            })
              .height(this.isLandscape ? '100%' : '55%')
              .aspectRatio(1920 / 1080)
              .onLoad(() => {
                this.surfaceId = Number(this.mXComponentController.getXComponentSurfaceId())
                this.isPlaying = true
                const uri: string = this.onlineVideoData.uri
                const licenseUrl: string = this.onlineVideoData.drm_license_url
                const title: string = this.onlineVideoData.name
                Logger.info(TAG, `drmUrl: ${uri}`)
                Logger.info(TAG, `drmLicenseUrl: ${licenseUrl}`)
                this.myMedia.drmInit(this.surfaceId.toString(), title, uri, licenseUrl)
              })
            Column().layoutWeight(2)
          }.zIndex(0)
        }

        // 上层操作界面
        Column() {
          // 标题栏区域
          Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceAround }) {
            Image($r('app.media.icon_back'))
              .width(24)
              .height(24)
              .margin(15)
              .onClick(() => {
                if (this.isLandscape) {
                  this.isLandscape = false
                } else {
                  router.back()
                }
              })

            Text(this.myMedia.fileName || $r('app.string.phoneMain_title'))
              .fontColor('rgba(255,255,255,0.90)')
              .fontSize(18)
              .fontFamily('HarmonyHeiTi-Medium')
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.MARQUEE })
              .width('50%')

            Blank()

            Text($r('app.string.onlinePlayerView_bitrate'))
              .fontColor('rgba(255,255,255,0.90)')
              .fontSize(18)
              .fontFamily('HarmonyHeiTi-Medium')
              .margin(15)
              .onClick(() => {
                this.isBitrateShow = !this.isBitrateShow
              })
              .bindPopup(this.isBitrateShow, {
                builder: this.bitratePopup, // 气泡的内容
                placement: Placement.Bottom, // 气泡的弹出位置
                popupColor: 'rgba(0,0,0,0.6)' // 气泡的背景色
              })

            Text($r('app.string.onlinePlayerView_speed'))
              .fontColor('rgba(255,255,255,0.90)')
              .fontSize(18)
              .fontFamily('HarmonyHeiTi-Medium')
              .margin(15)
              .onClick(() => {
                this.isSpeedShow = !this.isSpeedShow
              })
              .bindPopup(this.isSpeedShow, {
                builder: this.speedPopup, // 气泡的内容
                placement: Placement.Bottom, // 气泡的弹出位置
                popupColor: 'rgba(0,0,0,0.6)' // 气泡的背景色
              })
          }.layoutWeight(1)

          // 提示
          Column() {
            // 加载中UI
            LoadingProgress()
              .color(Color.White)
              .opacity(0.6)
              .width(40)
              .height(40)
              .enableLoading(this.myMedia.isLoading ? true : false)

            if (this.errorText) {
              Text(this.errorText)
                .fontColor('rgba(255,255,255,0.90)')
                .fontSize(18)
                .fontFamily('HarmonyHeiTi-Medium')
                .margin(15)
            }
          }
          .justifyContent(FlexAlign.Center)
          .height('55%')

          // 进度条区域
          Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceEvenly }) {
            Image(this.isPlaying ? $r('app.media.icon_play') : $r('app.media.icon_pause'))
              .width(24)
              .height(24)
              .onClick(() => {
                this.isPlaying = !this.isPlaying
              })
            Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
              Text(getTimeString(this.currentTime) || '00:00')
                .fontSize(12)
                .fontColor('#FFFFFF')
                .fontWeight(500)
                .opacity(0.6)
                .fontFamily('HarmonyHeiTi')
              Slider({
                value: Math.floor((this.currentTime / 1000)),
                max: Math.floor(this.myMedia.totalDuration / 1000)
              },)
                .layoutWeight(1)
                .selectedColor(Color.White)
                .trackColor(Color.Gray)
                .onChange((value: number, mode: SliderChangeMode) => {
                  let changeTime = Math.floor(value) * 1000
                  if (mode === SliderChangeMode.Begin) {
                    this.isProgressMoving = true
                  } else if (mode === SliderChangeMode.Moving) {
                    this.isProgressMoving = true
                    this.currentTime = changeTime
                  } else if (mode === SliderChangeMode.End) {
                    this.isProgressMoving = false
                    this.myMedia.seek(changeTime)
                  }
                })
              Text(this.myMedia ? getTimeString(this.myMedia.totalDuration) : '00:00')
                .fontSize(12)
                .fontColor('#FFFFFF')
                .fontWeight(500)
                .opacity(0.6)
                .fontFamily('HarmonyHeiTi')
            }.width('80%')

            Image($r('app.media.icon_large'))
              .width(24)
              .height(24)
              .opacity(this.isLandscape ? 1 : 0.4)
              .onClick(() => {
                this.isLandscape = !this.isLandscape
              })
          }
          .layoutWeight(1)

          // 控制栏
          Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceAround }) {
            Image($r("app.media.icon_seekStart"))
              .width(24)
              .height(24)
              .onClick(() => {
                this.myMedia.seek(0)
              })

            Image($r('app.media.icon_cycle'))
              .width(24)
              .height(24)
              .opacity(this.isLoop ? 1 : 0.4)
              .onClick(() => {
                this.isLoop = !this.isLoop
              })

            Image($r("app.media.icon_seekEnd"))
              .width(24)
              .height(24)
              .onClick(() => {
                this.myMedia.seek(this.myMedia.totalDuration)
              })

            Image($r("app.media.delete"))
              .width(24)
              .height(24)
              .visibility(this.isDeleteShow ? Visibility.Visible : Visibility.Hidden)
              .onClick(async () => {
                if (this.isDeleteShow) {
                  this.isDeleteShow = false
                  this.myMedia.deleteOfflineLicense(this.onlineVideoData.uri)
                }
              })
          }
          .layoutWeight(1)
        }
        .zIndex(1)
      }
    }
    .height(this.isLandscape ? '100%' : '50%')
    .backgroundColor(Color.Black)
  }
}