/**
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

import { PromptAction } from '@kit.ArkUI';
import hilog from '../model/Logger';
import { wifiManager } from '@kit.ConnectivityKit';
import { P2pView } from '../component/P2pView';

const TAG = 'availableP2p';

/**
 * available p2p page of WiFi test
 */
@Entry
@Component
struct WifiConnect {
  @State p2pList: Array<wifiManager.WifiP2pDevice> = []
  @State p2pLinkedInfo: wifiManager.WifiP2pLinkedInfo | null = null;
  private selectIndex: number = - 1
  @State isSwitchOn: boolean = false;
  promptAction: PromptAction = this.getUIContext().getPromptAction();

  addListener() {
    // 连接状态改变时，修改连接信息
    hilog.info(TAG, 'addListener');
    wifiManager.on('p2pConnectionChange', async wifiP2pLinkedInfo => {
      hilog.info('p2p connection change receive event: ' + JSON.stringify(wifiP2pLinkedInfo));
      this.p2pLinkedInfo = wifiP2pLinkedInfo;
      let connectState = wifiP2pLinkedInfo.connectState;
      let p2pConnectionMessage = '';
      switch ( connectState ) {
        case 0:
          p2pConnectionMessage = 'DISCONNECTED!';
          this.p2pLinkedInfo = null;
          this.promptAction.showToast({
            message: 'CONNECT DISABLE',
            duration: 2000
          });
          break;
        case 1:
          p2pConnectionMessage = 'CONNECTED!';
          this.promptAction.showToast({
            message: 'CONNECT SUCCESS',
            duration: 2000
          });
          let curGp = await wifiManager.getCurrentGroup();
          AppStorage.setOrCreate('p2pLinkedDeviceName', curGp.groupName);
          break;
        default:
          p2pConnectionMessage = '未知状态';
          break;
      }
      AppStorage.setOrCreate('p2pConnectState', connectState);
    })

    wifiManager.on('p2pPeerDeviceChange', async (_: wifiManager.WifiP2pDevice[]) => {
      hilog.info(TAG, 'p2pPeerDeviceChange:', JSON.stringify(_));
      try {
        let devices = await wifiManager.getP2pPeerDevices();
        this.p2pList = devices;
      } catch (e) {
        hilog.info(JSON.stringify(e));
      }
    })
  }

  // [Start discover_p2p_device]
  aboutToAppear() {
    // 如果wifi是开的，就记录下状态，然后扫描p2p设备，并获取连接信息
    if (!wifiManager.isWifiActive()) {
      this.promptAction.showToast({
        message: 'please active wifi',
        duration: 2000
      });
      return;
    }
    this.isSwitchOn = true;
    wifiManager.startDiscoverDevices();
    this.addListener();
  }

  aboutToDisappear() {
    wifiManager.off('p2pPeerDeviceChange');
    wifiManager.off('p2pConnectionChange');
  }
  // [End discover_p2p_device]

  // [Start connectP2p]
  connectP2p(p2pScanInfo: wifiManager.WifiP2pDevice) {
    this.promptAction.showToast({
      message: 'connect to device',
      duration: 2000
    });
    hilog.info(TAG , `connect deviceAddress=${ p2pScanInfo.deviceAddress }`);
    hilog.info(TAG , `p2pScanInfo:` + JSON.stringify(p2pScanInfo));
    let config: wifiManager.WifiP2PConfig = {
      deviceAddress : p2pScanInfo.deviceAddress,
      netId : - 2 ,
      deviceAddressType: 1,
      passphrase : '' ,
      groupName : '' ,
      goBand : 0
    }
    wifiManager.p2pConnect(config);
  }
  // [End connectP2p]

  build() {
    Column() {
      Row() {
        Text($r('app.string.p2p_available'))
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .height(40)
      }
      .width('100%')
      .padding({ left: 16, right: 16 })

      List({ space: 5 }) {
        ForEach(this.p2pList , (item: wifiManager.WifiP2pDevice , index: number) => {
          ListItem() {
            P2pView({ p2p : item })
          }
          .onClick(() => {
            hilog.info(TAG , 'p2p click');
            this.selectIndex = index;
            if ( this.p2pLinkedInfo !== null && this.p2pLinkedInfo.connectState == 1 ) {
              this.promptAction.showToast({
                message: 'this p2p is connected',
                duration: 2000
              });
              return;
            }
            this.connectP2p(item);
          })
        } , (item: wifiManager.WifiP2pDevice) => JSON.stringify(item))
      }
      .layoutWeight(1)
      .divider({ strokeWidth : 1 , color : Color.Gray , startMargin : 10 , endMargin : 10 })
      .margin(10)
    }
    .margin({ top : 15 , bottom : 100 })
  }
}