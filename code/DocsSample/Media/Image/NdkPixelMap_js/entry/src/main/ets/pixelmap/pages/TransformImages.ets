/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import testNapi from 'libentry.so';
import { image } from '@kit.ImageKit';
import { router } from '@kit.ArkUI';
import Logger from '../../common/Logger';

@Entry
@Component
struct TransformImages {
  @State message: string = 'IMAGE'
  @State pixelMap: image.PixelMap | undefined = undefined;

  build() {
    Row() {
      Column({ space: 30 }) {
        Button($r('app.string.IMAGE'))
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            const color: ArrayBuffer = new ArrayBuffer(96);
            let opts: image.InitializationOptions = {
              alphaType: 0,
              editable: true,
              pixelFormat: 4,
              scaleMode: 1,
              size: { height: 4, width: 6 }
            };
            image.createPixelMap(color, opts)
              .then((pixelmap: image.PixelMap) => {
                this.pixelMap = pixelmap;
                testNapi.testGetImageInfo(this.pixelMap);
                Logger.info('Test GetImageInfo success');

                testNapi.testAccessPixels(this.pixelMap);
                Logger.info('Test AccessPixels success');

                testNapi.testUnAccessPixels(this.pixelMap);
                Logger.info('Test UnAccessPixels success');
              });
          })
        Button($r('app.string.Go_Back'))
          .onClick(() => {
            router.back();
          });
      }
      .width('100%')
    }
    .height('100%')
  }
}