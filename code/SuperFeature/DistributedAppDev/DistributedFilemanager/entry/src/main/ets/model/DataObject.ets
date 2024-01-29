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
import fs from '@ohos.file.fs';
import { Logger } from '@ohos/feature-file-manager';

const TAG: string = 'DataObjectModel';

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
}

export default new DataObject();
