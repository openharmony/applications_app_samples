/*
 * Copyright (c) 2023-2024 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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

import storageStatistics from '@ohos.file.storageStatistics';
import fs from '@ohos.file.fs';
import { Options } from '@ohos.file.fs';
import { BusinessError } from '@ohos.base';
import Logger from '../../utils/Logger';
import { FileType, SubDirectoryType } from '../../mock/local/FileData';
import prompt from '@ohos.promptAction';

class NewFileSystem {
  // 创建多级目录
  createDirectory(filePath: string): void {
    try {
      console.log("To create recursive path");
      fs.mkdirSync(filePath,true);
    } catch (err) {
      Logger.error(`create directory failed, code is ${err.code}, message is ${err.message}`);
    }
  }

  // 修改文件时间
  setFileTime(filePath: string, timeStr: string): void {
    try {
      let time = new Date(timeStr).getTime();
      if (Number.isNaN(time)) {
        return prompt.showToast({ message: $r('app.string.tip_invalid_time') });
      }
      fs.utimes(filePath,time);
    } catch (err) {
      Logger.error(`setFileTime failed, code is ${err.code}, message is ${err.message}`);
      throw new Error(`setFileTime failed, code is ${err.code}, message is ${err.message}`);
    }
  }

  // 读取文件内容
  async ReadFile(filePath: string):Promise<string> {
    try{
      let content : string='';
      let options: Options = {
        encoding: 'utf-8'
      };
      await fs.readLines(filePath, options).then((readerIterator: fs.ReaderIterator) => {
        for (let it = readerIterator.next(); !it.done; it = readerIterator.next()) {
          content += it.value;
        }
      }
      ).catch((err: BusinessError) => {
        console.info("readLines failed with error message: " + err.message + ", error code: " + err.code);
      });
      return content;
    } catch (err) {
      Logger.error(`OpenFile failed, code is ${err.code}, message is ${err.message}`);
      throw new Error(`OpenFile failed, code is ${err.code}, message is ${err.message}`);
    }
  }
}

export default new NewFileSystem();
