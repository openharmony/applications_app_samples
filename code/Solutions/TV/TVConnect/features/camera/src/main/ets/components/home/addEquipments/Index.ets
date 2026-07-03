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
import { CommonConstants } from '@ohos/common';
import { HeadTitleNavBar } from '../HeadTitleNavBar';
import { ScanningDeviceList } from '../../../model/utils/CommitUtil';

@Component
export struct AddEquipments {
  succ: () => void = () => {
  };
  @State title: Resource = $r(`app.string.add_equipments`);
  @State isClose: boolean = true;
  @State isLeftIcon: string | Resource = '';
  @State scanningDeviceList: ScanningDeviceList[] = [
    new ScanningDeviceList('生产设备', 'plant', false),
    new ScanningDeviceList('生产设备', 'plant', false),
    new ScanningDeviceList('生产设备', 'plant', false),
    new ScanningDeviceList('生产设备', 'plant', false),
    new ScanningDeviceList('摄像头', 'camera', false)
  ];

  build() {
    Column() {
      HeadTitleNavBar({
        title: $title,
        isLeftIcon: $isLeftIcon,
        isClose: this.isClose,
        closeCallback: () => {
        }
      });

      Column() {
        Image($r('app.media.beScanning'))
          .width($r('app.string.modify_scene_icon_height'))
          .height($r('app.string.modify_scene_icon_height'));
      }.margin({ top: $r('app.string.p_40'), bottom: $r('app.string.p_44') });

      Column({ space: 12 }) {
        Text($r('app.string.scanning_pcl_devices'))
          .fontColor($r('app.color.text_color_3'))
          .fontSize($r('app.string.font_20'));
        Text($r('app.string.and_near_the_phone'))
          .fontColor($r('app.color.text_color_1'))
          .fontSize($r('app.string.font_14'));
      }.margin({ bottom: $r('app.string.p_24') });

      Column() {
        List() {
          ForEach(this.scanningDeviceList, (item: ScanningDeviceList) => {
            ListItem() {
              Row() {
                Row({ space: 16 }) {
                  Image($r('app.media.beScanning'))
                    .width($r('app.string.p_52'))
                    .height($r('app.string.p_52'));

                  Text(item.label || '')
                    .fontColor($r('app.color.text_color_2'))
                    .fontSize($r('app.string.font_16'));
                };

                Button($r('app.string.connect'))
                  .fontColor($r('app.color.btn_text_color'))
                  .fontSize($r('app.string.font_14'))
                  .width(72)
                  .height(28)
                  .backgroundColor($r('app.color.btn_text_bg'))
                  .onClick(() => this.succ());
              }
              .width(CommonConstants.FULL_WIDTH_PERCENT)
              .height(84)
              .borderRadius(16)
              .backgroundColor($r('app.color.equipment_img_bg'))
              .justifyContent(FlexAlign.SpaceBetween)
              .padding({ left: $r('app.string.p_12'), right: $r('app.string.p_12') });
            }.padding({ left: $r('app.string.p_12'), right: $r('app.string.p_12'), bottom: $r('app.string.p_12') });
          });
        }.height('180vp');
      }.layoutWeight(1);

      Row({ space: 12 }) {
        Button($r('app.string.manually_add')).width($r('app.string.btn_width'))
          .height($r('app.string.btn_height'))
          .backgroundColor($r('app.color.btn_text_bg'))
          .fontColor($r('app.color.btn_text_color'));

        Button($r('app.string.scan_code_addition')).width($r('app.string.btn_width'))
          .height($r('app.string.btn_height'))
          .backgroundColor($r('app.color.btn_text_bg'))
          .fontColor($r('app.color.btn_text_color'));

      }.margin({ bottom: $r('app.string.p_12') });

    }.width(CommonConstants.FULL_WIDTH_PERCENT)
    .layoutWeight(1);
  }
}