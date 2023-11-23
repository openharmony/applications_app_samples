/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
      }
      delegator.startAbility(want, (err) => {
        Logger.info(TAG, 'StartAbility get err ' + JSON.stringify(err))
        expect(err).assertNull()
      })
      Logger.info(TAG, BUNDLE + '_startAbility end')
      done()
    })
    /**
     * 点击HiDumper按钮，进入HiDumper查看组件信息页面
     */
    it(BUNDLE + "HiDumperFunction_001", 2, async (done: Function) => {
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
    it(BUNDLE + "HiDumperFunction_002", 3, async (done: Function) => {
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
    it(BUNDLE + "HiDumperFunction_003", 4, async (done: Function) => {
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
    it(BUNDLE + "HiDumperFunction_004", 5, async (done: Function) => {
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
     * 进入查看SmartPerfHostFrameTimeline优化前页面，查看页面是否在正常显示
     */
    it(BUNDLE + "SmartPerfHostFrameTimeline01", 555, async (done: Function) => {
      Logger.info(TAG, `${BUNDLE}SmartPerfHostFrameTimeline01 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      await driver.pressBack()
      await driver.delayMs(500);
      await driver.pressBack()
      await driver.delayMs(500);
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
    it(BUNDLE + "SmartPerfHostFrameTimeline02", 556, async (done: Function) => {
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
    it(BUNDLE + "SmartPerfHostAPPStartup01", 557, async (done: Function) => {
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
    it(BUNDLE + "SmartPerfHostAPPStartup02", 558, async (done: Function) => {
      Logger.info(TAG, `${BUNDLE}SmartPerfHostAPPStartup02 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      let showChange: Component = await driver.findComponent(ON.text("AppStartup优化后代码"));
      await driver.delayMs(500);
      await showChange.click();
      await driver.delayMs(5000);
      await driver.pressBack();
      await driver.delayMs(500);
      Logger.info(TAG, `${BUNDLE}SmartPerfHostAPPStartup02 end`);
      done();
    })
  })
}