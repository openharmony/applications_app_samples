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

// [Start get_default_network_methods]
// 从@kit.NetworkKit中导入connection命名空间。
import { connection } from '@kit.NetworkKit';
// [StartExclude get_default_network_methods]

const BUTTON_HEIGHT = 50; // 按钮的高度
const BUTTON_FONT_SIZE = 20; // 按钮的字体大小
const BUTTON_RADIUS = 5; // 按钮的圆角半径
const TEXT_MARGIN_TOP_L = 10; // 长文本的上边距

@Component
export default struct defaultNetworkBtn {
  @Link defaultNetworkStatus: string;

  build() {
    Column() {
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
    }
  }

  // 根据数据网络查询网络的能力信息及连接信息
  // [EndExclude get_default_network_methods]
  getDefaultNetwork() {
    let netHandleInfo:connection.NetHandle|null = null;
    // 调用getDefaultNet方法，获取默认的数据网络(NetHandle)
    connection.getDefaultNet().then((data: connection.NetHandle) => {
      if (data.netId == 0) {
        console.info(`don't have defaultNet`);
        // 当前无默认网络时，获取的netHandler的netid为0,属于异常情况，需要额外处理
        return;
      }
      if (data) {
        // [StartExclude get_default_network_methods]
        this.defaultNetworkStatus = 'Retrieved successfully'
        // [EndExclude get_default_network_methods]
        console.info('getDefaultNet get data: ' + JSON.stringify(data));
        // 获取netHandle对应网络的能力信息。能力信息包含了网络类型、网络具体能力等网络信息
        netHandleInfo = data;
        connection.getNetCapabilities(netHandleInfo).then(
          (data: connection.NetCapabilities) => {
            console.info('getNetCapabilities get data: ' + JSON.stringify(data));
            // 获取网络类型(bearerTypes)
            let bearerTypes: Set<number> = new Set(data.bearerTypes);
            let bearerTypesNum = Array.from(bearerTypes.values());
            for (let item of bearerTypesNum) {
              if (item == 0) {
                // 蜂窝网
                console.info(JSON.stringify('BEARER_CELLULAR'));
              } else if (item == 1) {
                // Wi-Fi网络
                console.info(JSON.stringify('BEARER_WIFI'));
              } else if (item == 3) {
                // 以太网网络
                console.info(JSON.stringify('BEARER_ETHERNET'));
              }
            }

            // 获取网络具体能力(networkCap)
            let itemNumber: Set<number> = new Set(data.networkCap);
            let dataNumber = Array.from(itemNumber.values());
            for (let item of dataNumber) {
              if (item == 0) {
                // 表示网络可以访问运营商的MMSC(Multimedia Message Service，多媒体短信服务)发送和接收彩信
                console.info(JSON.stringify('NET_CAPABILITY_MMS'));
              } else if (item == 11) {
                // 表示网络流量未被计费
                console.info(JSON.stringify('NET_CAPABILITY_NOT_METERED'));
              } else if (item == 12) {
                // 表示该网络应具有访问Internet的能力，该能力由网络提供者设置
                console.info(JSON.stringify('NET_CAPABILITY_INTERNET'));
              } else if (item == 15) {
                // 表示网络不使用VPN（Virtual Private Network，虚拟专用网络）
                console.info(JSON.stringify('NET_CAPABILITY_NOT_VPN'));
              } else if (item == 16) {
                // 表示该网络访问Internet的能力被网络管理成功验证，该能力由网络管理模块设置
                console.info(JSON.stringify('NET_CAPABILITY_VALIDATED'));
              }
            }
          });
      }
    });

    // 获取netHandle对应的网络的连接信息。
    connection.getConnectionProperties(netHandleInfo).then((data: connection.ConnectionProperties) => {
      console.info('getConnectionProperties get data: ' + JSON.stringify(data));
    })
  }
  // [End get_default_network_methods]
}
