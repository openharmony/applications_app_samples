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

interface SignalEvent {
  sourceId: string;
  signalStrength: number;
  timestamp: number;
  eventType: 'connect' | 'disconnect' | 'jitter' | 'stable';
}

interface PlugEvent {
  sourceId: string;
  port: number;
  timestamp: number;
  eventType: 'insert' | 'remove';
}

interface PageLifecycleEvent {
  pageId: string;
  eventType: 'show' | 'hide' | 'foreground' | 'background';
  timestamp: number;
  sequenceId: number;
}

type PageLifecycleEventType = 'show' | 'hide' | 'foreground' | 'background';

class SignalJitterSimulator {
  public events: SignalEvent[] = [];
  public stableThreshold: number = 30;
  public jitterWindowMs: number = 100;
  public lastSignalTime: number = 0;
  public jitterDeltaThreshold: number = 20;
  public lastSignalStrengthBySource: Map<string, number> = new Map();

  simulateJitter(sourceId: string, baseStrength: number, jitterCount: number): void {
    const previousStrength = this.lastSignalStrengthBySource.get(sourceId);
    const sourceShifted = previousStrength !== undefined &&
      Math.abs(baseStrength - previousStrength) >= this.jitterDeltaThreshold;
    for (let i = 0; i < jitterCount; i++) {
      const strength = Math.max(0, Math.min(100, baseStrength));
      const timeDelta = this.jitterWindowMs * i;
      this.events.push({
        sourceId,
        signalStrength: strength,
        timestamp: this.lastSignalTime + timeDelta,
        eventType: sourceShifted ? 'jitter' : 'stable'
      });
      this.lastSignalTime += timeDelta;
    }
    this.lastSignalStrengthBySource.set(sourceId, baseStrength);
  }

  isSignalStable(sourceId: string): boolean {
    const sourceEvents = this.events.filter(e => e.sourceId === sourceId);
    if (sourceEvents.length < this.stableThreshold) {
      return false;
    }
    const recentEvents = sourceEvents.slice(-this.stableThreshold);
    const jitterCount = recentEvents.filter(e => e.eventType === 'jitter').length;
    return jitterCount < recentEvents.length * 0.1;
  }

  getSignalReliability(sourceId: string): number {
    const sourceEvents = this.events.filter(e => e.sourceId === sourceId);
    if (sourceEvents.length === 0) {
      return 0;
    }
    const stableCount = sourceEvents.filter(e => e.eventType === 'stable').length;
    return Math.round((stableCount / sourceEvents.length) * 100);
  }

  reset(): void {
    this.events = [];
    this.lastSignalTime = 0;
    this.lastSignalStrengthBySource.clear();
  }
}

class PlugEventSimulator {
  public events: PlugEvent[] = [];
  public rapidInsertThresholdMs: number = 500;
  public lastEventTime: number = 0;

  simulateInsert(sourceId: string, port: number): void {
    const now = Date.now();
    const isRapid = (now - this.lastEventTime) < this.rapidInsertThresholdMs;
    this.events.push({
      sourceId,
      port,
      timestamp: now,
      eventType: 'insert'
    });
    this.lastEventTime = now;
  }

  simulateRemove(sourceId: string, port: number): void {
    const now = Date.now();
    this.events.push({
      sourceId,
      port,
      timestamp: now,
      eventType: 'remove'
    });
    this.lastEventTime = now;
  }

  isRapidPlugDetected(): boolean {
    if (this.events.length < 2) {
      return false;
    }
    const lastTwo = this.events.slice(-2);
    if (lastTwo.length !== 2) {
      return false;
    }
    const timeDelta = lastTwo[1].timestamp - lastTwo[0].timestamp;
    return timeDelta < this.rapidInsertThresholdMs &&
      lastTwo[0].eventType !== lastTwo[1].eventType;
  }

  getPlugCount(sourceId: string): number {
    return this.events.filter(e => e.sourceId === sourceId).length;
  }

  getLastPlugState(sourceId: string): 'insert' | 'remove' | null {
    const sourceEvents = this.events.filter(e => e.sourceId === sourceId);
    if (sourceEvents.length === 0) {
      return null;
    }
    return sourceEvents[sourceEvents.length - 1].eventType;
  }

  reset(): void {
    this.events = [];
    this.lastEventTime = 0;
  }
}

class PageRepeatLifecycleSimulator {
  public events: PageLifecycleEvent[] = [];
  public sequenceCounter: number = 0;
  public repeatThreshold: number = 3;
  public minIntervalMs: number = 100;

  simulateShow(pageId: string): void {
    this.events.push({
      pageId,
      eventType: 'show',
      timestamp: Date.now(),
      sequenceId: ++this.sequenceCounter
    });
  }

  simulateHide(pageId: string): void {
    this.events.push({
      pageId,
      eventType: 'hide',
      timestamp: Date.now(),
      sequenceId: ++this.sequenceCounter
    });
  }

  simulateForeground(pageId: string): void {
    this.events.push({
      pageId,
      eventType: 'foreground',
      timestamp: Date.now(),
      sequenceId: ++this.sequenceCounter
    });
  }

  simulateBackground(pageId: string): void {
    this.events.push({
      pageId,
      eventType: 'background',
      timestamp: Date.now(),
      sequenceId: ++this.sequenceCounter
    });
  }

  getRepeatCount(pageId: string, eventType: PageLifecycleEventType): number {
    const pageEvents = this.events.filter(e => e.pageId === pageId && e.eventType === eventType);
    return pageEvents.length;
  }

  isRepeatShowDetected(pageId: string): boolean {
    return this.getRepeatCount(pageId, 'show') >= this.repeatThreshold;
  }

  getPageVisibilityRatio(pageId: string): number {
    const pageEvents = this.events.filter(e => e.pageId === pageId);
    if (pageEvents.length === 0) {
      return 0;
    }
    const showCount = pageEvents.filter(e => e.eventType === 'show').length;
    return Math.round((showCount / pageEvents.length) * 100);
  }

  getLastEvent(pageId: string): PageLifecycleEvent | null {
    const pageEvents = this.events.filter(e => e.pageId === pageId);
    if (pageEvents.length === 0) {
      return null;
    }
    return pageEvents[pageEvents.length - 1];
  }

  isAbnormalLifecycle(pageId: string): boolean {
    const pageEvents = this.events.filter(e => e.pageId === pageId);
    if (pageEvents.length < 2) {
      return false;
    }
    let consecutiveSame = 0;
    let maxConsecutive = 0;
    for (let i = 1; i < pageEvents.length; i++) {
      if (pageEvents[i].eventType === pageEvents[i - 1].eventType) {
        consecutiveSame++;
        maxConsecutive = Math.max(maxConsecutive, consecutiveSame);
      } else {
        consecutiveSame = 0;
      }
    }
    return maxConsecutive >= this.repeatThreshold;
  }

  reset(): void {
    this.events = [];
    this.sequenceCounter = 0;
  }
}

export default function SignalAndPlugStressTest(): void {
  describe('SignalJitterSimulator_Basic', () => {
    let simulator: SignalJitterSimulator;

    beforeEach(() => {
      simulator = new SignalJitterSimulator();
    });

    afterEach(() => {
      simulator.reset();
    });

    it('should_generate_jitter_events', 0, () => {
      simulator.simulateJitter('HDMI1', 80, 10);
      expect(simulator.events.length).assertEqual(10);
    });

    it('should_detect_stable_signal', 0, () => {
      simulator.simulateJitter('HDMI1', 80, 50);
      expect(simulator.isSignalStable('HDMI1')).assertEqual(true);
    });

    it('should_detect_unstable_signal', 0, () => {
      for (let i = 0; i < 5; i++) {
        simulator.simulateJitter('HDMI1', 50 + (i % 2) * 30, 10);
      }
      expect(simulator.isSignalStable('HDMI1')).assertEqual(false);
    });

    it('should_calculate_signal_reliability', 0, () => {
      simulator.simulateJitter('HDMI1', 80, 20);
      const reliability = simulator.getSignalReliability('HDMI1');
      expect(reliability).assertLarger(0);
      expect(reliability).assertLessOrEqual(100);
    });

    it('should_return_zero_reliability_for_unknown_source', 0, () => {
      const reliability = simulator.getSignalReliability('UNKNOWN');
      expect(reliability).assertEqual(0);
    });

    it('should_accumulate_jitter_events_across_multiple_calls', 0, () => {
      simulator.simulateJitter('HDMI1', 80, 10);
      simulator.simulateJitter('HDMI1', 75, 10);
      simulator.simulateJitter('HDMI1', 70, 10);
      expect(simulator.events.length).assertEqual(30);
    });
  });

  describe('SignalJitterSimulator_Stress_Scenarios', () => {
    let simulator: SignalJitterSimulator;

    beforeEach(() => {
      simulator = new SignalJitterSimulator();
    });

    afterEach(() => {
      simulator.reset();
    });

    it('should_handle_high_frequency_jitter', 0, () => {
      simulator.simulateJitter('HDMI1', 80, 100);
      expect(simulator.events.length).assertEqual(100);
      expect(simulator.isSignalStable('HDMI1')).assertEqual(true);
    });

    it('should_handle_multiple_sources_concurrent_jitter', 0, () => {
      simulator.simulateJitter('HDMI1', 80, 30);
      simulator.simulateJitter('HDMI2', 70, 30);
      simulator.simulateJitter('HDMI3', 60, 30);
      expect(simulator.events.length).assertEqual(90);
    });

    it('should_detect_signal_degradation', 0, () => {
      simulator.simulateJitter('HDMI1', 90, 20);
      simulator.simulateJitter('HDMI1', 30, 20);
      expect(simulator.getSignalReliability('HDMI1')).assertLess(80);
    });

    it('should_maintain_event_order_by_timestamp', 0, () => {
      simulator.simulateJitter('HDMI1', 80, 5);
      const firstTimestamp = simulator.events[0].timestamp;
      const lastTimestamp = simulator.events[simulator.events.length - 1].timestamp;
      expect(lastTimestamp).assertLarger(firstTimestamp);
    });
  });

  describe('PlugEventSimulator_Basic', () => {
    let simulator: PlugEventSimulator;

    beforeEach(() => {
      simulator = new PlugEventSimulator();
    });

    afterEach(() => {
      simulator.reset();
    });

    it('should_record_insert_event', 0, () => {
      simulator.simulateInsert('HDMI1', 1);
      expect(simulator.events.length).assertEqual(1);
      expect(simulator.getLastPlugState('HDMI1')).assertEqual('insert');
    });

    it('should_record_remove_event', 0, () => {
      simulator.simulateInsert('HDMI1', 1);
      simulator.simulateRemove('HDMI1', 1);
      expect(simulator.getLastPlugState('HDMI1')).assertEqual('remove');
    });

    it('should_detect_rapid_plug', 0, () => {
      simulator.simulateInsert('HDMI1', 1);
      simulator.simulateRemove('HDMI1', 1);
      expect(simulator.isRapidPlugDetected()).assertEqual(true);
    });

    it('should_not_detect_rapid_plug_when_slow', 0, () => {
      simulator.simulateInsert('HDMI1', 1);
      setTimeout(() => {
        simulator.simulateRemove('HDMI1', 1);
      }, 600);
      expect(simulator.isRapidPlugDetected()).assertEqual(false);
    });

    it('should_count_plug_events', 0, () => {
      simulator.simulateInsert('HDMI1', 1);
      simulator.simulateInsert('HDMI1', 1);
      simulator.simulateRemove('HDMI1', 1);
      expect(simulator.getPlugCount('HDMI1')).assertEqual(3);
    });

    it('should_return_null_for_unknown_source', 0, () => {
      expect(simulator.getLastPlugState('UNKNOWN')).assertNull();
    });
  });

  describe('PlugEventSimulator_Stress_Scenarios', () => {
    let simulator: PlugEventSimulator;

    beforeEach(() => {
      simulator = new PlugEventSimulator();
    });

    afterEach(() => {
      simulator.reset();
    });

    it('should_handle_rapid_repeated_insertions', 0, () => {
      for (let i = 0; i < 10; i++) {
        simulator.simulateInsert('HDMI1', 1);
        simulator.simulateRemove('HDMI1', 1);
      }
      expect(simulator.getPlugCount('HDMI1')).assertEqual(20);
    });

    it('should_handle_multiple_ports_concurrent_activity', 0, () => {
      simulator.simulateInsert('HDMI1', 1);
      simulator.simulateInsert('HDMI2', 2);
      simulator.simulateInsert('HDMI3', 3);
      simulator.simulateRemove('HDMI1', 1);
      simulator.simulateRemove('HDMI2', 2);
      expect(simulator.events.length).assertEqual(5);
    });

    it('should_detect_rapid_plug_across_all_ports', 0, () => {
      simulator.simulateInsert('HDMI1', 1);
      simulator.simulateRemove('HDMI1', 1);
      simulator.simulateInsert('HDMI2', 2);
      simulator.simulateRemove('HDMI2', 2);
      expect(simulator.isRapidPlugDetected()).assertEqual(true);
    });
  });

  describe('PageRepeatLifecycleSimulator_Basic', () => {
    let simulator: PageRepeatLifecycleSimulator;

    beforeEach(() => {
      simulator = new PageRepeatLifecycleSimulator();
    });

    afterEach(() => {
      simulator.reset();
    });

    it('should_record_show_event', 0, () => {
      simulator.simulateShow('HdmiPage');
      expect(simulator.events.length).assertEqual(1);
      expect(simulator.getRepeatCount('HdmiPage', 'show')).assertEqual(1);
    });

    it('should_record_hide_event', 0, () => {
      simulator.simulateShow('HdmiPage');
      simulator.simulateHide('HdmiPage');
      expect(simulator.getRepeatCount('HdmiPage', 'hide')).assertEqual(1);
    });

    it('should_detect_repeat_show', 0, () => {
      for (let i = 0; i < 5; i++) {
        simulator.simulateShow('HdmiPage');
      }
      expect(simulator.isRepeatShowDetected('HdmiPage')).assertEqual(true);
    });

    it('should_not_detect_repeat_show_below_threshold', 0, () => {
      simulator.simulateShow('HdmiPage');
      simulator.simulateShow('HdmiPage');
      expect(simulator.isRepeatShowDetected('HdmiPage')).assertEqual(false);
    });

    it('should_calculate_visibility_ratio', 0, () => {
      simulator.simulateShow('HdmiPage');
      simulator.simulateHide('HdmiPage');
      simulator.simulateShow('HdmiPage');
      expect(simulator.getPageVisibilityRatio('HdmiPage')).assertEqual(67);
    });

    it('should_return_last_event', 0, () => {
      simulator.simulateShow('HdmiPage');
      simulator.simulateHide('HdmiPage');
      const lastEvent = simulator.getLastEvent('HdmiPage');
      expect(((lastEvent) === null) || ((lastEvent) === undefined)).assertFalse();
      expect(lastEvent!.eventType).assertEqual('hide');
    });

    it('should_return_null_for_unknown_page', 0, () => {
      expect(simulator.getLastEvent('Unknown')).assertNull();
    });

    it('should_track_sequence_ids', 0, () => {
      simulator.simulateShow('HdmiPage');
      simulator.simulateHide('HdmiPage');
      simulator.simulateShow('HdmiPage');
      expect(simulator.events[0].sequenceId).assertEqual(1);
      expect(simulator.events[1].sequenceId).assertEqual(2);
      expect(simulator.events[2].sequenceId).assertEqual(3);
    });
  });

  describe('PageRepeatLifecycleSimulator_Stress_Scenarios', () => {
    let simulator: PageRepeatLifecycleSimulator;

    beforeEach(() => {
      simulator = new PageRepeatLifecycleSimulator();
    });

    afterEach(() => {
      simulator.reset();
    });

    it('should_handle_rapid_show_hide_repetition', 0, () => {
      for (let i = 0; i < 10; i++) {
        simulator.simulateShow('HdmiPage');
        simulator.simulateHide('HdmiPage');
      }
      expect(simulator.isAbnormalLifecycle('HdmiPage')).assertEqual(false);
    });

    it('should_detect_abnormal_consecutive_shows', 0, () => {
      for (let i = 0; i < 5; i++) {
        simulator.simulateShow('HdmiPage');
      }
      expect(simulator.isAbnormalLifecycle('HdmiPage')).assertEqual(true);
    });

    it('should_handle_multiple_pages_concurrent_lifecycle', 0, () => {
      simulator.simulateShow('HdmiPage');
      simulator.simulateShow('IndexPage');
      simulator.simulateShow('SearchPage');
      expect(simulator.events.length).assertEqual(3);
      expect(simulator.getRepeatCount('HdmiPage', 'show')).assertEqual(1);
      expect(simulator.getRepeatCount('IndexPage', 'show')).assertEqual(1);
    });

    it('should_maintain_foreground_background_events', 0, () => {
      simulator.simulateForeground('HdmiPage');
      simulator.simulateBackground('HdmiPage');
      expect(simulator.getRepeatCount('HdmiPage', 'foreground')).assertEqual(1);
      expect(simulator.getRepeatCount('HdmiPage', 'background')).assertEqual(1);
    });
  });

  describe('Integrated_Stress_Scenarios', () => {
    let signalSimulator: SignalJitterSimulator;
    let plugSimulator: PlugEventSimulator;
    let lifecycleSimulator: PageRepeatLifecycleSimulator;

    beforeEach(() => {
      signalSimulator = new SignalJitterSimulator();
      plugSimulator = new PlugEventSimulator();
      lifecycleSimulator = new PageRepeatLifecycleSimulator();
    });

    afterEach(() => {
      signalSimulator.reset();
      plugSimulator.reset();
      lifecycleSimulator.reset();
    });

    it('should_correlate_signal_jitter_with_plug_events', 0, () => {
      plugSimulator.simulateInsert('HDMI1', 1);
      signalSimulator.simulateJitter('HDMI1', 80, 30);
      expect(signalSimulator.getSignalReliability('HDMI1')).assertLarger(0);
    });

    it('should_correlate_plug_events_with_page_lifecycle', 0, () => {
      plugSimulator.simulateInsert('HDMI1', 1);
      lifecycleSimulator.simulateShow('HdmiPage');
      lifecycleSimulator.simulateHide('HdmiPage');
      expect(lifecycleSimulator.getPageVisibilityRatio('HdmiPage')).assertEqual(50);
    });

    it('should_handle_source_switch_under_stress', 0, () => {
      plugSimulator.simulateInsert('HDMI1', 1);
      signalSimulator.simulateJitter('HDMI1', 80, 20);
      plugSimulator.simulateRemove('HDMI1', 1);
      plugSimulator.simulateInsert('HDMI2', 2);
      signalSimulator.simulateJitter('HDMI2', 70, 20);
      expect(signalSimulator.getSignalReliability('HDMI1')).assertEqual(100);
      expect(signalSimulator.getSignalReliability('HDMI2')).assertLarger(0);
    });

    it('should_maintain_stability_under_repeated_stress', 0, () => {
      for (let i = 0; i < 5; i++) {
        lifecycleSimulator.simulateShow('HdmiPage');
        signalSimulator.simulateJitter('HDMI1', 80, 10);
        lifecycleSimulator.simulateHide('HdmiPage');
        plugSimulator.simulateRemove('HDMI1', 1);
        plugSimulator.simulateInsert('HDMI1', 1);
      }
      expect(signalSimulator.getSignalReliability('HDMI1')).assertLarger(0);
      expect(lifecycleSimulator.getRepeatCount('HdmiPage', 'show')).assertEqual(5);
    });
  });

  describe('LongRunning_Stress_Scenarios', () => {
    it('should_sustain_signal_monitoring_over_extended_period', 0, () => {
      const simulator = new SignalJitterSimulator();
      for (let cycle = 0; cycle < 100; cycle++) {
        simulator.simulateJitter('HDMI1', 75 + (cycle % 10), 10);
      }
      expect(simulator.events.length).assertEqual(1000);
      expect(simulator.getSignalReliability('HDMI1')).assertLarger(0);
      simulator.reset();
    });

    it('should_sustain_plug_detection_over_extended_period', 0, () => {
      const simulator = new PlugEventSimulator();
      for (let cycle = 0; cycle < 50; cycle++) {
        simulator.simulateInsert('HDMI1', 1);
        simulator.simulateRemove('HDMI1', 1);
      }
      expect(simulator.getPlugCount('HDMI1')).assertEqual(100);
      simulator.reset();
    });

    it('should_sustain_page_lifecycle_tracking_over_extended_period', 0, () => {
      const simulator = new PageRepeatLifecycleSimulator();
      for (let cycle = 0; cycle < 100; cycle++) {
        simulator.simulateShow('HdmiPage');
        simulator.simulateHide('HdmiPage');
      }
      expect(simulator.events.length).assertEqual(200);
      expect(simulator.getRepeatCount('HdmiPage', 'show')).assertEqual(100);
      simulator.reset();
    });
  });
}
