/*
* Copyright (C) 2023 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import abilityAccessCtrl, { Permissions } from '@ohos.abilityAccessCtrl';
import Log from './Log';

const permissions: Array<Permissions> = ['ohos.permission.READ_AUDIO'];

export default class PermissionUtils {
  public static init(context: Context, callback: Function) {
    Log.info('start init permission');
    let atManager = abilityAccessCtrl.createAtManager();
    // requestPermissionsFromUser会判断权限的授权状态来决定是否唤起弹窗

    atManager.requestPermissionsFromUser(context, permissions).then((data) => {
      let grantStatus: Array<number> = data.authResults;
      let length: number = grantStatus.length;
      for (let i = 0; i < length; i ++) {
        if(grantStatus[i] !== 0) {
          Log.info(`User reject permission: ${grantStatus[i]}`);
          callback(false);
          return;
        }
      }
      Log.info(`get permission succeed`);
      callback(true);
    }).catch((err: Error) => {
      Log.info(`Failed to request permissions from user. err : ${JSON.stringify(err)}`);
    })
  }
}