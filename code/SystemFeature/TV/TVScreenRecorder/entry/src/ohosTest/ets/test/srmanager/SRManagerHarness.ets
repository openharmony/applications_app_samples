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

import {
  MockPhotoAccessLike,
  MockRecordingState,
  MockPhotoCreateOptions,
  MockSRApiController
} from '../foundation/TestTypes';

export interface SRManagerHarnessConfig {
  fdPrefix: string
  defaultFd: number
  filePrefix: string
  fileType: string
}

export interface SRManagerHarnessMetrics {
  startAttempts: number
  stopAttempts: number
  successfulStarts: number
  successfulStops: number
  stateCallbackCount: number
  createAssetCount: number
  queryCount: number
}

export interface SRManagerHarnessSnapshot {
  state: MockRecordingState
  metrics: SRManagerHarnessMetrics
  fileName: string
  fd: number
  lastStartUrl: string
}

export interface StartStopRound {
  round: number
  shouldFail: boolean
}

class StartStopRoundEntity implements StartStopRound {
  round: number
  shouldFail: boolean

  constructor(round: number, shouldFail: boolean) {
    this.round = round
    this.shouldFail = shouldFail
  }
}

class SRManagerHarnessMetricsEntity implements SRManagerHarnessMetrics {
  startAttempts: number = 0
  stopAttempts: number = 0
  successfulStarts: number = 0
  successfulStops: number = 0
  stateCallbackCount: number = 0
  createAssetCount: number = 0
  queryCount: number = 0
}

const DEFAULT_CONFIG: SRManagerHarnessConfig = {
  fdPrefix: 'fd://',
  defaultFd: 1000,
  filePrefix: 'REC',
  fileType: '.mp4'
}

export class SRManagerHarness {
  private api: MockSRApiController
  private photoAccess: MockPhotoAccessLike
  private config: SRManagerHarnessConfig
  private state: MockRecordingState = MockRecordingState.Idle
  private fileName: string = ''
  private fd: number = -1
  private lastStartUrl: string = ''
  private callback: (state: MockRecordingState) => void = (): void => {}
  private metrics: SRManagerHarnessMetrics = new SRManagerHarnessMetricsEntity()

  constructor(api: MockSRApiController, photoAccess: MockPhotoAccessLike, config?: Partial<SRManagerHarnessConfig>) {
    this.api = api
    this.photoAccess = photoAccess
    this.config = this.buildConfig(config)
    this.api.onStateChange((state: number) => {
      this.state = state as MockRecordingState
      this.metrics.stateCallbackCount += 1
      this.callback(this.state)
    })
  }

  private buildConfig(config?: Partial<SRManagerHarnessConfig>): SRManagerHarnessConfig {
    const merged: SRManagerHarnessConfig = {
      fdPrefix: DEFAULT_CONFIG.fdPrefix,
      defaultFd: DEFAULT_CONFIG.defaultFd,
      filePrefix: DEFAULT_CONFIG.filePrefix,
      fileType: DEFAULT_CONFIG.fileType
    }
    if (config) {
      if (config.fdPrefix !== undefined) {
        merged.fdPrefix = config.fdPrefix
      }
      if (config.defaultFd !== undefined) {
        merged.defaultFd = config.defaultFd
      }
      if (config.filePrefix !== undefined) {
        merged.filePrefix = config.filePrefix
      }
      if (config.fileType !== undefined) {
        merged.fileType = config.fileType
      }
    }
    return merged
  }

  private buildVideoName(seed: number): string {
    const date = new Date(seed)
    const year = `${date.getFullYear()}`
    const month = `${date.getMonth() + 1}`.padStart(2, '0')
    const day = `${date.getDate()}`.padStart(2, '0')
    const hour = `${date.getHours()}`.padStart(2, '0')
    const minute = `${date.getMinutes()}`.padStart(2, '0')
    const second = `${date.getSeconds()}`.padStart(2, '0')
    return `${this.config.filePrefix}_${year}${month}${day}_${hour}${minute}${second}${this.config.fileType}`
  }

  private async ensureAsset(seed: number): Promise<void> {
    this.fileName = this.buildVideoName(seed)
    const createOption: MockPhotoCreateOptions = { subtype: 1 }
    await this.photoAccess.createAsset(this.fileName, createOption)
    this.metrics.createAssetCount += 1
    if (this.fd < 0) {
      this.fd = this.config.defaultFd
    }
  }

  async start(seed: number = 1700000000000): Promise<number> {
    this.metrics.startAttempts += 1
    if (this.state !== MockRecordingState.Idle && this.state !== MockRecordingState.Stopped) {
      return -1000
    }
    await this.ensureAsset(seed)
    const url = `${this.config.fdPrefix}${this.fd}`
    this.lastStartUrl = url
    const code = this.api.startRecording(url)
    if (code === 0) {
      this.metrics.successfulStarts += 1
    }
    return code
  }

  stop(): number {
    this.metrics.stopAttempts += 1
    if (this.state !== MockRecordingState.Recording) {
      return -1001
    }
    const code = this.api.stopRecording()
    if (code === 0) {
      this.metrics.successfulStops += 1
    }
    return code
  }

  queryState(): MockRecordingState {
    this.metrics.queryCount += 1
    this.state = this.api.getRecorderState() as MockRecordingState
    return this.state
  }

  onStateChange(callback: (state: MockRecordingState) => void): void {
    this.callback = callback
  }

  forceState(state: MockRecordingState): void {
    this.api.setState(state)
    this.state = state
  }

  setFd(fd: number): void {
    this.fd = fd
  }

  resetMetrics(): void {
    this.metrics = new SRManagerHarnessMetricsEntity()
  }

  getMetrics(): SRManagerHarnessMetrics {
    const value = new SRManagerHarnessMetricsEntity()
    value.startAttempts = this.metrics.startAttempts
    value.stopAttempts = this.metrics.stopAttempts
    value.successfulStarts = this.metrics.successfulStarts
    value.successfulStops = this.metrics.successfulStops
    value.stateCallbackCount = this.metrics.stateCallbackCount
    value.createAssetCount = this.metrics.createAssetCount
    value.queryCount = this.metrics.queryCount
    return value
  }

  getSnapshot(): SRManagerHarnessSnapshot {
    return {
      state: this.state,
      metrics: this.getMetrics(),
      fileName: this.fileName,
      fd: this.fd,
      lastStartUrl: this.lastStartUrl
    }
  }

  getLastStartUrl(): string {
    return this.lastStartUrl
  }

  getCurrentState(): MockRecordingState {
    return this.state
  }

  getCurrentFileName(): string {
    return this.fileName
  }
}

export function createScenarioSeeds(count: number, seed: number = 1700000000000): number[] {
  const seeds: number[] = []
  for (let i = 0; i < count; i++) {
    seeds.push(seed + i * 1000)
  }
  return seeds
}

export function buildStartStopRounds(rounds: number): StartStopRound[] {
  const items: StartStopRound[] = []
  for (let i = 1; i <= rounds; i++) {
    items.push(new StartStopRoundEntity(i, i % 9 === 0))
  }
  return items
}
