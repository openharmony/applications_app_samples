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

// [Start dynamic_focus_tab_index]
@Entry
@Component
export struct TabIndexExample {
  build() {
    NavDestination() {
      Column() {
        Button('Button1')
          .width(140)
          .height(45)
          .margin(5)
        Button('Focus Button1')
          .width(140)
          .height(45)
          .margin(5).tabIndex(1)
        Button('Button2')
          .width(140)
          .height(45)
          .margin(5)
        Button('Focus Button2')
          .width(140)
          .height(45)
          .margin(5).tabIndex(2)
      }.width('100%')
    }
    // [StartExclude dynamic_focus_tab_index]
    .backgroundColor('#f1f2f3')
    .title($r('app.string.Tab_Index_TabIndex_title'))
    // [EndExclude dynamic_focus_tab_index]
  }
}
// [End dynamic_focus_tab_index]