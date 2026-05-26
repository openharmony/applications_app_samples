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
import { TipButton } from '../view/TipButton';
import { CloudDeviceModel } from '@ohos/connect_cloud';
import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';

@HMRouter({ pageUrl: 'AboutDevicePage' })
@Component
export struct AboutDevicePage {
  @State deviceInfo?: CloudDeviceModel = undefined;
  //临时数据，获取到实际数据后需删除
  private deviceName: ResourceStr = '隧道控制器';

  aboutToAppear(): void {
    this.deviceInfo = HMRouterMgr.getCurrentParam() as CloudDeviceModel;
  }

  pushNamedRoute(name: string) {
    HMRouterMgr.push({ pageUrl: name, param: this.deviceInfo });
  }

  build() {
    Column() {
      NavBar({ title: $r('app.string.about_device'), paddingLeft: $r('app.string.scan_tip_margin_top') });
      Row() {
        Text($r('app.string.device_alias_name')).listTextStyle();
        Blank();
        TextInput({ placeholder: '', text: this.deviceInfo?.name ?? this.deviceName })
          .cancelButton({
            style: CancelButtonStyle.INPUT,
            icon: {
              size: $r('app.string.wh_value_24'),
              src: $r('app.media.ic_public_edit'),
            }
          })
          .textAlign(TextAlign.End)
          .textInputFancy()
          .onChange((value: string) => {
            this.deviceName = value;
          });
      }.listStyle()
      .height($r('app.string.tab_bar_height'));

      List() {
        ListItem() {
          Row() {
            Text($r('app.string.device_info')).listTextStyle();
            Blank();
            Image($r('app.media.ic_arrow_right'))
              .width($r('app.string.vp_12')).height($r('app.string.wh_value_24'));
          }.width(CommonConstants.FULL_WIDTH_PERCENT);
        }.height($r('app.string.vp_50'))
        .onClick(() => {
          this.pushNamedRoute('DeviceInfoPage');
        });

        ListItem() {
          Row() {
            Text($r('app.string.device_net_info')).listTextStyle();
            Blank();
            Image($r('app.media.ic_arrow_right'))
              .width($r('app.string.vp_12')).height($r('app.string.wh_value_24'));
          }.width(CommonConstants.FULL_WIDTH_PERCENT);
        }.height($r('app.string.vp_50'))
        .onClick(() => {
          this.pushNamedRoute('DeviceNetInfoPage');
        });
      }.listStyle()
      .divider({ strokeWidth: $r('app.string.vp_1') });

      Row() {
        Text($r('app.string.relate_scenery_info')).listTextStyle();
        Blank();
        Image($r('app.media.ic_arrow_right'))
          .width($r('app.string.vp_12')).height($r('app.string.wh_value_24'));
      }.listStyle()
      .height($r('app.string.tab_bar_height'));

      Blank();
      TipButton({
        btnStyle: {
          btnRes: $r('app.string.delete_device'),
          fontColor: $r('app.color.delete_color_fff33232'),
          backgroundColor: $r('app.color.add_button_backgroundColor'),
          width: $r('app.string.delete_btn_width'),
          height: $r('app.string.wh_value_48'),
          clickEvent: () => {
            HMRouterMgr.pop();
          }
        }
      });
    }
    .width(CommonConstants.FULL_WIDTH_PERCENT)
    .height(CommonConstants.FULL_HEIGHT_PERCENT)
    .padding({ left: $r('app.string.scan_tip_margin_top'), right: $r('app.string.scan_tip_margin_top') })
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
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
function listTextStyle() {
  .fontSize($r('app.string.font_16'))
  .fontColor($r('app.color.font_color_E6000000'))
  .fontWeight(FontWeight.Medium);
}

@Extend(TextInput)
function textInputFancy() {
  .placeholderColor(Color.Grey)
  .backgroundColor($r('app.color.white'))
  .placeholderFont({ size: $r('app.string.font_16'), weight: FontWeight.Medium })
  .fontSize($r('app.string.font_16'))
  .fontColor($r('app.color.font_color_E6000000'))
  .layoutWeight(1);
}