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


export default function GridLayout() {
  describe('GridLayout', () => {
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
     * @tc.number     : GridLayoutReference_001
     * @tc.name       : testGridLayoutReference
     * @tc.desc       : 测试栅格布局，通过reference设置断点切换参考物
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testGridLayoutReference', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/gridlayout/GridLayoutReference' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
     * @tc.number     : GridLayoutColumns_002
     * @tc.name       : testGridLayoutColumns
     * @tc.desc       : 测试栅格布局，通过columns设置栅格布局的总列数
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testGridLayoutColumns', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/gridlayout/GridLayoutColumns' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
     * @tc.number     : GridLayoutColumnsToFour_003
     * @tc.name       : testGridLayoutColumnsToFour
     * @tc.desc       : 测试栅格布局，通过columns设置栅格布局的总列数
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testGridLayoutColumnsToFour', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/gridlayout/GridLayoutColumnsToFour' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
     * @tc.number     : GridLayoutColumnsToEight_004
     * @tc.name       : testGridLayoutColumnsToEight
     * @tc.desc       : 测试栅格布局，通过columns设置栅格布局的总列数
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testGridLayoutColumnsToEight', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/gridlayout/GridLayoutColumnsToEight' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
     * @tc.number     : GridLayoutColumnOption_005
     * @tc.name       : testGridLayoutColumnOption
     * @tc.desc       : 测试栅格布局，为GridRowColumnOption时，支持不同尺寸设备的栅格列数设置
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testGridLayoutColumnOption', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/gridlayout/GridLayoutColumnOption' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
     * @tc.number     : GridLayoutDirectionRow_006
     * @tc.name       : testGridLayoutDirectionRow
     * @tc.desc       : 测试栅格布局，子组件默认从左往右排列
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testGridLayoutDirectionRow', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/gridlayout/GridLayoutDirectionRow' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
     * @tc.number     : GridLayoutDirectionRowReverse_007
     * @tc.name       : testGridLayoutDirectionRowReverse
     * @tc.desc       : 测试栅格布局，子组件从右往左排列
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testGridLayoutDirectionRowReverse', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/gridlayout/GridLayoutDirectionRowReverse' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
    * @tc.number     : GridLayoutGutterToNumber_008
    * @tc.name       : testGridLayoutGutterToNumber
    * @tc.desc       : 测试栅格布局，当gutter类型为number时，同时设置栅格子组件间水平和垂直方向边距且相等
    * @tc.size       : MediumTest
    * @tc.type       : Function
    * @tc.level      : Level 1
    */
    it('testGridLayoutGutterToNumber', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/gridlayout/GridLayoutGutterToNumber' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
     * @tc.number     : GridLayoutGutterOption_009
     * @tc.name       : testGridLayoutGutterOption
     * @tc.desc       : 测试栅格布局，当gutter类型为GutterOption时，单独设置栅格子组件水平垂直边距，x属性为水平方向间距，y为垂直方向间距
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testGridLayoutGutterOption', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/gridlayout/GridLayoutGutterOption' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
     * @tc.number     : GridColSpan_010
     * @tc.name       : testGridColSpan
     * @tc.desc       : 测试栅格布局，子组件GridCol设置span
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testGridColSpan', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/gridlayout/GridColSpan' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
     * @tc.number     : GridColOffset_011
     * @tc.name       : testGridColOffset
     * @tc.desc       : 测试栅格布局，子组件GridCol设置offset
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testGridColOffset', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/gridlayout/GridColOffset' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
     * @tc.number     : GridColOrder_012
     * @tc.name       : testGridColOrder
     * @tc.desc       : 测试栅格布局，子组件GridCol设置order
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testGridColOrder', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/gridlayout/GridColOrder' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
     * @tc.number     : GridColSpanToNumber_013
     * @tc.name       : testGridColSpanToNumber
     * @tc.desc       : 测试栅格布局，当span类型为number时，子组件在所有尺寸设备下占用的列数相同
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testGridColSpanToNumber', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/gridlayout/GridColSpanToNumber' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
     * @tc.number     : GridColSpanToOption_014
     * @tc.name       : testGridColSpanToOption
     * @tc.desc       : 测试栅格布局，当span类型为GridColColumnOption时,支持不同尺寸设备中子组件所占列数设置
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testGridColSpanToOption', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/gridlayout/GridColSpanToOption' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
     * @tc.number     : GridColOffsetToNumber_015
     * @tc.name       : testGridColOffsetToNumber
     * @tc.desc       : 测试栅格布局，当offset类型为number时，子组件偏移相同列数
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testGridColOffsetToNumber', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/gridlayout/GridColOffsetToNumber' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
     * @tc.number     : GridColOffsetToOption_016
     * @tc.name       : testGridColOffsetToOption
     * @tc.desc       : 测试栅格布局，当offset类型为GridColColumnOption时，支持不同尺寸设备中子组件所占列数设置
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testGridColOffsetToOption', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/gridlayout/GridColOffsetToOption' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
     * @tc.number     : GridColOrderToNumber_017
     * @tc.name       : testGridColOrderToNumber
     * @tc.desc       : 测试栅格布局，当order类型为number时，子组件在任何尺寸下排序次序一致
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testGridColOrderToNumber', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/gridlayout/GridColOrderToNumber' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
     * @tc.number     : GridColOrderToOption_018
     * @tc.name       : testGridColOrderToOption
     * @tc.desc       : 测试栅格布局，当order类型为GridColColumnOption时，支持不同尺寸设备中子组件排序次序设置
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testGridColOrderToOption', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/gridlayout/GridColOrderToOption' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
     * @tc.number     : GridRowExample_019
     * @tc.name       : testGridRowExample
     * @tc.desc       : 测试栅格布局，栅格组件的嵌套使用
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testGridRowExample', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/gridlayout/GridRowExample' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
  });
}