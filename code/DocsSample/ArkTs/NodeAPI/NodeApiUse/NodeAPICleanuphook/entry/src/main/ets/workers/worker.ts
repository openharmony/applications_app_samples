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

// [Start connect_with_main_thread]
import hilog from '@ohos.hilog';
import worker from '@ohos.worker';
import testNapi from 'libentry.so';

let parent = worker.workerPort;
// 处理来自主线程的消息
parent.onmessage = function(message) {
  hilog.info(0x0000, 'testTag', 'Test Node-API message from main thread: %{public}s', JSON.stringify(message));
  // 发送消息到主线程
  parent.postMessage('Test Node-API worker:' + testNapi.napiEnvCleanUpHook());
}
// [End connect_with_main_thread]