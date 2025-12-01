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

import { describe, it, beforeAll, afterAll, TestType, Size, Level } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import Want from '@ohos.app.ability.Want';
import hilog from '@ohos.hilog';

class Logger {
  private domain: number = 0xFF00;
  private prefix: string = '[Sample_StartAbility]';
  private format: string = '%{public}s';

  debug(tag: string, message: string): void {
    hilog.debug(this.domain, this.prefix, this.format, `${tag}: ${message}`);
  }

  info(tag: string, message: string): void {
    hilog.info(this.domain, this.prefix, this.format, `${tag}: ${message}`);
  }

  warn(tag: string, message: string): void {
    hilog.warn(this.domain, this.prefix, this.format, `${tag}: ${message}`);
  }

  error(tag: string, message: string): void {
    hilog.error(this.domain, this.prefix, this.format, `${tag}: ${message}`);
  }
}

const logger = new Logger();

const BUNDLE_NAME: string = 'com.example.commoneventpublish';
const ABILITY_NAME: string = 'EntryAbility';

// define delay time interface
interface DelayTimes {
  SHORT: number;
  MEDIUM: number;
  LONG: number;
  PAGE_LOAD: number;
  PANEL_WAIT: number;
  INIT: number;
}

// define delay time constants (unit: milliseconds)
const DELAY: DelayTimes = {
  SHORT: 500,        // short delay
  MEDIUM: 1000,      // medium delay
  LONG: 2000,        // long delay
  PAGE_LOAD: 3000,   // page load delay
  PANEL_WAIT: 3000,  // panel wait delay
  INIT: 1000,        // initialization delay
};

export default function EventUITest() {
  describe('EventUITest', () => {
    let driver: Driver;

    beforeAll(async () => {
      driver = Driver.create();
      await driver.delayMs(DELAY.INIT);

      logger.info('TestSetup', 'start APP...');
      try {
        const abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
        const want: Want = {
          bundleName: BUNDLE_NAME,
          abilityName: ABILITY_NAME
        };
        await abilityDelegator.startAbility(want);
        logger.info('TestSetup', 'start app success');
      } catch (error) {
        logger.warn('TestSetup', 'app is running');
      }

      await driver.delayMs(DELAY.PAGE_LOAD);
    });

    afterAll(async () => {
      await driver.delayMs(DELAY.MEDIUM);
      logger.info('TestCleanup', 'Test is over');
    });

    /**
     * @tc.number  : test_all_buttons_exist
     * @tc.name    : test_all_buttons_exist
     * @tc.desc    : Test whether all buttons exist.
     * @tc.level   : Level0
     * @tc.size    : SmallTest
     * @tc.type    : Function
     */
    it('test_all_buttons_exist', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, async (done: Function) => {
      logger.info('test_all_buttons_exist', 'Check all buttons');

      const buttonTexts: string[] = [
        '订阅事件', '中止当前的有序公共事件', '取消当前有序公共事件的中止状态',
        '修改有序公共事件的内容', '取消订阅公共事件', '发布公共事件'
      ];

      for (const buttonText of buttonTexts) {
        const button = await driver.findComponent(ON.text(buttonText));
        await button.click();
        await driver.delayMs(DELAY.SHORT);
        logger.info('ButtonsCheck', `Locate the button: ${buttonText}`);
      }

      logger.info('test_all_buttons_exist', 'All buttons have been checked.');
      done();
    });
  });
}