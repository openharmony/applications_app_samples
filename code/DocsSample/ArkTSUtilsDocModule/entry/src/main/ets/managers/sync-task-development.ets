/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { taskpool } from '@kit.ArkTS';
import Handle from './Handle'; // 返回静态句柄

// 步骤1: 定义并发函数，内部调用同步方法
@Concurrent
function func(num: number): number {
  // 调用静态类对象中实现的同步等待调用
  // 先调用syncSet方法并将其结果作为syncSet2的参数，模拟同步调用逻辑
  let tmpNum: number = Handle.syncSet(num);
  console.info('this is Child_Thread');
  return Handle.syncSet2(tmpNum);
}

// 步骤2: 创建任务并执行
async function asyncGet(): Promise<boolean> {
  // 创建task、task2并传入函数func
  let task: taskpool.Task = new taskpool.Task(func, 1);
  let task2: taskpool.Task = new taskpool.Task(func, 2);
  // 执行task、task2任务，await保证其同步执行
  let res: number = await taskpool.execute(task) as number;
  let res2: number = await taskpool.execute(task2) as number;
  // 打印任务结果
  console.info('taskpool: task res is: ' + res);
  console.info('taskpool: task res2 is: ' + res2);
  if (res == 3 && res2 == 4) {
    return true;
  } else {
    return false;
  }
}

export async function syncTaskTest(): Promise<string> {
  let num: number = Handle.syncSet(100);
  console.info('this is Main_Thread!');
  let res = await asyncGet();
  if(res) {
    return 'syncTaskTest Succeed';
  } else {
    return 'syncTaskTest Failed';
  }
}