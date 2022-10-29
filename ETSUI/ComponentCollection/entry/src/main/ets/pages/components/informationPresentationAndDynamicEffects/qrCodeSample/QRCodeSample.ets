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

import { CommonItemInput, CommonItemSelect } from '../../common/AttributeModificationTool'
import { TitleBar } from '../../../../common/TitleBar'

@Entry
@Component
struct QRCodeSample {
  @State qrCodeContent: string = ''
  @State qrCodeColor: Color = Color.Black

  @Styles backgroundStyle() {
    .padding(12)
    .borderRadius(24)
    .margin({ top: 12 })
    .layoutWeight(4)
    .backgroundColor(Color.White)
  }

  build() {
    Column() {
      TitleBar({ title: $r('app.string.qrcode_title') })
      Column() {
        QRCode(this.qrCodeContent) // QR code content
          .color(this.qrCodeColor) // QR code color
      }
      .backgroundStyle()
      .justifyContent(FlexAlign.Center)

      Scroll() {
        Column() {
          CommonItemInput({
            inputValue: $qrCodeContent,
            name: $r('app.string.qrcode_content'),
            placeholder: $r('app.string.qrcode_enter_content')
          })

          // QR code color
          CommonItemSelect({
            name: $r('app.string.qrcode_color'),
            selects: ['Black', 'Green', 'Yellow', 'Red'],
            isItemStyle: false,
            callback: (index) => {
              switch (index) {
                case 1:
                  this.qrCodeColor = Color.Green
                  break
                case 2:
                  this.qrCodeColor = Color.Yellow
                  break
                case 3:
                  this.qrCodeColor = Color.Red
                  break
                default:
                  this.qrCodeColor = Color.Black
              }
            }
          })
        }
      }
      .margin({ top: 12, left: 12, right: 12  })
      .layoutWeight(6)
    }
    .justifyContent(FlexAlign.Center)
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}