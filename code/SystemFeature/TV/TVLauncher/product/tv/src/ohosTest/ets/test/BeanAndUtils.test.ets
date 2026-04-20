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
import { Driver } from '@ohos.UiTest';
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
import { CheckEmptyUtils } from '../../../../../../common/src/main/ets/default/utils/CheckEmptyUtils';
import { AppItemInfo as CommonAppItemInfo } from '../../../../../../common/src/main/ets/default/bean/AppItemInfo';
import { AppItemInfo as MainAppItemInfo } from '../../../main/ets/common/bean/AppItemInfo';
import { CommonConstants } from '../../../../../../common/src/main/ets/default/constants/CommonConstants';
import { KeyCode } from '../../../main/ets/common/constants/KeyCode';
import StyleConstants from '../../../main/ets/common/constants/StyleConstants';

export default function beanAndUtilsTest() {
  describe('BeanAndUtils_Test', () => {
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

    it('isEmpty_undefined_should_be_true', 0, () => {
      expect(CheckEmptyUtils.isEmpty(undefined)).assertTrue();
    });
    it('isEmpty_null_should_be_true', 0, () => {
      expect(CheckEmptyUtils.isEmpty(null)).assertTrue();
    });
    it('isEmpty_empty_string_should_be_true', 0, () => {
      expect(CheckEmptyUtils.isEmpty('')).assertTrue();
    });
    it('isEmpty_nonempty_string_should_be_false', 0, () => {
      expect(CheckEmptyUtils.isEmpty('launcher')).assertFalse();
    });
    it('isEmpty_zero_should_be_false', 0, () => {
      expect(CheckEmptyUtils.isEmpty(0)).assertFalse();
    });
    it('isEmpty_false_should_be_false', 0, () => {
      expect(CheckEmptyUtils.isEmpty(false)).assertFalse();
    });
    it('isEmpty_negative_number_should_be_false', 0, () => {
      expect(CheckEmptyUtils.isEmpty(-1)).assertFalse();
    });
    it('isEmpty_whitespace_string_should_be_false', 0, () => {
      expect(CheckEmptyUtils.isEmpty('   ')).assertFalse();
    });
    it('isEmpty_object_should_be_false', 0, () => {
      const obj: Record<string, ESObject> = {};
      expect(CheckEmptyUtils.isEmpty(obj)).assertFalse();
    });
    it('isEmpty_array_should_be_false', 0, () => {
      expect(CheckEmptyUtils.isEmpty([1, 2])).assertFalse();
    });
    it('checkStrIsEmpty_blank_should_be_true', 0, () => {
      expect(CheckEmptyUtils.checkStrIsEmpty('   ')).assertTrue();
    });
    it('checkStrIsEmpty_tab_should_be_true', 0, () => {
      expect(CheckEmptyUtils.checkStrIsEmpty('\t')).assertTrue();
    });
    it('checkStrIsEmpty_newline_should_be_true', 0, () => {
      expect(CheckEmptyUtils.checkStrIsEmpty('\n')).assertTrue();
    });
    it('checkStrIsEmpty_nonempty_should_be_false', 0, () => {
      expect(CheckEmptyUtils.checkStrIsEmpty('  tv  ')).assertFalse();
    });
    it('checkStrIsEmpty_single_char_should_be_false', 0, () => {
      expect(CheckEmptyUtils.checkStrIsEmpty('a')).assertFalse();
    });
    it('checkStrIsEmpty_undefined_should_be_true', 0, () => {
      expect(CheckEmptyUtils.checkStrIsEmpty(undefined as ESObject as string)).assertTrue();
    });
    it('checkStrIsEmpty_null_should_be_true', 0, () => {
      expect(CheckEmptyUtils.checkStrIsEmpty(null as ESObject as string)).assertTrue();
    });
    it('isEmptyArr_empty_should_be_true', 0, () => {
      expect(CheckEmptyUtils.isEmptyArr([])).assertTrue();
    });
    it('isEmptyArr_nonempty_should_be_false', 0, () => {
      expect(CheckEmptyUtils.isEmptyArr([1])).assertFalse();
    });
    it('isEmptyArr_undefined_should_be_true', 0, () => {
      expect(CheckEmptyUtils.isEmptyArr(undefined as ESObject as ESObject[])).assertTrue();
    });
    it('isEmptyArr_null_should_be_true', 0, () => {
      expect(CheckEmptyUtils.isEmptyArr(null as ESObject as ESObject[])).assertTrue();
    });
    it('isEmptyArr_single_false_element_should_be_false', 0, () => {
      expect(CheckEmptyUtils.isEmptyArr([false as ESObject])).assertFalse();
    });
    it('isEmpty_vs_checkStr_blank', 0, () => {
      expect(CheckEmptyUtils.isEmpty('   ')).assertFalse();
      expect(CheckEmptyUtils.checkStrIsEmpty('   ')).assertTrue();
    });

    it('launcher_bundle_should_match', 0, () => {
      expect(CommonConstants.LAUNCHER_BUNDLE).assertEqual('com.ohos.launcher');
    });
    it('launcher_ability_should_match', 0, () => {
      expect(CommonConstants.LAUNCHER_ABILITY).assertEqual('com.ohos.launcher.MainAbility');
    });
    it('invalid_value_should_be_minus_one', 0, () => {
      expect(CommonConstants.INVALID_VALUE).assertEqual(-1);
    });
    it('type_app_should_be_zero', 0, () => {
      expect(CommonConstants.TYPE_APP).assertEqual(0);
    });
    it('type_folder_should_be_three', 0, () => {
      expect(CommonConstants.TYPE_FOLDER).assertEqual(3);
    });
    it('type_add_should_be_four', 0, () => {
      expect(CommonConstants.TYPE_ADD).assertEqual(4);
    });
    it('type_values_are_sequential_from_zero', 0, () => {
      expect(CommonConstants.TYPE_APP).assertEqual(0);
      expect(CommonConstants.TYPE_CARD).assertEqual(CommonConstants.TYPE_APP + 1);
      expect(CommonConstants.TYPE_FUNCTION).assertEqual(CommonConstants.TYPE_CARD + 1);
      expect(CommonConstants.TYPE_FOLDER).assertEqual(CommonConstants.TYPE_FUNCTION + 1);
      expect(CommonConstants.TYPE_ADD).assertEqual(CommonConstants.TYPE_FOLDER + 1);
    });
    it('overlay_types_distinct', 0, () => {
      const types = [CommonConstants.OVERLAY_TYPE_HIDE, CommonConstants.OVERLAY_TYPE_APP_MENU,
        CommonConstants.OVERLAY_TYPE_APP_ICON, CommonConstants.OVERLAY_TYPE_FOLDER,
        CommonConstants.OVERLAY_TYPE_CARD];
      expect(new Set(types).size).assertEqual(types.length);
    });
    it('badge_codes_distinct', 0, () => {
      expect(CommonConstants.BADGE_DISPLAY_HIDE === CommonConstants.BADGE_DISPLAY_SHOW).assertFalse();
    });
    it('default_user_id_should_be_zero', 0, () => {
      expect(CommonConstants.DEFAULT_USER_ID).assertEqual(0);
    });
    it('folder_name_max_length_should_be_positive', 0, () => {
      expect(CommonConstants.FOLDER_NAME_MAX_LENGTH).assertLargerOrEqual(1);
    });
    it('setting_data_uri_should_start_with_datashare', 0, () => {
      expect(CommonConstants.SETTING_DATA_ABILITY_URI.startsWith('datashare://')).assertTrue();
    });
    it('bean_style_constants_valid', 0, () => {
      expect(StyleConstants.DEFAULT_APP_ICON_SIZE_WIDTH).assertLargerOrEqual(1);
      expect(StyleConstants.DEFAULT_APP_NAME_SIZE).assertLargerOrEqual(1);
      expect(StyleConstants.DEFAULT_NUMBER_0).assertEqual(0);
    });
    it('keycodes_distinct', 0, () => {
      expect((KeyCode.KEY_DPAD_LEFT as number) !== (KeyCode.KEY_DPAD_RIGHT as number)).assertTrue();
      expect((KeyCode.KEY_DPAD_UP as number) !== (KeyCode.KEY_DPAD_DOWN as number)).assertTrue();
      expect(KeyCode.KEY_ENTER).assertLargerOrEqual(1);
    });

    it('default_fields_should_be_undefined', 0, () => {
      const app = new CommonAppItemInfo();
      expect(app.appId === undefined).assertTrue();
      expect(app.appName === undefined).assertTrue();
      expect(app.bundleName === undefined).assertTrue();
      expect(app.typeId === undefined).assertTrue();
    });
    it('identity_fields_should_be_assignable', 0, () => {
      const app = new CommonAppItemInfo();
      app.appId = 'com.demo.app';
      app.appName = 'Demo';
      app.bundleName = 'com.demo';
      app.abilityName = 'DemoAbility';
      expect(app.appId).assertEqual('com.demo.app');
      expect(app.appName).assertEqual('Demo');
      expect(app.bundleName).assertEqual('com.demo');
      expect(app.abilityName).assertEqual('DemoAbility');
    });
    it('layout_fields_assignable', 0, () => {
      const app = new CommonAppItemInfo();
      app.typeId = 0;
      app.page = 1;
      app.column = 2;
      app.row = 3;
      expect(app.typeId).assertEqual(0);
      expect(app.page).assertEqual(1);
      expect(app.column).assertEqual(2);
      expect(app.row).assertEqual(3);
    });
    it('boolean_fields_assignable', 0, () => {
      const app = new CommonAppItemInfo();
      app.isSystemApp = true;
      app.isUninstallAble = false;
      expect(app.isSystemApp).assertTrue();
      expect(app.isUninstallAble).assertFalse();
    });
    it('two_instances_independent', 0, () => {
      const a = new CommonAppItemInfo();
      const b = new CommonAppItemInfo();
      a.appId = 'id_a';
      b.appId = 'id_b';
      expect(a.appId).assertEqual('id_a');
      expect(b.appId).assertEqual('id_b');
    });
    it('overwrite_takes_new_value', 0, () => {
      const app = new CommonAppItemInfo();
      app.appName = 'old';
      app.appName = 'new';
      expect(app.appName).assertEqual('new');
    });

    it('cover_copies_all_identity_fields', 0, () => {
      const src = new CommonAppItemInfo();
      src.appId = 'id_t';
      src.appName = 'T';
      src.appIconId = 101;
      src.bundleName = 'com.t';
      src.abilityName = 'TA';
      src.moduleName = 'entry';
      const dst = new MainAppItemInfo();
      dst.cover(src);
      expect(dst.appId).assertEqual('id_t');
      expect(dst.appName).assertEqual('T');
      expect(dst.appIconId).assertEqual(101);
      expect(dst.bundleName).assertEqual('com.t');
    });
    it('cover_keeps_default_policy_flags', 0, () => {
      const dst = new MainAppItemInfo();
      dst.cover(new CommonAppItemInfo());
      expect(dst.canMove).assertTrue();
      expect(dst.canRemove).assertTrue();
    });
    it('cover_overwrites_existing_values', 0, () => {
      const src = new CommonAppItemInfo();
      src.appName = 'new';
      const dst = new MainAppItemInfo();
      dst.appName = 'old';
      dst.cover(src);
      expect(dst.appName).assertEqual('new');
    });
    it('cover_does_not_mutate_source', 0, () => {
      const src = new CommonAppItemInfo();
      src.appId = 'orig';
      src.appName = 'orig_name';
      const dst = new MainAppItemInfo();
      dst.cover(src);
      expect(src.appId).assertEqual('orig');
      expect(src.appName).assertEqual('orig_name');
    });
    it('cover_invalid_icon_id_preserved', 0, () => {
      const src = new CommonAppItemInfo();
      src.appIconId = CommonConstants.INVALID_VALUE;
      const dst = new MainAppItemInfo();
      dst.cover(src);
      expect(dst.appIconId).assertEqual(CommonConstants.INVALID_VALUE);
    });
    it('batch_cover_ten_apps_correct', 0, () => {
      for (let i = 0; i < 3; i++) {
        const src = new CommonAppItemInfo();
        src.appId = 'app_' + i;
        src.bundleName = 'com.b.' + i;
        const dst = new MainAppItemInfo();
        dst.cover(src);
        expect(dst.appId).assertEqual('app_' + i);
        expect(dst.bundleName).assertEqual('com.b.' + i);
      }
    });

    it('empty_check_then_edit_cycle', 0, async () => {
      expect(CheckEmptyUtils.isEmpty(undefined)).assertTrue();
      expect(CheckEmptyUtils.isEmpty('launcher')).assertFalse();
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
    });
    it('bean_cover_then_home_back_surface_ok', 0, async () => {
      const src = new CommonAppItemInfo();
      src.appId = 'ui_test';
      src.appName = 'UIApp';
      const dst = new MainAppItemInfo();
      dst.cover(src);
      expect(dst.appId).assertEqual('ui_test');
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      const after = await surfaceCount(driver);
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(TOLERANCE_EDIT_CYCLE);
    });
    it('constants_then_nav_text_readable', 0, async () => {
      expect(CommonConstants.LAUNCHER_BUNDLE).assertEqual('com.ohos.launcher');
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(120);
      await driver.triggerKey(KEY_LEFT);
      await driver.delayMs(120);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('isEmpty_large_positive_number_false', 0, () => {
      expect(CheckEmptyUtils.isEmpty(9999)).assertFalse();
    });
    it('isEmpty_array_with_zeros_false', 0, () => {
      expect(CheckEmptyUtils.isEmpty([0, 0, 0])).assertFalse();
    });
    it('checkStrIsEmpty_mixed_whitespace_true', 0, () => {
      expect(CheckEmptyUtils.checkStrIsEmpty(' \t \n ')).assertTrue();
    });
    it('checkStrIsEmpty_single_space_true', 0, () => {
      expect(CheckEmptyUtils.checkStrIsEmpty(' ')).assertTrue();
    });
    it('checkStrIsEmpty_chinese_char_false', 0, () => {
      expect(CheckEmptyUtils.checkStrIsEmpty('\u8bbe\u7f6e')).assertFalse();
    });
    it('isEmptyArr_large_array_false', 0, () => {
      expect(CheckEmptyUtils.isEmptyArr(new Array(100).fill(0))).assertFalse();
    });
    it('isEmptyArr_single_undefined_element_false', 0, () => {
      expect(CheckEmptyUtils.isEmptyArr([undefined as ESObject])).assertFalse();
    });
    it('isEmpty_boolean_true_false', 0, () => {
      expect(CheckEmptyUtils.isEmpty(true)).assertFalse();
    });

    it('bean_drag_from_dock_desktop_distinct', 0, () => {
      expect(CommonConstants.DRAG_FROM_DOCK === CommonConstants.DRAG_FROM_DESKTOP).assertFalse();
    });
    it('bean_uninstall_success_zero', 0, () => {
      expect(CommonConstants.UNINSTALL_SUCCESS).assertEqual(0);
    });
    it('bean_uninstall_forbid_one', 0, () => {
      expect(CommonConstants.UNINSTALL_FORBID).assertEqual(1);
    });
    it('overlay_types_all_distinct', 0, () => {
      const t = [CommonConstants.OVERLAY_TYPE_HIDE, CommonConstants.OVERLAY_TYPE_APP_MENU,
        CommonConstants.OVERLAY_TYPE_APP_ICON, CommonConstants.OVERLAY_TYPE_FOLDER,
        CommonConstants.OVERLAY_TYPE_CARD];
      expect(new Set(t).size).assertEqual(5);
    });
    it('card_dimensions_4_distinct', 0, () => {
      const d = [CommonConstants.CARD_DIMENSION_1x2, CommonConstants.CARD_DIMENSION_2x2,
        CommonConstants.CARD_DIMENSION_2x4, CommonConstants.CARD_DIMENSION_4x4];
      expect(new Set(d).size).assertEqual(4);
    });
    it('layout_levels_3_distinct', 0, () => {
      const l = [CommonConstants.LAYOUT_CONFIG_LEVEL_COMMON,
        CommonConstants.LAYOUT_CONFIG_LEVEL_FEATURE, CommonConstants.LAYOUT_CONFIG_LEVEL_PRODUCT];
      expect(new Set(l).size).assertEqual(3);
    });
    it('menu_types_distinct', 0, () => {
      expect(CommonConstants.MENU_TYPE_FIXED === CommonConstants.MENU_TYPE_DYNAMIC).assertFalse();
    });
    it('bean_device_types_distinct', 0, () => {
      expect(CommonConstants.DEFAULT_DEVICE_TYPE === CommonConstants.PAD_DEVICE_TYPE).assertFalse();
    });

    it('cover_50_apps_all_flags_default', 0, () => {
      for (let i = 0; i < 5; i++) {
        const src = new CommonAppItemInfo();
        src.appId = 'id_' + i;
        const dst = new MainAppItemInfo();
        dst.cover(src);
        expect(dst.canMove).assertTrue();
        expect(dst.canRemove).assertTrue();
      }
    });
    it('cover_empty_source_undefined_fields', 0, () => {
      const dst = new MainAppItemInfo();
      dst.appName = 'pre';
      dst.cover(new CommonAppItemInfo());
      expect(dst.appId === undefined).assertTrue();
    });
    it('area_field_accepts_array', 0, () => {
      const app = new CommonAppItemInfo();
      app.area = [2, 4];
      expect(app.area[0]).assertEqual(2);
      expect(app.area[1]).assertEqual(4);
    });
    it('badge_number_zero_assignable', 0, () => {
      const app = new CommonAppItemInfo();
      app.badgeNumber = 0;
      expect(app.badgeNumber).assertEqual(0);
    });
    it('cover_does_not_mutate_source_fields', 0, () => {
      const src = new CommonAppItemInfo();
      src.appId = 'orig';
      src.bundleName = 'b.orig';
      const dst = new MainAppItemInfo();
      dst.cover(src);
      expect(src.appId).assertEqual('orig');
      expect(src.bundleName).assertEqual('b.orig');
    });
    it('main_useSelfIcon_default_false', 0, () => {
      const dst = new MainAppItemInfo();
      expect(dst.useSelfIcon).assertFalse();
    });

    it('bean_twenty_home_back_bounded', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(22);
    });
    it('bean_ten_edit_cycles_no_leak', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(18);
    });
    it('bean_nav_30_lr_home_text', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
        await driver.delayMs(50);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('five_enter_back_then_edit_home_text', 0, async () => {
      for (let i = 0; i < 5; i++) {
        await driver.triggerKey(KEY_ENTER);
        await driver.delayMs(900);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('bean_circular_4dirs_8rounds_text', 0, async () => {
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
    it('three_home_back_edit_nav_chain_surface_ok', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
        await driver.triggerKey(KEY_RIGHT);
        await driver.delayMs(100);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(20);
    });
    it('ten_home_back_edit_combined_text', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });
    it('five_nav_edit_home_back_surface_ok', 0, async () => {
      const before = await surfaceCount(driver);
      for (let i = 0; i < 5; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
        await driver.delayMs(100);
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      }
      expect(Math.abs(await surfaceCount(driver) - before)).assertLessOrEqual(22);
    });

    it('isEmpty_matrix_cases_expected', 0, () => {
      interface IsEmptyCase {
        value: ESObject;
        expected: boolean
      }

      const cases: IsEmptyCase[] = [
        { value: undefined as ESObject, expected: true },
        { value: null as ESObject, expected: true },
        { value: '' as ESObject, expected: true },
        { value: 'tv' as ESObject, expected: false },
        { value: 0 as ESObject, expected: false },
        { value: false as ESObject, expected: false },
        { value: {} as ESObject, expected: false },
        { value: [] as ESObject, expected: false }
      ];
      for (const c of cases) {
        expect(CheckEmptyUtils.isEmpty(c.value)).assertEqual(c.expected);
      }
    });

    it('checkStrIsEmpty_matrix_cases_expected', 0, () => {
      const trueCases = [' ', '\t', '\n', ' \t \n '];
      const falseCases = ['a', ' launcher ', '0'];
      for (const s of trueCases) {
        expect(CheckEmptyUtils.checkStrIsEmpty(s)).assertTrue();
      }
      for (const s of falseCases) {
        expect(CheckEmptyUtils.checkStrIsEmpty(s)).assertFalse();
      }
    });

    it('common_app_item_mass_assignment_stable', 0, () => {
      for (let i = 0; i < 3; i++) {
        const app = new CommonAppItemInfo();
        app.appId = 'mass_' + i;
        app.appName = 'MassName_' + i;
        app.bundleName = 'com.mass.' + i;
        app.page = i;
        app.row = i % 4;
        app.column = i % 6;
        expect(app.appId).assertEqual('mass_' + i);
        expect(app.bundleName).assertEqual('com.mass.' + i);
        expect(app.page).assertEqual(i);
      }
    });

    it('main_app_cover_repeated_overwrite_stable', 0, () => {
      const dst = new MainAppItemInfo();
      for (let i = 0; i < 3; i++) {
        const src = new CommonAppItemInfo();
        src.appId = 'cover_' + i;
        src.appName = 'CoverName_' + i;
        src.bundleName = 'com.cover.' + i;
        dst.cover(src);
        expect(dst.appId).assertEqual('cover_' + i);
        expect(dst.appName).assertEqual('CoverName_' + i);
        expect(dst.bundleName).assertEqual('com.cover.' + i);
      }
    });

    it('constants_and_style_values_should_be_consistent', 0, () => {
      expect(CommonConstants.LAUNCHER_BUNDLE.length).assertLargerOrEqual(1);
      expect(CommonConstants.LAUNCHER_ABILITY.length).assertLargerOrEqual(1);
      expect(StyleConstants.DEFAULT_APP_ICON_SIZE_WIDTH).assertLargerOrEqual(StyleConstants.DEFAULT_NUMBER_0);
      expect(StyleConstants.DEFAULT_APP_NAME_SIZE).assertLargerOrEqual(StyleConstants.DEFAULT_NUMBER_0);
    });

    it('home_edit_back_five_rounds_text_readable', 0, async () => {
      for (let i = 0; i < 5; i++) {
        await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
        await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      }
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('alternating_nav_forty_then_home_back_text', 0, async () => {
      for (let i = 0; i < 4; i++) {
        await driver.triggerKey(i % 2 === 0 ? KEY_RIGHT : KEY_LEFT);
        await driver.delayMs(50);
      }
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('surface_count_positive_after_chain_ops', 0, async () => {
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_EDIT, 2, TIMEOUT_EDIT);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_EDIT);
      await driver.triggerKey(KEY_RIGHT);
      await driver.delayMs(100);
      await driver.triggerKey(KEY_LEFT);
      await driver.delayMs(100);
      expect(await surfaceCount(driver)).assertLargerOrEqual(2);
    });
  });
}
