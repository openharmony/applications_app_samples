/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import worker, { ThreadWorkerGlobalScope, MessageEvents, ErrorEvent } from '@ohos.worker';
import { computeTask } from '../model/CalculateUtil';
import Logger from '../utils/Logger';

const workerPort: ThreadWorkerGlobalScope = worker.workerPort;
const TAG: string = 'CalculateWorker';

/**
 * Defines the event handler to be called when the worker thread receives a message sent by the host thread.
 * The event handler is executed in the worker thread.
 *
 * @param e message data
 */
workerPort.onmessage = function (e: MessageEvents): void {
  Logger.info(TAG, 'CalculateWorker: start calculating...');
  let data = e.data;
  console.info(TAG, 'message from main thread' + JSON.stringify(data));
  let res: number = computeTask(data.timeSteps);
  workerPort.postMessage({ result: res });
};

/**
 * Defines the event handler to be called when the worker receives a message that cannot be deserialized.
 * The event handler is executed in the worker thread.
 *
 * @param e message data
 */
workerPort.onmessageerror = function (e: MessageEvents): void {
  Logger.error(TAG, 'CalculateWorker: onmessageerror = ' + e.data);
};

/**
 * Defines the event handler to be called when an exception occurs during worker execution.
 * The event handler is executed in the worker thread.
 *
 * @param e error message
 */
workerPort.onerror = function (e: ErrorEvent): void {
  Logger.error(TAG, 'CalculateWorker: onerror = ' + e.message);
};