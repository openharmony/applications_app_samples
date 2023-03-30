/*
 *
 *  Copyright (c) 2023 Huawei Device Co., Ltd.
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 */

import data_preferences from '@ohos.data.preferences';

import { logger } from './Logger';

let TAG: string = 'DataPreferencesUtil';

export default class DataPreferencesUtil {
  private preferences: data_preferences.Preferences;
  private context: Context;
  private listLimit: number = 15;
  public recentSearchesTag: string = 'recent_searches';

  private async initDataPreferences() {
    try {
      this.preferences = await data_preferences.getPreferences(this.context, 'as_orange_shopping_store');
    } catch (err) {
      if (err) {
        logger.info(TAG, 'Failed to get preferences. code =' + err.code + ', message =' + err.message);
        return;
      }
    }
    logger.info(TAG, 'Succeeded in getting preferences.');
  }

  /**
   * 从持久化数据中获取最近搜索的结果
   */
  public async getSearchList(context: Context): Promise<Array<string>> {
    this.context = context;
    if (this.preferences === undefined) {
      await this.initDataPreferences();
    }
    let result: Array<string>;
    try {
      result = await this.preferences.get(this.recentSearchesTag, []) as Array<string>;
    } catch (err) {
      if (err) {
        logger.info(TAG, 'Failed to get recent_searches. code =' + err.code + ', message =' + err.message);
        return;
      }
    }
    logger.info(TAG, `Get search list: ${result.toString()}`);
    return result;
  }

  /**
   * 将最近搜索结果持久化
   */
  public async pushSearchList(context: Context, searchList: Array<string>): Promise<Array<string>> {
    this.context = context;
    if (this.preferences === undefined) {
      await this.initDataPreferences();
    }

    try {
      await this.preferences.put(this.recentSearchesTag, searchList.slice(0, this.listLimit));
      await this.preferences.flush();
    } catch (err) {
      if (err) {
        logger.error(TAG, 'Push search list fail! ');
        logger.error(TAG, `err.code: ${err.code} message: ${err.message}`)
        return;
      }
    }
    return searchList.slice(0, this.listLimit);
  }
}