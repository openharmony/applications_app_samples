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
struct ShapeDrawing {
  private xComponentContext: XComponentContext | undefined = undefined;

  build() {
    Column() {
      XComponent({ id: 'shapeDrawingXComponent', type: XComponentType.SURFACE, libraryname: 'entry' })
        .onLoad((xComponentContext) => {
          this.xComponentContext = xComponentContext as XComponentContext;
        })
        .backgroundColor(Color.White)
        .width('100%')
        .height('80%')
      Row() {
        Button($r('app.string.Point'))
          .onClick((): void => {
            if (this.xComponentContext) {
              this.xComponentContext.draw('CanvasGet', 'Point');
            }
          })
        Button($r('app.string.Arc'))
          .onClick((): void => {
            if (this.xComponentContext) {
              this.xComponentContext.draw('CanvasGet', 'Arc');
            }
          })
        Button($r('app.string.Circle'))
          .onClick((): void => {
            if (this.xComponentContext) {
              this.xComponentContext.draw('CanvasGet', 'Circle');
            }
          })
        Button($r('app.string.Path'))
          .onClick((): void => {
            if (this.xComponentContext) {
              this.xComponentContext.draw('CanvasGet', 'Path');
            }
          })
      }
      .justifyContent(FlexAlign.SpaceEvenly)
      .width('100%')
      .height('7%')
      Row() {
        Button($r('app.string.Region'))
          .onClick((): void => {
            if (this.xComponentContext) {
              this.xComponentContext.draw('CanvasGet', 'Region');
            }
          })
        Button($r('app.string.Rect'))
          .onClick((): void => {
            if (this.xComponentContext) {
              this.xComponentContext.draw('CanvasGet', 'Rect');
            }
          })
        Button($r('app.string.RoundRect'))
          .onClick((): void => {
            if (this.xComponentContext) {
              this.xComponentContext.draw('CanvasGet', 'RoundRect');
            }
          })
      }
      .justifyContent(FlexAlign.SpaceEvenly)
      .width('100%')
      .height('7%')
    }
  }
}