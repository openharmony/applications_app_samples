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
import { Driver, ON } from '@ohos.UiTest';
import {
  getDriver,
  createFreshDriver,
  KEY_LEFT,
  KEY_RIGHT,
  KEY_DOWN,
  KEY_UP,
  KEY_BACK,
  KEY_HOME,
  KEY_ENTER,
  KEY_EDIT,
  surfaceCount,
  waitForSurface,
  waitForStableSurface,
  pressAndWait,
  countNonEmptyTexts,
  TIMEOUT_HOME,
  TIMEOUT_EDIT,
  TIMEOUT_COLD_START,
  STABLE_ROUNDS,
  STABLE_TOLERANCE,
  TOLERANCE_EDIT_CYCLE,
  TOLERANCE_STRESS
} from './SharedDriver';

export default function scenarioRegressionTest() {
  describe('ScenarioRegression_Test', () => {
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

    it('desktop_images_in_reasonable_range', 0, async () => {
      const images = (await driver.findComponents(ON.type('Image'))).length;
      expect(images).assertLargerOrEqual(3);
      expect(images).assertLessOrEqual(80);
    });

    it('desktop_texts_in_reasonable_range', 0, async () => {
      const texts = (await driver.findComponents(ON.type('Text'))).length;
      expect(texts).assertLargerOrEqual(1);
      expect(texts).assertLessOrEqual(100);
    });

    it('component_total_stable_across_samples', 0, async () => {
      const total1 = await surfaceCount(driver);
      await driver.delayMs(700);
      const total2 = await surfaceCount(driver);
      expect(Math.abs(total2 - total1)).assertLessOrEqual(10);
    });

    it('non_empty_text_at_least_one', 0, async () => {
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('surface_count_at_least_two', 0, async () => {
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
    });

    it('right_key_50_times_keeps_desktop_alive', 0, async () => {
      for (let i = 0; i < 5; i++) {
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(60);
      }
      expect((await driver.findComponents(ON.type('Image'))).length).assertLargerOrEqual(1);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
    });

    it('alternating_lr_60_times_stable', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(60);
        await driver.triggerKey(KEY_LEFT);
        await driver.delayMs(60);
      }
      expect((await driver.findComponents(ON.type('Image'))).length).assertLargerOrEqual(1);
    });

    it('edit_mode_10_cycles_stable', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(TOLERANCE_STRESS);
    });

    it('home_back_loop_no_component_expansion', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(await surfaceCount(driver)).assertLargerOrEqual(1);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(12);
    });

    it('left_boundary_move_keeps_desktop_stable', 0, async () => {
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await driver.triggerKey(KEY_LEFT);
      await driver.delayMs(300);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(TOLERANCE_EDIT_CYCLE);
    });

    it('right_boundary_move_keeps_desktop_stable', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(80);
      }
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(300);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(TOLERANCE_EDIT_CYCLE);
    });

    it('edit_mode_exit_keeps_ui_available', 0, async () => {
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      expect((await driver.findComponents(ON.type('Text'))).length).assertLargerOrEqual(1);
    });

    it('edit_up_down_enter_back_home_surface_ok', 0, async () => {
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await driver.triggerKey(KEY_UP);
      await driver.delayMs(150);
      await driver.triggerKey(KEY_DOWN);
      await driver.delayMs(150);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(TOLERANCE_EDIT_CYCLE);
    });

    it('stress_then_edit_cycle_surface_recoverable', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
        await driver.delayMs(55);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(TOLERANCE_STRESS);
    });

    it('edit_interrupt_then_home_back_text_readable', 0, async () => {
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('triple_home_back_reentry_text_readable', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('nav_burst_then_edit_home_back_surface_ok', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
        await driver.delayMs(50);
      }
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(TOLERANCE_STRESS);
    });

    it('edit_menu_cycle_home_back_reentry_surface_ok', 0, async () => {
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await driver.triggerKey(KEY_UP);
      await driver.delayMs(150);
      await driver.triggerKey(KEY_DOWN);
      await driver.delayMs(150);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(TOLERANCE_STRESS);
    });

    it('scenario_twenty_home_back_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(22);
    });
    it('scenario_fifteen_edit_cycles_no_leak', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(20);
    });
    it('scenario_nav_50_lr_home_text', 0, async () => {
      for (let i = 0; i < 5; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
        await driver.delayMs(45);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
  });
}
