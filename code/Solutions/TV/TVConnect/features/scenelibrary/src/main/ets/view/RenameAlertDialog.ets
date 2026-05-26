/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
import { CommonConstants } from '@ohos/common/src/main/ets/constants/CommonConstants';
import { KeyCode } from '@ohos.multimodalInput.keyCode';

@CustomDialog
export default struct RenameAlertDialog {
  onConfirm: Function = () => {
  };
  controller: CustomDialogController = new CustomDialogController({
    builder: this
  });
  @Link name: string;

  build() {
    Column() {
      Text($r('app.string.rename_scene_name'))
        .fontSize($r('app.string.font_16'))
        .fontWeight(FontWeight.Medium)
        .width(CommonConstants.FULL_WIDTH_PERCENT);

      Row() {
        TextInput({ placeholder: '我是提示文本', text: this.name })
          .fontSize($r('app.string.font_16'))
          .maxLength(12)
          .backgroundColor(Color.Transparent)
          .padding(0)
          .onChange((value: string) => {
            this.name = value;
          })
          .onKeyEvent((event) => {
            if (event.type == KeyType.Down) {
              if (event.keyCode == KeyCode.KEYCODE_DPAD_DOWN) {
                focusControl.requestFocus('confirm');
              }
            }
          });
      }
      .borderStyle({ bottom: BorderStyle.Solid })
      .borderWidth({ bottom: 1 })
      .borderColor({ bottom: $r('app.color.dialog_bottom_color') })
      .margin({ bottom: $r('app.string.dialog_padding_bottom'), top: $r('app.string.dialog_padding_top') });

      Row() {
        Text($r('app.string.button_text_cancel'))
          .fontColor($r('app.color.button_text_color'))
          .fontSize($r('app.string.font_16'))
          .fontWeight(FontWeight.Medium)
          .onClick(() => {
            this.controller.close();
          });

        Divider().vertical(true)
          .color($r('app.color.dialog_divider_color'))
          .height($r('app.string.dialog_divider_height'));

        Column() {
          Text($r('app.string.button_text_confirm'))
            .fontColor($r('app.color.button_text_confirm_color'))
            .fontSize($r('app.string.font_16'))
            .fontWeight(FontWeight.Medium)
            .onClick(() => {
              this.onConfirm();
              this.controller.close();
            });
        }
        .key('confirm')
        .defaultFocus(true);
      }.justifyContent(FlexAlign.SpaceAround)
      .width(CommonConstants.FULL_WIDTH_PERCENT);
    }.padding($r('app.string.dialog_padding_bottom'));
  }
}