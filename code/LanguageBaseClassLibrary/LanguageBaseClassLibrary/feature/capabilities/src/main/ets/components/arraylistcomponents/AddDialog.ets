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

import prompt from '@ohos.promptAction';
import { Information } from '../../model/Information';
import { logger } from '@ohos/common/src/main/ets/util/Logger';

const TAG: string = 'AddDialog';

@CustomDialog
export struct AddDialog {
  @State writeInformation: Information = new Information('', Number.NaN, '')
  private saveData: (information: Information) => void = () => {
  };
  private controller?: CustomDialogController;

  build() {
    Column() {
      Text($r('app.string.contact_information'))
        .fontSize(24)
        .fontColor(Color.Black)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 12 })
      Row() {
        Text($r('app.string.contact_name'))
          .width(65)
          .fontSize(20)
          .fontColor(Color.Black)
          .fontWeight(FontWeight.Medium)
          .margin({ left: 10 })

        TextInput({ placeholder: $r('app.string.input_name'), text: this.writeInformation.name })
          .key('inputPhone')
          .layoutWeight(1)
          .type(InputType.Normal)
          .placeholderColor(Color.Gray)
          .fontSize(19)
          .maxLength(11)
          .margin({ right: 10 })
          .onChange((value: string) => {
            this.writeInformation.name = value;
            logger.info(TAG, ` this.writeInformation.name = ${value}`);
          })
      }
      .margin({ top: 12 })

      Row() {
        Text($r('app.string.contact_age'))
          .width(65)
          .fontSize(20)
          .fontColor(Color.Black)
          .fontWeight(FontWeight.Medium)
          .margin({ left: 10 })

        TextInput({ placeholder: $r('app.string.input_age') })
          .key('inputPhone')
          .layoutWeight(1)
          .type(InputType.Number)
          .placeholderColor(Color.Gray)
          .fontSize(19)
          .maxLength(11)
          .margin({ right: 10 })
          .onChange((value: string) => {
            this.writeInformation.age = Number(value);
          })
      }
      .margin({ top: 12 })

      Row() {
        Text($r('app.string.contact_phone'))
          .width(65)
          .fontSize(20)
          .fontColor(Color.Black)
          .fontWeight(FontWeight.Medium)
          .margin({ left: 10 })

        TextInput({ placeholder: $r('app.string.input_phone'), text: this.writeInformation.phone })
          .key('inputPhone')
          .layoutWeight(1)
          .type(InputType.Number)
          .placeholderColor(Color.Gray)
          .fontSize(19)
          .maxLength(11)
          .margin({ right: 10 })
          .onChange((value: string) => {
            this.writeInformation.phone = value;
          })
      }
      .margin({ top: 12 })

      Row() {
        Button() {
          Text($r("app.string.button_confirm"))
            .key('confirm')
            .fontColor(Color.Blue)
            .fontSize(17)
        }
        .layoutWeight(7)
        .backgroundColor(Color.White)
        .margin(5)
        .onClick(() => {
          this.addInformation();
        })

        Divider()
          .height(30)
          .vertical(true)
          .strokeWidth(2)
          .color('#999999')

        Button() {
          Text($r('app.string.button_cancel'))
            .fontColor(Color.Red)
            .fontSize(17)
        }
        .margin(5)
        .layoutWeight(7)
        .backgroundColor(Color.White)
        .onClick(() => {
          this.controller?.close();
        })
      }
      .margin({ top: 12 })
    }
    .padding(12)
  }

  addInformation() {
    if (this.writeInformation.name === '') {
      prompt.showToast({ message: $r('app.string.name_null') });
      return;
    }
    if (this.writeInformation.age < 1 || Number.isNaN(this.writeInformation.age)) {
      prompt.showToast({ message: $r('app.string.age_null') });
      return;
    }
    if (this.writeInformation.phone === '') {
      prompt.showToast({ message: $r('app.string.phone_null') });
      return;
    }
    if (this.writeInformation.name !== '' && this.writeInformation.phone !== '' && this.writeInformation.age > 0) {
      this.saveData(this.writeInformation);
    }
    this.controller?.close();
  }
}