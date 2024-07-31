/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import { describe, beforeAll, it } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG = '[Sample_OpenAtomicService]';
const DOMAIN = 0xF811;
const BUNDLE = 'OpenAtomicService_';

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    beforeAll(async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility begin');
      let abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.fullscreenstart',
          abilityName: 'EntryAbility'
        });
      } catch (err) {
        let code = (err as BusinessError).code;
        let message = (err as BusinessError).message;
        hilog.error(DOMAIN, TAG, BUNDLE + `openAtomicService failed, code is ${code}, message is ${message}`);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility end');
    })

    /**
     * @tc.number     : OpenAtomicServiceTest_001
     * @tc.name       : OpenAtomicServiceTest_001
     * @tc.desc       : test @ohos.arkui.advanced.FullScreenLaunchComponent
     * @tc.size       : MEDIUM
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('Sample_OpenAtomicService_OpenAtomicServiceTest_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'OpenAtomicServiceTest_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('EmbeddableStart'));
      let btnEmbeddable = await driver.findComponent(ON.id('EmbeddableStart'));
      await btnEmbeddable.click();
      await driver.delayMs(1500);
      await driver.pressBack();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'OpenAtomicServiceTest_001 end');
      done();
    })

    /**
     * @tc.number     : OpenAtomicServiceTest_002
     * @tc.name       : OpenAtomicServiceTest_002
     * @tc.desc       : test UIAbilityContext.openAtomicService
     * @tc.size       : MEDIUM
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('Sample_OpenAtomicService_OpenAtomicServiceTest_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'OpenAtomicServiceTest_002 begin');
      let driver = await Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('UIAbilityStart'));
      let btnUIAbilityContext = await driver.findComponent(ON.id('UIAbilityStart'));
      await btnUIAbilityContext.click();
      await driver.delayMs(1500);
      await driver.pressBack();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'OpenAtomicServiceTest_002 end');
      done();
    })

    /**
     * @tc.number     : OpenAtomicServiceTest_003
     * @tc.name       : OpenAtomicServiceTest_003
     * @tc.desc       : test UIExtensionContext.openAtomicService
     * @tc.size       : MEDIUM
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('Sample_OpenAtomicService_OpenAtomicServiceTest_003', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'OpenAtomicServiceTest_003 begin');
      let driver = await Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('UIExtensionStart'));
      let btnUIExtensionContext = await driver.findComponent(ON.id('UIExtensionStart'));
      await btnUIExtensionContext.click();
      await driver.delayMs(1500);
      await driver.pressBack();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'OpenAtomicServiceTest_003 end');
      done();
    })
  })
}