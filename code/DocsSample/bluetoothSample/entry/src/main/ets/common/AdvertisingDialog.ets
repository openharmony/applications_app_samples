/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { util } from '@kit.ArkTS';

@CustomDialog
@Component
export struct AdvertisingDialog {
  @Link textValueOfAdvManufactureId: string;
  @Link inputValueOfAdvManufactureId: string;
  @Link textValueOfAdvManufactureValueBuffer: string;
  @Link inputValueOfAdvManufactureValueBuffer: Uint8Array;
  @Link textValueOfAdvServiceUuids: string;
  @Link inputValueOfAdvServiceUuids: string;
  @Link textValueOfAdvServiceBuffer: string;
  @Link inputValueOfAdvServiceBuffer: Uint8Array;
  @Link textValueOfAdvIncludeDeviceName: string;
  @Link inputValueOfAdvIncludeDeviceName: boolean;
  decoder = new util.TextDecoder();
  controller?: CustomDialogController
  cancel: () => void = () => {
  }
  confirm: () => void = () => {
  }

  build() {
    Column() {
      Text('set advertising parameters').fontSize(20).margin({ top: 10, bottom: 10 });
      Row() {
        Text('ManufactureValueBuffer')
          .margin(5)
          .width('30%')
        TextInput({ text: this.textValueOfAdvManufactureValueBuffer })
          .height(40)
          .width('65%')
          .onChange((value: string) => {
            this.textValueOfAdvManufactureValueBuffer = value;
          })
          .margin(5)
      }

      Row() {
        Text('manufactureId')
          .width('30%')
          .margin(5)
        TextInput({ text: this.textValueOfAdvManufactureId })
          .height(40)
          .width('65%')
          .onChange((value: string) => {
            this.textValueOfAdvManufactureId = value;
          })
          .margin(5)
      }

      Row() {
        Text('serviceBuffer')
          .width('30%')
          .margin(5)
        TextInput({ text: this.textValueOfAdvServiceBuffer })
          .height(40)
          .width('65%')
          .onChange((value: string) => {
            this.textValueOfAdvServiceBuffer = value;
          })
          .margin(5)
      }

      Row() {
        Text('serviceUuids')
          .width('30%')
          .margin(5)
        TextInput({ text: this.textValueOfAdvServiceUuids })
          .height(40)
          .width('65%')
          .onChange((value: string) => {
            this.textValueOfAdvServiceUuids = value;
          })
          .margin(5)
      }

      Row() {
        Text('enableIncludeDeviceName')
          .width('30%')
          .margin(5)
        TextInput({ text: this.textValueOfAdvIncludeDeviceName })
          .height(40)
          .width('65%')
          .onChange((value: string) => {
            this.textValueOfAdvIncludeDeviceName = value;
          })
          .margin(5)
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
            this.textValueOfAdvManufactureValueBuffer = '';
            this.textValueOfAdvManufactureId = '';
            this.textValueOfAdvServiceUuids = '';
            this.textValueOfAdvServiceBuffer = '';
            this.textValueOfAdvIncludeDeviceName = '';
            this.inputValueOfAdvManufactureValueBuffer = new Uint8Array(0);
            this.inputValueOfAdvManufactureId = '';
            this.inputValueOfAdvServiceUuids = '00001888-0000-1000-8000-00805f9b34fb';
            this.inputValueOfAdvServiceBuffer = new Uint8Array(0);
            this.inputValueOfAdvIncludeDeviceName = false;
          }).backgroundColor(0xffffff).fontColor(Color.Red)

        Button('confirm')
          .onClick(() => {
            if (this.controller != undefined) {
              let manufactureValueBuffer = new Uint8Array(this.textValueOfAdvManufactureValueBuffer.length);
              for (let i = 0; i < this.textValueOfAdvManufactureValueBuffer.length; i++) {
                manufactureValueBuffer[i] = parseInt(this.textValueOfAdvManufactureValueBuffer[i], 10);
              }
              let serviceBuffer = new Uint8Array(this.textValueOfAdvServiceBuffer.length);
              for (let i = 0; i < this.textValueOfAdvManufactureValueBuffer.length; i++) {
                manufactureValueBuffer[i] = parseInt(this.textValueOfAdvManufactureValueBuffer[i], 10);
              }
              this.inputValueOfAdvServiceBuffer = serviceBuffer;
              this.inputValueOfAdvManufactureValueBuffer = manufactureValueBuffer;
              this.inputValueOfAdvManufactureId = this.textValueOfAdvManufactureId;
              if (this.textValueOfAdvServiceUuids) {
                this.inputValueOfAdvServiceUuids = this.textValueOfAdvServiceUuids;
              }
              if (this.textValueOfAdvIncludeDeviceName) {
                this.inputValueOfAdvIncludeDeviceName = true;
              } else {
                this.inputValueOfAdvIncludeDeviceName = false;
              }
              this.controller.close();
              this.confirm();
            }
          }).backgroundColor(0xffffff).fontColor(Color.Red)
      }.margin({ bottom: 10 })
    }.borderRadius(10)
  }
}