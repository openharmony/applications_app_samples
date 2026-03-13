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

// [Start default_InputCastPicker]
import { AVCastPickerState, AVInputCastPicker } from '@kit.AVSessionKit';

// [StartExclude default_InputCastPicker]
@Entry
@Component
struct SelfInputCastPicker {
  // [EndExclude default_InputCastPicker]
  // 设备列表显示状态变化回调（可选）。
  private onStateChange(state: AVCastPickerState) {
    if (state === AVCastPickerState.STATE_APPEARING) {
      console.info('The picker starts showing.');
    } else if (state === AVCastPickerState.STATE_DISAPPEARING) {
      console.info('The picker finishes presenting.');
    }
  }

  // 创建组件，并设置大小。
  build() {
    Row() {
      Column() {
        AVInputCastPicker(
          {
            onStateChange: this.onStateChange
          }
        ).size({ height: 45, width: 45 })
      }
    }
  }
  // [End default_InputCastPicker]
}