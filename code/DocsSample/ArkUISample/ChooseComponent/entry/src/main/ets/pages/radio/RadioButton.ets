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

import { promptAction } from '@kit.ArkUI';

@Entry
@Component
export struct RadioSample2 {
  build() {
    NavDestination() {
      Row() {
        compRadi1()
        compRadi2().visibility(Visibility.None)
      }.height('100%').width('100%').justifyContent(FlexAlign.Center)
    }
  }
}

@Component struct compRadi1 {
  build() {
    Row(){
      // [Start click_radio_to_show_function]
      Radio({ value: 'Radio1', group: 'radioGroup' })
        .checked(false)
      Radio({ value: 'Radio2', group: 'radioGroup' })
        .checked(true)
      // [End click_radio_to_show_function]
    }
  }
}

@Component struct compRadi2 {
  build() {
    Row(){
      // [Start click_radio_event_function]
      Radio({ value: 'Radio1', group: 'radioGroup' })
        .onChange((isChecked: boolean) => {
          if(isChecked) {
            //需要执行的操作
            // [StartExclude click_radio_event_function]
            promptAction.openToast({ 'message': 'Radio1 is on.' });
            // [EndExclude click_radio_event_function]
          }
        })
      Radio({ value: 'Radio2', group: 'radioGroup' })
        .onChange((isChecked: boolean) => {
          if(isChecked) {
            //需要执行的操作
            // [StartExclude click_radio_event_function]
            promptAction.openToast({ 'message': 'Radio2 is on.' });
            // [EndExclude click_radio_event_function]
          }
        })
      // [End click_radio_event_function]
    }
  }
}