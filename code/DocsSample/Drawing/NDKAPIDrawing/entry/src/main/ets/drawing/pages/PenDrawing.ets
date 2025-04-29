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
struct PenDrawing {
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
        Button($r('app.string.DrawingPenBasic'))
          .onClick((): void => {
            if (this.xComponentContext) {
              this.xComponentContext.draw('CanvasGet', 'PenBasic');
            }
          })
          .margin({ top: 10, bottom: 10, left: 10, right: 10 })
        Button($r('app.string.DrawingCapJoin'))
          .onClick((): void => {
            if (this.xComponentContext) {
              this.xComponentContext.draw('CanvasGet', 'Stroke');
            }
          })
          .margin({ top: 10, bottom: 10, left: 10, right: 10 })
        Button($r('app.string.DrawingMiterLimit'))
          .onClick((): void => {
            if (this.xComponentContext) {
              this.xComponentContext.draw('CanvasGet', 'MiterLimit');
            }
          })
          .margin({ top: 10, bottom: 10, left: 10, right: 10 })
        Button($r('app.string.DrawingImageFilter'))
          .onClick((): void => {
            if (this.xComponentContext) {
              this.xComponentContext.draw('CanvasGet', 'ImageFilter');
            }
          })
          .margin({ top: 10, bottom: 10, left: 10, right: 10 })
        Button($r('app.string.DrawingPathEffect'))
          .onClick((): void => {
            if (this.xComponentContext) {
              this.xComponentContext.draw('CanvasGet', 'PathEffect');
            }
          })
          .margin({ top: 10, bottom: 10, left: 10, right: 10 })
        Button($r('app.string.DrawingShaderEffect'))
          .onClick((): void => {
            if (this.xComponentContext) {
              this.xComponentContext.draw('CanvasGet', 'PenLinearGradient');
            }
          })
          .margin({ top: 10, bottom: 10, left: 10, right: 10 })
        Button($r('app.string.DrawingMaskFilter'))
          .onClick((): void => {
            if (this.xComponentContext) {
              this.xComponentContext.draw('CanvasGet', 'MaskFilterPen');
            }
          })
          .margin({ top: 10, bottom: 10, left: 10, right: 10 })
      }
      .width('100%')
      .height('30%')
    }
  }
}