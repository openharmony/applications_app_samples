/*
 * Copyright (c) 2021-2023 Huawei Device Co., Ltd.
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

import rpc from '@ohos.rpc'
import { Logger } from '../common/Logger'
import { PRICE_LIST } from '../muck/MyData'

const TAG = '[eTSRPC.ReceivedData]'
let resultList: Array<number> = Array.from({ length: 4 }, () => 0)

class ReceivedData extends rpc.RemoteObject {
  onRemoteRequest(code: number, data: rpc.MessageParcel, reply: rpc.MessageParcel, option: rpc.MessageOption): boolean {
    Logger.info(TAG, `called`)
    if (code === 1) {
      let result = 0
      let readIntArr
      try {
        readIntArr = data.readStringArray()
      } catch (err) {
        Logger.error(`readStringArray failed, code is ${err.code}, message is ${err.message}`)
      }
      Logger.info(TAG, `readIntArr= ${readIntArr}`)
      for (let i = 0; i < 4; i++) {
        if (readIntArr[i] === '0') {
          resultList[i] = 0
        } else {
          resultList[i] = PRICE_LIST.get(readIntArr[i]) * Number(readIntArr[i+4])
        }
        Logger.info(TAG, `this.resultList= ${resultList}`)
        result += resultList[i]
      }
      try {
        reply.writeInt(result)
      } catch (err) {
        Logger.error(TAG, `writeInt failed, code is ${err.code}, message is ${err.message}`)
      }
      Logger.info(TAG, `result= ${result}`)
    } else {
      Logger.info(TAG, `unknown request code`)
    }
    return true
  }
}

export default new ReceivedData('send')