/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import Logger from '../util/Logger';
import router from '@ohos.router';

@Component
export struct WebBrowser {
  getRouter: string = '';
  controller: webview.WebviewController = new webview.WebviewController();

  build() {
    Row() {
      Column({ space: 20 }) {
        Web({ src: 'https://www.openharmony.cn/mainPlay', controller: this.controller })
          .domStorageAccess(true)
          .onPageEnd((event) => {
            if(event) {
              Logger.info("WebPerformance onPageEnd");
              if(this.getRouter === 'InitializedWeb') {
                // 预加载下一页
                this.controller.prefetchPage('https://www.openharmony.cn/download');
              }
            }
          })
        Button($r('app.string.web_page_next'))
          .onClick(() => {
            Logger.info("webPerformance nextPage");
            // 跳转网页
            this.controller.loadUrl('https://www.openharmony.cn/download');
          })
          .width($r('app.string.web_button_width'))
          .height($r('app.string.web_button_height'))
        Button($r('app.string.web_page_back'))
          .onClick(() => {
            router.back();
          })
          .width($r('app.string.web_button_width'))
          .height($r('app.string.web_button_height'))
          .margin({ top: $r('app.string.web_button_margin') })
      }
      .width('100%')
    }
    .height('80%')
  }
}