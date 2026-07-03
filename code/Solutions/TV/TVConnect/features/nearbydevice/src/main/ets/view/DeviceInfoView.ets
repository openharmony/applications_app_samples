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

import { AboutDevice } from './aboutDevice';

@Extend(ListItem)
function settingListItemFancy() {
  .width('100%')
  .borderRadius($r('app.string.radius_16'))
  .backgroundColor($r('app.color.default_component_color'))
  .padding($r('app.string.distance_4'));
}

@Extend(List)
function settingListItemDividerFancy() {
  .divider({
    strokeWidth: $r('app.string.divider_wh'),
    color: $r('sys.color.ohos_id_color_list_separator'),
    startMargin: $r('app.string.wh_value_48'),
    endMargin: $r('app.string.wh_value_8')
  });
}

@Component
export default struct DeviceInfoView {
  private listSpaces: string = '18lpx';
  @Prop manufacturerName: string | Resource;
  @Prop deviceType: string | Resource;
  @Prop deviceName: string | Resource;
  @Prop operatingSystemType: string | Resource;
  @Prop operatingSystemVersionNumber: string | Resource;

  build() {
    Column() {
      Text($r('app.string.equipment_information'))
        .width('100%')
        .textAlign(TextAlign.Start)
        .margin({
          left: $r('app.string.distance_11'),
          top: $r('app.string.distance_11'),
          bottom: $r('app.string.distance_11')
        });
      List({ space: this.listSpaces }) {
        ListItem() {
          List() {
            ListItem() {
              AboutDevice({
                deviceInfoName: $r('app.string.manufacturer_name_text'),
                deviceInfoValue: this.manufacturerName,
              });
            }.settingListItemFancy();

            ListItem() {
              AboutDevice({
                deviceInfoName: $r('app.string.device_type_text'),
                deviceInfoValue: this.deviceType,
              });
            }.settingListItemFancy();

            ListItem() {
              AboutDevice({
                deviceInfoName: $r('app.string.device_name_text'),
                deviceInfoValue: this.deviceName,
              });
            }.settingListItemFancy();

            ListItem() {
              AboutDevice({
                deviceInfoName: $r('app.string.operating_system_type_text'),
                deviceInfoValue: this.operatingSystemType,
              });
            }.settingListItemFancy();

            ListItem() {
              AboutDevice({
                deviceInfoName: $r('app.string.operating_system_version_number_text'),
                deviceInfoValue: this.operatingSystemVersionNumber,
              });
            }.settingListItemFancy();
          }
          .settingListItemDividerFancy();
        };
      }
      .width('95%')
      .divider({ strokeWidth: $r('app.string.divider_wh'), color: $r('sys.color.ohos_id_color_list_separator') })
      .padding({
        left: $r('sys.float.ohos_id_card_margin_start'),
        right: $r('sys.float.ohos_id_card_margin_start'),
        top: $r('app.string.distance_4'),
        bottom: $r('app.string.distance_4')
      })
      .borderRadius($r('app.string.distance_24'))
      .backgroundColor($r('app.color.default_component_color'));
    };
  }
}