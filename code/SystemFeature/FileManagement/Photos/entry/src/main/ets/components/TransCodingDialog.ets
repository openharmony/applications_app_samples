/*
 * Copyright (c) 2024 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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

import { Log } from '../utils/Log';
import { DialogCallback } from '../utils/DialogUtil';
import { screenManager } from '../common/ScreenManager';
import { Constants } from '../constants/Constants';

const TAG: string = 'TransCodingDialog';
@CustomDialog
export struct TransCodingDialog {
  @StorageLink('isHorizontal') isHorizontal: boolean = screenManager.isHorizontal();
  @StorageLink('isSidebar') isSidebar: boolean = screenManager.isSidebar();
  @StorageLink('leftBlank') leftBlank: number[] = [0, 0, 0, 0];
  controller?: CustomDialogController ;
  @Consume renameFileName: string;
  @Consume dialogCallback: DialogCallback;
  @State isNull: boolean = false;
  @State dividerColor: Resource = $r('app.color.dialog_divider_h_color_182431');
  @State dividerWidth: string = '1vp';
  @State showProgressNum: number = 0;
  @State transCodingResult: boolean = false;
  @State fileUri: string = '';

  aboutToAppear(): void {
    Log.info(TAG, 'aboutToAppear');
  }

  build() {
    Column() {

      if(this.transCodingResult === true) {
        Column() {
          Text($r('app.string.action_transcoding_path')).fontSize(16)
          Text(`${this.fileUri}`).fontSize(16)
          Text($r('app.string.action_transcoding_success')).fontSize(30)
        }.justifyContent(FlexAlign.Center).padding($r('app.float.crop_vertical_padding'))
      }

      if(this.showProgressNum !== 0 && this.transCodingResult !== true) {
        Row() {
          Text($r('app.string.action_transcoding_progress')).fontSize(20)
          Text(`: ${this.showProgressNum}` + ' %').fontSize(20)
        }.justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)
      }

      Stack({ alignContent: Alignment.Top }) {
        Row() {
          Button() {
            Text($r('app.string.no'))
              .fontSize($r('sys.float.ohos_id_text_size_button1'))
              .fontColor($r('app.color.color_control_highlight'))
              .fontWeight(FontWeight.Medium)
              .width('50%')
              .textAlign(TextAlign.Center)
          }
          .margin({ right: $r('app.float.details_dialog_button_margin_right') })
          .backgroundColor($r('app.color.transparent'))
          .height($r('app.float.details_dialog_button_height'))
          .onClick((): void => {
            if (this.dialogCallback?.cancelCallback !== undefined) {
              this.dialogCallback.cancelCallback();
            };
            this.controller?.close();
          })

          Row() {
            Divider()
              .vertical(true)
              .height($r('app.float.dialog_divider_height'))
              .color($r('app.color.divider_vertical_color'))
          }.height($r('app.float.details_dialog_button_height'))
          .alignItems(VerticalAlign.Center)

          Button() {
            Text($r('app.string.action_transcoding'))
              .fontSize($r('sys.float.ohos_id_text_size_button1'))
              .fontColor($r('app.color.color_control_highlight'))
              .fontWeight(FontWeight.Medium)
              .width('50%')
              .textAlign(TextAlign.Center)
          }
          .enabled(!this.isNull)
          .opacity(this.isNull ? $r('app.float.disable_button_opacity') : 1)
          .margin({ right: $r('app.float.details_dialog_button_margin_left') })
          .backgroundColor($r('app.color.transparent'))
          .height($r('app.float.details_dialog_button_height'))
          .onClick((): void => {
            if (this.dialogCallback != null && this.dialogCallback.confirmCallback !== null) {
              const fileUri = (uri: string) => {
                this.fileUri = uri;
                Log.info(TAG, 'fileUri uri:' + uri);
              };
              const transCodingResult = (result: boolean) => {
                this.transCodingResult = result;
                Log.info(TAG, 'Transcoding Result:' + result);
              };
              const showProgressNum = (progress: number) => {
                this.showProgressNum = progress;
                Log.info(TAG, 'Progress:' + progress);
              };
              this.dialogCallback.confirmCallback(fileUri, transCodingResult, showProgressNum);
            }
          })
        }
      }
      .height($r('app.float.details_dialog_button_area_height'))
      .margin({
        left: $r('app.float.dialog_content_margin'), right: $r('app.float.dialog_content_margin')
      })
    }
    .alignItems(HorizontalAlign.Start)
    .borderRadius($r('app.float.dialog_border_radius'))
    .width(screenManager.getColumnsWidth(4))
    .backgroundColor($r('app.color.white'))
    .margin({
      right: $r('app.float.dialog_window_margin'),
      left: $r('app.float.dialog_window_margin'),
      bottom: this.isHorizontal || this.isSidebar ? 0 : Constants.DIALOG_BOTTOM_OFFSET + px2vp(this.leftBlank[3])
    })
  }
}
