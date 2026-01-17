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
// [Start test_instanceof]
// pages/index.ets
import { worker, ErrorEvent } from '@kit.ArkTS'
import { A } from './Sendable'
const workerInstance = new worker.ThreadWorker('../workers/Worker.ets');
function testInstanceof() {
  let a = new A();
  if (a instanceof A) {
    // 打印test instanceof in main thread success
    console.info('test instanceof in main thread success');
  } else {
    console.info('test instanceof in main thread failed');
  }
  workerInstance.postMessageWithSharedSendable(a);
  workerInstance.onerror = (err: ErrorEvent) => {
    console.error('worker err :' + err.message)
  }
}

testInstanceof();
// [End test_instanceof]