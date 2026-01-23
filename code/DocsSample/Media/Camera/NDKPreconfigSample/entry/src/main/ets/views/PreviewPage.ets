 /*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { promptAction, router } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { http } from '@kit.NetworkKit';
import { image } from '@kit.ImageKit';
import cameraDemo from 'libentry.so';


class RouTmp {
  uri: string = ''
  pixelMap:PixelMap | undefined = undefined

}
@Entry
@Component
struct PreviewPage {
  @State imgUri: string = '';
  @State imgPixelMap: PixelMap | undefined = undefined;

  build() {
    Column() {
      Column() {
        Column() {
          Text('back')
            .size({ width: 64, height: 28 })
            .borderRadius(14)
            .fontSize(15)
            .fontColor(Color.Black)
            .onClick(() => {
              router.back();
            })
        }
        Image(this.imgUri || $r('app.media.camera_thumbnail_4x'))
          .objectFit(ImageFit.Fill)
          .width('1280px')
          .height('1920px')
          .onAppear(() => {
            const params: RouTmp = router.getParams() as RouTmp;
            this.imgUri = params?.uri
        })
      }
      .height('100%')
      .width('100%')
    }
  }
}