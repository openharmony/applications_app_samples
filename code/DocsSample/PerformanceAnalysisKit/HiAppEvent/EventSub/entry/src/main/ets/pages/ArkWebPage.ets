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
 
// [Start ArkWeb_Fling_Jank_Page]
import web_webview from '@ohos.web.webview';

// 用于存储web_id到url的映射
export const webIdToUrlMap = new Map<number, string>();

@Entry
@Component
struct ArkWebPage {
  controller = new web_webview.WebviewController();

  build() {
    Column() {
      Web({ src: 'https://baidu.com',
        controller: this.controller
      })
        .height('100%')
        .onPageBegin((event) => {
          // 每次跳转到新页面都更新webId到url的映射关系，便于后续通过系统侧提供的web_id查询到发生丢帧的网页
          if (event) {
            const newUrl = event.url;
            const webId = this.controller.getWebId();
            webIdToUrlMap.set(webId, newUrl);
          }
        })
        .onPageEnd(() => {
          // 每2s阻塞应用主线程200ms
          setInterval(() => {
            const endTime = Date.now() + 200;
            while (Date.now() < endTime) {}
          }, 2000);
        })
    }
  }
}
// [End ArkWeb_Fling_Jank_Page]