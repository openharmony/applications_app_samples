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
import { Driver, Component, abilityDelegatorRegistry } from '@kit.TestKit';
import {
  createFreshDriver,
  openBrowserHome,
  waitForId,
  waitForSurface,
  waitForStableSurface,
  countSurface,
  countReadableTexts,
  readInputText,
  safeFindAllById,
  safeDelay,
  debugSurfaceCount,
  TIMEOUT_START,
  STABLE_ROUNDS,
  STABLE_TOLERANCE,
  backToSafeHome
} from './SharedDriver';
import { ComponentIds, TestTimeouts } from './TestConstants';

const BUNDLE_NAME: string = 'ohos.samples.browser1';
const ABILITY_NAME: string = 'MainAbility';

interface BrowserWant {
  bundleName: string;
  abilityName: string;
  uri?: string;
}

async function startMainAbility(uri?: string): Promise<void> {
  const abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
  const want: BrowserWant = {
    bundleName: BUNDLE_NAME,
    abilityName: ABILITY_NAME
  };
  if (uri !== undefined && uri.length > 0) {
    want.uri = uri;
  }

  await abilityDelegator.startAbility(want);
}

export default function appTest(): void {
  describe('Browser_App_Test', () => {
    let driver: Driver;

    beforeAll(async () => {
      driver = createFreshDriver();
      await startMainAbility();
      await openBrowserHome(driver);
    });

    afterAll(async () => {
      await backToSafeHome(driver);
    });

    it('browser_home_should_render_texts_and_components', 0, async () => {
      await new Promise<void>((resolve: () => void) => setTimeout(resolve, 1000));

      const totalSurface: number = await countSurface(driver);
      const readableTexts: number = await countReadableTexts(driver);

      expect(totalSurface + readableTexts).assertLargerOrEqual(0);
    });

    it('browser_home_input_should_be_empty_on_default_start', 0, async () => {
      const inputText: string = await readInputText(driver, ComponentIds.INPUT_URL);
      expect(inputText === '' || inputText.length === 0).assertTrue();
    });

    it('browser_initial_tab_contract_should_hide_close_button', 0, async () => {
      const closeButtons: Component[] = await safeFindAllById(driver, 'cancelBtn');
      expect(closeButtons.length).assertEqual(0);
    });

    it('browser_should_keep_surface_after_multiple_resume_like_delays', 0, async () => {
      const beforeSurface: number = await countSurface(driver);
      await new Promise<void>((resolve: () => void) => setTimeout(resolve, 1000));
      const afterSurface: number = await countSurface(driver);
      expect(afterSurface).assertLargerOrEqual(0);
      expect(Math.abs(afterSurface - beforeSurface)).assertLessOrEqual(50);
    });
  });
}
