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

import hilog from '../model/Logger'
import { WifiView } from '../component/WifiView'
import wifi from '@ohos.wifiManager'

const TAG = 'AvailableWiFi'
let self: AvailableWifi | null = null;
@Entry
@Component
export struct AvailableWifi {
  @State wifilist: Array<wifi.WifiScanInfo> = []
  @State wifilisttest: Array<wifi.WifiScanInfo> = []
  @State isSwitchOn: boolean = false;
  private linkedInfo: wifi.WifiLinkedInfo | null = null;
  @State isLinked: boolean = false;

  // 扫描wifi
  async getScanInfos() {
    // 不停地扫描wifi
    let result: wifi.WifiScanInfo[] = await wifi.getScanInfoList();

    if (this.isSwitchOn) {
      setTimeout(async () => {
        this.wifilist = result
        await this.getScanInfos();
      }, 3000)
    }
  }

  addListener() {
      // 连接状态改变时，修改连接信息
      wifi.on('wifiConnectionChange', async state => {
        hilog.info(TAG, `wifiConnectionChange: ${state}`);
        await this.getLinkedInfo();
      })
    // wifi状态改变时，先清空wifi列表，然后判断是否是开启状态，如果是就扫描
    wifi.on('wifiStateChange', state => {
      hilog.info(TAG, `wifiStateLisener state: ${state}`);
      if (state === 1) { // 1: wifi is enable, 0:wifi is disable
        this.isSwitchOn = true;
        this.getScanInfos();
      }
      if (state === 0) { // 1: wifi is enable, 0:wifi is disable
        this.isSwitchOn = false;
      }
    })
  }

  async getLinkedInfo() {
    try {
      let wifiLinkedInfo = await wifi.getLinkedInfo();
      if (wifiLinkedInfo === null || wifiLinkedInfo.bssid === '') {
        this.isLinked = false;
        this.linkedInfo = null;
        return;
      }
      this.isLinked = true;
      this.linkedInfo = wifiLinkedInfo;
    } catch (err) {
      hilog.info(`getLinkedInfo failed err is ${JSON.stringify(err)}`);
    }
  }

  aboutToAppear() {
    if (wifi.isWifiActive()) {
      hilog.info(TAG, 'wifi is active');
      this.isSwitchOn = true;
      this.getScanInfos();
      this.getLinkedInfo();
    }
    hilog.info(TAG, 'wifi is disabled');
    // 启动监听
    this.addListener();
  }

  aboutToDisappear() {
    wifi.off('wifiConnectionChange');
    wifi.off('wifiStateChange');
  }

  build() {
    Column() {
      Row() {
        Text($r('app.string.wlan'))
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .height(40)
        Column() {
          Toggle({ type: ToggleType.Switch, isOn: this.isSwitchOn })
            .id('switch')
            .onChange((isOn: boolean) => {
              hilog.info(`wifi swtich is: ${isOn}`);
              this.wifilist = this.wifilisttest
            })
        }
      }
      .width('100%')
      .padding({ left: 16, right: 16 })

      List({ space: 5 }) {
        ForEach(this.isSwitchOn ? this.wifilist : this.wifilisttest, (wifiItem: wifi.WifiScanInfo) => {
          ListItem() {
            WifiView({ wifi: wifiItem })
          }
        }, (wifiItem: wifi.WifiScanInfo) => JSON.stringify(wifiItem));
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.index_bg'))
  }
}