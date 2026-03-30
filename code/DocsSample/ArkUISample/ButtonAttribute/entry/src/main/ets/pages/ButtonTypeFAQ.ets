/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

// [Start button_type_faq]
// pages/ButtonTypeFAQ.ets
@Entry
@Component
struct ButtonTypeDemo {
  build() {
    Column({ space: 20 }) {
      // 使用枚举设置（推荐）
      Text('使用枚举设置：')
      Button('Capsule')
        .type(ButtonType.Capsule)
      Button('Circle')
        .type(ButtonType.Circle)
      Button('Normal')
        .type(ButtonType.Normal)
      Button('ROUNDED_RECTANGLE')
        .type(ButtonType.ROUNDED_RECTANGLE)

      // 使用数字设置（需使用type实际数值）
      Text('使用数字设置：')
      Button('type(1)')
        .type(1) // 等同于 ButtonType.Capsule
      Button('type(2)')
        .type(2) // 等同于 ButtonType.Circle
      Button('type(0)')
        .type(0) // 等同于 ButtonType.Normal
      Button('type(8)')
        .type(8) // 等同于 ButtonType.ROUNDED_RECTANGLE

      // 错误示例：使用SDK枚举值作为type数字
      Text('错误示例（使用SDK枚举值）：')
      Button('type(3)')
        .type(3) // 不对应任何类型，使用默认样式
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
    .justifyContent(FlexAlign.Center)
  }
}
// [End button_type_faq]