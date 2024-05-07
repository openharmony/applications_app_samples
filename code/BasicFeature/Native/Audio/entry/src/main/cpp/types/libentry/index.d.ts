/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

export const audioCapturerInit: () => void;
export const audioCapturerLowLatencyInit: () => void;
export const audioCapturerStart: () => void;
export const audioCapturerPause: () => void;
export const audioCapturerStop: () => void;
export const audioCapturerRelease: () => void;
export const audioRendererInit: () => void;
export const audioRendererLowLatencyInit: () => void;
export const audioRendererStart: () => void;
export const audioRendererPause: () => void;
export const audioRendererStop: () => void;
export const audioRendererRelease: () => void;
export const getRendererState: () => number;
export const getCapturerState: () => number;
export const getFileState: () => number;
export const getFastState: () => number;
export const getFramesWritten: () => number;
export const getFileSize: () => number;
export const closeFile: () => number;

export const avpAudioRendererInit: () => void;
export const avpAudioRendererStart: () => void;
export const avpAudioRendererPause: () => void;
export const avpAudioRendererStop: () => void;
export const avpAudioRendererRelease: () => void;
export const avpGetRendererState: () => number;
export const avpVividAudioRendererInit: () => void;
export const avpVividAudioRendererStart: () => void;
export const avpVividAudioRendererPause: () => void;
export const avpVividAudioRendererStop: () => void;
export const avpVividAudioRendererRelease: () => void;
export const avpVividGetRendererState: () => number;