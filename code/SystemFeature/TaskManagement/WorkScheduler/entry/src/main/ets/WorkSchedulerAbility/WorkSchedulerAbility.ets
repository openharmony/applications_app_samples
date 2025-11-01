/*
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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

import {workScheduler, WorkSchedulerExtensionAbility} from '@kit.BackgroundTasksKit';
import { http } from '@kit.NetworkKit';
import { notificationSubscribe } from '@kit.NotificationKit';
import { WorkSchedulerSystem } from '../feature/WorkSchedulerSystem';
import { Logger } from '../utils/Logger';

const VERSION: string = '1.0';
const HTTP_STATUS_CODE: number = 200;
const URL: string = 'https://gitcode.com/openharmony/applications_app_samples/blob/master/code/DataMock/' +
  'WorkScheduler/UpdateWorkScheduler.hap';
const BUNDLE_NAME = ['ohos.samples.workschedulerextensionability'];

export default class WorkSchedulerAbility extends WorkSchedulerExtensionAbility {
  // 延迟任务开始回调
  onWorkStart(workInfo: workScheduler.WorkInfo) {
    Logger.info('WorkScheduler', 'WorkSchedulerAbility start 838078');
    // 打印 parameters中的参数，如：参数key1
    // console.info(`work info parameters: ${JSON.parse(workInfo.parameters?.toString()).key1}`)
    let version:string = '';
    let filePath: string = '';
    if (workInfo.parameters) {
      filePath = JSON.parse(workInfo.parameters?.toString()).filePath;
      version = JSON.parse(workInfo.parameters?.toString()).version;
    }
    Logger.info('838078 WorkScheduler version: %{public}s', JSON.stringify(version));
    if (version === VERSION) {
      let result: Promise<http.HttpResponse> = WorkSchedulerSystem.getNewHap(URL);
      result.then(data => {
        Logger.info('838078WorkScheduler', 'getNewHap success' + data.responseCode);
        if (data.responseCode === HTTP_STATUS_CODE) {
          Logger.info('838078WorkScheduler', 'saveFile start');
          WorkSchedulerSystem.saveFile(filePath, data.result as ArrayBuffer);
          Logger.info('838078WorkScheduler', 'saveFile success, publishNotification start');
          WorkSchedulerSystem.publishNotification('download', 'isReady', 'download hap to update the application');
          Logger.info('838078WorkScheduler', 'publishNotification success');
          notificationSubscribe.subscribe({
            onConsume: (data) => {
              if (data.request.content.normal?.text === 'allow') {
                let path: string[] = [];
                path.push(filePath);
                WorkSchedulerSystem.installBundle(path);
              }
            }
          }, {
            bundleNames: BUNDLE_NAME
          })
        }
      })
    }
  }

  // 延迟任务结束回调。当延迟任务2分钟超时或应用调用stopWork接口取消任务时，触发该回调。
  onWorkStop(workInfo: workScheduler.WorkInfo) {
    console.info(`onWorkStop, workInfo is ${JSON.stringify(workInfo)}`);
  }
}