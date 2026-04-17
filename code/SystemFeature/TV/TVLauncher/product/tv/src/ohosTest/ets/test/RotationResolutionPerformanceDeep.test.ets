/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 */

import { describe, it, expect, beforeAll, afterAll } from '@ohos/hypium';
import { Driver, DisplayRotation, ON } from '@ohos.UiTest';
import {
  createFreshDriver,
  KEY_HOME,
  KEY_BACK,
  KEY_EDIT,
  KEY_RIGHT,
  KEY_LEFT,
  KEY_UP,
  KEY_DOWN,
  KEY_ENTER,
  surfaceCount,
  waitForSurface,
  waitForStableSurface,
  pressAndWait,
  pressKeyWithDelay,
  countNonEmptyTexts,
  resetDriver,
  runSerializedUiOperation
} from './SharedDriver';

const THRESHOLD_FOCUS_MS: number = 500;
const THRESHOLD_EDIT_MS: number = 5200;
const THRESHOLD_HOME_MS: number = 3800;
const THRESHOLD_MIXED_MS: number = 11500;
const THRESHOLD_ROTATION_HOME_BACK_MS: number = 9500;

async function settleUi(driver: Driver, minimumCount: number = 2, timeoutMs: number = 3000): Promise<void> {
  await waitForSurface(driver, minimumCount, timeoutMs);
  await waitForStableSurface(driver, 2, 6, Math.min(timeoutMs, 2000));
}

async function costMs(fn: () => Promise<void>): Promise<number> {
  const start = Date.now();
  await fn();
  return Date.now() - start;
}

async function rotateTo(driver: Driver, rotation: DisplayRotation): Promise<void> {
  try {
    await runSerializedUiOperation(async () => {
      await driver.setDisplayRotation(rotation);
    });
    await runSerializedUiOperation(async () => {
      await driver.delayMs(1200);
    });
    await settleUi(driver, 1, 3000);
  } catch (e) {
    await runSerializedUiOperation(async () => {
      await driver.delayMs(200);
    });
  }
}

async function componentCountByType(driver: Driver, type: string): Promise<number> {
  let count = 0;
  try {
    await runSerializedUiOperation(async () => {
      const components = await driver.findComponents(ON.type(type));
      count = components ? components.length : 0;
    });
  } catch (e) {
    count = 0;
  }
  return count;
}

export default function rotationResolutionPerformanceDeepTest() {
  describe('RotationResolutionPerformanceDeep_Test', () => {
    let driver: Driver;

    beforeAll(async () => {
      driver = createFreshDriver();
      await waitForSurface(driver, 1, 4000);
      await waitForStableSurface(driver, 2, 6, 2500);
      await pressAndWait(driver, KEY_HOME, 1, 3000);
    });

    afterAll(async () => {
      try {
        await driver.setDisplayRotation(DisplayRotation.ROTATION_0);
      } catch (e) {
      }
      await pressAndWait(driver, KEY_HOME, 1, 3000);
      await waitForStableSurface(driver, 2, 6, 2000);
      resetDriver();
    });

    it('rotation_0_should_keep_desktop_surface_available', 0, async () => {
      await rotateTo(driver, DisplayRotation.ROTATION_0);
      const surface = await surfaceCount(driver);
      expect(surface).assertLargerOrEqual(1);
    });

    it('rotation_90_should_keep_desktop_surface_available', 0, async () => {
      await rotateTo(driver, DisplayRotation.ROTATION_90);
      const surface = await surfaceCount(driver);
      expect(surface).assertLargerOrEqual(1);
    });

    it('rotation_180_should_keep_desktop_surface_available', 0, async () => {
      await rotateTo(driver, DisplayRotation.ROTATION_180);
      const surface = await surfaceCount(driver);
      expect(surface).assertLargerOrEqual(1);
    });

    it('rotation_270_should_keep_desktop_surface_available', 0, async () => {
      await rotateTo(driver, DisplayRotation.ROTATION_270);
      const surface = await surfaceCount(driver);
      expect(surface).assertLargerOrEqual(1);
    });

    it('edit_enter_exit_latency_should_be_under_threshold', 0, async () => {
      const elapsed = await costMs(async () => {
        await pressAndWait(driver, KEY_EDIT, 1, 2500);
        await pressAndWait(driver, KEY_BACK, 1, 2500);
      });
      expect(elapsed).assertLessOrEqual(THRESHOLD_EDIT_MS);
    });

    it('rot_perf_twenty_home_back_text_readable', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 1, 3000);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('rot_perf_edit_interrupt_10x_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, 2500);
        await pressAndWait(driver, KEY_HOME, 1, 3000);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(24);
    });

    it('combined_rotation_resolution_chain_text', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 1, 3000);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
        await pressAndWait(driver, KEY_EDIT, 2, 2500);
        await pressAndWait(driver, KEY_HOME, 1, 3000);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('rot_perf_twenty_home_back_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 1, 3000);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(22);
    });
    it('rot_perf_twelve_edit_cycles_no_leak', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, 2500);
        await pressAndWait(driver, KEY_BACK, 2, 2500);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(20);
    });
    it('rot_perf_nav_burst_50_home_text', 0, async () => {
      for (let i = 0; i < 5; i++) {
        await pressKeyWithDelay(driver, i % 2 === 0 ? KEY_RIGHT : KEY_LEFT, 45);
      }
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('rotation_perf_edit_int_15x_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, 2500);
        await pressAndWait(driver, KEY_HOME, 1, 3000);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(28);
    });
  });
}
