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
 * @file TestUtils.ets
 * @overview 测试工具类，提供公共测试方法，减少重复代码
 */

import SettingsDBHelper from '../../../main/ets/Utils/SettingsDBHelper';
import { settingsDataConfig } from '../../../main/ets/Utils/SettingsDataConfig';
import { dataSharePredicates, relationalStore } from '@kit.ArkData';
import { Log } from '../../../main/ets/Utils/Log';

/**
 * 测试数据清理器
 */
export class TestDataCleaner {
  private static cleanedKeys: Set<string> = new Set<string>();

  /**
   * 清理指定 key 的测试数据
   */
  static async cleanTestData(key: string): Promise<void> {
    try {
      if (TestDataCleaner.cleanedKeys.has(key)) {
        return;
      }
      const helper = SettingsDBHelper.getInstance();
      const rdbStore = await helper.getRdbStore();
      if (rdbStore !== undefined) {
        const predicates = new dataSharePredicates.DataSharePredicates();
        predicates.equalTo('KEYWORD', key);
        await rdbStore.delete(settingsDataConfig.TABLE_NAME, predicates);
        TestDataCleaner.cleanedKeys.add(key);
      }
    } catch (e) {
      Log.warn(`Failed to clean test data for key: ${key}`);
    }
  }

  /**
   * 批量清理测试数据
   */
  static async cleanMultipleTestData(keys: string[]): Promise<void> {
    for (const key of keys) {
      await TestDataCleaner.cleanTestData(key);
    }
  }

  /**
   * 清理所有以指定前缀开头的测试数据
   */
  static async cleanTestDataByPrefix(prefix: string): Promise<void> {
    try {
      const helper = SettingsDBHelper.getInstance();
      const rdbStore = await helper.getRdbStore();
      if (rdbStore !== undefined) {
        const predicates = new dataSharePredicates.DataSharePredicates();
        predicates.like('KEYWORD', `${prefix}%`);
        await rdbStore.delete(settingsDataConfig.TABLE_NAME, predicates);
      }
    } catch (e) {
      Log.warn(`Failed to clean test data with prefix: ${prefix}`);
    }
  }

  /**
   * 重置清理记录
   */
  static reset(): void {
    TestDataCleaner.cleanedKeys.clear();
  }
}

/**
 * 数据库操作助手
 */
export class DatabaseTestHelper {
  /**
   * 插入测试数据
   */
  static async insertTestData(key: string, value: string): Promise<number> {
    const helper = SettingsDBHelper.getInstance();
    const rdbStore = await helper.getRdbStore();
    if (rdbStore === undefined) {
      throw new Error('RdbStore is undefined');
    }
    const valuesBucket: relationalStore.ValuesBucket = {
      'KEYWORD': key,
      'VALUE': value
    };
    return await rdbStore.insert(settingsDataConfig.TABLE_NAME, valuesBucket);
  }

  /**
   * 查询测试数据
   */
  static async queryTestData(key: string): Promise<relationalStore.ResultSet> {
    const helper = SettingsDBHelper.getInstance();
    const rdbStore = await helper.getRdbStore();
    if (rdbStore === undefined) {
      throw new Error('RdbStore is undefined');
    }
    const predicates = new dataSharePredicates.DataSharePredicates();
    predicates.equalTo('KEYWORD', key);
    return await rdbStore.query(settingsDataConfig.TABLE_NAME, predicates, []);
  }

  /**
   * 更新测试数据
   */
  static async updateTestData(key: string, newValue: string): Promise<number> {
    const helper = SettingsDBHelper.getInstance();
    const rdbStore = await helper.getRdbStore();
    if (rdbStore === undefined) {
      throw new Error('RdbStore is undefined');
    }
    const predicates = new dataSharePredicates.DataSharePredicates();
    predicates.equalTo('KEYWORD', key);
    const valuesBucket: relationalStore.ValuesBucket = {
      'VALUE': newValue
    };
    return await rdbStore.update(settingsDataConfig.TABLE_NAME, valuesBucket, predicates);
  }

  /**
   * 删除测试数据
   */
  static async deleteTestData(key: string): Promise<number> {
    const helper = SettingsDBHelper.getInstance();
    const rdbStore = await helper.getRdbStore();
    if (rdbStore === undefined) {
      throw new Error('RdbStore is undefined');
    }
    const predicates = new dataSharePredicates.DataSharePredicates();
    predicates.equalTo('KEYWORD', key);
    return await rdbStore.delete(settingsDataConfig.TABLE_NAME, predicates);
  }

  /**
   * 验证数据存在
   */
  static async assertDataExists(key: string): Promise<boolean> {
    const resultSet = await DatabaseTestHelper.queryTestData(key);
    return resultSet.rowCount >= 1;
  }

  /**
   * 验证数据不存在
   */
  static async assertDataNotExists(key: string): Promise<boolean> {
    const resultSet = await DatabaseTestHelper.queryTestData(key);
    return resultSet.rowCount === 0;
  }
}

/**
 * 测试断言助手
 */
export class TestAssertions {
  /**
   * 安全执行测试，捕获异常
   */
  static async safeExecute(action: () => Promise<void>): Promise<boolean> {
    try {
      await action();
      return true;
    } catch (e) {
      return false;
    }
  }

  /**
   * 验证操作应该成功（不抛异常）
   */
  static async shouldSucceed(action: () => Promise<void>): Promise<boolean> {
    return await TestAssertions.safeExecute(action);
  }

  /**
   * 验证操作应该失败（抛异常）
   */
  static async shouldFail(action: () => Promise<void>): Promise<boolean> {
    try {
      await action();
      return false;
    } catch (e) {
      return true;
    }
  }

  /**
   * 增强断言：验证操作成功并返回详细错误信息
   */
  static async assertOperationSuccess(
    action: () => Promise<void>, 
    errorMessage: string = '操作应该成功'
  ): Promise<void> {
    try {
      await action();
    } catch (error) {
      throw new Error(`${errorMessage}: ${error.message}`);
    }
  }

  /**
   * 增强断言：验证操作失败并返回详细错误信息
   */
  static async assertOperationFailure(
    action: () => Promise<void>, 
    expectedError: string = '',
    errorMessage: string = '操作应该失败'
  ): Promise<void> {
    try {
      await action();
      throw new Error(`${errorMessage}: 期望操作失败，但操作成功完成`);
    } catch (error) {
      if (expectedError && !error.message.includes(expectedError)) {
        throw new Error(`${errorMessage}: 期望错误包含'${expectedError}'，但实际错误为'${error.message}'`);
      }
    }
  }

  /**
   * 验证数据相等性
   */
  static assertDataEquals(expected: object | string | number | boolean | null, actual: object | string | number | boolean | null, message: string = '数据应该相等'): void {
    if (JSON.stringify(expected) !== JSON.stringify(actual)) {
      throw new Error(`${message}: 期望 ${JSON.stringify(expected)}，实际 ${JSON.stringify(actual)}`);
    }
  }

  /**
   * 验证数据包含特定值
   */
  static assertDataContains(data: string, expectedSubstring: string, message: string = '数据应该包含特定值'): void {
    if (!data.includes(expectedSubstring)) {
      throw new Error(`${message}: 数据'${data}'不包含'${expectedSubstring}'`);
    }
  }

  /**
   * 验证数据长度
   */
  static assertDataLength(data: object[], expectedLength: number, message: string = '数据长度应该正确'): void {
    if (data.length !== expectedLength) {
      throw new Error(`${message}: 期望长度 ${expectedLength}，实际长度 ${data.length}`);
    }
  }

  /**
   * 验证性能指标
   */
  static assertPerformance(actualTime: number, maxAllowedTime: number, operation: string = '操作'): void {
    if (actualTime > maxAllowedTime) {
      throw new Error(`${operation}性能不达标: 实际耗时 ${actualTime}ms，最大允许耗时 ${maxAllowedTime}ms`);
    }
  }

  /**
   * 验证并发操作结果
   */
  static assertConcurrentResults(results: boolean[], expectedSuccessCount: number, operation: string = '并发操作'): void {
    const successCount = results.filter(result => result).length;
    if (successCount !== expectedSuccessCount) {
      throw new Error(`${operation}并发结果异常: 期望成功 ${expectedSuccessCount} 次，实际成功 ${successCount} 次`);
    }
  }
}

/**
 * 测试数据生成器
 */
export class TestDataGenerator {
  /**
   * 生成唯一的测试 key
   */
  static generateTestKey(prefix: string = 'test'): string {
    return `${prefix}_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
  }

  /**
   * 生成测试数据条目
   */
  static generateTestEntry(key: string, value: string): Map<string, string> {
    const entry: Map<string, string> = new Map<string, string>();
    entry.set('name', key);
    entry.set('value', value);
    return entry;
  }

  /**
   * 批量生成测试数据
   */
  static generateTestEntries(count: number, prefix: string = 'test'): Map<string, string>[] {
    const entries: Map<string, string>[] = [];
    for (let i = 0; i < count; i++) {
      entries.push(TestDataGenerator.generateTestEntry(`${prefix}_${i}`, `${prefix}_value_${i}`));
    }
    return entries;
  }

  /**
   * 生成边界值测试数据
   */
  static generateBoundaryValues(): string[] {
    return [
      '', // 空字符串
      'a'.repeat(1024), // 长字符串
      'test\nvalue', // 包含换行符
      'test\tvalue', // 包含制表符
      'test\"value', // 包含引号
      'test\\value', // 包含反斜杠
      'test\u0000value', // 包含空字符
      'test\u2028value', // 包含行分隔符
      'test\u2029value', // 包含段落分隔符
      'test\uD83D\uDE00value' // 包含emoji
    ];
  }

  /**
   * 生成特殊字符测试数据
   */
  static generateSpecialCharacters(): string[] {
    return [
      '!@#$%^&*()',
      '[]{}<>',
      ';:,./?',
      '`~|',
      '±§',
      '中文测试',
      'русский',
      'العربية',
      '🎯📱💻'
    ];
  }

  /**
   * 生成数值边界测试数据
   */
  static generateNumericBoundaries(): string[] {
    return [
      '0',
      '1',
      '-1',
      '2147483647', // INT_MAX
      '-2147483648', // INT_MIN
      '999999999999',
      '-999999999999',
      '0.1',
      '-0.1',
      '3.141592653589793'
    ];
  }

  /**
   * 生成随机测试数据
   */
  static generateRandomData(count: number = 10): Map<string, string>[] {
    const entries: Map<string, string>[] = [];
    const types = ['string', 'number', 'boolean', 'null', 'object'];
    
    for (let i = 0; i < count; i++) {
      const type = types[Math.floor(Math.random() * types.length)];
      let value: string;
      
      switch (type) {
        case 'string':
          value = `random_string_${Math.random().toString(36).substr(2, 8)}`;
          break;
        case 'number':
          value = Math.floor(Math.random() * 1000).toString();
          break;
        case 'boolean':
          value = Math.random() > 0.5 ? 'true' : 'false';
          break;
        case 'null':
          value = 'null';
          break;
        default:
          value = `{\"key\":\"value_${i}\"}`;
      }
      
      entries.push(TestDataGenerator.generateTestEntry(`random_key_${i}`, value));
    }
    
    return entries;
  }
}
