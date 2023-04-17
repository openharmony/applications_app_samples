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

@Component
export struct AddressService {
  @Link isPanel: boolean
  @Link currentLocation: string

  @Builder Server(text: Resource, marginTop: number) {
    Row() {
      Image($r('app.media.service'))
        .objectFit(ImageFit.Contain)
        .width(16)
        .aspectRatio(1)

      Row() {
        Text(text)
          .fontSize(14)
          .fontColor($r('app.color.blank'))
          .margin({ left: 6 })
      }
    }
    .margin({ top: marginTop })
  }

  build() {
    Column() {
      Row() {
        Text($r('app.string.send_to'))
          .fontSize(14)
          .fontColor($r('app.color.blank'))
          .fontWeight(500)
          .margin({ right: 16 })
        Column() {
          Row() {
            Row() {
              Image($r('app.media.local'))
                .width(16)
                .aspectRatio(1)
                .margin({ right: 12 })
              Text(`${this.currentLocation}`)
                .fontSize(14)
                .fontColor($r('app.color.blank'))
                .opacity(0.6)
            }
            .flexShrink(1)
            .flexGrow(1)

            Image($r('app.media.alternative'))
              .objectFit(ImageFit.Contain)
              .width(14)
              .aspectRatio(1)
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)

          Divider()
            .color($r('app.color.blank'))
            .opacity(0.2)
            .width('100%')
            .margin({ top: 12 })
        }
        .flexShrink(1)
        .flexGrow(1)
      }
      .alignItems(VerticalAlign.Top)
      .width('100%')
      .onClick(() => {
        this.isPanel = !this.isPanel
      })

      Row() {
        Text($r('app.string.service'))
          .fontSize(14)
          .fontColor($r('app.color.blank'))
          .fontWeight(500)
          .margin({ right: 16 })
        Column() {
          this.Server($r('app.string.free_hipping'), 0)
          this.Server($r('app.string.store_delivery'), 16)
          this.Server($r('app.string.return_goods'), 16)
        }
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
      .alignItems(VerticalAlign.Top)
      .margin({ top: 12 })
    }
    .width('100%')
    .justifyContent(FlexAlign.Start)
    .backgroundColor($r('app.color.white'))
    .borderRadius(16)
    .padding({ top: 16, bottom: 16, left: 12, right: 12 })
  }
}