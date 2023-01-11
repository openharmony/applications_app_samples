/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import mediaLibrary from '@ohos.multimedia.mediaLibrary'
import iaImage from '@ohos.multimedia.image'
import { getTimeString } from '../model/TimeTools'
import Logger from '../model/Logger'

const TRANSLATE: number = -110
const TAG: string = 'MediaItem:'

@Component
export struct MediaItem {
  @State translateLeft: number = 0
  @State translateRight: number = TRANSLATE
  @State pixelMap: iaImage.PixelMap = undefined
  @State mediaItem: mediaLibrary.FileAsset = undefined
  @Link @Watch('leftSliderChange') leftSliderIndex: number
  private index: number = -1
  private deleteDialogShow: (index: number, mediaType) => void
  private renameDialogShow: (index: number, mediaType) => void

  leftSliderChange() {
    animateTo({ duration: 500, curve: Curve.Linear }, () => {
      if (this.index !== this.leftSliderIndex) {
        this.translateLeft = 0
        this.translateRight = TRANSLATE
      } else {
        if (this.translateLeft < 0) {
          this.translateLeft = 0
          this.translateRight = TRANSLATE
        } else {
          this.translateLeft = TRANSLATE
          this.translateRight = 0
        }
      }
    })
  }

  async aboutToAppear() {
    let size: iaImage.Size = { width: 100, height: 66 }
    this.mediaItem.getThumbnail(size, (err, pixelMap) => {
      Logger.info(TAG, 'getThumbnail callback')
      if (err) {
        Logger.info(TAG, `getThumbnail callback,err=${JSON.stringify(err)}`)
        return
      }
      this.pixelMap = pixelMap
      Logger.info(TAG, `getThumbnail callback,success = ${typeof this.pixelMap}`)
    })
  }

  getImageSrc() {
    switch (this.mediaItem.mediaType) {
      case mediaLibrary.MediaType.VIDEO:
        return $r('app.media.videoCover')
      case mediaLibrary.MediaType.AUDIO:
        return $r('app.media.audioCover')
    }
  }

  build() {
    Flex({ justifyContent: FlexAlign.Center }) {
      Flex({
        justifyContent: FlexAlign.Start,
        alignItems: ItemAlign.Center
      }) {

        Image(this.pixelMap ? this.pixelMap : this.getImageSrc())
          .width(100)
          .height('100%')
          .borderRadius(12)
          .objectFit(ImageFit.Fill)

        Text(getTimeString(this.mediaItem.duration))
          .fontSize(14)
          .fontColor('#FFFFFF')
          .position({
            x: '5',
            y: '42%'
          })
          .zIndex(2)

        Text(this.mediaItem.displayName)
          .align(Alignment.Start)
          .fontSize(16)
          .fontColor('#FFFFFF')
          .fontFamily('HarmonyHeiTi-Medium')
          .margin({
            left: 12
          })
          .height(40)
          .textOverflow({
            overflow: TextOverflow.Clip
          })
          .width('48%')
      }
      .width('95%')
      .height(66)
      .borderRadius(12)
      .backgroundColor('rgba(255,255,255,0.10)')


      Row() {
        Button() {
          Image($r("app.media.icon_rename"))
            .size({
              width: 60,
              height: 40
            })
            .objectFit(ImageFit.Contain)
        }
        .margin({
          left: 5
        })
        .size({
          width: 40,
          height: 40
        })
        .type(ButtonType.Circle)
        .onClick(() => {
          this.leftSliderIndex = -1
          this.renameDialogShow(this.index, this.mediaItem.mediaType)
        })

        Button() {
          Image($r('app.media.icon_delete'))
            .objectFit(ImageFit.Contain)
            .size({
              width: 40,
              height: 40
            })
        }
        .type(ButtonType.Circle)
        .size({
          width: 40,
          height: 40
        })
        .backgroundColor('#FF0000')
        .margin({
          left: 8
        })
        .onClick(() => {
          this.deleteDialogShow(this.index, this.mediaItem.mediaType)
          this.leftSliderIndex = -1
        })
      }
      .width('15%')
      .margin({
        left: 15,
        right: 15
      })
    }
    .width('120%')
    .margin({
      left: this.translateLeft,
      right: 110
    })
    .priorityGesture(
    GestureGroup(
      GestureMode.Parallel,
    PanGesture({
      fingers: 1,
      direction: PanDirection.Right,
      distance: 20
    })
      .onActionEnd(() => {
        this.leftSliderIndex = -1
      }),
    PanGesture({
      fingers: 1,
      direction: PanDirection.Left,
      distance: 20
    })
      .onActionEnd(() => {
        this.leftSliderIndex = this.index
      }))
    )
  }
}