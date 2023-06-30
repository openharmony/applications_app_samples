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

import { ButtonDialogBuilder } from '../pages/picker';

@Entry
@Component
struct Index {
  @State shareLinkResource: Resource = $r('app.string.share_button');
  private shareDialog: CustomDialogController;

  homeBtn() {
    this.shareDialog = new CustomDialogController({
      builder: ButtonDialogBuilder({
        controller: this.shareDialog
      }),
      cancel: undefined,
      autoCancel: true,
      alignment: DialogAlignment.Bottom,
      customStyle: true
    });
    this.shareDialog.open();
  }

  build() {
    Row() {
      Column() {
        Button() {
          Text(this.shareLinkResource)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
        }
        .id('share')
        .width('60%')
        .height('6%')
        .margin({ bottom: $r('app.float.fontSize_eighteen') })
        .onClick(() => {
          this.homeBtn();
        })
      }
      .width('100%')
    }
    .height('100%')
  }
}