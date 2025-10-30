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
const DOMAIN = 0xF811;

export default function NewGlobalTest() {
  describe('NewGlobalTest', () => {
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
      hilog.info(DOMAIN,'get top ability','get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })
    beforeEach(() => {
      hilog.info(DOMAIN,'NewGlobal beforeEach start','NewGlobal beforeEach start');
      let options: router.RouterOptions = {
        url: 'pages/NewGlobal',
      }
      try {
        const routerInstance = AppStorage.get<Router>('router') as Router
        let pages = routerInstance.getState();
        hilog.info(DOMAIN,'get NewGlobal state pages',JSON.stringify(pages));
        if (('NewGlobal' != pages.name)) {
          hilog.info(DOMAIN,'get NewGlobal state pages',JSON.stringify(pages.name));
          routerInstance.pushUrl(options);
        }
      } catch (err) {
        hilog.error(DOMAIN,'get NewGlobal state pages',err);
      }
      hilog.info(DOMAIN,'NewGlobal beforeEach end','NewGlobal beforeEach end');
    });

    /*
     * @tc.number     : NewGlobal_01
     * @tc.name       : NewGlobalTest_01
     * @tc.desc       : 测试UIContext替代全局接口
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */

    it('NewGlobalTest_01', 0, async (done: Function) => {
      hilog.info(DOMAIN,'uitest: NewGlobalTest begin','uitest: NewGlobalTest begin');
      let driver = Driver.create();
      let componentText = await driver.findComponent(ON.text('Calculate 20vp to px'));
      await componentText.click();
      hilog.info(DOMAIN,'uitest: already click','uitest: already click');
      await driver.delayMs(2000);
      done();
    })
  });
}