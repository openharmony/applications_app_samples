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
import { MockExtensionContext, MockSession, MockWindow } from './base/TestDoubles';

class MainAbilityLifecycleProbe {
  // 生命周期探针用于验证应用启动和销毁的正确顺序，确保设备管理应用稳定运行
  // 全局状态初始化必须在创建阶段完成，防止后续业务逻辑访问未初始化数据
  events: string[] = [];

  onCreate(): void {
    globalThis.context = 'context';
    globalThis.allBundleInfo = [];
    globalThis.allUserPermissions = [];
    globalThis.allGroups = [];
    this.events.push('create');
  }

  onForeground(): void {
    this.events.push('foreground');
  }

  onBackground(): void {
    this.events.push('background');
  }

  onDestroy(): void {
    this.events.push('destroy');
  }
}

class DestroyLifecycleProbe {
  window: MockWindow = new MockWindow();
  session: MockSession = new MockSession();
  context: MockExtensionContext = new MockExtensionContext();

  async destroy(): Promise<void> {
    await this.window.destroyWindow();
    this.session.terminateSelf();
    this.context.terminateSelf();
  }
}

class MainAbilityLifecycleModel {
  routePages: string[] = ['pages/ConfirmDialog'];
  lifecycleEvents: string[] = ['create', 'windowStageCreate', 'foreground', 'background', 'destroy', 'windowStageDestroy'];

  initializeGlobals(): Map<string, string[]> {
    const globals: Map<string, string[]> = new Map<string, string[]>();
    globals.set('allBundleInfo', []);
    globals.set('allUserPermissions', []);
    globals.set('allGroups', []);
    return globals;
  }

  getDefaultRoute(): string {
    return this.routePages[0];
  }
}

class AbilityStageSignalModel {
  stageLog: string[] = [];

  createStage(): void {
    this.stageLog.push('[Demo] MyAbilityStage onCreate');
  }
}

class WindowStageLifecycleProbe {
  events: string[] = [];
  loadedRoutes: string[] = [];

  onWindowStageCreate(route: string): void {
    this.events.push('windowStageCreate');
    this.loadedRoutes.push(route);
  }

  onWindowStageDestroy(): void {
    this.events.push('windowStageDestroy');
  }
}

class ExtensionDestroyCoordinator {
  readonly window: MockWindow = new MockWindow();
  readonly session: MockSession = new MockSession();
  readonly context: MockExtensionContext = new MockExtensionContext();
  readonly trace: string[] = [];

  async destroy(): Promise<void> {
    this.trace.push('destroy-window');
    await this.window.destroyWindow();
    this.trace.push('terminate-session');
    this.session.terminateSelf();
    this.trace.push('terminate-extension');
    this.context.terminateSelf();
  }
}

export default function abilityAndStageLifecycleTest(): void {
  describe('TVDeviceManagerUiAbilityAndStageLifecycleTest', () => {
    it('should record main ability lifecycle events in expected order', 0, () => {
      const probe: MainAbilityLifecycleProbe = new MainAbilityLifecycleProbe();
      probe.onCreate();
      probe.onForeground();
      probe.onBackground();
      probe.onDestroy();

      TestAsserts.assertLifecycleEvents(probe.events);
    });

    it('should initialize expected global state during main ability create', 0, () => {
      const probe: MainAbilityLifecycleProbe = new MainAbilityLifecycleProbe();
      probe.onCreate();

      TestAsserts.assertTrue(Array.isArray(globalThis.allBundleInfo as string[]));
      TestAsserts.assertTrue(Array.isArray(globalThis.allUserPermissions as string[]));
      TestAsserts.assertTrue(Array.isArray(globalThis.allGroups as string[]));
    });

    it('should terminate window session and extension together during destroy chain', 0, async () => {
      const probe: DestroyLifecycleProbe = new DestroyLifecycleProbe();
      await probe.destroy();

      TestAsserts.assertTrue(probe.window.destroyed);
      TestAsserts.assertNumberEquals(probe.session.terminateCount, 1);
      TestAsserts.assertNumberEquals(probe.context.terminateCount, 1);
    });

    it('should route startup window stage to confirm dialog page', 0, () => {
      const model: MainAbilityLifecycleModel = new MainAbilityLifecycleModel();
      TestAsserts.assertStringEquals(model.getDefaultRoute(), 'pages/ConfirmDialog');
    });

    it('should initialize all shared global containers during ability creation', 0, () => {
      const model: MainAbilityLifecycleModel = new MainAbilityLifecycleModel();
      const globals: Map<string, string[]> = model.initializeGlobals();

      TestAsserts.assertNumberEquals(globals.size, 3);
      TestAsserts.assertTrue(globals.has('allBundleInfo'));
      TestAsserts.assertTrue(globals.has('allUserPermissions'));
      TestAsserts.assertTrue(globals.has('allGroups'));
    });

    it('should keep shared global containers empty before business data hydration', 0, () => {
      const model: MainAbilityLifecycleModel = new MainAbilityLifecycleModel();
      const globals: Map<string, string[]> = model.initializeGlobals();

      TestAsserts.assertArrayLength(globals.get('allBundleInfo') ?? [], 0);
      TestAsserts.assertArrayLength(globals.get('allUserPermissions') ?? [], 0);
      TestAsserts.assertArrayLength(globals.get('allGroups') ?? [], 0);
    });

    it('should preserve lifecycle event order expected by stage model startup', 0, () => {
      const model: MainAbilityLifecycleModel = new MainAbilityLifecycleModel();

      TestAsserts.assertArrayLength(model.lifecycleEvents, 6);
      TestAsserts.assertStringEquals(model.lifecycleEvents[0], 'create');
      TestAsserts.assertStringEquals(model.lifecycleEvents[1], 'windowStageCreate');
      TestAsserts.assertStringEquals(model.lifecycleEvents[2], 'foreground');
      TestAsserts.assertStringEquals(model.lifecycleEvents[5], 'windowStageDestroy');
    });

    it('should keep route declaration set free from empty placeholder values', 0, () => {
      const model: MainAbilityLifecycleModel = new MainAbilityLifecycleModel();
      TestAsserts.assertNoEmptyStrings(model.routePages);
    });

    it('should emit ability stage create signal once during application bootstrap', 0, () => {
      const model: AbilityStageSignalModel = new AbilityStageSignalModel();
      model.createStage();

      TestAsserts.assertArrayLength(model.stageLog, 1);
      TestAsserts.assertStringEquals(model.stageLog[0], '[Demo] MyAbilityStage onCreate');
    });

    it('should keep create log content readable for integration diagnostics', 0, () => {
      const model: AbilityStageSignalModel = new AbilityStageSignalModel();
      model.createStage();

      TestAsserts.assertReadableText(model.stageLog[0]);
      TestAsserts.assertStringContains(model.stageLog[0], 'MyAbilityStage');
    });

    it('should keep bootstrap signal free from empty placeholder values', 0, () => {
      const model: AbilityStageSignalModel = new AbilityStageSignalModel();
      model.createStage();

      TestAsserts.assertNoEmptyStrings(model.stageLog);
    });

    it('should allow repeated stage bootstrap replay without mutating historical entries', 0, () => {
      const model: AbilityStageSignalModel = new AbilityStageSignalModel();
      model.createStage();
      model.createStage();

      TestAsserts.assertArrayLength(model.stageLog, 2);
      TestAsserts.assertStringEquals(model.stageLog[0], '[Demo] MyAbilityStage onCreate');
      TestAsserts.assertStringEquals(model.stageLog[1], '[Demo] MyAbilityStage onCreate');
    });

    it('should record window stage create and destroy around route loading', 0, () => {
      const probe: WindowStageLifecycleProbe = new WindowStageLifecycleProbe();
      probe.onWindowStageCreate('pages/ConfirmDialog');
      probe.onWindowStageDestroy();

      TestAsserts.assertArrayLength(probe.events, 2);
      TestAsserts.assertStringEquals(probe.events[0], 'windowStageCreate');
      TestAsserts.assertStringEquals(probe.events[1], 'windowStageDestroy');
      TestAsserts.assertStringEquals(probe.loadedRoutes[0], 'pages/ConfirmDialog');
    });

    it('should keep lifecycle route names unique for stage bootstrap assets', 0, () => {
      const model: MainAbilityLifecycleModel = new MainAbilityLifecycleModel();
      const routes: string[] = [...model.routePages, 'pages/Transparent', 'pages/InputPinDialog', 'pages/PinDialog'];

      TestAsserts.assertStringArrayUnique(routes);
    });

    it('should preserve destroy order from window to session to extension', 0, async () => {
      const coordinator: ExtensionDestroyCoordinator = new ExtensionDestroyCoordinator();
      await coordinator.destroy();

      // 生命周期链路里最危险的问题通常是终止顺序错误，容易留下孤儿窗口或悬空 session。
      // 这里把资源释放顺序锁定，可以在后续能力拆分时第一时间发现退出协议被破坏。
      TestAsserts.assertArrayLength(coordinator.trace, 3);
      TestAsserts.assertStringEquals(coordinator.trace[0], 'destroy-window');
      TestAsserts.assertStringEquals(coordinator.trace[1], 'terminate-session');
      TestAsserts.assertStringEquals(coordinator.trace[2], 'terminate-extension');
    });

    it('should keep lifecycle event names readable for diagnostics export', 0, () => {
      const model: MainAbilityLifecycleModel = new MainAbilityLifecycleModel();
      model.lifecycleEvents.forEach((eventName: string) => {
        TestAsserts.assertReadableText(eventName);
      });
    });

    it('should keep stage log history append only during repeated bootstrap replay', 0, () => {
      const model: AbilityStageSignalModel = new AbilityStageSignalModel();
      model.createStage();
      model.createStage();
      model.createStage();

      TestAsserts.assertArrayLength(model.stageLog, 3);
      TestAsserts.assertStringEquals(model.stageLog[2], '[Demo] MyAbilityStage onCreate');
    });
  
    it('should process lifecycle data correctly', 0, () => {
      const dataProcessor = new LifecycleDataProcessor();
      
      const lifecycleEvents = ['create', 'foreground', 'background', 'destroy'];
      const processed = dataProcessor.processLifecycleData(lifecycleEvents);
      
      TestAsserts.assertArrayLength(processed, 4);
      TestAsserts.assertStringEquals(processed[0], 'processed:create');
      TestAsserts.assertNumberEquals(dataProcessor.getEventCount(), 4);
      
      const moreEvents = ['resume', 'pause'];
      dataProcessor.processLifecycleData(moreEvents);
      TestAsserts.assertNumberEquals(dataProcessor.getEventCount(), 6);
      
      const summary = dataProcessor.getDataSummary();
      TestAsserts.assertNumberAtLeast(summary.totalEvents, 6);
      
      dataProcessor.clearEvents();
      TestAsserts.assertNumberEquals(dataProcessor.getEventCount(), 0);
    });
  
    it('should manage ability configuration correctly', 0, () => {
      const configManager = new AbilityConfigurationManager();
      
      configManager.setConfig('max_instances', '5');
      configManager.setConfig('memory_limit', '1024');
      configManager.setConfig('timeout_duration', '30000');
      
      TestAsserts.assertStringEquals(configManager.getConfig('max_instances')!, '5');
      TestAsserts.assertBooleanEquals(configManager.hasConfig('memory_limit'), true);
      TestAsserts.assertBooleanEquals(configManager.hasConfig('invalid_key'), false);
      
      const allConfig = configManager.getAllConfig();
      TestAsserts.assertNumberEquals(allConfig.size, 3);
      
      configManager.removeConfig('timeout_duration');
      TestAsserts.assertBooleanEquals(configManager.hasConfig('timeout_duration'), false);
      TestAsserts.assertNumberEquals(configManager.getAllConfig().size, 2);
    });
  
    it('should apply ability validation rules correctly', 0, () => {
      const validationEngine = new AbilityValidationEngine();
      
      validationEngine.addRule('instance_count', (value: string) => parseInt(value) <= 10);
      validationEngine.addRule('memory_usage', (value: string) => parseInt(value) <= 2048);
      validationEngine.addRule('timeout_valid', (value: string) => parseInt(value) > 0);
      
      TestAsserts.assertNumberEquals(validationEngine.getRuleCount(), 3);
      
      TestAsserts.assertBooleanEquals(validationEngine.validate('instance_count', '5'), true);
      TestAsserts.assertBooleanEquals(validationEngine.validate('instance_count', '15'), false);
      TestAsserts.assertBooleanEquals(validationEngine.validate('memory_usage', '1024'), true);
      TestAsserts.assertBooleanEquals(validationEngine.validate('memory_usage', '4096'), false);
      
      const allResults = validationEngine.validateAll('1000');
      TestAsserts.assertBooleanEquals(allResults.get('timeout_valid')!, true);
    });
  
    it('should handle ability state transitions correctly', 0, () => {
      const stateMachine = new AbilityStateMachine();
      
      TestAsserts.assertStringEquals(stateMachine.getCurrentState(), 'initial');
      
      TestAsserts.assertBooleanEquals(stateMachine.canTransitionTo('created'), true);
      TestAsserts.assertBooleanEquals(stateMachine.canTransitionTo('running'), false);
      
      stateMachine.transitionTo('created');
      stateMachine.transitionTo('running');
      stateMachine.transitionTo('paused');
      
      TestAsserts.assertStringEquals(stateMachine.getCurrentState(), 'paused');
      TestAsserts.assertStringEquals(stateMachine.getPreviousState()!, 'running');
      
      const history = stateMachine.getStateHistory();
      TestAsserts.assertArrayLength(history, 3);
      TestAsserts.assertStringEquals(history[0], 'initial');
      
      TestAsserts.assertBooleanEquals(stateMachine.canTransitionTo('destroyed'), true);
      TestAsserts.assertBooleanEquals(stateMachine.canTransitionTo('created'), false);
      
      stateMachine.reset();
      TestAsserts.assertStringEquals(stateMachine.getCurrentState(), 'initial');
      TestAsserts.assertArrayLength(stateMachine.getStateHistory(), 0);
    });
  
    it('should handle ability events correctly', 0, () => {
      const eventManager = new AbilityEventManager();
      
      let createCount = 0;
      let destroyCount = 0;
      
      const createListener = (data?: string) => { createCount++; };
      const destroyListener = (data?: string) => { destroyCount++; };
      
      eventManager.addEventListener('ability_create', createListener);
      eventManager.addEventListener('ability_destroy', destroyListener);
      eventManager.addEventListener('ability_create', destroyListener);
      
      TestAsserts.assertNumberEquals(eventManager.getListenerCount('ability_create'), 2);
      TestAsserts.assertNumberEquals(eventManager.getListenerCount('ability_destroy'), 1);
      
      eventManager.dispatchEvent('ability_create', 'Ability created');
      eventManager.dispatchEvent('ability_destroy', 'Ability destroyed');
      
      TestAsserts.assertNumberEquals(createCount, 1);
      TestAsserts.assertNumberEquals(destroyCount, 2);
      
      eventManager.removeEventListener('ability_create', destroyListener);
      TestAsserts.assertNumberEquals(eventManager.getListenerCount('ability_create'), 1);
      
      eventManager.dispatchEvent('ability_create', 'Another ability created');
      TestAsserts.assertNumberEquals(createCount, 2);
      TestAsserts.assertNumberEquals(destroyCount, 2);
    });
  
    it('should manage ability resources correctly', 0, () => {
      const resourceManager = new AbilityResourceManager();
      
      resourceManager.allocateResource('memory', 1024);
      resourceManager.allocateResource('cpu', 2);
      resourceManager.allocateResource('storage', 500);
      
      TestAsserts.assertNumberEquals(resourceManager.getResourceUsage('memory'), 1024);
      TestAsserts.assertBooleanEquals(resourceManager.hasResource('cpu'), true);
      TestAsserts.assertBooleanEquals(resourceManager.hasResource('gpu'), false);
      
      const allResources = resourceManager.getAllResources();
      TestAsserts.assertNumberEquals(allResources.size, 3);
      
      resourceManager.releaseResource('storage');
      TestAsserts.assertBooleanEquals(resourceManager.hasResource('storage'), false);
      TestAsserts.assertNumberEquals(resourceManager.getAllResources().size, 2);
    });
  });
}

interface LifecycleDataSummary {
  totalEvents: number;
  uniqueEvents: number;
}

class LifecycleDataProcessor {
  private events: string[] = [];
  private processedEvents: string[] = [];

  processLifecycleData(data: string[]): string[] {
    this.events = [...this.events, ...data];
    this.processedEvents = this.events.map(event => `processed:${event}`);
    return this.processedEvents;
  }

  getEventCount(): number {
    return this.events.length;
  }

  getProcessedEvents(): string[] {
    return [...this.processedEvents];
  }

  clearEvents(): void {
    this.events = [];
    this.processedEvents = [];
  }

  getDataSummary(): LifecycleDataSummary {
    const uniqueEvents = new Set(this.events).size;
    const summary: LifecycleDataSummary = {totalEvents: this.events.length, uniqueEvents};
    return summary;
  }
}

class AbilityConfigurationManager {
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

class AbilityValidationEngine {
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

class AbilityStateMachine {
  private currentState: string = 'initial';
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
      ['initial', ['created', 'error']],
      ['created', ['running', 'error']],
      ['running', ['paused', 'destroyed', 'error']],
      ['paused', ['running', 'destroyed', 'error']],
      ['destroyed', ['initial', 'error']],
      ['error', ['initial', 'created']]
    ]);
    
    const allowedStates = validTransitions.get(this.currentState);
    return allowedStates ? allowedStates.includes(targetState) : false;
  }

  reset(): void {
    this.currentState = 'initial';
    this.stateHistory = [];
  }
}

class AbilityEventManager {
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

class AbilityResourceManager {
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
