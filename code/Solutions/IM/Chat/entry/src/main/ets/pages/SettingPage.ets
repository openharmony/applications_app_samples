/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import router from '@ohos.router';

@Entry
@Component
export struct SettingPage {
  private scroller: Scroller = new Scroller()

  build() {
    Column() {
      Scroll(this.scroller) {
        Column() {
          Column() {
            Row() {
              Image($r('app.media.personality3'))
                .width(80)
                .height(80)
              Column({ space: 10 }) {
                Row() {
                  Text($r('app.string.myself'))
                    .fontSize(15)
                    .fontColor(Color.Black)
                }

                Text("聊天号：*******")
                  .fontSize(15)
                  .fontColor(Color.Black)
              }
              .id('mineMessage')
              .alignItems(HorizontalAlign.Start)
              .padding({ left: 20 })
            }
            .backgroundColor(Color.White)
            .padding(10)
            .backgroundColor(Color.White)
            .width('100%')
          }
          .backgroundColor(Color.White)
          .height(100)
          .onClick(() => {
            router.pushUrl({ url: 'pages/UserInfo' })
          })
          .margin({ bottom: 10 })

          Column() {
            SettingItemView({ image: $r('app.media.icon_me_photo'), text: $r("app.string.album") })
          }

          Column() {
            SettingItemView({ image: $r('app.media.icon_me_collect'), text: $r("app.string.collection") })
          }

          Column() {
            SettingItemView({ image: $r('app.media.icon_me_money'), text: $r("app.string.wallet") })
          }

          Column() {
            SettingItemView({ image: $r('app.media.icon_me_card'), text: $r("app.string.card") })
          }
          .margin({ bottom: 10 })

          Column() {
            SettingItemView({ image: $r('app.media.icon_me_smail'), text: $r("app.string.expression") })
          }
          .margin({ bottom: 10 })

          Column() {
            SettingItemView({ image: $r('app.media.icon_me_setting'), text: $r("app.string.setting") })
          }
          .id('setting')
          .margin({ bottom: 10 })
          .onClick(() => {
            router.pushUrl({ url: 'pages/Setting' })
          })

          Column() {
            SettingItemView({ image: $r('app.media.icon_me_setting'), text: $r("app.string.chat_list") })
          }
          .onClick(() => {
            router.pushUrl({ url: 'pages/Index' })
          })
        }
      }
    }
    .backgroundColor("#cccccc")
    .width("100%")
    .height("100%")
  }

  pageTransition() {
    PageTransitionEnter({ duration: 0 })
    PageTransitionExit({ duration: 0 })
  }
}

@Component
export struct SettingItemView {
  private image: string | Resource
  private text: string | Resource

  build() {
    Stack({ alignContent: Alignment.End }) {
      Row() {
        Image(this.image)
          .width(45)
          .height(45)
        Text(this.text)
          .fontSize(20)
          .fontColor('#000000')
          .margin({ left: 10 })
      }
      .width('100%')
      .height(60)
      .padding({ left: 15, right: 15 })
      .backgroundColor(Color.White)

      Image($r('app.media.right'))
        .height(30)
        .width(20)
        .align(Alignment.End)
        .margin({ right: 15 })
    }
    .width('100%')
    .height(60)
  }
}