/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { ImageItemSlider } from '../../../../common/AttributeModificationTool';
import { IntroductionTitle } from '../../../../common/IntroductionTitle';
import { TitleBar } from '../../../../common/TitleBar';

class ImageSlider {
  isXAxis: boolean = false;
  axisName!: Resource;
}

@Entry
@Component
struct TranslateSample {
  @State imageTranslateX: number = 1;
  @State imageTranslateY: number = 1;
  @State containerTranslateX: number = 0;
  @State containerTranslateY: number = 0;
  private imageSliders: Array<ImageSlider> =
    [
      { isXAxis: true, axisName: $r('app.string.translate_x_axis') },
      { isXAxis: false, axisName: $r('app.string.translate_y_axis') }
    ];

  build() {
    Column() {
      TitleBar({ title: $r('app.string.scale') })
      Scroll() {
        Column() {
          IntroductionTitle({ introduction: $r('app.string.scale_image') })
          // Image translate
          Column() {
            Image($r('app.media.ic_scenery1'))
              .width(100)
              .height(100)
              .scale({ x: this.imageTranslateX, y: this.imageTranslateY })
          }
          .height(300)
          .margin({ left: 12, right: 12 })
          .width('100%')
          .borderRadius(24)
          .backgroundColor(Color.White)
          .justifyContent(FlexAlign.Center)

          ForEach(this.imageSliders, (item: ImageSlider) => {
            Row() {
              if (item.isXAxis) {
                ImageItemSlider({ changeValue: $imageTranslateX, min: 0, max: 4, name: item.axisName })
                  .id('scale_x')
              } else {
                ImageItemSlider({ changeValue: $imageTranslateY, min: 0, max: 2, name: item.axisName })
                  .id('scale_y')
              }
            }
            .padding(4)
            .margin({ left: 20, right: 20 })
            .justifyContent(FlexAlign.Center)
          })
        }
        .constraintSize({ minHeight: '100%' })
      }
    }
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}