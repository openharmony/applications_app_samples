/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import hilog from '@ohos.hilog';
import { Driver, ON, MatchPattern } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import type resourceManager from '@ohos.resourceManager';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';

const BUNDLE_NAME = 'com.samples.voicecalldemo';
const ABILITY_NAME = 'EntryAbility';
const TAG = 'callUITest';
const DOMAIN = 0xF811;

export default function callUITest() {
  describe('CallUITest', function () {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(function () {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    });
    beforeEach(function () {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    });
    afterEach(function () {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    });
    afterAll(function () {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    });

    // 启动呼叫页，确认权限弹窗
    it(BUNDLE_NAME + ' StartAbility_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, '%{public}s', BUNDLE_NAME + ' StartAbility_001 begin');

      try {
        let driver = Driver.create();
        let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
        await abilityDelegator.startAbility({
          bundleName: BUNDLE_NAME,
          abilityName: ABILITY_NAME,
          parameters: {
            'START_ABILITY_EVENT_KEY': 'START_ABILITY_CALL',
            'START_ABILITY_DATA_KEY': 1
          }
        });
        hilog.info(DOMAIN, TAG, '%{public}s', BUNDLE_NAME + ' StartAbility_001 startAbility success');

        let remgr: resourceManager.ResourceManager =  abilityDelegator.getAppContext().resourceManager;
        let isAllow:string = remgr.getStringSync($r("app.string.is_allow"));
        let allow:string = remgr.getStringSync($r("app.string.allow"));
        let call:string = remgr.getStringSync($r("app.string.tips_call"));

        // 点掉权限弹窗
        await driver.delayMs(2000);
        await driver.assertComponentExist(ON.text(isAllow, MatchPattern.CONTAINS));
        let sureBtn = await driver.findComponent(ON.text(allow, MatchPattern.EQUALS));
        await sureBtn.click();
        hilog.info(DOMAIN, TAG, '%{public}s', BUNDLE_NAME + ' StartAbility_001 allow permission success');

        // 判断页面元素是否正常出现
        await driver.delayMs(500);
        await driver.assertComponentExist(ON.text(call, MatchPattern.EQUALS));
        hilog.info(DOMAIN, TAG, '%{public}s', BUNDLE_NAME + ' StartAbility_001 check ui text success');

        done();
      } catch (err) {
        hilog.error(DOMAIN, TAG, '%{public}s', `${BUNDLE_NAME} StartAbility_001 err ${err.code}  msg ${err.message}`);
        expect().assertFail();
      }
      hilog.info(DOMAIN, TAG, '%{public}s', BUNDLE_NAME + ' StartAbility_001 end');
    })

    // 切换悬浮窗
    it('Switch_window_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, '%{public}s', 'Switch_window_001 begin');

      try {
        let driver = Driver.create();
        await driver.delayMs(1000);

        // 切换
        await driver.delayMs(2000);
        await driver.assertComponentExist(ON.id('switch_window_to_float'));
        let switchOnce = await driver.findComponent(ON.id('switch_window_to_float'));
        await switchOnce.click();
        hilog.info(DOMAIN, TAG, '%{public}s', 'Switch_window_001 switch_window_to_float click');
        // 切换
        await driver.delayMs(500);
        await driver.assertComponentExist(ON.id('switch_window_to_index'));
        let switchTwice = await driver.findComponent(ON.id('switch_window_to_index'));
        await switchTwice.click();
        hilog.info(DOMAIN, TAG, '%{public}s', 'Switch_window_001 switch_window_to_index click');
        // 判断页面元素是否正常出现
        await driver.delayMs(500);
        await driver.assertComponentExist(ON.id('switch_window_to_float'));
        hilog.info(DOMAIN, TAG, '%{public}s', 'Switch_window_001 check ui success');
        // 结束
        done();
      } catch (err) {
        hilog.error(DOMAIN, TAG, '%{public}s', `Switch_window_001 err ${err.code}  msg ${err.message}`);
        expect().assertFail();
      }
      hilog.info(DOMAIN, TAG, '%{public}s', 'Switch_window_001 end');
    });

  });
}