/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { Filter } from '@ohos.file.fs';
import { BusinessError } from '@ohos.base';
import fileAccess from '@ohos.file.fileAccess';
import { Logger } from '@ohos/feature-file-manager';

class FilterType {
  public suffix: string[] = ['.txt']
}

class DocumentFileManager {
  getDeviceInfo(context: Context, fileAccessHelperAllServer: fileAccess.FileAccessHelper) {
    try {
      fileAccessHelperAllServer = fileAccess.createFileAccessHelper(context);
      Logger.info('createFileAccessHelper interface returns an object: ' + JSON.stringify(fileAccessHelperAllServer));
      if (!fileAccessHelperAllServer) {
        Logger.error('createFileAccessHelper interface returns an undefined object');
        return fileAccessHelperAllServer;
      }
      return fileAccessHelperAllServer;
    } catch (err) {
      let error: BusinessError = err as BusinessError;
      Logger.error('createFileAccessHelper failed, errCode:' + error.code + ', errMessage:' + error.message);
      return fileAccessHelperAllServer;
    }
  }

  async getRootsDir(rootInfos: fileAccess.RootInfo[], fileAccessHelperAllServer: fileAccess.FileAccessHelper) {
    let isDone: boolean = false;
    let rootIterator: fileAccess.RootIterator;
    try {
      rootIterator = await fileAccessHelperAllServer.getRoots();
      while (!isDone) {
        let result = rootIterator.next();
        Logger.info('next result = ' + JSON.stringify(result));
        isDone = result.done;
        if (!isDone) {
          rootInfos.push(result.value);
          Logger.info('rootsInfos is: ' + rootInfos)
        }
      }
    } catch (err) {
      let error: BusinessError = err as BusinessError;
      Logger.error('getRoots failed, errCode:' + error.code + ', errMessage:' + error.message);
      return rootInfos;
    }
    return rootInfos;
  }

  iteratorDir(rootInfos: fileAccess.RootInfo[]) {
    let rootInfo: fileAccess.RootInfo = rootInfos[0];
    let fileInfos: fileAccess.FileInfo[] = [];
    let isDone: boolean = false;
    try {
      let fileIterator: fileAccess.FileIterator = rootInfo.listFile();
      if (!fileIterator) {
        Logger.error('listFile interface returns an undefined object');
        return fileInfos;
      }
      while (!isDone) {
        let result = fileIterator.next();
        Logger.info('next result = ' + JSON.stringify(result));
        isDone = result.done;
        if (!isDone) {
          fileInfos.push(result.value);
        }
      }
    } catch (err) {
      let error: BusinessError = err as BusinessError;
      Logger.error('listFile failed, errCode:' + error.code + ', errMessage:' + error.message);
    }
    return fileInfos;
  }

  async createFile(fileAccessHelperAllServer: fileAccess.FileAccessHelper) {
    const MOCK: string = 'mock_';
    let fileUri: string = '';
    let displayName: string = MOCK + Date.now() + '.txt';
    let fileInfo: fileAccess.FileInfo | undefined = undefined;
    let sourceUri: string = 'file://docs/storage/Users/currentUser/Download';

    try {
      fileUri = await fileAccessHelperAllServer.createFile(sourceUri, displayName);
      fileInfo = await fileAccessHelperAllServer.getFileInfoFromUri(fileUri);
      return fileInfo;
      if (!fileUri) {
        Logger.error('createFile return undefined object');
      }
      Logger.info('createFile sucess, fileUri: ' + JSON.stringify(fileUri));
    } catch (err) {
      let error: BusinessError = err as BusinessError;
      Logger.error('createFile failed, errCode:' + error.code + ', errMessage:' + error.message);
    }
    return fileInfo;
  }

  scanFiles(fileInfos: fileAccess.FileInfo[]) {
    let fileInfoDir: fileAccess.FileInfo = fileInfos[1];
    let subfileInfos: fileAccess.FileInfo[] = [];
    let isDone: boolean = false;
    let filter: FilterType = { suffix: ['.txt'] };
    try {
      let fileIterator = fileInfoDir.scanFile(filter);
      while (!isDone) {
        let result = fileIterator.next();
        isDone = result.done;
        if (!isDone) {
          subfileInfos.push(result.value);
        }
      }
    } catch (err) {
      let error: BusinessError = err as BusinessError;
      Logger.error('scanFile failed, errCode:' + error.code + ', errMessage:' + error.message);
    }
    return subfileInfos;
  }
}

export default new DocumentFileManager();

