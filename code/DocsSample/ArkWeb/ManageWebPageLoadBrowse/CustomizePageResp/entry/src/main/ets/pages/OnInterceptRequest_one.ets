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

function resourceToString(resource: Resource) {
  return getContext().resourceManager.getStringSync(resource);
}

@Entry
@Component
struct WebComponent {
  controller: webview.WebviewController = new webview.WebviewController();
  responseResource: WebResourceResponse = new WebResourceResponse();
  // 开发者自定义响应数据
  @State webData: string = '<!DOCTYPE html>\n' +
    '<html>\n' +
    '<head>\n' +
    '<title>intercept test</title>\n' +
    '</head>\n' +
    '<body>\n' +
    '<h1>intercept ok</h1>\n' +
    '</body>\n' +
    '</html>'

  build() {
    Column() {
      Web({ src: $rawfile('index1.html'), controller: this.controller })
        .onInterceptRequest((event) => {
          if (event) {
            console.info('url:' + event.request.getRequestUrl());
            // 拦截页面请求
            if (event.request.getRequestUrl() !== resourceToString($r('app.string.web_path')) + '/test.html') {
              return null;
            }
          }
          // 构造响应数据
          this.responseResource.setResponseData(this.webData);
          this.responseResource.setResponseEncoding('utf-8');
          this.responseResource.setResponseMimeType('text/html');
          this.responseResource.setResponseCode(200);
          this.responseResource.setReasonMessage('OK');
          return this.responseResource;
        })
    }
  }
}
