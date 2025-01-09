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
  cancel?: () => void;
  confirm?: () => void;
  controller: CustomDialogController;

  build() {
    Column() {
      Text('Please confirm your choice')
        .padding({ top: 24, right: 24, left: 24 })
      Row({ space: 8 }) {
        Button() {
          Text('refuse')
            .fontFamily('HarmonyHeiTi')
            .fontWeight(FontWeight.Medium)
            .fontSize($r('sys.float.Body_L'))
            .fontColor($r('sys.color.font_emphasize'))
            .lineHeight(21)
        }
        .onClick(() => {
          this.controller.close();
        })
        .layoutWeight(1)
        .backgroundColor(Color.Transparent)
        .width(180)
        .height(40)

        Button() {
          Text('confirm')
            .fontFamily('HarmonyHeiIi')
            .fontWeight(FontWeight.Medium)
            .fontSize($r('sys.float.Body_L'))
            .fontColor($r('sys.color.font_emphasize'))
        }
        .onClick(() => {
          this.controller.close();
        })
        .layoutWeight(1)
        .backgroundColor(Color.Transparent)
        .width(180)
        .height(40)
      }.padding({ top: 8, bottom: 16 })
    }.width(400)

  }
}

@Entry
@Component
export struct DialogInteraction {
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample({
      cancel: () => {
        this.onCancel();
      },
      confirm: () => {
        this.onAccept();
      },
    }),
  })

  onCancel() {
    console.info('Callback when the first button is clicked')
  }

  onAccept() {
    console.info('Callback when the second button is clicked')
  }

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
    .title($r('app.string.CustomDialog_interaction'))
  }
}