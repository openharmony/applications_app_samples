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

// [Start worker_download_json_layout]
import { MessageEvents, ThreadWorkerGlobalScope, worker } from '@kit.ArkTS';
import { QuickTransformer } from '@kwai_harmony/quick-transformer';
import { plainToInstance } from 'class-transformer';
import { Layout } from '../layout/Layout';

const workerPort: ThreadWorkerGlobalScope = worker.workerPort;
workerPort.onmessage = (e: MessageEvents) => {
  QuickTransformer.hookScope(() => {
    // Worker线程下载JSON格式的UI布局
    const layoutString = `{'type':'Text'}`;
    const layout = plainToInstance(Layout, JSON.parse(layoutString));
    console.info('Worker download layout: ', layout);
    workerPort.postMessage({
      status: 'success',
      result: layout,
    });
  });
};
// [End worker_download_json_layout]