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

import { MockRecordingState, MockWindowRect, MockWindowRectEntity } from './TestTypes';

export interface FoundationFaultPattern {
  name: string
  failCreateAsset: boolean
  failGetAssets: boolean
  startReturnCode: number
  stopReturnCode: number
  expectedState: MockRecordingState
}

export interface FoundationKeySequenceStep {
  keyCode: number
  isDown: boolean
  delayMs: number
}

export interface FoundationKeySequenceCase {
  name: string
  keyA: number
  keyB: number
  steps: FoundationKeySequenceStep[]
  expectedTriggerCount: number
}

export class FoundationStorageEntity {
  private store: Map<string, Object> = new Map()

  /**
   * 测试中需要一个可预测的存储桩，避免真实 LocalStorage 在不同运行器间出现隐式共享。
   * 这里用纯内存实现，保证冷启动模拟时状态来源是可控的。
   */
  set(key: string, value: Object): void {
    this.store.set(key, value);
  }

  /**
   * 业务回放经常依赖“若不存在则初始化”的语义，因此单独保留这个方法。
   * 它可以把首次启动和再次启动路径统一到一套桩逻辑上，便于后续回归扩展。
   */
  setOrCreate(key: string, value: Object): void {
    if (!this.store.has(key)) {
      this.store.set(key, value);
      return;
    }
    this.store.set(key, value);
  }

  get<T>(key: string): T | undefined {
    return this.store.get(key) as T | undefined;
  }

  getSize(): number {
    return this.store.size;
  }

  getKeys(): string[] {
    const keys: string[] = [];
    this.store.forEach((_value: Object, key: string) => {
      keys.push(key);
    });
    return keys;
  }

  snapshot(): Map<string, Object> {
    const copy = new Map<string, Object>();
    this.store.forEach((value: Object, key: string) => {
      copy.set(key, value);
    });
    return copy;
  }
}

export class FoundationScenarioCounter {
  private counts: Map<string, number> = new Map()

  /**
   * 压测类用例更关心场景覆盖是否均衡，而不是单次结果。
   * 这个计数器把重复执行的样本沉淀成指标，便于发现某类路径被遗漏。
   */
  record(name: string): void {
    const current = this.counts.get(name) ?? 0;
    this.counts.set(name, current + 1);
  }

  getCount(name: string): number {
    return this.counts.get(name) ?? 0;
  }

  getDistinctCount(): number {
    return this.counts.size;
  }

  getTotalCount(): number {
    let total = 0;
    this.counts.forEach((value: number) => {
      total += value
    });
    return total;
  }

  getMostFrequentName(): string {
    let target = '';
    let maxCount = -1;
    this.counts.forEach((value: number, key: string) => {
      if (value > maxCount) {
        maxCount = value
        target = key
      }
    });
    return target;
  }
}

export class FoundationRollingChecksum {
  private value: number = 17

  /**
   * 组合场景回归时，直接比较大数组会让测试既笨重又脆弱。
   * 这里使用轻量校验和，把关键序列映射为稳定指纹，适合长稳回归对比。
   */
  appendNumber(value: number): void {
    this.value = (this.value * 31 + value) % 1000000007;
  }

  appendText(text: string): void {
    for (let index = 0; index < text.length; index++) {
      this.appendNumber(text.charCodeAt(index));
    }
  }

  getValue(): number {
    return this.value;
  }
}

export class FoundationFaultPatternQueue {
  private patterns: FoundationFaultPattern[]

  constructor(patterns: FoundationFaultPattern[]) {
    this.patterns = patterns.slice();
  }

  /**
   * 混沌测试需要按轮次稳定地注入故障，否则失败不可复现。
   * 采用取模轮询可以在无限轮压测中保证故障分布固定，方便回归对比。
   */
  getPattern(index: number): FoundationFaultPattern {
    if (this.patterns.length === 0) {
      return {
        name: 'default-idle',
        failCreateAsset: false,
        failGetAssets: false,
        startReturnCode: 0,
        stopReturnCode: 0,
        expectedState: MockRecordingState.Idle
      }
    }
    const targetIndex = index % this.patterns.length;
    return this.patterns[targetIndex];
  }

  getSize(): number {
    return this.patterns.length;
  }
}

export function buildFoundationFaultPatterns(): FoundationFaultPattern[] {
  return [
    {
      name: 'all-green',
      failCreateAsset: false,
      failGetAssets: false,
      startReturnCode: 0,
      stopReturnCode: 0,
      expectedState: MockRecordingState.Stopped
    },
    {
      name: 'create-asset-failed',
      failCreateAsset: true,
      failGetAssets: false,
      startReturnCode: 0,
      stopReturnCode: 0,
      expectedState: MockRecordingState.Error
    },
    {
      name: 'fetch-assets-failed',
      failCreateAsset: false,
      failGetAssets: true,
      startReturnCode: 0,
      stopReturnCode: 0,
      expectedState: MockRecordingState.Recording
    },
    {
      name: 'start-call-failed',
      failCreateAsset: false,
      failGetAssets: false,
      startReturnCode: -1,
      stopReturnCode: 0,
      expectedState: MockRecordingState.Error
    },
    {
      name: 'stop-call-failed',
      failCreateAsset: false,
      failGetAssets: false,
      startReturnCode: 0,
      stopReturnCode: -2,
      expectedState: MockRecordingState.Error
    }
  ]
}

export function buildFoundationDurations(): number[] {
  return [0, 1, 8, 16, 33, 100, 300, 500, 800, 1200, 3000, 10000];
}

export function buildFoundationCanaryBuckets(): number[] {
  return [1, 5, 10, 20, 50, 100];
}

export function buildFoundationAssetNames(prefix: string, count: number): string[] {
  const names: string[] = [];
  for (let index = 0; index < count; index++) {
    const value = `${prefix}_${index.toString().padStart(3, '0')}.mp4`;
    names.push(value);
  }
  return names;
}

export function buildFoundationKeySequenceCases(): FoundationKeySequenceCase[] {
  return [
    {
      name: 'a-then-b-once',
      keyA: 23,
      keyB: 24,
      steps: [
        { keyCode: 23, isDown: true, delayMs: 0 },
        { keyCode: 24, isDown: true, delayMs: 20 },
        { keyCode: 23, isDown: false, delayMs: 20 },
        { keyCode: 24, isDown: false, delayMs: 20 }
      ],
      expectedTriggerCount: 1
    },
    {
      name: 'b-then-a-once',
      keyA: 23,
      keyB: 24,
      steps: [
        { keyCode: 24, isDown: true, delayMs: 0 },
        { keyCode: 23, isDown: true, delayMs: 15 },
        { keyCode: 24, isDown: false, delayMs: 15 },
        { keyCode: 23, isDown: false, delayMs: 15 }
      ],
      expectedTriggerCount: 1
    },
    {
      name: 'long-press-with-reentry-guard',
      keyA: 23,
      keyB: 24,
      steps: [
        { keyCode: 23, isDown: true, delayMs: 0 },
        { keyCode: 24, isDown: true, delayMs: 10 },
        { keyCode: 24, isDown: true, delayMs: 10 },
        { keyCode: 23, isDown: true, delayMs: 10 },
        { keyCode: 24, isDown: false, delayMs: 10 },
        { keyCode: 23, isDown: false, delayMs: 10 }
      ],
      expectedTriggerCount: 1
    },
    {
      name: 'two-complete-rounds',
      keyA: 23,
      keyB: 24,
      steps: [
        { keyCode: 23, isDown: true, delayMs: 0 },
        { keyCode: 24, isDown: true, delayMs: 12 },
        { keyCode: 23, isDown: false, delayMs: 12 },
        { keyCode: 24, isDown: false, delayMs: 12 },
        { keyCode: 24, isDown: true, delayMs: 12 },
        { keyCode: 23, isDown: true, delayMs: 12 },
        { keyCode: 24, isDown: false, delayMs: 12 },
        { keyCode: 23, isDown: false, delayMs: 12 }
      ],
      expectedTriggerCount: 2
    }
  ]
}

export function buildFoundationCompatibilityProfiles(): string[] {
  return [
    'tv-1080p-landscape',
    'tv-4k-landscape',
    'tv-720p-legacy',
    'box-1080p-low-memory',
    'emulator-1080p-debug'
  ]
}

export function buildFoundationGrayReleaseKeys(): string[] {
  return [
    'foundation.mock.photo',
    'foundation.mock.window',
    'foundation.mock.input',
    'foundation.mock.srapi',
    'foundation.regression.matrix'
  ]
}

export function generateWindowRectMatrix(): MockWindowRect[] {
  const rects: MockWindowRect[] = [];
  const widths: number[] = [640, 960, 1280, 1920, 2560, 3840];
  const heights: number[] = [360, 540, 720, 1080, 1440, 2160];
  for (let widthIndex = 0; widthIndex < widths.length; widthIndex++) {
    for (let heightIndex = 0; heightIndex < heights.length; heightIndex++) {
      for (let offsetIndex = 0; offsetIndex < 20; offsetIndex++) {
        rects.push(
          new MockWindowRectEntity(
            24 + offsetIndex * 3,
            18 + offsetIndex * 2,
            widths[widthIndex] + offsetIndex,
            heights[heightIndex] + offsetIndex
          )
        )
      }
    }
  }
  return rects;
}
