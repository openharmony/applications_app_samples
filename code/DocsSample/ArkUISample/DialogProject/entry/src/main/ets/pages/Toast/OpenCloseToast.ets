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
// [Start toast_openClose]
import { PromptAction } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
export struct OpenCloseToastExample {
  @State toastId: number = 0;
  private uiContext: UIContext = this.getUIContext();
  private promptAction: PromptAction = this.uiContext.getPromptAction();

  build() {
    // [StartExclude toast_openClose]
    NavDestination() {
      // [EndExclude toast_openClose]
      Column({ space: 12 }) {
        Column() {
          Button('Open Toast')
            .height(100)
            .onClick(() => {
              this.promptAction.openToast({
                message: 'Toast Massage',
                duration: 10000,
              }).then((toastId: number) => {
                this.toastId = toastId;
              });
            })
          Blank().height(50);
          Button('Close Toast')
            .height(100)
            .onClick(() => {
              this.promptAction.closeToast(this.toastId);
            })
        }.height('100%').width('100%').justifyContent(FlexAlign.Center)
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
      // [StartExclude toast_openClose]
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.OpenCloseToast_title'))
    // [EndExclude toast_openClose]
  }
}
// [End toast_openClose]