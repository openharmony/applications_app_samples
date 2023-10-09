/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { BusinessError } from '@ohos.base';
import pasteboard from '@ohos.pasteboard';
import promptAction from '@ohos.promptAction';
import Logger from '../../utils/Logger';

@Component
export struct SecPasteButton {
  @Link pasteContent: string;
  @StorageLink('copyButtonFocused') copyButtonFocused: boolean = true;
  @State imageFocused: Resource = $r('app.media.paste1');
  @State backColorFocused: Resource = $r('app.color.button_default_bg_color1');
  @State textColorFocused: Resource = $r('app.color.button_default_bg_color');
  @State imageNormal: Resource = $r('app.media.paste');
  @State backColorNormal: Resource = $r('app.color.button_default_bg_color1');
  @State textColorNormal: Resource = $r('app.color.button_default_text_color');

  pastToMessage() {
    let systemPasteboard = pasteboard.getSystemPasteboard();
    systemPasteboard.getData().then((pasteData) => {
      let primaryText = pasteData.getPrimaryText();
      this.pasteContent = primaryText;
      if (!primaryText) {
        this.promptAction('Empty');
      }
      this.promptAction($r('app.string.Paste_succeed'));
      Logger.error('Succeed to get PasteData. primaryText' + primaryText);
    }).catch ((error: string) => {
      this.promptAction(error);
      Logger.info('promise, getCurrentLocation: error=' + JSON.stringify(error));
    });
  }

  promptAction(message: string | Resource) {
    try {
      promptAction.showToast({
        message: message,
        duration: 3000,
      });
    } catch (error) {
      let e: BusinessError = error as BusinessError;
      Logger.error(`showToast args error code is ${e.code}, message is ${e.message}`);
    }
  }

  build() {
    Column() {
      Row() {
        if (!this.copyButtonFocused) {
          PasteButton({
            icon:PasteIconStyle.LINES, text:PasteDescription.PASTE, buttonType:ButtonType.Capsule
          })
            .onClick(() => {
              this.copyButtonFocused = false;
              this.pastToMessage();
            })
            .backgroundColor(this.backColorFocused)
            .fontColor(this.textColorFocused)
        } else {
          PasteButton({
            icon:PasteIconStyle.LINES, text:PasteDescription.PASTE, buttonType:ButtonType.Capsule
          })
            .onClick(() => {
              this.copyButtonFocused = false;
              this.pastToMessage();
            })
            .backgroundColor(this.backColorNormal)
            .fontColor(this.textColorNormal)
        }
      }
    }
  }
}
