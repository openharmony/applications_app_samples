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

/**
 * @file UITestSuite.test.ets
 * @overview UI 交互测试套件
 *           将所有 UI 相关的测试集中管理，与逻辑测试分离
 *           覆盖：页面导航、组件渲染、交互响应
 */

import { describe, it, expect, beforeAll, afterAll } from '@ohos/hypium';
import SettingsDBHelper from '../../../main/ets/Utils/SettingsDBHelper';
import { GlobalContext } from '../../../main/ets/Utils/GlobalContext';
import {
  getDriver,
  createFreshDriver,
  KEY_HOME,
  KEY_BACK,
  surfaceCount,
  waitForSurface,
  waitForStableSurface,
  pressAndWait,
  countNonEmptyTexts,
  TIMEOUT_HOME,
  TIMEOUT_COLD_START,
  STABLE_TOLERANCE,
  STABLE_ROUNDS
} from './SharedDriver';
import { Driver } from '@kit.TestKit';

export default function uiTestSuite() {
  describe('UI_Interaction_Test', () => {
    let driver: Driver;

    beforeAll(async () => {
      SettingsDBHelper.resetInstance();
      
      driver = createFreshDriver();
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await waitForSurface(driver, 2, TIMEOUT_COLD_START);
      await waitForStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, 2500);
      
      const ctx = GlobalContext.getContext();
      const abilityContext = getContext() as Context;
      ctx.setObject('abilityContext', abilityContext);
    });

    afterAll(async () => {
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await waitForStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, 2000);
    });

    // ========== 页面导航测试 ==========

    it('ui_home_back_navigation_should_be_stable', 0, async () => {
      const before = await surfaceCount(driver);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      const after = await surfaceCount(driver);
      
      expect(after).assertLargerOrEqual(2);
      expect(Math.abs(after - before)).assertLessOrEqual(14);
    });

    it('ui_text_components_should_be_readable', 0, async () => {
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      expect(await countNonEmptyTexts(driver)).assertLargerOrEqual(1);
    });

    it('ui_home_key_should_render_minimum_components', 0, async () => {
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      const count = await surfaceCount(driver);
      expect(count).assertLargerOrEqual(2);
    });

    it('ui_back_key_should_not_crash', 0, async () => {
      let threw = false;
      try {
        await pressAndWait(driver, KEY_BACK, 2, TIMEOUT_HOME);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 页面稳定性测试 ==========

    it('ui_surface_count_should_be_stable_after_navigation', 0, async () => {
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      const count1 = await surfaceCount(driver);
      await pressAndWait(driver, KEY_HOME, 2, TIMEOUT_HOME);
      const count2 = await surfaceCount(driver);
      
      expect(Math.abs(count2 - count1)).assertLessOrEqual(8);
    });

    it('ui_stable_surface_check_should_pass', 0, async () => {
      const isStable = await waitForStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, 3000);
      expect(isStable).assertTrue();
    });
  });
}
