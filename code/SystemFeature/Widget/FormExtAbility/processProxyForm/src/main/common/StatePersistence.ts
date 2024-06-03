/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import type common from '@ohos.app.ability.common';
import fs from '@ohos.file.fs';
import Logger from './Logger';

const TAG = '[Sample_StatePersistence]';
const DATA_SIZE = 6;
const PROCESS_FILE_NAME = '/Process.txt';

function getConditionIDtoFile(context: common.Context, fileName: string): string {
  Logger.debug(TAG, 'getConditionIDtoFile call');
  if (context === undefined || context === null || typeof fileName !== 'string' || fileName === '') {
    Logger.error(TAG, `getConditionIDtoFile failed, context : ${JSON.stringify(context)}`);
    return '';
  }

  try {
    let filePath = context.filesDir + fileName;
    let file = fs.openSync(filePath, fs.OpenMode.READ_ONLY);
    let buff = new ArrayBuffer(DATA_SIZE);
    let num = fs.readSync(file.fd, buff);
    let conditionID = String.fromCharCode.apply(null, new Uint8Array(buff));
    Logger.info(TAG, `getConditionIDtoFile : ${conditionID.length} ${conditionID}, ${num} ${filePath}`);
    fs.closeSync(file);
    return conditionID;
  } catch (err) {
    Logger.error(TAG, `getConditionIDtoFile err : ${JSON.stringify(err)}`);
    return '';
  }
}

function updateConditionIDtoFile(context: common.Context, conditionID: string, fileName: string): void {
  Logger.debug(TAG, 'updateConditionIDtoFile call');
  if (context === undefined || context === null ||
  typeof conditionID !== 'string' || conditionID === '' ||
  typeof fileName !== 'string' || fileName === '') {
    Logger.error(TAG, `updateConditionIDtoFile failed, conditionID : ${JSON.stringify(conditionID)}, context : ${JSON.stringify(context)}`);
    return;
  }

  try {
    let filePath = context.filesDir + fileName;
    let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    let num = fs.writeSync(file.fd, conditionID);
    fs.closeSync(file);
    Logger.info(TAG, `updateConditionIDtoFile : ${conditionID}, ${num} ${filePath}`);
  } catch (err) {
    Logger.error(TAG, `updateConditionIDtoFile err : ${JSON.stringify(err)}`);
  }
}

export function getProcessConditionID(context: common.Context): string {
  return getConditionIDtoFile(context, PROCESS_FILE_NAME);
}

export function saveProcessConditionID(context: common.Context, conditionID: string): void {
  updateConditionIDtoFile(context, conditionID, PROCESS_FILE_NAME);
}
