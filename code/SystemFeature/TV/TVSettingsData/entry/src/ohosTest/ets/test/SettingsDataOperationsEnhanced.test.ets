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

import { it, expect } from '@ohos/hypium';
import { DataOperationsTest, BoundaryValueTest } from './BaseSettingsTest';
import { TestDataGenerator, TestAssertions } from './TestUtils';
import { DataSettingsKey } from '../../../main/ets/Utils/SettingsDataConfig';

/**
 * 增强的数据操作测试类
 */
class EnhancedDataOperationsTest extends DataOperationsTest {
  protected getTestPrefix(): string {
    return 'enhanced_operations_test';
  }

  protected getTestSuiteName(): string {
    return 'EnhancedDataOperations_Test';
  }

  protected testDataInsertion(): void {
    it('insert_single_record_with_enhanced_assertions', 0, async () => {
      const testKey = this.generateTestKey('single_insert');
      const testValue = 'enhanced_insert_value';
      
      await this.assertOperationSuccess(async () => {
        const rowId = await this.insertTestData(testKey, testValue);
        expect(rowId).assertLargerOrEqual(0);
        
        const exists = await this.queryTestData(testKey);
        expect(exists).assertTrue();
      }, '单条记录插入应该成功');
    });

    it('insert_with_settings_key_should_succeed', 0, async () => {
      await this.assertOperationSuccess(async () => {
        const rowId = await this.insertTestData(
          DataSettingsKey.SETTINGS_SCREEN_BRIGHTNESS, 
          '200'
        );
        expect(rowId).assertLargerOrEqual(0);
      }, '使用设置键插入应该成功');
    });

    it('insert_multiple_records_should_succeed', 0, async () => {
      const testEntries = TestDataGenerator.generateTestEntries(5, this.getTestPrefix());
      
      for (const entry of testEntries) {
        await this.assertOperationSuccess(async () => {
          const rowId = await this.insertTestData(entry.get('name')!, entry.get('value')!);
          expect(rowId).assertLargerOrEqual(0);
        }, `插入记录 ${entry.get('name')} 应该成功`);
      }
    });
  }

  protected testDataQuery(): void {
    it('query_existing_record_should_return_data', 0, async () => {
      const testKey = this.generateTestKey('query_test');
      const testValue = 'query_test_value';
      
      // 先插入数据
      await this.insertTestData(testKey, testValue);
      
      await this.assertOperationSuccess(async () => {
        const exists = await this.queryTestData(testKey);
        expect(exists).assertTrue();
      }, '查询已存在记录应该成功');
    });

    it('query_non_existing_record_should_return_false', 0, async () => {
      const nonExistingKey = this.generateTestKey('non_existing');
      
      await this.assertOperationSuccess(async () => {
        const exists = await this.queryTestData(nonExistingKey);
        expect(exists).assertFalse();
      }, '查询不存在的记录应该返回false');
    });
  }

  protected testDataUpdate(): void {
    it('update_existing_record_should_succeed', 0, async () => {
      const testKey = this.generateTestKey('update_test');
      const initialValue = 'initial_value';
      const updatedValue = 'updated_value';
      
      // 先插入数据
      await this.insertTestData(testKey, initialValue);
      
      await this.assertOperationSuccess(async () => {
        const affectedRows = await this.updateTestData(testKey, updatedValue);
        expect(affectedRows).assertLargerOrEqual(1);
        
        // 验证数据已更新
        const exists = await this.queryTestData(testKey);
        expect(exists).assertTrue();
      }, '更新已存在记录应该成功');
    });

    it('update_non_existing_record_should_return_zero', 0, async () => {
      const nonExistingKey = this.generateTestKey('non_existing_update');
      
      await this.assertOperationSuccess(async () => {
        const affectedRows = await this.updateTestData(nonExistingKey, 'new_value');
        expect(affectedRows).assertEqual(0);
      }, '更新不存在的记录应该返回0');
    });
  }

  protected testDataDeletion(): void {
    it('delete_existing_record_should_succeed', 0, async () => {
      const testKey = this.generateTestKey('delete_test');
      const testValue = 'delete_test_value';
      
      // 先插入数据
      await this.insertTestData(testKey, testValue);
      
      await this.assertOperationSuccess(async () => {
        const affectedRows = await this.deleteTestData(testKey);
        expect(affectedRows).assertLargerOrEqual(1);
        
        // 验证数据已删除
        const exists = await this.queryTestData(testKey);
        expect(exists).assertFalse();
      }, '删除已存在记录应该成功');
    });

    it('delete_non_existing_record_should_return_zero', 0, async () => {
      const nonExistingKey = this.generateTestKey('non_existing_delete');
      
      await this.assertOperationSuccess(async () => {
        const affectedRows = await this.deleteTestData(nonExistingKey);
        expect(affectedRows).assertEqual(0);
      }, '删除不存在的记录应该返回0');
    });
  }
}

/**
 * 增强的边界值测试类
 */
class EnhancedBoundaryValueTest extends BoundaryValueTest {
  protected getTestPrefix(): string {
    return 'enhanced_boundary_test';
  }

  protected getTestSuiteName(): string {
    return 'EnhancedBoundaryValue_Test';
  }

  protected testEmptyValues(): void {
    it('handle_empty_string_value', 0, async () => {
      const testKey = this.generateTestKey('empty_value');
      
      await this.assertOperationSuccess(async () => {
        const rowId = await this.insertTestData(testKey, '');
        expect(rowId).assertLargerOrEqual(0);
      }, '处理空字符串值应该成功');
    });

    it('handle_null_like_values', 0, async () => {
      const testKey = this.generateTestKey('null_like');
      
      await this.assertOperationSuccess(async () => {
        const rowId = await this.insertTestData(testKey, 'null');
        expect(rowId).assertLargerOrEqual(0);
      }, '处理null-like值应该成功');
    });
  }

  protected testLongValues(): void {
    it('handle_long_string_values', 0, async () => {
      const testKey = this.generateTestKey('long_value');
      const longValue = 'x'.repeat(1024);
      
      await this.assertOperationSuccess(async () => {
        const rowId = await this.insertTestData(testKey, longValue);
        expect(rowId).assertLargerOrEqual(0);
      }, '处理长字符串值应该成功');
    });

    it('handle_extreme_long_values', 0, async () => {
      const testKey = this.generateTestKey('extreme_long');
      const extremeValue = 'y'.repeat(4096);
      
      await this.assertOperationSuccess(async () => {
        const rowId = await this.insertTestData(testKey, extremeValue);
        expect(rowId).assertLargerOrEqual(0);
      }, '处理极长字符串值应该成功');
    });
  }

  protected testSpecialCharacters(): void {
    it('handle_special_characters', 0, async () => {
      const specialChars = TestDataGenerator.generateSpecialCharacters();
      
      for (const charValue of specialChars) {
        const testKey = this.generateTestKey(`special_${charValue.substring(0, 10)}`);
        
        await this.assertOperationSuccess(async () => {
          const rowId = await this.insertTestData(testKey, charValue);
          expect(rowId).assertLargerOrEqual(0);
        }, `处理特殊字符 ${charValue} 应该成功`);
      }
    });

    it('handle_boundary_numeric_values', 0, async () => {
      const numericValues = TestDataGenerator.generateNumericBoundaries();
      
      for (const numValue of numericValues) {
        const testKey = this.generateTestKey(`numeric_${numValue}`);
        
        await this.assertOperationSuccess(async () => {
          const rowId = await this.insertTestData(testKey, numValue);
          expect(rowId).assertLargerOrEqual(0);
        }, `处理数值边界值 ${numValue} 应该成功`);
      }
    });
  }
}

/**
 * 导出测试函数
 */
export default function settingsDataOperationsEnhancedTest(): void {
  // 运行数据操作测试
  const dataOperationsTest = new EnhancedDataOperationsTest();
  dataOperationsTest.runTestSuite();

  // 运行边界值测试
  const boundaryValueTest = new EnhancedBoundaryValueTest();
  boundaryValueTest.runTestSuite();
}