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

import { MockRecordingState, RecorderScenarioCase, ResolutionEntity, ResolutionLike } from './TestTypes';

export function buildRecorderScenarioCases(): RecorderScenarioCase[] {
  return [
    {
      name: 'idle-start-success',
      initialState: MockRecordingState.Idle,
      action: 'start',
      startReturnCode: 0,
      stopReturnCode: 0,
      expectedState: MockRecordingState.Recording,
      expectError: false
    },
    {
      name: 'idle-start-fail',
      initialState: MockRecordingState.Idle,
      action: 'start',
      startReturnCode: -1,
      stopReturnCode: 0,
      expectedState: MockRecordingState.Error,
      expectError: true
    },
    {
      name: 'recording-stop-success',
      initialState: MockRecordingState.Recording,
      action: 'stop',
      startReturnCode: 0,
      stopReturnCode: 0,
      expectedState: MockRecordingState.Stopped,
      expectError: false
    },
    {
      name: 'recording-stop-fail',
      initialState: MockRecordingState.Recording,
      action: 'stop',
      startReturnCode: 0,
      stopReturnCode: -2,
      expectedState: MockRecordingState.Error,
      expectError: true
    },
    {
      name: 'stopped-query',
      initialState: MockRecordingState.Stopped,
      action: 'query',
      startReturnCode: 0,
      stopReturnCode: 0,
      expectedState: MockRecordingState.Stopped,
      expectError: false
    },
    {
      name: 'error-query',
      initialState: MockRecordingState.Error,
      action: 'query',
      startReturnCode: 0,
      stopReturnCode: 0,
      expectedState: MockRecordingState.Error,
      expectError: true
    }
  ]
}

export function buildConcurrencyRounds(): number[] {
  const rounds: number[] = []
  for (let i = 1; i <= 40; i++) {
    rounds.push(i)
  }
  return rounds
}

export function buildStressDurationsMs(): number[] {
  return [1, 5, 10, 20, 50, 100, 200, 500, 1000]
}

export function buildResolutionMatrix(): ResolutionLike[] {
  const matrix: ResolutionLike[] = []
  matrix.push(new ResolutionEntity(1280, 720))
  matrix.push(new ResolutionEntity(1920, 1080))
  matrix.push(new ResolutionEntity(2560, 1440))
  matrix.push(new ResolutionEntity(3840, 2160))
  return matrix
}

export function buildRotationMatrix(): number[] {
  return [0, 90, 180, 270]
}

export function buildFailureCodes(): number[] {
  return [-1, -2, -3, -100, -200, -999]
}

export function buildCanaryBuckets(): string[] {
  return ['gray-1%', 'gray-5%', 'gray-10%', 'gray-30%', 'canary-50%', 'full-100%']
}

export function buildCompatibilityDevices(): string[] {
  return ['default', 'tablet', 'ohtv-low-memory', 'ohtv-high-memory', 'rk-chip']
}
