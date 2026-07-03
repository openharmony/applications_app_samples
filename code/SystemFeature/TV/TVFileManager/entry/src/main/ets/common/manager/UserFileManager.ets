/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { userFileManager } from '@kit.CoreFileKit';
import { dataSharePredicates } from '@kit.ArkData';
import { MLog } from '../utils/MLog';
import { FileIoManager } from './FileIoManager';
import { Context } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG: string = 'UserFileManager';

export class UserFileManager {
  private static ins: UserFileManager = new UserFileManager();
  private mgr: userFileManager.UserFileManager | null = null;
  private static context: Context | undefined;

  public static getIns(ctx?: Context): UserFileManager {
    if (ctx) {
      UserFileManager.context = ctx;
    }
    if (!UserFileManager.ins.mgr) {
      UserFileManager.ins.mgr = UserFileManager.ins.getMgr(UserFileManager.context);
    }
    return UserFileManager.ins;
  }

  private getMgr(ctx?: Context): userFileManager.UserFileManager {
    try {
      return userFileManager.getUserFileMgr(ctx);
    } catch (err) {
      throw new Error(`getUserFileMgr failed: ${JSON.stringify(err)}`);
    }
  }

  public release(): void {
    if (this.mgr) {
      this.mgr.release();
      this.mgr = null;
    }
  }

  public async delete(uri: string): Promise<void> {
    if (!this.mgr) {
      throw new Error('UserFileManager not initialized');
    }
    MLog.print(TAG, `delete uri:${uri}`);
    return this.mgr.delete(uri).then(() => {
      MLog.print(TAG, `delete success uri:${uri}`);
    });
  }

  public async createFile(fileName: string, albumUri?: string): Promise<userFileManager.FileAsset> {
    if (!this.mgr) {
      throw new Error('UserFileManager not initialized');
    }
    try {
      MLog.print(TAG, `createFile fileName:${fileName}  albumUri:${albumUri}`);
      let fileAsset: userFileManager.FileAsset = await this.mgr.createPhotoAsset(fileName, albumUri);
      MLog.print(TAG, `createFile displayName:${fileAsset.displayName}  uri:${fileAsset.uri}`);
      return fileAsset;
    } catch (err) {
      MLog.info(TAG, 'createFile failed, message = ' + err);
      throw new Error(`createFile failed: ${JSON.stringify(err)}`);
    }
  }

  public async getFileAsset(fileUri: string): Promise<userFileManager.FileAsset> {
    if (!this.mgr) {
      throw new Error('UserFileManager not initialized');
    }
    try {
      let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
      predicates.equalTo('uri', fileUri);
      let imagesFetchOp: userFileManager.FetchOptions = {
        fetchColumns: [],
        predicates: predicates
      };
      MLog.print(TAG, `getFileAsset  fileUri:${fileUri}`);
      let fetchFileResult: userFileManager.FetchResult<userFileManager.FileAsset> =
        await this.mgr.getPhotoAssets(imagesFetchOp);
      const count: number = fetchFileResult.getCount();
      if (count <= 0) {
        MLog.warn(TAG, `Failed to get count from fetchFileResult: count: ${count} fileUri:${fileUri}`);
        throw Error('not find');
      }

      MLog.info(TAG, 'Get fetchFileResult success, count: ' + count);
      let fileAsset: userFileManager.FileAsset = await fetchFileResult.getFirstObject();
      MLog.log(TAG, 'fileAsset.displayName ' + fileAsset.displayName + ' >>>>');

      return fileAsset;
    } catch (err) {
      MLog.error(TAG, 'Failed to get file assets: ' + err);
      throw new Error(`getFileAsset failed: ${JSON.stringify(err)}`);
    }
  }

  public async copyFile(src: string, dest: string): Promise<number> {
    try {
      MLog.print(TAG, `copy src:${src} dest:${dest}`);
      let fileAsset: userFileManager.FileAsset = await this.getFileAsset(src);
      let srcName: string = fileAsset.displayName;
      let fd: number = await fileAsset.open('rw');
      let buf: ArrayBuffer | undefined = await FileIoManager.readFileFd(fd);
      await fileAsset.close(fd);
      if (!buf) {
        MLog.error(TAG, 'Failed to read file data');
        return -1;
      }

      let writeAsset: userFileManager.FileAsset = await this.createFile(dest, srcName);
      fd = await writeAsset.open('rw');
      let writeFd: number = await FileIoManager.writeFileFd(fd, buf);
      await writeAsset.close(fd);
      MLog.print(TAG, `copy success >>${writeFd}`);
      return writeFd;
    } catch (err) {
      MLog.error(TAG, 'Failed to copyFile : ' + err);
      return -1;
    }
  }

  private async parseFetchResult(result: userFileManager.FetchResult<userFileManager.FileAsset>):
    Promise<userFileManager.FileAsset[]> {
    if (!result) {
      MLog.print(TAG, `parseFetchResult Assets Error >>>`);
      return [];
    }
    const count: number = result.getCount();
    if (count <= 0) {
      MLog.info(TAG, 'The count of fetchFileResult is zero');
      return [];
    }

    MLog.info(TAG, 'parseFetchResult Assets success, count: ' + count);
    let fileAsset: userFileManager.FileAsset = await result.getFirstObject();
    if (!fileAsset) {
      MLog.error(TAG, 'parseFetchResult Assets Failed to get first object: ');
      return [];
    }
    MLog.info(TAG, 'fileAsset ' + ': ' + JSON.stringify(fileAsset.displayName) + ', type = ' + fileAsset.fileType);
    let fileList: userFileManager.FileAsset[] = [];
    fileList.push(fileAsset);
    for (let i: number = 1; i < count; i++) {
      let nextAsset: userFileManager.FileAsset = await result.getNextObject();
      if (!nextAsset) {
        MLog.error(TAG, 'parseFetchResult Assets Failed to get next object: ');
        return fileList;
      }
      MLog.info(TAG, 'parseFetchResult Assets fileAsset.displayName ' + i + ': ' + nextAsset.displayName +
        ',type:' + nextAsset.fileType);
      fileList.push(nextAsset);
    }
    return fileList;
  }

  public async getVideoOrImage(): Promise<userFileManager.FileAsset[]> {
    if (!this.mgr) {
      MLog.error(TAG, 'UserFileManager not initialized');
      return [];
    }
    MLog.print(TAG, `get Video Assets >>>`);
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    let fetchOptions: userFileManager.FetchOptions = {
      fetchColumns: ['uri', 'display_name', 'date_added', 'size'],
      predicates: predicates
    };
    let result: userFileManager.FetchResult<userFileManager.FileAsset> = await this.mgr.getPhotoAssets(fetchOptions);
    return await this.parseFetchResult(result);
  }

  public async getAudio(): Promise<userFileManager.FileAsset[]> {
    if (!this.mgr) {
      MLog.error(TAG, 'UserFileManager not initialized');
      return [];
    }
    MLog.print(TAG, `get Audio Assets >>>`);
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    let fetchOptions: userFileManager.FetchOptions = {
      fetchColumns: ['uri', 'display_name', 'date_added', 'size'],
      predicates: predicates
    };
    let result: userFileManager.FetchResult<userFileManager.FileAsset> = await this.mgr.getAudioAssets(fetchOptions);
    return await this.parseFetchResult(result);
  }
}
