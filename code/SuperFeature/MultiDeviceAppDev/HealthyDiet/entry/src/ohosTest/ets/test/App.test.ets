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
import { describe, it, expect } from '@ohos/hypium';
import { Driver, ON, Component } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import Logger from '../util/Logger';

const BUNDLE = 'HealthyDiet_';
const TAG = 'AppTestPage';
let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      Logger.info(TAG, 'StartAbility start')
      let want = {
        bundleName: 'ohos.samples.healthy_diet',
        abilityName: 'MainAbility'
      }
      abilityDelegatorRegistry.startAbility(want, (err, data) => {
        Logger.info(TAG, `StartAbility get err ${JSON.stringify(err)}`);
        done()
        Logger.info(TAG, 'StartAbility end');
      });
      Logger.info(TAG, 'StartAbility end')
    })
    /**
     * 点击食物进入详情页面并记录食物，用例只支持RK3568
     */
    it(BUNDLE + 'IndexPage_EnterFoodDetail_001', 0, async function () {
      Logger.info(TAG, 'IndexPage_EnterFoodDetail_001 start');
      let driver = Driver.create();
      await driver.delayMs(5000);
      await driver.assertComponentExist(ON.id('foodItem0'));
      let tomato = await driver.findComponent(ON.id('foodItem0'));
      await driver.delayMs(1000);
      await tomato.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('record'));
      let record = await driver.findComponent(ON.id('record'));
      await record.click();
      await driver.delayMs(1000);
      Logger.info(TAG, 'IndexPage_EnterFoodDetail_001 end');
    })
    /**
     * 配置饮食标准，用例只支持RK3568
     */
    it(BUNDLE + 'FoodDetailPage_SetDiet_001', 0, async function () {
      Logger.info(TAG, 'FoodDetailPage_SetDiet_001 start');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 查看食物详细信息
      for (let i = 0;i < 4; i++) {
        // 坐标基于rk3568
        await driver.swipe(400, 829, 320, 829, 600);
        await driver.delayMs(1000);
      }
      // 设置饮食，用例只支持RK3568
      await driver.swipe(360, 960, 360, 900, 600);
      await driver.delayMs(1000);
      await driver.swipe(559, 960, 559, 900, 600);
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('complete'));
      let complete = await driver.findComponent(ON.id('complete'));
      await complete.click();
      await driver.delayMs(1000);
      // 返回到首页
      await driver.assertComponentExist(ON.id('backIndex'));
      let backIndex = await driver.findComponent(ON.id('backIndex'));
      await backIndex.click();
      await driver.delayMs(1000);
      Logger.info(TAG, 'FoodDetailPage_SetDiet_001 end');
    });
    /**
     * 删除记录，用例只支持RK3568
     */
    it(BUNDLE + 'RecordPage_DeleteRecord_001', 0, async function () {
      Logger.info(TAG, 'FoodDetailPage_SetDiet_001 start');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 切换到记录tab
      await driver.assertComponentExist(ON.id('tabTitle1'));
      let recordPage = await driver.findComponent(ON.id('tabTitle1'));
      await recordPage.click();
      await driver.delayMs(1000);
      // 校验记录是否添加成功
      if (await driver.findComponent(ON.id('noRecord'))) expect().assertFail();
      // 切换到营养元素视图
      await driver.swipe(300, 344, 400, 344, 600);
      await driver.delayMs(1000);
      // 用例只支持RK3568
      await driver.swipe(580, 914, 320, 914, 600);
      // 删除记录
      await driver.click(580, 956);
      await driver.delayMs(3000);
      if (await driver.findComponent(ON.id('mealFoodInfoIndex0'))) expect().assertFail();
      // 返回到首页
      await driver.delayMs(2000);
      await driver.assertComponentExist(ON.id('tabTitle0'));
      let homePage = await driver.findComponent(ON.id('tabTitle0'));
      await homePage.click();
      await driver.delayMs(1000);
      Logger.info(TAG, 'FoodDetailPage_SetDiet_001 end');
    });
    /**
     * 切换到食物列表
     */
    it(BUNDLE + 'IndexPage_SwitchFoodList_001', 0, async function () {
      Logger.info(TAG, 'IndexPage_SwitchFoodList_001 start');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 切换到食物里面
      await driver.assertComponentExist(ON.id('switch'));
      let switchPage = await driver.findComponent(ON.id('switch'));
      await switchPage.click();
      // 校验记录是否添加成功
      if (!await driver.findComponent(ON.id('foodList'))) expect().assertFail();
      // 进入食物详情
      let ability = await abilityDelegatorRegistry.getCurrentTopAbility();
      let resourceManager = ability.context.resourceManager;
      let foodName = await resourceManager.getStringValue($r('app.string.food_name_avocado'));
      await driver.assertComponentExist(ON.text(foodName));
      let avocado = await driver.findComponent(ON.text(foodName));
      await avocado.click();
      Logger.info(TAG, 'IndexPage_SwitchFoodList_001 end');
    });
  })
}
