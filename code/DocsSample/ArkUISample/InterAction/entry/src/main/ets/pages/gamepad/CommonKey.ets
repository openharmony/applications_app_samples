/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

// [Start gamepad_common_key]
import { KeyCode } from '@kit.InputKit';

@Entry
@Component
struct CommonKey {
  build() {
    Column() {
      if (canIUse('SystemCapability.MultimodalInput.Input.Core')) {
        Button('JoyStick')
          .defaultFocus(true)
          .onKeyEvent((event: KeyEvent) => {
            if (event && event.type === KeyType.Down) {
              switch (event.keyCode) {
                case KeyCode.KEYCODE_BUTTON_SELECT:
                  console.info('trigger BUTTON_SELECT');
                  // 处理BUTTON_SELECT按键的输入逻辑
                  break;
                case KeyCode.KEYCODE_BUTTON_START:
                  console.info('trigger BUTTON_START');
                  // 处理BUTTON_START按键的输入逻辑
                  break;
                default:
                  console.info('trigger BUTTON_DEFAULT');
                  // 处理其他按键的输入逻辑
                  break;
              }
            }
          })
      }
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }
}
// [End gamepad_common_key]