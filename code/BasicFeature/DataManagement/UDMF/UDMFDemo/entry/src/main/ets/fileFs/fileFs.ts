/*
 * Copyright (c) 2024 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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

import { bufferToString } from '../util/Common';
import { logger }  from '../util/Logger';
import fs from '@ohos.file.fs';
import fileUri from '@ohos.file.fileuri';
import wantConstant from '@ohos.ability.wantConstant';

import Want from '@ohos.app.ability.Want';

let fileContent = '';
const BUFFER_SIZE = 4096; // 读写文件缓冲区大小
const FILE_NUM = 3; // 沙箱目录预制文件个数
const DIR_FILE_NUM = 10; // 沙箱目录文件夹中预制文件个数
const TAG: string = '[File].[SandboxShare]';

export default class FileFs {
  public fileSize: number = 0;
  private baseDir: string = '';
  private dmClass: Object = null;
  public log: string[] = [];
  public fileInfo = {
    path: [],
    size: 0
  };

  constructor() {
    let content1: string = AppStorage.Get('fileContent1');
    let content2: string = AppStorage.Get('fileContent2');
    let content3: string = AppStorage.Get('fileContent3');
    let content4: string = AppStorage.Get('fileContent4');
    fileContent = content1 + '\r\n\n' + content2 + '\r\n\n' + content3 + '\r\n\n' + content4;
  }

  readyFilesToTestDir(filesDir: string): void {
    let content = fileContent;
    this.baseDir = filesDir + '/TestDir';

    try {
      let flag = TAG;
      if (!fs.accessSync(this.baseDir)) {
        fs.mkdirSync(this.baseDir);
      }
      let dpath = this.baseDir;


      logger.info(TAG, 'readyFileToWatcher dpath = ' + dpath);
      for (let i = 0; i < DIR_FILE_NUM; i++) {
        let myFile = dpath + `/testFile_${i}.txt`;
        logger.info(TAG, 'readyFileToWatcher myFile = ' + myFile);
        let file = fs.openSync(myFile, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
        fs.writeSync(file.fd, content);
        fs.closeSync(file);
      }
      logger.info(TAG, 'readyFileToWatcher successful');
    } catch (e) {
      logger.error(TAG, `readyFileToWatcher has failed for: {message: ${e.message}, code: ${e.code}}`);
    }
  }

  readyFilesToCurDir(filesDir: string): void {
    let content = fileContent;
    this.baseDir = filesDir;

    try {
      let flag = TAG;
      if (!fs.accessSync(this.baseDir)) {
        fs.mkdirSync(this.baseDir);
      }
      let dpath = this.baseDir;

      logger.info(TAG, 'readyFileToWatcher dpath = ' + dpath);
      for (let i = 0; i < FILE_NUM; i++) {
        let myFile = dpath + `/myFile_${i}.txt`;
        logger.info(TAG, 'readyFileToWatcher myFile = ' + myFile);
        let file = fs.openSync(myFile, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
        fs.writeSync(file.fd, content);
        fs.closeSync(file);
      }
      logger.info(TAG, 'readyFileToWatcher successful');
    } catch (e) {
      logger.error(TAG, `readyFileToWatcher has failed for: {message: ${e.message}, code: ${e.code}}`);
    }
  }

  getFileContentBuffer(path: string): ArrayBuffer {
    let buf = new ArrayBuffer(BUFFER_SIZE);
    try {
      logger.info(TAG, 'modifyFileToWatcher getFileContent filePath = ' + path);
      let file = fs.openSync(path, fs.OpenMode.READ_WRITE);
      let num = fs.readSync(file.fd, buf);
      logger.info(TAG, 'modifyFileToWatcher getFileContent read num = ' + num);
      fs.closeSync(file);
      return buf;
    } catch (e) {
      logger.error(TAG, `modifyFileToWatcher getFileContent has failed for: {message: ${e.message}, code: ${e.code}}`);
      return buf;
    }
  }

  getFileContent(path: string): string {
    let resultPut = '';
    try {
      logger.info(TAG, 'modifyFileToWatcher getFileContent filePath = ' + path);
      let file = fs.openSync(path, fs.OpenMode.READ_WRITE);
      let buf = new ArrayBuffer(BUFFER_SIZE);
      let num = fs.readSync(file.fd, buf);
      logger.info(TAG, 'modifyFileToWatcher getFileContent read num = ' + num);
      resultPut = bufferToString(buf);
      logger.info(TAG, 'modifyFileToWatcher getFileContent read resultPut = ' + resultPut);
      fs.closeSync(file);
      return resultPut;
    } catch (e) {
      logger.error(TAG, `modifyFileToWatcher getFileContent has failed for: {message: ${e.message}, code: ${e.code}}`);
      return resultPut;
    }
  }
}