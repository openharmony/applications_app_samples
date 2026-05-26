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

import HeadTitleComponent from '../model/ble/openvalley/scene/component/HeadTitleComponent';
import { CommonConstants, NavBar } from '@ohos/common';
import { DevicesInfo } from './DeviceNetInfoPage';
import { CloudDeviceModel } from '@ohos/connect_cloud';
import router from '@ohos.router';
import { HMRouter } from '@hadss/hmrouter';

@HMRouter({ pageUrl: 'DeviceInfoPage' })
@Component
export struct DeviceInfoPage {
  //临时数据，获取到实际数据后需删除
  @State deviceName: ResourceStr = '隧道控制器';
  @State factory: ResourceStr = '华为终端有限公司';
  @State macAddr: ResourceStr = 'AA:BB:CC:DD:EE:FF';
  @State serialNum: ResourceStr = '12345454545445';
  @State version: ResourceStr = '10.0.0.1';
  @State deviceInfo?: CloudDeviceModel = undefined;

  aboutToAppear(): void {
    this.deviceInfo = router.getParams() as CloudDeviceModel;
  }

  @Builder
  listItemData($$: DevicesInfo) {
    Row() {
      Text($$.name)
        .listTextStyle($r('app.color.tips_button_backgroundColor'));
      Blank();
      Text($$.value)
        .listTextStyle();
    }.width(CommonConstants.FULL_WIDTH_PERCENT);
  }

  build() {
    Column() {
      NavBar({
        title: $r('app.string.device_info'),
        paddingLeft: $r('app.string.scan_tip_margin_top')
      });

      List() {
        ListItem() {
          this.listItemData({ name: $r('app.string.device_name'), value: this.deviceInfo?.name ?? this.deviceName });
        }.height($r('app.string.vp_50'));

        ListItem() {
          this.listItemData({ name: $r('app.string.factory'), value: this.factory });
        }.height($r('app.string.vp_50'));
      }.listStyle()
      .divider({ strokeWidth: $r('app.string.vp_1') });

      List() {
        ListItem() {
          this.listItemData({ name: $r('app.string.MAC_addr'), value: this.macAddr });
        }.height($r('app.string.vp_50'));

        ListItem() {
          this.listItemData({ name: $r('app.string.serial_number'), value: this.serialNum });
        }.height($r('app.string.vp_50'));
      }.listStyle()
      .divider({ strokeWidth: $r('app.string.vp_1') });

      Row() {
        Text($r('app.string.version'))
          .listTextStyle($r('app.color.tips_button_backgroundColor'));
        Blank();
        Text(this.version)
          .listTextStyle();
      }.listStyle()
      .height($r('app.string.tab_bar_height'));
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