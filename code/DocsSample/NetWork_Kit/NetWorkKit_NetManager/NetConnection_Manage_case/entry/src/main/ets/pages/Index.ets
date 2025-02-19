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

import { connection, socket } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import Logger from '../common/Logger';
import { promptAction } from '@kit.ArkUI';

const NETWORK_CONNECTION_TIMEOUT = 1000; // 网络连接超时
const BUTTON_HEIGHT = 50; // 按钮的高度
const BUTTON_FONT_SIZE = 20; // 按钮的字体大小
const BUTTON_RADIUS = 5; // 按钮的圆角半径
const TEXT_FONT_SIZE = 18; // 文本的字体大小
const TEXT_MARGIN_TOP = 10; // 文本的上边距
const TEXT_MARGIN_TOP_L = 20; // 长文本的上边距

let sock: socket.TCPSocket = socket.constructTCPSocketInstance();

let netAddress: socket.NetAddress = {
  address: '',
  port: 8080 // 端口号，默认设置为8080
};

// 监控默认网络变化
async function test() {
  const netConnection = connection.createNetConnection();
  /* 监听默认网络改变 */
  netConnection.on('netAvailable', (data: connection.NetHandle) => {
    Logger.info(JSON.stringify(data));
  });
}

// 原网络连接使用Socket模块建立连接
async function useSocket() {
  let tcpConnectOptions: socket.TCPConnectOptions = {
    address: netAddress,
    timeout: 6000 // 连接超时时间
  };

  /* 建立socket连接 */
  sock.connect(tcpConnectOptions, (err: BusinessError) => {
    if (err) {
      Logger.error('connect fail');
      promptAction.showToast({
        message: 'Connect fail!',
        duration: 4000, // 提示消息持续时间
        bottom: 300 // 提示消息与底部的距离
      });
      return;
    }
    Logger.info('connect success');

    /* 通过socket发送数据 */
    let tcpSendOptions: socket.TCPSendOptions = {
      data: 'Hello, server!'
    };
    sock.send(tcpSendOptions).then(() => {
      Logger.info('send success');
      promptAction.showToast({
        message: 'Connect and Send successfully!',
        duration: 4000, // 提示消息持续时间
        bottom: 300 // 提示消息与底部的距离
      });
    }).catch((err: BusinessError) => {
      Logger.error('send fail');
      promptAction.showToast({
        message: 'Send fail!',
        duration: 4000, // 提示消息持续时间
        bottom: 300 // 提示消息与底部的距离
      });
    });
  });
}

async function socketTest() {
  const netConnection = connection.createNetConnection();
  netConnection.on('netAvailable', async (netHandle: connection.NetHandle) => {
    Logger.info('default network changed');
    await sock.close();
    sock = socket.constructTCPSocketInstance();
    useSocket();
  });
  try {
    netConnection.register(() => {
    });
    useSocket();
  } catch (e) {
    Logger.error(e.code.toString());
  };
}

// 构造单例对象
export class GlobalContext {
  private static instance: GlobalContext;
  public netList: connection.NetHandle[] = [];
  public netHandle: connection.NetHandle | null = null;
  private _objects = new Map<string, Object>();

  private constructor() {
  }

  public static getContext(): GlobalContext {
    if (!GlobalContext.instance) {
      GlobalContext.instance = new GlobalContext();
    }
    return GlobalContext.instance;
  }

  getObject(value: string): Object | undefined {
    return this._objects.get(value);
  }

  setObject(key: string, objectClass: Object): void {
    this._objects.set(key, objectClass);
  }
}

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

      Button($r('app.string.Connect_Network'))
        .onClick(() => {
          this.connectNetwork();
        })
        .width('80%')
        .height(BUTTON_HEIGHT)
        .margin({ top: TEXT_MARGIN_TOP_L })
        .fontColor(Color.White)
        .fontSize(BUTTON_FONT_SIZE)
        .borderRadius(BUTTON_RADIUS)
        .id('Connect_Network')

      Button($r('app.string.Disconnect_Network'))
        .onClick(() => {
          this.disconnectNetwork();
        })
        .width('80%')
        .height(BUTTON_HEIGHT)
        .margin({ top: TEXT_MARGIN_TOP_L })
        .fontColor(Color.White)
        .fontSize(BUTTON_FONT_SIZE)
        .borderRadius(BUTTON_RADIUS)
        .id('Disconnect_Network')

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

      Button($r('app.string.Get_Connected_Network'))
        .onClick(() => {
          this.getAllNetworks();
        })
        .width('80%')
        .height(BUTTON_HEIGHT)
        .margin({ top: TEXT_MARGIN_TOP_L })
        .fontColor(Color.White)
        .fontSize(BUTTON_FONT_SIZE)
        .borderRadius(BUTTON_RADIUS)
        .id('Get_Connected_Network')

      Button($r('app.string.Get_Default_Network'))
        .onClick(() => {
          this.getDefaultNetwork();
        })
        .width('80%')
        .height(BUTTON_HEIGHT)
        .margin({ top: TEXT_MARGIN_TOP_L })
        .fontColor(Color.White)
        .fontSize(BUTTON_FONT_SIZE)
        .borderRadius(BUTTON_RADIUS)
        .id('Get_Default_Network')

      Button($r('app.string.Get_Default_Network_IP'))
        .onClick(() => {
          this.getDefaultNetworkIP();
        })
        .width('80%')
        .height(BUTTON_HEIGHT)
        .margin({ top: TEXT_MARGIN_TOP_L })
        .fontColor(Color.White)
        .fontSize(BUTTON_FONT_SIZE)
        .borderRadius(BUTTON_RADIUS)
        .id('Get_Default_Network_IP')
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }

  // 连接并接收指定网络的状态变化通知
  connectNetwork() {
    if (this.conn) {
      Logger.info('Network connection already established.');
      return; // 如果已有连接，直接返回
    };

    let netSpecifier: connection.NetSpecifier = {
      netCapabilities: {
        // 假设当前默认网络是蜂窝网络连接，需要创建WIFI网络连接，可指定网络类型为WIFI
        bearerTypes: [connection.NetBearType.BEARER_WIFI],
        // 指定网络能力为Internet
        networkCap: [connection.NetCap.NET_CAPABILITY_INTERNET],
      }
    };

    // 指定超时时间为10s(默认值为0)
    let TIMEOUT = 10 * NETWORK_CONNECTION_TIMEOUT;

    // 创建NetConnection对象
    this.conn = connection.createNetConnection(netSpecifier, TIMEOUT);

    // 订阅连接状态变化
    this.conn.register((err: BusinessError, data: void) => {
      if (err) {
        Logger.error('Error occurred during connection:', JSON.stringify(err));
        this.connectStatus = 'Connection failed';
        return;
      }
    });

    // 订阅事件，如果当前指定网络可用，通过on_netAvailable通知用户
    this.conn.on('netAvailable', (data: connection.NetHandle) => {
      Logger.info('Network available, NetId is ' + data.netId);
      this.connectStatus = `Network available, NetId: ${data.netId}`;
    });

    // 订阅事件，如果当前指定网络不可用，通过on_netUnavailable通知用户
    this.conn.on('netUnavailable', (data: void) => {
      Logger.info('Network unavailable, data is ' + JSON.stringify(data));
      this.connectStatus = 'Network unavailable';
    });

    Logger.info('Network connection attempt started');
  }

  // 当不使用该网络时，可以调用该对象的unregister()方法，取消订阅
  disconnectNetwork() {
    if (this.conn) {
      this.conn.unregister((err: BusinessError, data: void) => {
        if (err) {
          Logger.error('Error occurred during unsubscription:', JSON.stringify(err));
        }
      });
      this.conn = null;
      this.disconnectStatus = 'Network disconnected';
      Logger.info('Network connection disconnected.');
    } else {
      Logger.info('No active network connection.');
    }
  }

  // 获取所有注册的网络
  getAllNetworks() {
    // 调用getAllNets,获取所有处于连接状态的网络列表(Array<NetHandle>)
    connection.getAllNets().then((data: connection.NetHandle[]) => {
      Logger.info('getAllNets get data: ' + JSON.stringify(data));
      if (data) {
        this.allNetworksStatus = 'Retrieved successfully';
        GlobalContext.getContext().netList = data;

        let itemNumber: Set<connection.NetHandle> = new Set(GlobalContext.getContext().netList);
        let dataNumber = Array.from(itemNumber.values());
        for (let item of dataNumber) {
          // 循环获取网络列表每个netHandle对应网络的能力信息
          connection.getNetCapabilities(item).then((data: connection.NetCapabilities) => {
            Logger.info('getNetCapabilities get data: ' + JSON.stringify(data));
          });

          // 循环获取网络列表每个netHandle对应的网络的连接信息
          connection.getConnectionProperties(item).then((data: connection.ConnectionProperties) => {
            Logger.info('getConnectionProperties get data: ' + JSON.stringify(data));
          });
        }
      }
    });
  }

  // 根据数据网络查询网络的能力信息及连接信息
  getDefaultNetwork() {
    // 调用getDefaultNet方法，获取默认的数据网络(NetHandle)
    connection.getDefaultNet().then((data: connection.NetHandle) => {
      if (data.netId == 0) {
        // 当前无默认网络时，获取的netHandler的netid为0,属于异常情况，需要额外处理
        return;
      }
      if (data) {
        this.defaultNetworkStatus = 'Retrieved successfully'
        Logger.info('getDefaultNet get data: ' + JSON.stringify(data));
        GlobalContext.getContext().netHandle = data;
        // 获取netHandle对应网络的能力信息。能力信息包含了网络类型、网络具体能力等网络信息
        connection.getNetCapabilities(GlobalContext.getContext().netHandle).then(
          (data: connection.NetCapabilities) => {
            Logger.info('getNetCapabilities get data: ' + JSON.stringify(data));
            // 获取网络类型(bearerTypes)
            let bearerTypes: Set<number> = new Set(data.bearerTypes);
            let bearerTypesNum = Array.from(bearerTypes.values());
            for (let item of bearerTypesNum) {
              if (item == 0) {
                // 蜂窝网
                Logger.info(JSON.stringify('BEARER_CELLULAR'));
              } else if (item == 1) {
                // Wi-Fi网络
                Logger.info(JSON.stringify('BEARER_WIFI'));
              } else if (item == 3) {
                // 以太网网络
                Logger.info(JSON.stringify('BEARER_ETHERNET'));
              }
            }

            // 获取网络具体能力(networkCap)
            let itemNumber: Set<number> = new Set(data.networkCap);
            let dataNumber = Array.from(itemNumber.values());
            for (let item of dataNumber) {
              if (item == 0) {
                // 表示网络可以访问运营商的MMSC（Multimedia Message Service，多媒体短信服务）发送和接收彩信
                Logger.info(JSON.stringify('NET_CAPABILITY_MMS'));
              } else if (item == 11) {
                // 表示网络流量未被计费
                Logger.info(JSON.stringify('NET_CAPABILITY_NOT_METERED'));
              } else if (item == 12) {
                // 表示该网络应具有访问Internet的能力，该能力由网络提供者设置
                Logger.info(JSON.stringify('NET_CAPABILITY_INTERNET'));
              } else if (item == 15) {
                // 表示网络不使用VPN（Virtual Private Network，虚拟专用网络）
                Logger.info(JSON.stringify('NET_CAPABILITY_NOT_VPN'));
              } else if (item == 16) {
                // 表示该网络访问Internet的能力被网络管理成功验证，该能力由网络管理模块设置
                Logger.info(JSON.stringify('NET_CAPABILITY_VALIDATED'));
              }
            }
          });
      }
    });
  }

  // 使用默认网络解析主机名以获取所有IP地址
  getDefaultNetworkIP() {
    this.defaultNetworkIPStatus = 'Retrieving...';
    connection.getDefaultNet().then((data: connection.NetHandle) => {
      if (data.netId === 0) {
        this.defaultNetworkIPStatus = 'No default network';
        Logger.error('No default network available');
        return;
      }
      connection.getAddressesByName('localhost').then((data: connection.NetAddress[]) => {
        Logger.info('Successfully retrieved default network IP address: ' + JSON.stringify(data));
        this.defaultNetworkIPStatus = 'Retrieved successfully';
      }).catch((err: BusinessError) => {
        this.defaultNetworkIPStatus = 'Retrieval failed';
        Logger.error('Failed to retrieve default network IP address:', JSON.stringify(err));
      });
    }).catch((err: BusinessError) => {
      this.defaultNetworkIPStatus = 'Retrieval failed';
      Logger.error('Failed to retrieve default network:', JSON.stringify(err));
    });
  }
}
