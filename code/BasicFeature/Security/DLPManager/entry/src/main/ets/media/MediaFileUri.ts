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

import fileIo from '@ohos.fileio';
import fileAccess from '@ohos.file.fileAccess';
import Logger from '../utils/Logger';
import util from '@ohos.util';
import { BusinessError } from '@ohos.base';
import fs, { Filter } from '@ohos.file.fs';

const TAG = '[dlpmanager_MediaFileUri]';
const RECENT_MAX = 10; // 最近打开最大文件数
const BUFFER_SIZE = 4096; // 文件读写缓冲区大小
const COMMON_FD = -1; // 文件fd默认值

class ListFileOption {
  public recursion: boolean = false;
  public listNum: number = 0;
  public filter: Filter = {};
}

export default class MediaFileUri {
  content: string = '';
  private commonFd: number = COMMON_FD;
  private fileNameList: Array<string> = [];
  private fileUriList: Array<string> = [];
  private fileAccessHelper: fileAccess.FileAccessHelper;
  private fileInfos: Array<fileAccess.FileInfo> = [];

  constructor() {
  }

  myWriteSync(fd: number, content: string, isClose: boolean): void {
    try {
      let result = fs.writeSync(fd, content);
      Logger.info(TAG, 'myWriteSync: write result = ' + result);
    } catch (err) {
      Logger.error(TAG, 'myWriteSync： write failed with error:' + err);
    }
    if (isClose) {
      this.closeSync(fd);
      this.commonFd = COMMON_FD;
    } else {
      this.commonFd = fd;
    }
  }

  // sync-close
  closeSync(fd: number): void {
    try {
      fileIo.closeSync(fd);
      Logger.info(TAG, 'closeSync file finish.');
    } catch (err) {
      Logger.error(TAG, 'closeSync file error = ' + err);
    }
  }

  readFileContent(uri: string, isRead: boolean = true, isClose: boolean = true): string {
    let content = '';
    Logger.info(TAG, 'open path = ' + uri);
    let file;
    if (isClose || this.commonFd === COMMON_FD) {
      try {
        Logger.info(TAG, 'uri: ' + uri);
        file = fs.openSync(uri, fs.OpenMode.READ_ONLY);
        Logger.info(TAG, 'openReadSync: get fd success. file = ' + JSON.stringify(file));
        Logger.info(TAG, 'openReadSync: get fd success. fd = ' + file.fd);
        this.commonFd = file.fd;
      } catch (err) {
        Logger.error(TAG, 'openReadSync: open file failed. error = ' + err);
        return content;
      }
      if (file === undefined) {
        Logger.error(TAG, 'openReadSync: open file failed. file = undefined.');
        return content;
      }
    }
    if (isRead) {
      try {
        let buffer = new ArrayBuffer(BUFFER_SIZE);
        let readOut = fs.readSync(this.commonFd, buffer, {
          offset: 0
        });
        content = bufferToString(buffer);
        Logger.info(TAG, 'myReadSync: read result: ' + String.fromCharCode.apply(null, new Uint8Array(buffer.slice(0, readOut))));
      } catch (err) {
        Logger.error(TAG, 'myReadSync: read error: ' + err);
        return content;
      }

      if (isClose) {
        this.closeSync(this.commonFd);
        this.commonFd = COMMON_FD;
      } else {
        this.commonFd = this.commonFd;
      }
    }
    return content;
  }

  writeFileContent(uri: string, content: string): void {
    Logger.info(TAG, 'writeFileContent begin');
    let file = fs.openSync(uri, fs.OpenMode.READ_WRITE);
    Logger.info(TAG, 'writeFileContent file fd: ' + file.fd);
    let writeLen = fs.writeSync(file.fd, content);
    Logger.info(TAG, 'writeFileContent write data to file succeed and size is:' + writeLen);
    fs.closeSync(file);
  }

  async getFileData(url: string): Promise<void> {
    let isDone: boolean = false;
    let fileInfo = await this.fileAccessHelper.getFileInfoFromUri(url);
    try {
      let fileIterator = fileInfo.scanFile({
        suffix: ['.txt']
      });
      if (!fileIterator) {
        Logger.info(TAG, 'listFile interface returns an undefined object');
      }
      while (!isDone) {
        let result = fileIterator.next();
        isDone = result.done;
        if (!isDone) {
          this.fileInfos.push(result.value);
        }
      }
    } catch (err) {
      Logger.info(TAG, `listFile failed, ${err}`);
    }
  }

  async getAllFiles(context): Promise<void> {
    Logger.info(TAG, 'getAllFiles begin');
    this.fileInfos = [];
    this.fileAccessHelper = fileAccess.createFileAccessHelper(context);
    let rootIterator = await this.fileAccessHelper.getRoots();
    let catalogueUrl: string = rootIterator.next().value.uri;
    await this.getFileData(catalogueUrl);
    for (let index = 0; index < this.fileInfos.length && index < RECENT_MAX; index++) {
      this.fileNameList[index] = this.fileInfos[index].fileName;
      this.fileUriList[index] = this.fileInfos[index].uri;
    }
    AppStorage.setOrCreate('fileNameList', this.fileNameList);
    AppStorage.setOrCreate('fileUriList', this.fileUriList);
  }

  async getListFile(pathDir): Promise<void> {
    let option = new ListFileOption();
    option.filter.suffix = ['.txt', '.doc', '.docx', '.dlp'];
    fs.listFile(pathDir, option, (err: BusinessError, filenames: Array<string>) => {
      if (err) {
        Logger.info(TAG, 'list file failed with error message: ' + err.message + ', error code: ' + err.code);
      } else {
        Logger.info(TAG, 'listFile succeed');
        for (let i = 0; i < filenames.length; i++) {
          Logger.info(TAG, 'filename: %s', filenames[i]);
        }
      }
    });
  }
}

export function bufferToString(buffer: ArrayBuffer): string {
  let textDecoder = new util.TextDecoder('utf-8', {
    ignoreBOM: true
  });
  let resultPut = textDecoder.decodeWithStream(new Uint8Array(buffer), {
    stream: true
  });
  return resultPut;
}