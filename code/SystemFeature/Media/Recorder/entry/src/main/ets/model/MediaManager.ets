/*
 * Copyright (c) 2022-2024 Huawei Device Co., Ltd.
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

import userFileManager from '@ohos.filemanagement.userFileManager';
import dataSharePredicates from '@ohos.data.dataSharePredicates';
import preferences from '@ohos.data.preferences';
import DateTimeUtil from '../model/DateTimeUtil';
import Logger from './Logger';
import { Record } from './Record';

const TAG: string = '[Recorder.MediaManager]';

class MediaManager {
  private context: Context;
  private mediaTest: userFileManager.UserFileManager | undefined = undefined;
  private storage: preferences.Preferences | undefined = undefined;

  constructor(context: Context) {
    this.context = context;
    this.mediaTest = userFileManager.getUserFileMgr(context);
    this.initStorage();
  }

  async initStorage(): Promise<void> {
    let name = 'ohos.samples.recorder';
    try {
      this.storage = await preferences.getPreferences(this.context, `${name}`);
      Logger.info(TAG, `getStorage success`);
    } catch (err) {
      Logger.error(TAG, `getStorage failed, code is ${err.code}, message is ${err.message}`);
    }
    if (this.storage === null) {
      Logger.info(TAG, 'Create storage is fail.');
    }
  }

  /**
   * 创建音频文件
   * @returns FileAsset
   */
  async createAudioFile(): Promise<userFileManager.FileAsset> {
    let suffix = '.m4a';
    let dateTimeUtil = new DateTimeUtil();
    let name = `${dateTimeUtil.getDate()}_${dateTimeUtil.getTime()}`;
    let displayName = `${name}${suffix}`;
    Logger.info(TAG, `createAudioFile displayName=${displayName}`);
    let file: userFileManager.FileAsset = await this.mediaTest!.createAudioAsset(displayName);
    Logger.info(TAG, `createAudioFile publicUri=${file?.uri}`);
    return file;
  }

  /**
   * 获取所有音频文件
   * @returns
   */
  async queryAllAudios(): Promise<Array<Record>> {
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();

    predicates.greaterThan('duration', 0)
    let fetchOptions: userFileManager.FetchOptions = {
      fetchColumns: ['duration', 'date_added'],
      predicates: predicates
    };
    let fetchResult: userFileManager.FetchResult<userFileManager.FileAsset> =
      await this.mediaTest!.getAudioAssets(fetchOptions);
    Logger.info(TAG,`queryAllAudios count ${fetchResult.getCount()}`);
    let fetchArr = await fetchResult.getAllObject();
    let result: Record[] = [];
    for (let i = 0; i < fetchArr.length; i++) {
      let record: Record = new Record(this.context);
      await record.init(fetchArr[i], false);
      result.push(record);
    }
    Logger.info(TAG, `queryAllAudios fetchFileResult=${result.length}`);
    return result;
  }

  /**
   * 查询指定uri音频
   * @param uri 音频uri
   * @returns Record
   */
  async queryFile(uri: string): Promise<Record> {
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    predicates.equalTo('uri', uri);
    let fetchOptions: userFileManager.FetchOptions = {
      fetchColumns: ['uri', 'duration', 'date_added'],
      predicates: predicates
    };
    let fetchResult: userFileManager.FetchResult<userFileManager.FileAsset> =
      await this.mediaTest!.getAudioAssets(fetchOptions);
    Logger.info(TAG, `fetchFileResult.getCount() = ${fetchResult.getCount()}`);
    let fileAsset: userFileManager.FileAsset = await fetchResult.getFirstObject();
    if(fileAsset !== undefined) {
      Logger.info(TAG, `queryFile success`);
    }
    let record: Record = new Record(this.context);
    await record.init(fileAsset, false);
    return Promise.resolve(record);
  }

  /**
   * 删除指定音频
   * @param fileAsset 音频资源
   * @returns void
   */
  async deleteFile(fileAsset: userFileManager.FileAsset): Promise<void> {
    Logger.info(TAG, `mst deleteFile,title = ${fileAsset.displayName},uri = ${fileAsset.uri}`);
    try {
      await this.mediaTest!.delete(fileAsset.uri);
      Logger.info(TAG, `trash successfully`);
    } catch (error) {
      Logger.error(TAG, 'trash failed with error: ' + error);
    }
  }

  onAudioChange(callback: () => void) {
    this.mediaTest!.on('audioChange', () => {
      callback();
    })
  }

  /**
   * 保存音频Duration
   * @param name
   * @param value
   * @returns
   */
  async saveFileDuration(name: string, value: string): Promise<void> {
    if (this.storage === null) {
      Logger.info(TAG, 'Create storage is fail.');
      return;
    }
    try {
      await this.storage?.put(name, value);
      await this.storage?.flush();
      Logger.info(TAG, 'Create storage is success.');
    } catch (err) {
      Logger.error(TAG, `Create storage is failed, err = ${JSON.stringify(err)}.`);
    }
  }

  async getFileDuration(name: string): Promise<string> {
    let bundleName = 'ohos.samples.recorder';
    let duration: string = '';
    try {
      let storage = await preferences.getPreferences(this.context, `${bundleName}`);
      duration = (await storage.get(name, '00:00')) as string;
    } catch (err) {
      Logger.info(TAG, `Failed to get value of duration,code:${err.code},message:${err.message}`);
    }
    return duration as string;
  }
}

export default MediaManager;