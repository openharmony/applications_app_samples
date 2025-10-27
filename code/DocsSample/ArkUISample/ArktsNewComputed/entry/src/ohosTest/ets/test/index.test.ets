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

import { describe, it, expect, beforeAll, Level } from '@ohos/hypium';
// 导入测试依赖kit
import { abilityDelegatorRegistry, Driver, ON, MatchPattern, On, Component } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import hilog from '@ohos.hilog';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let abilityDelegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
let want: Want;
const TAG = '[Sample_Arktsnewcomputed]'
const DOMAIN = 0xF811
const BUNDLE = 'Arktsnewcomputed_'

async function getResourceString(resource: Resource): Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager;
  let textString: string = await manage.getStringValue(resource);
  return textString;
}

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
      hilog.info(DOMAIN, TAG, BUNDLE + 'get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })

    /**
     * @tc.number UiTest_001
     * @tc.name testCustomComponentUse
     * @tc.desc 测试在自定义组件中使用计算属性
     * @tc.level: Level 1
     */
    it('testCustomComponentUse', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testCreateText begin');
      let driver = Driver.create();
      let str = await getResourceString($r('app.string.computed_desc_1'));
      let buttonComponent = await driver.findComponent(ON.text(str));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();

      buttonComponent = await driver.findComponent(ON.text('changed lastName', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      await buttonComponent.click();
      buttonComponent = await driver.findComponent(ON.text('changed age', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      await buttonComponent.click();

      await driver.pressBack();
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testCreateText end');
      done();
    })

    /**
     * @tc.number UiTest_002
     * @tc.name testObservedV2ClassUser
     * @tc.desc 测试在自定义组件中使用计算属性
     * @tc.level: Level 1
     */
    it('testObservedV2ClassUser', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testObservedV2ClassUser begin');
      let driver = Driver.create();
      let str = await getResourceString($r('app.string.computed_desc_2'));
      let buttonComponent = await driver.findComponent(ON.text(str));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();

      buttonComponent = await driver.findComponent(ON.text('changed lastName', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      await buttonComponent.click();

      await driver.pressBack();
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testObservedV2ClassUser end');
      done();
    })

    /**
     * @tc.number UiTest_003
     * @tc.name testComputingPropertyResolution
     * @tc.desc 测试在自定义组件中使用计算属性
     * @tc.level: Level 1
     */
    it('testComputingPropertyResolution', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testComputingPropertyResolution begin');
      let driver = Driver.create();
      let str = await getResourceString($r('app.string.computed_title_2'));
      let buttonComponent = await driver.findComponent(ON.text(str));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();

      buttonComponent = await driver.findComponent(ON.text('-', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      await buttonComponent.click();
      buttonComponent = await driver.findComponent(ON.text('+', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      await buttonComponent.click();

      await driver.pressBack();
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testComputingPropertyResolution end');
      done();
    })

    /**
     * @tc.number UiTest_004
     * @tc.name testComputedInitParam
     * @tc.desc 测试在自定义组件中使用计算属性
     * @tc.level: Level 1
     */
    it('testComputedInitParam', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testComputedInitParam begin');
      let driver = Driver.create();
      let str = await getResourceString($r('app.string.computed_title_3'));
      let buttonComponent = await driver.findComponent(ON.text(str));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();

      buttonComponent = await driver.findComponent(ON.text('-', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      await buttonComponent.click();
      buttonComponent = await driver.findComponent(ON.text('+', MatchPattern.CONTAINS));
      expect(buttonComponent === null).assertFalse();
      await buttonComponent.click();
      await buttonComponent.click();

      await driver.pressBack();
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: testComputedInitParam end');
      done();
    })

  })
}