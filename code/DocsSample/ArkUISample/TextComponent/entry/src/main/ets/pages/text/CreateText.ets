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
export struct CreateText {
  build() {
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({ title: $r('app.string.CreatText_title_1') }) {
          // [Start create_a_text_in_one_way]
          Text($r('app.string.CreateText_Text_1'))
          // [End create_a_text_in_one_way]
        }

        ComponentCard({
          title: $r('app.string.CreatText_title_2'),
          description: $r('app.string.CreatText_description_1')
        }) {
          // [Start create_a_text_in_another_way]
          Text($r('app.string.module_desc'))
            .baselineOffset(0)
            .fontSize(30)
            .border({ width: 1 })
            .padding(10)
            .width(300)
          // [End create_a_text_in_another_way]
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.CreatText_title'))
  }
}