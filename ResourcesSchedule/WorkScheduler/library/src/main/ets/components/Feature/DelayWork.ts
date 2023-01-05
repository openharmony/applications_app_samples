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

import prompt from '@ohos.prompt'
import workScheduler from '@ohos.resourceschedule.workScheduler'
import { Logger } from '@ohos/notification'

const TAG: string = 'DelayWork'

export default class DelayWork {
  private workInfo = {
    workId: 1,
    networkType: workScheduler.NetworkType.NETWORK_TYPE_WIFI,
    bundleName: '',
    abilityName: ''
  }
  // 注册延迟调度任务
  startWork(bundleName: string, abilityName: string) {
    this.workInfo.bundleName = bundleName
    this.workInfo.abilityName = abilityName
    try {
      workScheduler.startWork(this.workInfo)
      Logger.info(TAG, `startWork success`)
    } catch (error) {
      Logger.error(TAG, `startWork startwork failed. code is ${error.code} message is ${error.message}`)
      prompt.showToast({
        message: `${error.message}`
      })
    }
  }

  // 停止延迟调度任务
  stopWork(bundleName: string, abilityName: string) {
    this.workInfo.bundleName = bundleName
    this.workInfo.abilityName = abilityName
    workScheduler.stopWork(this.workInfo, false)
    Logger.info(TAG, `stopWork`)
  }
}