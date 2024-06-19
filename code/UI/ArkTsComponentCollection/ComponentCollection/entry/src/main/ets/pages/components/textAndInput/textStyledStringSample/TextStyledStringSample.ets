/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { TitleBar } from '../../../../common/TitleBar';
import { CommonItemSelect } from '../../../../common/AttributeModificationTool';
import { IntroductionTitle } from './IntroductionTitle';
import ShowToast from '../../../../util/ShowToast';

@Extend(Column) function backgroundStyle() {
  .width('100%')
  .padding(12)
  .borderRadius(24)
  .backgroundColor(Color.White)
}

@Entry
@Component
struct TextStyledStringSample {
  @State inputSelectContent: string = '';
  @State fontColor: ResourceColor | undefined = undefined;
  private startSelect: number = 0;
  private startSelects: string[] = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];
  private selectedLength: number = 1;
  private lengthSelects: string[] = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];
  private context: Context = getContext(this);

  controller: TextController = new TextController();
  fontStyleAttr: StyledStringValue = new TextStyle({ fontColor: Color.Red, fontWeight: FontWeight.Bold });
  mutableStyledString: MutableStyledString =
    new MutableStyledString((this.context.resourceManager.getStringSync($r('app.string.text_content').id)), [{
      start: this.startSelect,
      length: this.selectedLength,
      styledKey: StyledStringKey.FONT,
      styledValue: this.fontStyleAttr
    }]);
  otherStyledString:StyledString = new StyledString('new style', [{
    start: 0,
    length: 9,
    styledKey: StyledStringKey.FONT,
    styledValue: new TextStyle({ fontColor: Color.Blue, fontWeight: FontWeight.Bold })
  }]);

  // GestureStyle
  gestureStyleAttr: GestureStyle = new GestureStyle({
    onClick: () => {
      ShowToast.longToast('trigger click event, change fontColor to green');
      this.fontColor = Color.Green;
    },
    onLongPress: () => {
      ShowToast.longToast('trigger long press event, change fontColor to orange');
      this.fontColor = Color.Orange;
    }
  });
  // 创建事件的对象gestureMutableStyledString
  gestureMutableStyledString: MutableStyledString = new MutableStyledString('Trigger gesture style: ' +
    (this.context.resourceManager.getStringSync($r('app.string.text_content').id)), [{
    start: 0,
    length: 21,
    styledKey: StyledStringKey.GESTURE,
    styledValue: this.gestureStyleAttr
  }]);
  gestureController: TextController = new TextController();

  async onPageShow() {
    this.controller.setStyledString(this.mutableStyledString);
    this.gestureController.setStyledString(this.gestureMutableStyledString);
  }

  build() {
    Column() {
      TitleBar({ title: $r('app.string.text_styled_string_title') })
      Scroll() {
        Column({ space: 12 }) {
          Scroll() {
            Column() {
                Text('', { controller: this.controller })
                  .key('mutableStyledString')
                  .minFontSize(16)
                  .maxFontSize(20)
                  .baselineOffset(0)
              }
              .backgroundStyle()
            }
            .height('20%')
            .scrollable(ScrollDirection.Vertical)

            IntroductionTitle({ introduction: $r('app.string.text_mutable_styled_string') })
            Column() {
              Row() {
                Text($r('app.string.text_mutable_styled_string_start'))
                  .fontSize(14)
                Column() {
                  TextPicker({ range: this.startSelects, selected: this.startSelect })
                    .onChange((value: string | string[], index: number | number[]) => {
                      if (!Array.isArray(value)) {
                        this.startSelect = Number.parseInt(value);
                      }
                    })
                    .id('start_select')
                }
                .height(90)
                .width(40)

                Text($r('app.string.text_mutable_styled_string_length'))
                  .fontSize(14)
                Column() {
                  TextPicker({ range: this.lengthSelects})
                    .onChange((value: string | string[], index: number | number[]) => {
                      if (!Array.isArray(value)) {
                        this.selectedLength = Number.parseInt(value);
                      }
                    })
                    .id('length_select')
                }
                .height(90)
                .width(50)

                Column() {
                  CommonItemSelect({
                    selects: ['replaceString', 'replaceStyle', 'replaceStyledString', 'insertString', 'insertStyledString',
                      'appendStyledString', 'removeString', 'removeStyle', 'removeStyles', 'clearStyles'],
                    isItemStyle: true,
                    callback: (index) => {
                      if (this.inputSelectContent.length == 0) {
                        ShowToast.longToast(
                          `${this.context.resourceManager.getStringSync($r('app.string.text_mutable_styled_error').id)}`);
                        return;
                      }
                      switch (index) {
                        case 1:
                          this.mutableStyledString.replaceStyle({
                            start: this.startSelect,
                            length: this.selectedLength,
                            styledKey: StyledStringKey.DECORATION,
                            styledValue: new DecorationStyle({type: TextDecorationType.LineThrough, color: Color.Blue})
                          });
                          break
                        case 2:
                          this.mutableStyledString.replaceStyledString(this.startSelect, this.selectedLength,
                            this.otherStyledString);
                          break
                        case 3:
                          this.mutableStyledString.insertString(this.startSelect, this.inputSelectContent);
                          break
                        case 4:
                          this.mutableStyledString.insertStyledString(this.startSelect, this.otherStyledString);
                          break
                        case 5:
                          this.mutableStyledString.appendStyledString(this.otherStyledString);
                          break
                        case 6:
                          this.mutableStyledString.removeString(this.startSelect, this.selectedLength);
                          break
                        case 7:
                          this.mutableStyledString.removeStyle(this.startSelect, this.selectedLength,
                            StyledStringKey.FONT);
                          break
                        case 8:
                          this.mutableStyledString.removeStyles(this.startSelect, this.selectedLength);
                          break
                        case 9:
                          this.mutableStyledString.clearStyles();
                          break
                        default:
                          this.mutableStyledString.replaceString(this.startSelect, this.selectedLength,
                            this.inputSelectContent);
                      }
                      this.controller.setStyledString(this.mutableStyledString);
                    }
                  })
                }
                .width('40%')
              }
              .justifyContent(FlexAlign.SpaceAround)
              .width('100%')
              TextInput()
                .defaultFocus(true)
                .enableKeyboardOnFocus(false)
                .id('test_input_to_select_string')
                .onChange((value: string) => {
                  this.inputSelectContent = value;
                })
            }
            .backgroundStyle()

            IntroductionTitle({ introduction: $r('app.string.text_styled_string_gesture_style') })
            Column() {
              Text('', { controller: this.gestureController })
                .key('gestureMutableStyledString')
                .height(80)
                .minFontSize(16)
                .maxFontSize(20)
                .baselineOffset(0)
                .fontColor(this.fontColor)
            }
            .backgroundStyle()
        }
        .constraintSize({ minHeight: '100%' })
      }
      .size({ width: '100%', height: '100%' })
      .padding({ left: 12, right: 12 })
    }
    .size({ width: '100%', height: '100%' })
    .justifyContent(FlexAlign.Center)
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}