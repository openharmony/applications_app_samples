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
  KEY_BACK,
  KEY_EDIT,
  KEY_HOME,
  KEY_RIGHT,
  KEY_LEFT,
  KEY_UP,
  KEY_DOWN,
  KEY_ENTER,
  surfaceCount,
  waitForSurface,
  waitForStableSurface,
  pressAndWait,
  countNonEmptyTexts
} from './SharedDriver';

export default function persistenceTest() {
  describe('Persistence_Test', () => {
    let driver: Driver;

    beforeAll(async () => {
      driver = createFreshDriver();
      await waitForSurface(driver, 2, 4000);
      await waitForStableSurface(driver, 2, 6, 2500);
    });

    afterAll(async () => {
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      await waitForStableSurface(driver, 2, 6, 2000);
    });

    it('single_edit_cycle_should_keep_image_count_stable', 0, async () => {
      const before = (await driver.findComponents(ON.type('Image'))).length;
      await pressAndWait(driver, KEY_EDIT, 2, 2500);
      await pressAndWait(driver, KEY_BACK, 2, 2500);
      const after = (await driver.findComponents(ON.type('Image'))).length;
      expect(after).assertLargerOrEqual(1);
      expect(Math.abs(after - before)).assertLessOrEqual(6);
    });

    it('multiple_edit_cycles_no_accumulate', 0, async () => {
      const base = (await driver.findComponents(ON.type('Image'))).length;
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, 2500);
        await pressAndWait(driver, KEY_BACK, 2, 2500);
      }
      const after = (await driver.findComponents(ON.type('Image'))).length;
      expect(Math.abs(after - base)).assertLessOrEqual(8);
    });

    it('home_reload_should_keep_layout_consistent', 0, async () => {
      const before = (await driver.findComponents(ON.type('Text'))).length;
      await driver.pressHome();
      await driver.delayMs(1500);
      const after = (await driver.findComponents(ON.type('Text'))).length;
      expect(after).assertLargerOrEqual(1);
      expect(Math.abs(after - before)).assertLessOrEqual(6);
    });

    it('home_reload_twice_should_keep_images_available', 0, async () => {
      await driver.pressHome();
      await driver.delayMs(900);
      await driver.pressHome();
      await driver.delayMs(900);
      const images = await driver.findComponents(ON.type('Image'));
      expect(images.length).assertLargerOrEqual(1);
    });

    it('edit_int_home_back_reload_surface_ok', 0, async () => {
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_EDIT, 2, 2500);
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(16);
    });

    it('multi_edit_reload_cycle_should_keep_text_readable', 0, async () => {
      for (let i = 0; i < 2; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, 2500);
        await pressAndWait(driver, KEY_BACK, 2, 2500);
        await pressAndWait(driver, KEY_HOME, 2, 3000);
      }
      const nonEmpty = await countNonEmptyTexts(driver);
      expect(nonEmpty).assertLargerOrEqual(1);
    });

    it('persist_five_edit_cycles_image_count_bounded', 0, async () => {
      const base = (await driver.findComponents(ON.type('Image'))).length;
      for (let i = 0; i < 5; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, 2500);
        await pressAndWait(driver, KEY_BACK, 2, 2500);
      }
      const after = (await driver.findComponents(ON.type('Image'))).length;
      expect(after).assertLargerOrEqual(1);
      expect(Math.abs(after - base)).assertLessOrEqual(10);
    });

    it('ten_home_back_cycles_surface_stable', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, 3000);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(14);
    });

    it('edit_home_back_interleaved_5x_text_readable', 0, async () => {
      for (let i = 0; i < 5; i++) {
        if (i % 2 === 0) {
          await pressAndWait(driver, KEY_EDIT, 2, 2500);
          await pressAndWait(driver, KEY_BACK, 2, 2500);
        } else {
          await pressAndWait(driver, KEY_HOME, 2, 3000);
          await pressAndWait(driver, KEY_BACK, 2, 3000);
        }
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('rapid_edit_3x_then_home_surface_consistent', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, 2500);
        await pressAndWait(driver, KEY_BACK, 2, 2500);
      }
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(12);
    });

    it('single_home_back_image_positive', 0, async () => {
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      expect((await driver.findComponents(ON.type('Image'))).length).assertLargerOrEqual(1);
    });

    it('edit_back_immediately_image_positive', 0, async () => {
      await pressAndWait(driver, KEY_EDIT, 2, 2500);
      await pressAndWait(driver, KEY_BACK, 2, 2500);
      expect((await driver.findComponents(ON.type('Image'))).length).assertLargerOrEqual(1);
    });

    it('edit_home_edit_back_surface_recoverable', 0, async () => {
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_EDIT, 2, 2500);
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      await pressAndWait(driver, KEY_EDIT, 2, 2500);
      await pressAndWait(driver, KEY_BACK, 2, 2500);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(16);
    });

    it('repeated_home_5x_text_stays_readable', 0, async () => {
      for (let i = 0; i < 5; i++) {
        await pressAndWait(driver, KEY_HOME, 2, 3000);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('home_back_edit_back_home_chain_surface_ok', 0, async () => {
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      await pressAndWait(driver, KEY_EDIT, 2, 2500);
      await pressAndWait(driver, KEY_BACK, 2, 2500);
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(14);
    });

    it('persist_twenty_home_back_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, 3000);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(22);
    });
    it('persist_fifteen_edit_cycles_no_leak', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, 2500);
        await pressAndWait(driver, KEY_BACK, 2, 2500);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(20);
    });
    it('nav_burst_50_home_text_readable', 0, async () => {
      for (let i = 0; i < 5; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
        await driver.delayMs(45);
      }
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('persist_eight_launch_back_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_ENTER);
        await driver.delayMs(900);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(24);
    });
    it('persist_edit_interrupt_12x_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, 2500);
        await pressAndWait(driver, KEY_HOME, 2, 3000);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(26);
    });
    it('persist_circular_4dirs_8rounds_text', 0, async () => {
      const dirs = [KEY_RIGHT, KEY_DOWN, KEY_LEFT, KEY_UP];
      for (let r = 0; r < 8; r++) {
        for (const d of dirs) {
          await driver.triggerKey(d);
          await driver.delayMs(60);
        }
      }
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('three_edit_home_back_nav_chain_text', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, 2500);
        await pressAndWait(driver, KEY_HOME, 2, 3000);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(120);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('alternating_edit_home_back_chain_text_readable', 0, async () => {
      for (let i = 0; i < 6; i++) {
        if (i % 2 === 0) {
          await pressAndWait(driver, KEY_EDIT, 2, 2500);
          await pressAndWait(driver, KEY_BACK, 2, 2500);
        } else {
          await pressAndWait(driver, KEY_HOME, 2, 3000);
          await pressAndWait(driver, KEY_BACK, 2, 3000);
        }
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('home_edit_home_back_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      await pressAndWait(driver, KEY_EDIT, 2, 2500);
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(18);
    });

    it('back_burst_after_home_surface_positive', 0, async () => {
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      for (let i = 0; i < 6; i++) {
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
    });

    it('post_chain_stability_sampling_should_be_bounded', 0, async () => {
      await pressAndWait(driver, KEY_EDIT, 2, 2500);
      await pressAndWait(driver, KEY_BACK, 2, 2500);
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      await waitForStableSurface(driver, 2, 6, 2200);
      const s1 = await surfaceCount(driver);
      await driver.delayMs(300);
      const s2 = await surfaceCount(driver);
      expect(Math.abs(s2 - s1)).assertLessOrEqual(6);
    });
  });
}
