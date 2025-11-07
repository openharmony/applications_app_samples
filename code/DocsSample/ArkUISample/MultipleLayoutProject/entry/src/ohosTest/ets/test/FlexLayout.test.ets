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


export default function FlexLayout() {
  describe('FlexLayout', () => {
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
     * @tc.number     : FlexDirectionRow_001
     * @tc.name       : testFlexDirectionRow
     * @tc.desc       : 测试Flex布局,主轴为水平方向，子元素从起始端沿着水平方向开始排布
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testFlexDirectionRow', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/flexlayout/FlexDirectionRow' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
     * @tc.number     : FlexDirectionRowReverse_002
     * @tc.name       : testFlexDirectionRowReverse
     * @tc.desc       : 测试Flex布局,主轴为水平方向，子元素从终点端沿着FlexDirection.Row相反的方向开始排布
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testFlexDirectionRowReverse', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/flexlayout/FlexDirectionRowReverse' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
     * @tc.number     : FlexDirectionColumn_003
     * @tc.name       : testFlexDirectionColumn
     * @tc.desc       : 测试Flex布局,主轴为垂直方向，子元素从起始端沿着垂直方向开始排布
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testFlexDirectionColumn', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/flexlayout/FlexDirectionColumn' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });


    /*
     * @tc.number     : FlexDirectionColumnReverse_004
     * @tc.name       : testFlexDirectionColumnReverse
     * @tc.desc       : 测试Flex布局,主轴为垂直方向，子元素从终点端沿着FlexDirection.Column相反的方向开始排布
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testFlexDirectionColumnReverse', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/flexlayout/FlexDirectionColumnReverse' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });


    /*
     * @tc.number     : FlexWrapNoWrap_005
     * @tc.name       : testFlexWrapNoWrap
     * @tc.desc       : 测试Flex布局,不换行,如果子元素的宽度总和大于父元素的宽度，则子元素会被压缩宽度
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testFlexWrapNoWrap', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/flexlayout/FlexWrapNoWrap' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
       * @tc.number     : FlexWrapWrap_006
       * @tc.name       : testFlexWrapWrap
       * @tc.desc       : 测试Flex布局,换行，每一行子元素按照主轴方向排列
       * @tc.size       : MediumTest
       * @tc.type       : Function
       * @tc.level      : Level 1
       */
    it('testFlexWrapWrap', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/flexlayout/FlexWrapWrap' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
       * @tc.number     : FlexWrapWrapReverse_007
       * @tc.name       : testFlexWrapWrapReverse
       * @tc.desc       : 测试Flex布局,换行，每一行子元素按照主轴反方向排列
       * @tc.size       : MediumTest
       * @tc.type       : Function
       * @tc.level      : Level 1
       */

    it('testFlexWrapWrapReverse', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/flexlayout/FlexWrapWrapReverse' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
       * @tc.number     : FlexAlignStart_008
       * @tc.name       : testFlexAlignStart
       * @tc.desc       : 测试Flex布局,元素在主轴方向起始端对齐， 第一个子元素与父元素边沿对齐，其他元素与前一个元素对齐
       * @tc.size       : MediumTest
       * @tc.type       : Function
       * @tc.level      : Level 1
       */

    it('testFlexAlignStart', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/flexlayout/FlexAlignStart' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
       * @tc.number     : FlexAlignCenter_009
       * @tc.name       : testFlexAlignCenter
       * @tc.desc       : 测试Flex布局,子元素在主轴方向居中对齐
       * @tc.size       : MediumTest
       * @tc.type       : Function
       * @tc.level      : Level 1
       */
    it('testFlexAlignCenter', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/flexlayout/FlexAlignCenter' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
       * @tc.number     : FlexAlignEnd_010
       * @tc.name       : testFlexAlignEnd
       * @tc.desc       : 测试Flex布局,子元素在主轴方向终点端对齐，最后一个子元素与父元素边沿对齐，其他元素与后一个元素对齐
       * @tc.size       : MediumTest
       * @tc.type       : Function
       * @tc.level      : Level 1
       */
    it('testFlexAlignEnd', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/flexlayout/FlexAlignEnd' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
       * @tc.number     : FlexAlignSpaceBetween_011
       * @tc.name       : testFlexAlignSpaceBetween
       * @tc.desc       : 测试Flex布局,Flex主轴方向均匀分配弹性元素，相邻子元素之间距离相同
       * @tc.size       : MediumTest
       * @tc.type       : Function
       * @tc.level      : Level 1
       */
    it('testFlexAlignSpaceBetween', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/flexlayout/FlexAlignSpaceBetween' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
       * @tc.number     : FlexAlignSpaceAround_012
       * @tc.name       : testFlexAlignSpaceAround
       * @tc.desc       : 测试Flex布局,flex主轴方向均匀分配弹性元素，相邻子元素之间距离相同
       * @tc.size       : MediumTest
       * @tc.type       : Function
       * @tc.level      : Level 1
       */
    it('testFlexAlignSpaceAround', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/flexlayout/FlexAlignSpaceAround' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
      * @tc.number     : FlexAlignSpaceEvenly_013
      * @tc.name       : testFlexAlignSpaceEvenly
      * @tc.desc       : 测试Flex布局,Flex主轴方向元素等间距布局
      * @tc.size       : MediumTest
      * @tc.type       : Function
      * @tc.level      : Level 1
      */
    it('testFlexAlignSpaceEvenly', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/flexlayout/FlexAlignSpaceEvenly' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
      * @tc.number     : FlexItemAlignAuto_014
      * @tc.name       : testFlexItemAlignAuto
      * @tc.desc       : 测试Flex布局,使用Flex容器中默认配置
      * @tc.size       : MediumTest
      * @tc.type       : Function
      * @tc.level      : Level 1
      */
    it('testFlexItemAlignAuto', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/flexlayout/FlexItemAlignAuto' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
      * @tc.number     : FlexItemAlignStart_015
      * @tc.name       : testFlexItemAlignStart
      * @tc.desc       : 测试Flex布局,交叉轴方向首部对齐
      * @tc.size       : MediumTest
      * @tc.type       : Function
      * @tc.level      : Level 1
      */
    it('testFlexItemAlignStart', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/flexlayout/FlexItemAlignStart' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
      * @tc.number     : FlexItemAlignCenter_016
      * @tc.name       : testFlexItemAlignCenter
      * @tc.desc       : 测试Flex布局,交叉轴方向居中对齐
      * @tc.size       : MediumTest
      * @tc.type       : Function
      * @tc.level      : Level 1
      */
    it('testFlexItemAlignCenter', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/flexlayout/FlexItemAlignCenter' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
      * @tc.number     : FlexItemAlignEnd_017
      * @tc.name       : testFlexItemAlignEnd
      * @tc.desc       : 测试Flex布局,交叉轴方向底部对齐
      * @tc.size       : MediumTest
      * @tc.type       : Function
      * @tc.level      : Level 1
      */
    it('testFlexItemAlignEnd', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/flexlayout/FlexItemAlignEnd' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
      * @tc.number     : FlexItemAlignStretch_018
      * @tc.name       : testFlexItemAlignStretch
      * @tc.desc       : 测试Flex布局,交叉轴方向拉伸填充，在未设置尺寸时，拉伸到容器尺寸
      * @tc.size       : MediumTest
      * @tc.type       : Function
      * @tc.level      : Level 1
      */
    it('testFlexItemAlignStretch', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/flexlayout/FlexItemAlignStretch' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
      * @tc.number     : FlexItemAlignBaseline_019
      * @tc.name       : testFlexItemAlignBaseline
      * @tc.desc       : 测试Flex布局,交叉轴方向文本基线对齐
      * @tc.size       : MediumTest
      * @tc.type       : Function
      * @tc.level      : Level 1
      */
    it('testFlexItemAlignBaseline', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/flexlayout/FlexItemAlignBaseline' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
      * @tc.number     : FlexAlignSelf_020
      * @tc.name       : testFlexAlignSelf
      * @tc.desc       : 测试Flex布局,子元素设置交叉轴对齐
      * @tc.size       : MediumTest
      * @tc.type       : Function
      * @tc.level      : Level 1
      */
    it('testFlexAlignSelf', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/flexlayout/FlexAlignSelf' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
      * @tc.number     : FlexAlignCenterFlexAlignStart_021
      * @tc.name       : testFlexAlignCenterFlexAlignStart
      * @tc.desc       : 测试Flex布局,子元素各行与交叉轴起点对齐
      * @tc.size       : MediumTest
      * @tc.type       : Function
      * @tc.level      : Level 1
      */
    it('testFlexAlignCenterFlexAlignStart', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/flexlayout/FlexAlignCenterFlexAlignStart' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
      * @tc.number     : FlexAlignCenterFlexAlignCenter_022
      * @tc.name       : testFlexAlignCenterFlexAlignCenter
      * @tc.desc       : 测试Flex布局,子元素各行在交叉轴方向居中对齐
      * @tc.size       : MediumTest
      * @tc.type       : Function
      * @tc.level      : Level 1
      */
    it('testFlexAlignCenterFlexAlignCenter', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/flexlayout/FlexAlignCenterFlexAlignCenter' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
      * @tc.number     : FlexAlignCenterFlexAlignEnd_023
      * @tc.name       : testFlexAlignCenterFlexAlignEnd
      * @tc.desc       : 测试Flex布局,子元素各行与交叉轴终点对齐
      * @tc.size       : MediumTest
      * @tc.type       : Function
      * @tc.level      : Level 1
      */
    it('testFlexAlignCenterFlexAlignEnd', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/flexlayout/FlexAlignCenterFlexAlignEnd' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
     * @tc.number     : FlexAlignCenterFlexAlignSpaceBetween_024
     * @tc.name       : testFlexAlignCenterFlexAlignSpaceBetween
     * @tc.desc       : 测试Flex布局,子元素各行与交叉轴两端对齐，各行间垂直间距平均分布
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testFlexAlignCenterFlexAlignSpaceBetween', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/flexlayout/FlexAlignCenterFlexAlignSpaceBetween' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
     * @tc.number     : FlexAlignCenterFlexAlignSpaceAround_025
     * @tc.name       : testFlexAlignCenterFlexAlignSpaceAround
     * @tc.desc       : 测试Flex布局,子元素各行间距相等，是元素首尾行与交叉轴两端距离的两倍
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testFlexAlignCenterFlexAlignSpaceAround', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/flexlayout/FlexAlignCenterFlexAlignSpaceAround' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
     * @tc.number     : FlexAlignCenterFlexAlignSpaceEvenly_026
     * @tc.name       : testFlexAlignCenterFlexAlignSpaceEvenly
     * @tc.desc       : 测试Flex布局,子元素各行间距，子元素首尾行与交叉轴两端距离都相等
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testFlexAlignCenterFlexAlignSpaceEvenly', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/flexlayout/FlexAlignCenterFlexAlignSpaceEvenly' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
     * @tc.number     : FlexFlexBasis_027
     * @tc.name       : testFlexBasis
     * @tc.desc       : 测试Flex布局,设置子元素在父容器主轴方向上的基准尺寸
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testFlexBasis', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/flexlayout/FlexBasis' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
     * @tc.number     : FlexGrow_028
     * @tc.name       : testFlexGrow
     * @tc.desc       : 测试Flex布局,设置父容器的剩余空间分配给此属性所在组件的比例
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testFlexGrow', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/flexlayout/FlexGrow' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
     * @tc.number     : FlexShrink_029
     * @tc.name       : testFlexShrink
     * @tc.desc       : 测试Flex布局,当父容器空间不足时，子元素的压缩比例
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testFlexShrink', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/flexlayout/FlexShrink' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
     * @tc.number     : FlexExample_030
     * @tc.name       : testFlexExample
     * @tc.desc       : 测试Flex布局,多种子组件场景示例
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testFlexExample', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/flexlayout/FlexExample' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
  });
}