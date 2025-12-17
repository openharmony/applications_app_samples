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

// [Start HTTP_case_module_import_data_request]
import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
// [End HTTP_case_module_import_data_request]

import { ComponentId } from '../common/CommonConstant';
import { promptAction, Router } from '@kit.ArkUI';

// 常量定义
const LOG_TAG: string = '[Sample_HttpRequestDemo]';

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

      // 第三个按钮：HTTP 拓展WebDav请求
      Button($r('app.string.Stream_HTTP_Request_WebDav_Button'))
        .onClick(() => {
          let page = new Router();
          page.pushUrl({ url: 'pages/WebDav' });
        })
        .width('80%')
        .height($r('app.float.height50'))
        .margin({ top: $r('app.float.margin20') })
        .backgroundColor(Color.Red)
        .fontColor(Color.White)
        .fontSize($r('app.float.size20'))
        .borderRadius($r('app.float.borderRadius'))
        .id(ComponentId.HTTP_WEBDAV_BUTTON)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }

  // [Start request_interface_development]
  // 封装普通的 HTTP 请求逻辑
  private sendHttpRequest(): void {
    this.normalReqResult = $r('app.string.testing');
    // [Start HTTP_case_create_http_method]
    let context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
    // 每一个httpRequest对应一个HTTP请求任务，不可复用。
    let httpRequest = http.createHttp();
    // [End HTTP_case_create_http_method]

    // [Start HTTP_case_http_request_on_method]
    // 用于订阅HTTP响应头，此接口会比request请求先返回。可以根据业务需要订阅此消息。
    // 从API 8开始，使用on('headersReceive', Callback)替代on('headerReceive', AsyncCallback)。
    httpRequest.on('headersReceive', (header) => {
     hilog.info(0x0000, 'testTag', `header: ${JSON.stringify(header)}`);
    });
    // [End HTTP_case_http_request_on_method]

    // [Start HTTP_case_http_request_request_method]
    httpRequest.request(
      // 填写HTTP请求的URL地址，可以带参数也可以不带参数。URL地址需要开发者自定义。请求的参数可以在extraData中指定
      'EXAMPLE_URL',
      {
        method: http.RequestMethod.POST, // 可选，默认为http.RequestMethod.GET，用于从服务器获取数据，而POST方法用于向服务器上传数据。
        // 开发者根据自身业务需要添加header字段
        header: {
          'Content-Type': 'application/json'
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
        caPath:'/path/to/cacert.pem', // 可选，默认使用系统预制证书，自API 10开始支持该属性
        clientCert: { // 可选，默认不使用客户端证书，自API 11开始支持该属性
          certPath: '/path/to/client.pem', // 默认不使用客户端证书，自API 11开始支持该属性
          keyPath: '/path/to/client.key', // 若证书包含Key信息，传入空字符串，自API 11开始支持该属性
          certType: http.CertType.PEM, // 可选，默认使用PEM，自API 11开始支持该属性
          keyPassword: 'passwordToKey' // 可选，输入key文件的密码，自API 11开始支持该属性
        },
        // 可选，仅当Header中，'content-Type'为'multipart/form-data'时生效,自API 11开始支持该属性
        // 该属性用于支持向服务器上传二进制数据，根据上传的具体数据类型进行选择。
        multiFormDataList: [
          {
            name: 'Part1', // 数据名，自API 11开始支持该属性
            contentType: 'text/plain', // 数据类型，自API 11开始支持该属性，上传的数据类型为普通文本文件。
            data: 'Example data', // 可选，数据内容，自API 11开始支持该属性
            remoteFileName: 'example.txt' // 可选，自API 11开始支持该属性
          }, {
          name: 'Part2', // 数据名，自API 11开始支持该属性
          contentType: 'text/plain', // 数据类型，自API 11开始支持该属性，上传的数据类型为普通文本文件。
          // data/app/el2/100/base/com.example.myapplication/haps/entry/files/fileName.txt
          filePath: `${context.filesDir}/fileName.txt`, // 可选，传入文件路径，自API 11开始支持该属性
          remoteFileName: 'fileName.txt' // 可选，自API 11开始支持该属性
          }, {
            name: 'Part3', // 数据名，自API 11开始支持该属性。
            contentType: 'image/png', // 数据类型，自API 11开始支持该属性，上传的数据类型为png格式的图片。
            // data/app/el2/100/base/com.example.myapplication/haps/entry/files/fileName.png。
            filePath: `${context.filesDir}/fileName.png`, // 可选，传入文件路径，自API 11开始支持该属性。
            remoteFileName: 'fileName.png' // 可选，自API 11开始支持该属性。
          }, {
            name: 'Part4', // 数据名，自API 11开始支持该属性。
            contentType: 'audio/mpeg', // 数据类型，自API 11开始支持该属性，上传的数据类型为mpeg格式的音频。
            // data/app/el2/100/base/com.example.myapplication/haps/entry/files/fileName.mpeg。
            filePath: `${context.filesDir}/fileName.mpeg`, // 可选，传入文件路径，自API 11开始支持该属性。
            remoteFileName: 'fileName.mpeg' // 可选，自API 11开始支持该属性。
          }, {
            name: 'Part5', // 数据名，自API 11开始支持该属性。
            contentType: 'video/mp4', // 数据类型，自API 11开始支持该属性，上传的数据类型为mp4格式的视频。
            // data/app/el2/100/base/com.example.myapplication/haps/entry/files/fileName.mp4。
            filePath: `${context.filesDir}/fileName.mp4`, // 可选，传入文件路径，自API 11开始支持该属性。
            remoteFileName: 'fileName.mp4' // 可选，自API 11开始支持该属性。
          }
        ]
      }, (err: BusinessError, data: http.HttpResponse) => {
      if (!err) {
        // [StartExclude HTTP_case_http_request_request_method]
        // 请求成功，处理响应结果
        this.normalReqResult = $r('app.string.httpSendSuccess');
        promptAction.showToast({
          message: this.normalReqResult,
          duration: 4000, // 持续时间
          bottom: 300 // 与底间隔
        });
        // [EndExclude HTTP_case_http_request_request_method]
        // data.result为HTTP响应内容，可根据业务需要进行解析。
        hilog.info(0x0000, 'testTag', `Result: ${JSON.stringify(data.result)}`);
        hilog.info(0x0000, 'testTag', `code: ${JSON.stringify(data.responseCode)}`);
        // data.header为HTTP响应头，可根据业务需要进行解析。
        hilog.info(0x0000, 'testTag', `header: ${JSON.stringify(data.header)}`);
        hilog.info(0x0000, 'testTag', `cookies: ${JSON.stringify(data.cookies)}`);
        // 当该请求使用完毕时，调用destroy方法主动销毁。
        httpRequest.destroy();
      } else {
        // [StartExclude HTTP_case_http_request_request_method]
        this.normalReqResult = 'error:' + JSON.stringify(err);
        promptAction.showToast({
          message: this.normalReqResult,
          duration: 4000, // 持续时间
          bottom: 300 // 与底间隔
        });
        // [EndExclude HTTP_case_http_request_request_method]
        hilog.error(0x0000, 'testTag', `error: ${JSON.stringify(err)}`);
        // 取消订阅HTTP响应头事件
        httpRequest.off('headersReceive');
        // 当该请求使用完毕时，调用destroy方法主动销毁
        httpRequest.destroy();
      }
    }
    );
    // [End HTTP_case_http_request_request_method]
  }
  // [End request_interface_development]


  // [Start request_in_stream_interface_development]
  // 封装流式 HTTP 请求逻辑
  private sendStreamHttpRequest(): void {
    this.streamReqResult = $r('app.string.testing');
    // [Start request_in_stream_create_http_method]
    // 每一个httpRequest对应一个HTTP请求任务，不可复用。
    let httpRequest = http.createHttp();
    // [End request_in_stream_create_http_method]

    // [Start request_in_stream_data_receive]
    // 用于订阅HTTP流式响应数据接收事件。
    let res = new ArrayBuffer(0);
    // [StartExclude request_in_stream_data_receive]
    // 订阅HTTP响应头事件
    httpRequest.on('headersReceive', (header: Object) => {
      hilog.info(0x0000, 'testTag', `header: ${JSON.stringify(header)}`);
    });
    // [EndExclude request_in_stream_data_receive]
    // 订阅HTTP流式响应数据接收事件
    httpRequest.on('dataReceive', (data: ArrayBuffer) => {
      const newRes = new ArrayBuffer(res.byteLength + data.byteLength);
      const resView = new Uint8Array(newRes);
      resView.set(new Uint8Array(res));
      resView.set(new Uint8Array(data), res.byteLength);
      res = newRes;
      hilog.info(0x0000, 'testTag', `res length: ${res.byteLength}`);
    });

    // 用于订阅HTTP流式响应数据接收完毕事件。
    httpRequest.on('dataEnd', () => {
      hilog.info(0x0000, 'testTag', `No more data in response, data receive end`);
    });

    // 订阅HTTP流式响应数据接收进度事件，下载服务器的数据时，可以通过该回调获取数据下载进度。
    httpRequest.on('dataReceiveProgress', (data: http.DataReceiveProgressInfo) => {
      hilog.info(0x0000, 'testTag', 'dataReceiveProgress receiveSize:' + data.receiveSize + ', totalSize:' + data.totalSize);
    });

    // 订阅HTTP流式响应数据发送进度事件，向服务器上传数据时，可以通过该回调获取数据上传进度。
    httpRequest.on('dataSendProgress', (data: http.DataSendProgressInfo) => {
      hilog.info(0x0000, 'testTag', 'dataSendProgress receiveSize:' + data.sendSize + ', totalSize:' + data.totalSize);
    });
    // [End request_in_stream_data_receive]

    // [Start request_in_stream_get_server_data]
    let streamInfo: http.HttpRequestOptions = {
      method: http.RequestMethod.POST, // 可选，默认为http.RequestMethod.GET，用于向服务器获取数据，而POST方法用于向服务器上传数据。
      // 开发者根据自身业务需要添加header字段。
      header: {
        'Content-Type': 'application/json'
      },
      // 当使用POST请求时此字段用于传递请求体内容，具体格式与服务端协商确定。
      extraData: 'data to send', // 请求体内容
      expectDataType: http.HttpDataType.STRING, // 可选，指定返回数据的类型。
      usingCache: true,  // 可选，默认为true。
      priority: 1, // 可选，默认为1。
      connectTimeout: 60000, // 可选，默认为60000ms。
      readTimeout: 60000, // 可选，默认为60000ms。若传输的数据较大，需要较长的时间，建议增大该参数以保证数据传输正常终止。
      usingProtocol: http.HttpProtocol.HTTP1_1 // 可选，协议类型默认值由系统自动指定。
    };

    // 填写HTTP请求的URL地址，可以带参数也可以不带参数。URL地址需要开发者自定义。请求的参数可以在extraData中指定。
    httpRequest.requestInStream('EXAMPLE_URL', streamInfo)
      .then((data: number) => {
        // [StartExclude request_in_stream_get_server_data]
        this.streamReqResult = $r('app.string.testSuccess'); // 测试通过
        promptAction.showToast({
          message: this.streamReqResult,
          duration: 4000, // 持续时间
          bottom: 300 // 与底间隔
        });
        // [EndExclude request_in_stream_get_server_data]
        hilog.info(0x0000, 'testTag', `requestInStream OK!`);
        hilog.info(0x0000, 'testTag', `ResponseCode : ${JSON.stringify(data)}`);
        // 取消订阅步骤3中订阅的事件，并调用destroy方法主动销毁。
        this.destroyRequest(httpRequest);
        // [StartExclude request_in_stream_get_server_data]
        // 取消订阅事件
        httpRequest.off('headersReceive');
        // [EndExclude request_in_stream_get_server_data]
      }).catch((err: Error) => {
        // [StartExclude request_in_stream_get_server_data]
        this.streamReqResult = 'error:' + JSON.stringify(err); // 测试失败
        promptAction.showToast({
          message: this.streamReqResult,
          duration: 4000, // 持续时间
          bottom: 300 // 与底间隔
        });
        // [EndExclude request_in_stream_get_server_data]
        hilog.error(0x0000, 'testTag', `requestInStream ERROR : err = ${JSON.stringify(err)}`);
        // 取消订阅步骤3中订阅的事件，并调用destroy方法主动销毁。
        this.destroyRequest(httpRequest);
      })
      // [End request_in_stream_get_server_data]
  }
  // [End request_in_stream_interface_development]

  // [Start request_in_stream_destroy_request_method]
  public destroyRequest(httpRequest: http.HttpRequest) {
    // 取消订阅HTTP流式响应数据接收事件。
    httpRequest.off('dataReceive');
    // 取消订阅HTTP流式响应数据发送进度事件。
    httpRequest.off('dataSendProgress');
    // 取消订阅HTTP流式响应数据接收进度事件。
    httpRequest.off('dataReceiveProgress');
    // 取消订阅HTTP流式响应数据接收完毕事件。
    httpRequest.off('dataEnd');
    // 当该请求使用完毕时，调用destroy方法主动销毁。
    httpRequest.destroy();
  }
  // [End  request_in_stream_destroy_request_method]
}