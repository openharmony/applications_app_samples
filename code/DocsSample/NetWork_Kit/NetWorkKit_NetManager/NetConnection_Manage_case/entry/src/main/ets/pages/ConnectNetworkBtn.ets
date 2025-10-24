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

// [Start NetConnection_manage_case_module_import]
// 引入包名。
import { connection } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
// [End NetConnection_manage_case_module_import]

const NETWORK_CONNECTION_TIMEOUT = 1000; // 网络连接超时
const BUTTON_HEIGHT = 50; // 按钮的高度
const BUTTON_FONT_SIZE = 20; // 按钮的字体大小
const BUTTON_RADIUS = 5; // 按钮的圆角半径
const TEXT_MARGIN_TOP_L = 10; // 长文本的上边距
// [Start notification_network_create_NetConnection]
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
let conn = connection.createNetConnection(netSpecifier, TIMEOUT);
// [End notification_network_create_NetConnection]
@Component
export default struct connectNetworkBtn {
  @Link connectStatus: string;
  @Link disconnectStatus: string;

  build() {
    Column() {
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
    }
  }

  // 连接并接收指定网络的状态变化通知
  connectNetwork() {
    // [Start notification_network_netAvailable_netUnavailable]
    // 订阅事件，如果当前指定网络可用，通过on_netAvailable通知用户
    conn.on('netAvailable', (data: connection.NetHandle) => {
      console.info('Network available, NetId is ' + data.netId);
      // [StartExclude notification_network_netAvailable_netUnavailable]
      this.connectStatus = `Network available, NetId: ${data.netId}`;
      // [EndExclude notification_network_netAvailable_netUnavailable]
    });

    // 订阅事件，如果当前指定网络不可用，通过on_netUnavailable通知用户
    conn.on('netUnavailable', (data: void) => {
      console.info('Network unavailable, data is ' + JSON.stringify(data));
      // [StartExclude notification_network_netAvailable_netUnavailable]
      this.connectStatus = 'Network unavailable';
      // [EndExclude notification_network_netAvailable_netUnavailable]
    });
    // [End notification_network_netAvailable_netUnavailable]

    // [Start notification_network_register]
    // 订阅连接状态变化
    conn.register((err: BusinessError, data: void) => {
      // [StartExclude notification_network_register]
      if (err) {
        // [EndExclude notification_network_register]
        console.error('Error occurred during connection:', JSON.stringify(err));
        // [StartExclude notification_network_register]
        this.connectStatus = 'Connection failed';
        return;
      }
      // [EndExclude notification_network_register]
    });
    // [End notification_network_register]
    console.info('Network connection attempt started');
  }

  // 当不使用该网络时，可以调用该对象的unregister()方法，取消订阅
  disconnectNetwork() {
    // [Start notification_network_unregister]
    // 当不使用该网络时，可以调用该对象的unregister()方法，取消订阅。
    conn.unregister((err: BusinessError, data: void) => {
      // [StartExclude notification_network_unregister]
      if (err) {
        console.error('Error occurred during unsubscription:', JSON.stringify(err));
      } else {
        this.disconnectStatus = 'Network disconnected';
        console.info('Network connection disconnected.');
      }
      // [EndExclude notification_network_unregister]
    });
    // [End notification_network_unregister]
  }
}
