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

import P2PManager from '../entryability/p2pability';
import P2PConnectManager from '../entryability/p2pConnect';
import { wifiManager } from '@kit.ConnectivityKit';

@Entry
@Component
struct Index {
  @State message: string = 'p2p sample';
  scroller: Scroller = new Scroller();

  build() {
    Column() {
      Text(this.message)
      Button('create group').onClick(async () => {
        try {
          // 创建P2P群组
          await P2PManager.create();
          let devices = await wifiManager.getLinkedInfo();
          if (Array.isArray(devices)) {
            this.message = JSON.stringify(devices, null, 2);
          } else {
            this.message = typeof devices === 'object' ? JSON.stringify(devices, null, 2) : String(devices);
          }

        } catch (error) {
          console.error('Error creating P2P group or getting peer devices:', error);
          this.message = 'Failed to create P2P group or get peer devices.';
        }
      })
        .width('30%')
        .margin('5')

      Button('connect').onClick(async () => {
        try {
          // 执行p2p连接
          await P2PConnectManager.connect();
          this.message = P2PConnectManager.message;
        } catch (error) {
          console.error('Error creating P2P group or getting peer devices:', error);
          this.message = 'Failed to connect.';
        }
      })
        .width('30%')
        .margin('5')

      Button('delete group').onClick(() => {
        // 删除p2p群组
        P2PManager.delete();
        let devices = wifiManager.getLinkedInfo();
        this.message = JSON.stringify(devices, null, 2);
      })
        .width('30%')
        .margin('5')
    }
    .height('100%')
    .width('100%')
  }
}