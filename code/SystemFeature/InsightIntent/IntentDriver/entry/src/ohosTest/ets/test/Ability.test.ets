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

import { describe, beforeAll, it, expect } from '@ohos/hypium'
import { Driver, ON, UIElementInfo } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { logger } from '../util/Logger';

const BUNDLE: string = 'IntentDriver';
const SLEEP_MS: number = 2000;
const BUNDLE_NAME: string = 'com.samples.intentdriver';
const INTENT_NAME: string = 'PlayMusic';
const UIABILITY_FOREGROUND_CALLBACK: string = 'onExecuteInUIAbilityForegroundMode';
const SERVICE_EXTENSION_CALLBACK: string = 'onExecuteInServiceExtensionAbility';
const SUCCESS_FLAG: string = 'succeed';
let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();

function sleep(time: number) {
  return new Promise<void>((resolve: Function) => setTimeout(resolve, time));
}

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    beforeAll(async (done: Function) => {
      logger.info(`${BUNDLE} beforeAll begin`);
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.intentexecutor',
          abilityName: 'EntryAbility'
        });
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.intentdriver',
          abilityName: 'EntryAbility'
        });
      } catch (err) {
        logger.info(`${BUNDLE} beforeAll error: ${JSON.stringify(err)}`);
      }
      logger.info(`${BUNDLE}  beforeAll end`);
      done();
    })

    /**
     * @tc.number: IntentDriver_ExecuteInServiceExtension_001
     * @tc.name: IntentDriver_ExecuteInServiceExtension_001
     * @tc.desc: Execute insight intent in ServiceExtension
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('IntentDriver_ExecuteInServiceExtension_001', 0, async (done: Function) => {
      logger.info(`${BUNDLE}_ExecuteInServiceExtension_001 begin`);
      await sleep(SLEEP_MS);
      let driver: Driver = Driver.create();
      let toastCallback = (uieInfo: UIElementInfo) => {
        logger.info(`${BUNDLE}_ExecuteInServiceExtension_001 UIElementInfo: ${JSON.stringify(uieInfo)}`);
        expect(uieInfo.bundleName).assertEqual(BUNDLE_NAME);
        expect(uieInfo.text).assertContain(SERVICE_EXTENSION_CALLBACK);
        expect(uieInfo.text).assertContain(INTENT_NAME);
        expect(uieInfo.text).assertContain(SUCCESS_FLAG);
        logger.info(`${BUNDLE}_ExecuteInServiceExtension_001 end`);
        done();
      };

      let observer = await driver.createUIEventObserver();
      observer.once('toastShow', toastCallback);
      await sleep(SLEEP_MS);
      let btn = await driver.findComponent(ON.id('button_IntentInServiceExtension'));
      await btn.click();
      await sleep(SLEEP_MS);
    })

    /**
     * @tc.number: IntentDriver_ExecuteInUIAbility_001
     * @tc.name: IntentDriver_ExecuteInUIAbility_001
     * @tc.desc: Execute insight intent in UIAbility foreground mode
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('IntentDriver_ExecuteInUIAbility_001', 0, async (done: Function) => {
      logger.info(`${BUNDLE}_ExecuteInUIAbility_001 begin`);
      await sleep(SLEEP_MS);
      let driver: Driver = Driver.create();
      let toastCallback = (uieInfo: UIElementInfo) => {
        logger.info(`${BUNDLE}_ExecuteInUIAbility_001 UIElementInfo: ${JSON.stringify(uieInfo)}`);
        expect(uieInfo.bundleName).assertEqual(BUNDLE_NAME);
        expect(uieInfo.text).assertContain(UIABILITY_FOREGROUND_CALLBACK);
        expect(uieInfo.text).assertContain(INTENT_NAME);
        expect(uieInfo.text).assertContain(SUCCESS_FLAG);
        logger.info(`${BUNDLE}_ExecuteInUIAbility_001 end`);
        done();
      };

      let observer = await driver.createUIEventObserver();
      observer.once('toastShow', toastCallback);
      await sleep(SLEEP_MS);
      let btn = await driver.findComponent(ON.id('button_IntentInUIAbilityForeground'));
      await btn.click();
      await sleep(SLEEP_MS);
    })
  })
}
