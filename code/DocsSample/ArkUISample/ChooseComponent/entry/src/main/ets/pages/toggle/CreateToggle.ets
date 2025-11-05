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

import { ComponentCard } from '../../common/Card';
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
export struct CreateToggle {
  pathStack: NavPathStack = new NavPathStack();

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({
          title: 'ToggleType is Checkbox',
        }) {
          // [Start create_toggle_with_checkbox]
          Toggle({ type: ToggleType.Checkbox, isOn: false }).id('toggle1')
          Toggle({ type: ToggleType.Checkbox, isOn: true }).id('toggle2')
          // [End create_toggle_with_checkbox]
        }

        ComponentCard({
          title: 'ToggleType is Switch',
        }) {
          // [Start create_toggle_with_switch]
          Toggle({ type: ToggleType.Switch, isOn: false }).id('toggle3') // 请开发者替换为实际的id
          Toggle({ type: ToggleType.Switch, isOn: true }).id('toggle4') // 请开发者替换为实际的id
          // [End create_toggle_with_switch]

          // [Start create_toggle_with_event]
          Toggle({ type: ToggleType.Switch, isOn: false })
            .onChange((isOn: boolean) => {
              if(isOn) {
                // 需要执行的操作
                // [StartExclude create_toggle_with_event]
                promptAction.openToast({ 'message': 'Switch is on.' });
                // [EndExclude create_toggle_with_event]
              }
            })
            // [End create_toggle_with_event]
            .visibility(Visibility.None)
        }

        ComponentCard({
          title: 'ToggleType is Button',
        }) {
          // [Start create_a_toggle_that_contains_subcomponents]
          Toggle({ type: ToggleType.Button, isOn: false }) {
            Text('status button')
              .fontColor('#182431')
              .fontSize(12)
          }.width(100).id('toggle5') // 请开发者替换为实际的id

          Toggle({ type: ToggleType.Button, isOn: true }) {
            Text('status button')
              .fontColor('#182431')
              .fontSize(12)
          }.width(100).id('toggle6') // 请开发者替换为实际的id
          // [End create_a_toggle_that_contains_subcomponents]
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    // $r('app.string.xxx')需要替换为开发者所需的字符串资源文件
    .title($r('app.string.CreateToggle_title'))
  }
}