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
 
import { KeyCode } from '@kit.InputKit';
import { ColorMetrics, LengthMetrics } from '@kit.ArkUI';

// [Start focus_scope_navigation]
@Entry
@Component
export struct FocusScopePriority {
  @State inputValue: string = '';

  build() {
    NavDestination() {
      Column({ space: 12 }) {

        Scroll() {
          Row({ space: 20 }) {
            Column({ space: 20 }) {  // 标记为Column1
              Column({ space: 5 }) {
                Button('Group1')
                  .width(165)
                  .height(40)
                  .fontColor(Color.White)
                Row({ space: 5 }) {
                  Button()
                    .width(80)
                    .height(40)
                    .fontColor(Color.White)
                  Button()
                    .width(80)
                    .height(40)
                    .fontColor(Color.White)
                }
                Row({ space: 5 }) {
                  Button()
                    .width(80)
                    .height(40)
                    .fontColor(Color.White)
                  Button()
                    .width(80)
                    .height(40)
                    .fontColor(Color.White)
                }
              }.borderWidth(2).borderColor(Color.Red).borderStyle(BorderStyle.Dashed)
              Column({ space: 5 }) {
                Button('Group2')
                  .width(165)
                  .height(40)
                  .fontColor(Color.White)
                Row({ space: 5 }) {
                  Button()
                    .width(80)
                    .height(40)
                    .fontColor(Color.White)
                  Button()
                    .width(80)
                    .height(40)
                    .fontColor(Color.White)
                    .focusScopePriority('ColumnScope1', FocusPriority.PRIOR)  // Column1首次获焦时获焦
                }
                Row({ space: 5 }) {
                  Button()
                    .width(80)
                    .height(40)
                    .fontColor(Color.White)
                  Button()
                    .width(80)
                    .height(40)
                    .fontColor(Color.White)
                }
              }.borderWidth(2).borderColor(Color.Green).borderStyle(BorderStyle.Dashed)
            }
            .focusScopeId('ColumnScope1')
            Column({ space: 5 }) {  // 标记为Column2
              TextInput({placeholder: 'input', text: this.inputValue})
                .onChange((value: string) => {
                  this.inputValue = value;
                })
                .width(156)
              Button('Group3')
                .width(165)
                .height(40)
                .fontColor(Color.White)
              Row({ space: 5 }) {
                Button()
                  .width(80)
                  .height(40)
                  .fontColor(Color.White)
                Button()
                  .width(80)
                  .height(40)
                  .fontColor(Color.White)
              }
              Button()
                .width(165)
                .height(40)
                .fontColor(Color.White)
                .focusScopePriority('ColumnScope2', FocusPriority.PREVIOUS)  // Column2获焦时获焦
              Row({ space: 5 }) {
                Button()
                  .width(80)
                  .height(40)
                  .fontColor(Color.White)
                Button()
                  .width(80)
                  .height(40)
                  .fontColor(Color.White)
              }
              Button()
                .width(165)
                .height(40)
                .fontColor(Color.White)
              Row({ space: 5 }) {
                Button()
                  .width(80)
                  .height(40)
                  .fontColor(Color.White)
                Button()
                  .width(80)
                  .height(40)
                  .fontColor(Color.White)
              }
            }.borderWidth(2).borderColor(Color.Orange).borderStyle(BorderStyle.Dashed)
            .focusScopeId('ColumnScope2', true)  // Column2为焦点组
          }.alignItems(VerticalAlign.Top)
        }

      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.Focus_FocusScopePriority_title'))
  }
}
// [End focus_scope_navigation]