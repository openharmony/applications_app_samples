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

import { Broadcast } from '../common/Broadcast';
import { Log } from '../utils/Log';
import { screenManager } from '../common/ScreenManager';
import { Constants } from '../constants/Constants';

@Observed
export class CancelParam {
  continueFunc: Function | null = null
  cancelFunc: Function | null = null
}

@CustomDialog
export struct CancelOperationDialog {
  private TAG: string = 'CancelOperationDialog'
  @StorageLink('isHorizontal') isHorizontal: boolean = screenManager.isHorizontal();
  @StorageLink('isSidebar') isSidebar: boolean = screenManager.isSidebar();
  @StorageLink('leftBlank') leftBlank: number[] = [0, 0, 0, 0];
  controller?: CustomDialogController;
  @Consume cancelMessage: Resource;
  @Consume broadCast: Broadcast;
  @Consume deleteProgress: number;
  @Consume cancelParam: CancelParam;

  build() {
    Column() {
      Text(this.cancelMessage)
        .fontSize($r('sys.float.ohos_id_text_size_body1'))
        .fontFamily($r('app.string.id_text_font_family_regular'))
        .flexGrow(1)
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .padding({
          bottom: 8
        })

      Stack({ alignContent: Alignment.Top }) {
        Row() {
          Button() {
            Text($r('app.string.continue'))
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
            Log.info(this.TAG, 'click continue')
            if (this.cancelParam?.continueFunc !== null) {
              this.cancelParam.continueFunc();
            }
            this.controller?.close();
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
            Text($r('app.string.stop'))
              .fontSize($r('sys.float.ohos_id_text_size_button1'))
              .fontColor(Color.Red)
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
            Log.info(this.TAG, 'click cancel')
            if (this.cancelParam?.cancelFunc !== null) {
              this.cancelParam.cancelFunc();
            }
            this.controller?.close();
          })
        }
      }
      .width('100%')
      .height($r('app.float.details_dialog_button_area_height'))
    }
    .padding({
      left: $r('app.float.max_padding_start'),
      right: $r('app.float.max_padding_end'),
      top: $r('app.float.max_padding_start'),
    })
    .alignItems(HorizontalAlign.Start)
    .border({ radius: $r('sys.float.ohos_id_corner_radius_default_l') })
    .backgroundColor($r('sys.color.ohos_id_color_dialog_bg'))
    .borderRadius($r('app.float.dialog_border_radius'))
    .width(screenManager.getColumnsWidth(4))
    .margin({
      right: $r('app.float.dialog_window_margin'),
      left: $r('app.float.dialog_window_margin'),
      bottom: this.isHorizontal || this.isSidebar ? 0 : Constants.DIALOG_BOTTOM_OFFSET + px2vp(this.leftBlank[3])
    })
  }
}
