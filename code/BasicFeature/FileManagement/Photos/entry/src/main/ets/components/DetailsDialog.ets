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

import MediaLib from '@ohos.multimedia.mediaLibrary';
import { Log } from '../utils/Log';
import { DateUtil } from '../utils/DateUtil';
import { screenManager } from '../common/ScreenManager';
import { Constants } from '../constants/Constants';

@Observed
export class MediaDetails {
  mediaType: number = 0;
  height: number = 0;
  width: number = 0;
  size: number = 0;
  path: string = '';
  duration: number = 0;
  title: string = '';
  dateTaken: number = 0;
  dateAdded: number = 0;
  uri: string = '';
  displayName: string = '';
  dateModified: number = 0;
}

@CustomDialog
export struct DetailsDialog {
  private TAG: string = 'DetailsDialog'
  @StorageLink('isHorizontal') isHorizontal: boolean = screenManager.isHorizontal();
  @StorageLink('isSidebar') isSidebar: boolean = screenManager.isSidebar();
  @StorageLink('leftBlank') leftBlank: number[] = [0, 0, 0, 0];
  sizeConvert = 1024;
  controller?: CustomDialogController ;
  dataTime: string = '';
  @Consume mediaDetails: MediaDetails;

  aboutToAppear(): void {
    let localizedDate = DateUtil.getLocalizedDate(this.mediaDetails.dateAdded);
    let localizedTime = DateUtil.getLocalizedTime(this.mediaDetails.dateAdded);
    this.dataTime = localizedDate + ' ' + localizedTime;
  }

  getResolution(height: number, width: number): string {
    return width + 'x' + height;
  }

  getTitle(): string {
    Log.info(this.TAG, 'getTitle');
    if (this.mediaDetails.title != null) {
      return this.mediaDetails.title;
    }
    let index = this.mediaDetails.displayName.lastIndexOf('.');
    return this.mediaDetails.displayName.substr(0, index);
  }

  getDisplayPath(): string {
    let showPath = this.mediaDetails.path.toString() + this.mediaDetails.displayName.toString();
    return showPath;
  }

  getSize(size: number): string {
    if (size / (this.sizeConvert * this.sizeConvert) > 1) {
      return (size / (this.sizeConvert * this.sizeConvert)).toFixed(2) + 'MB';
    } else {
      return (size / this.sizeConvert).toFixed(2) + 'KB';
    }
  }

  build() {
    Column() {
      Row() {
        Text($r('app.string.details'))
          .fontSize($r('sys.float.ohos_id_text_size_headline7'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
      }.alignItems(VerticalAlign.Center)
      .height($r('app.float.dialog_title_height'))

      Row() {
        Column() {
          Text($r('app.string.title'))
            .fontSize($r('sys.float.ohos_id_text_size_body2'))
            .fontFamily($r('app.string.id_text_font_family_regular'))
            .fontColor($r('sys.color.ohos_id_color_text_primary'))
        }

        Column() {
          Text(this.getTitle())
            .fontSize($r('sys.float.ohos_id_text_size_body2'))
            .fontFamily($r('app.string.id_text_font_family_regular'))
            .fontColor($r('sys.color.ohos_id_color_text_secondary'))
            .maxLines(Constants.DETAILS_DIALOG_NAME_MAX_LINE)
            .padding({ right: $r('app.float.dialog_content_margin') })
        }
      }.alignItems(VerticalAlign.Top)
      .margin({ bottom: $r('sys.float.ohos_id_text_paragraph_margin_s') })

      Row() {
        Column() {
          Text($r('app.string.time'))
            .fontSize($r('sys.float.ohos_id_text_size_body2'))
            .fontFamily($r('app.string.id_text_font_family_regular'))
            .fontColor($r('sys.color.ohos_id_color_text_primary'))
        }

        Column() {
          Text(this.dataTime)
            .fontSize($r('sys.float.ohos_id_text_size_body2'))
            .fontFamily($r('app.string.id_text_font_family_regular'))
            .fontColor($r('sys.color.ohos_id_color_text_secondary'))
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
      }.margin({
        bottom: $r('sys.float.ohos_id_text_paragraph_margin_s') })

      Row() {
        Column() {
          Text($r('app.string.size'))
            .fontSize($r('sys.float.ohos_id_text_size_body2'))
            .fontFamily($r('app.string.id_text_font_family_regular'))
            .fontColor($r('sys.color.ohos_id_color_text_primary'))
        }

        Column() {
          Text(this.getSize(this.mediaDetails.size).toString())
            .fontSize($r('sys.float.ohos_id_text_size_body2'))
            .fontFamily($r('app.string.id_text_font_family_regular'))
            .fontColor($r('sys.color.ohos_id_color_text_secondary'))
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
      }.margin({
        bottom: $r('sys.float.ohos_id_text_paragraph_margin_s') })

      Row() {
        Column() {
          Text($r('app.string.resolution'))
            .fontSize($r('sys.float.ohos_id_text_size_body2'))
            .fontFamily($r('app.string.id_text_font_family_regular'))
            .fontColor($r('sys.color.ohos_id_color_text_primary'))
        }

        Column() {
          Text(this.getResolution(this.mediaDetails.height, this.mediaDetails.width))
            .fontSize($r('sys.float.ohos_id_text_size_body2'))
            .fontFamily($r('app.string.id_text_font_family_regular'))
            .fontColor($r('sys.color.ohos_id_color_text_secondary'))
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
      }.margin({
        bottom: $r('sys.float.ohos_id_text_paragraph_margin_s') })

      if (this.mediaDetails.mediaType === MediaLib.MediaType.VIDEO) {
        Row() {
          Column() {
            Text($r('app.string.duration'))
              .fontSize($r('sys.float.ohos_id_text_size_body2'))
              .fontFamily($r('app.string.id_text_font_family_regular'))
              .fontColor($r('sys.color.ohos_id_color_text_primary'))
          }

          Column() {
            Text(DateUtil.getFormattedDuration(this.mediaDetails.duration))
              .fontSize($r('sys.float.ohos_id_text_size_body2'))
              .fontFamily($r('app.string.id_text_font_family_regular'))
              .fontColor($r('sys.color.ohos_id_color_text_secondary'))
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
        }.margin({
          bottom: $r('sys.float.ohos_id_text_paragraph_margin_s') })
      }

      Stack({ alignContent: Alignment.Top }) {
        Button() {
          Text($r('app.string.detail_dialog_confirm'))
            .fontSize($r('sys.float.ohos_id_text_size_button1'))
            .fontColor($r('app.color.color_control_highlight'))
            .width('100%')
            .textAlign(TextAlign.Center)
            .fontWeight(FontWeight.Medium)
        }
        .backgroundColor($r('app.color.transparent'))
        .height($r('app.float.details_dialog_button_height'))
        .onClick((): void => {
          this.controller?.close();
        })
      }.width('100%')
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
