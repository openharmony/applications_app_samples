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

import { wifiManager } from '@kit.ConnectivityKit';

export class P2PConnectMananger {
  public message: string = 'connecting...';

  public connect() {
    let recvP2pConnectionChangeFunc = (result: wifiManager.WifiP2pLinkedInfo) => {
      console.info('p2p connection change receive event: ' + JSON.stringify(result));
      wifiManager.getP2pLinkedInfo((err, data) => {
        if (err) {
          console.error('getP2pLinkedInfo ' + JSON.stringify(err));
          return;
        }
        console.info('get getP2pLinkedInfo: ' + JSON.stringify(data));
        // 添加P2P连接成功或者失败场景的业务处理
      });
    }
    // P2P连接完成，会调用'p2pConnectionChange'事件回调
    wifiManager.on('p2pConnectionChange', recvP2pConnectionChangeFunc);

    let recvP2pPeerDeviceChangeFunc = (result: wifiManager.WifiP2pDevice[]) => {
      console.info('p2p peer device change receive event: ' + JSON.stringify(result));
      wifiManager.getP2pPeerDevices((err, data) => {
        if (err) {
          console.error('failed to get peer devices: ' + JSON.stringify(err));
          return;
        }
        console.info('get peer devices: ' + JSON.stringify(data));
        let len = data.length;
        for (let i = 0; i < len; ++i) {
          // 选择符合条件的对端P2P设备
          if (data[i].deviceName === 'ShineAirPlay') {
            console.info('p2p connect to test device: ' + data[i].deviceAddress);
            let config: wifiManager.WifiP2PConfig = {
              deviceAddress: data[i].deviceAddress,
              deviceAddressType: 1,
              netId: -2,
              passphrase: '',
              groupName: '',
              goBand: 0,
            }
            // 执行P2P连接，作为GO时不能主动发起连接
            wifiManager.p2pConnect(config);
            this.message = 'p2p connect to test device: ' + data[i].deviceAddress;
          }
        }
      });
    }
    // P2P扫描结果上报时会调用'p2pPeerDeviceChange'事件回调
    wifiManager.on('p2pPeerDeviceChange', recvP2pPeerDeviceChangeFunc);

    setTimeout(() => {
      wifiManager.off('p2pConnectionChange', recvP2pConnectionChangeFunc);
    }, 125 * 1000);
    setTimeout(() => {
      wifiManager.off('p2pPeerDeviceChange', recvP2pPeerDeviceChangeFunc);
    }, 125 * 1000);
    // 开始发现P2P设备，即，开始P2P扫描
    console.info('start discover devices -> ' + wifiManager.startDiscoverDevices());
  }
}

// 默认导出let
let p2pConnectManager = new P2PConnectMananger();

export default p2pConnectManager as P2PConnectMananger;
