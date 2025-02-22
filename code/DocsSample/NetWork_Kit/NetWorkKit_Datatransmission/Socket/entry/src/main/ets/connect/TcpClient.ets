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
import Logger from '../common/Logger';

const workerPort = new worker.ThreadWorker('entry/ets/workers/TcpClientWorker.ets');

export interface TcpMessage {
  type: string;
  message?: string;
  clientIp?: string,
  clientPort?: number;
  serverIp?: string;
  serverPort?: number;
}

interface FONT_SIZE {
  SMALL: number;
  MEDIUM: number;
  LARGE: number;
}

const FONT: FONT_SIZE = {
  SMALL: 16, // 小字体大小
  MEDIUM: 20, // 中等字体大小
  LARGE: 50, // 大字体大小
};

interface MARGIN_SIZE {
  SMALL: number;
  MEDIUM: number;
  LARGE: number;
}

const MARGIN: MARGIN_SIZE = {
  SMALL: 10, // 小间隔距离
  MEDIUM: 20, // 中等间隔距离
  LARGE: 30, // 大间隔距离
};

const BUTTON_HEIGHT: number = 50; // 按钮高度

let ipNum = wifiManager.getIpInfo().ipAddress;
let clientIp = (ipNum >>> 24) + '.' + (ipNum >> 16 & 0xFF) + '.' + (ipNum >> 8 & 0xFF) + '.' + (ipNum & 0xFF);

@Entry
@Component
struct Index {
  @State message: string = ''; // 用于展示发送的消息
  @State logMessage: string = ''; // 用于展示接收到的消息
  @State clientIp: string = clientIp; // 客户端IP
  @State clientPort: number = 5555; // 客户端端口号
  @State serverIp: string = ''; // 输入的服务端IP
  @State serverPort: number = 5555; // 服务端端口号
  scroller: Scroller = new Scroller();
  // 客户端Socket对象
  @State msgHistory: string = '';

  aboutToDisappear(): void {
    workerPort.terminate();
  }

  // 构建界面
  build() {
    Column() {
      Column() {
        Row({ space: 12 }) { // Row布局使输入框水平排列
          // Server IP 输入框
          Column() {
            Text($r('app.string.Enter_Server_Ip'))
              .fontSize(FONT.MEDIUM)
              .fontColor(Color.Gray)
              .textAlign(TextAlign.Start)
              .width('100%')
            TextInput()
              .width('100%')
              .onChange((value) => {
                this.serverIp = value;
              })
          }
          .width('50%') // 控制占据的宽度，可以调整百分比

          // Server Port 输入框
          Column() {
            Text($r('app.string.Enter_Server_Port'))
              .fontSize(FONT.MEDIUM)
              .fontColor(Color.Gray)
              .textAlign(TextAlign.Start)
              .width('100%')
            TextInput()
              .width('100%')
              .onChange((value) => {
                this.serverPort = parseInt(value);
              })
          }
          .width('50%') // 控制占据的宽度，可以调整百分比
        }
        .width('80%')
        .margin({
          bottom: MARGIN.MEDIUM
        })
        .padding({
          left: MARGIN.SMALL,
          right: MARGIN.SMALL
        })
      }

      // 消息输入框
      Column() {
        Text($r('app.string.Send'))
          .fontSize(FONT.MEDIUM)
          .fontColor(Color.Gray)
          .textAlign(TextAlign.Start)
          .width('100%')
        TextInput()
          .width('100%')
          .onChange((value) => {
            this.message = value;
          })
      }
      .width('80%')
      .margin({
        bottom: MARGIN.MEDIUM
      })
      .padding({
        left: MARGIN.SMALL,
        right: MARGIN.SMALL
      })

      // 连接、关闭按钮
      Column({ space: 12 }) {
        Button($r('app.string.Connect'))
          .onClick(() => {
            this.connectToServer();
          })
          .width('80%')
          .height(BUTTON_HEIGHT)
          .fontColor(Color.White)
          .fontSize(FONT.MEDIUM)

        Button($r('app.string.Close_Connection'))
          .onClick(() => {
            this.closeConnection();
          })
          .width('80%')
          .height(BUTTON_HEIGHT)
          .fontColor(Color.White)
          .fontSize(FONT.MEDIUM)
      }

      // 展示历史消息记录
      Scroll(this.scroller) {
        Text(this.msgHistory)
          .textAlign(TextAlign.Start)
          .padding(10)
          .width('100%')
          .height('100%')
          .backgroundColor(0xeeeeee)
      }
      .width('80%')
      .height('60%')
      .margin({ top: MARGIN.SMALL })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }

  // 连接到服务端
  async connectToServer() {

    if (this.clientIp === '' || !this.clientPort || this.serverIp === '' || !this.serverPort) {
      this.msgHistory += 'Some required fields are missing.' + '\r\n';
      Logger.error('Some required fields are missing.');
      return;
    }

    let tcpMessage: TcpMessage = {
      type: 'sendMessage',
      clientIp: this.clientIp,
      clientPort: this.clientPort,
      serverIp: this.serverIp,
      serverPort: this.serverPort,
      message: this.message,
    };

    workerPort.postMessage(
      tcpMessage
    );

    workerPort.onmessage = (e: MessageEvents) => {
      const response: TcpMessage = e.data;

      if (response.type === 'sendMessageSuccess') {
        this.msgHistory += 'sendMessageSuccess' + '\r\n';
        this.msgHistory += 'Me: ' + response.message + getCurrentTimeString() + '\r\n';
      }
      if (response.type === 'sendMessageFailure') {
        this.msgHistory += 'Send failed: ' + response.message + '\r\n';
      }
    }
  }

  // 关闭连接
  closeConnection() {
    let tcpMessage: TcpMessage = {
      type: 'disConnect',
    };
    workerPort.postMessage(
      tcpMessage
    );

    workerPort.onmessage = (e: MessageEvents) => {
      const response: TcpMessage = e.data;
      if (response.type === 'Connection closed') {
        this.msgHistory += 'Connection closed.\n';
      } else if (response.type === 'Close connection failed') {
        this.msgHistory += `Close connection failed`;
      }
    }
  }
}

function getCurrentTimeString() {
  const now = new Date();
  // 如果转换后的字符串长度小于2，则在字符串前添加'0'，直到字符串长度达到2
  const hours = now.getHours().toString().padStart(2, '0');
  const minutes = now.getMinutes().toString().padStart(2, '0');
  const seconds = now.getSeconds().toString().padStart(2, '0');
  return `[${hours}:${minutes}:${seconds}]`;
}
