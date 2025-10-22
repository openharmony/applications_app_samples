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
// [Start AchieveConfirmDialogPage2]
import { webview } from '@kit.ArkWeb';
import { ConfirmDialog } from '@kit.ArkUI';
import hilog from '@ohos.hilog';
const TAG = '[Sample_ShowWebPageDialog]';
const DOMAIN = 0xF811;
const BUNDLE = 'ProcessWeb_';

@Entry
@Component
struct DialogConfirmDialog {
  @State message: string = 'Hello World';
  @State title: string = 'Hello World';
  @State result: JsResult | null = null;
  context = this.getUIContext().getHostContext()
  webviewController: webview.WebviewController = new webview.WebviewController();
  isChecked = false;
  dialogControllerCheckBox: CustomDialogController = new CustomDialogController({
    builder: ConfirmDialog({
      title: this.title,
      content: this.message,
      // 勾选框选中状态
      isChecked: this.isChecked,
      // 勾选框说明文本
      checkTips: $r('app.string.noPrompt'),
      primaryButton: {
        value: $r('app.string.no'),
        action: () => {
          this.result?.handleCancel();
        },
      },
      secondaryButton: {
        value: $r('app.string.allow'),
        action: () => {
          this.isChecked = false;
          hilog.info(DOMAIN, TAG, BUNDLE, 'Callback when the second button is clicked');
          this.result?.handleConfirm();
        }
      },
      onCheckedChange: (checked) => {
        this.isChecked = checked;
        hilog.info(DOMAIN, TAG, BUNDLE, 'Callback when the checkbox is clicked');
      },
    }),
    onWillDismiss: () => {
      this.result?.handleCancel();
      this.dialogControllerCheckBox.close();
    },
    autoCancel: true
  })

  build() {
    Column() {
      Web({ src: $rawfile('confirm.html'), controller: this.webviewController })
        .onConfirm((event) => {
          if (event) {
            if (this.isChecked) {
              event.result.handleCancel();
            } else {
              hilog.info(DOMAIN, TAG, BUNDLE, "event.url:" + event.url);
              hilog.info(DOMAIN, TAG, BUNDLE, "event.message:" + event.message);
              this.title = this.context?.resourceManager.getStringSync($r('app.string.from').id) +
              event.url + this.context?.resourceManager.getStringSync($r('app.string.from').id);
              this.message = event.message;
              this.result = event.result;
              this.dialogControllerCheckBox.open();
            }
          }
          return true;
        })
    }
  }
}
// [End AchieveConfirmDialogPage2]