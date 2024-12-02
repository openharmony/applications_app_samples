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
import { screenManager } from '../common/ScreenManager';
import { Constants } from '../constants/Constants';
import { userFileModel } from '../base/UserFileModel';

const TAG: string = 'SelectSensitiveDialog';
@CustomDialog
export struct SelectSensitiveDialog {
  @StorageLink('isHorizontal') isHorizontal: boolean = screenManager.isHorizontal();
  @StorageLink('isSidebar') isSidebar: boolean = screenManager.isSidebar();
  @StorageLink('leftBlank') leftBlank: number[] = [0, 0, 0, 0];
  controller?: CustomDialogController ;
  @Consume uris: string[];

  aboutToAppear(): void {
  }

  getResolution(height: number, width: number): string {
    return width + 'x' + height;
  }
  hideSensitive(type: number): void {
    if (this.uris.length === 0) {
      Log.warn(TAG, 'uris is empty');
      return;
    } else {
      userFileModel.hideSensitives(type, this.uris);
    }
  }

  build() {
    Column() {
      Button() {
        Text($r('app.string.hide_location_and_shootingparam'))
          .fontSize($r('sys.float.ohos_id_text_size_button1'))
          .fontColor($r('app.color.color_control_highlight'))
          .width('100%')
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Medium)
      }
      .backgroundColor($r('app.color.transparent'))
      .height($r('app.float.details_dialog_button_height'))
      .onClick((): void => {
        this.hideSensitive(0);
        this.controller?.close();
      })

      Button() {
        Text($r('app.string.hide_location_only'))
          .fontSize($r('sys.float.ohos_id_text_size_button1'))
          .fontColor($r('app.color.color_control_highlight'))
          .width('100%')
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Medium)
      }
      .backgroundColor($r('app.color.transparent'))
      .height($r('app.float.details_dialog_button_height'))
      .onClick((): void => {
        this.hideSensitive(1);
        this.controller?.close();
      })

      Button() {
        Text($r('app.string.hide_shootingparam_only'))
          .fontSize($r('sys.float.ohos_id_text_size_button1'))
          .fontColor($r('app.color.color_control_highlight'))
          .width('100%')
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Medium)
      }
      .backgroundColor($r('app.color.transparent'))
      .height($r('app.float.details_dialog_button_height'))
      .onClick((): void => {
        this.hideSensitive(2);
        this.controller?.close();
      })

      Button() {
        Text($r('app.string.no_hide_sensitive_type'))
          .fontSize($r('sys.float.ohos_id_text_size_button1'))
          .fontColor($r('app.color.color_control_highlight'))
          .width('100%')
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Medium)
      }
      .backgroundColor($r('app.color.transparent'))
      .height($r('app.float.details_dialog_button_height'))
      .onClick((): void => {
        this.hideSensitive(3);
        this.controller?.close();
      })
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
