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
import { PreferencesHelper } from '@ohos/common';

@Observed
export class HistoryRecordManager {
  public static readonly MAX_COUNT = 10;
  public static readonly HISTORY_RECORD_KEY = 'history_record';
  public historyRecord: string[] = [];

  /**
   * 添加历史记录
   */
  async addHistoryRecord(value: string): Promise<boolean> {
    if (!value || value.trim() === '') {
      return false;
    }
    let records: string = (await PreferencesHelper.get(HistoryRecordManager.HISTORY_RECORD_KEY,
      JSON.stringify(this.historyRecord))) as string;
    let recordList: string[] = JSON.parse(records);
    recordList = recordList.filter(item => item != value);
    recordList.push(value);
    if (recordList.length > HistoryRecordManager.MAX_COUNT) {
      recordList.splice(0, recordList.length - HistoryRecordManager.MAX_COUNT);
    }
    this.historyRecord = recordList;
    return await PreferencesHelper.put(HistoryRecordManager.HISTORY_RECORD_KEY, JSON.stringify(this.historyRecord));
  }

  /**
   * 删除所有历史记录
   */
  async deleteHistoryRecord() {
    await PreferencesHelper.put(HistoryRecordManager.HISTORY_RECORD_KEY, '[]');
    this.historyRecord = [];
  }

  /**
   * 查询全部历史记录
   */
  async queryHistoryRecord(): Promise<Array<string>> {
    let records: string = (await PreferencesHelper.get(HistoryRecordManager.HISTORY_RECORD_KEY,
      JSON.stringify(this.historyRecord))) as string;
    this.historyRecord = JSON.parse(records);
    return this.historyRecord;
  }
}