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

import { picker } from '@kit.CoreFileKit';
import { MessageEvents, util, worker } from '@kit.ArkTS';
import fs from '@ohos.file.fs';

const workerPort = new worker.ThreadWorker('entry/ets/workers/TlsServerWorker.ets');

export interface TlsServerMessage {
  type: string;
  serverIp?: string; // 服务器 IP 地址
  serverPort?: number; // 服务器端口
  serverKey?: string; // CA 证书内容
  serverCert?: string; // 客户端证书内容
  caCert?: string; // 客户端私钥内容
  message?: string;
}

@Entry
@Component
struct TLS_Server {
  @State msgHistory: string = ''; // 通信历史记录
  @State serverIp: string = ''; // 服务器 IP 同一网段下
  @State serverPort: number = 5555; // 服务器端口
  @State serverKey: string = ''; // 服务器私钥内容
  @State serverCert: string = ''; // 服务器证书内容
  @State caCert: string = ''; // CA 证书内容
  @State canStartServer: boolean = false; // 是否可以启动服务器
  @State canSendMessage: boolean = false; // 是否可以发送消息
  @State tlsServerRunning: boolean = false; // TLS 服务器是否正在运行
  scroller: Scroller = new Scroller();

  aboutToDisappear(): void {
    workerPort.terminate();
  }

  build() {
    Column() {
      Text($r('app.string.TlsServer'))
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 10, bottom: 10 })
        .width('100%')
        .textAlign(TextAlign.Center)
        .padding(10)

      // 服务器IP与端口输入框
      Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
        Text($r('app.string.Server_Address'))
          .width(120)
          .fontSize(14)
        TextInput({ text: this.serverIp })
          .onChange((value) => {
            this.serverIp = value;
          })
          .width(200)
          .fontSize(12)
        TextInput({ text: this.serverPort.toString() })
          .type(InputType.Number)
          .onChange((value) => {
            this.serverPort = parseInt(value);
          })
          .width(100)
          .fontSize(12)
      }
      .padding(10)

      // 选择并加载服务器私钥
      Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
        Text($r('app.string.Select_Server_Key'))
          .width(120)
          .fontSize(14)
        Button($r('app.string.Select'))
          .onClick(() => {
            this.selectServerKey();
          })
          .width(100)
          .fontSize(14)
        Button($r('app.string.Load'))
          .onClick(() => {
            this.loadServerKey();
          })
          .enabled(this.serverKey !== '')
          .width(100)
          .fontSize(14)
      }
      .padding(10)

      // 选择并加载服务器证书
      Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
        Text($r('app.string.Select_Server_Cert'))
          .width(120)
          .fontSize(14)
        Button($r('app.string.Select'))
          .onClick(() => {
            this.selectServerCert();
          })
          .width(100)
          .fontSize(14)
        Button($r('app.string.Load'))
          .onClick(() => {
            this.loadServerCert();
          })
          .enabled(this.serverCert !== '')
          .width(100)
          .fontSize(14)
      }
      .padding(10)

      // 选择并加载 CA 证书
      Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
        Text($r('app.string.CA_File'))
          .width(120)
          .fontSize(14)
        Button($r('app.string.Select'))
          .onClick(() => {
            this.selectCACert();
          })
          .width(100)
          .fontSize(14)
        Button($r('app.string.Load'))
          .onClick(() => {
            this.loadCACert();
          })
          .enabled(this.caCert !== '')
          .width(100)
          .fontSize(14)
      }
      .padding(10)

      // 启动服务器按钮
      Button($r('app.string.Start_Server'))
        .onClick(() => {
          this.startServer();
        })
        .enabled(this.canStartServer)
        .width(150)
        .fontSize(14)

      // 消息历史展示区
      TextArea({ text: this.msgHistory })
        .height(150)
        .padding(10)
        .width('100%')

      // 滚动区域
      Scroll(this.scroller) {
        Text(this.msgHistory)
          .textAlign(TextAlign.Start)
          .padding(10)
          .width('100%')
          .backgroundColor(0xeeeeee)
      }
      .height(300)
      .scrollable(ScrollDirection.Vertical)
    }
    .width('100%')
  }

  // 选择并加载服务器私钥
  selectServerKey() {
    let documentPicker = new picker.DocumentViewPicker();
    documentPicker.select().then((result) => {
      if (result.length > 0) {
        this.serverKey = result[0];
        this.msgHistory += `Selected server private key file: ${this.serverKey}\n`;
      }
    }).catch((err: Error) => {
      this.msgHistory += `Failed to select server private key file: ${err.message}\n`;
    });
  }

  loadServerKey() {
    try {
      let buf = new ArrayBuffer(4096); // 设置缓冲区大小为4096字节
      let file = fs.openSync(this.serverKey, fs.OpenMode.READ_ONLY);
      let readLen = fs.readSync(file.fd, buf, { offset: 0 });
      this.serverKey = this.bufToString(buf.slice(0, readLen));
      this.msgHistory += 'Server private key loaded successfully\n';
      this.checkCanStartServer();
    } catch (err) {
      this.msgHistory += `Failed to load server private key: ${err.message}\n`;
    }
  }

  // 选择并加载服务器证书
  selectServerCert() {
    let documentPicker = new picker.DocumentViewPicker();
    documentPicker.select().then((result) => {
      if (result.length > 0) {
        this.serverCert = result[0];
        this.msgHistory += `Selected server certificate file: ${this.serverCert}\n`;
      }
    }).catch((err: Error) => {
      this.msgHistory += `Failed to select server certificate file: ${err.message}\n`;
    });
  }

  loadServerCert() {
    try {
      let buf = new ArrayBuffer(4096); // 设置缓冲区大小为4096字节
      let file = fs.openSync(this.serverCert, fs.OpenMode.READ_ONLY);
      let readLen = fs.readSync(file.fd, buf, { offset: 0 });
      this.serverCert = this.bufToString(buf.slice(0, readLen));
      this.msgHistory += 'Server certificate loaded successfully\n';
      this.checkCanStartServer();
    } catch (err) {
      this.msgHistory += `Failed to load server certificate: ${err.message}\n`;
    }
  }

  // 选择并加载 CA 证书
  selectCACert() {
    let documentPicker = new picker.DocumentViewPicker();
    documentPicker.select().then((result) => {
      if (result.length > 0) {
        this.caCert = result[0];
        this.msgHistory += `Selected CA certificate file: ${this.caCert}\n`;
      }
    }).catch((err: Error) => {
      this.msgHistory += `Failed to select CA certificate file: ${err.message}\n`;
    });
  }

  loadCACert() {
    try {
      let buf = new ArrayBuffer(4096); // 设置缓冲区大小为4096字节
      let file = fs.openSync(this.caCert, fs.OpenMode.READ_ONLY);
      let readLen = fs.readSync(file.fd, buf, { offset: 0 });
      this.caCert = this.bufToString(buf.slice(0, readLen));
      this.msgHistory += 'CA certificate loaded successfully\n';
      this.checkCanStartServer();
    } catch (err) {
      this.msgHistory += `Failed to load CA certificate: ${err.message}\n`;
    }
  }

  checkCanStartServer() {
    if (this.serverKey && this.serverCert && this.caCert) {
      this.canStartServer = true;
    }
  }

  // 启动服务器
  startServer() {
    workerPort.postMessage({
      type: 'startServer',
      serverIp: this.serverIp,
      serverPort: this.serverPort,
      serverKey: this.serverKey,
      serverCert: this.serverCert,
      caCert: this.caCert
    });

    workerPort.onmessage = (e: MessageEvents) => {
      const response: TlsServerMessage = e.data;
      if (response.type === 'serverStarted') {
        this.msgHistory += 'TLS server started successfully\n';
        this.tlsServerRunning = true;
      } else if (response.type === 'error') {
        this.msgHistory += `Error: ${response.message}\n`;
      } else if (response.type === 'clientMessage') {
        this.msgHistory += `Client message: ${response.message}\n`;
      } else if (response.type === 'messageSent') {
        this.msgHistory += `Message sent: ${response.message}\n`;
      } else if (response.type === 'connectionClosed') {
        this.msgHistory += `Connection closed: ${response.message}\n`;
      }
    };
  }

  bufToString(buf: ArrayBuffer): string {
    let msgArray = new Uint8Array(buf);
    let textDecoder = util.TextDecoder.create('utf-8');
    return textDecoder.decodeToString(msgArray);
  }
}
