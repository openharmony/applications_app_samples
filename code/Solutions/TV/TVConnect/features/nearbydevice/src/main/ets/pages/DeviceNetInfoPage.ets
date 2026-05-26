/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { CommonConstants, NavBar } from '@ohos/common';
import { CloudDeviceModel } from '@ohos/connect_cloud';
import router from '@ohos.router';
import { HMRouter } from '@hadss/hmrouter';

export class DevicesInfo {
  public name: ResourceStr = '';
  public value: ResourceStr = '';
}

@HMRouter({ pageUrl: 'DeviceNetInfoPage' })
@Component
export struct DeviceNetInfoPage {
  //临时数据 获取到真实数据需删除
  private wlanName: ResourceStr = 'TP-LINK_5G';
  private rssi: ResourceStr = '-40dbm';
  private ipAddr: ResourceStr = '192.168.3.100';
  private bssid: ResourceStr = 'AA:BB:CC:DD:EE:FF';
  @State deviceInfo?: CloudDeviceModel = undefined;

  aboutToAppear(): void {
    this.deviceInfo = router.getParams() as CloudDeviceModel;
  }

  @Builder
  listItemData($$: DevicesInfo) {
    ListItem() {
      Row() {
        Text($$.name)
          .listTextStyle($r('app.color.tips_button_backgroundColor'));
        Blank();
        Text($$.value)
          .listTextStyle();
      }.width(CommonConstants.FULL_WIDTH_PERCENT);
    }.height($r('app.string.vp_50'));
  }

  build() {
    Column() {
      NavBar({
        title: $r('app.string.device_net_info'),
        paddingLeft: $r('app.string.scan_tip_margin_top')
      });

      List() {
        this.listItemData({ name: $r('app.string.WLAN_name'), value: this.wlanName });
        this.listItemData({ name: $r('app.string.RSSI'), value: this.rssi });
        this.listItemData({ name: $r('app.string.ip_address'), value: this.ipAddr });
        this.listItemData({ name: $r('app.string.BSSID'), value: this.bssid });
      }.listStyle()
      .divider({ strokeWidth: $r('app.string.vp_1') });
    }
    .width(CommonConstants.FULL_WIDTH_PERCENT)
    .height(CommonConstants.FULL_HEIGHT_PERCENT)
    .padding({ left: $r('app.string.scan_tip_margin_top'), right: $r('app.string.scan_tip_margin_top') })
    .backgroundColor($r('app.color.page_color_f1f3f5'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM]);
  }
}

@Styles
function listStyle() {
  .width(CommonConstants.FULL_WIDTH_PERCENT)
  .borderRadius($r('app.string.radius_16'))
  .backgroundColor(Color.White)
  .padding({ left: $r('app.string.scan_tip_margin_top'), right: $r('app.string.scan_tip_margin_top') })
  .margin({ bottom: $r('app.string.scan_tip_margin_top') });
}

@Extend(Text)
function listTextStyle(color?: ResourceColor) {
  .fontSize($r('app.string.fp_12'))
  .fontColor(color ?? $r('app.color.font_color_E6000000'))
  .fontWeight(FontWeight.Regular);
}