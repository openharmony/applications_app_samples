/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { hilog } from '@kit.PerformanceAnalysisKit';
const DOMAIN = 0x0000;
// [Start dialog_interaction_use_constructor]
// [Start dialog_interaction_use_constructor_example]
@CustomDialog
struct CustomDialogExample {
  cancel: () => void = () => {
  }
  confirm: () => void = () => {
  }
  controller: CustomDialogController;

  build() {
    Column() {
      //$r('app.string.i_am_content')资源文件中的value为'我是内容'
      Text($r('app.string.i_am_content')).fontSize(20).margin({ top: 10, bottom: 10 })
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('cancel')
          .onClick(() => {
            this.controller.close();
            if (this.cancel) {
              this.cancel();
            }
          }).backgroundColor(0xffffff).fontColor(Color.Black)
        Button('confirm')
          .onClick(() => {
            this.controller.close();
            if (this.confirm) {
              this.confirm();
            }
          }).backgroundColor(0xffffff).fontColor(Color.Red)
      }.margin({ bottom: 10 })
    }
  }
}
// [End dialog_interaction_use_constructor_example]

// [Start dialog_interaction_use_constructor_user]
@Entry
@Component
export struct DialogInteractionUseConstructor {
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample({
      cancel: ()=> { this.onCancel() },
      confirm: ()=> { this.onAccept() },
    }),
  });

  onCancel() {
    hilog.info(DOMAIN, 'testTag', 'Callback when the first button is clicked');
  }

  onAccept() {
    hilog.info(DOMAIN, 'testTag', 'Callback when the second button is clicked');
  }

  build() {
    Column() {
      NavDestination() {
        Button('click me')
          .onClick(() => {
            this.dialogController.open();
          })
      }.width('100%').margin({ top: 5 })
    }
  }
}
// [End dialog_interaction_use_constructor_user]
// [End dialog_interaction_use_constructor]