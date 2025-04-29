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
import { image } from '@kit.ImageKit';
import { resourceManager } from '@kit.LocalizationKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct PixelMapDrawing {
  private xComponentContext: XComponentContext | undefined = undefined;
  private pMap: image.PixelMap | undefined = undefined;
  aboutToAppear() {
    const context: Context = getContext(this);
    const resourceMgr: resourceManager.ResourceManager = context.resourceManager;
    resourceMgr.getRawFileContent('startIcon.png').then((fileData: Uint8Array) => {
      console.log('Succeeded in getting RawFileContent');
      const buffer = fileData.buffer.slice(0);
      const imageSource: image.ImageSource = image.createImageSource(buffer);
      imageSource.createPixelMap().then((pMap: image.PixelMap) => {
        this.pMap = pMap;
      }).catch((err: BusinessError) => {
        console.error('Failed to creating PixelMap');
      });
    }).catch((err: BusinessError) => {
      console.error('Failed to get RawFileContent');
    });
  }

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
        Button($r('app.string.DrawingLocalPixelMap'))
          .onClick((): void => {
            if (this.xComponentContext) {
              this.xComponentContext.drawImage('CanvasGet', 'LocalPixelMap', this.pMap);
            }
          })
          .margin({ top: 10, bottom: 10, left: 10, right: 10 })
        Button($r('app.string.DrawingCustomPixelMap'))
          .onClick((): void => {
            if (this.xComponentContext) {
              this.xComponentContext.draw('CanvasGet', 'CustomPixelMap');
            }
          })
          .margin({ top: 10, bottom: 10, left: 10, right: 10 })
      }
      .width('100%')
      .height('30%')
    }
  }
}