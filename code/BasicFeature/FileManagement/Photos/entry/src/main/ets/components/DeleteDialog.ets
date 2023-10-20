/*
 * Copyright (c) 2023 Shenzhen Kaihong Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { DialogCallback } from '../utils/DialogUtil';
import { Log } from '../utils/Log';
import { screenManager } from '../common/ScreenManager';
import { Constants } from '../constants/Constants';

@CustomDialog
export struct DeleteDialog {
  private TAG: string = 'DeleteDialog'
  @StorageLink('isHorizontal') isHorizontal: boolean = screenManager.isHorizontal();
  @StorageLink('isSidebar') isSidebar: boolean = screenManager.isSidebar();
  @StorageLink('leftBlank') leftBlank: number[] = [0, 0, 0, 0];
  @Consume dialogCallback: DialogCallback;
  @Consume dialogMessage: Resource;
  @Consume dialogDeleteMessage: Resource;
  controller?: CustomDialogController;

  aboutToAppear(): void {
  }

  build() {
    Column() {
      Stack({ alignContent: Alignment.Center }) {
        Text(this.dialogMessage)
          .fontSize($r('sys.float.ohos_id_text_size_body1'))
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
      }.width('100%')
      .margin({
        top: $r('app.float.dialog_content_margin'),
        bottom: $r('sys.float.ohos_id_text_paragraph_margin_s')
      })

      Stack({ alignContent: Alignment.Top }) {
        Row() {
          Button() {
            Text($r('app.string.dialog_cancel'))
              .fontSize($r('sys.float.ohos_id_text_size_button1'))
              .fontColor($r('app.color.color_control_highlight'))
              .fontWeight(FontWeight.Medium)
              .width('50%')
              .textAlign(TextAlign.Center)
          }
          .margin({
            left: $r('app.float.details_dialog_button_margin_left'),
            right: $r('app.float.details_dialog_button_margin_right')
          })
          .backgroundColor($r('app.color.transparent'))
          .height($r('app.float.details_dialog_button_height'))
          .onClick((): void => {
            Log.debug(this.TAG, 'cancelCallback');
            this.controller?.close();
            if (this.dialogCallback?.cancelCallback !== undefined) {
              this.dialogCallback.cancelCallback();
            };
          })

          Row() {
            Divider()
              .vertical(true)
              .height($r('app.float.dialog_divider_height'))
              .color($r('app.color.divider_vertical_color'))
          }
          .height($r('app.float.details_dialog_button_height'))
          .alignItems(VerticalAlign.Center)

          Button() {
            Text(this.dialogDeleteMessage)
              .fontSize($r('sys.float.ohos_id_text_size_button1'))
              .fontColor($r('sys.color.ohos_id_color_warning'))
              .fontWeight(FontWeight.Medium)
              .width('50%')
              .textAlign(TextAlign.Center)
          }.id('deleteConfirm')
          .margin({
            left: $r('app.float.details_dialog_button_margin_left'),
            right: $r('app.float.details_dialog_button_margin_right')
          })
          .backgroundColor($r('app.color.transparent'))
          .height($r('app.float.details_dialog_button_height'))
          .onClick((): void => {
            Log.debug(this.TAG, 'confirmCallback');
            this.controller?.close();
            if (this.dialogCallback?.confirmCallback !== null) {
              this.dialogCallback.confirmCallback();
            };
          })
        }
      }
      .width('100%')
      .height($r('app.float.details_dialog_button_area_height'))
    }
    .borderRadius($r('app.float.dialog_border_radius'))
    .width(screenManager.getColumnsWidth(4))
    .backgroundColor($r('app.color.white'))
    .margin({
      right: $r('app.float.dialog_window_margin'),
      left: $r('app.float.dialog_window_margin'),
      bottom: this.isHorizontal || this.isSidebar ? 0 : Constants.DIALOG_BOTTOM_OFFSET + px2vp(this.leftBlank[3])
    })
    .padding({ left: $r('app.float.dialog_content_margin'), right: $r('app.float.dialog_content_margin') })
    .alignItems(HorizontalAlign.Start)
  }
}
