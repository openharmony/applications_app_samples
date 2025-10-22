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
  @State message: string = 'ComPlex Text ArkTs Test\n';

  build() {
    Row(){

      Column( { space: 5 }) {
        Text(this.message)
          .fontSize(25)

        Button($r("app.string.Button_page_Multilanguage"))
          .fontSize('12fp')
          .fontWeight(500)
          .margin({ bottom: 24, left: 5 })
          .onClick(() => {
            this.getUIContext().getRouter().pushUrl({ url: 'pages/multilanguage/MultilanguageText' })
          })
          .width('60%')
          .height('4%')
          .shadow(ShadowStyle.OUTER_DEFAULT_LG)

        Button($r("app.string.Button_page_Multiline"))
          .fontSize('12fp')
          .fontWeight(500)
          .margin({ bottom: 24, left: 5 })
          .onClick(() => {
            this.getUIContext().getRouter().pushUrl({ url: 'pages/multiline/MultilineText' })
          })
          .width('60%')
          .height('4%')
          .shadow(ShadowStyle.OUTER_DEFAULT_LG)

        Button($r("app.string.Button_page_Complexstyle"))
          .fontSize('12fp')
          .fontWeight(500)
          .margin({ bottom: 24, left: 5 })
          .onClick(() => {
            this.getUIContext().getRouter().pushUrl({ url: 'pages/complexStyle/ComplexStyleText' })
          })
          .width('60%')
          .height('4%')
          .shadow(ShadowStyle.OUTER_DEFAULT_LG)

        Button($r("app.string.IndependentShaping"))
          .fontSize('12fp')
          .fontWeight(500)
          .margin({ bottom: 24, left: 5 })
          .onClick(() => {
            this.getUIContext().getRouter().pushUrl({ url: 'pages/shape/IndependentShaping' })
          })
          .width('60%')
          .height('4%')
          .shadow(ShadowStyle.OUTER_DEFAULT_LG)




      }.width('100%')
    }.height('100%')

  }
}