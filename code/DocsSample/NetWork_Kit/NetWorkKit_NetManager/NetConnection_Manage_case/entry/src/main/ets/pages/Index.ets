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

// [Start net_Connection_create_connection_import]
import { connection, socket } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
// [End net_Connection_create_connection_import]

import { promptAction } from '@kit.ArkUI';
import connectNetworkBtn from './connectNetworkBtn';
import allNetworksBtn from './allNetworksBtn';
import defaultNetworkBtn from './defaultNetworkBtn';
import defaultNetworkIPBtn from './defaultNetworkIPBtn';
import defaultNetSyncBtn from './defaultNetSyncBtn';
import getAllNets from './getAllNets';

const NETWORK_CONNECTION_TIMEOUT = 1000; // 网络连接超时
const BUTTON_HEIGHT = 50; // 按钮的高度
const BUTTON_FONT_SIZE = 20; // 按钮的字体大小
const BUTTON_RADIUS = 5; // 按钮的圆角半径
const TEXT_FONT_SIZE = 18; // 文本的字体大小
const TEXT_MARGIN_TOP = 5; // 文本的上边距
const TEXT_MARGIN_TOP_L = 10; // 长文本的上边距

// 监控默认网络变化
async function test() {
  // [Start monitor_default_network_change]
  const netConnection = connection.createNetConnection();
  /* 监听默认网络改变 */
  netConnection.on('netAvailable', (data: connection.NetHandle) => {
    console.info(JSON.stringify(data));
  });
  // [End monitor_default_network_change]
}

// [Start original_network_connection_uses_socket]
// 创建socket对象。
let sock: socket.TCPSocket = socket.constructTCPSocketInstance();

// 原网络连接使用Socket模块建立连接
async function useSocket() {
  let netAddress: socket.NetAddress = {
    address: '192.168.xx.xxx',
    port: 8080 // 端口号，默认设置为8080
  };

  let tcpConnectOptions: socket.TCPConnectOptions = {
    address: netAddress,
    timeout: 6000 // 连接超时时间
  };

  /* 建立socket连接 */
  sock.connect(tcpConnectOptions, (err: BusinessError) => {
    if (err) {
      console.error('connect fail: '+JSON.stringify(err));
      // [StartExclude original_network_connection_uses_socket]
      promptAction.showToast({
        message: 'Connect fail!',
        duration: 4000, // 提示消息持续时间
        bottom: 300 // 提示消息与底部的距离
      });
      // [EndExclude original_network_connection_uses_socket]
      return;
    }
    console.info('connect success');

    /* 通过socket发送数据 */
    let tcpSendOptions: socket.TCPSendOptions = {
      data: 'Hello, server!'
    };
    socketSend(tcpSendOptions);
  });
}

// 通过socket发送数据。
function socketSend(tcpSendOptions: socket.TCPSendOptions) {
  sock.send(tcpSendOptions).then(() => {
    console.log('send success');
    // [StartExclude original_network_connection_uses_socket]
    promptAction.showToast({
      message: 'Connect and Send successfully!',
      duration: 4000, // 提示消息持续时间
      bottom: 300 // 提示消息与底部的距离
    });
    // [EndExclude original_network_connection_uses_socket]
  }).catch((err: BusinessError) => {
    console.error('send fail');
    // [StartExclude original_network_connection_uses_socket]
    promptAction.showToast({
      message: 'Send fail!',
      duration: 4000, // 提示消息持续时间
      bottom: 300 // 提示消息与底部的距离
    });
    // [EndExclude original_network_connection_uses_socket]
  });
}

async function socketTest() {
  const netConnection = connection.createNetConnection();
  // 网络切换会导致网络发生中断，原socket失效，故需重新建立socket。
  netConnection.on('netAvailable', async (netHandle: connection.NetHandle) => {
    console.info('default network changed123: ' + JSON.stringify(netHandle));
    await sock.close();
    sock = socket.constructTCPSocketInstance();
    // 通过socket发送数据。
    useSocket();
  });
  // [StartExclude original_network_connection_uses_socket]
  try {
    // [EndExclude original_network_connection_uses_socket]
    // 订阅指定网络状态变化的通知。
    netConnection.register((error: BusinessError) => {
      if (error) {
        console.error('register fail: ' + JSON.stringify(error));
      } else {
        console.info('register success');
      }
    });
    // [StartExclude original_network_connection_uses_socket]
    useSocket();
  } catch (e) {
    console.error(e.code.toString());
  };
  // [EndExclude original_network_connection_uses_socket]
}
// [End original_network_connection_uses_socket]

export function resourceToString(resource: Resource): string {
  return getContext().resourceManager.getStringSync(resource);
}

@Entry
@Component
struct NetworkConnectionPage {
  @State connectStatus: string = 'Not connected';
  @State disconnectStatus: string = 'Not disconnected';
  @State allNetworksStatus: string = 'Not retrieved';
  @State defaultNetworkStatus: string = 'Not retrieved';
  @State defaultNetworkIPStatus: string = 'Not retrieved';
  @State defaultNetSync: string = 'Not retrieved';
  @State getAllNetsStatus: string = 'Not retrieved';

  private conn: connection.NetConnection | null = null;

  onInit() {
    test(); // 开始监听网络变化
  }

  build() {
    Column() {
      Text($r('app.string.Network_Connection_Example'))
        .fontSize(BUTTON_FONT_SIZE)
        .margin({ bottom: TEXT_MARGIN_TOP_L })
        .id('Network_Connection_Example')

      Text(resourceToString($r('app.string.connectStatus')) + ':' + this.connectStatus)
        .fontSize(TEXT_FONT_SIZE)
        .fontColor(Color.Black)
        .margin({ top: TEXT_MARGIN_TOP })
        .id('connectStatus')

      Text(resourceToString($r('app.string.disconnectStatus')) + ':' + this.disconnectStatus)
        .fontSize(TEXT_FONT_SIZE)
        .fontColor(Color.Black)
        .margin({ top: TEXT_MARGIN_TOP })
        .id('disconnectStatus')

      Text(resourceToString($r('app.string.allNetworksStatus')) + ':' + this.allNetworksStatus)
        .fontSize(TEXT_FONT_SIZE)
        .fontColor(Color.Black)
        .margin({ top: TEXT_MARGIN_TOP })
        .id('allNetworksStatus')

      Text('查询所有网络连接信息' + ':' + this.getAllNetsStatus)
        .fontSize(TEXT_FONT_SIZE)
        .fontColor(Color.Black)
        .margin({ top: TEXT_MARGIN_TOP })
        .id('allNetworksStatus')

      Text(resourceToString($r('app.string.defaultNetworkStatus')) + ':' + this.defaultNetworkStatus)
        .fontSize(TEXT_FONT_SIZE)
        .fontColor(Color.Black)
        .margin({ top: TEXT_MARGIN_TOP })
        .id('defaultNetworkStatus')

      Text(resourceToString($r('app.string.defaultNetworkIPStatus')) + ':' + this.defaultNetworkIPStatus)
        .fontSize(TEXT_FONT_SIZE)
        .fontColor(Color.Black)
        .margin({ top: TEXT_MARGIN_TOP })
        .id('defaultNetworkIPStatus')

      Text(resourceToString($r('app.string.JudgeDefaultNetwork')) + ':' + this.defaultNetSync)
        .fontSize(TEXT_FONT_SIZE)
        .fontColor(Color.Black)
        .margin({ top: TEXT_MARGIN_TOP })
        .id('defaultNetworkIPStatus')

      // 连接断开网络
      connectNetworkBtn({connectStatus: this.connectStatus, disconnectStatus: this.disconnectStatus});

      Button($r('app.string.Reconnect_Network'))
        .onClick(() => {
          socketTest();
        })
        .width('80%')
        .height(BUTTON_HEIGHT)
        .margin({ top: TEXT_MARGIN_TOP_L })
        .fontColor(Color.White)
        .fontSize(BUTTON_FONT_SIZE)
        .borderRadius(BUTTON_RADIUS)
        .id('SocketConnect_Network')

      // 获取所有注册的网络
      allNetworksBtn({ allNetworksStatus: this.allNetworksStatus });

      // 查询所有网络连接信息
      getAllNets({ getAllNetsStatus: this.getAllNetsStatus });

      // 获取默认网络信息
      defaultNetworkBtn({ defaultNetworkStatus: this.defaultNetworkStatus })

      // 获取默认网络IP
      defaultNetworkIPBtn({ defaultNetworkIPStatus: this.defaultNetworkIPStatus })

      // 默认网络是否可以访问互联网
      defaultNetSyncBtn({ defaultNetSync: this.defaultNetSync })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}
