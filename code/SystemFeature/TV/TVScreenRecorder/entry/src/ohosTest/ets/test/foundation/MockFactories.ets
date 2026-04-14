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
  MockClockLike,
  MockFetchResult,
  MockInputConsumerLike,
  MockInputTriggerRecord,
  MockPhotoAccessLike,
  MockPhotoCreateOptions,
  MockRecordingState,
  MockSRApiController,
  MockStateTransition,
  MockVideoAsset,
  MockWindowLike,
  MockWindowManagerLike,
  MockWindowOpenRecord,
  MockWindowRect,
  MockWindowPopupRecord
} from './TestTypes';

class InMemoryFetchResult implements MockFetchResult {
  private assets: MockVideoAsset[]

  constructor(assets: MockVideoAsset[]) {
    this.assets = assets
  }

  getCount(): number {
    return this.assets.length
  }

  getFirstObject(): MockVideoAsset | undefined {
    if (this.assets.length === 0) {
      return undefined
    }
    return this.assets[0]
  }
}

class MockVideoAssetEntity implements MockVideoAsset {
  uri: string
  fileName: string
  createdAt: number

  constructor(uri: string, fileName: string, createdAt: number) {
    this.uri = uri
    this.fileName = fileName
    this.createdAt = createdAt
  }
}

class MockWindowOpenRecordEntity implements MockWindowOpenRecord {
  name: string
  page: string
  width: number
  height: number

  constructor(name: string, page: string, width: number, height: number) {
    this.name = name
    this.page = page
    this.width = width
    this.height = height
  }
}

class MockWindowPopupRecordEntity implements MockWindowPopupRecord {
  name: string
  page: string
  duration: number

  constructor(name: string, page: string, duration: number) {
    this.name = name
    this.page = page
    this.duration = duration
  }
}

class MockInputTriggerRecordEntity implements MockInputTriggerRecord {
  keyCode: number
  isDown: boolean
  triggeredAt: number

  constructor(keyCode: number, isDown: boolean, triggeredAt: number) {
    this.keyCode = keyCode
    this.isDown = isDown
    this.triggeredAt = triggeredAt
  }
}

class DefaultMockClock implements MockClockLike {
  private currentMs: number

  constructor(seed: number = 1700000000000) {
    this.currentMs = seed
  }

  now(): number {
    return this.currentMs
  }

  tick(ms: number): number {
    this.currentMs += ms
    return this.currentMs
  }

  set(ms: number): void {
    this.currentMs = ms
  }
}

class MockPhotoAccessControllerEntity implements MockPhotoAccessLike {
  private owner: MockPhotoAccessHelperFactory

  constructor(owner: MockPhotoAccessHelperFactory) {
    this.owner = owner
  }

  async createAsset(fileName: string, createOption: MockPhotoCreateOptions): Promise<MockVideoAsset> {
    if (this.owner.throwOnCreateAsset) {
      throw new Error('createAsset-failed-by-mock')
    }
    this.owner.creationCounter += 1
    const subtype = createOption.subtype
    const uri = `file://mock/${this.owner.creationCounter}_${subtype}_${fileName}`
    const asset = new MockVideoAssetEntity(uri, fileName, this.owner.clock.now())
    this.owner.assets.push(asset)
    return asset
  }

  async getAssets(_fetchOptions: Record<string, Object>): Promise<MockFetchResult> {
    if (this.owner.throwOnGetAssets) {
      throw new Error('getAssets-failed-by-mock')
    }
    return new InMemoryFetchResult(this.owner.assets.slice())
  }
}

export class MockPhotoAccessHelperFactory {
  assets: MockVideoAsset[] = []
  throwOnCreateAsset: boolean = false
  throwOnGetAssets: boolean = false
  creationCounter: number = 0
  clock: MockClockLike

  constructor(clock?: MockClockLike) {
    this.clock = clock ?? new DefaultMockClock()
  }

  setThrowOnCreateAsset(value: boolean): void {
    this.throwOnCreateAsset = value
  }

  setThrowOnGetAssets(value: boolean): void {
    this.throwOnGetAssets = value
  }

  getCreationCounter(): number {
    return this.creationCounter
  }

  getAssetCount(): number {
    return this.assets.length
  }

  getAssetsSnapshot(): MockVideoAsset[] {
    return this.assets.slice()
  }

  build(): MockPhotoAccessLike {
    return new MockPhotoAccessControllerEntity(this)
  }
}

class InMemoryMockWindow implements MockWindowLike {
  private hiddenCounter: number = 0

  hide(): void {
    this.hiddenCounter += 1
  }

  getHideCount(): number {
    return this.hiddenCounter
  }
}

class MockWindowManagerControllerEntity implements MockWindowManagerLike {
  private owner: MockWindowManagerFactory

  constructor(owner: MockWindowManagerFactory) {
    this.owner = owner
  }

  openTimerWindow(name: string, page: string, rect: MockWindowRect, _ctx: Object, _storage?: Object): void {
    this.owner.openRecords.push(new MockWindowOpenRecordEntity(name, page, rect.width, rect.height))
    if (!this.owner.windows.has(name)) {
      this.owner.windows.set(name, new InMemoryMockWindow())
    }
  }

  popupRecorderTip(name: string, page: string, _rect: MockWindowRect, duration: number, _ctx: Object, callback?: () => void): void {
    this.owner.popupRecords.push(new MockWindowPopupRecordEntity(name, page, duration))
    if (callback) {
      callback()
    }
  }

  get(name: string): MockWindowLike | undefined {
    return this.owner.windows.get(name)
  }

  release(): void {
    this.owner.released = true
    this.owner.windows.clear()
  }
}

export class MockWindowManagerFactory {
  windows: Map<string, InMemoryMockWindow> = new Map()
  openRecords: MockWindowOpenRecord[] = []
  popupRecords: MockWindowPopupRecord[] = []
  released: boolean = false

  getOpenRecords(): MockWindowOpenRecord[] {
    return this.openRecords.slice()
  }

  getPopupRecords(): MockWindowPopupRecord[] {
    return this.popupRecords.slice()
  }

  isReleased(): boolean {
    return this.released
  }

  getWindowHideCount(name: string): number {
    const target = this.windows.get(name)
    if (!target) {
      return 0
    }
    return target.getHideCount()
  }

  build(): MockWindowManagerLike {
    return new MockWindowManagerControllerEntity(this)
  }
}

class MockSRApiControllerEntity implements MockSRApiController {
  private owner: MockSRApiFactory

  constructor(owner: MockSRApiFactory) {
    this.owner = owner
  }

  startRecording(url: string): number {
    this.owner.lastStartUrl = url
    if (this.owner.startReturnCode === 0) {
      this.owner.emitState(MockRecordingState.Recording)
    } else {
      this.owner.emitState(MockRecordingState.Error)
    }
    return this.owner.startReturnCode
  }

  stopRecording(): number {
    if (this.owner.stopReturnCode === 0) {
      this.owner.emitState(MockRecordingState.Stopped)
    } else {
      this.owner.emitState(MockRecordingState.Error)
    }
    return this.owner.stopReturnCode
  }

  getRecorderState(): number {
    return this.owner.currentState
  }

  onStateChange(callback: (state: number) => void): void {
    this.owner.callback = callback
  }

  emitState(state: MockRecordingState): void {
    this.owner.emitState(state)
  }

  setState(state: MockRecordingState): void {
    this.owner.setState(state)
  }

  setStartReturn(code: number): void {
    this.owner.setStartReturn(code)
  }

  setStopReturn(code: number): void {
    this.owner.setStopReturn(code)
  }

  getLastStartUrl(): string {
    return this.owner.getLastStartUrl()
  }

  getStateHistory(): MockRecordingState[] {
    return this.owner.getStateHistory()
  }
}

export class MockSRApiFactory {
  currentState: MockRecordingState = MockRecordingState.Idle
  startReturnCode: number = 0
  stopReturnCode: number = 0
  callback: ((state: number) => void) | undefined
  lastStartUrl: string = ''
  stateHistory: MockRecordingState[] = [MockRecordingState.Idle]

  setState(state: MockRecordingState): void {
    this.currentState = state
    this.stateHistory.push(state)
  }

  setStartReturn(code: number): void {
    this.startReturnCode = code
  }

  setStopReturn(code: number): void {
    this.stopReturnCode = code
  }

  emitState(state: MockRecordingState): void {
    this.currentState = state
    this.stateHistory.push(state)
    if (this.callback) {
      this.callback(state)
    }
  }

  getLastStartUrl(): string {
    return this.lastStartUrl
  }

  getStateHistory(): MockRecordingState[] {
    return this.stateHistory.slice()
  }

  build(): MockSRApiController {
    return new MockSRApiControllerEntity(this)
  }
}

class MockInputConsumerControllerEntity implements MockInputConsumerLike {
  private owner: MockInputConsumerFactory

  constructor(owner: MockInputConsumerFactory) {
    this.owner = owner
  }

  setCallback(cb: () => void): void {
    this.owner.callback = cb
  }

  triggerDown(keyCode: number): void {
    this.owner.records.push(new MockInputTriggerRecordEntity(keyCode, true, this.owner.clock.now()))
    if (keyCode === this.owner.keyA) {
      this.owner.isDownA = true
    }
    if (keyCode === this.owner.keyB) {
      this.owner.isDownB = true
    }
    if (this.owner.isDownA && this.owner.isDownB && this.owner.gateOpen) {
      this.owner.gateOpen = false
      this.owner.callback()
    }
  }

  triggerUp(keyCode: number): void {
    this.owner.records.push(new MockInputTriggerRecordEntity(keyCode, false, this.owner.clock.now()))
    if (keyCode === this.owner.keyA) {
      this.owner.isDownA = false
    }
    if (keyCode === this.owner.keyB) {
      this.owner.isDownB = false
    }
    this.owner.gateOpen = true
  }

  getTriggerHistory(): MockInputTriggerRecord[] {
    return this.owner.getTriggerHistory()
  }
}

export class MockInputConsumerFactory {
  callback: () => void = (): void => {}
  records: MockInputTriggerRecord[] = []
  keyA: number
  keyB: number
  isDownA: boolean = false
  isDownB: boolean = false
  gateOpen: boolean = true
  clock: MockClockLike

  constructor(keyA: number, keyB: number, clock?: MockClockLike) {
    this.keyA = keyA
    this.keyB = keyB
    this.clock = clock ?? new DefaultMockClock()
  }

  getTriggerHistory(): MockInputTriggerRecord[] {
    return this.records.slice()
  }

  build(): MockInputConsumerLike {
    return new MockInputConsumerControllerEntity(this)
  }
}

export function buildStateTransitionCases(): MockStateTransition[] {
  return [
    { from: MockRecordingState.Idle, to: MockRecordingState.Recording, reason: 'start-success' },
    { from: MockRecordingState.Recording, to: MockRecordingState.Stopped, reason: 'stop-success' },
    { from: MockRecordingState.Recording, to: MockRecordingState.Error, reason: 'capture-error' },
    { from: MockRecordingState.Stopped, to: MockRecordingState.Idle, reason: 'service-restart' },
    { from: MockRecordingState.Error, to: MockRecordingState.Idle, reason: 'recovery' }
  ]
}

export function createDefaultClock(seed: number = 1700000000000): MockClockLike {
  return new DefaultMockClock(seed)
}
