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
import common from '@ohos.app.ability.common';
import Logger from '../../utils/Logger';
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { SecPasteButton } from '../../common/Component/PasteButton';
import { CopyButton } from '../../common/Component/CopyButton';
import { TitleBar } from '../../common/Component/TitleBar';
import { IntroductionTitle } from '../../common/Component/IntroductionTitle';

@Extend(Column) function backgroundStyle() {
  .size({ width: '95%', height: 139 })
  .margin({ top: 5 })
  .padding(12)
  .borderRadius(24)
  .alignItems(HorizontalAlign.Start)
  .backgroundColor(Color.White)
}

@Entry
@Component
struct Paste {
  @State pasteContent: string = '';
  @State copyContent: string = '';

  promptAction(message: string) {
    try {
      promptAction.showToast({
        message: message,
        duration: 2000,
      });
    } catch (error) {
      Logger.error(`showToast args error code is ${error.code}, message is ${error.message}`);
    }
    ;
  }

  aboutToAppear() {
    let context: common.Context = getContext(this);
    try {
      context.resourceManager.getStringValue($r('app.string.Happy_every_day').id, (error, value) => {
        if (error != null) {
          console.log("error is " + error);
        } else {
          this.copyContent = value;
        }
      });
    } catch (error) {
      let e: BusinessError = error as BusinessError;
      Logger.error(`promise getStringByName failed, error code: ${e.code}, message: ${e.message}.`);
    }
  }

  build() {
    Column() {
      TitleBar({ title: $r('app.string.EntryAbility_label') })
        .id('backBtn')
        .onClick(() => {
          router.back();
        })
      IntroductionTitle({ introduction: $r('app.string.Copy_content') })
      Column() {
        TextInput({ text: this.copyContent })
          .backgroundColor(Color.White)
          .fontColor(Color.Black)
          .enableKeyboardOnFocus(false)
          .onChange((data => {
            this.copyContent = data;
          }))
      }
      .padding({ top: 5 })
      .size({ width: '95%', height: 139 })
      .margin({ top: 5 })
      .borderRadius(24)
      .alignItems(HorizontalAlign.Start)
      .backgroundColor(Color.White)

      IntroductionTitle({ introduction: $r('app.string.Paste_content') })
      Column() {
        Text(this.pasteContent)
          .fontColor(Color.Black)
      }
      .backgroundStyle()

      Column() {
        CopyButton({
          copyContent: $copyContent
        })
        SecPasteButton({
          pasteContent: $pasteContent,
        })
      }
      .layoutWeight(1)
      .padding(30)
      .justifyContent(FlexAlign.End)

    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}
