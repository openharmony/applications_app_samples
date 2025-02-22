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

import { MessageEvents, worker } from '@kit.ArkTS';
import wifiManager from '@ohos.wifiManager';
import picker from '@ohos.file.picker';

const workerPort = new worker.ThreadWorker('entry/ets/workers/OneWayTlsWorker.ets');

interface TlsOneWayMessage {
  type: string;
  fileUri?: string; // 用于传递 CA 文件路径
  serverIp?: string;
  serverPort?: number;
  ca?: string;
  message?: string;
  caContent?: string;
}

let ipNum = wifiManager.getIpInfo().ipAddress;
let localIp = (ipNum >>> 24) + '.' + (ipNum >> 16 & 0xFF) + '.' + (ipNum >> 8 & 0xFF) + '.' + (ipNum & 0xFF);
let caFileUri = '';

@Entry
@Component
struct Index {
  @State msgHistory: string = '';
  @State sendMsg: string = '';
  @State serverIp: string = ''; // 服务端IP地址
  @State serverPort: number = 5555; // 服务端端口号
  @State canLoad: boolean = false;
  @State canConnect: boolean = false;
  @State canSend: boolean = false;
  @State ca: string = '';
  scroller: Scroller = new Scroller();

  aboutToDisappear(): void {
    workerPort.terminate();
  }

  build() {
    Row() {
      Column() {
        Text($r('app.string.TLS_Communication_Example'))
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .textAlign(TextAlign.Center)
          .padding(10)

        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
          Text($r('app.string.Local_IP_Address'))
            .width(100)
            .fontSize(14)
            .flexGrow(0)
          Text(localIp)
            .width(110)
            .fontSize(12)
            .flexGrow(1)
        }.width('100%')
        .padding(10)

        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
          Text($r('app.string.Server_Address'))
            .fontSize(14)
            .width(90)
            .flexGrow(1)

          TextInput({ text: this.serverIp })
            .onChange((value) => {
              this.serverIp = value;
            })
            .width(110)
            .fontSize(12)
            .flexGrow(4)

          Text(':')
            .width(5)
            .flexGrow(0)

          TextInput({ text: this.serverPort.toString() })
            .type(InputType.Number)
            .onChange((value) => {
              this.serverPort = parseInt(value);
            })
            .fontSize(12)
            .flexGrow(2)
            .width(50)
        }
        .width('100%')
        .padding(10)

        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
          Text($r('app.string.CA'))
            .fontSize(14)
            .width(90)
            .flexGrow(1)

          Button($r('app.string.Select'))
            .onClick(() => {
              this.selectCA();
            })
            .width(70)
            .fontSize(14)
            .flexGrow(0)

          Button($r('app.string.Load'))
            .onClick(() => {
              this.loadCA();
            })
            .enabled(this.canLoad)
            .width(70)
            .fontSize(14)
            .flexGrow(0)

          Button($r('app.string.Connect'))
            .onClick(() => {
              this.connect2Server();
            })
            .enabled(this.canConnect)
            .width(70)
            .fontSize(14)
            .flexGrow(0)
        }
        .width('100%')
        .padding(10)

        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
          TextArea({ text: this.ca }).onChange((value) => {
            this.ca = value;
          })
            .flexGrow(1)
            .height(200)
        }
        .width('100%')
        .padding(10)

        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
          TextInput({ placeholder: $r('app.string.Enter_The_Message_To_Send') }).onChange((value) => {
            this.sendMsg = value;
          })
            .width(200)
            .flexGrow(1)

          Button($r('app.string.Send'))
            .enabled(this.canSend)
            .width(70)
            .fontSize(14)
            .flexGrow(0)
            .onClick(() => {
              this.sendMsg2Server();
            })
        }
        .width('100%')
        .padding(10)

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

  // 发送消息到服务端
  sendMsg2Server() {
    if (!this.sendMsg.trim()) {
      return;
    }
    workerPort.postMessage({ type: 'sendMessage', message: this.sendMsg });

    workerPort.onmessage = (e: MessageEvents) => {
      const response: TlsOneWayMessage = e.data;

      if (response.type === 'sendMessageSuccess') {
        this.msgHistory += 'Me: ' + response.message + getCurrentTimeString() + '\r\n';
      } else if (response.type === 'sendMessageFailure') {
        this.msgHistory += 'Send failed: ' + response.message + '\r\n';
      }
    }
  }

  // 选择 CA 文件，并通过 worker 加载 CA 证书
  selectCA() {
    let documentPicker = new picker.DocumentViewPicker();
    documentPicker.select().then((result) => {
      if (result.length > 0) {
        caFileUri = result[0];
        this.msgHistory += 'select file: ' + caFileUri + '\r\n';
        this.canLoad = true;
      }
    }).catch((e: Error) => {
      this.msgHistory += 'DocumentViewPicker.select failed ' + e.message + '\r\n';
    });
  }

  loadCA() {
    if (!caFileUri) {
      this.msgHistory += 'Error: CA file URI is empty.\r\n';
      return;
    }

    workerPort.postMessage({ type: 'loadCA', fileUri: caFileUri });
    workerPort.onmessage = (e: MessageEvents) => {
      const response: TlsOneWayMessage = e.data; // 确保类型明确

      if (response.type === 'caLoaded' && response.caContent) {
        this.ca = response.caContent;
        this.msgHistory += 'CA file loaded successfully.\r\n';
        this.canConnect = true;
      } else if (response.type === 'error') {
        this.msgHistory += 'Error loading CA file: ' + response.message + '\r\n';
      }
    }
  }

  // 连接服务端
  connect2Server() {
    if (!this.ca) {
      this.msgHistory += 'Error: CA certificate is empty. Please load CA before connecting.\r\n';
      return;
    }
    // 服务端地址
    workerPort.postMessage({
      type: 'connectServer',
      serverIp: this.serverIp,
      serverPort: this.serverPort,
      ca: this.ca
    });
    workerPort.onmessage = (e: MessageEvents) => {
      const response: TlsOneWayMessage = e.data; // 确保类型明确

      if (response.type === 'connectSuccess') {
        this.msgHistory += 'Connected to server successfully.\r\n';
        this.canSend = true;
      } else if (response.type === 'connectFailure') {
        this.msgHistory += 'Failed to connect to server: ' + response.message + '\r\n';
      }
    };
  }
}

// 同步获取当前时间的字符串形式
function getCurrentTimeString() {
  const now = new Date();
  const hours = now.getHours().toString().padStart(2, '0');
  const minutes = now.getMinutes().toString().padStart(2, '0');
  const seconds = now.getSeconds().toString().padStart(2, '0');

  return `[${hours}:${minutes}:${seconds}]`;
}
