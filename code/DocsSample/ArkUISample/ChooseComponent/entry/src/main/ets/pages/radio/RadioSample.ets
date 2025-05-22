/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
export struct RadioSample {
  @State message: string = 'Ringing';
  pathStack: NavPathStack = new NavPathStack();

  resourceToString(resource: Resource): string {
    return getContext(this).resourceManager.getStringSync(resource);
  }

  build() {
    NavDestination() {
      Column({ space: 8 }) {
        Column({ space: 8 }) {
          Text(this.message).id('message')
          Row() {
            // [Start set_radio_status]
            Radio({ value: 'Ringing', group: 'radioGroup' })
              .checked(true)
                // [End set_radio_status]
              .id('ringing')
              .onChange((isChecked: boolean) => {
                if (isChecked) {
                  // 切换为响铃模式
                  // [StartExclude click_radio_to_change_function]
                  this.message = 'Ringing mode';
                  // [EndExclude click_radio_to_change_function]
                  promptAction.showToast({ 'message': 'Ringing mode.' });
                }
              })
            Text('Ringing')
          }.width('25%')

          // [Start change_radio_function]
          Row() {
            Radio({ value: 'Vibration', group: 'radioGroup' })
              .id('vibration')
              .onChange((isChecked: boolean) => {
                if (isChecked) {
                  // 切换为振动模式
                  // [StartExclude change_radio_function]
                  this.message = 'Vibration';
                  // [EndExclude change_radio_function]
                  promptAction.showToast({ 'message': 'Vibration mode.' });
                }
              })
            Text('Vibration')
          }.width('25%')

          Row() {
            Radio({ value: 'Silent', group: 'radioGroup' })
              .id('silent')
              .onChange((isChecked: boolean) => {
                if (isChecked) {
                  // 切换为静音模式
                  // [StartExclude change_radio_function]
                  this.message = 'Silent';
                  // [EndExclude change_radio_function]
                  promptAction.showToast({ 'message': 'Silent mode.' });
                }
              })
            Text('Silent')
          }.width('25%')
          // [End change_radio_function]
        }
        .alignItems(HorizontalAlign.Center)
        .backgroundColor('#fff')
        .borderRadius(12)
        .padding(12)
        .width('100%')
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title(this.resourceToString($r('app.string.RadioSample_title')))
  }
}
// [End click_radio_to_change_function]