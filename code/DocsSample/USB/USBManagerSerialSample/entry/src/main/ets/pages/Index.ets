/*
* Copyright (C) 2025 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

// [Start head]
// 导入usbManager模块
import { serialManager } from '@kit.BasicServicesKit';
import { BusinessError } from '@kit.BasicServicesKit'
import { buffer } from '@kit.ArkTS';
import { JSON } from '@kit.ArkTS';

// [End head]
@Entry
@Component
struct Index {
  @State logInfo_: string = '';
  @State portList_: serialManager.SerialPort[] = [];
  @State portId_: number = 0;

  private getPortList() {
    // [Start getPortList]
    // 获取连接主设备的USB设备列表
    let portList: serialManager.SerialPort[] = serialManager.getPortList();
    console.info(`usbSerial portList: ${portList}`);
    this.logInfo_ += '\n[INFO] usbSerial portList: ' + JSON.stringify(portList);
    if (portList === undefined || portList.length === 0) {
      console.error('usbSerial portList is empty');
      this.logInfo_ += '\n[ERROR] usbSerial portList is empty';
      return;
    }
    this.portList_ = portList;
    // [End getPortList]
  }

  private requestSerialRight() {
    // [Start requestSerialRight]
    if (this.portList_ === undefined || this.portList_.length === 0) {
      console.error('usbSerial portList is empty');
      this.logInfo_ += '\n[ERROR] usbSerial portList is empty';
      return;
    }
    let portList: serialManager.SerialPort[] = this.portList_;
    let portId: number = portList[0].portId;
    if (!serialManager.hasSerialRight(portId)) {
      serialManager.requestSerialRight(portId).then((result: boolean) => {
        console.info('serial device request right result: ' + result);
        this.logInfo_ += '\n[INFO] serial device request right result: ' + JSON.stringify(result);
      }).catch((error: BusinessError) => {
        console.error(`usb device request right failed : ${error}`);
        this.logInfo_ += '\n[ERROR] usb device request right failed: ' + JSON.stringify(error);
      });
    } else {
      console.info('serial device already request right');
      this.logInfo_ += '\n[INFO] serial device already request right';
    }
    this.portId_ = portId;
    // [End requestSerialRight]
  }

  private openSerialDevice() {
    // [Start openSerialDevice]
    let portId: number = this.portId_;
    try {
      serialManager.open(portId)
      console.info(`open usbSerial success, portId: ${portId}`);
      this.logInfo_ += '\n[INFO] open usbSerial success, portId: ' + JSON.stringify(portId);
    } catch (error) {
      console.error(`open usbSerial error： ${error}`);
      this.logInfo_ += '\n[ERROR] open usbSerial error: ' + JSON.stringify(error);
    }
    // [End openSerialDevice]
  }

  private serialRead() {
    // [Start serialRead]
    let portId: number = this.portId_;
    // 异步读取
    let readBuffer: Uint8Array = new Uint8Array(64);
    serialManager.read(portId, readBuffer, 2000).then((size: number) => {
      console.info(`readAsync usbSerial success, readAsyncBuffer: ${readBuffer}`);
      this.logInfo_ += '\n[INFO] readAsync usbSerial success, readAsyncBuffer: ' + JSON.stringify(readBuffer);
    }).catch((error: Error) => {
      console.error(`readAsync usbSerial error: ${error}`);
      this.logInfo_ += '\n[ERROR] readAsync usbSerial error: ' + JSON.stringify(error);
    })

    // 同步读取
    let readSyncBuffer: Uint8Array = new Uint8Array(64);
    try {
      serialManager.readSync(portId, readSyncBuffer, 2000);
      console.info(`readSync usbSerial success, readSyncBuffer: ${readSyncBuffer}`);
      this.logInfo_ += '\n[INFO] readSync usbSerial success, readSyncBuffer: ' + JSON.stringify(readSyncBuffer);
    } catch (error) {
      console.error(`readSync usbSerial error: ${error}`);
      this.logInfo_ += '\n[ERROR] readSync usbSerial error: ' + JSON.stringify(error);
    }
    // [End serialRead]
  }

  private serialWrite() {
    // [Start serialWrite]
    let portId: number = this.portId_;
    // 异步写入
    let writeBuffer: Uint8Array = new Uint8Array(buffer.from('Hello World', 'utf-8').buffer)
    serialManager.write(portId, writeBuffer, 2000).then((size: number) => {
      console.info(`writeAsync usbSerial success, writeAsyncBuffer: ${writeBuffer}`);
      this.logInfo_ += '\n[INFO] writeAsync usbSerial success, writeAsyncBuffer: ' + JSON.stringify(writeBuffer);
    }).catch((error: Error) => {
      console.error(`writeAsync usbSerial error: ${error}`);
      this.logInfo_ += '\n[ERROR] writeAsync usbSerial error: ' + JSON.stringify(error);
    })

    // 同步写入
    let writeSyncBuffer: Uint8Array = new Uint8Array(buffer.from('Hello World', 'utf-8').buffer)
    try {
      serialManager.writeSync(portId, writeSyncBuffer, 2000);
      console.info(`writeSync usbSerial success, writeSyncBuffer: ${writeSyncBuffer}`);
      this.logInfo_ += '\n[INFO] writeSync usbSerial success, writeSyncBuffer: ' + JSON.stringify(writeSyncBuffer);
    } catch (error) {
      console.error(`writeSync usbSerial error: ${error}`);
      this.logInfo_ += '\n[ERROR] writeSync usbSerial error: ' + JSON.stringify(error);
    }
    // [End serialWrite]
  }

  private getSerialConfig() {
    // [Start getSerialConfig]
    let portId: number = this.portId_;
    // 获取串口配置
    try {
      let attribute: serialManager.SerialAttribute = serialManager.getAttribute(portId);
      if (attribute === undefined) {
        console.error('getAttribute usbSerial error, attribute is undefined');
        this.logInfo_ += '\n[ERROR] getAttribute usbSerial error, attribute is undefined';
      } else {
        console.info(`getAttribute usbSerial success, attribute: ${attribute}`);
        this.logInfo_ += '\n[INFO] getAttribute usbSerial success, attribute: ' + JSON.stringify(attribute);
      }
    } catch (error) {
      console.error(`getAttribute usbSerial error: ${error}`);
      this.logInfo_ += '\n[ERROR] getAttribute usbSerial error: ' + JSON.stringify(error);
    }
    // [End getSerialConfig]
  }

  private setSerialConfig() {
    // [Start setSerialConfig]
    let portId: number = this.portId_;
    // 设置串口配置
    try {
      let attribute: serialManager.SerialAttribute = {
        baudRate: serialManager.BaudRates.BAUDRATE_9600,
        dataBits: serialManager.DataBits.DATABIT_8,
        parity: serialManager.Parity.PARITY_NONE,
        stopBits: serialManager.StopBits.STOPBIT_1
      }
      serialManager.setAttribute(portId, attribute);
      console.info(`setAttribute usbSerial success, attribute: ${attribute}`);
      this.logInfo_ += '\n[INFO] setAttribute usbSerial success, attribute: ' + JSON.stringify(attribute);
    } catch (error) {
      console.error(`setAttribute usbSerial error: ${error}`);
      this.logInfo_ += '\n[ERROR] setAttribute usbSerial error: ' + JSON.stringify(error);
    }
    // [End setSerialConfig]
  }

  private closeSerialDevice() {
    // [Start closeSerialDevice]
    let portId: number = this.portId_;
    try {
      serialManager.close(portId);
      console.info(`close usbSerial success, portId: ${portId}`);
      this.logInfo_ += '\n[INFO] close usbSerial success, portId: ' + JSON.stringify(portId);
    } catch (error) {
      console.error(`close usbSerial error: ${error}`);
      this.logInfo_ += '\n[ERROR] close usbSerial error: ' + JSON.stringify(error);
    }
    // [End closeSerialDevice]
  }

  build() {
    Column() {
      Row() {
        Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start, justifyContent: FlexAlign.SpaceBetween }) {
          TextArea({ text: this.logInfo_ })
            .height('100%')
            .width('100%')
            .fontSize(12)
            .onChange((value: string) => {
              this.logInfo_ = value;
            })
        }.height('100%').width('100%')
      }.height('40%')

      Row() {
        Button('获取设备列表', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .onClick(() => {

            this.getPortList();
          })
          .width('100%')
      }.padding({ top: 10 })

      Row() {
        Button('获取设备操作权限', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .onClick(() => {
            this.requestSerialRight();
          })
          .width('100%')
      }.padding({ top: 10 })

      Row() {
        Button('打开串口设备', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .onClick(() => {
            this.openSerialDevice();
          })
          .width('100%')
      }.padding({ top: 10 })

      Row() {
        Button('读取数据', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .onClick(() => {
            this.serialRead();
          })
          .width('100%')
      }.padding({ top: 10 })

      Row() {
        Button('写入数据', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .onClick(() => {
            this.serialWrite();
          })
          .width('100%')
      }.padding({ top: 10 })

      Row() {
        Button('获取串口配置', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .onClick(() => {
            this.getSerialConfig();
          })
          .width('100%')
      }.padding({ top: 10 })

      Row() {
        Button('修改串口配置', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .onClick(() => {
            this.setSerialConfig();
          })
          .width('100%')
      }.padding({ top: 10 })

      Row() {
        Button('关闭串口设备', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .onClick(() => {
            this.closeSerialDevice();
          })
          .width('100%')
      }.padding({ top: 10 })
    }.height('100%').width('100%').padding({ left: 10, right: 10 })
  }
}