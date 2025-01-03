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

import { PromptActionClass } from '../../common/PromptActionClass';
import { ComponentContent } from '@kit.ArkUI';

@CustomDialog
struct CustomDialogExample {
  controller: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample({}),
  })

  build() {
    Column() {
      Text($r('app.string.CustomDialog_dialog'))
    }
    .padding({
      top: 24,
      left: 24,
      bottom: 24,
      right: 24
    })
  }
}

@Entry
@Component
export struct CreateDialog {
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample(),
  })

  build() {
    NavDestination() {
      Column({ space: 12 }) {

        Column() {
          Button('click me')
            .onClick(() => {
              this.dialogController.open();
            })
        }.width('100%').margin({ top: 5 })

      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.CustomDialog_create'))
  }
}