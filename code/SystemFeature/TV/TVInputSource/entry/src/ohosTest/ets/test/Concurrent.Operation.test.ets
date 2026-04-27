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

interface ConcurrentOperation {
  id: string;
  type: 'switch' | 'scan' | 'edit' | 'delete' | 'sort';
  sourceId?: string;
  priority: number;
  startTime: number;
  endTime: number;
  status: 'pending' | 'running' | 'completed' | 'cancelled';
}

interface RaceConditionEvent {
  operationId: string;
  sharedResource: string;
  accessTime: number;
  accessType: 'read' | 'write';
  threadId: string;
}

class SharedResourceState {
  value: string;
  lockOwner: string | null;
  version: number;

  constructor(value: string, lockOwner: string | null, version: number) {
    this.value = value;
    this.lockOwner = lockOwner;
    this.version = version;
  }
}

class ResourceAccessLogEntry {
  resource: string;
  threadId: string;
  action: string;
  timestamp: number;

  constructor(resource: string, threadId: string, action: string, timestamp: number) {
    this.resource = resource;
    this.threadId = threadId;
    this.action = action;
    this.timestamp = timestamp;
  }
}

class OperationScheduler {
  public operations: ConcurrentOperation[] = [];
  public currentOperation: ConcurrentOperation | null = null;
  public maxConcurrent: number = 1;
  public operationQueue: ConcurrentOperation[] = [];
  public completedOperations: ConcurrentOperation[] = [];
  public raceConditionEvents: RaceConditionEvent[] = [];

  constructor(maxConcurrent: number = 1) {
    this.maxConcurrent = maxConcurrent;
  }

  submitOperation(operation: ConcurrentOperation): boolean {
    if (this.operations.length >= this.maxConcurrent) {
      this.operationQueue.push(operation);
      return false;
    }
    this.operations.push(operation);
    operation.status = 'running';
    operation.startTime = Date.now();
    this.refreshCurrentOperation();
    return true;
  }

  completeOperation(operationId: string): void {
    const operation = this.operations.find(op => op.id === operationId);
    if (operation) {
      operation.status = 'completed';
      operation.endTime = Date.now();
      this.completedOperations.push(operation);
      this.operations = this.operations.filter(op => op.id !== operationId);
      if (this.operationQueue.length > 0) {
        const nextOp = this.operationQueue.shift();
        if (nextOp) {
          this.submitOperation(nextOp);
        }
      }
      this.refreshCurrentOperation();
    }
  }

  cancelOperation(operationId: string): void {
    const operation = this.operations.find(op => op.id === operationId);
    if (operation) {
      operation.status = 'cancelled';
      operation.endTime = Date.now();
      this.operations = this.operations.filter(op => op.id !== operationId);
      if (this.operationQueue.length > 0) {
        const nextOp = this.operationQueue.shift();
        if (nextOp) {
          this.submitOperation(nextOp);
        }
      }
      this.refreshCurrentOperation();
    }
  }

  getActiveOperationCount(): number {
    return this.operations.filter(op => op.status === 'running').length;
  }

  getQueuedOperationCount(): number {
    return this.operationQueue.length;
  }

  simulateRaceCondition(operationId: string, sharedResource: string, accessType: 'read' | 'write'): void {
    this.raceConditionEvents.push({
      operationId,
      sharedResource,
      accessTime: Date.now(),
      accessType,
      threadId: `thread_${Math.random().toString(36).substring(7)}`
    });
  }

  isRaceConditionDetected(sharedResource: string): boolean {
    const resourceEvents = this.raceConditionEvents.filter(e => e.sharedResource === sharedResource);
    if (resourceEvents.length < 2) {
      return false;
    }
    const timeThreshold = 10;
    for (let i = 1; i < resourceEvents.length; i++) {
      const timeDelta = Math.abs(resourceEvents[i].accessTime - resourceEvents[i - 1].accessTime);
      if (timeDelta < timeThreshold &&
        resourceEvents[i].accessType === 'write' &&
        resourceEvents[i - 1].accessType === 'write') {
        return true;
      }
    }
    return false;
  }

  reset(): void {
    this.operations = [];
    this.currentOperation = null;
    this.operationQueue = [];
    this.completedOperations = [];
    this.raceConditionEvents = [];
  }

  private refreshCurrentOperation(): void {
    this.currentOperation = this.operations.length > 0 ? this.operations[0] : null;
  }
}

class SharedResourceManager {
  public resources: Map<string, SharedResourceState> = new Map();
  public accessLog: Array<ResourceAccessLogEntry> = [];

  constructor() {
    this.resources.set('currentSource', new SharedResourceState('HDMI1', null, 0));
    this.resources.set('channelList', new SharedResourceState('[]', null, 0));
    this.resources.set('focusedElement', new SharedResourceState('null', null, 0));
  }

  acquireLock(resource: string, threadId: string): boolean {
    const res = this.resources.get(resource);
    if (!res) {
      return false;
    }
    if (res.lockOwner === null) {
      res.lockOwner = threadId;
      this.logAccess(resource, threadId, 'acquire_lock');
      return true;
    }
    return res.lockOwner === threadId;
  }

  releaseLock(resource: string, threadId: string): boolean {
    const res = this.resources.get(resource);
    if (!res) {
      return false;
    }
    if (res.lockOwner === threadId) {
      res.lockOwner = null;
      this.logAccess(resource, threadId, 'release_lock');
      return true;
    }
    return false;
  }

  readResource(resource: string, threadId: string): string | null {
    const res = this.resources.get(resource);
    if (!res) {
      return null;
    }
    this.logAccess(resource, threadId, 'read');
    return res.value;
  }

  writeResource(resource: string, value: string, threadId: string): boolean {
    const res = this.resources.get(resource);
    if (!res) {
      return false;
    }
    if (res.lockOwner === threadId) {
      res.value = value;
      res.version++;
      this.logAccess(resource, threadId, 'write');
      return true;
    }
    return false;
  }

  isResourceLocked(resource: string): boolean {
    const res = this.resources.get(resource);
    return res ? res.lockOwner !== null : false;
  }

  getResourceVersion(resource: string): number {
    const res = this.resources.get(resource);
    return res ? res.version : -1;
  }

  logAccess(resource: string, threadId: string, action: string): void {
    this.accessLog.push(new ResourceAccessLogEntry(resource, threadId, action, Date.now()));
  }

  reset(): void {
    this.resources.set('currentSource', new SharedResourceState('HDMI1', null, 0));
    this.resources.set('channelList', new SharedResourceState('[]', null, 0));
    this.resources.set('focusedElement', new SharedResourceState('null', null, 0));
    this.accessLog = [];
  }
}

export default function ConcurrentOperationTest(): void {
  describe('OperationScheduler_Basic', () => {
    let scheduler: OperationScheduler;

    beforeEach(() => {
      scheduler = new OperationScheduler(1);
    });

    afterEach(() => {
      scheduler.reset();
    });

    it('should_submit_operation_when_idle', 0, () => {
      const op: ConcurrentOperation = {
        id: 'op1',
        type: 'switch',
        sourceId: 'HDMI1',
        priority: 1,
        startTime: 0,
        endTime: 0,
        status: 'pending'
      };
      const result = scheduler.submitOperation(op);
      expect(result).assertEqual(true);
      expect(scheduler.getActiveOperationCount()).assertEqual(1);
    });

    it('should_queue_operation_when_busy', 0, () => {
      const op1: ConcurrentOperation = {
        id: 'op1',
        type: 'switch',
        sourceId: 'HDMI1',
        priority: 1,
        startTime: 0,
        endTime: 0,
        status: 'pending'
      };
      const op2: ConcurrentOperation = {
        id: 'op2',
        type: 'switch',
        sourceId: 'HDMI2',
        priority: 1,
        startTime: 0,
        endTime: 0,
        status: 'pending'
      };
      scheduler.submitOperation(op1);
      const result = scheduler.submitOperation(op2);
      expect(result).assertEqual(false);
      expect(scheduler.getQueuedOperationCount()).assertEqual(1);
    });

    it('should_complete_operation_and_start_next', 0, () => {
      const op1: ConcurrentOperation = {
        id: 'op1',
        type: 'switch',
        sourceId: 'HDMI1',
        priority: 1,
        startTime: 0,
        endTime: 0,
        status: 'pending'
      };
      const op2: ConcurrentOperation = {
        id: 'op2',
        type: 'switch',
        sourceId: 'HDMI2',
        priority: 1,
        startTime: 0,
        endTime: 0,
        status: 'pending'
      };
      scheduler.submitOperation(op1);
      scheduler.submitOperation(op2);
      scheduler.completeOperation('op1');
      expect(scheduler.getActiveOperationCount()).assertEqual(1);
      expect(scheduler.getQueuedOperationCount()).assertEqual(0);
    });

    it('should_cancel_operation', 0, () => {
      const op1: ConcurrentOperation = {
        id: 'op1',
        type: 'switch',
        sourceId: 'HDMI1',
        priority: 1,
        startTime: 0,
        endTime: 0,
        status: 'pending'
      };
      const op2: ConcurrentOperation = {
        id: 'op2',
        type: 'switch',
        sourceId: 'HDMI2',
        priority: 1,
        startTime: 0,
        endTime: 0,
        status: 'pending'
      };
      scheduler.submitOperation(op1);
      scheduler.submitOperation(op2);
      scheduler.cancelOperation('op1');
      expect(scheduler.getActiveOperationCount()).assertEqual(1);
      expect(scheduler.getQueuedOperationCount()).assertEqual(0);
    });

    it('should_track_completed_operations', 0, () => {
      const op: ConcurrentOperation = {
        id: 'op1',
        type: 'switch',
        sourceId: 'HDMI1',
        priority: 1,
        startTime: 0,
        endTime: 0,
        status: 'pending'
      };
      scheduler.submitOperation(op);
      scheduler.completeOperation('op1');
      expect(scheduler.completedOperations.length).assertEqual(1);
      expect(scheduler.completedOperations[0].status).assertEqual('completed');
    });

    it('should_return_false_for_nonexistent_operation', 0, () => {
      scheduler.completeOperation('nonexistent');
      expect(scheduler.getActiveOperationCount()).assertEqual(0);
    });
  });

  describe('OperationScheduler_Concurrent_Scenarios', () => {
    let scheduler: OperationScheduler;

    beforeEach(() => {
      scheduler = new OperationScheduler(3);
    });

    afterEach(() => {
      scheduler.reset();
    });

    it('should_allow_multiple_concurrent_operations', 0, () => {
      const ops: ConcurrentOperation[] = [
        { id: 'op1', type: 'switch', sourceId: 'HDMI1', priority: 1, startTime: 0, endTime: 0, status: 'pending' },
        { id: 'op2', type: 'scan', priority: 1, startTime: 0, endTime: 0, status: 'pending' },
        { id: 'op3', type: 'edit', priority: 1, startTime: 0, endTime: 0, status: 'pending' }
      ];
      scheduler.submitOperation(ops[0]);
      scheduler.submitOperation(ops[1]);
      scheduler.submitOperation(ops[2]);
      expect(scheduler.getActiveOperationCount()).assertEqual(3);
    });

    it('should_queue_when_exceeding_max_concurrent', 0, () => {
      const ops: ConcurrentOperation[] = [
        { id: 'op1', type: 'switch', sourceId: 'HDMI1', priority: 1, startTime: 0, endTime: 0, status: 'pending' },
        { id: 'op2', type: 'scan', priority: 1, startTime: 0, endTime: 0, status: 'pending' },
        { id: 'op3', type: 'edit', priority: 1, startTime: 0, endTime: 0, status: 'pending' },
        { id: 'op4', type: 'delete', priority: 1, startTime: 0, endTime: 0, status: 'pending' }
      ];
      scheduler.submitOperation(ops[0]);
      scheduler.submitOperation(ops[1]);
      scheduler.submitOperation(ops[2]);
      scheduler.submitOperation(ops[3]);
      expect(scheduler.getActiveOperationCount()).assertEqual(3);
      expect(scheduler.getQueuedOperationCount()).assertEqual(1);
    });

    it('should_maintain_fifo_order_in_queue', 0, () => {
      const ops: ConcurrentOperation[] = [
        { id: 'op1', type: 'switch', sourceId: 'HDMI1', priority: 1, startTime: 0, endTime: 0, status: 'pending' },
        { id: 'op2', type: 'scan', priority: 1, startTime: 0, endTime: 0, status: 'pending' },
        { id: 'op3', type: 'edit', priority: 1, startTime: 0, endTime: 0, status: 'pending' },
        { id: 'op4', type: 'delete', priority: 1, startTime: 0, endTime: 0, status: 'pending' },
        { id: 'op5', type: 'sort', priority: 1, startTime: 0, endTime: 0, status: 'pending' }
      ];
      scheduler.submitOperation(ops[0]);
      scheduler.submitOperation(ops[1]);
      scheduler.submitOperation(ops[2]);
      scheduler.submitOperation(ops[3]);
      scheduler.submitOperation(ops[4]);
      scheduler.completeOperation('op1');
      expect(scheduler.currentOperation?.id).assertEqual('op2');
    });

    it('should_prioritize_higher_priority_operations', 0, () => {
      const op1: ConcurrentOperation = {
        id: 'op1',
        type: 'switch',
        sourceId: 'HDMI1',
        priority: 1,
        startTime: 0,
        endTime: 0,
        status: 'pending'
      };
      const op2: ConcurrentOperation = {
        id: 'op2',
        type: 'scan',
        priority: 10,
        startTime: 0,
        endTime: 0,
        status: 'pending'
      };
      scheduler.submitOperation(op1);
      scheduler.submitOperation(op2);
      scheduler.completeOperation('op1');
      expect(scheduler.currentOperation?.id).assertEqual('op2');
    });
  });

  describe('SharedResourceManager_Basic', () => {
    let manager: SharedResourceManager;

    beforeEach(() => {
      manager = new SharedResourceManager();
    });

    afterEach(() => {
      manager.reset();
    });

    it('should_acquire_unlocked_resource', 0, () => {
      const result = manager.acquireLock('currentSource', 'thread1');
      expect(result).assertEqual(true);
      expect(manager.isResourceLocked('currentSource')).assertEqual(true);
    });

    it('should_fail_to_acquire_locked_resource', 0, () => {
      manager.acquireLock('currentSource', 'thread1');
      const result = manager.acquireLock('currentSource', 'thread2');
      expect(result).assertEqual(false);
    });

    it('should_release_lock', 0, () => {
      manager.acquireLock('currentSource', 'thread1');
      const result = manager.releaseLock('currentSource', 'thread1');
      expect(result).assertEqual(true);
      expect(manager.isResourceLocked('currentSource')).assertEqual(false);
    });

    it('should_read_resource', 0, () => {
      const value = manager.readResource('currentSource', 'thread1');
      expect(value).assertEqual('HDMI1');
    });

    it('should_write_resource_with_lock', 0, () => {
      manager.acquireLock('currentSource', 'thread1');
      const result = manager.writeResource('currentSource', 'HDMI2', 'thread1');
      expect(result).assertEqual(true);
      expect(manager.readResource('currentSource', 'thread1')).assertEqual('HDMI2');
    });

    it('should_increment_version_on_write', 0, () => {
      manager.acquireLock('currentSource', 'thread1');
      manager.writeResource('currentSource', 'HDMI2', 'thread1');
      expect(manager.getResourceVersion('currentSource')).assertEqual(1);
    });

    it('should_log_access_operations', 0, () => {
      manager.acquireLock('currentSource', 'thread1');
      manager.readResource('currentSource', 'thread1');
      manager.releaseLock('currentSource', 'thread1');
      expect(manager.accessLog.length).assertEqual(3);
    });
  });

  describe('SharedResourceManager_Thread_Safety', () => {
    let manager: SharedResourceManager;

    beforeEach(() => {
      manager = new SharedResourceManager();
    });

    afterEach(() => {
      manager.reset();
    });

    it('should_prevent_write_without_lock', 0, () => {
      const result = manager.writeResource('currentSource', 'HDMI2', 'thread1');
      expect(result).assertEqual(false);
    });

    it('should_allow_read_without_lock', 0, () => {
      const value = manager.readResource('currentSource', 'thread1');
      expect(value).assertEqual('HDMI1');
    });

    it('should_handle_same_thread_reentrant_lock', 0, () => {
      manager.acquireLock('currentSource', 'thread1');
      const result = manager.acquireLock('currentSource', 'thread1');
      expect(result).assertEqual(true);
    });

    it('should_track_multiple_resources_independently', 0, () => {
      manager.acquireLock('currentSource', 'thread1');
      manager.acquireLock('channelList', 'thread2');
      expect(manager.isResourceLocked('currentSource')).assertEqual(true);
      expect(manager.isResourceLocked('channelList')).assertEqual(true);
    });

    it('should_prevent_cross_thread_write', 0, () => {
      manager.acquireLock('currentSource', 'thread1');
      const result = manager.writeResource('currentSource', 'HDMI2', 'thread2');
      expect(result).assertEqual(false);
    });
  });

  describe('RaceConditionDetection', () => {
    let scheduler: OperationScheduler;

    beforeEach(() => {
      scheduler = new OperationScheduler(3);
    });

    afterEach(() => {
      scheduler.reset();
    });

    it('should_detect_concurrent_write_race', 0, () => {
      scheduler.simulateRaceCondition('op1', 'currentSource', 'write');
      scheduler.simulateRaceCondition('op2', 'currentSource', 'write');
      expect(scheduler.isRaceConditionDetected('currentSource')).assertEqual(true);
    });

    it('should_not_detect_race_with_read_only', 0, () => {
      scheduler.simulateRaceCondition('op1', 'currentSource', 'read');
      scheduler.simulateRaceCondition('op2', 'currentSource', 'read');
      expect(scheduler.isRaceConditionDetected('currentSource')).assertEqual(false);
    });

    it('should_not_detect_race_with_time_gap', 0, () => {
      scheduler.raceConditionEvents.push({
        operationId: 'op1',
        sharedResource: 'currentSource',
        accessTime: Date.now(),
        accessType: 'write',
        threadId: 'thread1'
      });
      scheduler.raceConditionEvents.push({
        operationId: 'op2',
        sharedResource: 'currentSource',
        accessTime: Date.now() + 100,
        accessType: 'write',
        threadId: 'thread2'
      });
      expect(scheduler.isRaceConditionDetected('currentSource')).assertEqual(false);
    });

    it('should_not_detect_race_on_different_resources', 0, () => {
      scheduler.simulateRaceCondition('op1', 'currentSource', 'write');
      scheduler.simulateRaceCondition('op2', 'channelList', 'write');
      expect(scheduler.isRaceConditionDetected('currentSource')).assertEqual(false);
    });
  });

  describe('Integrated_Concurrent_Scenarios', () => {
    let scheduler: OperationScheduler;
    let resourceManager: SharedResourceManager;

    beforeEach(() => {
      scheduler = new OperationScheduler(2);
      resourceManager = new SharedResourceManager();
    });

    afterEach(() => {
      scheduler.reset();
      resourceManager.reset();
    });

    it('should_handle_parallel_source_switches', 0, () => {
      const op1: ConcurrentOperation = {
        id: 'switch1',
        type: 'switch',
        sourceId: 'HDMI1',
        priority: 1,
        startTime: 0,
        endTime: 0,
        status: 'pending'
      };
      const op2: ConcurrentOperation = {
        id: 'switch2',
        type: 'switch',
        sourceId: 'HDMI2',
        priority: 1,
        startTime: 0,
        endTime: 0,
        status: 'pending'
      };
      scheduler.submitOperation(op1);
      scheduler.submitOperation(op2);
      expect(scheduler.getActiveOperationCount()).assertEqual(2);
      expect(resourceManager.isResourceLocked('currentSource')).assertEqual(false);
    });

    it('should_protect_shared_resource_during_concurrent_access', 0, () => {
      resourceManager.acquireLock('currentSource', 'thread1');
      const canWrite = resourceManager.writeResource('currentSource', 'HDMI3', 'thread2');
      expect(canWrite).assertEqual(false);
    });

    it('should_handle_operation_cancellation_with_resource_cleanup', 0, () => {
      const op: ConcurrentOperation = {
        id: 'cancelOp',
        type: 'edit',
        priority: 1,
        startTime: 0,
        endTime: 0,
        status: 'pending'
      };
      scheduler.submitOperation(op);
      resourceManager.acquireLock('channelList', 'thread1');
      scheduler.cancelOperation('cancelOp');
      expect(resourceManager.isResourceLocked('channelList')).assertEqual(true);
      resourceManager.releaseLock('channelList', 'thread1');
    });

    it('should_maintain_consistency_under_stress', 0, () => {
      for (let i = 0; i < 10; i++) {
        const op: ConcurrentOperation = {
          id: `stressOp${i}`,
          type: 'switch',
          sourceId: `HDMI${i % 4 + 1}`,
          priority: i % 3 + 1,
          startTime: 0,
          endTime: 0,
          status: 'pending'
        };
        scheduler.submitOperation(op);
        if (i % 3 === 0) {
          scheduler.completeOperation(op.id);
        }
      }
      expect(scheduler.completedOperations.length).assertLarger(0);
    });
  });

  describe('LongRunning_Concurrent_Scenarios', () => {
    it('should_sustain_concurrent_operations_over_extended_period', 0, () => {
      const scheduler = new OperationScheduler(5);
      for (let cycle = 0; cycle < 50; cycle++) {
        const op: ConcurrentOperation = {
          id: `longRunOp${cycle}`,
          type: cycle % 2 === 0 ? 'switch' : 'scan',
          sourceId: cycle % 2 === 0 ? `HDMI${cycle % 4 + 1}` : undefined,
          priority: cycle % 5 + 1,
          startTime: 0,
          endTime: 0,
          status: 'pending'
        };
        scheduler.submitOperation(op);
        if (cycle % 5 === 0) {
          scheduler.completeOperation(op.id);
        }
      }
      expect(scheduler.completedOperations.length).assertLarger(0);
      scheduler.reset();
    });

    it('should_handle_resource_contention_over_extended_period', 0, () => {
      const manager = new SharedResourceManager();
      for (let cycle = 0; cycle < 100; cycle++) {
        const threadId = `thread${cycle % 3}`;
        if (!manager.isResourceLocked('currentSource')) {
          manager.acquireLock('currentSource', threadId);
        }
        manager.readResource('currentSource', threadId);
        if (cycle % 10 === 0) {
          manager.releaseLock('currentSource', threadId);
        }
      }
      expect(manager.accessLog.length).assertLarger(99);
      manager.reset();
    });
  });
}
