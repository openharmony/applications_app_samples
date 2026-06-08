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


export default function ContainerReaderTest() {
  describe('ContainerReaderTest', () => {
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
     * @tc.number     : FillTheSpace_001
     * @tc.name       : testFillTheSpace
     * @tc.desc       : 测试占满空间
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testFillTheSpace', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/layoutSpecifications/FillTheSpace' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
     * @tc.number     : DivideRemainingSpace_002
     * @tc.name       : testDivideRemainingSpace
     * @tc.desc       : 测试占满剩余空间
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testDivideRemainingSpace', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/layoutSpecifications/DivideRemainingSpace' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
     * @tc.number     : DivideRemainingSpaceEqually_003
     * @tc.name       : testDivideRemainingSpaceEqually
     * @tc.desc       : 测试平分剩余空间
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testDivideRemainingSpaceEqually', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/layoutSpecifications/DivideRemainingSpaceEqually' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
     * @tc.number     : LayoutSpecificationsIndex_004
     * @tc.name       : testLayoutSpecificationsIndex
     * @tc.desc       : 测试布局规格
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testLayoutSpecificationsIndex', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/layoutSpecifications/LayoutSpecificationsIndex' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
     * @tc.number     : DevelopmentSteps_005
     * @tc.name       : testDevelopmentSteps
     * @tc.desc       : 测试开发步骤的demo
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testDevelopmentSteps', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/developmentSteps/DevelopmentSteps' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
     * @tc.number     : CombineWithLayoutWeight_006
     * @tc.name       : testCombineWithLayoutWeight
     * @tc.desc       : 测试结合layoutWeight使用
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testCombineWithLayoutWeight', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/combineWithFlexRowColumn/CombineWithLayoutWeight' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
     * @tc.number     : CombineWithLowDisplayPriority_007
     * @tc.name       : testCombineWithLowDisplayPriority
     * @tc.desc       : 测试displayPriority控制显示优先级
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testCombineWithLowDisplayPriority', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/combineWithFlexRowColumn/CombineWithLowDisplayPriority' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
     * @tc.number     : CombineWithHighDisplayPriority_008
     * @tc.name       : testCombineWithHighDisplayPriority
     * @tc.desc       : 测试displayPriority控制显示优先级
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testCombineWithHighDisplayPriority', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/combineWithFlexRowColumn/CombineWithHighDisplayPriority' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
     * @tc.number     : CombineWithFlexShrink_009
     * @tc.name       : testCombineWithFlexShrink
     * @tc.desc       : 测试通过flexShrink控制收缩比例
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testCombineWithFlexShrink', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/combineWithFlexRowColumn/CombineWithFlexShrink' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
     * @tc.number     : CombineWithFlexGrow_010
     * @tc.name       : testCombineWithFlexGrow
     * @tc.desc       : 测试通过flexGrow控制扩展比例
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testCombineWithFlexGrow', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/combineWithFlexRowColumn/CombineWithFlexGrow' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
     * @tc.number     : CombineWithFlexColumnRowIndex_011
     * @tc.name       : testCombineWithFlexColumnRowIndex
     * @tc.desc       : 测试结合flex、column、row使用
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testCombineWithFlexColumnRowIndex', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/combineWithFlexRowColumn/CombineWithFlexColumnRowIndex' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
     * @tc.number     : IndependentBreakpoints_012
     * @tc.name       : testIndependentBreakpoints
     * @tc.desc       : 测试独立断点设置
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testIndependentBreakpoints', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/developmentDemo/IndependentBreakpoints' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
     * @tc.number     : GridComponentAdaptiveColumnSettings_013
     * @tc.name       : testGridComponentAdaptiveColumnSettings
     * @tc.desc       : 测试Grid的自适应列数设置
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testGridComponentAdaptiveColumnSettings', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/developmentDemo/GridComponentAdaptiveColumnSettings' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
     * @tc.number     : CustomComponentAdaptiveLayout_014
     * @tc.name       : testCustomComponentAdaptiveLayout
     * @tc.desc       : 测试自定义组件自适应布局
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testCustomComponentAdaptiveLayout', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/developmentDemo/CustomComponentAdaptiveLayout' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
     * @tc.number     : LeftOrRightSplitLayout_015
     * @tc.name       : testLeftOrRightSplitLayout
     * @tc.desc       : 测试自适应左右分栏
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testLeftOrRightSplitLayout', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/developmentDemo/LeftOrRightSplitLayout' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
  });
}
