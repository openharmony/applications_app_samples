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

// [Start build_response_resource_enable_gen]
import { webview } from '@kit.ArkWeb';

function resourceToString(resource: Resource) {
  return getContext().resourceManager.getStringSync(resource);
}

@Entry
@Component
struct WebComponent {
  controller: webview.WebviewController = new webview.WebviewController();
  responseResource: WebResourceResponse = new WebResourceResponse();
  // 开发者自定义响应数据（响应数据长度需大于等于1024才会生成codecache）
  @State jsData: string = 'let text_msg = "the modified content:version 0000000000001";\n' +
    'let element1 = window.document.getElementById("div-1");\n' +
    'let element2 = window.document.getElementById("div-2");\n' +
    'let element3 = window.document.getElementById("div-3");\n' +
    'let element4 = window.document.getElementById("div-4");\n' +
    'let element5 = window.document.getElementById("div-5");\n' +
    'let element6 = window.document.getElementById("div-6");\n' +
    'let element7 = window.document.getElementById("div-7");\n' +
    'let element8 = window.document.getElementById("div-8");\n' +
    'let element9 = window.document.getElementById("div-9");\n' +
    'let element10 = window.document.getElementById("div-10");\n' +
    'let element11 = window.document.getElementById("div-11");\n' +
    'element1.innerHTML = text_msg;\n' +
    'element2.innerHTML = text_msg;\n' +
    'element3.innerHTML = text_msg;\n' +
    'element4.innerHTML = text_msg;\n' +
    'element5.innerHTML = text_msg;\n' +
    'element6.innerHTML = text_msg;\n' +
    'element7.innerHTML = text_msg;\n' +
    'element8.innerHTML = text_msg;\n' +
    'element9.innerHTML = text_msg;\n' +
    'element10.innerHTML = text_msg;\n' +
    'element11.innerHTML = text_msg;\n';

  build() {
    Column() {
      Web({ src: $rawfile('index2.html'), controller: this.controller })
        .onInterceptRequest((event) => {
          // 拦截页面请求
          if (event?.request.getRequestUrl() == resourceToString($r('app.string.web_path')) + '/test.js') {
            // 构造响应数据
            this.responseResource.setResponseHeader([
              {
                // 格式：不超过13位纯数字。js识别码，Js有更新时必须更新该字段
                headerKey: 'ResponseDataID',
                headerValue: '0000000000001'
              }]);
            this.responseResource.setResponseData(this.jsData);
            this.responseResource.setResponseEncoding('utf-8');
            this.responseResource.setResponseMimeType('application/javascript');
            this.responseResource.setResponseCode(200);
            this.responseResource.setReasonMessage('OK');
            return this.responseResource;
          }
          return null;
        })
    }
  }
}
// [End build_response_resource_enable_gen]