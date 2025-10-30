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


export default function BuilderProxyNode01Test() {
  describe('BuilderProxyNode01Test', () => {
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
      hilog.info(0xF811,'testTag','%{public}s','BuilderProxyNode01Test beforeEach start');
      let options: router.RouterOptions = {
        url: 'pages/BuilderProxyNode01',
      }
      try {
        const routerInstance = AppStorage.get<Router>('router') as Router
        let pages = routerInstance.getState();
        hilog.info(0xF811,'testTag','%{public}s','get BuilderProxyNode01 state pages:' + JSON.stringify(pages));
        if (('BuilderProxyNode01' != pages.name)) {
          hilog.info(0xF811,'testTag','%{public}s','get BuilderProxyNode01 pages.name:' + JSON.stringify(pages.name));
          routerInstance.pushUrl(options);
        }
      } catch (err) {
        hilog.error(0xF811,'testTag','%{public}s','push BuilderProxyNode01 page error:' + err);
      }
      hilog.info(0xF811,'testTag','%{public}s','BuilderProxyNode01 beforeEach end');
    });

    /*
     * @tc.number     : BuilderProxyNode01_01
     * @tc.name       : BuilderProxyNode01Test
     * @tc.desc       : 测试传入的Builder的根节点为语法节点或自定义组件，是否将额外生成一个FrameNode
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */

    it('BuilderProxyNode01Test', 0, async (done: Function) => {
      hilog.info(0xF811,'testTag','%{public}s','uitest: WrappedBuilderTest_01 begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.id('BuilderProxyNode01'));
      await componentButton.click();
      hilog.info(0xF811,'testTag','%{public}s','uitest: already click');
      await driver.delayMs(2000);
      done();
    })
  });
}