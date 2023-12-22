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

import common from '@ohos.app.ability.common';
import fs from '@ohos.file.fs';
import Logger from '../../../../../Library/src/main/ets/utils/Logger';
import prompt from '@ohos.promptAction';
import { BusinessError } from '@ohos.base';

const TAG: string = 'DistributedFileManager';
const BASE_PATH = "/data/storage/el2/base/haps/entry/files";
let filesDir1 = BASE_PATH + '/test1';
let filesDir2 = BASE_PATH + '/test2';
let precastFiles: string[] = [
  "file1.txt",
  "file2.txt",
  "file3.txt",
];

let isCopying: boolean = false;
let totalProgress: number = 0;
let totalCopySize: number = 0;
let copiedSize: number = 0;

class FsManager {
  initFiles(): void {
    try {
      let res = fs.accessSync(filesDir1);
      if (res) {
        Logger.info(`file path: ${filesDir1} exists`);
      } else {
        Logger.info(`file path: ${filesDir1} not exists`);
        fs.mkdirSync(filesDir1);
      }
    } catch(error) {
      let err: BusinessError = error as BusinessError;
      Logger.error("accessSync failed with error message: " + err.message + ", error code: " + err.code);
    }
    try {
      let res = fs.accessSync(filesDir2);
      if (res) {
        Logger.info(`file path: ${filesDir2} exists`);
      } else {
        Logger.info(`file path: ${filesDir2} not exists`);
        fs.mkdirSync(filesDir2);
      }
    } catch(error) {
      let err: BusinessError = error as BusinessError;
      Logger.error("accessSync failed with error message: " + err.message + ", error code: " + err.code);
    }

  for (let i = 0; i < precastFiles.length; i++) {
    let fileName = filesDir1 + "/" + precastFiles[i];
    Logger.info(`The file name: ${fileName}`);
    try {
      let res = fs.accessSync(fileName);
      if (res) {
        Logger.info(`file: ${fileName} exists!.`);
      } else {
        Logger.info(`file: ${fileName} not exists, will create it!.`);
        let file = fs.openSync(fileName, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
        fs.write(file.fd, 'test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1' +
          'test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1test' +
          'test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1test' +
          'test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1test' +
          'test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1test' +
          'test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1test');
        fs.closeSync(file);
      }
    } catch(error) {
      let err: BusinessError = error as BusinessError;
      Logger.error("accessSync failed with error message: " + err.message + ", error code: " + err.code);
    }
  }
}

  listFiles(dir: string): Array<string> {
    let files: string[] = [];
    let context = getContext(this) as common.UIAbilityContext;
    let fileDir = (dir == 'files' ? context.filesDir : (dir == 'temp' ? context.tempDir : context.cacheDir));
    Logger.info(TAG, `listFiles fileDir =${fileDir}`);
    try {
      files = fs.listFileSync(fileDir);
      Logger.info(TAG, `listFiles listFileSync =${JSON.stringify(files)}`);
    } catch (err) {
      Logger.info(TAG, `listFiles err =${JSON.stringify(err)}`);
    }
    return files;
  }

  //复制到剪切板，不弹进度条
  copyFilesToDistributedDir(from:string,to:string) {
    try {
      // copy
      let progressListener: fs.ProgressListener = (progress: fs.Progress) => {
        Logger.info("progressSize: " + progress.processedSize + ", totalSize: " + progress.totalSize);
      };
      let options: fs.CopyOptions = {
        "progressListener" : progressListener
      }
      // 进行拷贝
      fs.copy(from, to, options).then(()=>{
        Logger.info("Succeeded in copying. ");
      }).catch((err: BusinessError)=>{
        Logger.info(`Failed to copy. Code: ${err.code}, message: ${err.message}`);
        return prompt.showToast({ message: $r('app.string.label_copyfailed') });
      })
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      Logger.error(`Failed to set paste data. Code: ${err.code}, message: ${err.message}`);
    }
  }

  //粘贴，弹进度条
  pasteFromDistributedDir(firstCopy:boolean,from:string,to:string) {
    try {
      // 定义拷贝回调
      let lastCopiedSize:number = 0;
      let progressListener: fs.ProgressListener = (progress: fs.Progress) => {
        Logger.info("progressSize: " + progress.processedSize + ", totalSize: " + progress.totalSize);
        //第一次进入回调
        if(firstCopy) {
          totalCopySize += progress.totalSize;
          copiedSize += progress.processedSize;
          lastCopiedSize = progress.processedSize;
        } else {
          copiedSize -= lastCopiedSize;
          copiedSize += progress.processedSize;
          lastCopiedSize = progress.processedSize;
        }

        totalProgress = Number(((copiedSize/totalCopySize)*100).toFixed(0));
        AppStorage.SetOrCreate('progress',totalProgress);

        if(totalCopySize != copiedSize) {
          Logger.info("to set isCopying true");
          isCopying = true;
          AppStorage.SetOrCreate('isCopying',true);
        } else {
          isCopying = false;
          AppStorage.SetOrCreate('isCopying',false);
          AppStorage.SetOrCreate('flashPage',!AppStorage.Get<string>('flashPage'));
        }
      };
      let options: fs.CopyOptions = {
        "progressListener" : progressListener
      }
      // 进行拷贝
      fs.copy(from, to, options).then(() => {
        isCopying = false;
        AppStorage.SetOrCreate('isCopying',false);
        Logger.info("Succeeded in copying. ");
        return prompt.showToast({ message: $r('app.string.label_dirupdate') });
      }).catch((err: BusinessError) => {
        isCopying = false;
        AppStorage.SetOrCreate('isCopying',false);
        Logger.info(`Failed to copy. Code: ${err.code}, message: ${err.message}`);
        return prompt.showToast({ message: $r('app.string.label_copyfailed') });
      })
    } catch(err) {
      Logger.error(`Failed to getData. Code: ${err.code}, message: ${err.message}`);
    }
  }
}

export default new FsManager();
