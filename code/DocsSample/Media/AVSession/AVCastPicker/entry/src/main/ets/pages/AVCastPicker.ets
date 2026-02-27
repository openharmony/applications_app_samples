/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

// [Start create_castPicker]
import { AVCastPickerState, AVCastPicker } from '@kit.AVSessionKit';

@Entry
@Component
export struct AVCastPickerComponent {
  // 应用可以通过onStateChange接口监听组件显示/消失状态，
  // 当组件显示时建议不要销毁AVCastPicker的显示；当组件消失时，再根据业务隐藏AVCastPicker。
  private onStateChange(state: AVCastPickerState) {
    if (state == AVCastPickerState.STATE_APPEARING) {
      console.info('The picker starts showing.');
    } else if (state == AVCastPickerState.STATE_DISAPPEARING) {
      console.info('The picker finishes presenting.');
    }
  }

  // 创建组件，并设置大小
  build() {
    Row() {
      Column() {
        AVCastPicker({
          normalColor: Color.Red,
          onStateChange: this.onStateChange
        })
          .width('40vp')
          .height('40vp')
          .border({ width: 1, color: Color.Red })
      }.height('50%')
    }.width('50%')
  }
}
// End create_castPicker]