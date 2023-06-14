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
import commonEventManager from '@ohos.commonEventManager';
import type common from '@ohos.app.ability.common';
import { describe, it, expect } from '@ohos/hypium';
import { Driver, ON, MatchPattern } from '@ohos.UiTest';
import historyFeature from '../../../main/ets/feature/HistoryFeature';
import { logger } from '../util/Logger';

const TAG = '[Sample_CustomCommonEvent]';
const BUNDLE = 'CustomCommonEvent_';
let ability;
const RADIO_ID: Array<string> = [
commonEventManager.Support.COMMON_EVENT_WIFI_POWER_STATE,
commonEventManager.Support.COMMON_EVENT_SCREEN_OFF,
commonEventManager.Support.COMMON_EVENT_SCREEN_ON
];

export default function abilityTest() {
  let driver = Driver.create();
  describe('AbilityTest', function () {
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      logger.info(TAG, `${BUNDLE}StartAbility_001 begin`)
      let delegator = AbilityDelegatorRegistry.getAbilityDelegator();
      let want = {
        bundleName: "com.samples.customcommonevent",
        abilityName: "LauncherAbility"
      };
      delegator.startAbility(want, (err) => {
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

    // 进入监听界面，监听
    it(BUNDLE + 'Main_001', 0, async function () {
      logger.info(TAG, `${BUNDLE}Main_001 begin`);
      // 进入监听界面，进行试11次监听
      for (let i = 0;i < 11; i++) {
        await driver.delayMs(200);
        await driver.assertComponentExist(ON.id('jumpToStart'));
        let jumpToStart = await driver.findComponent(ON.id('jumpToStart'));
        await jumpToStart.click();
        await driver.delayMs(500);
        await driver.assertComponentExist(ON.id('startMonitor'));
        let startOrStop = await driver.findComponent(ON.id('startMonitor'));
        await startOrStop.click();
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.text('当前监听状态：', MatchPattern.CONTAINS));
        await driver.delayMs(1000);
        await startOrStop.click();
        await driver.delayMs(200);
        await driver.assertComponentExist(ON.text('本次监控时长：', MatchPattern.CONTAINS));
        if (i < 10) {
          await driver.pressBack();
          await driver.delayMs(500);
        }
      }
      logger.info(TAG, `${BUNDLE}Main_001 end`);
    })

    // 进入详情界面
    it(BUNDLE + 'Detail_001', 0, async function (done) {
      logger.info(TAG, `${BUNDLE}Detail_001 begin`);
      await driver.assertComponentExist(ON.id('nextDetail'));
      let nextDetail = await driver.findComponent(ON.id('nextDetail'));
      await nextDetail.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.id('onceEventText'));
      // 返回首页
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.pressBack();
      await driver.delayMs(200);
      await driver.assertComponentExist(ON.id('jumpToHistory'));
      logger.info(TAG, `${BUNDLE}Detail_001 end`);
      done();
    })

    // 进入历史页面
    it(BUNDLE + 'History_001', 0, async function (done) {
      logger.info(TAG, `${BUNDLE}History_001 begin`);
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.id('jumpToHistory'));
      let jumpToHistory = await driver.findComponent(ON.id('jumpToHistory'));
      await jumpToHistory.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text('开始于', MatchPattern.CONTAINS));
      let feature: historyFeature = new historyFeature(ability.context);
      let recorderArray = await feature.getData().then((data: Array<Array<string>>) => {
        return data;
      })
      // 判断添加20条数据之后的历史记录
      if (recorderArray.length > 1) {
        logger.info(TAG, 'Empty failed');
        expect().assertFail();
      }
      // 返回首页
      await driver.delayMs(2000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.id('jumpToSetting'));
      logger.info(TAG, `${BUNDLE}History_001 end`);
      done();
    })

    // 进入设置页面
    it(BUNDLE + 'Setting_001', 0, async function (done) {
      logger.info(TAG, `${BUNDLE}Setting_001 begin`);
      await driver.delayMs(200);
      await driver.assertComponentExist(ON.id('jumpToSetting'));
      let jumpToHistory = await driver.findComponent(ON.id('jumpToSetting'));
      await jumpToHistory.click();
      await driver.delayMs(200);
      await driver.assertComponentExist(ON.text('是否记录联网事件', MatchPattern.CONTAINS));
      logger.info(TAG, `${BUNDLE}Setting_001 end`);
      done();
    })

    // 设置功能
    it(BUNDLE + 'Setting_002', 0, async function (done) {
      logger.info(TAG, `${BUNDLE}Setting_002 begin`);
      await driver.delayMs(200);
      await driver.assertComponentExist(ON.id(RADIO_ID[1] + '1'));
      let screenOffRadio2 = await driver.findComponent(ON.id(RADIO_ID[1] + '1'));
      await screenOffRadio2.click();
      let screenOffCheck = await screenOffRadio2.isChecked();
      await driver.assertComponentExist(ON.id(RADIO_ID[2] + '1'));
      let screenOnRadio2 = await driver.findComponent(ON.id(RADIO_ID[2] + '1'));
      await screenOnRadio2.click();
      let screenOnCheck = await screenOnRadio2.isChecked();
      expect(screenOffCheck && screenOnCheck).assertTrue();
      // 返回首页
      await driver.delayMs(200);
      await driver.pressBack();
      logger.info(TAG, `${BUNDLE}Setting_002 end`);
      done();
    })

    // 进入关于页面
    it(BUNDLE + 'About_001', 0, async function (done) {
      logger.info(TAG, `${BUNDLE}About_001 begin`);
      await driver.delayMs(500);
      // 点击进入关于页面
      await driver.assertComponentExist(ON.id('jumpToAbout'));
      let jumpToHistory = await driver.findComponent(ON.id('jumpToAbout'));
      await jumpToHistory.click();
      await driver.assertComponentExist(ON.text('本示例用于', MatchPattern.CONTAINS));
      // 返回首页
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.id('jumpToSetting'));
      logger.info(TAG, `${BUNDLE}About_001 end`);
      done();
    })
  })
}