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
// [Start web_components_load_html_strings_by_data_url]
import { webview } from '@kit.ArkWeb';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct WebComponent {
  controller: webview.WebviewController = new webview.WebviewController();
  htmlStr: string = 'data:text/html, <html><body bgcolor=\'white\'>Source:<pre>source</pre></body></html>';

  build() {
    Column() {
      // 组件创建时，加载htmlStr
      Web({ src: this.htmlStr, controller: this.controller });
    }
  }
}
// [End web_components_load_html_strings_by_data_url]
