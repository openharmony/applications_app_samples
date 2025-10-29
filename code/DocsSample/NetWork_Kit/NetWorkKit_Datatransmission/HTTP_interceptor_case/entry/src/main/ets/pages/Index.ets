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
import { BusinessError } from '@kit.BasicServicesKit';
import http from '@ohos.net.http';
import { promptAction } from '@kit.ArkUI';

const BUTTON_HEIGHT = 50; // 按钮的高度
const BUTTON_FONT_SIZE = 18; // 按钮的字体大小
const BUTTON_RADIUS = 5; // 按钮的圆角半径
const TEXT_MARGIN_TOP_L = 20; // 长文本的上边距

const HTTP_URL: string = "https://www.baidu.com/"; // 长文本的上边距

enum InterceptorType {
  // 1.创建请求之后，向服务端发送请求之前；
  // 2.result返回为true，标识请求可以继续往下执行；待确定：result返回为false，表示请求在此中断，将response的信息返回为客户端；
  INITIAL_REQUEST = 'INITIAL_REQUEST',

  REDIRECTION = 'REDIRECTION',
  //1.服务端返回信息，命中缓存之后触发(发送第二次相同请求之前并且命中缓存之后才会触发)；
  CACHE_CHECKED = 'READ_CACHE',
  // 1.创建请求之后，向服务端发送请求之前，更靠近请求；
  NETWORK_CONNECT = 'CONNECT_NETWORK',
  // 1.服务端返回信息之后；
  FINAL_RESPONSE = 'FINAL_RESPONSE'
}

class TestHttpInterceptor implements http.HttpInterceptor {
  interceptorType: InterceptorType = InterceptorType.INITIAL_REQUEST;
  result: boolean;
  title = "";

  constructor(interceptorType: InterceptorType, result: boolean) {
    this.interceptorType = interceptorType;
    this.result = result;
    this.title = this.interceptorType.toString() + " Promise.resolve(" + this.result + ")";
    console.log("TestHttpInterceptor::constructor::" + this.title + '::success');
  }

  interceptorHandle(reqContext: http.HttpRequestContext, rspContext: http.HttpResponse): Promise<http.ChainContinue> {
    console.log(this.title + '::success');
    console.log(this.title + '::reqContext::' + JSON.stringify(reqContext));
    console.log(this.title + '::rspContext::' + JSON.stringify(rspContext));

    rspContext.result = "INITIAL_REQUEST";
    rspContext.responseCode = 200;
    rspContext.header =
      "content-encoding:br \r\n content-type:text/html\r\ncharset=UTF-8,cxy_all:+5c4ea5d1638626cbb796a7db10e0d663\r\ndate:Tue";
    return Promise.resolve(this.result);
  }
}

class NetworkHttpInterceptor implements http.HttpInterceptor {
  interceptorType: InterceptorType = InterceptorType.NETWORK_CONNECT;
  result: boolean;
  title = "";

  constructor(interceptorType: InterceptorType, result: boolean) {
    this.interceptorType = interceptorType;
    this.result = result;
    this.title = this.interceptorType.toString() + " Promise.resolve(" + this.result + ")";
    console.log("NetworkHttpInterceptor::constructor::" + this.title + '::success');
  }

  interceptorHandle(reqContext: http.HttpRequestContext, rspContext: http.HttpResponse): Promise<http.ChainContinue> {
    console.log(this.title + '::success');
    console.log(this.title + '::reqContext::' + JSON.stringify(reqContext));
    console.log(this.title + '::rspContext::' + JSON.stringify(rspContext));

    rspContext.result = "NETWORK_CONNECT";
    rspContext.responseCode = 900;
    rspContext.header =
      "content-encoding:br \r\n content-type:text/html\r\ncharset=UTF-8,cxy_all:+5c4ea5d1638626cbb796a7db10e0d663\r\ndate:Tue";
    return Promise.resolve(this.result);
  }
}

class FinallyHttpInterceptor implements http.HttpInterceptor {
  interceptorType: InterceptorType = InterceptorType.INITIAL_REQUEST;
  result: boolean;
  title = "";

  constructor(interceptorType: InterceptorType, result: boolean) {
    this.interceptorType = interceptorType;
    this.result = result;
    this.title = this.interceptorType.toString() + " Promise.resolve(" + this.result + ")";
    console.log("FinallyHttpInterceptor::constructor::" + this.title + '::success');
  }

  interceptorHandle(reqContext: http.HttpRequestContext, rspContext: http.HttpResponse): Promise<http.ChainContinue> {
    console.log(this.title + '::success');
    console.log(this.title + '::reqContext::' + JSON.stringify(reqContext));
    console.log(this.title + '::rspContext::' + JSON.stringify(rspContext));

    rspContext.result = "FINAL_RESPONSE";
    rspContext.responseCode = 900;
    rspContext.header =
      "content-encoding:br \r\n content-type:text/html\r\ncharset=UTF-8,cxy_all:+5c4ea5d1638626cbb796a7db10e0d663\r\ndate:Tue";
    return Promise.resolve(this.result);
  }
}

function httpNormalRequest() {
  try {
    // 创建http请求
    let httpRequest: http.HttpRequest = http.createHttp();
    // 创建拦截器链
    let chain: http.HttpInterceptorChain = new http.HttpInterceptorChain();
    // 创建所需要的拦截器对象
    let c1 = new TestHttpInterceptor(InterceptorType.INITIAL_REQUEST, true);
    let c2 = new NetworkHttpInterceptor(InterceptorType.NETWORK_CONNECT, true);
    let c3 = new FinallyHttpInterceptor(InterceptorType.FINAL_RESPONSE, true);
    // 将拦截器对象加入拦截器链中
    chain.addChain([
      c1, c2, c3
    ]);
    // 将请求应用到拦截器链中
    chain.apply(httpRequest);
    // 创建请求可选项
    let options: http.HttpRequestOptions = {
      method: http.RequestMethod.POST,
      header: { "content-type": "text/html" } as Record<string, string>,
      extraData: { "context": "BODY_NO_CHANGE" } as Record<string, string>,
    };
    // 发起请求
    httpRequest.request(HTTP_URL, options, (err: BusinessError, res: http.HttpResponse) => {
      if (err) {
        console.log(`request fail, error code: ${err.code}, msg: ${err.message}`);
        promptAction.showToast({
          message: `request hit the interceptor fail`,
          duration: 4000, // 持续时间
          bottom: 300 // 与底间隔
        });
      } else {
        console.log(`res:${JSON.stringify(res)}`);
        promptAction.showToast({
          message: `request hit the interceptor successfully`,
          duration: 4000, // 持续时间
          bottom: 300 // 与底间隔
        });
      }
      // 销毁请求
      httpRequest.destroy();
    });
  } catch (error) {
    console.log(`catch ERROR-->:${JSON.stringify(error)}`);
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