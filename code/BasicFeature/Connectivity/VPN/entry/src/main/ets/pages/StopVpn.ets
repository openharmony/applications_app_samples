/*
* Copyright (c) 2023 Huawei Device Co., Ltd.
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

import hilog from '@ohos.hilog';
import vpnext from '@ohos.net.vpnExtension';
import Want from '@ohos.app.ability.Want';
import common from '@ohos.app.ability.common';
import vpn_client from "libvpn_client.so";
import { showToast } from '../components/ShowToast';

let want: Want = {
  deviceId: "",
  bundleName: "com.example.myvpndemo",
  abilityName: "MyVpnExtAbility",
};
let g_tunnelFd = -1;

@Entry
@Component
struct StopVpn {
  @State message: string = 'VPN';
  @State vpnServerIp: string = '192.168.31.13';
  @State tunIp: string = '10.0.0.5';
  @State routeAddr: string = '192.168.214.0';
  @State prefix: string = '24';
  @State blockedAppName: string = 'com.example.baidumyapplication';
  private context = getContext(this) as common.VpnExtensionContext;
  private VpnConnection: vpnext.VpnConnection = vpnext.createVpnConnection(this.context);

  Destroy() {
    hilog.info(0x0000, 'developTag', '%{public}s', 'vpn Destroy');
    vpn_client.stopVpn(g_tunnelFd);
    this.VpnConnection.destroy().then(() => {
      showToast('vpn Destroy Success', 2000);
      hilog.info(0x0000, 'developTag', '%{public}s', 'vpn Destroy Success');
    }).catch((err: Error) => {
      showToast('vpn Destroy Failed: ' + JSON.stringify(err), 2000);
      hilog.error(0x0000, 'developTag', 'vpn Destroy Failed: %{public}s', JSON.stringify(err) ?? '');
    })
  }

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(35)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            hilog.info(0x0000, 'developTag', '%{public}s', 'vpn Client');
          })
        Button('stop vpn').onClick(() => {
          this.Destroy();
        }).fontSize(50)
        Button('stop vpnExt').onClick(() => {
          try {
            vpnext.stopVpnExtensionAbility(want).then(() => {
              showToast('stop vpnExt Success', 2000);
              hilog.info(0x0000, 'developTag', '%{public}s', 'stop vpnExt Success');
            })
          } catch (err) {
            showToast('stop vpnExt Fail: ' + JSON.stringify(err), 2000);
            hilog.error(0x0000, 'developTag', 'stop vpnExt Fail %{public}s', JSON.stringify(err) ?? '');
          }
        }).fontSize(50)
      }.width('100%')
    }.height('100%')
  }
}