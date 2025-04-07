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

const delegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let driver: Driver;
let want: Want;

export default function IndexTest() {
  describe('IndexTest', () => {
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
      console.info('get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    });

    /**
     * @tc.number ImageTest_001
     * @tc.name testHomePageLoad
     * @tc.desc 测试首页加载是否成功
     */
    it('testHomePageLoad', 0, async (done: Function) => {
      console.info('ImageTest: testHomePageLoad begin');

      // 验证标题存在
      const title = await driver.findComponent(ON.text('图片显示'));
      expect(title === null).assertFalse();

      // 验证列表存在
      const list = await driver.findComponent(ON.type('List'));
      expect(list === null).assertFalse();

      console.info('ImageTest: testHomePageLoad end');
      done();
    });

    /**
     * @tc.number ImageTest_002
     * @tc.name testImageZoomNavigation
     * @tc.desc 测试图片缩放类型设置页面跳转
     */
    it('testImageZoomNavigation', 0, async (done: Function) => {
      console.info('ImageTest: testImageZoomNavigation begin');

      // 点击"设置图片缩放类型"项
      const zoomItem = await driver.findComponent(ON.text('设置图片缩放类型'));
      expect(zoomItem === null).assertFalse();
      await zoomItem.click();
      await driver.delayMs(1000);

      // 验证是否跳转到目标页面
      const pageTitle = await driver.findComponent(ON.type('Image'));
      expect(pageTitle === null).assertFalse();

      // 返回首页
      await driver.pressBack();
      await driver.delayMs(500);

      console.info('ImageTest: testImageZoomNavigation end');
      done();
    });

    /**
     * @tc.number ImageTest_003
     * @tc.name testImageInterpolationNavigation
     * @tc.desc 测试图片插值页面跳转
     */
    it('testImageInterpolationNavigation', 0, async (done: Function) => {
      console.info('ImageTest: testImageInterpolationNavigation begin');

      // 点击"图片插值"项
      const interpolationItem = await driver.findComponent(ON.text('图片插值'));
      expect(interpolationItem === null).assertFalse();
      await interpolationItem.click();
      await driver.delayMs(1000);

      // 验证是否跳转到目标页面
      const pageTitle = await driver.findComponent(ON.type('Image'));
      expect(pageTitle === null).assertFalse();

      // 返回首页
      await driver.pressBack();
      await driver.delayMs(500);

      console.info('ImageTest: testImageInterpolationNavigation end');
      done();
    });

    /**
     * @tc.number ImageTest_004
     * @tc.name testImageInterpolationNavigation
     * @tc.desc 测试设置图片重复样式页面跳转
     */
    it('testSetImageRepetitionStyle', 0, async (done: Function) => {
      console.info('ImageTest: testSetImageRepetitionStyle begin');

      // 点击"设置图片重复样式"项
      const interpolationItem = await driver.findComponent(ON.text('设置图片重复样式'));
      expect(interpolationItem === null).assertFalse();
      await interpolationItem.click();
      await driver.delayMs(1000);

      // 验证是否跳转到目标页面
      const pageTitle = await driver.findComponent(ON.type('Image'));
      expect(pageTitle === null).assertFalse();

      // 返回首页
      await driver.pressBack();
      await driver.delayMs(500);

      console.info('ImageTest: testSetImageRepetitionStyle end');
      done();
    });

    /**
     * @tc.number ImageTest_005
     * @tc.name testImageInterpolationNavigation
     * @tc.desc 测试设置图片渲染模式页面跳转
     */
    it('testSetImageRenderingMode', 0, async (done: Function) => {
      console.info('ImageTest: testSetImageRenderingMode begin');

      // 点击"设置图片渲染模式"项
      const interpolationItem = await driver.findComponent(ON.text('设置图片渲染模式'));
      expect(interpolationItem === null).assertFalse();
      await interpolationItem.click();
      await driver.delayMs(1000);

      // 验证是否跳转到目标页面
      const pageTitle = await driver.findComponent(ON.type('Image'));
      expect(pageTitle === null).assertFalse();

      // 返回首页
      await driver.pressBack();
      await driver.delayMs(500);

      console.info('ImageTest: testSetImageRenderingMode end');
      done();
    });


    /**
     * @tc.number ImageTest_006
     * @tc.name testPageLoadPerformance
     * @tc.desc 测试页面加载性能
     */
    it('testPageLoadPerformance', 0, async (done: Function) => {
      console.info('ImageTest: testPageLoadPerformance begin');

      const startTime = new Date().getTime();

      // 点击第一个项目
      const firstItem = await driver.findComponent(ON.text('设置图片缩放类型'));
      await firstItem.click();

      // 等待新页面加载完成
      await driver.delayMs(1000);
      const endTime = new Date().getTime();

      const loadTime = endTime - startTime;
      console.info(`Page load time: ${loadTime}ms`);
      expect(loadTime < 3000).assertTrue(); // 加载时间应小于3秒

      await driver.pressBack();

      console.info('ImageTest: testPageLoadPerformance end');
      done();
    });
  });
}