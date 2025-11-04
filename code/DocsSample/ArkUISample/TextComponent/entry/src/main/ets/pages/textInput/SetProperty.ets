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
import { LengthMetrics } from '@kit.ArkUI';

@Entry
@Component
export struct SetProperty {
  build() {
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({ description: $r('app.string.Set_Omission_Property_description') }) {
          // [Start set_omission_property]
          // 'app.string.Set_Omission_Property_textContent'资源文件中的value值为"这是一段文本，用来展示省略模式"
          TextInput({ text: $r('app.string.Set_Omission_Property_textContent') })
            .textOverflow(TextOverflow.Ellipsis)
            .ellipsisMode(EllipsisMode.END)
            .style(TextInputStyle.Inline)
            .fontSize(30)
            .margin(30)
          // [End set_omission_property]
        }
        ComponentCard({ description: $r('app.string.Set_Stroke_Property_description') }) {
          // [Start set_stroke_property]
          TextInput({ text: 'Text with stroke' })
            .width('100%')
            .height(60)
            .borderWidth(1)
            .fontSize(40)
            .strokeWidth(LengthMetrics.px(3.0))
            .strokeColor(Color.Red)
          // [End set_stroke_property]
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.Set_Property'))
  }
}