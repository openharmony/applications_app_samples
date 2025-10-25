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

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let abilityDelegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
let want: Want;

async function getResourceString(resource: Resource): Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager;
  let textString: string = await manage.getStringValue(resource);
  return textString;
}

export default function attributeTest() {
  describe('attributeTest', () => {
    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      let driver = Driver.create();
      await driver.delayMs(1000);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      console.info('get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })

    /**
     * @tc.number UiTest_041
     * @tc.name testArcListArcIndexerBar
     * @tc.desc 测试弧形列表联动indexer示例
     */

    it('attributeTest_01', 0, async (done: Function) => {
      console.info('uitest: attributeTest_01 begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.id('btn'));
      await componentButton.click();
      console.info('uitest: already click');
      await driver.delayMs(2000);
      await componentButton.click();
      console.info('uitest: click end');
      await driver.delayMs(1000);
      done();
    })

    it('attributeTest_02', 0, async (done: Function) => {
      console.info('uitest: attributeTest_02 begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.id('btn2'));
      await componentButton.click();
      console.info('uitest: already click');
      await driver.delayMs(2000);
      await componentButton.click();
      console.info('uitest: click end');
      await driver.delayMs(1000);
      done();
    })

    it('attributeTest_03', 0, async (done: Function) => {
      console.info('uitest: attributeTest_03 begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.id('btn3'));
      await componentButton.click();
      console.info('uitest: already click');
      await driver.delayMs(2000);
      await componentButton.click();
      console.info('uitest: click end');
      await driver.delayMs(1000);
      done();
    })

    it('attributeTest_04', 0, async (done: Function) => {
      console.info('uitest: attributeTest_04 begin');
      let driver = Driver.create();
      let componentButton = await driver.findComponent(ON.id('btn4'));
      await componentButton.longClick();
      console.info('uitest: already longClick');
      await driver.delayMs(2000);
      done();
    })
  })
}