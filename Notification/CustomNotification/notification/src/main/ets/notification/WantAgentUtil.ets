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

import wantAgent from '@ohos.wantAgent'

const REQUEST_CODE: number = 0 // WantAgentInfo的请求码，默认定义成0
class WantAgentUtil {
  /**
   * create wantAgent for start ability
   *
   * @param bundleName
   * @param abilityName
   * @return return the created WantAgent object.
   */
  async createWantAgentForStartAbility(bundleName: string, abilityName: string) {
    let wantAgentInfo = {
      wants: [
        {
          bundleName: bundleName,
          abilityName: abilityName
        }
      ],
      operationType: wantAgent.OperationType.START_ABILITY,
      requestCode: REQUEST_CODE // requestCode是WantAgentInfo的请求码，是使用者定义的一个私有值
    }
    return await wantAgent.getWantAgent(wantAgentInfo)
  }

  /**
   * create wantAgent for common event
   *
   * @param mAction
   * @return return the created WantAgent object.
   */
  async createWantAgentForCommonEvent(action: string) {
    let wantAgentInfo = {
      wants: [{ action: action }],
      operationType: wantAgent.OperationType.SEND_COMMON_EVENT,
      requestCode: REQUEST_CODE // requestCode是WantAgentInfo的请求码，是使用者定义的一个私有值
    }
    return await wantAgent.getWantAgent(wantAgentInfo)
  }
}

export let wantAgentUtil = new WantAgentUtil()