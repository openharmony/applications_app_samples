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
// [End HTTP_interceptor_case_import]
import { promptAction } from '@kit.ArkUI';

const BUTTON_HEIGHT = 50; // 按钮的高度
const BUTTON_FONT_SIZE = 18; // 按钮的字体大小
const BUTTON_RADIUS = 5; // 按钮的圆角半径
const TEXT_MARGIN_TOP_L = 20; // 长文本的上边距

// [Start HTTP_interceptor_case_creat_http_interceptor]
enum InterceptorType {
  INITIAL_REQUEST = 'INITIAL_REQUEST',
  REDIRECTION = 'REDIRECTION',
  CACHE_CHECKED = 'READ_CACHE',
  NETWORK_CONNECT = 'CONNECT_NETWORK',
  FINAL_RESPONSE = 'FINAL_RESPONSE'
}

class TestHttpInterceptor implements http.HttpInterceptor {
  interceptorType: InterceptorType = InterceptorType.INITIAL_REQUEST;

  constructor(interceptorType: InterceptorType) {
    this.interceptorType = interceptorType;
  }

  interceptorHandle(reqContext: http.HttpRequestContext, rspContext: http.HttpResponse): Promise<http.ChainContinue> {
    // 命中拦截器后对请求报文与请求响应操作
    // [StartExclude HTTP_interceptor_case_creat_http_interceptor]
    rspContext.result = "INITIAL_REQUEST";
    rspContext.responseCode = 200;
    rspContext.header =
      "content-encoding:br \r\n content-type:text/html\r\ncharset=UTF-8,cxy_all:+5c4ea5d1638626cbb796a7db10e0d663\r\ndate:Tue";
    // [EndExclude HTTP_interceptor_case_creat_http_interceptor]
    return Promise.resolve(true);
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
      new TestHttpInterceptor(InterceptorType.INITIAL_REQUEST),
      new TestHttpInterceptor(InterceptorType.NETWORK_CONNECT),
      new TestHttpInterceptor(InterceptorType.FINAL_RESPONSE)
    ]);
    // [End HTTP_interceptor_case_addChain]

    // [Start HTTP_interceptor_case_apply]
    // 将请求应用到拦截器链中
    chain.apply(httpRequest);
    // [End HTTP_interceptor_case_apply]

    // [Start HTTP_interceptor_case_options]
    // 创建请求可选项
    let options: http.HttpRequestOptions = {
      method: http.RequestMethod.POST,
      header: { "content-type": "text/html" } as Record<string, string>,
      extraData: { "context": "BODY_NO_CHANGE" } as Record<string, string>,
    };
    // [End HTTP_interceptor_case_options]

    // [Start HTTP_interceptor_case_request]
    // 发起请求
    httpRequest.request("https://www.baidu.com/", options, (err: BusinessError, res: http.HttpResponse) => {
      if (err) {
        console.log(`request fail, error code: ${err.code}, msg: ${err.message}`);
        // [StartExclude HTTP_interceptor_case_request]
        promptAction.showToast({
          message: `request hit the interceptor fail`,
          duration: 4000, // 持续时间
          bottom: 300 // 与底间隔
        });
        // [EndExclude HTTP_interceptor_case_request]
      } else {
        console.log(`res:${JSON.stringify(res)}`);
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
    console.log(`catch ERROR-->:${JSON.stringify(error.message)}`);
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