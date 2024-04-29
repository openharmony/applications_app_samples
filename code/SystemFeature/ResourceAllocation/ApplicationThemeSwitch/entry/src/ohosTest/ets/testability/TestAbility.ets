/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
import Logger from '../utils/Logger';
import UIAbility from '@ohos.app.ability.UIAbility'
import AbilityDelegatorRegistry from '@ohos.application.abilityDelegatorRegistry';
import { Hypium } from '@ohos/hypium';
import testsuite from '../test/List.test';
import Window from '@ohos.window';

export default class TestAbility extends UIAbility {
    onCreate(want, launchParam) {
        Logger.info('testTag', '%{public}s', 'TestAbility onCreate');
        Logger.info('testTag', '%{public}s', 'want param:' + JSON.stringify(want) ?? '');
        Logger.info('testTag', '%{public}s', 'launchParam:'+ JSON.stringify(launchParam) ?? '');
        var abilityDelegator: any;
        abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
        var abilityDelegatorArguments: any;
        abilityDelegatorArguments = AbilityDelegatorRegistry.getArguments();
        Logger.info('testTag', '%{public}s', 'start run testcase!!!');
        Hypium.hypiumTest(abilityDelegator, abilityDelegatorArguments, testsuite);
    }

    onDestroy() {
        Logger.info('testTag', '%{public}s', 'TestAbility onDestroy');
    }

    onWindowStageCreate(windowStage: Window.WindowStage) {
        Logger.info('testTag', '%{public}s', 'TestAbility onWindowStageCreate');
        windowStage.loadContent('testability/pages/Index', (err, data) => {
            if (err.code) {
                Logger.error('testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
                return;
            }
            Logger.info('testTag', 'Succeeded in loading the content. Data: %{public}s',
                JSON.stringify(data) ?? '');
        });
    }

    onWindowStageDestroy() {
        Logger.info('testTag', '%{public}s', 'TestAbility onWindowStageDestroy');
    }

    onForeground() {
        Logger.info('testTag', '%{public}s', 'TestAbility onForeground');
    }

    onBackground() {
        Logger.info('testTag', '%{public}s', 'TestAbility onBackground');
    }
}