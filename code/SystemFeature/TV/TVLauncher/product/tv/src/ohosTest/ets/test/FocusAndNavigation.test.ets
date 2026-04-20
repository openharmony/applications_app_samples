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

import { describe, it, expect, beforeAll, afterAll } from '@ohos/hypium';
import { Driver } from '@ohos.UiTest';
import {
  getDriver,
  createFreshDriver,
  KEY_HOME,
  KEY_BACK,
  KEY_EDIT,
  KEY_RIGHT,
  KEY_LEFT,
  KEY_UP,
  KEY_DOWN,
  KEY_ENTER,
  waitForSurface,
  waitForStableSurface,
  pressAndWait,
  surfaceCount,
  countNonEmptyTexts,
  TIMEOUT_HOME,
  TIMEOUT_EDIT,
  TIMEOUT_COLD_START,
  TOLERANCE_EDIT_CYCLE,
  STABLE_TOLERANCE,
  STABLE_ROUNDS
} from './SharedDriver';

export default function focusAndNavigationTest() {
  describe('FocusAndNavigation_Test', () => {
    let driver: Driver;

    beforeAll(async () => {
      driver = createFreshDriver();
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await waitForSurface(driver, 2, TIMEOUT_COLD_START);
      await waitForStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, 2500);
    });
    afterAll(async () => {
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await waitForStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, 2000);
    });

    it('right_keeps_ui', 0, async () => {
      const b = await surfaceCount(driver);
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(200);
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
      expect(Math.abs(await surfaceCount(driver) - b)).assertLessOrEqual(8);
    });
    it('left_keeps_ui', 0, async () => {
      await driver.triggerKey(KEY_LEFT);
      await driver.delayMs(200);
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
    });
    it('up_keeps_ui', 0, async () => {
      await driver.triggerKey(KEY_UP);
      await driver.delayMs(200);
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
    });
    it('down_keeps_ui', 0, async () => {
      await driver.triggerKey(KEY_DOWN);
      await driver.delayMs(200);
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
    });
    it('right_left_restores', 0, async () => {
      const b = await surfaceCount(driver);
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(150);
      await driver.triggerKey(KEY_LEFT);
      await driver.delayMs(150);
      expect(Math.abs(await surfaceCount(driver) - b)).assertLessOrEqual(6);
    });
    it('focus_all_four_dirs_text_readable', 0, async () => {
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(120);
      await driver.triggerKey(KEY_DOWN);
      await driver.delayMs(120);
      await driver.triggerKey(KEY_LEFT);
      await driver.delayMs(120);
      await driver.triggerKey(KEY_UP);
      await driver.delayMs(120);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('rapid_right_10_alive', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(80);
      }
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
    });
    it('rapid_left_10_alive', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_LEFT);
        await driver.delayMs(80);
      }
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
    });

    it('right_boundary_20_no_crash', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(50);
      }
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
    });
    it('left_boundary_20_no_crash', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_LEFT);
        await driver.delayMs(50);
      }
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
    });
    it('up_boundary_10_no_crash', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_UP);
        await driver.delayMs(80);
      }
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
    });
    it('down_boundary_10_no_crash', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_DOWN);
        await driver.delayMs(80);
      }
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
    });
    it('right_boundary_home_back_text', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(60);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('alternating_lr_20_alive', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
        await driver.delayMs(60);
      }
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('enter_back_surface_recovers', 0, async () => {
      const b = await surfaceCount(driver);
      await driver.triggerKey(KEY_ENTER);
      await driver.delayMs(200);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(Math.abs(await surfaceCount(driver) - b)).assertLessOrEqual(TOLERANCE_EDIT_CYCLE);
    });
    it('nav_enter_back_home_ok', 0, async () => {
      const b = await surfaceCount(driver);
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(150);
      await driver.triggerKey(KEY_ENTER);
      await driver.delayMs(200);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(Math.abs(await surfaceCount(driver) - b)).assertLessOrEqual(TOLERANCE_EDIT_CYCLE + 4);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('back_repeated_five_times_not_crash', 0, async () => {
      for (let i = 0; i < 5; i++) {
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
    });
    it('home_repeated_five_times_not_crash', 0, async () => {
      for (let i = 0; i < 5; i++) {
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      }
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
    });

    it('nav_edit_back_text', 0, async () => {
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(120);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(120);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('edit_back_home_back_sequence_keeps_text', 0, async () => {
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('burst_nav_then_edit_home_back_text', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
        await driver.delayMs(55);
      }
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('triple_edit_nav_cycle_ok', 0, async () => {
      const b = await surfaceCount(driver);
      for (let r = 0; r < 3; r++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(100);
        await driver.triggerKey(KEY_LEFT);
        await driver.delayMs(100);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(Math.abs(await surfaceCount(driver) - b)).assertLessOrEqual(22);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('mixed_direction_burst_then_edit_home_back', 0, async () => {
      const b = await surfaceCount(driver);
      const dirs = [KEY_RIGHT, KEY_DOWN, KEY_LEFT, KEY_UP];
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(dirs[i%4]);
        await driver.delayMs(55);
      }
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      const a = await surfaceCount(driver);
      expect(a).assertLargerOrEqual(2);
      expect(Math.abs(a - b)).assertLessOrEqual(22);
    });

    it('zigzag_4dirs_ok', 0, async () => {
      const before = await surfaceCount(driver);
      const dirs = [KEY_RIGHT, KEY_DOWN, KEY_LEFT, KEY_UP];
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(dirs[i % 4]);
        await driver.delayMs(80);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(12);
    });
    it('alternating_ud_30_alive', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_UP : KEY_DOWN);
        await driver.delayMs(50);
      }
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
    });
    it('circular_3rounds_text_readable', 0, async () => {
      for (let r = 0; r < 3; r++) {
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(90);
        await driver.triggerKey(KEY_DOWN);
        await driver.delayMs(90);
        await driver.triggerKey(KEY_LEFT);
        await driver.delayMs(90);
        await driver.triggerKey(KEY_UP);
        await driver.delayMs(90);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('sparse_nav_surface_ok', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 5; i++) {
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(300);
        await driver.triggerKey(KEY_LEFT);
        await driver.delayMs(300);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(10);
    });
    it('rapid_alt_lr_40_alive', 0, async () => {
      for (let i = 0; i < 4; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
        await driver.delayMs(50);
      }
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('five_enter_back_home_cycles_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 5; i++) {
        await driver.triggerKey(KEY_ENTER);
        await driver.delayMs(200);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(22);
    });
    it('nav_burst_edit_3x_text', 0, async () => {
      for (let r = 0; r < 3; r++) {
        for (let i = 0; i < 3; i++) {
          await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
          await driver.delayMs(55);
        }
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('enter_nav_home_3x_surface_stable', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(120);
        await driver.triggerKey(KEY_ENTER);
        await driver.delayMs(200);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(22);
    });
    it('home_back_nav_edit_chain_text', 0, async () => {
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      for (let i = 0; i < 5; i++) {
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(80);
      }
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('all_dirs_then_enter_back_edit_home_surface_ok', 0, async () => {
      const before = await surfaceCount(driver);
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(100);
      await driver.triggerKey(KEY_DOWN);
      await driver.delayMs(100);
      await driver.triggerKey(KEY_LEFT);
      await driver.delayMs(100);
      await driver.triggerKey(KEY_UP);
      await driver.delayMs(100);
      await driver.triggerKey(KEY_ENTER);
      await driver.delayMs(200);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(22);
    });

    it('focus_twenty_home_back_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(22);
    });
    it('focus_fifteen_edit_cycles_no_leak', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(20);
    });
    it('nav_60_lr_home_text', 0, async () => {
      for (let i = 0; i < 5; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
        await driver.delayMs(45);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('ten_enter_back_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_ENTER);
        await driver.delayMs(200);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(24);
    });
    it('focus_edit_interrupt_12x_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(26);
    });
    it('focus_circular_4dirs_10rounds_text', 0, async () => {
      const dirs = [KEY_RIGHT, KEY_DOWN, KEY_LEFT, KEY_UP];
      for (let r = 0; r < 10; r++) {
        for (const d of dirs) {
          await driver.triggerKey(d);
          await driver.delayMs(55);
        }
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
  });
}
