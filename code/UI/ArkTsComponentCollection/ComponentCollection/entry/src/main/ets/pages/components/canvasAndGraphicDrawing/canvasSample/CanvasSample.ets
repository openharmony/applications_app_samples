/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { TitleBar } from '../../../../common/TitleBar';
import { LEFT_PADDING, RIGHT_PADDING } from '../../ComponentData';

@Extend(Column) function cardStyle() {
  .backgroundColor($r('app.color.white'))
  .borderRadius(16)
  .width('100%')
  .padding(12)
}

@Entry
@Component
struct CanvasSample {
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);

  build() {
    Column() {
      TitleBar({ title: $r('app.string.canvas_title') })
      Column() {
        Column() {
          Canvas(this.context)
            .backgroundColor('#ff9750d6')
            .onReady(() => {
              this.context.fillRect(40, 30, 100, 100)
            })
            .onAppear(() => {
              this.context.fillStyle = '#fc57cbcb'
              this.context.lineWidth = 50
              this.context.strokeStyle = '#ff00ff'
            })
            .size({ width: 300, height: 200 })
        }.cardStyle()
        .height('35%')
      }.padding({ left: LEFT_PADDING, right: RIGHT_PADDING })
    }
    .backgroundColor($r('app.color.background_light_gray'))
    .height('100%')
  }
}