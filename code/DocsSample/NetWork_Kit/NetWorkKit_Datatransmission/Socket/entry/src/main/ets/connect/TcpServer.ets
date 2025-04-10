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

import { TcpMessage } from './TcpClient';
import { MessageEvents, worker } from '@kit.ArkTS';
import Logger from '../common/Logger';

const workerPort = new worker.ThreadWorker('entry/ets/workers/TcpServerWorker.ets');

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

@Entry
@Component
struct Index {
  @State message: string = ''; // 用于展示发送的消息
  @State logMessage: string = ''; // 用于展示接收到的消息
  @State serverIp: string = ''; // 服务端IP地址，默认值
  @State serverPort: number = 5555; // 服务端端口，默认值
  @State connectionStatus: string = ''; // 显示连接状态
  scroller: Scroller = new Scroller();
  // 消息记录
  @State msgHistory: string = '';

  aboutToDisappear(): void {
    workerPort.terminate();
  }

  // 构建界面
  build() {
    Column() {
      // 显示服务端IP地址的输入框
      Column() {
        Text($r('app.string.Enter_Server_Ip'))
          .fontSize(FONT.MEDIUM)
          .fontColor(Color.Gray)
          .textAlign(TextAlign.Start)
          .margin({ bottom: MARGIN.MEDIUM });
        TextInput()
          .width('80%')
          .onChange((value) => {
            this.serverIp = value;
          })
      }
      .margin({ bottom: MARGIN.MEDIUM })
      .padding({
        left: MARGIN.SMALL,
        right: MARGIN.SMALL
      })

      // 显示服务端Port的输入框
      Column() {
        Text($r('app.string.Enter_Server_Port'))
          .fontSize(FONT.MEDIUM)
          .fontColor(Color.Gray)
          .textAlign(TextAlign.Start)
          .margin({ bottom: MARGIN.MEDIUM });
        TextInput()
          .width('80%')
          .onChange((value) => {
            this.serverPort = parseInt(value);
          })
      }
      .margin({ bottom: MARGIN.MEDIUM })
      .padding({
        left: MARGIN.SMALL,
        right: MARGIN.SMALL
      })

      // 启动服务器按钮
      Button($r('app.string.Start_Server'))
        .onClick(() => {
          this.startServer();
        })
        .margin({ bottom: MARGIN.SMALL })
        .width('80%')
        .height(BUTTON_HEIGHT)
        .fontColor(Color.White)
        .fontSize(FONT.MEDIUM)

      // 发送消息按钮
      Button($r('app.string.Send'))
        .onClick(() => {
          this.sendMessage();
        })
        .margin({ bottom: MARGIN.SMALL })
        .width('80%')
        .height(BUTTON_HEIGHT)
        .fontColor(Color.White)
        .fontSize(FONT.MEDIUM)

      // 关闭连接按钮
      Button($r('app.string.Close_Connection'))
        .onClick(() => {
          this.closeConnection();
        })
        .margin({ bottom: MARGIN.SMALL })
        .width('80%')
        .height(BUTTON_HEIGHT)
        .fontColor(Color.White)
        .fontSize(FONT.MEDIUM)

      // 显示连接状态
      Text(this.connectionStatus)
        .fontSize(FONT.SMALL)
        .fontColor(Color.Green)
        .margin({ top: MARGIN.SMALL })

      // 输入消息框
      Column() {
        Text($r('app.string.Enter_Message'))
          .fontSize(FONT.MEDIUM)
          .fontColor(Color.Gray)
          .margin({ bottom: MARGIN.SMALL })
        TextInput()
          .width('80%')
          .onChange((value) => {
            this.message = value;
          })
      }
      .margin({ top: MARGIN.MEDIUM })

      // 消息记录框
      Column() {
        Text($r('app.string.Message_History'))
          .fontSize(FONT.MEDIUM)
          .fontColor(Color.Gray)
          .margin({ bottom: MARGIN.SMALL })
        Scroll(this.scroller) {
          Text(this.msgHistory)
            .textAlign(TextAlign.Start)
            .padding(10)
            .width('100%')
            .height('100%')
            .backgroundColor(0xeeeeee)
        }
        .width('80%')
        .height(200) // 消息记录区域
        .margin({ top: MARGIN.SMALL })
      }
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }

  // 启动服务器
  startServer() {
    if (!this.serverIp || !this.serverPort) {
      Logger.error('Some required fields are missing.');
      this.msgHistory += 'Some required fields are missing.' + '\r\n';
      return;
    }

    let tcpMessage: TcpMessage = {
      type: 'startServer',
      serverIp: this.serverIp,
      serverPort: this.serverPort,
      message: this.message,
    };

    Logger.info(tcpMessage.serverIp! + tcpMessage.serverPort);
    workerPort.postMessage(
      tcpMessage
    );

    workerPort.onmessage = (e: MessageEvents) => {
      const response: TcpMessage = e.data;

      if (response.type === 'listen success') {
        this.msgHistory += 'listen success' + getCurrentTimeString() + '\r\n';
      }
      if (response.type === 'client connected') {
        this.msgHistory += 'client connected' + getCurrentTimeString() + '\r\n';
      }
      if (response.type === 'client on close success') {
        this.msgHistory += 'Client disconnected\n';
      }
      if (response.type === 'received message--') {
        this.msgHistory += `Received message: ${response.message}` + getCurrentTimeString() + '\r\n';
      } else if (response.type === 'listen fail') {
        this.msgHistory += 'listen fail' + '\r\n';
      }
    }
  }

  // 发送消息到服务端
  sendMessage() {
    if (!this.message) {
      Logger.error('Some required fields are missing.');
      this.msgHistory += 'Some required fields are missing.' + '\r\n';
      return;
    }

    let tcpMessage: TcpMessage = {
      type: 'sendMessage',
      message: this.message,
    };

    workerPort.postMessage(
      tcpMessage
    );

    workerPort.onmessage = (e: MessageEvents) => {
      const response: TcpMessage = e.data;

      if (response.type === 'send success') {
        this.msgHistory += `Sent: ${this.message}\n`;
      }
      if (response.type === 'send fail') {
        this.msgHistory += `Send failed: ` + response.message;
      } else if (response.type === 'No client connected') {
        this.msgHistory += 'No client connected\n';
      }
    }
  }

  // 关闭连接
  closeConnection() {
    let tcpMessage: TcpMessage = {
      type: 'disConnect'
    };

    workerPort.postMessage(
      tcpMessage
    );

    workerPort.onmessage = (e: MessageEvents) => {
      const response: TcpMessage = e.data;

      if (response.type === 'close success') {
        this.msgHistory += `close success`;
      }
      if (response.type === 'close fail') {
        this.msgHistory += 'Close failed:' + response.message;
      } else if (response.type === 'No client to close') {
        this.msgHistory += 'No client to close\n';
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
