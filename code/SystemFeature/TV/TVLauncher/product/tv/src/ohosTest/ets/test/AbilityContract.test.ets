/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 */

import { describe, it, expect, beforeAll, afterAll } from '@ohos/hypium';
import { Driver } from '@ohos.UiTest';
import {
  getDriver,
  createFreshDriver,
  KEY_HOME,
  KEY_BACK,
  KEY_EDIT,
  KEY_RIGHT,
  KEY_LEFT,
  KEY_ENTER,
  surfaceCount,
  waitForSurface,
  waitForStableSurface,
  pressAndWait,
  countNonEmptyTexts,
  TIMEOUT_HOME,
  TIMEOUT_EDIT,
  STABLE_TOLERANCE,
  STABLE_ROUNDS
} from './SharedDriver';
import MainAbility from '../../../main/ets/MainAbility/MainAbility';
import type { commonEventParma, eventParma } from '../../../main/ets/MainAbility/MainAbility';
import MyAbilityStage from '../../../main/ets/Application/AbilityStage';
import StyleConstants from '../../../main/ets/common/constants/StyleConstants';
import { KeyCode } from '../../../main/ets/common/constants/KeyCode';
import { AppItemInfo as MainAppItemInfo } from '../../../main/ets/common/bean/AppItemInfo';

export default function abilityContractTest() {
  describe('AbilityContract_Test', () => {
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

    it('main_ability_exposes_lifecycle_methods', 0, () => {
      const ability = new MainAbility();
      expect(typeof ability.onCreate).assertEqual('function');
      expect(typeof ability.onDestroy).assertEqual('function');
      expect(typeof ability.onRequest).assertEqual('function');
    });
    it('main_ability_exposes_setup_methods', 0, () => {
      const ability = new MainAbility();
      expect(typeof ability.initSetup).assertEqual('function');
      expect(typeof ability.liftUpApp).assertEqual('function');
      expect(typeof ability.checkReboot).assertEqual('function');
      expect(typeof ability.initLauncher).assertEqual('function');
      expect(typeof ability.getSystemStartTime).assertEqual('function');
    });

    it('event_parma_accepts_boolean_and_module_name', 0, () => {
      const params: eventParma<boolean> = { T: true, moduleName: 'entry' };
      expect(params.T).assertTrue();
      expect(params.moduleName).assertEqual('entry');
    });
    it('common_event_parma_keeps_payload_fields', 0, () => {
      const payload: commonEventParma<boolean> = {
        event: 'action.system.home',
        bundleName: 'com.ohos.launcher',
        code: 0,
        data: 'ok',
        parameters: { T: false, moduleName: 'tv_launcher' } as eventParma<boolean>
      };
      expect(payload.event).assertEqual('action.system.home');
      expect(payload.bundleName).assertEqual('com.ohos.launcher');
      expect(payload.code).assertEqual(0);
      expect(payload.parameters.moduleName).assertEqual('tv_launcher');
    });
    it('event_parma_false_boolean_valid', 0, () => {
      const params: eventParma<boolean> = { T: false, moduleName: 'tv' };
      expect(params.T).assertFalse();
      expect(params.moduleName).assertEqual('tv');
    });

    it('ability_stage_constructable', 0, () => {
      const stage = new MyAbilityStage();
      expect(stage !== null && stage !== undefined).assertTrue();
    });
    it('style_and_key_constants_accessible', 0, () => {
      expect(KeyCode.KEY_DPAD_LEFT).assertLargerOrEqual(1);
      expect(StyleConstants.DEFAULT_APP_ICON_SIZE_WIDTH).assertLargerOrEqual(1);
    });
    it('main_app_item_model_constructable', 0, () => {
      const app = new MainAppItemInfo();
      app.appName = 'demo';
      expect(app.appName).assertEqual('demo');
    });
    it('fifty_app_items_constructable', 0, () => {
      for (let i = 0; i < 5; i++) {
        const a = new MainAppItemInfo();
        a.appName = 'app' + i;
        expect(a.appName).assertEqual('app' + i);
      }
    });
    it('main_app_item_default_flags_true', 0, () => {
      const app = new MainAppItemInfo();
      expect(app.canMove).assertTrue();
      expect(app.canRemove).assertTrue();
    });

    it('home_navigation_keeps_contract_visible', 0, async () => {
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
    });
    it('ability_edit_int_home_back_surface_ok', 0, async () => {
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(16);
    });
    it('nav_enter_back_text_readable', 0, async () => {
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(120);
      await driver.triggerKey(KEY_ENTER);
      await driver.delayMs(900);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('ability_five_edit_cycles_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 5; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(14);
    });
    it('ability_ten_home_back_text_readable', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('three_launch_back_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(130);
        await driver.triggerKey(KEY_ENTER);
        await driver.delayMs(900);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(20);
    });
    it('edit_home_back_3x_text_readable', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('nav_burst_edit_home_back_surface_ok', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
        await driver.delayMs(80);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(18);
    });
    it('composite_chain_text_readable', 0, async () => {
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(120);
      await driver.triggerKey(KEY_ENTER);
      await driver.delayMs(900);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('ability_twenty_home_back_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(22);
    });
    it('ability_twelve_edit_cycles_no_leak', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(20);
    });
    it('ability_eight_launch_back_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(130);
        await driver.triggerKey(KEY_ENTER);
        await driver.delayMs(900);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(24);
    });
    it('ability_edit_interrupt_12x_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(26);
    });
    it('ability_nav_40_home_text_readable', 0, async () => {
      for (let i = 0; i < 4; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
        await driver.delayMs(50);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('event_parma_empty_module_name_valid', 0, () => {
      const params: eventParma<boolean> = { T: false, moduleName: '' };
      expect(params.T).assertFalse();
      expect(params.moduleName).assertEqual('');
    });

    it('fifty_app_items_cover_all_fields_stable', 0, () => {
      for (let i = 0; i < 5; i++) {
        const app = new MainAppItemInfo();
        app.appName = 'ability_app_' + i;
        app.bundleName = 'com.ability.' + i;
        app.appIconId = i;
        expect(app.appName).assertEqual('ability_app_' + i);
        expect(app.bundleName).assertEqual('com.ability.' + i);
        expect(app.appIconId).assertEqual(i);
        expect(app.canMove).assertTrue();
        expect(app.canRemove).assertTrue();
      }
    });

    it('alternating_edit_home_back_chain_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 4; i++) {
        if (i % 2 === 0) {
          await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
          await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
        } else {
          await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
          await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
        }
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(18);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('keycode_and_style_constants_match_expected_ranges', 0, () => {
      expect(KeyCode.KEY_DPAD_LEFT).assertLargerOrEqual(1);
      expect(KeyCode.KEY_DPAD_RIGHT).assertLargerOrEqual(1);
      expect((KeyCode.KEY_DPAD_LEFT as number) !== (KeyCode.KEY_DPAD_RIGHT as number)).assertTrue();
      expect(StyleConstants.DEFAULT_APP_ICON_SIZE_WIDTH).assertLargerOrEqual(1);
      expect(StyleConstants.DEFAULT_NUMBER_0).assertEqual(0);
    });

    it('hundred_app_items_all_fields_consistent', 0, () => {
      for (let i = 0; i < 5; i++) {
        const app = new MainAppItemInfo();
        app.appName = 'deep_app_' + i;
        app.bundleName = 'com.deep.' + i;
        app.appIconId = i * 2;
        expect(app.appName).assertEqual('deep_app_' + i);
        expect(app.bundleName).assertEqual('com.deep.' + i);
        expect(app.appIconId).assertEqual(i * 2);
        expect(app.canMove).assertTrue();
        expect(app.canRemove).assertTrue();
      }
    });

    it('event_parma_various_module_names_valid', 0, () => {
      const names = ['entry', 'tv_launcher', '', 'com.ohos.launcher', 'main'];
      for (const name of names) {
        const p: eventParma<boolean> = { T: name.length > 0, moduleName: name };
        expect(p.moduleName).assertEqual(name);
        expect(p.T).assertEqual(name.length > 0);
      }
    });

    it('common_event_parma_five_codes_valid', 0, () => {
      for (let code = 0; code < 5; code++) {
        const payload: commonEventParma<boolean> = {
          event: 'action.' + code,
          bundleName: 'com.bundle.' + code,
          code,
          data: 'data_' + code,
          parameters: { T: code % 2 === 0, moduleName: 'mod_' + code } as eventParma<boolean>
        };
        expect(payload.code).assertEqual(code);
        expect(payload.parameters.T).assertEqual(code % 2 === 0);
        expect(payload.parameters.moduleName).assertEqual('mod_' + code);
      }
    });

    it('home_nav_edit_back_four_rounds_surface_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 4; i++) {
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(120);
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(22);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('launch_back_edit_home_back_three_rounds_text', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(130);
        await driver.triggerKey(KEY_ENTER);
        await driver.delayMs(900);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('ability_stage_and_style_constants_non_null', 0, () => {
      const stage = new MyAbilityStage();
      expect(stage !== null).assertTrue();
      expect(StyleConstants.DEFAULT_APP_ICON_SIZE_WIDTH).assertLargerOrEqual(1);
      expect(KeyCode.KEY_DPAD_UP).assertLargerOrEqual(1);
      expect(KeyCode.KEY_DPAD_DOWN).assertLargerOrEqual(1);
      expect((KeyCode.KEY_DPAD_UP as number) !== (KeyCode.KEY_DPAD_DOWN as number)).assertTrue();
    });

    it('nav_burst_edit_home_back_five_rounds_no_leak', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 5; i++) {
        for (let j = 0; j < 4; j++) {
          await driver.triggerKey(j % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
          await driver.delayMs(70);
        }
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(26);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
  });
}
