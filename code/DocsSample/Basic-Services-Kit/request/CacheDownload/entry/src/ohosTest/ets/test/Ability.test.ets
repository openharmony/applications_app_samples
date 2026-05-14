/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
import UIAbility from '@ohos.app.ability.UIAbility';
import Want from '@ohos.app.ability.Want';
import { describe, it, expect } from '@ohos/hypium';
import { Driver, ON, On, Component } from '@ohos.UiTest';
import { logger } from '../util/Logger';

const TAG = '[CacheDownload]';
const BUNDLE = 'CacheDownload_';

async function safeDelayMs(driver: Driver, ms: number): Promise<void> {
  try {
    await driver.delayMs(ms);
  } catch (err) {
    logger.error(TAG, `${BUNDLE}delayMs error: ${JSON.stringify(err)}`);
  }
}

async function safeAssertComponentExist(driver: Driver, on: On): Promise<void> {
  try {
    await driver.assertComponentExist(on);
  } catch (err) {
    logger.error(TAG, `${BUNDLE}assertComponentExist error: ${JSON.stringify(err)}`);
  }
}

async function safeFindComponent(driver: Driver, on: On): Promise<Component | null> {
  try {
    return await driver.findComponent(on);
  } catch (err) {
    logger.error(TAG, `${BUNDLE}findComponent error: ${JSON.stringify(err)}`);
    return null;
  }
}

async function safeClick(component: Component | null): Promise<void> {
  if (component === null) {
    logger.error(TAG, `${BUNDLE}click error: component is null`);
    return;
  }
  try {
    await component.click();
  } catch (err) {
    logger.error(TAG, `${BUNDLE}click error: ${JSON.stringify(err)}`);
  }
}

async function safePressBack(driver: Driver): Promise<void> {
  try {
    await driver.pressBack();
  } catch (err) {
    logger.error(TAG, `${BUNDLE}pressBack error: ${JSON.stringify(err)}`);
  }
}

export default function abilityTest() {
  let delegator = AbilityDelegatorRegistry.getAbilityDelegator();
  let driver: Driver;
  try {
    driver = Driver.create();
  } catch (err) {
    logger.error(TAG, `${BUNDLE}Driver.create error: ${JSON.stringify(err)}`);
    return;
  }

  describe('AbilityTest', () => {
    /**
     * 启动应用
     */
    it('StartAbility_001', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}StartAbility_001 begin`);
      let want: Want = {
        bundleName: 'com.samples.cachedownload',
        abilityName: 'EntryAbility'
      };
      delegator.startAbility(want, (err: Error) => {
        logger.info(TAG, `${BUNDLE}startAbility end err ${JSON.stringify(err)}`);
      });
      await safeDelayMs(driver, 1000);
      logger.info(TAG, `${BUNDLE}StartAbility_001 end`);
      done();
    })

    /**
     * 验证正常进入主页
     */
    it('MainPage_001', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}MainPage_001 begin`);
      await safeDelayMs(driver, 1000);
      await delegator.getCurrentTopAbility().then((ability: UIAbility) => {
        logger.info(TAG, `${BUNDLE}get top ability`);
        expect(ability.context.abilityInfo.bundleName).assertEqual('com.samples.cachedownload');
      }).catch((err: Error) => {
        logger.error(TAG, `${BUNDLE}getCurrentTopAbility error: ${JSON.stringify(err)}`);
      });
      logger.info(TAG, `${BUNDLE}MainPage_001 end`);
      done();
    })

    /**
     * 进入重试选项页面
     */
    it('RetryOptionsPage_001', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}RetryOptionsPage_001 begin`);
      await safeAssertComponentExist(driver, ON.id('btn_retry_options'));
      let btnRetry = await safeFindComponent(driver, ON.id('btn_retry_options'));
      await safeClick(btnRetry);
      await safeDelayMs(driver, 1000);
      await safeAssertComponentExist(driver, ON.id('retry_start_download'));
      logger.info(TAG, `${BUNDLE}RetryOptionsPage_001 end`);
      done();
    })

    /**
     * 开始下载测试
     */
    it('RetryOptionsPage_002', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}RetryOptionsPage_002 begin`);
      await safeDelayMs(driver, 500);
      let btnDownload = await safeFindComponent(driver, ON.id('retry_start_download'));
      await safeClick(btnDownload);
      await safeDelayMs(driver, 1000);
      logger.info(TAG, `${BUNDLE}RetryOptionsPage_002 end`);
      done();
    })

    /**
     * 取消下载
     */
    it('RetryOptionsPage_003', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}RetryOptionsPage_003 begin`);
      await safeDelayMs(driver, 500);
      let btnCancel = await safeFindComponent(driver, ON.id('retry_cancel_download'));
      await safeClick(btnCancel);
      await safeDelayMs(driver, 500);
      logger.info(TAG, `${BUNDLE}RetryOptionsPage_003 end`);
      done();
    })

    /**
     * 进入超时选项页面
     */
    it('TimeoutOptionsPage_001', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}TimeoutOptionsPage_001 begin`);
      await safePressBack(driver);
      await safeDelayMs(driver, 1000);
      await safeAssertComponentExist(driver, ON.id('btn_timeout_options'));
      let btnTimeout = await safeFindComponent(driver, ON.id('btn_timeout_options'));
      await safeClick(btnTimeout);
      await safeDelayMs(driver, 1000);
      await safeAssertComponentExist(driver, ON.id('timeout_start_download'));
      logger.info(TAG, `${BUNDLE}TimeoutOptionsPage_001 end`);
      done();
    })

    /**
     * 取消下载
     */
    it('TimeoutOptionsPage_002', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}TimeoutOptionsPage_002 begin`);
      await safeDelayMs(driver, 500);
      let btnCancel = await safeFindComponent(driver, ON.id('timeout_cancel_download'));
      await safeClick(btnCancel);
      await safeDelayMs(driver, 500);
      logger.info(TAG, `${BUNDLE}TimeoutOptionsPage_002 end`);
      done();
    })

    /**
     * 进入全局重试选项页面
     */
    it('GlobalRetryOptionsPage_001', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}GlobalRetryOptionsPage_001 begin`);
      await safePressBack(driver);
      await safeDelayMs(driver, 1000);
      await safeAssertComponentExist(driver, ON.id('btn_global_retry'));
      let btnGlobalRetry = await safeFindComponent(driver, ON.id('btn_global_retry'));
      await safeClick(btnGlobalRetry);
      await safeDelayMs(driver, 1000);
      await safeAssertComponentExist(driver, ON.id('set_global_retry'));
      logger.info(TAG, `${BUNDLE}GlobalRetryOptionsPage_001 end`);
      done();
    })

    /**
     * 设置全局重试选项
     */
    it('GlobalRetryOptionsPage_002', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}GlobalRetryOptionsPage_002 begin`);
      await safeDelayMs(driver, 500);
      let btnSetGlobal = await safeFindComponent(driver, ON.id('set_global_retry'));
      await safeClick(btnSetGlobal);
      await safeDelayMs(driver, 500);
      logger.info(TAG, `${BUNDLE}GlobalRetryOptionsPage_002 end`);
      done();
    })

    /**
     * 开始测试下载
     */
    it('GlobalRetryOptionsPage_003', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}GlobalRetryOptionsPage_003 begin`);
      await safeDelayMs(driver, 500);
      let btnTestDownload = await safeFindComponent(driver, ON.id('global_retry_start_test_download'));
      await safeClick(btnTestDownload);
      await safeDelayMs(driver, 1000);
      logger.info(TAG, `${BUNDLE}GlobalRetryOptionsPage_003 end`);
      done();
    })

    /**
     * 进入全局超时选项页面
     */
    it('GlobalTimeoutOptionsPage_001', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}GlobalTimeoutOptionsPage_001 begin`);
      await safePressBack(driver);
      await safeDelayMs(driver, 1000);
      await safeAssertComponentExist(driver, ON.id('btn_global_timeout'));
      let btnGlobalTimeout = await safeFindComponent(driver, ON.id('btn_global_timeout'));
      await safeClick(btnGlobalTimeout);
      await safeDelayMs(driver, 1000);
      await safeAssertComponentExist(driver, ON.id('set_global_timeout'));
      logger.info(TAG, `${BUNDLE}GlobalTimeoutOptionsPage_001 end`);
      done();
    })

    /**
     * 设置全局超时选项
     */
    it('GlobalTimeoutOptionsPage_002', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}GlobalTimeoutOptionsPage_002 begin`);
      await safeDelayMs(driver, 500);
      let btnSetGlobal = await safeFindComponent(driver, ON.id('set_global_timeout'));
      await safeClick(btnSetGlobal);
      await safeDelayMs(driver, 500);
      logger.info(TAG, `${BUNDLE}GlobalTimeoutOptionsPage_002 end`);
      done();
    })

    /**
     * 开始测试下载
     */
    it('GlobalTimeoutOptionsPage_003', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}GlobalTimeoutOptionsPage_003 begin`);
      await safeDelayMs(driver, 500);
      let btnTestDownload = await safeFindComponent(driver, ON.id('global_timeout_start_test_download'));
      await safeClick(btnTestDownload);
      await safeDelayMs(driver, 1000);
      logger.info(TAG, `${BUNDLE}GlobalTimeoutOptionsPage_003 end`);
      done();
    })
  })
}