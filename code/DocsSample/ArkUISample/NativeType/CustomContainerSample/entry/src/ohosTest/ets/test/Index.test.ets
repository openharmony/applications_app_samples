/*
 * Copyright (c) 2025-2026 Huawei Device Co., Ltd.
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
// 导入测试依赖kit
import { abilityDelegatorRegistry, Driver, ON, MouseButton,MatchPattern, UiDirection, Component } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import { Point } from '@ohos.UiTest';
import { hilog } from '@kit.PerformanceAnalysisKit';


const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let abilityDelegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
let want: Want;
const DOMAIN_NUMBER: number = 0xFF00;
const TAG: string = '[uitest]';

export default function IndexTest() {
  describe('IndexTest', () => {
    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      let driver = Driver.create();
      await driver.delayMs(1000);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      hilog.info(DOMAIN_NUMBER, TAG, 'get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })

    /**
     * @tc.number UiTest_001
     * @tc.name testCustomContainer
     * @tc.desc 测试自定义布局容器。
     */
    it('CustomContainer', 0, async (done: Function) => {
      hilog.info(DOMAIN_NUMBER, TAG, 'uitest: testCustomContainer begin');
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text('NativeUI', MatchPattern.CONTAINS));
      expect(button === null).assertFalse();
      await button.click();
      await driver.delayMs(1000);
      let testContent = await driver.findComponent(ON.text('CustomContainer Example', MatchPattern.CONTAINS));
      expect(testContent === null).assertFalse();
      await testContent.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN_NUMBER, TAG, 'uitest: testCustomContainer end');
      done();
    })
  })
}