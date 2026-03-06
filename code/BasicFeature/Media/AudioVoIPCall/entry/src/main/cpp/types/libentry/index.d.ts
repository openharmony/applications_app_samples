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

import { Callback } from '@ohos.base';

export const activateAudioSessionVoIP: () => void;
export const deActivateAudioSessionVoIP: () => void;
export const audioRendererPlayerInitVoIP: (number) => void;
export const audioRendererPlayerStartVoIP: () => void;
export const audioRendererPlayerPauseVoIP: () => void;
export const audioRendererPlayerStopVoIP: () => void;
export const audioRendererPlayerReleaseVoIP: () => void;
export const audioRendererPlayerMuteVoIP: () => void;
export const audioRendererPlayerUnMuteVoIP: () => void;
export const audioCapturerInitVoIP: () => void;
export const audioCapturerStartVoIP: () => void;
export const audioCapturerPauseVoIP: () => void;
export const audioCapturerStopVoIP: () => void;
export const audioCapturerReleaseVoIP: () => void;
export const audioCapturerMuteVoIP: () => void;
export const audioCapturerUnMuteVoIP: () => void;