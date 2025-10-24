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
// [Start AchievePromptDialogPage]
import { CustomContentDialog } from '@kit.ArkUI';
import { webview } from '@kit.ArkWeb';
import hilog from '@ohos.hilog';
const TAG = '[Sample_ShowWebPageDialog]';
const DOMAIN = 0xF811;
const BUNDLE = 'ShowWebPageDialog_';

@Entry
@Component
struct PromptDialog {
  @State message: string = 'Hello World';
  @State title: string = 'Hello World';
  @State result: JsResult | null = null;
  promptResult: string = '';
  webviewController: webview.WebviewController = new webview.WebviewController();
  context = this.getUIContext().getHostContext();
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomContentDialog({
      primaryTitle: this.title,
      contentBuilder: () => {
        this.buildContent();
      },
      buttons: [
        {
          // $r('app.string.cancel')需要替换为开发者所需的资源文件
          value: $r('app.string.cancel'),
          buttonStyle: ButtonStyleMode.TEXTUAL,
          action: () => {
            hilog.info(DOMAIN, TAG, BUNDLE, 'Callback when the button is clicked');
            this.result?.handleCancel();
          }
        },
        {
          // $r('app.string.notarize')需要替换为开发者所需的资源文件
          value: $r('app.string.notarize'),
          buttonStyle: ButtonStyleMode.TEXTUAL,
          action: () => {
            this.result?.handlePromptConfirm(this.promptResult);
          }
        }
      ],
    }),
    onWillDismiss: () => {
      this.result?.handleCancel();
      this.dialogController.close();
    }
  });

  // 自定义弹出框的内容区
  @Builder
  buildContent(): void {
    Column() {
      Text(this.message)
      TextInput()
        .onChange((value) => {
          this.promptResult = value;
        })
        .defaultFocus(true)
    }
    .width('100%')
  }

  build() {
    Column() {
      Web({ src: $rawfile('prompt.html'), controller: this.webviewController })
        .onPrompt((event) => {
          if (event) {
            hilog.info(DOMAIN, TAG, BUNDLE, 'event.url:' + event.url);
            hilog.info(DOMAIN, TAG, BUNDLE, 'event.message:' + event.message);
            hilog.info(DOMAIN, TAG, BUNDLE, 'event.value:' + event.value);
            // $r('app.string.from')需要替换为开发者所需的资源文件
            this.title = this.context?.resourceManager.getStringSync($r('app.string.from').id) +
              // $r('app.string.info')需要替换为开发者所需的资源文件
            event.url + this.context?.resourceManager.getStringSync($r('app.string.info').id);
            this.message = event.message;
            this.promptResult = event.value;
            this.result = event.result;
            this.dialogController.open();
          }
          return true;
        })
    }
  }
}
// [End AchievePromptDialogPage]