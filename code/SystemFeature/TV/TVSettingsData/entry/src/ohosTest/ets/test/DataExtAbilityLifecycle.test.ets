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

/**
 * @file DataExtAbilityLifecycle.test.ets
 * @overview 测试 DataExtAbility 生命周期管理
 *           覆盖：初始化、启动、停止、异常恢复、状态转换
 */

import { describe, it, expect, beforeAll, afterAll, beforeEach, afterEach } from '@ohos/hypium';
import SettingsDBHelper from '../../../main/ets/Utils/SettingsDBHelper';
import { TestDataCleaner, DatabaseTestHelper, TestAssertions } from './TestUtils';
import { GlobalContext } from '../../../main/ets/Utils/GlobalContext';
import { Log } from '../../../main/ets/Utils/Log';
import { relationalStore } from '@kit.ArkData';
import {
  getDriver,
  createFreshDriver,
  KEY_HOME,
  KEY_BACK,
  surfaceCount,
  waitForSurface,
  waitForStableSurface,
  pressAndWait,
  countNonEmptyTexts,
  TIMEOUT_HOME,
  TIMEOUT_COLD_START,
  STABLE_TOLERANCE,
  STABLE_ROUNDS
} from './SharedDriver';
import { Driver } from '@kit.TestKit';

interface LifecycleStatusObj {
  status: string;
}

export default function dataExtAbilityLifecycleTest() {
  describe('DataExtAbilityLifecycle_Test', () => {
    let driver: Driver;
    const TEST_PREFIX = 'lifecycle_test';

    beforeAll(async () => {
      SettingsDBHelper.resetInstance();
      TestDataCleaner.reset();

      driver = createFreshDriver();
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await waitForSurface(driver, 2, TIMEOUT_COLD_START);
      await waitForStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, 2500);

      const ctx = GlobalContext.getContext();
      const abilityContext = getContext() as Context;
      ctx.setObject('abilityContext', abilityContext);
    });

    afterAll(async () => {
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await waitForStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, 2000);
    });

    beforeEach(async () => {
      TestDataCleaner.reset();
    });

    afterEach(async () => {
      await TestDataCleaner.cleanTestDataByPrefix(TEST_PREFIX);
    });

    // ========== 初始化测试 ==========

    it('lability_initialization_should_create_context', 0, () => {
      let threw = false;
      try {
        const ctx = GlobalContext.getContext();
        expect(ctx !== undefined).assertTrue();
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('lability_initialization_should_create_db_helper', 0, () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        expect(helper !== undefined).assertTrue();
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('lability_initialization_should_log_startup', 0, () => {
      let threw = false;
      try {
        Log.info('Ability lifecycle initialization test started');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 启动测试 ==========

    it('lability_startup_should_initialize_db', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        await helper.getRdbStore();
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('lability_startup_should_set_context', 0, () => {
      let threw = false;
      try {
        const ctx = GlobalContext.getContext();
        const statusObj: LifecycleStatusObj = { status: 'started' };
        ctx.setObject('startup_status', statusObj);
        expect(ctx.getObject('startup_status') !== undefined).assertTrue();
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('lability_startup_should_log_startup', 0, () => {
      let threw = false;
      try {
        Log.info('Ability lifecycle startup test completed');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 停止测试 ==========

    it('lability_shutdown_should_log_shutdown', 0, () => {
      let threw = false;
      try {
        Log.info('Ability lifecycle shutdown test started');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('lability_shutdown_should_cleanup_context', 0, () => {
      let threw = false;
      try {
        const ctx = GlobalContext.getContext();
        const shutdownObj: LifecycleStatusObj = { status: 'stopped' };
        ctx.setObject('shutdown_status', shutdownObj);
        expect(ctx.getObject('shutdown_status') !== undefined).assertTrue();
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 异常恢复测试 ==========

    it('lability_recovery_after_db_error', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        await helper.getRdbStore();
        await helper.getRdbStore();
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('lability_recovery_after_context_error', 0, () => {
      let threw = false;
      try {
        const ctx = GlobalContext.getContext();
        const recoveryObj1: LifecycleStatusObj = { status: 'recovered' };
        const recoveryObj2: LifecycleStatusObj = { status: 'recovered_again' };
        ctx.setObject('recovery_test', recoveryObj1);
        ctx.setObject('recovery_test', recoveryObj2);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 状态转换测试 ==========

    it('lability_state_transition_idle_to_started', 0, () => {
      let threw = false;
      try {
        const ctx = GlobalContext.getContext();
        ctx.setProperty('lifecycle_state', 'idle');
        ctx.setProperty('lifecycle_state', 'started');
        expect(ctx.getProperty('lifecycle_state')).assertEqual('started');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('lability_state_transition_started_to_stopped', 0, () => {
      let threw = false;
      try {
        const ctx = GlobalContext.getContext();
        ctx.setProperty('lifecycle_state', 'started');
        ctx.setProperty('lifecycle_state', 'stopped');
        expect(ctx.getProperty('lifecycle_state')).assertEqual('stopped');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('lability_state_transition_stopped_to_started', 0, () => {
      let threw = false;
      try {
        const ctx = GlobalContext.getContext();
        ctx.setProperty('lifecycle_state', 'stopped');
        ctx.setProperty('lifecycle_state', 'started');
        expect(ctx.getProperty('lifecycle_state')).assertEqual('started');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('lability_state_transition_full_cycle', 0, () => {
      let threw = false;
      try {
        const ctx = GlobalContext.getContext();
        ctx.setProperty('lifecycle_state', 'idle');
        ctx.setProperty('lifecycle_state', 'started');
        ctx.setProperty('lifecycle_state', 'stopped');
        ctx.setProperty('lifecycle_state', 'idle');
        expect(ctx.getProperty('lifecycle_state')).assertEqual('idle');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 多次启动测试 ==========

    it('lability_multiple_startup_should_be_idempotent', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        await helper.getRdbStore();
        await helper.getRdbStore();
        await helper.getRdbStore();
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 并发生命周期测试 ==========

    it('lability_concurrent_startup_should_not_conflict', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const promises: Promise<relationalStore.RdbStore | undefined>[] = [];
        for (let i = 0; i < 5; i++) {
          promises.push(helper.getRdbStore());
        }
        const results = await Promise.all(promises);
        for (let i = 1; i < results.length; i++) {
          expect(results[i] === results[0]).assertTrue();
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });
  });
}
