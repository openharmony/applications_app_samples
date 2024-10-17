/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import testNapi from 'libentry.so';

@Entry
@Component
struct Index {
  @State message: string = 'Native Notification Sample';
  @Provide('pageInfo') pageInfo: NavPathStack = new NavPathStack();
  @State result:Boolean = false;

  privacyDialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample({ result: $result }),
    autoCancel: false,
    alignment: DialogAlignment.Center,
    customStyle: false,
    backgroundColor: Color.White,
  });

  build() {
    Column() {
      Column() {
        Text(this.message)
          .fontSize(30)
          .fontWeight(700)
          .textAlign(TextAlign.Start)
          .margin({ top: 56, left:16, right: 16 })
      }
      .width('100%')
      .height(px2vp(280))
      .alignItems(HorizontalAlign.Start)

      Column() {
        Row() {
          Button('Check notification enabled')
            .layoutWeight(1)
            .fontSize(18)
            .onClick(() => {
              this.result = testNapi.isNotificationEnabled();
              this.privacyDialogController.open();
            })
            .margin({ left: 16, right: 16 })
        }
        .width('100%')
        .margin({bottom: 16})
      }
      .justifyContent(FlexAlign.End)
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.SpaceBetween)
  }
}

@CustomDialog
struct CustomDialogExample {
  @Link result: Boolean;

  controller?: CustomDialogController;
  cancel: () => void = () => {
  }
  confirm: () => void = () => {
  }

  build() {
    Column() {
      Text('Native Notification Sample')
        .fontSize(24)
        .fontWeight(700)
        .height(px2vp(100))
      Text('Current application notification enabled: ' + this.result)
        .fontSize(18)
        .fontWeight(400)
        .textAlign(TextAlign.Start)
        .margin({ left: px2vp(84), right: px2vp(84) })
        .width('90%')
      Button('OK', { buttonStyle: ButtonStyleMode.TEXTUAL, role: ButtonRole.NORMAL })
        .onClick(() => {
          if (this.controller != undefined) {
            this.controller.close();
          }
        })
        .stateEffect(false)
        .fontSize(18)
        .fontWeight(500)
        .margin(5)
    }
  }
}