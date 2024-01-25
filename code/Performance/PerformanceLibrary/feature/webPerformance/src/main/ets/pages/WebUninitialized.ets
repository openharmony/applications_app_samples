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
import router from '@ohos.router';
import Logger from '../util/Logger';

@Component
export struct WebUninitialized {
  build() {
    Row() {
      Column({ space: 20 }) {
        // 点击按钮跳转未优化的Web组件页
        Button($r('app.string.web_entry_button'))
          .onClick(() => {
            AppStorage.setOrCreate('webPage', 'UninitializedWeb');
            Logger.info("WebPerformance uninitializedWeb");
            router.pushUrl({ url: 'pages/webPerformance/WebBrowserPage', params: 'UninitializedWeb' });
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
    .height('100%')
  }
}