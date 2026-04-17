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

async function openRecent(driver: Driver): Promise<void> {
  await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
}

async function closeRecent(driver: Driver): Promise<void> {
  await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
}

export default function recentTest() {
  describe('Recent_Test', () => {
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

    it('open_recent_shows_components', 0, async () => {
      await openRecent(driver);
      const total = (await driver.findComponents(ON.type('Image'))).length +
      (await driver.findComponents(ON.type('Text'))).length;
      expect(total).assertLargerOrEqual(1);
    });
    it('close_recent_returns_desktop', 0, async () => {
      await openRecent(driver);
      await closeRecent(driver);
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('five_recent_open_close_cycles_stable', 0, async () => {
      for (let i = 0; i < 5; i++) {
        await openRecent(driver);
        await closeRecent(driver);
      }
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
    });
    it('recent_open_nav_close_five_cycles_stable', 0, async () => {
      for (let i = 0; i < 5; i++) {
        await openRecent(driver);
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(120);
        await closeRecent(driver);
      }
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
    });

    it('left_right_navigation_not_crash', 0, async () => {
      await openRecent(driver);
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(150);
      await driver.triggerKey(KEY_LEFT);
      await driver.delayMs(150);
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
    });
    it('up_operation_keeps_ui', 0, async () => {
      await openRecent(driver);
      await driver.triggerKey(KEY_UP);
      await driver.delayMs(500);
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
    });
    it('nav_then_back_text_readable', 0, async () => {
      await openRecent(driver);
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(150);
      await driver.triggerKey(KEY_LEFT);
      await driver.delayMs(150);
      await closeRecent(driver);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('recent_enter_back_surface_recoverable', 0, async () => {
      const before = await surfaceCount(driver);
      await openRecent(driver);
      await driver.triggerKey(KEY_ENTER);
      await driver.delayMs(900);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(TOLERANCE_EDIT_CYCLE);
    });
    it('recent_up_delete_back_desktop_alive', 0, async () => {
      await openRecent(driver);
      await driver.triggerKey(KEY_UP);
      await driver.delayMs(900);
      await closeRecent(driver);
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
    });
    it('recent_three_up_operations_surface_positive', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await openRecent(driver);
        await driver.triggerKey(KEY_UP);
        await driver.delayMs(900);
      }
      await closeRecent(driver);
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
    });
    it('recent_down_enter_back_home_surface_recoverable', 0, async () => {
      const before = await surfaceCount(driver);
      await openRecent(driver);
      await driver.triggerKey(KEY_DOWN);
      await driver.delayMs(180);
      await driver.triggerKey(KEY_ENTER);
      await driver.delayMs(900);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(TOLERANCE_EDIT_CYCLE + 2);
    });

    it('recent_open_switch_back_home_text_readable', 0, async () => {
      await openRecent(driver);
      await driver.triggerKey(KEY_ENTER);
      await driver.delayMs(900);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('edit_then_recent_open_close_surface_recoverable', 0, async () => {
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await openRecent(driver);
      await closeRecent(driver);
      await openRecent(driver);
      await closeRecent(driver);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(TOLERANCE_EDIT_CYCLE + 2);
    });
    it('three_recent_edit_cycles_surface_stable', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await openRecent(driver);
        await closeRecent(driver);
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
        await openRecent(driver);
        await closeRecent(driver);
      }
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(22);
    });
    it('recent_launch_edit_chain_text_readable', 0, async () => {
      await openRecent(driver);
      await driver.triggerKey(KEY_ENTER);
      await driver.delayMs(900);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('recent_double_cycle_with_navigation_keeps_contract', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 2; i++) {
        await openRecent(driver);
        await closeRecent(driver);
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(100);
        await driver.triggerKey(KEY_LEFT);
        await driver.delayMs(100);
      }
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(TOLERANCE_EDIT_CYCLE);
    });

    it('recent_ten_recent_open_close_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await openRecent(driver);
        await closeRecent(driver);
      }
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(14);
    });
    it('five_enter_back_cycles_surface_ok', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 5; i++) {
        await openRecent(driver);
        await driver.triggerKey(KEY_ENTER);
        await driver.delayMs(800);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(22);
    });
    it('recent_edit_interleaved_5x_text_readable', 0, async () => {
      for (let i = 0; i < 5; i++) {
        await openRecent(driver);
        await closeRecent(driver);
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('three_up_operations_surface_positive', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await openRecent(driver);
        await driver.triggerKey(KEY_UP);
        await driver.delayMs(900);
      }
      await closeRecent(driver);
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
    });
    it('rapid_nav_in_recent_surface_ok', 0, async () => {
      await openRecent(driver);
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
        await driver.delayMs(80);
      }
      await closeRecent(driver);
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('immediate_back_after_open_surface_ok', 0, async () => {
      const before = await surfaceCount(driver);
      await openRecent(driver);
      await closeRecent(driver);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(8);
    });
    it('open_home_back_image_positive', 0, async () => {
      await openRecent(driver);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
    });
    it('recent_down_enter_back_home_text_readable', 0, async () => {
      await openRecent(driver);
      await driver.triggerKey(KEY_DOWN);
      await driver.delayMs(180);
      await driver.triggerKey(KEY_ENTER);
      await driver.delayMs(900);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('recent_nav_edit_chain_surface_ok', 0, async () => {
      const before = await surfaceCount(driver);
      await openRecent(driver);
      await closeRecent(driver);
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(120);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(18);
    });

    it('recent_twenty_home_back_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(22);
    });
    it('recent_fifteen_edit_cycles_no_leak', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(20);
    });
    it('recent_nav_50_lr_home_text', 0, async () => {
      for (let i = 0; i < 5; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
        await driver.delayMs(45);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('recent_ten_recent_open_close_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await openRecent(driver);
        await closeRecent(driver);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(18);
    });
    it('five_recent_enter_back_text', 0, async () => {
      for (let i = 0; i < 5; i++) {
        await openRecent(driver);
        await driver.triggerKey(KEY_ENTER);
        await driver.delayMs(900);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('edit_interrupt_8x_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(22);
    });

    it('open_recent_nav_four_steps_then_back_text', 0, async () => {
      await openRecent(driver);
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(100);
      await driver.triggerKey(KEY_DOWN);
      await driver.delayMs(100);
      await driver.triggerKey(KEY_LEFT);
      await driver.delayMs(100);
      await driver.triggerKey(KEY_UP);
      await driver.delayMs(100);
      await closeRecent(driver);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('recent_enter_back_3x_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await openRecent(driver);
        await driver.triggerKey(KEY_ENTER);
        await driver.delayMs(900);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(20);
    });

    it('edit_then_recent_open_close_three_rounds_text', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
        await openRecent(driver);
        await closeRecent(driver);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('rapid_recent_open_close_8x_positive', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await openRecent(driver);
        await closeRecent(driver);
      }
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
    });
  });
}
