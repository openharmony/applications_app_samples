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

import Logger from './Logger'

const TAG = '[MyInfoModule]'

@Component
export default struct MyInfoModule {
  @State selectContent: Resource = $r("app.string.my_low_mode")
  @State selectContent1: Resource = $r("app.string.my_ets")

  @Link vibrationIntensity: string
  @Link php: string

  build() {
    Column({ space: 30 }) {
      Column({ space: 10 }) {
        Row({ space: 10 }) {
          Image($r("app.media.set"))
            .height(20)
            .width(20)
          Text($r("app.string.my_settings"))
            .fontColor(Color.White)
            .fontSize(20)
          Text(this.selectContent)
            .fontSize(16)
            .fontColor("#ffcbc2c2")
        }
        .id('intensitySelect')
        .height("100%")
        .width("80%")
        .onClick(() => {
          ActionSheet.show({
            title: $r("app.string.my_settings"),
            message: $r("app.string.my_select_msg"),
            autoCancel: true,
            confirm: {
              value: $r("app.string.cancel"),
              action: () => {
                Logger.info(TAG, 'Get Alert Dialog handled')
              }
            },
            cancel: () => {
              Logger.info(TAG, 'actionSheet canceled')
            },
            alignment: DialogAlignment.Bottom,
            offset: { dx: 0, dy: -10 },
            sheets: [
              {
                icon: $r("app.media.app_icon"),
                title: $r("app.string.my_high_mode"),
                action: () => {
                  this.selectContent = $r("app.string.my_high_mode")
                  this.vibrationIntensity = 'H'
                  Logger.info(TAG, 'Vibration intensity is high')
                }
              },
              {
                icon: $r("app.media.app_icon"),
                title: $r("app.string.my_middle_mode"),
                action: () => {
                  this.selectContent = $r("app.string.my_middle_mode")
                  this.vibrationIntensity = 'M'
                  Logger.info(TAG, 'Vibration intensity is middle')
                }
              },
              {
                icon: $r("app.media.app_icon"),
                title: $r("app.string.my_low_mode"),
                action: () => {
                  this.selectContent = $r("app.string.my_low_mode")
                  this.vibrationIntensity = 'L'
                  Logger.info(TAG, 'Vibration intensity is low')
                }
              }
            ]
          })
        })
        .width("80%")

        Row() {
        }
        .height(1)
        .width("85%")
        .backgroundColor('#ff404048')
      }

      Column({ space: 10 }) {
        Row({ space: 10 }) {
          Image($r("app.media.select"))
            .height(20)
            .width(20)
          Text($r("app.string.my_php"))
            .fontColor(Color.White)
            .fontSize(20)
          Text(this.selectContent1)
            .fontSize(16)
            .fontColor("#ffcbc2c2")
        }
        .id('phpSelect1')
        .height("100%")
        .width("80%")
        .onClick(() => {
          ActionSheet.show({
            title: $r("app.string.my_php_select"),
            message: $r("app.string.my_linguistic_type"),
            autoCancel: true,
            confirm: {
              value: $r("app.string.cancel"),
              action: () => {
                Logger.info(TAG, 'Get Alert Dialog handled')
              }
            },
            cancel: () => {
              Logger.info(TAG, 'actionSheet canceled')
            },
            alignment: DialogAlignment.Bottom,
            offset: { dx: 0, dy: -10 },
            sheets: [
              {
                icon: $r("app.media.app_icon"),
                title: $r("app.string.my_ets"),
                action: () => {
                  this.selectContent1 = $r("app.string.my_ets")
                  this.php = 'ets'
                }
              },
              {
                icon: $r("app.media.app_icon"),
                title: $r("app.string.my_capi"),
                action: () => {
                  this.selectContent1 = $r("app.string.my_capi")
                  this.php = 'capi'
                }
              }
            ]
          })
        })
        .width("80%")

        Row() {
        }
        .height(1)
        .width("85%")
        .backgroundColor('#ff404048')
      }

      Column({ space: 10 }) {
        Row({ space: 10 }) {
          Image($r("app.media.Verison"))
            .width(20)
            .height(20)
          Text($r("app.string.my_version"))
            .fontColor(Color.White)
            .fontSize(20)
            .backgroundColor('#cc191a32')
          Text('v1.0')
            .fontSize(20)
            .fontColor("#ff706666")
        }
        .width("80%")

        Row() {
        }
        .height(1)
        .width("85%")
        .backgroundColor("#ff404048")
      }

      Column({ space: 10 }) {
        Row({ space: 10 }) {
          Image($r("app.media.bangzhu"))
            .width(20)
            .height(20)
          Text($r("app.string.my_help"))
            .fontColor(Color.White)
            .fontSize(20)
            .backgroundColor('#cc191a32')
          Text('Please Waiting!')
            .fontSize(20)
            .fontColor("#ff706666")
        }
        .width("80%")

        Row() {
        }
        .height(1)
        .width("85%")
        .backgroundColor("#ff404048")
      }

      Column({ space: 10 }) {
        Row({ space: 10 }) {
          Image($r("app.media.xinxi"))
            .width(20)
            .height(20)
          Text($r("app.string.my_develop"))
            .fontColor(Color.White)
            .fontSize(20)
            .backgroundColor('#cc191a32')
          Text('Please Waiting!')
            .fontSize(20)
            .fontColor("#ff706666")
        }
        .width("80%")

        Row() {
        }
        .height(1)
        .width("85%")
        .backgroundColor("#ff404048")
      }
    }
  }
}
