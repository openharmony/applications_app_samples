/*
 * Copyright (c) 2023-2026 Huawei Device Co., Ltd.
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

import { BusinessError } from '@kit.BasicServicesKit';
import { workScheduler } from '@kit.BackgroundTasksKit';

export namespace WorkSchedulerSystem {
  export async function startUpdateSample(key1: string, module: string): Promise<void> {
    // [Start startWork]
    let workInfo: workScheduler.WorkInfo = {
      workId: 1,
      networkType: workScheduler.NetworkType.NETWORK_TYPE_ANY,
      bundleName: 'ohos.samples.workschedulerextensionability',
      abilityName: 'WorkSchedulerAbility',
      // [StartExclude startWork]
      parameters: {
        key1: key1,
        module: module
      }
      // [EndExclude startWork]
    }

    try {
      workScheduler.startWork(workInfo);
      console.info(`startWork success`);
    }
    catch (error) {
      console.error(`startWork failed. code is ${(error as BusinessError).code} message is ${(error as BusinessError).message}`);
    }
    // [End startWork]
  }

  async function stopWork(key1: string, module: string): Promise<void> {
    // [Start stopWork]
    let workInfo: workScheduler.WorkInfo = {
      workId: 1,
      networkType: workScheduler.NetworkType.NETWORK_TYPE_ANY,
      bundleName: 'ohos.samples.workschedulerextensionability',
      abilityName: 'WorkSchedulerAbility',
      // [StartExclude stopWork]
      parameters: {
        key1: key1,
        module: module
      }
      // [EndExclude stopWork]
    }
    try {
      workScheduler.stopWork(workInfo);
      console.info(`stopWork success`);
    } catch (error) {
      console.error(`stopWork failed. code is ${(error as BusinessError).code} message is ${(error as BusinessError).message}`);
    }
    // [End stopWork]
  }
}
