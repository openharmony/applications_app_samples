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

import { Driver, ON, MatchPattern } from '@ohos.UiTest';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import Logger from '../util/Logger';
import { getString, getStringArray } from '../util/ResourceUtil';

const TAG: string = '[Sample_International]';
const BUNDLE = 'International_';

let driver: Driver = Driver.create();

// 通过id验证有没有这个组件 有的话点击一下
async function checkButtonAndClickWithID(text: string) {
  let atom = text;
  await driver.assertComponentExist(ON.id(atom));
  let button = await driver.findComponent(ON.id(atom));
  await button.click();
  await driver.delayMs(1000);
}

// 通过text验证有没有这个组件 有的话点击一下
async function checkButtonAndClickWithText(text: string) {
  let atom = text;
  await driver.assertComponentExist(ON.text(atom));
  let button = await driver.findComponent(ON.text(atom));
  await button.click();
  await driver.delayMs(1000);
}

// 通过type验证有没有这个组件 有的话点击一下
async function checkButtonAndClickWithType(type: string) {
  let atom = type;
  await driver.assertComponentExist(ON.type(atom));
  let button = await driver.findComponent(ON.type(atom));
  await button.click();
  await driver.delayMs(1000);
}

// 通过type验证有没有这个组件 有的话点击相关文字组件
async function checkScrollAndClickWithType(type: string, text: string) {
  let atom = type;
  await driver.assertComponentExist(ON.type(atom));
  let list = await driver.findComponent(ON.type(atom));
  let button = await list.scrollSearch(ON.text(text));
  await button.click();
  await driver.delayMs(1000);
}

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    /**
     * 拉起应用
     */
    it(BUNDLE + 'StartAbility_001', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'StartAbility_001 begin');
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'ohos.samples.international',
          abilityName: 'EntryAbility'
        });
      } catch (error) {
        Logger.info(TAG, `StartAbility end ${JSON.stringify(error)}`);
        expect(0).assertEqual(error.code);
      }
      Logger.info(TAG, BUNDLE + 'StartAbility_001 end');
      done();
    })

    /**
     * 测试语言和地区
     */
    it(BUNDLE + 'TimeZone_001', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'TimeZone_001 begin');
      // 进入语言和地区页面
      await driver.delayMs(1000);
      await checkButtonAndClickWithText(getString($r('app.string.language_region')));
      // 点击编辑
      await checkButtonAndClickWithText(getString($r('app.string.edit_language')));
      await driver.pressBack();
      await driver.delayMs(1000);
      // 进入添加语言页面
      await checkButtonAndClickWithText(getString($r('app.string.add_language')));
      // 添加语言
      await checkButtonAndClickWithID('edit_lan_lv');
      // 进入地区设置页面
      await checkButtonAndClickWithText(getString($r('app.string.current_region')));
      // 设置地区
      await checkScrollAndClickWithType('Scroll', getString($r('app.string.united_states')));
      // 进入地区设置页面
      await checkButtonAndClickWithText(getString($r('app.string.current_region')));
      // 设置地区
      await checkScrollAndClickWithType('Scroll', getString($r('app.string.china')));
      Logger.info(TAG, BUNDLE + 'TimeZone_001 end');
      await driver.pressBack();
      await driver.delayMs(1000);
      done();
    })

    /**
     * 测试时区设置
     */
    it(BUNDLE + 'TimeZone_002', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'TimeZone_002 begin');
      // 进入时间和日期页面
      await driver.delayMs(1000);
      await checkButtonAndClickWithText(getString($r('app.string.date_time')));
      // 24小时切换
      await checkButtonAndClickWithType('Toggle');
      // 设置日期
      await checkButtonAndClickWithText(getString($r('app.string.date')));
      await checkButtonAndClickWithText(getString($r('app.string.ok')));
      // 设置时间
      await checkButtonAndClickWithText(getString($r('app.string.time')));
      await checkButtonAndClickWithText(getString($r('app.string.ok')));
      // 进入时区设置页面
      await checkButtonAndClickWithText(getString($r('app.string.time_zone')));
      // 设置时区
      await checkButtonAndClickWithID('time_zone_item0');
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(getString($r('app.string.time_zone'))));

      Logger.info(TAG, BUNDLE + 'TimeZone_002 end');
      await driver.pressBack();
      done();
    })

    /**
     * 测试区域格式示例
     */
    it(BUNDLE + 'TimeZone_003', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'TimeZone_003 begin');
      // 进入时间和日期页面
      await driver.delayMs(1000);
      await checkButtonAndClickWithText(getString($r('app.string.format_example')));
      await driver.assertComponentExist(ON.text('1,234,567'));
      Logger.info(TAG, BUNDLE + 'TimeZone_003 end');
      await driver.pressBack();
      done();
    })

  })
}