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

// [Start gamepad_sample]
@Entry
@Component
struct GamepadSample {
  @State keyValue: string = '';
  @State keyEventType: string = '';
  @State axisValue: string = '';

  build() {
    Column({ space: 10 }) {
      Button('Button1')

      Column() {
        Button('JoyStick')
          .defaultFocus(true)
          .onFocusAxisEvent((event: FocusAxisEvent) => {
            let absX = event.axisMap.get(AxisModel.ABS_X);
            let absY = event.axisMap.get(AxisModel.ABS_Y);
            let absZ = event.axisMap.get(AxisModel.ABS_Z);
            let absRz = event.axisMap.get(AxisModel.ABS_RZ);
            let absGas = event.axisMap.get(AxisModel.ABS_GAS);
            let absBrake = event.axisMap.get(AxisModel.ABS_BRAKE);
            let absHat0X = event.axisMap.get(AxisModel.ABS_HAT0X);
            let absHat0Y = event.axisMap.get(AxisModel.ABS_HAT0Y);
            this.axisValue =
              'absX: ' + absX + '\nabsY: ' + absY + '\nabsZ: ' + absZ + '\nabsRz: ' + absRz + '\nabsGas: ' + absGas +
                '\nabsBrake: ' + absBrake + '\nabsHat0X: ' + absHat0X + '\nabsHat0Y: ' + absHat0Y;
          })
          .onKeyEvent((event: KeyEvent) => {
            if (event && event.type === KeyType.Down) {
              this.keyValue =
                'keyCode:' + event.keyCode + '\nkeyText:' + event.keyText + '\nintentionCode:' + event.intentionCode;
            }
          })
      }.focusScopeId('myGroup', true, false)

      Button('Button2')

      Text('Axis value info: ').margin({ top: 10 })
      Column() {
        Text(this.axisValue).padding(15)
      }.width('100%').alignItems(HorizontalAlign.Start).padding({ left: 40 })

      Divider()

      Text('Key value info: ').margin({ top: 10 })
      Column() {
        Text(this.keyValue).padding(15)
      }.width('100%').alignItems(HorizontalAlign.Start).padding({ left: 40 })

    }.height(300).width('100%').margin({ top: 30 })
  }
}
// [End gamepad_sample]