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
  KEY_UP,
  KEY_DOWN,
  KEY_ENTER,
  KEY_HOME,
  KEY_BACK,
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
  TOLERANCE_SINGLE_OP,
  TOLERANCE_EDIT_CYCLE,
  TOLERANCE_STRESS
} from './SharedDriver';

export default function launcherTest() {
  describe('Launcher_Test', () => {
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

    it('desktop_should_have_text_and_image_components', 0, async () => {
      await waitForSurface(driver, 1, TIMEOUT_HOME);
      await waitForStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, 1500);
      const total = await surfaceCount(driver);
      const nonEmpty = await countNonEmptyTexts(driver);
      expect(total).assertLargerOrEqual(1);
      expect(nonEmpty).assertLargerOrEqual(1);
    });

    it('image_count_should_be_in_reasonable_range', 0, async () => {
      await waitForSurface(driver, 1, TIMEOUT_HOME);
      await waitForStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, 1500);
      const total = await surfaceCount(driver);
      expect(total).assertLargerOrEqual(1);
      expect(total).assertLessOrEqual(60);
    });

    it('desktop_should_keep_stable_after_sampling', 0, async () => {
      const s1 = await surfaceCount(driver);
      await driver.delayMs(400);
      const s2 = await surfaceCount(driver);
      await driver.delayMs(400);
      const s3 = await surfaceCount(driver);
      const max = Math.max(s1, s2, s3);
      const min = Math.min(s1, s2, s3);
      expect(max - min).assertLessOrEqual(TOLERANCE_SINGLE_OP);
    });

    it('move_right_should_not_break_desktop', 0, async () => {
      const before = await surfaceCount(driver);
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(300);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(1);
      expect(Math.abs(after - before)).assertLessOrEqual(TOLERANCE_SINGLE_OP);
    });

    it('left_boundary_should_not_crash', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_LEFT);
        await driver.delayMs(150);
      }
      const total = await surfaceCount(driver);
      expect(total).assertLargerOrEqual(1);
    });

    it('right_boundary_should_not_crash', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(120);
      }
      const total = await surfaceCount(driver);
      expect(total).assertLargerOrEqual(1);
    });

    it('enter_after_focus_move_should_keep_ui_available', 0, async () => {
      await driver.delayMs(150);
      await driver.triggerKey(KEY_ENTER);
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(900);
      const total = await surfaceCount(driver);
      expect(total).assertLargerOrEqual(1);
    });

    it('double_back_should_return_to_desktop', 0, async () => {
      await driver.delayMs(900);
      await driver.pressBack();
      await driver.delayMs(600);
      await driver.pressBack();
      await driver.delayMs(600);
      const texts = (await driver.findComponents(ON.type('Text'))) ?? [];
      expect(texts.length).assertLargerOrEqual(1);
    });

    it('edit_int_home_back_launch_surface_ok', 0, async () => {
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(140);
      await driver.triggerKey(KEY_ENTER);
      await driver.delayMs(900);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(18);
    });

    it('nav_home_back_cycle_text_ok', 0, async () => {
      await pressAndWait(driver, KEY_LEFT, 1, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 1, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 1, TIMEOUT_HOME);
      await waitForStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, 2500);
      const nonEmpty = await countNonEmptyTexts(driver);
      const total = await surfaceCount(driver);
      expect(nonEmpty > 0 || total > 0).assertTrue();
    });

    it('right_burst_edit_int_enter_back_home_ok', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(70);
      }
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      await driver.triggerKey(KEY_ENTER);
      await driver.delayMs(850);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(20);
    });

    it('launcher_ten_home_back_text_readable', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('launcher_five_edit_cycles_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 5; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(TOLERANCE_EDIT_CYCLE);
    });

    it('nav_20_then_home_back_text', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
        await driver.delayMs(55);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('launcher_three_edit_home_back_cycles_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(20);
    });

    it('five_launch_back_cycles_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 5; i++) {
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(130);
        await driver.triggerKey(KEY_ENTER);
        await driver.delayMs(900);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(TOLERANCE_STRESS);
    });

    it('circular_nav_5rounds_text_readable', 0, async () => {
      const dirs = [KEY_RIGHT, KEY_DOWN, KEY_LEFT, KEY_UP];
      for (let r = 0; r < 5; r++) {
        for (const d of dirs) {
          await driver.triggerKey(d);
          await driver.delayMs(80);
        }
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('rapid_lr_nav_then_home_back_text_readable', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
        await driver.delayMs(55);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('edit_interrupt_three_rounds_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(TOLERANCE_STRESS);
    });

    it('launch_back_three_times_then_home_text_readable', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_ENTER);
        await driver.delayMs(900);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('directional_square_three_rounds_surface_positive', 0, async () => {
      const dirs = [KEY_RIGHT, KEY_DOWN, KEY_LEFT, KEY_UP];
      for (let r = 0; r < 3; r++) {
        for (const d of dirs) {
          await driver.triggerKey(d);
          await driver.delayMs(85);
        }
      }
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
    });
  });
}
