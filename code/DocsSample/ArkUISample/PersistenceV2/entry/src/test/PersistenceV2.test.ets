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

import { beforeAll, describe, expect, it } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import router from '@ohos.router';


const delegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let driver: Driver;
let want: Want;


export default function PersistenceV2Test() {
  describe('PersistenceV2Test', () => {
    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      driver = Driver.create();
      await driver.delayMs(1000);

      const ability: UIAbility = await delegator.getCurrentTopAbility();
      console.info('get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    });

    /*
     * @tc.number     : PersistenceV2_001
     * @tc.name       : testCircularReferenceOfObject
     * @tc.desc       : 测试PersistenceV2持久化循环引用对象场景
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testCircularReferenceOfObject', 0, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/CircularReferenceOfObject' });
      await driver.delayMs(1000);
      let btn = await driver.findComponent(ON.type('Text'));
      await btn.click();
      await driver.delayMs(1000);
      done();
    });

    /*
     * @tc.number     : PersistenceV2_002
     * @tc.name       : testNonTopLevelNumberOfClass
     * @tc.desc       : 测试PersistenceV2持久化自定义class中属性为Number场景
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testNonTopLevelNumberOfClass', 0, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/NonTopLevelNumberOfClass' });
      await driver.delayMs(1000);
      let btn = await driver.findComponent(ON.type('Text'));
      await btn.click();
      await driver.delayMs(1000);
      done();
    });

    /*
     * @tc.number     : PersistenceV2_003
     * @tc.name       : testTopLevelArrayClassA
     * @tc.desc       : 测试PersistenceV2持久化Array<ClassA>场景
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testTopLevelArrayClassA', 0, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/TopLevelArrayClassA' });
      await driver.delayMs(1000);
      let btn = await driver.findComponent(ON.type('Button'));
      await btn.click();
      await driver.delayMs(1000);
      done();
    });

    /*
     * @tc.number     : PersistenceV2_004
     * @tc.name       : testTopLevelArrayClassAAPIs
     * @tc.desc       : 测试PersistenceV2持久化Array<ClassA>, 测试各种Array API的场景
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testTopLevelArrayClassAAPIs', 0, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/TopLevelArrayClassAAPIs' });
      await driver.delayMs(1000);
      let btn = await driver.findComponent(ON.type('Button'));
      await btn.click();
      await driver.delayMs(1000);
      done();
    });

    /*
     * @tc.number     : PersistenceV2_005
     * @tc.name       : testTopLevelCollectionsArray
     * @tc.desc       : 测试PersistenceV2持久化collections.Array<ClassA>的场景
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testTopLevelCollectionsArray', 0, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/TopLevelCollectionsArray' });
      await driver.delayMs(1000);
      let btn = await driver.findComponent(ON.type('Button'));
      await btn.click();
      await driver.delayMs(1000);
      done();
    });

    /*
     * @tc.number     : PersistenceV2_006
     * @tc.name       : testTopLevelDate
     * @tc.desc       : 测试PersistenceV2持久化Date的场景
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testTopLevelDate', 0, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/TopLevelDate' });
      await driver.delayMs(1000);
      let btn = await driver.findComponent(ON.type('Button'));
      await btn.click();
      await driver.delayMs(1000);
      done();
    });
  })
}
