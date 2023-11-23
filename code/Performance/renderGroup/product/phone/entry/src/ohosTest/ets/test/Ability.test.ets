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
import { Driver, ON } from '@ohos.UiTest';
import Logger from '../util/Logger';
import Want from '@ohos.app.ability.Want';

const BUNDLE = 'Performance';
const TAG = '[Sample_Performance_Test]';
const delegator = AbilityDelegatorRegistry.getAbilityDelegator();

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    /**
     * 打开应用
     */
    it(BUNDLE + '_startAbility', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + '_startAbility start')
      let want: Want = {
        bundleName: 'com.example.performance',
        abilityName: 'EntryAbility'
      }
      delegator.startAbility(want, (err, data) => {
        Logger.info(TAG, 'StartAbility get err ' + JSON.stringify(err))
        expect(err).assertNull()
      })
      Logger.info(TAG, BUNDLE + '_startAbility end')
      done()
    })

    /**
     * 点击RenderGroup
     */
    it(BUNDLE + 'RenderGroupFunction_001', 1, async (done: Function) => {
      Logger.info(TAG, `${BUNDLE}RenderGroupFunction_001 begin`);
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 点击RenderGroup跳转到RenderGroup页面
      Logger.info(TAG, `${BUNDLE}RenderGroupFunction_001 RenderGroup`);
      await driver.assertComponentExist(ON.id('RenderGroup'))
      let RenderGroup = await driver.findComponent(ON.id('RenderGroup'))
      await RenderGroup.click()
      await driver.delayMs(1000)
      // 点击正例场景示例
      Logger.info(TAG, `${BUNDLE}RenderGroupFunction_001 ProfitScenePage`);
      await driver.assertComponentExist(ON.id('ProfitScenePage'))
      let ProfitScenePage = await driver.findComponent(ON.id('ProfitScenePage'))
      await ProfitScenePage.click()
      await driver.delayMs(1000)
      // 点击renderGroup开关按钮
      Logger.info(TAG, `${BUNDLE}RenderGroupFunction_001 renderGroupSwitch`);
      await driver.assertComponentExist(ON.id('renderGroupSwitch'))
      let renderGroupSwitch = await driver.findComponent(ON.id('renderGroupSwitch'))
      await renderGroupSwitch.click()
      await driver.delayMs(1000)
      // 点击返回场景主页
      await driver.assertComponentExist(ON.id('returnBtn'))
      let returnScenePageBtn = await driver.findComponent(ON.id('returnBtn'))
      await returnScenePageBtn.click()
      await driver.delayMs(1000)
      Logger.info(TAG, BUNDLE + 'RenderGroupFunction_001 end')

      done();
    })

    /**
     * 点击RenderGroup反例场景
     */
    it(BUNDLE + 'RenderGroupFunction_002', 2, async (done: Function) => {
      Logger.info(TAG, `${BUNDLE}RenderGroupFunction_002 begin`);
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 点击反例场景示例
      Logger.info(TAG, `${BUNDLE}RenderGroupFunction_002 NonProfitScenePage`);
      await driver.assertComponentExist(ON.id('NonProfitScenePage'))
      let NonProfitScenePage = await driver.findComponent(ON.id('NonProfitScenePage'))
      await NonProfitScenePage.click()
      await driver.delayMs(1000)
      // 点击renderGroup开关按钮
      Logger.info(TAG, `${BUNDLE}RenderGroupFunction_002 renderGroupSwitch`);
      await driver.assertComponentExist(ON.id('renderGroupSwitch'))
      let renderGroupSwitch = await driver.findComponent(ON.id('renderGroupSwitch'))
      await renderGroupSwitch.click()
      await driver.delayMs(1000)
      // 点击返回场景主页
      await driver.assertComponentExist(ON.id('returnBtn'))
      let returnScenePageBtn = await driver.findComponent(ON.id('returnBtn'))
      await returnScenePageBtn.click()
      await driver.delayMs(1000)
      Logger.info(TAG, BUNDLE + 'RenderGroupFunction_002 returnBtn')
      // 点击返回主页
      await driver.assertComponentExist(ON.id('returnBtn'))
      let returnRenderGroupBtn = await driver.findComponent(ON.id('returnBtn'))
      await returnRenderGroupBtn.click()
      await driver.delayMs(1000)
      Logger.info(TAG, BUNDLE + 'RenderGroupFunction_002 end')

      done();
    })

  })
}