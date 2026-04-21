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

export interface HdmiSignalDecision {
  isPlay: boolean;
  isPlaying: boolean;
  shouldStartPlayer: boolean;
  shouldStopPlayer: boolean;
  shouldStartSearch: boolean;
  shouldClearTimer: boolean;
}

export interface HdmiBackDecision {
  action: 'routerBackDelayed' | 'cecMenuBack';
  delayMs: number;
  cecCommand: number;
}

export function resolveHdmiPageSourceId(rebootSourceId: number, routeSourceId: number): number {
  return rebootSourceId === -1 ? routeSourceId : rebootSourceId;
}

export function shouldRebindHdmiSource(currentSourceId: number, nextSourceId: number): boolean {
  return currentSourceId !== nextSourceId;
}

export function resolveHdmiSignalDecision(isAvailable: boolean, searchTimerId: number): HdmiSignalDecision {
  const hasActiveTimer: boolean = searchTimerId > 0;
  if (isAvailable) {
    return {
      isPlay: true,
      isPlaying: true,
      shouldStartPlayer: true,
      shouldStopPlayer: false,
      shouldStartSearch: false,
      shouldClearTimer: hasActiveTimer
    };
  }
  return {
    isPlay: false,
    isPlaying: false,
    shouldStartPlayer: false,
    shouldStopPlayer: true,
    shouldStartSearch: searchTimerId === -1,
    shouldClearTimer: false
  };
}

export function resolveHdmiBackDecision(isPlay: boolean): HdmiBackDecision {
  if (isPlay) {
    return {
      action: 'cecMenuBack',
      delayMs: 0,
      cecCommand: 5
    };
  }
  return {
    action: 'routerBackDelayed',
    delayMs: 300,
    cecCommand: -1
  };
}
