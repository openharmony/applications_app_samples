/*
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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

import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { describe, it, expect } from '@ohos/hypium'
import { Component, Driver, ON } from '@ohos.UiTest';
import Logger from '../util/Logger';
import Want from '@ohos.app.ability.Want';

const BUNDLE: string = 'Performance';
const TAG: string = '[Sample_Performance_Test]';
const delegator: AbilityDelegatorRegistry.AbilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();

async function getResourceString<T extends Resource>(resource: T): Promise<string> {
  let manage = delegator.getAppContext().resourceManager;
  let text = await manage.getStringValue(resource);
  return text;
}

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    /**
     * 打开应用
     */
    it(BUNDLE + '_startAbility', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + '_startAbility start')
      let want: Want = {
        bundleName: 'com.samples.performancelibrary',
        abilityName: 'EntryAbility'
      };
      delegator.startAbility(want, (err) => {
        Logger.info(TAG, 'StartAbility get err ' + JSON.stringify(err));
        expect(err).assertNull();
      })
      Logger.info(TAG, BUNDLE + '_startAbility end');
      done();
    })

    /**
     * 点击HiDumper按钮，进入HiDumper查看组件信息页面
     */
    it(BUNDLE + "HiDumperFunction_001", 1, async (done: Function) => {
      Logger.info(TAG, `${BUNDLE}HiDumperFunction_001 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(5000);
      let hiDumper: Component = await driver.findComponent(ON.text("HiDumper"));
      await driver.delayMs(500);
      await hiDumper.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text("HiDumper查看组件信息"));
      await driver.assertComponentExist(ON.text("查看应用组件树"));
      await driver.assertComponentExist(ON.text("查看if/else组件"));
      await driver.assertComponentExist(ON.text("查看visibility属性"));
      await driver.delayMs(500);
      Logger.info(TAG, `${BUNDLE}HiDumperFunction_001 end`);
      done();
    })

    /**
     * 进入查看应用组件树页面，查看页面是否在正常显示
     */
    it(BUNDLE + "HiDumperFunction_002", 2, async (done: Function) => {
      Logger.info(TAG, `${BUNDLE}HiDumperFunction_002 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      let componentTree: Component = await driver.findComponent(ON.text("查看应用组件树"));
      await driver.delayMs(500);
      await componentTree.click();
      await driver.delayMs(2000);
      await driver.assertComponentExist(ON.id("ID_GRID"));
      await driver.delayMs(500);
      await driver.pressBack()
      await driver.delayMs(500);
      Logger.info(TAG, `${BUNDLE}HiDumperFunction_002 end`);
      done();
    })

    /**
     * 进入查看if/else组件页面，查看页面是否在正常显示
     */
    it(BUNDLE + "HiDumperFunction_003", 3, async (done: Function) => {
      Logger.info(TAG, `${BUNDLE}HiDumperFunction_003 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      let ifElseComponent: Component = await driver.findComponent(ON.text("查看if/else组件"));
      await driver.delayMs(500);
      await ifElseComponent.click();
      await driver.delayMs(1000);
      let showChange: Component = await driver.findComponent(ON.text("显隐切换"));
      await driver.delayMs(500);
      await showChange.click();
      await driver.delayMs(1000);
      await showChange.click();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);
      Logger.info(TAG, `${BUNDLE}HiDumperFunction_003 end`);
      done();
    })

    /**
     * 进入查看visibility属性页面，查看页面是否在正常显示
     */
    it(BUNDLE + "HiDumperFunction_004", 4, async (done: Function) => {
      Logger.info(TAG, `${BUNDLE}HiDumperFunction_004 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      let checkVisibleComponent: Component = await driver.findComponent(ON.text("查看visibility属性"));
      await driver.delayMs(500);
      await checkVisibleComponent.click();
      await driver.delayMs(500);
      let visibleComponent: Component = await driver.findComponent(ON.text("Visible"));
      await driver.delayMs(500);
      let hiddenComponent: Component = await driver.findComponent(ON.text("Hidden"));
      await driver.delayMs(500);
      let noneComponent: Component = await driver.findComponent(ON.text("None"));
      await driver.delayMs(500);
      await visibleComponent.click();
      await driver.delayMs(1000);
      await hiddenComponent.click();
      await driver.delayMs(1000);
      await visibleComponent.click();
      await driver.delayMs(1000);
      await noneComponent.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);
      Logger.info(TAG, `${BUNDLE}HiDumperFunction_004 end`);
      done();
    })

    /**
     * 点击"点击跳转静态加载案例"按钮，进入静态加载场景页面
     */
    it(BUNDLE + "DynamicImportFunction_001", 1, async (done: Function) => {
      Logger.info(TAG, `${BUNDLE}DynamicImportFunction_001 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      let staticEntry: Component = await driver.findComponent(ON.text("StaticImport"));
      await driver.delayMs(500);
      await staticEntry.click();
      await driver.delayMs(500);
      let staticImport: Component = await driver.findComponent(ON.id("conventionExample"));
      await driver.delayMs(500);
      await staticImport.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text("主页"));
      await driver.assertComponentExist(ON.text("返回"));
      await driver.assertComponentExist(ON.text("pageOne"));
      await driver.assertComponentExist(ON.text("pageTwo"));
      await driver.delayMs(500);
      let pageOneDynamic: Component = await driver.findComponent(ON.text("pageOne"));
      await driver.delayMs(500);
      await pageOneDynamic.click();
      await driver.delayMs(2000);
      await driver.pressBack();
      await driver.delayMs(500);
      let pageTwoDynamic: Component = await driver.findComponent(ON.text("pageTwo"));
      await driver.delayMs(500);
      await pageTwoDynamic.click();
      await driver.delayMs(2000);
      await driver.pressBack();
      await driver.delayMs(500);
      let back: Component = await driver.findComponent(ON.text("返回"));
      await driver.delayMs(500);
      await back.click();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);
      Logger.info(TAG, `${BUNDLE}DynamicImportFunction_001 end`);
      done();
    })

    /**
     * 点击"点击跳转动态加载案例"按钮，进入动态加载场景页面
     */
    it(BUNDLE + "DynamicImportFunction_001", 1, async (done: Function) => {
      Logger.info(TAG, `${BUNDLE}DynamicImportFunction_001 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      let dynamicEntry: Component = await driver.findComponent(ON.text("DynamicImport"));
      await driver.delayMs(500);
      await dynamicEntry.click();
      await driver.delayMs(500);
      let dynamicImport: Component = await driver.findComponent(ON.text("点击跳转动态加载案例"));
      await driver.delayMs(500);
      await dynamicImport.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text("主页"));
      await driver.assertComponentExist(ON.text("返回"));
      await driver.assertComponentExist(ON.text("pageOne"));
      await driver.delayMs(500);
      let pageOneDynamic: Component = await driver.findComponent(ON.text("pageOne"));
      await driver.delayMs(500);
      await pageOneDynamic.click();
      await driver.delayMs(2000);
      await driver.pressBack();
      await driver.delayMs(500);
      let back: Component = await driver.findComponent(ON.text("返回"));
      await driver.delayMs(500);
      await back.click();
      await driver.delayMs(500);
      await driver.pressBack();
      Logger.info(TAG, `${BUNDLE}DynamicImportFunction_001 end`);
      done();
    })

    /**
     * 点击IfOrVisibility按钮，进入合理渲染信息页面
     */
    it(BUNDLE + "IfOrVisibilityFunction_001", 1, async (done: Function) => {
      Logger.info(TAG, `${BUNDLE}IfOrVisibilityFunction_001 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(1000);
      let IfOrVisibility: Component = await driver.findComponent(ON.text("IfOrVisibility"));
      await driver.delayMs(500);
      await IfOrVisibility.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text("合理选择条件渲染和显隐控制"));
      await driver.assertComponentExist(ON.text("频繁切换：显隐控制"));
      await driver.assertComponentExist(ON.text("频繁切换：条件渲染"));
      await driver.assertComponentExist(ON.text("首页渲染：条件渲染"));
      await driver.assertComponentExist(ON.text("首页渲染：显隐控制"));
      await driver.assertComponentExist(ON.text("部分修改：条件渲染+容器限制"));
      await driver.assertComponentExist(ON.text("部分修改：仅条件渲染"));
      await driver.assertComponentExist(ON.text("复杂子树：条件渲染+组件复用"));
      await driver.assertComponentExist(ON.text("复杂子树：仅条件渲染"));
      await driver.delayMs(500);
      Logger.info(TAG, `${BUNDLE}IfOrVisibilityFunction_001 end`);
      done();
    })

    /**
     * 进入频繁切换场景，查看页面是否在正常显示
     */
    it(BUNDLE + "IfOrVisibilityFunction_002", 2, async (done: Function) => {
      Logger.info(TAG, `${BUNDLE}IfOrVisibilityFunction_002 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(1000);
      let animateComponent: Component = await driver.findComponent(ON.text("频繁切换：显隐控制"));
      await driver.delayMs(500);
      await animateComponent.click();
      await driver.delayMs(1000);
      let showChange: Component = await driver.findComponent(ON.text("Switch visible and hidden"));
      await driver.delayMs(500);
      await showChange.click();
      await driver.delayMs(2000);
      await showChange.click();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);
      animateComponent = await driver.findComponent(ON.text("频繁切换：条件渲染"));
      await driver.delayMs(500);
      await animateComponent.click();
      await driver.delayMs(1000);
      showChange = await driver.findComponent(ON.text("Switch visible and hidden"));
      await driver.delayMs(500);
      await showChange.click();
      await driver.delayMs(2000);
      await showChange.click();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);
      Logger.info(TAG, `${BUNDLE}IfOrVisibilityFunction_002 end`);
      done();
    })

    /**
     * 进入首页渲染场景，查看页面是否在正常显示
     */
    it(BUNDLE + "IfOrVisibilityFunction_003", 3, async (done: Function) => {
      Logger.info(TAG, `${BUNDLE}IfOrVisibilityFunction_003 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(1000);
      let animateComponent: Component = await driver.findComponent(ON.text("首页渲染：条件渲染"));
      await driver.delayMs(500);
      await animateComponent.click();
      await driver.delayMs(1000);
      let showChange: Component = await driver.findComponent(ON.text("Show the Hidden on start"));
      await driver.delayMs(500);
      await showChange.click();
      await driver.delayMs(1000);
      await showChange.click();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);
      animateComponent = await driver.findComponent(ON.text("首页渲染：显隐控制"));
      await driver.delayMs(500);
      await animateComponent.click();
      await driver.delayMs(1000);
      showChange = await driver.findComponent(ON.text("Show the Hidden on start"));
      await driver.delayMs(500);
      await showChange.click();
      await driver.delayMs(1000);
      await showChange.click();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);
      Logger.info(TAG, `${BUNDLE}IfOrVisibilityFunction_003 end`);
      done();
    })

    /**
     * 进入部分修改场景，查看页面是否在正常显示
     */
    it(BUNDLE + "IfOrVisibilityFunction_004", 4, async (done: Function) => {
      Logger.info(TAG, `${BUNDLE}IfOrVisibilityFunction_004 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(1000);
      let animateComponent: Component = await driver.findComponent(ON.text("部分修改：条件渲染+容器限制"));
      await driver.delayMs(1000);
      await animateComponent.click();
      await driver.delayMs(1000);
      let showChange: Component = await driver.findComponent(ON.text("Switch Hidden and Show"));
      await driver.delayMs(500);
      await showChange.click();
      await driver.delayMs(1000);
      await showChange.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);

      animateComponent = await driver.findComponent(ON.text("部分修改：仅条件渲染"));
      await driver.delayMs(3000);
      await animateComponent.click();
      await driver.delayMs(15000);
      showChange = await driver.findComponent(ON.text("Switch Hidden and Show"));
      await driver.delayMs(1000);
      await showChange.click();
      await driver.delayMs(1000);
      await showChange.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      Logger.info(TAG, `${BUNDLE}IfOrVisibilityFunction_004 end`);
      done();
    })

    /**
     * 进入复杂子树场景，查看页面是否在正常显示
     */
    it(BUNDLE + "IfOrVisibilityFunction_005", 5, async (done: Function) => {
      Logger.info(TAG, `${BUNDLE}IfOrVisibilityFunction_005 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(1000);
      let animateComponent: Component = await driver.findComponent(ON.text("复杂子树：条件渲染+组件复用"));
      await driver.delayMs(1000);
      await animateComponent.click();
      await driver.delayMs(1000);
      let showChange: Component = await driver.findComponent(ON.text("Change FlexAlign"));
      await driver.delayMs(500);
      await showChange.click();
      await driver.delayMs(1000);
      await showChange.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);

      animateComponent = await driver.findComponent(ON.text("复杂子树：仅条件渲染"));
      await driver.delayMs(3000);
      await animateComponent.click();
      await driver.delayMs(1000);
      showChange = await driver.findComponent(ON.text("Change FlexAlign"));
      await driver.delayMs(5000);
      await showChange.click();
      await driver.delayMs(1000);
      await showChange.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      Logger.info(TAG, `${BUNDLE}IfOrVisibilityFunction_005 end`);
      done();
    })

    /**
     * Grid的使用
     */
    it(BUNDLE + "GridFunction_001", 1, async (done: Function) => {
      Logger.info(TAG, `${BUNDLE}GridFunction_001 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      // 点击进入grid首页
      let gridBtn: Component = await driver.findComponent(ON.text('Grid'));
      await driver.delayMs(500);
      await gridBtn.click();
      await driver.delayMs(500);
      // 点击进入懒加载页面
      let lazyForEachBtn: Component = await driver.findComponent(ON.id('buttonOne'));
      await driver.delayMs(500);
      await lazyForEachBtn.click();
      await driver.delayMs(500);
      // 验证是否进入懒加载页面
      await driver.assertComponentExist(ON.text('图片1'));
      // 退出懒加载页面
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(1000);
      // 点击进入columnStart页面
      let columnStartBtn: Component = await driver.findComponent(ON.id('buttonTwo'));
      await driver.delayMs(500);
      await columnStartBtn.click();
      await driver.delayMs(500);
      // 点击滑动位置
      let scrollToIndexBtn: Component = await driver.findComponent(ON.id('scrollToIndexBtn'));
      await driver.delayMs(500);
      await scrollToIndexBtn.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text('1900'));
      // 退出columnStart页面
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      // 点击进入smartPerf页面
      let smartPerfEditorBtn: Component = await driver.findComponent(ON.id('buttonThree'));
      await driver.delayMs(1000);
      await smartPerfEditorBtn.click();
      await driver.delayMs(500);
      // 点击滑动位置
      let scrollToIndexTwoBtn: Component = await driver.findComponent(ON.id('scrollToIndexTwoBtn'));
      await driver.delayMs(500);
      await scrollToIndexTwoBtn.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text('1900'));
      // 退出columnStart页面
      await driver.delayMs(500);
      await driver.pressBack();
      // 退出到首页
      await driver.delayMs(500);
      await driver.pressBack();
      Logger.info(TAG, `${BUNDLE}GridFunction_001 end`);
      done();
    })

    /**
     * SmartPerf Editor的使用
     */
    it(BUNDLE + "SmartPerf_001", 1, async (done: Function) => {
      Logger.info(TAG, `${BUNDLE}SmartPerf_001 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      // 点击进入SmartPerf Editor首页
      let smartPerfBtn: Component = await driver.findComponent(ON.text('SmartPerf Editor'));
      await driver.delayMs(500);
      await smartPerfBtn.click();
      await driver.delayMs(500);
      // 点击展示图片
      let showImageBtn: Component = await driver.findComponent(ON.id('showImageBtn'));
      await driver.delayMs(500);
      await showImageBtn.click();
      await driver.delayMs(500);
      // 退出到首页面
      await driver.delayMs(500);
      await driver.pressBack();
      Logger.info(TAG, `${BUNDLE}SmartPerf_001 end`);
      done();
    })

    /**
     * 进入查看SmartPerfHostFrameTimeline优化前页面，查看页面是否在正常显示
     */
    it(BUNDLE + "SmartPerfHostFrameTimeline01", 1, async (done: Function) => {
      Logger.info(TAG, `${BUNDLE}SmartPerfHostFrameTimeline01 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text("SmartPerfHost"))
      let ifElseComponent: Component = await driver.findComponent(ON.text("SmartPerfHost"));
      await driver.delayMs(500);
      await ifElseComponent.click();
      await driver.delayMs(1000);
      let showChange: Component = await driver.findComponent(ON.text("FrameTimeline优化前代码"));
      await driver.delayMs(500);
      await showChange.click();
      await driver.delayMs(10000);
      await driver.pressBack();
      await driver.delayMs(500);
      Logger.info(TAG, `${BUNDLE}SmartPerfHostFrameTimeline01 end`);
      done();
    })

    /**
     * 进入查看SmartPerfHostFrameTimeline优化后页面，查看页面是否在正常显示
     */
    it(BUNDLE + "SmartPerfHostFrameTimeline02", 2, async (done: Function) => {
      Logger.info(TAG, `${BUNDLE}SmartPerfHostFrameTimeline00 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      let showChange: Component = await driver.findComponent(ON.text("FrameTimeline优化后代码"));
      await driver.delayMs(500);
      await showChange.click();
      await driver.delayMs(5000);
      await driver.pressBack();
      await driver.delayMs(500);
      Logger.info(TAG, `${BUNDLE}SmartPerfHostFrameTimeline02 end`);
      done();
    })

    /**
     * 进入查看SmartPerfHostAPPStartup优化前页面，查看页面是否在正常显示
     */
    it(BUNDLE + "SmartPerfHostAPPStartup01", 1, async (done: Function) => {
      Logger.info(TAG, `${BUNDLE}SmartPerfHostAPPStartup01 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      let showChange: Component = await driver.findComponent(ON.text("AppStartup优化前代码"));
      await driver.delayMs(500);
      await showChange.click();
      await driver.delayMs(5000);
      await driver.pressBack();
      await driver.delayMs(500);
      Logger.info(TAG, `${BUNDLE}SmartPerfHostAPPStartup01 end`);
      done();
    })

    /**
     * 进入查看SmartPerfHostAPPStartup优化后页面，查看页面是否在正常显示
     */
    it(BUNDLE + "SmartPerfHostAPPStartup02", 2, async (done: Function) => {
      Logger.info(TAG, `${BUNDLE}SmartPerfHostAPPStartup02 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      let showChange: Component = await driver.findComponent(ON.text("AppStartup优化后代码"));
      await driver.delayMs(500);
      await showChange.click();
      await driver.delayMs(5000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);
      Logger.info(TAG, `${BUNDLE}SmartPerfHostAPPStartup02 end`);
      done();
    })

    /**
     * Trace的使用
     */
    it(BUNDLE + "Trace_001", 1, async (done: Function) => {
      Logger.info(TAG, `${BUNDLE}Trace_001 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      // 点击进入Trace首页
      let traceBtn: Component = await driver.findComponent(ON.text('Trace'));
      await driver.delayMs(500);
      await traceBtn.click();
      await driver.delayMs(500);
      // 滑动页面 循环连续向上滑动3次
      for (let index = 0; index < 3; index++) {
        await driver.swipe(0, 800, 0, 100, 600);
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.id('itemImage'));
      }
      // 退出到首页面
      await driver.delayMs(500);
      await driver.pressBack();
      Logger.info(TAG, `${BUNDLE}Trace_001 end`);
      done();
    })

    /**
     * 合理使用后台任务场景
     */
    it(BUNDLE + "BackgroundTask_001", 6, async (done: Function) => {
      Logger.info(TAG, `${BUNDLE}BackgroundTask_001 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(1000);
      await driver.swipe(0, 800, 0, 100, 600);
      await driver.delayMs(1000);
      // 点击进入后台任务首页
      let backgroundTaskBtn: Component = await driver.findComponent(ON.text('BackgroundTask'));
      await driver.delayMs(1000);
      await backgroundTaskBtn.click();
      await driver.delayMs(1000);
      // 点击进入短时任务场景
      let transientTaskBtn: Component = await driver.findComponent(ON.text('短时任务'));
      await driver.delayMs(1000);
      await transientTaskBtn.click();
      await driver.delayMs(1000);
      // 返回上一级进入长时任务场景
      await driver.pressBack();
      await driver.delayMs(1000);
      let longTermTaskBtn: Component = await driver.findComponent(ON.text('长时任务'));
      await driver.delayMs(1000);
      await longTermTaskBtn.click();
      await driver.delayMs(3000);
      // 获取通知权限
      let btnAccept: Component = await driver.findComponent(ON.text('允许'));
      if (btnAccept) {
        await btnAccept.click();
      }
      await driver.delayMs(3000);
      // 获取定位权限
      let locAcceptBtn: Component = await driver.findComponent(ON.text(await getResourceString($r('app.string.permission_while_use'))));
      await driver.delayMs(500);
      if (locAcceptBtn) {
        await locAcceptBtn.click();
        await driver.delayMs(1000);
      }
      // 点击开启定位服务
      let startLocationBtn: Component = await driver.findComponent(ON.text('开启定位服务'));
      await driver.delayMs(500);
      await startLocationBtn.click();
      await driver.delayMs(3000);
      // 点击关闭定位服务
      let stopLocationBtn: Component = await driver.findComponent(ON.text('关闭定位服务'));
      await driver.delayMs(1000);
      await stopLocationBtn.click();
      await driver.delayMs(1000);
      // 退出到首页面
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      Logger.info(TAG, `${BUNDLE}BackgroundTask_001 end`);
      done();
    })

    /**
     * WaterFlow高性能开发指导
     */
    it(BUNDLE + "WaterFlow_001", 1, async (done: Function) => {
      Logger.info(TAG, `${BUNDLE}WaterFlow_001 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      await driver.swipe(0, 800, 0, 100, 600);
      // 点击进入WaterFlow的使用首页
      let waterBtn: Component = await driver.findComponent(ON.text('WaterFlow'));
      await driver.delayMs(500);
      await waterBtn.click();
      await driver.delayMs(500);
      // 滑动页面 循环连续向上滑动4次

      for (let index = 0; index < 4; index++) {
        await driver.swipe(10, 1000, 10, 0, 15000);
      }
      // 退出到首页面
      await driver.delayMs(500);
      await driver.pressBack();
      Logger.info(TAG, `${BUNDLE}WaterFlow_001 end`);
      done();
    })

    /** 多线程共享内存页面场景
     */
    it(BUNDLE + "memoryShared_001", 1, async (done: Function) => {
      Logger.info(TAG, `${BUNDLE}memoryShared_001 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(1000);
      await driver.swipe(0, 800, 0, 100, 600);
      await driver.delayMs(1000);
      // 点击进入多线程共享内存页面
      let backgroundTaskBtn: Component = await driver.findComponent(ON.text(await getResourceString($r('app.string.MemoryShared'))));
      await driver.delayMs(1000);
      await backgroundTaskBtn.click();
      await driver.delayMs(1000);
      // 点击进入原子操作场景
      let AtomicSceneBtn: Component = await driver.findComponent(ON.text(await getResourceString($r('app.string.atomic_operation'))));
      await driver.delayMs(1000);
      await AtomicSceneBtn.click();
      await driver.delayMs(1000);
      // 点击进入原子操作场景
      let AtomicTaskBtn: Component = await driver.findComponent(ON.text(await getResourceString($r('app.string.use_atomic'))));
      await driver.delayMs(1000);
      await AtomicTaskBtn.click();
      await driver.delayMs(1000);
      // 点击进入原子操作场景
      let NonAtomicTaskBtn: Component = await driver.findComponent(ON.text(await getResourceString($r('app.string.not_use_atomic'))));
      await driver.delayMs(1000);
      await NonAtomicTaskBtn.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      // 点击进入锁的使用任务场景
      let LockSceneBtn: Component = await driver.findComponent(ON.text(await getResourceString($r('app.string.lock_operation'))));
      await driver.delayMs(1000);
      await LockSceneBtn.click();
      await driver.delayMs(1000);
      // 点击进入锁的使用任务场景
      let LockTaskBtn: Component = await driver.findComponent(ON.text(await getResourceString($r('app.string.use_lock'))));
      await driver.delayMs(1000);
      await LockTaskBtn.click();
      await driver.delayMs(3000);
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.write_success'))));
      // 点击进入锁的使用任务场景
      let NonLockTaskBtn: Component = await driver.findComponent(ON.text(await getResourceString($r('app.string.not_use_lock'))));
      await driver.delayMs(1000);
      await NonLockTaskBtn.click();
      await driver.delayMs(3000);
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.write_success'))));

      // 退出到首页面
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      Logger.info(TAG, `${BUNDLE}memoryShared_001 end`);
      done();
    })

    /**
     * native跨线程示例
     */
    it(BUNDLE + "NativeThreadsCallJS_001", 1, async (done: Function) => {
      Logger.info(TAG, `${BUNDLE}NativeThreadsCallJS_001 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      await driver.swipe(10, 800, 10, 100, 600);
      // 点击进入NativeThreadsCallJS的使用首页
      let NativeThreads: Component = await driver.findComponent(ON.text('NativeThreadsCallJS'));
      await driver.delayMs(500);
      await NativeThreads.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text("threadSafeTest"));
      await driver.assertComponentExist(ON.text("libuvTest"));
      await driver.delayMs(500);
      Logger.info(TAG, `${BUNDLE}NativeThreadsCallJS_001 end`);
      done();
    })

    it(BUNDLE + "NativeThreadsCallJS_002", 1, async (done: Function) => {
      Logger.info(TAG, `${BUNDLE}NativeThreadsCallJS_002 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      // 安全函数验证
      let threadSafeTest: Component = await driver.findComponent(ON.text('threadSafeTest'));
      let textValue: Component = await driver.findComponent(ON.id('textNativeValue'));
      for (let index = 0; index < 3; index++) {
        // 获取点击之前的值
        let textBefore = await textValue.getText();
        let vauleBefore = Number(textBefore);
        await threadSafeTest.click();
        await driver.delayMs(1000);
        // 获取点击之后的值
        let textAfter = await textValue.getText();
        let vauleAfter = Number(textAfter);
        expect(vauleBefore + 30).assertEqual(vauleAfter);
        await driver.delayMs(500);
      }
      // libuv验证
      let libuvTest: Component = await driver.findComponent(ON.text('libuvTest'));
      for (let index = 0; index < 3; index++) {
        // 获取点击之前的值
        let textBefore = await textValue.getText();
        let vauleBefore = Number(textBefore);
        await libuvTest.click();
        await driver.delayMs(1000);
        // 获取点击之后的值
        let textAfter = await textValue.getText();
        let vauleAfter = Number(textAfter);
        expect(vauleBefore + 30).assertEqual(vauleAfter);
        await driver.delayMs(500);
      }
      Logger.info(TAG, `${BUNDLE}NativeThreadsCallJS_002 end`);
      // 退出到首页面
      await driver.delayMs(500);
      await driver.pressBack();
      done();
    })

    /**
     * 主线程和子线程通信
     */
    it(BUNDLE + "ThreadCommunication_001", 1, async (done: Function) => {
      Logger.info(TAG, `${BUNDLE}ThreadCommunication_001 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      await driver.swipe(10, 800, 10, 0, 600);
      await driver.delayMs(500);
      let threadHome: Component = await driver.findComponent(ON.text('ThreadCommunication'));
      await driver.delayMs(500);
      await threadHome.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(getContext()
        .resourceManager
        .getStringSync($r('app.string.thread_communication'))));
      await driver.delayMs(200);
      await driver.assertComponentExist(ON.text(getContext()
        .resourceManager
        .getStringSync($r('app.string.scenario_1'))));
      await driver.delayMs(200);
      await driver.assertComponentExist(ON.text(getContext()
        .resourceManager
        .getStringSync($r('app.string.scenario_2'))));
      await driver.delayMs(200);
      await driver.assertComponentExist(ON.text(getContext()
        .resourceManager
        .getStringSync($r('app.string.scenario_3'))));
      await driver.delayMs(200);
      await driver.assertComponentExist(ON.text(getContext()
        .resourceManager
        .getStringSync($r('app.string.scenario_4'))));
      await driver.delayMs(200);
      await driver.assertComponentExist(ON.text(getContext()
        .resourceManager
        .getStringSync($r('app.string.scenario_5'))));
      await driver.delayMs(200);
      Logger.info(TAG, `${BUNDLE}ThreadCommunication_001 end`);
      done();
    })

    /**
     * 独立的耗时任务测试用例
     */
    it(BUNDLE + "ThreadCommunication_002", 1, async (done: Function) => {
      Logger.info(TAG, `${BUNDLE}ThreadCommunication_002 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      let scenario: Component = await driver.findComponent(ON.text(getContext()
        .resourceManager
        .getStringSync($r('app.string.scenario_1'))));
      await driver.delayMs(500);
      await scenario.click();
      await driver.delayMs(1000);
      let loadImage: Component = await driver.findComponent(ON.text(getContext()
        .resourceManager
        .getStringSync($r('app.string.load_image'))));
      await driver.delayMs(500);
      await loadImage.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      Logger.info(TAG, `${BUNDLE}ThreadCommunication_002 end`);
      done();
    })

    /**
     * 多个任务执行结果统一返回测试用例
     */
    it(BUNDLE + "ThreadCommunication_003", 1, async (done: Function) => {
      Logger.info(TAG, `${BUNDLE}ThreadCommunication_003 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      let scenario: Component = await driver.findComponent(ON.text(getContext()
        .resourceManager
        .getStringSync($r('app.string.scenario_2'))));
      await driver.delayMs(500);
      await scenario.click();
      await driver.delayMs(1000);
      let loadImage: Component = await driver.findComponent(ON.text(getContext()
        .resourceManager
        .getStringSync($r('app.string.load_image'))));
      await driver.delayMs(500);
      await loadImage.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      Logger.info(TAG, `${BUNDLE}ThreadCommunication_003 end`);
      done();
    })

    /**
     * TaskPool和主线程的即时通信测试用例
     */
    it(BUNDLE + "ThreadCommunication_004", 1, async (done: Function) => {
      Logger.info(TAG, `${BUNDLE}ThreadCommunication_004 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      let scenario: Component = await driver.findComponent(ON.text(getContext()
        .resourceManager
        .getStringSync($r('app.string.scenario_3'))));
      await driver.delayMs(500);
      await scenario.click();
      await driver.delayMs(1000);
      let loadImage: Component = await driver.findComponent(ON.text(getContext()
        .resourceManager
        .getStringSync($r('app.string.load_image'))));
      await driver.delayMs(500);
      await loadImage.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      Logger.info(TAG, `${BUNDLE}ThreadCommunication_004 end`);
      done();
    })

    /**
     * Worker和主线程的即时通信测试用例
     */
    it(BUNDLE + "ThreadCommunication_005", 1, async (done: Function) => {
      Logger.info(TAG, `${BUNDLE}ThreadCommunication_005 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      let scenario: Component = await driver.findComponent(ON.text(getContext()
        .resourceManager
        .getStringSync($r('app.string.scenario_4'))));
      await driver.delayMs(500);
      await scenario.click();
      await driver.delayMs(1000);
      let loadImage: Component = await driver.findComponent(ON.text(getContext()
        .resourceManager
        .getStringSync($r('app.string.change_image_number'))));
      await driver.delayMs(500);
      await loadImage.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      Logger.info(TAG, `${BUNDLE}ThreadCommunication_005 end`);
      done();
    })

    /**
     * 子线程同步调用主线程的接口测试用例
     */
    it(BUNDLE + "ThreadCommunication_006", 1, async (done: Function) => {
      Logger.info(TAG, `${BUNDLE}ThreadCommunication_006 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      let scenario: Component = await driver.findComponent(ON.text(getContext()
        .resourceManager
        .getStringSync($r('app.string.scenario_5'))));
      await driver.delayMs(500);
      await scenario.click();
      await driver.delayMs(1000);
      let loadImage: Component = await driver.findComponent(ON.text(getContext()
        .resourceManager
        .getStringSync($r('app.string.load_image'))));
      await driver.delayMs(500);
      await loadImage.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      Logger.info(TAG, `${BUNDLE}ThreadCommunication_006 end`);
      done();
    })

    /**
     * 点击WebPerformance按钮，进入Web首页面
     */
    it(BUNDLE + "WebPerformance_001", 1, async (done: Function) => {
      Logger.info(TAG, `${BUNDLE}WebPerformance_001 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      await driver.swipe(0, 800, 0, 100, 600);
      await driver.delayMs(500);
      await driver.swipe(0, 800, 0, 100, 600);
      await driver.delayMs(500);
      // 进入Web应用首页
      let WebIndexEntry: Component = await driver.findComponent(ON.text((await getResourceString($r('app.string.web_performance')))));
      await driver.delayMs(500);
      await WebIndexEntry.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text((await getResourceString($r('app.string.web_uninitialized')))));
      await driver.assertComponentExist(ON.text((await getResourceString($r('app.string.web_initialized')))));
      await driver.delayMs(500);
      // 进入常规未优化页面
      let WebUninitializedPage: Component = await driver.findComponent(ON.text((await getResourceString($r('app.string.web_uninitialized')))));
      await driver.delayMs(500);
      await WebUninitializedPage.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text((await getResourceString($r('app.string.web_open_page')))));
      await driver.assertComponentExist(ON.text((await getResourceString($r('app.string.web_back')))));
      await driver.delayMs(500);
      // 进入网页
      let WebHomeEntry: Component = await driver.findComponent(ON.text((await getResourceString($r('app.string.web_open_page')))));
      await driver.delayMs(500);
      await WebHomeEntry.click();
      // 返回Web页面
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(1000);
      done();
    })

    it(BUNDLE + "WebPerformance_002", 1, async (done: Function) => {
      Logger.info(TAG, `${BUNDLE}WebPerformance_002 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      // 进入优化Web页面
      let WebIndexEntry: Component = await driver.findComponent(ON.text((await getResourceString($r('app.string.web_initialized')))));
      await driver.delayMs(500);
      await WebIndexEntry.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text((await getResourceString($r('app.string.web_open_page')))));
      await driver.assertComponentExist(ON.text((await getResourceString($r('app.string.web_back')))));
      await driver.delayMs(500);
      // 进入网页
      let WebHomeEntry: Component = await driver.findComponent(ON.text((await getResourceString($r('app.string.web_open_page')))));
      await driver.delayMs(500);
      await WebHomeEntry.click();
      // 返回Web页面
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      // 退出到首页面
      await driver.delayMs(500);
      await driver.pressBack();
      done();
    })

    /**
     * 线程间大数据传输测试用例
     */
    it(BUNDLE + "ThreadDataTransfer_001", 1, async (done: Function) => {
      Logger.info(TAG, `${BUNDLE}ThreadDataTransfer_001 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      await driver.swipe(10, 800, 10, 0, 600);
      await driver.delayMs(500);
      let threadDataTransfer: Component = await driver.findComponent(ON.text('ThreadDataTransfer'));
      await driver.delayMs(500);
      await threadDataTransfer.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text(getContext()
        .resourceManager
        .getStringSync($r('app.string.saturation'))));
      await driver.delayMs(200);
      await driver.assertComponentExist(ON.text(getContext().resourceManager.getStringSync($r('app.string.task_num'))));
      await driver.delayMs(200);
      await driver.assertComponentExist(ON.text(getContext()
        .resourceManager
        .getStringSync($r('app.string.pass_params'))));
      await driver.delayMs(200);
      let transferData: Component = await driver.findComponent(ON.text(getContext()
        .resourceManager
        .getStringSync($r('app.string.start_transfer'))));
      await driver.delayMs(200);
      await driver.assertComponentExist(ON.text(getContext()
        .resourceManager
        .getStringSync($r('app.string.running_time'))));
      await driver.delayMs(200);
      await transferData.click();
      await driver.delayMs(500);
      let slider: Component = await driver.findComponent(ON.id('thread_transfer_data_slider'));
      await driver.delayMs(500);
      await slider.click();
      await driver.delayMs(70000);
      await driver.pressBack();
      await driver.delayMs(500);
      Logger.info(TAG, `${BUNDLE}ThreadDataTransfer_001 end`);
      done();
    })

    /**
     * DFXStateManagement 查看内容
     */
    it(BUNDLE + "DFXStateManagement", 2, async (done: Function) => {
      Logger.info(TAG, `${BUNDLE}DFXStateManagement begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(1000);
      let scrollBar: Component = await driver.findComponent(ON.type("Scroll"));
      let ifElseComponent = await scrollBar.scrollSearch(ON.text("DFX StateManagement"));
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text("DFX StateManagement"))
      await driver.delayMs(500);
      await ifElseComponent.click();
      await driver.delayMs(1000);
      let showChange1: Component = await driver.findComponent(ON.text(await getResourceString($r('app.string.before_optimization'))));
      await driver.delayMs(500);
      await showChange1.click();
      await driver.delayMs(1000);
      let showChange3: Component = await driver.findComponent(ON.text("Move"));
      await driver.delayMs(500);
      await showChange3.click();
      await showChange3.click();
      await showChange3.click();
      let showChange4: Component = await driver.findComponent(ON.text("Scale"));
      await driver.delayMs(500);
      await showChange4.click();
      await showChange4.click();
      await showChange4.click();
      await driver.delayMs(500);
      await driver.pressBack();

      await driver.delayMs(1000);
      let showChange2: Component = await driver.findComponent(ON.text(await getResourceString($r('app.string.after_optimization'))));
      await driver.delayMs(500);
      await showChange2.click();
      await driver.delayMs(1000);
      let showChange6: Component = await driver.findComponent(ON.text("Move"));
      await driver.delayMs(500);
      await showChange6.click();
      await showChange6.click();
      await showChange6.click();
      let showChange7: Component = await driver.findComponent(ON.text("Scale"));
      await driver.delayMs(500);
      await showChange7.click();
      await showChange7.click();
      await showChange7.click();
      await driver.delayMs(500);
      await driver.pressBack();
      Logger.info(TAG, `${BUNDLE}DFXStateManagement end`);
      await driver.pressBack();
      done();
    })

  })
}