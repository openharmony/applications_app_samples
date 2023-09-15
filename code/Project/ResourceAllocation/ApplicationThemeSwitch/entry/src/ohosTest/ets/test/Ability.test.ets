/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import Logger from '../utils/Logger';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

const BUNDLE = 'themeSwitch';
const DRIVER = Driver.create();
let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();


export default function abilityTest() {
  describe('ActsAbilityTest', function () {

    /**
     * 启动应用
     */
    it('StartAbility_001', 0, async function (done) {
      Logger.info(BUNDLE, 'StartAbility_001 begin');
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'ohos.example.themeswitch',
          abilityName: 'MainAbility'
        });
        done();
      } catch (err) {
        expect(err.code).assertEqual(0);
      }
      Logger.info(BUNDLE, 'StartAbility_001 end');
    })

    /**
     * 切换主题弹窗
     */
    it('changeThemeDialog_001', 0, async (done) => {
      Logger.info(BUNDLE, 'changeThemeDialog_001 begin');
      let ability = await abilityDelegatorRegistry.getCurrentTopAbility();
      let manager = ability.context.resourceManager;
      await DRIVER.delayMs(1000);
      // 是否存在“点击切换主题”
      await DRIVER.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.ClickAndSwitchTheme'))));
      let themeBtn = await DRIVER.findComponent(ON.text(await manager.getStringValue($r('app.string.ClickAndSwitchTheme'))));
      await themeBtn.click();
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.Day'))));
      await DRIVER.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.Night'))));
      await DRIVER.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.Custom'))));
      done();
      Logger.info(BUNDLE, 'changeThemeDialog_001 end');
    })

    /**
     * 切换到白天
     */
    it('changeToDay_001', 0, async (done) => {
      Logger.info(BUNDLE, 'changeToDay_001 begin');
      let ability = await abilityDelegatorRegistry.getCurrentTopAbility();
      let manager = ability.context.resourceManager;
      let dayOption = await DRIVER.findComponent(ON.text(await manager.getStringValue($r('app.string.Day'))));
      await dayOption.click();
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('1'))
      done();
      Logger.info(BUNDLE, 'changeToDay_001 end');
    })

    /**
     * 切换到夜晚
     */
    it('changeToNight_001', 0, async (done) => {
      Logger.info(BUNDLE, 'changeToNight_001 begin');
      let ability = await abilityDelegatorRegistry.getCurrentTopAbility();
      let manager = ability.context.resourceManager;
      await DRIVER.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.CurrentSystemTheme'))));
      let themeBtn = await DRIVER.findComponent(ON.text(await manager.getStringValue($r('app.string.CurrentSystemTheme'))));
      await themeBtn.click();
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.Night'))));
      let nightOption = await DRIVER.findComponent(ON.text(await manager.getStringValue($r('app.string.Night'))));
      await nightOption.click();
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('0'));
      done();
      Logger.info(BUNDLE, 'changeToNight_001 end');
    })

    /**
     * 切换到自定义
     */
    it('changeToCustom_001', 0, async (done) => {
      Logger.info(BUNDLE, 'changeToCustom_001 begin');
      let ability = await abilityDelegatorRegistry.getCurrentTopAbility();
      let manager = ability.context.resourceManager;
      await DRIVER.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.CurrentSystemTheme'))));
      let themeBtn = await DRIVER.findComponent(ON.text(await manager.getStringValue($r('app.string.CurrentSystemTheme'))));
      await themeBtn.click();
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.Custom'))));
      let nightOption = await DRIVER.findComponent(ON.text(await manager.getStringValue($r('app.string.Custom'))));
      await nightOption.click();
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('3'));
      done();
      Logger.info(BUNDLE, 'changeToCustom_001 end');
    })

    /**
     * 切换回白天
     */
    it('changeToDay_002', 0, async (done) => {
      Logger.info(BUNDLE, 'changeToDay_002 begin');
      let ability = await abilityDelegatorRegistry.getCurrentTopAbility();
      let manager = ability.context.resourceManager;
      await DRIVER.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.CurrentSystemTheme'))));
      let themeBtn = await DRIVER.findComponent(ON.text(await manager.getStringValue($r('app.string.CurrentSystemTheme'))));
      await themeBtn.click();
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.Day'))));
      let dayOption = await DRIVER.findComponent(ON.text(await manager.getStringValue($r('app.string.Day'))));
      await dayOption.click();
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('1'));
      done();
      Logger.info(BUNDLE, 'changeToDay_002 end');
    })
  })
}