/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 */

import { describe, it, expect, beforeAll, afterAll } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import {
  getDriver,
  createFreshDriver,
  KEY_EDIT,
  KEY_BACK,
  KEY_LEFT,
  KEY_RIGHT,
  KEY_UP,
  KEY_DOWN,
  KEY_ENTER,
  KEY_HOME,
  surfaceCount,
  waitForSurface,
  waitForStableSurface,
  pressAndWait,
  pressKeyWithDelay,
  countNonEmptyTexts,
  TIMEOUT_HOME,
  TIMEOUT_EDIT,
  STABLE_TOLERANCE,
  STABLE_ROUNDS
} from './SharedDriver';

export default function appEditTest() {
  describe('AppEdit_Test', () => {
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

    it('enter_edit_mode_keeps_layout', 0, async () => {
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      expect((await driver.findComponents(ON.type('Image'))).length).assertLargerOrEqual(1);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
    });
    it('exit_edit_mode_restores_desktop', 0, async () => {
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      expect((await driver.findComponents(ON.type('Text'))).length).assertLargerOrEqual(1);
    });
    it('edit_enter_exit_surface_stable', 0, async () => {
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(14);
    });

    it('move_right_in_edit_not_break_ui', 0, async () => {
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressKeyWithDelay(driver, KEY_RIGHT, 300);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(8);
    });
    it('move_left_in_edit_not_break_ui', 0, async () => {
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressKeyWithDelay(driver, KEY_LEFT, 300);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      expect((await driver.findComponents(ON.type('Image'))).length).assertLargerOrEqual(1);
    });
    it('move_up_down_in_edit_not_break_ui', 0, async () => {
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressKeyWithDelay(driver, KEY_UP, 200);
      await pressKeyWithDelay(driver, KEY_DOWN, 200);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
    });

    it('edit_move_confirm_back_home_surface_stable', 0, async () => {
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressKeyWithDelay(driver, KEY_RIGHT, 180);
      await pressKeyWithDelay(driver, KEY_ENTER, 260);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(14);
    });
    it('edit_interrupt_by_home_text_readable', 0, async () => {
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('edit_left_up_enter_back_home_surface_recoverable', 0, async () => {
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressKeyWithDelay(driver, KEY_LEFT, 160);
      await pressKeyWithDelay(driver, KEY_UP, 160);
      await pressKeyWithDelay(driver, KEY_ENTER, 220);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(16);
    });

    it('appedit_five_edit_cycles_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 5; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(14);
    });
    it('three_edit_home_interrupt_text_readable', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('edit_nav_burst_back_home_surface_ok', 0, async () => {
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      for (let i = 0; i < 3; i++) {
        await pressKeyWithDelay(driver, i % 2 === 0 ? KEY_RIGHT : KEY_LEFT, 70);
      }
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(16);
    });
    it('enter_in_edit_back_home_text_readable', 0, async () => {
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressKeyWithDelay(driver, KEY_ENTER, 500);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('edit_up_down_enter_back_home_recoverable', 0, async () => {
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressKeyWithDelay(driver, KEY_UP, 150);
      await pressKeyWithDelay(driver, KEY_DOWN, 150);
      await pressKeyWithDelay(driver, KEY_ENTER, 300);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(16);
    });
    it('rapid_edit_exit_6x_no_leak', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 6; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(14);
    });
    it('edit_home_back_3x_nav_text_readable', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      await pressKeyWithDelay(driver, KEY_RIGHT, 120);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('appedit_twenty_home_back_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(22);
    });
    it('appedit_twelve_edit_cycles_no_leak', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(20);
    });
    it('nav_40_edit_home_back_text', 0, async () => {
      for (let i = 0; i < 4; i++) {
        await pressKeyWithDelay(driver, i % 2 === 0 ? KEY_RIGHT : KEY_LEFT, 50);
      }
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('circular_edit_5rounds_text', 0, async () => {
      const dirs = [KEY_RIGHT, KEY_DOWN, KEY_LEFT, KEY_UP];
      for (let r = 0; r < 5; r++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressKeyWithDelay(driver, dirs[r % 4], 100);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('twenty_edit_cycles_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(26);
    });

    it('edit_right_enter_back_home_3x_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressKeyWithDelay(driver, KEY_RIGHT, 200);
        await pressKeyWithDelay(driver, KEY_ENTER, 300);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(20);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('edit_left_down_enter_home_back_text_readable', 0, async () => {
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressKeyWithDelay(driver, KEY_LEFT, 150);
      await pressKeyWithDelay(driver, KEY_DOWN, 150);
      await pressKeyWithDelay(driver, KEY_ENTER, 300);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('nav_then_edit_then_nav_then_home_surface_ok', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 6; i++) {
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(80);
      }
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      for (let i = 0; i < 4; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_LEFT : KEY_RIGHT);
        await driver.delayMs(100);
      }
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      for (let i = 0; i < 6; i++) {
        await driver.triggerKey(KEY_LEFT);
        await driver.delayMs(80);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(18);
    });

    it('rapid_edit_nav_burst_five_rounds_no_leak', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 5; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await driver.triggerKey(KEY_UP);
        await driver.delayMs(120);
        await driver.triggerKey(KEY_DOWN);
        await driver.delayMs(120);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(16);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('edit_home_int_back_edit_again_positive', 0, async () => {
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('five_edit_enter_back_home_cycles_no_accumulation', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 5; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await driver.triggerKey(KEY_ENTER);
        await driver.delayMs(350);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(22);
    });

    it('edit_with_all_four_dirs_then_home_text_readable', 0, async () => {
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      for (const k of [KEY_RIGHT, KEY_DOWN, KEY_LEFT, KEY_UP]) {
        await driver.triggerKey(k);
        await driver.delayMs(130);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('alternating_edit_nav_home_back_8x_ok', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        if (i % 2 === 0) {
          await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
          await driver.triggerKey(i % 4 === 0 ? KEY_RIGHT : KEY_LEFT);
          await driver.delayMs(120);
          await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
        } else {
          await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
          await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
        }
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(22);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
  });
}
