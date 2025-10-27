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
// [Start AchieveAlertDialogPage1]
import { webview } from '@kit.ArkWeb';
import hilog from '@ohos.hilog';
const TAG = '[Sample_ShowWebPageDialog]';
const DOMAIN = 0xF811;
const BUNDLE = 'ShowWebPageDialog_';
@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  webviewController: webview.WebviewController = new webview.WebviewController();
  uiContext: UIContext = this.getUIContext();
  context = this.getUIContext().getHostContext();

  build() {
    Row() {
      Web({ src: $rawfile('test.html'), controller: this.webviewController })
        .onAlert((event) => {
          if (event) {
            hilog.info(DOMAIN, TAG, BUNDLE, 'event.url:' + event.url);
            hilog.info(DOMAIN, TAG, BUNDLE, 'event.message:' + event.message);
            this.uiContext.showAlertDialog({
              // $r('app.string.from')需要替换为开发者所需的资源文件
              title: this.context?.resourceManager.getStringSync($r('app.string.from').id) + event.url +
                // $r('app.string.warn')需要替换为开发者所需的资源文件
              this.context?.resourceManager.getStringSync($r('app.string.warn').id),
              message: event.message,
              confirm:{
                // $r('app.string.notarize')需要替换为开发者所需的资源文件
                value: $r('app.string.notarize'),
                action: () => {
                  hilog.info(DOMAIN, TAG, BUNDLE, 'Alert confirmed.');
                  event.result.handleConfirm();
                }
              },
              cancel: () => {
                event.result.handleCancel();
              }
            })
          }
          return true;
        })
    }
  }
}
// [End AchieveAlertDialogPage1]