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

@Entry
@Component
export struct CustomTextInputStyle {
  build() {
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({ title: $r('app.string.CustomTextInputStyle_title_1') }) {
          // [Start custom_text_input_with_place_holder]
          TextInput({ placeholder: $r('app.string.CustomTextInputStyle_textContent_1') })
          // [End custom_text_input_with_place_holder]
        }

        ComponentCard({ title: $r('app.string.CustomTextInputStyle_title_2') }) {
          // [Start custom_text_input_with_place_holder_and_text]
          TextInput({
            placeholder: $r('app.string.CustomTextInputStyle_textContent_1'),
            text: $r('app.string.CustomTextInputStyle_textContent_2')
          })
          // [End custom_text_input_with_place_holder_and_text]
        }

        ComponentCard({ title: $r('app.string.CustomTextInputStyle_title_3') }) {
          // [Start custom_text_input_background_color]
          TextInput({
            placeholder: $r('app.string.CustomTextInputStyle_textContent_1'),
            text: $r('app.string.CustomTextInputStyle_textContent_2')
          })
            .backgroundColor(Color.Pink)
          // [End custom_text_input_background_color]
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.CustomTextInputStyle_title'))
  }
}