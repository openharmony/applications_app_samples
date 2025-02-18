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

import { webview } from '@kit.ArkWeb';

function resourceToString(resource: Resource) {
  return getContext().resourceManager.getStringSync(resource);
}

@Entry
@Component
struct WebComponent {
  webviewController: webview.WebviewController = new webview.WebviewController();

  build() {
    Column() {
      Button('loadData')
        .onClick(() => {
          if (this.webviewController.accessBackward()) {
            this.webviewController.backward();
          }
        })
      Web({ src: $r('app.string.web_path_one'), controller: this.webviewController })
        .onAppear(() => {
          // 指定第二个参数为true，代表要进行预连接，如果为false该接口只会对网址进行dns预解析
          // 第三个参数为要预连接socket的个数。最多允许6个。
          webview.WebviewController.prepareForPageLoad(resourceToString($r('app.string.web_path_one')), true, 2);
        })
    }
  }
}
