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

import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import Logger from '../model/Logger';
import { window } from '@kit.ArkUI';

const TAG = '[MainAbility]';

export default class MainAbility extends UIAbility {
    onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
        Logger.info(TAG, `MainAbility onCreate`);
        Logger.info(`${TAG} onCreate, want parameters info: ${JSON.stringify(want)}`);
        if (want.uri) {
            let url: string = want.uri as string;
            AppStorage.setOrCreate('url', url);
        }
    }

    onNewWant(want: Want) {
        if (want.uri) {
            let url: string = want.uri as string;
            AppStorage.setOrCreate('url', url);
        }
    }

    onDestroy() {
        Logger.info(TAG, `MainAbility onDestroy`);
    }

    onWindowStageCreate(windowStage: window.WindowStage) {
        // Main window is created, set main page for this ability
        Logger.info(TAG, `MainAbility onWindowStageCreate`);

        windowStage.loadContent('pages/Index', () => {
            Logger.info(TAG, `MainAbility loadContent`);
        });
    }

    onWindowStageDestroy() {
        // Main window is destroyed, release UI related resources
        Logger.info(TAG, `MainAbility onWindowStageDestroy`);
    }

    onForeground() {
        // Ability has brought to foreground
        Logger.info(TAG, `MainAbility onForeground`);
    }

    onBackground() {
        // Ability has back to background
        Logger.info(TAG, `MainAbility onBackground`);
    }
};
