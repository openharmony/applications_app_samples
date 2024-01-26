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
import fileuri from '@ohos.file.fileuri';
import Logger from '../../../../../Library/src/main/ets/utils/Logger';
import prompt from '@ohos.promptAction';
import DataObject from './DataObject';
import { BusinessError } from '@ohos.base';
import { FileStructure, FileType } from '@ohos/feature-file-manager/src/main/ets/mock/local/FileData';

const TAG: string = 'FsManager';
const BASE_PATH = "/data/storage/el2/base/haps/entry/files";
let filesDir1 = BASE_PATH + '/test1';
let filesDir2 = BASE_PATH + '/test2';
let precastFiles: string[] = [
  "file1.txt",
  "file2.txt",
  "file3.txt",
];

let isCopying: boolean = false;
const fileCopy: string = '-副本';

class FsManager {
  initFiles(): void {
    try {
      let res = fs.accessSync(filesDir1);
      if (res) {
        Logger.info(TAG, `file path: ${filesDir1} exists`);
      } else {
        Logger.info(TAG, `file path: ${filesDir1} not exists`);
        fs.mkdirSync(filesDir1);
      }
    } catch(error) {
      let err: BusinessError = error as BusinessError;
      Logger.error(TAG, "accessSync failed with error message: " + err.message + ", error code: " + err.code);
    }
    try {
      let res = fs.accessSync(filesDir2);
      if (res) {
        Logger.info(TAG, `file path: ${filesDir2} exists`);
      } else {
        Logger.info(TAG, `file path: ${filesDir2} not exists`);
        fs.mkdirSync(filesDir2);
      }
    } catch(error) {
      let err: BusinessError = error as BusinessError;
      Logger.error(TAG, "accessSync failed with error message: " + err.message + ", error code: " + err.code);
    }

  for (let i = 0; i < precastFiles.length; i++) {
    let fileName = filesDir1 + "/" + precastFiles[i];
    Logger.info(TAG, `The file name: ${fileName}`);
    try {
      let res = fs.accessSync(fileName);
      if (res) {
        Logger.info(TAG, `file: ${fileName} exists!.`);
      } else {
        Logger.info(TAG, `file: ${fileName} not exists, will create it!.`);
        let file = fs.openSync(fileName, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
        fs.writeSync(file.fd, 'test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1' +
          'test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1test' +
          'test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1test' +
          'test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1test' +
          'test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1test' +
          'test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1test1test');
        fs.closeSync(file);
      }
    } catch(error) {
      let err: BusinessError = error as BusinessError;
      Logger.error(TAG, "accessSync failed with error message: " + err.message + ", error code: " + err.code);
    }
  }

    let fileName = filesDir2 + "/" + "file4.txt";
    try {
      let res = fs.accessSync(fileName);
      if (res) {
        Logger.info(TAG, `file: ${fileName} exists!.`);
      } else {
        Logger.info(TAG, `file: ${fileName} not exists, will create it!.`);
        let file = fs.openSync(fileName, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
        fs.writeSync(file.fd, 'test4test4test4test4test4test4test4test4test4test4test4test4test4test4test4test4' +
          'test4test4test4test4test4test4test4test4test4test4test4test4test4test4test4test4test4test4test4' +
          'test4test4test4test4test4test4test4test4test4test4test4test4test4test4test4test4test4test4test4' +
          'test4test4test4test4test4test4test4test4test4test4test4test4test4test4test4test4test4test4test4' +
          'test4test4test4test4test4test4test4test4test4test4test4test4test4test4test4test4test4test4test4' +
          'test4test4test4test4test4test4test4test4test4test4test4test4test4test4test4test4test4test4test4');
        fs.closeSync(file);
      }
    } catch(error) {
      let err: BusinessError = error as BusinessError;
      Logger.error(TAG, "accessSync failed with error message: " + err.message + ", error code: " + err.code);
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

  copyFilesToDistributedDir(deviceId: string, needMoveFiles: Array<FileType>, disPathInSandbox: string) {
    let distributedUri0 = fileuri.getUriFromPath(disPathInSandbox);
    let localFileUriList: Array<string> = [];
    let disFileUriList: Array<string> = [];
    let disFileList: Array<string> = [];
    let distributedUri = '';
    needMoveFiles.forEach((file: FileType) => {
      Logger.info(TAG, `in copyToDistributedDir--file type : ${file.type}`);
      //用于粘贴完后的clear动作中
      let disFilePath = disPathInSandbox + "/" + file.fileName;
      //type： 1 directory,type 2 file
      let localSrcUri = fileuri.getUriFromPath(file.filePath);
      //如果是文件夹
      if (file.type === 1) {
        distributedUri = distributedUri0+ "/" + file.fileName;
        this.innerCopyFilesToDistributedDir(localSrcUri,distributedUri0);
      } else if (file.type === 2) { //处理Uri，如果是文件类型，需另外处理，前缀增加"file+"，用分布式对象进行传输
        const fileName = localSrcUri.split('/').pop();
        distributedUri = distributedUri0 +"/"+fileName;
        this.innerCopyFilesToDistributedDir(localSrcUri,distributedUri);
        localSrcUri = "file+" + localSrcUri;
        distributedUri = "file+" + distributedUri;
      } else {
        Logger.error(TAG, `this is not file or directory`);
      }
      // to update DataObject
      localFileUriList.push(localSrcUri);
      disFileUriList.push(distributedUri);
      disFileList.push(disFilePath);
    })
    DataObject.update(deviceId,localFileUriList,disFileUriList,disFileList);
  }

  //复制到剪切板，不弹进度条
  innerCopyFilesToDistributedDir(from:string,to:string) {
    Logger.info(TAG, `copyToDistributedDir--from: ${from}`);
    Logger.info(TAG, `copyToDistributedDir--to: ${to}`);
    try {
      // copy
      let progressListener: fs.ProgressListener = (progress: fs.Progress) => {
        Logger.info(TAG ,"progressSize: " + progress.processedSize + ", totalSize: " + progress.totalSize);
      };
      let options: fs.CopyOptions = {
        "progressListener" : progressListener
      }
      // 进行拷贝
      fs.copy(from, to, options).then(()=>{
        Logger.info("Succeeded in copying. ");
      }).catch((err: BusinessError)=>{
        Logger.info(`Failed to copy. Code: ${err.code}, message: ${err.message}`);
        return prompt.showToast({ message: $r('app.string.label_copy2disfailed') });
      })
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      Logger.error(TAG, `Failed to set paste data. Code: ${err.code}, message: ${err.message}`);
    }
  }

  pasteFromDistributedDir(deviceId: string, directoryPath:string, fileData: Array<FileStructure>) {
    let localDstUri = fileuri.getUriFromPath(directoryPath);

    if (DataObject.distributedObject["disFileUriList"].length === 0) {
      return prompt.showToast({ message: $r('app.string.label_nodata') });
    }
    //本地拷贝:文件需进行重命名操作
    if (deviceId == DataObject.distributedObject["from"]) {
      let localFileArray: Array<string> = DataObject.distributedObject["localFileUriList"];
      let newFileName:string = '';
      localFileArray.forEach( item  => {
        //判断uri前缀是否有“file+”，如果是文件类型，去掉“file+”前缀，在localDstUri后面加上文件名称
        if (item.includes("file+")) {
          item = item.substring(5, item.length);
          let fileName: string | undefined = item.split('/').pop();
          if(fileName)
          {
            newFileName = fileName;
          } else {
            return;
          }
          //判断本地是否有同名文件，有则重命名
          fileData.forEach(file => {
            //有同名文件
            if(file.name.includes(newFileName)){
              //extension 文件后缀
              let extension :string = newFileName.slice((newFileName.lastIndexOf(".") - 1 >>> 0) + 2);
              if(extension){
                let fileParts = newFileName.split('.');
                newFileName = fileParts[0] + fileCopy + '.' + fileParts[1];
              } else {
                newFileName = newFileName + fileCopy;
              }
            }
          })
        }
        this.innerPasteFromDistributedDir(item,localDstUri+newFileName);
      })
    } else { //跨设备拷贝
      let disFileUriArray: Array<string> = DataObject.distributedObject["disFileUriList"];
      disFileUriArray.forEach( item  => {
        if (item.includes("file+")) {
          item = item.substring(5, item.length);
          let fileName: string | undefined = item.split('/').pop();
          let newFileName: string = '';
          if(fileName)
          {
            newFileName = fileName;
          } else {
            return;
          }
          this.innerPasteFromDistributedDir(item,localDstUri+newFileName);
        } else {
          this.innerPasteFromDistributedDir(item,localDstUri);
        }
      })
    }
  }
  //粘贴，弹进度条
  innerPasteFromDistributedDir(from:string,to:string) {
    Logger.info(TAG, `innerPasteFromDistributedDir--from: ${from}`);
    Logger.info(TAG, `innerPasteFromDistributedDir--to: ${to}`);
    try {
      // 定义拷贝回调
      let totalProgress: number = 0;
      let totalCopySize: number = 0;
      let copiedSize: number = 0;
      let lastCopiedSize: number = 0;
      let firstCopy = true;
      let progressListener: fs.ProgressListener = (progress: fs.Progress) => {
        Logger.info(TAG, "progressSize: " + progress.processedSize + ", totalSize: " + progress.totalSize);
        //第一次进入回调
        if(firstCopy === true) {
          Logger.info(TAG, "firstCopy");
          totalCopySize += progress.totalSize;
          copiedSize += progress.processedSize;
          lastCopiedSize = progress.processedSize;
          firstCopy = false;
        } else {
          copiedSize -= lastCopiedSize;
          copiedSize += progress.processedSize;
          lastCopiedSize = progress.processedSize;
        }

        totalProgress = Number(((copiedSize/totalCopySize)*100).toFixed(0));
        AppStorage.SetOrCreate('progress',totalProgress);
        Logger.info(TAG, "totalCopySize: " + totalCopySize + ", copiedSize: " + copiedSize);
        if(totalCopySize != copiedSize) {
          isCopying = true;
          AppStorage.SetOrCreate('isCopying',true);
        } else {
          Logger.info(TAG, "totalCopySize == copiedSize,Successfully coppied");
          isCopying = false;
          AppStorage.SetOrCreate('isCopying',false);
          AppStorage.SetOrCreate('flashPage',!AppStorage.Get<string>('flashPage'));
          DataObject.clear();
          return prompt.showToast({ message: $r('app.string.label_dirupdate') });
        }
      };
      let options: fs.CopyOptions = {
        "progressListener" : progressListener
      }
      // 进行拷贝
      fs.copy(from, to, options).then(() => {
        isCopying = false;
        AppStorage.SetOrCreate('isCopying',false);
        Logger.info(TAG, "Succeeded in copying. ");
      }).catch((err: BusinessError) => {
        isCopying = false;
        AppStorage.SetOrCreate('isCopying',false);
        Logger.info(TAG, `Failed to copy. Code: ${err.code}, message: ${err.message}`);
        DataObject.clear();
        return prompt.showToast({ message: $r('app.string.label_copyfailed') });
      })
    } catch(err) {
      Logger.error(TAG, `Failed to getData. Code: ${err.code}, message: ${err.message}`);
    }
  }
}

export default new FsManager();
