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

export interface LowLatencyCapturerStats {
  state: number;
  streamId: number;
  latencyMode: number;
  fastStatus: number;
  frameSize: number;
  capturedBytes: number;
  callbackCount: number;
  lastReadSize: number;
  lastFastStatus: number;
  lastError: number;
  savedBytes: number;
}

export const lowLatencyCapturerInit: (
  streamId: number,
  sourceType: number,
  sampleRate: number,
  channelCount: number,
  sampleFormat: number
) => number;
export const lowLatencyCapturerStart: (streamId: number) => number;
export const lowLatencyCapturerStop: (streamId: number) => number;
export const lowLatencyCapturerRelease: (streamId: number) => number;
export const lowLatencyCapturerSetSaveFile: (streamId: number, path: string) => number;
export const lowLatencyCapturerGetStats: (streamId: number) => LowLatencyCapturerStats;
export const lowLatencyCapturerResetStats: (streamId: number) => number;
export const lowLatencyCapturerPrintSnapshot: (streamId: number, fd: number) => number;
export const pcmPlayerStart: (
  streamId: number,
  path: string,
  sampleRate: number,
  channelCount: number,
  sampleFormat: number
) => number;
export const pcmPlayerStop: (streamId: number) => number;
export const pcmPlayerGetStats: (streamId: number) => {
  state: number;
  playedBytes: number;
  totalBytes: number;
  lastError: number;
};
export const pcmPlayerPrintSnapshot: (streamId: number, fd: number) => number;
export const audioDebuggingManagerProbe: () => number;
export const audioDebuggingManagerPrintAppInfo: (fd: number) => number;

export interface NativeAudioNapi {
  lowLatencyCapturerInit: typeof lowLatencyCapturerInit;
  lowLatencyCapturerStart: typeof lowLatencyCapturerStart;
  lowLatencyCapturerStop: typeof lowLatencyCapturerStop;
  lowLatencyCapturerRelease: typeof lowLatencyCapturerRelease;
  lowLatencyCapturerSetSaveFile: typeof lowLatencyCapturerSetSaveFile;
  lowLatencyCapturerGetStats: typeof lowLatencyCapturerGetStats;
  lowLatencyCapturerResetStats: typeof lowLatencyCapturerResetStats;
  lowLatencyCapturerPrintSnapshot: typeof lowLatencyCapturerPrintSnapshot;
  pcmPlayerStart: typeof pcmPlayerStart;
  pcmPlayerStop: typeof pcmPlayerStop;
  pcmPlayerGetStats: typeof pcmPlayerGetStats;
  pcmPlayerPrintSnapshot: typeof pcmPlayerPrintSnapshot;
  audioDebuggingManagerProbe: typeof audioDebuggingManagerProbe;
  audioDebuggingManagerPrintAppInfo: typeof audioDebuggingManagerPrintAppInfo;
}

declare const audioNapi: NativeAudioNapi;
export default audioNapi;
