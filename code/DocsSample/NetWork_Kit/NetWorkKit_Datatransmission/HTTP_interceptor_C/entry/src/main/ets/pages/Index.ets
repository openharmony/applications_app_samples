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

import { promptAction } from '@kit.ArkUI';
// [Start HttpInterceptor_C_full_example]
import httpInterceptor from 'libentry.so';
import { http } from '@kit.NetworkKit';

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
              console.log('AddResponseInterceptor ret:', ret);
            })

          Button('Start Interceptors')
            .id('StartInterceptors')
            .onClick(() => {
              let ret = httpInterceptor.StartInterceptors();
              console.log('StartInterceptors ret:', ret);
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
                  console.info(`request fail, error code: ${err.code}, msg: ${err.message}`);
                  httpRequest.destroy();
                } else {
                  console.info(`res:${JSON.stringify(res)}`);
                  httpRequest.destroy();
                }
              });
            })

          Button('Stop Interceptors')
            .id('StopInterceptors')
            .onClick(() => {
              let ret = httpInterceptor.StopInterceptors();
              console.log('StopInterceptors ret:', ret);
            })

          Button('Remove Interceptor')
            .id('RemoveInterceptor')
            .onClick(() => {
              let ret = httpInterceptor.RemoveInterceptor();
              console.log('RemoveInterceptor ret:', ret);
            })

          Button('Remove All Interceptors')
            .id('RemoveAllInterceptors')
            .onClick(() => {
              let ret = httpInterceptor.RemoveAllInterceptors();
              console.log('RemoveAllInterceptors ret:', ret);
            })
        }
      }
      .padding(20)
    }
  }
}
// [End HttpInterceptor_C_full_example]