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

import { describe, it, expect, beforeAll, beforeEach } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { Router, router } from '@kit.ArkUI';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let want: Want;

export default function inheritFreezeRouterPageTest() {
  describe('inheritFreezeRouterPageTest', () => {
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
      hilog.info(0xF811,'testTag','%{public}s','get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })
    beforeEach(() => {
      hilog.info(0xF811,'testTag','%{public}s','inheritFreezeRouterPageTest beforeEach start');
      let options: router.RouterOptions = {
        url: 'pages/inheritFreezeRouterPage1',
      }
      try {
        const routerInstance = AppStorage.get<Router>('router') as Router
        let pages = routerInstance.getState();
        hilog.info(0xF811,'testTag','%{public}s','get inheritFreezeRouterPage1 state pages:' + JSON.stringify(pages));
        if (('inheritFreezeRouterPage1' != pages.name)) {
          hilog.info(0xF811,'testTag','%{public}s','get inheritFreezeRouterPage1 pages.name:' + JSON.stringify(pages.name));
          routerInstance.pushUrl(options);
        }
      } catch (err) {
        hilog.error(0xF811,'testTag','%{public}s','push inheritFreezeRouterPage1 page error:' + err);
      }
      hilog.info(0xF811,'testTag','%{public}s','inheritFreezeRouterPage1 beforeEach end');
    });

    /*
     * @tc.number     : inheritFreezeRouterPage1_01
     * @tc.name       : inheritFreezeRouterPageTest_01
     * @tc.desc       : 测试通过BuilderNode的build可以实现组件树的创建。
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */

    it('inheritFreezeRouterPageTest_01', 0, async (done: Function) => {
      hilog.info(0xF811,'testTag','%{public}s','uitest: inheritFreezeRouterPageTest_01 begin');
      let driver = Driver.create();
      let componentButton1 = await driver.findComponent(ON.text('change'));
      await componentButton1.click();
      hilog.info(0xF811,'testTag','%{public}s','uitest: already click');
      await driver.delayMs(2000);
      let componentButton2 = await driver.findComponent(ON.text('next'));
      await componentButton2.click();
      hilog.info(0xF811,'testTag','%{public}s','uitest: already click');
      await driver.delayMs(2000);
      let componentButton3 = await driver.findComponent(ON.text('Back'));
      await componentButton3.click();
      hilog.info(0xF811,'testTag','%{public}s','uitest: already click');
      await driver.delayMs(2000);
      done();
    })
  })
}