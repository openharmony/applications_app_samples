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

import fileio from '@ohos.fileio';
import Logger from '../../utils/Logger';
import { FileType, SubDirectoryType } from '../../mock/local/FileData';

// 大小和单位
const GB_MAGNITUDE: number = 1024 * 1024 * 1024;
const MB_MAGNITUDE: number = 1024 * 1024;
const KB_MAGNITUDE: number = 1024;
const GB_SYMBOL: string = 'GB';
const MB_SYMBOL: string = 'MB';
const KB_SYMBOL: string = 'KB';
const BYTE_SYMBOL: string = 'B';

class FileSystem {
  // 获取文件大小
  getFileSize(filePath: string): string {
    try {
      let fileSize = fileio.statSync(filePath).size;
      if (fileSize / GB_MAGNITUDE > 1) {
        return `${(fileSize / GB_MAGNITUDE).toFixed(2)}${GB_SYMBOL}`;
      } else if (fileSize / MB_MAGNITUDE > 1) {
        return `${(fileSize / MB_MAGNITUDE).toFixed(2)}${MB_SYMBOL}`;
      } else if (fileSize / KB_MAGNITUDE > 1) {
        return `${(fileSize / KB_MAGNITUDE).toFixed(2)}${KB_SYMBOL}`;
      } else {
        return `${fileSize}${BYTE_SYMBOL}`;
      }
    } catch (err) {
      Logger.error(`getFileSize failed, code is ${err.code}, message is ${err.message}`);
      throw new Error(`getFileSize failed, code is ${err.code}, message is ${err.message}`);
    }
  }
  // 根据沙箱路径打开目录
  getSubdirectory(filePath: string): Array<SubDirectoryType> {
    // 获取目录
    let dir = fileio.opendirSync(filePath);
    // 读取的结果
    let dirent: fileio.Dirent;
    // 结果数组
    class SubDirectory {
      name: string = ''
      type: number = 0
      time: Date
      childrenNum: number = 0
      fileSize: string = ''
      constructor(time: Date) {
        this.time = time
      }
    }
    let subdirectory: Array<SubDirectory> = [];
    do {
      dirent = dir.readSync();
      if (dirent) {
        let subdirectoryNum: number = 0;
        let fileSize: string = '';
        let time: Date = new Date();
        // 如果是文件夹，就读取文件夹中文件的数量
        if (dirent.isDirectory()) {
          subdirectoryNum = this.getSubdirectoryNum(filePath + `${dirent.name}`);
        } else {
          // 如果不是文件夹，就读取文件大小和时间
          fileSize = this.getFileSize(filePath + `${dirent.name}`);
          time = this.getFileTime(filePath + `${dirent.name}`);
        }
        let item = new SubDirectory(time);
        item.name = dirent.name;
        item.type = dirent.isDirectory() ? 1 : 2;
        item.childrenNum = subdirectoryNum;
        item.fileSize = fileSize;
        subdirectory.push(item);
      }
    } while (dirent);
    return subdirectory;
  }

  // 获取目录中的子目录个数
  getSubdirectoryNum(filePath: string): number {
    Logger.info("----getSubdirectoryNum filePath="+filePath);
    let dir = fileio.opendirSync(filePath);
    // 读取的结果
    let dirent: fileio.Dirent;
    // 记录子目录的个数
    let subdirectoryNum = 0;
    do {
      dirent = dir.readSync();
      if (dirent) {
        subdirectoryNum++;
      }
    } while (dirent);
    return subdirectoryNum;
  }

  // 获取文件修改时间
  getFileTime(filePath: string): Date {
    try {
      let fileTime = fileio.statSync(filePath).ctime;
      return new Date(fileTime * 1000);
    } catch (err) {
      Logger.error(`getFileTime failed, code is ${err.code}, message is ${err.message}`);
      throw new Error(`getFileTime failed, code is ${err.code}, message is ${err.message}`);
    }
  }
}

export default new FileSystem()
