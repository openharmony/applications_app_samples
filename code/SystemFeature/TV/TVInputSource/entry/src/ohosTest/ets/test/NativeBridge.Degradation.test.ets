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

interface NativeBridgeMetrics {
  latencyMs: number;
  successCount: number;
  failureCount: number;
  timeoutCount: number;
  lastCallTime: number;
  degraded: boolean;
}

interface BridgeHealthStatus {
  bridgeName: string;
  state: 'healthy' | 'degraded' | 'failed' | 'unknown';
  errorCode: number;
  errorMessage: string;
  recoveryAttempts: number;
  lastRecoveryTime: number;
}

interface FallbackChain {
  primary: string;
  secondary: string | null;
  tertiary: string | null;
  currentActive: string;
  fallbackCount: number;
}

class NativeBridgeMonitor {
  public metrics: Map<string, NativeBridgeMetrics> = new Map();
  public healthStatuses: Map<string, BridgeHealthStatus> = new Map();
  public fallbackChains: Map<string, FallbackChain> = new Map();
  public latencyThreshold: number = 50;
  public failureThreshold: number = 5;
  public timeoutThreshold: number = 3;

  constructor() {
    this.initializeBridge('SourceManager');
    this.initializeBridge('DtvManager');
    this.initializeBridge('InputSourceModel');
    this.initializeBridge('HdmiPage');
  }

  initializeBridge(bridgeName: string): void {
    this.metrics.set(bridgeName, {
      latencyMs: 0,
      successCount: 0,
      failureCount: 0,
      timeoutCount: 0,
      lastCallTime: 0,
      degraded: false
    });
    this.healthStatuses.set(bridgeName, {
      bridgeName,
      state: 'healthy',
      errorCode: 0,
      errorMessage: '',
      recoveryAttempts: 0,
      lastRecoveryTime: 0
    });
    this.fallbackChains.set(bridgeName, {
      primary: bridgeName,
      secondary: null,
      tertiary: null,
      currentActive: bridgeName,
      fallbackCount: 0
    });
  }

  recordCall(bridgeName: string, success: boolean, latencyMs: number, timeout: boolean = false): void {
    const metrics = this.metrics.get(bridgeName);
    if (!metrics) {
      return;
    }
    metrics.lastCallTime = Date.now();
    metrics.latencyMs = latencyMs;
    if (timeout) {
      metrics.timeoutCount++;
    } else if (success) {
      metrics.successCount++;
    } else {
      metrics.failureCount++;
    }
    this.evaluateDegradation(bridgeName);
  }

  evaluateDegradation(bridgeName: string): void {
    const metrics = this.metrics.get(bridgeName);
    const status = this.healthStatuses.get(bridgeName);
    if (!metrics || !status) {
      return;
    }
    const totalCalls = metrics.successCount + metrics.failureCount + metrics.timeoutCount;
    const failureRate = (metrics.failureCount + metrics.timeoutCount) / totalCalls;
    const isHighLatency = metrics.latencyMs > this.latencyThreshold;
    const recentTimeouts = metrics.timeoutCount >= this.timeoutThreshold;
    if (isHighLatency || recentTimeouts) {
      metrics.degraded = true;
      status.state = 'degraded';
      return;
    }
    if (totalCalls <= this.failureThreshold) {
      return;
    }
    if (failureRate > 0.5) {
      metrics.degraded = true;
      status.state = 'degraded';
    }
  }

  getHealthStatus(bridgeName: string): BridgeHealthStatus | null {
    return this.healthStatuses.get(bridgeName) || null;
  }

  isBridgeDegraded(bridgeName: string): boolean {
    const metrics = this.metrics.get(bridgeName);
    return metrics ? metrics.degraded : false;
  }

  isBridgeHealthy(bridgeName: string): boolean {
    const status = this.healthStatuses.get(bridgeName);
    return status ? status.state === 'healthy' : false;
  }

  recordError(bridgeName: string, errorCode: number, errorMessage: string): void {
    const status = this.healthStatuses.get(bridgeName);
    if (!status) {
      return;
    }
    status.errorCode = errorCode;
    status.errorMessage = errorMessage;
    if (status.state === 'healthy') {
      status.state = 'failed';
    }
  }

  attemptRecovery(bridgeName: string): boolean {
    const status = this.healthStatuses.get(bridgeName);
    if (!status) {
      return false;
    }
    status.recoveryAttempts++;
    status.lastRecoveryTime = Date.now();
    if (status.state === 'failed' || status.state === 'degraded') {
      status.state = 'healthy';
      status.errorCode = 0;
      status.errorMessage = '';
      const metrics = this.metrics.get(bridgeName);
      if (metrics) {
        metrics.degraded = false;
        metrics.failureCount = 0;
        metrics.timeoutCount = 0;
      }
      const chain = this.fallbackChains.get(bridgeName);
      if (chain) {
        chain.currentActive = chain.primary;
      }
      return true;
    }
    return false;
  }

  setFallbackChain(bridgeName: string, secondary: string | null, tertiary: string | null): void {
    const chain = this.fallbackChains.get(bridgeName);
    if (!chain) {
      return;
    }
    chain.secondary = secondary;
    chain.tertiary = tertiary;
  }

  triggerFallback(bridgeName: string): string | null {
    const chain = this.fallbackChains.get(bridgeName);
    if (!chain) {
      return null;
    }
    if (chain.secondary !== null && chain.currentActive === chain.primary) {
      chain.currentActive = chain.secondary;
      chain.fallbackCount++;
      if (!this.metrics.has(chain.secondary)) {
        this.initializeBridge(chain.secondary);
      }
      return chain.secondary;
    }
    if (chain.tertiary !== null && chain.currentActive === chain.secondary) {
      chain.currentActive = chain.tertiary;
      chain.fallbackCount++;
      if (!this.metrics.has(chain.tertiary)) {
        this.initializeBridge(chain.tertiary);
      }
      return chain.tertiary;
    }
    return null;
  }

  getCurrentActive(bridgeName: string): string {
    const chain = this.fallbackChains.get(bridgeName);
    return chain ? chain.currentActive : bridgeName;
  }

  getFallbackCount(bridgeName: string): number {
    const chain = this.fallbackChains.get(bridgeName);
    return chain ? chain.fallbackCount : 0;
  }

  getTotalCalls(bridgeName: string): number {
    const metrics = this.metrics.get(bridgeName);
    if (!metrics) {
      return 0;
    }
    return metrics.successCount + metrics.failureCount + metrics.timeoutCount;
  }

  getSuccessRate(bridgeName: string): number {
    const metrics = this.metrics.get(bridgeName);
    if (!metrics) {
      return 0;
    }
    const total = this.getTotalCalls(bridgeName);
    if (total === 0) {
      return 100;
    }
    return Math.round((metrics.successCount / total) * 100);
  }

  resetBridge(bridgeName: string): void {
    this.initializeBridge(bridgeName);
  }

  resetAll(): void {
    const bridgeNames: string[] = Array.from(this.metrics.keys());
    for (const name of bridgeNames) {
      this.resetBridge(name);
    }
  }
}

export default function NativeBridgeDegradationTest(): void {
  describe('NativeBridgeMonitor_Basic', () => {
    let monitor: NativeBridgeMonitor;

    beforeEach(() => {
      monitor = new NativeBridgeMonitor();
    });

    afterEach(() => {
      monitor.resetAll();
    });

    it('should_initialize_with_healthy_status', 0, () => {
      const status = monitor.getHealthStatus('SourceManager');
      expect(((status) === null) || ((status) === undefined)).assertFalse();
      expect(status!.state).assertEqual('healthy');
      expect(status!.errorCode).assertEqual(0);
    });

    it('should_record_successful_call', 0, () => {
      monitor.recordCall('SourceManager', true, 10, false);
      expect(monitor.getTotalCalls('SourceManager')).assertEqual(1);
      expect(monitor.getSuccessRate('SourceManager')).assertEqual(100);
    });

    it('should_record_failed_call', 0, () => {
      monitor.recordCall('SourceManager', false, 0, false);
      expect(monitor.getTotalCalls('SourceManager')).assertEqual(1);
      expect(monitor.getSuccessRate('SourceManager')).assertEqual(0);
    });

    it('should_record_timeout_call', 0, () => {
      monitor.recordCall('SourceManager', false, 100, true);
      expect(monitor.getTotalCalls('SourceManager')).assertEqual(1);
      const metrics = monitor.metrics.get('SourceManager');
      expect(metrics!.timeoutCount).assertEqual(1);
    });

    it('should_detect_degradation_from_high_failure_rate', 0, () => {
      for (let i = 0; i < 6; i++) {
        monitor.recordCall('SourceManager', false, 0, false);
      }
      expect(monitor.isBridgeDegraded('SourceManager')).assertEqual(true);
    });

    it('should_detect_degradation_from_high_latency', 0, () => {
      monitor.recordCall('SourceManager', true, 100, false);
      expect(monitor.isBridgeDegraded('SourceManager')).assertEqual(true);
    });

    it('should_detect_degradation_from_timeouts', 0, () => {
      monitor.recordCall('SourceManager', false, 100, true);
      monitor.recordCall('SourceManager', false, 100, true);
      monitor.recordCall('SourceManager', false, 100, true);
      expect(monitor.isBridgeDegraded('SourceManager')).assertEqual(true);
    });

    it('should_record_error_details', 0, () => {
      monitor.recordError('SourceManager', 1001, 'Native module not found');
      const status = monitor.getHealthStatus('SourceManager');
      expect(status!.errorCode).assertEqual(1001);
      expect(status!.errorMessage).assertEqual('Native module not found');
      expect(status!.state).assertEqual('failed');
    });

    it('should_attempt_recovery', 0, () => {
      monitor.recordError('SourceManager', 1001, 'Native module not found');
      const recovered = monitor.attemptRecovery('SourceManager');
      expect(recovered).assertEqual(true);
      expect(monitor.isBridgeHealthy('SourceManager')).assertEqual(true);
    });

    it('should_reset_metrics_after_recovery', 0, () => {
      for (let i = 0; i < 6; i++) {
        monitor.recordCall('SourceManager', false, 0, false);
      }
      monitor.attemptRecovery('SourceManager');
      const metrics = monitor.metrics.get('SourceManager');
      expect(metrics!.failureCount).assertEqual(0);
      expect(metrics!.timeoutCount).assertEqual(0);
    });

    it('should_calculate_success_rate_correctly', 0, () => {
      for (let i = 0; i < 3; i++) {
        monitor.recordCall('SourceManager', true, 10, false);
      }
      monitor.recordCall('SourceManager', false, 0, false);
      expect(monitor.getSuccessRate('SourceManager')).assertEqual(75);
    });
  });

  describe('NativeBridgeMonitor_Fallback_Chain', () => {
    let monitor: NativeBridgeMonitor;

    beforeEach(() => {
      monitor = new NativeBridgeMonitor();
    });

    afterEach(() => {
      monitor.resetAll();
    });

    it('should_set_fallback_chain', 0, () => {
      monitor.setFallbackChain('SourceManager', 'BackupSourceManager', null);
      const chain = monitor.fallbackChains.get('SourceManager');
      expect(chain!.secondary).assertEqual('BackupSourceManager');
      expect(chain!.tertiary).assertNull();
    });

    it('should_trigger_fallback_to_secondary', 0, () => {
      monitor.setFallbackChain('SourceManager', 'BackupSourceManager', null);
      const fallback = monitor.triggerFallback('SourceManager');
      expect(fallback).assertEqual('BackupSourceManager');
      expect(monitor.getCurrentActive('SourceManager')).assertEqual('BackupSourceManager');
    });

    it('should_trigger_fallback_to_tertiary', 0, () => {
      monitor.setFallbackChain('SourceManager', 'BackupSourceManager', 'FinalBackupManager');
      monitor.triggerFallback('SourceManager');
      const fallback = monitor.triggerFallback('SourceManager');
      expect(fallback).assertEqual('FinalBackupManager');
      expect(monitor.getCurrentActive('SourceManager')).assertEqual('FinalBackupManager');
    });

    it('should_not_fallback_when_no_alternative_available', 0, () => {
      monitor.initializeBridge('StandaloneBridge');
      const fallback = monitor.triggerFallback('StandaloneBridge');
      expect(fallback).assertNull();
    });

    it('should_count_fallback_occurrences', 0, () => {
      monitor.setFallbackChain('SourceManager', 'BackupSourceManager', 'FinalBackupManager');
      monitor.triggerFallback('SourceManager');
      monitor.triggerFallback('SourceManager');
      expect(monitor.getFallbackCount('SourceManager')).assertEqual(2);
    });

    it('should_not_trigger_fallback_beyond_tertiary', 0, () => {
      monitor.setFallbackChain('SourceManager', 'BackupSourceManager', 'FinalBackupManager');
      monitor.triggerFallback('SourceManager');
      monitor.triggerFallback('SourceManager');
      const fallback = monitor.triggerFallback('SourceManager');
      expect(fallback).assertNull();
      expect(monitor.getCurrentActive('SourceManager')).assertEqual('FinalBackupManager');
    });
  });

  describe('NativeBridgeMonitor_Multi_Bridge_Scenarios', () => {
    let monitor: NativeBridgeMonitor;

    beforeEach(() => {
      monitor = new NativeBridgeMonitor();
    });

    afterEach(() => {
      monitor.resetAll();
    });

    it('should_track_multiple_bridges_independently', 0, () => {
      monitor.recordCall('SourceManager', false, 0, false);
      monitor.recordCall('DtvManager', true, 10, false);
      expect(monitor.isBridgeDegraded('SourceManager')).assertEqual(false);
      expect(monitor.isBridgeDegraded('DtvManager')).assertEqual(false);
      expect(monitor.getSuccessRate('SourceManager')).assertEqual(0);
      expect(monitor.getSuccessRate('DtvManager')).assertEqual(100);
    });

    it('should_handle_partial_degradation', 0, () => {
      for (let i = 0; i < 6; i++) {
        monitor.recordCall('SourceManager', false, 0, false);
      }
      monitor.recordCall('DtvManager', true, 10, false);
      expect(monitor.isBridgeDegraded('SourceManager')).assertEqual(true);
      expect(monitor.isBridgeHealthy('DtvManager')).assertEqual(true);
    });

    it('should_recover_one_bridge_without_affecting_others', 0, () => {
      for (let i = 0; i < 6; i++) {
        monitor.recordCall('SourceManager', false, 0, false);
      }
      for (let i = 0; i < 6; i++) {
        monitor.recordCall('DtvManager', false, 0, false);
      }
      monitor.attemptRecovery('SourceManager');
      expect(monitor.isBridgeHealthy('SourceManager')).assertEqual(true);
      expect(monitor.isBridgeDegraded('DtvManager')).assertEqual(true);
    });

    it('should_set_different_fallback_chains_for_different_bridges', 0, () => {
      monitor.setFallbackChain('SourceManager', 'BackupSM', null);
      monitor.setFallbackChain('DtvManager', 'BackupDM', 'FinalBackupDM');
      const fallbackSM = monitor.triggerFallback('SourceManager');
      const fallbackDM = monitor.triggerFallback('DtvManager');
      expect(fallbackSM).assertEqual('BackupSM');
      expect(fallbackDM).assertEqual('BackupDM');
    });
  });

  describe('NativeBridgeMonitor_Degradation_Recovery_Cycles', () => {
    let monitor: NativeBridgeMonitor;

    beforeEach(() => {
      monitor = new NativeBridgeMonitor();
    });

    afterEach(() => {
      monitor.resetAll();
    });

    it('should_handle_degradation_recovery_cycle', 0, () => {
      for (let i = 0; i < 6; i++) {
        monitor.recordCall('SourceManager', false, 0, false);
      }
      expect(monitor.isBridgeDegraded('SourceManager')).assertEqual(true);
      monitor.attemptRecovery('SourceManager');
      expect(monitor.isBridgeHealthy('SourceManager')).assertEqual(true);
    });

    it('should_handle_multiple_degradation_cycles', 0, () => {
      for (let i = 0; i < 6; i++) {
        monitor.recordCall('SourceManager', false, 0, false);
      }
      monitor.attemptRecovery('SourceManager');
      for (let i = 0; i < 6; i++) {
        monitor.recordCall('SourceManager', false, 0, false);
      }
      expect(monitor.isBridgeDegraded('SourceManager')).assertEqual(true);
      monitor.attemptRecovery('SourceManager');
      expect(monitor.isBridgeHealthy('SourceManager')).assertEqual(true);
    });

    it('should_accumulate_recovery_attempts', 0, () => {
      for (let i = 0; i < 6; i++) {
        monitor.recordCall('SourceManager', false, 0, false);
      }
      monitor.attemptRecovery('SourceManager');
      for (let i = 0; i < 6; i++) {
        monitor.recordCall('SourceManager', false, 0, false);
      }
      monitor.attemptRecovery('SourceManager');
      const status = monitor.getHealthStatus('SourceManager');
      expect(status!.recoveryAttempts).assertEqual(2);
    });

    it('should_handle_rapid_failure_recovery_cycles', 0, () => {
      for (let cycle = 0; cycle < 10; cycle++) {
        for (let i = 0; i < 6; i++) {
          monitor.recordCall('SourceManager', false, 0, false);
        }
        monitor.attemptRecovery('SourceManager');
      }
      const status = monitor.getHealthStatus('SourceManager');
      expect(status!.recoveryAttempts).assertEqual(10);
    });

    it('should_track_last_call_time', 0, () => {
      const beforeCall = Date.now();
      monitor.recordCall('SourceManager', true, 10, false);
      const afterCall = Date.now();
      const metrics = monitor.metrics.get('SourceManager');
      expect(metrics!.lastCallTime).assertLarger(beforeCall - 1);
      expect(metrics!.lastCallTime).assertLessOrEqual(afterCall);
    });
  });

  describe('NativeBridgeMonitor_Edge_Cases', () => {
    let monitor: NativeBridgeMonitor;

    beforeEach(() => {
      monitor = new NativeBridgeMonitor();
    });

    afterEach(() => {
      monitor.resetAll();
    });

    it('should_handle_zero_calls_gracefully', 0, () => {
      expect(monitor.getSuccessRate('SourceManager')).assertEqual(100);
      expect(monitor.isBridgeDegraded('SourceManager')).assertEqual(false);
    });

    it('should_handle_unknown_bridge_name', 0, () => {
      expect(monitor.getHealthStatus('UnknownBridge')).assertNull();
      expect(monitor.isBridgeDegraded('UnknownBridge')).assertEqual(false);
      expect(monitor.getSuccessRate('UnknownBridge')).assertEqual(0);
    });

    it('should_handle_all_successful_calls', 0, () => {
      for (let i = 0; i < 100; i++) {
        monitor.recordCall('SourceManager', true, 10, false);
      }
      expect(monitor.getSuccessRate('SourceManager')).assertEqual(100);
      expect(monitor.isBridgeDegraded('SourceManager')).assertEqual(false);
    });

    it('should_handle_all_failed_calls', 0, () => {
      for (let i = 0; i < 10; i++) {
        monitor.recordCall('SourceManager', false, 0, false);
      }
      expect(monitor.getSuccessRate('SourceManager')).assertEqual(0);
      expect(monitor.isBridgeDegraded('SourceManager')).assertEqual(true);
    });

    it('should_handle_exactly_threshold_failures', 0, () => {
      for (let i = 0; i < 5; i++) {
        monitor.recordCall('SourceManager', false, 0, false);
      }
      expect(monitor.isBridgeDegraded('SourceManager')).assertEqual(false);
      monitor.recordCall('SourceManager', false, 0, false);
      expect(monitor.isBridgeDegraded('SourceManager')).assertEqual(true);
    });

    it('should_handle_recovery_attempt_when_healthy', 0, () => {
      const recovered = monitor.attemptRecovery('SourceManager');
      expect(recovered).assertEqual(false);
      expect(monitor.isBridgeHealthy('SourceManager')).assertEqual(true);
    });

    it('should_reset_bridge_independently', 0, () => {
      for (let i = 0; i < 6; i++) {
        monitor.recordCall('SourceManager', false, 0, false);
      }
      monitor.recordError('DtvManager', 1001, 'Error');
      monitor.resetBridge('SourceManager');
      expect(monitor.isBridgeHealthy('SourceManager')).assertEqual(true);
      expect(monitor.isBridgeHealthy('DtvManager')).assertEqual(false);
    });
  });

  describe('NativeBridgeMonitor_Integrated_Scenarios', () => {
    let monitor: NativeBridgeMonitor;

    beforeEach(() => {
      monitor = new NativeBridgeMonitor();
    });

    afterEach(() => {
      monitor.resetAll();
    });

    it('should_handle_source_switch_with_fallback', 0, () => {
      monitor.setFallbackChain('SourceManager', 'BackupSourceManager', null);
      for (let i = 0; i < 6; i++) {
        monitor.recordCall('SourceManager', false, 0, false);
      }
      const fallback = monitor.triggerFallback('SourceManager');
      expect(fallback).assertEqual('BackupSourceManager');
      monitor.recordCall('BackupSourceManager', true, 10, false);
      expect(monitor.isBridgeHealthy('BackupSourceManager')).assertEqual(true);
    });

    it('should_handle_full_degradation_with_multiple_fallbacks', 0, () => {
      monitor.setFallbackChain('SourceManager', 'BackupSM', 'FinalBackupSM');
      for (let i = 0; i < 6; i++) {
        monitor.recordCall('SourceManager', false, 0, false);
      }
      for (let i = 0; i < 6; i++) {
        monitor.recordCall('BackupSM', false, 0, false);
      }
      monitor.triggerFallback('SourceManager');
      monitor.triggerFallback('SourceManager');
      expect(monitor.getCurrentActive('SourceManager')).assertEqual('FinalBackupSM');
    });

    it('should_handle_concurrent_bridge_failures', 0, () => {
      for (let i = 0; i < 6; i++) {
        monitor.recordCall('SourceManager', false, 0, false);
        monitor.recordCall('DtvManager', false, 0, false);
      }
      expect(monitor.isBridgeDegraded('SourceManager')).assertEqual(true);
      expect(monitor.isBridgeDegraded('DtvManager')).assertEqual(true);
      monitor.attemptRecovery('SourceManager');
      monitor.attemptRecovery('DtvManager');
      expect(monitor.isBridgeHealthy('SourceManager')).assertEqual(true);
      expect(monitor.isBridgeHealthy('DtvManager')).assertEqual(true);
    });

    it('should_maintain_health_across_operation_cycles', 0, () => {
      for (let cycle = 0; cycle < 5; cycle++) {
        for (let i = 0; i < 5; i++) {
          monitor.recordCall('SourceManager', true, 10, false);
        }
        monitor.recordCall('SourceManager', false, 0, false);
        monitor.attemptRecovery('SourceManager');
      }
      expect(monitor.isBridgeHealthy('SourceManager')).assertEqual(true);
    });
  });

  describe('NativeBridgeMonitor_LongRunning_Scenarios', () => {
    it('should_sustain_monitoring_over_extended_period', 0, () => {
      const monitor = new NativeBridgeMonitor();
      for (let cycle = 0; cycle < 100; cycle++) {
        const success = Math.random() > 0.1;
        monitor.recordCall('SourceManager', success, 10 + (cycle % 50), false);
      }
      expect(monitor.getTotalCalls('SourceManager')).assertEqual(100);
      monitor.resetAll();
    });

    it('should_handle_bridge_churn_over_extended_period', 0, () => {
      const monitor = new NativeBridgeMonitor();
      monitor.setFallbackChain('SourceManager', 'BackupSM', 'FinalBackupSM');
      for (let cycle = 0; cycle < 50; cycle++) {
        for (let i = 0; i < 6; i++) {
          monitor.recordCall('SourceManager', false, 0, false);
        }
        monitor.triggerFallback('SourceManager');
        monitor.attemptRecovery('SourceManager');
      }
      expect(monitor.getFallbackCount('SourceManager')).assertEqual(50);
      monitor.resetAll();
    });
  });
}
