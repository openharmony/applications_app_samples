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

// [Start create_custom_dialog_1]
@CustomDialog
struct CustomDialogExample {
  controller: CustomDialogController;

  build() {
    Column() {
      Text($r('app.string.i_am_content'))
        .fontSize(20)
    }.height(60).justifyContent(FlexAlign.Center)
  }
}

@Entry
@Component
export struct CreateCustomDialog1 {
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample(),
  })

  build() {
    // [StartExclude create_custom_dialog_1]
    NavDestination() {
      // [EndExclude create_custom_dialog_1]
      Column() {
        Button('click me')
          .onClick(() => {
            this.dialogController.open();
          })
      }.width('100%').margin({ top: 5 })
      // [StartExclude create_custom_dialog_1]
    }
    // [EndExclude create_custom_dialog_1]
  }
}
// [End create_custom_dialog_1]
