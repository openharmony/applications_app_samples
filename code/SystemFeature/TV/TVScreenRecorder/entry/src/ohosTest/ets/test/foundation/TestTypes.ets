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

export enum MockRecordingState {
  Idle = 0,
  Recording = 1,
  Stopped = 2,
  Error = 3
}

export interface MockStateTransition {
  from: MockRecordingState
  to: MockRecordingState
  reason: string
}

export interface MockVideoAsset {
  uri: string
  fileName: string
  createdAt: number
}

export interface MockFetchResult {
  getCount(): number
  getFirstObject?(): MockVideoAsset | undefined
}

export interface MockPhotoCreateOptions {
  subtype: number
}

export interface MockPhotoAccessLike {
  createAsset(fileName: string, createOption: MockPhotoCreateOptions): Promise<MockVideoAsset>
  getAssets(fetchOptions: Record<string, Object>): Promise<MockFetchResult>
}

export interface MockWindowLike {
  hide(): void
}

export interface MockWindowOpenRecord {
  name: string
  page: string
  width: number
  height: number
}

export interface MockWindowPopupRecord {
  name: string
  page: string
  duration: number
}

export interface MockWindowRect {
  x: number
  y: number
  width: number
  height: number
}

export class MockWindowRectEntity implements MockWindowRect {
  x: number
  y: number
  width: number
  height: number

  constructor(x: number, y: number, width: number, height: number) {
    this.x = x
    this.y = y
    this.width = width
    this.height = height
  }
}

export class MockContextData {
}

export interface MockWindowManagerLike {
  openTimerWindow(
    name: string,
    page: string,
    rect: MockWindowRect,
    ctx: Object,
    storage?: Object
  ): void
  popupRecorderTip(
    name: string,
    page: string,
    rect: MockWindowRect,
    duration: number,
    ctx: Object,
    callback?: () => void
  ): void
  get(name: string): MockWindowLike | undefined
  release(): void
}

export interface MockSRApiLike {
  startRecording(url: string): number
  stopRecording(): number
  getRecorderState(): number
  onStateChange(callback: (state: number) => void): void
}

export interface MockSRApiController extends MockSRApiLike {
  emitState(state: MockRecordingState): void
  setState(state: MockRecordingState): void
  setStartReturn(code: number): void
  setStopReturn(code: number): void
  getLastStartUrl(): string
  getStateHistory(): MockRecordingState[]
}

export interface MockInputTriggerRecord {
  keyCode: number
  isDown: boolean
  triggeredAt: number
}

export interface MockInputConsumerLike {
  setCallback(cb: () => void): void
  triggerDown(keyCode: number): void
  triggerUp(keyCode: number): void
  getTriggerHistory(): MockInputTriggerRecord[]
}

export interface MockClockLike {
  now(): number
  tick(ms: number): number
  set(ms: number): void
}

export interface RecorderScenarioCase {
  name: string
  initialState: MockRecordingState
  action: 'start' | 'stop' | 'query'
  startReturnCode: number
  stopReturnCode: number
  expectedState: MockRecordingState
  expectError: boolean
}

export interface ResolutionLike {
  width: number
  height: number
}

export class ResolutionEntity implements ResolutionLike {
  width: number
  height: number

  constructor(width: number, height: number) {
    this.width = width
    this.height = height
  }
}
