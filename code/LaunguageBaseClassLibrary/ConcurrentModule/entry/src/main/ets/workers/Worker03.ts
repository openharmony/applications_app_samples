/*
 * Copyright (c) 2023 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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
import worker from '@ohos.worker';
import type { ThreadWorkerGlobalScope } from '@ohos.worker';
import Logger from '../common/Logger';
import fs from '@ohos.file.fs';

const workerPort: ThreadWorkerGlobalScope = worker.workerPort;
const TAG: string = '[MyFile].[Worker03]';
/**
 * Defines the event handler to be called when the worker thread receives a message sent by the host thread.
 * The event handler is executed in the worker thread.
 *
 * @param e message data
 */
workerPort.onmessage = function (message): void {
  let data = message.data;
  let srcPath = null;
  let destPath = null;
  let fileNames = data.fileNames;
  console.info('Workerets Worker03 fileNames length = ' + fileNames.length);
  for (let i = 0; i < fileNames.length; i++) {
    srcPath = data.srcDir + '/' + fileNames[i];
    Logger.info('Workerets Worker03 srcPath ' + srcPath);
    destPath = data.destDir + '/' + fileNames[i];
    Logger.info('Workerets Worker03 destPath ' + destPath);
    try {
      fs.copyFileSync(srcPath, destPath);
      let countTest = fs.listFileSync(data.destDir).length;
      Logger.info(`Worker workerInstance::onmessage receive countTest: ${countTest}`);
    } catch (e) {
      Logger.error(TAG, 'Worker03::copyFile has failed for: ' + JSON.stringify(e));
    }
  }
  let listFileNames = [];
  listFileNames.length = 0;
  try {
    let count = fs.listFileSync(data.destDir).length;
    let listFiles = fs.listFileSync(data.destDir);
    Logger.info('listFile succeed');
    for (let i = 0; i < listFiles.length; i++) {
      listFileNames[i] = listFiles[i];
      Logger.info(`Worker workerInstance::onmessage receive listFileNames: ${listFileNames[i]}`);
    }
    workerPort.postMessage({
      count: count,
      strFlag: true,
      listFileNames: listFileNames
    });
    Logger.info(TAG, 'Worker03::onmessage thread post message successfully');
  } catch (e) {
    Logger.error(TAG, 'Worker03::onmessage has failed for: ' + JSON.stringify(e));
  }
};

/**
 * Defines the event handler to be called when the worker receives a message that cannot be deserialized.
 * The event handler is executed in the worker thread.
 *
 * @param e message data
 */
workerPort.onmessageerror = async function (message): Promise<void> {
  Logger.error(TAG, 'Worker03::onmessageerror : ' + JSON.stringify(message));
};

/**
 * Defines the event handler to be called when an exception occurs during worker execution.
 * The event handler is executed in the worker thread.
 *
 * @param e error message
 */
workerPort.onerror = function (e): void {
  Logger.error(TAG, 'Worker03::onerror : ' + JSON.stringify(e));
};