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
import { Driver } from '@kit.TestKit';
import {
  createFreshDriver,
  typeToInput,
  clickById,
  safePressBack,
  readInputText,
  waitForStableSurface,
  countReadableTexts,
  countSurface,
  openBrowserHome,
  backToSafeHome,
  STABLE_ROUNDS,
  STABLE_TOLERANCE,
  safeDelay
} from './SharedDriver';
import { TestConstants, TestTimeouts, TestData, WebInteractionConstants } from './TestConstants';

const SURFACE_CHANGE_THRESHOLD_WEB: number = WebInteractionConstants.SURFACE_CHANGE_THRESHOLD;
const BACK_DELAY: number = WebInteractionConstants.BACK_DELAY;
const BACK_WAIT_DELAY: number = WebInteractionConstants.BACK_WAIT_DELAY;
const BACK_CHECK_TIMEOUT: number = WebInteractionConstants.BACK_CHECK_TIMEOUT;

export default function webInteractionTest(): void {
  describe('Browser_Web_Interaction_Test', () => {
    let driver: Driver;

    beforeAll(async () => {
      driver = createFreshDriver();
      await openBrowserHome(driver);
    });

    afterAll(async () => {
      await backToSafeHome(driver);
    });

    /**
     * 回到主页按钮必须能把复杂网页状态清回本地首页。
     * 这对客厅场景的“重置当前浏览上下文”非常关键。
     */
    it('home_button_should_reset_to_local_home_page', 0, async () => {
      await clickById(driver, 'navigationButton3', 1800);
      const inputText: string = await readInputText(driver, 'inputUrl');
      expect(inputText.length === 0 || !inputText.includes('.')).assertTrue();
    });

    /**
     * 刷新按钮验证当前页可重复加载而不会把页面打回异常态。
     * 对网络波动恢复和用户主动重试都很关键。
     */
    it('refresh_button_should_keep_surface_and_text_available', 0, async () => {
      const beforeSurface: number = await countSurface(driver);
      await clickById(driver, 'navigationButton2', 1500);
      const readableTexts: number = await countReadableTexts(driver);
      const afterSurface: number = await countSurface(driver);
      expect(readableTexts).assertLargerOrEqual(1);
      expect(Math.abs(afterSurface - beforeSurface)).assertLessOrEqual(16);
    });

    /**
     * 后退与前进按钮共同构成历史记录体验。
     * 这里通过跳转、后退、前进组合验证历史栈没有被破坏。
     */
    it('back_and_forward_buttons_should_preserve_history_flow', 0, async () => {
      await typeToInput(driver, 'inputUrl', 'www.bing.com');
      await clickById(driver, 'actionButton0', 2500);
      await clickById(driver, 'navigationButton0', 1200);
      await clickById(driver, 'navigationButton1', 1500);
      const inputText: string = await readInputText(driver, 'inputUrl');
      expect(inputText.includes('bing') || inputText.includes('baidu') || inputText.length === 0).assertTrue();
    });

    /**
     * 连续打开网页后多次返回，是 onBackPress 的真实业务场景。
     * 这个用例重点验证返回逻辑最终还能回到宿主页，而不是卡在半退半留状态。
     */
    it('multiple_web_back_operations_should_return_to_host_page', 0, async () => {
      await safePressBack(driver, 800);
      await safePressBack(driver, 800);
      await safeDelay(driver, 1000);
      const stable: boolean = await waitForStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, 3200);
      const readableTexts: number = await countReadableTexts(driver);
      expect(stable).assertTrue();
      expect(readableTexts).assertLargerOrEqual(1);
    });
  });
}
