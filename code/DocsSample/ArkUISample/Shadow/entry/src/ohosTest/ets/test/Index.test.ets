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

import { describe, it, expect, beforeAll } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
const DOMAIN = 0x0001;
const TAG = 'Sample_imagecomponent';
const delegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let driver: Driver;
let want: Want;

export default function IndexTest() {
  describe('IndexTest', () => {
    beforeAll(async () => {
      // 启动应用
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      driver = Driver.create();
      await driver.delayMs(1000);

      // 验证当前页面是否正确
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      hilog.info(DOMAIN, TAG,'get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    });

    /**
     * @tc.number: ImageTest_001
     * @tc.name: testShadow
     * @tc.desc: Test page add shadow effect
     * @tc.level: Level1
     * @tc.size: MediumTest
     * @tc.type: Function
     */
    it('testShadow', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'ImageTest: testShadow begin');

      // Click the 'Add Shadow Effect' option
      const shadowItem = await driver.findComponent(ON.text('Shadow'));
      expect(shadowItem === null).assertFalse();
      await shadowItem.click();
      await driver.delayMs(1000);

      // Verify whether it redirects to the target page
      const pageTitle = await driver.findComponent(ON.type('Image'));
      expect(pageTitle === null).assertFalse();

      // Return to Home
      await driver.pressBack();
      await driver.delayMs(500);

      hilog.info(DOMAIN, TAG, 'ImageTest: testShadow end');
      done();
    });
  });
}