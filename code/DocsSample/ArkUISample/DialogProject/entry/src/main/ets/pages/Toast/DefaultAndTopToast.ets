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

import {promptAction} from '@kit.ArkUI';

@Entry
@Component
export struct DefaultAndTopToastExample {
  private uiContext: UIContext = this.getUIContext();

  build() {
    NavDestination() {
      Column({ space: 10 }) {
        TextInput()
        Column() {
          Button() {
            Text('DEFAULT Toast')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)

          }
          .height(100)
          .width('100%')
          .onClick(() => {
            promptAction.showToast({
              message: 'ok,I am DEFAULT toast',
              duration: 2000,
              showMode: promptAction.ToastShowMode.DEFAULT,
              bottom: 80
            })
          })
          Blank().height(200);
          Button() {
            Text('TOPMOST Toast')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)

          }
          .height(100)
          .width('100%')
          .onClick(() => {
            promptAction.showToast({
              message: 'ok,I am TOP_MOST toast',
              duration: 2000,
              showMode: promptAction.ToastShowMode.TOP_MOST,
              bottom: 85
            })
          })
        }.height('100%').width('100%').justifyContent(FlexAlign.Center)
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
  }
}
