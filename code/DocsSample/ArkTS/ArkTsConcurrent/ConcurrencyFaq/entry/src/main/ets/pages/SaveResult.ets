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
// [Start save_result]
// Index.ets
import { taskpool } from '@kit.ArkTS'
import { BusinessError } from '@kit.BasicServicesKit'
import { TestClass } from './Sendable'

@Concurrent
function createTask(a: number): string {
  return `test${a}`;
}
function executeTask() {
  let testObject: TestClass = new TestClass();
  let task: taskpool.Task = new taskpool.Task(createTask, 1)
  taskpool.execute(task).then((res) => {
    testObject.setName(res as string);
    console.info('execute task success, name is ' + testObject.getName());
  }).catch((e: BusinessError) => {
    console.error('execute task error: ' + e.message);
  })
}
// [End save_result]