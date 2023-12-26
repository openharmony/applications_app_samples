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

import distributedDataObject from '@ohos.data.distributedDataObject';
import common from '@ohos.app.ability.common';
import FsManager from './FsManager';
import fs from '@ohos.file.fs';
import fileuri from '@ohos.file.fileuri';
import prompt from '@ohos.promptAction';
import { FileStructure, FileType } from '@ohos/feature-file-manager/src/main/ets/mock/local/FileData';
import { Logger } from '@ohos/feature-file-manager';

const TAG: string = 'DataObjectModel';
const fileCopy: string = '-副本';

class DataObject {
  public distributedObject: distributedDataObject.DistributedObject;
  constructor() {
    this.distributedObject = distributedDataObject.createDistributedObject( {
      from: '',
      localFileUriList: [],
      disFileUriList: [],
      disFileList: [],
    })
  }
  setSessionId(context: common.UIAbilityContext, sessionId: string): void {
    Logger.info(TAG, `setSessionId`)
    this.distributedObject.setSessionId(sessionId)
  }

  update(from: string, localFileUriList: string[], disFileUriList: string[], disFileList: string[]) {
    Logger.info(TAG, `doUpdate,${from},${localFileUriList},${disFileUriList},${disFileList}`)
    this.distributedObject['from'] = from;
    this.distributedObject['localFileUriList'] = localFileUriList;
    this.distributedObject['disFileUriList'] = disFileUriList;
    this.distributedObject['disFileList'] = disFileList;
  }

  clear() {
    try{
      let disFileArray: Array<string> = this.distributedObject["disFileList"];
      disFileArray.forEach( item  => {
        //判断uri前缀是否有“file+”，如果有则为文件
        if(item.includes("file+")){
          item = item.substring(5, item.length);
          fs.unlinkSync(item);
        } else {
          fs.rmdirSync(item);
        }
      })
    } catch (err) {
      Logger.error(TAG, `delete failed, code is ${err.code}, message is ${err.message}`);
    }
    this.distributedObject['from'] = '';
    this.distributedObject['localFileUriList'] = [];
    this.distributedObject['disFileUriList'] = [];
    this.distributedObject['disFileList'] = [];
  }

  pasteFromDistributedDir(deviceId: string, directoryPath:string, fileData: Array<FileStructure>) {
    let localDstUri = fileuri.getUriFromPath(directoryPath);
    if (this.distributedObject["disFileUriList"].length === 0) {
      return prompt.showToast({ message: $r('app.string.label_nodata') });
    }
    //本地拷贝:文件需进行重命名操作
    if (deviceId == this.distributedObject["from"]) {
      let localFileArray: Array<string> = this.distributedObject["localFileUriList"];
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
        FsManager.pasteFromDistributedDir(item,localDstUri+newFileName);
      })
    } else { //跨设备拷贝
      let disFileUriArray: Array<string> = this.distributedObject["disFileUriList"];
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
          FsManager.pasteFromDistributedDir(item,localDstUri+newFileName);
        } else {
          FsManager.pasteFromDistributedDir(item,localDstUri);
        }
      })
    }
  }

  copyFilesToDistributedDir(deviceId: string, needMoveFiles: Array<FileType>, disPathInSandbox: string) {
    let distributedUri0 = fileuri.getUriFromPath(disPathInSandbox);
    let localFileUriList: Array<string> = [];
    let disFileUriList: Array<string> = [];
    let disFileList: Array<string> = [];
    let distributedUri = '';
    needMoveFiles.forEach((file: FileType) => {
      //用于粘贴完后的clear动作中
      let disFilePath = disPathInSandbox + "/" + file.fileName;
      //type： 1 directory,type 2 file
      let localSrcUri = fileuri.getUriFromPath(file.filePath);
      //如果是文件夹
      if (file.type === 1) {
        distributedUri = distributedUri0+ "/" + file.fileName;
        FsManager.copyFilesToDistributedDir(localSrcUri,distributedUri);
      }
      //处理Uri，如果是文件类型，需另外处理，前缀增加"file+"，用分布式对象进行传输
      else if (file.type === 2) {
        const fileName = localSrcUri.split('/').pop();
        distributedUri = distributedUri0 +"/"+fileName;
        FsManager.copyFilesToDistributedDir(localSrcUri,distributedUri);
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
    this.update(deviceId,localFileUriList,disFileUriList,disFileList);
  }
}

export default new DataObject();
