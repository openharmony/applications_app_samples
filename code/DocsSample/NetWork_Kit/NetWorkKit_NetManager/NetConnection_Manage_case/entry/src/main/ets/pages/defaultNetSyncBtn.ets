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

// [Start NetConnection_manage_case_default_net_sync]
// 从@kit.NetworkKit中导入connection命名空间。
import { connection } from '@kit.NetworkKit';
// [StartExclude NetConnection_manage_case_default_net_sync]

const BUTTON_HEIGHT = 50; // 按钮的高度
const BUTTON_FONT_SIZE = 20; // 按钮的字体大小
const BUTTON_RADIUS = 5; // 按钮的圆角半径
const TEXT_MARGIN_TOP_L = 20; // 长文本的上边距

@Component
export default struct defaultNetSyncBtn {
  @Link defaultNetSync: string;

  build() {
    Column() {
      Button($r('app.string.accessTheInternet'))
        .onClick(() => {
          this.getDefaultNetSync();
        })
        .width('80%')
        .height(BUTTON_HEIGHT)
        .margin({ top: TEXT_MARGIN_TOP_L })
        .fontColor(Color.White)
        .fontSize(BUTTON_FONT_SIZE)
        .borderRadius(BUTTON_RADIUS)
        .id('Get_Default_Net_Sync')
    }
  }

  getDefaultNetSync() {
    this.defaultNetSync = 'Retrieving...';
    // [EndExclude NetConnection_manage_case_default_net_sync]
    // 获取默认激活的数据网络。
    let netHandle = connection.getDefaultNetSync();
    if (!netHandle || netHandle.netId === 0) {
      console.error('getDefaultNetSync fail');
      // [StartExclude NetConnection_manage_case_default_net_sync]
      this.defaultNetSync = 'getDefaultNetSync fail';
      // [EndExclude NetConnection_manage_case_default_net_sync]
    } else {
      console.info('default network: ' + JSON.stringify(netHandle));
      // 获取netHandle对应网络的能力信息。
      let netCapabilities = connection.getNetCapabilitiesSync(netHandle);
      let cap = netCapabilities.networkCap;
      console.info('network capabilities: ' + JSON.stringify(netCapabilities));
      // 判断网络是否可以访问互联网。
      if (cap?.includes(connection.NetCap.NET_CAPABILITY_CHECKING_CONNECTIVITY)) {
        // 正在验证网络连通性，请稍后重试。
        console.info('default network is checking, please try again later');
      } else {
        if (cap?.includes(connection.NetCap.NET_CAPABILITY_VALIDATED)) {
          // 网络连通性验证成功，当前默认网络可以访问互联网。
          console.info('default network is validated');
          // [StartExclude NetConnection_manage_case_default_net_sync]
          this.defaultNetSync = 'default network is validated';
          // [EndExclude NetConnection_manage_case_default_net_sync]
        } else {
          // 网络连通性验证失败，当前默认网络不可以访问互联网。
          console.info('default network is not validated');
          // [StartExclude NetConnection_manage_case_default_net_sync]
          this.defaultNetSync = 'default network is not validated';
          // [EndExclude NetConnection_manage_case_default_net_sync]
        }
      }
    }
    // [End NetConnection_manage_case_default_net_sync]
  }
}
