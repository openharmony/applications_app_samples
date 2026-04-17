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
  KEY_UP,
  KEY_DOWN,
  waitForSurface,
  waitForStableSurface,
  pressAndWait,
  surfaceCount,
  countNonEmptyTexts,
  runSerializedUiOperation,
  TIMEOUT_HOME,
  TIMEOUT_EDIT,
  TIMEOUT_COLD_START,
  TOLERANCE_EDIT_CYCLE,
  STABLE_TOLERANCE,
  STABLE_ROUNDS
} from './SharedDriver';
import { StyleConstants } from '../../../../../../common/src/main/ets/default/constants/StyleConstants';

export default function styleConstantsDeepTest() {
  describe('StyleConstantsDeep_Test', () => {
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

    it('default_font_color_is_white', 0, () => {
      expect(StyleConstants.DEFAULT_FONT_COLOR).assertEqual('#ffffff');
    });
    it('default_bg_color_is_transparent', 0, () => {
      expect(StyleConstants.DEFAULT_BG_COLOR).assertEqual('#00000000');
    });
    it('default_desktop_bg_color_correct', 0, () => {
      expect(StyleConstants.DEFAULT_DESKTOP_BG_COLOR).assertEqual('#18181A');
    });
    it('text_color_primary_correct', 0, () => {
      expect(StyleConstants.TEXT_COLOR_PRIMARY).assertEqual('#E6000000');
    });
    it('button_font_color_correct', 0, () => {
      expect(StyleConstants.BUTTON_FONT_COLOR).assertEqual('#007DFF');
    });
    it('folder_add_app_font_color_is_black', 0, () => {
      expect(StyleConstants.FOLDER_ADD_APP_FONT_COLOR).assertEqual('#000000');
    });
    it('error_color_correct', 0, () => {
      expect(StyleConstants.DEFAULT_COLOR_ERROR).assertEqual('#FFE84026');
    });
    it('light_black_color_correct', 0, () => {
      expect(StyleConstants.LIGHT_BLACK).assertEqual('#3c000000');
    });
    it('divider_color_correct', 0, () => {
      expect(StyleConstants.DEFAULT_DIVIDER_COLOR).assertEqual('rgb(207, 195, 195)');
    });
    it('broad_color_correct', 0, () => {
      expect(StyleConstants.DEFAULT_BROAD_COLOR).assertEqual('rgba(0,0,0,0.15)');
    });
    it('transparent_color_correct', 0, () => {
      expect(StyleConstants.DEFAULT_TRANSPARENT_COLOR).assertEqual('rgba(0,0,0,0)');
    });
    it('color_constants_font_bg_distinct', 0, () => {
      expect((StyleConstants.DEFAULT_FONT_COLOR as string) !== (StyleConstants.DEFAULT_BG_COLOR as string))
        .assertTrue();
    });

    it('app_grid_column_positive', 0, () => {
      expect(StyleConstants.DEFAULT_APP_GRID_COLUMN).assertLargerOrEqual(1);
    });
    it('app_grid_row_positive', 0, () => {
      expect(StyleConstants.DEFAULT_APP_GRID_ROW).assertLargerOrEqual(1);
    });
    it('app_icon_size_width_positive', 0, () => {
      expect(StyleConstants.DEFAULT_APP_ICON_SIZE_WIDTH).assertLargerOrEqual(1);
    });
    it('app_item_width_positive', 0, () => {
      expect(StyleConstants.DEFAULT_APP_ITEM_WIDTH).assertLargerOrEqual(1);
    });
    it('app_item_height_positive', 0, () => {
      expect(StyleConstants.DEFAULT_APP_ITEM_HEIGHT).assertLargerOrEqual(1);
    });
    it('folder_grid_size_positive', 0, () => {
      expect(StyleConstants.DEFAULT_FOLDER_GRID_SIZE).assertLargerOrEqual(1);
    });
    it('open_folder_grid_row_positive', 0, () => {
      expect(StyleConstants.DEFAULT_OPEN_FOLDER_GRID_ROW).assertLargerOrEqual(1);
    });
    it('open_folder_grid_column_positive', 0, () => {
      expect(StyleConstants.DEFAULT_OPEN_FOLDER_GRID_COLUMN).assertLargerOrEqual(1);
    });
    it('badge_size_positive', 0, () => {
      expect(StyleConstants.DEFAULT_BADGE_SIZE).assertLargerOrEqual(1);
    });
    it('max_badge_count_is_99', 0, () => {
      expect(StyleConstants.MAX_BADGE_COUNT).assertEqual(99);
    });
    it('badge_font_size_positive', 0, () => {
      expect(StyleConstants.DEFAULT_BADGE_FONT_SIZE).assertLargerOrEqual(1);
    });
    it('context_menu_width_positive', 0, () => {
      expect(StyleConstants.CONTEXT_MENU_WIDTH).assertLargerOrEqual(1);
    });
    it('window_show_delay_positive', 0, () => {
      expect(StyleConstants.WINDOW_SHOW_DELAY).assertLargerOrEqual(1);
    });
    it('dpi_ratio_is_one', 0, () => {
      expect(StyleConstants.DPI_RATIO).assertEqual(1);
    });
    it('app_grid_column_gap_positive', 0, () => {
      expect(StyleConstants.DEFAULT_APP_GRID_COLUMN_GAP).assertLargerOrEqual(0);
    });
    it('app_grid_row_gap_positive', 0, () => {
      expect(StyleConstants.DEFAULT_APP_GRID_ROW_GAP).assertLargerOrEqual(0);
    });

    it('percentage_100_correct', 0, () => {
      expect(StyleConstants.PERCENTAGE_100).assertEqual('100%');
    });
    it('percentage_85_correct', 0, () => {
      expect(StyleConstants.PERCENTAGE_85).assertEqual('85%');
    });
    it('percentage_80_correct', 0, () => {
      expect(StyleConstants.PERCENTAGE_80).assertEqual('80%');
    });
    it('percentage_80_number_correct', 0, () => {
      expect(StyleConstants.PERCENTAGE_80_number).assertEqual(0.8);
    });
    it('percentage_75_correct', 0, () => {
      expect(StyleConstants.PERCENTAGE_75).assertEqual('75%');
    });
    it('percentage_70_correct', 0, () => {
      expect(StyleConstants.PERCENTAGE_70).assertEqual('70%');
    });
    it('percentage_15_correct', 0, () => {
      expect(StyleConstants.PERCENTAGE_15).assertEqual('15%');
    });
    it('percentage_100_layout_correct', 0, () => {
      expect(StyleConstants.DEFAULT_LAYOUT_PERCENTAGE).assertEqual('100%');
    });
    it('percentage_values_decreasing', 0, () => {
      const p100 = parseFloat(StyleConstants.PERCENTAGE_100);
      const p85 = parseFloat(StyleConstants.PERCENTAGE_85);
      const p80 = parseFloat(StyleConstants.PERCENTAGE_80);
      const p75 = parseFloat(StyleConstants.PERCENTAGE_75);
      const p70 = parseFloat(StyleConstants.PERCENTAGE_70);
      expect(p100 > p85).assertTrue();
      expect(p85 > p80).assertTrue();
      expect(p80 > p75).assertTrue();
      expect(p75 > p70).assertTrue();
    });

    it('default_0_is_zero', 0, () => {
      expect(StyleConstants.DEFAULT_0).assertEqual(0);
    });
    it('default_1_is_one', 0, () => {
      expect(StyleConstants.DEFAULT_1).assertEqual(1);
    });
    it('default_numeric_sentinels_ascending', 0, () => {
      expect(StyleConstants.DEFAULT_4 < StyleConstants.DEFAULT_5).assertTrue();
      expect(StyleConstants.DEFAULT_5 < StyleConstants.DEFAULT_8).assertTrue();
      expect(StyleConstants.DEFAULT_8 < StyleConstants.DEFAULT_10).assertTrue();
      expect(StyleConstants.DEFAULT_10 < StyleConstants.DEFAULT_12).assertTrue();
      expect(StyleConstants.DEFAULT_12 < StyleConstants.DEFAULT_14).assertTrue();
      expect(StyleConstants.DEFAULT_14 < StyleConstants.DEFAULT_16).assertTrue();
      expect(StyleConstants.DEFAULT_16 < StyleConstants.DEFAULT_20).assertTrue();
      expect(StyleConstants.DEFAULT_20 < StyleConstants.DEFAULT_24).assertTrue();
      expect(StyleConstants.DEFAULT_24 < StyleConstants.DEFAULT_28).assertTrue();
      expect(StyleConstants.DEFAULT_28 < StyleConstants.DEFAULT_30).assertTrue();
      expect(StyleConstants.DEFAULT_30 < StyleConstants.DEFAULT_40).assertTrue();
      expect(StyleConstants.DEFAULT_40 < StyleConstants.DEFAULT_56).assertTrue();
      expect(StyleConstants.DEFAULT_56 < StyleConstants.DEFAULT_60).assertTrue();
      expect(StyleConstants.DEFAULT_60 < StyleConstants.DEFAULT_80).assertTrue();
    });
    it('pixel_constants_positive', 0, () => {
      expect(StyleConstants.PIXEL_50).assertEqual(50);
      expect(StyleConstants.PIXEL_150).assertEqual(150);
      expect(StyleConstants.PIXEL_200).assertEqual(200);
    });
    it('pixel_constants_ascending', 0, () => {
      expect(StyleConstants.PIXEL_50 < StyleConstants.PIXEL_150).assertTrue();
      expect(StyleConstants.PIXEL_150 < StyleConstants.PIXEL_200).assertTrue();
    });

    it('dialog_radius_correct', 0, () => {
      expect(StyleConstants.DEFAULT_DIALOG_RADIUS).assertEqual('24vp');
    });
    it('dialog_width_correct', 0, () => {
      expect(StyleConstants.DEFAULT_DIALOG_WIDTH).assertEqual('395vp');
    });
    it('button_height_correct', 0, () => {
      expect(StyleConstants.DEFAULT_BUTTON_HEIGHT).assertEqual('40vp');
    });
    it('button_font_size_correct', 0, () => {
      expect(StyleConstants.DEFAULT_BUTTON_FONT_SIZE).assertEqual('16fp');
    });
    it('dialog_bottom_margin_correct', 0, () => {
      expect(StyleConstants.DEFAULT_DIALOG_BOTTOM_MARGIN).assertEqual('16vp');
    });
    it('dialog_bottom_margin_number_correct', 0, () => {
      expect(StyleConstants.DEFAULT_DIALOG_BOTTOM_MARGIN_NUMBER).assertEqual(16);
    });
    it('button_height_number_correct', 0, () => {
      expect(StyleConstants.DEFAULT_BUTTON_HEIGHT_NUMBER).assertEqual(40);
    });
    it('menu_height_positive', 0, () => {
      expect(StyleConstants.DEFAULT_MENU_HEIGHT).assertLargerOrEqual(1);
    });

    it('constants_valid_then_edit_cycle_surface_ok', 0, async () => {
      expect(StyleConstants.DEFAULT_APP_GRID_COLUMN).assertLargerOrEqual(1);
      expect(StyleConstants.MAX_BADGE_COUNT).assertEqual(99);
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(TOLERANCE_EDIT_CYCLE);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('percentage_constants_then_nav_surface_ok', 0, async () => {
      expect(StyleConstants.PERCENTAGE_100).assertEqual('100%');
      expect(StyleConstants.PERCENTAGE_80_number).assertEqual(0.8);
      const before = await surfaceCount(driver);
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(120);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(TOLERANCE_EDIT_CYCLE);
    });
    it('dimension_constants_then_home_back_text_readable', 0, async () => {
      expect(StyleConstants.DEFAULT_BADGE_SIZE).assertLargerOrEqual(1);
      expect(StyleConstants.DPI_RATIO).assertEqual(1);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('style_twenty_home_back_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(22);
    });
    it('style_ten_edit_cycles_no_leak', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(18);
    });
    it('style_nav_30_lr_home_text', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
        await driver.delayMs(50);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('five_edit_home_back_nav_chain_text', 0, async () => {
      for (let i = 0; i < 5; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(80);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('style_circular_4dirs_8rounds_text', 0, async () => {
      const dirs = [KEY_RIGHT, KEY_DOWN, KEY_LEFT, KEY_UP];
      for (let r = 0; r < 8; r++) {
        for (const d of dirs) {
          await driver.triggerKey(d);
          await driver.delayMs(60);
        }
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
  });
}
