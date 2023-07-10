/*
 * Copyright (c) 2022 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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
import Want from '@ohos.application.Want';
import { Log } from '../utils/Log';
import { startAbility } from '../utils/AbilityUtils';
import { MenuOperation } from './MenuOperation';
import { MenuContext } from './MenuContext';
import { ItemDataSource } from '../common/ItemDataSource';

const TAG = "ShareMenuOperation"

export class ShareMenuOperation implements MenuOperation {
    private menuContext: MenuContext;
    private uris: string[];

    constructor(menuContext: MenuContext) {
        this.menuContext = menuContext;
    }

    doAction(): void {
        if (this.menuContext == null) {
            Log.warn(TAG, 'menuContext is null, return');
            return;
        }
        let dataSource: ItemDataSource = this.menuContext.dataSource;
        if (dataSource == null) {
            return;
        }
        this.uris = dataSource.getSelectedUris();
        this.shareFileAsset();
    }

    shareFileAsset(): void {
        Log.info(TAG, 'shareFileAsset');
        let param1: Map<string, string[]> = new Map<string, string[]>();
        param1.set('ability.params.stream', this.uris);
        let param2: Map<string, Object> = new Map<string, Object>();
        param2.set('action', 'ability.intent.SEND_DATA');
        param2.set('type', '*/*');
        param2.set('parameters', Object.fromEntries<Object>(param1));
        let param3: Map<string, Object> = new Map<string, Object>();
        param3.set('ability.want.params.INTENT', Object.fromEntries<Object>(param2));
        let want: Want = {
            action: 'com.huawei.intent.action.hwCHOOSER',
            parameters: Object.fromEntries<Object>(param3)
        };
        startAbility(want);
    }
}
