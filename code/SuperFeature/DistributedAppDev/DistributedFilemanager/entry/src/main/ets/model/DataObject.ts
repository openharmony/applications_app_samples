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
import { FileStructure, FileType } from '@ohos/feature-file-manager/src/main/ets/mock/local/FileData';
import { Logger } from '@ohos/feature-file-manager';

const TAG: string = 'DataObjectModel';

class DataObject {
  public distributedObject: distributedDataObject.DistributedObject;


  constructor() {
    this.distributedObject = distributedDataObject.createDistributedObject(  {
      from: '',
      localFileUriList: [],
      disFileUriList: [],
      disFileList: [],
    })
  }
  setSessionId(context: common.UIAbilityContext, sessionId: string): void {
    Logger.info(TAG, `setSessionId`)
    this.distributedObject = distributedDataObject.createDistributedObject( {
      from: '',
      localFileUriList: [],
      disFileUriList: [],
      disFileList: [],
    })
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
      this.distributedObject["disFileList"].forEach( item  => {
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
    //本地拷贝:文件需进行重命名操作
    if (deviceId == this.distributedObject["from"]) {
      this.distributedObject["localFileUriList"].forEach( item => {
        //判断uri前缀是否有“file+”，如果是文件类型，去掉“file+”前缀，在localDstUri后面加上文件名称
        if (item.includes("file+")) {
          item = item.substring(5, item.length);
          let fileName : string = item.split('/').pop();
          //判断本地是否有同名文件，有则重命名
          fileData.forEach(file => {
            //有同名文件
            if(file.name.includes(fileName)){
              //extension 文件后缀
              let extension :string = fileName.slice((fileName.lastIndexOf(".") - 1 >>> 0) + 2);
              if(extension){
                let fileParts = fileName.split('.');
                fileName = fileParts[0] + $r('app.string.label_copyfile') + fileParts[1];
              } else {
                fileName = fileName + $r('app.string.label_copyfile');
              }
            }
          })
          localDstUri = localDstUri+fileName;
        }
        FsManager.pasteFromDistributedDir(item,localDstUri);
      })
    } else { //跨设备拷贝
      this.distributedObject["disFileUriList"].forEach( item => {
        if (item.includes("file+")) {
          item = item.substring(5, item.length);
          let fileName : string = item.split('/').pop();
          FsManager.pasteFromDistributedDir(item,localDstUri+fileName);
        } else {
          FsManager.pasteFromDistributedDir(item,localDstUri);
        }
      })
    }
  }

  copyFilesToDistributedDir(deviceId: string, needMoveFiles: Array<FileType>, disPathInSandbox: string) {
    let distributedUri = fileuri.getUriFromPath(disPathInSandbox);
    let localFileUriList: Array<string> = [];
    let disFileUriList: Array<string> = [];
    let disFileList: Array<string> = [];
    needMoveFiles.forEach((file: FileType) => {
      //用于粘贴完后的clear动作中
      let disFilePath = disPathInSandbox + "/" + file.fileName;
      //type： 1 directory,type 2 file
      let localSrcUri = fileuri.getUriFromPath(file.filePath);
      //如果是文件夹
      if (file.type === 1) {
        distributedUri = distributedUri+ "/" + file.fileName;
        FsManager.copyFilesToDistributedDir(localSrcUri,distributedUri);
      }
      //处理Uri，如果是文件类型，需另外处理，前缀增加"file+"，用分布式对象进行传输
      else if (file.type === 2) {
        const fileName = localSrcUri.split('/').pop();
        distributedUri = distributedUri +"/"+fileName;
        FsManager.copyFilesToDistributedDir(localSrcUri,distributedUri);
        localSrcUri = "file+" + localSrcUri;
        distributedUri = "file+" + distributedUri;
      } else {
        console.log("this is not file or directory");
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
