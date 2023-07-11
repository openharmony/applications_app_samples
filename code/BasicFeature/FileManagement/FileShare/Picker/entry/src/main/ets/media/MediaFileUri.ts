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
import fs from '@ohos.file.fs';
import mediaLibrary from '@ohos.multimedia.mediaLibrary';
import Logger from '../common/Logger';
import { bufferToString } from '../common/Common';

const RECENT_MAX = 10; // 最近打开最大文件数
const BUFFER_SIZE = 4096; // 文件读写缓冲区大小
const COMMON_FD = -1; // 文件fd默认值
const TAG = 'MediaFileUri';

const MODE_READ_ONLY = 0;
const MODE_WRITE_ONLY = 1;
const MODE_READ_WRITE = 2;

export default class MediaFileUri {
  private commonFd: number = COMMON_FD;
  content: string = '';

  private fileSizeList: Array<number> = [];
  private fileNameList: Array<string> = [];
  private fileUriList: Array<string> = [];

  constructor() {

  }

  getMode(openFlag: number): number {
    let mode;
    switch (openFlag) {
      case MODE_READ_ONLY:
        mode = fs.OpenMode.READ_ONLY; // r
        break;
      case MODE_WRITE_ONLY:
        mode = fs.OpenMode.WRITE_ONLY; // w
        break;
      case MODE_READ_WRITE:
        mode = fs.OpenMode.READ_WRITE; // rw
        break;
    }
    return mode;
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
        file = fs.openSync(uri, fs.OpenMode.READ_ONLY);
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

  myGetFileSize(uri: string, mode: number): number {
    let file = fs.openSync(uri, mode); // fs.OpenMode.READ_ONLY
    Logger.info(TAG, 'file fd: ' + file.fd);

    let stat = fs.statSync(file.fd);
    Logger.info(TAG, 'get file info succeed, the size of file is ' + stat.size);
    return stat.size;
  }

  writeFileContent(uri: string, content: string): void {
    Logger.info(TAG, 'writeFileContent begin');
    let file = fs.openSync(uri, fs.OpenMode.READ_WRITE);
    Logger.info(TAG, 'writeFileContent file fd: ' + file.fd);

    let writeLen = fs.writeSync(file.fd, content);
    Logger.info(TAG, 'writeFileContent write data to file succeed and size is:' + writeLen);

    fs.closeSync(file);
  }

  getAllFiles(context): void {
    Logger.info(TAG, 'getAllFiles begin');
    let fileKeyObj = mediaLibrary.FileKey;
    let imageType = mediaLibrary.MediaType.FILE; // mediaLibrary.MediaType.IMAGE
    let args = imageType.toString();
    // 创建文件获取选项，此处参数为获取image类型的文件资源
    let imagesFetchOp = {
      selections: fileKeyObj.MEDIA_TYPE + '= ?',
      selectionArgs: [args],
      order: 'date_added DESC'
    };
    let media = mediaLibrary.getMediaLibrary(context);
    // 获取文件资源，使用callback方式返回异步结果
    media.getFileAssets(imagesFetchOp, async (error, fetchFileResult) => {
      // 判断获取的文件资源的检索结果集是否为undefined，若为undefined则接口调用失败
      if (fetchFileResult === undefined) {
        Logger.error(TAG, 'get fetchFileResult failed with error: ' + error);
        return;
      }
      // 获取文件检索结果集中的总数
      const count = fetchFileResult.getCount();
      // 判断结果集中的数量是否小于0，小于0时表示接口调用失败
      if (count < 0) {
        Logger.error(TAG, 'get count from fetchFileResult failed, count: ' + count);
        return;
      }
      // 判断结果集中的数量是否等于0，等于0时表示接口调用成功，但是检索结果集为空，请检查文件获取选项参数配置是否有误和设备中是否存在相应文件
      if (count === 0) {
        Logger.info(TAG, 'The count of fetchFileResult is zero');
        return;
      }
      Logger.info(TAG, 'Get fetchFileResult successfully, count: ' + count);
      // 获取文件检索结果集中的第一个资源，使用callback方式返回异步结果，文件数量较多时请使用getAllObject接口
      fetchFileResult.getFirstObject(async (error, fileAsset) => {
        // 检查获取的第一个资源是否为undefined，若为undefined则接口调用失败
        if (fileAsset === undefined) {
          Logger.error(TAG, 'get first object failed with error: ' + error);
          return;
        }
        Logger.info(TAG, 'fileAsset.displayName ' + '0 : ' + fileAsset.displayName);
        Logger.info(TAG, 'fileAsset.uri 0:' + fileAsset.uri);

        let index = 0;
        this.fileNameList[index] = fileAsset.displayName;
        this.fileSizeList[index] = fileAsset.size;
        this.fileUriList[index] = fileAsset.uri;

        // this.writeFileContent(this.fileUriList[index])
        // 调用 getNextObject 接口获取下一个资源，直到最后一个
        for (let i = 1; i < count && i < RECENT_MAX; i++) {
          let fileAsset = await fetchFileResult.getNextObject();
          if (fileAsset === undefined) {
            Logger.error(TAG, 'get Next object failed with error: ' + error);
            return;
          }

          index = index + 1;
          this.fileNameList[index] = fileAsset.displayName;
          this.fileSizeList[index] = fileAsset.size;
          this.fileUriList[index] = fileAsset.uri;

          Logger.info(TAG, 'fileAsset.uri:' + i.toString() + fileAsset.uri);
          Logger.info(TAG, 'fileAsset.displayName ' + i + ': ' + fileAsset.displayName);
        }
        AppStorage.SetOrCreate('fileNameList', this.fileNameList);
        AppStorage.SetOrCreate('fileSizeList', this.fileSizeList);
        AppStorage.SetOrCreate('fileUriList', this.fileUriList);

        // 释放FetchFileResult实例并使其失效。无法调用其他方法
        fetchFileResult.close();
      });
    });
  }
}