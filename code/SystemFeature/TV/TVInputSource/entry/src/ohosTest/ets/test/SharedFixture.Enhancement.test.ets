/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { describe, beforeEach, afterEach, it, expect } from '@ohos/hypium';
import { patchMember, restoreAll } from './Batch1TestHelper';

interface FixturePool<T> {
  acquire(): T;
  release(item: T): void;
  size(): number;
  available(): number;
  reset(): void;
}

interface TestContext {
  sourceId: string;
  channelList: string[];
  focusedElement: string | null;
  timestamp: number;
  metadata: Map<string, string>;
}

interface SharedState {
  testRuns: number;
  fixtureAllocationCount: number;
  fixtureReleaseCount: number;
  contextCreations: number;
  contextDestructions: number;
}

class SharedStateSnapshot implements SharedState {
  testRuns: number = 0;
  fixtureAllocationCount: number = 0;
  fixtureReleaseCount: number = 0;
  contextCreations: number = 0;
  contextDestructions: number = 0;
}

function cloneSharedState(state: SharedState): SharedState {
  const snapshot = new SharedStateSnapshot();
  snapshot.testRuns = state.testRuns;
  snapshot.fixtureAllocationCount = state.fixtureAllocationCount;
  snapshot.fixtureReleaseCount = state.fixtureReleaseCount;
  snapshot.contextCreations = state.contextCreations;
  snapshot.contextDestructions = state.contextDestructions;
  return snapshot;
}

class EmptyFixture {
}

class SourceManagerFixture {
  sources: string[] = [];
}

class ChannelManagerFixture {
  channels: string[] = [];
}

class SharedSourceFixture {
  name: string = '';
  refs: number = 0;
}

class CycleFixture {
  id: number;

  constructor(id: number) {
    this.id = id;
  }
}

class FixtureFactory<T> {
  private creator: () => T;
  private reset: (item: T) => void;
  private validator: (item: T) => boolean;

  constructor(creator: () => T, reset: (item: T) => void, validator: (item: T) => boolean = () => true) {
    this.creator = creator;
    this.reset = reset;
    this.validator = validator;
  }

  create(): T {
    return this.creator();
  }

  resetFixture(item: T): void {
    this.reset(item);
  }

  validate(item: T): boolean {
    return this.validator(item);
  }
}

class GenericFixturePool<T> implements FixturePool<T> {
  private pool: T[] = [];
  private factory: FixtureFactory<T>;
  private maxSize: number;
  private inUse: Set<T> = new Set();

  constructor(factory: FixtureFactory<T>, maxSize: number = 10) {
    this.factory = factory;
    this.maxSize = maxSize;
    this.initializePool();
  }

  private initializePool(): void {
    for (let i = 0; i < this.maxSize; i++) {
      this.pool.push(this.factory.create());
    }
  }

  acquire(): T {
    if (this.pool.length > 0) {
      const item = this.pool.pop()!;
      this.inUse.add(item);
      return item;
    }
    const newItem = this.factory.create();
    this.inUse.add(newItem);
    return newItem;
  }

  release(item: T): void {
    if (this.inUse.has(item)) {
      this.inUse.delete(item);
      this.factory.resetFixture(item);
      if (this.pool.length < this.maxSize) {
        this.pool.push(item);
      }
    }
  }

  size(): number {
    return this.pool.length + this.inUse.size;
  }

  available(): number {
    return this.pool.length;
  }

  reset(): void {
    for (const item of this.inUse) {
      this.factory.resetFixture(item);
      this.pool.push(item);
    }
    this.inUse.clear();
  }
}

class TestContextFactory {
  private contextIdCounter: number = 0;
  private sharedState: SharedState;

  constructor() {
    this.sharedState = {
      testRuns: 0,
      fixtureAllocationCount: 0,
      fixtureReleaseCount: 0,
      contextCreations: 0,
      contextDestructions: 0
    };
  }

  createContext(sourceId: string = 'HDMI1'): TestContext {
    this.sharedState.contextCreations++;
    this.sharedState.fixtureAllocationCount++;
    return {
      sourceId,
      channelList: [],
      focusedElement: null,
      timestamp: Date.now(),
      metadata: new Map()
    };
  }

  cloneContext(original: TestContext): TestContext {
    this.sharedState.contextCreations++;
    this.sharedState.fixtureAllocationCount++;
    return {
      sourceId: original.sourceId,
      channelList: original.channelList.slice(),
      focusedElement: original.focusedElement,
      timestamp: Date.now(),
      metadata: new Map(original.metadata)
    };
  }

  destroyContext(context: TestContext): void {
    this.sharedState.contextDestructions++;
    this.sharedState.fixtureReleaseCount++;
    context.channelList = [];
    context.metadata.clear();
  }

  getSharedState(): SharedState {
    return cloneSharedState(this.sharedState);
  }

  incrementTestRuns(): void {
    this.sharedState.testRuns++;
  }

  reset(): void {
    this.contextIdCounter = 0;
    this.sharedState = {
      testRuns: 0,
      fixtureAllocationCount: 0,
      fixtureReleaseCount: 0,
      contextCreations: 0,
      contextDestructions: 0
    };
  }
}

class FixtureLifecycleManager {
  private fixtures: Map<string, Object> = new Map();
  private lifecycleHooks: Map<string, Array<() => void>> = new Map();
  private initializationOrder: string[] = [];
  private destructionOrder: string[] = [];

  registerFixture(name: string, fixture: Object): void {
    this.fixtures.set(name, fixture);
    this.lifecycleHooks.set(name, []);
    this.initializationOrder.push(name);
  }

  registerLifecycleHook(name: string, hook: () => void): void {
    const hooks = this.lifecycleHooks.get(name);
    if (hooks) {
      hooks.push(hook);
    }
  }

  getFixture<T>(name: string): T | null {
    return (this.fixtures.get(name) as T) || null;
  }

  hasFixture(name: string): boolean {
    return this.fixtures.has(name);
  }

  initializeAll(): void {
    for (const name of this.initializationOrder) {
      const hooks = this.lifecycleHooks.get(name);
      if (hooks) {
        for (const hook of hooks) {
          hook();
        }
      }
    }
  }

  destroyAll(): void {
    this.destructionOrder = this.initializationOrder.slice().reverse();
    for (const name of this.destructionOrder) {
      const hooks = this.lifecycleHooks.get(name);
      if (hooks) {
        for (const hook of hooks.reverse()) {
          hook();
        }
      }
    }
    this.fixtures.clear();
    this.lifecycleHooks.clear();
    this.initializationOrder = [];
    this.destructionOrder = [];
  }

  getInitializationOrder(): string[] {
    return this.initializationOrder.slice();
  }

  getDestructionOrder(): string[] {
    return this.destructionOrder.slice();
  }
}

class SharedFixtureTracker {
  private allocations: Map<string, number> = new Map();
  private releases: Map<string, number> = new Map();
  private leaks: Array<string> = [];

  recordAllocation(fixtureType: string): void {
    const current = this.allocations.get(fixtureType) || 0;
    this.allocations.set(fixtureType, current + 1);
  }

  recordRelease(fixtureType: string): void {
    const current = this.releases.get(fixtureType) || 0;
    this.releases.set(fixtureType, current + 1);
  }

  getAllocationCount(fixtureType: string): number {
    return this.allocations.get(fixtureType) || 0;
  }

  getReleaseCount(fixtureType: string): number {
    return this.releases.get(fixtureType) || 0;
  }

  hasLeaks(fixtureType: string): boolean {
    return this.getAllocationCount(fixtureType) > this.getReleaseCount(fixtureType);
  }

  getLeakCount(fixtureType: string): number {
    return this.getAllocationCount(fixtureType) - this.getReleaseCount(fixtureType);
  }

  recordLeak(fixtureType: string): void {
    this.leaks.push(fixtureType);
  }

  getAllLeaks(): string[] {
    return this.leaks.slice();
  }

  reset(): void {
    this.allocations.clear();
    this.releases.clear();
    this.leaks = [];
  }
}

export default function SharedFixtureEnhancementTest(): void {
  describe('GenericFixturePool_Basic', () => {
    let pool: GenericFixturePool<TestContext>;

    beforeEach(() => {
      const factory = new FixtureFactory<TestContext>(
        () => ({ sourceId: 'HDMI1', channelList: [], focusedElement: null, timestamp: Date.now(), metadata: new Map() }),
        (ctx) => { ctx.sourceId = 'HDMI1'; ctx.channelList = []; ctx.focusedElement = null; ctx.metadata.clear(); }
      );
      pool = new GenericFixturePool<TestContext>(factory, 5);
    });

    it('should_initialize_with_specified_size', 0, () => {
      expect(pool.size()).assertEqual(5);
      expect(pool.available()).assertEqual(5);
    });

    it('should_acquire_fixture_from_pool', 0, () => {
      const context = pool.acquire();
      expect(((context) === null) || ((context) === undefined)).assertFalse();
      expect(pool.available()).assertEqual(4);
    });

    it('should_release_fixture_back_to_pool', 0, () => {
      const context = pool.acquire();
      pool.release(context);
      expect(pool.available()).assertEqual(5);
    });

    it('should_reset_fixture_on_release', 0, () => {
      const context = pool.acquire();
      context.sourceId = 'HDMI2';
      context.channelList = ['ch1', 'ch2'];
      pool.release(context);
      const acquired = pool.acquire();
      expect(acquired.sourceId).assertEqual('HDMI1');
      expect(acquired.channelList.length).assertEqual(0);
    });

    it('should_create_new_fixture_when_pool_exhausted', 0, () => {
      const contexts: TestContext[] = [];
      for (let i = 0; i < 5; i++) {
        contexts.push(pool.acquire());
      }
      expect(pool.available()).assertEqual(0);
      const extra = pool.acquire();
      expect(((extra) === null) || ((extra) === undefined)).assertFalse();
      expect(pool.size()).assertEqual(6);
      for (const ctx of contexts) {
        pool.release(ctx);
      }
    });

    it('should_not_exceed_max_size_on_release', 0, () => {
      const contexts: TestContext[] = [];
      for (let i = 0; i < 5; i++) {
        contexts.push(pool.acquire());
      }
      for (const ctx of contexts) {
        pool.release(ctx);
      }
      expect(pool.available()).assertEqual(5);
    });
  });

  describe('TestContextFactory_Basic', () => {
    let factory: TestContextFactory;

    beforeEach(() => {
      factory = new TestContextFactory();
    });

    afterEach(() => {
      factory.reset();
    });

    it('should_create_context_with_default_values', 0, () => {
      const context = factory.createContext();
      expect(context.sourceId).assertEqual('HDMI1');
      expect(context.channelList.length).assertEqual(0);
      expect(context.focusedElement).assertNull();
    });

    it('should_create_context_with_specified_source', 0, () => {
      const context = factory.createContext('HDMI2');
      expect(context.sourceId).assertEqual('HDMI2');
    });

    it('should_clone_context', 0, () => {
      const original = factory.createContext('HDMI1');
      original.channelList = ['ch1', 'ch2'];
      original.focusedElement = 'element1';
      const cloned = factory.cloneContext(original);
      expect(cloned.sourceId).assertEqual(original.sourceId);
      expect(cloned.channelList.length).assertEqual(original.channelList.length);
      expect(cloned.focusedElement).assertEqual(original.focusedElement);
      cloned.channelList.push('ch3');
      expect(original.channelList.length).assertEqual(2);
    });

    it('should_destroy_context', 0, () => {
      const context = factory.createContext();
      factory.destroyContext(context);
      const state = factory.getSharedState();
      expect(state.contextDestructions).assertEqual(1);
    });

    it('should_track_allocation_count', 0, () => {
      factory.createContext();
      factory.createContext();
      const state = factory.getSharedState();
      expect(state.fixtureAllocationCount).assertEqual(2);
    });

    it('should_increment_test_runs', 0, () => {
      factory.incrementTestRuns();
      factory.incrementTestRuns();
      const state = factory.getSharedState();
      expect(state.testRuns).assertEqual(2);
    });
  });

  describe('FixtureLifecycleManager_Basic', () => {
    let manager: FixtureLifecycleManager;

    beforeEach(() => {
      manager = new FixtureLifecycleManager();
    });

    afterEach(() => {
      manager.destroyAll();
    });

    it('should_register_fixtures', 0, () => {
      manager.registerFixture('sourceManager', new SourceManagerFixture());
      manager.registerFixture('dtvManager', new ChannelManagerFixture());
      expect(manager.hasFixture('sourceManager')).assertEqual(true);
      expect(manager.hasFixture('dtvManager')).assertEqual(true);
    });

    it('should_retrieve_registered_fixtures', 0, () => {
      const fixture = new SourceManagerFixture();
      fixture.sources = ['HDMI1', 'HDMI2'];
      manager.registerFixture('sourceManager', fixture);
      const retrieved = manager.getFixture<SourceManagerFixture>('sourceManager');
      expect(((retrieved) === null) || ((retrieved) === undefined)).assertFalse();
      expect(retrieved!.sources.length).assertEqual(2);
    });

    it('should_execute_lifecycle_hooks_on_initialize', 0, () => {
      let initialized = false;
      manager.registerFixture('testFixture', new EmptyFixture());
      manager.registerLifecycleHook('testFixture', () => { initialized = true; });
      manager.initializeAll();
      expect(initialized).assertEqual(true);
    });

    it('should_execute_lifecycle_hooks_on_destroy', 0, () => {
      let destroyed = false;
      manager.registerFixture('testFixture', new EmptyFixture());
      manager.registerLifecycleHook('testFixture', () => { destroyed = true; });
      manager.initializeAll();
      manager.destroyAll();
      expect(destroyed).assertEqual(true);
    });

    it('should_maintain_initialization_order', 0, () => {
      const order: string[] = [];
      manager.registerFixture('first', new EmptyFixture());
      manager.registerFixture('second', new EmptyFixture());
      manager.registerFixture('third', new EmptyFixture());
      manager.registerLifecycleHook('first', () => order.push('first'));
      manager.registerLifecycleHook('second', () => order.push('second'));
      manager.registerLifecycleHook('third', () => order.push('third'));
      manager.initializeAll();
      expect(order[0]).assertEqual('first');
      expect(order[1]).assertEqual('second');
      expect(order[2]).assertEqual('third');
    });

    it('should_reverse_order_on_destruction', 0, () => {
      const order: string[] = [];
      manager.registerFixture('first', new EmptyFixture());
      manager.registerFixture('second', new EmptyFixture());
      manager.registerFixture('third', new EmptyFixture());
      manager.registerLifecycleHook('first', () => order.push('first'));
      manager.registerLifecycleHook('second', () => order.push('second'));
      manager.registerLifecycleHook('third', () => order.push('third'));
      manager.initializeAll();
      order.length = 0;
      manager.destroyAll();
      expect(order[0]).assertEqual('third');
      expect(order[1]).assertEqual('second');
      expect(order[2]).assertEqual('first');
    });
  });

  describe('SharedFixtureTracker_Basic', () => {
    let tracker: SharedFixtureTracker;

    beforeEach(() => {
      tracker = new SharedFixtureTracker();
    });

    afterEach(() => {
      tracker.reset();
    });

    it('should_track_allocations', 0, () => {
      tracker.recordAllocation('TestContext');
      tracker.recordAllocation('TestContext');
      expect(tracker.getAllocationCount('TestContext')).assertEqual(2);
    });

    it('should_track_releases', 0, () => {
      tracker.recordAllocation('TestContext');
      tracker.recordAllocation('TestContext');
      tracker.recordRelease('TestContext');
      expect(tracker.getReleaseCount('TestContext')).assertEqual(1);
    });

    it('should_detect_leaks', 0, () => {
      tracker.recordAllocation('TestContext');
      tracker.recordAllocation('TestContext');
      tracker.recordRelease('TestContext');
      expect(tracker.hasLeaks('TestContext')).assertEqual(true);
      expect(tracker.getLeakCount('TestContext')).assertEqual(1);
    });

    it('should_not_detect_leaks_when_balanced', 0, () => {
      tracker.recordAllocation('TestContext');
      tracker.recordRelease('TestContext');
      expect(tracker.hasLeaks('TestContext')).assertEqual(false);
    });

    it('should_record_leak_instances', 0, () => {
      tracker.recordAllocation('TestContext');
      tracker.recordAllocation('TestContext');
      tracker.recordLeak('TestContext');
      tracker.recordLeak('TestContext');
      const leaks = tracker.getAllLeaks();
      expect(leaks.length).assertEqual(2);
    });

    it('should_reset_all_tracking_data', 0, () => {
      tracker.recordAllocation('TestContext');
      tracker.recordLeak('TestContext');
      tracker.reset();
      expect(tracker.getAllocationCount('TestContext')).assertEqual(0);
      expect(tracker.getLeakCount('TestContext')).assertEqual(0);
      expect(tracker.getAllLeaks().length).assertEqual(0);
    });
  });

  describe('SharedFixtureEnhancement_Integrated_Scenarios', () => {
    let factory: TestContextFactory;
    let pool: GenericFixturePool<TestContext>;
    let tracker: SharedFixtureTracker;
    let manager: FixtureLifecycleManager;

    beforeEach(() => {
      factory = new TestContextFactory();
      const contextFactory = new FixtureFactory<TestContext>(
        () => factory.createContext('HDMI1'),
        (ctx) => { ctx.sourceId = 'HDMI1'; ctx.channelList = []; ctx.focusedElement = null; ctx.metadata.clear(); }
      );
      pool = new GenericFixturePool<TestContext>(contextFactory, 10);
      tracker = new SharedFixtureTracker();
      manager = new FixtureLifecycleManager();
    });

    afterEach(() => {
      pool.reset();
      manager.destroyAll();
      factory.reset();
      tracker.reset();
    });

    it('should_track_fixture_usage_across_tests', 0, () => {
      const ctx1 = pool.acquire();
      tracker.recordAllocation('TestContext');
      pool.release(ctx1);
      tracker.recordRelease('TestContext');
      factory.incrementTestRuns();
      const ctx2 = pool.acquire();
      tracker.recordAllocation('TestContext');
      pool.release(ctx2);
      tracker.recordRelease('TestContext');
      factory.incrementTestRuns();
      expect(tracker.hasLeaks('TestContext')).assertEqual(false);
    });

    it('should_handle_fixture_contention', 0, () => {
      const contexts: TestContext[] = [];
      for (let i = 0; i < 10; i++) {
        contexts.push(pool.acquire());
        tracker.recordAllocation('TestContext');
      }
      for (const ctx of contexts) {
        pool.release(ctx);
        tracker.recordRelease('TestContext');
      }
      expect(tracker.hasLeaks('TestContext')).assertEqual(false);
    });

    it('should_manage_fixture_lifecycle_with_manager', 0, () => {
      const fixture = new SharedSourceFixture();
      fixture.name = 'sharedSource';
      manager.registerFixture('sharedSource', fixture);
      manager.registerLifecycleHook('sharedSource', () => { fixture.refs++; });
      manager.initializeAll();
      expect((manager.getFixture<SharedSourceFixture>('sharedSource'))!.refs).assertEqual(1);
      manager.destroyAll();
    });

    it('should_isolate_contexts_between_acquisitions', 0, () => {
      const ctx1 = pool.acquire();
      ctx1.sourceId = 'HDMI1';
      ctx1.channelList = ['ch1'];
      pool.release(ctx1);
      const ctx2 = pool.acquire();
      expect(ctx2.sourceId).assertEqual('HDMI1');
      expect(ctx2.channelList.length).assertEqual(0);
      pool.release(ctx2);
    });

    it('should_detect_pool_exhaustion', 0, () => {
      const contexts: TestContext[] = [];
      for (let i = 0; i < 10; i++) {
        contexts.push(pool.acquire());
        tracker.recordAllocation('TestContext');
      }
      expect(pool.available()).assertEqual(0);
      const extra = pool.acquire();
      tracker.recordAllocation('TestContext');
      expect(((extra) === null) || ((extra) === undefined)).assertFalse();
      for (const ctx of contexts) {
        pool.release(ctx);
        tracker.recordRelease('TestContext');
      }
      pool.release(extra);
      tracker.recordRelease('TestContext');
      expect(tracker.hasLeaks('TestContext')).assertEqual(false);
    });
  });

  describe('SharedFixtureEnhancement_Edge_Cases', () => {
    let factory: TestContextFactory;

    beforeEach(() => {
      factory = new TestContextFactory();
    });

    afterEach(() => {
      factory.reset();
    });

    it('should_handle_empty_pool_gracefully', 0, () => {
      const contextFactory = new FixtureFactory<TestContext>(
        () => factory.createContext('HDMI1'),
        (ctx) => { ctx.sourceId = 'HDMI1'; }
      );
      const pool = new GenericFixturePool<TestContext>(contextFactory, 0);
      expect(pool.size()).assertEqual(0);
      expect(pool.available()).assertEqual(0);
      const ctx = pool.acquire();
      expect(((ctx) === null) || ((ctx) === undefined)).assertFalse();
      expect(pool.size()).assertEqual(1);
    });

    it('should_handle_multiple_context_clones', 0, () => {
      const original = factory.createContext('HDMI1');
      original.channelList = ['ch1', 'ch2', 'ch3'];
      const clones: TestContext[] = [];
      for (let i = 0; i < 5; i++) {
        clones.push(factory.cloneContext(original));
      }
      const state = factory.getSharedState();
      expect(state.contextCreations).assertEqual(6);
    });

    it('should_handle_metadata_in_context', 0, () => {
      const context = factory.createContext('HDMI1');
      context.metadata.set('key1', 'value1');
      context.metadata.set('key2', 'value2');
      const cloned = factory.cloneContext(context);
      expect(cloned.metadata.size).assertEqual(2);
      cloned.metadata.set('key3', 'value3');
      expect(context.metadata.size).assertEqual(2);
    });

    it('should_track_zero_allocations', 0, () => {
      const state = factory.getSharedState();
      expect(state.fixtureAllocationCount).assertEqual(0);
      expect(state.fixtureReleaseCount).assertEqual(0);
    });

    it('should_handle_sequential_create_and_destroy', 0, () => {
      for (let i = 0; i < 10; i++) {
        const context = factory.createContext(`HDMI${i % 4 + 1}`);
        factory.destroyContext(context);
      }
      const state = factory.getSharedState();
      expect(state.contextCreations).assertEqual(10);
      expect(state.contextDestructions).assertEqual(10);
    });
  });

  describe('SharedFixtureEnhancement_LongRunning_Scenarios', () => {
    it('should_sustain_fixture_pool_over_extended_period', 0, () => {
      const factory = new TestContextFactory();
      const contextFactory = new FixtureFactory<TestContext>(
        () => factory.createContext('HDMI1'),
        (ctx) => { ctx.sourceId = 'HDMI1'; ctx.channelList = []; }
      );
      const pool = new GenericFixturePool<TestContext>(contextFactory, 20);
      const tracker = new SharedFixtureTracker();
      for (let cycle = 0; cycle < 100; cycle++) {
        const ctx = pool.acquire();
        tracker.recordAllocation('TestContext');
        factory.incrementTestRuns();
        pool.release(ctx);
        tracker.recordRelease('TestContext');
      }
      expect(tracker.hasLeaks('TestContext')).assertEqual(false);
      pool.reset();
      tracker.reset();
      factory.reset();
    });

    it('should_sustain_fixture_lifecycle_tracking', 0, () => {
      const manager = new FixtureLifecycleManager();
      const tracker = new SharedFixtureTracker();
      for (let cycle = 0; cycle < 50; cycle++) {
        const fixtureName = `fixture_${cycle % 5}`;
        if (!manager.hasFixture(fixtureName)) {
          manager.registerFixture(fixtureName, new CycleFixture(cycle));
          tracker.recordAllocation(fixtureName);
        }
        if (cycle % 10 === 0) {
          manager.destroyAll();
          tracker.recordRelease(fixtureName);
        }
      }
      manager.destroyAll();
      expect(tracker.getAllLeaks().length).assertEqual(0);
    });
  });
}
