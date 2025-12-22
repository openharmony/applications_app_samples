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
export struct CreatTextInput {
  build() {
    NavDestination() {
      Column({ space: 12 }) {
        // 请将$r('app.string.CreatTextInput_title_1')替换为实际资源文件，在本示例中该资源文件的value值为"单行输入框"
        ComponentCard({ title: $r('app.string.CreatTextInput_title_1') }) {
          // [Start create_text_input]
          TextInput()
          // [End create_text_input]
        }

        ComponentCard({
          // 请将$r('app.string.CreatTextInput_title_2')替换为实际资源文件，在本示例中该资源文件的value值为"多行输入框"
          title: $r('app.string.CreatTextInput_title_2'),
          // 请将$r('app.string.CreatTextInput_description_1')替换为实际资源文件，在本示例中该资源文件的value值为"多行输入框文字超出一行时会自动折行"
          description: $r('app.string.CreatTextInput_description_1')
        }) {
          Column({ space: 8 }) {
            // [Start create_text_area]
            TextArea()
            // [End create_text_area]
            // [Start create_text_area_example]
            /* 请将$r('app.string.CreatTextInput_textContent')替换为实际资源文件，在本示例中该资源文件的value值为
             "我是TextArea我是TextArea我是TextArea我是TextArea" */
            TextArea({ text: $r('app.string.CreatTextInput_textContent') })
              .width(300)
            // [End create_text_area_example]
          }
        }

        // 请将$r('app.string.CreatTextInput_title_3')替换为实际资源文件，在本示例中该资源文件的value值为"搜索框"
        ComponentCard({ title: $r('app.string.CreatTextInput_title_3') }) {
          // [Start create_text_search]
          Search()
            // 请将$r('app.string.Creat_TextInput_Content')替换为实际资源文件，在本示例中该资源文件的value值为"搜索"
            .searchButton($r('app.string.Creat_TextInput_Content'))
          // [End create_text_search]
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    // 请将$r('app.string.CreatTextInput_title_3')替换为实际资源文件，在本示例中该资源文件的value值为"创建输入框"
    .title($r('app.string.CreatTextInput_title'))
  }
}