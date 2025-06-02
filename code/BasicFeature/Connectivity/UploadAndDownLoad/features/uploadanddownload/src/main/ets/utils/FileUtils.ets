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

import common from '@ohos.app.ability.common';
import fs from '@ohos.file.fs';
import { logger } from '../utils/Logger';

const TAG: string = 'FileUtil';
const ALBUMS: string[] = ['Pictures', 'Videos', 'Others'];

class FileUtil {
  constructor() {
  }

  async initDownloadDir(downloadDir: string): Promise<void> {  
    logger.info(TAG, `initDownloadDir downloadDir=${downloadDir}`);
    try {
      fs.mkdirSync(`${downloadDir}/${ALBUMS[0]}`);
      fs.mkdirSync(`${downloadDir}/${ALBUMS[1]}`);
      fs.mkdirSync(`${downloadDir}/${ALBUMS[2]}`);
    } catch (err) {
      logger.info(TAG, `initDownloadDir err =${JSON.stringify(err)}`);
    }
  }

  async listFolders(downloadDir: string): Promise<Array<string>> {
    await this.initDownloadDir(downloadDir);
    return ALBUMS;
  }

  async clearFolder(downloadDir: string,folderName: string): Promise<void> {
    try {
      let files: string[] = fs.listFileSync(`${downloadDir}/${folderName}`);
      logger.info(TAG, `listFiles listFileSync =${JSON.stringify(files)}`);
      for (let i = 0; i < files.length; i++) {
        fs.unlinkSync(`${downloadDir}/${folderName}/${files[i]}`);
      }
    } catch (err) {
      logger.info(TAG, `listFiles err =${JSON.stringify(err)}`);
    }
  }

  async listFiles(downloadDir:string,folderName: string): Promise<Array<string>> { 
    let files: string[] = [];
    try {
      files = fs.listFileSync(`${downloadDir}/${folderName}`);
      logger.info(TAG, `listFiles listFileSync =${JSON.stringify(files)}`);
    } catch (err) {
      logger.info(TAG, `listFiles err =${JSON.stringify(err)}`);
    }
    return files;
  }
}

export const fileUtils = new FileUtil();