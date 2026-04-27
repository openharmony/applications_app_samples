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
  @State message: string = 'HTTP Interceptor Demo';

  build() {
    Navigation() {
      Column() {
        Text(this.message)
          .fontSize(20)
          .margin({ bottom: 20 })

        Column({
          space: 12
        }) {
          Button('Add Response Interceptor')
            .id('AddInterceptor')
            .onClick(() => {
              let ret = httpInterceptor.AddResponseInterceptor();
              hilog.info(0x0000, LOG_TAG, `AddResponseInterceptor ret: ${ret}`);
            })

          Button('Start Interceptors')
            .id('StartInterceptors')
            .onClick(() => {
              let ret = httpInterceptor.StartInterceptors();
              hilog.info(0x0000, LOG_TAG, `StartInterceptors ret: ${ret}`);
            })

          Button('Send HTTP Request')
            .id('networkRequest')
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

          Button('Stop Interceptors')
            .id('StopInterceptors')
            .onClick(() => {
              let ret = httpInterceptor.StopInterceptors();
              hilog.info(0x0000, LOG_TAG, `StopInterceptors ret: ${ret}`);
            })

          Button('Remove Interceptor')
            .id('RemoveInterceptor')
            .onClick(() => {
              let ret = httpInterceptor.RemoveInterceptor();
              hilog.info(0x0000, LOG_TAG, `RemoveInterceptor ret: ${ret}`);
            })

          Button('Remove All Interceptors')
            .id('RemoveAllInterceptors')
            .onClick(() => {
              let ret = httpInterceptor.RemoveAllInterceptors();
              hilog.info(0x0000, LOG_TAG, `RemoveAllInterceptors ret: ${ret}`);
            })

          Text('Modify Network Kit Request Interceptor')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 10 })

          Button('Add Modify Request Interceptor')
            .id('AddModifyRequestInterceptor')
            .onClick(() => {
              let ret = httpInterceptor.AddModifyRequestInterceptor();
              hilog.info(0x0000, LOG_TAG, `AddModifyRequestInterceptor ret: ${ret}`);
            })

          Button('Start Modify Request Interceptors')
            .id('StartModifyRequestInterceptors')
            .onClick(() => {
              let ret = httpInterceptor.StartModifyRequestInterceptors();
              hilog.info(0x0000, LOG_TAG, `StartModifyRequestInterceptors ret: ${ret}`);
            })

          Button('Stop Modify Request Interceptors')
            .id('StopModifyRequestInterceptors')
            .onClick(() => {
              let ret = httpInterceptor.StopModifyRequestInterceptors();
              hilog.info(0x0000, LOG_TAG, `StopModifyRequestInterceptors ret: ${ret}`);
            })

          Button('Remove Modify Request Interceptor')
            .id('RemoveModifyRequestInterceptor')
            .onClick(() => {
              let ret = httpInterceptor.RemoveModifyRequestInterceptor();
              hilog.info(0x0000, LOG_TAG, `RemoveModifyRequestInterceptor ret: ${ret}`);
            })

          Button('Remove All Modify Request Interceptors')
            .id('RemoveAllModifyRequestInterceptors')
            .onClick(() => {
              let ret = httpInterceptor.RemoveAllModifyRequestInterceptors();
              hilog.info(0x0000, LOG_TAG, `RemoveAllModifyRequestInterceptors ret: ${ret}`);
            })

          Text('Modify Network Kit Response Interceptor')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 10 })

          Button('Add Modify Response Interceptor')
            .id('AddModifyResponseInterceptor')
            .onClick(() => {
              let ret = httpInterceptor.AddModifyResponseInterceptor();
              hilog.info(0x0000, LOG_TAG, `AddModifyResponseInterceptor ret: ${ret}`);
            })

          Button('Start Modify Response Interceptors')
            .id('StartModifyResponseInterceptors')
            .onClick(() => {
              let ret = httpInterceptor.StartModifyResponseInterceptors();
              hilog.info(0x0000, LOG_TAG, `StartModifyResponseInterceptors ret: ${ret}`);
            })

          Button('Stop Modify Response Interceptors')
            .id('StopModifyResponseInterceptors')
            .onClick(() => {
              let ret = httpInterceptor.StopModifyResponseInterceptors();
              hilog.info(0x0000, LOG_TAG, `StopModifyResponseInterceptors ret: ${ret}`);
            })

          Button('Remove Modify Response Interceptor')
            .id('RemoveModifyResponseInterceptor')
            .onClick(() => {
              let ret = httpInterceptor.RemoveModifyResponseInterceptor();
              hilog.info(0x0000, LOG_TAG, `RemoveModifyResponseInterceptor ret: ${ret}`);
            })

          Button('Remove All Modify Response Interceptors')
            .id('RemoveAllModifyResponseInterceptors')
            .onClick(() => {
              let ret = httpInterceptor.RemoveAllModifyResponseInterceptors();
              hilog.info(0x0000, LOG_TAG, `RemoveAllModifyResponseInterceptors ret: ${ret}`);
            })
        }
      }
      .padding(20)
    }
  }
}
// [End HttpInterceptor_C_full_example]