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
import { CloudDeviceModel } from '@ohos/connect_cloud/src/main/ets/components/connect/http/model/ProjectDeviceModel';
import { TipButton } from './TipButton';


/**
 * 主动弹出的需连接设备弹窗
 */
@CustomDialog
export struct ConnectDialog {
  /**
   * 设备相关信息
   */
  private deviceInfo?: CloudDeviceModel;
  /**
   * 提示弹出框控制器
   */
  private controller: CustomDialogController;

  build() {
    Column() {
      Image($r('app.media.scene_detail_tip'))
        .width($r('app.string.configure_device_image'))
        .height($r('app.string.configure_device_image'))
        .margin({ bottom: $r('app.string.device_item_ic_size'), top: $r('app.string.add_font_height') });

      Text(this.deviceInfo?.name ?? '')
        .fontSize($r('app.string.font_16'))
        .fontColor($r('app.color.font_color_E6000000'))
        .fontWeight(FontWeight.Regular)
        .width(CommonConstants.FULL_WIDTH_PERCENT)
        .textAlign(TextAlign.Center)
        .margin({ bottom: $r('app.string.device_item_ic_size') });

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        TipButton({
          btnStyle: {
            btnRes: $r('app.string.button_text_cancel'),
            backgroundColor: Color.White,
            fontColor: $r('app.color.add_text_color'),
          }
        });
        TipButton({
          btnStyle: {
            btnRes: $r('app.string.connect'),
          }
        });
      }.width(CommonConstants.FULL_WIDTH_PERCENT);
    }
    .width($r('app.string.delete_btn_width'))
    .height($r('app.string.connect_dialog_height'))
    .margin({ bottom: $r('app.string.wh_value_24') })
    .borderRadius($r('app.string.distance_24'))
    .backgroundColor(Color.White)
    .padding({ left: $r('app.string.distance_16'), right: $r('app.string.distance_16') });
  }
}