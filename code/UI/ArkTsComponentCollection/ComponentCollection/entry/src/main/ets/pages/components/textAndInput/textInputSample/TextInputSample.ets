/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { CommonItemSelect } from '../../../../common/AttributeModificationTool';
import { IntroductionTitle } from '../../../../common/IntroductionTitle';
import ShowToast from '../../../../util/ShowToast';
import Logger from '../../../../util/Logger';
import { TitleBar } from '../../../../common/TitleBar';

@Extend(Column)
function backgroundStyle() {
  .width('100%')
  .padding(12)
  .borderRadius(24)
  .backgroundColor(Color.White)
}

@Entry
@Component
struct TextInputSample {
  @State caretIndex: number = 0;
  @State inputLength: number = 0;
  @State hasFilterError: boolean = false;
  @State showPasswordIcon: boolean = true;
  @State inputType: InputType = InputType.Normal;
  @State inputContent: string = '';
  @State typePlaceholder: Resource = $r('app.string.text_input_normal_type');
  @State inputSelectContent: string = '';
  @State startSelect: number = 0;
  @State endSelect: number = 0;
  @State maxSelect: number = 0;
  @State selects: string[] = ['0'];
  private select: number = 1;
  private maxLength: number = 12;
  private context: Context = getContext(this);
  private inputController: TextInputController = new TextInputController();
  private inputSelectController: TextInputController = new TextInputController();

  build() {
    Column() {
      TitleBar({ title: $r('app.string.text_input_title') })
      Scroll() {
        Column() {
          IntroductionTitle({ introduction: $r('app.string.text_input_input_type') })
          Column() {
            TextInput({ placeholder: this.typePlaceholder })
              .type(this.inputType).id('test_input')
              .showPasswordIcon(this.showPasswordIcon)
              .enableKeyboardOnFocus(false)

            CommonItemSelect({
              selects: ['Normal', 'Password', 'Email', 'Number', 'PhoneNumber'],
              name: $r('app.string.text_input_current_type'),
              callback: (index) => {
                switch (index) {
                  case 1:
                    this.inputType = InputType.Password
                    this.typePlaceholder = $r('app.string.text_input_password_type')
                    break
                  case 2:
                    this.inputType = InputType.Email
                    this.typePlaceholder = $r('app.string.text_input_email_type')
                    break
                  case 3:
                    this.inputType = InputType.Number
                    this.typePlaceholder = $r('app.string.text_input_number_type')
                    break
                  case 4:
                    this.inputType = InputType.PhoneNumber
                    this.typePlaceholder = $r('app.string.text_input_phone_type')
                    break
                  default:
                    this.inputType = InputType.Normal
                    this.typePlaceholder = $r('app.string.text_input_normal_type')
                }
              }
            })
              .margin({ top: 12 })

            if (this.inputType === InputType.Password) {
              CommonItemSelect({
                selects: [$r('app.string.text_input_icon_show'), $r('app.string.text_input_icon_hide')],
                name: $r('app.string.text_input_show_password_icon'),
                callback: (index) => {
                  switch (index) {
                    case 1:
                      this.showPasswordIcon = false
                      break
                    default:
                      this.showPasswordIcon = true
                  }
                }
              })
            }
          }
          .backgroundStyle()

          IntroductionTitle({ introduction: $r('app.string.text_input_event') })
          TextInput({ placeholder: $r('app.string.text_input_event_placeholder') })
            .type(InputType.Email)
            .enterKeyType(EnterKeyType.Search)
            .onPaste(value => {
              ShowToast.longToast(
                `${this.context.resourceManager.getStringSync($r('app.string.text_input_toast_paste').id)}${value}`)
            })
            .onCut(value => {
              ShowToast.longToast(
                `${this.context.resourceManager.getStringSync($r('app.string.text_input_toast_cut').id)}${value}`)
            })
            .onCopy(value => {
              ShowToast.longToast(
                `${this.context.resourceManager.getStringSync($r('app.string.text_input_toast_copy').id)}${value}`)
            })
            .onSubmit(keyType => {
              ShowToast.longToast(
                `${this.context.resourceManager.getStringSync($r('app.string.text_input_toast_submit').id)}${keyType}`)
            })
            .onEditChange(isEditing => {
              // You can get edit status by isEditing
            })

          IntroductionTitle({ introduction: $r('app.string.text_input_placeholder_style') })
          TextInput({ placeholder: $r('app.string.text_input_placeholder') })
            .type(InputType.Normal)
            .placeholderFont({ size: '16fp', weight: FontWeight.Normal })
            .placeholderColor(Color.Red)

          IntroductionTitle({ introduction: $r('app.string.text_input_filter') })
          TextInput({ placeholder: $r('app.string.text_input_only_input_english') })
            .type(InputType.Normal)
            .copyOption(CopyOptions.None)
            .border({ width: this.hasFilterError ? 1 : 0, color: Color.Red })
            .inputFilter('[a-zA-Z]', (value: string) => {
              this.hasFilterError = true
            })
            .onChange((value: string) => {
              this.hasFilterError = false
            })
          Text(this.hasFilterError ? $r('app.string.text_input_only_input_english') : '')
            .width('100%')
            .height(this.hasFilterError ? 15 : 0)
            .fontSize(12)
            .margin({ top: 6 })
            .padding({ left: 16, right: 16 })
            .textAlign(TextAlign.Start)
            .fontColor(Color.Red)

          IntroductionTitle({ introduction: $r('app.string.text_input_max_length') })
          Stack() {
            TextInput({ placeholder: $r('app.string.text_input_placeholder_max_length') })
              .maxLength(this.maxLength)
              .onChange((value: string) => {
                this.inputLength = value.length
              })
            Text(`${this.inputLength}/${this.maxLength}`)
              .width('100%')
              .fontSize(16)
              .margin({ top: 6 })
              .padding({ left: 16, right: 16 })
              .textAlign(TextAlign.End)
              .fontColor(Color.Gray)
          }

          IntroductionTitle({ introduction: $r('app.string.text_input_caret_position') })
          Row() {
            TextInput({ controller: this.inputController })
              .layoutWeight(1)
              .onChange((value: string) => {
                this.caretIndex = value.length
                this.inputContent = value
                this.inputController.caretPosition(this.caretIndex)
              })
            Counter() {
              Text(this.caretIndex.toString())
            }
            .margin({ left: 12 })
            .onInc(() => {
              if (this.caretIndex >= 0 && this.caretIndex < this.inputContent.length) {

                this.inputController.caretPosition(++this.caretIndex)
              }
            })
            .onDec(() => {
              if (this.caretIndex > 0) {
                this.inputController.caretPosition(--this.caretIndex)
              }
            })
          }

          IntroductionTitle({ introduction: $r('app.string.text_input_set_text_selection') })
          Column() {
            TextInput({ controller: this.inputSelectController })
              .enableKeyboardOnFocus(false)
              .id('test_input_to_select')
              .onChange((value: string) => {
                this.inputSelectContent = value
                this.maxSelect = value.length
                for (let i = 0;i < this.maxSelect; i++) {
                  this.selects[i] = i.toString()
                }
              })
            Row() {
              Text($r('app.string.text_input_set_text_selection_start_select'))
              Column() {
                TextPicker({ range: this.selects, selected: this.select })
                  .onChange((value: string | string[], index: number | number[]) => {
                    if (!Array.isArray(value)) {
                      this.startSelect = Number.parseInt(value);
                      Logger.info(`Picker item changed, value: ${value}, index: ${index}`);
                    }
                  })
              }
              .height(90)
              .width(100)

              Text($r('app.string.text_input_set_text_selection_end_select'))
              Column() {
                TextPicker({ range: this.selects, selected: this.select })
                  .onChange((value: string | string[], index: number | number[]) => {
                    if (!Array.isArray(value)) {
                      this.endSelect = Number.parseInt(value);
                      Logger.info(`Picker item changed, value: ${value}, index: ${index}`);
                    }
                  })
                  .id('end_select')
              }
              .height(90)
              .width(100)

              Button($r('app.string.text_area_set_text_selection'))
                .id('button_to_select')
                .onClick(() => {
                  this.inputSelectController.setTextSelection(this.startSelect, this.endSelect)
                  Logger.info(`startSelect: ${this.startSelect}, endSelect: ${this.endSelect}`)
                })
            }
            .justifyContent(FlexAlign.SpaceAround)
            .width('100%')
          }
          .backgroundStyle()
          .margin({ bottom: 70 })
        }
        .constraintSize({ minHeight: '100%' }) // Let the minHeight of the component cover screen at least
      }
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .height('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}