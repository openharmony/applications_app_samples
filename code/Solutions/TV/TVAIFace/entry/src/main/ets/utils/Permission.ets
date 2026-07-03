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
import { initInfo } from './Log';
import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import { common, Permissions } from '@kit.AbilityKit';
import bundleManager from '@ohos.bundle.bundleManager';

interface PermissionsType {
  name: Permissions;
}

interface userGrantPermissionParam {
  permissions: PermissionsType[],
  bundleName?: string,
  bundleFlag?: number,
  userID?: number,
}

let log = initInfo('UserGrantPermission');

export async function userGrantPermission(context: common.UIAbilityContext, opts: userGrantPermissionParam,
  call?: Function) {
  let permissions = opts.permissions;
  let bundleName = opts.bundleName;
  let bundleFlag = opts.bundleFlag; // 数字枚举
  let userID = opts.userID; // 系统设置默认100
  if (!bundleName) {
    bundleName = context.abilityInfo.bundleName;
  }
  let tokenID: number = 0;
  // 获取应用信息
  let appInfo = await bundleManager.getApplicationInfo(bundleName, bundleFlag, userID);
  tokenID = appInfo.accessTokenId;
  let atManager = abilityAccessCtrl.createAtManager();

  let noPermissions: Permissions[] = [];
  await Promise.all(permissions.map(async (permission) => {
    // 检验权限是否已授权
    let result = await atManager.verifyAccessToken(tokenID, permission.name);
    if (result == abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
    } else {
      noPermissions.push(permission.name);
    }
  }));
  // 申请动态授权，使用接口：requestPermissionsFromUser
  let res = await atManager.requestPermissionsFromUser(context, noPermissions);
  if (res && res.authResults) {
    res.authResults.forEach((r, i) => {
      if (r == 0) {
      } else if (r == -1) {
        log(`${noPermissions[i]} faild!`);
      }
    });
  } else {
    log(`faild!`);
  }
  if (call) {
    call();
  }
}
