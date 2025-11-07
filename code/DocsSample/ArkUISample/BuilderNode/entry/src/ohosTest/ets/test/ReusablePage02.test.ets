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


export default function ReusablePage02Test() {
  describe('ReusablePage02Test', () => {
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
      hilog.info(0xF811,'testTag','%{public}s','ReusablePage02Test beforeEach start');
      let options: router.RouterOptions = {
        url: 'pages/ReusablePage02',
      }
      try {
        const routerInstance = AppStorage.get<Router>('router') as Router
        let pages = routerInstance.getState();
        hilog.info(0xF811,'testTag','%{public}s','get ReusablePage02 state pages:' + JSON.stringify(pages));
        if (('ReusablePage02' != pages.name)) {
          hilog.info(0xF811,'testTag','%{public}s','get ReusablePage02 pages.name:' + JSON.stringify(pages.name));
          routerInstance.pushUrl(options);
        }
      } catch (err) {
        hilog.error(0xF811,'testTag','%{public}s','push ReusablePage02 page error:' + err);
      }
      hilog.info(0xF811,'testTag','%{public}s','ReusablePage02 beforeEach end');
    });

    /*
     * @tc.number     : ReusablePage02_01
     * @tc.name       : ReusablePage02Test
     * @tc.desc       : 测试使用@Reusable装饰器时，使用一个普通自定义组件包裹该自定义组件
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */

    it('ReusablePage02Test', 0, async (done: Function) => {
      hilog.info(0xF811,'testTag','%{public}s','uitest: ReusablePage02Test begin');
      let driver = Driver.create();
      let componentList = await driver.findComponent(ON.id('ReusablePage02'));
      await componentList.click()
      hilog.info(0xF811,'testTag','%{public}s','uitest: already click');
      await driver.delayMs(2000);
      done();
    })
  });
}