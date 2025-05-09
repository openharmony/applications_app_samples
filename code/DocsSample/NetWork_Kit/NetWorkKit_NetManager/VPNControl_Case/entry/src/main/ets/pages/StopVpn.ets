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

import vpnext from '@ohos.net.vpnExtension';
import Want from '@ohos.app.ability.Want';
import common from '@ohos.app.ability.common';
import vpn_client from 'libentry.so';
import { showToast } from '../common/ShowToast';
import { ComponentId } from '../common/CommonConstant';
import TitleBar from '../common/component';
import Logger from '../common/Logger';

// 常量提取
const TITLE_FONT_SIZE = 35; // 标题字体大小
const BUTTON_FONT_SIZE = 25; // 按钮字体大小
const TOAST_DURATION = 2000; // Toast 显示时间
const BUTTON_MARGIN = 16;

let want: Want = {
  deviceId: '',
  bundleName: 'com.samples.vpncontrol_case',
  abilityName: 'MyVpnExtAbility',
};
let g_tunnelFd = -1;

@Entry
@Component
struct StopVpn {
  @State message: string = 'VPN';
  @State flag: string = 'wait';
  @State blockedAppName: string = 'com.example.baidumyapplication';
  private context = getContext(this) as common.VpnExtensionContext;
  private vpnConnection: vpnext.VpnConnection = vpnext.createVpnConnection(this.context);

  Destroy() {
    Logger.info('developTag', '%{public}s', 'vpn Destroy');
    vpn_client.stopVpn(g_tunnelFd);
    this.vpnConnection.destroy().then(() => {
      showToast('vpn Destroy Success', TOAST_DURATION);
      Logger.info('developTag', '%{public}s', 'vpn Destroy Success');
      this.flag = 'Pass';
    }).catch((err: Error) => {
      showToast('vpn Destroy Failed: ' + JSON.stringify(err), TOAST_DURATION);
      Logger.error('developTag', 'vpn Destroy Failed: %{public}s', JSON.stringify(err) ?? '');
      this.flag = 'Error';
    })
  }

  build() {
    Row() {
      Column() {
        TitleBar({ hasBackPress: true, title: 'BACK' })
        Text(this.message)
          .fontSize(TITLE_FONT_SIZE)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            Logger.info('developTag', '%{public}s', 'vpn Client');
          })
        Button($r('app.string.stop_vpn'))
          .onClick(() => {
            this.Destroy();
          })
          .width('70%')
          .id(ComponentId.INNER_STOP_VPN_BUTTON)
          .fontSize(BUTTON_FONT_SIZE)
          .margin(BUTTON_MARGIN)
        // [Start stop_vpn_extension_ability]
        Button($r('app.string.stop_vpnExt'))
          .onClick(() => {
            try {
              vpnext.stopVpnExtensionAbility(want).then(() => {
                showToast('stop vpnExt Success', TOAST_DURATION);
                Logger.info('developTag', '%{public}s', 'stop vpnExt Success');
                this.flag = 'Pass';
              });
            } catch (err) {
              showToast('stop vpnExt Fail: ' + JSON.stringify(err), TOAST_DURATION);
              Logger.error('developTag', 'stop vpnExt Fail %{public}s', JSON.stringify(err) ?? '');
              this.flag = 'Error';
            }
          })
          .width('70%')
          .id(ComponentId.STOP_VPN_EXT_BUTTON)
          .fontSize(BUTTON_FONT_SIZE)
          .margin(BUTTON_MARGIN)
        // [End stop_vpn_extension_ability]
      }.width('100%');
    }.height('100%');
  }
}
