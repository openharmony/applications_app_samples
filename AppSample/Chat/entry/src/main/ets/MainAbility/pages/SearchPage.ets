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
import router from '@ohos.router';

@Entry
@Component
struct SearchPage {
  @State changeValue: string = ''

  build() {
    Column() {
      Row() {
        Stack({ alignContent: Alignment.Center }) {
          Row() {
            Image($r('app.media.search'))
              .width(20)
              .height(20)
              .opacity(0.5)
              .margin({ left: 10 })
            Text("搜索")
              .fontSize(20)
              .opacity(0.5)
              .padding({ left: 10 })
          }
        }
        .backgroundColor(Color.White)
        .height(40)
        .width('90%')
        .borderRadius(10)

        Text("取消")
          .key('cancelSearchBtn')
          .fontSize(16)
          .fontColor("#0066cc")
          .margin({ left: 10 })
          .onClick(() => {
            router.back()
          })
      }
      .margin({ top: 30 })

      Row() {
        Text("搜索指定内容")
          .fontSize(16)
      }
      .opacity(0.5)
      .padding(30)
      .height(86)

      Row() {
        Text("社区")
          .fontColor("#0066cc")
          .width("33%")
          .fontSize(20)
          .padding(20)
        Text("文章")
          .fontColor("#0066cc")
          .width("33%")
          .fontSize(20)
          .padding(20)
        Text("表情")
          .fontColor("#0066cc")
          .width("33%")
          .fontSize(20)
          .padding(20)
      }
      .margin({ left: "7%" })
      .justifyContent(FlexAlign.SpaceBetween)

      Row() {
        Text("小程序")
          .fontColor("#0066cc")
          .width("33%")
          .fontSize(20)
          .padding(20)
        Text("音乐")
          .fontColor("#0066cc")
          .width("33%")
          .fontSize(20)
          .padding(20)
        Text("公众号")
          .fontColor("#0066cc")
          .width("33%")
          .fontSize(20)
          .padding(20)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ left: "7%" })

      Row() {
        Text("服务")
          .fontColor("#0066cc")
          .width("33%")
          .fontSize(20)
          .padding(20)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ left: "7%" })
    }.padding(10).backgroundColor("#f5f5f5").height('100%')
  }

  pageTransition() {
    PageTransitionEnter({ duration: 0 })
    PageTransitionExit({ duration: 0 })
  }
}