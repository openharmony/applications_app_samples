/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
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
import { serial, BusinessError } from '@kit.BasicServicesKit';
// [End head]

const TAG = '[SerialSample]';

@Entry
@Component
struct Index {
  private port: serial.SerialPort | null = null;
  private dataCallback: ((data: Uint8Array) => void) | null = null;

  build() {
    Scroll() {
      Column({ space: 10 }) {
        Text('Serial Manager Sample')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 20, bottom: 10 })

        Text('Basic')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .width('90%')

        Button('getSerialPortList')
          .width('90%')
          .onClick(() => this.testGetSerialPortList())

        Button('portInfo')
          .width('90%')
          .onClick(() => this.testPortInfo())

        Button('open')
          .width('90%')
          .onClick(() => this.testOpen())

        Text('Data Transfer')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .width('90%')
          .margin({ top: 10 })

        Button('write')
          .width('90%')
          .onClick(() => this.testWrite())

        Button('onDataRead')
          .width('90%')
          .onClick(() => this.testOnDataRead())

        Button('offDataRead')
          .width('90%')
          .onClick(() => this.testOffDataRead())

        Text('Buffer & Signal')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .width('90%')
          .margin({ top: 10 })

        Button('flush')
          .width('90%')
          .onClick(() => this.testFlush())

        Button('drain')
          .width('90%')
          .onClick(() => this.testDrain())

        Button('setRts')
          .width('90%')
          .onClick(() => this.testSetRts())

        Button('getCts')
          .width('90%')
          .onClick(() => this.testGetCts())

        Button('sendBrk')
          .width('90%')
          .onClick(() => this.testSendBrk())

        Text('Close')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .width('90%')
          .margin({ top: 10 })

        Button('close')
          .width('90%')
          .onClick(() => this.testClose())
      }
      .width('100%')
      .padding({ left: '5%', right: '5%', bottom: 30 })
    }
    .width('100%')
    .height('100%')
  }

  async testGetSerialPortList(): Promise<void> {
    // [Start getSerialPortList]
    try {
      const portList = await serial.getSerialPortList();
      console.info(`${TAG} getSerialPortList success, count: ${portList.length}`);
      portList.forEach((port: serial.SerialPort, index: number) => {
        console.info(`${TAG}   [${index}] portName=${port.portInfo.portName}, vendorId=${port.portInfo.vendorId}, productId=${port.portInfo.productId}`);
      });
      if (portList.length > 0) {
        this.port = portList[0];
      }
    } catch (err) {
      const e = err as BusinessError;
      console.error(`${TAG} getSerialPortList failed, code: ${e.code}, message: ${e.message}`);
    }
    // [End getSerialPortList]
  }

  async testPortInfo(): Promise<void> {
    // [Start portInfo]
    try {
      if (!this.port) {
        console.error(`${TAG} No serial port found, please call getSerialPortList first`);
        return;
      }
      const info = this.port.portInfo;
      console.info(`${TAG} portInfo: portName=${info.portName}, vendorId=${info.vendorId}, productId=${info.productId}, manufacturer=${info.manufacturer}`);
    } catch (err) {
      const e = err as BusinessError;
      console.error(`${TAG} portInfo failed, code: ${e.code}, message: ${e.message}`);
    }
    // [End portInfo]
  }

  async testOpen(): Promise<void> {
    // [Start open]
    try {
      if (!this.port) {
        console.error(`${TAG} No serial port found, please call getSerialPortList first`);
        return;
      }
      const config: serial.SerialConfigs = {
        baudRate: 115200,
        dataBits: serial.DataBits.EIGHT,
        stopBits: serial.StopBits.ONE,
        parity: serial.Parity.NONE
      };
      await this.port.open(config);
      console.info(`${TAG} open success`);
    } catch (err) {
      const e = err as BusinessError;
      console.error(`${TAG} open failed, code: ${e.code}, message: ${e.message}`);
    }
    // [End open]
  }

  async testWrite(): Promise<void> {
    // [Start write]
    try {
      if (!this.port) {
        console.error(`${TAG} No serial port found, please call getSerialPortList first`);
        return;
      }
      const data = new Uint8Array([0x48, 0x65, 0x6C, 0x6C, 0x6F]);
      const writeLen = await this.port.write(data);
      console.info(`${TAG} write success, length: ${writeLen}`);
    } catch (err) {
      const e = err as BusinessError;
      console.error(`${TAG} write failed, code: ${e.code}, message: ${e.message}`);
    }
    // [End write]
  }

  async testOnDataRead(): Promise<void> {
    // [Start onDataRead]
    try {
      if (!this.port) {
        console.error(`${TAG} No serial port found, please call getSerialPortList first`);
        return;
      }
      this.dataCallback = (data: Uint8Array) => {
        console.info(`${TAG} onDataRead: ${Array.from(data).join(', ')}`);
      };
      this.port.onDataRead(this.dataCallback);
      console.info(`${TAG} onDataRead registered`);
    } catch (err) {
      const e = err as BusinessError;
      console.error(`${TAG} onDataRead failed, code: ${e.code}, message: ${e.message}`);
    }
    // [End onDataRead]
  }

  async testOffDataRead(): Promise<void> {
    // [Start offDataRead]
    try {
      if (!this.port) {
        console.error(`${TAG} No serial port found, please call getSerialPortList first`);
        return;
      }
      if (!this.dataCallback) {
        console.error(`${TAG} No data callback registered, please call onDataRead first`);
        return;
      }
      this.port.offDataRead(this.dataCallback);
      this.dataCallback = null;
      console.info(`${TAG} offDataRead success`);
    } catch (err) {
      const e = err as BusinessError;
      console.error(`${TAG} offDataRead failed, code: ${e.code}, message: ${e.message}`);
    }
    // [End offDataRead]
  }

  async testFlush(): Promise<void> {
    // [Start flush]
    try {
      if (!this.port) {
        console.error(`${TAG} No serial port found, please call getSerialPortList first`);
        return;
      }
      await this.port.flush();
      console.info(`${TAG} flush success`);
    } catch (err) {
      const e = err as BusinessError;
      console.error(`${TAG} flush failed, code: ${e.code}, message: ${e.message}`);
    }
    // [End flush]
  }

  async testDrain(): Promise<void> {
    // [Start drain]
    try {
      if (!this.port) {
        console.error(`${TAG} No serial port found, please call getSerialPortList first`);
        return;
      }
      await this.port.drain();
      console.info(`${TAG} drain success`);
    } catch (err) {
      const e = err as BusinessError;
      console.error(`${TAG} drain failed, code: ${e.code}, message: ${e.message}`);
    }
    // [End drain]
  }

  async testSetRts(): Promise<void> {
    // [Start setRts]
    try {
      if (!this.port) {
        console.error(`${TAG} No serial port found, please call getSerialPortList first`);
        return;
      }
      await this.port.setRts(true);
      console.info(`${TAG} setRts(true) success`);
    } catch (err) {
      const e = err as BusinessError;
      console.error(`${TAG} setRts failed, code: ${e.code}, message: ${e.message}`);
    }
    // [End setRts]
  }

  async testGetCts(): Promise<void> {
    // [Start getCts]
    try {
      if (!this.port) {
        console.error(`${TAG} No serial port found, please call getSerialPortList first`);
        return;
      }
      const ctsStatus = await this.port.getCts();
      console.info(`${TAG} getCts success, CTS: ${ctsStatus}`);
    } catch (err) {
      const e = err as BusinessError;
      console.error(`${TAG} getCts failed, code: ${e.code}, message: ${e.message}`);
    }
    // [End getCts]
  }

  async testSendBrk(): Promise<void> {
    // [Start sendBrk]
    try {
      if (!this.port) {
        console.error(`${TAG} No serial port found, please call getSerialPortList first`);
        return;
      }
      await this.port.sendBrk();
      console.info(`${TAG} sendBrk success`);
    } catch (err) {
      const e = err as BusinessError;
      console.error(`${TAG} sendBrk failed, code: ${e.code}, message: ${e.message}`);
    }
    // [End sendBrk]
  }

  async testClose(): Promise<void> {
    // [Start close]
    try {
      if (!this.port) {
        console.error(`${TAG} No serial port found, please call getSerialPortList first`);
        return;
      }
      await this.port.close();
      console.info(`${TAG} close success`);
      this.port = null;
    } catch (err) {
      const e = err as BusinessError;
      console.error(`${TAG} close failed, code: ${e.code}, message: ${e.message}`);
    }
    // [End close]
  }
}
