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

// [Start WebSocket_case_module_import]
import { webSocket } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
// [End WebSocket_case_module_import]

const BUTTON_HEIGHT = 50; // 按钮高度
const BUTTON_RADIUS = 5; // 按钮边缘角度
const BUTTON_FONT_SIZE = 20; // 按钮字体大小
const TEXT_FONT_SIZE = 18; // 内容字体大小
const TITLE_FONT_SIZE = 20; // 标题字体大小
const MARGIN_TOP = 20; // 与顶间隔
const MARGIN_BOTTOM = 10; // 与底间隔
// [Start WebSocket_creat_websocket]
let defaultIpAddress = 'wss://echo.websocket.org'; // WebSocket地址
let ws: webSocket.WebSocket = webSocket.createWebSocket();
// [End WebSocket_creat_websocket]
export function resourceToString(resource: Resource): string {
  return getContext().resourceManager.getStringSync(resource);
}

@Entry
@Component
struct WebSocketDemo {
  @State connectionStatus: string = 'Not connected';
  @State sendMessageResult: string = '';
  @State closeConnectionResult: string = '';

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

      Text(resourceToString($r('app.string.CloseConnectionResult')) + ':' + this.closeConnectionResult)
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
    // [Start websocket_open_message_close_error_methods]
    ws.on('open', (err: BusinessError, value: Object) => {
      console.info('on open, status:' + JSON.stringify(value));
      // 当收到on('open')事件时，可以通过send()方法与服务器进行通信。
      // [StartExclude websocket_open_message_close_error_methods]
      if (!err) {
        this.connectionStatus = 'Connected';
        console.info(`WebSocket connected: ` + JSON.stringify(value));
      } else {
        this.connectionStatus = 'Connection failed';
        console.error(`WebSocket connection failed: ` + JSON.stringify(err));
      }
      // [EndExclude websocket_open_message_close_error_methods]
    });

    ws.on('message', (err: BusinessError, value: string | ArrayBuffer) => {
      // [StartExclude websocket_open_message_close_error_methods]
      if (err) {
        console.error(`Error receiving message: ` + JSON.stringify(err));
        return;
      }
      // [EndExclude websocket_open_message_close_error_methods]
      console.info('on message, message:' + value);
      // 当收到服务器的`bye`消息时（此消息字段仅为示意，具体字段需要与服务器协商），主动断开连接。
      if (value === 'bye') {
        ws!.close((err: BusinessError) => {
          if (!err) {
            // [StartExclude websocket_open_message_close_error_methods]
            this.closeConnectionResult = 'Connection closed successfully';
            this.connectionStatus = 'Not connected';
            // [EndExclude websocket_open_message_close_error_methods]
            console.info(`WebSocket closed successfully`);
          } else {
            // [StartExclude websocket_open_message_close_error_methods]
            this.closeConnectionResult = 'Connection closing failed';
            // [EndExclude websocket_open_message_close_error_methods]
            console.error(`WebSocket closing failed: ` + JSON.stringify(err));
          }
        });
      }
    })

    ws.on('close', (err: BusinessError, value: webSocket.CloseResult) => {
      console.log('on close, code is ' + value.code + ', reason is ' + value.reason);
      // [StartExclude websocket_open_message_close_error_methods]
      if (!err) {
        this.connectionStatus = 'Disconnected';
        console.info('Connection closed: code = ' + value.code + ', reason ='  + value.reason);
      } else {
        console.error('Error while closing connection: ' + JSON.stringify(err));
      }
      // [EndExclude websocket_open_message_close_error_methods]
    });

    ws.on('error', (err: BusinessError) => {
      // [StartExclude websocket_open_message_close_error_methods]
      this.connectionStatus = 'Error';
      // [EndExclude websocket_open_message_close_error_methods]
      console.error('WebSocket error: ' + JSON.stringify(err));
    });
    // [End websocket_open_message_close_error_methods]


    // [Start webSocket_case_object_connect]
    ws.connect(defaultIpAddress, (err: BusinessError, value: boolean) => {
      if (!err) {
        console.info('Connected successfully');
      } else {
        // [StartExclude webSocket_case_object_connect]
        this.connectionStatus = 'Connection failed';
        // [EndExclude webSocket_case_object_connect]
        console.error(`WebSocket connection failed: ` + JSON.stringify(err));
      }
    });
    // [End webSocket_case_object_connect]
  }

  // 发送消息
  sendMessage() {
    if (this.connectionStatus !== 'Connected') {
      this.sendMessageResult = 'WebSocket not connected';
      console.error(`WebSocket not connected`);
      return;
    }
    // [Start webSocket_case_send_message]
    ws.send('Hello, server!', (err: BusinessError, value: boolean) => {
      if (!err) {
        // [StartExclude webSocket_case_send_message]
        this.sendMessageResult = 'Message sent successfully';
        // [EndExclude webSocket_case_send_message]
        console.info('Message sent successfully');
      } else {
        // [StartExclude webSocket_case_send_message]
        this.sendMessageResult = 'Message sending failed';
        // [EndExclude webSocket_case_send_message]
        console.error(`Message sending failed: ` + JSON.stringify(err));
      }
    });
    // [End webSocket_case_send_message]
  }

  // 关闭WebSocket连接
  closeWebSocket() {
    if (this.connectionStatus !== 'Connected') {
      this.closeConnectionResult = 'WebSocket not connected';
      console.error(`WebSocket not connected`);
      return;
    }

    ws.close((err: BusinessError) => {
      if (!err) {
        this.closeConnectionResult = 'Connection closed successfully';
        this.connectionStatus = 'Not connected';
        console.info(`WebSocket closed successfully`);
      } else {
        this.closeConnectionResult = 'Connection closing failed';
        console.error(`WebSocket closing failed: ` + JSON.stringify(err));
      }
    });
    ws.off('open');
    ws.off('close');
    ws.off('error');
  }
}