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

import pasteboard from '@ohos.pasteboard';
import promptAction from '@ohos.promptAction';
import { AuthorizedButton } from './AuthorizedButton';
import Logger from "../../utils/Logger";

@Component
export struct CopyButton {
  @Link copyContent: string;
  @State copyButtonText: Resource = $r('app.string.Copy');
  @StorageLink('copyButtonFocused') copyButtonFocused: boolean = true;
  @State imageFocused: Resource = $r('app.media.copy');
  @State backColorFocused: Resource = $r('app.color.button_default_bg_color');
  @State textColorFocused: Resource = $r('app.color.background_shallow_grey');
  @State imageNormal: Resource = $r('app.media.copy1');
  @State backColorNormal: Resource = $r('app.color.button_default_text_color');
  @State textColorNormal: Resource = $r('app.color.button_default_bg_color1');

  promptAction(message: string | Resource) {
    try {
      promptAction.showToast({
        message: message,
        duration: 3000,
      });
    } catch (error) {
      Logger.error(`showToast args error code is ${error.code}, message is ${error.message}`);
    }
  }

  build() {
    Column() {
      Row() {
        if (this.copyButtonFocused) {
          AuthorizedButton({
            title: this.copyButtonText,
            image: $imageFocused,
            backColor: $backColorFocused,
            textColor: $textColorFocused,
          })
        } else {
          AuthorizedButton({
            title: this.copyButtonText,
            image: $imageNormal,
            backColor: $backColorNormal,
            textColor: $textColorNormal,
          })
        }
      }
      .id('copyButton')
      .onClick(() => {
        this.copyButtonFocused = true;
        let systemPasteboard = pasteboard.getSystemPasteboard();
        let pasteData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, this.copyContent);
        systemPasteboard = pasteboard.getSystemPasteboard();
        systemPasteboard.setData(pasteData).then(async () => {
          this.promptAction($r('app.string.Copy_succeed'));
          Logger.info('Succeeded in setting PasteData.');
        });
      })
    }
  }
}