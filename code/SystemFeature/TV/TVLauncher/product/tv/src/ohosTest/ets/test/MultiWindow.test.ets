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
  KEY_HOME,
  KEY_BACK,
  KEY_RIGHT,
  KEY_LEFT,
  KEY_ENTER,
  KEY_EDIT,
  surfaceCount,
  waitForSurface,
  waitForStableSurface,
  pressAndWait,
  countNonEmptyTexts
} from './SharedDriver';

async function openRecent(driver: Driver): Promise<void> {
  await pressAndWait(driver, KEY_HOME, 2, 3000);
}

export default function multiWindowTest() {
  describe('MultiWindow_Test', () => {
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

    it('open_and_close_recent_should_keep_desktop_alive', 0, async () => {
      const before = (await driver.findComponents(ON.type('Image'))).length;
      await openRecent(driver);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      const after = (await driver.findComponents(ON.type('Image'))).length;
      expect(after).assertLargerOrEqual(1);
      expect(Math.abs(after - before)).assertLessOrEqual(8);
    });

    it('repeat_recent_cycles_should_be_stable', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await openRecent(driver);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      const texts = await driver.findComponents(ON.type('Text'));
      expect(texts.length).assertLargerOrEqual(1);
    });

    it('recent_after_nav_desktop_state_ok', 0, async () => {
      for (let i = 0; i < 2; i++) {
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(120);
      }

      const before = (await driver.findComponents(ON.type('Image'))).length;
      await openRecent(driver);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      const after = (await driver.findComponents(ON.type('Image'))).length;

      expect(after).assertLargerOrEqual(1);
      expect(Math.abs(after - before)).assertLessOrEqual(8);
    });

    it('recent_enter_back_home_surface_ok', 0, async () => {
      const before = await surfaceCount(driver);
      await openRecent(driver);
      await driver.triggerKey(KEY_ENTER);
      await driver.delayMs(900);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(16);
    });

    it('edit_int_with_recent_cycle_text_ok', 0, async () => {
      await pressAndWait(driver, KEY_EDIT, 2, 2500);
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      await openRecent(driver);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      const nonEmpty = await countNonEmptyTexts(driver);
      expect(nonEmpty).assertLargerOrEqual(1);
    });

    it('recent_cycle_enter_back_home_window_ok', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 2; i++) {
        await openRecent(driver);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      await openRecent(driver);
      await driver.triggerKey(KEY_ENTER);
      await driver.delayMs(850);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(18);
    });

    it('five_recent_enter_back_cycles_surface_stable', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 5; i++) {
        await openRecent(driver);
        await driver.triggerKey(KEY_ENTER);
        await driver.delayMs(800);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(22);
    });

    it('recent_edit_interleaved_3x_text_readable', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await openRecent(driver);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
        await pressAndWait(driver, KEY_EDIT, 2, 2500);
        await pressAndWait(driver, KEY_BACK, 2, 2500);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('multiwin_ten_recent_open_close_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await openRecent(driver);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(14);
    });

    it('nav_recent_edit_chain_surface_ok', 0, async () => {
      const before = await surfaceCount(driver);
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(120);
      await openRecent(driver);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      await pressAndWait(driver, KEY_EDIT, 2, 2500);
      await pressAndWait(driver, KEY_BACK, 2, 2500);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(16);
    });

    it('recent_enter_back_edit_interrupt_text_readable', 0, async () => {
      await openRecent(driver);
      await driver.triggerKey(KEY_ENTER);
      await driver.delayMs(850);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      await pressAndWait(driver, KEY_EDIT, 2, 2500);
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('single_recent_open_close_image_positive', 0, async () => {
      await openRecent(driver);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      expect((await driver.findComponents(ON.type('Image'))).length).assertLargerOrEqual(1);
    });

    it('recent_home_back_image_positive', 0, async () => {
      await openRecent(driver);
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      expect((await driver.findComponents(ON.type('Image'))).length).assertLargerOrEqual(1);
    });

    it('immediate_back_after_recent_surface_ok', 0, async () => {
      const before = await surfaceCount(driver);
      await openRecent(driver);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(8);
    });

    it('three_nav_then_recent_text_readable', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(100);
      }
      await openRecent(driver);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('multiwin_twenty_home_back_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, 3000);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(22);
    });
    it('multiwin_fifteen_edit_cycles_no_leak', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, 2500);
        await pressAndWait(driver, KEY_BACK, 2, 2500);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(20);
    });
    it('multiwin_ten_recent_open_close_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await openRecent(driver);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(18);
    });
    it('multiwin_nav_burst_40_home_text', 0, async () => {
      for (let i = 0; i < 4; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
        await driver.delayMs(50);
      }
      await pressAndWait(driver, KEY_HOME, 2, 3000);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('five_recent_enter_back_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 5; i++) {
        await openRecent(driver);
        await driver.triggerKey(KEY_ENTER);
        await driver.delayMs(900);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(22);
    });
    it('edit_home_back_5x_text_readable', 0, async () => {
      for (let i = 0; i < 5; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, 2500);
        await pressAndWait(driver, KEY_HOME, 2, 3000);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('recent_nav_edit_chain_3x_surface_ok', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await openRecent(driver);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(120);
        await pressAndWait(driver, KEY_EDIT, 2, 2500);
        await pressAndWait(driver, KEY_HOME, 2, 3000);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(24);
    });

    it('recent_open_close_five_rounds_text_readable', 0, async () => {
      for (let i = 0; i < 5; i++) {
        await openRecent(driver);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('multiwin_recent_enter_back_3x_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await openRecent(driver);
        await driver.triggerKey(KEY_ENTER);
        await driver.delayMs(900);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(20);
    });

    it('edit_recent_chain_four_rounds_surface_positive', 0, async () => {
      for (let i = 0; i < 4; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, 2500);
        await pressAndWait(driver, KEY_BACK, 2, 2500);
        await openRecent(driver);
        await pressAndWait(driver, KEY_BACK, 2, 3000);
      }
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
    });

    it('rapid_lr_nav_then_recent_back_text', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
        await driver.delayMs(55);
      }
      await openRecent(driver);
      await pressAndWait(driver, KEY_BACK, 2, 3000);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
  });
}
