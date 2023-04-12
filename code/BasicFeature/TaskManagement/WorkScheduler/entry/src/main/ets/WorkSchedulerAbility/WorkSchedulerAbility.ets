/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import WorkSchedulerExtensionAbility from '@ohos.WorkSchedulerExtensionAbility'
import http from '@ohos.net.http'
import Notification from '@ohos.notification'
import { WorkSchedulerSystem } from '../feature/WorkSchedulerSystem'
import { Logger } from '../utils/Logger'

const VERSION: string = '1.0'
const HTTP_STATUS_CODE: number = 200
const URL: string = 'https://gitee.com/openharmony/applications_app_samples/raw/' +
'OpenHarmony_4.X_Dev/DataMock/WorkScheduler/UpdateWorkScheduler.hap'
const BUNDLE_NAME = ['ohos.samples.workschedulerextensionability']

export default class WorkSchedulerAbility extends WorkSchedulerExtensionAbility {
  onWorkStart(workInfo) {
    let filePath = JSON.parse(workInfo.parameters).filePath
    if (JSON.parse(workInfo.parameters).version === VERSION) {
      let result: Promise<http.HttpResponse> = WorkSchedulerSystem.getNewHap(URL)
      result.then(data => {
        if (data.responseCode === HTTP_STATUS_CODE) {
          WorkSchedulerSystem.saveFile(filePath, data.result as ArrayBuffer)
          WorkSchedulerSystem.publishNotification('download', 'isReady', 'download hap to update the application')
          Notification.subscribe({
            onConsume: (data) => {
              if (data.request.content.normal.text === 'allow') {
                let path: string[] = []
                path.push(filePath)
                WorkSchedulerSystem.installBundle(path)
              }
            }
          }, {
            bundleNames: BUNDLE_NAME
          })
        }
      })
    }
  }
}