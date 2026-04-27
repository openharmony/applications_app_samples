/**
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
import { abilityAccessCtrl, bundleManager, PermissionRequestResult, Permissions } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import LogUtil from './LogUtil';
import { JSON } from '@kit.ArkTS';

const TAG = '[PPL_permission]'
export class PermissionUtils {
  static async requestPermission(permission: Permissions[]): Promise<boolean> {
    return new Promise((resolve, reject) => {
      PermissionUtils.checkPermissions(permission).then((result)=>{
        LogUtil.info(TAG,`check permission result=`+result)
        if (result) {
          resolve(true)
        }else{
          let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();

          LogUtil.info(TAG,`request permission `)
          atManager.requestPermissionsFromUser(getContext(), permission).then((result) => {
            LogUtil.info(TAG,`request permission result= ${JSON.stringify(result)}`)
            let denied = result.authResults.includes(abilityAccessCtrl.GrantStatus.PERMISSION_DENIED)
            resolve(!denied)
          }).catch((err: BusinessError) => {
            LogUtil.info(TAG,`request permission fail= ${JSON.stringify(err)}`)
            reject(err)
          })
        }
      })
    })
  }

  private static async checkPermissions(permissions: Permissions[]):Promise<boolean>{
    return new Promise(async (resolve, reject) => {
      for (let index = 0; index < permissions.length; index++) {
        const granted = await PermissionUtils.checkPermissionGrant(permissions[index])
        if (granted === abilityAccessCtrl.GrantStatus.PERMISSION_DENIED) {
          resolve(false)
          return
        }
      }
      resolve(true)
    })
  }

  private static async checkPermissionGrant(permission: Permissions): Promise<abilityAccessCtrl.GrantStatus> {
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
      LogUtil.error(TAG,`Failed to get bundle info for self. Code is ${err.code}, message is ${err.message}`);
    }

    // 校验应用是否被授予权限
    try {
      grantStatus = await atManager.checkAccessToken(tokenId, permission);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      LogUtil.error(TAG,`Failed to check access token. Code is ${err.code}, message is ${err.message}`);
    }

    return grantStatus;
  }
}