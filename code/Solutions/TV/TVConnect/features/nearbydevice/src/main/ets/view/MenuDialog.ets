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
import { CommonConstants, Logger, PageViewUtils } from '@ohos/common';
import DeleteDeviceAlertDialog from './DeleteDeviceAlertDialog';

@CustomDialog
export default struct MenuDialog {
  @State focusId: string = '';
  @State selectedFontColor: string = '#dbd02727';
  @State unSelectedFontColor: string = '#db2e2ecd';
  @State unSelectedFontColor1: string = '#db2e2ecd';
  controller?: CustomDialogController;
  deviceId: string = '';
  setToppingindex: number = 0;
  deleteDevice: (devId: string) => void = () => {
  };
  setTopping: (index: number) => void = () => {
  };
  deleteController: CustomDialogController | null = new CustomDialogController({
    builder: DeleteDeviceAlertDialog({
      onConfirm: () => {
        Logger.info(this.deviceId);
        this.deleteDevice(this.deviceId);
      }
    })
  });

  build() {
    Column() {
      Row() {
        Text($r('app.string.Topping'))
          .fontColor($r('app.color.button_text_color'))
          .fontSize($r('app.string.font_16'))
          .fontWeight(FontWeight.Medium)
          .onClick(() => {
            this.setTopping(this.setToppingindex);
          })
          .focusable(true);
        Divider().vertical(true)
          .color($r('app.color.dialog_divider_color'))
          .height($r('app.string.dialog_divider_height'));

        Text($r('app.string.delete'))
          .fontColor('#E84026')
          .fontSize($r('app.string.font_16'))
          .fontWeight(FontWeight.Medium)
          .onClick(() => {
            this.controller?.close();
            if (this.deleteController != null) {
              this.deleteController.open();
            }
          })
          .focusable(true)
          .defaultFocus(true);
      }.justifyContent(FlexAlign.SpaceAround)
      .width(CommonConstants.FULL_WIDTH_PERCENT);
    }.padding($r('app.string.wh_value_24'));
  }
}