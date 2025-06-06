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
struct CanvasGetResult {
  private xComponentContext: XComponentContext | undefined = undefined;

  build() {
    Column() {
      XComponent({ id: 'canvasGetResultXComponent', type: XComponentType.SURFACE, libraryname: 'entry' })
        .onLoad((xComponentContext) => {
          console.info('XComponent loaded successfully');
          this.xComponentContext = xComponentContext as XComponentContext;
        })
        .backgroundColor(Color.White)
        .width('100%')
        .height('70%')
      Row() {
        Button($r('app.string.CanvasGet'))
          .onClick((): void => {
            if (this.xComponentContext) {
              this.xComponentContext.draw('CanvasGet', 'Point');
            }
          })
        Button($r('app.string.CanvasGetByCPU'))
          .onClick((): void => {
            if (this.xComponentContext) {
              this.xComponentContext.draw('CanvasGetByCPU', 'Arc');
            }
          })
        Button($r('app.string.CanvasGetByGPU'))
          .onClick((): void => {
            if (this.xComponentContext) {
              this.xComponentContext.draw('CanvasGetByGPU', 'Circle');
            }
          })
      }
      .justifyContent(FlexAlign.SpaceEvenly)
      .width('100%')
      .height('8%')
    }
  }
}