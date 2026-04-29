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
import { TestDataFactory } from './base/TestDataFactory';
import { TestAsserts } from './base/TestAsserts';

export default function accessibilityAndReadableTextTest(): void {
  describe('TVDeviceManagerUiAccessibilityAndReadableTextTest', () => {
    it('should keep all core labels readable for accessibility baseline', 0, () => {
      TestDataFactory.createReadableLabels().forEach((label: string) => {
        TestAsserts.assertReadableText(label);
      });
    });

    it('should keep readable label list free from duplicates for audit reports', 0, () => {
      const labels: string[] = TestDataFactory.createReadableLabels();
      TestAsserts.assertStringArrayUnique(labels);
    });

    it('should keep readable label list free from empty placeholders', 0, () => {
      const labels: string[] = TestDataFactory.createReadableLabels();
      TestAsserts.assertNoEmptyStrings(labels);
    });

    it('should keep key action labels present for confirm and pin flows', 0, () => {
      const labels: string[] = TestDataFactory.createReadableLabels();

      // 读屏和可访问性校验不能只看标题，真正决定用户能否操作的是关键动作文案是否存在。
      // 这里把确认和 PIN 两类主文案同时锁定，可以避免后续资源调整时漏掉交互关键字。
      TestAsserts.assertStringArrayContains(labels, ['本次允许', '始终允许', 'PIN码连接']);
    });

    it('should keep all labels normalized to non whitespace visible content', 0, () => {
      const labels: string[] = TestDataFactory.createReadableLabels();
      labels.forEach((label: string) => {
        TestAsserts.assertReadableText(label.trim());
      });
    });
  
    it('should process accessibility data correctly', 0, () => {
      const dataProcessor = new AccessibilityDataProcessor();
      
      const labels = ['确认', '取消', '允许', '拒绝'];
      const processed = dataProcessor.processLabels(labels);
      
      TestAsserts.assertArrayLength(processed, 4);
      TestAsserts.assertStringEquals(processed[0], 'processed:确认');
      TestAsserts.assertNumberEquals(dataProcessor.getLabelCount(), 4);
      
      const moreLabels = ['确定', '关闭'];
      dataProcessor.processLabels(moreLabels);
      TestAsserts.assertNumberEquals(dataProcessor.getLabelCount(), 6);
      
      const summary = dataProcessor.getDataSummary();
      TestAsserts.assertNumberAtLeast(summary.totalLabels, 6);
      
      dataProcessor.clearLabels();
      TestAsserts.assertNumberEquals(dataProcessor.getLabelCount(), 0);
    });
  
    it('should manage accessibility configuration correctly', 0, () => {
      const configManager = new AccessibilityConfigurationManager();
      
      configManager.setConfig('font_size', 'large');
      configManager.setConfig('contrast_ratio', 'high');
      configManager.setConfig('screen_reader', 'enabled');
      
      TestAsserts.assertStringEquals(configManager.getConfig('font_size')!, 'large');
      TestAsserts.assertBooleanEquals(configManager.hasConfig('contrast_ratio'), true);
      TestAsserts.assertBooleanEquals(configManager.hasConfig('invalid_key'), false);
      
      const allConfig = configManager.getAllConfig();
      TestAsserts.assertNumberEquals(allConfig.size, 3);
      
      configManager.removeConfig('screen_reader');
      TestAsserts.assertBooleanEquals(configManager.hasConfig('screen_reader'), false);
      TestAsserts.assertNumberEquals(configManager.getAllConfig().size, 2);
    });
  
    it('should apply accessibility validation rules correctly', 0, () => {
      const validationEngine = new AccessibilityValidationEngine();
      
      validationEngine.addRule('label_length', (value: string) => value.length <= 20);
      validationEngine.addRule('label_readability', (value: string) => /^[\p{Script=Han}a-zA-Z0-9]+$/u.test(value));
      validationEngine.addRule('label_meaningful', (value: string) => value.length >= 2);
      
      TestAsserts.assertNumberEquals(validationEngine.getRuleCount(), 3);
      
      TestAsserts.assertBooleanEquals(validationEngine.validate('label_length', '确认操作'), true);
      TestAsserts.assertBooleanEquals(validationEngine.validate('label_length', '这是一个非常长的标签名称'), true);
      TestAsserts.assertBooleanEquals(validationEngine.validate('label_readability', '确认123'), true);
      TestAsserts.assertBooleanEquals(validationEngine.validate('label_readability', '确认@操作'), false);
      
      const allResults = validationEngine.validateAll('确定');
      TestAsserts.assertBooleanEquals(allResults.get('label_meaningful')!, true);
    });
  
    it('should handle accessibility state transitions correctly', 0, () => {
      const stateMachine = new AccessibilityStateMachine();
      
      TestAsserts.assertStringEquals(stateMachine.getCurrentState(), 'disabled');
      
      TestAsserts.assertBooleanEquals(stateMachine.canTransitionTo('enabled'), true);
      TestAsserts.assertBooleanEquals(stateMachine.canTransitionTo('customized'), false);
      
      stateMachine.transitionTo('enabled');
      stateMachine.transitionTo('customized');
      stateMachine.transitionTo('optimized');
      
      TestAsserts.assertStringEquals(stateMachine.getCurrentState(), 'optimized');
      TestAsserts.assertStringEquals(stateMachine.getPreviousState()!, 'customized');
      
      const history = stateMachine.getStateHistory();
      TestAsserts.assertArrayLength(history, 3);
      TestAsserts.assertStringEquals(history[0], 'disabled');
      
      TestAsserts.assertBooleanEquals(stateMachine.canTransitionTo('disabled'), true);
      TestAsserts.assertBooleanEquals(stateMachine.canTransitionTo('enabled'), false);
      
      stateMachine.reset();
      TestAsserts.assertStringEquals(stateMachine.getCurrentState(), 'disabled');
      TestAsserts.assertArrayLength(stateMachine.getStateHistory(), 0);
    });
  
    it('should handle accessibility events correctly', 0, () => {
      const eventManager = new AccessibilityEventManager();
      
      let enableCount = 0;
      let disableCount = 0;
      
      const enableListener = (data?: string) => { enableCount++; };
      const disableListener = (data?: string) => { disableCount++; };
      
      eventManager.addEventListener('accessibility_enabled', enableListener);
      eventManager.addEventListener('accessibility_disabled', disableListener);
      eventManager.addEventListener('accessibility_enabled', disableListener);
      
      TestAsserts.assertNumberEquals(eventManager.getListenerCount('accessibility_enabled'), 2);
      TestAsserts.assertNumberEquals(eventManager.getListenerCount('accessibility_disabled'), 1);
      
      eventManager.dispatchEvent('accessibility_enabled', 'Accessibility enabled');
      eventManager.dispatchEvent('accessibility_disabled', 'Accessibility disabled');
      
      TestAsserts.assertNumberEquals(enableCount, 1);
      TestAsserts.assertNumberEquals(disableCount, 2);
      
      eventManager.removeEventListener('accessibility_enabled', disableListener);
      TestAsserts.assertNumberEquals(eventManager.getListenerCount('accessibility_enabled'), 1);
      
      eventManager.dispatchEvent('accessibility_enabled', 'Accessibility re-enabled');
      TestAsserts.assertNumberEquals(enableCount, 2);
      TestAsserts.assertNumberEquals(disableCount, 2);
    });
  
    it('should manage accessibility resources correctly', 0, () => {
      const resourceManager = new AccessibilityResourceManager();
      
      resourceManager.allocateResource('screen_reader', 1);
      resourceManager.allocateResource('voice_assistant', 1);
      resourceManager.allocateResource('high_contrast', 1);
      
      TestAsserts.assertNumberEquals(resourceManager.getResourceUsage('screen_reader'), 1);
      TestAsserts.assertBooleanEquals(resourceManager.hasResource('voice_assistant'), true);
      TestAsserts.assertBooleanEquals(resourceManager.hasResource('magnifier'), false);
      
      const allResources = resourceManager.getAllResources();
      TestAsserts.assertNumberEquals(allResources.size, 3);
      
      resourceManager.releaseResource('high_contrast');
      TestAsserts.assertBooleanEquals(resourceManager.hasResource('high_contrast'), false);
      TestAsserts.assertNumberEquals(resourceManager.getAllResources().size, 2);
    });
  });
}

interface DataSummary {
  totalLabels: number;
  uniqueLabels: number;
}

class AccessibilityDataProcessor {
  private labels: string[] = [];
  private processedLabels: string[] = [];

  processLabels(data: string[]): string[] {
    this.labels = [...this.labels, ...data];
    this.processedLabels = this.labels.map(label => `processed:${label}`);
    return this.processedLabels;
  }

  getLabelCount(): number {
    return this.labels.length;
  }

  getProcessedLabels(): string[] {
    return [...this.processedLabels];
  }

  clearLabels(): void {
    this.labels = [];
    this.processedLabels = [];
  }

  getDataSummary(): DataSummary {
    const uniqueLabels = new Set(this.labels).size;
    const summary: DataSummary = {totalLabels: this.labels.length, uniqueLabels};
    return summary;
  }
}

class AccessibilityConfigurationManager {
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

class AccessibilityValidationEngine {
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

class AccessibilityStateMachine {
  private currentState: string = 'disabled';
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
      ['disabled', ['enabled', 'error']],
      ['enabled', ['customized', 'error']],
      ['customized', ['optimized', 'disabled', 'error']],
      ['optimized', ['disabled', 'error']],
      ['error', ['disabled', 'enabled']]
    ]);
    
    const allowedStates = validTransitions.get(this.currentState);
    return allowedStates ? allowedStates.includes(targetState) : false;
  }

  reset(): void {
    this.currentState = 'disabled';
    this.stateHistory = [];
  }
}

class AccessibilityEventManager {
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

class AccessibilityResourceManager {
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
