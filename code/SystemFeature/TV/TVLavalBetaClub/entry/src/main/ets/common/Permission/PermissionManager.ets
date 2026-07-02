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
import LogManager from '../Log/LogManager';
import abilityAccessCtrl, { Context, Permissions } from '@ohos.abilityAccessCtrl';

const TAG = 'PermissionManager';

export default class PermissionManager {
  private static manager: PermissionManager;

  public static shareInstance(): PermissionManager {
    if (!PermissionManager.manager) {
      PermissionManager.manager = new PermissionManager();
    }
    return PermissionManager.manager;
  }

  public requestPermissions(context: Context, permissions: Permissions[]) {
    let atManager = abilityAccessCtrl.createAtManager();
    try {
      atManager.requestPermissionsFromUser(context, permissions, (err, data) => {
        LogManager.hilogIWithTag(TAG, 'data:' + JSON.stringify(data));
        LogManager.hilogIWithTag(TAG, 'data permissions:' + data.permissions);
        LogManager.hilogIWithTag(TAG, 'data authResults:' + data.authResults);
      });
    } catch (err) {
      LogManager.hilogIWithTag(TAG, `catch err->${JSON.stringify(err)}`);
    }
  }
};