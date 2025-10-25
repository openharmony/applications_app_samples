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
// [Start AchieveAlertDialogPage2]
import { AlertDialog } from '@kit.ArkUI';
import { webview } from '@kit.ArkWeb';
import hilog from '@ohos.hilog';
const TAG = '[Sample_ShowWebPageDialog]';
const DOMAIN = 0xF811;
const BUNDLE = 'ShowWebPageDialog_';

@Entry
@Component
struct AlertDialogPage {
  @State message: string = 'Hello World';
  @State title: string = 'Hello World';
  @State subtitle: string = '';
  @State result: JsResult | null = null;
  webviewController: webview.WebviewController = new webview.WebviewController();
  dialogControllerAlert: CustomDialogController = new CustomDialogController({
    builder: AlertDialog({
      primaryTitle: this.title,
      secondaryTitle: this.subtitle,
      content: this.message,
      primaryButton: {
        // $r('app.string.notarize')需要替换为开发者所需的资源文件
        value: $r('app.string.notarize'),
        role: ButtonRole.ERROR,
        action: () => {
          hilog.info(DOMAIN, TAG, BUNDLE, 'Callback when the second button is clicked');
          this.result?.handleConfirm();
        }
      },
    }),
    onWillDismiss: () => {
      this.result?.handleCancel();
      this.dialogControllerAlert.close();
    }
  })
  context = this.getUIContext().getHostContext();
  build() {
    Column() {
      Web({ src: $rawfile('alert.html'), controller: this.webviewController })
        .onAlert((event) => {
          if (event) {
            hilog.info(DOMAIN, TAG, BUNDLE, 'event.url:' + event.url);
            hilog.info(DOMAIN, TAG, BUNDLE, 'event.message:' + event.message);
            // $r('app.string.from')需要替换为开发者所需的资源文件
            this.title = this.context?.resourceManager.getStringSync($r('app.string.from').id) + event.url +
              // $r('app.string.warn')需要替换为开发者所需的资源文件
            this.context?.resourceManager.getStringSync($r('app.string.warn').id);
            this.message = event.message;
            this.result = event.result;
            this.dialogControllerAlert.open();
          }
          return true;
        })
    }
  }
}
// [End AchieveAlertDialogPage2]