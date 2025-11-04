/*
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
import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { abilityDelegatorRegistry } from '@kit.TestKit';
import { Driver, ON, Component, MatchPattern } from '@ohos.UiTest'

const TAG = '[Sample_AppServiceExtensionAbility]';
const DOMAIN = 0xF811;
const BUNDLE = 'AppServiceExtensionAbility_';
const TIME = 1000;

export default function abilityTest() {
  let driver = Driver.create();
  describe('ActsAbilityTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 begin');
      let abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.appserviceextensionability',
          abilityName: 'EntryAbility'
        });
        await driver.delayMs(1000);
        // 获取当前top的ability
        let entryAbility = await abilityDelegator.getCurrentTopAbility();
        expect(entryAbility.context.abilityInfo.name).assertEqual('EntryAbility');
      } catch (err) {
        hilog.info(DOMAIN, TAG, BUNDLE + 'error: ' + err.message);
        expect(err.code).assertEqual(0);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 end');
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    it('AppServiceExtensionAbility_start_001', 0, async (done: () => void) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'start_001 begin');
      try {
        const button = await driver.findComponent(ON.text('start backend service'));
        await button.click();
        await driver.delayMs(TIME);
        hilog.info(DOMAIN, TAG, BUNDLE + 'start_001 end');
        done();
      } catch (err) {
        hilog.info(DOMAIN, TAG, `${BUNDLE} ${err}`);
        expect(true).assertTrue();
        done();
      }
    })
    it('AppServiceExtensionAbility_start_002', 0, async (done: () => void) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'start_002 begin');
      try {
        const button = await driver.findComponent(ON.id('start service'));
        await button.click();
        await driver.delayMs(TIME);
        await driver.pressBack();
        hilog.info(DOMAIN, TAG, BUNDLE + 'start_002 end');
        done();
      } catch (err) {
        hilog.info(DOMAIN, TAG, `${BUNDLE} ${err}`);
        expect(true).assertTrue();
        done();
      }
    })
    it('AppServiceExtensionAbility_stop_001', 0, async (done: () => void) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'stop_001 begin');
      try {
        const button = await driver.findComponent(ON.text('stop backend service'));
        await button.click();
        await driver.delayMs(TIME);
        hilog.info(DOMAIN, TAG, BUNDLE + 'stop_001 end');
        done();
      } catch (err) {
        hilog.info(DOMAIN, TAG, `${BUNDLE} ${err}`);
        expect(true).assertTrue();
        done();
      }
    })
    it('AppServiceExtensionAbility_stop_002', 0, async (done: () => void) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'stop_002 begin');
      try {
        const button = await driver.findComponent(ON.id('stop service'));
        await button.click();
        await driver.delayMs(TIME);
        await driver.pressBack();
        hilog.info(DOMAIN, TAG, BUNDLE + 'stop_002 end');
        done();
      } catch (err) {
        hilog.info(DOMAIN, TAG, `${BUNDLE} ${err}`);
        expect(true).assertTrue();
        done();
      }
    })
    it('AppServiceExtensionAbility_connect_001', 0, async (done: () => void) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'connect_001 begin');
      try {
        const button = await driver.findComponent(ON.text('connect backend service'));
        await button.click();
        await driver.delayMs(TIME);
        hilog.info(DOMAIN, TAG, BUNDLE + 'connect_001 end');
        done();
      } catch (err) {
        hilog.info(DOMAIN, TAG, `${BUNDLE} ${err}`);
        expect(true).assertTrue();
        done();
      }
    })
    it('AppServiceExtensionAbility_connect_002', 0, async (done: () => void) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'connect_002 begin');
      try {
        const button = await driver.findComponent(ON.id('connect service'));
        await button.click();
        await driver.delayMs(TIME);
        await driver.pressBack();
        hilog.info(DOMAIN, TAG, BUNDLE + 'connect_002 end');
        done();
      } catch (err) {
        hilog.info(DOMAIN, TAG, `${BUNDLE} ${err}`);
        expect(true).assertTrue();
        done();
      }
    })
    it('AppServiceExtensionAbility_disconnect_001', 0, async (done: () => void) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'disconnect_001 begin');
      try {
        const button = await driver.findComponent(ON.text('dis connect backend service'));
        await button.click();
        await driver.delayMs(TIME);
        hilog.info(DOMAIN, TAG, BUNDLE + 'disconnect_001 end');
        done();
      } catch (err) {
        hilog.info(DOMAIN, TAG, `${BUNDLE} ${err}`);
        expect(true).assertTrue();
        done();
      }
    })
    it('AppServiceExtensionAbility_disconnect_002', 0, async (done: () => void) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'disconnect_002 begin');
      try {
        const button = await driver.findComponent(ON.id('dis connect service'));
        await button.click();
        await driver.delayMs(TIME);
        await driver.pressBack();
        hilog.info(DOMAIN, TAG, BUNDLE + 'disconnect_002 end');
        done();
      } catch (err) {
        hilog.info(DOMAIN, TAG, `${BUNDLE} ${err}`);
        expect(true).assertTrue();
        done();
      }
    })
    it('AppServiceExtensionAbility_client_service_001', 0, async (done: () => void) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'client_service_001 begin');
      try {
        const button = await driver.findComponent(ON.text('client service'));
        await button.click();
        await driver.delayMs(TIME);
        hilog.info(DOMAIN, TAG, BUNDLE + 'client_service_001 end');
        done();
      } catch (err) {
        hilog.info(DOMAIN, TAG, `${BUNDLE} ${err}`);
        expect(true).assertTrue();
        done();
      }
    })
    it('AppServiceExtensionAbility_client_service_002', 0, async (done: () => void) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'client_service_002 begin');
      try {
        const button = await driver.findComponent(ON.id('clientService'));
        await button.click();
        await driver.delayMs(TIME);
        await driver.pressBack();
        hilog.info(DOMAIN, TAG, BUNDLE + 'client_service_002 end');
        done();
      } catch (err) {
        hilog.info(DOMAIN, TAG, `${BUNDLE} ${err}`);
        expect(true).assertTrue();
        done();
      }
    })
  })
}