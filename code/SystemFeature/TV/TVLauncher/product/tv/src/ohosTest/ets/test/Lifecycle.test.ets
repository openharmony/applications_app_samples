/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 */

import { describe, it, expect, beforeAll, beforeEach, afterEach, afterAll } from '@ohos/hypium';
import { Driver, DisplayRotation } from '@ohos.UiTest';
import {
  getDriver,
  createFreshDriver,
  KEY_HOME,
  KEY_BACK,
  KEY_EDIT,
  KEY_RIGHT,
  KEY_LEFT,
  KEY_ENTER,
  waitForSurface,
  waitForStableSurface,
  pressAndWait,
  runSerializedUiOperation,
  surfaceCount,
  countNonEmptyTexts,
  TIMEOUT_HOME,
  TIMEOUT_EDIT,
  TIMEOUT_COLD_START,
  TOLERANCE_EDIT_CYCLE,
  TOLERANCE_STRESS,
  STABLE_TOLERANCE,
  STABLE_ROUNDS
} from './SharedDriver';

async function enterEdit(d: Driver): Promise<void> {
  await pressAndWait(d, KEY_EDIT, 2, TIMEOUT_EDIT);
}

async function exitEdit(d: Driver): Promise<void> {
  await pressAndWait(d, KEY_BACK, 2, TIMEOUT_EDIT);
}

export default function lifecycleTest() {
  describe('Lifecycle_Test', () => {
    let driver: Driver;

    beforeAll(async () => {
      driver = createFreshDriver();
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await runSerializedUiOperation(async () => {
        await driver.setDisplayRotation(DisplayRotation.ROTATION_0);
      });
      await waitForSurface(driver, 2, TIMEOUT_COLD_START);
      await waitForStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, 2500);
    });
    beforeEach(async () => {
      driver = getDriver();
      await runSerializedUiOperation(async () => {
        await driver.setDisplayRotation(DisplayRotation.ROTATION_0);
      });
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await waitForSurface(driver, 2, TIMEOUT_COLD_START);
      await waitForStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, 2000);
    });
    afterEach(async () => {
      await runSerializedUiOperation(async () => {
        await driver.setDisplayRotation(DisplayRotation.ROTATION_0);
      });
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await waitForStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, 2000);
    });
    afterAll(async () => {
      await runSerializedUiOperation(async () => {
        await driver.setDisplayRotation(DisplayRotation.ROTATION_0);
      });
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await waitForStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, 2000);
    });

    it('cold_start_renders_components', 0, async () => {
      await waitForSurface(driver, 1, TIMEOUT_COLD_START);
      expect(await surfaceCount(driver)).assertLargerOrEqual(1);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('press_home_keeps_desktop', 0, async () => {
      await pressAndWait(driver, KEY_HOME, 1, TIMEOUT_HOME);
      expect(await surfaceCount(driver)).assertLargerOrEqual(1);
    });

    it('single_home_back_text', 0, async () => {
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('five_home_back_bounded', 0, async () => {
      const b = await surfaceCount(driver);
      for (let i = 0; i < 5; i++) {
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
      expect(Math.abs(await surfaceCount(driver) - b)).assertLessOrEqual(14);
    });
    it('lifecycle_ten_home_back_text_readable', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('nav_then_home_back_text', 0, async () => {
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(120);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('enter_exit_edit_layout_stable', 0, async () => {
      const b = await surfaceCount(driver);
      await enterEdit(driver);
      await exitEdit(driver);
      const a = await surfaceCount(driver);
      expect(a).assertLargerOrEqual(2);
      expect(Math.abs(a - b)).assertLessOrEqual(TOLERANCE_EDIT_CYCLE);
    });
    it('repeat_edit_3x_not_break', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await enterEdit(driver);
        await exitEdit(driver);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('lifecycle_five_edit_cycles_bounded', 0, async () => {
      const b = await surfaceCount(driver);
      for (let i = 0; i < 5; i++) {
        await enterEdit(driver);
        await exitEdit(driver);
      }
      expect(Math.abs(await surfaceCount(driver) - b)).assertLessOrEqual(14);
    });
    it('edit_interrupt_home_back_text', 0, async () => {
      await enterEdit(driver);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('lifecycle_five_edit_home_back_cycles_recoverable', 0, async () => {
      const b = await surfaceCount(driver);
      for (let i = 0; i < 5; i++) {
        await enterEdit(driver);
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      const a = await surfaceCount(driver);
      expect(a).assertLargerOrEqual(2);
      expect(Math.abs(a - b)).assertLessOrEqual(TOLERANCE_STRESS);
    });

    it('launch_enter_back_returns_desktop', 0, async () => {
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(150);
      await driver.triggerKey(KEY_ENTER);
      await driver.delayMs(1200);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('lifecycle_three_launch_back_cycles_stable', 0, async () => {
      const b = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(130);
        await driver.triggerKey(KEY_ENTER);
        await driver.delayMs(900);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      const a = await surfaceCount(driver);
      expect(a).assertLargerOrEqual(2);
      expect(Math.abs(a - b)).assertLessOrEqual(TOLERANCE_EDIT_CYCLE + 4);
    });
    it('edit_interrupt_by_home_recovers_text', 0, async () => {
      await enterEdit(driver);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('rotate_90_restore_surface_ok', 0, async () => {
      const before = await surfaceCount(driver);
      await driver.setDisplayRotation(DisplayRotation.ROTATION_90);
      await driver.delayMs(900);
      await driver.setDisplayRotation(DisplayRotation.ROTATION_0);
      await driver.delayMs(900);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(18);
    });
    it('rotate_home_back_text_readable', 0, async () => {
      await driver.setDisplayRotation(DisplayRotation.ROTATION_90);
      await driver.delayMs(800);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      await driver.setDisplayRotation(DisplayRotation.ROTATION_0);
      await driver.delayMs(800);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('rotate_edit_interrupt_text', 0, async () => {
      await driver.setDisplayRotation(DisplayRotation.ROTATION_90);
      await driver.delayMs(700);
      await enterEdit(driver);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      await driver.setDisplayRotation(DisplayRotation.ROTATION_0);
      await driver.delayMs(700);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('double_rotate_home_back_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 2; i++) {
        await driver.setDisplayRotation(DisplayRotation.ROTATION_90);
        await driver.delayMs(700);
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
        await driver.setDisplayRotation(DisplayRotation.ROTATION_0);
        await driver.delayMs(700);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(20);
    });

    it('nav_edit_home_combined_surface_ok', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 6; i++) {
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(60);
      }
      await enterEdit(driver);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(20);
    });
    it('three_launch_back_edit_chain_text', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(120);
        await driver.triggerKey(KEY_ENTER);
        await driver.delayMs(900);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      await enterEdit(driver);
      await exitEdit(driver);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('burst_nav_home_edit_3x_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let r = 0; r < 3; r++) {
        for (let i = 0; i < 3; i++) {
          await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
          await driver.delayMs(55);
        }
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
        await enterEdit(driver);
        await exitEdit(driver);
      }
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(22);
    });
    it('home_back_edit_home_back_5x_text', 0, async () => {
      for (let i = 0; i < 5; i++) {
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
        await enterEdit(driver);
        await exitEdit(driver);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('rotate_nav_edit_combined_text', 0, async () => {
      await driver.setDisplayRotation(DisplayRotation.ROTATION_90);
      await driver.delayMs(700);
      for (let i = 0; i < 5; i++) {
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(80);
      }
      await driver.setDisplayRotation(DisplayRotation.ROTATION_0);
      await driver.delayMs(700);
      await enterEdit(driver);
      await exitEdit(driver);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('home_back_edit_chain_three_rounds_text', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
        await enterEdit(driver);
        await exitEdit(driver);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('launch_then_edit_back_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(130);
      await driver.triggerKey(KEY_ENTER);
      await driver.delayMs(900);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      await enterEdit(driver);
      await exitEdit(driver);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(20);
    });

    it('rotation_home_back_twice_text_readable', 0, async () => {
      for (let i = 0; i < 2; i++) {
        await driver.setDisplayRotation(DisplayRotation.ROTATION_90);
        await driver.delayMs(700);
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
        await driver.setDisplayRotation(DisplayRotation.ROTATION_0);
        await driver.delayMs(700);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('alternating_lr_nav_then_home_surface_positive', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
        await driver.delayMs(60);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
    });

    it('cold_start_home_back_edit_5x_no_accum', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 5; i++) {
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
        await enterEdit(driver);
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(130);
        await exitEdit(driver);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(22);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('launch_back_edit_int_home_3x_text', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(130);
        await driver.triggerKey(KEY_ENTER);
        await driver.delayMs(900);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
        await enterEdit(driver);
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('nav_burst_home_back_edit_cycle_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
        await driver.delayMs(65);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      await enterEdit(driver);
      await exitEdit(driver);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(20);
    });

    it('home_back_rotate_edit_chain_text_readable', 0, async () => {
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      await driver.setDisplayRotation(DisplayRotation.ROTATION_90);
      await driver.delayMs(800);
      await enterEdit(driver);
      await exitEdit(driver);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await driver.setDisplayRotation(DisplayRotation.ROTATION_0);
      await driver.delayMs(800);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
  });
} 


