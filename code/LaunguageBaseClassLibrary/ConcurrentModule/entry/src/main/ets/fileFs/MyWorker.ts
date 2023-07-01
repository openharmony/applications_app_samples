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
import fs from '@ohos.file.fs';
import { Logger, sleep } from '../common/Common';

const CONTENT = 'hello world';
const TAG: string = '[FileIO].[MyWorker]';
const FILE_NUM: number = 200; // 预制200 1m以下的小文件
const FILE_NUMBER: number = 9; // 文件1-9命名时加上0
const LIST_FILE_TWO: number = 2; // 显示拷贝成功后的第二个文件名
const SLEEP_TIME: number = 100; // 睡眠时间

let workerInstance = null;
let fileFlag = false;

export default class MyFile {
  public baseDir: string = '';
  public filesCount: number = 0;
  private flag: boolean = false;
  public realFileNames: Array<string> = [];

  constructor() {
    this.baseDir = AppStorage.Get('sanBoxFileDir');
  }

  readyFileToFileFs(): void {
    let fileFsDir = this.baseDir + '/fileFs';
    try {
      if (!fs.accessSync(fileFsDir)) {
        fs.mkdirSync(fileFsDir);
      }
      Logger.info(TAG, 'readyFileToFileFs successful');
    } catch (e) {
      Logger.error(TAG, `readyFileToFileFs has failed for: {message: ${e.message}, code: ${e.code}}`);
    }
  }

  // worker file
  readyFilesToWorker(): void {
    let content = CONTENT + CONTENT + new Date() + '\n';
    let workerDir = this.baseDir + '/workerDir';

    try {
      if (!fs.accessSync(workerDir)) {
        fs.mkdirSync(workerDir);
      }
      Logger.info(TAG, 'readyFilesToWorker dpath = ' + workerDir);
      for (let i = 0; i < FILE_NUM; i++) {
        let myFile = '';
        if (i < FILE_NUMBER) {
          myFile = workerDir + `/TestFile0${i + 1}.txt`;
        } else {
          myFile = workerDir + `/TestFile${i + 1}.txt`;
        }
        Logger.info(TAG, 'readyFilesToWorker myFile = ' + myFile);
        let file = fs.openSync(myFile, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
        fs.writeSync(file.fd, content);
        fs.closeSync(file);
      }
      Logger.info(TAG, 'readyFilesToWorker successful');
    } catch (e) {
      Logger.error(TAG, `readyFilesToWorker has failed for: {message: ${e.message}, code: ${e.code}}`);
    }
  }

  async workToCopyFiles(files: Array<string>, filePath: string): Promise<void> {
    try {
      Logger.info(TAG, 'WorkCreator start to create worker');
      let destPath = filePath;
      Logger.info(TAG, 'Workerets destPath ' + destPath);
      if (!fs.accessSync(destPath)) {
        fs.mkdirSync(destPath);
      }
      if (fs.accessSync(destPath)) {
        fs.listFile(destPath).then((filenames) => {
          Logger.info(TAG, 'listFile succeed');
          for (let i = 0; i < filenames.length; i++) {
            Logger.info(TAG, 'Workerets fileName: ' + filenames[i]);
          }
        }).catch((err) => {
          Logger.info(TAG, 'list file failed with error message: ' + err.message + ', error code: ' + err.code);
        });
      }
      if (files !== null) {
        this.realFileNames.length = 0;
        for (let i = 0; i < files.length; i++) {
          if (files[i] === 'deletedTag') {
            continue;
          }
          this.realFileNames.push(files[i]);
        }
      }
      let count = this.realFileNames.length;
      for (let j = 0; j < count; j++) {
        console.info('workToCopyFiles this.realFileNames = ' + this.realFileNames[j]);
      }
      workerInstance = new worker.ThreadWorker('entry/ets/workers/Worker03.ts');
      if (this.realFileNames !== null) {
        let srcPath = this.baseDir + '/workerDir';
        workerInstance.postMessage({
          srcDir: srcPath,
          destDir: destPath,
          fileNames: this.realFileNames
        });
      }

      workerInstance.onexit = function (code): void {
        Logger.info(TAG, `workerInstance::onexit has been exit ${code}`);
      };
      workerInstance.onerror = function (err): void {
        Logger.info(TAG, `workerInstance::onerror has errors: ${JSON.stringify(err)}`);
      };
      workerInstance.onmessageerror = function (event): void {
        Logger.info(TAG, `workerInstance::onmessageerror has errors: ${JSON.stringify(event)}`);
      };
      workerInstance.onmessage = function (message): void {
        let data = message.data;
        Logger.info(TAG, `workerInstance::onmessage receive data: ${JSON.stringify(data)}`);
        if (data.hasOwnProperty('count')) {
          Logger.info(TAG, `workerInstance::onmessage receive data length = ${data.count}`);
          this.filesCount = data.count;
          fileFlag = data.strFlag;
          this.flag = true;
          let fileName1 = null;
          let fileName2 = null;
          for (let i = 0; i < data.listFileNames.length; i++) {
            Logger.info(`Worker workerInstance::onmessage receive listFileNames: ${data.listFileNames[i]}`);
          }
          if (data.listFileNames[0] !== undefined && data.listFileNames[1] !== undefined && data.listFileNames[LIST_FILE_TWO] === undefined) {
            fileName1 = data.listFileNames[0] + '、';
            fileName2 = data.listFileNames[1];
          } else if (data.listFileNames[0] !== undefined && data.listFileNames[1] === undefined) {
            fileName1 = data.listFileNames[0];
            fileName2 = '';
          } else {
            fileName1 = data.listFileNames[0] + '、';
            let copyFileLog = AppStorage.Get('copyFileLog5');
            fileName2 = data.listFileNames[1] + copyFileLog;
          }
          AppStorage.SetOrCreate('fileListName1', fileName1);
          AppStorage.SetOrCreate('fileListName2', fileName2);
          Logger.info(TAG, `Worker workerInstance::onmessage receive count: ${JSON.stringify(this.filesCount)}`);
        }
        if (this.fileNames !== 0) {
          AppStorage.SetOrCreate('fileNumber', JSON.stringify(this.filesCount));
        } else {
          AppStorage.SetOrCreate('fileNumber', '0');
          AppStorage.SetOrCreate('fileListName1', '');
          AppStorage.SetOrCreate('fileListName2', '');
        }
        Logger.info(TAG, 'workerInstance::onmessage Finish to process data from Worker03.ts');
        workerInstance.terminate();
      };
      while (!fileFlag) {
        await sleep(SLEEP_TIME);
      }
    } catch (e) {
      Logger.error(TAG, `Worker WorkCreator error package: message: ${e.message}, code: ${e.code}`);
    }
  }

  deleteCopyFile(filePath: string): void {
    Logger.info(TAG, 'deleteCopyFile destCopyFilePath = ' + filePath);
    try {
      if (fs.accessSync(filePath)) {
        let isDirectory = fs.statSync(filePath).isDirectory();
        if (isDirectory) {
          fs.rmdirSync(filePath);
          fs.mkdirSync(filePath);
        }
      }
    } catch (e) {
      Logger.error(TAG, `delete workerCopyFile error package: message: ${e.message}, code: ${e.code}`);
    }
  }
}