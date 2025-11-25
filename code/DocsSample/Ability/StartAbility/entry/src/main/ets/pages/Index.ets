/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

@Entry
@Component
struct Index {

  build() {
    Row() {
      Column() {
        Button('Navigation')
          .fontSize(20)
          .width('80%')
          .height(50)
          .margin(10)
          .onClick(() => {
            this.getUIContext().getRouter().pushUrl({ url: 'pages/NavigationIndex' });
          })

        Button('Email')
          .fontSize(20)
          .width('80%')
          .height(50)
          .margin(10)
          .onClick(() => {
            this.getUIContext().getRouter().pushUrl({ url: 'pages/MailIndex' });
          })

        Button('Finance')
          .fontSize(20)
          .width('80%')
          .height(50)
          .margin(10)
          .onClick(() => {
            this.getUIContext().getRouter().pushUrl({ url: 'pages/FinanceIndex' });
          })

        Button('Emailto')
          .fontSize(20)
          .width('80%')
          .height(50)
          .margin(10)
          .onClick(() => {
            this.getUIContext().getRouter().pushUrl({ url: 'pages/MailtoIndex' });
          })

        Button('Flight')
          .fontSize(20)
          .width('80%')
          .height(50)
          .margin(10)
          .onClick(() => {
            this.getUIContext().getRouter().pushUrl({ url: 'pages/FlightIndex' });
          })

        Button('Express')
          .fontSize(20)
          .width('80%')
          .height(50)
          .margin(10)
          .onClick(() => {
            this.getUIContext().getRouter().pushUrl({ url: 'pages/ExpressIndex' });
          })

        Button('File')
          .fontSize(20)
          .width('80%')
          .height(50)
          .margin(10)
          .onClick(() => {
            this.getUIContext().getRouter().pushUrl({ url: 'pages/FileIndex' });
          })

        Button('PhotoEdit')
          .fontSize(20)
          .width('80%')
          .height(50)
          .margin(10)
          .onClick(() => {
            this.getUIContext().getRouter().pushUrl({ url: 'pages/PhotoIndex' });
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
    }
    .height('100%')
  }
}