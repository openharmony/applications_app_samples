/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import promptAction from '@ohos.promptAction';
import Logger from '../utils/Logger';
import pasteboard from '@ohos.pasteboard';
import Constants from '../utils/Constants';

@Component
export struct PasteControl {
  @Link isSelectionMenuHidden: boolean;
  @Link textInputValue: string;

  @Builder
  CopyButton() {
    Text($r('app.string.copy'))
      .fontSize($r('app.integer.layout_size_16'))
      .fontColor(Color.Black)
      .onClick(() => {
        this.isSelectionMenuHidden = false;
        this.copyMessage();
      })
  }

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

  copyMessage() {
    let systemPasteboard = pasteboard.getSystemPasteboard();
    let pasteData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, this.textInputValue);
    systemPasteboard = pasteboard.getSystemPasteboard();
    systemPasteboard.setData(pasteData).then(async () => {
      this.promptAction($r('app.string.copy_succeed'));
      Logger.info('Succeeded in setting PasteData.');
    });
  }

  pastToMessage() {
    let systemPasteboard = pasteboard.getSystemPasteboard();
    systemPasteboard.getData().then((pasteData) => {
      let primaryText = pasteData.getPrimaryText();
      let currentInputValue: string = this.textInputValue;
      if (!primaryText) {
        this.promptAction('Empty');
      }
      this.textInputValue = currentInputValue + primaryText;
      this.promptAction($r('app.string.paste_succeed'));
      Logger.error('Succeed to get PasteData. primaryText' + primaryText);
    }).catch((error: string) => {
      this.promptAction(error);
      Logger.info('promise, getCurrentLocation: error=' + JSON.stringify(error));
    });
  }

  build() {
    Row() {
      this.CopyButton()
      PasteButton()
        .fontSize($r('app.integer.layout_size_16'))
        .fontColor(Color.Black)
        .backgroundColor(Color.White)
        .padding(0)
        .onClick(() => {
          this.isSelectionMenuHidden = false;
          this.pastToMessage();
        })
    }
    .width($r('app.integer.layout_size_120'))
    .justifyContent(FlexAlign.SpaceAround)
    .padding({
      left: $r('app.integer.layout_size_20'),
      right: $r('app.integer.layout_size_20'),
      top: $r('app.integer.layout_size_10'),
      bottom: $r('app.integer.layout_size_10')
    })
    .borderRadius($r('app.integer.layout_size_20'))
    .backgroundColor(Color.White)
    .border({
      width: Constants.BORDERWIDTH,
      color: $r('app.color.border_color')
    })
    .position({ x: $r('app.integer.layout_size_60'), y: -50 })
  }
}