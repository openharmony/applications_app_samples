/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
import { SingletonA } from './sharedModule';

let sig: SingletonA = SingletonA.getInstance();

@Concurrent
async function test2(sig: SingletonA) {
  console.info('sendable: taskpool count is:' + await sig.getCount());
  let n = Date.now();
  // 等待1000us,模拟实际业务
  while (Date.now() - n < 1000) {
    console.info('this is test2 func');
  }
}

async function mainThreadTest() {
  // 主线程调用单例sig.incrementCount()、fetchCount();
  sig.increaseCount();
  console.info('sendable: main thread count is:' + await sig.getCount());
}

async function childThreadTest() {
  let task = new taskpool.Task(test2, sig);
  await taskpool.execute(task);
}

export async function sendableModuleTest(): Promise<string> {
  await mainThreadTest();
  childThreadTest();
  if(await sig.getCount() == 1) {
    console.info('ArkTs-SimpleDemo:: SendableModuleTest success');
    return 'SendableModuleTest Succeed';
  } else {
    return 'SendableModuleTest Failed';
  }
}