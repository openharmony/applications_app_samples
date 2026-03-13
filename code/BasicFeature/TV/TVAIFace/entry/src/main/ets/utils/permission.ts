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

import { initInfo } from "./log";
import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import { bundleManager, PermissionRequestResult } from '@kit.AbilityKit';


interface userGrantPermissionParam {
  permissions: any[],
  bundleName?: string,
  bundleFlag?: number,
  userID?: number,
}

let log: (tag?: string | number, log?: string | number | undefined) => void = initInfo('UserGrantPermission');

export async function userGrantPermission(context: any, opts: userGrantPermissionParam, call?: Function) {
  let {
    permissions = [],
    bundleName = "",
    bundleFlag = 0, // 数字枚举
    userID = 100, // 系统设置默认100
  }: userGrantPermissionParam = opts;
  if (!bundleName) {
    bundleName = context.abilityInfo.bundleName;
  }
  var tokenID: any = undefined;
  // 获取应用信息
  var appInfo: bundleManager.ApplicationInfo = await bundleManager.getApplicationInfo(bundleName, bundleFlag, userID);

  tokenID = appInfo.accessTokenId;
  var atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();

  let noPermissions: string[] = [];
  await Promise.all(permissions.map(async (permission) => {
    // 检验权限是否已授权
    let result: abilityAccessCtrl.GrantStatus = await atManager.verifyAccessToken(tokenID, permission.name);
    if (result === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
    } else {
      noPermissions.push(permission.name);
    }
  }));
  // 申请动态授权，使用接口：requestPermissionsFromUser
  let res: PermissionRequestResult = await context.requestPermissionsFromUser(noPermissions);
  if (res && res.authResults) {
    res.authResults.forEach((r, i) => {
      if (r === 0) {
      } else if (r === -1) {
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
