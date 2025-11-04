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

// [Start stop_vpn_extension_ability_import]
import { common, Want } from '@kit.AbilityKit';
import { vpnExtension } from '@kit.NetworkKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
// [End stop_vpn_extension_ability_import]
import vpn_client from 'libentry.so';
import { showToast } from '../common/ShowToast';
import { ComponentId } from '../common/CommonConstant';
import TitleBar from '../common/component';

// 常量提取
const TOAST_DURATION = 2000; // Toast 显示时间
let g_tunnelFd = -1;

// [Start stop_vpn_extension_ability]
const TITLE_FONT_SIZE = 35; // 标题字体大小
const BUTTON_FONT_SIZE = 25; // 按钮字体大小
const BUTTON_MARGIN = 16;

let want: Want = {
  deviceId: '',
  bundleName: 'com.samples.vpncontrol_case',
  abilityName: 'MyVpnExtAbility',
};

@Entry
@Component
struct StopVpn {
  @State message: string = 'VPN';

  // [StartExclude stop_vpn_extension_ability]
  @State flag: string = 'wait';
  @State blockedAppName: string = 'com.example.baidumyapplication';
  // [Start stop_vpn_extension_ability_on_destroy]
  private context = getContext(this) as common.VpnExtensionContext;
  private vpnConnection: vpnExtension.VpnConnection = vpnExtension.createVpnConnection(this.context);

  Destroy() {
    hilog.info(0x0000, 'testTag', 'developTag', '%{public}s', 'vpn Destroy');
    // [StartExclude stop_vpn_extension_ability_on_destroy]
    vpn_client.stopVpn(g_tunnelFd);
    // [EndExclude stop_vpn_extension_ability_on_destroy]
    this.vpnConnection.destroy().then(() => {
      hilog.info(0x0000, 'testTag', 'developTag', '%{public}s', 'vpn Destroy Success');
      // [StartExclude stop_vpn_extension_ability_on_destroy]
      showToast('vpn Destroy Success', TOAST_DURATION);
      this.flag = 'Pass';
      // [EndExclude stop_vpn_extension_ability_on_destroy]
    }).catch((err: Error) => {
       hilog.error(0x0000, 'testTag', 'developTag', 'vpn Destroy Failed: %{public}s', JSON.stringify(err) ?? '');
      // [StartExclude stop_vpn_extension_ability_on_destroy]
      showToast('vpn Destroy Failed: ' + JSON.stringify(err), TOAST_DURATION);
      this.flag = 'Error';
      // [EndExclude stop_vpn_extension_ability_on_destroy]
    })
  }
  // [End stop_vpn_extension_ability_on_destroy]

  // [EndExclude stop_vpn_extension_ability]
  build() {
    Row() {
      Column() {
        // [StartExclude stop_vpn_extension_ability]
        TitleBar({ hasBackPress: true, title: 'BACK' })
        // [EndExclude stop_vpn_extension_ability]
        Text(this.message)
          .fontSize(TITLE_FONT_SIZE)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            hilog.info(0x0000, 'testTag', 'developTag', '%{public}s', 'vpn Client');
          })
        // [StartExclude stop_vpn_extension_ability]
        Button($r('app.string.stop_vpn'))
          .onClick(() => {
            this.Destroy();
          })
          .width('70%')
          .id(ComponentId.INNER_STOP_VPN_BUTTON)
          .fontSize(BUTTON_FONT_SIZE)
          .margin(BUTTON_MARGIN)
        // [EndExclude stop_vpn_extension_ability]
        Button('Start Extension').onClick(() => {
          vpnExtension.startVpnExtensionAbility(want);
        }).width('70%').fontSize(45).margin(16);
        Button($r('app.string.stop_vpnExt'))
          .onClick(() => {
            try {
              hilog.info(0x0000, 'testTag', 'btn end')
              vpnExtension.stopVpnExtensionAbility(want)
              // [StartExclude stop_vpn_extension_ability]
                .then(() => {
                  showToast('stop vpnExt Success', TOAST_DURATION);
                  hilog.info(0x0000, 'testTag', 'developTag', '%{public}s', 'stop vpnExt Success');
                  this.flag = 'Pass';
                });
              // [EndExclude stop_vpn_extension_ability]
            } catch (err) {
              // [StartExclude stop_vpn_extension_ability]
              showToast('stop vpnExt Fail: ' + JSON.stringify(err), TOAST_DURATION);
              this.flag = 'Error';
              // [EndExclude stop_vpn_extension_ability]
              hilog.error(0x0000, 'testTag', 'developTag', 'stop vpnExt Fail %{public}s', JSON.stringify(err) ?? '');
            }

          })
          .width('70%')
          // [StartExclude stop_vpn_extension_ability]
          .id(ComponentId.STOP_VPN_EXT_BUTTON)
          // [EndExclude stop_vpn_extension_ability]
          .fontSize(BUTTON_FONT_SIZE)
          .margin(BUTTON_MARGIN)
      }.width('100%');
    }.height('100%');
  }
}
// [End stop_vpn_extension_ability]