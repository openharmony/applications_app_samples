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

import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import Logger from '../common/Logger';
import { ComponentId } from '../common/CommonConstant';
import { promptAction } from '@kit.ArkUI';

// 常量定义
const LOG_TAG: string = '[Sample_HttpRequestDemo]';
const TARGET_URL: string = '';

@Entry
@Component
struct HttpRequestDemo {
  @State normalReqResult: ResourceStr = '';
  @State streamReqResult: ResourceStr = '';

  build() {
    Column() {
      Text($r('app.string.HTTP_Request_Example'))
        .fontSize($r('app.float.size20'))
        .id(ComponentId.HTTP_TITLE)
        .margin({ bottom: $r('app.float.margin20') })

      // 第一个按钮：普通 HTTP 请求
      Button($r('app.string.HTTP_Request_Button'))
        .onClick(() => {
          this.sendHttpRequest();
        })
        .width('80%')
        .height($r('app.float.height50'))
        .margin({ top: $r('app.float.margin20') })
        .backgroundColor(Color.Blue)
        .fontColor(Color.White)
        .fontSize($r('app.float.size20'))
        .borderRadius($r('app.float.borderRadius'))
        .id(ComponentId.HTTP_BUTTON)

      // 第二个按钮：流式 HTTP 请求
      Button($r('app.string.Stream_HTTP_Request_Button'))
        .onClick(() => {
          this.sendStreamHttpRequest();
        })
        .width('80%')
        .height($r('app.float.height50'))
        .margin({ top: $r('app.float.margin20') })
        .backgroundColor(Color.Green)
        .fontColor(Color.White)
        .fontSize($r('app.float.size20'))
        .borderRadius($r('app.float.borderRadius'))
        .id(ComponentId.STREAM_HTTP_BUTTON)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
  
  // [Start request_interface_development]
  // 封装普通的 HTTP 请求逻辑
  private sendHttpRequest(): void {
    this.normalReqResult = $r('app.string.testing');
    let httpRequest = http.createHttp();

    // 订阅HTTP响应头
    httpRequest.on('headersReceive', (header) => {
      Logger.info(`${LOG_TAG} header: ${JSON.stringify(header)}`);
    });

    httpRequest.request(
      // 填写HTTP请求的URL地址，可以带参数也可以不带参数。URL地址需要开发者自定义。请求的参数可以在extraData中指定
      TARGET_URL,
      {
        method: http.RequestMethod.POST, // 可选，默认为http.RequestMethod.GET
        // 开发者根据自身业务需要添加header字段
        header: {
          'contentType': 'application/json'
        },
        // 当使用POST请求时此字段用于传递请求体内容，具体格式与服务端协商确定
        extraData: 'data to send',
        expectDataType: http.HttpDataType.STRING, // 可选，指定返回数据的类型
        usingCache: true, // 可选，默认为true
        priority: 1, // 可选，默认为1
        connectTimeout: 60000, // 可选，默认为60000ms
        readTimeout: 60000, // 可选，默认为60000ms
        usingProtocol: http.HttpProtocol.HTTP1_1, // 可选，协议类型默认值由系统自动指定
        usingProxy: false, // 可选，默认不使用网络代理，自API 10开始支持该属性
        // caPath:'/path/to/cacert.pem', // 可选，默认使用系统预制证书，自API 10开始支持该属性
        // clientCert: { // 可选，默认不使用客户端证书，自API 11开始支持该属性
        //   certPath: '/path/to/client.pem', // 默认不使用客户端证书，自API 11开始支持该属性
        //   keyPath: '/path/to/client.key', // 若证书包含Key信息，传入空字符串，自API 11开始支持该属性
        //   certType: http.CertType.PEM, // 可选，默认使用PEM，自API 11开始支持该属性
        //   keyPassword: "passwordToKey" // 可选，输入key文件的密码，自API 11开始支持该属性
        // },
        multiFormDataList: [ // 可选，仅当Header中，'content-Type'为'multipart/form-data'时生效，自API 11开始支持该属性
          {
            name: 'Part1', // 数据名，自API 11开始支持该属性
            contentType: 'text/plain', // 数据类型，自API 11开始支持该属性
            data: 'Example data', // 可选，数据内容，自API 11开始支持该属性
            remoteFileName: 'example.txt' // 可选，自API 11开始支持该属性
          }, {
          name: 'Part2', // 数据名，自API 11开始支持该属性
          contentType: 'text/plain', // 数据类型，自API 11开始支持该属性
          // data/app/el2/100/base/com.example.myapplication/haps/entry/files/fileName.txt
          filePath: `${getContext(this).filesDir}/fileName.txt`, // 可选，传入文件路径，自API 11开始支持该属性
          remoteFileName: 'fileName.txt' // 可选，自API 11开始支持该属性
        }
        ]
      }, (err: BusinessError, data: http.HttpResponse) => {
      if (!err) {
        // 请求成功，处理响应结果
        this.normalReqResult = $r('app.string.httpSendSuccess');
        promptAction.showToast({
          message: this.normalReqResult,
          duration: 4000, // 持续时间
          bottom: 300 // 与底间隔
        });
        Logger.info(`${LOG_TAG} Result: ${JSON.stringify(data.result)}`);
        Logger.info(`${LOG_TAG} code: ${JSON.stringify(data.responseCode)}`);
        Logger.info(`${LOG_TAG} header: ${JSON.stringify(data.header)}`);
        Logger.info(`${LOG_TAG} cookies: ${JSON.stringify(data.cookies)}`);

        httpRequest.destroy();
      } else {
        this.normalReqResult = 'error:' + JSON.stringify(err);
        promptAction.showToast({
          message: this.normalReqResult,
          duration: 4000, // 持续时间
          bottom: 300 // 与底间隔
        });
        // 请求失败，处理错误
        Logger.error(`${LOG_TAG} error: ${JSON.stringify(err)}`);
        // 取消订阅HTTP响应头事件
        httpRequest.off('headersReceive');

        // 当该请求使用完毕时，调用destroy方法主动销毁
        httpRequest.destroy();
      }
    }
    );
  }
  // [End request_interface_development]

  // [Start request_in_stream_interface_development]
  // 封装流式 HTTP 请求逻辑
  private sendStreamHttpRequest(): void {
    this.streamReqResult = $r('app.string.testing');
    let httpRequest = http.createHttp();
    let res = new ArrayBuffer(0);

    // 订阅HTTP响应头事件
    httpRequest.on('headersReceive', (header: Object) => {
      Logger.info(`${LOG_TAG} header: ${JSON.stringify(header)}`);
    });

    // 订阅HTTP流式响应数据接收事件
    httpRequest.on('dataReceive', (data: ArrayBuffer) => {
      const newRes = new ArrayBuffer(res.byteLength + data.byteLength);
      const resView = new Uint8Array(newRes);
      resView.set(new Uint8Array(res));
      resView.set(new Uint8Array(data), res.byteLength);
      res = newRes;
      Logger.info(`${LOG_TAG} res length: ${res.byteLength}`);
    });

    // 订阅HTTP流式响应数据接收完毕事件
    httpRequest.on('dataEnd', () => {
      Logger.info(`${LOG_TAG} No more data in response, data receive end`);
    });

    class Data {
      public receiveSize: number = 0;
      public totalSize: number = 0;
    }

    // 订阅HTTP流式响应数据接收进度事见
    httpRequest.on('dataReceiveProgress', (data: Data) => {
      Logger.info(`${LOG_TAG} dataReceiveProgress receiveSize: ${data.receiveSize},totalSize: ${data.totalSize}`);
    });

    let streamInfo: http.HttpRequestOptions = {
      method: http.RequestMethod.POST, // 使用POST请求
      header: {
        'contentType': 'application/json'
      },
      extraData: 'data to send', // 请求体内容
      expectDataType: http.HttpDataType.STRING, // 指定返回数据的类型
      usingCache: true, // 使用缓存
      priority: 1, // 请求优先级
      connectTimeout: 60000, // 连接超时
      readTimeout: 60000, // 读取超时
      usingProtocol: http.HttpProtocol.HTTP1_1 // 协议类型
    };

    // 发送流式请求
    httpRequest.requestInStream(TARGET_URL, streamInfo)
      .then((data: number) => {
        this.streamReqResult = $r('app.string.testSuccess'); // 测试通过
        promptAction.showToast({
          message: this.streamReqResult,
          duration: 4000, // 持续时间
          bottom: 300 // 与底间隔
        });
        Logger.info(`${LOG_TAG} requestInStream OK!`);
        Logger.info(`${LOG_TAG} ResponseCode : ${JSON.stringify(data)}`);

        // 取消订阅事件
        httpRequest.off('headersReceive');
        httpRequest.off('dataReceive');
        httpRequest.off('dataReceiveProgress');
        httpRequest.off('dataEnd');
      })
      .catch((err: Error) => {
        this.streamReqResult = 'error:' + JSON.stringify(err); // 测试失败
        promptAction.showToast({
          message: this.streamReqResult,
          duration: 4000, // 持续时间
          bottom: 300 // 与底间隔
        });
        Logger.error(`${LOG_TAG} requestInStream ERROR : err = ${JSON.stringify(err)}`);
      })
      .finally(() => {
        // 销毁请求对象
        httpRequest.destroy();
      });
  }
  // [End request_in_stream_interface_development]
}