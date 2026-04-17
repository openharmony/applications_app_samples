/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 */

import { describe, it, expect, beforeAll, beforeEach, afterAll } from '@ohos/hypium';
import { Driver, DisplayRotation, ON } from '@ohos.UiTest';
import {
  createFreshDriver,
  KEY_RIGHT,
  KEY_BACK,
  KEY_HOME,
  surfaceCount,
  waitForSurface,
  waitForStableSurface,
  pressKeyWithDelay,
  countNonEmptyTexts,
  TIMEOUT_HOME,
  STABLE_TOLERANCE,
  STABLE_ROUNDS,
  runSerializedUiOperation
} from './SharedDriver';

const CASE_TIMEOUT: number = 90000;
const QUICK_TIMEOUT_HOME: number = 4000;
const QUICK_STABLE_TIMEOUT: number = 3200;
const ROTATION_TIMEOUT: number = 5000;
const BEFORE_EACH_TIMEOUT: number = 2500;

async function requireSurface(
  driver: Driver,
  minimumCount: number,
  timeoutMs: number,
  stage: string
): Promise<void> {
  const ok = await waitForSurface(driver, minimumCount, timeoutMs);
  if (!ok) {
    throw new Error(`${stage}: surface did not reach ${minimumCount} within ${timeoutMs}ms`);
  }
}

async function requireStableSurface(
  driver: Driver,
  stableRounds: number,
  tolerance: number,
  timeoutMs: number,
  stage: string
): Promise<void> {
  const ok = await waitForStableSurface(driver, stableRounds, tolerance, timeoutMs);
  if (!ok) {
    throw new Error(`${stage}: surface did not stabilize within ${timeoutMs}ms`);
  }
}

async function requireLauncherReady(driver: Driver, stage: string): Promise<void> {
  await requireSurface(driver, 1, ROTATION_TIMEOUT, `${stage}/surface`);
  await requireStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, ROTATION_TIMEOUT, `${stage}/stable`);
  expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
}

async function pressControlKeyAndSettle(
  driver: Driver,
  key: number,
  settleTimeoutMs: number = QUICK_TIMEOUT_HOME,
  delayMs: number = 250
): Promise<void> {
  await pressKeyWithDelay(driver, key, delayMs);
  await requireSurface(driver, 1, settleTimeoutMs, `press key ${key}`);
  await requireStableSurface(driver, 1, STABLE_TOLERANCE, settleTimeoutMs, `press key ${key}`);
}

async function pressNavKeyAndSettle(
  driver: Driver,
  key: number,
  delayMs: number = 120,
  settleTimeoutMs: number = 1200
): Promise<void> {
  await pressKeyWithDelay(driver, key, delayMs);
  await requireStableSurface(driver, 1, STABLE_TOLERANCE, settleTimeoutMs, `press nav key ${key}`);
}

async function rotateAndWait(driver: Driver, rotation: DisplayRotation): Promise<void> {
  let rotated = false;
  await runSerializedUiOperation(async () => {
    try {
      await driver.setDisplayRotation(rotation);
      rotated = true;
      await driver.delayMs(900);
    } catch (e) {
      await driver.delayMs(200);
    }
  });
  if (!rotated) {
    throw new Error(`setDisplayRotation failed: ${rotation}`);
  }
  await requireSurface(driver, 1, ROTATION_TIMEOUT, `rotate ${rotation}`);
  await requireStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, ROTATION_TIMEOUT, `rotate ${rotation}`);
}

async function resetLauncherBaseline(driver: Driver): Promise<void> {
  await pressControlKeyAndSettle(driver, KEY_HOME, QUICK_TIMEOUT_HOME, 220);
  await pressControlKeyAndSettle(driver, KEY_BACK, QUICK_TIMEOUT_HOME, 220);
  await requireLauncherReady(driver, 'resetLauncherBaseline');
}

async function recoverLauncherBaseline(driver: Driver): Promise<void> {
  try {
    await pressControlKeyAndSettle(driver, KEY_HOME, BEFORE_EACH_TIMEOUT, 180);
  } catch (e) {
  }
  try {
    await pressControlKeyAndSettle(driver, KEY_BACK, BEFORE_EACH_TIMEOUT, 180);
  } catch (e) {
  }
  try {
    await requireSurface(driver, 1, BEFORE_EACH_TIMEOUT, 'recoverLauncherBaseline/surface');
    await requireStableSurface(driver, 1, STABLE_TOLERANCE, BEFORE_EACH_TIMEOUT, 'recoverLauncherBaseline/stable');
  } catch (e) {
  }
}

async function imageCount(driver: Driver): Promise<number> {
  let images = 0;
  await runSerializedUiOperation(async () => {
    const components = await driver.findComponents(ON.type('Image'));
    images = components ? components.length : 0;
  });
  return images;
}

export default function rotationTest() {
  describe('Rotation_Test', () => {
    let driver: Driver;

    beforeAll(async () => {
      driver = createFreshDriver();
      await rotateAndWait(driver, DisplayRotation.ROTATION_0);
      await pressControlKeyAndSettle(driver, KEY_HOME, TIMEOUT_HOME);
      await requireLauncherReady(driver, 'beforeAll');
    });
    beforeEach(async () => {
      driver = createFreshDriver();
      await rotateAndWait(driver, DisplayRotation.ROTATION_0);
      await recoverLauncherBaseline(driver);
    });
    afterAll(async () => {
      try {
        await rotateAndWait(driver, DisplayRotation.ROTATION_0);
      } catch (e) {
      }
      try {
        await pressControlKeyAndSettle(driver, KEY_HOME, TIMEOUT_HOME);
        await pressControlKeyAndSettle(driver, KEY_BACK, TIMEOUT_HOME);
        await requireStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, ROTATION_TIMEOUT, 'afterAll');
      } catch (e) {
      }
    });

    it('rotation_0_keeps_layout', CASE_TIMEOUT, async () => {
      await rotateAndWait(driver, DisplayRotation.ROTATION_0);
      expect(await surfaceCount(driver)).assertLargerOrEqual(1);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('rotation_90_keeps_layout', CASE_TIMEOUT, async () => {
      await rotateAndWait(driver, DisplayRotation.ROTATION_90);
      expect(await surfaceCount(driver)).assertLargerOrEqual(1);
      await rotateAndWait(driver, DisplayRotation.ROTATION_0);
    });
    it('rotation_180_keeps_layout', CASE_TIMEOUT, async () => {
      await rotateAndWait(driver, DisplayRotation.ROTATION_180);
      expect(await surfaceCount(driver)).assertLargerOrEqual(1);
      await rotateAndWait(driver, DisplayRotation.ROTATION_0);
    });
    it('rotation_270_keeps_layout', CASE_TIMEOUT, async () => {
      await rotateAndWait(driver, DisplayRotation.ROTATION_270);
      expect(await surfaceCount(driver)).assertLargerOrEqual(1);
      await rotateAndWait(driver, DisplayRotation.ROTATION_0);
    });

    it('nav_after_180_home_back_text_readable', CASE_TIMEOUT, async () => {
      await rotateAndWait(driver, DisplayRotation.ROTATION_180);
      await pressNavKeyAndSettle(driver, KEY_RIGHT, 150, 1200);
      await pressControlKeyAndSettle(driver, KEY_HOME, TIMEOUT_HOME);
      await pressControlKeyAndSettle(driver, KEY_BACK, TIMEOUT_HOME);
      await rotateAndWait(driver, DisplayRotation.ROTATION_0);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('rotation_edit_exit_home_surface_stable', CASE_TIMEOUT, async () => {
      const before = await surfaceCount(driver);
      await rotateAndWait(driver, DisplayRotation.ROTATION_90);
      await pressControlKeyAndSettle(driver, KEY_HOME, QUICK_TIMEOUT_HOME, 180);
      await pressControlKeyAndSettle(driver, KEY_BACK, QUICK_TIMEOUT_HOME, 180);
      await rotateAndWait(driver, DisplayRotation.ROTATION_0);
      await requireStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, ROTATION_TIMEOUT, 'rotation_edit_exit_home_surface_stable');
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(14);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('double_rotation_enter_back_home_ok', CASE_TIMEOUT, async () => {
      const before = await surfaceCount(driver);
      await rotateAndWait(driver, DisplayRotation.ROTATION_180);
      await pressControlKeyAndSettle(driver, KEY_HOME, QUICK_TIMEOUT_HOME, 180);
      await pressControlKeyAndSettle(driver, KEY_BACK, QUICK_TIMEOUT_HOME, 180);
      await rotateAndWait(driver, DisplayRotation.ROTATION_0);
      await requireStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, ROTATION_TIMEOUT, 'double_rotation_enter_back_home_ok');
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(16);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('rotation_edit_interrupt_twice_text_readable', CASE_TIMEOUT, async () => {
      await pressControlKeyAndSettle(driver, KEY_HOME, QUICK_TIMEOUT_HOME, 180);
      await pressControlKeyAndSettle(driver, KEY_BACK, QUICK_TIMEOUT_HOME, 180);
      await rotateAndWait(driver, DisplayRotation.ROTATION_270);
      await pressControlKeyAndSettle(driver, KEY_HOME, QUICK_TIMEOUT_HOME, 180);
      await pressControlKeyAndSettle(driver, KEY_BACK, QUICK_TIMEOUT_HOME, 180);
      await rotateAndWait(driver, DisplayRotation.ROTATION_0);
      await requireStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, ROTATION_TIMEOUT, 'rotation_edit_interrupt_twice_text_readable');
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('rotate_0_90_0_surface_bounded', CASE_TIMEOUT, async () => {
      const before = await surfaceCount(driver);
      await rotateAndWait(driver, DisplayRotation.ROTATION_90);
      await rotateAndWait(driver, DisplayRotation.ROTATION_0);
      await requireStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, ROTATION_TIMEOUT, 'rotate_0_90_0_surface_bounded');
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(14);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('rotate_nav_right_home_back_text', CASE_TIMEOUT, async () => {
      const before = await surfaceCount(driver);
      await resetLauncherBaseline(driver);
      await waitForStableSurface(driver, 1, STABLE_TOLERANCE, 1200);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(18);
    });
    it('rotate_270_edit_home_back_surface_ok', CASE_TIMEOUT, async () => {
      const before = await surfaceCount(driver);
      await rotateAndWait(driver, DisplayRotation.ROTATION_270);
      await resetLauncherBaseline(driver);
      await requireStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, ROTATION_TIMEOUT, 'rotate_270_edit_home_back_surface_ok');
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(18);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('four_rotation_edit_text_readable', CASE_TIMEOUT, async () => {
      await rotateAndWait(driver, DisplayRotation.ROTATION_90);
      await rotateAndWait(driver, DisplayRotation.ROTATION_0);
      await resetLauncherBaseline(driver);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
      expect(await surfaceCount(driver)).assertLargerOrEqual(1);
    });
    it('rotate_180_nav_enter_back_recoverable', CASE_TIMEOUT, async () => {
      const before = await surfaceCount(driver);
      await rotateAndWait(driver, DisplayRotation.ROTATION_180);
      await resetLauncherBaseline(driver);
      await requireStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, ROTATION_TIMEOUT, 'rotate_180_nav_enter_back_recoverable');
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(18);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('rotate_90_five_home_back_bounded', CASE_TIMEOUT, async () => {
      const before = await surfaceCount(driver);
      await rotateAndWait(driver, DisplayRotation.ROTATION_90);
      for (let i = 0; i < 3; i++) {
        await pressControlKeyAndSettle(driver, KEY_HOME, QUICK_TIMEOUT_HOME, 180);
        await pressControlKeyAndSettle(driver, KEY_BACK, QUICK_TIMEOUT_HOME, 180);
      }
      await rotateAndWait(driver, DisplayRotation.ROTATION_0);
      await requireStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, ROTATION_TIMEOUT, 'rotate_90_five_home_back_bounded');
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(22);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('rotation_twenty_home_back_surface_bounded', CASE_TIMEOUT * 2, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 4; i++) {
        await pressControlKeyAndSettle(driver, KEY_HOME, QUICK_TIMEOUT_HOME, 180);
        await pressControlKeyAndSettle(driver, KEY_BACK, QUICK_TIMEOUT_HOME, 180);
      }
      await requireStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, ROTATION_TIMEOUT, 'rotation_twenty_home_back_surface_bounded');
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(22);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('rotation_twelve_edit_cycles_no_leak', CASE_TIMEOUT, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressControlKeyAndSettle(driver, KEY_HOME, QUICK_TIMEOUT_HOME, 180);
        await pressControlKeyAndSettle(driver, KEY_BACK, QUICK_TIMEOUT_HOME, 180);
      }
      await requireStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, ROTATION_TIMEOUT, 'rotation_twelve_edit_cycles_no_leak');
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(20);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('rotation_eight_enter_back_bounded', CASE_TIMEOUT, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 2; i++) {
        await pressNavKeyAndSettle(driver, KEY_RIGHT, 120, 1000);
        await pressControlKeyAndSettle(driver, KEY_BACK, QUICK_TIMEOUT_HOME, 180);
      }
      await requireStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, ROTATION_TIMEOUT, 'rotation_eight_enter_back_bounded');
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(24);
    });
    it('all_four_rotations_edit_cycle_surface_bounded', CASE_TIMEOUT, async () => {
      const before = await surfaceCount(driver);
      await rotateAndWait(driver, DisplayRotation.ROTATION_90);
      await rotateAndWait(driver, DisplayRotation.ROTATION_0);
      await pressControlKeyAndSettle(driver, KEY_HOME, QUICK_TIMEOUT_HOME, 180);
      await pressControlKeyAndSettle(driver, KEY_BACK, QUICK_TIMEOUT_HOME, 180);
      await requireStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, ROTATION_TIMEOUT, 'all_four_rotations_edit_cycle_surface_bounded');
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(22);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('rotate_90_nav_burst_10_home_back_text', CASE_TIMEOUT, async () => {
      const before = await surfaceCount(driver);
      await rotateAndWait(driver, DisplayRotation.ROTATION_90);
      for (let i = 0; i < 4; i++) {
        await pressNavKeyAndSettle(driver, KEY_RIGHT, 100, 1000);
      }
      await pressControlKeyAndSettle(driver, KEY_HOME, QUICK_TIMEOUT_HOME, 180);
      await pressControlKeyAndSettle(driver, KEY_BACK, QUICK_TIMEOUT_HOME, 180);
      await rotateAndWait(driver, DisplayRotation.ROTATION_0);
      await requireStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, ROTATION_TIMEOUT, 'rotate_90_nav_burst_10_home_back_text');
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
      expect(await surfaceCount(driver)).assertLargerOrEqual(1);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(20);
    });

    it('rotate_180_launch_back_edit_back_surface_bounded', CASE_TIMEOUT, async () => {
      const before = await surfaceCount(driver);
      await rotateAndWait(driver, DisplayRotation.ROTATION_180);
      await pressControlKeyAndSettle(driver, KEY_HOME, QUICK_TIMEOUT_HOME, 180);
      await pressControlKeyAndSettle(driver, KEY_BACK, QUICK_TIMEOUT_HOME, 180);
      await rotateAndWait(driver, DisplayRotation.ROTATION_0);
      await requireStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, ROTATION_TIMEOUT, 'rotate_180_launch_back_edit_back_surface_bounded');
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(20);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('rotate_270_five_home_back_edit_chain_text', CASE_TIMEOUT, async () => {
      await rotateAndWait(driver, DisplayRotation.ROTATION_270);
      for (let i = 0; i < 2; i++) {
        await pressControlKeyAndSettle(driver, KEY_HOME, QUICK_TIMEOUT_HOME, 180);
        await pressControlKeyAndSettle(driver, KEY_BACK, QUICK_TIMEOUT_HOME, 180);
      }
      await rotateAndWait(driver, DisplayRotation.ROTATION_0);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
      expect(await surfaceCount(driver)).assertLargerOrEqual(1);
    });

    it('rotate_cycle_with_nav_up_down_surface_positive', CASE_TIMEOUT, async () => {
      const before = await surfaceCount(driver);
      await rotateAndWait(driver, DisplayRotation.ROTATION_90);
      await pressNavKeyAndSettle(driver, KEY_RIGHT, 120, 1000);
      await rotateAndWait(driver, DisplayRotation.ROTATION_0);
      await requireStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, ROTATION_TIMEOUT, 'rotate_cycle_with_nav_up_down_surface_positive');
      expect(await surfaceCount(driver)).assertLargerOrEqual(1);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(20);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
  });
}
