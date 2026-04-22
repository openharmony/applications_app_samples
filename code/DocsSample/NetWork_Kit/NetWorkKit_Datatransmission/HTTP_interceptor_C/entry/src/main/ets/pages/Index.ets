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
        }
      }
      .padding(20)
    }
  }
}
// [End HttpInterceptor_C_full_example]