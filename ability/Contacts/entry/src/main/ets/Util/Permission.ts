/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

/**
 * 权限类，主要承担如下职责
 * 1. 申请权限
 */
import accessControl from "@ohos.abilityAccessCtrl"
import bundle from '@ohos.bundle'
import Logger from './Logger'

const BUNDLE_NAME = 'com.example.contact'
const PERMISSION_REJECT = -1

class Permission {
    async requestPermissions(context) {
        let permissions: Array<string> = [
            'ohos.permission.DISTRIBUTED_DATASYNC'
        ];
        let needGrantPermission = false
        let accessManger = accessControl.createAtManager()
        Logger.info('app permission get bundle info')
        let bundleInfo = await bundle.getApplicationInfo(BUNDLE_NAME, 0, 100)
        Logger.info('app permission query permission ${bundle.accessTokenId.toString()}')
        for (const permission of permissions) {
            Logger.info('app permission query grant status ${permission}')
            try {
                let grantStatus = await accessManger.verifyAccessToken(bundleInfo.accessTokenId, permission)
                if (grantStatus == PERMISSION_REJECT) {
                    needGrantPermission = true
                    break
                }
            } catch (err) {
                Logger.error('app permission query grant status error ${permission} ${JSON.stringify(err)}')
                needGrantPermission = true
                break
            }
        }
        if (needGrantPermission) {
            Logger.info('app permission needGrantPermission')
            try {
                await context.requestPermissionsFromUser(permissions)
            } catch (err) {
                Logger.error('app permission ${JSON.stringify(err)}')
            }
        }
        else {
            Logger.info('app permission already granted')
        }
    }
}

export default new Permission()
