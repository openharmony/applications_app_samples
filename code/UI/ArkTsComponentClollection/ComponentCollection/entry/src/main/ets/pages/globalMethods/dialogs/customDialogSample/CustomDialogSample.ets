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

import { IntroductionTitle } from '../../../../common/IntroductionTitle'
import { TitleBar } from '../../../../common/TitleBar'
import { UpgradeDialog } from './CustomDialog'

@Extend(Row) function rowStyle () {
  .width('100%')
  .borderRadius(24)
  .margin({ top: 8, bottom: 8 })
  .justifyContent(FlexAlign.SpaceBetween)
}

@Entry
@Component
struct CustomDialogSample {
  private autoCloseDialog: CustomDialogController = new CustomDialogController({
    builder: UpgradeDialog(),
    autoCancel: true
  })
  private manualCloseDialog: CustomDialogController = new CustomDialogController({
    builder: UpgradeDialog(),
    autoCancel: false
  })
  private topDialog: CustomDialogController = new CustomDialogController({
    builder: UpgradeDialog(),
    alignment: DialogAlignment.Top
  })
  private centerDialog: CustomDialogController = new CustomDialogController({
    builder: UpgradeDialog(),
    alignment: DialogAlignment.Center
  })
  private bottomDialog: CustomDialogController = new CustomDialogController({
    builder: UpgradeDialog(),
    alignment: DialogAlignment.Bottom
  })
  private leftDialog: CustomDialogController = new CustomDialogController({
    builder: UpgradeDialog(),
    offset: { dx: -20, dy: -150 }
  })
  private rightDialog: CustomDialogController = new CustomDialogController({
    builder: UpgradeDialog(),
    offset: { dx: 20, dy: 150 }
  })
  private customDialog: CustomDialogController = new CustomDialogController({
    builder: UpgradeDialog(),
    customStyle: true,
    alignment: DialogAlignment.Bottom,
  })
  private unCustomDialog: CustomDialogController = new CustomDialogController({
    builder: UpgradeDialog(),
    customStyle: false,
    alignment: DialogAlignment.Bottom,
  })

  build() {
    Column() {
      TitleBar({ title: $r('app.string.custom_dialog') })
      Scroll() {
        Column() {
          IntroductionTitle({ introduction: $r('app.string.alert_dialog_auto_cancel') })
          Row() {
            this.DialogButton($r('app.string.alert_dialog_true'), this.autoCloseDialog)
            this.DialogButton($r('app.string.alert_dialog_false'), this.manualCloseDialog)
          }
          .rowStyle()

          IntroductionTitle({ introduction: $r('app.string.alert_dialog_location') })
          Row() {
            this.DialogButton($r('app.string.alert_dialog_top'), this.topDialog)
            this.DialogButton($r('app.string.alert_dialog_center'), this.centerDialog)
            this.DialogButton($r('app.string.alert_dialog_bottom'), this.bottomDialog)
          }
          .rowStyle()

          IntroductionTitle({ introduction: $r('app.string.alert_dialog_offset') })
          Row() {
            this.DialogButton($r('app.string.alert_dialog_left'), this.leftDialog)
            this.DialogButton($r('app.string.alert_dialog_right'), this.rightDialog)
          }
          .rowStyle()

          IntroductionTitle({ introduction: $r('app.string.custom_dialog_style_custom') })
          Row() {
            this.DialogButton($r('app.string.custom_dialog_style_custom_true'), this.customDialog)
            this.DialogButton($r('app.string.custom_dialog_style_custom_false'), this.unCustomDialog)
          }
          .rowStyle()
        }
        .constraintSize({ minHeight: '100%' })
      }
    }
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }

  @Builder DialogButton(dialogName: Resource, dialog: CustomDialogController) {
    Button(dialogName)
      .margin(8)
      .fontSize(16)
      .layoutWeight(1)
      .fontColor($r('app.color.background_blue'))
      .backgroundColor($r('app.color.background_grey'))
      .padding({ left: 12, right: 12, top: 8, bottom: 8 })
      .onClick(() => {
        dialog.open()
      })
  }
}