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
// [Start on_page_end_trigger_prefetch_post_request_access_page]
import { webview } from '@kit.ArkWeb';
// [StartExclude on_page_end_trigger_prefetch_post_request_access_page]
function resourceToString(resource: Resource) {
  return getContext().resourceManager.getStringSync(resource);
}
// [EndExclude on_page_end_trigger_prefetch_post_request_access_page]
@Entry
@Component
struct WebComponent {
  webviewController: webview.WebviewController = new webview.WebviewController();

  build() {
    Column() {
      Web({ src: $r('app.string.web_path'), controller: this.webviewController})
        .onPageEnd(() => {
          // 预获取时，需要將'https://www.example1.com/post?e=f&g=h'替换成真实要访问的网站地址。
          webview.WebviewController.prefetchResource(
            {url:resourceToString($r('app.string.web_path')) + '/post?e=f&g=h',
              method:'POST',
              formData:'a=x&b=y',},
            [{headerKey:'c',
              headerValue:'z',},],
            'KeyX', 500);
        })
    }
  }
}
//[End on_page_end_trigger_prefetch_post_request_access_page]
