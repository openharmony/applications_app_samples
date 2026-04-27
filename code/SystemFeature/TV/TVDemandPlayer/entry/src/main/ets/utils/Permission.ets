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
/* eslint-disable */
import { initInfo } from '../utils/log';
import { abilityAccessCtrl } from '@kit.AbilityKit'
import { bundleManager as bundle } from '@kit.AbilityKit'
interface userGrantPermissionParam{
    permissions: any[],
    bundleName?: string,
    bundleFlag?: number,
    userID?: number,
}
let log = initInfo('UserGrantPermission');
export default async function userGrantPermission(context:any, opts:userGrantPermissionParam, call?:Function){
    log(`User_Grant start`)
    let {
        permissions = [],
        bundleName = '',
        bundleFlag = 0, // 数字枚举
        userID = 100, // 系统设置默认100
    } = opts;
    if(!bundleName){
        bundleName = context.abilityInfo.bundleName
    }
    var tokenID: any = undefined;
    // 获取应用信息
    var appInfo = await bundle.getApplicationInfo(bundleName, bundleFlag, userID);

    tokenID = appInfo.accessTokenId;
    var atManager = abilityAccessCtrl.createAtManager();

    let noPermissions: string[] = []
    await Promise.all(permissions.map(async (permission) => {
        // 检验权限是否已授权
        let result = await atManager.verifyAccessToken(tokenID, permission.name);
        if (result == abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
            log(`User_Grant ${permission.name} is authorized`)
        } else {
            noPermissions.push(permission.name)
        }
    }));
    // 申请动态授权，使用接口：requestPermissionsFromUser
    let res = await context.requestPermissionsFromUser(noPermissions);
    if(res && res.authResults){
        res.authResults.forEach((r,i)=>{
            if(r == 0){
                log(`User_Grant ${noPermissions[i]} success!`)
            } else if (r == -1) {
                log(`User_Grant ${noPermissions[i]} faild!`)
            }
        })
    } else {
        console.log(`chen:User_Grant faild!`)
    }
    log(`User_Grant end`)
    if(call){
        call();
    }
}
