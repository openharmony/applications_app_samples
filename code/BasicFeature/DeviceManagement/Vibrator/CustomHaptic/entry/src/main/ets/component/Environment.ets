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

import { playVibrateCustom, avPlayer, getDynamicStates } from '../moudle/Util'
import { getImageEnvironmentList, ImageDataSource, ImagesData } from '../moudle/ImageData'
import Logger from '../moudle/Logger'

const TAG = '[EnvironmentLayout]'

@Component
export default struct EnvironmentLayout {
  private environmentList = new ImageDataSource(getImageEnvironmentList())
  @State status: boolean[] = [false, false, false, false, false, false, false]
  @Link vibrationIntensity: string

  build() {
    Column({ space: 10 }) {
      List() {
        LazyForEach(this.environmentList, (Item: ImagesData) => {
          ListItem() {
            Row() {
              Row() {
                Image(Item.src).width(60).height(50).borderRadius(5).autoResize(false)
              }

              Stack({ alignContent: Alignment.Start }) {
                Column() {
                  Text(Item.name).fontSize(15).fontColor(Color.White)
                }.alignItems(HorizontalAlign.Start).padding({ left: 20 })
              }.layoutWeight(7)

              Image($r("app.media.music")).width(15).height(15)
                .visibility(this.status[Item.id] ? Visibility.Visible : Visibility.Hidden)
            }
            .width("95%")
            .height(70)
            .padding({ top: 5, left: 10, right: 10, bottom: 5 })
            .backgroundColor(this.status[Item.id] ? "#1a3e3f56" : "#4d191a32")
            .onClick(() => {
              this.status = getDynamicStates(this.status, Item.id)
              avPlayer(Item.audioName)
              if (this.vibrationIntensity === 'H') {
                Logger.info(TAG, "High intensity mode")
                playVibrateCustom(Item.vibratorFileH)
              } else if (this.vibrationIntensity === 'M') {
                Logger.info(TAG, "Middle intensity mode")
                playVibrateCustom(Item.vibratorFileM)
              } else if (this.vibrationIntensity === 'L') {
                Logger.info(TAG, "Low intensity mode")
                playVibrateCustom(Item.vibratorFileL)
              } else {
                Logger.info(TAG, "Vibration mode error")
              }
              Logger.info(TAG, Item.id.toString() + ' ' + Item.name + ' ' + Item.audioName)
            })
          }
        }) // LazyForEach
      }.listDirection(Axis.Vertical)
      .divider({ strokeWidth: 3, color: "#00f3f3f3", startMargin: 0, endMargin: 0 })
      .height('50%')
      .width('100%')
    }
  }
}
