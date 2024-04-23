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

import { BroadcastConstants } from '../constants/BroadcastConstants'
import { Broadcast } from '../common/Broadcast'
import { screenManager } from '../common/ScreenManager'
import { Constants } from '../constants/Constants';

@CustomDialog
export struct SaveImageDialog {
  @Consume broadCast: Broadcast
  @StorageLink('isHorizontal') isHorizontal: boolean = screenManager.isHorizontal();
  @StorageLink('isSidebar') isSidebar: boolean = screenManager.isSidebar();
  @StorageLink('leftBlank') leftBlank: number[] = [0, 0, 0, 0];
  controller?: CustomDialogController;

  controllerClose(): void {
    this.controllerCloseBindImpl()
  }

  private controllerCloseBindImpl(): void {
    this.controller?.close();
  }

  aboutToAppear(): void {
    this.broadCast.on(BroadcastConstants.EXIT_SAVE_PROGRESS_CLOSE, (): void => this.controllerCloseBindImpl());
  }

  build() {
    Column() {
      Row() {
        Text($r('app.string.edit_save_picture_text')).fontSize($r('sys.float.ohos_id_text_size_body1'))
          .flexGrow(1)
        LoadingProgress().width($r('app.float.image_save_dialog_loading_w'))
          .height($r('app.float.image_save_dialog_loading_h'))
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
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
    .padding({
      left: $r('app.float.dialog_content_margin'),
      right: $r('app.float.dialog_content_margin'),
      bottom: $r('app.float.dialog_content_margin'),
      top: $r('app.float.dialog_content_margin')
    })
  }
}