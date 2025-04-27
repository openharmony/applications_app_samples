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
import { router } from '@kit.ArkUI';

// [Start index_load_route_link_to_profile]
@Entry
@Component
struct WebComponent {
  webviewController: webview.WebviewController = new webview.WebviewController();

  build() {
    Column() {
      // 资源文件route.html存放路径src/main/resources/rawfile
      Web({ src: $rawfile('route.html'), controller: this.webviewController })
        .onLoadIntercept((event) => {
          if (event) {
            let url: string = event.data.getRequestUrl();
            if (url.indexOf('native://') === 0) {
              // 跳转其他界面
              router.pushUrl({ url: url.substring(9) });
              return true;
            }
          }
          return false;
        })
    }
  }
}
// [End index_load_route_link_to_profile]