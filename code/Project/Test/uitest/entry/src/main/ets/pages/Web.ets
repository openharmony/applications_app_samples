/*
* Copyright (c) 2023-2024 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License")
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

import web_webview from '@ohos.web.webview';

@Entry
@Component
struct Index {
  controller: web_webview.WebviewController = new web_webview.WebviewController();
  // 将 WebviewController 存储到应用全局状态，TestAbility 中可获取并使用该对象
  @StorageLink('controller') storageLink: web_webview.WebviewController = this.controller;

  build() {
    Row() {
      Column() {
        Web({ src: $rawfile('index.html'), controller: this.controller })
          .javaScriptAccess(true)
          .onPageEnd(e => {
            console.info(`webview onPageEnd`);
          })
          .id('webComponent')
          .width('80%')
          .height('80%')
          .align(Alignment.Center)
          .borderColor(Color.Black)
          .borderWidth(5)
      }
      .width('100%')
    }
    .height('100%')
  }
}