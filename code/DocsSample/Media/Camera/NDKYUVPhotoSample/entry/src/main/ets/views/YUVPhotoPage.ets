/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

// YUV photo page
import cameraDemo from 'libentry.so';
import { camera } from '@kit.CameraKit';

@Component
export struct YUVPhotoPage {
  // singlePhoto photo mode: false=关闭, true=开启
  @State isSinglePhoto: boolean = false;

  showToast(
    uiContext: UIContext,
    message: ResourceStr = '',
    duration = 2000,
    alignment = Alignment.Top,
    offset: Offset = { dx: 0, dy: 300 }
  ) {
    uiContext.getPromptAction().openToast({
      message,
      duration,
      alignment,
      offset
    });
  }

  build() {
    Row() {
      SymbolGlyph(this.isSinglePhoto
        ? $r('sys.symbol.picture')
        : $r('sys.symbol.picture_on_square_1'))
          .onClick(() => {
            console.log('SinglePhoto Button clicked');
            this.isSinglePhoto = !this.isSinglePhoto;
            cameraDemo.setPhotoOutputCallback(this.isSinglePhoto);
            const message = this.isSinglePhoto ? '单段式拍照' : '分段式拍照';
            this.showToast(this.getUIContext(), message);
        })
        .width('80px')
        .height('80px')
        .fontSize(22)
        .fontColor([Color.White])
    }
    .position({ x: '20%', y: '2.8%' })
  }
}