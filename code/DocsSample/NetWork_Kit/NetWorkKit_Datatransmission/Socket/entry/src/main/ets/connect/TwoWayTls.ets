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

// 创建 Worker 实例
const workerPort = new worker.ThreadWorker('entry/ets/workers/TwoWayTlsWorker.ets');

interface TlsTwoWayMessage {
  type: string;
  fileUri?: string; // 用于传递文件路径
  serverIp?: string; // 服务器 IP 地址
  serverPort?: number; // 服务器端口
  ca?: string; // CA 证书内容
  cert?: string; // 客户端证书内容
  privateKey?: string; // 客户端私钥内容
  message?: string; // 要发送的消息
  caContent?: string; // 从文件中读取的 CA 内容
  certContent?: string; // 从文件中读取的证书内容
  privateKeyContent?: string; // 从文件中读取的私钥内容
  content?: string; // 通用的文件加载返回内容（可选）
}

// 全局状态
let ipNum = wifiManager.getIpInfo().ipAddress;
let localIp = (ipNum >>> 24) + '.' + (ipNum >> 16 & 0xFF) + '.' + (ipNum >> 8 & 0xFF) + '.' + (ipNum & 0xFF);
let caFileUri = '';
let certFileUri = '';
let keyFileUri = '';

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
  @State cert: string = '';
  @State privateKey: string = '';
  scroller: Scroller = new Scroller();

  aboutToDisappear(): void {
    workerPort.terminate();
  }

  build() {
    Row() {
      Column() {
        Text($r('app.string.TwoWayTls'))
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .textAlign(TextAlign.Center)
          .padding(10)

        // 本地 IP 地址
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

        // 服务端 IP 和端口输入框
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
        }.width('100%')
        .padding(10)

        // 选择和加载 CA 文件
        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
          Text($r('app.string.CA_File'))
            .fontSize(14)
            .width(90)
            .flexGrow(1)
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
        }.width('100%')
        .padding(10)

        // 选择和加载客户端证书
        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
          Text($r('app.string.Client_Cert'))
            .fontSize(14)
            .width(90)
            .flexGrow(1)
          Button($r('app.string.Select'))
            .onClick(() => {
              this.selectCert();
            })
            .width(70)
            .fontSize(14)
          Button($r('app.string.Load'))
            .onClick(() => {
              this.loadCert();
            })
            .enabled(this.canLoad)
            .width(70)
            .fontSize(14)
        }.width('100%')
        .padding(10)

        // 选择和加载客户端私钥
        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
          Text($r('app.string.Client_Key'))
            .fontSize(14)
            .width(90)
            .flexGrow(1)
          Button($r('app.string.Select'))
            .onClick(() => {
              this.selectKey();
            })
            .width(70)
            .fontSize(14)
          Button($r('app.string.Load'))
            .onClick(() => {
              this.loadKey();
            })
            .enabled(this.canLoad)
            .width(70)
            .fontSize(14)
        }.width('100%')
        .padding(10)

        // 连接和输入发送消息
        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
          Button($r('app.string.Connect'))
            .onClick(() => {
              this.connect2Server();
            })
            .enabled(!!this.ca && !!this.cert && !!this.privateKey)
            .width(70)
            .fontSize(14)
        }.width('100%')
        .padding(10)

        // 发送消息输入框
        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
          TextInput({ text: this.sendMsg, placeholder: $r('app.string.Enter_Message') })
            .onChange((value) => {
              this.sendMsg = value;
            })
            .width(200)
            .fontSize(14)
            .flexGrow(1)
          Button($r('app.string.Send'))
            .enabled(this.canSend)
            .onClick(() => {
              this.sendMsg2Server();
            })
            .width(70)
            .fontSize(14)
        }.width('100%')
        .padding(10)

        // 消息展示区域
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
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
      .height('100%')
    }
    .height('100%')
  }

  // 发送消息
  sendMsg2Server() {
    if (!this.sendMsg.trim()) {
      return;
    }
    workerPort.postMessage({ type: 'sendMessage', message: this.sendMsg });
    workerPort.onmessage = (e: MessageEvents) => {
      const response: TlsTwoWayMessage = e.data;
      if (response.type === 'sendMessageSuccess') {
        this.msgHistory += `Me: ${response.message} ${getCurrentTimeString()}\r\n`;
      } else if (response.type === 'sendMessageFailure') {
        this.msgHistory += `Send fail: ${response.message}\r\n`;
      }
    }
  }

  // 选择文件：CA、证书、私钥
  selectCA() {
    this.selectFile((file: string) => {
      caFileUri = file;
      this.canLoad = true;
    })
  }

  selectCert() {
    this.selectFile((file: string) => {
      certFileUri = file;
      this.canLoad = true;
    })
  }

  selectKey() {
    this.selectFile((file: string) => {
      keyFileUri = file;
      this.canLoad = true;
    })
  }

  selectFile(callback: (file: string) => void) {
    let pickerInstance = new picker.DocumentViewPicker();
    pickerInstance.select().then((result) => {
      if (result.length > 0) {
        callback(result[0]);
      }
    }).catch((e: Error) => {
      this.msgHistory += `Select fail: ${e.message}\r\n`;
    });
  }

  checkAllFilesLoaded() {
    if (caFileUri && certFileUri && keyFileUri) {
      this.canSend = true;
    }
  }

  // 从文件加载内容
  loadCA() {
    this.loadFile(caFileUri, (content: string) => {
      this.ca = content;
    })
  }

  loadCert() {
    this.loadFile(certFileUri, (content: string) => {
      this.cert = content;
    })
  }

  loadKey() {
    this.loadFile(keyFileUri, (content: string) => {
      this.privateKey = content;
    })
  }

  // 加载文件内容并设置状态
  loadFile(fileUri: string, callback: (content: string) => void) {
    workerPort.postMessage({ type: 'loadFile', fileUri: fileUri });
    workerPort.onmessage = (e: MessageEvents) => {
      const response: TlsTwoWayMessage = e.data;
      // 根据返回的字段判断：若有 caContent、certContent 或 privateKeyContent，则调用回调
      if (response.type === 'fileLoaded') {
        if (response.caContent) {
          this.msgHistory += 'CA file loaded successfully.\r\n';
          callback(response.caContent);
        } else if (response.certContent) {
          this.msgHistory += 'CERT file loaded successfully.\r\n';
          callback(response.certContent);
        } else if (response.privateKeyContent) {
          this.msgHistory += 'KEY file loaded successfully.\r\n';
          callback(response.privateKeyContent);
        }
        this.checkAllFilesLoaded();
      } else {
        this.msgHistory += `Load file fail: ${response.message}\r\n`;
      }
    }
  }

  // 连接服务端
  connect2Server() {
    workerPort.postMessage({
      type: 'connectServer',
      serverIp: this.serverIp,
      serverPort: this.serverPort,
      ca: this.ca,
      cert: this.cert,
      privateKey: this.privateKey
    });
    workerPort.onmessage = (e: MessageEvents) => {
      const response: TlsTwoWayMessage = e.data;
      if (response.type === 'connectSuccess') {
        this.msgHistory += 'Connect success\r\n';
        this.canSend = true;
      } else if (response.type === 'connectFailure') {
        this.msgHistory += `Connect fail: ${response.message}\r\n`;
      }
    }
  }
}

// 获取当前时间的字符串
function getCurrentTimeString() {
  const now = new Date();
  return `[${now.getHours()}:${now.getMinutes()}:${now.getSeconds()}]`;
}
