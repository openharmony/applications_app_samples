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
// [Start WebSocket_server_case_module_import]
import { webSocket } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
// [End WebSocket_server_case_module_import]
import { promptAction } from '@kit.ArkUI';


const BUTTON_HEIGHT = 50; // 按钮的高度
const BUTTON_FONT_SIZE = 18; // 按钮的字体大小
const BUTTON_RADIUS = 5; // 按钮的圆角半径
const TEXT_MARGIN_TOP_L = 20; // 长文本的上边距

// [Start WebSocket_server_creat_websocket]
let localServer: webSocket.WebSocketServer;
localServer = webSocket.createWebSocketServer();
// [End WebSocket_server_creat_websocket]

// [Start WebSocket_server_connections]
let connections: webSocket.WebSocketConnection[] = [];

// [StartExclude WebSocket_server_connections]
function localServerStart() {
  try{
    // [Start websocket_server_open_message_close_error_methods]
    localServer.on('connect', async (connection: webSocket.WebSocketConnection) => {
      hilog.info(0x0000, 'testTag', `New client connected! Client ip: ${connection.clientIP}, Client port: ${connection.clientPort}`);
      // 当收到on('connect')事件时，可以通过send()方法与客户端进行通信。
      localServer.send("Hello, I'm server!", connection).then((success: boolean) => {
        if (success) {
          hilog.info(0x0000, 'testTag', 'message send successfully');
        } else {
          hilog.error(0x0000, 'testTag', 'message send failed');
        }
      }).catch((error: BusinessError) => {
        hilog.error(0x0000, 'testTag', `message send failed, Code: ${error.code}, message: ${error.message}`);
      });
    });

    localServer.on('messageReceive', (message: webSocket.WebSocketMessage) => {
      try{
        hilog.info(0x0000, 'testTag', `on message received, client: ${message.clientConnection}, data: ${message.data}`);
        // 当收到客户端的"bye"消息时（此消息字段仅为示意，具体字段需要与客户端协商），主动断开连接。
        if (message.data === 'bye') {
          localServer.close(message.clientConnection).then((success: boolean) => {
            if (success) {
              hilog.info(0x0000, 'testTag', 'close client successfully');
            } else {
              hilog.error(0x0000, 'testTag', 'close client failed');
            }
          });
        }
      } catch (error) {
        hilog.error(0x0000, 'testTag', `on messageReceive failed. Code: ${error.code}, message: ${error.message}`);
      }
    });

    localServer.on('close', (clientConnection: webSocket.WebSocketConnection, closeReason: webSocket.CloseResult) => {
      hilog.info(0x0000, 'testTag', `client close, client: ${clientConnection}, closeReason: Code: ${closeReason.code}, reason: ${closeReason.reason}`);
    });

    localServer.on('error', (error: BusinessError) => {
      hilog.error(0x0000, 'testTag', `error. Code: ${error.code}, message: ${error.message}`);
    });
    // [End websocket_server_open_message_close_error_methods]

    // [Start websocket_server_config]
    let config: webSocket.WebSocketServerConfig = {
      // 监听端口。
      serverPort: 8080,
      maxConcurrentClientsNumber: 10,
      maxConnectionsForOneClient: 10,
    }
    localServer.start(config).then((success: boolean) => {
      if (success) {
        hilog.info(0x0000, 'testTag', 'WebSocket server started successfully');
      } else {
        hilog.error(0x0000, 'testTag', 'Failed to start WebSocket server');
      }
    }).catch((error: BusinessError) => {
      hilog.error(0x0000, 'testTag', `Failed to start. Code: ${error.code}, message: ${error.message}`);
    });
    // [End websocket_server_config]

  } catch (err) {
    hilog.error(0x0000, 'testTag', 'errCode: ' + err.code + ',errMessage: ' + err.message);
    promptAction.showToast({
      message: 'errCode: ' + err.code + ',errMessage: ' + err.message,
      duration: 4000, // 持续时间
      bottom: 300 // 与底间隔
    });
  }
}

async function allClientMessage() {
  // [EndExclude WebSocket_server_connections]
  try{
    connections = await localServer.listAllConnections();
    if (connections.length === 0) {
      hilog.info(0x0000, 'testTag', 'client list is empty');
      // [StartExclude WebSocket_server_connections]
      promptAction.showToast({
        message: 'client list is empty',
        duration: 4000, // 持续时间
        bottom: 300 // 与底间隔
      });
      // [EndExclude WebSocket_server_connections]
    } else {
      hilog.info(0x0000, 'testTag', `client list cnt: ${connections.length}, client connections list is: ${connections}`);
    }
  } catch (error) {
    hilog.error(0x0000, 'testTag', `Failed to listAllConnections. Code: ${error.code}, message: ${error.message}`);
    // [StartExclude WebSocket_server_connections]
    promptAction.showToast({
      message: `Failed to listAllConnections. Code: ${error.code}, message: ${error.message}`,
      duration: 4000, // 持续时间
      bottom: 300 // 与底间隔
    });
    // [EndExclude WebSocket_server_connections]
  }
  // [End WebSocket_server_connections]
}

async function localServerClose() {
  if (!localServer) {
    hilog.info(0x0000, 'testTag', 'localServer is nullptr');
    return;
  }
  try{
    connections = await localServer!.listAllConnections();
    if(connections.length === 0){
      hilog.info(0x0000, 'testTag', 'client list is empty');
      return
    }
    hilog.info(0x0000, 'testTag', 'all client connections are:' + JSON.stringify(connections));
    // 指定某个客户端来断开连接，本示例以第一个客户端为例。
    const firstClient = connections[0];
    hilog.info(0x0000, 'testTag', 'close client connections is:' + JSON.stringify(firstClient));
    localServer.close(firstClient).then((success) => {
      if(success){
        hilog.info(0x0000, 'testTag', 'close client connections success');
        promptAction.showToast({
          message: 'close client connections success',
          duration: 4000, // 持续时间
          bottom: 300 // 与底间隔
        });
      } else {
        hilog.error(0x0000, 'testTag', 'close client connections fail');
      }
    })
  } catch (err) {
    hilog.error(0x0000, 'testTag', 'errCode: ' + err.code + 'errMessage: ' + err.message);
    promptAction.showToast({
      message: 'errCode: ' + err.code + 'errMessage: ' + err.message,
      duration: 4000, // 持续时间
      bottom: 300 // 与底间隔
    });
  }
}

function localServerStop() {
  try{
    // [Start WebSocket_server_stop]
    localServer.stop().then((success: boolean) => {
      if (success) {
        hilog.info(0x0000, 'testTag', 'server stop service successfully');
        // [StartExclude WebSocket_server_stop]
        promptAction.showToast({
          message: 'server stop service successfully',
          duration: 4000, // 持续时间
          bottom: 300 // 与底间隔
        });
        // [EndExclude WebSocket_server_stop]
      } else {
        hilog.error(0x0000, 'testTag', 'server stop service failed');
        // [StartExclude WebSocket_server_stop]
        promptAction.showToast({
          message: 'server stop service failed',
          duration: 4000, // 持续时间
          bottom: 300 // 与底间隔
        });
        // [EndExclude WebSocket_server_stop]
      }
    });
    // [End WebSocket_server_stop]
  } catch (err) {
    hilog.error(0x0000, 'testTag', 'errCode: ' + err.code + 'errMessage: ' + err.message);
    promptAction.showToast({
      message: 'errCode: ' + err.code + 'errMessage: ' + err.message,
      duration: 4000, // 持续时间
      bottom: 300 // 与底间隔
    });
  }
}

@Entry
@Component
struct Index {
  build() {
    Column() {

      Button('启动服务、监听连接并发送消息')
        .onClick(() => {
          localServerStart();
        })
        .width('85%')
        .height(BUTTON_HEIGHT)
        .margin({ top: TEXT_MARGIN_TOP_L })
        .fontColor(Color.White)
        .fontSize(BUTTON_FONT_SIZE)
        .borderRadius(BUTTON_RADIUS)

      Button('所有已连接的客户端信息')
        .onClick(() => {
          allClientMessage();
        })
        .width('85%')
        .height(BUTTON_HEIGHT)
        .margin({ top: TEXT_MARGIN_TOP_L })
        .fontColor(Color.White)
        .fontSize(BUTTON_FONT_SIZE)
        .borderRadius(BUTTON_RADIUS)

      Button('关闭指定连接')
        .onClick(() => {
          localServerClose();
        })
        .width('85%')
        .height(BUTTON_HEIGHT)
        .margin({ top: TEXT_MARGIN_TOP_L })
        .fontColor(Color.White)
        .fontSize(BUTTON_FONT_SIZE)
        .borderRadius(BUTTON_RADIUS)

      Button('停止服务')
        .onClick(() => {
          localServerStop();
        })
        .width('85%')
        .height(BUTTON_HEIGHT)
        .margin({ top: TEXT_MARGIN_TOP_L })
        .fontColor(Color.White)
        .fontSize(BUTTON_FONT_SIZE)
        .borderRadius(BUTTON_RADIUS)
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }
}