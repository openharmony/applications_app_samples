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
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG: string = '[Sample_dialogproject]';
const DOMAIN: number = 0xFF00;

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
      Column() {
        Button('Open Toast')
          .height(100)
          .type(ButtonType.Capsule)
          .onClick(() => {
            try {
              this.promptAction.openToast({
                message: 'Toast Massage',
                duration: 10000,
              }).then((toastId: number) => {
                this.toastId = toastId;
              });
            } catch (error) {
              let message = (error as BusinessError).message;
              let code = (error as BusinessError).code;
              hilog.error(DOMAIN, TAG, '%{public}s', 'OpenToast error code is $\{code}, message is $\{message}');
            }
          })
        Blank().height(50);
        Button('Close Toast')
          .height(100)
          .type(ButtonType.Capsule)
          .onClick(() => {
            try {
              this.promptAction.closeToast(this.toastId);
            } catch (error) {
              let message = (error as BusinessError).message;
              let code = (error as BusinessError).code;
              hilog.error(DOMAIN, TAG, '%{public}s', 'CloseToast error code is $\{code}, message is $\{message}');
            }
          })
      }.height('100%').width('100%').justifyContent(FlexAlign.Center)
      // [StartExclude toast_openClose]
    }
    .backgroundColor('#f1f2f3')
    // 请将$r('app.string.OpenCloseToast_title')替换为实际资源文件，在本示例中该资源文件的value值为"显示关闭即时反馈"
    .title($r('app.string.OpenCloseToast_title'))
    // [EndExclude toast_openClose]
  }
}
// [End toast_openClose]