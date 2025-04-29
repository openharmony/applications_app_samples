/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import XComponentContext from '../../interface/XComponentContext';

@Entry
@Component
struct CanvasDrawing {
  private xComponentContext: XComponentContext | undefined = undefined;

  build() {
    Column() {
      XComponent({ id: 'basicEffectXComponent', type: XComponentType.SURFACE, libraryname: 'entry' })
        .onLoad((xComponentContext) => {
          this.xComponentContext = xComponentContext as XComponentContext;
        })
        .backgroundColor(Color.White)
        .width('100%')
        .height('70%')
      Flex({
        direction: FlexDirection.Row,
        wrap: FlexWrap.Wrap,
        justifyContent: FlexAlign.Start,
        alignItems: ItemAlign.Start
      }) {
        Button($r('app.string.DrawingCreateCanvas'))
          .onClick((): void => {
            if (this.xComponentContext) {
              this.xComponentContext.draw('CanvasGetByCPU', 'CanvasCreate');
            }
          })
          .margin({ top: 10, bottom: 10, left: 10, right: 10 })
        Button($r('app.string.DrawingClip'))
          .onClick((): void => {
            if (this.xComponentContext) {
              this.xComponentContext.draw('CanvasGet', 'ClipOperation');
            }
          })
          .margin({ top: 10, bottom: 10, left: 10, right: 10 })
        Button($r('app.string.DrawingSave'))
          .onClick((): void => {
            if (this.xComponentContext) {
              this.xComponentContext.draw('CanvasGet', 'SaveOperation');
            }
          })
          .margin({ top: 10, bottom: 10, left: 10, right: 10 })
        Button($r('app.string.DrawingSaveLayer'))
          .onClick((): void => {
            if (this.xComponentContext) {
              this.xComponentContext.draw('CanvasGet', 'SaveLayerOperation');
            }
          })
          .margin({ top: 10, bottom: 10, left: 10, right: 10 })
        Button($r('app.string.DrawingConcatMatrix'))
          .onClick((): void => {
            if (this.xComponentContext) {
              this.xComponentContext.draw('CanvasGet', 'ConcatMatrix');
            }
          })
          .margin({ top: 10, bottom: 10, left: 10, right: 10 })
        Button($r('app.string.DrawingDrawPixelMap'))
          .onClick((): void => {
            if (this.xComponentContext) {
              this.xComponentContext.draw('CanvasGet', 'CustomPixelMap');
            }
          })
          .margin({ top: 10, bottom: 10, left: 10, right: 10 })
        Button($r('app.string.DrawingDrawRegion'))
          .onClick((): void => {
            if (this.xComponentContext) {
              this.xComponentContext.draw('CanvasGet', 'DrawRegion');
            }
          })
          .margin({ top: 10, bottom: 10, left: 10, right: 10 })
      }
      .width('100%')
      .height('30%')
    }
  }
}