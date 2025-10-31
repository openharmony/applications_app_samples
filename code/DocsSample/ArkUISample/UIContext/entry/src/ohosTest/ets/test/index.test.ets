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
const DOMAIN = 0xF811;

export default function IndexTest() {
  describe('IndexTest', () => {
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
      hilog.info(DOMAIN, 'get top ability', 'get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })
    beforeEach(() => {
      hilog.info(0xF811, 'testTag', '%{public}s', 'inheritFreezeTest beforeEach start');
      let options: router.RouterOptions = {
        url: 'pages/ContextPage',
      }
      try {
        const routerInstance = AppStorage.get<Router>('router') as Router
        let pages = routerInstance.getState();
        hilog.info(0xF811, 'testTag', '%{public}s',
          'get inheritFreezeOptionsPage state pages:' + JSON.stringify(pages));
        if (('ContextPage' != pages.name)) {
          hilog.info(0xF811, 'testTag', '%{public}s',
            'get inheritFreezeOptionsPage pages.name:' + JSON.stringify(pages.name));
          routerInstance.pushUrl(options);
        }
      } catch (err) {
        hilog.error(0xF811, 'testTag', '%{public}s', 'push inheritFreezeOptionsPage page error:' + err);
      }
      hilog.info(0xF811, 'testTag', '%{public}s', 'inheritFreezeOptionsPage beforeEach end');
    });

    /*
     * @tc.number     : ContextPage_01
     * @tc.name       : IndexTest_01
     * @tc.desc       : 测试在单Ability场景中，直接获取Ability的context属性。
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */

    it('IndexTest_01', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'uitest: IndexTest_01 begin', 'uitest: IndexTest_01 begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.text('getContext'));
      await componentButton.click();
      hilog.info(DOMAIN, 'uitest: already click', 'uitest: already click');
      await driver.delayMs(2000);
      done();
    })
  })
}