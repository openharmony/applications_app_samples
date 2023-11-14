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

import { BusinessError } from '@ohos.base';
import fs from '@ohos.file.fs';
import { bufferToString, expect, Logger, sleep } from '../../common/Common';

const CONTENT = 'hello world';
const TAG: string = '[FileIO].[Watcher]';
const TIMEOUT: number = 500; // 超时时间
const IN_ACCESS: number = 0x00000001;
const IN_MODIFY: number = 0x00000002;
const IN_ATTRIB: number = 0x00000004;
const IN_CLOSE_WRITE: number = 0x00000008;
const IN_CLOSE_NOWRITE: number = 0x00000010;
const IN_OPEN: number = 0x00000020;
const IN_MOVED_FROM: number = 0x00000040;
const IN_MOVED_TO: number = 0x00000080;
const IN_CREATE: number = 0x00000100;
const IN_DELETE: number = 0x00000200;
const IN_DELETE_SELF: number = 0x00000400;
const IN_MOVE_SELF: number = 0x00000800;
const IN_ISDIR: number = 0x40000000;
const BUFFER: number = 4096; // 读写文件buffer大小
const FILE_NUMBER: number = 9; // 文件1-9命名时加上0

interface FILEINFO {
  path: string[],
  size: number
}
export default class MyWatcher {
  public fileSize: number = 0;
  private baseDir: string = '';
  public watcherList: Array<fs.Watcher> = [];
  private timeOut: number = TIMEOUT;
  public log: string[] = [];
  public fileInfo: FILEINFO= {
    path: [],
    size: 0
  };
  private watcherCodeMap = new Map([
    ['IN_ACCESS', IN_ACCESS],
    ['IN_MODIFY', IN_MODIFY],
    ['IN_ATTRIB', IN_ATTRIB],
    ['IN_CLOSE_WRITE', IN_CLOSE_WRITE],
    ['IN_CLOSE_NOWRITE', IN_CLOSE_NOWRITE],
    ['IN_OPEN', IN_OPEN],
    ['IN_MOVED_FROM', IN_MOVED_FROM],
    ['IN_MOVED_TO', IN_MOVED_TO],
    ['IN_CREATE', IN_CREATE],
    ['IN_DELETE', IN_DELETE],
    ['IN_DELETE_SELF', IN_DELETE_SELF],
    ['IN_MOVE_SELF', IN_MOVE_SELF],
    ['IN_ISDIR', IN_ISDIR]
  ]);
  public content1: string = AppStorage.Get<string>('fileContent1') as string;
  public content2: string = AppStorage.Get<string>('fileContent2') as string;
  public content3: string = AppStorage.Get<string>('fileContent3') as string;
  public content4: string = AppStorage.Get<string>('fileContent4') as string;

  constructor() {
    this.baseDir = AppStorage.Get<string>('sanBoxFileDir') as string;
  }

  startWatcher(watcherName: string): void {
    let watcherDir: string = this.baseDir + '/watcherDir';
    Logger.info(TAG, `${watcherName}-startWatcher start path = ${watcherDir}`);
    if (this.watcherCodeMap.has(watcherName)) { // 是否存在key 'watchName': true
      try {
        Logger.info(TAG, `${watcherName}-startWatcher has watchName`);
        let watcher: fs.Watcher = fs.createWatcher(watcherDir, this.watcherCodeMap.get(watcherName), (data) => { //获取key对应的value
          if (data.event === IN_ACCESS) {
            Logger.info('startWatcher ' + data.fileName + ' was accessed');
          } else if (data.event === IN_MODIFY) {
            Logger.info('startWatcher ' + data.fileName + ' was modified');
          } else if (data.event === IN_ATTRIB) {
            Logger.info('startWatcher ' + data.fileName + ' was attributed');
          } else if (data.event === IN_CLOSE_WRITE) {
            Logger.info('startWatcher ' + data.fileName + ' was in close write');
          } else if (data.event === IN_CLOSE_NOWRITE) {
            Logger.info('startWatcher ' + data.fileName + ' was closed');
          } else if (data.event === IN_OPEN) {
            Logger.info('startWatcher ' + data.fileName + ' was opened');
          } else if (data.event === IN_MOVED_FROM) {
            Logger.info('startWatcher ' + data.fileName + ' was moved to other path');
          } else if (data.event === IN_MOVED_TO) {
            Logger.info('startWatcher ' + data.fileName + ' was moved in this path');
          } else if (data.event === IN_CREATE) {
            Logger.info('startWatcher ' + data.fileName + ' was added');
          } else if (data.event === IN_DELETE) {
            Logger.info('startWatcher ' + data.fileName + ' was deleted ');
          } else if (data.event === IN_DELETE_SELF) {
            Logger.info('startWatcher ' + data.fileName + ' was deleted and stop watcher');
          } else if (data.event === IN_MOVE_SELF) {
            Logger.info('startWatcher ' + data.fileName + ' was moved and continue watcher');
          } else if (data.event === IN_ISDIR) {
            Logger.info('startWatcher ' + data.fileName + ' was watch all event');
          } else {
            Logger.info('startWatcher fail');
          }
          AppStorage.SetOrCreate('eventLog', JSON.stringify(data.event));
          AppStorage.SetOrCreate('fileNameLog', data.fileName);
          AppStorage.SetOrCreate('cookieLog', JSON.stringify(data.cookie));
          Logger.info(TAG, `${watcherName}-startWatcher :{event: ${data.event}, fileName: ${data.fileName}, cookie: ${data.cookie}}`);
        });

        watcher.start();
        setTimeout(async () => {
          this.watcherList.push(watcher);
        }, this.timeOut);

        Logger.info('watcherList is ' + JSON.stringify(this.watcherList));
      } catch (e) {
        Logger.error(TAG, `${watcherName}-startWatcher has failed for: {message: ${e.message}, code: ${e.code}}`);
      }
    } else {
      Logger.info(TAG, `${watcherName}-startWatcher does not in watcherCodeMap`);
    }
  }

  stopWatcher(watcher: fs.Watcher, index: number): void {
    if (watcher !== null) {
      watcher.stop();
      setTimeout(async () => {
        this.watcherList.splice(index, 1);
      }, this.timeOut);
      Logger.info(TAG, 'stopWatcher successful');
    } else {
      Logger.info(TAG, 'stopWatcher null');
    }
  }

  readyFilesToWatcher(pathDir: string): void {
    let content = this.content1 + '\r\n' + this.content2 + '\r\n' + this.content3 + '\r\n' + this.content4;

    try {
      let flag = TAG;
      if (!fs.accessSync(pathDir)) {
        fs.mkdirSync(pathDir);
      }
      let dpath = pathDir;
      Logger.info('readyFileToWatcher dpath = ' + dpath);
      for (let i = 0; i < FILE_NUMBER; i++) {
        let myFile = dpath + `/TestFile0${i + 1}.txt`;
        Logger.info('readyFileToWatcher myFile = ' + myFile);
        let file = fs.openSync(myFile, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE | fs.OpenMode.TRUNC);
        fs.writeSync(file.fd, content);
        fs.closeSync(file);
      }
      Logger.info(TAG, 'readyFileToWatcher successful');
    } catch (e) {
      Logger.error(TAG, `readyFileToWatcher has failed for: {message: ${e.message}, code: ${e.code}}`);
    }
  }

  addFileToWatcher(path: string): void {
    let content = CONTENT + '\n';
    try {
      let addFile = this.baseDir + '/watcherDir/' + path;
      Logger.info('addFileToWatcher addFile = ' + addFile);
      let file = fs.openSync(addFile, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE | fs.OpenMode.TRUNC);
      fs.writeSync(file.fd, content);
      fs.closeSync(file);
    } catch (e) {
      Logger.error(TAG, `addFileToWatcher has failed for: {message: ${e.message}, code: ${e.code}}`);
    }
  }

  deleteFileToWatcher(path: string): void {
    try {
      let deleteFile = this.baseDir + '/watcherDir/' + path;
      Logger.info(TAG, 'deleteFileToWatcher deleteFile = ' + deleteFile);
      fs.unlink(deleteFile).then(() => {
        Logger.info(TAG, 'deleteFileToWatcher file succeed');
      }).catch((err: BusinessError) => {
        Logger.info(TAG, 'deleteFileToWatcher file failed with error message: ' + err.message + ', error code: ' + err.code);
      });
    } catch (e) {
      Logger.error(TAG, `readyFileToWatcher has failed for: {message: ${e.message}, code: ${e.code}}`);
    }
  }

  modifyFileNameToWatcher(oldName: string, newName: string): boolean {
    try {
      let srcFile = this.baseDir + '/watcherDir/' + oldName;
      Logger.info(TAG, 'modifyFileNameToWatcher srcFile = ' + srcFile);
      let dstFile = this.baseDir + '/watcherDir/' + newName;
      Logger.info(TAG, 'modifyFileNameToWatcher dstFile = ' + dstFile);
      fs.renameSync(srcFile, dstFile);
      return true;
    } catch (e) {
      Logger.info(`-readyFileRW-creat has failed for: {message: ${e.message}, code: ${e.code}}`);
      return false;
    }
  }

  modifyFileContentToWatcher(fileName: string, content: string): boolean {
    let filePath = this.baseDir + '/watcherDir/' + fileName;
    Logger.info(TAG, 'modifyFileContentToWatcher filePath = ' + filePath);
    try {
      let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE | fs.OpenMode.TRUNC);
      let writeLen = fs.writeSync(file.fd, content);
      Logger.info(TAG, 'modifyFileContentToWatcher write data to file succeed and size is:' + writeLen);
      fs.closeSync(file);
      let fileRead = fs.openSync(filePath, fs.OpenMode.READ_WRITE);
      let buf = new ArrayBuffer(BUFFER);
      this.fileSize = fs.readSync(fileRead.fd, buf);
      let resultPut = bufferToString(buf);
      Logger.info('modifyFileContentToWatcher Read num = ' + this.fileSize);
      Logger.info('modifyFileContentToWatcher Read resultPut = ' + resultPut);
      fs.closeSync(fileRead);
      Logger.info('modifyFileContentToWatcher write data to file succeed and fileSize is:' + this.fileSize);
      return true;
    } catch (e) {
      Logger.info(`-readyFileRW-creat has failed for: {message: ${e.message}, code: ${e.code}}`);
      return false;
    }
  }

  modifyFileToWatcher(oldName: string, newName: string, content: string): number {
    // 重命名文件
    let filePath = '';
    if (newName.trim() === oldName.trim()) {
      filePath = this.baseDir + '/watcherDir/' + oldName;
      Logger.info('modifyFileToWatcher The new file name is the same as the old file name');
    } else {
      try {
        let srcFile = this.baseDir + '/watcherDir/' + oldName;
        Logger.info('modifyFileToWatcher srcFile = ' + srcFile);
        let dstFile = this.baseDir + '/watcherDir/' + newName;
        filePath = dstFile;
        Logger.info('modifyFileToWatcher dstFile = ' + dstFile);
        fs.renameSync(srcFile, dstFile);
      } catch (e) {
        Logger.info(`modifyFileToWatcher -readyFileRW-creat has failed for: {message: ${e.message}, code: ${e.code}}`);
      }
    }

    // 修改文件内容
    Logger.info('modifyFileContentToWatcher filePath = ' + filePath);
    try {
      let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE | fs.OpenMode.TRUNC);
      let writeLen = fs.writeSync(file.fd, content);
      Logger.info('modifyFileContentToWatcher write data to file succeed and size is:' + writeLen);
      fs.closeSync(file);

      let fileRead = fs.openSync(filePath, fs.OpenMode.READ_WRITE);
      let buf = new ArrayBuffer(BUFFER);
      this.fileSize = fs.readSync(fileRead.fd, buf);
      let resultPut = bufferToString(buf);
      Logger.info('modifyFileContentToWatcher Read num = ' + this.fileSize);
      Logger.info('modifyFileContentToWatcher Read resultPut = ' + resultPut);
      fs.closeSync(fileRead);
      Logger.info('modifyFileContentToWatcher write data to file succeed and fileSize is:' + this.fileSize);
    } catch (e) {
      Logger.info(`-readyFileRW-creat has failed for: {message: ${e.message}, code: ${e.code}}`);
    }
    return this.fileSize;
  }
}