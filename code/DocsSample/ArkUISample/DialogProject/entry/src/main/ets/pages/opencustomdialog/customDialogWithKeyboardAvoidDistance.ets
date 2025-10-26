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

// [Start custom_dialog_with_key_board_distance]
import { BusinessError } from '@kit.BasicServicesKit';
import { LengthMetrics } from '@kit.ArkUI'
import resource from '../../common/resource';
import { hilog } from '@kit.PerformanceAnalysisKit';
const DOMAIN = 0x0000;

@Entry
@Component
export struct customDialogWithKeyboardAvoidDistance {
  @Builder
  customDialogComponent() {
    Column() {
      Text('keyboardAvoidDistance: 0vp')
        .fontSize(20)
        .margin({ bottom: 36 })
      TextInput({ placeholder: '' })
    }.backgroundColor('#FFF0F0F0')
  }

  build() {
    // [StartExclude custom_dialog_with_key_board_distance]
    NavDestination() {
      // [EndExclude custom_dialog_with_key_board_distance]
      Row() {
        Row({ space: 20 }) {
          Text($r('app.string.open_windows'))
            .fontSize(30)
            .onClick(() => {
              this.getUIContext().getPromptAction().openCustomDialog({
                builder: () => {
                  this.customDialogComponent()
                },
                alignment: DialogAlignment.Bottom,
                keyboardAvoidMode: KeyboardAvoidMode.DEFAULT, // 软键盘弹出时，弹出框自动避让
                keyboardAvoidDistance: LengthMetrics.vp(0) // 软键盘弹出时与弹出框的距离为0vp
              }).catch((error: BusinessError) => {
                hilog.error(DOMAIN, 'testTag', `openCustomDialog error code is ${error.code}, message is ${error.message}`)
              })
            })
        }
        .width('100%')
      }
      .height('100%')
      // [StartExclude custom_dialog_with_key_board_distance]
    }
    // [EndExclude custom_dialog_with_key_board_distance]
  }
}
// [end custom_dialog_with_key_board_distance]