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
struct MatrixDrawing {
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
        Button($r('app.string.DrawingMatrixBasic'))
          .onClick((): void => {
            if (this.xComponentContext) {
              this.xComponentContext.draw('CanvasGet', 'MatrixBasic');
            }
          })
          .margin({ top: 5, bottom: 5, left: 5, right: 5 })
        Button($r('app.string.DrawingTranslation'))
          .onClick((): void => {
            if (this.xComponentContext) {
              this.xComponentContext.draw('CanvasGet', 'TranslationOperation');
            }
          })
          .margin({ top: 5, bottom: 5, left: 5, right: 5 })
        Button($r('app.string.DrawingPreTranslation'))
          .onClick((): void => {
            if (this.xComponentContext) {
              this.xComponentContext.draw('CanvasGet', 'PreTranslationOperation');
            }
          })
          .margin({ top: 5, bottom: 5, left: 5, right: 5 })
        Button($r('app.string.DrawingPostTranslation'))
          .onClick((): void => {
            if (this.xComponentContext) {
              this.xComponentContext.draw('CanvasGet', 'PostTranslationOperation');
            }
          })
          .margin({ top: 5, bottom: 5, left: 5, right: 5 })
        Button($r('app.string.DrawingRotation'))
          .onClick((): void => {
            if (this.xComponentContext) {
              this.xComponentContext.draw('CanvasGet', 'RotationOperation');
            }
          })
          .margin({ top: 5, bottom: 5, left: 5, right: 5 })
        Button($r('app.string.DrawingPreRotation'))
          .onClick((): void => {
            if (this.xComponentContext) {
              this.xComponentContext.draw('CanvasGet', 'PreRotationOperation');
            }
          })
          .margin({ top: 5, bottom: 5, left: 5, right: 5 })
        Button($r('app.string.DrawingPostRotation'))
          .onClick((): void => {
            if (this.xComponentContext) {
              this.xComponentContext.draw('CanvasGet', 'PostRotationOperation');
            }
          })
          .margin({ top: 5, bottom: 5, left: 5, right: 5 })
        Button($r('app.string.DrawingScale'))
          .onClick((): void => {
            if (this.xComponentContext) {
              this.xComponentContext.draw('CanvasGet', 'ScaleOperation');
            }
          })
          .margin({ top: 5, bottom: 5, left: 5, right: 5 })
        Button($r('app.string.DrawingPreScale'))
          .onClick((): void => {
            if (this.xComponentContext) {
              this.xComponentContext.draw('CanvasGet', 'PreScaleOperation');
            }
          })
          .margin({ top: 5, bottom: 5, left: 5, right: 5 })
        Button($r('app.string.DrawingPostScale'))
          .onClick((): void => {
            if (this.xComponentContext) {
              this.xComponentContext.draw('CanvasGet', 'PostScaleOperation');
            }
          })
          .margin({ top: 5, bottom: 5, left: 5, right: 5 })
        Button($r('app.string.DrawingConcat'))
          .onClick((): void => {
            if (this.xComponentContext) {
              this.xComponentContext.draw('CanvasGet', 'ConcatOperation');
            }
          })
          .margin({ top: 5, bottom: 5, left: 5, right: 5 })
      }
      .width('100%')
      .height('30%')
    }
  }
}