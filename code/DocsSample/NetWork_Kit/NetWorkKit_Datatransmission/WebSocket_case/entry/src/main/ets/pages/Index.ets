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

import { webSocket } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import Logger from '../common/Logger';

const LOG_TAG = '[Sample_WebSocketDemo]';
const DEFAULT_IP_ADDRESS = 'wss://echo.websocket.org'; // WebSocket地址
const BUTTON_HEIGHT = 50; // 按钮高度
const BUTTON_RADIUS = 5; // 按钮边缘角度
const BUTTON_FONT_SIZE = 20; // 按钮字体大小
const TEXT_FONT_SIZE = 18; // 内容字体大小
const TITLE_FONT_SIZE = 20; // 标题字体大小
const MARGIN_TOP = 20; // 与顶间隔
const MARGIN_BOTTOM = 10; // 与底间隔

export function resourceToString(resource: Resource): string {
  return getContext().resourceManager.getStringSync(resource);
}

@Entry
@Component
struct WebSocketDemo {
  @State connectionStatus: string = 'Not connected';
  @State sendMessageResult: string = '';
  @State closeConnectionResult: string = '';
  @State isConnect: Boolean = false;
  ws: webSocket.WebSocket | null = null;

  build() {
    Column() {
      Text($r('app.string.WebSocket_Example')).fontSize(TITLE_FONT_SIZE).margin({ bottom: MARGIN_BOTTOM })

      Text(resourceToString($r('app.string.ConnectStatus')) + ':' + this.connectionStatus)
        .fontSize(TEXT_FONT_SIZE)
        .fontColor(Color.Black)
        .margin({ top: MARGIN_TOP })
        .id('connectionStatus')

      Text(resourceToString($r('app.string.SendMessageResult')) + ':' + this.sendMessageResult)
        .fontSize(TEXT_FONT_SIZE)
        .fontColor(Color.Black)
        .margin({ top: MARGIN_TOP })
        .id('sendMessageResult')

      Text(resourceToString($r('app.string.CloseConnectionResult')) + '' + this.closeConnectionResult)
        .fontSize(TEXT_FONT_SIZE)
        .fontColor(Color.Black)
        .margin({ top: MARGIN_TOP })
        .id('closeConnection')

      Button($r('app.string.Connect_WebSocket'))
        .onClick(() => {
          this.connectWebSocket();
        })
        .width('80%')
        .height(BUTTON_HEIGHT)
        .margin({ top: MARGIN_TOP })
        .backgroundColor(Color.Blue)
        .fontColor(Color.White)
        .fontSize(BUTTON_FONT_SIZE)
        .borderRadius(BUTTON_RADIUS)
        .id('Connect_WebSocket')

      Button($r('app.string.SendMessage'))
        .onClick(() => {
          this.sendMessage();
        })
        .width('80%')
        .height(BUTTON_HEIGHT)
        .margin({ top: MARGIN_TOP })
        .backgroundColor(Color.Green)
        .fontColor(Color.White)
        .fontSize(BUTTON_FONT_SIZE)
        .borderRadius(BUTTON_RADIUS)
        .id('SendMessage')

      Button($r('app.string.DisConnect'))
        .onClick(() => {
          this.closeWebSocket();
        })
        .width('80%')
        .height(BUTTON_HEIGHT)
        .margin({ top: MARGIN_TOP })
        .backgroundColor(Color.Red)
        .fontColor(Color.White)
        .fontSize(BUTTON_FONT_SIZE)
        .borderRadius(BUTTON_RADIUS)
        .id('DisConnect')
    }.width('100%').height('100%').justifyContent(FlexAlign.Center)
  }

  // 连接WebSocket
  connectWebSocket() {
    this.connectionStatus = 'Connecting...';
    this.sendMessageResult = '';
    this.closeConnectionResult = '';
    if (this.isConnect) {
      this.connectionStatus = 'WebSocket is already connected';
      return;
    }

    this.ws = webSocket.createWebSocket();

    this.ws.on('open', (err: BusinessError, value: Object) => {
      if (!err) {
        this.connectionStatus = 'Connected';
        this.isConnect = true;
        Logger.info(`${LOG_TAG} WebSocket connected: ` + JSON.stringify(value));
      } else {
        this.connectionStatus = 'Connection failed';
        Logger.error(`${LOG_TAG} WebSocket connection failed: ` + JSON.stringify(err));
      }
    });

    this.ws.on('message', (err: BusinessError, value: string | ArrayBuffer) => {
      if (err) {
        Logger.error(`${LOG_TAG} Error receiving message: ` + JSON.stringify(err));
        return;
      }
      Logger.info('Received message: ' + value);

      if (value === 'bye') {
        this.ws!.close((err: BusinessError) => {
          if (!err) {
            this.closeConnectionResult = 'Connection closed successfully';
            this.connectionStatus = 'Not connected';
            Logger.info(`${LOG_TAG} WebSocket closed successfully`);
          } else {
            this.closeConnectionResult = 'Connection closing failed';
            Logger.error(`${LOG_TAG} WebSocket closing failed: ` + JSON.stringify(err));
          }
        });
      }
    })

    this.ws.on('close', (err: BusinessError, value: webSocket.CloseResult) => {
      if (!err) {
        this.connectionStatus = 'Disconnected';
        Logger.info('Connection closed: code = ' + value.code + ', reason ='  + value.reason);
        this.ws = null;
      } else {
        Logger.error('Error while closing connection: ' + JSON.stringify(err));
      }
    });

    this.ws.on('error', (err: BusinessError) => {
      this.connectionStatus = 'Error';
      Logger.error('WebSocket error: ' + JSON.stringify(err));
    });

    this.ws.connect(DEFAULT_IP_ADDRESS, (err: BusinessError) => {
      if (!err) {
      } else {
        this.connectionStatus = 'Connection failed';
        Logger.error(`${LOG_TAG} WebSocket connection failed: ` + JSON.stringify(err));
      }
    });
  }

  // 发送消息
  sendMessage() {
    if (!this.ws) {
      this.sendMessageResult = 'WebSocket not connected';
      Logger.error(`${LOG_TAG} WebSocket not connected`);
      return;
    }

    const message = 'Hello, WebSocket!';
    this.ws.send(message, (err: BusinessError) => {
      if (!err) {
        this.sendMessageResult = 'Message sent successfully';
        Logger.info(`${LOG_TAG} Message sent successfully: ${message}`);
      } else {
        this.sendMessageResult = 'Message sending failed';
        Logger.error(`${LOG_TAG} Message sending failed: ` + JSON.stringify(err));
      }
    });
  }

  // 关闭WebSocket连接
  closeWebSocket() {
    if (!this.ws) {
      this.closeConnectionResult = 'WebSocket not connected';
      Logger.error(`${LOG_TAG} WebSocket not connected`);
      return;
    }

    this.ws.close((err: BusinessError) => {
      if (!err) {
        this.closeConnectionResult = 'Connection closed successfully';
        this.connectionStatus = 'Not connected';
        Logger.info(`${LOG_TAG} WebSocket closed successfully`);
      } else {
        this.closeConnectionResult = 'Connection closing failed';
        Logger.error(`${LOG_TAG} WebSocket closing failed: ` + JSON.stringify(err));
      }
    });
    this.ws.off('open');
    this.ws.off('close');
    this.ws.off('error');
    this.ws = null;
  }
}
