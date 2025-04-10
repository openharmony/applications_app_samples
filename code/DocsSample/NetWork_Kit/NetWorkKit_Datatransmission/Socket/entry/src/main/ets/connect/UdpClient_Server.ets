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
import Logger from '../common/Logger';
import { TcpMessage } from './TcpClient';

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

const workerPort = new worker.ThreadWorker('entry/ets/workers/UdpWorker.ets'); // 初始化 Worker

@Entry
@Component
struct Index {
  @State message: string = ''; // 用于展示发送的消息
  @State serverIp: string = ''; // 服务端IP地址
  @State clientIp: string = ''; // 客户端IP地址
  @State serverPort: number = 5555; // 服务端端口号
  @State clientPort: number = 5555; // 客户端端口号
  @State msgHistory: string = ''; // 消息记录
  @State connectionStatus: string = ''; // 连接状态
  scroller: Scroller = new Scroller();

  aboutToDisappear(): void {
    workerPort.terminate();
  }

  // 构建界面
  build() {
    Column() {
      // 服务端IP和端口放在一行
      Row() {
        Column() {
          Text($r('app.string.Enter_Server_Ip'))
            .fontSize(FONT.MEDIUM)
            .fontColor(Color.Gray)
            .textAlign(TextAlign.Start)
            .margin({ right: MARGIN.MEDIUM })
          TextInput()
            .width('100%')
            .onChange((value) => {
              this.serverIp = value; // 更新serverIp的值
            })
        }
        .width('50%')

        Column() {
          Text($r('app.string.Enter_Server_Port'))
            .fontSize(FONT.MEDIUM)
            .fontColor(Color.Gray)
            .textAlign(TextAlign.Start)
          TextInput()
            .width('100%')
            .onChange((value) => {
              this.serverPort = parseInt(value, 10); // 更新serverPort的值
            })
        }
        .width('50%')
      }
      .width('80%')
      .margin({ bottom: MARGIN.MEDIUM })

      Row() {
        // 客户端IP和端口放在一行
        Column() {
          Text($r('app.string.Enter_Client_Ip'))
            .fontSize(FONT.MEDIUM)
            .fontColor(Color.Gray)
            .textAlign(TextAlign.Start)
            .margin({ right: MARGIN.MEDIUM })
          TextInput()
            .width('100%')
            .onChange((value) => {
              this.clientIp = value; // 更新serverIp的值
            })
        }
        .width('50%')

        Column() {
          Text($r('app.string.Enter_Client_Port'))
            .fontSize(FONT.MEDIUM)
            .fontColor(Color.Gray)
            .textAlign(TextAlign.Start)
          TextInput()
            .width('100%')
            .onChange((value) => {
              this.clientPort = parseInt(value, 10); // 更新serverPort的值
            })
        }
        .width('50%')
      }
      .width('80%')
      .margin({ bottom: MARGIN.MEDIUM })

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
        .height(200) // 消息记录区域高度
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
      this.msgHistory += 'Some required fields are missing.\n';
      Logger.error('Some required fields are missing.');
      return;
    }

    let tcpMessage: TcpMessage = {
      type: 'startServer',
      serverIp: this.serverIp,
      serverPort: this.serverPort,
    };

    workerPort.postMessage(tcpMessage);

    workerPort.onmessage = (e: MessageEvents) => {
      const response: TcpMessage = e.data;

      if (response.type === 'listen success') {
        this.msgHistory += 'Server listening success.\n';
      }
      if (response.type === 'received message--') {
        this.msgHistory += `Received message: ${response.message}\n`;
      } else if (response.type === 'listen fail') {
        this.msgHistory += 'Listen fail.\n';
      }
    }
  }

  // 发送消息
  sendMessage() {
    if (!this.message || !this.clientIp || !this.clientPort) {
      this.msgHistory += 'Some required fields are missing.\n';
      Logger.error('Some required fields are missing.');
      return;
    }

    let tcpMessage: TcpMessage = {
      type: 'sendMessage',
      message: this.message,
      clientIp: this.clientIp, // 使用用户输入的clientIp
      clientPort: this.clientPort, // 假设客户端端口为默认值
    };

    workerPort.postMessage(tcpMessage);

    workerPort.onmessage = (e: MessageEvents) => {
      const response: TcpMessage = e.data;
      if (response.type === 'send success') {
        this.msgHistory += `Sent: ${this.message}\n`;
      } else if (response.type === 'send fail') {
        this.msgHistory += `Send failed: ${response.message}\n`;
      }
    }
  }

  // 关闭连接
  closeConnection() {
    let tcpMessage: TcpMessage = {
      type: 'disConnect'
    };

    workerPort.postMessage(tcpMessage);

    workerPort.onmessage = (e: MessageEvents) => {
      const response: TcpMessage = e.data;

      if (response.type === 'close success') {
        this.msgHistory += `Connection closed.\n`;
      } else if (response.type === 'close fail') {
        this.msgHistory += `Close failed\n`;
      }
    }
  }
}
