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

export class P2PManager {
  private eventListeners = [];
  public recvP2pPersistentGroupChangeFunc = () => {
    console.info('p2p persistent group change receive event');
    // 永久组创建好后需要处理的业务逻辑
  };

  public create() {
    wifiManager.on('p2pPersistentGroupChange', this.recvP2pPersistentGroupChangeFunc);
    try {
      let config: wifiManager.WifiP2PConfig = {
        deviceAddress: '00:11:22:33:44:55',
        deviceAddressType: 1,
        netId: -2,
        passphrase: '12345678',
        groupName: 'testGroup',
        goBand: 0
      }
      wifiManager.createGroup(config);
    } catch (error) {
      console.error('failed:' + JSON.stringify(error));
    }
  }

  public delete() {
    try {
      wifiManager.removeGroup();
    } catch (error) {
      console.error('failed:' + JSON.stringify(error));
    }
  }
}

// 默认导出let
let p2pManager = new P2PManager();

export default p2pManager as P2PManager;