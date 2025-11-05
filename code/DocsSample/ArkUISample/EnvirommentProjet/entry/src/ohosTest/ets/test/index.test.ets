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
const TAG = 'MyApp';
const delegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let driver: Driver;
let want: Want;

export default function EnvironmentTest() {
  describe('EnvironmentTest', () => {
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
      hilog.info(DOMAIN, TAG, 'get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    });

    /**
     * @tc.number EnvironmentTest_001
     * @tc.name testEnvironmentPagesNavigation
     * @tc.desc 测试两个Environment页面，每个页面进入后停留3秒
     */
    it('testEnvironmentPagesNavigation', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'EnvironmentTest: testEnvironmentPagesNavigation begin');

      // 测试 UiEnvironment 页面
      hilog.info(DOMAIN, TAG, 'EnvironmentTest: Testing UiEnvironment page');

      const uiEnvironmentItem = await driver.findComponent(ON.text('UiEnvironment'));
      if (uiEnvironmentItem !== null) {
        await uiEnvironmentItem.click();
        hilog.info(DOMAIN, TAG, 'EnvironmentTest: Clicked UiEnvironment item');

        // 等待页面加载
        await driver.delayMs(1000);

        // 在页面停留3秒
        hilog.info(DOMAIN, TAG, 'EnvironmentTest: Staying on UiEnvironment page for 3 seconds');
        await driver.delayMs(3000);

        // 返回主页
        await driver.pressBack();
        await driver.delayMs(1000);
        hilog.info(DOMAIN, TAG, 'EnvironmentTest: Returned from UiEnvironment page');
      } else {
        hilog.error(DOMAIN, TAG, 'EnvironmentTest: Could not find UiEnvironment item');
      }

      // 测试 AppliedLogic 页面
      hilog.info(DOMAIN, TAG, 'EnvironmentTest: Testing AppliedLogic page');

      const appliedLogicItem = await driver.findComponent(ON.text('AppliedLogic'));
      if (appliedLogicItem !== null) {
        await appliedLogicItem.click();
        hilog.info(DOMAIN, TAG, 'EnvironmentTest: Clicked AppliedLogic item');

        // 等待页面加载
        await driver.delayMs(1000);

        // 在页面停留3秒
        hilog.info(DOMAIN, TAG, 'EnvironmentTest: Staying on AppliedLogic page for 3 seconds');
        await driver.delayMs(3000);

        // 返回主页
        await driver.pressBack();
        await driver.delayMs(1000);
        hilog.info(DOMAIN, TAG, 'EnvironmentTest: Returned from AppliedLogic page');
      } else {
        hilog.error(DOMAIN, TAG, 'EnvironmentTest: Could not find AppliedLogic item');
      }

      hilog.info(DOMAIN, TAG, 'EnvironmentTest: Completed all pages test successfully');
      hilog.info(DOMAIN, TAG, 'EnvironmentTest: testEnvironmentPagesNavigation end');
      done();
    });
  });
}