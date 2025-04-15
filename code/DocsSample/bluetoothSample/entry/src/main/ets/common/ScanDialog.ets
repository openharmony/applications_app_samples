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

@CustomDialog
@Component
export struct ScanDialog {
  @Link textValueOfInterval: string;
  @Link inputValueOfInterval: string;
  @Link textValueOfManufactureId: string;
  @Link inputValueOfManufactureId: string;
  @Link textValueOfDeviceName: string;
  @Link inputValueOfDeviceName: string;
  @Link textValueOfDeviceId: string;
  @Link inputValueOfDeviceId: string;
  controller?: CustomDialogController
  cancel: () => void = () => {
  }
  confirm: () => void = () => {
  }

  build() {
    Column() {
      Text('set scan filtering parameters').fontSize(20).margin({ top: 10, bottom: 10 });
      Row() {
        Text('interval')
          .width('30%')
          .margin(5)
        TextInput({ placeholder: 'default is 0', text: this.textValueOfInterval })
          .height(40)
          .width('65%')
          .onChange((value: string) => {
            this.textValueOfInterval = value;
          })

      }

      Row() {
        Text('manufactureId')
          .width('30%')
          .margin(5)
        TextInput({ placeholder: 'default is 4567', text: this.textValueOfManufactureId })
          .height(40)
          .width('65%')
          .onChange((value: string) => {
            this.textValueOfManufactureId = value;
          })
      }

      Row() {
        Text('deviceName')
          .width('30%')
          .margin(5)
        TextInput({ placeholder: 'default is \'\'', text: this.textValueOfDeviceName })
          .height(40)
          .width('65%')
          .onChange((value: string) => {
            this.textValueOfDeviceName = value;
          })
      }

      Row() {
        Text('deviceId')
          .width('30%')
          .margin(5)
        TextInput({ placeholder: 'default is \'\'', text: this.textValueOfDeviceId })
          .height(40)
          .width('65%')
          .onChange((value: string) => {
            this.textValueOfDeviceId = value;
          })
      }

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('cancel')
          .onClick(() => {
            if (this.controller != undefined) {
              this.controller.close();
              this.cancel();
            }
          }).backgroundColor(0xffffff).fontColor(Color.Black)

        Button('clean up')
          .onClick(() => {
            this.textValueOfInterval = '';
            this.inputValueOfInterval = '0';
            this.textValueOfManufactureId = '';
            this.inputValueOfManufactureId = '4567';
            this.textValueOfDeviceName = '';
            this.inputValueOfDeviceName = '';
            this.textValueOfDeviceId = '';
            this.inputValueOfDeviceId = '';
          }).backgroundColor(0xffffff).fontColor(Color.Red)

        Button('confirm')
          .onClick(() => {
            if (this.controller != undefined) {
              this.inputValueOfInterval = this.textValueOfInterval;
              this.inputValueOfManufactureId = this.textValueOfManufactureId;
              this.inputValueOfDeviceName = this.textValueOfDeviceName;
              this.inputValueOfDeviceId = this.textValueOfDeviceId;
              this.controller.close();
              this.confirm();
            }
          }).backgroundColor(0xffffff).fontColor(Color.Red)
      }.margin({ bottom: 10 })
    }.borderRadius(10)
  }
}