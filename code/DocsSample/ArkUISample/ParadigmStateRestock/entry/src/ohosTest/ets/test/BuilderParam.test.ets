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
import { describe, beforeAll, it, expect } from '@ohos/hypium';
import { UIAbility, Want } from '@kit.AbilityKit';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { getResourceString } from './Ability.test';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;

let want: Want;
const DOMAIN = 0x0000;

export default function builderParamTest() {
  describe('builderParamTest', () => {
    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      let driver = Driver.create();
      await driver.delayMs(1000);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })

    /**
     * @tc.number     : builderParam_BuilderParamInitMethodDemo01
     * @tc.name       : builderParam_BuilderParamInitMethodDemo01
     * @tc.desc       : builderParam
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('builderParam_BuilderParamInitMethodDemo01', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('builder_param')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('builder_param_init_method_demo01')));
      await text1.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : builderParam_BuilderParamInitMethodDemo02
     * @tc.name       : builderParam_BuilderParamInitMethodDemo02
     * @tc.desc       : builderParam
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('builderParam_BuilderParamInitMethodDemo02', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('builder_param')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('builder_param_init_method_demo02')));
      await text1.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : builderParam_BuilderParamSceneInitComponent
     * @tc.name       : builderParam_BuilderParamSceneInitComponent
     * @tc.desc       : builderParam
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('builderParam_BuilderParamSceneInitComponent', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('builder_param')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('builder_param_scene_init_component')));
      await text1.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : builderParam_BuilderParamSceneTrailingClosure01
     * @tc.name       : builderParam_BuilderParamSceneTrailingClosure01
     * @tc.desc       : builderParam
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('builderParam_BuilderParamSceneTrailingClosure01', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('builder_param')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('builder_param_scene_trailing_closure_01')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('testA' || 'testB'));
      await text2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : builderParam_BuilderParamSceneTrailingClosure02
     * @tc.name       : builderParam_BuilderParamSceneTrailingClosure02
     * @tc.desc       : builderParam
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('builderParam_BuilderParamSceneTrailingClosure02', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('builder_param')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('builder_param_scene_trailing_closure_02')));
      await text1.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

  })
}