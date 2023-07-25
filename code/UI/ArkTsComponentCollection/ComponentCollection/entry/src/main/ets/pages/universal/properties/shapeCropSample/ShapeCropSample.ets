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

import { IntroductionTitle } from '../../../../common/IntroductionTitle';
import { TitleBar } from '../../../../common/TitleBar';

@Extend(Row) function rowStyle() {
  .padding(8)
  .borderRadius(24)
  .height(230)
  .width('100%')
  .backgroundColor(Color.White)
  .margin({ left: 12, right: 12 })
}

@Entry
@Component
struct ShapeCropSample {
  build() {
    Column() {
      TitleBar({ title: $r('app.string.shape_crop') })
      IntroductionTitle({ introduction: $r('app.string.shape_crop_clip') })
      Row() {
        // 用一个200px直径的圆对图片进行裁剪
        Image($r('app.media.ic_scenery1'))
          .clip(new Circle({ width: 200, height: 200 }))
          .width(350)
          .height(200)
      }
      .rowStyle()

      IntroductionTitle({ introduction: $r('app.string.shape_crop_mask') })
      Row() {
        // 给图片添加了一个200px*200px的圆形遮罩
        Image($r('app.media.ic_scenery1'))
          .mask(new Circle({ width: 200, height: 200 }).fill(Color.Gray))
          .width(350)
          .height(200)
      }
      .rowStyle()
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}