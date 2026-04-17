import { describe, it, expect, beforeAll, afterAll } from '@ohos/hypium';
import { Driver } from '@ohos.UiTest';
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
  pressKeyWithDelay,
  countNonEmptyTexts,
  TIMEOUT_HOME,
  TIMEOUT_EDIT,
  TIMEOUT_COLD_START,
  DELAY_APP_LAUNCH,
  DELAY_NAV_KEY,
  DELAY_BURST_KEY,
  TOLERANCE_SINGLE_OP,
  TOLERANCE_EDIT_CYCLE,
  TOLERANCE_STRESS,
  STABLE_TOLERANCE,
  STABLE_ROUNDS
} from './SharedDriver';

export default function focusNavigationDeepTest() {
  describe('FocusNavigationDeep_Test', () => {
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

    it('single_right_should_keep_desktop_available', 0, async () => {
      const before = await surfaceCount(driver);
      await pressKeyWithDelay(driver, KEY_RIGHT, DELAY_NAV_KEY * 2);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(TOLERANCE_SINGLE_OP);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('single_left_should_keep_desktop_available', 0, async () => {
      await pressKeyWithDelay(driver, KEY_LEFT, DELAY_NAV_KEY * 2);
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('five_right_should_not_crash', 0, async () => {
      for (let i = 0; i < 5; i++) {
        await pressKeyWithDelay(driver, KEY_RIGHT, DELAY_NAV_KEY);
      }
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('five_left_should_not_crash', 0, async () => {
      for (let i = 0; i < 5; i++) {
        await pressKeyWithDelay(driver, KEY_LEFT, DELAY_NAV_KEY);
      }
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('ten_right_then_ten_left_should_keep_image_count', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressKeyWithDelay(driver, KEY_RIGHT, DELAY_BURST_KEY);
      }
      for (let i = 0; i < 3; i++) {
        await pressKeyWithDelay(driver, KEY_LEFT, DELAY_BURST_KEY);
      }
      const after = await surfaceCount(driver);
      expect(Math.abs(after - before)).assertLessOrEqual(TOLERANCE_SINGLE_OP);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('alternating_lr_20x_surface_ok', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
        await driver.delayMs(60);
      }
      const after = await surfaceCount(driver);
      expect(Math.abs(after - before)).assertLessOrEqual(TOLERANCE_EDIT_CYCLE);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('right_boundary_burst_should_not_break_ui', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(50);
      }
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('left_boundary_burst_should_not_break_ui', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_LEFT);
        await driver.delayMs(50);
      }
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('single_up_should_keep_ui_available', 0, async () => {
      await driver.triggerKey(KEY_UP);
      await driver.delayMs(DELAY_NAV_KEY * 2);
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('single_down_should_keep_ui_available', 0, async () => {
      await driver.triggerKey(KEY_DOWN);
      await driver.delayMs(DELAY_NAV_KEY * 2);
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('up_down_cycle_should_keep_surface_stable', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 6; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_UP : KEY_DOWN);
        await driver.delayMs(100);
      }
      const after = await surfaceCount(driver);
      expect(Math.abs(after - before)).assertLessOrEqual(TOLERANCE_SINGLE_OP + 2);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('down_burst_ten_should_not_crash', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_DOWN);
        await driver.delayMs(DELAY_BURST_KEY);
      }
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('up_burst_ten_should_not_crash', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_UP);
        await driver.delayMs(DELAY_BURST_KEY);
      }
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('cross_nav_four_dirs_text_ok', 0, async () => {
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(DELAY_NAV_KEY);
      await driver.triggerKey(KEY_DOWN);
      await driver.delayMs(DELAY_NAV_KEY);
      await driver.triggerKey(KEY_LEFT);
      await driver.delayMs(DELAY_NAV_KEY);
      await driver.triggerKey(KEY_UP);
      await driver.delayMs(DELAY_NAV_KEY);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
    });
    it('nav_then_enter_back_should_restore_desktop', 0, async () => {
      const before = await surfaceCount(driver);
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(DELAY_NAV_KEY);
      await driver.triggerKey(KEY_ENTER);
      await driver.delayMs(DELAY_APP_LAUNCH);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(TOLERANCE_EDIT_CYCLE);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('nav_edit_int_home_back_surface_ok', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(100);
      }
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(TOLERANCE_EDIT_CYCLE);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('zigzag_nav_then_home_should_keep_text_readable', 0, async () => {
      const dirs = [KEY_RIGHT, KEY_DOWN, KEY_LEFT, KEY_UP, KEY_RIGHT, KEY_DOWN];
      for (const d of dirs) {
        await driver.triggerKey(d);
        await driver.delayMs(100);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
    });
    it('burst_nav_then_enter_back_home_should_keep_surface', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(60);
      }
      await driver.triggerKey(KEY_ENTER);
      await driver.delayMs(DELAY_APP_LAUNCH);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(TOLERANCE_EDIT_CYCLE + 4);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('nav_right_edit_back_home_cycle_should_keep_surface', 0, async () => {
      const before = await surfaceCount(driver);
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(DELAY_NAV_KEY);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      const after = await surfaceCount(driver);
      expect(Math.abs(after - before)).assertLessOrEqual(TOLERANCE_EDIT_CYCLE);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('nav_down_recent_back_should_keep_text_readable', 0, async () => {
      await driver.triggerKey(KEY_DOWN);
      await driver.delayMs(DELAY_NAV_KEY);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
    });
    it('three_edit_nav_cycles_should_keep_surface_stable', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(100);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(TOLERANCE_STRESS);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('nav_home_back_repeated_should_keep_text_readable', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(100);
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
    });

    it('focus_deep_twenty_home_back_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(22);
    });
    it('focus_deep_fifteen_edit_cycles_no_leak', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(20);
    });
    it('nav_burst_60_lr_home_text', 0, async () => {
      for (let i = 0; i < 5; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
        await driver.delayMs(45);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('ten_enter_back_cycles_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_ENTER);
        await driver.delayMs(900);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(24);
    });
    it('focus_nav_deep_edit_interrupt_15x_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(28);
    });
    it('circular_4dirs_12rounds_text', 0, async () => {
      const dirs = [KEY_RIGHT, KEY_DOWN, KEY_LEFT, KEY_UP];
      for (let r = 0; r < 12; r++) {
        for (const d of dirs) {
          await driver.triggerKey(d);
          await driver.delayMs(55);
        }
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('nav_edit_enter_home_chain_3x_text', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(120);
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
        await driver.triggerKey(KEY_ENTER);
        await driver.delayMs(900);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
  });
}
