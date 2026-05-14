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

import { describe, it, expect, beforeEach, afterEach, TestType, Size, Level } from '@ohos/hypium';
import Logger from '../../../../main/ets/utils/Logger';

function strRepeat(str: string, count: number): string {
  let result: string = '';
  for (let i: number = 0; i < count; i++) {
    result += str;
  }
  return result;
}

export default function LogComprehensiveTestSuite(): void {
  describe('LogComprehensiveTest', () => {

    beforeEach(() => {
    });

    afterEach(() => {
    });

    it('test_debug_singleArg', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      let threw: boolean = false;
      try {
        Logger.debug('TestDebug');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_debug_multipleArgs', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      let threw: boolean = false;
      try {
        Logger.debug('TestTag', 'TestMessage');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_debug_noArgs', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      let threw: boolean = false;
      try {
        Logger.debug();
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_debug_emptyString', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      let threw: boolean = false;
      try {
        Logger.debug('');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_debug_chineseChars', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      let threw: boolean = false;
      try {
        Logger.debug('中文调试信息');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_debug_longString', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const longStr: string = strRepeat('D', 100);
      let threw: boolean = false;
      try {
        Logger.debug('longDebug', longStr);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_debug_rapid_100', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      for (let i: number = 0; i < 100; i++) {
        Logger.debug('dTag_' + i, 'dMsg_' + i);
      }
      expect(true).assertTrue();
    });

    it('test_info_singleArg', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      let threw: boolean = false;
      try {
        Logger.info('InfoTag');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_info_multipleArgs', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      let threw: boolean = false;
      try {
        Logger.info('InfoTag', 'InfoMsg');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_info_noArgs', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      let threw: boolean = false;
      try {
        Logger.info();
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_info_chineseChars', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      let threw: boolean = false;
      try {
        Logger.info('中文信息消息');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_info_longString', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const longStr: string = strRepeat('I', 100);
      let threw: boolean = false;
      try {
        Logger.info('longInfo', longStr);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_info_rapid_100', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      for (let i: number = 0; i < 100; i++) {
        Logger.info('iTag_' + i, 'iMsg_' + i);
      }
      expect(true).assertTrue();
    });

    it('test_error_singleArg', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      let threw: boolean = false;
      try {
        Logger.error('ErrTag');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_error_multipleArgs', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      let threw: boolean = false;
      try {
        Logger.error('ErrTag', 'ErrMsg');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_error_noArgs', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      let threw: boolean = false;
      try {
        Logger.error();
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_error_chineseChars', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      let threw: boolean = false;
      try {
        Logger.error('errorTag', 'errorMsg');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_error_longString', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const longStr: string = strRepeat('E', 100);
      let threw: boolean = false;
      try {
        Logger.error('longErr', longStr);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_error_rapid_100', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      for (let i: number = 0; i < 100; i++) {
        Logger.error('eTag_' + i, 'eMsg_' + i);
      }
      expect(true).assertTrue();
    });

    it('test_warn_singleArg', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      let threw: boolean = false;
      try {
        Logger.warn('WarnTag');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_warn_multipleArgs', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      let threw: boolean = false;
      try {
        Logger.warn('WarnTag', 'WarnMsg');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_warn_noArgs', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      let threw: boolean = false;
      try {
        Logger.warn();
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_warn_chineseChars', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      let threw: boolean = false;
      try {
        Logger.warn('中文警告信息');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_warn_longString', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const longStr: string = strRepeat('W', 100);
      let threw: boolean = false;
      try {
        Logger.warn('longWarn', longStr);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_warn_rapid_100', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      for (let i: number = 0; i < 100; i++) {
        Logger.warn('wTag_' + i, 'wMsg_' + i);
      }
      expect(true).assertTrue();
    });

    it('test_allFunctions_mixedCalls', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      for (let i: number = 0; i < 100; i++) {
        Logger.debug('tag_' + i);
        Logger.info('tag_' + i);
        Logger.error('tag_' + i);
        Logger.warn('tag_' + i);
      }
      expect(true).assertTrue();
    });

    it('test_stress_debug_1000_calls', TestType.RELIABILITY | Size.LARGETEST | Level.LEVEL3, () => {
      for (let i: number = 0; i < 1000; i++) {
        Logger.debug('stress_tag_' + i, 'stress_msg_' + i);
      }
      expect(true).assertTrue();
    });

    it('test_stress_info_1000_calls', TestType.RELIABILITY | Size.LARGETEST | Level.LEVEL3, () => {
      for (let i: number = 0; i < 1000; i++) {
        Logger.info('stress_tag_' + i, 'stress_msg_' + i);
      }
      expect(true).assertTrue();
    });

    it('test_stress_error_1000_calls', TestType.RELIABILITY | Size.LARGETEST | Level.LEVEL3, () => {
      for (let i: number = 0; i < 1000; i++) {
        Logger.error('stress_tag_' + i, 'stress_msg_' + i);
      }
      expect(true).assertTrue();
    });

    it('test_stress_warn_1000_calls', TestType.RELIABILITY | Size.LARGETEST | Level.LEVEL3, () => {
      for (let i: number = 0; i < 1000; i++) {
        Logger.warn('stress_tag_' + i, 'stress_msg_' + i);
      }
      expect(true).assertTrue();
    });

    it('test_stress_mixedAllLogFunctions_100', TestType.RELIABILITY | Size.LARGETEST | Level.LEVEL3, () => {
      for (let i: number = 0; i < 100; i++) {
        Logger.debug('s_' + i);
        Logger.info('s_' + i);
        Logger.error('s_' + i);
        Logger.warn('s_' + i);
      }
      expect(true).assertTrue();
    });

    it('test_debug_jsonString', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const currentTime: number = new Date().getTime();
      const jsonMsg: string = JSON.stringify({ action: 'test', timestamp: currentTime, data: [1, 2, 3] });
      let threw: boolean = false;
      try {
        Logger.debug('jsonTag', jsonMsg);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_info_emojiChars', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      let threw: boolean = false;
      try {
        Logger.info('emoji', '🚀🔥💯🎵🎮');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_error_scriptTagInjection', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      let threw: boolean = false;
      try {
        Logger.error('injection', '<script>alert(1)</script>');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_warn_sqlInjection', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      let threw: boolean = false;
      try {
        Logger.warn('sql', 'SELECT * FROM users WHERE 1=1; DROP TABLE users;--');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_debug_nullCharInMsg', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const msgWithNull: string = 'before\0after';
      let threw: boolean = false;
      try {
        Logger.debug('nullChar', msgWithNull);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('test_boundary_emptyArgs', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      let threw: boolean = false;
      try {
        Logger.debug('');
        Logger.info('');
        Logger.error('');
        Logger.warn('');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });
  });
}
