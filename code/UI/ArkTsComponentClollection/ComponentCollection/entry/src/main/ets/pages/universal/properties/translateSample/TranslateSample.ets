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

import { CommonItemSlider } from '../../../../common/AttributeModificationTool'
import { IntroductionTitle } from '../../../../common/IntroductionTitle'
import { TitleBar } from '../../../../common/TitleBar'

@Entry
@Component
struct TranslateSample {
  @State imageTranslateX: number = 0
  @State imageTranslateY: number = 0
  @State containerTranslateX: number = 0
  @State containerTranslateY: number = 0
  private componentSliders: Array<{
    isXAxis: boolean,
    axisName: Resource
  }> =
    [
      { isXAxis: true, axisName: $r('app.string.translate_x_axis') },
      { isXAxis: false, axisName: $r('app.string.translate_y_axis') }
    ]
  private imageSliders: Array<{
    isXAxis: boolean,
    axisName: Resource
  }> =
    [
      { isXAxis: true, axisName: $r('app.string.translate_x_axis') },
      { isXAxis: false, axisName: $r('app.string.translate_y_axis') }
    ]

  build() {
    Column() {
      TitleBar({ title: $r('app.string.graphic_transformation_translate') })
      Scroll() {
        Column() {
          IntroductionTitle({ introduction: $r('app.string.translate_image') })
          // Image translate
          Column() {
            Image($r('app.media.ic_scenery1'))
              .width(160)
              .height(120)
              .translate({ x: this.imageTranslateX, y: this.imageTranslateY })
          }
          .height(180)
          .padding(12)
          .width('100%')
          .borderRadius(24)
          .backgroundColor(Color.White)
          .justifyContent(FlexAlign.Center)

          ForEach(this.imageSliders, (item) => {
            Row() {
              if (item.isXAxis) {
                CommonItemSlider({ changeValue: $imageTranslateX, min: -20, max: 20, name: item.axisName })
              } else {
                CommonItemSlider({ changeValue: $imageTranslateY, min: -20, max: 20, name: item.axisName })
              }
            }
            .padding(4)
            .margin({ left: 10, right: 10 })
            .justifyContent(FlexAlign.Center)
          })
          IntroductionTitle({ introduction: $r('app.string.translate_container') })
          // Container translate
          Column() {
            Column() {
              this.TextInfo()
              this.TextInfo()
              this.TextInfo()
            }
            .margin({ top: 20, bottom: 20 })
            .backgroundColor($r('app.color.background_grey'))
            .translate({ x: this.containerTranslateX, y: this.containerTranslateY })
            .justifyContent(FlexAlign.Center)
          }
          .width('100%')
          .borderRadius(24)
          .backgroundColor(Color.White)
          .padding({ top: 4, bottom: 4 })

          ForEach(this.componentSliders, (item) => {
            Row() {
              if (item.isXAxis) {
                CommonItemSlider({ changeValue: $containerTranslateX, min: -20, max: 20, name: item.axisName }) // -20和20为平移的区间
              } else {
                CommonItemSlider({ changeValue: $containerTranslateY, min: -20, max: 20, name: item.axisName })
              }
            }
            .padding(4)
            .margin({ left: 10, right: 10 })
            .justifyContent(FlexAlign.Center)
          })
        }
        .constraintSize({ minHeight: '100%' })
      }
    }
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }

  @Builder TextInfo() {
    Text('ArkUI')
      .margin(8)
      .fontSize(18)
  }
}