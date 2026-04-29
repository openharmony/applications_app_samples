/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

// [Start HttpInterceptor_C_full_example]
import { hilog } from '@kit.PerformanceAnalysisKit';
import httpInterceptor from 'libentry.so';
import { http } from '@kit.NetworkKit';

const LOG_TAG: string = 'HttpInterceptorDemo';
const HTTP_URL_BAIDU: string = "http://www.baidu.com";

@Entry
@Component
struct Index {
  @State message: string = 'ReadOnly Network Kit Response Interceptor';
  scroller: Scroller = new Scroller();

  build() {
    Scroll(this.scroller) {
      Column() {
        Text(this.message)
          .fontSize(20)
          .margin({ bottom: 30 })

        Button('Add ReadOnly Response Interceptor')
          .margin({ top: 10 })
          .width(350)
          .borderRadius(8)
          .id('AddInterceptor')
          .onClick(() => {
            let ret = httpInterceptor.AddReadOnlyResponseInterceptor();
            hilog.info(0x0000, LOG_TAG, `AddReadOnlyResponseInterceptor ret: ${ret}`);
          })

        Button('Start ReadOnly Response Interceptors')
          .id('StartInterceptors')
          .width(350)
          .borderRadius(8)
          .margin({ top: 15 })
          .onClick(() => {
            let ret = httpInterceptor.StartReadOnlyResponseInterceptors();
            hilog.info(0x0000, LOG_TAG, `StartReadOnlyResponseInterceptors ret: ${ret}`);
          })

        Button('Stop ReadOnly Response Interceptors')
          .id('StopInterceptors')
          .width(350)
          .borderRadius(8)
          .margin({ top: 15 })
          .onClick(() => {
            let ret = httpInterceptor.StopReadOnlyResponseInterceptors();
            hilog.info(0x0000, LOG_TAG, `StopReadOnlyResponseInterceptors ret: ${ret}`);
          })

        Button('Remove ReadOnly Response Interceptor')
          .id('RemoveInterceptor')
          .width(350)
          .borderRadius(8)
          .margin({ top: 15 })
          .onClick(() => {
            let ret = httpInterceptor.RemoveReadOnlyResponseInterceptor();
            hilog.info(0x0000, LOG_TAG, `RemoveReadOnlyResponseInterceptor ret: ${ret}`);
          })

        Button('Remove All ReadOnly Response Interceptors')
          .id('RemoveAllInterceptors')
          .width(350)
          .borderRadius(8)
          .margin({ top: 15, bottom: 30 })
          .onClick(() => {
            let ret = httpInterceptor.RemoveAllReadOnlyResponseInterceptors();
            hilog.info(0x0000, LOG_TAG, `RemoveAllReadOnlyResponseInterceptors ret: ${ret}`);
          })

        Text('Modify Network Kit Request Interceptor')
          .fontSize(20)
          .margin({ bottom: 30 })

        Button('Add Modify Request Interceptor')
          .id('AddModifyRequestInterceptor')
          .width(350)
          .borderRadius(8)
          .margin({ top: 10 })
          .onClick(() => {
            let ret = httpInterceptor.AddModifyRequestInterceptor();
            hilog.info(0x0000, LOG_TAG, `AddModifyRequestInterceptor ret: ${ret}`);
          })

        Button('Start Modify Request Interceptors')
          .id('StartModifyRequestInterceptors')
          .width(350)
          .borderRadius(8)
          .margin({ top: 15 })
          .onClick(() => {
            let ret = httpInterceptor.StartModifyRequestInterceptors();
            hilog.info(0x0000, LOG_TAG, `StartModifyRequestInterceptors ret: ${ret}`);
          })

        Button('Stop Modify Request Interceptors')
          .id('StopModifyRequestInterceptors')
          .width(350)
          .borderRadius(8)
          .margin({ top: 15 })
          .onClick(() => {
            let ret = httpInterceptor.StopModifyRequestInterceptors();
            hilog.info(0x0000, LOG_TAG, `StopModifyRequestInterceptors ret: ${ret}`);
          })

        Button('Remove Modify Request Interceptor')
          .id('RemoveModifyRequestInterceptor')
          .width(350)
          .borderRadius(8)
          .margin({ top: 15 })
          .onClick(() => {
            let ret = httpInterceptor.RemoveModifyRequestInterceptor();
            hilog.info(0x0000, LOG_TAG, `RemoveModifyRequestInterceptor ret: ${ret}`);
          })

        Button('Remove All Modify Request Interceptors')
          .id('RemoveAllModifyRequestInterceptors')
          .width(350)
          .borderRadius(8)
          .margin({ top: 15, bottom: 30 })
          .onClick(() => {
            let ret = httpInterceptor.RemoveAllModifyRequestInterceptors();
            hilog.info(0x0000, LOG_TAG, `RemoveAllModifyRequestInterceptors ret: ${ret}`);
          })

        Text('Modify Network Kit Response Interceptor')
          .fontSize(20)
          .margin({ bottom: 30 })

        Button('Add Modify Response Interceptor')
          .id('AddModifyResponseInterceptor')
          .width(350)
          .borderRadius(8)
          .margin({ top: 10 })
          .onClick(() => {
            let ret = httpInterceptor.AddModifyResponseInterceptor();
            hilog.info(0x0000, LOG_TAG, `AddModifyResponseInterceptor ret: ${ret}`);
          })

        Button('Start Modify Response Interceptors')
          .id('StartModifyResponseInterceptors')
          .width(350)
          .borderRadius(8)
          .margin({ top: 15 })
          .onClick(() => {
            let ret = httpInterceptor.StartModifyResponseInterceptors();
            hilog.info(0x0000, LOG_TAG, `StartModifyResponseInterceptors ret: ${ret}`);
          })

        Button('Stop Modify Response Interceptors')
          .id('StopModifyResponseInterceptors')
          .width(350)
          .borderRadius(8)
          .margin({ top: 15 })
          .onClick(() => {
            let ret = httpInterceptor.StopModifyResponseInterceptors();
            hilog.info(0x0000, LOG_TAG, `StopModifyResponseInterceptors ret: ${ret}`);
          })

        Button('Remove Modify Response Interceptor')
          .id('RemoveModifyResponseInterceptor')
          .width(350)
          .borderRadius(8)
          .margin({ top: 15 })
          .onClick(() => {
            let ret = httpInterceptor.RemoveModifyResponseInterceptor();
            hilog.info(0x0000, LOG_TAG, `RemoveModifyResponseInterceptor ret: ${ret}`);
          })

        Button('Remove All Modify Response Interceptors')
          .id('RemoveAllModifyResponseInterceptors')
          .width(350)
          .borderRadius(8)
          .margin({ top: 15, bottom: 30 })
          .onClick(() => {
            let ret = httpInterceptor.RemoveAllModifyResponseInterceptors();
            hilog.info(0x0000, LOG_TAG, `RemoveAllModifyResponseInterceptors ret: ${ret}`);
          })

        Text('Send HTTP Request')
          .fontSize(20)
          .margin({ bottom: 30 })

        Button('Send HTTP Request')
          .id('networkRequest')
          .width(350)
          .borderRadius(8)
          .margin({ top: 15 })
          .onClick(() => {
            let httpRequest: http.HttpRequest = http.createHttp();
            let options: http.HttpRequestOptions = {
              method: http.RequestMethod.POST,
            };
            httpRequest.request(HTTP_URL_BAIDU, options, (err: BusinessError, res: http.HttpResponse) => {
              if (err) {
                hilog.info(0x0000, LOG_TAG, `request fail, error code: ${err.code}, msg: ${err.message}`);
                httpRequest.destroy();
              } else {
                hilog.info(0x0000, LOG_TAG, `res:${JSON.stringify(res)}`);
                httpRequest.destroy();
              }
            });
          })
      }
      .width('100%')
    }
  }
}
// [End HttpInterceptor_C_full_example]