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
//[Start prefetch_post_request_on_page_end_clear_cache]
import { webview } from '@kit.ArkWeb';
// [StartExclude prefetch_post_request_on_page_end_clear_cache]
function resourceToString(resource: Resource) {
  return getContext().resourceManager.getStringSync(resource);
}
// [EndExclude prefetch_post_request_on_page_end_clear_cache]
@Entry
@Component
struct WebComponent {
  webviewController: webview.WebviewController = new webview.WebviewController();

  build() {
    Column() {
      Web({ src: $r('app.string.web_path'), controller: this.webviewController})
        .onAppear(() => {
          // 预获取时，需要將'https://www.example1.com/post?e=f&g=h'替换成真实要访问的网站地址。
          webview.WebviewController.prefetchResource(
            {url:resourceToString($r('app.string.post_path')),
              method:'POST',
              formData:'a=x&b=y',},
            [{headerKey:'c',
              headerValue:'z',},],
            'KeyX', 500);
        })
        .onPageEnd(() => {
          // 清除后续不再使用的预获取资源缓存。
          webview.WebviewController.clearPrefetchedResource(['KeyX',]);
        })
    }
  }
}
//[End prefetch_post_request_on_page_end_clear_cache]