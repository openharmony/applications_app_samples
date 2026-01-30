/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 ("the License");
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

import { abilityAccessCtrl, Context, Permissions } from '@kit.AbilityKit';
import { Logger } from 'commons';

const TAG = 'PermissionManager';

// [Start request_permissions]
class PermissionManager {
  private static atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();

  static async request(permissions: Permissions[], context: Context) {
    const data = await PermissionManager.atManager.requestPermissionsFromUser(context, permissions);
    const grantStatus: number[] = data.authResults;
    const deniedPermissions = permissions.filter((_, i) => grantStatus[i] !== 0);
    for (const permission of deniedPermissions) {
      const secondGrantStatus = await PermissionManager.atManager.requestPermissionOnSetting(context, [permission]);
      if (secondGrantStatus[0] !== 0) {
        Logger.error(TAG, 'permission denied');
        throw new Error('permission denied');
      }
    }
  }
}
// [End request_permissions]

export default PermissionManager;