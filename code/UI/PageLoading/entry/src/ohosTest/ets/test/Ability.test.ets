/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { describe, it, expect } from '@ohos/hypium';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Driver, ON } from '@ohos.UiTest';
import { logger } from '../utils/logger';

const BUNDLE: string = 'PageLoading';
const TAG: string = '[PageLoading_Test]';

export default function abilityTest() {
  describe('ActsAbilityTest', () => {

    /**
     * 打开应用
     */
    it(BUNDLE + '_StartAbility', 0, async (done: Function) => {
      logger.info(TAG, BUNDLE + '_StartAbility start');
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.pageloading',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        logger.error(TAG, BUNDLE + '_StartAbility error');
        expect().assertFail();
      }
      logger.info(TAG, BUNDLE + '_StartAbility end');
      done();
    })

    /**
     * 页面加载效果实现案例只能断言页面加载后的列表是否正常滚动和展示（加载lottie动画需手工用例进行测试）
     */
    it(BUNDLE, 0, async (done: Function) => {
      let driver = Driver.create();

      await driver.delayMs(5000); // 进度条加载耗时

      const loadProgressHide = await driver.findComponent(ON.id('loadingHUD'));
      expect(loadProgressHide).assertEqual(null); // 断言界面数据正在加载完成并消失

      await driver.assertComponentExist(ON.id('commodity_list')); // 断言数据列表加载成功
      await driver.swipe(200, 1500, 200, 100, 2200); // 向上滑动
      await driver.delayMs(1000);
      const isScroll = await (await driver.findComponent(ON.id('commodity_list'))).isScrollable();
      expect(isScroll).assertEqual(true); // 断言商品列表可滚动

      done();
    })
  })
}