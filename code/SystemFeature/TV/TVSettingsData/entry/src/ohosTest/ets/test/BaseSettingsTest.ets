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
 * @file BaseSettingsTest.ets
 * @overview 基础测试模板类，提供统一的测试框架和工具方法
 *           减少重复代码，提高测试代码的可维护性
 */

import { describe, it, expect, beforeAll, afterAll, beforeEach, afterEach } from '@ohos/hypium';
import { GlobalContext } from '../../../main/ets/Utils/GlobalContext';
import SettingsDBHelper from '../../../main/ets/Utils/SettingsDBHelper';
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
import { TestDataCleaner, DatabaseTestHelper, TestAssertions, TestDataGenerator } from './TestUtils';
import { Driver } from '@kit.TestKit';

/**
 * 基础设置测试抽象类
 */
export abstract class BaseSettingsTest {
  protected driver: Driver | null = null;
  protected abstract getTestPrefix(): string;

  /**
   * 设置测试环境
   */
  protected async setupTestEnvironment(): Promise<void> {
    SettingsDBHelper.resetInstance();
    TestDataCleaner.reset();

    this.driver = createFreshDriver();
    await pressAndWait(this.driver, KEY_HOME, 2, TIMEOUT_HOME);
    await waitForSurface(this.driver, 2, TIMEOUT_COLD_START);
    await waitForStableSurface(this.driver, STABLE_ROUNDS, STABLE_TOLERANCE, 2500);

    const ctx = GlobalContext.getContext();
    const abilityContext = getContext() as Context;
    ctx.setObject('abilityContext', abilityContext);
  }

  /**
   * 清理测试环境
   */
  protected async cleanupTestEnvironment(): Promise<void> {
    if (this.driver) {
      await pressAndWait(this.driver, KEY_HOME, 2, TIMEOUT_HOME);
      await waitForStableSurface(this.driver, STABLE_ROUNDS, STABLE_TOLERANCE, 2000);
    }
  }

  /**
   * 清理测试数据
   */
  protected async cleanupTestData(): Promise<void> {
    await TestDataCleaner.cleanTestDataByPrefix(this.getTestPrefix());
  }

  /**
   * 生成测试键
   */
  protected generateTestKey(suffix: string = ''): string {
    const baseKey = TestDataGenerator.generateTestKey(this.getTestPrefix());
    return suffix ? `${baseKey}_${suffix}` : baseKey;
  }

  /**
   * 插入测试数据
   */
  protected async insertTestData(key: string, value: string): Promise<number> {
    return await DatabaseTestHelper.insertTestData(key, value);
  }

  /**
   * 查询测试数据
   */
  protected async queryTestData(key: string): Promise<boolean> {
    return await DatabaseTestHelper.assertDataExists(key);
  }

  /**
   * 更新测试数据
   */
  protected async updateTestData(key: string, newValue: string): Promise<number> {
    return await DatabaseTestHelper.updateTestData(key, newValue);
  }

  /**
   * 删除测试数据
   */
  protected async deleteTestData(key: string): Promise<number> {
    return await DatabaseTestHelper.deleteTestData(key);
  }

  /**
   * 验证操作成功
   */
  protected async assertOperationSuccess(
    action: () => Promise<void>,
    errorMessage: string = '操作应该成功'
  ): Promise<void> {
    await TestAssertions.assertOperationSuccess(action, errorMessage);
  }

  /**
   * 验证操作失败
   */
  protected async assertOperationFailure(
    action: () => Promise<void>,
    expectedError: string = '',
    errorMessage: string = '操作应该失败'
  ): Promise<void> {
    await TestAssertions.assertOperationFailure(action, expectedError, errorMessage);
  }

  /**
   * 运行测试套件
   */
  public runTestSuite(): void {
    describe('BaseSettingsTest_Suite', () => {
      beforeAll(async () => {
        await this.setupTestEnvironment();
      });

      afterAll(async () => {
        await this.cleanupTestEnvironment();
      });

      beforeEach(async () => {
        TestDataCleaner.reset();
      });

      afterEach(async () => {
        await this.cleanupTestData();
      });

      // 调用子类实现的测试方法
      this.implementTests();
    });
  }

  /**
   * 子类必须实现的测试方法
   */
  protected abstract implementTests(): void;
}

/**
 * 数据操作测试模板类
 */
export abstract class DataOperationsTest extends BaseSettingsTest {
  /**
   * 测试数据插入
   */
  protected abstract testDataInsertion(): void;

  /**
   * 测试数据查询
   */
  protected abstract testDataQuery(): void;

  /**
   * 测试数据更新
   */
  protected abstract testDataUpdate(): void;

  /**
   * 测试数据删除
   */
  protected abstract testDataDeletion(): void;

  /**
   * 实现测试方法
   */
  protected implementTests(): void {
    this.testDataInsertion();
    this.testDataQuery();
    this.testDataUpdate();
    this.testDataDeletion();
  }
}

/**
 * 边界值测试模板类
 */
export abstract class BoundaryValueTest extends BaseSettingsTest {
  /**
   * 测试空值处理
   */
  protected abstract testEmptyValues(): void;

  /**
   * 测试超长值处理
   */
  protected abstract testLongValues(): void;

  /**
   * 测试特殊字符处理
   */
  protected abstract testSpecialCharacters(): void;

  /**
   * 实现测试方法
   */
  protected implementTests(): void {
    this.testEmptyValues();
    this.testLongValues();
    this.testSpecialCharacters();
  }
}

/**
 * 性能测试模板类
 */
export abstract class PerformanceTest extends BaseSettingsTest {
  /**
   * 测试批量操作性能
   */
  protected abstract testBatchOperations(): void;

  /**
   * 测试并发操作性能
   */
  protected abstract testConcurrentOperations(): void;

  /**
   * 测试查询性能
   */
  protected abstract testQueryPerformance(): void;

  /**
   * 实现测试方法
   */
  protected implementTests(): void {
    this.testBatchOperations();
    this.testConcurrentOperations();
    this.testQueryPerformance();
  }
}