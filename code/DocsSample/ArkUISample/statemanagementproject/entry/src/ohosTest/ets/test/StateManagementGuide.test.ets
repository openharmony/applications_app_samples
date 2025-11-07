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

import { beforeAll, describe, expect, it, Level, TestType, Size } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import router from '@ohos.router';


const delegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let driver: Driver;
let want: Want;


export default function StateManagementGuide() {
  describe('StateManagementGuide', () => {
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
     * @tc.number     : StateArray_001
     * @tc.name       : testStateArray
     * @tc.desc       : 测试数据状态管理将简单属性数组合并成对象数组，配合ForEach进行使用
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testStateArray', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/statemanagementguide/StateArray' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
     * @tc.number     : StateArrayUpdate_001
     * @tc.name       : testStateArrayUpdate
     * @tc.desc       : 测试减少“冗余刷新”，将属性数组转变为对象数组，配合自定义组件，实现精准控制更新范围
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testStateArrayUpdate', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/statemanagementguide/StateArrayUpdate' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
     * @tc.number     : StateArrayBig_001
     * @tc.name       : testStateArrayBig
     * @tc.desc       : 测试定义一个大的对象，其中包含了很多样式相关的属性，并且在父子组件间传递这个对象，将其中的属性绑定在组件上
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testStateArrayBig', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/statemanagementguide/StateArrayBig' })
        await driver.delayMs(1000);
        const text = await driver.findComponent(ON.text('Move'));
        await text.click();
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
    * @tc.number     : StateArrayPrecise_001
    * @tc.name       : testStateArrayPrecise
    * @tc.desc       : 测试定义一个大的对象，其中包含了很多样式相关的属性，并且在父子组件间传递这个对象，将其中的属性绑定在组件上
    * @tc.size       : MediumTest
    * @tc.type       : Function
    * @tc.level      : Level 1
    */
    it('testStateArrayPrecise', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/statemanagementguide/StateArrayPrecise' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
    * @tc.number     : StateArrayTrack_001
    * @tc.name       : testStateArrayTrack
    * @tc.desc       : 测试使用@Track装饰器则无需做属性拆分，也能达到同样控制组件更新范围的作用。
    * @tc.size       : MediumTest
    * @tc.type       : Function
    * @tc.level      : Level 1
    */
    it('StateArrayTrack', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/statemanagementguide/StateArrayTrack' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });


    /*
    * @tc.number     : StateArrayObserved_001
    * @tc.name       : testStateArrayObserved
    * @tc.desc       : 测试使用@Observed装饰或被声明为状态变量的类对象绑定组件
    * @tc.size       : MediumTest
    * @tc.type       : Function
    * @tc.level      : Level 1
    */
    it('StateArrayObserved', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/statemanagementguide/StateArrayObserved' })
        await driver.delayMs(2000);
        await driver.delayMs(2000);
        const text = await driver.findComponent(ON.text('X'));
        await text.click();
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
   * @tc.number     : StateArrayLoadDate_001
   * @tc.name       : testStateArrayLoadDate
   * @tc.desc       : 测试childList重新赋值时，是通过Ancestor对象的方法loadData。
   * @tc.size       : MediumTest
   * @tc.type       : Function
   * @tc.level      : Level 1
   */
    it('StateArrayLoadDate', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/statemanagementguide/StateArrayLoadDate' })
        await driver.delayMs(2000);
        const text = await driver.findComponent(ON.text('X'));
        await text.click();
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
    * @tc.number     : StateArrayNo_001
    * @tc.name       : testStateArrayNo
    * @tc.desc       : 测试UI能够正常的刷新
    * @tc.size       : MediumTest
    * @tc.type       : Function
    * @tc.level      : Level 1
    */
    it('StateArrayNo', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/statemanagementguide/StateArrayNo' })
        await driver.delayMs(1000);
        const text = await driver.findComponent(ON.text('X'));
        await text.click();
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
    * @tc.number     : StateArrayNo2_001
    * @tc.name       : testStateArrayNo2
    * @tc.desc       : 测试UI能够正常的刷新
    * @tc.size       : MediumTest
    * @tc.type       : Function
    * @tc.level      : Level 1
    */
    it('StateArrayNo2', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/statemanagementguide/StateArrayNo2' })
        await driver.delayMs(1000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
* @tc.number     : StateArrayLazy_001
* @tc.name       : testStateArrayLazy
* @tc.desc       : 测试减少使用LazyForEach的重建机制刷新UI
* @tc.size       : MediumTest
* @tc.type       : Function
* @tc.level      : Level 1
*/
    it('StateArrayLazy', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/statemanagementguide/StateArrayLazy' })
        await driver.delayMs(1000);
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
* @tc.number     : StateArrayLazy2_001
* @tc.name       : testStateArrayLazy2
* @tc.desc       : 测试使用状态变量来触发LazyForEach中的组件刷新，这就需要使用自定义组件。
* @tc.size       : MediumTest
* @tc.type       : Function
* @tc.level      : Level 1
*/
    it('StateArrayLazy2', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/statemanagementguide/StateArrayLazy2' })
        await driver.delayMs(1000);
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
   * @tc.number     : StateArrayForeach_001
   * @tc.name       : testStateArrayForeach
   * @tc.desc       : 测试在ForEach中使用自定义组件搭配对象数组
   * @tc.size       : MediumTest
   * @tc.type       : Function
   * @tc.level      : Level 1
   */
    it('StateArrayForeach', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/statemanagementguide/StateArrayForeach' })
        await driver.delayMs(1000);
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
       * @tc.number     : StateArrayForeach2_001
       * @tc.name       : testStateArrayForeach2
       * @tc.desc       : 测试需要使用自定义组件，配合@ObjectLink来实现观测的能力
       * @tc.size       : MediumTest
       * @tc.type       : Function
       * @tc.level      : Level 1
       */
    it('StateArrayForeach2', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/statemanagementguide/StateArrayForeach2' })
        await driver.delayMs(1000);
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });



    /*
* @tc.number     : StateArrayInit_001
* @tc.name       : testStateArrayInit
* @tc.desc       : 测试在Page中初始化定义childList的时候，也可以@State childList进行初始化的
* @tc.size       : MediumTest
* @tc.type       : Function
* @tc.level      : Level 1
*/
    it('testStateArrayInit', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/statemanagementguide/StateArrayInit' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
  });
}