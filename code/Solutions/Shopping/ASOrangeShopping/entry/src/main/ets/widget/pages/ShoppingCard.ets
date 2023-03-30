/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

@Entry
@Component
struct ShoppingCard {
  @Builder Title() {
    Row() {
      Image($r('app.media.point'))
        .size({ width: 5, height: 5 })
      Image($r('app.media.icon'))
        .size({ width: 20, height: 20 })
        .shadow({
          radius: 3,
          offsetX: 3,
          offsetY: 3,
          color: $r('app.color.shadow')
        })
      Text($r("app.string.card_special_offers"))
        .fontSize(16)
        .fontColor($r('app.color.white'))
        .fontWeight(FontWeight.Bolder)
      Image($r('app.media.point'))
        .size({ width: 5, height: 5 })
    }
    .width('100%')
    .height(30)
    .padding({ left: 6, right: 6 })
    .shadow({
      radius: 3,
      offsetY: 3,
      color: $r('app.color.shadow')
    })
    .margin({ bottom: 12 })
    .justifyContent(FlexAlign.SpaceAround)
    .backgroundColor($r('app.color.pink'))
  }

  @Builder GoodsInfo() {
    Row() {
      Column() {
        Image($r('app.media.product003'))
          .width('100%')
        Text($r('app.string.card_product_name'))
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Center)

      Column({ space: 6 }) {
        Text($r('app.string.card_lower_price'))
          .fontSize(12)
          .fontWeight(FontWeight.Bolder)

        Text($r('app.string.card_save_money'))
          .fontSize(12)
          .fontWeight(FontWeight.Bolder)
        Text($r('app.string.card_price'))
          .fontColor($r('app.color.pink'))

        Text($r('app.string.card_details'))
          .fontSize(12)
          .fontWeight(FontWeight.Bolder)
          .fontColor($r('app.color.white'))
          .size({ width: '100%', height: 25 })
          .backgroundColor($r('app.color.pink'))
          .borderRadius(20)
          .textAlign(TextAlign.Center)
          .shadow({
            radius: 3,
            offsetY: 3,
            color: $r('app.color.shadow')
          })
          .margin({ left: 6, right: 6 })
          .onClick(() => {
            postCardAction(this, {
              'action': 'router',
              'bundleName': 'com.samples.asorangeshopping',
              'abilityName': 'EntryAbility'
            });
          })
      }
      .layoutWeight(1)
      .padding({ right: 6 })
    }
    .width('100%')
    .height('100%')
    .alignItems(VerticalAlign.Top)
  }

  build() {
    Column() {
      this.Title();
      this.GoodsInfo();
    }
    .borderRadius(6)
    .width('100%')
    .height('100%')
    .backgroundImage($r('app.media.background'))
    .backgroundImageSize({ width: '100%', height: '100%' })
  }
}