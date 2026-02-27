/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
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

import { Router } from '@kit.ArkUI';
// [Start self_inputCastPicker]
import { AVCastPickerState, AVInputCastPicker } from '@kit.AVSessionKit';

@Entry
@Component
struct InputCastPicker {
  @State pickerImage: ResourceStr = $r('app.media.sound'); // 自定义资源。
  // [StartExclude self_inputCastPicker]
  @State router: Router = new Router();
  // [EndExclude self_inputCastPicker]

  // 设备列表显示状态变化回调（可选）。
  private onStateChange(state: AVCastPickerState) {
    if (state === AVCastPickerState.STATE_APPEARING) {
      console.info('The picker starts showing.');
    } else if (state === AVCastPickerState.STATE_DISAPPEARING) {
      console.info('The picker finishes presenting.');
    }
  }

  build() {
    Row() {
      Column() {
        AVInputCastPicker(
          {
            customPicker: this.ImageBuilder.bind(this), // 新增自定义参数。
            onStateChange: this.onStateChange
          }
        )
          .size({ width: '50%', height: '20%' })
          .id('AVInputCastPicker')
        // [StartExclude self_inputCastPicker]
        Blank().height(40);
        Button('back')
          .onClick(async() => {
            await this.router.pushUrl({ url:'pages/Index' });
          })
          .size({ width: '50%', height: '10%' })
        // [EndExclude self_inputCastPicker]
      }
      .width('100%')
      .alignItems(HorizontalAlign.Center)
    }
    .alignItems(VerticalAlign.Center)
    .width('100%')
    .height('100%')
  }

  // 自定义内容。
  @Builder
  ImageBuilder() {
    Text($r('app.string.switch_InputDevice'))
    Image(this.pickerImage)
      .size({ width: '100%', height: '100%' })
      .backgroundColor('#00000000')
      .fillColor(Color.Black)
  }
}
// [End self_inputCastPicker]