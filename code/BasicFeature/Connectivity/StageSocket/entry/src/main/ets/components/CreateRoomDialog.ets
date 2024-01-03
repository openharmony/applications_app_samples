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
import Logger from '../utils/Logger';

const TAG: string = '[CreateRoomDialog]';

@CustomDialog
export struct CreateRoomDialog {
  controller: CustomDialogController;
  private title: Resource = $r('app.string.input_room');
  @Link roomNumber: string; // 当前选择项的内容

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


      TextInput()
        .id('inputNumber')
        .backgroundColor($r('app.color.COLOR_FFFFFF'))
        .width('85%')
        .height(48)
        .maxLength(10)
        .borderRadius(0)
        .fontSize(16)
        .fontColor($r('app.color.COLOR_99000000'))
        .fontFamily($r('app.string.font_family_regular'))
        .padding(0)
        .onChange((inputs: string) => {
          this.roomNumber = inputs;
        })

      Divider()
        .vertical(false)
        .strokeWidth(1)
        .width('85%')
        .color($r('app.color.COLOR_33000000'))

      Row() {
        Row(){
          Text($r('app.string.cancel'))
            .fontSize(16)
            .fontColor($r('app.color.COLOR_007DFF'))
            .fontFamily($r('app.string.font_family'))
            .textAlign(TextAlign.Center)

        }
        .height('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          this.controller.close();
        });


        Divider()
          .vertical(true)
          .strokeWidth(1)
          .height(24)
          .color('#33000000')

        Row(){
          Text($r('app.string.confirm'))
            .id('roomConfirm')
            .fontSize(16)
            .fontColor($r('app.color.COLOR_007DFF'))
            .fontFamily($r('app.string.font_family'))
            .textAlign(TextAlign.Center)
        }
        .layoutWeight(1)
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          Logger.info(TAG, `onClick begin: ${this.roomNumber}`);
          AppStorage.set('sendMsg', 'invitationNumber&' + this.roomNumber);
          AppStorage.set('sendMsg', 'clear');
          this.controller.close();
        });

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