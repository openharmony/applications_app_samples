/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 */

import { describe, it, expect } from '@ohos/hypium';
import { CheckEmptyUtils } from '../../../../../../common/src/main/ets/default/utils/CheckEmptyUtils';
import { CommonConstants } from '../../../../../../common/src/main/ets/default/constants/CommonConstants';
import { AppItemInfo as CommonAppItemInfo } from '../../../../../../common/src/main/ets/default/bean/AppItemInfo';
import { AppItemInfo as MainAppItemInfo } from '../../../main/ets/common/bean/AppItemInfo';
import { KeyCode } from '../../../main/ets/common/constants/KeyCode';
import StyleConstants from '../../../main/ets/common/constants/StyleConstants';
import { storeToken, preferenceToken as storagePreferenceToken } from '../../../main/ets/common/baseUtil/storage';
import { preferenceToken as dockerPreferenceToken } from '../../../main/ets/common/baseUtil/dockerAppStorage';

export default function coreUtilsAndContractsOnlyTest() {
  describe('CoreUtilsAndContractsOnly_Test', () => {
    it('check_empty_utils_matches_business_expectation', 0, () => {
      expect(CheckEmptyUtils.isEmpty(null)).assertTrue();
      expect(CheckEmptyUtils.isEmpty('')).assertTrue();
      expect(CheckEmptyUtils.checkStrIsEmpty('   ')).assertTrue();
      expect(CheckEmptyUtils.checkStrIsEmpty(' tv ')).assertFalse();
    });

    it('common_and_product_constants_keep_core_identity', 0, () => {
      expect(CommonConstants.LAUNCHER_ABILITY).assertEqual('com.ohos.launcher.MainAbility');
      expect(StyleConstants.DEFAULT_APP_NAME_SIZE).assertLargerOrEqual(1);
      expect((KeyCode.KEY_DPAD_LEFT as number) !== (KeyCode.KEY_DPAD_RIGHT as number)).assertTrue();
    });

    it('main_app_item_cover_keeps_mapping_contract', 0, () => {
      const commonApp = new CommonAppItemInfo();
      commonApp.appId = 'app.id.demo';
      commonApp.appName = 'demo-app';
      commonApp.appIconId = 7;
      commonApp.bundleName = 'com.demo.bundle';
      commonApp.abilityName = 'DemoAbility';
      commonApp.moduleName = 'entry';
      const mainApp = new MainAppItemInfo();
      mainApp.cover(commonApp);
      expect(mainApp.appId).assertEqual('app.id.demo');
      expect(mainApp.appName).assertEqual('demo-app');
      expect(mainApp.appIconId).assertEqual(7);
      expect(mainApp.canMove).assertTrue();
      expect(mainApp.canRemove).assertTrue();
    });

    it('storage_tokens_consistent_across_policies', 0, () => {
      expect(storagePreferenceToken).assertEqual('shortcuts_preferences');
      expect(dockerPreferenceToken).assertEqual('shortcuts_preferences');
    });

    it('store_token_non_empty_string', 0, () => {
      expect(typeof storeToken).assertEqual('string');
      expect(storeToken.length > 0).assertTrue();
    });

    it('launcher_bundle_matches_expected', 0, () => {
      expect(CommonConstants.LAUNCHER_BUNDLE).assertEqual('com.ohos.launcher');
    });

    it('type_constants_sequential', 0, () => {
      expect(CommonConstants.TYPE_APP).assertEqual(0);
      expect(CommonConstants.TYPE_FOLDER).assertEqual(3);
      expect(CommonConstants.INVALID_VALUE).assertEqual(-1);
    });

    it('cover_batch_preserves_default_policy_flags', 0, () => {
      for (let i = 0; i < 5; i++) {
        const source = new CommonAppItemInfo();
        source.appId = 'cu' + i;
        const target = new MainAppItemInfo();
        target.cover(source);
        expect(target.canMove).assertTrue();
        expect(target.canRemove).assertTrue();
      }
    });

    it('isEmpty_numbers_all_false', 0, () => {
      for (let i = 1; i <= 100; i++) {
        expect(CheckEmptyUtils.isEmpty(i)).assertFalse();
      }
    });

    it('isEmptyArr_non_empty_sizes_all_false', 0, () => {
      for (let i = 1; i <= 50; i++) {
        expect(CheckEmptyUtils.isEmptyArr(new Array(i).fill(0))).assertFalse();
      }
    });

    it('check_empty_utils_matrix_all_expected', 0, () => {
      const trueCases: (null | undefined | string)[] = [null, undefined, ''];
      const falseCases: (number | boolean | string)[] = [0, false, 'a', 'nonempty', '123'];
      for (const value of trueCases) {
        expect(CheckEmptyUtils.isEmpty(value)).assertTrue();
      }
      for (const value of falseCases) {
        expect(CheckEmptyUtils.isEmpty(value)).assertFalse();
      }
    });

    it('main_app_item_all_fields_assignable_stable', 0, () => {
      const app = new MainAppItemInfo();
      app.appName = 'core_app';
      app.bundleName = 'com.core.test';
      app.appIconId = 42;
      app.isFocus = true;
      app.canMove = false;
      expect(app.appName).assertEqual('core_app');
      expect(app.bundleName).assertEqual('com.core.test');
      expect(app.appIconId).assertEqual(42);
      expect(app.isFocus).assertTrue();
      expect(app.canMove).assertFalse();
    });

    it('storage_tokens_type_and_non_empty', 0, () => {
      expect(typeof storagePreferenceToken).assertEqual('string');
      expect(storagePreferenceToken.length > 0).assertTrue();
      expect(typeof dockerPreferenceToken).assertEqual('string');
      expect(dockerPreferenceToken.length > 0).assertTrue();
    });
  });
}
