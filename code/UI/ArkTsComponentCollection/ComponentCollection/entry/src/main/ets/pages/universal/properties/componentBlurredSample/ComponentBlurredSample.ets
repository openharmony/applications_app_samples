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

import { TitleBar } from '../../../../common/TitleBar';

@Entry
@Component
struct ComponentBlurredSample {
  build() {
    Column() {
      TitleBar({ title: $r('app.string.component_blurred') })
      Column() {
        Row() {
          Text($r('app.string.component_blurred_thin'))
        }
        .justifyContent(FlexAlign.Center)
        .width('50%')
        .height('50%')
        .backgroundBlurStyle(BlurStyle.Thin)
      }
      .justifyContent(FlexAlign.Center)
      .height('90%')
      .width('90%')
      .backgroundImage($r('app.media.ic_scenery1'))
      .backgroundImageSize(ImageSize.Cover)
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}