/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

@CustomDialog
export struct UpgradeDialog {
  private controller: CustomDialogController

  build() {
    Column() {
      Text($r('app.string.custom_dialog_title'))
        .padding(8)
        .fontSize(24)
      this.PermissionIntroduction($r('app.media.ic_custom_dialog_voice'), $r('app.string.custom_dialog_permission_microphone'), $r('app.string.custom_dialog_permission_microphone_info'))
      this.PermissionIntroduction($r('app.media.ic_custom_dialog_location'), $r('app.string.custom_dialog_permission_location'), $r('app.string.custom_dialog_permission_location_info'))
      Blank()
      Button($r('app.string.custom_dialog_start'))
        .height(40)
        .fontSize(24)
        .fontColor(Color.White)
        .margin({ left: 4, right: 4, top: 12 })
        .onClick(() => {
          this.controller.close()
        })
    }
    .margin(20)
    .height(380)
    .borderRadius(24)
    .padding({ top: 20, bottom: 32 })
    .backgroundColor($r('app.color.background_shallow_grey'))
  }

  @Builder PermissionIntroduction(image: Resource, permissionName: Resource, introduction: Resource) {
    Row() {
      Image(image)
        .width(50)
        .height(50)
        .margin({ left: 30, right: 30 })
      Column({ space: 4 }) {
        Text(permissionName)
          .fontSize(20)
        Text(introduction)
          .fontSize(18)
          .fontColor($r('app.color.font_color_shallow'))
          .constraintSize({ maxWidth: 280 })
      }
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .margin({ top: 20 })
  }
}