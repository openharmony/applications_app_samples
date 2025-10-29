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

import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = '[Sample_Eventproject]';
const DOMAIN = 0xF811;
const BUNDLE = 'Eventproject_';
// [Start On_key_distribute_event]
@Entry
@Component
export struct OnKeyDistributeEvent {
  build() {
    // [StartExclude On_key_distribute_event]
    NavDestination() {
      Column({ space: 12 }) {
        // [EndExclude On_key_distribute_event]
        Row() {
          Row() {
            Button('button1').id('button1').onKeyEvent((event) => {
              hilog.info(DOMAIN, TAG, BUNDLE + 'button1');
              return true
            })
            Button('button2').id('button2').onKeyEvent((event) => {
              hilog.info(DOMAIN, TAG, BUNDLE + 'button2');
              return true
            })
          }
          .width('100%')
          .height('100%')
          .id('Row1')
          .onKeyEventDispatch((event) => {
            let context = this.getUIContext();
            context.getFocusController().requestFocus('button1');
            return context.dispatchKeyEvent('button1', event);
          })

        }
        .height('100%')
        .width('100%')
        .onKeyEventDispatch((event) => {
          if (event.type == KeyType.Down) {
            let context = this.getUIContext();
            context.getFocusController().requestFocus('Row1');
            return context.dispatchKeyEvent('Row1', event);
          }
          return true;
        })
        // [StartExclude On_key_distribute_event]
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.OnKeyDistributeEvent_title'))
    // [EndExclude On_key_distribute_event]
  }
}
// [End On_key_distribute_event]