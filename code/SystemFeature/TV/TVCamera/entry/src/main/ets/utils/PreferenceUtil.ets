/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     `http://www.apache.org/licenses/LICENSE-2.0`
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { preferences } from '@kit.ArkData';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG: string = 'PreferenceUtil';
const CONFIG_FILE_NAME = 'configPreference';  // 文件名

class PreferenceUtil {

  private _preference?: preferences.Preferences | undefined;

  getPreferenceFile(context: Context, fileName: string) {
    this._preference = preferences.getPreferencesSync(context, { name: fileName });
    return this;
  }

  // 获取首选项实例
  getConfigPreference(context: Context): PreferenceUtil {
    return this.getPreferenceFile(context, CONFIG_FILE_NAME);
  }

  // 保存信息，传入key、value
  saveConfig(key: string, value: preferences.ValueType) {
    this._preference?.putSync(key, value);
    this._preference?.flush((err: BusinessError) => {
      if (err) {
        hilog.error(0x000, TAG, 'save config failed code =' + err.code + ', message =' + err.message);
      } else hilog.info(0x000, TAG, 'save config success');
    });
  }

  // 删除 key
  deleteKey(key: string) {
    this._preference?.deleteSync(key);
    this._preference?.flush((err: BusinessError) => {
      if (err) {
        hilog.error(0x000, TAG, 'delete config failed code =' + err.code + ', message =' + err.message);
      } else hilog.info(0x000, TAG, 'delete config success');
    });
  }

  // 清除首选项内容
  clearPreference() {
    this._preference?.clearSync();
    this._preference?.flush((err: BusinessError) => {
      if (err) {
        hilog.error(0x000, TAG, 'clear config failed code =' + err.code + ', message =' + err.message);
      } else hilog.info(0x000, TAG, 'clear config success');
    });
  }

  // T 泛型，返回该类型数据
   getConfig<T>(name: string, defValue: preferences.ValueType): T {
    return this._preference?.getSync(name, defValue) as T;
  }

}

export default new PreferenceUtil()
