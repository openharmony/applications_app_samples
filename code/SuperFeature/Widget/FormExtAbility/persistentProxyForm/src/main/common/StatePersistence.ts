import type common from '@ohos.app.ability.common';
import fs from '@ohos.file.fs';
import Logger from './Logger';

const TAG = '[Sample_StatePersistence]';
const DATA_SIZE = 6;
const PERSISTENT_FILE_NAME = '/Persistent.txt';

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

export function getPersistentConditionID(context: common.Context): string {
  return getConditionIDtoFile(context, PERSISTENT_FILE_NAME);
}

export function savePersistentConditionID(context: common.Context, conditionID: string): void {
  updateConditionIDtoFile(context, conditionID, PERSISTENT_FILE_NAME);
}