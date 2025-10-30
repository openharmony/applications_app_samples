/*
 * Copyright (c) 2024-2025 Huawei Device Co., Ltd.
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

// [Start click_radio_to_change_function]
// xxx.ets
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
export struct RadioExample {
  @State rst: promptAction.ShowToastOptions = { 'message': 'Ringing mode.' };
  @State vst: promptAction.ShowToastOptions = { 'message': 'Vibration mode.' };
  @State sst: promptAction.ShowToastOptions = { 'message': 'Silent mode.' };

  build() {
    // [StartExclude click_radio_to_change_function]
    NavDestination() {
      // [EndExclude click_radio_to_change_function]
      Row() {
        Column() {
          Radio({ value: 'Ringing', group: 'radioGroup' }).checked(true)
            .height(50)
            .width(50)
            .onChange((isChecked: boolean) => {
              if (isChecked) {
                // 切换为响铃模式
                this.getUIContext().getPromptAction().openToast(this.rst);
              }
            })
          Text('Ringing')
        }

        Column() {
          Radio({ value: 'Vibration', group: 'radioGroup' })
            .height(50)
            .width(50)
            .onChange((isChecked: boolean) => {
              if (isChecked) {
                // 切换为振动模式
                this.getUIContext().getPromptAction().openToast(this.vst);
              }
            })
          Text('Vibration')
        }

        Column() {
          Radio({ value: 'Silent', group: 'radioGroup' })
            .height(50)
            .width(50)
            .onChange((isChecked: boolean) => {
              if (isChecked) {
                // 切换为静音模式
                this.getUIContext().getPromptAction().openToast(this.sst);
              }
            })
          Text('Silent')
        }
      }.height('100%').width('100%').justifyContent(FlexAlign.Center)
      // [StartExclude click_radio_to_change_function]
    }
    // [EndExclude click_radio_to_change_function]
  }
}
// [End click_radio_to_change_function]