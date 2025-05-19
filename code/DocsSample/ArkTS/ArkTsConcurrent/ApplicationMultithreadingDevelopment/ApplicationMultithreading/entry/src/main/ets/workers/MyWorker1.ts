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

// [Start interact_main_thread]
import { worker, ThreadWorkerGlobalScope, MessageEvents, ErrorEvent } from '@kit.ArkTS';

let workerPort: ThreadWorkerGlobalScope = worker.workerPort;

// 定义训练模型及结果
let result: Array<number>;

// 定义预测函数
function predict(x: number): number {
  return result[x];
}

// 定义优化器训练过程
function optimize(): void {
  result = [0];
}

// Worker线程的onmessage逻辑
workerPort.onmessage = (e: MessageEvents): void => {
  // 根据传输的数据的type选择进行操作
  switch (e.data.type as number) {
    case 0:
      // 进行训练
      optimize();
      // 训练之后发送宿主线程训练成功的消息
      workerPort.postMessage({ type: 'message', value: 'train success.' });
      break;
    case 1:
      // 执行预测
      const output: number = predict(e.data.value as number);
      // 发送宿主线程预测的结果
      workerPort.postMessage({ type: 'predict', value: output });
      break;
    default:
      workerPort.postMessage({ type: 'message', value: 'send message is invalid' });
      break;
  }
  // 销毁线程
  // workerPort.close();
}
// [End interact_main_thread]