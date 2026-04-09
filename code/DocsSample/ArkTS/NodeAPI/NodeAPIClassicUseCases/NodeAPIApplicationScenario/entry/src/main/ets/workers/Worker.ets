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

// [Start napi_call_threadsafe_function_worker]
// entry/src/main/ets/workers/Worker.ets

import nativeModule from 'libentry1.so';
import { worker, MessageEvents } from '@kit.ArkTS';

const port = worker.workerPort;

port.onmessage = (e: MessageEvents) => {
  console.info('Worker thread received:' + e.data);
  nativeModule.startWithCallback('Hello', (result: string) => {
    console.info('[Worker] Got from native:', result);
    port.postMessage(result);
  });
}
// [End napi_call_threadsafe_function_worker]
