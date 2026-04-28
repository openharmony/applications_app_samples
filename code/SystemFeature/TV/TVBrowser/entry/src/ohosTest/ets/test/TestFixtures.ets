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
 * @file TestFixtures.ets
 * @overview 测试数据工厂，集中管理测试数据和测试场景
 * @category test_fixtures
 */

import { TestData } from './TestConstants';

/**
 * 通用数据类型
 */
export interface GenericData {
  value: string | number | boolean | Record<string, string | number | boolean>;
}

/**
 * 测试用户数据
 */
export interface TestUserData {
  username: string;
  password: string;
  email: string;
}

/**
 * 威胁场景数据
 */
export interface ThreatScenario {
  activity: string;
  data: string;
}

/**
 * 标签页状态数据
 */
export interface TabState {
  url: string;
  title: string;
  loading: boolean;
  progress: number;
}

/**
 * 导航历史条目
 */
export interface NavigationHistoryEntry {
  url: string;
  timestamp: number;
}

/**
 * 缓存配置选项
 */
export interface CacheOptions {
  ttl: number;
}

/**
 * 缓存条目
 */
export interface CacheEntry {
  value: GenericData;
  timestamp: number;
  ttl: number;
}

/**
 * 会话数据项
 */
export interface SessionDataItem {
  key: string;
  value: string;
}

/**
 * 性能测试配置
 */
export interface PerformanceTestConfig {
  metric: string;
  value: number;
  expected: boolean;
  severity: string;
}

/**
 * 安全策略数据
 */
export interface SecurityPolicy {
  name: string;
  rules: SecurityRule[];
  description?: string;
  version?: string;
  enforcement?: string;
  requiresContext?: boolean;
  restrictions?: string[];
}

/**
 * 安全规则
 */
export interface SecurityRule {
  condition: string;
  action: string;
}

/**
 * 通用测试结果接口
 */
export interface BaseTestResult {
  success: boolean;
  issues?: string[];
  recommendations?: string[];
}

/**
 * 兼容性测试结果接口
 */
export interface CompatibilityTestResult {
  test: string;
  environment: string;
  result: string;
  details: string;
  compatible?: boolean;
  issues?: string[];
  recommendations?: string[];
}

/**
 * 性能测试结果接口
 */
export interface PerformanceTestResult {
  metric: string;
  value: number;
  threshold: number;
  passed: boolean;
}

/**
 * 资源使用数据接口
 */
export interface ResourceUsage {
  cpu: number;
  memory: number;
  network?: number;
}

/**
 * 资源指标数据接口
 */
export interface ResourceMetric {
  min: number;
  max: number;
  average: number;
}

/**
 * 测试场景数据接口
 */
export interface TestScenario {
  name: string;
  parameters: Record<string, string | number | boolean>;
  expectedResult: string;
  result?: string;
}

/**
 * 边界范围数据接口
 */
export interface BoundaryRange {
  min: number;
  max: number;
  typical: number;
}

/**
 * 异常流数据接口
 */
export interface ExceptionFlow {
  flowType: string;
  handled: boolean;
  recoveryTime: number;
}

/**
 * 并发测试数据接口
 */
export interface ConcurrentTest {
  testName: string;
  concurrency: number;
  successRate: number;
}

/**
 * 事务日志数据接口
 */
export interface TransactionLog {
  id: string;
  operation: string;
  timestamp: number;
  status: string;
}

/**
 * 冲突解决数据接口
 */
export interface ConflictResolution {
  conflictType: string;
  resolution: string;
  timestamp: number;
}

/**
 * 备份状态数据接口
 */
export interface BackupState {
  backupTime: number;
  dataSize: number;
  integrity: boolean;
}

/**
 * 屏幕尺寸信息接口
 */
export interface ScreenSizeInfo {
  width: number;
  height: number;
  density: number;
}

/**
 * 网络请求结果接口
 */
export interface NetworkRequestResult {
  success: boolean;
  statusCode?: number;
  error?: string;
}

/**
 * 网络统计信息接口
 */
export interface NetworkStatistics {
  totalRequests: number;
  failedRequests: number;
  averageLatency: number;
}

/**
 * 按钮状态接口
 */
export interface ButtonStates {
  back: boolean;
  forward: boolean;
  refresh: boolean;
  home: boolean;
}

/**
 * 组件状态接口
 */
export interface ComponentState {
  focused: boolean;
  pressed: boolean;
  visible: boolean;
  enabled: boolean;
}

/**
 * 验证结果接口
 */
export interface ValidationResult {
  valid: boolean;
  errors?: string[];
  validationPassed?: boolean;
  overallScore?: number;
  failedCriteria?: string[];
  validationReport?: ValidationReport;
}

/**
 * 验证报告接口
 */
export interface ValidationReport {
  validationType: string;
  timestamp: number;
  totalCriteria: number;
  failedCriteriaCount: number;
  overallScore: number;
  status: string;
  error?: string;
}

/**
 * 测试数据工厂类
 * 提供统一的测试数据创建和管理
 */
export class TestFixtureFactory {
  /**
   * 创建默认测试用户数据
   */
  static createDefaultUser(): TestUserData {
    return {
      username: TestData.TEST_USER.username,
      password: TestData.TEST_USER.password,
      email: TestData.TEST_USER.email
    };
  }

  /**
   * 创建自定义测试用户数据
   */
  static createCustomUser(username: string, password: string, email: string): TestUserData {
    return { username, password, email };
  }

  /**
   * 创建恶意输入测试数据集
   */
  static createMaliciousInputs(): string[] {
    return TestData.MALICIOUS_INPUTS.slice();
  }

  /**
   * 创建威胁场景数据集
   */
  static createThreatScenarios(): ThreatScenario[] {
    return TestData.THREAT_SCENARIOS.map(scenario => {
      const threatScenario: ThreatScenario = {
        activity: scenario.activity,
        data: scenario.data
      };
      return threatScenario;
    });
  }

  /**
   * 创建权限测试数据集
   */
  static createTestPermissions(): string[] {
    return TestData.TEST_PERMISSIONS.slice();
  }

  /**
   * 创建漏洞扫描类型数据集
   */
  static createScanTypes(): string[] {
    return TestData.SCAN_TYPES.slice();
  }

  /**
   * 创建标签页状态数据
   */
  static createTabState(url: string, title: string, loading: boolean = false, progress: number = 0): TabState {
    return {
      url,
      title,
      loading,
      progress
    };
  }

  /**
   * 创建导航历史条目
   */
  static createNavigationEntry(url: string, timestamp: number): NavigationHistoryEntry {
    return { url, timestamp };
  }

  /**
   * 创建缓存条目
   */
  static createCacheEntry(value: string | number | boolean | Record<string, string | number | boolean>,
    ttl: number): CacheEntry {
    return {
      value: { value },
      timestamp: Date.now(),
      ttl
    };
  }

  /**
   * 创建会话数据项
   */
  static createSessionItem(index: number): SessionDataItem {
    return {
      key: `item_${index}`,
      value: `value_${index}`
    };
  }

  /**
   * 批量创建会话数据
   */
  static createSessionBatch(count: number): SessionDataItem[] {
    const items: SessionDataItem[] = [];
    for (let i = 0; i < count; i++) {
      items.push(TestFixtureFactory.createSessionItem(i));
    }
    return items;
  }

  /**
   * 创建性能测试配置
   */
  static createPerformanceTests(): PerformanceTestConfig[] {
    const config1: PerformanceTestConfig = {
      metric: 'startup_time',
      value: 2500,
      expected: true,
      severity: 'normal'
    };
    const config2: PerformanceTestConfig = {
      metric: 'memory_usage',
      value: 150,
      expected: false,
      severity: 'warning'
    };
    const config3: PerformanceTestConfig = {
      metric: 'cpu_usage',
      value: 75,
      expected: true,
      severity: 'normal'
    };

    return [config1, config2, config3];
  }

  /**
   * 创建安全策略数据
   */
  static createTestSecurityPolicy(): SecurityPolicy {
    const securityRule1: SecurityRule = { condition: 'user.role === "admin"', action: 'grant_access' };
    const securityRule2: SecurityRule = { condition: 'request.origin === "trusted"', action: 'allow' };

    const policy: SecurityPolicy = {
      name: 'Test Security Policy',
      rules: [securityRule1, securityRule2],
      description: 'Test policy for validation',
      version: '1.0.0',
      enforcement: 'strict',
      requiresContext: false,
      restrictions: []
    };
    return policy;
  }

  /**
   * 创建URL测试数据集
   */
  static createUrlTestData(): UrlTestData {
    const validUrls: string[] = [
      'https://example.com',
      'http://localhost:8080',
      'https://www.huawei.com'
    ];
    const invalidUrls: string[] = [
      '',
      'not-a-url',
      'ftp://invalid',
      'javascript:alert(1)'
    ];

    const urlTestData: UrlTestData = {
      valid: validUrls,
      invalid: invalidUrls
    };
    return urlTestData;
  }

  /**
   * 创建混沌测试故障类型数据集
   */
  static createChaosFaultTypes(): ChaosFaultTypes {
    const networkFaults: string[] = ['latency', 'packet_loss', 'dns_failure', 'connection_timeout'];
    const memoryFaults: string[] = ['leak', 'pressure', 'fragmentation'];
    const cpuFaults: string[] = ['overload', 'throttling', 'spike'];
    const storageFaults: string[] = ['full', 'corrupted', 'slow_io'];

    const faultTypes: ChaosFaultTypes = {
      network: networkFaults,
      memory: memoryFaults,
      cpu: cpuFaults,
      storage: storageFaults
    };
    return faultTypes;
  }

  /**
   * 创建系统恢复测试场景
   */
  static createRecoveryScenarios(): RecoveryScenario[] {
    const scenario1: RecoveryScenario = { crashType: ['crash'], recoveryMode: ['auto_recovery'] };
    const scenario2: RecoveryScenario = { crashType: ['freeze'], recoveryMode: ['manual_recovery'] };
    const scenario3: RecoveryScenario = { crashType: ['memory_leak'], recoveryMode: ['gc_recovery'] };

    return [scenario1, scenario2, scenario3];
  }
}

/**
 * URL测试数据集接口
 */
export interface UrlTestData {
  valid: string[];
  invalid: string[];
}

/**
 * 混沌测试故障类型数据集接口
 */
export interface ChaosFaultTypes {
  network: string[];
  memory: string[];
  cpu: string[];
  storage: string[];
}

/**
 * 系统恢复测试场景接口
 */
export interface RecoveryScenario {
  crashType: string[];
  recoveryMode: string[];
}
