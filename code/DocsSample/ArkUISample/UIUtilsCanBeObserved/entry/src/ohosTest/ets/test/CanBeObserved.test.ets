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


export default function CanBeObservedTest() {
  describe('CanBeObservedTest', () => {
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
     * @tc.number     : CanBeObserved_001
     * @tc.name       : testV1State
     * @tc.desc       : 测试v1@State装饰器场景
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testV1State', 0, async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/V1State' });
        await driver.delayMs(1000);
        let btn = await driver.findComponent(ON.type('Button'));
        await btn.click();
        await driver.delayMs(1000);
        done();
      });

    /*
     * @tc.number     : CanBeObserved_002
     * @tc.name       : testV1Prop
     * @tc.desc       : 测试v1@Prop装饰器场景
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testV1Prop', 0, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/V1Prop' });
      await driver.delayMs(1000);
      let btn = await driver.findComponent(ON.type('Button'));
      await btn.click();
      await driver.delayMs(1000);
      done();
    });

    /*
     * @tc.number     : CanBeObserved_003
     * @tc.name       : testV1Link
     * @tc.desc       : 测试v1@Link装饰器场景
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testV1Link', 0, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/V1Link' });
      await driver.delayMs(1000);
      let btn = await driver.findComponent(ON.type('Button'));
      await btn.click();
      await driver.delayMs(1000);
      done();
    });

    /*
     * @tc.number     : CanBeObserved_004
     * @tc.name       : testV1ObjectLink
     * @tc.desc       : 测试v1@ObjectLink装饰器场景
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testV1ObjectLink', 0, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/V1ObjectLink' });
      await driver.delayMs(1000);
      let btn = await driver.findComponent(ON.type('Button'));
      await btn.click();
      await driver.delayMs(1000);
      done();
    });

    /*
     * @tc.number     : CanBeObserved_005
     * @tc.name       : testV1StorageLink
     * @tc.desc       : 测试v1@StorageLink装饰器场景
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testV1StorageLink', 0, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/V1StorageLink' });
      await driver.delayMs(1000);
      let btn = await driver.findComponent(ON.type('Button'));
      await btn.click();
      await driver.delayMs(1000);
      done();
    });

    /*
     * @tc.number     : CanBeObserved_006
     * @tc.name       : testV1StorageProp
     * @tc.desc       : 测试v1@StorageProp装饰器场景
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testV1StorageProp', 0, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/V1StorageProp' });
      await driver.delayMs(1000);
      let btn = await driver.findComponent(ON.type('Button'));
      await btn.click();
      await driver.delayMs(1000);
      done();
    });

    /*
     * @tc.number     : CanBeObserved_007
     * @tc.name       : testV1LocalStorageLink
     * @tc.desc       : 测试v1@LocalStorageLink装饰器场景
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testV1LocalStorageLink', 0, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/V1LocalStorageLink' });
      await driver.delayMs(1000);
      let btn = await driver.findComponent(ON.type('Button'));
      await btn.click();
      await driver.delayMs(1000);
      done();
    });

    /*
     * @tc.number     : CanBeObserved_008
     * @tc.name       : testV1LocalStorageProp
     * @tc.desc       : 测试v1@LocalStorageProp装饰器场景
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testV1LocalStorageProp', 0, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/V1LocalStorageProp' });
      await driver.delayMs(1000);
      let btn = await driver.findComponent(ON.type('Button'));
      await btn.click();
      await driver.delayMs(1000);
      done();
    });

    /*
     * @tc.number     : CanBeObserved_009
     * @tc.name       : testV1ProvideAndConsume
     * @tc.desc       : 测试v1@Provide和@Consume装饰器场景
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testV1ProvideAndConsume', 0, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/V1ProvideAndConsume' });
      await driver.delayMs(1000);
      let btn = await driver.findComponent(ON.type('Button'));
      await btn.click();
      await driver.delayMs(1000);
      done();
    });

    /*
     * @tc.number     : CanBeObserved_010
     * @tc.name       : testV1BuiltIn
     * @tc.desc       : 测试v1 BuiltIn类型场景
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testV1BuiltIn', 0, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/V1BuiltIn' });
      await driver.delayMs(1000);
      let btn = await driver.findComponent(ON.type('Button'));
      await btn.click();
      await driver.delayMs(1000);
      done();
    });

    /*
     * @tc.number     : CanBeObserved_011
     * @tc.name       : testV1MakeV1Observed
     * @tc.desc       : 测试v1使用makeV1Observed方法场景
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testV1MakeV1Observed', 0, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/V1MakeV1Observed' });
      await driver.delayMs(1000);
      let btn = await driver.findComponent(ON.type('Button'));
      await btn.click();
      await driver.delayMs(1000);
      done();
    });

    /*
     * @tc.number     : CanBeObserved_012
     * @tc.name       : testV2Local
     * @tc.desc       : 测试v2@Local装饰器场景
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testV2Local', 0, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/V2Local' });
      await driver.delayMs(1000);
      let btn = await driver.findComponent(ON.type('Button'));
      await btn.click();
      await driver.delayMs(1000);
      done();
    });

    /*
     * @tc.number     : CanBeObserved_013
     * @tc.name       : testV2Param
     * @tc.desc       : 测试v2@Param装饰器场景
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testV2Param', 0, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/V2Param' });
      await driver.delayMs(1000);
      let btn = await driver.findComponent(ON.type('Button'));
      await btn.click();
      await driver.delayMs(1000);
      done();
    });

    /*
      * @tc.number     : CanBeObserved_014
      * @tc.name       : testV2Computed
      * @tc.desc       : 测试v2@Computed装饰器场景
      * @tc.size       : MediumTest
      * @tc.type       : Function
      * @tc.level      : Level 1
      */
    it('testV2Computed', 0, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/V2Computed' });
      await driver.delayMs(1000);
      let btn = await driver.findComponent(ON.type('Button'));
      await btn.click();
      await driver.delayMs(1000);
      done();
    });

    /*
     * @tc.number     : CanBeObserved_015
     * @tc.name       : testV2Monitor
     * @tc.desc       : 测试v2@Monitor装饰器场景
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testV2Monitor', 0, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/V2Monitor' });
      await driver.delayMs(1000);
      let btn = await driver.findComponent(ON.type('Button'));
      await btn.click();
      await driver.delayMs(1000);
      done();
    });

    /*
     * @tc.number     : CanBeObserved_016
     * @tc.name       : testV2ProviderAndConsumer
     * @tc.desc       : 测试v2@Provider和@Consumer装饰器场景
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testV2ProviderAndConsumer', 0, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/V2ProviderAndConsumer' });
      await driver.delayMs(1000);
      let btn = await driver.findComponent(ON.type('Button'));
      await btn.click();
      await driver.delayMs(1000);
      done();
    });

    /*
     * @tc.number     : CanBeObserved_017
     * @tc.name       : testV2MakeObserved
     * @tc.desc       : 测试v2使用makeObserved方法场景
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testV2MakeObserved', 0, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/V2MakeObserved' });
      await driver.delayMs(1000);
      let btn = await driver.findComponent(ON.type('Button'));
      await btn.click();
      await driver.delayMs(1000);
      done();
    });

    /*
     * @tc.number     : CanBeObserved_018
     * @tc.name       : testV2BuiltIn
     * @tc.desc       : 测试v2 BuiltIn类型数据场景
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testV2BuiltIn', 0, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/V2BuiltIn' });
      await driver.delayMs(1000);
      let btn = await driver.findComponent(ON.type('Button'));
      await btn.click();
      await driver.delayMs(1000);
      done();
    });

    /*
      * @tc.number     : CanBeObserved_019
      * @tc.name       : testV1AndV2Compatibility
      * @tc.desc       : 测试V1AndV2Compatibility场景
      * @tc.size       : MediumTest
      * @tc.type       : Function
      * @tc.level      : Level 1
      */
    it('testV1AndV2Compatibility', 0, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/V1AndV2Compatibility' });
      await driver.delayMs(1000);
      let btn = await driver.findComponent(ON.type('Button'));
      await btn.click();
      await driver.delayMs(1000);
      done();
    });
  })
}
