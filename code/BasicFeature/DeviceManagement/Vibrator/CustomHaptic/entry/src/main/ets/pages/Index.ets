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

import DisplayModule from '../module/DisplayModule'
import MyInfoModule from '../module/MyInfoModule'

@Entry
@Component
struct Index {
  private controller: TabsController = new TabsController()
  @State barIndex: number = 0
  @State vibrationIntensity: string = 'L'
  @State php: string = 'ets'

  @Builder
  Discover() {

    Column({ space: 5 }) {
      Text($r("app.string.index_find"))
        .fontSize(16)
        .fontColor(this.barIndex === 0 ? "#2AEFCC" : Color.White)
    }
    .id('indexDiscover')
    .height('100%')
    .width("100%")
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.barIndex = 0
      this.controller.changeIndex(this.barIndex);
    })
  }

  @Builder
  My() {
    Column({ space: 5 }) {
      Text($r("app.string.index_my"))
        .fontSize(16)
        .fontColor(this.barIndex === 1 ? "#2AEFCC" : Color.White)
    }
    .id('indexMy')
    .height('100%')
    .width("100%")
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.barIndex = 1
      this.controller.changeIndex(this.barIndex);
    })
  }

  build() {
    Tabs({
      barPosition: BarPosition.End,
      controller: this.controller
    }) {
      TabContent() {
        DisplayModule({
          vibrationIntensity: $vibrationIntensity,
          php: $php
        })
      }
      .tabBar(this.Discover())

      TabContent() {
        Column({ space: 100 }) {
          Column({ space: 50 }) {
            Image($r("app.media.icon5"))
              .objectFit(ImageFit.ScaleDown)
              .height("50%")
              .width("50%")
            Text($r("app.string.index_welcome"))
              .fontColor(Color.White)
              .fontSize(20)
              .width("100%")
              .height("10%")
              .textAlign(TextAlign.Center)
          }
          .height("30%")
          .width("100%")
          .justifyContent(FlexAlign.Center)

          Column({ space: 20 }) {
            MyInfoModule({
              vibrationIntensity: $vibrationIntensity,
              php: $php
            })
          }
          .height("5%")
          .alignItems(HorizontalAlign.Center)
        }
        .width('100%')
        .height('100%')
        .backgroundColor('#f2191a32')
      }
      .tabBar(this.My())
    }
    .backgroundColor('#e6191a32')
    .onChange((index: number) => {
      this.barIndex = index;
    })
  }
}
