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

// [Start create_custom_dialog_new]
// [Start create_custom_dialog_new_customDialog_controller_default]
@CustomDialog
struct CustomDialogExample {
  controller: CustomDialogController;

  build() {
    Column() {
      //$r('app.string.i_am_content')资源文件中的value为'我是内容'
      Text($r('app.string.i_am_content'))
        .fontSize(20)
    }.height(60).justifyContent(FlexAlign.Center)
  }
}
// [End create_custom_dialog_new_customDialog_controller_default]

// [Start create_custom_dialog_new_customDialog_controller_on_click]
// [Start create_custom_dialog_new_customDialog_controller_constructor]
@Entry
@Component
export struct CreateCustomDialogNew {
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample(),
  })
  // [StartExclude create_custom_dialog_new_customDialog_controller_constructor]
  build() {
    NavDestination() {
      Column() {
        Button('click me')
          .onClick(() => {
            this.dialogController.open();
          })
      }.width('100%').margin({ top: 5 })
    }
  }
  // [EndExclude create_custom_dialog_new_customDialog_controller_constructor]
}
// [End create_custom_dialog_new_customDialog_controller_constructor]
// [End create_custom_dialog_new_customDialog_controller_on_click]
// [End create_custom_dialog_new]
