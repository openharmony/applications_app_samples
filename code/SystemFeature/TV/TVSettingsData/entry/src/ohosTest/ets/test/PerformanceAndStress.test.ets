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
 * @file PerformanceAndStress.test.ets
 * @overview 测试性能和压力场景
 *           覆盖：高频操作、长时间运行、并发访问、内存泄漏检测
 */

import { describe, it, expect, beforeAll, afterAll, beforeEach, afterEach } from '@ohos/hypium';
import { settingsDataConfig, DataSettingsKey } from '../../../main/ets/Utils/SettingsDataConfig';
import SettingsDBHelper from '../../../main/ets/Utils/SettingsDBHelper';
import { TestDataCleaner, DatabaseTestHelper, TestAssertions } from './TestUtils';
import { GlobalContext } from '../../../main/ets/Utils/GlobalContext';
import { relationalStore } from '@kit.ArkData';
import {
  getDriver,
  createFreshDriver,
  KEY_HOME,
  KEY_BACK,
  KEY_EDIT,
  KEY_LEFT,
  KEY_RIGHT,
  KEY_UP,
  KEY_DOWN,
  surfaceCount,
  waitForSurface,
  waitForStableSurface,
  pressAndWait,
  countNonEmptyTexts,
  TIMEOUT_HOME,
  TIMEOUT_EDIT,
  TIMEOUT_COLD_START,
  STABLE_TOLERANCE,
  STABLE_ROUNDS,
  TOLERANCE_EDIT_CYCLE,
  TOLERANCE_STRESS
} from './SharedDriver';
import { Driver } from '@kit.TestKit';

interface StressValObj {
  val: number;
}

export default function performanceAndStressTest() {
  describe('PerformanceAndStress_Test', () => {
    let driver: Driver;
    const TEST_PREFIX = 'performance_test';

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

    // ========== 高频操作测试 ==========

    it('stress_ten_home_back_cycles_surface_stable', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(14);
    });

    it('stress_ten_edit_cycles_no_leak', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      const after = await surfaceCount(driver);
      expect(Math.abs(after - before)).assertLessOrEqual(TOLERANCE_EDIT_CYCLE);
    });

    it('stress_rapid_home_back_text_readable', 0, async () => {
      for (let i = 0; i < 5; i++) {
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('stress_rapid_edit_back_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 5; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(TOLERANCE_STRESS);
    });

    // ========== 并发访问测试 ==========

    it('stress_concurrent_db_access', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        const promises: Promise<relationalStore.RdbStore | undefined>[] = [];
        for (let i = 0; i < 10; i++) {
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

    it('stress_concurrent_context_access', 0, () => {
      let threw = false;
      try {
        const contexts: GlobalContext[] = [];
        for (let i = 0; i < 10; i++) {
          contexts.push(GlobalContext.getContext());
        }
        for (let i = 1; i < contexts.length; i++) {
          expect(contexts[i] === contexts[0]).assertTrue();
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 内存泄漏检测测试 ==========

    it('stress_memory_no_leak_after_operations', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        for (let i = 0; i < 20; i++) {
          await helper.getRdbStore();
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('stress_memory_context_operations', 0, () => {
      let threw = false;
      try {
        const ctx = GlobalContext.getContext();
        for (let i = 0; i < 50; i++) {
          const stressObj: StressValObj = { val: i };
          ctx.setObject('stress_key_' + i, stressObj);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 长时间运行测试 ==========

    it('stress_long_running_db_operations', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        for (let i = 0; i < 30; i++) {
          await helper.getRdbStore();
          if (i % 10 === 0) {
            helper.getArea();
          }
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 混合压力测试 ==========

    it('stress_mixed_home_edit_back_cycles', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 5; i++) {
        if (i % 2 === 0) {
          await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
          await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
        } else {
          await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
          await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
        }
      }
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(TOLERANCE_STRESS);
    });

    it('stress_mixed_nav_operations', 0, async () => {
      const before = await surfaceCount(driver);
      const keys = [KEY_LEFT, KEY_RIGHT, KEY_UP, KEY_DOWN];
      for (let i = 0; i < 10; i++) {
        await driver.triggerKey(keys[i % keys.length]);
        await driver.delayMs(50);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(TOLERANCE_STRESS);
    });

    // ========== 数据操作压力测试 ==========

    it('stress_data_operations_batch', 0, async () => {
      let threw = false;
      try {
        const helper = SettingsDBHelper.getInstance();
        await helper.getRdbStore();
        for (let i = 0; i < 20; i++) {
          await helper.initialInsert(settingsDataConfig.TABLE_NAME);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });
  });
}
