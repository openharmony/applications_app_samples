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

import { webview, WebNetErrorList } from '@kit.ArkWeb';
import { BusinessError } from '@kit.BasicServicesKit';
import { buffer } from '@kit.ArkTS';

@Entry
@Component
struct WebComponent {
  controller: webview.WebviewController = new webview.WebviewController();
  schemeHandler: webview.WebSchemeHandler = new webview.WebSchemeHandler();
  htmlData: string = '<html><body bgcolor=\'white\'>Source:<pre>source</pre></body></html>';

  build() {
    Column() {
      Web({ src: 'https://www.example.com', controller: this.controller })
        .onControllerAttached(() => {
          try {
            this.schemeHandler.onRequestStart
            ((request: webview.WebSchemeHandlerRequest, resourceHandler: webview.WebResourceHandler) => {
              console.info('[schemeHandler] onRequestStart');
              try {
                console.info('[schemeHandler] onRequestStart url:' + request.getRequestUrl());
                console.info('[schemeHandler] onRequestStart method:' + request.getRequestMethod());
                console.info('[schemeHandler] onRequestStart referrer:' + request.getReferrer());
                console.info('[schemeHandler] onRequestStart isMainFrame:' + request.isMainFrame());
                console.info('[schemeHandler] onRequestStart hasGesture:' + request.hasGesture());
                console.info('[schemeHandler] onRequestStart header size:' + request.getHeader().length);
                console.info('[schemeHandler] onRequestStart resource type:' + request.getRequestResourceType());
                console.info('[schemeHandler] onRequestStart frame url:' + request.getFrameUrl());
                let header = request.getHeader();
                for (let i = 0; i < header.length; i++) {
                  console.info('[schemeHandler] onRequestStart header:' + header[i].headerKey + ' ' + header[i].headerValue);
                }
                let stream = request.getHttpBodyStream();
                if (stream) {
                  console.info('[schemeHandler] onRequestStart has http body stream');
                } else {
                  console.info('[schemeHandler] onRequestStart has no http body stream');
                }
              } catch (error) {
                console.error(`ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
              }

              if (request.getRequestUrl().endsWith('example.com')) {
                return false;
              }

              let response = new webview.WebSchemeHandlerResponse();
              try {
                response.setNetErrorCode(WebNetErrorList.NET_OK);
                response.setStatus(200);
                response.setStatusText('OK');
                response.setMimeType('text/html');
                response.setEncoding('utf-8');
                response.setHeaderByName('header1', 'value1', false);
              } catch (error) {
                console.error(`[schemeHandler] ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
              }

              // 调用didFinish/didFail前需要优先调用didReceiveResponse将构造的响应头传递给被拦截的请求。
              let buf = buffer.from(this.htmlData)
              try {
                if (buf.length === 0) {
                  console.info('[schemeHandler] length 0');
                  resourceHandler.didReceiveResponse(response);
                  // 如果认为buf.length为0是正常情况，则调用resourceHandler.didFinish，否则调用resourceHandler.didFail。
                  resourceHandler.didFail(WebNetErrorList.ERR_FAILED);
                } else {
                  console.info('[schemeHandler] length 1');
                  resourceHandler.didReceiveResponse(response);
                  resourceHandler.didReceiveResponseBody(buf.buffer);
                  resourceHandler.didFinish();
                }
              } catch (error) {
                console.error(`[schemeHandler] ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
              }
              return true;
            })

            this.schemeHandler.onRequestStop((request: webview.WebSchemeHandlerRequest) => {
              console.info('[schemeHandler] onRequestStop');
            });

            this.controller.setWebSchemeHandler('https', this.schemeHandler);
          } catch (error) {
            console.error(`ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
          }
        })
        .javaScriptAccess(true)
        .domStorageAccess(true)
    }
  }
}