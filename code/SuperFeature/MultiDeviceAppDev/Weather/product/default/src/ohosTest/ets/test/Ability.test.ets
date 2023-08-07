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

import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { describe, it, expect } from '@ohos/hypium';
import { Driver, ON, MatchPattern } from '@ohos.UiTest';
import { logger } from '../util/Logger';

const TAG = '[Sample_Weather]';
const BUNDLE = 'Weather_';
const driver = Driver.create();

export default function abilityTest() {
  describe('AbilityTest', function () {
    // 启动应用，进入首页
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      logger.info(TAG, `${BUNDLE}StartAbility_001 begin`);
      let delegator = AbilityDelegatorRegistry.getAbilityDelegator();
      let want = {
        bundleName: "ohos.samples.weather",
        abilityName: "MainAbility"
      };
      delegator.startAbility(want, (err) => {
        logger.info(TAG, `${BUNDLE}startAbility end err ${JSON.stringify(err)}`);
      })
      await driver.delayMs(1000);
      await delegator.getCurrentTopAbility().then((Ability) => {
        console.info("get top ability");
        expect(Ability.context.abilityInfo.name).assertEqual('MainAbility');
      })
      logger.info(TAG, `${BUNDLE}StartAbility_001 end`);
      done();
    })

    // 侧边栏隐藏和显示
    it(BUNDLE + 'Slider_001', 0, async function (done) {
      logger.info(TAG, `${BUNDLE}Slider_001 begin`)
      if(AppStorage.Get('curBp') == 'lg') {
        await driver.assertComponentExist(ON.id('cancelSubarea'));
        let cancelSlider = await driver.findComponent(ON.id('cancelSubarea'));
        await cancelSlider.click();
        await driver.assertComponentExist(ON.id('iconSubarea'));
        let subarea = await driver.findComponent(ON.id('iconSubarea'));
        await subarea.click();
        await driver.assertComponentExist(ON.id('cancelSubarea'));
      }
      logger.info(TAG, `${BUNDLE}Slider_001 end`);
      done();
    })

    // 侧边栏中点击切换城市
    it(BUNDLE + 'Slider_002', 0, async function (done) {
      logger.info(TAG, `${BUNDLE}Slider_001 begin`)
      if(AppStorage.Get('curBp') == 'lg') {
        await driver.assertComponentExist(ON.id('sliderCity1'));
        let shanghai = await driver.findComponent(ON.id('sliderCity1'));
        await shanghai.click();
        await driver.assertComponentExist(ON.id('homeContent1'));
        await driver.assertComponentExist(ON.id('sliderCity0'));
        let beijing = await driver.findComponent(ON.id('sliderCity0'));
        await beijing.click();
        await driver.assertComponentExist(ON.id('homeContent0'));
        await driver.assertComponentExist(ON.id('cancelSubarea'));
        let cancelSlider1 = await driver.findComponent(ON.id('cancelSubarea'));
        await cancelSlider1.click();
        await driver.assertComponentExist(ON.id('iconSubarea'));
      }
      logger.info(TAG, `${BUNDLE}Slider_002 end`);
      done();
    })

    //Swiper滑动切换城市
    it(BUNDLE + 'Home_001', 0, async function (done) {
      logger.info(TAG, `${BUNDLE}Home_001 begin`);
      await driver.assertComponentExist(ON.id('homeContent0'));
      await driver.swipe(500, 200, 100, 200);
      await driver.assertComponentExist(ON.id('homeContent1'));
      await driver.swipe(100, 200, 500, 200);
      await driver.assertComponentExist(ON.id('homeContent0'));
      logger.info(TAG, `${BUNDLE}Home_001 end`);
      done();
    })

    // 更新间隔
    it(BUNDLE + 'UpdateTime_001', 0, async function (done) {
      logger.info(TAG, `${BUNDLE}UpdateTime_001 begin`)
      let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();
      // 获取ability
      let ability = await abilityDelegatorRegistry.getCurrentTopAbility();
      //获取manager
      let manager = ability.context.resourceManager;
      // 点击弹出菜单
      await driver.assertComponentExist(ON.id('menuPopup'));
      let iconMore = await driver.findComponent(ON.id('menuPopup'));
      await iconMore.click();
      // 点击弹出更新时间弹窗
      await driver.assertComponentExist(ON.id('menu1'));
      let city = await driver.findComponent(ON.id('menu1'));
      await city.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.cancel')), MatchPattern.CONTAINS));
      let cancel = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.cancel')), MatchPattern.CONTAINS));
      await cancel.click();
      logger.info(TAG, `${BUNDLE}UpdateTime_001 end`);
      done();
    })

    // 点击弹出菜单
    it(BUNDLE + 'City_001', 0, async function (done) {
      logger.info(TAG, `${BUNDLE}City_001 begin`);
      let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();
      // 获取ability
      let ability = await abilityDelegatorRegistry.getCurrentTopAbility();
      //获取manager
      let manager = ability.context.resourceManager;
      // 点击弹出菜单
      await driver.assertComponentExist(ON.id('menuPopup'));
      let iconMore = await driver.findComponent(ON.id('menuPopup'));
      await iconMore.click();
      // 点击菜单进入管理城市
      await driver.assertComponentExist(ON.id('menu0'));
      let city = await driver.findComponent(ON.id('menu0'));
      await city.click();
      await driver.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.bei_jing')), MatchPattern.CONTAINS));
      await driver.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.shang_hai')), MatchPattern.CONTAINS));
      logger.info(TAG, `${BUNDLE}City_001 end`);
      done();
    })

    // 添加城市
    it(BUNDLE + 'AddCity_001', 0, async function (done) {
      logger.info(TAG, `${BUNDLE}AddCity_001 begin`);
      let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();
      // 获取ability
      let ability = await abilityDelegatorRegistry.getCurrentTopAbility();
      //获取manager
      let manager = ability.context.resourceManager;
      // 点击菜单进入管理城市
      await driver.assertComponentExist(ON.id('addCity'));
      let addCity = await driver.findComponent(ON.id('addCity'));
      await addCity.click();
      // 添加城市
      await driver.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.wu_han')), MatchPattern.CONTAINS));
      let city = await driver.findComponent(ON.text(await manager.getStringValue($r('app.string.wu_han')), MatchPattern.CONTAINS));
      await city.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.wu_han')), MatchPattern.CONTAINS));
      // 返回首页
      await driver.pressBack();
      logger.info(TAG, `${BUNDLE}AddCity_001 end`);
      done();
    })
  })
}