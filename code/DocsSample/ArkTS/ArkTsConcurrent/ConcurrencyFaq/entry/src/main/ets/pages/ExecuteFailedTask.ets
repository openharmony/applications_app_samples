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
// [Start unsupport_task]
// index.ets
import { taskpool } from '@kit.ArkTS'
import { BusinessError } from '@kit.BasicServicesKit'
import { printArgs} from './utils'
@Concurrent
function createTask(a: number, b:number) {
  let sum = a + b;
  // task1: 不支持的序列化类型
  let task1: taskpool.Task = new taskpool.Task(printArgs, sum);
  return task1;
}

function executeTask() {
  // task
  let task: taskpool.Task = new taskpool.Task(createTask, 1, 2);
  taskpool.execute(task).then((res) => {
  }).catch((e: BusinessError) => {
    // 打印“返回结果序列化失败”异常信息
    console.error('execute task failed ' + e.message);
  })
}
// [End unsupport_task]