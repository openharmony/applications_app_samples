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
 

import { bundleManager as BundleMgr } from '@kit.AbilityKit';
import Log from '../Log';
import SwitchUserManager from '../SwitchUserManager';
import AbilityManager from './abilityManager';

const TAG = 'BRManager';

interface Resource {
    bundleName: string;
    moduleName: string;
    id: number;
}

export default class BundleManager {
    public static readonly RESOURCE_MANAGER = 'SystemUi_Resource_Manager';

    static getResourceManager() {
        if(!globalThis[BundleManager.RESOURCE_MANAGER]){
            Log.showInfo(TAG, 'init resourceManager');
            globalThis[BundleManager.RESOURCE_MANAGER] = AbilityManager.getContext().resourceManager;
        }
        return globalThis[BundleManager.RESOURCE_MANAGER];
    }

    static getString(resource: Resource, callback?: Function){
        Log.showDebug(TAG, `getString, resource: ${JSON.stringify(resource)}`);
        if(callback){
            BundleManager.getResourceManager().getString(resource).then((value) => {
                Log.showDebug(TAG, `getString, callback excute`);
                callback(value) ;
            })
            return;
        } else {
            return BundleManager.getResourceManager().getString(resource);
        }
    }

    static getMediaBase64(resource: Resource, callback?: Function){
        Log.showDebug(TAG, `getMediaBase64, resource: ${JSON.stringify(resource)}`);
        if(callback){
            BundleManager.getResourceManager().getMediaBase64(resource).then((value) => {
                Log.showDebug(TAG, `getMediaBase64, callback excute`);
                callback(value) ;
            })
            return;
        } else {
            return  BundleManager.getResourceManager().getMediaBase64(resource);
        }
    }

    static async getBundleInfo(tag: string, bundleName: string, getInfo?: any, requestId?: number) {
        getInfo = getInfo ?? BundleMgr.BundleFlag.GET_BUNDLE_INFO_DEFAULT;
        let userInfo = {
            userId: requestId ?? (await SwitchUserManager.getInstance().getCurrentUserInfo()).userId,
        };
        Log.showDebug(TAG, `getBundleInfo from: ${tag}, userId: ${userInfo.userId}`);
        return await BundleMgr.getBundleInfo(bundleName, getInfo, userInfo.userId);
    }
}
