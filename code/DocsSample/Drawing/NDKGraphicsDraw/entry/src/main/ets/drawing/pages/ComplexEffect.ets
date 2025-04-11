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
struct ComplexEffect {
  private xComponentContext: XComponentContext | undefined = undefined;

  build() {
    Column() {
      XComponent({ id: 'complexEffectXComponent', type: XComponentType.SURFACE, libraryname: 'entry' })
        .onLoad((xComponentContext) => {
          this.xComponentContext = xComponentContext as XComponentContext;
        })
        .backgroundColor(Color.White)
        .width('100%')
        .height('70%')
      Row() {
        Button($r('app.string.MixedMode'))
          .onClick((): void => {
            if (this.xComponentContext) {
              this.xComponentContext.draw('CanvasGet', 'MixedMode');
            }
          })
        Button($r('app.string.PathEffect'))
          .onClick((): void => {
            if (this.xComponentContext) {
              this.xComponentContext.draw('CanvasGet', 'PathEffect');
            }
          })
      }
      .justifyContent(FlexAlign.SpaceEvenly)
      .width('100%')
      .height('8%')
      Row() {
        Button($r('app.string.LinearGradient'))
          .onClick((): void => {
            if (this.xComponentContext) {
              this.xComponentContext.draw('CanvasGet', 'LinearGradient');
            }
          })
        Button($r('app.string.PathGradient'))
          .onClick((): void => {
            if (this.xComponentContext) {
              this.xComponentContext.draw('CanvasGet', 'PathGradient');
            }
          })
        Button($r('app.string.SectorGradient'))
          .onClick((): void => {
            if (this.xComponentContext) {
              this.xComponentContext.draw('CanvasGet', 'SectorGradient');
            }
          })
      }
      .justifyContent(FlexAlign.SpaceEvenly)
      .width('100%')
      .height('8%')
      Row() {
        Button($r('app.string.ColorFilter'))
          .onClick((): void => {
            if (this.xComponentContext) {
              this.xComponentContext.draw('CanvasGet', 'ColorFilter');
            }
          })
        Button($r('app.string.ImageFilter'))
          .onClick((): void => {
            if (this.xComponentContext) {
              this.xComponentContext.draw('CanvasGet', 'ImageFilter');
            }
          })
        Button($r('app.string.MaskFilter'))
          .onClick((): void => {
            if (this.xComponentContext) {
              this.xComponentContext.draw('CanvasGet', 'MaskFilter');
            }
          })
      }
      .justifyContent(FlexAlign.SpaceEvenly)
      .width('100%')
      .height('8%')
    }
  }
}