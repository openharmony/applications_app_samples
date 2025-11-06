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
// [Start button_case_2]
// xxx.ets
const DOMAIN = 0x0000;
@Entry
@Component
export struct ButtonCaseLogin {
  build() {
    NavDestination() {
      Column() {
        TextInput({ placeholder: 'input your username' }).margin({ top: 20 })
        TextInput({ placeholder: 'input your password' }).type(InputType.Password).margin({ top: 20 })
        Button('Register').width(300).margin({ top: 20 })
          .onClick(() => {
            // 需要执行的操作
          })
        // [StartExclude button_case_2]

        // [Start button_case2_add_event]
        Button('Ok', { type: ButtonType.Normal, stateEffect: true })
          .onClick(()=>{
            hilog.info(DOMAIN, 'testTag', 'Button onClick')
          }).margin(10)
        // [End button_case2_add_event]
        // [EndExclude button_case_2]
      }.padding(20)
    }
  }
}
// [End button_case_2]