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
// 导入测试依赖kit
import hilog from '@ohos.hilog';
import { abilityDelegatorRegistry, Driver, ON, MatchPattern } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';

const TAG = '[Sample_MyApp]';
const DOMAIN = 0xF811;
const BUNDLE = 'MyApp_';
const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let want: Want;

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
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })

    /**
     * @tc.number ThemeSkinningTest_001
     * @tc.name testThemeSkinning
     * @tc.desc 测试主题是否显示正常
     */
    it(BUNDLE + 'ThemeSkinningTest_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ThemeSkinningTest_001 begin');
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text('ThemeCustomThree', MatchPattern.CONTAINS));
      await button.click();
      let button1 = await driver.findComponent(ON.text('ThemeCustomTamplateThree', MatchPattern.CONTAINS));
      await button1.click();
      let button2 = await driver.findComponent(ON.text('Switch ColorMode', MatchPattern.CONTAINS));
      await button2.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ThemeSkinningTest_001 end');
      done();
    })

    /**
     * @tc.number ThemeSkinningTest_002
     * @tc.name testThemeSkinning
     * @tc.desc 测试主题是否显示正常
     */
    it(BUNDLE + 'ThemeSkinningTest_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ThemeSkinningTest_002 begin');
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text('ThemeCustomOne', MatchPattern.CONTAINS));
      await button.click();
      let button1 = await driver.findComponent(ON.text('ThemeCustomTamplateOne', MatchPattern.CONTAINS));
      await button1.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ThemeSkinningTest_002 end');
      done();
    })

    /**
     * @tc.number ThemeSkinningTest_003
     * @tc.name testThemeSkinning
     * @tc.desc 测试主题是否显示正常
     */
    it(BUNDLE + 'ThemeSkinningTest_003', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ThemeSkinningTest_003 begin');
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text('ThemeCustomTwo', MatchPattern.CONTAINS));
      await button.click();
      let button1 = await driver.findComponent(ON.text('ThemeCustomTamplateTwo', MatchPattern.CONTAINS));
      await button1.click();
      let button2 = await driver.findComponent(ON.text('change theme', MatchPattern.CONTAINS));
      await button2.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ThemeSkinningTest_003 end');
      done();
    })
  })
}