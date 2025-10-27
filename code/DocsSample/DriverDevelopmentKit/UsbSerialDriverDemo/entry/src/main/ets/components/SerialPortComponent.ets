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

import RpcTool from '../tool/RpcTool';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { promptAction } from '@kit.ArkUI';
import { SerialPortStatusManager } from '../tool/SerialPortStatusManager';
import { TemperatureStatusManager } from '../tool/TemperatureStatusManager';

const TEXT_HEIGHT: number = 60;
const keyValuePairs = new Map<number, string>();

interface Options {
  value: string;
}

@Component
export struct SerialPortComponent {
  @State baudRateValue: string = '';
  @State baudRateIndex: number = 0;
  @State dataBitValue: string = '';
  @State dataBitIndex: number = 1;
  @State stopBitValue: string = '';
  @State stopBitIndex: number = 2;
  @State parityBitValue: string = '';
  @State parityBitIndex: number = 3;
  @State flowControlValue: string = '';
  @State flowControlIndex: number = 4;
  @State isSerialPortStatus: boolean = false; //串口状态
  @State connectStatus: boolean = false;
  // @Link msg:number;
  @State isReadStatus: boolean = false; //监听温度显示的读取温度状态
  private onReadTemperatureStatusChange = (status: boolean) => {
    hilog.info(0, 'testTag ui', `onReadTemperatureStatusChange status:${status}`);
    this.isReadStatus = status;
  };
  //定义波特率数组
  @State baudRates: Array<Options> = [{ value: '1200' }, { value: '2400' }, { value: '4800' }, { value: '9600' },
    { value: '19200' }, { value: '38400' }, { value: '57600' }, { value: '115200' }];
  //定义数据位数组
  @State dataBits: Array<Options> = [{ value: '8' }, { value: '7' }, { value: '6' }];
  //定义停止位数组
  @State stopBits: Array<Options> = [{ value: '1' }, { value: '2' }];
  //定义校验位
  @State parityBits: Array<Options> = [{ value: 'None' }, { value: 'Odd' }, { value: 'Even' }];
  //定义软件流控
  @State flowControls: Array<Options> = [{ value: '0' }, { value: '1' }, { value: '2' }];

  async aboutToAppear() {
    RpcTool.getInstance().initSerialPortComponent(this);
  }

  bindStatusChange(vendorId: string, productId: string) {
    hilog.info(0, 'testTag ui', `bindStatusChange vendorId: ${vendorId} productId:${productId}`);
    if (vendorId.length == 0 || productId.length == 0) {
      this.connectStatus = false;
    } else {
      this.connectStatus = true;
    }
  }

  build() {
    Column({ space: 10 }) {
      Row({ space: 10 }) {
        Text($r('app.string.baud_rates'))
          .padding({ left: 10 })
        Select(this.baudRates)
          .selected(this.baudRateIndex)
          .selectedOptionFont({ size: 13 })
          .optionFont({ size: 13 })
          .width('40%')
          .margin({ left: 20 })
          .onSelect((index: number, text?: string | undefined) => {
            hilog.info(0, 'testTag ui', `select baudRateIndex:${this.baudRateIndex}`);
            if (text) {
              this.baudRateValue = text;
              hilog.info(0, 'testTag ui', `baudRateValue:${this.baudRateValue}`);
            }
          })
      }.width('100%')
      .height(TEXT_HEIGHT)

      Row({ space: 10 }) {
        Text($r('app.string.data_bits'))
          .padding({ left: 10 })
        Select(this.dataBits)
          .selected(this.dataBitIndex)
          .selectedOptionFont({ size: 13 })
          .optionFont({ size: 13 })
          .width('40%')
          .margin({ left: 20 })
          .onSelect((index: number, text?: string | undefined) => {
            hilog.info(0, 'testTag ui', `select dataBitIndex:${this.dataBitIndex}`);
            if (text) {
              this.dataBitValue = text;
              hilog.info(0, 'testTag ui', `dataBitValue:${this.dataBitValue}`);
            }
          })
      }.width('100%')
      .height(TEXT_HEIGHT)

      Row({ space: 10 }) {
        Text($r('app.string.stop_bits'))
          .padding({ left: 10 })
        Select(this.stopBits)
          .selected(this.stopBitIndex)
          .selectedOptionFont({ size: 13 })
          .optionFont({ size: 13 })
          .width('40%')
          .margin({ left: 20 })
          .onSelect((index: number, text?: string | undefined) => {
            hilog.info(0, 'testTag ui', `select stopBitIndex:${this.stopBitIndex}`);
            if (text) {
              this.stopBitValue = text;
              hilog.info(0, 'testTag ui', `stopBitValue:${this.stopBitValue}`);
            }
          })
      }.width('100%')
      .height(TEXT_HEIGHT)

      Row({ space: 10 }) {
        Text($r('app.string.parity_bits'))
          .padding({ left: 10 })
        Select(this.parityBits)
          .selected(this.parityBitIndex)
          .selectedOptionFont({ size: 13 })
          .optionFont({ size: 13 })
          .width('40%')
          .margin({ left: 20 })
          .onSelect((index: number, text?: string | undefined) => {
            hilog.info(0, 'testTag ui', `select parityBitIndex:${this.parityBitIndex}`);
            if (text) {
              this.parityBitValue = text;
              hilog.info(0, 'testTag ui', `parityBitValue:${this.parityBitValue}`);
            }
          })
      }.width('100%')
      .height(TEXT_HEIGHT)

      Row({ space: 10 }) {
        Text($r('app.string.flow_controls'))
          .padding({ left: 10 })
        Select(this.flowControls)
          .selected(this.flowControlIndex)
          .selectedOptionFont({ size: 13 })
          .optionFont({ size: 13 })
          .width('40%')
          .onSelect((index: number, text?: string | undefined) => {
            hilog.info(0, 'testTag ui', `select flowControlIndex:${this.flowControlIndex}`);
            if (text) {
              this.flowControlValue = text;
              hilog.info(0, 'testTag ui', `flowControlValue:${this.flowControlValue}`);
            }
          })
      }.width('100%')
      .height(TEXT_HEIGHT)

      Row() {
        Button(this.isSerialPortStatus ? $r('app.string.close_serial') : $r('app.string.open_serial'))
          .enabled(this.connectStatus)
          .width('40%')
          .backgroundColor(this.isSerialPortStatus ? 'red' : '')
          .onClick(() => {
            if (this.baudRateValue != '' && this.dataBitValue != '' && this.stopBitValue != '' &&
              this.parityBitValue != '' && this.flowControlValue != '') {
              this.isSerialPortStatus = !this.isSerialPortStatus;
              if (this.isSerialPortStatus) {
                SerialPortStatusManager.notify(this.isSerialPortStatus);
                hilog.info(0, 'testTag ui', 'Open serial port successfully.');
                this.issueParameters();
              } else {
                TemperatureStatusManager.subscribe(this.onReadTemperatureStatusChange)
                if (this.isReadStatus == true) {
                  this.isSerialPortStatus = true;
                  SerialPortStatusManager.notify(this.isSerialPortStatus);
                  promptAction.showToast({ message: '正在读取温度，无法关闭串口.', duration: 2000 });
                  hilog.info(0, 'testTag ui', 'Reading temperature, unable to close serial port.');
                } else {
                  SerialPortStatusManager.notify(this.isSerialPortStatus);
                  hilog.info(0, 'testTag ui', 'Close serial port');
                  RpcTool.getInstance().closeConnection();
                }
              }
            } else {
              promptAction.showToast({ message: '有未选择的选项.', duration: 2000 });
              hilog.info(0, 'testTag ui', 'There are options not selected.');
            }
          })
      }
      .height(TEXT_HEIGHT)
      .alignItems(VerticalAlign.Center)
    }
    .width('100%')
    .height('80%')
    .margin({ top: 20 })
  }

  //下发波特率参数
  private issueParameters() {
    keyValuePairs.set(this.baudRateIndex, this.baudRateValue);
    keyValuePairs.set(this.dataBitIndex, this.dataBitValue);
    keyValuePairs.set(this.stopBitIndex, this.stopBitValue);
    keyValuePairs.set(this.parityBitIndex, this.parityBitValue);
    keyValuePairs.set(this.flowControlIndex, this.flowControlValue);
    RpcTool.getInstance().setKeyValue(keyValuePairs);
  }
}