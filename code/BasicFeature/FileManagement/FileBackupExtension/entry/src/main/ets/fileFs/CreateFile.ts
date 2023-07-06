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

import Logger from '../common/Logger';
import fs from '@ohos.file.fs';

export default class CreatFile {
  TAG: string = '[Sample_FileBackDemo]';
  baseDir: string = AppStorage.Get('sanBoxFileDir') + '/TextDir';

  constructor() {
  }

  async createTestFiles(): Promise<void> {
    try {
      let num = Math.floor(Math.random() * 10) + 1;
      if (!fs.accessSync(this.baseDir)) {
        fs.mkdirSync(this.baseDir);
      }
      let dpath = this.baseDir;
      Logger.info(this.TAG, 'sanBoxFileDir = ' + dpath);
      Logger.info(this.TAG, 'num is  = ' + num);
      for (let i = 0; i < num; i++) {
        let myFile = dpath + `/TestFile_${i}.txt`;
        Logger.info(this.TAG, 'readyFile myFile = ' + myFile);
        let file = fs.openSync(myFile, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
        fs.writeSync(file.fd, new ArrayBuffer(1024 * Math.random()));
        fs.closeSync(file);
      }
    } catch (e) {
      Logger.error(this.TAG, 'Failed to prepare media files, error:' + e.message + e.code);
    }
  }
}