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

import fs from '@ohos.file.fs';
import fileAccess from '@ohos.file.fileAccess';
import { BusinessError } from '@ohos.base';
import { TestDlpFileInfo } from '../feature/DlpManager';
import Logger from '../util/Logger';
import common from '@ohos.app.ability.common';
import fileUri from '@ohos.file.fileuri';
import { PreferencesManager } from './PreferencesManager';

const TAG = 'FileManager';
const RECENT_MAX = 10; // 最近打开最大文件数
let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;

export class FileInfoType {
  fileUri: string = '';
  fileName: string = '';
  size: number = 0;
  isEncryption: boolean = false;

  constructor(fileUri: string, fileName: string, size: number, isEncryption?: boolean) {
    this.fileUri = fileUri;
    this.fileName = fileName;
    this.size = size;
  }
}

export class MediaFileUri {
  private fileAccessHelper: fileAccess.FileAccessHelper = {} as fileAccess.FileAccessHelper;
  private fileInfos: Array<FileInfoType> = [];

  constructor() {
    this.fileAccessHelper = fileAccess.createFileAccessHelper(context);
  }

  // sync-close
  closeSync(fd: number): void {
    try {
      fs.closeSync(fd);
      Logger.info(TAG, 'closeSync file finish.');
    } catch (err) {
      Logger.error(TAG, 'closeSync file error = ' + err);
    }
  }

  myGetFileSize(uri: string, mode: number): number {
    let file = fs.openSync(uri, mode); // fs.OpenMode.READ_ONLY
    Logger.info(TAG, `file fd: file.fd`);
    let stat = fs.statSync(file.fd);
    Logger.info(TAG, `get file info succeed, the size of file is ${stat.size}`);
    return stat.size;
  }

  // 获取文件数据
  async getFileData(url: string): Promise<void> {
    let isDone: boolean = false;
    let fileInfo = await this.fileAccessHelper.getFileInfoFromUri(url);
    try {
      let fileIterator = fileInfo.scanFile({ suffix: ['.txt'] });
      if (!fileIterator) {
        Logger.info(TAG, 'listFile interface returns an undefined object');
      }
      while (!isDone) {
        let result = fileIterator.next();
        isDone = result.done;
        if (!isDone) {
          let fileMsg: FileInfoType = new FileInfoType(result.value.uri, result.value.fileName, result.value.size);
           let filterArray: Array<FileInfoType> = this.fileInfos.filter((item) => {
            return item.fileName === fileMsg.fileName;
          })
          if (filterArray.length > 0) {
            return;
          }
          this.fileInfos.push(fileMsg);
        }
      }
    } catch (err) {
      Logger.info(TAG, `listFile failed, ${err}`);
    }
  }

  // 获取文件
  async getAllFiles(context: common.UIAbilityContext, dlpFileInfos: Array<TestDlpFileInfo>): Promise<void> {
    Logger.info(TAG, 'getAllFiles begin');
    Logger.info(TAG, 'getAllFiles begin' + JSON.stringify(dlpFileInfos));
    this.fileInfos = [];
    let rootIterator = await this.fileAccessHelper.getRoots();
    // 获取目录url
    let catalogueUrl: string = rootIterator.next().value.uri;
    await this.getFileData(catalogueUrl);
    await this.handleFileData(dlpFileInfos);
    AppStorage.set('fileInfos', this.fileInfos);
  }

  // 处理文件数据
  async handleFileData(dlpFileInfos: Array<TestDlpFileInfo>) {
    if (dlpFileInfos.length > 0) {
      for (let index = 0; index < this.fileInfos.length && index < RECENT_MAX; index++) {
        dlpFileInfos.forEach(async (item: TestDlpFileInfo, ind: number) => {
          let uriInfo: fileUri.FileUri = await this.getFileName(item.plaintextPath);
          let fileInfo: FileInfoType = this.fileInfos[index];
          if (uriInfo.name === fileInfo.fileName) {
            fileInfo.isEncryption = true;
          }
        })
      }
    }
  }

  // 删除文件
  async deleteFile(uri: string) {
    Logger.info(`deleteFile start, uri is ${uri}`);
    try {
      let code = await this.fileAccessHelper.delete(uri);
      if (code !== 0) {
        Logger.error(`delete failed, code:${code}`);
      }
    } catch (err) {
      let error: BusinessError = err as BusinessError;
      Logger.error(`delete failed, errCode:${error.code}`);
    }
  }

  // 根据Uri获取名称
  async getFileName(uri: string) {
    let uriInfo: fileUri.FileUri = new fileUri.FileUri(uri);
    return uriInfo;
  }

  // 新增文件
  async createFile(sourceUri: string, displayName: string): Promise<number> {
    Logger.info(`SourceUri:${sourceUri}----displayName:${displayName}`);
    try {
      // fileAccessHelper 参考 fileAccess.createFileAccessHelper 示例代码获取
      let fileUri = await this.fileAccessHelper.createFile(sourceUri, displayName);
      let file = fs.openSync(fileUri, fs.OpenMode.READ_WRITE);
      Logger.info('the fd is ' + file.fd);
      return file.fd;
    } catch (err) {
      let error: BusinessError = err as BusinessError;
      Logger.error(`createFile failed, errCode:${error.code}, errMessage:${error.message}`);
      return -1;
    }
  }
}