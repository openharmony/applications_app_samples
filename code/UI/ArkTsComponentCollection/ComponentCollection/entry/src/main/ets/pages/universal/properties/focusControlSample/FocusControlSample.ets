/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


import { IntroductionTitle } from '../../../../common/IntroductionTitle';
import { TitleBar } from '../../../../common/TitleBar';
import { getStringData } from '../../../../data/ResourceDataHandle';
import ShowToast from '../../../../util/ShowToast';

@Extend(Row) function rowStyle() {
  .padding(8)
  .borderRadius(24)
  .width('100%')
  .backgroundColor(Color.White)
  .margin({ left: 12, right: 12 })
}

@Entry
@Component
struct FocusControlSample {
  @State inputValue: string = '';
  @State idList: string[] = [getStringData($r('app.string.text_picker_text_banana'))
    , getStringData($r('app.string.text_picker_text_orange'))
    , getStringData($r('app.string.text_picker_text_grape'))
    , getStringData($r('app.string.text_picker_text_peach'))
    , getStringData($r('app.string.focus_control_lastPageId'))];
  @State selectId: string = getStringData($r('app.string.focus_control_lastPageId'));

  build() {
    Column() {
      TitleBar({ title: $r('app.string.focus_control') })
      Column() {
        IntroductionTitle({ introduction: $r('app.string.focus_control_tab') })
        Row({ space: 20 }) {
          Column({ space: 20 }) {
            Column({ space: 5 }) {
              Button($r('app.string.focus_control_group1'))
                .width(165)
                .height(40)
                .fontColor(Color.White)
                .focusOnTouch(true) // 该Button组件点击后可获焦
              Row({ space: 5 }) {
                Button()
                  .width(80)
                  .height(40)
                  .fontColor(Color.White)
                Button()
                  .width(80)
                  .height(40)
                  .fontColor(Color.White)
                  .focusOnTouch(true) // 该Button组件点击后可获焦
              }
            }
            .borderWidth(2)
            .borderColor(Color.Red)
            .borderStyle(BorderStyle.Dashed)
            .tabIndex(1) // 该Column组件为按TAB键走焦的第一个获焦的组件
            Column({ space: 5 }) {
              Button($r('app.string.focus_control_group2'))
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
                  .groupDefaultFocus(true) // 该Button组件上级Column组件获焦时获焦
              }
            }
            .borderWidth(2)
            .borderColor(Color.Green)
            .borderStyle(BorderStyle.Dashed)
            .tabIndex(2) // 该Column组件为按TAB键走焦的第二个获焦的组件
          }
          .width('50%')

          Column({ space: 5 }) {
            TextInput({ placeholder: $r('app.string.focus_control_input'), text: this.inputValue })
              .width(165)
              .height(40)
              .onChange((value: string) => {
                this.inputValue = value;
              })
              .defaultFocus(true) // 该TextInput组件为页面的初始默认焦点
            Button($r('app.string.focus_control_group3'))
              .width(165)
              .height(40)
              .fontColor(Color.White)
          }
          .width('40%')
          .borderWidth(2)
          .borderColor(Color.Orange)
          .borderStyle(BorderStyle.Dashed)
          .tabIndex(3) // 该Column组件为按TAB键走焦的第三个获焦的组件
        }
        .alignItems(VerticalAlign.Top)
        .rowStyle()

        IntroductionTitle({ introduction: $r('app.string.focus_control_request_focus') })
        Row() {
          Column({ space: 20 }) {
            Row({ space: 16 }) {
              Button(this.idList[0])
                .width(200)
                .height(40)
                .fontColor(Color.White)
                .key(this.idList[0])
                .focusable(false)
              Button(this.idList[1])
                .width(200)
                .height(40)
                .fontColor(Color.White)
                .key(this.idList[1])
            }

            Row({ space: 16 }) {
              Button(this.idList[2])
                .width(200)
                .height(40)
                .fontColor(Color.White)
                .key(this.idList[2])
              Button(this.idList[3])
                .width(200)
                .height(40)
                .fontColor(Color.White)
                .key(this.idList[3])
            }

            Row({ space: 16 }) {
              Select([{ value: this.idList[0] },
                { value: this.idList[1] },
                { value: this.idList[2] },
                { value: this.idList[3] },
                { value: this.idList[4] }])
                .value(this.selectId)
                .onSelect((index: number) => {
                  this.selectId = this.idList[index];
                })
                .id('focus_select')

              Button($r('app.string.focus_control_request_focus'))
                .width(200)
                .height(40)
                .fontColor(Color.White)
                .onClick(() => {
                  let res:boolean = focusControl.requestFocus(this.selectId); // 使选中的this.selectId的组件获焦
                  if (res) {
                    ShowToast.shortToast($r('app.string.focus_control_success'));
                  } else {
                    ShowToast.shortToast($r('app.string.focus_control_failed'));
                  }
                })
                .id('focus_btn')
            }
          }
          .width('100%')
          .margin({ top: 20 })
        }
        .rowStyle()
      }
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}