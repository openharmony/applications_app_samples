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

// [Start dynamic_focus_project_area]
@Entry
@Component
export struct ProjectAreaFocusExample {
  build() {
    NavDestination() {
    Column() {
      Column({ space: 5 }) {
        Text('Wrap').fontSize(12).width('90%')
        // 子组件多行布局
        Flex({ wrap: FlexWrap.Wrap }) {
          Button('1').width(140).height(50).margin(5)
          Button('2').width(140).height(50).margin(5)
          Button('3').width(140).height(50).margin(5)
          Button('4').width(140).height(50).margin(5)
          Button('5').width(140).height(50).margin(5)
        }
        .width('90%')
        .padding(10)
      }.width('100%').margin({ top: 5 })
    }.width('100%')
    }
    // [StartExclude dynamic_focus_project_area]
    .backgroundColor('#f1f2f3')
    .title($r('app.string.Focus_Index_ProjectionBasedFocus_title'))
    // [EndExclude dynamic_focus_project_area]
  }
}
// [End dynamic_focus_project_area]