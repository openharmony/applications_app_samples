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

// [Start HTTP_interceptor_case_import]
import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
// [End HTTP_interceptor_case_import]
import { promptAction } from '@kit.ArkUI';

const BUTTON_HEIGHT = 50; // 按钮的高度
const BUTTON_FONT_SIZE = 18; // 按钮的字体大小
const BUTTON_RADIUS = 5; // 按钮的圆角半径
const TEXT_MARGIN_TOP_L = 20; // 长文本的上边距

const EXAMPLE_URL: string = 'http://www.baidu.com/';
const EXAMPLE_INITIAL_URL: string = 'http://www.hao123.com';
const EXAMPLE_Final_URL: string = 'http://www.test.com/';

// [Start HTTP_interceptor_case_creat_http_interceptor]
enum InterceptorType {
  INITIAL_REQUEST = 'INITIAL_REQUEST',
  REDIRECTION = 'REDIRECTION',
  CACHE_CHECKED = 'READ_CACHE',
  NETWORK_CONNECT = 'CONNECT_NETWORK',
  FINAL_RESPONSE = 'FINAL_RESPONSE'
}

class InitialHttpInterceptor implements http.HttpInterceptor {
  interceptorType: InterceptorType = InterceptorType.INITIAL_REQUEST;
  result: boolean = false;

  constructor(interceptorType: InterceptorType, result: boolean) {
    this.interceptorType = interceptorType;
    this.result = result;
  }

  interceptorHandle(reqContext: http.HttpRequestContext, rspContext: http.HttpResponse): Promise<http.ChainContinue> {
    // 命中拦截器后对请求报文与请求响应操作
    hilog.info(0xFF00, 'httpNormalRequest', `INITIAL_REQUEST, Original req: ${JSON.stringify(reqContext)}`);
    hilog.info(0xFF00, 'httpNormalRequest', `INITIAL_REQUEST, Original rsp: ${JSON.stringify(rspContext)}`);

    reqContext.url = EXAMPLE_INITIAL_URL;
    reqContext.header = { 'content-type': 'text/plain' };
    reqContext.body = { 'context': 'INITIAL_REQUEST' };

    rspContext.result = 'INITIAL_REQUEST';
    rspContext.responseCode = 200;
    rspContext.header =
      'content-encoding:br \r\n content-type:text/html\r\ncharset=UTF-8,cxy_all:+5c4ea5d1638626cbb796a7db10e0d663\r\ndate:Tue';

    hilog.info(0xFF00, 'httpNormalRequest', `INITIAL_REQUEST, Update req: ${JSON.stringify(reqContext)}`);
    hilog.info(0xFF00, 'httpNormalRequest', `INITIAL_REQUEST, Update rsp: ${JSON.stringify(rspContext)}`);
    return Promise.resolve(this.result);
  }
}

class NetworkHttpInterceptor implements http.HttpInterceptor {
  interceptorType: InterceptorType = InterceptorType.INITIAL_REQUEST;
  result: boolean = false;

  constructor(interceptorType: InterceptorType, result: boolean) {
    this.interceptorType = interceptorType;
    this.result = result;
  }

  interceptorHandle(reqContext: http.HttpRequestContext, rspContext: http.HttpResponse): Promise<http.ChainContinue> {
    // 命中拦截器后对请求报文与请求响应操作
    hilog.info(0xFF00, 'httpNormalRequest', `NETWORK_CONNECT, Original req: ${JSON.stringify(reqContext)}`);
    hilog.info(0xFF00, 'httpNormalRequest', `NETWORK_CONNECT, Original rsp: ${JSON.stringify(rspContext)}`);

    reqContext.url = EXAMPLE_URL;
    reqContext.header = { 'content-type': 'text/xml' };
    reqContext.body = { 'context': 'NETWORK_CONNECT' };

    rspContext.result = 'NETWORK_CONNECT';
    rspContext.responseCode = 300;
    rspContext.header =
      'content-encoding:br \r\n content-type:text/html\r\ncharset=UTF-8,cxy_all:+5c4ea5d1638626cbb796a7db10e0d663\r\ndate:Tue';

    hilog.info(0xFF00, 'httpNormalRequest', `NETWORK_CONNECT, Update req: ${JSON.stringify(reqContext)}`);
    hilog.info(0xFF00, 'httpNormalRequest', `NETWORK_CONNECT, Update rsp: ${JSON.stringify(rspContext)}`);
    return Promise.resolve(this.result);
  }
}

class FinalHttpInterceptor implements http.HttpInterceptor {
  interceptorType: InterceptorType = InterceptorType.INITIAL_REQUEST;
  result: boolean = false;

  constructor(interceptorType: InterceptorType, result: boolean) {
    this.interceptorType = interceptorType;
    this.result = result;
  }

  interceptorHandle(reqContext: http.HttpRequestContext, rspContext: http.HttpResponse): Promise<http.ChainContinue> {
    // 命中拦截器后对请求报文与请求响应操作
    hilog.info(0xFF00, 'httpNormalRequest', `FINAL_RESPONSE, Original req: ${JSON.stringify(reqContext)}`);
    hilog.info(0xFF00, 'httpNormalRequest', `FINAL_RESPONSE, Original rsp: ${JSON.stringify(rspContext)}`);

    reqContext.url = EXAMPLE_Final_URL;
    reqContext.header = { 'content-type': 'text/html' };
    reqContext.body = { 'context': 'FINAL_RESPONSE' };

    rspContext.result = 'FINAL_RESPONSE';
    rspContext.responseCode = 200;
    rspContext.header =
      'content-encoding:br \r\n content-type:text/html\r\ncharset=UTF-8,cxy_all:+5c4ea5d1638626cbb796a7db10e0d663\r\ndate:Tue';

    hilog.info(0xFF00, 'httpNormalRequest', `FINAL_RESPONSE, Update req: ${JSON.stringify(reqContext)}`);
    hilog.info(0xFF00, 'httpNormalRequest', `FINAL_RESPONSE, Update rsp: ${JSON.stringify(rspContext)}`);
    return Promise.resolve(this.result);
  }
}
// [End HTTP_interceptor_case_creat_http_interceptor]

function httpNormalRequest() {
  try {
    // [Start HTTP_interceptor_case_creat_request]
    // 创建http请求
    let httpRequest: http.HttpRequest = http.createHttp();
    // [End HTTP_interceptor_case_creat_request]

    // [Start HTTP_interceptor_case_chain]
    // 创建拦截器链
    let chain: http.HttpInterceptorChain = new http.HttpInterceptorChain();
    // [End HTTP_interceptor_case_chain]

    // [Start HTTP_interceptor_case_addChain]
    // 创建所需要的拦截器对象,将拦截器对象加入拦截器链中
    chain.addChain([
      new InitialHttpInterceptor(InterceptorType.INITIAL_REQUEST, true),
      new NetworkHttpInterceptor(InterceptorType.NETWORK_CONNECT, true),
      new FinalHttpInterceptor(InterceptorType.FINAL_RESPONSE, true)
    ]);
    // [End HTTP_interceptor_case_addChain]

    // [Start HTTP_interceptor_case_apply]
    // 将当前配置好的拦截器链附加到httpRequest中
    chain.apply(httpRequest);
    // [End HTTP_interceptor_case_apply]

    // [Start HTTP_interceptor_case_options]
    // 创建请求可选项
    let options: http.HttpRequestOptions = {
      method: http.RequestMethod.POST,
      header: { 'content-type': 'text/html' } as Record<string, string>,
      extraData: { 'context': 'BODY' } as Record<string, string>,
    };
    // [End HTTP_interceptor_case_options]

    // [Start HTTP_interceptor_case_request]
    // 发起请求
    httpRequest.request(EXAMPLE_URL, options, (err: BusinessError, res: http.HttpResponse) => {
      if (err) {
        hilog.info(0xFF00, 'httpNormalRequest', `request fail, error code: ${err.code}, msg: ${err.message}`);
        // [StartExclude HTTP_interceptor_case_request]
        promptAction.showToast({
          message: `request hit the interceptor fail`,
          duration: 4000, // 持续时间
          bottom: 300 // 与底间隔
        });
        // [EndExclude HTTP_interceptor_case_request]
      } else {
        hilog.info(0xFF00, 'httpNormalRequest', `res:${JSON.stringify(res)}`);
        // [StartExclude HTTP_interceptor_case_request]
        promptAction.showToast({
          message: `request hit the interceptor successfully`,
          duration: 4000, // 持续时间
          bottom: 300 // 与底间隔
        });
        // [EndExclude HTTP_interceptor_case_request]
      }
      // [StartExclude HTTP_interceptor_case_request]
      // [Start HTTP_interceptor_case_request_destroy]
      // 销毁请求
      httpRequest.destroy();
      // [End HTTP_interceptor_case_request_destroy]
      // [EndExclude HTTP_interceptor_case_request]
    });
    // [End HTTP_interceptor_case_request]
  } catch (error) {
    hilog.info(0xFF00, 'httpNormalRequest', `catch ERROR-->:${JSON.stringify(error.message)}`);
    promptAction.showToast({
      message: `${error.message}`,
      duration: 4000, // 持续时间
      bottom: 300 // 与底间隔
    });
  }
}

@Entry
@Component
struct Index {
  build() {
    Column() {
      Button($r('app.string.normal_process_request'))
        .onClick(() => {
          httpNormalRequest()
        })
        .width('85%')
        .height(BUTTON_HEIGHT)
        .margin({ top: TEXT_MARGIN_TOP_L })
        .fontColor(Color.White)
        .fontSize(BUTTON_FONT_SIZE)
        .borderRadius(BUTTON_RADIUS)

    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }
}