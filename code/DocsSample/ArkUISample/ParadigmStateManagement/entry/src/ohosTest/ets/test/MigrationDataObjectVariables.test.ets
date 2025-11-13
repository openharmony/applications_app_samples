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

export default function migrationTest() {
  describe('migrationTest', () => {
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
     * @tc.number     : migration_MigrationNestedObjectPropertiesV1
     * @tc.name       : migration_MigrationNestedObjectPropertiesV1
     * @tc.desc       : migration
     * @tc.level      : Level 1
     * @tc.size       : migrationTest
     * @tc.type       : Function
     */
    it('migration_MigrationNestedObjectPropertiesV1', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('migration_data_object_variables')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('migration_nested_object_properties')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 = await driver.findComponent(ON.text('city +a'));
      await text2.click();
      await driver.delayMs(500);
      await text2.click();
      await driver.delayMs(500);
      await text2.click();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : migration_MigrationNestedObjectPropertiesV2
     * @tc.name       : migration_MigrationNestedObjectPropertiesV2
     * @tc.desc       : migration
     * @tc.level      : Level 1
     * @tc.size       : migrationTest
     * @tc.type       : Function
     */
    it('migration_MigrationNestedObjectPropertiesV2', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('migration_data_object_variables')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('migration_nested_object_properties_v2')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 = await driver.findComponent(ON.text('city +a'));
      await text2.click();
      await driver.delayMs(500);
      await text2.click();
      await driver.delayMs(500);
      await text2.click();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : migration_MigrationClassAttributeV1
     * @tc.name       : migration_MigrationClassAttributeV1
     * @tc.desc       : migration
     * @tc.level      : Level 1
     * @tc.size       : migrationTest
     * @tc.type       : Function
     */
    it('migration_MigrationClassAttributeV1', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('migration_data_object_variables')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('migration_class_attribute_v1')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 = await driver.findComponent(ON.text('increase age'));
      await text2.click();
      await driver.delayMs(500);
      await text2.click();
      await driver.delayMs(500);
      await text2.click();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

    /**
     * @tc.number     : migration_MigrationClassAttributeV2
     * @tc.name       : migration_MigrationClassAttributeV2
     * @tc.desc       : migration
     * @tc.level      : Level 1
     * @tc.size       : migrationTest
     * @tc.type       : Function
     */
    it('migration_MigrationClassAttributeV2', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: TestRuntimeTask begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text(await getResourceString('migration_data_object_variables')));
      await text.click();
      await driver.delayMs(1000);
      const text1 =
        await driver.findComponent(ON.text(await getResourceString('migration_class_attribute_v2')));
      await text1.click();
      await driver.delayMs(1000);
      const text2 = await driver.findComponent(ON.text('Increase age'));
      await text2.click();
      await driver.delayMs(500);
      await text2.click();
      await driver.delayMs(500);
      await text2.click();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.pressBack();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'uitest: testArcListArcIndexerBar end');
      done();
    })

  })
}