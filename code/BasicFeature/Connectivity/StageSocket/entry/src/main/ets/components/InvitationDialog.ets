/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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

import router from '@ohos.router';
import { SocketType } from '../model/Socket';

const TAG: string = '[InvitationDialog]';

@CustomDialog
export struct InvitationDialog {
  controller: CustomDialogController;
  private title: Resource = $r('app.string.invitation');
  private userId: number = 0;
  private socketType?: SocketType;
  @Link invitation: Resource;

  build() {
    Column() {
      Row() {
        Text(this.title)
          .fontSize(20)
          .fontColor($r('app.color.COLOR_E6000000'))
          .fontFamily($r('app.string.font_family'))
          .textAlign(TextAlign.Center)
          .margin({ top: 14, bottom: 24 })
      }
      .width('85%')
      .justifyContent(FlexAlign.Start)

      Row() {
        Text(this.invitation)
          .fontSize(16)
          .fontColor($r('app.color.COLOR_E6000000'))
          .fontFamily($r('app.string.font_family'))
          .textAlign(TextAlign.Center)
          .margin({ top: 14, bottom: 24 })
      }
      .width('85%')
      .justifyContent(FlexAlign.Start)

      Row() {
        Text($r('app.string.cancel'))
          .fontSize(16)
          .fontColor($r('app.color.COLOR_007DFF'))
          .fontFamily($r('app.string.font_family'))
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.controller.close();
          });

        Divider()
          .vertical(true)
          .strokeWidth(1)
          .height(24)
          .color($r('app.color.COLOR_33000000'))

        Text($r('app.string.confirm'))
          .fontSize(16)
          .fontColor($r('app.color.COLOR_007DFF'))
          .fontFamily($r('app.string.font_family'))
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            AppStorage.setOrCreate('sendMsg', 'ok');
            router.pushUrl({
              url: 'pages/NewIndex',
              params: {
                'userId': this.userId,
                'socketType': this.socketType
              }
            });
          })
      }
      .alignItems(VerticalAlign.Center)
      .height(56)
      .width('85%')
    }
    .alignItems(HorizontalAlign.Center)
    .width('100%')
    .height(176)
    .borderRadius(24)
    .backgroundColor($r('app.color.COLOR_FFFFFF'))
  }
}