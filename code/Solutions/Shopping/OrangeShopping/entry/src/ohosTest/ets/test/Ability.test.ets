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
import { Driver, ON, MatchPattern } from '@ohos.UiTest';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import Logger from '../utils/Logger';
import Want from '@ohos.app.ability.Want';

const BUNDLE = 'OrangeShopping';
const TAG = '[Sample_OrangeShopping]';

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    /**
     * 拉起一个ability
     * 本示例运行时间较长，请将Time Out调整为600s，确保用例正常执行
     */
    it(BUNDLE + 'StartAbility_001', 0, async (done: Function) => {
      Logger.info(TAG, 'StartAbility_001 start');
      let driver: Driver = await Driver.create();
      let want: Want = {
        bundleName: 'ohos.samples.orangeshopping',
        abilityName: 'MainAbility'
      }
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      await abilityDelegator.startAbility(want, (err, data) => {
        Logger.info(TAG, 'StartAbility get err ' + JSON.stringify(err));
        expect(err).assertNull();
      })
      await driver.delayMs(1000);
      Logger.info(TAG, 'StartAbility_001 end');
      done();
    })

    /**
     * 获取权限
     */
    it(BUNDLE + 'GetPermission_001', 0, async (done: Function) => {
      Logger.info(TAG, 'GetPermission_001 start');
      let driver = await Driver.create();
      let resourceManager = AbilityDelegatorRegistry.getAbilityDelegator().getAppContext().resourceManager;
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.allow'))));
      let agree = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.allow'))));
      await agree.click();
      await driver.delayMs(1000);
      await agree.click();
      await driver.delayMs(1000);
      await agree.click();
      await driver.delayMs(2000);
      // 允许通知
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.allow'))));
      let agree2 = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.allow'))));
      await agree2.click();
      await driver.delayMs(1000);
      // 关闭广告弹窗
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.close'))));
      let closeBtn = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.close'))));
      await closeBtn.click();
      await driver.delayMs(1000);
      // 关闭升级弹窗
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.update'))));
      let updateBtn = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.update'))));
      await updateBtn.click();
      await driver.delayMs(2000);
      Logger.info(TAG, 'GetPermission_001 end');
      done();
    })

    /**
     * 点击底部Tab切换不同页面
     */
    it(BUNDLE + 'SwitchPage_001', 0, async (done: Function) => {
      Logger.info(TAG, 'SwitchPage_001 start');
      let driver = await Driver.create();
      let resourceManager = AbilityDelegatorRegistry.getAbilityDelegator().getAppContext().resourceManager;
      // 检查Tab是否存在
      await driver.assertComponentExist(ON.id('homeTab0'));
      await driver.assertComponentExist(ON.id('homeTab1'));
      await driver.assertComponentExist(ON.id('homeTab2'));
      await driver.assertComponentExist(ON.id('homeTab3'));
      // 切换到新品页
      let newProduct = await driver.findComponent(ON.id('homeTab1'));
      await newProduct.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(
        ON.text(await resourceManager.getStringValue($r('app.string.title_bar_data_title_selected'))));
      // 切换到购物车页
      let shoppingCart = await driver.findComponent(ON.id('homeTab2'));
      await shoppingCart.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.shopping_cart'))));
      // 切换到用户中心页
      let userCenter = await driver.findComponent(ON.id('homeTab3'));
      await userCenter.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(
        ON.text(await resourceManager.getStringValue($r('app.string.official_Service'))));
      // 切换到首页
      let mainPage = await driver.findComponent(ON.id('homeTab0'));
      await mainPage.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(
        ON.text(await resourceManager.getStringValue($r('app.string.tab_title_data_home'))));
      Logger.info(TAG, 'SwitchPage_001 end');
      done();
    })

    /**
     * 点击播放键，播放视频
     */
    it(BUNDLE + 'PlayVideo_001', 0, async (done: Function) => {
      Logger.info(TAG, 'PlayVideo_001 start');
      let driver = await Driver.create();
      let goods0 = await driver.findComponent(ON.id('goods0'));
      await goods0.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('playBtn'));
      await driver.assertComponentExist(ON.id('previewImg'));
      let playBtn = await driver.findComponent(ON.id('playBtn'));
      await playBtn.click();
      await driver.delayMs(500);
      // 开始播放，预览图消失
      let previewImg = await driver.findComponent(ON.id('previewImg'));
      await expect(previewImg).assertNull();
      Logger.info(TAG, 'PlayVideo_001 end');
      done();
    })

    /**
     * 点击视频组件，进入全屏界面，检查播放与暂停功能
     */
    it(BUNDLE + 'FullVideo_001', 0, async (done: Function) => {
      Logger.info(TAG, 'FullVideo_001 start');
      let driver = await Driver.create();
      await driver.assertComponentExist(ON.id('VideoPage'));
      let playBtn = await driver.findComponent(ON.id('VideoPage'));
      await playBtn.click();
      await driver.delayMs(500);
      // 点击界面暂停播放
      await driver.assertComponentExist(ON.id('fullVideo'));
      let fullVideo = await driver.findComponent(ON.id('fullVideo'));
      await fullVideo.click();
      // 暂停后出现播放键
      await driver.assertComponentExist(ON.id('fullPlayBtn'));
      let fullPlayBtn = await driver.findComponent(ON.id('fullPlayBtn'));
      await fullPlayBtn.click();
      await driver.delayMs(500);
      let tempBtn = await driver.findComponent(ON.id('fullPlayBtn'));
      await expect(tempBtn).assertNull();
      await driver.pressBack();
      await driver.delayMs(500);
      // 返回主界面
      await driver.pressBack();
      await driver.delayMs(500);
      Logger.info(TAG, 'FullVideo_001 end');
      done();
    })

    /**
     * 添加某商品到购物车界面
     */
    it(BUNDLE + 'AddGoodsToCart_001', 0, async (done: Function) => {
      Logger.info(TAG, 'AddGoodsToCart_001 start');
      let driver = await Driver.create();
      let resourceManager = AbilityDelegatorRegistry.getAbilityDelegator().getAppContext().resourceManager;
      let cartTag = 'cart_';
      let goods = await driver.findComponent(ON.id("goods0"));
      // 点击商品
      await goods.click();
      await driver.delayMs(1000);
      // 检查跳转后商品是否一致
      await driver.assertComponentExist(
        ON.text(await resourceManager.getStringValue($r('app.string.add_to_cart'))));
      await driver.assertComponentExist(ON.id('goodsDetail0'));
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.shopping_cart'))));
      // 点击添加商品到购物车当中
      let addBtn = await driver.findComponent(
        ON.text(await resourceManager.getStringValue($r('app.string.add_to_cart'))));
      await addBtn.click();
      await driver.delayMs(1000);
      // 跳转到购物车页面
      let cartBtn = await driver.findComponent(
        ON.text(await resourceManager.getStringValue($r('app.string.shopping_cart'))));
      await cartBtn.click();
      await driver.delayMs(1000);
      // 检查商品是否已经添加
      await driver.assertComponentExist(ON.id(cartTag + 'goods0'));
      // 退回首页
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);
      Logger.info(TAG, 'AddGoodsToCart_001 end');
      done();
    })

    /**
     * 进入直播间
     */
    it(BUNDLE + 'OpenLivePage_001', 0, async (done: Function) => {
      Logger.info(TAG, 'OpenLivePage_001 start');
      let driver = await Driver.create();
      let goods0 = await driver.findComponent(ON.id('goods0'));
      await goods0.click();
      await driver.delayMs(1000);
      // 点击进入直播间
      await driver.assertComponentExist(ON.id('directVideo'));
      let enterVideoComp = await driver.findComponent(ON.id('directVideo'));
      await enterVideoComp.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.id('close'));
      await driver.assertComponentExist(ON.text('520', MatchPattern.CONTAINS));
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(500);
      Logger.info(TAG, 'OpenLivePage_001 end');
      done();
    })
  })
}