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
export struct SelectMenu {
  build() {
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({ description: $r('app.string.SelectionMenu_description') }) {
          Column({ space: 8 }) {
            // [Start select_textinput]
            // 请将$r('app.string.show_selected_menu')替换为实际资源文件，在本示例中该资源文件的value值为"这是一段文本，用来展示选中菜单"
            TextInput({ text: $r('app.string.show_selected_menu') })
            // [End select_textinput]
            // [Start select_textarea]
            // 请将$r('app.string.show_selected_menu')替换为实际资源文件，在本示例中该资源文件的value值为"这是一段文本，用来展示选中菜单"
            TextArea({ text: $r('app.string.show_selected_menu') })
            // [End select_textarea]
          }
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    // 请将$r('app.string.SelectionMenu_title')替换为实际资源文件，在本示例中该资源文件的value值为"设置选中菜单"
    .title($r('app.string.SelectionMenu_title'))
  }
}