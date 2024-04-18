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

import { Broadcast } from '../common/Broadcast'
import { screenManager } from '../common/ScreenManager'
import { BroadcastConstants } from '../constants/BroadcastConstants'
import { Constants } from '../constants/Constants';
import { DateUtil } from '../utils/DateUtil';


@Observed
export class SaveDialogCallback {
  saveAsNewCallback: Function | null = null;
  replaceOriginalCallback: Function | null = null;
}

@CustomDialog
export struct SaveDialog {
  @StorageLink('isHorizontal') isHorizontal: boolean = screenManager.isHorizontal();
  @StorageLink('isSidebar') isSidebar: boolean = screenManager.isSidebar();
  @StorageLink('leftBlank') leftBlank: number[] = [0, 0, 0, 0];
  @Consume broadCast: Broadcast;
  @Consume saveDialogCallback: SaveDialogCallback;
  controller?: CustomDialogController;

  build() {
    Column() {
      Text($r('app.string.save_dialog_title_text')).fontSize($r('sys.float.ohos_id_text_size_headline7'))
        .fontColor($r('sys.color.ohos_id_color_text_primary')).fontWeight(FontWeight.Medium)
        .height($r('app.float.title_default'))
      Text($r('app.string.save_dialog_context_text')).fontSize($r('sys.float.ohos_id_text_size_body1'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .margin({ bottom: $r('app.float.adjust_text_padding_bottom_isVertical') })
      if (DateUtil.getLocales() === 'zh-CN') {
        Stack({ alignContent: Alignment.Top }) {
          Row() {
            Column() {
              Button() {
                Text($r('app.string.save_dialog_cancel_text'))
                  .fontColor($r('app.color.color_control_highlight'))
                  .fontSize($r('sys.float.ohos_id_text_size_button1'))
                  .fontWeight(FontWeight.Medium)
              }
              .height($r('app.float.details_dialog_button_height'))
              .width('100%')
              .onClick((): void => {
                this.controller?.close();
              }).backgroundColor($r('app.color.transparent'))
            }
            .width(Constants.PERCENT_ONE_THIRD)
            .padding({ right: $r('app.float.details_dialog_button_margin_right') })


            Row() {
              Divider()
                .vertical(true)
                .height($r('app.float.dialog_divider_height'))
                .color($r('app.color.divider_vertical_color'))
            }
            .height($r('app.float.details_dialog_button_height'))
            .alignItems(VerticalAlign.Center)

            Column() {
              Button() {
                Text($r('app.string.save_dialog_overwrite_text'))
                  .fontColor($r('app.color.color_control_highlight'))
                  .fontSize($r('sys.float.ohos_id_text_size_button1'))
                  .fontWeight(FontWeight.Medium)
              }
              .height($r('app.float.details_dialog_button_height'))
              .width('100%')
              .onClick((): void => {
                this.broadCast.emit(BroadcastConstants.SHOW_EDIT_SAVE_PROGRESS_DIALOG, []);
                this.controller?.close();
                if (this.saveDialogCallback != null && this.saveDialogCallback.replaceOriginalCallback !== null) {
                  this.saveDialogCallback.replaceOriginalCallback();
                }
              }).backgroundColor($r('app.color.transparent'))
            }.width(Constants.PERCENT_ONE_THIRD)
            .padding({
              left: $r('app.float.details_dialog_button_margin_left'),
              right: $r('app.float.details_dialog_button_margin_right')
            })

            Row() {
              Divider()
                .vertical(true)
                .height($r('app.float.dialog_divider_height'))
                .color($r('app.color.divider_vertical_color'))
            }
            .height($r('app.float.details_dialog_button_height'))
            .alignItems(VerticalAlign.Center)

            Column() {
              Button() {
                Text($r('app.string.save_dialog_save_text'))
                  .fontColor($r('app.color.color_control_highlight'))
                  .fontSize($r('sys.float.ohos_id_text_size_button1'))
                  .fontWeight(FontWeight.Medium)
              }
              .height($r('app.float.details_dialog_button_height'))
              .width('100%')
              .onClick((): void => {
                this.controller?.close();
                this.broadCast.emit(BroadcastConstants.SHOW_EDIT_SAVE_PROGRESS_DIALOG, []);
                if (this.saveDialogCallback != null && this.saveDialogCallback.saveAsNewCallback !== null) {
                  this.saveDialogCallback.saveAsNewCallback();
                }
              }).backgroundColor($r('app.color.transparent'))
            }
            .width(Constants.PERCENT_ONE_THIRD)
            .padding({ left: $r('app.float.details_dialog_button_margin_left') })
          }
        }
        .width('100%')
        .height($r('app.float.details_dialog_button_area_height'))
      } else {
        Flex({
          direction: FlexDirection.Column,
          justifyContent: FlexAlign.Center,
          alignItems: ItemAlign.Center,
        }) {
          Button() {
            Text($r('app.string.save_dialog_save_text'))
              .fontColor($r('app.color.color_control_highlight'))
              .fontSize($r('sys.float.ohos_id_text_size_button1'))
              .fontWeight(FontWeight.Medium)
          }
          .height($r('app.float.details_dialog_button_height'))
          .margin({ bottom: $r('app.float.adjust_text_margin_bottom') })
          .onClick((): void => {
            this.controller?.close();
            this.broadCast.emit(BroadcastConstants.SHOW_EDIT_SAVE_PROGRESS_DIALOG, []);
            if (this.saveDialogCallback != null && this.saveDialogCallback.saveAsNewCallback !== null) {
              this.saveDialogCallback.saveAsNewCallback();
            }
          }).backgroundColor($r('app.color.transparent'))

          Button() {
            Text($r('app.string.save_dialog_overwrite_text'))
              .fontColor($r('app.color.color_control_highlight'))
              .fontSize($r('sys.float.ohos_id_text_size_button1'))
              .fontWeight(FontWeight.Medium)
          }
          .height($r('app.float.details_dialog_button_height'))
          .margin({ bottom: $r('app.float.adjust_text_margin_bottom') })
          .onClick((): void => {
            this.broadCast.emit(BroadcastConstants.SHOW_EDIT_SAVE_PROGRESS_DIALOG, []);
            this.controller?.close();
            if (this.saveDialogCallback?.replaceOriginalCallback != null) {
              this.saveDialogCallback.replaceOriginalCallback();
            }
          }).backgroundColor($r('app.color.transparent'))

          Button() {
            Text($r('app.string.save_dialog_cancel_text'))
              .fontColor($r('app.color.color_control_highlight'))
              .fontSize($r('sys.float.ohos_id_text_size_button1'))
              .fontWeight(FontWeight.Medium)
          }
          .height($r('app.float.details_dialog_button_height'))
          .margin({ bottom: $r('app.float.adjust_text_padding_bottom_isVertical') })
          .onClick((): void => {
            this.controller?.close();
          }).backgroundColor($r('app.color.transparent'))
        }
        .height($r('app.float.save_dialog_height'))
        .width('100%')
      }

    }
    .alignItems(HorizontalAlign.Start)
    .width(screenManager.getColumnsWidth(4))
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.float.dialog_border_radius'))
    .margin({
      right: $r('app.float.dialog_window_margin'),
      left: $r('app.float.dialog_window_margin'),
      bottom: this.isHorizontal || this.isSidebar ? 0 : Constants.DIALOG_BOTTOM_OFFSET + px2vp(this.leftBlank[3])
    })
    .padding({ left: $r('app.float.dialog_content_margin'), right: $r('app.float.dialog_content_margin') })
  }
}
