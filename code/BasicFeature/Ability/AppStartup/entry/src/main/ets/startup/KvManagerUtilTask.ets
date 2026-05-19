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

import StartupTask from '@ohos.app.appstartup.StartupTask';
import common from '@ohos.app.ability.common';
import { KvManagerUtil, TimeUtils } from '../util/SingleKVStore';
import distributedKVStore from '@ohos.data.distributedKVStore';
import systemDateTime from '@ohos.systemDateTime';

@Sendable
export default class KvManagerUtilTask extends StartupTask {
  constructor() {
    super();
  }

  async init(context: common.AbilityStageContext): Promise<distributedKVStore.KVManager> {
    let time = systemDateTime.getTime(false);
    TimeUtils.startTime = time;
    return KvManagerUtil.getInstance(context);
  }

  onDependencyCompleted(dependence: string, result: Object): void {
  }
}