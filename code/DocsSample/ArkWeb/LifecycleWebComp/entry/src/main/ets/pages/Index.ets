/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
// [Start the_status_of_web_component_web_page_loading]
import { webview } from '@kit.ArkWeb';
import { BusinessError } from '@kit.BasicServicesKit';
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
struct WebComponent {
  controller: webview.WebviewController = new webview.WebviewController();
  responseWeb: WebResourceResponse = new WebResourceResponse();
  heads: Header[] = new Array();
  @State webData: string = '<!DOCTYPE html>\n' +
    '<html>\n' +
    '<head>\n' +
    '<title>intercept test</title>\n' +
    '</head>\n' +
    '<body>\n' +
    '<h1>intercept test</h1>\n' +
    '</body>\n' +
    '</html>';

  aboutToAppear(): void {
    try {
      webview.WebviewController.setWebDebuggingAccess(true);
    } catch (error) {
      console.error(`ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
    }
  }

  build() {
    Column() {
      Web({ src: $rawfile('index.html'), controller: this.controller })
        .onControllerAttached(() => {
          // 推荐在此loadUrl、设置自定义用户代理、注入JS对象等
          console.log('onControllerAttached execute');
        })
        .onLoadIntercept((event) => {
          if (event) {
            console.log('onLoadIntercept url:' + event.data.getRequestUrl());
            console.log('url:' + event.data.getRequestUrl());
            console.log('isMainFrame:' + event.data.isMainFrame());
            console.log('isRedirect:' + event.data.isRedirect());
            console.log('isRequestGesture:' + event.data.isRequestGesture());
          }
          // 返回true表示阻止此次加载，否则允许此次加载
          return true;
        })
        .onOverrideUrlLoading((webResourceRequest: WebResourceRequest) => {
          if (webResourceRequest && webResourceRequest.getRequestUrl() == 'about:blank') {
            return true;
          }
          return false;
        })
        .onInterceptRequest((event) => {
          if (event) {
            console.log('url:' + event.request.getRequestUrl());
          }
          let head1: Header = {
            headerKey: 'Connection',
            headerValue: 'keep-alive'
          }
          let head2: Header = {
            headerKey: 'Cache-Control',
            headerValue: 'no-cache'
          }
          let length = this.heads.push(head1);
          length = this.heads.push(head2);
          this.responseWeb.setResponseHeader(this.heads);
          this.responseWeb.setResponseData(this.webData);
          this.responseWeb.setResponseEncoding('utf-8');
          this.responseWeb.setResponseMimeType('text/html');
          this.responseWeb.setResponseCode(200);
          this.responseWeb.setReasonMessage('OK');
          // 返回响应数据则按照响应数据加载，无响应数据则返回null表示按照原来的方式加载
          return this.responseWeb;
        })
        .onPageBegin((event) => {
          if (event) {
            console.log('onPageBegin url:' + event.url);
          }
        })
        .onFirstContentfulPaint(event => {
          if (event) {
            console.log('onFirstContentfulPaint:' + '[navigationStartTick]:' +
            event.navigationStartTick + ', [firstContentfulPaintMs]:' +
            event.firstContentfulPaintMs);
          }
        })
        .onProgressChange((event) => {
          if (event) {
            console.log('newProgress:' + event.newProgress);
          }
        })
        .onPageEnd((event) => {
          // 推荐在此事件中执行JavaScript脚本
          if (event) {
            console.log('onPageEnd url:' + event.url);
          }
        })
        .onPageVisible((event) => {
          console.log('onPageVisible url:' + event.url);
        })
        .onRenderExited((event) => {
          if (event) {
            console.log('onRenderExited reason:' + event.renderExitReason);
          }
        })
        .onDisAppear(() => {
          promptAction.showToast({
            message: 'The web is hidden',
            duration: 2000
          });
        })
    }
  }
}
// [End the_status_of_web_component_web_page_loading]