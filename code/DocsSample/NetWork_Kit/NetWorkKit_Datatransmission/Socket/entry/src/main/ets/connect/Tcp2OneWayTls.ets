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

import picker from '@ohos.file.picker';
import wifiManager from '@ohos.wifiManager';
import { MessageEvents, worker } from '@kit.ArkTS';

export interface TlsOneWayMessage {
  type: string; // 消息类型，如 'loadCA', 'connectToServer', 'sendMessage'
  fileUri?: string; // 文件路径，用于传递 CA 文件路径等
  serverIp?: string; // 服务器的 IP 地址
  serverPort?: number; // 服务器的端口
  ca?: string; // CA 证书内容
  message?: string; // 要发送的消息
  caContent?: string; // 加载后的 CA 证书内容
}

let ipNum = wifiManager.getIpInfo().ipAddress;
let localIp = (ipNum >>> 24) + '.' + (ipNum >> 16 & 0xFF) + '.' + (ipNum >> 8 & 0xFF) + '.' + (ipNum & 0xFF);
let caFileUri = '';

// 创建 Worker 实例
const workerPort = new worker.ThreadWorker('entry/ets/workers/Tcp2OneWayTlsWorker.ets');

@Entry
@Component
struct SingleTLSAuth {
  @State msgHistory: string = ''; // 通信历史记录
  @State sendMsg: string = ''; // 要发送的消息
  @State serverIp: string = ''; // 服务端IP
  @State serverPort: number = 5555; // 服务端端口
  @State ca: string = ''; // CA 证书内容
  @State canLoad: boolean = false; // 是否可以加载证书
  @State canConnect: boolean = false; // 是否可以连接
  @State canSend: boolean = false; // 是否可以发送消息
  scroller: Scroller = new Scroller();

  aboutToDisappear(): void {
    workerPort.terminate();
  }

  build() {
    Row() {
      Column() {
        Text($r('app.string.Tcp2OneWayTls'))
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .textAlign(TextAlign.Center)
          .padding(10)

        // 显示本地 IP 地址
        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
          Text($r('app.string.Local_IP_Address'))
            .fontSize(14)
            .width(100)
          Text(localIp)
            .fontSize(12)
            .width(150)
        }
        .width('100%')
        .padding(10)

        // 服务端 IP 和端口输入框
        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
          Text($r('app.string.Server_Address'))
            .fontSize(14)
            .width(100)
          TextInput({ text: this.serverIp })
            .onChange((value) => {
              this.serverIp = value;
            })
            .fontSize(12)
            .width(150)

          Text(':')
            .width(5)
          TextInput({ text: this.serverPort.toString() })
            .type(InputType.Number)
            .onChange((value) => {
              this.serverPort = parseInt(value);
            })
            .fontSize(12)
            .width(80)
        }
        .width('100%')
        .padding(10)

        // 选择和加载 CA 证书
        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
          Text($r('app.string.CA_File'))
            .fontSize(14)
            .width(120)
          Button($r('app.string.Select'))
            .onClick(() => {
              this.selectCA();
            })
            .width(70)
            .fontSize(14)
          Button($r('app.string.Load'))
            .onClick(() => {
              this.loadCA();
            })
            .enabled(this.canLoad)
            .width(70)
            .fontSize(14)
          Button($r('app.string.Connect'))
            .onClick(() => {
              this.connectToServer();
            })
            .enabled(this.canConnect)
            .width(70)
            .fontSize(14)
        }
        .width('100%')
        .padding(10)

        // 显示加载的 CA 内容
        TextArea({ text: this.ca })
          .onChange((value) => {
            this.ca = value;
          })
          .fontSize(12)
          .height(150)
          .padding(10)

        // 发送消息输入框
        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
          TextInput({ placeholder: $r('app.string.Enter_Message') })
            .onChange((value) => {
              this.sendMsg = value;
            })
            .fontSize(12)
            .width(200)
          Button($r('app.string.Send'))
            .onClick(() => {
              this.sendMessage();
            })
            .enabled(this.canSend)
            .width(70)
            .fontSize(14)
        }
        .width('100%')
        .padding(10)

        // 消息历史展示
        Scroll(this.scroller) {
          Text(this.msgHistory)
            .textAlign(TextAlign.Start)
            .padding(10)
            .width('100%')
            .backgroundColor(0xeeeeee)
        }
        .align(Alignment.Top)
        .backgroundColor(0xeeeeee)
        .height(300)
        .flexGrow(1)
        .scrollable(ScrollDirection.Vertical)
        .scrollBar(BarState.On)
        .scrollBarWidth(20)
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
      .height('100%')
    }
    .height('100%')
  }

  // 选择 CA 文件
  selectCA() {
    let documentPicker = new picker.DocumentViewPicker();
    documentPicker.select().then((result) => {
      if (result.length > 0) {
        caFileUri = result[0];
        this.msgHistory += `CA selected: ${caFileUri}\n`;
        this.canLoad = true;
      }
    }).catch((err: Error) => {
      this.msgHistory += `Fail to select CA: ${err.message}\n`;
    });
  }

  // 加载 CA 文件内容
  loadCA() {
    if (!caFileUri) {
      this.msgHistory += 'Error: CA file URI is empty.\r\n';
      return;
    }

    workerPort.postMessage({
      type: 'loadCA',
      fileUri: caFileUri
    });

    workerPort.onmessage = (e: MessageEvents) => {
      const response: TlsOneWayMessage = e.data;

      if (response.type === 'caLoaded') {
        if (response.caContent) {
          this.ca = response.caContent; // 确保 caContent 存在并赋值给 this.ca
          this.canConnect = true;
          this.msgHistory += 'CA Loaded\n';
        } else {
          this.msgHistory += 'CA is empty\n'; // 如果没有加载 CA 内容，进行错误提示
        }
      } else {
        this.msgHistory += `Load CA file: ${response.message}\n`;
      }
    };
  }

  // 连接到服务器
  connectToServer() {
    workerPort.postMessage({
      type: 'connectToServer',
      serverIp: this.serverIp,
      serverPort: this.serverPort,
      ca: this.ca
    });

    workerPort.onmessage = (e: MessageEvents) => {
      const response: TlsOneWayMessage = e.data;
      if (response.type === 'connectSuccess') {
        this.msgHistory += 'TCP connect success\n';
        this.upgradeToTLSSocket();
      } else {
        this.msgHistory += `TCP connect fail: ${response.message}\n`;
      }
    };
  }

  // 将 TCP Socket 升级为 TLS Socket
  upgradeToTLSSocket() {
    workerPort.postMessage({
      type: 'upgradeToTLS',
      serverIp: this.serverIp,
      serverPort: this.serverPort,
      ca: this.ca
    });

    workerPort.onmessage = (e: MessageEvents) => {
      const response: TlsOneWayMessage = e.data;
      if (response.type === 'tlsConnectSuccess') {
        this.msgHistory += 'TLS connect success\n';
        this.canSend = true;
      } else {
        this.msgHistory += `TLS connect fail: ${response.message}\n`;
      }
    };
  }

  // 发送消息到服务器
  sendMessage() {
    workerPort.postMessage({
      type: 'sendMessage',
      message: this.sendMsg
    });

    workerPort.onmessage = (e: MessageEvents) => {
      const response: TlsOneWayMessage = e.data;
      if (response.type === 'sendMessageSuccess') {
        this.msgHistory += `Me: ${response.message}\n`;
      } else if (response.type === 'sendMessageFailure') {
        this.msgHistory += `Send fail: ${response.message}\n`;
      } else if (response.type === 'connectionClosed') {
        this.msgHistory += `TLS connection closed\n`;
        this.canSend = false; // 连接关闭后，禁用发送按钮
      }
    };
  }
}
