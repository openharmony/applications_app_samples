/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { preferences } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { util } from '@kit.ArkTS';
import EntryAbility from '../entryability/EntryAbility';
import Logger from '../common/Logger';

let dataPreferences: preferences.Preferences | undefined = undefined;
const context = EntryAbility.getContext();

export class PreferencesInterface {
  public GetPreferencesSync = (() => {
    Logger.info('GetPreferencesSync start');
    try {
      // [Start GetPreferencesSync]
      let options: preferences.Options = { name: 'myStore' };
      dataPreferences = preferences.getPreferencesSync(context, options);
      // [End GetPreferencesSync]
      Logger.info('Succeeded in get preferences.');
    } catch (err) {
      Logger.error(`Failed to get preferences. Code:${err.code},message:${err.message}`);
    }
    Logger.info('GetPreferencesSync end');
  })


  public GetPreferencesSyncGSKV = (() => {
    Logger.info('GetPreferencesSyncGSKV start');
    try {
      // [Start isStorageTypeSupported]
      let isGskvSupported = preferences.isStorageTypeSupported(preferences.StorageType.GSKV);
      Logger.info('Is gskv supported on this platform: ' + isGskvSupported);
      // [End isStorageTypeSupported]
      if (isGskvSupported) {
        // [Start GetPreferencesSyncGSKV]
        let options: preferences.Options = { name: 'myStore', storageType: preferences.StorageType.GSKV };
        dataPreferences = preferences.getPreferencesSync(context, options);
        // [End GetPreferencesSyncGSKV]
      }
      Logger.info('Succeeded in get preferences GSKV.');
    } catch (err) {
      Logger.error(`Failed to get preferences GSKV. Code:${err.code},message:${err.message}`);
    }
    Logger.info('GetPreferencesSyncGSKV end');
  })
  
  public PutSync = (() => {
    Logger.info('PutSync start');
    if (dataPreferences === undefined) {
      Logger.info('PutSync: dataPreferences not initialized');
      return;
    }
    try {
      // [Start PutSync]
      if (dataPreferences.hasSync('startup')) {
        Logger.info('The key startup is contained.');
      } else {
        Logger.info('The key startup does not contain.');
        // 此处以此键值对不存在时写入数据为例
        dataPreferences.putSync('startup', 'auto');
        // 在XML模式下，当字符串包含非UTF-8格式的字符时，需要将字符串转为Uint8Array类型再存储，长度均不超过16 * 1024 * 1024个字节。
        let uInt8Array1 = new util.TextEncoder().encodeInto('~！@#￥%……&*（）——+？');
        dataPreferences.putSync('uInt8', uInt8Array1);
      }
      // [End PutSync]
      Logger.info('Succeeded in putting data.');
    } catch (e) {
      let error = e as BusinessError;
      Logger.error(`An unexpected error occurred. Code:${error.code},message:${error.message}`);
    }
  })

  public GetSync = (() => {
    Logger.info('GetSync start');
    if (dataPreferences == undefined) {
      Logger.info('GetSync: dataPreferences not initialized');
      return;
    }
    try {
      // [Start GetSync]
      let val = dataPreferences.getSync('startup', 'default');
      Logger.info('The startup value is ' + val);
      let uInt8Array2 : preferences.ValueType = dataPreferences.getSync('uInt8', new Uint8Array(0));
      // 将获取到的Uint8Array转换为字符串
      let textDecoder = util.TextDecoder.create('utf-8');
      val = textDecoder.decodeToString(uInt8Array2 as Uint8Array);
      Logger.info('The uInt8 value is ' + val);
      // [End GetSync]
      Logger.info(`Succeeded in getting val. val:${val}`);
    } catch (e) {
      let error = e as BusinessError;
      Logger.error(`An unexpected error occurred. Code:${error.code},message:${error.message}`);
    }
    Logger.info('GetSync end');
  })

  public DeleteSync = (() => {
    Logger.info('DeleteSync start');
    if (dataPreferences === undefined) {
      Logger.info('DeleteSync: dataPreferences not initialized');
      return;
    }
    try {
      // [Start DeleteSync]
      dataPreferences.deleteSync('startup');
      // [End DeleteSync]
      let val = dataPreferences.getSync('startup', 'default');
      Logger.info('The startup value is ' + val);
      Logger.info('Succeeded in deleting data.');
    } catch (e) {
      let error = e as BusinessError;
      Logger.error(`An unexpected error occurred. Code:${error.code},message:${error.message}`);
    }
    Logger.info('DeleteSync end');
  })

  public Flush = (() => {
    Logger.info('Flush start');
    if (dataPreferences === undefined) {
      Logger.info('Flush: dataPreferences not initialized');
      return;
    }
    try {
      // [Start Flush]
      dataPreferences.flush((err: BusinessError) => {
        if (err) {
          Logger.error(`Failed to flush. Code:${err.code}, message:${err.message}`);
          return;
        }
        Logger.info('Succeeded in flushing.');
      })
      // [End Flush]
    } catch (e) {
      let error = e as BusinessError;
      Logger.error(`An unexpected error occurred. Code:${error.code},message:${error.message}`);
    }
    Logger.info('Flush end');
  })

  public XMLOn = (() => {
    Logger.info('XMLOn start');
    if (dataPreferences === undefined) {
      Logger.info('XMLOn: dataPreferences not initialized');
      return;
    }
    try {
      // [Start XMLOn]
      let observer = (key: string) => {
        Logger.info('The key ' + key + ' changed.');
      }
      dataPreferences.on('change', observer);
      // 数据产生变更，由'auto'变为'manual'
      dataPreferences.put('startup', 'manual', (err: BusinessError) => {
        if (err) {
          Logger.error(`Failed to put the value of 'startup'. Code:${err.code},message:${err.message}`);
          return;
        }
        Logger.info('Succeeded in putting the value of startup.');
        if (dataPreferences !== undefined) {
          dataPreferences.flush((err: BusinessError) => {
            if (err) {
              Logger.error(`Failed to flush. Code:${err.code}, message:${err.message}`);
              return;
            }
            Logger.info('Succeeded in flushing.');
          })
        }
      })
      // [End XMLOn]
    } catch (e) {
      let error = e as BusinessError;
      Logger.error(`An unexpected error occurred. Code:${error.code},message:${error.message}`);
    }
    Logger.info('XMLOn end');
  }) 

  public GSKVOn = (() => {
    Logger.info('GSKVOn start');
    if (dataPreferences === undefined) {
      Logger.info('GSKVOn: dataPreferences not initialized');
      return;
    }
    try {
      // [Start GSKVOn]
      let observer = (key: string) => {
        Logger.info('The key ' + key + ' changed.');
      }
      dataPreferences.on('change', observer);
      // 数据产生变更，由'auto'变为'manual'
      dataPreferences.put('startup', 'manual', (err: BusinessError) => {
        if (err) {
          Logger.error(`Failed to put the value of 'startup'. Code:${err.code},message:${err.message}`);
          return;
        }
        Logger.info('Succeeded in putting the value of startup.');
      })
      // [End GSKVOn]
    } catch (e) {
      let error = e as BusinessError;
      Logger.error(`An unexpected error occurred. Code:${error.code},message:${error.message}`);
    }
    Logger.info('GSKVOn end');
  })

  public DeleteXMLPreferences = (() => {
    Logger.info('DeleteXMLPreferences start');
    if (dataPreferences === undefined) {
      Logger.info('DeleteXMLPreferences: dataPreferences not initialized');
      return;
    }
    try {
      // [Start DeleteXMLPreferences]
      let options: preferences.Options = { name: 'myStore' };
      preferences.deletePreferences(context, options, (err: BusinessError) => {
        if (err) {
          Logger.error(`Failed to delete preferences. Code:${err.code}, message:${err.message}`);
          return;
        }
        Logger.info('Succeeded in deleting preferences.');
      })
      // [End DeleteXMLPreferences]
    } catch (e) {
      let error = e as BusinessError;
      Logger.error(`An unexpected error occurred. Code:${error.code},message:${error.message}`);
    }
    Logger.info('DeleteXMLPreferences end');
  })

  // [Start DeleteGSKVPreferences]
  public DeleteGSKVPreferences = (() => {
    Logger.info('DeleteGSKVPreferences start');
    if (dataPreferences === undefined) {
      Logger.info('DeleteGSKVPreferences: dataPreferences not initialized');
      return;
    }
    try {
      let options: preferences.Options = { name: 'myStore', storageType: preferences.StorageType.GSKV };
      preferences.deletePreferences(context, options, (err: BusinessError) => {
        if (err) {
          Logger.error(`Failed to delete preferences. Code:${err.code}, message:${err.message}`);
          return;
        }
        Logger.info('Succeeded in deleting preferences.');
      })
    } catch (e) {
      let error = e as BusinessError;
      Logger.error(`An unexpected error occurred. Code:${error.code},message:${error.message}`);
    }
    Logger.info('DeleteGSKVPreferences end');
  })
  // [End DeleteGSKVPreferences]
}
