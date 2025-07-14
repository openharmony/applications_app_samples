/*
 * Copyright (c) 2021-2025 Huawei Device Co., Ltd.
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
import { Driver, ON } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import hilog from '@ohos.hilog';
import Want from '@ohos.app.ability.Want';

const TAG = '[Sample_DefiningPageLayoutAndConnection]';
const DOMAIN = 0xF811;
const BUNDLE = 'DefiningPageLayoutAndConnection_';

export default function appTest() {
  describe('appTest', () => {
    it('StartAbility_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin');
      const abilityDelegator: AbilityDelegatorRegistry.AbilityDelegator = AbilityDelegatorRegistry
        .getAbilityDelegator();
      const bundleName = AbilityDelegatorRegistry.getArguments().bundleName;
      let want: Want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      abilityDelegator.startAbility(want, (err) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001,err:' + JSON.stringify(err));
        done();
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end');
      });
    })

    /**
     * Grid布局 查看foodGridItem1详情
     */
    it('FoodGridFunction_001', 0, async () => {
      // create Driver
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_001 begin')
      let driver = Driver.create();
      await driver.delayMs(2000);
      // foodDetail
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_001 foodDetail');
      await driver.assertComponentExist(ON.id('foodGridItem1'));
      let foodGridItem1 = await driver.findComponent(ON.id('foodGridItem1'));
      await foodGridItem1.click();
      await driver.delayMs(1000);
      // 返回上一级
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_001 back');
      await driver.assertComponentExist(ON.id('back'));
      let backBtn = await driver.findComponent(ON.id('back'));
      await backBtn.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_001 end');
    })

    /**
     * Grid布局 查看foodGridItem2详情
     */
    it('FoodGridFunction_002', 0, async () => {
      // create Driver
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_002 begin')
      let driver = Driver.create();
      await driver.delayMs(2000);
      // foodDetail
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_002 foodDetail');
      await driver.assertComponentExist(ON.id('foodGridItem2'));
      let foodGridItem2 = await driver.findComponent(ON.id('foodGridItem2'));
      await foodGridItem2.click();
      await driver.delayMs(1000);
      // 返回上一级
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_002 back');
      await driver.assertComponentExist(ON.id('back'));
      let backBtn = await driver.findComponent(ON.id('back'));
      await backBtn.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_002 end');
    })

    /**
     * Grid布局 查看foodGridItem3详情
     */
    it('FoodGridFunction_003', 0, async () => {
      // create Driver
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_003 begin')
      let driver = Driver.create();
      await driver.delayMs(2000);
      // foodDetail
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_003 foodDetail');
      await driver.assertComponentExist(ON.id('foodGridItem3'));
      let foodGridItem3 = await driver.findComponent(ON.id('foodGridItem3'));
      await foodGridItem3.click();
      await driver.delayMs(1000);
      // 返回上一级
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_003 back');
      await driver.assertComponentExist(ON.id('back'));
      let backBtn = await driver.findComponent(ON.id('back'));
      await backBtn.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_003 end');
    })

    /**
     * Grid布局 查看foodGridItem4详情
     */
    it('FoodGridFunction_004', 0, async () => {
      // create Driver
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_004 begin')
      let driver = Driver.create();
      await driver.delayMs(2000);
      // foodDetail
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_004 foodDetail');
      await driver.assertComponentExist(ON.id('foodGridItem4'));
      let foodGridItem4 = await driver.findComponent(ON.id('foodGridItem4'));
      await foodGridItem4.click();
      await driver.delayMs(1000);
      // 返回上一级
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_004 back');
      await driver.assertComponentExist(ON.id('back'));
      let backBtn = await driver.findComponent(ON.id('back'));
      await backBtn.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_004 end');
    })

    /**
     * Grid布局 查看foodGridItem5详情
     */
    it('FoodGridFunction_005', 0, async () => {
      // create Driver
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_005 begin')
      let driver = Driver.create();
      await driver.delayMs(2000);
      // foodDetail
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_005 foodDetail');
      await driver.assertComponentExist(ON.id('foodGridItem5'));
      let foodGridItem5 = await driver.findComponent(ON.id('foodGridItem5'));
      await foodGridItem5.click();
      await driver.delayMs(1000);
      // 返回上一级
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_005 back');
      await driver.assertComponentExist(ON.id('back'));
      let backBtn = await driver.findComponent(ON.id('back'));
      await backBtn.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_005 end');
    })

    /**
     * Grid布局 查看foodGridItem6详情
     */
    it('FoodGridFunction_006', 0, async () => {
      // create Driver
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_006 begin')
      let driver = Driver.create();
      await driver.delayMs(2000);
      // foodDetail
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_006 foodDetail');
      await driver.assertComponentExist(ON.id('foodGridItem6'));
      let foodGridItem6 = await driver.findComponent(ON.id('foodGridItem6'));
      await foodGridItem6.click();
      await driver.delayMs(1000);
      // 返回上一级
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_006 back');
      await driver.assertComponentExist(ON.id('back'));
      let backBtn = await driver.findComponent(ON.id('back'));
      await backBtn.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_006 end');
    })

    /**
     * Grid布局 查看foodGridItem7详情
     */
    it('FoodGridFunction_007', 0, async () => {
      // create Driver
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_007 begin')
      let driver = Driver.create();
      await driver.delayMs(2000);
      // foodDetail
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_007 foodDetail');
      await driver.assertComponentExist(ON.id('foodGridItem7'));
      let foodGridItem7 = await driver.findComponent(ON.id('foodGridItem7'));
      await foodGridItem7.click();
      await driver.delayMs(1000);
      // 返回上一级
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_007 back');
      await driver.assertComponentExist(ON.id('back'));
      let backBtn = await driver.findComponent(ON.id('back'));
      await backBtn.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_007 end');
    })

    /**
     * Grid布局 查看foodGridItem8详情
     */
    it('FoodGridFunction_008', 0, async () => {
      // create Driver
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_008 begin')
      let driver = Driver.create();
      await driver.delayMs(2000);
      // foodDetail
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_008 foodDetail');
      await driver.assertComponentExist(ON.id('foodGridItem8'));
      let foodGridItem8 = await driver.findComponent(ON.id('foodGridItem8'));
      await foodGridItem8.click();
      await driver.delayMs(1000);
      // 返回上一级
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_008 back');
      await driver.assertComponentExist(ON.id('back'));
      let backBtn = await driver.findComponent(ON.id('back'));
      await backBtn.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_008 end');
    })

    /**
     * Grid布局 查看foodGridItem9详情
     */
    it('FoodGridFunction_009', 0, async () => {
      // create Driver
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_009 begin')
      let driver = Driver.create();
      await driver.delayMs(2000);
      // swipe list
      await driver.swipe(200, 800, 200, 200, 1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_009 swipe end');
      // foodDetail
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_009 foodDetail');
      await driver.assertComponentExist(ON.id('foodGridItem9'));
      let foodGridItem9 = await driver.findComponent(ON.id('foodGridItem9'));
      await foodGridItem9.click();
      await driver.delayMs(1000);
      // 返回上一级
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_009 back');
      await driver.assertComponentExist(ON.id('back'));
      let backBtn = await driver.findComponent(ON.id('back'));
      await backBtn.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_009 end');
    })

    /**
     * Grid布局 查看foodGridItem10详情
     */
    it('FoodGridFunction_010', 0, async () => {
      // create Driver
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_010 begin')
      let driver = Driver.create();
      await driver.delayMs(2000);
      // foodDetail
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_010 foodDetail');
      await driver.assertComponentExist(ON.id('foodGridItem10'));
      let foodGridItem10 = await driver.findComponent(ON.id('foodGridItem10'));
      await foodGridItem10.click();
      await driver.delayMs(1000);
      // 返回上一级
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_010 back');
      await driver.assertComponentExist(ON.id('back'));
      let backBtn = await driver.findComponent(ON.id('back'));
      await backBtn.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_010 end');
    })

    /**
     * Grid布局 查看foodGridItem11详情
     */
    it('FoodGridFunction_011', 0, async () => {
      // create Driver
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_011 begin')
      let driver = Driver.create();
      await driver.delayMs(2000);
      // foodDetail
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_011 foodDetail');
      await driver.assertComponentExist(ON.id('foodGridItem11'));
      let foodGridItem11 = await driver.findComponent(ON.id('foodGridItem11'));
      await foodGridItem11.click();
      await driver.delayMs(1000);
      // 返回上一级
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_011 back');
      await driver.assertComponentExist(ON.id('back'));
      let backBtn = await driver.findComponent(ON.id('back'));
      await backBtn.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_011 end');
    })

    /**
     * Grid布局 查看foodGridItem12详情
     */
    it('FoodGridFunction_012', 0, async () => {
      // create Driver
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_012 begin')
      let driver = Driver.create();
      await driver.delayMs(2000);
      // foodDetail
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_012 foodDetail');
      await driver.assertComponentExist(ON.id('foodGridItem12'));
      let foodGridItem12 = await driver.findComponent(ON.id('foodGridItem12'));
      await foodGridItem12.click();
      await driver.delayMs(1000);
      // 返回上一级
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_012 back');
      await driver.assertComponentExist(ON.id('back'));
      let backBtn = await driver.findComponent(ON.id('back'));
      await backBtn.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodGridFunction_012 end');
    })

    /**
     * Grid布局 查看VegetableList详情
     */
    it('VegetableGridFunction_001', 0, async () => {
      // create Driver
      hilog.info(DOMAIN, TAG, BUNDLE + 'VegetableGridFunction_001 begin')
      let driver = Driver.create();
      await driver.delayMs(2000);
      // switch foodlist
      hilog.info(DOMAIN, TAG, BUNDLE + 'VegetableGridFunction_001 foodDetail');
      let vegetableText = getContext().resourceManager.getStringSync($r('app.string.Category_Vegetable'));
      await driver.assertComponentExist(ON.text(vegetableText));
      let vegetableBtn = await driver.findComponent(ON.text(vegetableText));
      await vegetableBtn.click();
      await driver.delayMs(1000);
      // food detail
      for (let i = 1; i < 5; i++) {
        hilog.info(DOMAIN, TAG, BUNDLE + 'VegetableGridFunction_001 foodDetail');
        await driver.assertComponentExist(ON.id('foodGridItem'+i));
        let foodGridItem = await driver.findComponent(ON.id('foodGridItem'+i));
        await foodGridItem.click();
        await driver.delayMs(1000);
        // 返回上一级
        hilog.info(DOMAIN, TAG, BUNDLE + 'VegetableGridFunction_001 back');
        await driver.assertComponentExist(ON.id('back'));
        let backBtn = await driver.findComponent(ON.id('back'));
        await backBtn.click();
        await driver.delayMs(1000);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'VegetableGridFunction_001 end');
    })

    /**
     * Grid布局 查看FruitList详情
     */
    it('FruitGridFunction_001', 0, async () => {
      // create Driver
      hilog.info(DOMAIN, TAG, BUNDLE + 'FruitGridFunction_001 begin')
      let driver = Driver.create();
      await driver.delayMs(2000);
      // switch foodlist
      hilog.info(DOMAIN, TAG, BUNDLE + 'FruitGridFunction_001 foodDetail');
      let fruitText = getContext().resourceManager.getStringSync($r('app.string.Category_Fruit'));
      await driver.assertComponentExist(ON.text(fruitText));
      let fruitBtn = await driver.findComponent(ON.text(fruitText));
      await fruitBtn.click();
      await driver.delayMs(1000);
      // food detail
      for (let i = 1; i < 6; i++) {
        hilog.info(DOMAIN, TAG, BUNDLE + 'FruitGridFunction_001 foodDetail');
        await driver.assertComponentExist(ON.id('foodGridItem'+i));
        let foodGridItem = await driver.findComponent(ON.id('foodGridItem'+i));
        await foodGridItem.click();
        await driver.delayMs(1000);
        // 返回上一级
        hilog.info(DOMAIN, TAG, BUNDLE + 'FruitGridFunction_001 back');
        await driver.assertComponentExist(ON.id('back'));
        let backBtn = await driver.findComponent(ON.id('back'));
        await backBtn.click();
        await driver.delayMs(1000);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'FruitGridFunction_001 end');
    })

    /**
     * Grid布局 查看NutList详情
     */
    it('NutGridFunction_001', 0, async () => {
      // create Driver
      hilog.info(DOMAIN, TAG, BUNDLE + 'NutGridFunction_001 begin')
      let driver = Driver.create();
      await driver.delayMs(2000);
      // switch foodlist
      hilog.info(DOMAIN, TAG, BUNDLE + 'NutGridFunction_001 foodDetail');
      let nutText = getContext().resourceManager.getStringSync($r('app.string.Category_Nut'));
      await driver.assertComponentExist(ON.text(nutText));
      let nutBtn = await driver.findComponent(ON.text(nutText));
      await nutBtn.click();
      await driver.delayMs(1000);
      // food detail
        hilog.info(DOMAIN, TAG, BUNDLE + 'NutGridFunction_001 foodDetail');
        await driver.assertComponentExist(ON.id('foodGridItem1'));
        let foodGridItem = await driver.findComponent(ON.id('foodGridItem1'));
        await foodGridItem.click();
        await driver.delayMs(1000);
        // 返回上一级
        hilog.info(DOMAIN, TAG, BUNDLE + 'NutGridFunction_001 back');
        await driver.assertComponentExist(ON.id('back'));
        let backBtn = await driver.findComponent(ON.id('back'));
        await backBtn.click();
        await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'NutGridFunction_001 end');
    })

    /**
     * Grid布局 查看SeafoodList详情
     */
    it('SeafoodGridFunction_001', 0, async () => {
      // create Driver
      hilog.info(DOMAIN, TAG, BUNDLE + 'SeafoodGridFunction_001 begin')
      let driver = Driver.create();
      await driver.delayMs(2000);
      // switch foodlist
      hilog.info(DOMAIN, TAG, BUNDLE + 'SeafoodGridFunction_001 foodDetail');
      let seafoodText = getContext().resourceManager.getStringSync($r('app.string.Category_Seafood'));
      await driver.assertComponentExist(ON.text(seafoodText));
      let seafoodBtn = await driver.findComponent(ON.text(seafoodText));
      await seafoodBtn.click();
      await driver.delayMs(1000);
      // food detail
      hilog.info(DOMAIN, TAG, BUNDLE + 'SeafoodGridFunction_001 foodDetail');
      await driver.assertComponentExist(ON.id('foodGridItem1'));
      let foodGridItem = await driver.findComponent(ON.id('foodGridItem1'));
      await foodGridItem.click();
      await driver.delayMs(1000);
      // 返回上一级
      hilog.info(DOMAIN, TAG, BUNDLE + 'SeafoodGridFunction_001 back');
      await driver.assertComponentExist(ON.id('back'));
      let backBtn = await driver.findComponent(ON.id('back'));
      await backBtn.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'SeafoodGridFunction_001 end');
    })

    /**
     * Grid布局 查看DessertList详情
     */
    it('DessertGridFunction_001', 0, async () => {
      // create Driver
      hilog.info(DOMAIN, TAG, BUNDLE + 'DessertGridFunction_001 begin')
      let driver = Driver.create();
      await driver.delayMs(2000);
      // switch foodlist
      hilog.info(DOMAIN, TAG, BUNDLE + 'DessertGridFunction_001 foodDetail');
      let dessertText = getContext().resourceManager.getStringSync($r('app.string.Category_Dessert'));
      await driver.assertComponentExist(ON.text(dessertText));
      let dessertBtn = await driver.findComponent(ON.text(dessertText));
      await dessertBtn.click();
      await driver.delayMs(1000);
      // food detail
      hilog.info(DOMAIN, TAG, BUNDLE + 'DessertGridFunction_001 foodDetail');
      await driver.assertComponentExist(ON.id('foodGridItem1'));
      let foodGridItem = await driver.findComponent(ON.id('foodGridItem1'));
      await foodGridItem.click();
      await driver.delayMs(1000);
      // 返回上一级
      hilog.info(DOMAIN, TAG, BUNDLE + 'NutGridFunction_001 back');
      await driver.assertComponentExist(ON.id('back'));
      let backBtn = await driver.findComponent(ON.id('back'));
      await backBtn.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'DessertGridFunction_001 end');
    })

    /**
     * 切换布局
     */
    it('SwitchLayoutFunction_001', 0, async () => {
      // create Driver
      hilog.info(DOMAIN, TAG, BUNDLE + 'SwitchLayoutFunction_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // switchLayout
      hilog.info(DOMAIN, TAG, BUNDLE + 'SwitchLayoutFunction_001 switchLayout');
      await driver.assertComponentExist(ON.id('switch'));
      let switchBtn = await driver.findComponent(ON.id('switch'));
      await switchBtn.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'SwitchLayoutFunction_001 end');
    })

    /**
     * List布局 查看详情
     */
    it('FoodListFunction_001', 0, async () => {
      // create Driver
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodListFunction_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // foodDetail
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodListFunction_001 foodDetail');
      await driver.assertComponentExist(ON.id('foodListItem1'));
      let foodListItem1 = await driver.findComponent(ON.id('foodListItem1'));
      await foodListItem1.click();
      await driver.delayMs(1000);
      // 返回上一级
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodListFunction_001 back');
      await driver.assertComponentExist(ON.id('back'));
      let backBtn = await driver.findComponent(ON.id('back'));
      await backBtn.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodListFunction_001 end');
    })

    /**
     * List布局 查看详情
     */
    it('FoodListFunction_002', 0, async () => {
      // create Driver
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodListFunction_002 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // foodDetail
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodListFunction_002 foodDetail');
      await driver.assertComponentExist(ON.id('foodListItem2'));
      let foodListItem1 = await driver.findComponent(ON.id('foodListItem2'));
      await foodListItem1.click();
      await driver.delayMs(1000);
      // 返回上一级
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodListFunction_002 back');
      await driver.assertComponentExist(ON.id('back'));
      let backBtn = await driver.findComponent(ON.id('back'));
      await backBtn.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodListFunction_002 end');
    })

    /**
     * List布局 查看详情
     */
    it('FoodListFunction_003', 0, async () => {
      // create Driver
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodListFunction_003 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // foodDetail
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodListFunction_003 foodDetail');
      await driver.assertComponentExist(ON.id('foodListItem3'));
      let foodListItem1 = await driver.findComponent(ON.id('foodListItem3'));
      await foodListItem1.click();
      await driver.delayMs(1000);
      // 返回上一级
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodListFunction_003 back');
      await driver.assertComponentExist(ON.id('back'));
      let backBtn = await driver.findComponent(ON.id('back'));
      await backBtn.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodListFunction_003 end');
    })

    /**
     * List布局 查看详情
     */
    it('FoodListFunction_004', 0, async () => {
      // create Driver
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodListFunction_004 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // foodDetail
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodListFunction_004 foodDetail');
      await driver.assertComponentExist(ON.id('foodListItem4'));
      let foodListItem1 = await driver.findComponent(ON.id('foodListItem4'));
      await foodListItem1.click();
      await driver.delayMs(1000);
      // 返回上一级
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodListFunction_004 back');
      await driver.assertComponentExist(ON.id('back'));
      let backBtn = await driver.findComponent(ON.id('back'));
      await backBtn.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodListFunction_004 end');
    })

    /**
     * List布局 查看详情
     */
    it('FoodListFunction_005', 0, async () => {
      // create Driver
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodListFunction_005 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // foodDetail
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodListFunction_005 foodDetail');
      await driver.assertComponentExist(ON.id('foodListItem5'));
      let foodListItem1 = await driver.findComponent(ON.id('foodListItem5'));
      await foodListItem1.click();
      await driver.delayMs(1000);
      // 返回上一级
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodListFunction_005 back');
      await driver.assertComponentExist(ON.id('back'));
      let backBtn = await driver.findComponent(ON.id('back'));
      await backBtn.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodListFunction_005 end');
    })

    /**
     * List布局 查看详情
     */
    it('FoodListFunction_006', 0, async () => {
      // create Driver
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodListFunction_006 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // foodDetail
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodListFunction_006 foodDetail');
      await driver.assertComponentExist(ON.id('foodListItem6'));
      let foodListItem1 = await driver.findComponent(ON.id('foodListItem6'));
      await foodListItem1.click();
      await driver.delayMs(1000);
      // 返回上一级
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodListFunction_006 back');
      await driver.assertComponentExist(ON.id('back'));
      let backBtn = await driver.findComponent(ON.id('back'));
      await backBtn.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodListFunction_006 end');
    })

    /**
     * List布局 查看详情
     */
    it('FoodListFunction_007', 0, async () => {
      // create Driver
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodListFunction_007 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // foodDetail
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodListFunction_007 foodDetail');
      await driver.assertComponentExist(ON.id('foodListItem7'));
      let foodListItem1 = await driver.findComponent(ON.id('foodListItem7'));
      await foodListItem1.click();
      await driver.delayMs(1000);
      // 返回上一级
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodListFunction_007 back');
      await driver.assertComponentExist(ON.id('back'));
      let backBtn = await driver.findComponent(ON.id('back'));
      await backBtn.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodListFunction_007 end');
    })

    /**
     * List布局 查看详情
     */
    it('FoodListFunction_008', 0, async () => {
      // create Driver
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodListFunction_008 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // foodDetail
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodListFunction_008 foodDetail');
      await driver.assertComponentExist(ON.id('foodListItem8'));
      let foodListItem1 = await driver.findComponent(ON.id('foodListItem8'));
      await foodListItem1.click();
      await driver.delayMs(1000);
      // 返回上一级
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodListFunction_008 back');
      await driver.assertComponentExist(ON.id('back'));
      let backBtn = await driver.findComponent(ON.id('back'));
      await backBtn.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodListFunction_008 end');
    })

    /**
     * List布局 查看详情
     */
    it('FoodListFunction_009', 0, async () => {
      // create Driver
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodListFunction_009 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // foodDetail
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodListFunction_009 foodDetail');
      await driver.assertComponentExist(ON.id('foodListItem9'));
      let foodListItem1 = await driver.findComponent(ON.id('foodListItem9'));
      await foodListItem1.click();
      await driver.delayMs(1000);
      // 返回上一级
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodListFunction_009 back');
      await driver.assertComponentExist(ON.id('back'));
      let backBtn = await driver.findComponent(ON.id('back'));
      await backBtn.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodListFunction_009 end');
    })

    /**
     * List布局 查看详情
     */
    it('FoodListFunction_010', 0, async () => {
      // create Driver
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodListFunction_010 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // foodDetail
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodListFunction_010 foodDetail');
      await driver.assertComponentExist(ON.id('foodListItem10'));
      let foodListItem1 = await driver.findComponent(ON.id('foodListItem10'));
      await foodListItem1.click();
      await driver.delayMs(1000);
      // 返回上一级
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodListFunction_010 back');
      await driver.assertComponentExist(ON.id('back'));
      let backBtn = await driver.findComponent(ON.id('back'));
      await backBtn.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodListFunction_010 end');
    })

    /**
     * List布局 查看详情
     */
    it('FoodListFunction_011', 0, async () => {
      // create Driver
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodListFunction_011 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // foodDetail
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodListFunction_011 foodDetail');
      await driver.assertComponentExist(ON.id('foodListItem11'));
      let foodListItem1 = await driver.findComponent(ON.id('foodListItem11'));
      await foodListItem1.click();
      await driver.delayMs(1000);
      // 返回上一级
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodListFunction_011 back');
      await driver.assertComponentExist(ON.id('back'));
      let backBtn = await driver.findComponent(ON.id('back'));
      await backBtn.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'FoodListFunction_011 end');
    })
  })
}