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
 * @file BaseMockController.ets
 * @overview Mock控制器基类，提供通用的Mock功能和工具方法，减少代码重复
 * @category test_infrastructure
 */

/**
 * 测试结果接口
 */
export interface BaseTestResult {
  success: boolean;
  timestamp: number;
  duration?: number;
  error?: string;
}

/**
 * 性能指标数据
 */
export interface MetricData {
  name: string;
  value: number;
  timestamp: number;
}

/**
 * 操作耗时结果接口
 */
export interface OperationResult<T> {
  result: T;
  duration: number;
}

/**
 * Mock控制器基类
 * 提供通用的Mock功能，包括：
 * - 指标记录和查询
 * - 测试结果管理
 * - 时间模拟
 * - 错误模拟
 */
export abstract class BaseMockController {
  protected metrics: Map<string, MetricData[]> = new Map();
  protected testResults: BaseTestResult[] = [];
  protected startTime: number = Date.now();

  /**
   * 记录性能指标
   */
  protected recordMetric(name: string, value: number): void {
    const metric: MetricData = {
      name,
      value,
      timestamp: Date.now()
    };

    if (!this.metrics.has(name)) {
      this.metrics.set(name, []);
    }
    this.metrics.get(name)!.push(metric);
  }

  /**
   * 获取指标平均值
   */
  protected getMetricAverage(name: string): number {
    const metrics = this.metrics.get(name);
    if (!metrics || metrics.length === 0) {
      return 0;
    }
    const sum = metrics.reduce((acc: number, m: MetricData) => acc + m.value, 0);
    return sum / metrics.length;
  }

  /**
   * 获取指标最大值
   */
  protected getMetricMax(name: string): number {
    const metrics = this.metrics.get(name);
    if (!metrics || metrics.length === 0) {
      return 0;
    }
    return Math.max(...metrics.map((m: MetricData) => m.value));
  }

  /**
   * 记录测试结果
   */
  protected recordTestResult(result: BaseTestResult): void {
    this.testResults.push(result);
  }

  /**
   * 获取测试成功率
   */
  getSuccessRate(): number {
    if (this.testResults.length === 0) {
      return 0;
    }
    const successCount = this.testResults.filter((r: BaseTestResult) => r.success).length;
    return (successCount / this.testResults.length) * 100;
  }

  /**
   * 模拟异步延迟
   */
  protected async simulateDelay(ms: number): Promise<void> {
    await new Promise<void>(resolve => setTimeout(resolve, ms));
  }

  /**
   * 模拟操作耗时
   */
  protected async simulateOperation(baseTime: number, variance: number = 0): Promise<number> {
    const actualTime = baseTime + (Math.random() * variance - variance / 2);
    await this.simulateDelay(Math.max(0, actualTime));
    return actualTime;
  }

  /**
   * 计算操作耗时
   */
  protected async measureOperation<T>(operation: () => Promise<T>): Promise<OperationResult<T>> {
    const start = Date.now();
    const result = await operation();
    const duration = Date.now() - start;
    const operationResult: OperationResult<T> = { result, duration };
    return operationResult;
  }

  /**
   * 安全执行操作（带错误处理）
   */
  protected async safeExecute<T>(operation: () => Promise<T>, fallback: T): Promise<T> {
    try {
      return await operation();
    } catch (error) {
      const errorMessage = (error as Error).message || 'Unknown error';
      console.error(`[BaseMockController] Operation failed: ${errorMessage}`);
      return fallback;
    }
  }

  /**
   * 生成唯一ID
   */
  protected generateId(prefix: string = 'test'): string {
    return `${prefix}_${Date.now()}_${Math.random().toString(36).substring(2, 9)}`;
  }

  /**
   * 计算百分比
   */
  protected calculatePercentage(part: number, total: number): number {
    if (total === 0) {
      return 0;
    }
    return (part / total) * 100;
  }

  /**
   * 限制数值范围
   */
  protected clamp(value: number, min: number, max: number): number {
    return Math.max(min, Math.min(max, value));
  }

  /**
   * 获取运行时间
   */
  getElapsedTime(): number {
    return Date.now() - this.startTime;
  }

  /**
   * 清理资源
   */
  cleanup(): void {
    this.metrics.clear();
    this.testResults = [];
    this.startTime = Date.now();
  }
}
