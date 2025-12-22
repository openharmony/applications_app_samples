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
          // 请将$r('app.string.i_am_placeholder')替换为实际资源文件，在本示例中该资源文件的value值为"我是提示文本"
          TextInput({ placeholder: $r('app.string.i_am_placeholder') })
          // [End custom_text_input_with_place_holder]
        }

        ComponentCard({ title: $r('app.string.CustomTextInputStyle_title_2') }) {
          // [Start custom_text_input_with_place_holder_and_text]
          TextInput({
            // 请将$r('app.string.i_am_placeholder')替换为实际资源文件，在本示例中该资源文件的value值为"我是提示文本"
            placeholder: $r('app.string.i_am_placeholder'),
            // 请将$r('app.string.i_am_current_text_content')替换为实际资源文件，在本示例中该资源文件的value值为"我是当前文本内容"
            text: $r('app.string.i_am_current_text_content')
          })
          // [End custom_text_input_with_place_holder_and_text]
        }

        ComponentCard({ title: $r('app.string.CustomTextInputStyle_title_3') }) {
          // [Start custom_text_input_background_color]
          TextInput({
            // 请将$r('app.string.i_am_placeholder')替换为实际资源文件，在本示例中该资源文件的value值为"我是提示文本"
            placeholder: $r('app.string.i_am_placeholder'),
            // 请将$r('app.string.i_am_current_text_content')替换为实际资源文件，在本示例中该资源文件的value值为"我是当前文本内容"
            text: $r('app.string.i_am_current_text_content')
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