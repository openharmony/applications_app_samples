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

// [Start toast_showDefaultAndTop]
import {promptAction} from '@kit.ArkUI';

@Entry
@Component
export struct DefaultAndTopToastExample {
  build() {
    // [StartExclude toast_showDefaultAndTop]
    NavDestination() {
      // [EndExclude toast_showDefaultAndTop]
      Column({ space: 10 }) {
        TextInput()
        Button() {
          Text($r('app.string.DefaultAndTopToast_defaultToast'))
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
        }
        .height('100')
        .width('100%')
        .onClick(() => {
          this.getUIContext().getPromptAction().showToast({
            message: $r('app.string.DefaultAndTopToast_defaultToastMessage'),
            duration: 2000,
            showMode: promptAction.ToastShowMode.DEFAULT,
            bottom: 80
          });
        })

        Blank().height(200);
        Button() {
          Text($r('app.string.DefaultAndTopToast_topToast'))
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
        }
        .height('100')
        .width('100%')
        .onClick(() => {
          this.getUIContext().getPromptAction().showToast({
            message: $r('app.string.DefaultAndTopToast_topToastMessage'),
            duration: 2000,
            showMode: promptAction.ToastShowMode.TOP_MOST,
            bottom: 85
          });
        })
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
      // [StartExclude toast_showDefaultAndTop]
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.DefaultAndTopToast_title'))
    // [EndExclude toast_showDefaultAndTop]
  }
}
// [End toast_showDefaultAndTop]
