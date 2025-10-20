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
import webview from '@ohos.web.webview';

@Entry
@Component
struct FixingPageFlickering {
  webController: webview.WebviewController = new webview.WebviewController();

  build() {
    Column() {
      // [Start FixingPageFlickeringButton]
      Web({ src: $rawfile('xxx.html'),  controller: this.webController})
        .backgroundColor(Color.Gray)
      // [End FixingPageFlickeringButton]
        .width('100%')
        .height('100%')
        .onPageEnd(() => {
          // 页面加载完成时的回调
          console.info('Web page loaded completely');
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Gray)
  }
}