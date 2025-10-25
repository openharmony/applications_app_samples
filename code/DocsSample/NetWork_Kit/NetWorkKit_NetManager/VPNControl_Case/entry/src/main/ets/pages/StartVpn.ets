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

// [Start start_vpn_extension_ability]
import { common, Want } from '@kit.AbilityKit';
import { vpnExtension } from '@kit.NetworkKit';
// [StartExclude start_vpn_extension_ability]
import vpn_client from 'libentry.so';
import { showToast } from '../common/ShowToast';
import { ComponentId } from '../common/CommonConstant'; // 引入枚举
import TitleBar from '../common/component';
import NotificationOperations from '../notification/NotificationOperations';
import SetupVpn from './SetupVpn';
import { hilog } from '@kit.PerformanceAnalysisKit';

// 提取常量
const LABEL_FONT_SIZE = 20; // 标签字体大小
const INPUT_MARGIN = 2; // 输入框边距
const BUTTON_SUCCESS_MESSAGE = 4000; // Toast 显示时间

let g_tunFd = -1;
let g_tunnelFd = -1;
// [EndExclude start_vpn_extension_ability]

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
struct StartVpn {
  @State message: string = 'VPN';
  // [StartExclude start_vpn_extension_ability]
  @State vpnServerIp: string = '192.168.xxx.xxx'; // 示例服务端地址，若有vpn服务器可填写实际服务器ip
  @State tunIp: string = '10.0.0.5';  // 示例地址，代表客户端设备在虚拟网络中的地址
  @State prefix: string = '24';
  @State blockedAppName: string = 'com.example.baidumyapplication'; // 示例
  @State flag: string = 'wait';

  private context = getContext(this) as common.VpnExtensionContext;
  private vpnConnection: vpnExtension.VpnConnection = vpnExtension.createVpnConnection(this.context);
  private notificationOperations: NotificationOperations = new NotificationOperations(getContext(this));

  CreateTunnel() {
    g_tunnelFd = vpn_client.udpConnect(this.vpnServerIp, 8888);
    if (g_tunnelFd) {
      showToast('CreateTunnel Success', BUTTON_SUCCESS_MESSAGE);
      hilog.info(0x0000, 'testTag', 'developTag', '%{public}s', 'CreateTunnel Success');
      this.flag = 'Pass';
    } else {
      showToast('CreateTunnel Fail', BUTTON_SUCCESS_MESSAGE);
       hilog.error(0x0000, 'testTag', 'developTag', 'CreateTunnel Fail %{public}s', 'CreateTunnel Fail');
      this.flag = 'Error';
    }
  }

  Protect() {
    hilog.info(0x0000, 'testTag', 'developTag', '%{public}s', 'vpn Protect');
    this.vpnConnection.protect(g_tunnelFd).then(() => {
      showToast('vpn Protect Success', BUTTON_SUCCESS_MESSAGE);
      hilog.info(0x0000, 'testTag', 'developTag', '%{public}s', 'vpn Protect Success');
      this.flag = 'Pass';
    }).catch((err: Error) => {
      showToast('vpn Protect Failed: ' + JSON.stringify(err), BUTTON_SUCCESS_MESSAGE);
      hilog.error(0x0000, 'testTag', 'developTag', 'vpn Protect Failed %{public}s', JSON.stringify(err) ?? '');
      this.flag = 'Error';
    });
  }
  // [EndExclude start_vpn_extension_ability]
  build() {
    Row() {
      Column() {
        // [StartExclude start_vpn_extension_ability]
        TitleBar({ hasBackPress: true, title: 'BACK' })
        // [EndExclude start_vpn_extension_ability]
        Text(this.message)
          .fontSize(TITLE_FONT_SIZE)
          .fontWeight(FontWeight.Bold)
          // [StartExclude start_vpn_extension_ability]
          .id(this.flag)
          // [EndExclude start_vpn_extension_ability]
          .onClick(() => {
            hilog.info(0x0000, 'testTag', 'developTag', '%{public}s', 'vpn Client');
          })
        // [StartExclude start_vpn_extension_ability]
        Row() {
          Text('server ip')
            .fontSize(LABEL_FONT_SIZE)
            .width('40%')
            .textAlign(TextAlign.Center)
            .backgroundColor(0xAFEEEE);
          TextInput({ text: '192.168.xxx.xxx' })
            .onChange((value) => {
              this.vpnServerIp = value;
            })
            .width('60%')
            .margin(INPUT_MARGIN)
        }.width('90%');

        Row() {
          Text('tun ip')
            .fontSize(LABEL_FONT_SIZE)
            .width('40%')
            .textAlign(TextAlign.Center)
            .backgroundColor(0xAFEEEE);
          TextInput({ text: '10.0.0.5' })
            .onChange((value) => {
              this.tunIp = value;
            })
            .width('60%')
            .margin(INPUT_MARGIN)
        }.width('90%')

        Row() {
          Text('blockedApp')
            .fontSize(LABEL_FONT_SIZE)
            .width('40%')
            .textAlign(TextAlign.Center)
            .backgroundColor(0xAFEEEE)
          TextInput({ text: 'com.example.baidumyapplication' })
            .onChange((value) => {
              this.blockedAppName = value;
            })
            .width('60%')
            .margin(INPUT_MARGIN)
        }.width('90%')

        Button($r('app.string.CreateTunnel'))
          .onClick(() => {
            this.CreateTunnel();
          })
          .width('70%')
          .id(ComponentId.CREATE_TUNNEL_BUTTON)
          .fontSize(BUTTON_FONT_SIZE)
          .margin(BUTTON_MARGIN);
        Button($r('app.string.Protect'))
          .onClick(() => {
            this.Protect();
          })
          .width('70%')
          .id(ComponentId.PROTECT_BUTTON)
          .fontSize(BUTTON_FONT_SIZE)
          .margin(BUTTON_MARGIN);
        // [EndExclude start_vpn_extension_ability]
        Button($r('app.string.start_vpnExt'))
          .onClick(() => {
            // [StartExclude start_vpn_extension_ability]
            try {
              // [EndExclude start_vpn_extension_ability]
              vpnExtension.startVpnExtensionAbility(want)
              // [StartExclude start_vpn_extension_ability]
                .then(() => {
                  showToast('start vpnExt Success', BUTTON_SUCCESS_MESSAGE);
                  hilog.info(0x0000, 'testTag', 'developTag', '%{public}s', 'start vpnExt Success');
                  this.flag = 'Pass';
                })
            } catch (err) {
              showToast('start vpnExt Fail: ' + JSON.stringify(err), BUTTON_SUCCESS_MESSAGE);
              this.flag = 'Error';
              hilog.error(0x0000, 'testTag', 'developTag', 'start vpnExt Fail %{public}s', JSON.stringify(err) ?? '');
            }
            // [EndExclude start_vpn_extension_ability]
          })
          .width('70%')
          // [StartExclude start_vpn_extension_ability]
          .id(ComponentId.START_VPN_EXT_BUTTON)
          // [EndExclude start_vpn_extension_ability]
          .fontSize(BUTTON_FONT_SIZE)
          .margin(BUTTON_MARGIN)
        // [StartExclude start_vpn_extension_ability]
        SetupVpn({ flag: this.flag})
        // [EndExclude start_vpn_extension_ability]
      }.width('100%');
    }.height('100%');

  }
}
// [End start_vpn_extension_ability]