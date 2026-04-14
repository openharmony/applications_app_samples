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

import { FoundationStorageEntity } from '../foundation/FoundationAdvancedFixtures';

export interface LatencyRecord {
  type: string
  durationMs: number
}

export interface ResolutionStressRecord {
  width: number
  height: number
  rotation: number
  code: number
}

export class StartupPerformanceHarness {
  private startDurations: number[] = []
  private stopDurations: number[] = []
  private focusDurations: number[] = []

  recordStart(durationMs: number): void {
    this.startDurations.push(durationMs);
  }

  recordStop(durationMs: number): void {
    this.stopDurations.push(durationMs);
  }

  recordFocus(durationMs: number): void {
    this.focusDurations.push(durationMs);
  }

  getStartDurations(): number[] {
    return this.startDurations.slice();
  }

  getStopDurations(): number[] {
    return this.stopDurations.slice();
  }

  getFocusDurations(): number[] {
    return this.focusDurations.slice();
  }

  getAverageStart(): number {
    return average(this.startDurations);
  }

  getAverageStop(): number {
    return average(this.stopDurations);
  }

  getAverageFocus(): number {
    return average(this.focusDurations);
  }
}

export class ResolutionRotationHarness {
  private records: ResolutionStressRecord[] = []
  private unsupportedCount: number = 0

  apply(width: number, height: number, rotation: number): number {
    const area = width * height;
    const code = area > 3840 * 2160 ? -1 : 0;
    if (code !== 0) {
      this.unsupportedCount += 1;
    }
    this.records.push({ width, height, rotation, code });
    return code;
  }

  getRecords(): ResolutionStressRecord[] {
    return this.records.slice();
  }

  getUnsupportedCount(): number {
    return this.unsupportedCount;
  }
}

export class RecoveryPressureHarness {
  private storage: FoundationStorageEntity = new FoundationStorageEntity()
  private recent: string[] = []
  private state: string = 'idle'
  private failureCount: number = 0
  private recoveryCount: number = 0

  start(title: string, code: number): number {
    if (code !== 0) {
      this.state = 'error';
      this.failureCount += 1;
      this.storage.set('recovery.lastError', title);
      return code;
    }
    this.state = 'recording';
    this.storage.set('recovery.lastTitle', title);
    return 0;
  }

  stop(title: string, code: number): number {
    if (code !== 0) {
      this.state = 'error';
      this.failureCount += 1;
      this.storage.set('recovery.lastError', title);
      return code;
    }
    this.state = 'idle';
    this.recent.push(title);
    this.storage.set('recovery.lastSaved', title);
    return 0;
  }

  recover(): void {
    this.state = 'idle';
    this.recoveryCount += 1;
    this.storage.set('recovery.lastAction', 'recover');
  }

  clearRecent(): void {
    this.recent = [];
    this.storage.set('recovery.lastAction', 'clearRecent');
  }

  getState(): string {
    return this.state;
  }

  getFailureCount(): number {
    return this.failureCount;
  }

  getRecoveryCount(): number {
    return this.recoveryCount;
  }

  getRecent(): string[] {
    return this.recent.slice();
  }

  getStorage(): FoundationStorageEntity {
    return this.storage;
  }
}

export class LongRunMixHarness {
  private records: LatencyRecord[] = []

  push(type: string, durationMs: number): void {
    this.records.push({ type, durationMs });
  }

  getRecords(): LatencyRecord[] {
    return this.records.slice();
  }

  getCountByType(type: string): number {
    let total = 0;
    for (let index = 0; index < this.records.length; index++) {
      if (this.records[index].type === type) {
        total += 1
      }
    }
    return total;
  }

  getMaxDuration(): number {
    let maxValue = 0;
    for (let index = 0; index < this.records.length; index++) {
      if (this.records[index].durationMs > maxValue) {
        maxValue = this.records[index].durationMs
      }
    }
    return maxValue;
  }
}

function average(values: number[]): number {
  if (values.length === 0) {
    return 0;
  }
  let total = 0;
  for (let index = 0; index < values.length; index++) {
    total += values[index]
  }
  return Math.floor(total / values.length);
}
