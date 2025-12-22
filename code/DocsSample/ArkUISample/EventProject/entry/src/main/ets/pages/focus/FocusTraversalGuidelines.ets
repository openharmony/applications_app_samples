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

// [Start dynamic_focus_liner]
@Entry
@Component
export struct FocusLinerExample {
  build() {
    NavDestination() {
      Column() {
        Column() {
          Button('Column Button1')
            .width(150)
            .height(45)
            .fontColor(Color.White)
            .margin(10)
          Button('Column Button2')
            .width(150)
            .height(45)
            .fontColor(Color.White)
            .margin(10)
        }
        .margin(10)
        Row() {
          Button('Row Button1')
            .width(150)
            .height(45)
            .fontColor(Color.White)
            .margin(10)
          Button('Row Button2')
            .width(150)
            .height(45)
            .fontColor(Color.White)
            .margin(10)
        }
      }
    }
    // [StartExclude dynamic_focus_liner]
    .backgroundColor('#f1f2f3')
    // 请将$r('app.string.xxx')替换为实际资源文件，在本示例中该资源文件的value值为"聚焦遍历/FocusTraversalGuidelines"
    .title($r('app.string.Focus_Index_FocusTraversalGuidelines_title'))
    // [EndExclude dynamic_focus_liner]
  }
}
// [End dynamic_focus_liner]