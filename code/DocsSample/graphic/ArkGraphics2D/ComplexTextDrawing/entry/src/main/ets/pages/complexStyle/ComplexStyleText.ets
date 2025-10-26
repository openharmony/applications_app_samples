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
struct ComplexText {
  @State message: string = 'ComPlex Style Text ArkTs Test\n';
  build() {
    Row(){
      Column() {
        Text(this.message)
          .fontSize(25)

        Button($r('app.string.ComplexStyle_Button_example1'))
          .fontSize('12fp')
          .fontWeight(500)
          .margin({ bottom: 24, left: 5 })
          .onClick(() => {
            this.getUIContext().getRouter().pushUrl({ url: 'pages/complexStyle/ComplexStyleExample1' })
          })
          .width('90%')
          .height('4%')
          .shadow(ShadowStyle.OUTER_DEFAULT_LG)

        Button($r('app.string.ComplexStyle_Button_example2'))
          .fontSize('12fp')
          .fontWeight(500)
          .margin({ bottom: 24, left: 5 })
          .onClick(() => {
            this.getUIContext().getRouter().pushUrl({ url: 'pages/complexStyle/ComplexStyleExample2' })
          })
          .width('90%')
          .height('4%')
          .shadow(ShadowStyle.OUTER_DEFAULT_LG)

        Button($r('app.string.ComplexStyle_Button_example3'))
          .fontSize('12fp')
          .fontWeight(500)
          .margin({ bottom: 24, left: 5 })
          .onClick(() => {
            this.getUIContext().getRouter().pushUrl({ url: 'pages/complexStyle/ComplexStyleExample3' })
          })
          .width('90%')
          .height('4%')
          .shadow(ShadowStyle.OUTER_DEFAULT_LG)

        Button($r('app.string.ComplexStyle_Button_example4'))
          .fontSize('12fp')
          .fontWeight(500)
          .margin({ bottom: 24, left: 5 })
          .onClick(() => {
            this.getUIContext().getRouter().pushUrl({ url: 'pages/complexStyle/ComplexStyleExample4' })
          })
          .width('90%')
          .height('4%')
          .shadow(ShadowStyle.OUTER_DEFAULT_LG)

        Button($r('app.string.ComplexStyle_Button_example5'))
          .fontSize('12fp')
          .fontWeight(500)
          .margin({ bottom: 24, left: 5 })
          .onClick(() => {
            this.getUIContext().getRouter().pushUrl({ url: 'pages/complexStyle/ComplexStyleExample5' })
          })
          .width('90%')
          .height('4%')
          .shadow(ShadowStyle.OUTER_DEFAULT_LG)


      }.width('100%')
    }.height('100%')

  }
}