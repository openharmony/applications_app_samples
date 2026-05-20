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
import { Permissions, abilityAccessCtrl, bundleManager, common } from '@kit.AbilityKit';
import { MLog } from './MLog';

const TAG = 'Permission';
const PERMISSIONS_ARR: Array<Permissions> = [
  'ohos.permission.READ_MEDIA', 'ohos.permission.WRITE_MEDIA',
  'ohos.permission.FILE_ACCESS_MANAGER', 'ohos.permission.STORAGE_MANAGER',
  'ohos.permission.GET_BUNDLE_INFO_PRIVILEGED', 'ohos.permission.MANAGE_MISSIONS',
  'ohos.permission.MEDIA_LOCATION', 'ohos.permission.READ_AUDIO', 'ohos.permission.READ_IMAGEVIDEO',
  'ohos.permission.WRITE_IMAGEVIDEO','ohos.permission.CLEAN_BACKGROUND_PROCESSES',
  'ohos.permission.INTERNET','ohos.permission.SET_WALLPAPER','ohos.permission.GET_RUNNING_INFO',
];

export class Permission {

  public static async checkAndRequest(permissions: Permissions[] = PERMISSIONS_ARR): Promise<boolean>{
    MLog.print(TAG, `checkAndRequest permissions:${permissions}`);
    if(!Permission.allAllowed(permissions)){
      MLog.print(TAG, `checkAndRequest allAllowed:false`);
      let status = await Permission.requestPermissions(permissions);
      MLog.print(TAG, `checkAndRequest status:${status}`);
      return status && Permission.allAllowed(permissions);
    }else{
      return true;
    }
  }
  private static allAllowed(permissions: Permissions[]): boolean {
    if (permissions.length == 0) {
      return false;
    }

    const mgr: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    const bundleInfo = bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);

    let tokenID: number = bundleInfo.appInfo.accessTokenId;

    return permissions.every(permission => abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED == mgr.checkAccessTokenSync(tokenID, permission));
  }

  private static async requestPermissions(permissions: Permissions[]): Promise<boolean> {
    const mgr: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    const context: Context = getContext() as common.UIAbilityContext;

    const result = await mgr.requestPermissionsFromUser(context, permissions);
    return result.authResults.length > 0 && result.authResults.every(authResults => authResults == 0);
  }
}