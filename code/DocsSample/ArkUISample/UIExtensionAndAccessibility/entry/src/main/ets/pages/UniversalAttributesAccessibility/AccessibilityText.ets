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
export struct AccessibilityText {

  @Builder customAccessibilityNode() {
    Column() {
      Text(`virtual node`)
    }
    .width(10)
    .height(10)
  }

  build() {
    NavDestination() {
      Row() {
        Column() {
          Text($r('app.string.UniversalAttributesAccessibility_text5'))
            .fontSize(50)
            .fontWeight(FontWeight.Bold)
          Text($r('app.string.UniversalAttributesAccessibility_text6'))
            .fontSize(50)
            .fontWeight(FontWeight.Bold)
        }
        .width('100%')
        .accessibilityGroup(true)
        .accessibilityLevel('yes')
        .accessibilityText($r('app.string.UniversalAttributesAccessibility_text7'))
        .accessibilityDescription($r('app.string.UniversalAttributesAccessibility_text8'))
        .accessibilityVirtualNode(this.customAccessibilityNode)
        .accessibilityChecked(true)
        .accessibilitySelected(undefined)
      }
      .height('100%')
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.UniversalAttributesAccessibility_title1'))
  }
}