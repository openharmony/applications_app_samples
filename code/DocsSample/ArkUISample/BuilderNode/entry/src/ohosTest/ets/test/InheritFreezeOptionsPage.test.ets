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

import { describe, beforeAll, beforeEach, it, expect } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import { Router, router } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let want: Want;


export default function inheritFreezeTest() {
  describe('inheritFreezeTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      let driver = Driver.create();
      await driver.delayMs(1000);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      hilog.info(0xF811, 'testTag', '%{public}s','get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })
    beforeEach(() => {
      hilog.info(0xF811, 'testTag', '%{public}s','inheritFreezeTest beforeEach start');
      let options: router.RouterOptions = {
        url: 'pages/inheritFreezeOptionsPage',
      }
      try {
        const routerInstance = AppStorage.get<Router>('router') as Router
        let pages = routerInstance.getState();
        hilog.info(0xF811, 'testTag', '%{public}s','get inheritFreezeOptionsPage state pages:' + JSON.stringify(pages));
        if (!('inheritFreezeOptionsPage' == pages.name)) {
          hilog.info(0xF811, 'testTag', '%{public}s','get inheritFreezeOptionsPage pages.name:' + JSON.stringify(pages.name));
          routerInstance.pushUrl(options);
        }
      } catch (err) {
        hilog.error(DOMAIN, 'testTag', '%{public}s','push inheritFreezeOptionsPage page error:' + err);
      }
      hilog.info(0xF811, 'testTag', '%{public}s','inheritFreezeOptionsPage beforeEach end');
    });

    it('inheritFreezeTest', 0, async (done: Function) => {
      hilog.info(0xF811, 'testTag', '%{public}s','uitest: inheritFreezeTest begin');
      let driver = Driver.create();
      let componentButton1 = await driver.findComponent(ON.text('Next Page'));
      await componentButton1.click()
      hilog.info(0xF811, 'testTag', '%{public}s','uitest: already click');
      await driver.delayMs(2000);
      let componentButton2 = await driver.findComponent(ON.text('update builderNode'));
      await componentButton2.click()
      await driver.delayMs(500);
      await componentButton2.click()
      await driver.delayMs(500);
      await componentButton2.click()
      await driver.delayMs(500);
      await componentButton2.click()
      await driver.delayMs(500);
      await componentButton2.click()
      await driver.delayMs(500);
      hilog.info(0xF811, 'testTag', '%{public}s','uitest: already click');
      let componentButton3 = await driver.findComponent(ON.text('Next Page'));
      await componentButton3.click()
      await driver.delayMs(1000);
      let componentButton4 = await driver.findComponent(ON.text('Back Page'));
      await componentButton4.click()
      await driver.delayMs(2000);
      done();
    })
  });
}