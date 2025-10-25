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

import { describe, it, expect, beforeAll } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
const DOMAIN = 0x0001;
const TAG = 'MyApp';
const delegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let driver: Driver;
let want: Want;
export default function Index2Test() {
  describe('Index2Test', () => {
    beforeAll(async () => {
      // 启动应用
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      driver = Driver.create();
      await driver.delayMs(1000);
      // 验证当前页面是否正确
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      hilog.info(DOMAIN, TAG, 'get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    });
    /**
     * @tc.number ImageTest_001
     * @tc.name testHomePageLoad
     * @tc.desc 测试首页加载是否成功
     */
    it('testHomePageLoad', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'ImageTest: testHomePageLoad begin');
      // 验证标题存在
      const title = await driver.findComponent(ON.text('Show Image'));
      expect(title === null).assertFalse();
      // 验证列表存在
      const list = await driver.findComponent(ON.type('List'));
      expect(list === null).assertFalse();
      hilog.info(DOMAIN, TAG, 'ImageTest: testHomePageLoad end');
      done();
    });
    /**
     * @tc.number ImageTest_002
     * @tc.name testLoadingResourcesPage
     * @tc.desc 测试LoadingResources页面加载和返回功能
     */
    it('testLoadingResourcesPage', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'ImageTest: testLoadingResourcesPage begin');
      // 直接查找并点击，不额外等待首页
      const targetItem = await driver.findComponent(ON.text('LoadingResources'));
      if (targetItem !== null) {
        await targetItem.click();
        hilog.info(DOMAIN, TAG, 'ImageTest: Clicked LoadingResources item');
        // 等待目标页面加载
        await driver.delayMs(2000);
        // 返回
        await driver.pressBack();
        await driver.delayMs(1000);
        hilog.info(DOMAIN, TAG, 'ImageTest: Completed basic flow successfully');
      }
      hilog.info(DOMAIN, TAG, 'ImageTest: testLoadingResourcesPage end');
      done();
    });
    /**
     * @tc.number ImageTest_003
     * @tc.name LoadImageResources
     * @tc.desc 测试LoadImageResources页面加载和返回功能，包括选择照片
     */
    it('LoadImageResources', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'ImageTest: LoadImageResources begin');
      try {
        // 点击进入LoadImageResources页面
        const targetItem = await driver.findComponent(ON.text('LoadImageResources'));
        if (targetItem !== null) {
          await targetItem.click();
          hilog.info(DOMAIN, TAG, 'ImageTest: Clicked LoadImageResources item');
          // 1. 查找并点击第一个单选框
          const checkboxes = await driver.findComponents(ON.type('Checkbox'));
          if (checkboxes && checkboxes.length > 0) {
            await checkboxes[0].click();
            hilog.info(DOMAIN, TAG, 'ImageTest: Selected first checkbox');
            // 2. 查找并点击完成按钮
            await driver.delayMs(1000);
            const doneButton = await driver.findComponent(ON.text('完成'));
            if (doneButton !== null) {
              await doneButton.click();
              hilog.info(DOMAIN, TAG, 'ImageTest: Clicked done button');
            } else {
              // 备选完成按钮文本
              const confirmButton = await driver.findComponent(ON.text('确认'));
              if (confirmButton !== null) await confirmButton.click();
            }
            // 3. 等待照片加载并查看
            await driver.delayMs(2000); // 额外等待2秒查看效果
          } else {
            hilog.info(DOMAIN, TAG, 'ImageTest: No checkboxes found in photo picker');
          }
          // 返回首页
          await driver.pressBack();
          await driver.delayMs(1000);
          hilog.info(DOMAIN, TAG, 'ImageTest: Completed LoadImageResources flow successfully');
        }
      } catch (error) {
        hilog.info(DOMAIN, TAG, `ImageTest: LoadImageResources error - ${error.message}`);
      }
      hilog.info(DOMAIN, TAG, 'ImageTest: LoadImageResources end');
      done();
    });
    /**
     * @tc.number ImageTest_004
     * @tc.name MultimediaPixelArt
     * @tc.desc 测试MultimediaPixelArt页面加载和返回功能
     */
    it('MultimediaPixelArt', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'ImageTest: MultimediaPixelArt begin');
      // 直接查找并点击，不额外等待首页
      const targetItem = await driver.findComponent(ON.text('MultimediaPixelArt'));
      if (targetItem !== null) {
        await targetItem.click();
        hilog.info(DOMAIN, TAG, 'ImageTest: Clicked MultimediaPixelArt item');
        // 等待目标页面加载
        await driver.delayMs(4000);
        // 返回
        await driver.pressBack();
        await driver.delayMs(1000);
        hilog.info(DOMAIN, TAG, 'ImageTest: Completed basic flow successfully');
      }
      hilog.info(DOMAIN, TAG, 'ImageTest: MultimediaPixelArt end');
      done();
    });
    /**
     * @tc.number ImageTest_005
     * @tc.name DrawableDescriptor
     * @tc.desc 测试DrawableDescriptor页面加载和返回功能，包括向下滑动
     */
    it('DrawableDescriptor', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'ImageTest: DrawableDescriptor begin');
      // 直接查找并点击，不额外等待首页
      const targetItem = await driver.findComponent(ON.text('DrawableDescriptor'));
      if (targetItem !== null) {
        await targetItem.click();
        hilog.info(DOMAIN, TAG, 'ImageTest: Clicked DrawableDescriptor item');
        // 等待目标页面加载
        await driver.delayMs(2000);
        // 返回
        await driver.pressBack();
        await driver.delayMs(2000);
        // 使用 swipe 方法向下滑动
        await driver.swipe(500, 1000, 500, 200, 100);
        hilog.info(DOMAIN, TAG, 'ImageTest: Completed basic flow successfully');
      }
      hilog.info(DOMAIN, TAG, 'ImageTest: DrawableDescriptor end');
      done();
    });
    /**
     * @tc.number ImageTest_006
     * @tc.name DisplayVectorDiagram
     * @tc.desc 测试DisplayVectorDiagram页面加载和返回功能
     */
    it('DisplayVectorDiagram', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'ImageTest: DisplayVectorDiagram begin');
      // 直接查找并点击，不额外等待首页
      const targetItem = await driver.findComponent(ON.text('DisplayVectorDiagram'));
      if (targetItem !== null) {
        await targetItem.click();
        hilog.info(DOMAIN, TAG, 'ImageTest: Clicked DisplayVectorDiagram item');
        // 等待目标页面加载
        await driver.delayMs(2000);
        // 返回
        await driver.pressBack();
        await driver.delayMs(1000);
        hilog.info(DOMAIN, TAG, 'ImageTest: Completed basic flow successfully');
      }
      hilog.info(DOMAIN, TAG, 'ImageTest: DisplayVectorDiagram end');
      done();
    });
    /**
     * @tc.number ImageTest_007
     * @tc.name SetImageZoomType
     * @tc.desc 测试SetImageZoomType页面加载和返回功能
     */
    it('SetImageZoomType', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'ImageTest: SetImageZoomType begin');
      // 直接查找并点击，不额外等待首页
      const targetItem = await driver.findComponent(ON.text('SetImageZoomType'));
      if (targetItem !== null) {
        await targetItem.click();
        hilog.info(DOMAIN, TAG, 'ImageTest: Clicked SetImageZoomType item');
        // 等待目标页面加载
        await driver.delayMs(2000);
        // 返回
        await driver.pressBack();
        await driver.delayMs(2000);
        // 使用 swipe 方法向下滑动
        await driver.swipe(500, 1000, 500, 200, 100);
        hilog.info(DOMAIN, TAG, 'ImageTest: Completed basic flow successfully');
      }
      hilog.info(DOMAIN, TAG, 'ImageTest: SetImageZoomType end');
      done();
    });
    /**
     * @tc.number ImageTest_008
     * @tc.name ImageInterpolation
     * @tc.desc 测试ImageInterpolation页面加载和返回功能
     */
    it('ImageInterpolation', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'ImageTest: ImageInterpolation begin');
      // 直接查找并点击，不额外等待首页
      const targetItem = await driver.findComponent(ON.text('ImageInterpolation'));
      if (targetItem !== null) {
        await targetItem.click();
        hilog.info(DOMAIN, TAG, 'ImageTest: Clicked ImageInterpolation item');
        // 等待目标页面加载
        await driver.delayMs(2000);
        // 返回
        await driver.pressBack();
        await driver.delayMs(2000);
        // 使用 swipe 方法向下滑动
        await driver.swipe(500, 1000, 500, 200, 100);
        hilog.info(DOMAIN, TAG, 'ImageTest: Completed basic flow successfully');
      }
      hilog.info(DOMAIN, TAG, 'ImageTest: ImageInterpolation end');
      done();
    });
    /**
     * @tc.number ImageTest_009
     * @tc.name SetImageRepetitionStyle
     * @tc.desc 测试SetImageRepetitionStyle页面加载和返回功能
     */
    it('SetImageRepetitionStyle', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'ImageTest: SetImageRepetitionStyle begin');
      // 直接查找并点击，不额外等待首页
      const targetItem = await driver.findComponent(ON.text('SetImageRepetitionStyle'));
      if (targetItem !== null) {
        await targetItem.click();
        hilog.info(DOMAIN, TAG, 'ImageTest: Clicked SetImageRepetitionStyle item');
        // 等待目标页面加载
        await driver.delayMs(2000);
        // 返回
        await driver.pressBack();
        await driver.delayMs(1000);
        hilog.info(DOMAIN, TAG, 'ImageTest: Completed basic flow successfully');
      }
      hilog.info(DOMAIN, TAG, 'ImageTest: SetImageRepetitionStyle end');
      done();
    });
    /**
     * @tc.number ImageTest_010
     * @tc.name SetImageRenderingMode
     * @tc.desc 测试SetImageRenderingMode页面加载和返回功能
     */
    it('SetImageRenderingMode', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'ImageTest: SetImageRenderingMode begin');
      // 直接查找并点击，不额外等待首页
      const targetItem = await driver.findComponent(ON.text('SetImageRenderingMode'));
      if (targetItem !== null) {
        await targetItem.click();
        hilog.info(DOMAIN, TAG, 'ImageTest: Clicked SetImageRenderingMode item');
        // 等待目标页面加载
        await driver.delayMs(2000);
        // 返回
        await driver.pressBack();
        await driver.delayMs(1000);
        hilog.info(DOMAIN, TAG, 'ImageTest: Completed basic flow successfully');
      }
      hilog.info(DOMAIN, TAG, 'ImageTest: SetImageRenderingMode end');
      done();
    });
    /**
     * @tc.number ImageTest_011
     * @tc.name SetImageDecodingSize
     * @tc.desc 测试SetImageDecodingSize页面加载和返回功能
     */
    it('SetImageDecodingSize', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'ImageTest: SetImageDecodingSize begin');
      // 直接查找并点击，不额外等待首页
      const targetItem = await driver.findComponent(ON.text('SetImageDecodingSize'));
      if (targetItem !== null) {
        await targetItem.click();
        hilog.info(DOMAIN, TAG, 'ImageTest: Clicked SetImageDecodingSize item');
        // 等待目标页面加载
        await driver.delayMs(2000);
        // 返回
        await driver.pressBack();
        await driver.delayMs(2000);
        // 使用 swipe 方法向下滑动
        await driver.swipe(500, 1000, 500, 200, 100);
        hilog.info(DOMAIN, TAG, 'ImageTest: Completed basic flow successfully');
      }
      hilog.info(DOMAIN, TAG, 'ImageTest: SetImageDecodingSize end');
      done();
    });
    /**
     * @tc.number ImageTest_012
     * @tc.name AddFilterEffectsToImages
     * @tc.desc 测试AddFilterEffectsToImages页面加载和返回功能
     */
    it('AddFilterEffectsToImages', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'ImageTest: AddFilterEffectsToImages begin');
      // 直接查找并点击，不额外等待首页
      const targetItem = await driver.findComponent(ON.text('AddFilterEffectsToImages'));
      if (targetItem !== null) {
        await targetItem.click();
        hilog.info(DOMAIN, TAG, 'ImageTest: Clicked AddFilterEffectsToImages item');
        // 等待目标页面加载
        await driver.delayMs(2000);
        // 返回
        await driver.pressBack();
        await driver.delayMs(1000);
        hilog.info(DOMAIN, TAG, 'ImageTest: Completed basic flow successfully');
      }
      hilog.info(DOMAIN, TAG, 'ImageTest: AddFilterEffectsToImages end');
      done();
    });
    /**
     * @tc.number ImageTest_013
     * @tc.name EventCall
     * @tc.desc 测试EventCall页面加载和返回功能
     */
    it('EventCall', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'ImageTest: EventCall begin');
      // 直接查找并点击，不额外等待首页
      const targetItem = await driver.findComponent(ON.text('EventCall'));
      if (targetItem !== null) {
        await targetItem.click();
        hilog.info(DOMAIN, TAG, 'ImageTest: Clicked EventCall item');
        // 等待目标页面加载
        await driver.delayMs(2000);
        // 返回
        await driver.pressBack();
        await driver.delayMs(1000);
        hilog.info(DOMAIN, TAG, 'ImageTest: Completed basic flow successfully');
      }
       hilog.info(DOMAIN, TAG, 'ImageTest: EventCall end');
      done();
    });
  });
}