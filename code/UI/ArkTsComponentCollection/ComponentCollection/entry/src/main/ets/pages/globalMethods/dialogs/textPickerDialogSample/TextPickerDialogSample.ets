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
import ShowToast from '../../../../util/ShowToast';
import { TitleBar } from '../../../../common/TitleBar';
import { getStringData } from '../../../../data/ResourceDataHandle';

@Extend(Row) function rowStyle() {
  .height(50)
  .padding(12)
  .width('100%')
  .borderRadius(24)
  .margin({ top: 12, bottom: 12 })
}

@Extend(Button) function commonButtonStyle() {
  .margin(8)
  .fontSize(16)
  .layoutWeight(1)
  .height(40)
  .padding({ left: 12, right: 12, top: 8, bottom: 8 })
}

@Entry
@Component
struct TextDialogSample {
  @State select: number = 2;
  private apple: string = getStringData($r('app.string.text_picker_text_apple'));
  private orange: string = getStringData($r('app.string.text_picker_text_orange'));
  private peach: string = getStringData($r('app.string.text_picker_text_peach'));
  private grape: string = getStringData($r('app.string.text_picker_text_grape'));
  private banana: string = getStringData($r('app.string.text_picker_text_banana'));
  private fruits: string[] = [this.apple, this.orange, this.peach, this.grape, this.banana];

  build() {
    Column() {
      TitleBar({ title: $r('app.string.text_picker_dialog') })
      Scroll() {
        Column() {
          IntroductionTitle({ introduction: $r('app.string.text_picker_show') })
          Row({ space: 16 }) {
            Button($r('app.string.text_picker_click_text'))
              .commonButtonStyle()
              .id('text_pickerButton')
              .onClick(() => {
                TextPickerDialog.show({
                  range: this.fruits,
                  selected: this.select,
                  onAccept: (value: TextPickerResult) => {
                    // 设置select为按下确定按钮时候的选中项index，这样当弹窗再次弹出时显示选中的是上一次确定的选项
                    ShowToast.shortToast(value.value.toString());
                  },
                  onCancel: () => {
                    ShowToast.shortToast($r('app.string.date_picker_dialog_cancel'));
                  },
                  onChange: (value: TextPickerResult) => {
                    ShowToast.shortToast(value.value.toString());
                  },
                  defaultPickerItemHeight: 50
                });
              })
          }
          .justifyContent(FlexAlign.Center)
          .rowStyle()
        }
        .constraintSize({ minHeight: '100%' })
      }
    }
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}