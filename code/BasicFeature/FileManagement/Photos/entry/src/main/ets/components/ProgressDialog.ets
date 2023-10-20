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

import { MediaOperationType } from '../models/MediaOperationType'
import { screenManager } from '../common/ScreenManager';
import { Constants } from '../constants/Constants';

@Observed
export class ProgressParam {
  cancelFunc: Function | null = null;
  operationType: string = '';
}

@CustomDialog
export struct ProgressDialog {
  @StorageLink('isHorizontal') isHorizontal: boolean = screenManager.isHorizontal();
  @StorageLink('isSidebar') isSidebar: boolean = screenManager.isSidebar();
  @StorageLink('leftBlank') leftBlank: number[] = [0, 0, 0, 0];
  controller?: CustomDialogController;
  @Consume progressMessage: Resource;
  @Consume deleteProgress: number;
  @Consume progressParam: ProgressParam;

  build() {
    Column() {
      Row() {
        Text(this.progressMessage)
          .fontSize($r('sys.float.ohos_id_text_size_body2'))
          .fontFamily($r('app.string.id_text_font_family_regular'))
          .flexGrow(1)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        Text('' + this.deleteProgress + '%')
          .fontSize($r('sys.float.ohos_id_text_size_body2'))
          .fontFamily($r('app.string.id_text_font_family_regular'))
          .fontColor($r('sys.color.ohos_id_color_text_secondary'))
          .margin({
            left: $r('app.float.process_bar_margin_left'),
            right: $r('app.float.process_bar_margin_right'),
          })
      }
      .width('100%')

      Row() {
        Progress({ value: 0, total: Constants.PROGRESS_MAX, style: ProgressStyle.Linear })
          .value(this.deleteProgress)
          .color($r('app.color.color_control_highlight'))
          .width(screenManager.getColumnsWidth(4) - Constants.PROGRESS_LENGTH_DIFF)
          .margin({
            right: $r('app.float.progress_padding_right')
          })
        if (this.progressParam.operationType != MediaOperationType.Delete &&
        this.progressParam.operationType != MediaOperationType.Recover) {
          Image($r('app.media.ic_progress_cancel'))
            .width($r('app.float.icon_size'))
            .height($r('app.float.icon_size'))
            .onClick((): void => {
              if (this.progressParam !== undefined && this.progressParam.cancelFunc !== null) {
                this.progressParam.cancelFunc();
              }

            })
        }
      }
      .width('100%')
      .margin({ top: $r('app.float.id_icon_margin_horizontal') })
    }
    .padding({
      left: $r('app.float.max_padding_start'),
      right: $r('app.float.max_padding_end'),
      top: $r('app.float.max_padding_start'),
      bottom: $r('app.float.max_padding_end'),
    })
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
