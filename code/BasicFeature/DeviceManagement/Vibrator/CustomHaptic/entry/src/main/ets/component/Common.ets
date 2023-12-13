/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { playVibrateCustom, getDynamicStates } from '../module/Util'
import { ImageDataSource, ImagesData } from '../module/ImageData'
import AudioPlayer from '../module/AudioPlayer'
import Logger from '../module/Logger'

const TAG = '[CommonLayout]'

@Component
export default struct CommonLayout {
  @Link dataList: ImageDataSource
  @Link status: boolean[]
  @Link vibrationIntensity: string
  @Link php: string

  build() {
    Column({ space: 10 }) {
      List() {
        LazyForEach(this.dataList, (item: ImagesData) => {
          ListItem() {
            Row() {
              Row() {
                Image(item.src)
                  .width(60)
                  .height(50)
                  .borderRadius(5)
                  .autoResize(false)
              }

              Stack({ alignContent: Alignment.Start }) {
                Column() {
                  Text(item.name)
                    .fontSize(15)
                    .fontColor(Color.White)
                }
                .alignItems(HorizontalAlign.Start)
                .padding({ left: 20 })
              }
              .layoutWeight(7)

              if (item.id !== undefined) {
                Image($r("app.media.music"))
                  .width(15)
                  .height(15)
                  .visibility(this.status[item.id] ? Visibility.Visible : Visibility.Hidden)
              }
            }
            .id("audioHaptic")
            .width("95%")
            .height(70)
            .padding({ top: 5, left: 10, right: 10, bottom: 5 })
            .backgroundColor(this.status[item.id!] ? "#1a3e3f56" : "#4d191a32")
            .onClick(() => {
              this.status = getDynamicStates(this.status, item.id!)
              AudioPlayer.playAudio(item.audioName!)
              if (this.vibrationIntensity === 'H') {
                Logger.info(TAG, "High intensity mode")
                playVibrateCustom(item.vibratorFileH!, this.php)
              } else if (this.vibrationIntensity === 'M') {
                Logger.info(TAG, "Middle intensity mode")
                playVibrateCustom(item.vibratorFileM!, this.php)
              } else if (this.vibrationIntensity === 'L') {
                Logger.info(TAG, "Low intensity mode")
                playVibrateCustom(item.vibratorFileL!, this.php)
              } else {
                Logger.info(TAG, "Vibration mode error")
              }
              if (item.id) {
                Logger.info(TAG, item.id.toString() + ' ' + item.name + ' ' + item.audioName)
              }
            })
          }
        }) // LazyForEach
      }
      .listDirection(Axis.Vertical)
      .divider({ strokeWidth: 3, color: "#00f3f3f3", startMargin: 0, endMargin: 0 })
      .height('50%')
      .width('100%')
    }
  }
}
