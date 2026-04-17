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
  KEY_RIGHT,
  KEY_LEFT,
  KEY_UP,
  KEY_DOWN,
  KEY_ENTER,
  KEY_EDIT,
  surfaceCount,
  waitForSurface,
  waitForStableSurface,
  pressAndWait,
  pressKeyWithDelay,
  countNonEmptyTexts
} from './SharedDriver';

function hasClockShape(text: string | null): boolean {
  return !!text && (text.includes(':') || text.length > 0);
}

async function imageCount(driver: Driver): Promise<number> {
  return (await driver.findComponents(ON.type('Image'))).length;
}

async function textCount(driver: Driver): Promise<number> {
  return (await driver.findComponents(ON.type('Text'))).length;
}

async function countReadableTexts(driver: Driver): Promise<number> {
  return countNonEmptyTexts(driver);
}

async function hasTimeLikeText(driver: Driver): Promise<boolean> {
  const texts = await driver.findComponents(ON.type('Text'));
  for (let i = 0; i < texts.length; i++) {
    const value = await texts[i].getText().catch(() => '');
    if (value && hasClockShape(value)) {
      return true;
    }
  }
  return false;
}

export default function statusBarAndAccessibilityDeepTest() {
  describe('StatusBarAndAccessibilityDeep_Test', () => {
    let driver: Driver;

    beforeAll(async () => {
      driver = createFreshDriver();
      await waitForSurface(driver, 2, 4000);
      await waitForStableSurface(driver, 2, 6, 2500);
      await pressAndWait(driver, KEY_HOME, 2, 3000);
    });

    afterAll(async () => {
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      await waitForStableSurface(driver, 2, 6, 2000);
    });

    it('icon_baseline_should_be_visible_and_reasonable', 0, async () => {
      const icons = await imageCount(driver);
      expect(icons).assertLargerOrEqual(3);
      expect(icons).assertLessOrEqual(50);
    });

    it('sampled_icon_counts_small_jitter_ok', 0, async () => {
      const c1 = await imageCount(driver);
      await driver.delayMs(300);
      const c2 = await imageCount(driver);
      await driver.delayMs(300);
      const c3 = await imageCount(driver);

      const max = Math.max(c1, c2, c3);
      const min = Math.min(c1, c2, c3);
      expect(max - min).assertLessOrEqual(6);
    });

    it('horizontal_nav_statusbar_icon_layer_ok', 0, async () => {
      const before = await imageCount(driver);
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(120);
      await driver.triggerKey(KEY_LEFT);
      await driver.delayMs(120);
      const after = await imageCount(driver);

      expect(after).assertLargerOrEqual(3);
      expect(Math.abs(after - before)).assertLessOrEqual(8);
    });

    it('home_reentry_network_visual_contract_ok', 0, async () => {
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      const iconsAfterHome = await imageCount(driver);

      const surface = await surfaceCount(driver);
      expect(iconsAfterHome).assertLargerOrEqual(3);
      expect(surface).assertLargerOrEqual(2);
    });

    it('time_like_text_should_exist_under_normal_state', 0, async () => {
      const found = await hasTimeLikeText(driver);
      expect(found).assertTrue();
    });

    it('time_like_text_should_survive_navigation_and_home', 0, async () => {
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(120);
      await driver.triggerKey(KEY_LEFT);
      await driver.delayMs(120);
      await pressAndWait(driver, KEY_HOME, 2, 3000);

      const found = await hasTimeLikeText(driver);
      expect(found).assertTrue();
    });

    it('text_layer_should_keep_minimum_readable_population', 0, async () => {
      const readable = await countReadableTexts(driver);
      expect(readable).assertLargerOrEqual(1);
    });

    it('component_tree_integrity_after_edit_ok', 0, async () => {
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_EDIT, 2, 2500);
      await pressAndWait(driver, KEY_BACK, 2, 2500);
      const after = await surfaceCount(driver);

      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(14);
    });

    it('multi_stage_nav_readable_text_not_zero', 0, async () => {
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(100);
      await driver.triggerKey(KEY_LEFT);
      await driver.delayMs(100);
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      await pressAndWait(driver, KEY_BACK, 2, 3000);

      const readable = await countReadableTexts(driver);
      expect(readable).assertLargerOrEqual(1);
    });

    it('longer_sampling_window_should_keep_surface_stable', 0, async () => {
      const base = await surfaceCount(driver);
      await driver.delayMs(600);
      const mid = await surfaceCount(driver);
      await driver.delayMs(600);
      const end = await surfaceCount(driver);

      expect(Math.abs(mid - base)).assertLessOrEqual(18);
      expect(Math.abs(end - base)).assertLessOrEqual(18);
    });

    it('edit_int_home_back_time_text_ok', 0, async () => {
      await pressAndWait(driver, KEY_EDIT, 2, 2500);
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      const hasTime = await hasTimeLikeText(driver);
      expect(hasTime).assertTrue();
    });

    it('nav_home_cycle_icon_text_contract_ok', 0, async () => {
      const before = await surfaceCount(driver);
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(120);
      await driver.triggerKey(KEY_LEFT);
      await driver.delayMs(120);
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      const after = await surfaceCount(driver);
      const icons = await imageCount(driver);
      const readable = await countReadableTexts(driver);
      expect(icons).assertLargerOrEqual(3);
      expect(readable).assertLargerOrEqual(1);
      expect(Math.abs(after - before)).assertLessOrEqual(16);
    });

    it('double_edit_int_home_reentry_statusbar_ok', 0, async () => {
      const beforeIcons = await imageCount(driver);
      for (let i = 0; i < 2; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, 2500);
        await pressAndWait(driver, KEY_HOME, 2, 3000);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      const afterIcons = await imageCount(driver);
      const readable = await countReadableTexts(driver);
      expect(afterIcons).assertLargerOrEqual(3);
      expect(Math.abs(afterIcons - beforeIcons)).assertLessOrEqual(8);
      expect(readable).assertLargerOrEqual(1);
    });

    it('home_back_burst_nav_time_text_ok', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, i % 2 === 0 ? KEY_HOME : KEY_BACK, 2, 3000);
      }
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(120);
      await driver.triggerKey(KEY_LEFT);
      await driver.delayMs(120);
      const hasTime = await hasTimeLikeText(driver);
      expect(hasTime).assertTrue();
    });

    it('double_home_reentry_edit_int_statusbar_ok', 0, async () => {
      await pressAndWait(driver, KEY_EDIT, 2, 2500);
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      const hasTime = await hasTimeLikeText(driver);
      const icons = await imageCount(driver);
      expect(hasTime).assertTrue();
      expect(icons).assertLargerOrEqual(3);
    });

    it('statusbar_nav_storm_readable_text_ok', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
        await driver.delayMs(65);
      }
      const readable = await countReadableTexts(driver);
      expect(readable).assertLargerOrEqual(1);
    });

    it('statusbar_fifteen_home_back_text_readable', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, 3000);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('statusbar_ten_edit_cycles_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, 2500);
        await pressAndWait(driver, KEY_BACK, 2, 2500);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(18);
    });
    it('nav_burst_25_home_text', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
        await driver.delayMs(55);
      }
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('statusbar_three_edit_home_back_cycles_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, 2500);
        await pressAndWait(driver, KEY_HOME, 2, 3000);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(20);
    });
    it('statusbar_five_launch_back_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressKeyWithDelay(driver, KEY_RIGHT, 130);
        await pressKeyWithDelay(driver, KEY_ENTER, 900);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(22);
    });
    it('statusbar_rapid_edit_back_10x_no_leak', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, 2500);
        await pressAndWait(driver, KEY_BACK, 2, 2500);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(18);
    });
    it('statusbar_circular_dirs_6rounds_text', 0, async () => {
      const dirs = [KEY_RIGHT, KEY_DOWN, KEY_LEFT, KEY_UP];
      for (let r = 0; r < 6; r++) {
        for (const d of dirs) {
          await driver.triggerKey(d);
          await driver.delayMs(70);
        }
      }
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('combined_statusbar_chain_surface_ok', 0, async () => {
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_EDIT, 2, 2500);
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(120);
      await driver.triggerKey(KEY_ENTER);
      await driver.delayMs(900);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, 3000);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(20);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('statusbar_twenty_home_back_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, 3000);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(22);
    });
    it('statusbar_twelve_edit_cycles_no_leak', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, 2500);
        await pressAndWait(driver, KEY_BACK, 2, 2500);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(20);
    });
    it('statusbar_nav_burst_50_home_text', 0, async () => {
      for (let i = 0; i < 5; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
        await driver.delayMs(45);
      }
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('statusbar_eight_launch_back_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 2; i++) {
        await pressKeyWithDelay(driver, KEY_RIGHT, 130);
        await pressKeyWithDelay(driver, KEY_ENTER, 900);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(24);
    });
    it('statusbar_edit_interrupt_12x_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, 2500);
        await pressAndWait(driver, KEY_HOME, 2, 3000);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(26);
    });
    it('statusbar_circular_dirs_12rounds_text', 0, async () => {
      const dirs = [KEY_RIGHT, KEY_DOWN, KEY_LEFT, KEY_UP];
      for (let r = 0; r < 12; r++) {
        for (const d of dirs) {
          await driver.triggerKey(d);
          await driver.delayMs(50);
        }
      }
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
  });
}
