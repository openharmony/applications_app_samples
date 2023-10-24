/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http:// www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { ChangeVerticalAlign, ChangeObjectFit } from './ChangePanel'
import { IntroductionTitle } from '../../../../common/IntroductionTitle'
import { TitleBar } from '../../../../common/TitleBar'

@Extend(Column) function backgroundStyle() {
  .size({ width: '100%' })
  .margin({ top: 12 })
  .padding(12)
  .borderRadius(24)
  .justifyContent(FlexAlign.SpaceBetween)
  .backgroundColor(Color.White)
}

@Entry
@Component
struct ImageSpanSample {
  @State imageSpanAlignment: ImageSpanAlignment = ImageSpanAlignment.BOTTOM
  @State imageFit: ImageFit = ImageFit.Cover

  build() {
    Column() {
      TitleBar({ title: $r('app.string.image_span_title') })
      Scroll() {
        Column() {
          IntroductionTitle({ introduction: $r('app.string.image_span_and_span') })
          Column() {
            Text(){
              Span($r('app.string.text_content_en_first'))
              ImageSpan($r('app.media.banner'))
                .verticalAlign(this.imageSpanAlignment)
                .objectFit(this.imageFit)
                .width(300)
                .height(350)
                .border({ width: 1 })
              Span($r('app.string.text_content_en_last'))
            }
          }
          .backgroundStyle()

          IntroductionTitle({ introduction: $r('app.string.image_span_vertical_align_and_object_fit') })
          Column() {
            ChangeVerticalAlign({
              imageSpanAlignment: $imageSpanAlignment
            })
            ChangeObjectFit({
              imageFit: $imageFit
            })
          }
          .backgroundStyle()
          .margin({ bottom: 80 })
        }
        .constraintSize({ minHeight: '100%' }) // Let the minHeight of the component cover screen at least
      }
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}