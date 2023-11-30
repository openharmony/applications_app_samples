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
import Base from '@ohos.base';
import commonEventManager from '@ohos.commonEventManager';
import UIAbility from '@ohos.app.ability.UIAbility';
import Want from '@ohos.app.ability.Want';
import { describe, it, expect } from '@ohos/hypium';
import { Driver, ON, MatchPattern } from '@ohos.UiTest';
import { logger } from '../util/Logger';
import historyFeature from '../../../main/ets/feature/HistoryFeature';

const TAG = '[Sample_CustomCommonEvent]';
const BUNDLE = 'CustomCommonEvent_';
const RADIO_ID: Array<string> = [
commonEventManager.Support.COMMON_EVENT_WIFI_POWER_STATE,
commonEventManager.Support.COMMON_EVENT_SCREEN_OFF,
commonEventManager.Support.COMMON_EVENT_SCREEN_ON
];
let ability: UIAbility | null = null;

export default function abilityTest() {
  let driver: Driver = Driver.create();
  describe('AbilityTest', () => {

    /*
     *@tc.number CustomCommonEvent_StartAbility_001
     *@tc.name   Public event subscription and publishing related testing
     *@tc.desc   Pull up the application
     *@tc.size   MediumTest
     *@tc.type   Function
     *@tc.level  Level 1
     */
    it('CustomCommonEvent_StartAbility_001', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}StartAbility_001 begin`)
      let delegator: AbilityDelegatorRegistry.AbilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      let want: Want = {
        bundleName: "com.samples.customcommonevent",
        abilityName: "LauncherAbility"
      }
      delegator.startAbility(want, (err: Base.BusinessError) => {
        logger.info(TAG, `${BUNDLE}startAbility end err ${JSON.stringify(err)}`);
      })
      await driver.delayMs(1000);
      await delegator.getCurrentTopAbility().then((Ability) => {
        ability = Ability;
        expect(Ability.context.abilityInfo.name).assertEqual('LauncherAbility');
      })
      logger.info(TAG, `${BUNDLE}StartAbility_001 end`);
      done();
    })

    /*
     *@tc.number CustomCommonEvent_Main_001
     *@tc.name   Public event subscription and publishing related testing
     *@tc.desc   Enter the monitoring interface and listen
     *@tc.size   MediumTest
     *@tc.type   Function
     *@tc.level  Level 1
     */
    it('CustomCommonEvent_Main_001', 0, async () => {
      logger.info(TAG, `${BUNDLE}Main_001 begin`);
      // 进入监听界面，进行试11次监听
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('jumpToStart'));
      let jumpToStart = await driver.findComponent(ON.id('jumpToStart'));
      expect(jumpToStart != null).assertTrue();
      await jumpToStart.click();
      for (let i = 0;i < 11; i++) {
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.id('startMonitor'));
        let startBtn = await driver.findComponent(ON.id('startMonitor'));
        await driver.delayMs(1000);
        await startBtn.click();
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.text('当前监听状态：', MatchPattern.CONTAINS));
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.id('startMonitor'));
        let stopBtn = await driver.findComponent(ON.id('startMonitor'));
        await stopBtn.click();
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.text('本次监控时长：', MatchPattern.CONTAINS));
      }
      logger.info(TAG, `${BUNDLE}Main_001 end`);
    })

    /*
     *@tc.number CustomCommonEvent_Detail_001
     *@tc.name   Public event subscription and publishing related testing
     *@tc.desc   Enter the details interface
     *@tc.size   MediumTest
     *@tc.type   Function
     *@tc.level  Level 1
     */
    it('CustomCommonEvent_Detail_001', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}Detail_001 begin`);
      await driver.assertComponentExist(ON.id('nextDetail'));
      let nextDetail = await driver.findComponent(ON.id('nextDetail'));
      expect(nextDetail != null).assertTrue();
      await nextDetail.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.id('onceEventText'));
      // 返回首页
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('jumpToHistory'));
      logger.info(TAG, `${BUNDLE}Detail_001 end`);
      done();
    })

    /*
     *@tc.number CustomCommonEvent_History_001
     *@tc.name   Public event subscription and publishing related testing
     *@tc.desc   Enter the history page
     *@tc.size   MediumTest
     *@tc.type   Function
     *@tc.level  Level 1
     */
    it('CustomCommonEvent_History_001', 0, async () => {
      logger.info(TAG, `${BUNDLE}History_001 begin`);
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('jumpToHistory'));
      let jumpToHistory = await driver.findComponent(ON.id('jumpToHistory'));
      await jumpToHistory.click();
      await driver.delayMs(1000);
      if (ability) {
        let feature: historyFeature = new historyFeature(ability.context);
        let recorderArray = await feature.getData().then((data: Array<Array<string>>) => {
          return data;
        })
        // 判断添加10条数据之后的历史记录
        if (recorderArray.length > 1) {
          logger.info(TAG, 'Empty failed');
          expect().assertFail();
        }
      }
      // 返回首页
      await driver.delayMs(2000);
      await driver.pressBack();
      logger.info(TAG, `${BUNDLE}History_001 end`);
    })

    /*
     *@tc.number CustomCommonEvent_Setting_001
     *@tc.name   Public event subscription and publishing related testing
     *@tc.desc   Enter the settings page
     *@tc.size   MediumTest
     *@tc.type   Function
     *@tc.level  Level 1
     */
    it('CustomCommonEvent_Setting_001', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}Setting_001 begin`);
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('jumpToSetting'));
      let jumpToHistory = await driver.findComponent(ON.id('jumpToSetting'));
      await driver.delayMs(1000);
      expect(jumpToHistory != null).assertTrue();
      await jumpToHistory.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('是否记录联网事件', MatchPattern.CONTAINS));
      logger.info(TAG, `${BUNDLE}Setting_001 end`);
      done();
    })

    /*
     *@tc.number CustomCommonEvent_Setting_002
     *@tc.name   Public event subscription and publishing related testing
     *@tc.desc   Setting functions
     *@tc.size   MediumTest
     *@tc.type   Function
     *@tc.level  Level 1
     */
    it('CustomCommonEvent_Setting_002', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}Setting_002 begin`);
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id(RADIO_ID[1] + '1'));
      let screenOffRadio2 = await driver.findComponent(ON.id(RADIO_ID[1] + '1'));
      await driver.delayMs(1000);
      await screenOffRadio2.click();
      let screenOffCheck = await screenOffRadio2.isChecked();
      await driver.assertComponentExist(ON.id(RADIO_ID[2] + '1'));
      let screenOnRadio2 = await driver.findComponent(ON.id(RADIO_ID[2] + '1'));
      await driver.delayMs(1000);
      await screenOnRadio2.click();
      let screenOnCheck = await screenOnRadio2.isChecked();
      expect(screenOffCheck && screenOnCheck).assertTrue();
      // 返回首页
      await driver.delayMs(1000);
      await driver.pressBack();
      logger.info(TAG, `${BUNDLE}Setting_002 end`);
      done();
    })

    /*
     *@tc.number CustomCommonEvent_About_001
     *@tc.name   Public event subscription and publishing related testing
     *@tc.desc   Enter the About page
     *@tc.size   MediumTest
     *@tc.type   Function
     *@tc.level  Level 1
     */
    it('CustomCommonEvent_About_001', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}About_001 begin`);
      await driver.delayMs(1000);
      // 点击进入关于页面
      await driver.assertComponentExist(ON.id('jumpToAbout'));
      let jumpToHistory = await driver.findComponent(ON.id('jumpToAbout'));
      expect(jumpToHistory != null).assertTrue();
      await jumpToHistory.click();
      await driver.assertComponentExist(ON.text('本示例用于', MatchPattern.CONTAINS));
      // 返回首页
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('jumpToSetting'));
      logger.info(TAG, `${BUNDLE}About_001 end`);
      done();
    })

    /*
     *@tc.number CustomCommonEvent_CommonEvent_001
     *@tc.name   Public event subscription and publishing related testing
     *@tc.desc   Enter the subscription event page
     *@tc.size   MediumTest
     *@tc.type   Function
     *@tc.level  Level 1
     */
    it('CustomCommonEvent_CommonEvent_001', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}CommonEvent_001 begin`);
      let resourceManager = AbilityDelegatorRegistry.getAbilityDelegator().getAppContext().resourceManager;
      let jumpToSetting = await driver.findComponent(ON.id('jumpToSetting'));
      await driver.delayMs(500);
      expect(jumpToSetting != null).assertTrue();
      await jumpToSetting.click();
      // 进入事件订阅页面
      let jumpToCommonEvent = await driver.findComponent(ON.id('jumpToCommonEvent'));
      await driver.delayMs(500);
      await jumpToCommonEvent.click();
      await driver.delayMs(500);
      // 订阅事件
      let SubscribeEvent = await driver.findComponent(
        ON.text(await resourceManager.getStringValue($r('app.string.SubscribeEventOn'))));
      await driver.delayMs(1000);
      await SubscribeEvent.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(
        ON.text(await resourceManager.getStringValue($r('app.string.SubScribeSuccess'))));
      await driver.delayMs(4000);
      // 点击发布事件
      let postCard = await driver.findComponents(ON.type('FormComponent'));
      await postCard[0].click();
      await driver.delayMs(500);
      await driver.assertComponentExist(
        ON.text((await resourceManager.getStringValue($r('app.string.InAppSendSubmitEventSuccess')))));
      // 点击取消订阅
      let unSubscribeEvent = await driver.findComponent(
        ON.text(await resourceManager.getStringValue($r('app.string.UnSubscribeEvent'))));
      await unSubscribeEvent.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(
        ON.text(await resourceManager.getStringValue($r('app.string.UnSubscribeSuccess'))));
      // 返回首页
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      logger.info(TAG, `${BUNDLE}CommonEvent_001 end`);
      done();
    })

    /*
     *@tc.number CustomCommonEvent_CommonEvent_002
     *@tc.name   Public event subscription and publishing related testing
     *@tc.desc   Subscribe to external event pages
     *@tc.size   MediumTest
     *@tc.type   Function
     *@tc.level  Level 1
     */
    it('CustomCommonEvent_CommonEvent_002', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}CommonEvent_002 begin`);
      let resourceManager = AbilityDelegatorRegistry.getAbilityDelegator().getAppContext().resourceManager;
      let jumpToSetting = await driver.findComponent(ON.id('jumpToSetting'));
      expect(jumpToSetting != null).assertTrue();
      await driver.delayMs(500);
      await jumpToSetting.click();
      // 进入事件订阅页面
      let jumpToCommonEvent = await driver.findComponent(ON.id('jumpToCommonEvent'));
      await driver.delayMs(500);
      await jumpToCommonEvent.click();
      await driver.delayMs(500);
      // 订阅事件
      let SubscribeEvent = await driver.findComponent(
        ON.text(await resourceManager.getStringValue($r('app.string.SubscribeEventOn'))));
      await SubscribeEvent.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(
        ON.text(await resourceManager.getStringValue($r('app.string.SubScribeSuccess'))));
      await driver.delayMs(2000);
      // 点击发布事件
      let postCard = await driver.findComponents(ON.type('FormComponent'));
      await postCard[1].click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(
        ON.text((await resourceManager.getStringValue($r('app.string.OutAppSendSubmitEventSuccess')))));
      // 点击取消订阅
      let unSubscribeEvent = await driver.findComponent(
        ON.text(await resourceManager.getStringValue($r('app.string.UnSubscribeEvent'))));
      await unSubscribeEvent.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(
        ON.text(await resourceManager.getStringValue($r('app.string.UnSubscribeSuccess'))));
      // 返回首页
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      logger.info(TAG, `${BUNDLE}CommonEvent_002 end`);
      done();
    })
  })
}