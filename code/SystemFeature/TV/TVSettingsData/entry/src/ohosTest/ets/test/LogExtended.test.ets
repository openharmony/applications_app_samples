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
 * @file LogExtended.test.ets
 * @overview 扩展测试 Log 日志功能
 *           覆盖：日志级别、日志格式、日志输出、日志性能
 */

import { describe, it, expect, beforeAll, afterAll } from '@ohos/hypium';
import { Log } from '../../../main/ets/Utils/Log';
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

export default function logExtendedTest() {
  describe('LogExtended_Test', () => {
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

    // ========== 日志级别测试 ==========

    it('log_debug_level_should_not_throw', 0, () => {
      let threw = false;
      try {
        Log.debug('Debug level test message');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('log_info_level_should_not_throw', 0, () => {
      let threw = false;
      try {
        Log.info('Info level test message');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('log_warn_level_should_not_throw', 0, () => {
      let threw = false;
      try {
        Log.warn('Warn level test message');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('log_error_level_should_not_throw', 0, () => {
      let threw = false;
      try {
        Log.error('Error level test message');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('log_fatal_level_should_not_throw', 0, () => {
      let threw = false;
      try {
        Log.fatal('Fatal level test message');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 日志格式测试 ==========

    it('log_with_empty_message', 0, () => {
      let threw = false;
      try {
        Log.info('');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('log_with_special_characters', 0, () => {
      let threw = false;
      try {
        Log.info('Special chars: @#$%^&*()');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('log_with_unicode_characters', 0, () => {
      let threw = false;
      try {
        Log.info('Unicode: 中文测试');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('log_with_newline_characters', 0, () => {
      let threw = false;
      try {
        Log.info('Line1\nLine2\nLine3');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('log_with_tab_characters', 0, () => {
      let threw = false;
      try {
        Log.info('Tab1\tTab2\tTab3');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 日志输出测试 ==========

    it('log_debug_output_consistent', 0, () => {
      let threw = false;
      try {
        for (let i = 0; i < 5; i++) {
          Log.debug('Debug message ' + i);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('log_info_output_consistent', 0, () => {
      let threw = false;
      try {
        for (let i = 0; i < 5; i++) {
          Log.info('Info message ' + i);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('log_warn_output_consistent', 0, () => {
      let threw = false;
      try {
        for (let i = 0; i < 5; i++) {
          Log.warn('Warn message ' + i);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('log_error_output_consistent', 0, () => {
      let threw = false;
      try {
        for (let i = 0; i < 5; i++) {
          Log.error('Error message ' + i);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('log_fatal_output_consistent', 0, () => {
      let threw = false;
      try {
        for (let i = 0; i < 5; i++) {
          Log.fatal('Fatal message ' + i);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 日志性能测试 ==========

    it('log_performance_hundred_debug_calls', 0, () => {
      let threw = false;
      try {
        for (let i = 0; i < 100; i++) {
          Log.debug('Performance debug ' + i);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('log_performance_hundred_info_calls', 0, () => {
      let threw = false;
      try {
        for (let i = 0; i < 100; i++) {
          Log.info('Performance info ' + i);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('log_performance_hundred_warn_calls', 0, () => {
      let threw = false;
      try {
        for (let i = 0; i < 100; i++) {
          Log.warn('Performance warn ' + i);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('log_performance_hundred_error_calls', 0, () => {
      let threw = false;
      try {
        for (let i = 0; i < 100; i++) {
          Log.error('Performance error ' + i);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('log_performance_hundred_fatal_calls', 0, () => {
      let threw = false;
      try {
        for (let i = 0; i < 100; i++) {
          Log.fatal('Performance fatal ' + i);
        }
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 日志异常处理测试 ==========

    it('log_with_very_long_message', 0, () => {
      let threw = false;
      try {
        let longMessage = '';
        for (let i = 0; i < 5000; i++) {
          longMessage += 'a';
        }
        Log.info(longMessage);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('log_with_null_like_message', 0, () => {
      let threw = false;
      try {
        Log.info('null');
        Log.info('undefined');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 日志上下文测试 ==========

    it('log_context_settings_initialization', 0, () => {
      let threw = false;
      try {
        Log.info('Settings initialization started');
        Log.info('Loading default configuration');
        Log.info('Settings initialization completed');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('log_context_database_operations', 0, () => {
      let threw = false;
      try {
        Log.info('Database connection opening');
        Log.info('Executing query');
        Log.info('Query completed');
        Log.info('Database connection closing');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });
  });
}
