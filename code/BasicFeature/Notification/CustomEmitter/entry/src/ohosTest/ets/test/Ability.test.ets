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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Driver, ON, MatchPattern } from '@ohos.UiTest';
import Want from '@ohos.app.ability.Want';
import Base from '@ohos.base';
import Logger from '../util/Logger';

const BUNDLE = 'CustomEmitter';
const TAG = '[Sample_CustomEmitter]';

export default function abilityTest() {
  describe('ActsAbilityTest', () => {

    /**
     * @tc.number CustomEmitterStartAbility
     * @tc.name   Customize Emitter
     * @tc.desc   Pull up an ability
     * @tc.size   MediumTest
     * @tc.type   Function
     * @tc.level  Level 0
     */
    it(BUNDLE + 'StartAbility', 0, async () => {
      Logger.info(TAG, 'StartAbility start');
      let driver = Driver.create();
      let want: Want = {
        bundleName: 'com.samples.customemitter',
        abilityName: 'MainAbility'
      };
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      abilityDelegator.startAbility(want, (err: Base.BusinessError) => {
        Logger.info(TAG, 'StartAbility get err ' + JSON.stringify(err));
        expect(err).assertNull();
      })
      await driver.delayMs(1000);
      Logger.info(TAG, 'StartAbility end');
    })

    /**
     * @tc.number CustomEmitterOpenDialog
     * @tc.name   Customize Emitter
     * @tc.desc   Check if the dialog is displayed and can be closed normally
     * @tc.size   MediumTest
     * @tc.type   Function
     * @tc.level  Level 1
     */
    it(BUNDLE + 'OpenDialog', 1, async (done: Function) => {
      Logger.info(TAG, 'OpenDialog start');
      let driver = Driver.create();
      let resourceManager = AbilityDelegatorRegistry.getAbilityDelegator().getAppContext().resourceManager;
      // 检查Dialog是否显示
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.shopping'))));
      let closeBtn = await driver.findComponent(
        ON.text(await resourceManager.getStringValue($r('app.string.close_icon'))));
      await closeBtn.click();
      await driver.delayMs(500);
      // 检查Dialog是否关闭
      let title = await driver.findComponent(
        ON.text(await resourceManager.getStringValue($r('app.string.shopping'))));
      await expect(title).assertNull();
      await driver.delayMs(500);
      Logger.info(TAG, 'OpenDialog end');
      done();
    })

    /**
     * @tc.number CustomEmitterOpenDetail
     * @tc.name   Customize Emitter
     * @tc.desc   Click on a certain product to check if it is redirected,This example takes a long time to run.
     *            Please adjust the Time Out to 120s to ensure the normal execution of the use case
     * @tc.size   MediumTest
     * @tc.type   Function
     * @tc.level  Level 2
     */
    it(BUNDLE + 'OpenDetail', 2, async (done: Function) => {
      Logger.info(TAG, 'OpenDetail start');
      let driver = Driver.create();
      let resourceManager = AbilityDelegatorRegistry.getAbilityDelegator().getAppContext().resourceManager;
      let idList = ['0', '1', '2'];  // 商品id列表
      for (let i: number = 0; i < idList.length; i++) {
        let goods = await driver.findComponent(ON.id(idList[i]));
        // 点击商品
        await expect(goods != null).assertTrue();
        await goods.click();
        await driver.delayMs(500);
        // 检查跳转后商品是否一致
        await driver.assertComponentExist(
          ON.text(await resourceManager.getStringValue($r('app.string.evaluate')), MatchPattern.CONTAINS));
        await driver.assertComponentExist(ON.id(idList[i]));
        await driver.pressBack();
        await driver.delayMs(500);
      }
      Logger.info(TAG, 'OpenDetail end');
      done();
    })

    /**
     * @tc.number CustomEmitterAddGoodsToCart
     * @tc.name   Customize Emitter
     * @tc.desc   Add a certain product to the shopping cart interface,This example takes a long time to run.
     *            Please adjust the Time Out to 120s to ensure the normal execution of the use case
     * @tc.size   MediumTest
     * @tc.type   Function
     * @tc.level  Level 3
     */
    it(BUNDLE + 'AddGoodsToCart', 3, async (done: Function) => {
      Logger.info(TAG, 'AddGoodsToCart start');
      let driver = Driver.create();
      let resourceManager = AbilityDelegatorRegistry.getAbilityDelegator().getAppContext().resourceManager;
      let cartTag = 'cart';
      let idList = ['0', '1', '2'];  // 商品id列表
      for (let i: number = 0; i < idList.length; i++) {
        let goods = await driver.findComponent(ON.id(idList[i]));
        // 点击商品
        await expect(goods != null).assertTrue();
        await goods.click();
        await driver.delayMs(500);
        // 检查跳转后商品是否一致
        await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.add_to_cart'))));
        await driver.assertComponentExist(ON.id(idList[i]));
        await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.shop_cart'))));
        // 点击添加商品到购物车当中
        let addBtn = await driver.findComponent(
          ON.text(await resourceManager.getStringValue($r('app.string.add_to_cart'))));
        await addBtn.click();
        await driver.delayMs(500);
        // 跳转到购物车页面
        let cartBtn = await driver.findComponent(
          ON.text(await resourceManager.getStringValue($r('app.string.shop_cart'))));
        await cartBtn.click();
        await driver.delayMs(500);
        // 检查商品是否已经添加
        await driver.assertComponentExist(ON.id(cartTag + idList[i]));
        // 退回首页
        await driver.pressBack();
        await driver.delayMs(500);
        await driver.pressBack();
        await driver.delayMs(500);
      }
      Logger.info(TAG, 'AddGoodsToCart end');
      done();
    })

    /**
     * @tc.number CustomEmitterDeleteGoodsToCart
     * @tc.name   Customize Emitter
     * @tc.desc   Delete a product to the shopping cart interface,This example takes a long time to run.
     *            Please adjust the Time Out to 120s to ensure the normal execution of the use case
     * @tc.size   MediumTest
     * @tc.type   Function
     * @tc.level  Level 1
     */
    it(BUNDLE + 'DeleteGoodsToCart', 1, async (done: Function) => {
      Logger.info(TAG, 'DeleteGoodsToCart start');
      let driver = Driver.create();
      let cartTag = 'cart';
      let idList = ['0', '1', '2'];  // 商品id列表
      let deleteButton = 'reduceMedia';
      let resourceManager = AbilityDelegatorRegistry.getAbilityDelegator().getAppContext().resourceManager;
      let goods = await driver.findComponent(ON.id(idList[0]));
      // 点击商品
      await goods.click();
      await driver.delayMs(500);
      // 进入购物车
      let cartBtn = await driver.findComponent(
        ON.text(await resourceManager.getStringValue($r('app.string.shop_cart'))));
      await cartBtn.click();
      await driver.delayMs(500);
      for (let i: number = 0; i < idList.length; i++) {
        // 删除商品
        let deleteBtn = await driver.findComponent(ON.id(cartTag + idList[i] + deleteButton));
        await deleteBtn.click();
        await driver.delayMs(500);
        //检查商品是否已经删除
        let btn = await driver.findComponent(ON.id(cartTag + idList[i] + deleteButton));
        await expect(btn).assertNull();
      }
      // 退回首页
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);
      Logger.info(TAG, 'DeleteGoodsToCart end');
      done();
    })

    /**
     * @tc.number CustomEmitterPurchaseGoods
     * @tc.name   Customize Emitter
     * @tc.desc   Purchase a certain product and record the purchase quantity on the shopping cart interface,
     *            This example takes a long time to run.Please adjust the Time Out to 120s to ensure the normal
     *            execution of the use case
     * @tc.size   MediumTest
     * @tc.type   Function
     * @tc.level  Level 1
     */
    it(BUNDLE + 'PurchaseGoods', 1, async (done: Function) => {
      Logger.info(TAG, 'PurchaseGoods start');
      let driver = Driver.create();
      let idList = ['0', '1', '2'];  // 商品id列表
      let resourceManager = AbilityDelegatorRegistry.getAbilityDelegator().getAppContext().resourceManager;
      let goods = await driver.findComponent(ON.id(idList[0]));
      // 点击商品
      await goods.click();
      await driver.delayMs(500);
      for (let i: number = 0; i < idList.length; i++) {
        // 多次点击购买
        let buy = await driver.findComponent(
          ON.text(await resourceManager.getStringValue($r('app.string.buy_now'))));
        await buy.click();
        await driver.delayMs(500);
        await driver.assertComponentExist(
          ON.text(await resourceManager.getStringValue($r('app.string.purchase_successful'))));
        // 关闭弹窗
        let close = await driver.findComponent(
          ON.text(await resourceManager.getStringValue($r('app.string.determine_popup'))));
        await close.click();
        await driver.delayMs(500);
      }
      // 进入购物车
      let cartBtn = await driver.findComponent(
        ON.text(await resourceManager.getStringValue($r('app.string.shop_cart'))));
      await cartBtn.click();
      await driver.delayMs(500);
      //检查购买数量
      await driver.assertComponentExist(
        ON.text((await resourceManager.getStringValue(
          $r('app.string.number_of_purchases'))).concat(idList.length.toString())));
      // 清空购买数量
      let clearPurchaseGoods = await driver.findComponent(
        ON.text(await resourceManager.getStringValue($r('app.string.clear_purchase_quantity'))));
      await expect(clearPurchaseGoods != null).assertTrue();
      await clearPurchaseGoods.click();
      await driver.delayMs(500);
      //检查购买数量是否清空
      await driver.assertComponentExist(
        ON.text((await resourceManager.getStringValue(
          $r('app.string.number_of_purchases'))).concat('0')));
      Logger.info(TAG, 'PurchaseGoods end');
      done();
    })
  })
}