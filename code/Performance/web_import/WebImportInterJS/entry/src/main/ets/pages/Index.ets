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
import { hiTraceMeter } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct Index {
  webViewController: webview.WebviewController = new webview.WebviewController();
  responseResource: WebResourceResponse = new WebResourceResponse();
  // 开发者自定义响应数据，响应数据长度需大于等于1024才会生成CodeCache
  @State jsData: string = 'JavaScript Data';

  build() {
    Column() {
      Web({ src: $rawfile('index.html'), controller: this.webViewController })
        .onInterceptRequest(event => {
          // 拦截页面请求
          if (event?.request.getRequestUrl() === 'https://www.example.com/test.js') {
            // 构造响应数据
            this.responseResource.setResponseHeader([
              {
                headerKey: 'ResponseDataID',
                // 格式：不超过13位的纯数字。JS识别码，JS有更新时必须更新该字段
                headerValue: '0000000000001'
              }
            ]);
            this.responseResource.setResponseData(this.jsData);
            this.responseResource.setResponseEncoding('utf-8');
            this.responseResource.setResponseMimeType('application/javascript');
            this.responseResource.setResponseCode(200);
            this.responseResource.setReasonMessage('OK');
            return this.responseResource;
          }
          return null;
        })
        .onPageBegin(() => {
          hiTraceMeter.startTrace('getMessageData', 0);
        })
        .onPageEnd(() => {
          hiTraceMeter.finishTrace('getMessageData', 0);
        })
    }
    .width('100%')
  }
}