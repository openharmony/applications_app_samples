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

import { promptAction } from '@kit.ArkUI';
// [Start check_permission_func]
import { abilityAccessCtrl, bundleManager, Permissions } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

async function checkPermissionGrant(permission: Permissions): Promise<abilityAccessCtrl.GrantStatus> {
  let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
  let grantStatus: abilityAccessCtrl.GrantStatus = abilityAccessCtrl.GrantStatus.PERMISSION_DENIED;
  // 获取应用程序的accessTokenID
  let tokenId: number = 0;
  try {
    let bundleInfo: bundleManager.BundleInfo =
      await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
    let appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo;
    tokenId = appInfo.accessTokenId;
  } catch (error) {
    const err: BusinessError = error as BusinessError;
    console.error(`Failed to get bundle info for self. Code is ${err.code}, message is ${err.message}`);
  }
  // 校验应用是否被授予权限
  try {
    grantStatus = await atManager.checkAccessToken(tokenId, permission);
  } catch (error) {
    const err: BusinessError = error as BusinessError;
    console.error(`Failed to check access token. Code is ${err.code}, message is ${err.message}`);
  }
  return grantStatus;
}

async function checkPermissions(): Promise<void> {
  let grantStatus1: boolean = await checkPermissionGrant('ohos.permission.LOCATION') ===
  abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED; // 获取精确定位权限状态
  let grantStatus2: boolean = await checkPermissionGrant('ohos.permission.APPROXIMATELY_LOCATION') ===
  abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED; // 获取模糊定位权限状态
  // 精确定位权限只能跟模糊定位权限一起申请，或者已经有模糊定位权限才能申请精确定位权限
  if (grantStatus2 && !grantStatus1) {
    // 申请精确定位权限
    // [StartExclude check_permission_func]
    promptAction.showToast({ message: $r('app.string.location_not_apply') });
    // [EndExclude check_permission_func]
  } else if (!grantStatus1 && !grantStatus2) {
    // 申请模糊定位权限与精确定位权限或单独申请模糊定位权限
    // [StartExclude check_permission_func]
    promptAction.showToast({ message: $r('app.string.permission_not_apply') });
    // [EndExclude check_permission_func]
  } else {
    // 已经授权，可以继续访问目标操作
    // [StartExclude check_permission_func]
    promptAction.showToast({ message: $r('app.string.permission_apply') });
    // [EndExclude check_permission_func]
  }
}
// [End check_permission_func]
export {
  checkPermissionGrant, checkPermissions
}