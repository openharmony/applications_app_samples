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
// [Start initialize_item]
// Index.ets
import { taskpool } from '@kit.ArkTS'
import { BusinessError } from '@kit.BasicServicesKit'
import { SendableItem } from './Sendable'

@Concurrent
function createTask() {
  let data = new SendableItem();
}

function executeTask() {
  let task = new taskpool.Task(createTask);
  taskpool.execute(task).then((res) => {
    console.info('execute task success');
  }).catch((e: BusinessError) => {
    console.error('execute task error: ' + e.message);
  })
}

executeTask();
// [End initialize_item]