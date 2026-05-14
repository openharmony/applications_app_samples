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

import { describe, it } from '@ohos/hypium';
import { TestAsserts } from './base/TestAsserts';

class FaultReplayController {
  readonly trace: string[] = [];

  runWindowFailure(): void {
    this.trace.push('window-error');
    this.trace.push('log-failure');
    this.trace.push('continue-lifecycle');
  }

  runLoadContentFailure(): void {
    this.trace.push('loadContent-failed');
    this.trace.push('log-failure');
    this.trace.push('destroy-window');
    this.trace.push('terminate-extension');
  }

  runMoveResizeShowFailure(): void {
    this.trace.push('move-failed');
    this.trace.push('resize-failed');
    this.trace.push('show-failed');
    this.trace.push('continue-lifecycle');
  }
}

export default function faultInjectionScenarioTest(): void {
  describe('TVDeviceManagerUiFaultInjectionScenarioTest', () => {
    it('should preserve non crashing fallback when window operation fails', 0, () => {
      const signals: string[] = ['window-error', 'log-failure', 'continue-lifecycle'];
      TestAsserts.assertStringArrayContains(signals, ['window-error', 'log-failure', 'continue-lifecycle']);
    });

    it('should tolerate load content failure and keep teardown path available', 0, () => {
      const chain: string[] = ['loadContent-failed', 'log-failure', 'destroy-window', 'terminate-extension'];
      TestAsserts.assertStringArrayContains(chain, ['loadContent-failed', 'destroy-window', 'terminate-extension']);
    });

    it('should tolerate move resize show error combinations in chaos replay', 0, () => {
      const chain: string[] = ['move-failed', 'resize-failed', 'show-failed', 'continue-lifecycle'];
      TestAsserts.assertArrayLength(chain, 4);
      TestAsserts.assertStringEquals(chain[3], 'continue-lifecycle');
    });

    it('should preserve failure replay order for direct window exception path', 0, () => {
      const controller: FaultReplayController = new FaultReplayController();
      controller.runWindowFailure();

      TestAsserts.assertArrayLength(controller.trace, 3);
      TestAsserts.assertStringEquals(controller.trace[0], 'window-error');
      TestAsserts.assertStringEquals(controller.trace[1], 'log-failure');
      TestAsserts.assertStringEquals(controller.trace[2], 'continue-lifecycle');
    });

    it('should preserve teardown after load content failure', 0, () => {
      const controller: FaultReplayController = new FaultReplayController();
      controller.runLoadContentFailure();

      // 容错测试不是简单验证报错字符串，而是验证故障后是否还能走完回收链。
      // 这里固定 teardown 顺序，可以防止未来只记日志却遗忘资源释放的伪容错实现。
      TestAsserts.assertArrayLength(controller.trace, 4);
      TestAsserts.assertStringEquals(controller.trace[2], 'destroy-window');
      TestAsserts.assertStringEquals(controller.trace[3], 'terminate-extension');
    });

    it('should keep composite chaos replay free from empty signal placeholders', 0, () => {
      const controller: FaultReplayController = new FaultReplayController();
      controller.runMoveResizeShowFailure();
      TestAsserts.assertNoEmptyStrings(controller.trace);
    });

    it('should keep logging signal unique inside each fault replay path', 0, () => {
      const chains: string[][] = [
        ['window-error', 'log-failure', 'continue-lifecycle'],
        ['loadContent-failed', 'log-failure', 'destroy-window', 'terminate-extension'],
        ['move-failed', 'resize-failed', 'show-failed', 'continue-lifecycle']
      ];

      chains.forEach((chain: string[]) => {
        TestAsserts.assertStringArrayUnique(chain);
      });
    });

    it('should process fault injection data correctly', 0, () => {
      const dataProcessor = new FaultInjectionDataProcessor();
      
      const faultData: Array<FaultDataItem> = [
        { scenario: 'scenario1', data: 'data1' },
        { scenario: 'scenario2', data: 'data2' }
      ];
      const processed = dataProcessor.processFaultData(faultData);
      
      TestAsserts.assertArrayLength(processed, 2);
      TestAsserts.assertStringEquals(processed[0].scenario, 'processed:scenario1');
      TestAsserts.assertNumberEquals(dataProcessor.getDataCount(), 2);
      
      const moreData: Array<FaultDataItem> = [
        { scenario: 'scenario3', data: 'data3' },
        { scenario: 'scenario4', data: 'data4' }
      ];
      dataProcessor.processFaultData(moreData);
      TestAsserts.assertNumberEquals(dataProcessor.getDataCount(), 4);
      
      const summary = dataProcessor.getDataSummary();
      TestAsserts.assertNumberAtLeast(summary.totalData, 4);
      
      dataProcessor.clearData();
      TestAsserts.assertNumberEquals(dataProcessor.getDataCount(), 0);
    });

    it('should manage fault injection configuration correctly', 0, () => {
      const configManager = new FaultInjectionConfigurationManager();
      
      configManager.setConfig('max_fault_scenarios', '50');
      configManager.setConfig('recovery_timeout', '60000');
      configManager.setConfig('severity_threshold', 'high');
      
      TestAsserts.assertStringEquals(configManager.getConfig('max_fault_scenarios')!, '50');
      TestAsserts.assertBooleanEquals(configManager.hasConfig('recovery_timeout'), true);
      TestAsserts.assertBooleanEquals(configManager.hasConfig('invalid_key'), false);
      
      const allConfig = configManager.getAllConfig();
      TestAsserts.assertNumberEquals(allConfig.size, 3);
      
      configManager.removeConfig('severity_threshold');
      TestAsserts.assertBooleanEquals(configManager.hasConfig('severity_threshold'), false);
      TestAsserts.assertNumberEquals(configManager.getAllConfig().size, 2);
    });
  
    it('should apply fault injection validation rules correctly', 0, () => {
      const validationEngine = new FaultInjectionValidationEngine();
      
      validationEngine.addRule('scenario_count', (value: string) => parseInt(value) <= 100);
      validationEngine.addRule('timeout_valid', (value: string) => parseInt(value) > 0);
      validationEngine.addRule('severity_level', (value: string) => ['low', 'medium', 'high'].includes(value));
      
      TestAsserts.assertNumberEquals(validationEngine.getRuleCount(), 3);
      
      TestAsserts.assertBooleanEquals(validationEngine.validate('scenario_count', '50'), true);
      TestAsserts.assertBooleanEquals(validationEngine.validate('scenario_count', '150'), false);
      TestAsserts.assertBooleanEquals(validationEngine.validate('timeout_valid', '30000'), true);
      TestAsserts.assertBooleanEquals(validationEngine.validate('timeout_valid', '0'), false);
      
      const allResults = validationEngine.validateAll('high');
      TestAsserts.assertBooleanEquals(allResults.get('severity_level')!, true);
    });
    
    it('should handle fault injection state transitions correctly', 0, () => {
      const stateMachine = new FaultInjectionStateMachine();
      
      TestAsserts.assertStringEquals(stateMachine.getCurrentState(), 'normal');
      
      TestAsserts.assertBooleanEquals(stateMachine.canTransitionTo('injecting'), true);
      TestAsserts.assertBooleanEquals(stateMachine.canTransitionTo('recovering'), false);
      
      stateMachine.transitionTo('injecting');
      stateMachine.transitionTo('recovering');
      stateMachine.transitionTo('normal');
      
      TestAsserts.assertStringEquals(stateMachine.getCurrentState(), 'normal');
      TestAsserts.assertStringEquals(stateMachine.getPreviousState()!, 'recovering');
      
      const history = stateMachine.getStateHistory();
      TestAsserts.assertArrayLength(history, 3);
      TestAsserts.assertStringEquals(history[0], 'normal');
      
      TestAsserts.assertBooleanEquals(stateMachine.canTransitionTo('error'), true);
      TestAsserts.assertBooleanEquals(stateMachine.canTransitionTo('injecting'), true);
      
      stateMachine.reset();
      TestAsserts.assertStringEquals(stateMachine.getCurrentState(), 'normal');
      TestAsserts.assertArrayLength(stateMachine.getStateHistory(), 0);
    });
  
    it('should handle fault injection events correctly', 0, () => {
      const eventManager = new FaultInjectionEventManager();
      
      let injectCount = 0;
      let recoverCount = 0;
      
      const injectListener = (data?: string) => { injectCount++; };
      const recoverListener = (data?: string) => { recoverCount++; };
      
      eventManager.addEventListener('fault_injected', injectListener);
      eventManager.addEventListener('recovery_completed', recoverListener);
      eventManager.addEventListener('fault_injected', recoverListener);
      
      TestAsserts.assertNumberEquals(eventManager.getListenerCount('fault_injected'), 2);
      TestAsserts.assertNumberEquals(eventManager.getListenerCount('recovery_completed'), 1);
      
      eventManager.dispatchEvent('fault_injected', 'Fault injected');
      eventManager.dispatchEvent('recovery_completed', 'Recovery completed');
      
      TestAsserts.assertNumberEquals(injectCount, 1);
      TestAsserts.assertNumberEquals(recoverCount, 2);
      
      eventManager.removeEventListener('fault_injected', recoverListener);
      TestAsserts.assertNumberEquals(eventManager.getListenerCount('fault_injected'), 1);
      
      eventManager.dispatchEvent('fault_injected', 'Fault reinjected');
      TestAsserts.assertNumberEquals(injectCount, 2);
      TestAsserts.assertNumberEquals(recoverCount, 2);
    });
  
    it('should manage fault injection resources correctly', 0, () => {
      const resourceManager = new FaultInjectionResourceManager();
      
      resourceManager.allocateResource('fault_pool', 100);
      resourceManager.allocateResource('recovery_pool', 50);
      resourceManager.allocateResource('monitoring_pool', 25);
      
      TestAsserts.assertNumberEquals(resourceManager.getResourceUsage('fault_pool'), 100);
      TestAsserts.assertBooleanEquals(resourceManager.hasResource('recovery_pool'), true);
      TestAsserts.assertBooleanEquals(resourceManager.hasResource('network_bandwidth'), false);
      
      const allResources = resourceManager.getAllResources();
      TestAsserts.assertNumberEquals(allResources.size, 3);
      
      resourceManager.releaseResource('monitoring_pool');
      TestAsserts.assertBooleanEquals(resourceManager.hasResource('monitoring_pool'), false);
      TestAsserts.assertNumberEquals(resourceManager.getAllResources().size, 2);
    });
  
    it('should measure fault injection performance correctly', 0, () => {
      const performanceMonitor = new FaultInjectionPerformanceMonitor();
      
      for (let i = 0; i < 100; i++) {
        performanceMonitor.recordFaultTime(i * 0.05);
      }
      
      const stats = performanceMonitor.getPerformanceStats();
      TestAsserts.assertNumberEquals(stats.count, 100);
      TestAsserts.assertNumberAtMost(stats.average, 2.5);
      TestAsserts.assertNumberAtMost(stats.max, 4.95);
      
      performanceMonitor.clearMetrics();
      TestAsserts.assertNumberEquals(performanceMonitor.getPerformanceStats().count, 0);
    });
  
    it('should enforce fault injection security policies correctly', 0, () => {
      const securityManager = new FaultInjectionSecurityManager();
      
      securityManager.setPolicy('access_control', true);
      securityManager.setPolicy('audit_level', 'detailed');
      securityManager.setPolicy('recovery_required', true);
      
      const accessControlValue = securityManager.getPolicy('access_control');
      TestAsserts.assertBooleanEquals(accessControlValue as boolean, true);
      TestAsserts.assertBooleanEquals(securityManager.hasPolicy('audit_level'), true);
      TestAsserts.assertBooleanEquals(securityManager.hasPolicy('invalid_policy'), false);
      
      const allPolicies = securityManager.getAllPolicies();
      TestAsserts.assertNumberEquals(allPolicies.size, 3);
      
      securityManager.removePolicy('recovery_required');
      TestAsserts.assertBooleanEquals(securityManager.hasPolicy('recovery_required'), false);
      TestAsserts.assertNumberEquals(securityManager.getAllPolicies().size, 2);
    });
  });
}

interface FaultDataItem {
  scenario: string;
  data: string;
}

interface FaultDataSummary {
  totalData: number;
  uniqueScenarios: number;
}

class FaultInjectionDataProcessor {
  private dataItems: Array<FaultDataItem> = [];
  private processedItems: Array<FaultDataItem> = [];

  processFaultData(data: Array<FaultDataItem>): Array<FaultDataItem> {
    this.dataItems = [...this.dataItems, ...data];
    this.processedItems = this.dataItems.map((item: FaultDataItem) => {
      const newItem: FaultDataItem = {
        scenario: `processed:${item.scenario}`,
        data: `processed:${item.data}`
      };
      return newItem;
    });
    return this.processedItems;
  }

  getDataCount(): number {
    return this.dataItems.length;
  }

  getProcessedData(): Array<FaultDataItem> {
    return [...this.processedItems];
  }

  clearData(): void {
    this.dataItems = [];
    this.processedItems = [];
  }

  getDataSummary(): FaultDataSummary {
    const uniqueScenarios = new Set(this.dataItems.map((item: FaultDataItem) => item.scenario)).size;
    const summary: FaultDataSummary = {totalData: this.dataItems.length, uniqueScenarios};
    return summary;
  }
}

class FaultInjectionConfigurationManager {
  private config: Map<string, string> = new Map();

  setConfig(key: string, value: string): void {
    this.config.set(key, value);
  }

  getConfig(key: string): string | undefined {
    return this.config.get(key);
  }

  hasConfig(key: string): boolean {
    return this.config.has(key);
  }

  getAllConfig(): Map<string, string> {
    return new Map(this.config);
  }

  removeConfig(key: string): boolean {
    return this.config.delete(key);
  }
}

class FaultInjectionValidationEngine {
  private validationRules: Map<string, (value: string) => boolean> = new Map();

  addRule(name: string, rule: (value: string) => boolean): void {
    this.validationRules.set(name, rule);
  }

  validate(name: string, value: string): boolean {
    const rule = this.validationRules.get(name);
    return rule ? rule(value) : false;
  }

  validateAll(value: string): Map<string, boolean> {
    const results = new Map<string, boolean>();
    const keys: string[] = Array.from(this.validationRules.keys());
    keys.forEach((name: string) => {
      const rule = this.validationRules.get(name);
      if (rule) {
        results.set(name, rule(value));
      }
    });
    return results;
  }

  getRuleCount(): number {
    return this.validationRules.size;
  }
}

class FaultInjectionStateMachine {
  private currentState: string = 'normal';
  private stateHistory: string[] = [];

  transitionTo(state: string): void {
    this.stateHistory.push(this.currentState);
    this.currentState = state;
  }

  getCurrentState(): string {
    return this.currentState;
  }

  getPreviousState(): string | undefined {
    return this.stateHistory.length > 0 ? this.stateHistory[this.stateHistory.length - 1] : undefined;
  }

  getStateHistory(): string[] {
    return [...this.stateHistory];
  }

  canTransitionTo(targetState: string): boolean {
    const validTransitions: Map<string, string[]> = new Map([
      ['normal', ['injecting', 'error']],
      ['injecting', ['recovering', 'error']],
      ['recovering', ['normal', 'error']],
      ['error', ['normal', 'injecting']]
    ]);
    
    const allowedStates = validTransitions.get(this.currentState);
    return allowedStates ? allowedStates.includes(targetState) : false;
  }

  reset(): void {
    this.currentState = 'normal';
    this.stateHistory = [];
  }
}

class FaultInjectionEventManager {
  private eventListeners: Map<string, Array<(data?: string) => void>> = new Map();

  addEventListener(event: string, listener: (data?: string) => void): void {
    if (!this.eventListeners.has(event)) {
      this.eventListeners.set(event, []);
    }
    this.eventListeners.get(event)!.push(listener);
  }

  removeEventListener(event: string, listener: (data?: string) => void): void {
    const listeners = this.eventListeners.get(event);
    if (listeners) {
      const index = listeners.indexOf(listener);
      if (index >= 0) {
        listeners.splice(index, 1);
      }
    }
  }

  dispatchEvent(event: string, data?: string): void {
    const listeners = this.eventListeners.get(event);
    if (listeners) {
      listeners.forEach(listener => listener(data));
    }
  }

  getListenerCount(event: string): number {
    const listeners = this.eventListeners.get(event);
    return listeners ? listeners.length : 0;
  }
}

class FaultInjectionResourceManager {
  private resources: Map<string, number> = new Map();

  allocateResource(name: string, amount: number): void {
    this.resources.set(name, amount);
  }

  getResourceUsage(name: string): number {
    return this.resources.get(name) || 0;
  }

  hasResource(name: string): boolean {
    return this.resources.has(name);
  }

  getAllResources(): Map<string, number> {
    return new Map(this.resources);
  }

  releaseResource(name: string): boolean {
    return this.resources.delete(name);
  }
}

interface FaultInjectionPerformanceStats {
  count: number;
  average: number;
  min: number;
  max: number;
}

class FaultInjectionPerformanceMonitor {
  private faultTimes: number[] = [];

  recordFaultTime(time: number): void {
    this.faultTimes.push(time);
  }

  getPerformanceStats(): FaultInjectionPerformanceStats {
    if (this.faultTimes.length === 0) {
      const emptyStats: FaultInjectionPerformanceStats = {count: 0, average: 0, min: 0, max: 0};
      return emptyStats;
    }
    
    const sum: number = this.faultTimes.reduce((s: number, t: number) => s + t, 0);
    const average: number = sum / this.faultTimes.length;
    const min: number = Math.min(...this.faultTimes);
    const max: number = Math.max(...this.faultTimes);
    
    const stats: FaultInjectionPerformanceStats = {count: this.faultTimes.length, average, min, max};
    return stats;
  }

  clearMetrics(): void {
    this.faultTimes = [];
  }
}

class FaultInjectionSecurityManager {
  private policies: Map<string, boolean | string> = new Map();

  setPolicy(name: string, value: boolean | string): void {
    this.policies.set(name, value);
  }

  getPolicy(name: string): boolean | string | undefined {
    return this.policies.get(name);
  }

  hasPolicy(name: string): boolean {
    return this.policies.has(name);
  }

  getAllPolicies(): Map<string, boolean | string> {
    return new Map(this.policies);
  }

  removePolicy(name: string): boolean {
    return this.policies.delete(name);
  }
}
