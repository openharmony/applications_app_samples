/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { initInfo } from './Log';
import { abilityAccessCtrl, bundleManager } from '@kit.AbilityKit'

interface PermissionItem {
  name: string;
}

interface UserGrantPermissionParam {
  permissions: PermissionItem[],
  bundleName?: string,
  bundleFlag?: number,
  userID?: number,
}

interface PermissionResult {
  authResults?: number[];
}

interface AbilityInfoLike {
  bundleName: string;
}

interface PermissionContextLike {
  abilityInfo: AbilityInfoLike;
  requestPermissionsFromUser: (permissions: string[]) => Promise<PermissionResult>;
}

let log = initInfo('UserGrantPermission');

export async function userGrantPermission(
  context: PermissionContextLike,
  opts: UserGrantPermissionParam,
  call?: () => void
): Promise<void> {
  let permissions: PermissionItem[] = opts.permissions ?? [];
  let bundleName: string = opts.bundleName ?? '';
  let bundleFlag: number = opts.bundleFlag ?? 0; // 数字枚举
  let userID: number = opts.userID ?? 100; // 系统设置默认100
  if (!bundleName) {
    bundleName = context.abilityInfo.bundleName
  }
  let tokenID: number = 0;
  let bundleFlags = bundleFlag | bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION;
  let bundleInfo = await bundleManager.getBundleInfoForSelf(bundleFlags);
  tokenID = bundleInfo.appInfo.accessTokenId;


  let atManager = abilityAccessCtrl.createAtManager();

  let noPermissions: string[] = []
  await Promise.all(permissions.map(async (permission) => {

    let result = await atManager.verifyAccessToken(tokenID, permission.name);

    if (result == abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {

    } else {
      noPermissions.push(permission.name)
    }
  }));


  let res = await context.requestPermissionsFromUser(noPermissions);


  if (res && res.authResults) {
    res.authResults.forEach((r: number, i: number) => {
      if (r == 0) {
      } else if (r == -1) {
        log(`${noPermissions[i]} faild!`)
      }
    })
  } else {
    log(`faild!`)
  }
  if (call) {
    call();
  }
}
