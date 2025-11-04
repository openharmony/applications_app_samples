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

// [Start the_example_of_bluetooth]
// xxx.ets
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
export struct ToggleSample {
  @State message: string = 'off';
  pathStack: NavPathStack = new NavPathStack();

  build() {
    // [StartExclude the_example_of_bluetooth]
    NavDestination() {
      // [EndExclude the_example_of_bluetooth]
      Column({ space: 8 }) {
        Column({ space: 8 }) {
          Text('Bluetooth Mode: ' + this.message)
            .id('message')
          Row() {
            Text('Bluetooth')
            Blank()
            // [Start create_toggle_case]
            Toggle({ type: ToggleType.Switch })
              .id('toggle')
              .onChange((isOn: boolean) => {
                if (isOn) {
                  // [StartExclude create_toggle_case]
                  this.message = 'on';
                  // [EndExclude create_toggle_case]
                  promptAction.openToast({ 'message': 'Bluetooth is on.' });
                } else {
                  // [StartExclude create_toggle_case]
                  this.message = 'off';
                  // [EndExclude create_toggle_case]
                  promptAction.openToast({ 'message': 'Bluetooth is off.' });
                }
              })
            // [End create_toggle_case]
          }.width('100%')
        }
        .alignItems(HorizontalAlign.Start)
        .backgroundColor('#fff')
        .borderRadius(12)
        .padding(12)
        .width('100%')
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
      // [StartExclude the_example_of_bluetooth]
    }
    // [EndExclude the_example_of_bluetooth]
    .backgroundColor('#f1f2f3')
    // $r('app.string.xxx')需要替换为开发者所需的字符串资源文件
    .title($r('app.string.ToggleCaseExample_title'))
  }
}
// [End the_example_of_bluetooth]