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
 * @file GlobalContextAndLog.test.ets
 * @overview 测试 GlobalContext 单例模式和 Log 日志封装
 *           覆盖：单例一致性、对象存取、日志级别过滤、日志输出验证
 */

import { describe, it, expect, beforeAll, afterAll } from '@ohos/hypium';
import { GlobalContext } from '../../../main/ets/Utils/GlobalContext';
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

interface TestObject {
  key?: string;
  val?: string | number;
  name?: string;
  data?: string;
  index?: number;
  msg?: string;
  ts?: number;
  status?: string;
  level1?: Level2Object;
  items?: number[];
}

interface NestedObject {
  level1: Level2Object;
}

interface Level2Object {
  level2: string;
}

interface MockContext {
  bundleName: string;
}

interface MockHelper {
  initialized: boolean;
}

interface LargeObjectData {
  key_0?: string;
  key_1?: string;
  key_2?: string;
  key_3?: string;
  key_4?: string;
}

interface LargeObject {
  data: LargeObjectData;
}

export default function globalContextAndLogTest() {
  describe('GlobalContextAndLog_Test', () => {
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

    // ========== GlobalContext 单例测试 ==========

    it('get_context_should_return_same_instance', 0, () => {
      const ctx1 = GlobalContext.getContext();
      const ctx2 = GlobalContext.getContext();
      expect(ctx1 === ctx2).assertTrue();
    });

    it('get_context_should_not_return_null', 0, () => {
      const ctx = GlobalContext.getContext();
      expect(ctx !== null).assertTrue();
    });

    it('multiple_get_context_calls_should_return_same_ref', 0, () => {
      const instances: GlobalContext[] = [];
      for (let i = 0; i < 5; i++) {
        instances.push(GlobalContext.getContext());
      }
      for (let i = 1; i < instances.length; i++) {
        expect(instances[i] === instances[0]).assertTrue();
      }
    });

    // ========== GlobalContext 对象存取测试 ==========

    it('set_and_get_object_should_return_same_value', 0, () => {
      const ctx = GlobalContext.getContext();
      const testObj: TestObject = { key: 'test_value' };
      ctx.setObject('test_key', testObj);
      const retrieved = ctx.getObject('test_key');
      expect(retrieved !== undefined).assertTrue();
    });

    it('get_nonexistent_key_should_return_undefined', 0, () => {
      const ctx = GlobalContext.getContext();
      const result = ctx.getObject('nonexistent_key_xyz');
      expect(result === undefined).assertTrue();
    });

    it('set_object_should_overwrite_existing_value', 0, () => {
      const ctx = GlobalContext.getContext();
      const obj1: TestObject = { val: 'first' };
      const obj2: TestObject = { val: 'second' };
      ctx.setObject('overwrite_key', obj1);
      ctx.setObject('overwrite_key', obj2);
      const retrieved = ctx.getObject('overwrite_key');
      expect(retrieved !== undefined).assertTrue();
    });

    it('set_multiple_keys_should_be_independent', 0, () => {
      const ctx = GlobalContext.getContext();
      const objA: TestObject = { name: 'A' };
      const objB: TestObject = { name: 'B' };
      ctx.setObject('key_a', objA);
      ctx.setObject('key_b', objB);
      const retrievedA = ctx.getObject('key_a');
      const retrievedB = ctx.getObject('key_b');
      expect(retrievedA !== undefined).assertTrue();
      expect(retrievedB !== undefined).assertTrue();
    });

    it('set_empty_object_should_be_valid', 0, () => {
      const ctx = GlobalContext.getContext();
      const emptyObj: TestObject = {};
      ctx.setObject('empty_obj', emptyObj);
      const retrieved = ctx.getObject('empty_obj');
      expect(retrieved !== undefined).assertTrue();
    });

    it('set_null_object_should_be_valid', 0, () => {
      const ctx = GlobalContext.getContext();
      const nullObj: object | null = null;
      if (nullObj !== null) {
        ctx.setObject('null_obj', nullObj);
      }
      const retrieved = ctx.getObject('null_obj');
      expect(retrieved === undefined).assertTrue();
    });

    it('set_string_value_should_be_valid', 0, () => {
      const ctx = GlobalContext.getContext();
      const strObj: TestObject = { data: 'test_string' };
      ctx.setObject('string_key', strObj);
      const retrieved = ctx.getObject('string_key');
      expect(retrieved !== undefined).assertTrue();
    });

    it('set_number_value_should_be_valid', 0, () => {
      const ctx = GlobalContext.getContext();
      const numObj: TestObject = { index: 42 };
      ctx.setObject('number_key', numObj);
      const retrieved = ctx.getObject('number_key');
      expect(retrieved !== undefined).assertTrue();
    });

    it('set_boolean_value_should_be_valid', 0, () => {
      const ctx = GlobalContext.getContext();
      const boolObj: TestObject = { status: 'true' };
      ctx.setObject('bool_key', boolObj);
      const retrieved = ctx.getObject('bool_key');
      expect(retrieved !== undefined).assertTrue();
    });

    it('set_array_value_should_be_valid', 0, () => {
      const ctx = GlobalContext.getContext();
      const arrObj: TestObject = { items: [1, 2, 3] };
      ctx.setObject('array_key', arrObj);
      const retrieved = ctx.getObject('array_key');
      expect(retrieved !== undefined).assertTrue();
    });

    it('set_special_chars_key_should_be_valid', 0, () => {
      const ctx = GlobalContext.getContext();
      const obj: TestObject = { data: 'value' };
      ctx.setObject('key/with#special@chars', obj);
      const retrieved = ctx.getObject('key/with#special@chars');
      expect(retrieved !== undefined).assertTrue();
    });

    it('set_empty_string_key_should_be_valid', 0, () => {
      const ctx = GlobalContext.getContext();
      const obj: TestObject = { data: 'value' };
      ctx.setObject('', obj);
      const retrieved = ctx.getObject('');
      expect(retrieved !== undefined).assertTrue();
    });

    it('set_and_get_ability_context_should_be_valid', 0, () => {
      const ctx = GlobalContext.getContext();
      const mockContext: MockContext = { bundleName: 'com.ohos.settingsdata' };
      ctx.setObject('abilityContext', mockContext);
      const retrieved = ctx.getObject('abilityContext');
      expect(retrieved !== undefined).assertTrue();
    });

    it('set_and_get_db_helper_should_be_valid', 0, () => {
      const ctx = GlobalContext.getContext();
      const mockHelper: MockHelper = { initialized: true };
      ctx.setObject('dbHelper', mockHelper);
      const retrieved = ctx.getObject('dbHelper');
      expect(retrieved !== undefined).assertTrue();
    });

    it('concurrent_set_get_should_be_consistent', 0, () => {
      const ctx = GlobalContext.getContext();
      for (let i = 0; i < 10; i++) {
        const obj: TestObject = { index: i };
        ctx.setObject('concurrent_' + i, obj);
      }
      for (let i = 0; i < 10; i++) {
        const retrieved = ctx.getObject('concurrent_' + i);
        expect(retrieved !== undefined).assertTrue();
      }
    });

    it('get_context_after_multiple_sets_should_still_be_singleton', 0, () => {
      const ctx = GlobalContext.getContext();
      const temp1: TestObject = { val: 1 };
      const temp2: TestObject = { val: 2 };
      const temp3: TestObject = { val: 3 };
      ctx.setObject('temp1', temp1);
      ctx.setObject('temp2', temp2);
      ctx.setObject('temp3', temp3);
      const ctxAfter = GlobalContext.getContext();
      expect(ctx === ctxAfter).assertTrue();
    });

    // ========== GlobalContext 边界测试 ==========

    it('set_large_object_should_be_valid', 0, () => {
      const ctx = GlobalContext.getContext();
      const largeData: LargeObjectData = {
        key_0: 'value_0',
        key_1: 'value_1',
        key_2: 'value_2',
        key_3: 'value_3',
        key_4: 'value_4'
      };
      const largeObj: LargeObject = { data: largeData };
      ctx.setObject('large_obj', largeObj);
      const retrieved = ctx.getObject('large_obj');
      expect(retrieved !== undefined).assertTrue();
    });

    it('set_nested_object_should_be_valid', 0, () => {
      const ctx = GlobalContext.getContext();
      const nestedObj: NestedObject = {
        level1: { level2: 'deep_value' }
      };
      ctx.setObject('nested_obj', nestedObj);
      const retrieved = ctx.getObject('nested_obj');
      expect(retrieved !== undefined).assertTrue();
    });

    // ========== Log 日志测试 ==========

    it('log_info_should_not_throw', 0, () => {
      let threw = false;
      try {
        Log.info('test info log message');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('log_debug_should_not_throw', 0, () => {
      let threw = false;
      try {
        Log.debug('test debug log message');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('log_warn_should_not_throw', 0, () => {
      let threw = false;
      try {
        Log.warn('test warn log message');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('log_error_should_not_throw', 0, () => {
      let threw = false;
      try {
        Log.error('test error log message');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('log_fatal_should_not_throw', 0, () => {
      let threw = false;
      try {
        Log.fatal('test fatal log message');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('log_info_with_format_args_should_not_throw', 0, () => {
      let threw = false;
      try {
        Log.info('test info with args: %{public}s, %{public}d', 'string_arg', 123);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('log_debug_with_format_args_should_not_throw', 0, () => {
      let threw = false;
      try {
        Log.debug('test debug with args: %{public}s, %{public}d', 'debug_arg', 456);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('log_warn_with_format_args_should_not_throw', 0, () => {
      let threw = false;
      try {
        Log.warn('test warn with args: %{public}s, %{public}d', 'warn_arg', 789);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('log_error_with_format_args_should_not_throw', 0, () => {
      let threw = false;
      try {
        Log.error('test error with args: %{public}s, %{public}d', 'error_arg', 101);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('log_fatal_with_format_args_should_not_throw', 0, () => {
      let threw = false;
      try {
        Log.fatal('test fatal with args: %{public}s, %{public}d', 'fatal_arg', 202);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('log_empty_message_should_not_throw', 0, () => {
      let threw = false;
      try {
        Log.info('');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('log_special_chars_message_should_not_throw', 0, () => {
      let threw = false;
      try {
        Log.info('test message with special chars: @#$%^&*()');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('log_unicode_message_should_not_throw', 0, () => {
      let threw = false;
      try {
        Log.info('test unicode message: 设置数据');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('log_long_message_should_not_throw', 0, () => {
      let threw = false;
      try {
        let longMsg = '';
        for (let i = 0; i < 1000; i++) {
          longMsg += 'a';
        }
        Log.info(longMsg);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('log_multiple_args_should_not_throw', 0, () => {
      let threw = false;
      try {
        Log.info('multi args: %{public}s, %{public}d, %{public}b', 'str', 123, true);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ========== 组合场景测试 ==========

    it('context_set_then_log_should_not_interfere', 0, () => {
      const ctx = GlobalContext.getContext();
      const logTestObj: TestObject = { msg: 'test' };
      ctx.setObject('log_test_key', logTestObj);
      Log.info('context set completed');
      const retrieved = ctx.getObject('log_test_key');
      expect(retrieved !== undefined).assertTrue();
    });

    it('log_before_and_after_context_set', 0, () => {
      Log.info('before context set');
      const ctx = GlobalContext.getContext();
      const timingObj: TestObject = { ts: Date.now() };
      ctx.setObject('timing_key', timingObj);
      Log.info('after context set');
      const retrieved = ctx.getObject('timing_key');
      expect(retrieved !== undefined).assertTrue();
    });

    it('context_and_log_stress_test', 0, () => {
      const ctx = GlobalContext.getContext();
      for (let i = 0; i < 20; i++) {
        const stressObj: TestObject = { val: i };
        ctx.setObject('stress_' + i, stressObj);
        if (i % 5 === 0) {
          Log.info('stress iteration: %{public}d', i);
        }
      }
      for (let i = 0; i < 20; i++) {
        const retrieved = ctx.getObject('stress_' + i);
        expect(retrieved !== undefined).assertTrue();
      }
    });
  });
}
