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

@Component
export struct AccessibilityGroup {
  build() {
    NavDestination() {
      Column({ space: 10 }) {
        Text('123456')
          .focusable(true)
          .borderRadius(5)
          .accessibilityText($r('app.string.UniversalAttributesAccessibility_text1'))
          .accessibilityLevel('yes')
        Button().accessibilityLevel('yes').accessibilityText($r('app.string.UniversalAttributesAccessibility_text2'))
        Button($r('app.string.UniversalAttributesAccessibility_text3')).accessibilityLevel('yes')
        Button()
        Button('btnl23').accessibilityText($r('app.string.UniversalAttributesAccessibility_text4')).accessibilityLevel('yes')
        Button('btn123').accessibilityLevel('yes')
      }
      .accessibilityGroup(true, { accessibilityPreferred: true })
      //.accessibilityGroup(true)
      .borderWidth(5)
      .width('100%')
      .height('100%')
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.UniversalAttributesAccessibility_title2'))
  }
}