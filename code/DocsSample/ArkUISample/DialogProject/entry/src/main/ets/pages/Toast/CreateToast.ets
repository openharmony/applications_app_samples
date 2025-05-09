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

// [Start create_toast]
import { PromptAction } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
export struct CreateToastExample {
  private uiContext: UIContext = this.getUIContext();
  private promptAction: PromptAction = this.uiContext.getPromptAction();
  build() {
    NavDestination() {
      Column({ space: 12 }) {

        Column() {
          Button('Show toast').fontSize(20)
            .onClick(() => {
              try {
                this.promptAction.showToast({
                  message: 'Hello World',
                  duration: 2000
                });
              } catch (error) {
                let message = (error as BusinessError).message;
                let code = (error as BusinessError).code;
                console.error(`showToast args error code is ${code}, message is ${message}`);
              };
            })
        }.height('100%').width('100%').justifyContent(FlexAlign.Center)

      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.CreateToast_title'))
  }
}
// [End create_toast]