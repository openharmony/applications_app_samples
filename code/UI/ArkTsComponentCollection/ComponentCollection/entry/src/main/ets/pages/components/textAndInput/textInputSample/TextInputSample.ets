/*
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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
import pasteboard from '@ohos.pasteboard';
import promptAction from '@ohos.promptAction';
import { BusinessError } from '@ohos.base';
import InputUtil from '../InputUtil';

const DURATION: number = 200000;
const NUM_TEXT_MAXSIZE_LENGTH: number = 14;

@Extend(Column) function backgroundStyle() {
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
  @State message: string = 'Hint';
  @State chooseContents: string = '';
  @State selectedStart: number = 0;
  @State selectedEnd: number = 0;
  @State textStr : string = '';
  @State lineBreakStrategy: LineBreakStrategy = LineBreakStrategy.GREEDY;
  @State lineBreakStrategyStr: Resource = $r('app.string.text_input_line_break_strategy_content');
  @State wordBreak: WordBreak = WordBreak.NORMAL;
  @State wordBreakTextStr: Resource = $r('app.string.text_input_word_break_content');
  private select: number = 0;
  private maxLength: number = 12;
  private submitContent: string='';
  private context: Context = getContext(this);
  private inputController: TextInputController = new TextInputController();
  private inputSelectController: TextInputController = new TextInputController();
  textInputController: TextInputController = new TextInputController();
  textController: TextController = new TextController();
  options: TextOptions = { controller: this.textController };

  @Builder LongPressImageCustomMenu() {
    Row() {
      Text($r('app.string.text_input_text_copy'))
        .fontSize(16)
        .margin({ left: 18, right: 24, top: 10, bottom: 11 })
        .onClick(() => {
          let pasteData: pasteboard.PasteData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, this.chooseContents);
          let systemPasteboard: pasteboard.SystemPasteboard = pasteboard.getSystemPasteboard();
          try {
            systemPasteboard.setDataSync(pasteData);
          } catch (err) {
            Logger.error('Failed to set PasteData. Cause:' + err.message);
          };

          try {
            promptAction.showToast({
              message: $r('app.string.text_input_text_copy_success'),
              duration: DURATION
            });
          } catch (error) {
            let message = (error as BusinessError).message;
            let code = (error as BusinessError).code;
            Logger.error('showToast args error code is ' + code + 'message is' + message);
          };
          this.textController.closeSelectionMenu();
        })
      Text($r('app.string.text_input_text_paste'))
        .fontSize(16)
        .margin({ top: 10, bottom: 11 })
        .onClick(() => {
          let systemPasteboard: pasteboard.SystemPasteboard = pasteboard.getSystemPasteboard();
          try {
            let result: pasteboard.PasteData = systemPasteboard.getDataSync();
            let plainText: string = result.getPrimaryText();

            this.message = this.message.substring(0, this.selectedStart) + plainText +
              this.message.substring(this.selectedEnd, this.message.length);

          } catch (err) {
            Logger.error('Failed to get PasteData. Cause:' + err.message);
          };

          try {
            promptAction.showToast({
              message: $r('app.string.text_input_text_paste_success'),
              duration: DURATION
            });
          } catch (error) {
            let message = (error as BusinessError).message;
            let code = (error as BusinessError).code;
            Logger.error('showToast args error code is ' + code + 'message is' + message);
          };
          this.textController.closeSelectionMenu();
        })

      Text($r('app.string.text_input_text_get'))
        .fontSize(16)
        .margin({ left: 24, right: 18, top: 10, bottom: 11 })
        .onClick(() => {
          try {
            promptAction.showToast({
              message: this.chooseContents,
              duration: DURATION
            });
          } catch (error) {
            let message = (error as BusinessError).message;
            let code = (error as BusinessError).code;
            Logger.error('showToast args error code is ' + code + 'message is' + message);
          };
          this.textController.closeSelectionMenu();
        })
    }
    .backgroundColor('#FFFFFF')
    .borderRadius(24)
  }

  build() {
    Column() {
      TitleBar({ title: $r('app.string.text_input_title') })
      Scroll() {
        Column() {
          IntroductionTitle({ introduction: $r('app.string.text_input_input_type') })
          Column() {
            TextInput({text: `${this.textStr}`, placeholder: this.typePlaceholder })
              .type(this.inputType).id('test_input')
              .showPasswordIcon(this.showPasswordIcon)
              .enableKeyboardOnFocus(false)
              .onChange((number: string) => {
                  if (this.inputType == InputType.PhoneNumber) {
                    let telNumberNoSpace: string = InputUtil.removeSpace(number);
                    if (telNumberNoSpace.length > NUM_TEXT_MAXSIZE_LENGTH - 2) {
                      this.textStr = telNumberNoSpace;
                    } else if (InputUtil.checkNeedNumberSpace(number)) {
                      if (telNumberNoSpace.length <= 3) {
                        this.textStr = telNumberNoSpace;
                      } else {
                        let split1: string = telNumberNoSpace.substring(0, 3);
                        let split2: string = telNumberNoSpace.substring(3);
                        this.textStr = split1 + ' ' + split2;
                        if (telNumberNoSpace.length > 7) {
                          split2 = telNumberNoSpace.substring(3, 7);
                          let split3: string = telNumberNoSpace.substring(7);
                          this.textStr = split1 + ' ' + split2 + ' ' + split3;
                        }
                      }
                    } else if (telNumberNoSpace.length > 8) {
                      let split4 = telNumberNoSpace.substring(0, 8);
                      let split5 = telNumberNoSpace.substring(8);
                      this.textStr = split4 + ' ' + split5;
                    } else {
                      this.textStr = number;
                    }
                  }
              })

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
            .onChange((value:string)=>{
              this.submitContent = value;
            })
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
                `${this.context.resourceManager.getStringSync($r('app.string.text_input_toast_submit').id)}${this.submitContent}`)
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
            Row() {
              Text($r('app.string.text_input_set_text_selection_start_select'))
                .fontSize(14)
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
              .width(60)

              Text($r('app.string.text_input_set_text_selection_end_select'))
                .fontSize(14)
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
              .width(60)

              Button($r('app.string.text_area_set_text_selection'))
                .id('button_to_select')
                .onClick(() => {
                  this.inputSelectController.setTextSelection(this.startSelect, this.endSelect)
                  Logger.info(`startSelect: ${this.startSelect}, endSelect: ${this.endSelect}`)
                })
            }
            .justifyContent(FlexAlign.SpaceAround)
            .width('100%')
            TextInput({ controller: this.inputSelectController })
              .defaultFocus(true)
              .enableKeyboardOnFocus(false)
              .id('test_input_to_select')
              .onChange((value: string) => {
                this.inputSelectContent = value
                this.maxSelect = value.length
                for (let i = 0;i <= this.maxSelect; i++) {
                  this.selects[i] = i.toString()
                }
              })
          }
          .backgroundStyle()
            // 文本选择菜单
            IntroductionTitle({ introduction: $r('app.string.text_input_text_selection_menu') })

            Column() {
              Row() {
                Text(undefined, this.options) {
                  Span(this.message)
                }
                .id('text_hint')
                .copyOption(CopyOptions.LocalDevice)
                .bindSelectionMenu(TextSpanType.TEXT, this.LongPressImageCustomMenu, TextResponseType.LONG_PRESS)
                .onTextSelectionChange((selectionStart: number, selectionEnd: number) => {
                  this.selectedStart = selectionStart;
                  this.selectedEnd = selectionEnd;
                  this.chooseContents = this.message.substring(selectionStart, selectionEnd);
                })
                .margin({ left: 12 })
              }
              .width('100%')
              .height(40)
              .backgroundColor($r('app.color.background_shallow_grey'))
              .borderRadius(20)
            }
            .backgroundStyle()

            // 文本删除
            IntroductionTitle({ introduction: $r('app.string.text_input_text_delete') })
            Column() {
              TextInput({ placeholder: 'input ...', controller: this.textInputController })
                .id('text_delete')
                .borderRadius(20)
                .cancelButton({
                  style: CancelButtonStyle.CONSTANT
                })
            }
            .backgroundStyle()

            // 设置折行规则
            IntroductionTitle({ introduction: $r('app.string.text_input_line_break_strategy') })
            Column() {
              CommonItemSelect({
                selects: ['GREEDY', 'HIGH_QUALITY', 'BALANCED'],
                name: $r('app.string.text_input_current_type'),
                callback: (index) => {
                  switch (index) {
                    case 1:
                      this.lineBreakStrategy = LineBreakStrategy.HIGH_QUALITY;
                      break
                    case 2:
                      this.lineBreakStrategy = LineBreakStrategy.BALANCED;
                      break
                    default:
                      this.lineBreakStrategy = LineBreakStrategy.GREEDY;
                  }
                }
              })

              TextInput({text: this.lineBreakStrategyStr})
                .id('text_line_break_strategy')
                .fontSize(12)
                .border({ width: 1 })
                .padding(10)
                .width('100%')
                .maxLines(5)
                .style(TextInputStyle.Inline)
                .lineBreakStrategy(this.lineBreakStrategy)
            }
            .backgroundStyle()

            // 设置断行规则
            IntroductionTitle({ introduction: $r('app.string.text_input_word_break') })
            Column() {
              CommonItemSelect({
                selects: ['NORMAL', 'BREAK_ALL', 'BREAK_WORD'],
                name: $r('app.string.text_input_current_type'),
                callback: (index) => {
                  switch (index) {
                    case 1:
                      this.wordBreak = WordBreak.BREAK_ALL;
                      break
                    case 2:
                      this.wordBreak = WordBreak.BREAK_WORD;
                      break
                    default:
                      this.wordBreak = WordBreak.NORMAL;
                  }
                }
              })

              TextInput({text: this.wordBreakTextStr})
                .id('text_word_break')
                .fontSize(12)
                .border({ width: 1 })
                .padding(10)
                .width('100%')
                .maxLines(5)
                .style(TextInputStyle.Inline) // Inline模式
                .wordBreak(this.wordBreak) // 非Inline模式该属性无效
            }
            .backgroundStyle()
            .margin({ bottom: 70 })
        }
        .constraintSize({ minHeight: '100%' }) // Let the minHeight of the component cover screen at least
      }
      .id('input_scroll')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .height('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}