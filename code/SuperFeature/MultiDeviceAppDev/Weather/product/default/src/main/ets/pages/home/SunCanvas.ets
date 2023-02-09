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

import { Style } from '@ohos/common'
import { initMoon, initSun } from '../../feature/SunCanvasFeature'

@Preview
@Component
export default struct SunCanvas {
  private sunImg: ImageBitmap = new ImageBitmap('/common/images/sun.png')
  private moonImg: ImageBitmap = new ImageBitmap('/common/images/moon.png')
  private iconMoon: ImageBitmap = new ImageBitmap('/common/images/icon_moon.svg')
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)

  build() {
    Row() {
      Canvas(this.context)
        .height('95%')
        .aspectRatio(1.8)
        .onReady(() => {
          this.context.clearRect(0, 0, this.context.width, this.context.height)
          initSun(this.context, this.sunImg)
          initMoon(this.context, this.moonImg, this.iconMoon)
        })
    }
    .height(Style.CARD_HEIGHT)
    .justifyContent(FlexAlign.Center)
    .backgroundColor(Style.CARD_BACKGROUND_COLOR)
    .borderRadius(Style.NORMAL_RADIUS)
  }
}