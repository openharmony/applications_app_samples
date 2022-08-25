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

import { FirstNavInfo } from '../model/listItem'
import { FIRST_NAV_LIST, MyDataSource } from '../model/constant'
import { SecondaryNavigation } from '../common/components/secondaryNavigation'


@Component
struct ItemTemplate {
  @ObjectLink item: FirstNavInfo
  @State flag: boolean = true

  build() {
    Column() {
      Row() {
        Image($r('app.media.home'))
          .objectFit(ImageFit.Contain)
          .width('15.7%')
          .height(48)
        Text(this.item.title)
          .fontColor('#182431')
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .width('55%')
          .margin({ left: '5.2%', right: '20.2%' })
        Image($r('app.media.ic_public_arrow_right'))
          .objectFit(ImageFit.Contain)
          .width('4%')
          .height(24).rotate({ z: 1, angle: this.item.isClicked ? 270 : 90 })
      }
      .onClick(() => {
        animateTo({ duration: 300 }, () => {
          this.item.isClicked = !this.item.isClicked
        })
      })

      if (this.item.isClicked) {
        Column() {
          SecondaryNavigation({ index: this.item.secondIndex })
        }
        .clip(true)
        .transition({ opacity: 0 })
        .width('100%')
      }
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Start)
  }
}

@Entry
@Component
struct homePageSample {
  @State info: MyDataSource = new MyDataSource()
  @State clicked: boolean = false

  aboutToAppear() {
    this.info.replace(FIRST_NAV_LIST)
  }

  build() {
    Column() {
      Row() {
        Text('eTS Gallery')
          .fontColor('#000000')
          .fontSize(30)
          .fontWeight(FontWeight.Medium)
          .width('86.7%')
      }
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Center)
      .padding({ left: '6.7%' })
      .width('100%')
      .height(56)

      List({ space: 12, initialIndex: 0 }) {
        LazyForEach(this.info, (item) => {
          ListItem() {
            ItemTemplate({ item: item })
          }
          .width('93.3%')
          .borderRadius(24)
          .padding({ left: '3.6%', right: '5.4%', top: 12, bottom: 12 })
          .backgroundColor('#ffffff')
        }, item => item.title)
      }
      .layoutWeight(1)
      .listDirection(Axis.Vertical)
      .padding({ left: '3.3%', right: '3.3%', top: 8, bottom: 8 })
    }
    .flexGrow(1)
    .backgroundColor('#F1F3F5')
    .width('100%')
    .height('100%')
  }
}