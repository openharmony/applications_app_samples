/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import { abilityAccessCtrl, bundleManager, PermissionRequestResult, Permissions } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { Logger } from './Logger';

export class PermissionsClass {
  public name: Resource;
  public permissions: Permissions;

  constructor(name: Resource, permissions: Permissions) {
    this.name = name;
    this.permissions = permissions;
  }
}

/**
 * 检查权限组
 * @param permissions
 * @returns
 */
export async function checkPermission(permissions: Permissions[]): Promise<boolean[]> {
  let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
  // 获取应用程序的accessTokenID
  let tokenId: number = 0;
  try {
    let bundleInfo: bundleManager.BundleInfo =
      await bundleManager.getBundleInfoForSelf(
        bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION
      );
    let appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo;
    tokenId = appInfo.accessTokenId;
  } catch (error) {
    const err: BusinessError = error as BusinessError;
    Logger.error(`Failed to get bundle info for self. Code is ${err.code}, message is ${err.message}`);
  }
  const result: boolean[] = new Array(permissions.length);
  // 校验应用是否被授予权限
  try {
    for (let i = 0; i < permissions.length; i++) {
      const grantStatus = await atManager.checkAccessToken(tokenId, permissions[i]);
      result[i] = grantStatus == abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED;
    }
    return result;
  } catch (error) {
    const err: BusinessError = error as BusinessError;
    Logger.error(`Failed to check access token. Code is ${err.code}, message is ${err.message}`);
    for (let i = 0; i < result.length; i++) {
      result[i] = false;
    }
    return result;
  }
}


/**
 * 授权权限组
 * @param context
 * @returns
 */
export async function requestPermission(context: Context, permissions: Permissions[]): Promise<boolean[]> {
  let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
  const result: PermissionRequestResult = await atManager.requestPermissionsFromUser(context, permissions);
  let grantStatus: number[] = result.authResults;
  let length: number = grantStatus.length;
  const resultArr: boolean[] = new Array(permissions.length);
  for (let i = 0; i < length; i++) {
    resultArr[i] = grantStatus[i] === 0;
  }
  return resultArr;
}


/**
 * 判断结果是否都是true
 * @param arr
 * @returns
 */
export function isAllGrant(arr: boolean[]): boolean {
  if (!arr || arr.length == 0) {
    return false;
  }
  for (let i = 0; i < arr.length; i++) {
    if (!arr[i]) {
      return false;
    }
  }
  return true;
}

export function getPermissions(arr: PermissionsClass[]): Permissions[] {
  if (!arr || arr.length == 0) {
    return [];
  }
  return arr.map((permissionsClass) => permissionsClass.permissions);
}