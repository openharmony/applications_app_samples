/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import testNapi from 'libentry.so';
import { image } from '@kit.ImageKit';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct DecodeImages {
  @State pixelMap: PixelMap | undefined = undefined;

  aboutToAppear() {
    // 调用自定义的getSyncPixelMap接口，获取pixelMap
    this.pixelMap = testNapi.getSyncPixelMap(getContext(this).resourceManager, 'example.jpg');
  }

  build() {
    Row() {
      Column({ space: 30 }) {
        Image(this.pixelMap)
          .width(100)
          .height(100)
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