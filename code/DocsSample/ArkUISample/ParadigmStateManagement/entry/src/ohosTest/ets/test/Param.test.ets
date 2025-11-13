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

export default function paramTest() {
  describe('paramTest', () => {
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
     * @tc.number     : param_ParamDecoratorLimitations
     * @tc.name       : param_ParamDecoratorLimitations
     * @tc.desc       : param
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('param_ParamDecoratorLimitations', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('param')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('param_decorator_limitations')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('change Info'));
      await text2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : param_ParamObserveChangeVariable
     * @tc.name       : param_ParamObserveChangeVariable
     * @tc.desc       : param
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('param_ParamObserveChangeVariable', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('param')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('param_observe_change_variable')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('change Local'));
      await text2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : param_ParamObserveChangeClass
     * @tc.name       : param_ParamObserveChangeClass
     * @tc.desc       : param
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('param_ParamObserveChangeClass', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('param')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('param_observe_change_class')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('change object'));
      await text2.click();
      await driver.delayMs(300);
      const text3 =
        await driver.findComponent(ON.text('change name'));
      await text3.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : param_ParamObserveChangeArray
     * @tc.name       : param_ParamObserveChangeArray
     * @tc.desc       : param
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('param_ParamObserveChangeArray', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('param')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('param_observe_change_array')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('change array item'));
      await text2.click();
      await driver.delayMs(300);
      const text3 =
        await driver.findComponent(ON.text('change whole array'));
      await text3.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : param_ParamObserveChangeNestedClass
     * @tc.name       : param_ParamObserveChangeNestedClass
     * @tc.desc       : param
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('param_ParamObserveChangeNestedClass', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('param')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('param_observe_change_nested_class')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('change infoArr item'));
      await text2.click();
      await driver.delayMs(300);
      const text3 =
        await driver.findComponent(ON.text('change originInfo'));
      await text3.click();
      await driver.delayMs(300);
      const text4 =
        await driver.findComponent(ON.text('change originInfo region'));
      await text4.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : param_ParamUseSceneParentToChild
     * @tc.name       : param_ParamUseSceneParentToChild
     * @tc.desc       : param
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('param_ParamUseSceneParentToChild', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('param')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('param_use_scene_parent_to_child')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('change'));
      await text2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : param_ParamUseSceneArray
     * @tc.name       : param_ParamUseSceneArray
     * @tc.desc       : param
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('param_ParamUseSceneArray', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('param')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('param_use_scene_array')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('init array'));
      await text2.click();
      await driver.delayMs(300);
      const text3 =
        await driver.findComponent(ON.text('push'));
      await text3.click();
      await driver.delayMs(300);
      const text4 =
        await driver.findComponent(ON.text('reverse'));
      await text4.click();
      await driver.delayMs(300);
      const text5 =
        await driver.findComponent(ON.text('fill'));
      await text5.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : param_ParamUseSceneDate
     * @tc.name       : param_ParamUseSceneDate
     * @tc.desc       : param
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('param_ParamUseSceneDate', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('param')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('param_use_scene_date')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('parent update the new date'));
      await text2.click();
      await driver.delayMs(300);
      const text3 =
        await driver.findComponent(ON.text('increase the year by 1'));
      await text3.click();
      await driver.delayMs(300);
      const text4 =
        await driver.findComponent(ON.text('increase the month by 1'));
      await text4.click();
      await driver.delayMs(300);
      const text5 =
        await driver.findComponent(ON.text('parent increase the day by 1'));
      await text5.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : param_ParamUseSceneMap
     * @tc.name       : param_ParamUseSceneMap
     * @tc.desc       : param
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('param_ParamUseSceneMap', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('param')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('param_use_scene_map')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('init map'));
      await text2.click();
      await driver.delayMs(300);
      const text3 =
        await driver.findComponent(ON.text('set new one'));
      await text3.click();
      await driver.delayMs(300);
      const text4 =
        await driver.findComponent(ON.text('clear'));
      await text4.click();
      await driver.delayMs(300);
      const text5 =
        await driver.findComponent(ON.text('replace the first one'));
      await text5.click();
      await driver.delayMs(300);
      const text6 =
        await driver.findComponent(ON.text('delete the first one'));
      await text6.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : param_ParamUseSceneSet
     * @tc.name       : param_ParamUseSceneSet
     * @tc.desc       : param
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('param_ParamUseSceneSet', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('param')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('param_use_scene_set')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('init set'));
      await text2.click();
      await driver.delayMs(300);
      const text3 =
        await driver.findComponent(ON.text('set new one'));
      await text3.click();
      await driver.delayMs(300);
      const text4 =
        await driver.findComponent(ON.text('clear'));
      await text4.click();
      await driver.delayMs(300);
      const text5 =
        await driver.findComponent(ON.text('delete the first one'));
      await text5.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : param_ParamUseSceneUnite
     * @tc.name       : param_ParamUseSceneUnite
     * @tc.desc       : param
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('param_ParamUseSceneUnite', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('param')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 400, 200, 20, 600);
      await driver.delayMs(1500);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('param_use_scene_unite')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('change'));
      await text2.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : param_ParamRestrictModifyObject
     * @tc.name       : param_ParamRestrictModifyObject
     * @tc.desc       : param
     * @tc.level      : Level 1
     * @tc.size       : MediumTest
     * @tc.type       : Function
     */
    it('param_ParamRestrictModifyObject', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('param')));
      await text.click();
      await driver.delayMs(1000);
      await driver.swipe(100, 400, 200, 20, 600);
      await driver.delayMs(1500);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('param_restrict_modify_object')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 =
        await driver.findComponent(ON.text('Parent change info'));
      await text2.click();
      await driver.delayMs(300);
      const text3 =
        await driver.findComponent(ON.text('change info'));
      await text3.click();
      await driver.delayMs(300);
      const text4 =
        await driver.findComponent(ON.text('Child change info.name'));
      await text4.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })
  })
}