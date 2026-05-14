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

import { preferences } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { util } from '@kit.ArkTS';
import { Context } from '@kit.AbilityKit';

class PreferencesUtils{

 public static  dataPreferences : preferences.Preferences | null = null;

  public init(context:Context){
    let options: preferences.Options = { name: 'myStore' };
    PreferencesUtils.dataPreferences = preferences.getPreferencesSync(context, options);
  }

  public writeData(key:string , value : string | number | boolean | object ){
   if (PreferencesUtils.dataPreferences) {
    if (PreferencesUtils.dataPreferences.hasSync(key)) {
      console.info('11111','The key ',key,' is contained.');
      PreferencesUtils.dataPreferences.put(key, value);
    } else {
      console.info('11111','The key ',key,'does not contain.');
      // 此处以此键值对不存在时写入数据为例
      PreferencesUtils.dataPreferences.putSync(key, value);
    }
   }
   this.flushData();
  }

  public changeData(key:string , value : string | number | boolean | object ){
    if (PreferencesUtils.dataPreferences) {
      if (PreferencesUtils.dataPreferences.hasSync(key)) {
        console.info( '111112','The key ',key,' is contained.');
        PreferencesUtils.dataPreferences.put(key, value);
      }
    }
    this.flushData();
  }

  public readData(key:string){
    return PreferencesUtils.dataPreferences?.getSync(key, 'default');
  }

  public deleteData(key : string){
    PreferencesUtils.dataPreferences?.deleteSync(key);
    this.flushData();
  }

  public flushData(){
    PreferencesUtils.dataPreferences?.flush((err: BusinessError) => {
      if (err) {
        console.error(`Failed to flush. Code:${err.code}, message:${err.message}`);
        return;
      }
      console.info('Succeeded in flushing.');
    })
  }

  public subscribeData(key:string){
    let observer = (key: string) => {
      console.info('The key' + key + 'changed.');
    }
    PreferencesUtils.dataPreferences?.on('change', observer);
  }

}

export default new PreferencesUtils()