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

import http from '@ohos.net.http'
import Logger from './Logger'

const TAG: string = 'HttpUtil'

export default class HttpUtil {
  static async getDrmResponse(url: string, _extraData: string): Promise<string> {
    let responseData: string = 'defaultStr'
    let httpRequest = http.createHttp()
    let response = await httpRequest.request(url, {
      method: http.RequestMethod.POST,
      header: {
        'Content-Type': 'application/json',
        'Accept-Encoding': 'gzip, deflate',
      },
      extraData: _extraData,
      expectDataType: http.HttpDataType.STRING,
    })

    if (response?.responseCode == 200) {
      if (typeof response.result == 'string') {
        responseData = response.result
        Logger.info(TAG, 'responseData Length:' + responseData.length)
      } else {
        Logger.error(TAG, 'error:' + typeof response.result)
      }
      httpRequest.destroy()
    } else {
      Logger.error(TAG, 'error: responseCode' + response.responseCode)
    }
    return responseData
  }
}