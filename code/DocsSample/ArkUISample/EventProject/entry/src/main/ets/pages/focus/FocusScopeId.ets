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

// [Start dynamic_focus_scope_id]
@Entry
@Component
export struct FocusScopeIdExample {
  build() {
    NavDestination() {
      Column({ space: 20 }) {
        Column() {
          Button('Group1')
            .width(165)
            .height(40)
            .margin(5)
            .fontColor(Color.White)
          Row({ space: 5 }) {
            Button('Button1')
              .width(80)
              .height(40)
              .margin(5)
              .fontColor(Color.White)
            Button('Button2')
              .width(80)
              .height(40)
              .margin(5)
              .fontColor(Color.White)
          }
        }.focusScopeId('1', true, true)
        .borderWidth(2).borderColor(Color.Red).borderStyle(BorderStyle.Dashed)

        TextInput()
        Column() {
          Button('Group2')
            .width(165)
            .height(40)
            .margin(5)
            .fontColor(Color.White)
          Row({ space: 5 }) {
            Button('Button3')
              .width(80)
              .height(40)
              .margin(5)
              .fontColor(Color.White)
            Button('Button4')
              .width(80)
              .height(40)
              .margin(5)
              .fontColor(Color.White)
          }
        }.focusScopeId('2', true, false)
        .borderWidth(2).borderColor(Color.Green).borderStyle(BorderStyle.Dashed)

        TextInput()
      }.width('100%')
    }
    // [StartExclude dynamic_focus_scope_id]
    .backgroundColor('#f1f2f3')
    //app.string.Focus_Index_FocusScopeId_title资源文件中的value值为'聚焦范围Id/FocusScopeId'
    .title($r('app.string.Focus_Index_FocusScopeId_title'))
    // [EndExclude dynamic_focus_scope_id]
  }
}
// [End dynamic_focus_scope_id]