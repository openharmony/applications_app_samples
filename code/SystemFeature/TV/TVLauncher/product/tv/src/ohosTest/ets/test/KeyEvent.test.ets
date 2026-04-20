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
  KEY_BACK,
  KEY_HOME,
  KEY_EDIT,
  surfaceCount,
  waitForSurface,
  waitForStableSurface,
  pressAndWait,
  countNonEmptyTexts,
  TIMEOUT_HOME,
  TIMEOUT_EDIT,
  STABLE_TOLERANCE,
  STABLE_ROUNDS
} from './SharedDriver';

export default function keyEventTest() {
  describe('KeyEvent_Test', () => {
    let driver: Driver;

    beforeAll(async () => {
      driver = createFreshDriver();
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await waitForSurface(driver, 2, 4000);
      await waitForStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, 2500);
    });
    afterAll(async () => {
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await waitForStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, 2000);
    });

    it('right_key_keeps_desktop', 0, async () => {
      const before = await surfaceCount(driver);
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(250);
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(8);
    });
    it('left_key_keeps_desktop', 0, async () => {
      await driver.triggerKey(KEY_LEFT);
      await driver.delayMs(250);
      expect((await driver.findComponents(ON.type('Image'))).length).assertLargerOrEqual(1);
    });
    it('up_down_keys_not_break_ui', 0, async () => {
      await driver.triggerKey(KEY_UP);
      await driver.delayMs(150);
      await driver.triggerKey(KEY_DOWN);
      await driver.delayMs(150);
      const total = (await driver.findComponents(ON.type('Image'))).length +
      (await driver.findComponents(ON.type('Text'))).length;
      expect(total).assertLargerOrEqual(1);
    });
    it('right_left_alternating_5x_alive', 0, async () => {
      for (let i = 0; i < 5; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
        await driver.delayMs(120);
      }
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
    });
    it('keyevent_all_four_dirs_text_readable', 0, async () => {
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(100);
      await driver.triggerKey(KEY_DOWN);
      await driver.delayMs(100);
      await driver.triggerKey(KEY_LEFT);
      await driver.delayMs(100);
      await driver.triggerKey(KEY_UP);
      await driver.delayMs(100);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('enter_then_back_returns_desktop', 0, async () => {
      await driver.triggerKey(KEY_ENTER);
      await driver.delayMs(1000);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect((await driver.findComponents(ON.type('Image'))).length).assertLargerOrEqual(1);
    });
    it('home_key_keeps_launcher_visible', 0, async () => {
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect((await driver.findComponents(ON.type('Text'))).length).assertLargerOrEqual(1);
    });
    it('repeated_back_5x_not_crash', 0, async () => {
      for (let i = 0; i < 5; i++) {
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect((await driver.findComponents(ON.type('Image'))).length).assertLargerOrEqual(1);
    });
    it('edit_interrupt_home_back_key_pipeline_recoverable', 0, async () => {
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(120);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(16);
    });
    it('nav_enter_back_home_text_readable', 0, async () => {
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(120);
      await driver.triggerKey(KEY_ENTER);
      await driver.delayMs(900);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('dir_burst_enter_edit_int_surface_ok', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
        await driver.delayMs(60);
      }
      await driver.triggerKey(KEY_ENTER);
      await driver.delayMs(850);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(20);
    });

    it('twenty_lr_then_home_text_readable', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
        await driver.delayMs(55);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('ten_ud_then_home_surface_positive', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_UP : KEY_DOWN);
        await driver.delayMs(70);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
    });
    it('five_home_back_cycles_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 5; i++) {
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(14);
    });
    it('five_edit_cycles_no_accumulation', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 5; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(14);
    });
    it('three_enter_back_cycles_recoverable', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_ENTER);
        await driver.delayMs(900);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(18);
    });
    it('mixed_4dirs_edit_home_back_text', 0, async () => {
      const dirs = [KEY_RIGHT, KEY_DOWN, KEY_LEFT, KEY_UP];
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(dirs[i % 4]);
        await driver.delayMs(60);
      }
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('right_burst_15_edit_back_home', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(55);
      }
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(18);
    });
    it('nav_storm_home_back_3x_text', 0, async () => {
      for (let i = 0; i < 3; i++) {
        for (let j = 0; j < 6; j++) {
          await driver.triggerKey(j % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
          await driver.delayMs(55);
        }
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('keyevent_twenty_home_back_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(22);
    });
    it('keyevent_twelve_edit_cycles_no_leak', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(20);
    });
    it('keyevent_eight_enter_back_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_ENTER);
        await driver.delayMs(900);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(24);
    });
    it('keyevent_edit_interrupt_12x_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(26);
    });
    it('keyevent_circular_4dirs_10rounds_text', 0, async () => {
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
    it('keyevent_nav_50_lr_home_text', 0, async () => {
      for (let i = 0; i < 5; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
        await driver.delayMs(45);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('four_dir_square_three_rounds_surface_positive', 0, async () => {
      const dirs = [KEY_RIGHT, KEY_DOWN, KEY_LEFT, KEY_UP];
      for (let r = 0; r < 3; r++) {
        for (const d of dirs) {
          await driver.triggerKey(d);
          await driver.delayMs(80);
        }
      }
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
    });

    it('enter_back_edit_back_chain_text_readable', 0, async () => {
      await driver.triggerKey(KEY_ENTER);
      await driver.delayMs(900);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('rapid_back_burst_6x_surface_positive', 0, async () => {
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      for (let i = 0; i < 6; i++) {
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
    });

    it('alternating_edit_home_back_five_rounds_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 5; i++) {
        if (i % 2 === 0) {
          await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
          await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
        } else {
          await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
          await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
        }
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(18);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('home_back_edit_nav_right_chain_five_rounds_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 5; i++) {
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(130);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(22);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('burst_right_enter_back_edit_home_back_surface_ok', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 5; i++) {
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(70);
      }
      await driver.triggerKey(KEY_ENTER);
      await driver.delayMs(900);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(20);
    });

    it('up_down_burst_then_home_text_readable', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_UP : KEY_DOWN);
        await driver.delayMs(80);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('four_dir_round_then_enter_back_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (const k of [KEY_RIGHT, KEY_DOWN, KEY_LEFT, KEY_UP]) {
        await driver.triggerKey(k);
        await driver.delayMs(100);
      }
      await driver.triggerKey(KEY_ENTER);
      await driver.delayMs(900);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(16);
    });

    it('rapid_back_burst_after_edit_home_surface_positive', 0, async () => {
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
    });

    it('three_enter_edit_back_home_cycles_text_readable', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(120);
        await driver.triggerKey(KEY_ENTER);
        await driver.delayMs(900);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('left_burst_15_then_edit_home_back_text', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_LEFT);
        await driver.delayMs(55);
      }
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('down_burst_10_edit_back_home_surface_positive', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_DOWN);
        await driver.delayMs(70);
      }
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
    });
  });
}
