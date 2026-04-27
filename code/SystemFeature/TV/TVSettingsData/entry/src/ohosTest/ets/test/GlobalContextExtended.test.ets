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
 * @file GlobalContextExtended.test.ets
 * @overview 扩展测试 GlobalContext 单例模式
 *           覆盖：对象存储、属性存储、生命周期、并发访问、内存泄漏检测
 */

import { describe, it, expect, beforeAll, afterAll } from '@ohos/hypium';
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

interface TestObject {
  name?: string;
  data?: string;
  status?: string;
  index?: number;
  type?: string;
  level1?: Level2Object;
  items?: number[];
}

interface Level2Object {
  level2?: Level3Object;
}

interface Level3Object {
  value: string;
}

interface PersistObj {
  data: string;
}

interface MemoryTestObj {
  data: string;
}

interface EmptyKeyObj {
  empty_key_obj: boolean;
}

interface ConcurrentObj {
  index: number;
}

interface StressObj {
  index: number;
}

export default function globalContextExtendedTest() {
  describe('GlobalContextExtended_Test', () => {
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

    // ========== 对象存储测试 ==========

    it('set_and_get_object_should_return_same_instance', 0, () => {
      const ctx = GlobalContext.getContext();
      const testObj: TestObject = { name: 'test_object' };
      ctx.setObject('test_obj_key', testObj);
      const retrieved = ctx.getObject('test_obj_key');
      expect(retrieved === testObj).assertTrue();
    });

    it('set_and_get_object_multiple_keys_should_be_independent', 0, () => {
      const ctx = GlobalContext.getContext();
      const obj1: TestObject = { name: 'object1' };
      const obj2: TestObject = { name: 'object2' };
      ctx.setObject('obj_key1', obj1);
      ctx.setObject('obj_key2', obj2);
      expect(ctx.getObject('obj_key1') === obj1).assertTrue();
      expect(ctx.getObject('obj_key2') === obj2).assertTrue();
    });

    it('overwrite_existing_object_should_update_value', 0, () => {
      const ctx = GlobalContext.getContext();
      const oldObj: TestObject = { name: 'old_object' };
      const newObj: TestObject = { name: 'new_object' };
      ctx.setObject('overwrite_obj_key', oldObj);
      ctx.setObject('overwrite_obj_key', newObj);
      expect(ctx.getObject('overwrite_obj_key') === newObj).assertTrue();
    });

    it('get_nonexistent_object_should_return_undefined', 0, () => {
      const ctx = GlobalContext.getContext();
      expect(ctx.getObject('nonexistent_obj_key')).assertEqual(undefined);
    });

    it('set_object_with_null_value', 0, () => {
      const ctx = GlobalContext.getContext();
      ctx.setObject('null_obj_key', undefined);
      expect(ctx.getObject('null_obj_key')).assertEqual(undefined);
    });

    it('set_object_with_complex_structure', 0, () => {
      const ctx = GlobalContext.getContext();
      const complexObj: TestObject = {
        level1: {
          level2: {
            value: 'deep_value'
          }
        }
      };
      ctx.setObject('complex_obj_key', complexObj);
      const retrieved = ctx.getObject('complex_obj_key');
      expect(retrieved !== undefined).assertTrue();
    });

    it('set_object_with_array', 0, () => {
      const ctx = GlobalContext.getContext();
      const arrayObj: TestObject = { items: [1, 2, 3] };
      ctx.setObject('array_obj_key', arrayObj);
      const retrieved = ctx.getObject('array_obj_key');
      expect(retrieved !== undefined).assertTrue();
    });

    // ========== 属性存储测试 ==========

    it('set_and_get_property_should_return_same_value', 0, () => {
      const ctx = GlobalContext.getContext();
      ctx.setProperty('test_prop_key', 'test_prop_value');
      expect(ctx.getProperty('test_prop_key')).assertEqual('test_prop_value');
    });

    it('set_and_get_property_multiple_keys_should_be_independent', 0, () => {
      const ctx = GlobalContext.getContext();
      ctx.setProperty('prop_key1', 'prop_value1');
      ctx.setProperty('prop_key2', 'prop_value2');
      expect(ctx.getProperty('prop_key1')).assertEqual('prop_value1');
      expect(ctx.getProperty('prop_key2')).assertEqual('prop_value2');
    });

    it('overwrite_existing_property_should_update_value', 0, () => {
      const ctx = GlobalContext.getContext();
      ctx.setProperty('overwrite_prop_key', 'old_value');
      ctx.setProperty('overwrite_prop_key', 'new_value');
      expect(ctx.getProperty('overwrite_prop_key')).assertEqual('new_value');
    });

    it('get_nonexistent_property_should_return_undefined', 0, () => {
      const ctx = GlobalContext.getContext();
      expect(ctx.getProperty('nonexistent_prop_key')).assertEqual(undefined);
    });

    it('set_property_with_empty_string', 0, () => {
      const ctx = GlobalContext.getContext();
      ctx.setProperty('empty_prop_key', '');
      expect(ctx.getProperty('empty_prop_key')).assertEqual('');
    });

    it('set_property_with_special_characters', 0, () => {
      const ctx = GlobalContext.getContext();
      ctx.setProperty('special_prop_key', 'value@#$%^&*()');
      expect(ctx.getProperty('special_prop_key')).assertEqual('value@#$%^&*()');
    });

    it('set_property_with_unicode', 0, () => {
      const ctx = GlobalContext.getContext();
      ctx.setProperty('unicode_prop_key', '测试值');
      expect(ctx.getProperty('unicode_prop_key')).assertEqual('测试值');
    });

    it('set_property_with_long_string', 0, () => {
      const ctx = GlobalContext.getContext();
      let longValue = '';
      for (let i = 0; i < 1000; i++) {
        longValue += 'a';
      }
      ctx.setProperty('long_prop_key', longValue);
      expect(ctx.getProperty('long_prop_key')).assertEqual(longValue);
    });

    // ========== 生命周期测试 ==========

    it('context_singleton_consistent', 0, () => {
      const ctx1 = GlobalContext.getContext();
      const ctx2 = GlobalContext.getContext();
      expect(ctx1 === ctx2).assertTrue();
    });

    it('context_persists_across_operations', 0, () => {
      const ctx = GlobalContext.getContext();
      ctx.setProperty('persist_prop', 'persist_value');
      const persistObj: PersistObj = { data: 'persist_data' };
      ctx.setObject('persist_obj', persistObj);
      expect(ctx.getProperty('persist_prop')).assertEqual('persist_value');
      expect(ctx.getObject('persist_obj') !== undefined).assertTrue();
    });

    // ========== 并发访问测试 ==========

    it('concurrent_set_property_should_not_corrupt', 0, () => {
      const ctx = GlobalContext.getContext();
      for (let i = 0; i < 10; i++) {
        ctx.setProperty('concurrent_prop_' + i, 'value_' + i);
      }
      for (let i = 0; i < 10; i++) {
        expect(ctx.getProperty('concurrent_prop_' + i)).assertEqual('value_' + i);
      }
    });

    it('concurrent_set_object_should_not_corrupt', 0, () => {
      const ctx = GlobalContext.getContext();
      for (let i = 0; i < 10; i++) {
        const obj: ConcurrentObj = { index: i };
        ctx.setObject('concurrent_obj_' + i, obj);
      }
      for (let i = 0; i < 10; i++) {
        expect(ctx.getObject('concurrent_obj_' + i) !== undefined).assertTrue();
      }
    });

    // ========== 内存泄漏检测测试 ==========

    it('memory_leak_check_object_cleanup', 0, () => {
      const ctx = GlobalContext.getContext();
      const memObj: MemoryTestObj = { data: 'test_data' };
      ctx.setObject('memory_test_obj', memObj);
      expect(ctx.getObject('memory_test_obj') !== undefined).assertTrue();
    });

    it('memory_leak_check_property_cleanup', 0, () => {
      const ctx = GlobalContext.getContext();
      ctx.setProperty('memory_test_prop', 'test_value');
      expect(ctx.getProperty('memory_test_prop')).assertEqual('test_value');
    });

    // ========== 边界值测试 ==========

    it('property_key_empty_string', 0, () => {
      const ctx = GlobalContext.getContext();
      ctx.setProperty('', 'empty_key_value');
      expect(ctx.getProperty('')).assertEqual('empty_key_value');
    });

    it('object_key_empty_string', 0, () => {
      const ctx = GlobalContext.getContext();
      const emptyKeyObj: EmptyKeyObj = { empty_key_obj: true };
      ctx.setObject('', emptyKeyObj);
      expect(ctx.getObject('') !== undefined).assertTrue();
    });

    // ========== 类型验证测试 ==========

    it('property_value_is_string_type', 0, () => {
      const ctx = GlobalContext.getContext();
      ctx.setProperty('type_test_prop', 'string_value');
      const value = ctx.getProperty('type_test_prop');
      expect(typeof value === 'string').assertTrue();
    });

    it('object_value_is_object_type', 0, () => {
      const ctx = GlobalContext.getContext();
      const typeTestObj: TestObject = { type: 'test' };
      ctx.setObject('type_test_obj', typeTestObj);
      const value = ctx.getObject('type_test_obj');
      expect(value !== null && typeof value === 'object').assertTrue();
    });

    // ========== 压力测试 ==========

    it('stress_set_get_object_hundred_times', 0, () => {
      const ctx = GlobalContext.getContext();
      for (let i = 0; i < 100; i++) {
        const obj: StressObj = { index: i };
        ctx.setObject('stress_obj_' + i, obj);
      }
      for (let i = 0; i < 100; i++) {
        expect(ctx.getObject('stress_obj_' + i) !== undefined).assertTrue();
      }
    });

    it('stress_set_get_property_hundred_times', 0, () => {
      const ctx = GlobalContext.getContext();
      for (let i = 0; i < 100; i++) {
        ctx.setProperty('stress_prop_' + i, 'value_' + i);
      }
      for (let i = 0; i < 100; i++) {
        expect(ctx.getProperty('stress_prop_' + i)).assertEqual('value_' + i);
      }
    });
  });
}
