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

// [Start gamepad_new_joystick]
import { KeyCode } from '@kit.InputKit';

@Entry
@Component
struct NewJoystick {
  build() {
    Column() {
      if (canIUse('SystemCapability.MultimodalInput.Input.Core')) {
        Button('JoyStick')
          .defaultFocus(true)
          // 屏蔽方向键上报的按键事件
          .onKeyPreIme((event: KeyEvent) => {
            if (event.keyCode === KeyCode.KEYCODE_DPAD_UP || event.keyCode === KeyCode.KEYCODE_DPAD_DOWN ||
              event.keyCode === KeyCode.KEYCODE_DPAD_LEFT || event.keyCode === KeyCode.KEYCODE_DPAD_RIGHT) {
              return true;
            }
            return false;
          })
          // 在焦点轴事件中处理方向键操作逻辑
          .onFocusAxisEvent((event: FocusAxisEvent) => {
            let absHat0x = event.axisMap.get(AxisModel.ABS_HAT0X);
            let absHat0y = event.axisMap.get(AxisModel.ABS_HAT0Y);
            // 处理操纵杆输入逻辑
            console.info(`absHat0x: ${absHat0x}, absHat0y: ${absHat0y}`);
          })
      }
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }
}
// [End gamepad_new_joystick]