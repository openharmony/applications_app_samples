/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import { CustomDialogExample } from './CustomDialogExample';

// 右上角+号按钮的ID
const ID_ADD_BUTTON: string = "addBtn";
// 点击右上角+号按钮，弹出的弹窗的X轴偏移量
const DIALOG_CONTROLLER_OFFSET_X: number = -15;
// 点击右上角+号按钮，弹出的弹窗的Y轴偏移量
const DIALOG_CONTROLLER_OFFSET_Y: number = 110;
// 点击右上角+号按钮，弹窗弹出后，点击遮罩区域，弹窗能否自动消失
const DIALOG_CONTROLLER_AUTO_CANCEL: boolean = true;
// 点击右上角+号按钮，弹出的弹窗容器样式是否自定义
const DIALOG_CONTROLLER_CUSTOM_STYLE: boolean = true;

@Component
export struct TopBar {
  @State num: number = 0
  // 自定义点击右上角+号按钮时弹出的弹窗
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample({}),
    autoCancel: DIALOG_CONTROLLER_AUTO_CANCEL,
    alignment: DialogAlignment.TopEnd,
    offset: {
      dx: DIALOG_CONTROLLER_OFFSET_X,
      dy: DIALOG_CONTROLLER_OFFSET_Y
    },
    customStyle: DIALOG_CONTROLLER_CUSTOM_STYLE
  })

  build() {
    Stack({ alignContent: Alignment.End }) {
      Text($r('app.string.chat'))
        .fontSize($r('app.integer.top_bar_font_size'))
        .fontColor($r('app.color.top_bar_font_color'))
        .fontWeight(FontWeight.Bold)
        .height($r('app.integer.top_bar_text_height'))
        .width($r('app.string.layout_100'))
        .padding({left: $r('app.integer.top_bar_text_padding_left')})
        .textAlign(TextAlign.Start)
        .foregroundColor('#182431')

      Stack() {
        Image($r('app.media.ic_public_add_filled'))
          .height($r('app.integer.top_bar_add_button_image_height'))
          .width($r('app.integer.top_bar_add_button_image_width'))
      }
      .id(ID_ADD_BUTTON)
      .height($r('app.integer.top_bar_height'))
      .width($r('app.integer.top_bar_add_button_width'))
      .padding({
        right: $r('app.integer.top_bar_add_button_padding_right')
      })
      .onClick(() => {
        this.dialogController.open()
      })
    }
    .backgroundColor($r('app.color.top_bar_background_color'))
    .height($r('app.integer.top_bar_height'))
    .width($r('app.string.layout_100'))
  }
}