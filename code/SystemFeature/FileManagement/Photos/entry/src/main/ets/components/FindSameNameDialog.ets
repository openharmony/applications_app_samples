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

import photoAccessHelper from '@ohos.file.photoAccessHelper';
import { DialogCallback } from '../utils/DialogUtil';
import { Log } from '../utils/Log';
import { DateUtil } from '../utils/DateUtil';
import { FindSameOperation } from '../menus/ProcessMenuOperation';
import { screenManager } from '../common/ScreenManager';
import { Constants } from '../constants/Constants';

@Observed
export class FindSameNameParam {
  sourceFileAsset: photoAccessHelper.PhotoAsset | null = null;
  targetFileAsset: photoAccessHelper.PhotoAsset | null = null;
  replaceFunc: Function | null = null;
  skipFunc: Function | null = null;
  cancelFunc: Function | null = null;
  singlePhoto: boolean = false;
  doSameFunc: Function | null = null;
}

@CustomDialog
export struct FindSameNameDialog {
  private TAG: string = 'FindSameNameDialog'
  @StorageLink('isHorizontal') isHorizontal: boolean = screenManager.isHorizontal();
  @StorageLink('isSidebar') isSidebar: boolean = screenManager.isSidebar();
  @StorageLink('leftBlank') leftBlank: number[] = [0, 0, 0, 0];
  @State isDoSameAction: boolean = false;
  @Consume dialogCallback: DialogCallback;
  @Consume dialogMessage: Resource;
  @Consume findSameNameParam: FindSameNameParam;
  sourceDetails: photoAccessHelper.PhotoAsset | null = null;
  targetDetails: photoAccessHelper.PhotoAsset | null = null;
  controller?: CustomDialogController;
  dataTime: string = '';
  targetDataTime: string = '';
  timeConvert = 1000;

  getTitle(name: string): string {
    Log.info(this.TAG, 'getTitle ' + name);
    if (name != null) {
      let index: number = name.lastIndexOf('.');
      if (index === -1) {
        return name;
      }
      return name.substr(0, index);
    } else {
      return '';
    }
  }

  aboutToAppear(): void {
    this.sourceDetails = this.findSameNameParam.sourceFileAsset;
    this.targetDetails = this.findSameNameParam.targetFileAsset;
    try{
      this.dataTime = DateUtil.getDateTimeFormat(this.sourceDetails?.get(photoAccessHelper.PhotoKeys.DATE_MODIFIED.toString()) as number * this.timeConvert);
      this.targetDataTime = DateUtil.getDateTimeFormat(this.targetDetails?.get(photoAccessHelper.PhotoKeys.DATE_MODIFIED.toString()) as number * this.timeConvert);
    }catch (err){
    }
  }

  build() {
    Column() {
      Row() {
        Text($r('app.string.find_same_name'))
          .fontSize($r('sys.float.ohos_id_text_size_dialog_tittle'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
      }.alignItems(VerticalAlign.Center)
      .height($r('app.float.dialog_title_height'))

      Row() {
        Column() {
          if(this.sourceDetails !== null && this.sourceDetails !== undefined){
            Text($r('app.string.target_has_same_name', this.getTitle(this.sourceDetails.displayName)))
              .fontSize($r('sys.float.ohos_id_text_size_sub_title2'))
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.ohos_id_color_text_primary'))
              .maxLines(3)
          }
        }
      }.margin({
        bottom: $r('app.float.same_name_date_title_dialog_bottom') })

      Row() {
        Column() {
          Text($r('app.string.source_file_location'))
            .fontSize($r('sys.float.ohos_id_text_size_sub_title2'))
            .fontWeight(FontWeight.Medium)
            .fontColor($r('sys.color.ohos_id_color_text_primary'))
        }
      }.margin({
        bottom: $r('app.float.same_name_date_title2_dialog_bottom') })

      Row() {
        Column() {
          //TODO
          //Text($r('app.string.file_size_location', (this.sourceDetails.size / Constants.BYTE_TO_MB).toFixed(2) + 'MB'))
          Text($r('app.string.file_size_location', 'unknown MB'))
            .fontSize($r('sys.float.ohos_id_text_size_sub_title2'))
            .fontWeight(FontWeight.Regular)
            .fontColor($r('sys.color.ohos_id_color_text_primary'))
        }
      }.margin({
        bottom: $r('app.float.same_name_date_title3_dialog_bottom') })

      Row() {
        Column() {
          Text($r('app.string.file_time_location', this.dataTime))
            .fontSize($r('sys.float.ohos_id_text_size_body2'))
            .fontWeight(FontWeight.Regular)
            .fontColor($r('sys.color.ohos_id_color_text_secondary'))
        }
      }.margin({
        bottom: $r('app.float.same_name_date_title_dialog_bottom') })

      Row() {
        Column() {
          Text($r('app.string.target_file_location'))
            .fontSize($r('sys.float.ohos_id_text_size_sub_title2'))
            .fontWeight(FontWeight.Medium)
            .fontColor($r('sys.color.ohos_id_color_text_primary'))
        }
      }.margin({
        bottom: $r('app.float.same_name_date_title2_dialog_bottom') })

      Row() {
        Column() {
          //TODO
          Text($r('app.string.file_size_location', 'xx MB'))
            .fontSize($r('sys.float.ohos_id_text_size_sub_title2'))
            .fontWeight(FontWeight.Regular)
            .fontColor($r('sys.color.ohos_id_color_text_primary'))
        }
      }.margin({
        bottom: $r('app.float.same_name_date_title3_dialog_bottom') })

      Row() {
        Column() {
          Text($r('app.string.file_time_location', this.targetDataTime))
            .fontSize($r('sys.float.ohos_id_text_size_body2'))
            .fontWeight(FontWeight.Regular)
            .fontColor($r('sys.color.ohos_id_color_text_secondary'))
        }
      }.margin({
        bottom: $r('app.float.same_name_date_title_dialog_bottom') })

      Row() {
        Image(this.isDoSameAction ? $r('app.media.ic_gallery_public_checkbox_filled')
                      : $r('app.media.ic_checkbox_off_black_bg'))
          .height($r('app.float.icon_size'))
          .width($r('app.float.icon_size'))
          .margin({
            right: $r('app.float.details_dialog_button_margin_right') })
          .onClick((): void => {
            this.isDoSameAction = !this.isDoSameAction
          })

        Text($r('app.string.do_same_action'))
          .fontSize($r('sys.float.ohos_id_text_size_sub_title2'))
          .fontFamily($r('app.string.id_text_font_family_regular'))
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
      }
      .visibility(this.findSameNameParam.singlePhoto ? Visibility.None : Visibility.Visible)
      .margin({
        bottom: $r('app.float.same_name_date_dialog_bottom') })

      Stack({ alignContent: Alignment.Top }) {
        Row() {
          Button() {
            Text($r('app.string.replace_action'))
              .fontSize($r('sys.float.ohos_id_text_size_button1'))
              .fontColor($r('app.color.color_control_highlight'))
              .width(this.findSameNameParam.singlePhoto ? '50%' : Constants.PERCENT_ONE_THIRD)
              .textAlign(TextAlign.Center)
              .fontWeight(FontWeight.Medium)
          }
          .margin({
            left: $r('app.float.details_dialog_button_margin_left'),
            right: $r('app.float.details_dialog_button_margin_right')
          })
          .backgroundColor($r('app.color.transparent'))
          .height($r('app.float.details_dialog_button_height'))
          .onClick((): void => {
            Log.debug(this.TAG, 'replaceCallback');
            if (this.isDoSameAction && this.findSameNameParam.doSameFunc != null) {
              this.findSameNameParam.doSameFunc(FindSameOperation.REPLACE);
            }
            if(this.findSameNameParam.replaceFunc != null) this.findSameNameParam.replaceFunc();
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

          if (!this.findSameNameParam.singlePhoto) {
            Button() {
              Text($r('app.string.skip_action'))
                .fontSize($r('sys.float.ohos_id_text_size_button1'))
                .fontColor($r('app.color.color_control_highlight'))
                .width(Constants.PERCENT_ONE_THIRD)
                .textAlign(TextAlign.Center)
                .fontWeight(FontWeight.Medium)
            }
            .margin({
              left: $r('app.float.details_dialog_button_margin_left'),
              right: $r('app.float.details_dialog_button_margin_right')
            })
            .backgroundColor($r('app.color.transparent'))
            .height($r('app.float.details_dialog_button_height'))
            .onClick((): void => {
              Log.debug(this.TAG, 'skipCallback');
              if (this.isDoSameAction && this.findSameNameParam.doSameFunc != null) {
                this.findSameNameParam.doSameFunc(FindSameOperation.SKIP);
              }
              if(this.findSameNameParam.skipFunc != null) this.findSameNameParam.skipFunc();
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
          }

          Button() {
            Text($r('app.string.dialog_cancel'))
              .fontSize($r('sys.float.ohos_id_text_size_button1'))
              .fontColor($r('app.color.color_control_highlight'))
              .width(this.findSameNameParam.singlePhoto ? '50%' : Constants.PERCENT_ONE_THIRD)
              .textAlign(TextAlign.Center)
              .fontWeight(FontWeight.Medium)
          }
          .margin({
            left: $r('app.float.details_dialog_button_margin_left'),
            right: $r('app.float.details_dialog_button_margin_right')
          })
          .backgroundColor($r('app.color.transparent'))
          .height($r('app.float.details_dialog_button_height'))
          .onClick((): void => {
            Log.debug(this.TAG, 'cancelFunc');
            if(this.findSameNameParam.cancelFunc != null) this.findSameNameParam.cancelFunc();
            this.controller?.close();
          })
        }
      }
      .width('100%')
      .height($r('app.float.details_dialog_button_area_height'))
    }
    .padding({ left: $r('app.float.dialog_content_margin'), right: $r('app.float.dialog_content_margin') })
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
