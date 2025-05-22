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

// [Start cors_loccross_one]
import { webview } from '@kit.ArkWeb';

function resourceToString(resource: Resource) {
  return getContext().resourceManager.getStringSync(resource);
}

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  webviewController: webview.WebviewController = new webview.WebviewController();
  // 构造域名和本地文件的映射表
  schemeMap = new Map([
    [resourceToString($r('app.string.web_path')) + '/index.html', 'index.html'],
    [resourceToString($r('app.string.web_path')) + '/js/script.js', 'js/script.js'],
  ]);
  // 构造本地文件和构造返回的格式mimeType
  mimeTypeMap = new Map([
    ['index.html', 'text/html'],
    ['js/script.js', 'text/javascript']
  ]);

  build() {
    Row() {
      Column() {
        // 针对本地index1.html,使用http或者https协议代替file协议或者resource协议，并且构造一个属于自己的域名。
        // 本例中构造www.example.com为例。
        Web({ src: resourceToString($r('app.string.web_path')) + '/index.html', controller: this.webviewController })
          .javaScriptAccess(true)
          .fileAccess(true)
          .domStorageAccess(true)
          .geolocationAccess(true)
          .width('100%')
          .height('100%')
          .onInterceptRequest((event) => {
            if (!event) {
              return;
            }
            // 此处匹配自己想要加载的本地离线资源，进行资源拦截替换，绕过跨域
            if (this.schemeMap.has(event.request.getRequestUrl())) {
              let rawfileName: string = this.schemeMap.get(event.request.getRequestUrl())!;
              let mimeType = this.mimeTypeMap.get(rawfileName);
              if (typeof mimeType === 'string') {
                let response = new WebResourceResponse();
                // 构造响应数据，如果本地文件在rawfile下，可以通过如下方式设置
                response.setResponseData($rawfile(rawfileName));
                response.setResponseEncoding('utf-8');
                response.setResponseMimeType(mimeType);
                response.setResponseCode(200);
                response.setReasonMessage('OK');
                response.setResponseIsReady(true);
                return response;
              }
            }
            return null;
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End cors_loccross_one]