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


export default function LinearLayout() {
  describe('LinearLayout', () => {
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
     * @tc.number     : ColumnLayoutExample_001
     * @tc.name       : testColumnLayoutExample
     * @tc.desc       : 测试Column布局
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testColumnLayoutExample', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/linearlayout/ColumnLayoutExample' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
     * @tc.number     : RowLayoutExample_002
     * @tc.name       : testRowLayoutExample
     * @tc.desc       : 测试Row布局
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testRowLayoutExample', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/linearlayout/RowLayoutExample' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
     * @tc.number     : ColumnLayoutJustifyContentStart_003
     * @tc.name       : testColumnLayoutJustifyContentStart
     * @tc.desc       : 测试Column布局,元素在垂直方向首端对齐
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testColumnLayoutJustifyContentStart', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/linearlayout/ColumnLayoutJustifyContentStart' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });


    /*
     * @tc.number     : ColumnLayoutJustifyContentCenter_004
     * @tc.name       : testColumnLayoutJustifyContentCenter
     * @tc.desc       : 测试Column布局,元素在垂直方向中心对齐
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testColumnLayoutJustifyContentCenter', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/linearlayout/ColumnLayoutJustifyContentCenter' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });


    /*
     * @tc.number     : ColumnLayoutJustifyContentEnd_005
     * @tc.name       : testColumnLayoutJustifyContentEnd
     * @tc.desc       : 测试Column布局,元素在垂直方向尾部对齐
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testColumnLayoutJustifyContentEnd', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/linearlayout/ColumnLayoutJustifyContentEnd' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
       * @tc.number     : ColumnLayoutJustifyContentSpaceBetween_006
       * @tc.name       : testColumnLayoutJustifyContentSpaceBetween
       * @tc.desc       : 测试Column布局,垂直方向均匀分配元素，相邻元素之间距离相同
       * @tc.size       : MediumTest
       * @tc.type       : Function
       * @tc.level      : Level 1
       */
    it('testColumnLayoutJustifyContentSpaceBetween', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/linearlayout/ColumnLayoutJustifyContentSpaceBetween' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
       * @tc.number     : ColumnLayoutJustifyContentSpaceAround_007
       * @tc.name       : testColumnLayoutJustifyContentSpaceAround
       * @tc.desc       : 测试Column布局,垂直方向均匀分配元素，相邻元素之间距离相同
       * @tc.size       : MediumTest
       * @tc.type       : Function
       * @tc.level      : Level 1
       */

    it('testColumnLayoutJustifyContentSpaceAround', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/linearlayout/ColumnLayoutJustifyContentSpaceAround' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
       * @tc.number     : ColumnLayoutJustifyContentSpaceEvenly_008
       * @tc.name       : testColumnLayoutJustifyContentSpaceEvenly
       * @tc.desc       : 测试Column布局,垂直方向均匀分配元素，相邻元素之间的距离、第一个元素与行首的间距、最后一个元素到行尾的间距都完全一样
       * @tc.size       : MediumTest
       * @tc.type       : Function
       * @tc.level      : Level 1
       */

    it('testColumnLayoutJustifyContentSpaceEvenly', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/linearlayout/ColumnLayoutJustifyContentSpaceEvenly' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
       * @tc.number     : RowLayoutJustifyContentStart_009
       * @tc.name       : testRowLayoutJustifyContentStart
       * @tc.desc       : 测试Row布局,元素在水平方向首端对齐，第一个元素与行首对齐，同时后续的元素与前一个对齐
       * @tc.size       : MediumTest
       * @tc.type       : Function
       * @tc.level      : Level 1
       */
    it('testRowLayoutJustifyContentStart', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/linearlayout/RowLayoutJustifyContentStart' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
       * @tc.number     : RowLayoutJustifyContentCenter_010
       * @tc.name       : testRowLayoutJustifyContentCenter
       * @tc.desc       : 测试Row布局,元素在水平方向中心对齐，第一个元素与行首的距离与最后一个元素与行尾距离相同
       * @tc.size       : MediumTest
       * @tc.type       : Function
       * @tc.level      : Level 1
       */
    it('testRowLayoutJustifyContentCenter', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/linearlayout/RowLayoutJustifyContentCenter' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
       * @tc.number     : RowLayoutJustifyContentEnd_011
       * @tc.name       : testRowLayoutJustifyContentEnd
       * @tc.desc       : 测试Row布局,元素在水平方向尾部对齐，最后一个元素与行尾对齐，其他元素与后一个对齐
       * @tc.size       : MediumTest
       * @tc.type       : Function
       * @tc.level      : Level 1
       */
    it('testRowLayoutJustifyContentEnd', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/linearlayout/RowLayoutJustifyContentEnd' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
       * @tc.number     : RowLayoutJustifyContentSpaceBetween_012
       * @tc.name       : testRowLayoutJustifyContentSpaceBetween
       * @tc.desc       : 测试Row布局,水平方向均匀分配元素，相邻元素之间距离相同
       * @tc.size       : MediumTest
       * @tc.type       : Function
       * @tc.level      : Level 1
       */
    it('testRowLayoutJustifyContentSpaceBetween', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/linearlayout/RowLayoutJustifyContentSpaceBetween' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
      * @tc.number     : RowLayoutJustifyContentSpaceAround_013
      * @tc.name       : testRowLayoutJustifyContentSpaceAround
      * @tc.desc       : 测试Row布局,水平方向均匀分配元素，相邻元素之间距离相同
      * @tc.size       : MediumTest
      * @tc.type       : Function
      * @tc.level      : Level 1
      */
    it('testRowLayoutJustifyContentSpaceAround', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/linearlayout/RowLayoutJustifyContentSpaceAround' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
      * @tc.number     : RowLayoutJustifyContentSpaceEvenly_014
      * @tc.name       : testRowLayoutJustifyContentSpaceEvenly
      * @tc.desc       : 测试Row布局,水平方向均匀分配元素，相邻元素之间的距离、第一个元素与行首的间距、最后一个元素到行尾的间距都完全一样
      * @tc.size       : MediumTest
      * @tc.type       : Function
      * @tc.level      : Level 1
      */
    it('testRowLayoutJustifyContentSpaceEvenly', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/linearlayout/RowLayoutJustifyContentSpaceEvenly' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
      * @tc.number     : RowLayoutHorizontalAlignStart_015
      * @tc.name       : testRowLayoutHorizontalAlignStart
      * @tc.desc       : 测试Row布局,子元素在水平方向居中对齐
      * @tc.size       : MediumTest
      * @tc.type       : Function
      * @tc.level      : Level 1
      */
    it('testRowLayoutHorizontalAlignStart', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/linearlayout/RowLayoutHorizontalAlignStart' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
      * @tc.number     : RowLayoutHorizontalAlignCenter_016
      * @tc.name       : testRowLayoutHorizontalAlignCenter
      * @tc.desc       : 测试Row布局,子元素在水平方向居中对齐
      * @tc.size       : MediumTest
      * @tc.type       : Function
      * @tc.level      : Level 1
      */
    it('testRowLayoutHorizontalAlignCenter', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/linearlayout/RowLayoutHorizontalAlignCenter' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
      * @tc.number     : RowLayoutHorizontalAlignEnd_017
      * @tc.name       : testRowLayoutHorizontalAlignEnd
      * @tc.desc       : 测试Row布局,子元素在水平方向右对齐
      * @tc.size       : MediumTest
      * @tc.type       : Function
      * @tc.level      : Level 1
      */
    it('testRowLayoutHorizontalAlignEnd', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/linearlayout/RowLayoutHorizontalAlignEnd' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
      * @tc.number     : RowLayoutVerticalAlignTop_018
      * @tc.name       : testRowLayoutVerticalAlignTop
      * @tc.desc       : 测试Row布局,子元素在垂直方向顶部对齐
      * @tc.size       : MediumTest
      * @tc.type       : Function
      * @tc.level      : Level 1
      */
    it('testRowLayoutVerticalAlignTop', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/linearlayout/RowLayoutVerticalAlignTop' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
      * @tc.number     : RowLayoutVerticalAlignCenter_019
      * @tc.name       : testRowLayoutVerticalAlignCenter
      * @tc.desc       : 测试Row布局,子元素在垂直方向居中对齐
      * @tc.size       : MediumTest
      * @tc.type       : Function
      * @tc.level      : Level 1
      */
    it('testRowLayoutVerticalAlignCenter', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/linearlayout/RowLayoutVerticalAlignCenter' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
      * @tc.number     : RowLayoutVerticalAlignBottom_020
      * @tc.name       : testRowLayoutVerticalAlignBottom
      * @tc.desc       : 测试Row布局,子元素在垂直方向底部对齐
      * @tc.size       : MediumTest
      * @tc.type       : Function
      * @tc.level      : Level 1
      */
    it('testRowLayoutVerticalAlignBottom', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/linearlayout/RowLayoutVerticalAlignBottom' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
      * @tc.number     : BlankExample_021
      * @tc.name       : testBlankExample
      * @tc.desc       : 测试Row布局,自适应拉伸
      * @tc.size       : MediumTest
      * @tc.type       : Function
      * @tc.level      : Level 1
      */
    it('testBlankExample', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/linearlayout/BlankExample' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
      * @tc.number     : LayoutWeightExample_022
      * @tc.name       : testLayoutWeightExample
      * @tc.desc       : 测试Row布局,自适应缩放
      * @tc.size       : MediumTest
      * @tc.type       : Function
      * @tc.level      : Level 1
      */
    it('testLayoutWeightExample', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/linearlayout/LayoutWeightExample' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
      * @tc.number     : WidthExample_023
      * @tc.name       : testWidthExample
      * @tc.desc       : 测试Row布局,自适应缩放
      * @tc.size       : MediumTest
      * @tc.type       : Function
      * @tc.level      : Level 1
      */
    it('testWidthExample', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/linearlayout/WidthExample' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
     * @tc.number     : ScrollVerticalExample_024
     * @tc.name       : testScrollVerticalExample
     * @tc.desc       : 测试Row布局,自适应延伸
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testScrollVerticalExample', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/linearlayout/ScrollVerticalExample' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
     * @tc.number     : ScrollHorizontalExample_025
     * @tc.name       : testScrollHorizontalExample
     * @tc.desc       : 测试Row布局,自适应延伸
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testScrollHorizontalExample', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/linearlayout/ScrollHorizontalExample' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
  });
}