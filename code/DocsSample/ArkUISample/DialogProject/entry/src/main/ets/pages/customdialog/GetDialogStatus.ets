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
// [Start get_dialog_status]
// xxx.ets
@CustomDialog
struct CustomDialogExample {
  controller?: CustomDialogController;

  build() {
    Column() {
      //$r('app.string.closeDialog_by_dialog')资源文件中的value为'点我关闭弹窗：通过自定义组件自带的DialogController'
      Button($r('app.string.closeDialog_by_dialog'))
        .onClick(() => {
          if (this.getDialogController() !== undefined) {
            hilog.info(DOMAIN, 'testTag', 'state:' + this.getDialogController().getState())
          } else {
            hilog.info(DOMAIN, 'testTag', 'state: no exist')
          }
        }).margin(20)
      //$r('app.string.closeDialog_by_dialog_controller')资源文件中的value为'点击关闭弹窗：通过外部传递的DialogController'
      Button($r('app.string.closeDialog_by_dialog_controller'))
        .onClick(() => {
          hilog.info(DOMAIN, 'testTag', 'state:' + this.controller?.getState())
        }).margin(20)
      //$r('app.string.close_widows')资源文件中的value为'点我关闭弹窗'
      Button($r('app.string.close_widows'))
        .onClick(() => {
          if (this.getDialogController() !== undefined) {
            this.getDialogController().close()
          }
        }).margin(20)

    }
  }
}

@Entry
@Component
export struct GetDialogStatus {
  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: CustomDialogExample({
    }),
    autoCancel: false
  })

  build() {
    NavDestination() {
      Column() {
        Button('click me')
          .onClick(() => {
            if (this.dialogController !== null) {
              this.dialogController.open()
            }
          })
      }.width('100%').margin({ top: 5 })
    }
  }
}
// [End get_dialog_status]