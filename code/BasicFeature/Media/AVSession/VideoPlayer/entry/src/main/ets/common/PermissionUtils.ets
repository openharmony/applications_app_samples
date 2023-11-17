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

const TAG = 'AVPlayer';
const permissions: Array<Permissions> = ['ohos.permission.READ_AUDIO'];

export default class PermissionUtils {
  public static init(context: Context, callback: Function) {
    console.log(TAG, 'start init permission');
    let atManager = abilityAccessCtrl.createAtManager();
    //requestPermissionsFromUser会判断权限的授权状态来决定是否唤起弹窗

    atManager.requestPermissionsFromUser(context, permissions).then((data) => {
      let grantStatus: Array<number> = data.authResults;
      let length: number = grantStatus.length;
      for (let i = 0; i < length; i ++) {
        if(grantStatus[i] !== 0) {
          console.info(TAG, `User reject permission: ${grantStatus[i]}`);
          callback(false);
          return;
        }
      }
      console.info(TAG, `get permission succeed`);
      callback(true);
    }).catch((err: Error) => {
      console.error(TAG, `Failed to request permissions from user. err : ${JSON.stringify(err)}`);
    })
  }
}