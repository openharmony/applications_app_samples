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

import { bufferToString, Logger } from '../common/Common';
import fs from '@ohos.file.fs';
import fileUri from '@ohos.file.fileuri';
import wantConstant from '@ohos.ability.wantConstant';
import type Want from '@ohos.application.Want';

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

      Logger.info(TAG, 'readyFileToWatcher dpath = ' + dpath);
      for (let i = 0; i < DIR_FILE_NUM; i++) {
        let myFile = dpath + `/testFile_${i}.txt`;
        Logger.info(TAG, 'readyFileToWatcher myFile = ' + myFile);
        let file = fs.openSync(myFile, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
        fs.writeSync(file.fd, content);
        fs.closeSync(file);
      }
      Logger.info(TAG, 'readyFileToWatcher successful');
    } catch (e) {
      Logger.error(TAG, `readyFileToWatcher has failed for: {message: ${e.message}, code: ${e.code}}`);
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

      Logger.info(TAG, 'readyFileToWatcher dpath = ' + dpath);
      for (let i = 0; i < FILE_NUM; i++) {
        let myFile = dpath + `/myFile_${i}.txt`;
        Logger.info(TAG, 'readyFileToWatcher myFile = ' + myFile);
        let file = fs.openSync(myFile, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
        fs.writeSync(file.fd, content);
        fs.closeSync(file);
      }
      Logger.info(TAG, 'readyFileToWatcher successful');
    } catch (e) {
      Logger.error(TAG, `readyFileToWatcher has failed for: {message: ${e.message}, code: ${e.code}}`);
    }
  }

  getFileContent(path: string): string {
    let resultPut = '';
    try {
      Logger.info(TAG, 'modifyFileToWatcher getFileContent filePath = ' + path);
      let file = fs.openSync(path, fs.OpenMode.READ_WRITE);
      let buf = new ArrayBuffer(BUFFER_SIZE);
      let num = fs.readSync(file.fd, buf);
      Logger.info(TAG, 'modifyFileToWatcher getFileContent read num = ' + num);
      resultPut = bufferToString(buf);
      Logger.info(TAG, 'modifyFileToWatcher getFileContent read resultPut = ' + resultPut);
      fs.closeSync(file);
      return resultPut;
    } catch (e) {
      Logger.error(TAG, `modifyFileToWatcher getFileContent has failed for: {message: ${e.message}, code: ${e.code}}`);
      return resultPut;
    }
  }

  implicitStartAbility(context, fileName: string, fileSize: number, fileFd: number, filePath: string): void {
    let buf = new ArrayBuffer(BUFFER_SIZE);
    let num = fs.readSync(fileFd, buf);
    Logger.info(TAG, 'modifyFileToWatcher getFileContent read num = ' + num);
    let content = bufferToString(buf);

    let myUri: string = fileUri.getUriFromPath(filePath);
    Logger.info(TAG, 'implicitStartAbility myUri is: ' + myUri);
    let mode = wantConstant.Flags.FLAG_AUTH_WRITE_URI_PERMISSION | wantConstant.Flags.FLAG_AUTH_READ_URI_PERMISSION;
    let uris: string[] = [myUri];
    let want: Want = {
      action: 'ohos.want.action.sendData',
      parameters: {
        'keyFd': {
          'type': 'txt',
          'value': fileFd,
          'name': fileName,
          'size': fileSize,
          'content': content
        },
        'stream': uris
      },
      flags: mode,
      type: 'application/txt',
      uri: myUri,
    };

    context.startAbility(want).then(() => {
      Logger.info(TAG, 'startAbility success');
    }).catch((err) => {
      Logger.info(TAG, 'startAbility err:' + err);
    });
  }
}


