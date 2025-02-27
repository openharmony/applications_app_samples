/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import Logger from '../common/Logger';
import { fileIo as fs } from '@kit.CoreFileKit';
import { BusinessError } from '@ohos.base';

const ONE_KILOBYTE: number = 1024; // 1k = 1024B
const FILE_NUM: number = 5; // 创建文件的数量

export default class CreatFile {
  baseDir: string = AppStorage.get('sanBoxFileDir') + '/TextDir';

  constructor() {
  }

  async createTestFiles(filePath: string): Promise<void> {
    try {
      let num = FILE_NUM;
      if (!fs.accessSync(filePath)) {
        fs.mkdirSync(filePath);
      }
      let dpath = filePath;
      Logger.info('sanBoxFileDir = ' + dpath);
      Logger.info('num is  = ' + num);
      for (let i = 0; i < num; i++) {
        let myFile = dpath + `/TestFile_${i}.txt`;
        Logger.info('readyFile myFile = ' + myFile);
        let file = fs.openSync(myFile, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
        fs.writeSync(file.fd, new ArrayBuffer(ONE_KILOBYTE * Math.random()));
        fs.closeSync(file);
      }
    } catch (err) {
      let error: BusinessError = err as BusinessError;
      Logger.error('Failed to prepare media files, error:' + error.message + error.code);
    }
  }

  async deleteTestFiles(filePath: string): Promise<void> {
    try {
      let num = FILE_NUM;
      if (!fs.accessSync(filePath)) {
        fs.mkdirSync(filePath);
      }
      let dpath = filePath;
      Logger.info('sanBoxFileDir = ' + dpath);
      Logger.info('num is  = ' + num);
      for (let i = 0; i < num; i++) {
        let myFile = dpath + `/TestFile_${i}.txt`;
        fs.unlink(myFile).then(() => {
          Logger.info('remove file succeed');
        }).catch((err: BusinessError) => {
          Logger.error('remove file failed with error message: ' + err.message + err.code);
        });
      }
    } catch (err) {
      let error: BusinessError = err as BusinessError;
      Logger.error('Failed to prepare media files, error:' + error.message + error.code);
    }
  }
}


