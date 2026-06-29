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

// [Start extension_include]
import {workScheduler, WorkSchedulerExtensionAbility} from '@kit.BackgroundTasksKit';
// [End extension_include]
import { Logger } from '../utils/Logger';

// [Start workSchedulerExtension]
export default class WorkSchedulerAbility extends WorkSchedulerExtensionAbility {
  // 延迟任务开始回调
  onWorkStart(workInfo: workScheduler.WorkInfo) {
    // [StartExclude workSchedulerExtension]
    Logger.info('WorkScheduler', 'WorkSchedulerAbility start');
    // [EndExclude workSchedulerExtension]
    console.info(`onWorkStart, workInfo = ${JSON.stringify(workInfo)}`);
    // 打印 parameters中的参数，如：参数key1
    console.info(`work info parameters: ${JSON.parse(workInfo.parameters?.toString()).key1}`);
  }

  // 延迟任务结束回调。当延迟任务2分钟超时或应用调用stopWork接口取消任务时，触发该回调。
  onWorkStop(workInfo: workScheduler.WorkInfo) {
    console.info(`onWorkStop, workInfo is ${JSON.stringify(workInfo)}`);
  }
}
// [End workSchedulerExtension]