/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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
import Logger from '../util/Logger'
import { ShareConst } from '../util/ShareConst'

const TAG: string = 'httpRequest'

export function httpRequest(url, method, params, callback) {
  let httpRequest = http.createHttp()
  httpRequest.request(url,
    {
      method: http.RequestMethod.GET,
      header: {
        'Content-Type': 'application/json'
      },
      readTimeout: ShareConst.TIMEOUT_NUMBER,
      connectTimeout: ShareConst.TIMEOUT_NUMBER
    }, (err, data) => {
      if (!err) {
        callback(data)
      } else {
        Logger.info(TAG, `error: ${JSON.stringify(err)}`)
      }
    })
}