/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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


export default function DynamicLayoutTest() {
  describe('DynamicLayoutTest', () => {
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
     * @tc.number     : CreateDynamicLayout_001
     * @tc.name       : testCreateDynamicLayout
     * @tc.desc       : 测试创建动态布局
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testCreateDynamicLayout', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/basic/CreateDynamicLayout' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
     * @tc.number     : CustomLayoutBasic_002
     * @tc.name       : testCustomLayoutBasic
     * @tc.desc       : 测试自定义布局算法实现指导
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testCustomLayoutBasic', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/customlayout/CustomLayoutBasic' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
     * @tc.number     : CustomLayoutIndex_003
     * @tc.name       : testCustomLayoutIndex
     * @tc.desc       : 测试自定义布局索引页
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testCustomLayoutIndex', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/customlayout/CustomLayoutIndex' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
     * @tc.number     : CustomGridLayout_004
     * @tc.name       : testCustomGridLayout
     * @tc.desc       : 测试自定义网格布局
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testCustomGridLayout', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/customlayout/GridLayout' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
     * @tc.number     : TagCloudLayout_005
     * @tc.name       : testTagCloudLayout
     * @tc.desc       : 测试自定义标签云布局
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testTagCloudLayout', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/customlayout/TagCloudLayout' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
     * @tc.number     : WaterFlowLayout_006
     * @tc.name       : testWaterFlowLayout
     * @tc.desc       : 测试自定义瀑布流布局
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testWaterFlowLayout', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/customlayout/WaterFlowLayout' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
     * @tc.number     : GridLayoutAlgorithm_007
     * @tc.name       : testGridLayoutAlgorithm
     * @tc.desc       : 测试网格布局算法
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testGridLayoutAlgorithm', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/gridlayout/GridLayoutAlgorithm' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
     * @tc.number     : ColumnLayoutAlgorithm_008
     * @tc.name       : testColumnLayoutAlgorithm
     * @tc.desc       : 测试垂直线性布局算法
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testColumnLayoutAlgorithm', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/linearlayout/ColumnLayoutAlgorithm' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
     * @tc.number     : RowLayoutAlgorithm_009
     * @tc.name       : testRowLayoutAlgorithm
     * @tc.desc       : 测试水平线性布局算法
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testRowLayoutAlgorithm', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/linearlayout/RowLayoutAlgorithm' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
     * @tc.number     : ChangeAlgorithmProperties_010
     * @tc.name       : testChangeAlgorithmProperties
     * @tc.desc       : 测试通过修改算法属性触发重新布局
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testChangeAlgorithmProperties', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/responsivelayout/ChangeAlgorithmProperties' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
     * @tc.number     : ChangeLayoutAlgorithm_011
     * @tc.name       : testChangeLayoutAlgorithm
     * @tc.desc       : 测试通过状态变量切换布局算法
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testChangeLayoutAlgorithm', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/responsivelayout/ChangeLayoutAlgorithm' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
     * @tc.number     : ChangeLayoutWithConditionVariable_012
     * @tc.name       : testChangeLayoutWithConditionVariable
     * @tc.desc       : 测试通过条件运算符切换布局算法
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testChangeLayoutWithConditionVariable', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/responsivelayout/ChangeLayoutWithConditionVariable' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
     * @tc.number     : ChangeLayoutWithMediaQuery_013
     * @tc.name       : testChangeLayoutWithMediaQuery
     * @tc.desc       : 测试响应式布局算法切换
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testChangeLayoutWithMediaQuery', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/responsivelayout/ChangeLayoutWithMediaQuery' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
     * @tc.number     : ReserveChildState_014
     * @tc.name       : testReserveChildState
     * @tc.desc       : 测试布局切换保持子组件状态
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testReserveChildState', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/responsivelayout/ReserveChildState' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
     * @tc.number     : ResponsiveLayoutIndex_015
     * @tc.name       : testResponsiveLayoutIndex
     * @tc.desc       : 测试响应式布局索引页
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testResponsiveLayoutIndex', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/responsivelayout/ResponsiveLayoutIndex' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
     * @tc.number     : StackLayoutAlgorithm_016
     * @tc.name       : testStackLayoutAlgorithm
     * @tc.desc       : 测试堆叠布局算法
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testStackLayoutAlgorithm', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/stacklayout/StackLayoutAlgorithm' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
  });
}
