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

import { ComponentCard } from '../../common/Card';
import resource from '../../common/resource';

// [Start the_example_of_text_input]
@Entry
@Component
export struct LoginRegisterPage {
  build() {
    // [StartExclude the_example_of_text_input]
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({ title: $r('app.string.LoginRegisterPage_title') }) {
          // [EndExclude the_example_of_text_input]
          Column({ space: 12 }) {
            TextInput({ placeholder: 'input your username' })
              .id('username')
              .onSubmit((enterKeyType) => {
                console.info(enterKeyType + resource.resourceToString($r('app.string.LoginRegisterPage_textContent')));
              })
            TextInput({ placeholder: 'input your password' })
              .id('password')
              .type(InputType.Password)
              .onSubmit((enterKeyType) => {
                console.info(enterKeyType + resource.resourceToString($r('app.string.LoginRegisterPage_textContent')));
              })
            Button($r('app.string.LoginRegisterPage_Button_3'))
              .width('100%')
          }
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    // [End the_example_of_text_input]
    .backgroundColor('#f1f2f3')
    .title($r('app.string.LoginRegisterPage_title'))
  }
}